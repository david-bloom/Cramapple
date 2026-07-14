import { createServiceClient } from "../_shared/supabase.ts";
import { jsonResponse, readJsonBody } from "../_shared/http.ts";
import { requireProfile } from "../_shared/auth.ts";

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

// ── Categorical scoring model (DECISION-0038) ─────────────────────────────────
// The suitability decision is categorical: approve | approve_with_edits |
// disapprove. The legacy numeric tutor_score (1 Yes | 2 Maybe | 3 No) is still
// accepted from older clients and mapped, and is dual-written so any legacy
// reader of tutor_score keeps working during the transition.

const SUITABILITY_DECISIONS = ["approve", "approve_with_edits", "disapprove"];
const SCORE_TO_DECISION: Record<number, string> = {
  1: "approve",
  2: "approve_with_edits",
  3: "disapprove",
};
const DECISION_TO_SCORE: Record<string, number> = {
  approve: 1,
  approve_with_edits: 2,
  disapprove: 3,
};

// Resolve a stored decision row to a categorical suitability decision, preferring
// the new tutor_decision column and falling back to the legacy numeric score.
function resolveDecision(row: Record<string, unknown>): string | null {
  const d = row.tutor_decision as string | null;
  if (d && SUITABILITY_DECISIONS.includes(d)) return d;
  const s = row.tutor_score as number | null;
  if (s != null && SCORE_TO_DECISION[s]) return SCORE_TO_DECISION[s];
  return null;
}

// Resolve the AP Reader disposition from either the categorical reader_decision,
// the legacy agree/disagree values, or the legacy numeric score.
function resolveReaderDisposition(
  readerDecision: string | null,
  readerScore: number | null,
): "approve" | "recycle" | "exclude" | null {
  if (readerDecision === "approve" || readerDecision === "agree") return "approve";
  if (readerDecision === "disapprove" || readerDecision === "disagree") {
    return "exclude";
  }
  if (readerDecision === "approve_with_edits") return "recycle";
  if (readerScore === 1) return "approve";
  if (readerScore === 2) return "recycle";
  if (readerScore === 3) return "exclude";
  return null;
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
// group is now complete and, if so, computes the disposition and creates
// downstream assignments. All operations use service_role so they are not
// subject to reviewer RLS policies.
//
// State machine (DECISION-0038):
//
// tutor_question, Approve + Approve                       → create reader_question assignment
// tutor_question, >=1 Approve-with-edits, no Disapprove   → flag modification_reserved
// tutor_question, any Disapprove                          → flag excluded
//
// reader_question, Approve            → MCQ: fan out tutor_answer ×4 options ×2 tutors
//                                       FRQ: flag question_review_approved
// reader_question, Approve with edits → flag modification_reserved
// reader_question, Disapprove         → flag excluded

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
      .select(
        "content_review_assignment_id, tutor_decision, tutor_score, difficulty_action, difficulty_label",
      )
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

    const decA = resolveDecision(latestDecisions[0]);
    const decB = resolveDecision(latestDecisions[1]);
    if (!decA || !decB) return;

    const anyDisapprove = decA === "disapprove" || decB === "disapprove";
    const bothApprove = decA === "approve" && decB === "approve";

    if (bothApprove) {
      // Approve + Approve → create AP Reader assignment.
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

      // Difficulty agree/propose: any proposal blocks confirmation and routes to
      // discussion. Fall back to legacy label mismatch when actions are absent.
      const actA = latestDecisions[0].difficulty_action as string | null;
      const actB = latestDecisions[1].difficulty_action as string | null;
      const anyPropose = actA === "propose" || actB === "propose";
      const labelA = latestDecisions[0].difficulty_label as string | null;
      const labelB = latestDecisions[1].difficulty_label as string | null;
      const legacyMismatch = !actA && !actB && labelA != null &&
        labelB != null && labelA !== labelB;
      if (anyPropose || legacyMismatch) {
        await service.schema("app").from("content_item_versions")
          .update({ review_status: "difficulty_discussion" })
          .eq("id", versionId);
      }
    } else if (anyDisapprove) {
      await service.schema("app").from("content_item_versions")
        .update({ review_status: "excluded" })
        .eq("id", versionId);
    } else {
      // At least one Approve-with-edits, no Disapprove → edit and recycle.
      await service.schema("app").from("content_item_versions")
        .update({ review_status: "modification_reserved" })
        .eq("id", versionId);
    }
  }

  if (reviewStage === "reader_question") {
    const readerScore = decision.tutor_score as number | null;
    const readerDecisionValue = decision.reader_decision as string | null;

    const disposition = resolveReaderDisposition(readerDecisionValue, readerScore);
    const isApprove = disposition === "approve";
    const isRecycle = disposition === "recycle";
    const isExclude = disposition === "exclude";

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

  const reviewStage = assignment.review_stage as string;

  const decisionPayload: Record<string, unknown> = { review_stage: reviewStage };

  // ── tutor_question ────────────────────────────────────────────────────────
  // Accept the categorical tutor_decision (canonical) and legacy numeric
  // tutor_score/score (mapped). Difficulty uses difficulty_action agree/propose,
  // with legacy label-only submissions still accepted.

  const legacyTutorScore = asInt(b.tutor_score ?? b.score);
  let tutorDecision = asString(b.tutor_decision);
  const difficultyAction = asString(b.difficulty_action);
  const difficultyLabel = asString(b.difficulty_label ?? b.difficulty);
  const diagnosticFlag = asBool(b.diagnostic_flag) ?? false;
  const concernCodes = asStringArray(b.concern_codes);
  const note = asString(b.note ?? b.rationale);
  const topicSelections =
    b.topic_selections &&
    typeof b.topic_selections === "object" &&
    !Array.isArray(b.topic_selections)
      ? (b.topic_selections as Record<string, unknown>)
      : null;

  // Numeric score written to the legacy column (dual-write) for tutor_question.
  let tutorScoreForInsert: number | null = null;

  const validDifficulty = [
    "Easy",
    "Moderately easy",
    "Medium",
    "Hard",
    "Very hard",
  ];

  if (reviewStage === "tutor_question") {
    // Resolve the suitability decision: prefer categorical, fall back to legacy.
    if (!tutorDecision && legacyTutorScore && SCORE_TO_DECISION[legacyTutorScore]) {
      tutorDecision = SCORE_TO_DECISION[legacyTutorScore];
    }
    if (!tutorDecision) {
      return respond(
        { error: "missing_required_fields", required: ["tutor_decision"] },
        { status: 400 },
      );
    }
    if (!SUITABILITY_DECISIONS.includes(tutorDecision)) {
      return respond({ error: "invalid_tutor_decision" }, { status: 400 });
    }
    tutorScoreForInsert = DECISION_TO_SCORE[tutorDecision];

    // Difficulty: new agree/propose contract, with legacy label-only fallback.
    if (difficultyAction) {
      if (!["agree", "propose"].includes(difficultyAction)) {
        return respond({ error: "invalid_difficulty_action" }, { status: 400 });
      }
      if (difficultyAction === "propose" && !difficultyLabel) {
        return respond(
          { error: "missing_required_fields", required: ["difficulty_label"] },
          { status: 400 },
        );
      }
    } else if (!difficultyLabel) {
      return respond(
        { error: "missing_required_fields", required: ["difficulty_action"] },
        { status: 400 },
      );
    }
    if (difficultyLabel && !validDifficulty.includes(difficultyLabel)) {
      return respond(
        { error: "invalid_difficulty_label", allowed: validDifficulty },
        { status: 400 },
      );
    }

    decisionPayload.tutor_decision = tutorDecision;
    decisionPayload.tutor_score = tutorScoreForInsert;
    decisionPayload.difficulty_action = difficultyAction;
    decisionPayload.difficulty_label = difficultyLabel;
    decisionPayload.diagnostic_flag = diagnosticFlag;
    decisionPayload.concern_codes = concernCodes;
    decisionPayload.note = note;
    decisionPayload.topic_selections = topicSelections;
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
  // Accept the categorical reader_decision (approve | approve_with_edits |
  // disapprove), the legacy agree/disagree values, and the prototype alias
  // `decision`.

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
    if (
      !["agree", "disagree", "approve", "approve_with_edits", "disapprove"]
        .includes(readerDecision)
    ) {
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
      tutor_decision: reviewStage === "tutor_question" ? tutorDecision : null,
      tutor_score: tutorScoreForInsert,
      difficulty_action: reviewStage === "tutor_question"
        ? difficultyAction
        : null,
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
      "content_review_decision_id, content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, supersedes_id, tutor_decision, tutor_score, difficulty_action, reader_decision, decision_hash, submitted_at, created_at",
    )
    .maybeSingle();

  if (decisionError || !insertedDecision) {
    return respond({ error: "decision_insert_failed" }, { status: 500 });
  }

  // Mark the assignment submitted.
  await service.schema("app")
    .from("content_review_assignments")
    .update({ status: "submitted" })
    .eq("content_review_assignment_id", assignmentId);

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
