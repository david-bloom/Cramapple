import { deriveAssistanceState } from "../_shared/assistance-state.ts";
import { requireProfile } from "../_shared/auth.ts";
import { GRADING_ENTITLEMENTS_ENABLED } from "./config.ts";
import { type Service } from "./grade-store.ts";
import { type Respond } from "./request.ts";

// Load phases of handleEvaluateAttempt (TASK-0079 S4: bodies moved verbatim).
// Each returns the loaded rows, or the early-exit Response the handler sends;
// the handler returns any Response as is. Query order is unchanged: the replay
// lookup still sits between the two phases, in the handler.

type Profile = NonNullable<Awaited<ReturnType<typeof requireProfile>>>;

// Prompt governance, attempt and response ownership, Open Hand exclusion, and
// the content version the attempt is graded against.
export async function loadAttemptContext(input: {
  service: Service;
  respond: Respond;
  user: Profile["user"];
  profile: Profile["profile"];
  operation: string;
  promptVersion: string;
  attemptId: string;
  responseVersionId: string;
  artifactVersionId: string | null;
  requestedContentItemVersionId: string | null;
  requestedRubricVersionId: string | null;
}) {
  const {
    service,
    respond,
    user,
    profile,
    operation,
    promptVersion,
    attemptId,
    responseVersionId,
    artifactVersionId,
    requestedContentItemVersionId,
    requestedRubricVersionId,
  } = input;
  // Enforce prompt governance: the supplied promptVersion must correspond
  // to a published row in app.prompt_versions for this operation. Without
  // this check, a client could pass any free-text string and have it
  // written verbatim into grading_results.prompt_version, breaking the
  // audit trail and bypassing the prompt-rollout gate the table was
  // created to enforce.
  const { data: promptVersionRow, error: promptVersionLookupError } =
    await service.schema("app")
      .from("prompt_versions")
      .select("id, status")
      .eq("operation", operation)
      .eq("version", promptVersion)
      .maybeSingle();

  if (promptVersionLookupError) {
    return respond(
      { error: "prompt_version_lookup_failed" },
      { status: 500 },
    );
  }

  if (!promptVersionRow || promptVersionRow.status !== "published") {
    return respond(
      { error: "invalid_prompt_version" },
      { status: 400 },
    );
  }

  const [
    { data: attempt, error: attemptError },
    { data: responseVersion, error: responseError },
  ] = await Promise.all([
    service.schema("app")
      .from("attempts")
      .select(
        "id, user_id, learning_session_id, exam_pack_version_id, content_item_version_id, artifact_version_id, attempt_mode, status, assistance_state, pre_submit_hint_count, started_at, submitted_at, graded_at, score_points, score_possible",
      )
      .eq("id", attemptId)
      .maybeSingle(),
    service.schema("app")
      .from("response_versions")
      .select(
        "id, attempt_id, parent_response_version_id, response_text, response_parts, version_number, is_submitted, created_at",
      )
      .eq("id", responseVersionId)
      .maybeSingle(),
  ]);

  if (attemptError || responseError || !attempt || !responseVersion) {
    return respond({ error: "not_found" }, { status: 404 });
  }

  if (attempt.user_id !== user.id && profile.role !== "admin") {
    return respond({ error: "forbidden" }, { status: 403 });
  }

  if (responseVersion.attempt_id !== attempt.id) {
    return respond({ error: "response_attempt_mismatch" }, { status: 409 });
  }

  if (!responseVersion.is_submitted) {
    return respond({ error: "response_not_submitted" }, { status: 409 });
  }

  // DECISION-0080 / STUDENT_INTERACTION_DATA_SCHEMA_PLAN_2026_09_27.md Phase 1
  // item 1: attempts.assistance_state was entirely client-supplied until now.
  // Derive the server-truth value once here and use it everywhere below
  // instead of the raw attempt.assistance_state column.
  const derivedAssistanceState = deriveAssistanceState(
    attempt.assistance_state as string | null,
    attempt.pre_submit_hint_count as number | null,
  );

  const effectiveContentItemVersionId = requestedContentItemVersionId ??
    attempt.content_item_version_id as string;
  const effectiveRubricVersionId = requestedRubricVersionId ??
    effectiveContentItemVersionId;

  if (!effectiveContentItemVersionId || !effectiveRubricVersionId) {
    return respond({ error: "missing_content_version" }, { status: 409 });
  }

  // Open Hand discloses the full key and permanently makes that ITEM
  // non-scorable for that student. Fail before loading content or any
  // answer-bearing tables; service_role is the only direct reader of the
  // private exclusion table.
  //
  // Keyed on content_item_id, not content_item_version_id (DECISION-0086):
  // republishing an item mints a new version id, so a version-keyed check would
  // silently restore scorability for a student who has already read the key. The
  // version the attempt carries is client-supplied, so it is resolved to its item
  // here rather than trusted as a stable identity.
  // Resolve the version to its item first. This reads one non-answer-bearing
  // column and touches no key, rubric, or criterion data.
  const { data: versionItem, error: versionItemError } = await service
    .schema("app")
    .from("content_item_versions")
    .select("content_item_id")
    .eq("id", effectiveContentItemVersionId)
    .maybeSingle();

  if (versionItemError || !versionItem?.content_item_id) {
    return respond({ error: "open_hand_eligibility_check_failed" }, {
      status: 500,
    });
  }

  const { data: openHandExclusion, error: openHandExclusionError } =
    await service.schema("app")
      .from("open_hand_scoring_exclusions")
      .select("content_item_id")
      .eq("user_id", attempt.user_id)
      .eq("content_item_id", versionItem.content_item_id)
      // TASK-0051 QA F2: the key is (user_id, content_item_version_id), so a
      // student who viewed two versions of one item has two rows here.
      // .maybeSingle() errors on that; any row at all means "excluded".
      .limit(1);

  if (openHandExclusionError) {
    return respond({ error: "open_hand_eligibility_check_failed" }, {
      status: 500,
    });
  }

  if (openHandExclusion && openHandExclusion.length > 0) {
    return respond({ error: "open_hand_item_not_scorable" }, { status: 409 });
  }

  const { data: contentVersion, error: contentError } = await service
    .schema("app")
    .from("content_item_versions")
    .select(
      "id, content_item_id, version_num, stem, stimulus, prompt_json, rubric_type, evaluator_strategy, explanation, help_text, content_hash, status, approved_at, approved_by, published_at",
    )
    .eq("id", effectiveContentItemVersionId)
    .maybeSingle();

  if (contentError || !contentVersion) {
    return respond({ error: "not_found" }, { status: 404 });
  }

  if (
    requestedContentItemVersionId &&
    attempt.content_item_version_id !== contentVersion.id
  ) {
    return respond({ error: "content_version_mismatch" }, { status: 409 });
  }

  if (artifactVersionId && attempt.artifact_version_id !== artifactVersionId) {
    return respond({ error: "artifact_version_mismatch" }, { status: 409 });
  }
  return {
    attempt,
    responseVersion,
    derivedAssistanceState,
    effectiveContentItemVersionId,
    effectiveRubricVersionId,
    contentVersion,
  };
}

// The item, exam pack and rubric rows, publish and photo-policy checks, and the
// entitlement gate.
export async function loadItemContext(input: {
  service: Service;
  respond: Respond;
  user: Profile["user"];
  profile: Profile["profile"];
  operation: string;
  idempotencyKey: string;
  // deno-lint-ignore no-explicit-any
  attempt: Record<string, any>;
  // deno-lint-ignore no-explicit-any
  contentVersion: Record<string, any>;
}) {
  const {
    service,
    respond,
    user,
    profile,
    operation,
    idempotencyKey,
    attempt,
    contentVersion,
  } = input;
  const [
    { data: contentItem },
    { data: examPackVersion },
    { data: criteriaRows, error: criteriaError },
    { data: mcqChoices },
  ] = await Promise.all([
    service.schema("app")
      .from("content_items")
      .select("id, exam_pack_version_id, content_key, item_type, title, status, response_policy")
      .eq("id", contentVersion.content_item_id)
      .maybeSingle(),
    service.schema("app")
      .from("exam_pack_versions")
      .select("id, exam_pack_id, school_year, official_exam_date, status")
      .eq("id", attempt.exam_pack_version_id)
      .maybeSingle(),
    service.schema("app")
      .from("frq_criteria")
      .select(
        "criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants",
      )
      .eq("content_item_version_id", contentVersion.id)
      .order("criterion_key", { ascending: true }),
    service.schema("app")
      .from("mcq_choices")
      .select("choice_key, choice_text, is_correct, rationale")
      .eq("content_item_version_id", contentVersion.id)
      .order("choice_key", { ascending: true }),
  ]);

  if (!contentItem || !examPackVersion) {
    return respond({ error: "content_not_found" }, { status: 404 });
  }

  // re-QA finding 4: a frq_criteria READ ERROR must not masquerade as "no
  // criteria" (empty rows). An empty result is legitimate (MCQ / generated
  // data_driven items carry no frq_criteria); a genuine error would silently
  // flatten point weights and bypass the data_driven uncovered-criteria hold, so
  // fail loudly instead of grading against a fabricated empty rubric.
  if (criteriaError) {
    return respond({ error: "criteria_read_failed" }, { status: 500 });
  }

  if (
    contentItem.status !== "published" ||
    contentVersion.status !== "published" ||
    examPackVersion.status !== "published"
  ) {
    return respond({ error: "content_not_published" }, { status: 409 });
  }

  // TASK-0069 (QA P2-a): a photo_required item is scored by a human reviewer
  // (DECISION-0059); automated grading would move it out of the manual queue.
  if ((contentItem as { response_policy?: string | null }).response_policy === "photo_required") {
    return respond({ error: "human_review_required" }, { status: 409 });
  }

  // Product access is authoritative on the server. Paid/beta users pass
  // through; free-score-check users can reserve exactly one initial grade and
  // one repair grade, idempotently by request ID. Admin calls are operational
  // and intentionally bypass learner entitlements.
  if (GRADING_ENTITLEMENTS_ENABLED && profile.role !== "admin") {
    const { error: accessError } = await service.schema("app").rpc(
      "authorize_grading_access",
      {
        p_user_id: user.id,
        p_attempt_id: attempt.id,
        p_operation: operation,
        p_request_id: idempotencyKey,
      },
    );

    if (accessError) {
      const accessCode = accessError.message.match(
        /grading_access:([a-z_]+)/,
      )?.[1] ?? "entitlement_required";
      const status = accessCode === "attempt_not_found" ? 404 : 403;
      return respond({ error: accessCode }, { status });
    }
  }

  // Subject-driven grading: examName comes from the exam pack the question
  // actually belongs to, not a literal. This is what makes grading prompts
  // work for any subject without a code change per subject (TASK-0013
  // Phase 1) — fails loudly rather than silently falling back to Biology if
  // the exam pack row is somehow missing.
  const { data: examPack, error: examPackError } = await service
    .schema("app")
    .from("exam_packs")
    .select("id, exam_code, exam_name, subject_id")
    .eq("id", examPackVersion.exam_pack_id)
    .maybeSingle();

  if (examPackError || !examPack) {
    return respond({ error: "exam_pack_not_found" }, { status: 404 });
  }
  return {
    contentItem,
    examPackVersion,
    criteriaRows,
    mcqChoices,
    examPack,
  };
}
