import { stringOrNull as asString, looseUuid as asUuid } from "../_shared/input.ts";
import { sha256Text as sha256Hex } from "../_shared/encoding.ts";
import { createServiceClient } from "../_shared/supabase.ts";
import { jsonResponse, readJsonBody } from "../_shared/http.ts";
import { requireProfile } from "../_shared/auth.ts";
import { resolveGradingRoute } from "../_shared/grading-router.ts";
import { resolveFormulaRepairHint } from "../_shared/formula-notation.ts";
import {
  getVerificationProfile,
  summarizeVerificationProfile,
} from "../_shared/verification-profiles.ts";
import {
  buildStatisticsDeterministicFallback,
  checkStatisticsDeterministicEvidence,
  getStatisticsScopedCriteria,
} from "../_shared/statistics-verifier.ts";
import {
  buildDeterministicGradedPayload,
  buildFallbackCriteria,
  buildShadowReviewPayload,
  pickHighestGap,
} from "../_shared/grading-feedback.ts";
import { persistCellState } from "../_shared/cell-state-persist.ts";
import { deriveAssistanceState } from "../_shared/assistance-state.ts";
import {
  type AllowedOperation,
  applyDeterministicFlagScope,
  type FeedbackCriterionRow,
  type GradingExemplar,
  sanitizeModelResult,
} from "../_shared/grading-contract.ts";
import { loadLearningRuntimeContext } from "../_shared/learning-context.ts";
import { asRecord } from "../_shared/student-memory.ts";
import {
  buildEvaluateAttemptResponse,
  buildEvaluateAttemptResult,
} from "../_shared/evaluate-attempt-response.ts";
import {
  buildRepairPlan,
  lockGradeDecision,
} from "../_shared/grading-repair.ts";
import {
  createStageTimer,
  normalizeResponseText,
} from "../_shared/grading-telemetry.ts";
import { recordGrowthEvent } from "../_shared/growth-events.ts";
import { persistGradingMemory } from "../_shared/grading-memory.ts";
import { buildGraderSystemPrompt, runModelGrading } from "./model-grading.ts";
import {
  gradeDataDriven,
  gradeShadowReview,
  gradeSymbolicEcf,
} from "./deterministic-routes.ts";
import { loadMcqFeedbackContext } from "./mcq-context.ts";
import {
  EVALUATE_ATTEMPT_PROMPT_VERSION,
  gradingArm,
  GRADING_ENTITLEMENTS_ENABLED,
  MATH_VERIFIER_VERSION,
  OPENAI_DAILY_CAP_USD,
  OPENAI_INPUT_PRICE_PER_1M,
  OPENAI_MAX_OUTPUT_TOKENS,
  OPENAI_MODEL,
  OPENAI_OUTPUT_PRICE_PER_1M,
} from "./config.ts";
import { composeMcqFeedback, summarizeSelectedChoice } from "./mcq-feedback.ts";
import {
  checkpointGradeWrite,
  GRADE_STORE_FAILURE,
  type OutputCriterion,
  PENDING_GRADE_WRITE,
  persistAttemptCriterionResults,
  persistGradingTelemetry,
  PROCESSING_RECONCILIATION_MS,
  type Service,
  sanitizeGradingResultForClient,
  writeGradeResult,
} from "./grade-store.ts";

// Kept exported from the entry point for existing callers and tests.
export { composeMcqFeedback };



export type { AllowedOperation };


const allowedOperations = new Set<AllowedOperation>([
  "grade_initial_attempt",
  "select_repair",
  "grade_revision",
  "grade_transfer_attempt",
]);

function getBodyField(body: Record<string, unknown>, ...keys: string[]) {
  for (const key of keys) {
    const value = body[key];
    if (value !== undefined && value !== null) {
      return value;
    }
  }
  return undefined;
}


function estimateTokens(text: string) {
  return Math.max(32, Math.ceil(text.length / 4));
}

function money(value: number) {
  return Math.round(value * 10000) / 10000;
}

function parseJsonSafe(value: string | null | undefined) {
  if (!value) return null;
  try {
    return JSON.parse(value);
  } catch {
    return null;
  }
}


async function readBodyAsRecord(req: Request) {
  const body = await readJsonBody(req);
  return body && typeof body === "object" && !Array.isArray(body)
    ? body as Record<string, unknown>
    : null;
}

export interface EvaluateAttemptDeps {
  service?: Service;
  requireProfile?: typeof requireProfile;
}

const QA_NO_PERSIST_PATH_VERSION = "evaluate-attempt-qa-no-persist-2026-09-22";

// FF-11 (2026-09-24): this used to refuse any item that already carried a
// canonical_answer_1 (409 canonical_answer_already_present). That made
// DECISION-0052's rule -- "the production grader awards it 100% against its
// own rubric" -- permanently unverifiable for the 65 (of 68) Biology FRQ
// whose canonical predates the grader gate: once written, they could never
// be measured again. The guard added no security of its own (this path is
// already gated by the vault-held qa_grader_rpc_secret_v1 token, checked via
// verify_qa_grader_token below) and canonical_answer_1/2 are read only for
// that removed presence check -- never fed into the prompt or the response --
// so widening it cannot let an unverified canonical influence a score. See
// docs/product/AP_BIOLOGY_FAST_FOLLOW.md FF-11 and
// docs/research/biology_m1_regrade_and_blocker_2026_09_24/README.md.
//
/**
 * Privileged canonical-answer QA path.
 *
 * This deliberately reuses evaluate-attempt's live prompt builders, model
 * request shape, grading arm, retry behavior, and sanitizer, but it does not
 * create an attempt/response/grading-result row or run any post-grade side
 * effects. Access is limited to a database-held capability token checked by a
 * service-role-only RPC. The public gateway JWT remains enabled for the whole
 * function; the database wrapper supplies the project's anon JWT only to pass
 * that outer gateway, then supplies the private capability separately.
 */
async function handleQaNoPersist(
  req: Request,
  body: Record<string, unknown>,
  deps: EvaluateAttemptDeps = {},
) {
  const respond = (responseBody: unknown, init: ResponseInit = {}) =>
    jsonResponse(responseBody, init, req);
  const service = deps.service ?? createServiceClient();

  const qaToken = req.headers.get("x-qa-grader-token")?.trim() ?? "";
  if (!qaToken) {
    return respond({ error: "forbidden" }, { status: 403 });
  }

  const { data: tokenAccepted, error: tokenError } = await service
    .schema("app")
    .rpc("verify_qa_grader_token", { p_token: qaToken });
  if (tokenError || tokenAccepted !== true) {
    return respond({ error: "forbidden" }, { status: 403 });
  }

  const contentItemVersionId = asUuid(
    getBodyField(body, "content_item_version_id", "contentItemVersionId"),
  );
  const answerText = asString(
    getBodyField(body, "answer_text", "answerText"),
  )?.trim() ?? "";

  if (!contentItemVersionId || !answerText) {
    return respond(
      {
        error: "missing_required_fields",
        required: ["content_item_version_id", "answer_text"],
      },
      { status: 400 },
    );
  }
  if (answerText.length > 50_000) {
    return respond({ error: "answer_too_large" }, { status: 413 });
  }

  const { data: contentVersion, error: contentError } = await service
    .schema("app")
    .from("content_item_versions")
    .select(
      "id, content_item_id, version_num, stem, stimulus, prompt_json, rubric_type, evaluator_strategy, status, canonical_answer_1, canonical_answer_2, created_at",
    )
    .eq("id", contentItemVersionId)
    .maybeSingle();
  if (contentError || !contentVersion) {
    return respond({ error: "content_not_found" }, { status: 404 });
  }

  const [
    { data: latestVersion, error: latestVersionError },
    { data: contentItem, error: contentItemError },
    { data: criteriaRows, error: criteriaError },
  ] = await Promise.all([
    service.schema("app")
      .from("content_item_versions")
      .select("id, version_num, created_at")
      .eq("content_item_id", contentVersion.content_item_id)
      .order("version_num", { ascending: false })
      .order("created_at", { ascending: false })
      .order("id", { ascending: false })
      .limit(1)
      .maybeSingle(),
    service.schema("app")
      .from("content_items")
      .select(
        "id, exam_pack_version_id, content_key, item_type, title, status",
      )
      .eq("id", contentVersion.content_item_id)
      .maybeSingle(),
    service.schema("app")
      .from("frq_criteria")
      .select(
        "criterion_key, learner_facing_text, points_possible, evidence_requirements, minimum_fix, accepted_variants",
      )
      .eq("content_item_version_id", contentVersion.id)
      .order("criterion_key", { ascending: true }),
  ]);

  if (latestVersionError || !latestVersion) {
    return respond({ error: "latest_version_lookup_failed" }, { status: 500 });
  }
  if (latestVersion.id !== contentVersion.id) {
    return respond(
      {
        error: "content_version_not_latest",
        requested_content_item_version_id: contentVersion.id,
        latest_content_item_version_id: latestVersion.id,
      },
      { status: 409 },
    );
  }
  if (contentItemError || !contentItem) {
    return respond({ error: "content_item_not_found" }, { status: 404 });
  }
  if (
    criteriaError || !Array.isArray(criteriaRows) || criteriaRows.length === 0
  ) {
    return respond({ error: "criteria_not_found" }, { status: 409 });
  }
  if (
    contentItem.item_type !== "frq" ||
    contentItem.status !== "published" ||
    contentVersion.status !== "published"
  ) {
    return respond({ error: "content_not_published_frq" }, { status: 409 });
  }

  const { data: examPackVersion, error: examPackVersionError } = await service
    .schema("app")
    .from("exam_pack_versions")
    .select("id, exam_pack_id, status")
    .eq("id", contentItem.exam_pack_version_id)
    .maybeSingle();
  if (examPackVersionError || !examPackVersion) {
    return respond({ error: "exam_pack_version_not_found" }, { status: 404 });
  }
  if (examPackVersion.status !== "published") {
    return respond({ error: "exam_pack_version_not_published" }, {
      status: 409,
    });
  }

  const { data: examPack, error: examPackError } = await service.schema("app")
    .from("exam_packs")
    .select("id, exam_code, exam_name")
    .eq("id", examPackVersion.exam_pack_id)
    .maybeSingle();
  if (examPackError || !examPack) {
    return respond({ error: "exam_pack_not_found" }, { status: 404 });
  }
  if (examPack.exam_code !== "ap_biology") {
    return respond({ error: "qa_path_ap_biology_only" }, { status: 409 });
  }

  const promptVersion = EVALUATE_ATTEMPT_PROMPT_VERSION;
  const { data: promptVersionRow, error: promptVersionError } = await service
    .schema("app")
    .from("prompt_versions")
    .select("id, status")
    .eq("operation", "grade_initial_attempt")
    .eq("version", promptVersion)
    .maybeSingle();
  if (
    promptVersionError || !promptVersionRow ||
    promptVersionRow.status !== "published"
  ) {
    return respond({ error: "invalid_prompt_version" }, { status: 409 });
  }

  const routing = resolveGradingRoute({
    rubricType: contentVersion.rubric_type,
    evaluatorStrategy: contentVersion.evaluator_strategy,
    itemType: contentItem.item_type,
    promptJson: contentVersion.prompt_json,
  });
  if (routing.target !== "llm_text") {
    return respond(
      {
        error: "qa_path_requires_llm_text",
        resolved_target: routing.target,
      },
      { status: 409 },
    );
  }

  const criteria = criteriaRows as FeedbackCriterionRow[];
  const promptBase = {
    operation: "grade_initial_attempt" as AllowedOperation,
    promptVersion,
    examName: examPack.exam_name as string,
    itemTitle: contentItem.title as string,
    itemType: contentItem.item_type as string,
    stem: contentVersion.stem as string,
    stimulus: contentVersion.stimulus as string | null,
    responseText: answerText,
    responseParts: {},
    criteria,
  };

  const answerSha256 = await sha256Hex(answerText);
  const idempotencyKey =
    `qa:${contentVersion.id}:${promptVersion}:${answerSha256}`;
  const userIdHash = await sha256Hex(`canonical-qa:${contentVersion.id}`);
  const gradingArmForRequest = gradingArm();
  const systemPrompt = buildGraderSystemPrompt(
    gradingArmForRequest,
    examPack.exam_name as string,
  );

  try {
    const graded = await runModelGrading({
      arm: gradingArmForRequest,
      modelId: OPENAI_MODEL,
      systemPrompt,
      promptBase,
      sanitizeContext: { responseText: answerText, responseParts: {} },
      userIdHash,
      idempotencyKey,
    });
    const finalPayload = graded.finalPayload;
    const rawGraderResponse = graded.response.raw;
    const inputTokens = graded.inputTokens ?? 0;
    const outputTokens = graded.outputTokens ?? 0;
    const cachedTokens = graded.cachedTokens;
    const latencyMs = graded.response.elapsedMs;

    const possibleByKey = new Map(
      criteria.map((criterion) => [
        criterion.criterion_key,
        Number(criterion.points_possible || 0),
      ]),
    );
    const criterionResults = finalPayload.criteria.map((criterion) => ({
      ...criterion,
      points_possible: possibleByKey.get(criterion.criterion_key) ?? 0,
    }));

    return respond({
      status: finalPayload.status,
      function: "evaluate-attempt",
      mode: "qa_no_persist",
      content_key: contentItem.content_key,
      content_item_version_id: contentVersion.id,
      result: {
        ...finalPayload,
        criteria: criterionResults,
        carry_forward_used: false,
        carry_forward_reason:
          "QA no-persist mode has no prior-attempt context.",
      },
      grader: {
        qa_path_version: QA_NO_PERSIST_PATH_VERSION,
        deployment_id: Deno.env.get("DENO_DEPLOYMENT_ID") ?? null,
        execution_id: Deno.env.get("SB_EXECUTION_ID") ?? null,
        model_id: OPENAI_MODEL,
        prompt_version: promptVersion,
        grading_arm: gradingArmForRequest,
        latency_ms: latencyMs,
        input_tokens: inputTokens,
        output_tokens: outputTokens,
        cached_tokens: cachedTokens,
      },
      raw_grader_response: rawGraderResponse,
      persistence: {
        wrote_attempts: false,
        wrote_response_versions: false,
        wrote_grading_results: false,
        wrote_model_usage_ledger: false,
        wrote_student_memory: false,
        wrote_student_cell_state: false,
        wrote_content: false,
      },
    });
  } catch (error) {
    return respond(
      {
        error: "qa_grading_failed",
        detail: error instanceof Error ? error.message : "unknown_error",
        qa_path_version: QA_NO_PERSIST_PATH_VERSION,
      },
      { status: 500 },
    );
  }
}

export async function handleEvaluateAttempt(
  req: Request,
  deps: EvaluateAttemptDeps = {},
): Promise<Response> {
  const respond = (body: unknown, init: ResponseInit = {}) =>
    jsonResponse(body, init, req);

  if (req.method === "OPTIONS") {
    return respond({ ok: true }, { status: 200 });
  }

  if (req.method !== "POST") {
    return respond({ error: "method_not_allowed" }, { status: 405 });
  }

  const body = await readBodyAsRecord(req);
  if (!body) {
    return respond({ error: "invalid_json" }, { status: 400 });
  }

  if (body.qa_no_persist === true) {
    return await handleQaNoPersist(req, body, deps);
  }

  const operation = asString(getBodyField(body, "operation"));
  if (!operation || !allowedOperations.has(operation as AllowedOperation)) {
    return respond({ error: "invalid_operation" }, { status: 400 });
  }

  const idempotencyKey = asString(
    getBodyField(
      body,
      "idempotency_key",
      "idempotencyKey",
      "request_id",
      "requestId",
    ),
  );
  const attemptId = asUuid(getBodyField(body, "attempt_id", "attemptId"));
  const responseVersionId = asUuid(
    getBodyField(body, "response_version_id", "responseVersionId"),
  );
  const artifactVersionId = asUuid(
    getBodyField(body, "artifact_version_id", "artifactVersionId"),
  );
  const requestedContentItemVersionId = asUuid(
    getBodyField(body, "content_item_version_id", "contentItemVersionId"),
  );
  const requestedRubricVersionId = asUuid(
    getBodyField(body, "rubric_version_id", "rubricVersionId"),
  );
  // Prompt rollout is server-controlled. The version comes from
  // EVALUATE_ATTEMPT_PROMPT_VERSION only — any prompt_version supplied in
  // the request body is ignored. This closes the loophole where a client
  // could otherwise select any published prompt row at request time and
  // bypass the env-controlled rollout gate documented in
  // 202606210005_seed_initial_prompt_versions.sql.
  const promptVersion = EVALUATE_ATTEMPT_PROMPT_VERSION;
  const assistanceCondition = asString(
    getBodyField(body, "assistance_condition", "assistanceCondition"),
  ) ?? "independent";
  // Per-request opt-in for the exemplar-grading pilot
  // (docs/research/exemplar_grading_pilot_2026_08/). Deliberately per-request,
  // not env-based like GRADING_ARM: the pilot's capture script needs to flip
  // between "off" and "with_exemplar" call-to-call without a redeploy.
  // Defaults to "off" and any unrecognized value collapses to "off", so
  // existing callers (which never send this field) are byte-for-byte
  // unaffected. Exemplar payloads are supplied directly by the pilot's
  // capture script (sourced from that pilot's own materialized fixtures, not
  // a DB fetch here) to avoid adding a DB round-trip to a latency-sensitive
  // grading path for what is currently pilot-only usage.
  const exemplarModeRaw = asString(
    getBodyField(body, "exemplar_mode", "exemplarMode"),
  );
  const exemplarMode = exemplarModeRaw === "with_exemplar"
    ? "with_exemplar"
    : "off";
  const requestExemplars = exemplarMode === "with_exemplar"
    ? (Array.isArray(getBodyField(body, "exemplars"))
      ? getBodyField(body, "exemplars") as GradingExemplar[]
      : undefined)
    : undefined;

  if (!idempotencyKey || !attemptId || !responseVersionId) {
    return respond(
      {
        error: "missing_required_fields",
        required: [
          "idempotency_key",
          "attempt_id",
          "response_version_id",
        ],
      },
      { status: 400 },
    );
  }

  // Passive stage timings (replan 2.2): wall-clock per stage, written
  // best-effort at the end. Attacks the measured ~691 ms p50 non-model
  // floor with data; never affects the grading itself.
  const stageTimer = createStageTimer();

  const authenticate = deps.requireProfile ?? requireProfile;
  const profileResult = await authenticate(req);
  if (!profileResult) {
    return respond({ error: "unauthorized" }, { status: 401 });
  }
  stageTimer.mark("auth");

  const { user, profile } = profileResult;
  if (profile.role !== "student" && profile.role !== "admin") {
    return respond({ error: "forbidden" }, { status: 403 });
  }

  const service = deps.service ?? createServiceClient();

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

  const requestHashPayload = {
    operation,
    idempotencyKey,
    attemptId,
    responseVersionId,
    artifactVersionId,
    contentItemVersionId: effectiveContentItemVersionId,
    rubricVersionId: effectiveRubricVersionId,
    assistanceCondition,
    promptVersion,
  };
  const requestHash = await sha256Hex(JSON.stringify(requestHashPayload));

  // Replays may recover a private pending write, but NEVER call the grader.
  const respondFromStoredResult = async (
    row: Record<string, unknown>,
    recover = true,
  ): Promise<Response> => {
    if (row.request_hash !== requestHash) {
      return respond({ error: "idempotency_conflict" }, { status: 409 });
    }
    if (
      row.status === "failed" && row.uncertainty_reason === GRADE_STORE_FAILURE
    ) {
      if (!recover) {
        return respond({ error: "grade_store_retry_conflict", retryable: true }, {
          status: 409,
        });
      }
      const checkpoint = asRecord(row.raw_model_response);
      const payload = asRecord(checkpoint.payload);
      const forbidden = [
        "id",
        "request_id",
        "request_hash",
        "attempt_id",
        "response_version_id",
        "operation",
        "created_at",
        "updated_at",
      ];
      if (
        checkpoint.kind !== PENDING_GRADE_WRITE ||
        checkpoint.request_hash !== requestHash ||
        checkpoint.operation !== operation ||
        !["graded", "uncertain"].includes(String(payload.status)) ||
        forbidden.some((key) => Object.hasOwn(payload, key)) ||
        typeof row.updated_at !== "string" ||
        !Number.isFinite(Date.parse(row.updated_at))
      ) {
        return respond({
          error: "grading_reconciliation_required",
          reconciliation_required: true,
        }, { status: 503 });
      }
      // The version fence admits one writer; losers read its committed result.
      const { data: recovered, error } = await writeGradeResult(
        service,
        idempotencyKey,
        requestHash,
        payload,
        row.updated_at,
      );
      if (error) {
        console.error("evaluate-attempt:grade_store_retry_failed", {
          request_id: idempotencyKey,
          code: error.code,
        });
        return respond({ error: GRADE_STORE_FAILURE, retryable: true }, {
          status: 500,
        });
      }
      if (recovered) return await respondFromStoredResult(recovered, false);
      const { data: latest, error: readError } = await service.schema("app").from(
        "grading_results",
      )
        .select("*").eq("request_id", idempotencyKey).maybeSingle();
      if (readError || !latest) {
        return respond({
          error: "grading_reconciliation_required",
          reconciliation_required: true,
        }, { status: 503 });
      }
      return await respondFromStoredResult(latest, false);
    }
    if (row.status === "processing") {
      const updatedAt = Date.parse(
        String(row.updated_at ?? row.created_at ?? ""),
      );
      if (
        !Number.isFinite(updatedAt) ||
        Date.now() - updatedAt >= PROCESSING_RECONCILIATION_MS
      ) {
        return respond({
          error: "grading_reconciliation_required",
          reconciliation_required: true,
        }, { status: 503 });
      }
    }
    // A grade recovered after a failed store must also reach the attempt truth
    // row used by progress. Retrying this projection never re-runs grading and
    // cannot overwrite an attempt another request has already finalized.
    if (["graded", "uncertain"].includes(String(row.status)) && attempt.status === "submitted") {
      try {
        const { data: updated, error } = await service.schema("app").from("attempts")
          .update({
            status: row.status,
            graded_at: row.updated_at ?? new Date().toISOString(),
            score_points: row.points_earned,
            score_possible: row.points_available,
            confidence_level: row.confidence,
            result_state: row.status,
            result_summary: row.feedback_preview,
            assistance_state: derivedAssistanceState,
          }).eq("id", attempt.id).eq("status", "submitted").select("id").maybeSingle();
        if (error) throw error;
        if (!updated) {
          const { data: latestAttempt, error: readError } = await service.schema("app").from("attempts")
            .select("status").eq("id", attempt.id).maybeSingle();
          if (readError || !["graded", "uncertain"].includes(String(latestAttempt?.status))) {
            throw readError ?? { code: "attempt_not_finalized" };
          }
        }
      } catch (error) {
        console.error("attempts_grading_truth_recovery_failed", {
          attempt_id: attempt.id,
          code: typeof error === "object" && error !== null && "code" in error ? error.code : "transport_error",
        });
        return respond({ error: "attempt_grade_store_failed", retryable: true }, { status: 503 });
      }
    }
    return respond({
      status: row.status,
      function: "evaluate-attempt",
      operation,
      result: sanitizeGradingResultForClient(row),
    }, { status: row.status === "processing" ? 202 : 200 });
  };
  const { data: existingResult, error: existingReadError } = await service.schema(
    "app",
  )
    .from("grading_results").select("*").eq("request_id", idempotencyKey)
    .maybeSingle();
  if (existingReadError) {
    return respond({ error: "grading_result_read_failed" }, { status: 503 });
  }
  if (existingResult) return await respondFromStoredResult(existingResult);
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
  stageTimer.mark("db");

  const responseParts = parseJsonSafe(
    typeof responseVersion.response_parts === "string"
      ? responseVersion.response_parts
      : JSON.stringify(responseVersion.response_parts),
  ) ?? {};
  const responseText = typeof responseVersion.response_text === "string"
    ? responseVersion.response_text
    : null;
  const statisticsCheck = checkStatisticsDeterministicEvidence({
    contentKey: contentItem.content_key as string | null,
    responseText,
  });
  // O2 (2026-08-13): when a flag has a known per-criterion mapping, scope
  // the deterministic hold to just those criteria instead of the whole
  // item -- see getStatisticsScopedCriteria for which items qualify. Null
  // means "no mapping known," so the caller must fall back to the
  // item-wide behavior below (statisticsDeterministicFallback), unchanged
  // from before this change.
  const statisticsScopedCriteriaKeys = statisticsCheck?.status === "flag"
    ? getStatisticsScopedCriteria(contentItem.content_key as string | null)
    : null;
  stageTimer.mark("deterministic");
  // Replay-rate telemetry (passive): hash of the normalized response text.
  const normalizedResponseSha256 = await sha256Hex(
    normalizeResponseText(responseText),
  );

  const promptBase = {
    operation: operation as AllowedOperation,
    promptVersion,
    examName: examPack.exam_name as string,
    itemTitle: contentItem.title as string,
    itemType: contentItem.item_type as string,
    stem: contentVersion.stem as string,
    stimulus: contentVersion.stimulus as string | null,
    responseText,
    responseParts,
    criteria: Array.isArray(criteriaRows)
      ? criteriaRows as FeedbackCriterionRow[]
      : [],
    exemplars: requestExemplars,
  };

  const gradingRuntimeContext = attempt.learning_session_id
    ? await loadLearningRuntimeContext(
      service,
      attempt.learning_session_id as string,
    )
    : null;
  stageTimer.mark("db");
  const gradingRuntimeSubject = asRecord(
    asRecord(gradingRuntimeContext?.subject_defaults).subject,
  );
  const verificationProfile = getVerificationProfile(
    asString(gradingRuntimeSubject.subject_key),
  );
  const verificationProfileSummary = summarizeVerificationProfile(
    verificationProfile,
  );

  const routing = resolveGradingRoute({
    rubricType: (contentVersion as Record<string, unknown>).rubric_type,
    evaluatorStrategy:
      (contentVersion as Record<string, unknown>).evaluator_strategy,
    itemType: contentItem.item_type as string | null,
    promptJson: contentVersion.prompt_json,
  });

  const defaultPointsAvailable = promptBase.criteria.reduce(
    (sum, criterion) => sum + Number(criterion.points_possible || 0),
    0,
  ) || (contentItem.item_type === "mcq" ? 1 : 0);
  // Scoped flags skip the item-wide fallback entirely -- they proceed to
  // the normal model call below, and the flagged criteria are overridden
  // afterward (search statisticsScopedCriteriaKeys further down). Only an
  // unscoped flag (no known criterion mapping) still short-circuits here.
  const statisticsDeterministicFallback =
    routing.target === "llm_text" && !statisticsScopedCriteriaKeys
      ? buildStatisticsDeterministicFallback({
        contentKey: contentItem.content_key as string | null,
        responseText,
        criteria: promptBase.criteria,
        pointsAvailable: defaultPointsAvailable,
      })
      : null;
  stageTimer.mark("deterministic");

  const routedModelId = routing.target === "mcq_rule"
    ? "rule-based-mcq"
    : routing.target === "llm_text"
    ? statisticsDeterministicFallback
      ? "deterministic-statistics-prefilter"
      : OPENAI_MODEL
    : routing.target === "symbolic_ecf"
    ? "symbolic-ecf-verifier"
    : routing.target === "data_driven"
    ? "data-driven-deterministic-verifier"
    : "shadow-review-placeholder";

  const estimatedInputTokens = estimateTokens(
    [
      JSON.stringify(promptBase),
      JSON.stringify(contentVersion.prompt_json ?? {}),
    ].join("\n"),
  );
  const reservedCost = money(
    (estimatedInputTokens / 1_000_000) * OPENAI_INPUT_PRICE_PER_1M +
      (OPENAI_MAX_OUTPUT_TOKENS / 1_000_000) * OPENAI_OUTPUT_PRICE_PER_1M,
  );
  const modelId = OPENAI_MODEL;

  const requestRecord = {
    request_id: idempotencyKey,
    request_hash: requestHash,
    attempt_id: attempt.id,
    response_version_id: responseVersion.id,
    operation,
    status: "processing",
    points_available: defaultPointsAvailable,
    confidence: "medium",
    model_id: routedModelId,
    prompt_version: promptVersion,
    rubric_version_id: effectiveRubricVersionId,
    estimated_cost_usd: statisticsDeterministicFallback ? 0 : reservedCost,
    deterministic_verifier_version: MATH_VERIFIER_VERSION,
    boundary_contract_version: verificationProfile?.profile_version ?? null,
  };

  const { data: insertedResult, error: insertError } = await service.schema(
    "app",
  )
    .from("grading_results")
    .insert(requestRecord)
    .select("*")
    .maybeSingle();

  if (insertError || !insertedResult) {
    const { data: conflictResult } = await service.schema("app")
      .from("grading_results")
      .select("*")
      .eq("request_id", idempotencyKey)
      .maybeSingle();

    if (conflictResult) return await respondFromStoredResult(conflictResult);

    return respond({ error: "could_not_create_grading_record" }, {
      status: 409,
    });
  }

  let usageRow: Record<string, unknown> | null = null;
  const isMcq = routing.target === "mcq_rule";

  if (routing.target === "llm_text" && !statisticsDeterministicFallback) {
    try {
      usageRow = await service.schema("app").rpc("reserve_model_usage", {
        p_request_id: idempotencyKey,
        p_request_hash: requestHash,
        p_model_id: modelId,
        p_reserved_cost_usd: reservedCost,
        p_cap_usd: OPENAI_DAILY_CAP_USD,
      }).then((result) => result.data as Record<string, unknown> | null);

      if (!usageRow) {
        throw new Error("budget_reservation_failed");
      }
    } catch (error) {
      await service.schema("app")
        .from("grading_results")
        .update({
          status: "failed",
          confidence: "low",
          uncertainty_reason: error instanceof Error
            ? error.message
            : "budget_reservation_failed",
        })
        .eq("request_id", idempotencyKey);

      return respond(
        {
          status: "budget_capped",
          function: "evaluate-attempt",
          operation,
          message:
            "Cramapple has reached today's research limit. Your work is saved. Please come back after the daily limit resets.",
        },
        { status: 429 },
      );
    }
  }

  if (isMcq) {
    const selectedChoice =
      summarizeSelectedChoice(responseParts as Record<string, unknown>) ??
        responseText?.trim() ??
        null;
    const correctChoice = Array.isArray(mcqChoices)
      ? mcqChoices.find((choice) => choice.is_correct)
      : null;
    const earned = selectedChoice &&
        correctChoice &&
        (selectedChoice === correctChoice.choice_key ||
          selectedChoice === correctChoice.choice_text)
      ? 1
      : 0;

    const normalizedSelection = selectedChoice?.trim().toUpperCase() ?? null;
    const chosenChoice = Array.isArray(mcqChoices)
      ? mcqChoices.find((choice) =>
        (typeof choice.choice_key === "string" &&
          choice.choice_key.trim().toUpperCase() === normalizedSelection) ||
        (typeof choice.choice_text === "string" && selectedChoice !== null &&
          choice.choice_text.trim() === selectedChoice.trim())
      ) ?? null
      : null;

    const { skillLabels, unitNumber } = await loadMcqFeedbackContext({
      service,
      contentVersion,
      earned,
    });

    const { summary, actionableFix, redirect } = composeMcqFeedback({
      earned: earned === 1,
      rationale: chosenChoice && !chosenChoice.is_correct
        ? chosenChoice.rationale
        : null,
      skillLabels,
      unitNumber,
      // Stable per item and per chosen distractor: the same result re-read
      // reads the same way, while two items in one session almost certainly
      // take different shapes.
      variantSeed: `${contentVersion.id}:${chosenChoice?.choice_key ?? ""}`,
    });

    const criteria: OutputCriterion[] = [
      {
        criterion_key: "mcq_correct_choice",
        status: earned ? "earned" : "not_yet_earned",
        points_awarded: earned,
        evidence_quote: selectedChoice,
        decision_explanation: earned
          ? "The selected choice matches the published correct answer."
          : "The submitted choice does not match the published correct answer.",
        minimum_fix: earned ? null : actionableFix,
      },
    ];

    const finalResult = {
      status: "graded",
      points_earned: earned,
      points_available: 1,
      criteria,
      highest_value_gap: earned ? null : {
        criterion_key: "mcq_correct_choice",
        minimum_fix: actionableFix,
        repair_prompt: redirect,
      },
      predicted_improvement: null,
      confidence: "high",
      uncertainty_reason: null,
      student_facing_summary: summary,
    };

    const gradePayload = {
      status: "graded",
      points_earned: finalResult.points_earned,
      points_available: finalResult.points_available,
      criterion_results: finalResult.criteria,
      highest_value_gap: finalResult.highest_value_gap,
      predicted_label: null,
      predicted_point_gain: null,
      actual_point_gain: null,
      prediction_outcome: null,
      confidence: finalResult.confidence,
      uncertainty_reason: null,
      model_id: "rule-based-mcq",
      prompt_version: promptVersion,
      rubric_version_id: effectiveRubricVersionId,
      deterministic_verifier_version: MATH_VERIFIER_VERSION,
      boundary_contract_version: verificationProfile?.profile_version ?? null,
      feedback_preview: finalResult.student_facing_summary,
      input_tokens: 0,
      output_tokens: 0,
      estimated_cost_usd: 0,
      latency_ms: 0,
      raw_model_response: null,
    };
    const { data: storedGrade, error: gradeStoreError } = await writeGradeResult(service, idempotencyKey, requestHash, gradePayload);
    if (gradeStoreError || !storedGrade) {
      console.error("evaluate-attempt:grade_store_failed", { request_id: idempotencyKey, route: "mcq_rule", code: gradeStoreError?.code ?? "missing_row" });
      const retryable = await checkpointGradeWrite(service, idempotencyKey, requestHash, operation, gradePayload);
      return respond({ error: GRADE_STORE_FAILURE, retryable, ...(!retryable ? { reconciliation_required: true } : {}) }, { status: 500 });
    }

    // STUDENT_INTERACTION_DATA_SCHEMA_PLAN_2026_09_27.md Phase 0 item 6 finding:
    // this write was previously fire-and-forget (no error captured), and a live
    // audit found attempts.status/graded_at/confidence_level/score_points/
    // result_summary are 0% populated in Production despite grading_results
    // (updated just above) being genuinely correct -- i.e. this exact update has
    // apparently never once succeeded on real traffic. The leading suspect is
    // app.attempts' attempts_prevent_client_grading_truth_update trigger, which
    // only permits these columns to change when the request resolves to
    // service_role -- capturing and logging the error here (rather than
    // continuing to swallow it) is the only way to confirm the actual cause the
    // next time a real attempt is graded, without guessing at a fix blind.
    const { error: attemptUpdateError } = await service.schema("app").from(
      "attempts",
    ).update({
      status: "graded",
      graded_at: new Date().toISOString(),
      score_points: finalResult.points_earned,
      score_possible: finalResult.points_available,
      confidence_level: finalResult.confidence,
      result_state: "graded",
      result_summary: finalResult.student_facing_summary,
      assistance_state: derivedAssistanceState,
    }).eq("id", attempt.id);
    if (attemptUpdateError) {
      console.error("attempts_grading_truth_update_failed", {
        attempt_id: attempt.id,
        route: "deterministic",
        error: attemptUpdateError.message,
        code: (attemptUpdateError as { code?: string }).code,
      });
    }

    await Promise.all([
      persistGradingTelemetry(service, idempotencyKey, {
        normalized_response_sha256: normalizedResponseSha256,
        cached_tokens: null,
        stage_timings: stageTimer.finish(),
      }),
      persistAttemptCriterionResults(
        service,
        attempt.id as string,
        finalResult.criteria,
        "rule-based-mcq",
      ),
    ]);

    const runtimeContext = await persistGradingMemory({
      service,
      sessionId: attempt.learning_session_id as string | null,
      attemptId: attempt.id,
      attemptMode: attempt.attempt_mode as string,
      assistanceState: derivedAssistanceState as string,
      finalStatus: "graded",
      pointsEarned: finalResult.points_earned,
      pointsAvailable: finalResult.points_available,
      confidence: finalResult.confidence,
      highestValueGap: finalResult.highest_value_gap,
      criteria,
      summary: finalResult.student_facing_summary,
      feedbackPreview: finalResult.student_facing_summary,
      actionHint: null,
      repairHint: finalResult.highest_value_gap?.repair_prompt ?? null,
      deterministicCheck: statisticsCheck,
      examPackVersionId: attempt.exam_pack_version_id as string,
    });

    // Course Mode F2/F3: update cell mastery for a cell-tagged item. No-op for
    // untagged (legacy/non-course-mode) items; routed on item identity, never
    // session presence. Best-effort -- never fails the grade.
    await persistCellState({
      service,
      userId: attempt.user_id as string,
      contentItemVersionId: contentVersion.id as string,
      attemptId: attempt.id as string,
      subjectId: examPack.subject_id as string,
      sessionId: attempt.learning_session_id as string | null,
      assistanceState: derivedAssistanceState,
      attemptMode: attempt.attempt_mode as string,
      preSubmitHintCount: attempt.pre_submit_hint_count as number | null,
      finalStatus: "graded",
      pointsEarned: finalResult.points_earned,
      pointsAvailable: finalResult.points_available,
      submittedAt: attempt.submitted_at as string | null,
    });

    return respond(
      {
        status: "graded",
        function: "evaluate-attempt",
        operation,
        result: finalResult,
        runtime_context: runtimeContext,
      },
      { status: 200 },
    );
  }

  let modelResponse: {
    raw: Record<string, unknown>;
    parsed: Record<string, unknown>;
    elapsedMs: number;
  } | null = null;
  let finalStatus: "graded" | "uncertain" | "failed" = "failed";
  let finalPayload:
    | ReturnType<typeof sanitizeModelResult>
    | ReturnType<typeof buildShadowReviewPayload>
    | ReturnType<typeof buildDeterministicGradedPayload>
    | NonNullable<ReturnType<typeof buildStatisticsDeterministicFallback>>
    | null = null;
  let inputTokens = estimatedInputTokens;
  let outputTokens = 0;
  let actualCost = 0;
  // Passive telemetry only -- null means "provider reported nothing".
  let cachedTokensTelemetry: number | null = null;
  // Engine 3 shadow capture (TASK-0016 addendum, 2026-08-14): the
  // symbolic_ecf path's real ECF verdict was previously discarded --
  // finalStatus stays "uncertain" either way (shadow, non-authoritative),
  // but the actual computed result is now retained here instead of only
  // surviving as a substring inside uncertainty_reason's JSON.stringify.
  let shadowResult: Record<string, unknown> | null = null;
  // Stamped into grading_results.deterministic_verifier_version. Defaults to the
  // math/ECF verifier; the data_driven branch overrides it so a generated grade
  // is attributed to the verifier that actually produced it (Fable QA #4).
  let deterministicVerifierVersion = MATH_VERIFIER_VERSION;

  // Deterministic and held routes never call the model: no tokens, no cost.
  const routeContext = {
    contentItem,
    contentVersion,
    responseText,
    responseParts,
    promptBase,
    routing,
    statisticsCheck,
    defaultPointsAvailable,
    verificationProfile,
    verificationProfileSummary,
  };
  if (routing.target === "symbolic_ecf") {
    ({ finalPayload, finalStatus, shadowResult } = gradeSymbolicEcf(routeContext));
    modelResponse = null;
    inputTokens = 0;
    outputTokens = 0;
    actualCost = 0;
  } else if (routing.target === "data_driven") {
    ({ finalPayload, finalStatus, shadowResult, deterministicVerifierVersion } =
      await gradeDataDriven(service, routeContext));
    modelResponse = null;
    inputTokens = 0;
    outputTokens = 0;
    actualCost = 0;
  } else if (routing.target === "shadow_review") {
    ({ finalPayload, finalStatus } = gradeShadowReview(routeContext));
    modelResponse = null;
    inputTokens = 0;
    outputTokens = 0;
    actualCost = 0;
  } else {
    if (statisticsDeterministicFallback) {
      finalPayload = statisticsDeterministicFallback;
      finalStatus = "uncertain";
      modelResponse = null;
      inputTokens = 0;
      outputTokens = 0;
      actualCost = 0;
    } else {
      const gradingArmForRequest = gradingArm();
      const systemPrompt = buildGraderSystemPrompt(
        gradingArmForRequest,
        examPack.exam_name as string,
      );

      try {
        await service.schema("app").from("grading_results").update({
          status: "processing",
          model_id: routedModelId,
          estimated_cost_usd: reservedCost,
          prompt_version: promptVersion,
          rubric_version_id: effectiveRubricVersionId,
          deterministic_verifier_version: MATH_VERIFIER_VERSION,
          boundary_contract_version: verificationProfile?.profile_version ??
            null,
        }).eq("request_id", idempotencyKey);

        if (usageRow) {
          await service.schema("app").from("model_usage_ledger").update({
            status: "running",
          }).eq("request_id", idempotencyKey);
        }

        const graded = await runModelGrading({
          arm: gradingArmForRequest,
          modelId,
          systemPrompt,
          promptBase,
          sanitizeContext: { responseText, responseParts },
          userIdHash: await sha256Hex(user.id),
          idempotencyKey,
          // Record what is known before sanitization, which can throw: arm B
          // keeps the raw response and latency for the stored row, arm A keeps
          // its cached-token telemetry (see ModelReturnedEvent).
          onModelReturned: (event) => {
            stageTimer.mark("model");
            if (event.arm === "a") cachedTokensTelemetry = event.cachedTokens;
            else modelResponse = event.response;
          },
        });
        finalPayload = graded.finalPayload;
        modelResponse = graded.response;
        inputTokens = graded.inputTokens ?? inputTokens;
        outputTokens = graded.outputTokens ?? outputTokens;
        cachedTokensTelemetry = graded.cachedTokens;
        stageTimer.mark("sanitize");

        // O2 (2026-08-13): the model graded the whole item normally above --
        // now force just the deterministic-flagged criteria back to
        // unable_to_determine, leaving every other criterion's real,
        // model-graded verdict (and points) intact.
        if (statisticsScopedCriteriaKeys && finalPayload && statisticsCheck) {
          finalPayload = {
            ...finalPayload,
            ...applyDeterministicFlagScope(
              finalPayload,
              promptBase.criteria,
              statisticsScopedCriteriaKeys,
              statisticsCheck.reason,
            ),
          };
        }

        finalStatus = finalPayload.status === "graded" ? "graded" : "uncertain";

        const pricingInputTokens = inputTokens;
        const pricingOutputTokens = outputTokens;
        actualCost = money(
          (pricingInputTokens / 1_000_000) * OPENAI_INPUT_PRICE_PER_1M +
            (pricingOutputTokens / 1_000_000) * OPENAI_OUTPUT_PRICE_PER_1M,
        );
      } catch (error) {
        const errorMessage = error instanceof Error
          ? error.message
          : "grading_failed";
        finalStatus = "uncertain";
        finalPayload = {
          status: finalStatus,
          points_earned: 0,
          points_available: defaultPointsAvailable,
          criteria: buildFallbackCriteria(
            promptBase.criteria,
            "Cramapple can offer a few useful observations, but it is not confident enough to present this result as reliable.",
          ),
          highest_value_gap: null,
          predicted_improvement: null,
          confidence: "low",
          uncertainty_reason: errorMessage,
          student_facing_summary:
            "Your answer is saved, but feedback is taking longer than expected.",
          action_hint: null,
          repair_hint: null,
          sanitization_version: "grading-sanitizer-v3",
          integrity_issues: [{
            code: "criteria_missing" as const,
            criterion_key: null,
          }],
          // The model never returned, so nothing was reconciled.
          normalizations: [],
        };
      } finally {
        if (usageRow) {
          await service.schema("app").rpc("complete_model_usage", {
            p_request_id: idempotencyKey,
            p_request_hash: requestHash,
            p_status: finalStatus === "graded" ? "completed" : "failed",
            p_actual_cost_usd: actualCost,
            p_input_tokens: inputTokens,
            p_output_tokens: outputTokens,
          });
        }
      }
    }
  }

  if (!finalPayload) {
    return respond({ error: "grading_failed" }, { status: 500 });
  }

  const { data: previousResult } = await service.schema("app")
    .from("grading_results")
    .select("points_earned, status")
    .eq("attempt_id", attempt.id)
    .neq("request_id", idempotencyKey)
    .order("created_at", { ascending: false })
    .limit(1)
    .maybeSingle();

  const actualPointGain = previousResult &&
      "points_earned" in previousResult &&
      previousResult.points_earned !== null &&
      finalPayload.points_earned !== null &&
      finalPayload.points_earned !== undefined
    ? Number(finalPayload.points_earned) - Number(previousResult.points_earned)
    : null;

  const predictedPointGain =
    finalPayload.predicted_improvement?.predicted_point_gain ?? null;
  const predictionOutcome =
    predictedPointGain !== null && actualPointGain !== null
      ? predictedPointGain === actualPointGain
        ? "matched"
        : predictedPointGain < actualPointGain
        ? "under_predicted"
        : "over_predicted"
      : null;

  const highestValueGap = finalPayload.highest_value_gap ?? pickHighestGap(
    finalPayload.criteria,
    promptBase.criteria,
  );
  const feedbackPreview = finalPayload.student_facing_summary;
  const actionHint = finalPayload.action_hint ??
    (statisticsCheck?.status === "flag" ? "show_scaffold" : null);
  const repairHint = resolveFormulaRepairHint(
    finalPayload.repair_hint ?? statisticsCheck?.repair_hint,
    highestValueGap,
  );
  const repairPlan = buildRepairPlan({
    lockedGrade: lockGradeDecision({
      gradeFingerprint:
        `${idempotencyKey}:${promptVersion}:${effectiveRubricVersionId}`,
      pointsEarned: finalPayload.points_earned,
      pointsAvailable: finalPayload.points_available,
      criteria: finalPayload.criteria,
    }),
    sourceCriteria: promptBase.criteria,
    deterministicCheck: statisticsCheck,
  });

  const updatePayload = {
    status: finalStatus,
    points_earned: finalPayload.points_earned,
    points_available: finalPayload.points_available,
    criterion_results: finalPayload.criteria,
    highest_value_gap: highestValueGap,
    predicted_label: finalPayload.predicted_improvement?.label ?? null,
    predicted_point_gain: predictedPointGain,
    actual_point_gain: actualPointGain,
    prediction_outcome: predictionOutcome,
    confidence: finalPayload.confidence,
    uncertainty_reason: finalPayload.uncertainty_reason,
    model_id: routedModelId,
    prompt_version: promptVersion,
    rubric_version_id: effectiveRubricVersionId,
    deterministic_verifier_version: deterministicVerifierVersion,
    boundary_contract_version: verificationProfile?.profile_version ?? null,
    feedback_preview: feedbackPreview,
    action_hint: actionHint,
    repair_hint: repairHint,
    input_tokens: inputTokens,
    output_tokens: outputTokens,
    estimated_cost_usd: routing.target === "llm_text"
      ? (statisticsDeterministicFallback ? 0 : actualCost || reservedCost)
      : 0,
    latency_ms: modelResponse?.elapsedMs ?? 0,
    raw_model_response: modelResponse?.raw ?? null,
    shadow_result: shadowResult,
  };

  // Fired before this update commits, so the "prior graded results" count
  // below can't see this request's own row (still status='processing').
  if (
    profile.role === "student" &&
    (finalStatus === "graded" || finalStatus === "uncertain")
  ) {
    const { data: priorAttempts } = await service.schema("app")
      .from("attempts")
      .select("id")
      .eq("user_id", user.id);
    const priorAttemptIds = (priorAttempts ?? []).map((row) => row.id);
    let isFirstGradedResponse = true;
    if (priorAttemptIds.length > 0) {
      const { count } = await service.schema("app")
        .from("grading_results")
        .select("id", { count: "exact", head: true })
        .in("attempt_id", priorAttemptIds)
        .in("status", ["graded", "uncertain"]);
      isFirstGradedResponse = (count ?? 0) === 0;
    }
    if (isFirstGradedResponse) {
      await recordGrowthEvent(service, {
        eventName: "first_response_graded",
        userId: user.id,
        source: "web",
        dedupeKey: `first_response_graded:${user.id}`,
      });
    }
  }

  const { data: storedGrade, error: gradeStoreError } = await writeGradeResult(service, idempotencyKey, requestHash, updatePayload);
  if (gradeStoreError || !storedGrade) {
    console.error("evaluate-attempt:grade_store_failed", { request_id: idempotencyKey, route: routing.target, code: gradeStoreError?.code ?? "missing_row" });
    const retryable = await checkpointGradeWrite(service, idempotencyKey, requestHash, operation, updatePayload);
    return respond({ error: GRADE_STORE_FAILURE, retryable, ...(!retryable ? { reconciliation_required: true } : {}) }, { status: 500 });
  }

  // Passive telemetry, best-effort: separate write so the main update above
  // keeps working against the pre-migration schema (see
  // 20260811TBD_grading_telemetry.sql).
  await Promise.all([
    persistGradingTelemetry(service, idempotencyKey, {
      normalized_response_sha256: normalizedResponseSha256,
      cached_tokens: cachedTokensTelemetry,
      stage_timings: stageTimer.finish(),
    }),
    persistAttemptCriterionResults(
      service,
      attempt.id as string,
      finalPayload.criteria,
      routedModelId,
    ),
  ]);

  // See the deterministic-path sibling of this call for why the error is now
  // captured and logged instead of swallowed (STUDENT_INTERACTION_DATA_SCHEMA_PLAN_2026_09_27.md
  // Phase 0 item 6).
  const { error: attemptUpdateError } = await service.schema("app")
    .from("attempts")
    .update({
      status: finalStatus === "graded" ? "graded" : "uncertain",
      graded_at: new Date().toISOString(),
      score_points: finalPayload.points_earned,
      score_possible: finalPayload.points_available,
      confidence_level: finalPayload.confidence,
      result_state: finalStatus,
      result_summary: finalPayload.student_facing_summary,
      assistance_state: derivedAssistanceState,
    })
    .eq("id", attempt.id);
  if (attemptUpdateError) {
    console.error("attempts_grading_truth_update_failed", {
      attempt_id: attempt.id,
      route: "model_graded",
      error: attemptUpdateError.message,
      code: (attemptUpdateError as { code?: string }).code,
    });
  }

  const runtimeContext = await persistGradingMemory({
    service,
    sessionId: attempt.learning_session_id as string | null,
    attemptId: attempt.id,
    attemptMode: attempt.attempt_mode as string,
    assistanceState: derivedAssistanceState as string,
    finalStatus,
    pointsEarned: finalPayload.points_earned,
    pointsAvailable: finalPayload.points_available,
    confidence: finalPayload.confidence,
    highestValueGap,
    criteria: finalPayload.criteria,
    summary: finalPayload.student_facing_summary,
    repairHint,
    feedbackPreview,
    examPackVersionId: attempt.exam_pack_version_id as string,
    gradingRoute: routing,
    verificationProfile,
    verificationProfileSummary,
    actionHint,
    deterministicCheck: statisticsCheck,
  });

  // Course Mode F2/F3: update cell mastery for a cell-tagged item (covers the
  // data_driven, LLM-text, and shadow paths). No-op for untagged items; routed
  // on item identity, never session presence. Best-effort -- never fails the
  // grade. content_uncertain (uncertain/shadow) records the attempt without
  // writing false proficiency (CM-D07 / INV-3).
  await persistCellState({
    service,
    userId: attempt.user_id as string,
    contentItemVersionId: contentVersion.id as string,
    attemptId: attempt.id as string,
    subjectId: examPack.subject_id as string,
    sessionId: attempt.learning_session_id as string | null,
    assistanceState: derivedAssistanceState,
    attemptMode: attempt.attempt_mode as string,
    preSubmitHintCount: attempt.pre_submit_hint_count as number | null,
    finalStatus,
    pointsEarned: finalPayload.points_earned,
    pointsAvailable: finalPayload.points_available,
    submittedAt: attempt.submitted_at as string | null,
  });

  return respond(
    buildEvaluateAttemptResponse({
      status: finalStatus,
      operation: operation as AllowedOperation,
      result: buildEvaluateAttemptResult({
        finalPayload,
        actualPointGain,
        predictionOutcome,
        routedModelId,
        promptVersion,
        rubricVersionId: effectiveRubricVersionId,
        gradingRoute: routing,
        verificationProfile,
        verificationProfileSummary,
        feedbackPreview,
        actionHint,
        repairHint,
        repairPlan,
        deterministicCheck: statisticsCheck,
        attemptId: attempt.id,
        responseVersionId: responseVersion.id,
        requestId: idempotencyKey,
        latencyMs: modelResponse?.elapsedMs ?? 0,
      }),
      runtimeContext,
    }),
    { status: finalStatus === "graded" ? 200 : 202 },
  );
}

if (import.meta.main) {
  Deno.serve((req) => handleEvaluateAttempt(req));
}
