import { createServiceClient } from "../_shared/supabase.ts";
import { jsonResponse, readJsonBody } from "../_shared/http.ts";
import { requireProfile } from "../_shared/auth.ts";
import {
  hasExactChoiceKeys,
  normalizeAnswerApprovals,
  requiresTutorNote,
  resolveTutorScore,
} from "./review-payload.ts";

// Expand/contract rollout switch for the prompt-visual judgment.
//
// FALSE (current): image_needed is accepted and persisted when sent, ignored
// when absent. This lets this function deploy BEFORE the reviewer frontend
// that sends the field — flipping it on first would 400 every tutor_question
// submission from the currently-deployed client, blocking ~150 reviews/day
// across 3-9 active reviewers.
//
// Flip to TRUE only after the reviewer frontend carrying the two radio groups
// is live and confirmed sending image_needed. Values that ARE sent are fully
// validated either way, so no bad data can land during the soft window.
const REQUIRE_IMAGE_NEEDED = false;

// Mirrors app.content_visual_requirements' check constraints.
// "no" is split into two reasons on purpose: items whose stem says "submit one
// photograph showing your constructed graph" need the student to BUILD the
// visual, and giving those a prompt image would hand over the answer.
const IMAGE_NEEDED_VALUES = new Set(["yes", "no_constructs", "no_not_needed"]);
const IMAGE_APPROVAL_VALUES = new Set([
  "approved",
  "approved_with_edits",
  "disapproved",
  "missing",
]);

function asString(value: unknown) {
  return typeof value === "string" && value.trim() ? value.trim() : null;
}

function asUuid(value: unknown) {
  return typeof value === "string" &&
      /^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$/
        .test(value)
    ? value
    : null;
}

function asStringArray(value: unknown) {
  if (!Array.isArray(value)) return [];
  return value.filter((entry) => typeof entry === "string")
    .map((entry) => entry.trim())
    .filter(Boolean);
}

function asInt(value: unknown) {
  const n = Number(value);
  return Number.isInteger(n) ? n : null;
}

function asBool(value: unknown) {
  if (typeof value === "boolean") return value;
  if (value === "true") return true;
  if (value === "false") return false;
  return null;
}

async function sha256Hex(value: string) {
  const digest = await crypto.subtle.digest(
    "SHA-256",
    new TextEncoder().encode(value),
  );
  return Array.from(new Uint8Array(digest))
    .map((byte) => byte.toString(16).padStart(2, "0"))
    .join("");
}

async function loadProfile(req: Request) {
  const profileResult = await requireProfile(req);
  if (!profileResult) return null;
  const role = profileResult.profile.role as string;
  if (role !== "admin" && role !== "tutor" && role !== "reader") {
    return null;
  }
  return profileResult;
}

// ── Workflow advancement ──────────────────────────────────────────────────────
//
// Called synchronously after a decision is inserted. Checks whether the blind
// group is now complete and, if so, computes the aggregate and creates
// downstream assignments. All operations use service_role so they are not
// subject to reviewer RLS policies.
//
// State machine (from the architecture plan):
//
// tutor_question, aggregate 2 (Yes+Yes)    → create reader_question assignment
// tutor_question, aggregate 3 (Yes+Maybe)  → flag modification_reserved
// tutor_question, aggregate 4-6            → flag excluded
//
// reader_question, score 1 (Approve)       → MCQ: fan out tutor_answer ×4 options ×2 tutors
//                                            FRQ: flag question_review_approved
// reader_question, score 2 (Edit+recycle)  → flag modification_reserved
// reader_question, score 3 (Exclude)       → flag excluded

async function advanceWorkflow(
  service: ReturnType<typeof createServiceClient>,
  assignment: Record<string, unknown>,
  decision: Record<string, unknown>,
) {
  const reviewStage = assignment.review_stage as string;
  const reviewKind = assignment.review_kind as string | null;
  const blindGroupId = assignment.blind_group_id as string | null;
  const versionId = assignment.content_item_version_id as string | null;

  if (!versionId) return;

  if (reviewStage === "tutor_question" && blindGroupId) {
    // Check whether both tutor assignments for this blind group are submitted.
    const { data: groupAssignments } = await service
      .schema("app")
      .from("content_review_assignments")
      .select("content_review_assignment_id, reviewer_id, status")
      .eq("blind_group_id", blindGroupId)
      .eq("review_stage", "tutor_question");

    const allSubmitted =
      groupAssignments?.length === 2 &&
      groupAssignments.every((a) => a.status === "submitted");

    if (!allSubmitted) return;

    // Fetch both decisions for this blind group.
    const groupIds = groupAssignments.map(
      (a) => a.content_review_assignment_id,
    );

    const { data: groupDecisions } = await service
      .schema("app")
      .from("content_review_decisions")
      .select("content_review_assignment_id, tutor_score, difficulty_label")
      .in("content_review_assignment_id", groupIds)
      .order("submitted_at", { ascending: false });

    // Use only the most recent decision per assignment (handles supersedes).
    const seenAssignments = new Set<string>();
    const latestDecisions: Array<Record<string, unknown>> = [];
    for (const d of groupDecisions ?? []) {
      if (!seenAssignments.has(d.content_review_assignment_id as string)) {
        seenAssignments.add(d.content_review_assignment_id as string);
        latestDecisions.push(d as Record<string, unknown>);
      }
    }

    if (latestDecisions.length !== 2) return;

    const scoreA = latestDecisions[0].tutor_score as number;
    const scoreB = latestDecisions[1].tutor_score as number;
    const aggregate = scoreA + scoreB;

    if (aggregate === 2) {
      // Yes + Yes → create AP Reader assignment.
      // Find the original creator of the assignments (admin) to use as created_by.
      const { data: firstAssignment } = await service
        .schema("app")
        .from("content_review_assignments")
        .select("created_by")
        .eq("content_review_assignment_id", groupIds[0])
        .maybeSingle();

      // Find a reader profile to assign. For the pilot, pick the first
      // available reader. Production will use an explicit reader assignment.
      const { data: readers } = await service
        .schema("app")
        .from("profiles")
        .select("user_id")
        .eq("role", "reader")
        .limit(1);

      const readerId = readers?.[0]?.user_id;
      if (readerId) {
        await service.schema("app").from("content_review_assignments").insert({
          content_item_version_id: versionId,
          reviewer_id: readerId,
          review_stage: "reader_question",
          review_kind: reviewKind,
          status: "pending",
          created_by: firstAssignment?.created_by ?? null,
        });
      }

      await service.schema("app").from("content_item_versions")
        .update({ review_status: "ap_reader_pending" })
        .eq("id", versionId);

      // Check difficulty label agreement; flag discussion if they differ.
      const labelA = latestDecisions[0].difficulty_label as string | null;
      const labelB = latestDecisions[1].difficulty_label as string | null;
      if (labelA && labelB && labelA !== labelB) {
        await service.schema("app").from("content_item_versions")
          .update({ review_status: "difficulty_discussion" })
          .eq("id", versionId);
      }
    } else if (aggregate === 3) {
      await service.schema("app").from("content_item_versions")
        .update({ review_status: "modification_reserved" })
        .eq("id", versionId);
    } else {
      // aggregate 4-6
      await service.schema("app").from("content_item_versions")
        .update({ review_status: "excluded" })
        .eq("id", versionId);
    }
  }

  if (reviewStage === "reader_question") {
    const readerScore = decision.tutor_score as number | null;
    const readerDecisionValue = decision.reader_decision as string | null;

    // reader_decision: "agree" maps to score 1 (approve),
    // "disagree" maps to score 3 (exclude) per current design.
    // Full AP Reader 1/2/3 scoring is not yet wired in the prototype.
    const isApprove = readerDecisionValue === "agree" || readerScore === 1;
    const isExclude = readerDecisionValue === "disagree" || readerScore === 3;
    const isRecycle = readerScore === 2;

    if (isApprove) {
      if (reviewKind === "mcq") {
        // Fan out tutor_answer assignments: 4 answer options × 2 original tutors.
        const { data: originalTutorAssignments } = await service
          .schema("app")
          .from("content_review_assignments")
          .select("reviewer_id, blind_group_id, created_by")
          .eq("content_item_version_id", versionId)
          .eq("review_stage", "tutor_question");

        const tutorIds = [
          ...new Set(
            (originalTutorAssignments ?? []).map((a) => a.reviewer_id),
          ),
        ];
        const answerBlindGroupId = crypto.randomUUID();
        const createdBy =
          originalTutorAssignments?.[0]?.created_by ?? null;

        // Fetch answer option keys for this version.
        const { data: choices } = await service
          .schema("app")
          .from("mcq_choices")
          .select("choice_key")
          .eq("content_item_version_id", versionId)
          .order("choice_key", { ascending: true });

        const choiceKeys = (choices ?? []).map((c) => c.choice_key as string);

        const answerAssignments = tutorIds.flatMap((tutorId) =>
          choiceKeys.map((choiceKey) => ({
            content_item_version_id: versionId,
            reviewer_id: tutorId,
            review_stage: "tutor_answer",
            review_kind: "mcq",
            blind_group_id: answerBlindGroupId,
            status: "pending",
            created_by: createdBy,
          }))
        );

        if (answerAssignments.length > 0) {
          await service.schema("app")
            .from("content_review_assignments")
            .upsert(answerAssignments, {
              onConflict: "content_item_version_id,reviewer_id,review_stage",
              ignoreDuplicates: true,
            });
        }

        await service.schema("app").from("content_item_versions")
          .update({ review_status: "answer_tutor_review_pending" })
          .eq("id", versionId);
      } else {
        // FRQ: question review approved.
        await service.schema("app").from("content_item_versions")
          .update({ review_status: "question_review_approved" })
          .eq("id", versionId);
      }
    } else if (isRecycle) {
      await service.schema("app").from("content_item_versions")
        .update({ review_status: "modification_reserved" })
        .eq("id", versionId);
    } else if (isExclude) {
      await service.schema("app").from("content_item_versions")
        .update({ review_status: "excluded" })
        .eq("id", versionId);
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────

Deno.serve(async (req) => {
  const respond = (body: unknown, init: ResponseInit = {}) =>
    jsonResponse(body, init, req);

  if (req.method === "OPTIONS") {
    return respond({ ok: true }, { status: 200 });
  }

  if (req.method !== "POST") {
    return respond({ error: "method_not_allowed" }, { status: 405 });
  }

  const body = await readJsonBody(req);
  if (!body || typeof body !== "object" || Array.isArray(body)) {
    return respond({ error: "invalid_json" }, { status: 400 });
  }

  const profileResult = await loadProfile(req);
  if (!profileResult) {
    return respond({ error: "forbidden" }, { status: 403 });
  }

  const b = body as Record<string, unknown>;

  const assignmentId = asUuid(
    b.content_review_assignment_id ?? b.assignment_id ?? b.assignmentId,
  );

  if (!assignmentId) {
    return respond(
      {
        error: "missing_required_fields",
        required: ["content_review_assignment_id"],
      },
      { status: 400 },
    );
  }

  const service = createServiceClient();

  const { data: assignment, error: assignmentError } = await service
    .schema("app")
    .from("content_review_assignments")
    .select(
      "content_review_assignment_id, ingest_row_id, content_item_version_id, reviewer_id, review_stage, review_kind, blind_group_id, status",
    )
    .eq("content_review_assignment_id", assignmentId)
    .maybeSingle();

  if (assignmentError || !assignment) {
    return respond({ error: "assignment_not_found" }, { status: 404 });
  }

  const role = profileResult.profile.role as string;
  if (role !== "admin" && assignment.reviewer_id !== profileResult.user.id) {
    return respond({ error: "forbidden" }, { status: 403 });
  }

  if (!["pending", "in_progress"].includes(assignment.status as string)) {
    return respond({ error: "assignment_locked" }, { status: 409 });
  }

  const reviewStage = assignment.review_stage as string;

  const decisionPayload: Record<string, unknown> = { review_stage: reviewStage };

  // ── tutor_question ────────────────────────────────────────────────────────
  // Accept both canonical names and prototype aliases.

  const tutorScore = resolveTutorScore(
    b.tutor_score ?? b.score,
    b.tutor_decision,
  );
  const difficultyLabel = asString(b.difficulty_label ?? b.difficulty);
  const diagnosticFlag = asBool(b.diagnostic_flag) ?? false;
  const concernCodes = asStringArray(b.concern_codes);
  const note = asString(b.note ?? b.rationale);
  const answerApprovals = normalizeAnswerApprovals(b.answer_approvals);
  const imageNeeded = asString(b.image_needed);
  const imageApproval = asString(b.image_approval);
  const topicSelections =
    b.topic_selections &&
    typeof b.topic_selections === "object" &&
    !Array.isArray(b.topic_selections)
      ? (b.topic_selections as Record<string, unknown>)
      : null;

  if (reviewStage === "tutor_question") {
    if (!tutorScore) {
      return respond(
        { error: "missing_required_fields", required: ["tutor_score"] },
        { status: 400 },
      );
    }
    if (![1, 2, 3].includes(tutorScore)) {
      return respond({ error: "invalid_tutor_score" }, { status: 400 });
    }
    if (!difficultyLabel) {
      return respond(
        { error: "missing_required_fields", required: ["difficulty_label"] },
        { status: 400 },
      );
    }
    const validDifficulty = [
      "Easy",
      "Moderately easy",
      "Medium",
      "Hard",
      "Very hard",
    ];
    if (!validDifficulty.includes(difficultyLabel)) {
      return respond(
        { error: "invalid_difficulty_label", allowed: validDifficulty },
        { status: 400 },
      );
    }
    // Absent is tolerated only while REQUIRE_IMAGE_NEEDED is false. A value
    // that IS present is always validated, so the soft window cannot admit a
    // malformed judgment.
    if (imageNeeded && !IMAGE_NEEDED_VALUES.has(imageNeeded)) {
      return respond(
        { error: "invalid_image_needed", allowed: [...IMAGE_NEEDED_VALUES] },
        { status: 400 },
      );
    }
    if (!imageNeeded && REQUIRE_IMAGE_NEEDED) {
      return respond(
        {
          error: "missing_required_fields",
          required: ["image_needed"],
          allowed: [...IMAGE_NEEDED_VALUES],
        },
        { status: 400 },
      );
    }
    // Approval is required exactly when a visual is required. Rejecting the
    // mismatched pair here keeps the app.content_visual_requirements
    // approval-iff-needed constraint from surfacing as an opaque 500.
    if (imageNeeded === "yes") {
      // Unconditional: if a reviewer says a visual is required, the approval
      // must come with it regardless of the rollout switch.
      if (!imageApproval || !IMAGE_APPROVAL_VALUES.has(imageApproval)) {
        return respond(
          {
            error: "missing_required_fields",
            required: ["image_approval"],
            allowed: [...IMAGE_APPROVAL_VALUES],
          },
          { status: 400 },
        );
      }
    } else if (imageApproval) {
      return respond(
        { error: "image_approval_not_applicable" },
        { status: 400 },
      );
    }

    if (assignment.review_kind === "mcq" && !answerApprovals) {
      return respond(
        { error: "invalid_answer_approvals" },
        { status: 400 },
      );
    }
    if (
      assignment.review_kind === "mcq" &&
      assignment.content_item_version_id &&
      answerApprovals
    ) {
      const { data: choiceRows, error: choiceError } = await service
        .schema("app")
        .from("mcq_choices")
        .select("choice_key")
        .eq("content_item_version_id", assignment.content_item_version_id);
      if (choiceError) {
        return respond({ error: "choice_lookup_failed" }, { status: 500 });
      }
      const expectedChoiceKeys = (choiceRows ?? [])
        .map((row) => asString(row.choice_key))
        .filter((key): key is string => Boolean(key));
      if (!hasExactChoiceKeys(answerApprovals, expectedChoiceKeys)) {
        return respond(
          { error: "answer_approvals_do_not_match_choices" },
          { status: 400 },
        );
      }
    }
    if (requiresTutorNote(tutorScore, answerApprovals) && !note) {
      return respond(
        { error: "note_required_for_revision_or_rejection" },
        { status: 400 },
      );
    }
    decisionPayload.tutor_score = tutorScore;
    decisionPayload.difficulty_label = difficultyLabel;
    decisionPayload.diagnostic_flag = diagnosticFlag;
    decisionPayload.concern_codes = concernCodes;
    decisionPayload.image_needed = imageNeeded ?? null;
    decisionPayload.image_approval = imageNeeded === "yes" ? imageApproval : null;
    decisionPayload.note = note;
    decisionPayload.topic_selections = topicSelections;
    if (assignment.review_kind === "mcq") {
      decisionPayload.answer_approvals = answerApprovals;
    }
  }

  // ── tutor_answer ──────────────────────────────────────────────────────────

  const answerKey = asString(b.answer_key);
  const answerApproval = asString(b.answer_approval);

  if (reviewStage === "tutor_answer") {
    if (!answerApproval) {
      return respond(
        { error: "missing_required_fields", required: ["answer_approval"] },
        { status: 400 },
      );
    }
    if (!["approved", "rejected"].includes(answerApproval)) {
      return respond({ error: "invalid_answer_approval" }, { status: 400 });
    }
    decisionPayload.answer_key = answerKey;
    decisionPayload.answer_approval = answerApproval;
    decisionPayload.note = note;
  }

  // ── tutor_frq_canonical ───────────────────────────────────────────────────
  // Excluded from the pilot batch (canonical answers are NULL), but the
  // endpoint accepts the stage so it does not silently fail if called.

  const canonicalDecision = asString(b.canonical_decision);
  let canonicalAnswerSnapshot: string | null = null;

  if (reviewStage === "tutor_frq_canonical") {
    if (!canonicalDecision) {
      return respond(
        { error: "missing_required_fields", required: ["canonical_decision"] },
        { status: 400 },
      );
    }
    if (!["approved", "rejected", "edited"].includes(canonicalDecision)) {
      return respond(
        { error: "invalid_canonical_decision" },
        { status: 400 },
      );
    }

    if (assignment.ingest_row_id) {
      const { data: ingestRow } = await service.schema("app")
        .from("content_ingest_rows")
        .select("canonical_answer")
        .eq("ingest_row_id", assignment.ingest_row_id)
        .maybeSingle();
      canonicalAnswerSnapshot = asString(ingestRow?.canonical_answer);
    } else if (assignment.content_item_version_id) {
      const { data: version } = await service.schema("app")
        .from("content_item_versions")
        .select("canonical_answer_1")
        .eq("id", assignment.content_item_version_id)
        .maybeSingle();
      canonicalAnswerSnapshot = asString(
        (version as Record<string, unknown> | null)?.canonical_answer_1,
      );
    }

    decisionPayload.canonical_decision = canonicalDecision;
    decisionPayload.canonical_answer_snapshot = canonicalAnswerSnapshot;
    decisionPayload.note = note;
  }

  // ── reader_question ───────────────────────────────────────────────────────
  // Accept both reader_decision (canonical) and decision (prototype alias).

  const readerDecision = asString(
    b.reader_decision ??
      (reviewStage === "reader_question" ? b.decision : null),
  );

  if (reviewStage === "reader_question") {
    if (!readerDecision) {
      return respond(
        { error: "missing_required_fields", required: ["reader_decision"] },
        { status: 400 },
      );
    }
    if (!["agree", "disagree"].includes(readerDecision)) {
      return respond({ error: "invalid_reader_decision" }, { status: 400 });
    }
    decisionPayload.reader_decision = readerDecision;
    decisionPayload.note = note;
  }

  if (
    !["tutor_question", "tutor_answer", "tutor_frq_canonical", "reader_question"]
      .includes(reviewStage)
  ) {
    return respond(
      { error: "unsupported_review_stage", stage: reviewStage },
      { status: 400 },
    );
  }

  // ── Insert the decision ───────────────────────────────────────────────────

  const decisionPayloadJson = JSON.stringify(decisionPayload);
  const decisionHash = await sha256Hex(decisionPayloadJson);
  const supersedes = asUuid(b.supersedes_id);

  const { data: insertedDecision, error: decisionError } = await service
    .schema("app")
    .from("content_review_decisions")
    .insert({
      content_review_assignment_id: assignmentId,
      content_item_version_id: assignment.content_item_version_id ?? null,
      reviewer_id: profileResult.user.id,
      supersedes_id: supersedes,
      review_stage: reviewStage,
      tutor_score: tutorScore,
      difficulty_label: difficultyLabel,
      diagnostic_flag: diagnosticFlag,
      concern_codes: concernCodes,
      note,
      topic_selections: topicSelections,
      answer_key: answerKey,
      answer_approval: answerApproval,
      canonical_decision: canonicalDecision,
      canonical_answer_snapshot: canonicalAnswerSnapshot,
      reader_decision: readerDecision,
      decision_payload: decisionPayload,
      decision_hash: decisionHash,
      created_by: profileResult.user.id,
    })
    .select(
      "content_review_decision_id, content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, supersedes_id, decision_hash, submitted_at, created_at",
    )
    .maybeSingle();

  if (decisionError || !insertedDecision) {
    if (
      decisionError?.message?.includes("review_submission:assignment_locked")
    ) {
      return respond({ error: "assignment_locked" }, { status: 409 });
    }
    return respond({ error: "decision_insert_failed" }, { status: 500 });
  }

  // The database trigger atomically marked the assignment submitted in the
  // same transaction as the immutable decision insert.

  // Project the prompt-visual judgment to current state. The decision row above
  // is the immutable record; this table is what the student serving path reads,
  // so it must reflect the newest decision for this version. Non-fatal: the
  // decision is already durably recorded, and a failure here re-resolves on the
  // next review of the same version.
  if (
    reviewStage === "tutor_question" &&
    assignment.content_item_version_id &&
    imageNeeded
  ) {
    const { error: visualError } = await service
      .schema("app")
      .from("content_visual_requirements")
      .upsert({
        content_item_version_id: assignment.content_item_version_id,
        image_needed: imageNeeded,
        image_approval: imageNeeded === "yes" ? imageApproval : null,
        decided_by: profileResult.user.id,
        decided_at: new Date().toISOString(),
      }, { onConflict: "content_item_version_id" });

    if (visualError) {
      console.error("review-decision:content_visual_requirements", visualError);
    }
  }

  // Advance the workflow server-side. Errors here are non-fatal for the
  // reviewer — the decision is already immutably recorded.
  try {
    await advanceWorkflow(
      service,
      assignment as Record<string, unknown>,
      insertedDecision as Record<string, unknown>,
    );
  } catch (_err) {
    // Log but don't surface to the reviewer.
  }

  return respond(
    {
      status: "ok",
      function: "review-decision",
      assignment,
      decision: insertedDecision,
    },
    { status: 200 },
  );
});
