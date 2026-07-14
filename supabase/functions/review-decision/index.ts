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

type AnswerApproval = { choice_key: string; approved: boolean };

function asAnswerApprovals(value: unknown): AnswerApproval[] | null {
  if (!Array.isArray(value)) return null;
  const out: AnswerApproval[] = [];
  for (const entry of value) {
    if (
      !entry || typeof entry !== "object" ||
      typeof (entry as Record<string, unknown>).choice_key !== "string" ||
      typeof (entry as Record<string, unknown>).approved !== "boolean"
    ) {
      return null;
    }
    out.push({
      choice_key: (entry as Record<string, unknown>).choice_key as string,
      approved: (entry as Record<string, unknown>).approved as boolean,
    });
  }
  return out;
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
      // MCQ answer choices are now approved/rejected by both tutors alongside
      // the question itself (tutor_question.answer_approvals), so there is no
      // separate answer-review fan-out stage to spawn here — the reader's
      // approval finalizes the item for both MCQ and FRQ alike. (Legacy
      // tutor_answer assignments created before this change still function;
      // this code simply stops creating new ones.)
      await service.schema("app").from("content_item_versions")
        .update({ review_status: "question_review_approved" })
        .eq("id", versionId);
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
  // Accept both canonical names and prototype aliases.

  const tutorScore = asInt(b.tutor_score ?? b.score);
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

  let answerApprovals: AnswerApproval[] | null = null;

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

    // MCQ items require the tutor to approve/reject each answer choice
    // alongside the question itself, in this same submission.
    if (assignment.review_kind === "mcq") {
      const { data: choices, error: choicesError } = await service
        .schema("app")
        .from("mcq_choices")
        .select("choice_key")
        .eq("content_item_version_id", assignment.content_item_version_id);

      if (choicesError) {
        return respond({ error: "choices_lookup_failed" }, { status: 500 });
      }

      const expectedKeys = new Set(
        (choices ?? []).map((c) => c.choice_key as string),
      );

      const parsedAnswerApprovals = asAnswerApprovals(b.answer_approvals);
      if (!parsedAnswerApprovals) {
        return respond(
          {
            error: "missing_required_fields",
            required: ["answer_approvals"],
            detail:
              "answer_approvals must be an array of { choice_key, approved } covering every answer choice",
          },
          { status: 400 },
        );
      }

      const submittedKeys = new Set(
        parsedAnswerApprovals.map((a) => a.choice_key),
      );
      const missing = [...expectedKeys].filter((k) => !submittedKeys.has(k));
      const unknown = [...submittedKeys].filter((k) => !expectedKeys.has(k));
      if (missing.length > 0 || unknown.length > 0) {
        return respond(
          {
            error: "invalid_answer_approvals",
            detail: { missing, unknown },
          },
          { status: 400 },
        );
      }

      answerApprovals = parsedAnswerApprovals;
    }

    // A note explaining the reasoning is required whenever any part of the
    // item isn't fully approved — the question itself (tutor_score !== 1) or
    // any individual answer choice.
    const anyAnswerRejected = (answerApprovals ?? []).some((a) => !a.approved);
    if ((tutorScore !== 1 || anyAnswerRejected) && !note) {
      return respond(
        {
          error: "note_required",
          detail:
            "A note explaining the reasoning is required when the question or any answer choice is not approved",
        },
        { status: 400 },
      );
    }

    decisionPayload.tutor_score = tutorScore;
    decisionPayload.difficulty_label = difficultyLabel;
    decisionPayload.diagnostic_flag = diagnosticFlag;
    decisionPayload.concern_codes = concernCodes;
    decisionPayload.note = note;
    decisionPayload.topic_selections = topicSelections;
    decisionPayload.answer_approvals = answerApprovals;
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
    if (answerApproval === "rejected" && !note) {
      return respond(
        {
          error: "note_required",
          detail: "A note explaining the reasoning is required when rejecting an answer",
        },
        { status: 400 },
      );
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
      answer_approvals: answerApprovals,
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
