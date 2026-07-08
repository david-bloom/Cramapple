import { createServiceClient } from "../_shared/supabase.ts";
import { jsonResponse, readJsonBody } from "../_shared/http.ts";
import { requireAuthedUser } from "../_shared/auth.ts";

function requireEnv(name: string) {
  const value = Deno.env.get(name);
  if (!value) {
    throw new Error(`Missing required environment variable: ${name}`);
  }
  return value;
}

function asString(value: unknown) {
  return typeof value === "string" ? value : null;
}

function asUuid(value: unknown) {
  return typeof value === "string" && /^[0-9a-fA-F-]{36}$/.test(value)
    ? value
    : null;
}

function parseJsonSafe(value: string | null | undefined) {
  if (!value) return null;
  try {
    return JSON.parse(value);
  } catch {
    return null;
  }
}

function extractOutputText(raw: Record<string, unknown>) {
  const direct = raw.output_text;
  if (typeof direct === "string" && direct.length > 0) {
    return direct;
  }

  const output = raw.output;
  if (Array.isArray(output)) {
    for (const item of output) {
      if (!item || typeof item !== "object") continue;
      const content = (item as Record<string, unknown>).content;
      if (!Array.isArray(content)) continue;
      for (const piece of content) {
        if (!piece || typeof piece !== "object") continue;
        const text = (piece as Record<string, unknown>).text;
        if (typeof text === "string" && text.length > 0) {
          return text;
        }
      }
    }
  }

  return null;
}

function normalizeStatus(status: unknown) {
  return status === "earned" || status === "not_earned" ||
      status === "unable_to_determine"
    ? status
    : "unable_to_determine";
}

type CriterionResult = {
  criterion_key: string;
  label: string;
  status: "earned" | "not_earned" | "unable_to_determine";
  evidence_quote: string;
  explanation: string;
  minimum_fix: string;
  points_awarded: number;
  guardrail_notes: string[];
};

function pointsForStatus(
  status: CriterionResult["status"],
  pointsAwarded: number,
) {
  if (status !== "earned") return 0;
  return Math.max(0, pointsAwarded);
}

function enforceCriterionGuardrails(
  criterion: Omit<CriterionResult, "guardrail_notes">,
) {
  const guardrailNotes: string[] = [];
  let status = criterion.status;
  let pointsAwarded = Math.max(0, Math.trunc(criterion.points_awarded));
  const evidenceQuote = criterion.evidence_quote.trim();

  if (status === "earned" && evidenceQuote.length === 0) {
    status = "unable_to_determine";
    pointsAwarded = 0;
    guardrailNotes.push("earned_status_removed_because_evidence_quote_empty");
  }

  if (status !== "earned" && pointsAwarded > 0) {
    pointsAwarded = 0;
    guardrailNotes.push("points_removed_because_status_not_earned");
  }

  return {
    ...criterion,
    status,
    evidence_quote: evidenceQuote,
    points_awarded: pointsForStatus(status, pointsAwarded),
    guardrail_notes: guardrailNotes,
  };
}

function summarizeGuardrailNotes(criteria: CriterionResult[]) {
  return criteria.flatMap((criterion) =>
    criterion.guardrail_notes.map((note) => ({
      criterion_key: criterion.criterion_key,
      note,
    }))
  );
}

const OPENAI_API_KEY = requireEnv("OPENAI_API_KEY");
const OPENAI_MODEL = Deno.env.get("OPENAI_MODEL") ?? "gpt-4.1-mini";
const OPENAI_STRICT_MODEL = Deno.env.get("OPENAI_STRICT_MODEL") ?? "gpt-5.5";
const OPENAI_MAX_OUTPUT_TOKENS = Number(
  Deno.env.get("OPENAI_MAX_OUTPUT_TOKENS") ?? "1200",
);
const OPENAI_FAST_MAX_OUTPUT_TOKENS = (() => {
  const raw = Deno.env.get("OPENAI_FAST_MAX_OUTPUT_TOKENS");
  if (!raw) return 320;
  const parsed = Number(raw);
  if (!Number.isInteger(parsed) || parsed <= 0) {
    throw new Error("Invalid environment variable: OPENAI_FAST_MAX_OUTPUT_TOKENS");
  }
  return parsed;
})();

async function callOpenAIGrade(input: {
  model: string;
  systemPrompt: string;
  userPrompt: string;
  idempotencyKey: string;
  userId: string;
  reasoningEffort?: "low" | "medium" | "high";
  maxOutputTokens: number;
}) {
  const response = await fetch("https://api.openai.com/v1/responses", {
    method: "POST",
    headers: {
      Authorization: `Bearer ${OPENAI_API_KEY}`,
      "Content-Type": "application/json",
      "Idempotency-Key": input.idempotencyKey,
    },
    body: JSON.stringify({
      model: input.model,
      input: [
        {
          role: "system",
          content: [{ type: "input_text", text: input.systemPrompt }],
        },
        {
          role: "user",
          content: [{ type: "input_text", text: input.userPrompt }],
        },
      ],
      store: false,
      ...(input.reasoningEffort
        ? { reasoning: { effort: input.reasoningEffort } }
        : {}),
      max_output_tokens: input.maxOutputTokens,
      text: {
        format: {
          type: "json_schema",
          name: "grade_frq_result",
          strict: true,
          schema: {
            type: "object",
            additionalProperties: false,
            properties: {
              status: {
                type: "string",
                enum: ["graded", "uncertain", "failed"],
              },
              points_earned: { type: "integer" },
              points_available: { type: "integer" },
              point_summary: { type: "string" },
              criteria: {
                type: "array",
                items: {
                  type: "object",
                  additionalProperties: false,
                  properties: {
                    criterion_key: { type: "string" },
                    label: { type: "string" },
                    status: {
                      type: "string",
                      enum: [
                        "earned",
                        "not_earned",
                        "unable_to_determine",
                      ],
                    },
                    evidence_quote: { type: "string" },
                    explanation: { type: "string" },
                    minimum_fix: { type: "string" },
                    points_awarded: { type: "integer" },
                  },
                  required: [
                    "criterion_key",
                    "label",
                    "status",
                    "evidence_quote",
                    "explanation",
                    "minimum_fix",
                    "points_awarded",
                  ],
                },
              },
              missing_concept: { type: "string" },
              next_fix: { type: "string" },
              teaching_note: { type: "string" },
              confidence: {
                type: "string",
                enum: ["high", "qualified", "low"],
              },
              uncertainty_reason: { type: ["string", "null"] },
            },
            required: [
              "status",
              "points_earned",
              "points_available",
              "point_summary",
              "criteria",
              "missing_concept",
              "next_fix",
              "teaching_note",
              "confidence",
              "uncertainty_reason",
            ],
          },
        },
      },
      user: input.userId.slice(0, 64),
    }),
  });

  const raw = await response.json().catch(() => null);
  if (!response.ok) {
    const message = raw?.error?.message ?? `openai_http_${response.status}`;
    throw new Error(message);
  }

  const outputText = extractOutputText(raw ?? {});
  if (!outputText) {
    throw new Error("openai_missing_output_text");
  }

  return {
    raw,
    parsed: JSON.parse(outputText),
  };
}

Deno.serve(async (req) => {
  const respond = (body: unknown, init: ResponseInit = {}) =>
    jsonResponse(body, init, req);

  if (req.method === "OPTIONS") {
    return respond({ ok: true }, { status: 200 });
  }

  if (req.method !== "POST") {
    return respond({ error: "method_not_allowed" }, { status: 405 });
  }

  const user = await requireAuthedUser(req);
  if (!user) {
    return respond({ error: "unauthorized" }, { status: 401 });
  }

  const body = await readJsonBody(req);
  if (!body || typeof body !== "object" || Array.isArray(body)) {
    return respond({ error: "invalid_json" }, { status: 400 });
  }

  const request = body as Record<string, unknown>;
  const attemptId = asUuid(request.attempt_id ?? request.attemptId);
  const questionId = asUuid(request.question_id ?? request.questionId);
  const sessionId = asUuid(request.session_id ?? request.sessionId);
  const responseText =
    asString(request.response_text ?? request.responseText) ??
      "";
  const assistanceLevel = asString(
    request.assistance_level ?? request.assistanceLevel,
  ) ?? "cold";

  if (!attemptId || !questionId) {
    return respond(
      {
        error: "missing_required_fields",
        required: ["attempt_id", "question_id"],
      },
      { status: 400 },
    );
  }

  const service = createServiceClient();

  const { data: attempt, error: attemptError } = await service
    .schema("public")
    .from("student_attempts")
    .select("*")
    .eq("id", attemptId)
    .maybeSingle();

  if (attemptError || !attempt) {
    return respond({ error: "attempt_not_found" }, { status: 404 });
  }

  if (attempt.student_id !== user.id) {
    return respond({ error: "forbidden" }, { status: 403 });
  }

  if (attempt.question_id !== questionId) {
    return respond({ error: "attempt_question_mismatch" }, { status: 409 });
  }

  if (sessionId && attempt.session_id && attempt.session_id !== sessionId) {
    return respond({ error: "attempt_session_mismatch" }, { status: 409 });
  }

  const { data: question, error: questionError } = await service
    .schema("public")
    .from("questions")
    .select("*")
    .eq("id", questionId)
    .maybeSingle();

  if (questionError || !question) {
    return respond({ error: "question_not_found" }, { status: 404 });
  }

  if (question.status !== "approved") {
    return respond({ error: "question_not_approved" }, { status: 409 });
  }

  const rubric = parseJsonSafe(
    typeof question.rubric === "string"
      ? question.rubric
      : JSON.stringify(question.rubric ?? null),
  ) ?? {};
  const teachingPackage = question.teaching_package &&
      typeof question.teaching_package === "object" &&
      !Array.isArray(question.teaching_package)
    ? question.teaching_package as Record<string, unknown>
    : {};
  const frqSubtype = asString(question.frq_subtype) ??
    asString(teachingPackage.frq_subtype) ?? null;
  const questionDifficulty = asString(question.difficulty) ?? "standard";
  const isLongOrInvestigative = question.type === "long_frq" ||
    frqSubtype === "investigative_task" ||
    questionDifficulty === "challenging";
  const primaryModel = isLongOrInvestigative ? OPENAI_STRICT_MODEL : OPENAI_MODEL;
  const primaryReasoning = isLongOrInvestigative ? "medium" : undefined;
  const primaryMaxOutputTokens = isLongOrInvestigative
    ? OPENAI_MAX_OUTPUT_TOKENS
    : OPENAI_FAST_MAX_OUTPUT_TOKENS;

  const systemPrompt = [
    "You are Cramapple's criterion-based AP grader.",
    "Score only the rubric and do not invent evidence.",
    "Keep each string short and return only JSON that matches the schema.",
    "If evidence is weak or ambiguous, lower confidence rather than guessing.",
    "Do not invent evidence.",
    "When evidence is absent, use empty evidence_quote if there is truly no evidence.",
    "When evidence is present but ambiguous, use unable_to_determine and quote the observed text.",
  ].join(" ");

  const userPrompt = JSON.stringify(
    {
      question_type: question.type,
      frq_subtype: frqSubtype,
      difficulty: questionDifficulty,
      stem: question.stem,
      stimulus_url: question.stimulus_url ?? null,
      rubric,
      student_response_text: responseText,
      assistance_level: assistanceLevel,
    },
    null,
    0,
  );

  let graded: { raw: Record<string, unknown>; parsed: Record<string, unknown> };
  try {
    graded = await callOpenAIGrade({
      model: primaryModel,
      systemPrompt,
      userPrompt,
      idempotencyKey: attemptId,
      userId: user.id,
      reasoningEffort: primaryReasoning,
      maxOutputTokens: primaryMaxOutputTokens,
    });
  } catch (error) {
    const fallback = {
      status: "uncertain",
      points_earned: 0,
      points_available: Number(question.points_available ?? 1) || 1,
      point_summary:
        "Your answer is saved, but grading could not be completed confidently.",
      criteria: [],
      missing_concept: "The grader could not determine the missing concept.",
      next_fix: "Try again with the missing concept stated directly.",
      teaching_note:
        "This result should be reviewed if it appears unexpectedly.",
      confidence: "low",
      uncertainty_reason: error instanceof Error
        ? error.message
        : "grading_failed",
    };

    await service.schema("public").from("student_attempts").update({
      response_text: responseText || attempt.response_text,
      assistance_level: assistanceLevel,
      submitted_at: new Date().toISOString(),
      grading_state: "content_uncertain",
      grader_output: fallback,
    }).eq("id", attemptId);

    return respond(
      { status: "uncertain", function: "grade-frq", result: fallback },
      { status: 202 },
    );
  }

  const parsed = graded.parsed as Record<string, unknown>;
  const criteria = Array.isArray(parsed.criteria)
    ? parsed.criteria.map((item, index) => {
      const row = item && typeof item === "object"
        ? item as Record<string, unknown>
        : {};
      const criterionKey = asString(row.criterion_key) ??
        `criterion_${index + 1}`;
      return enforceCriterionGuardrails({
        criterion_key: criterionKey,
        label: asString(row.label) ?? criterionKey,
        status: normalizeStatus(row.status),
        evidence_quote: asString(row.evidence_quote) ?? "",
        explanation: asString(row.explanation) ?? "",
        minimum_fix: asString(row.minimum_fix) ?? "",
        points_awarded: Number.isFinite(Number(row.points_awarded))
          ? Number(row.points_awarded)
          : 0,
      });
    })
    : [];

  const guardrailNotes = summarizeGuardrailNotes(criteria);
  const hasUnableCriteria = criteria.some((criterion) =>
    criterion.status === "unable_to_determine"
  );
  const modelStatus = asString(parsed.status) ?? "graded";
  const modelConfidence = asString(parsed.confidence);
  const normalizedConfidence = modelConfidence === "high" ||
      modelConfidence === "qualified" || modelConfidence === "low"
    ? modelConfidence
    : "qualified";
  const shouldEscalateToStrict = !isLongOrInvestigative && (
    modelStatus !== "graded" ||
    normalizedConfidence === "low" ||
    hasUnableCriteria ||
    guardrailNotes.length > 0
  );

  if (shouldEscalateToStrict) {
    try {
      graded = await callOpenAIGrade({
        model: OPENAI_STRICT_MODEL,
        systemPrompt: [
          systemPrompt,
          "This is a strict escalation pass after the fast pass was low-confidence or guardrail-adjusted.",
        ].join(" "),
        userPrompt,
        idempotencyKey: `${attemptId}:strict`,
        userId: user.id,
        reasoningEffort: "medium",
        maxOutputTokens: OPENAI_MAX_OUTPUT_TOKENS,
      });
    } catch (error) {
      const fallback = {
        status: "uncertain",
        points_earned: 0,
        points_available: Number(question.points_available ?? 1) || 1,
        point_summary:
          "Your answer is saved, but grading could not be completed confidently.",
        criteria: [],
        missing_concept: "The grader could not determine the missing concept.",
        next_fix: "Try again with the missing concept stated directly.",
        teaching_note:
          "This result should be reviewed if it appears unexpectedly.",
        confidence: "low",
        uncertainty_reason: error instanceof Error
          ? error.message
          : "grading_failed",
      };

      await service.schema("public").from("student_attempts").update({
        response_text: responseText || attempt.response_text,
        assistance_level: assistanceLevel,
        submitted_at: new Date().toISOString(),
        grading_state: "content_uncertain",
        grader_output: fallback,
      }).eq("id", attemptId);

      return respond(
        { status: "uncertain", function: "grade-frq", result: fallback },
        { status: 202 },
      );
    }
  }

  const parsedAfterEscalation = graded.parsed as Record<string, unknown>;
  const criteriaAfterEscalation = Array.isArray(parsedAfterEscalation.criteria)
    ? parsedAfterEscalation.criteria.map((item, index) => {
      const row = item && typeof item === "object"
        ? item as Record<string, unknown>
        : {};
      const criterionKey = asString(row.criterion_key) ??
        `criterion_${index + 1}`;
      return enforceCriterionGuardrails({
        criterion_key: criterionKey,
        label: asString(row.label) ?? criterionKey,
        status: normalizeStatus(row.status),
        evidence_quote: asString(row.evidence_quote) ?? "",
        explanation: asString(row.explanation) ?? "",
        minimum_fix: asString(row.minimum_fix) ?? "",
        points_awarded: Number.isFinite(Number(row.points_awarded))
          ? Number(row.points_awarded)
          : 0,
      });
    })
    : [];

  const guardrailNotesAfterEscalation = summarizeGuardrailNotes(
    criteriaAfterEscalation,
  );
  const hasUnableCriteriaAfterEscalation = criteriaAfterEscalation.some((criterion) =>
    criterion.status === "unable_to_determine"
  );
  const modelStatusAfterEscalation = asString(parsedAfterEscalation.status) ??
    "graded";
  const modelConfidenceAfterEscalation = asString(parsedAfterEscalation.confidence);
  const normalizedConfidenceAfterEscalation = modelConfidenceAfterEscalation === "high" ||
      modelConfidenceAfterEscalation === "qualified" ||
      modelConfidenceAfterEscalation === "low"
    ? modelConfidenceAfterEscalation
    : "qualified";
  const shouldQualifyResult = modelStatusAfterEscalation !== "graded" ||
    normalizedConfidenceAfterEscalation === "low" ||
    hasUnableCriteriaAfterEscalation ||
    guardrailNotesAfterEscalation.length > 0;
  const pointsEarned = criteriaAfterEscalation.reduce(
    (sum, criterion) => sum + criterion.points_awarded,
    0,
  );

  const result = {
    status: shouldQualifyResult ? "uncertain" : "graded",
    points_earned: pointsEarned,
    points_available: Number.isFinite(Number(parsedAfterEscalation.points_available))
      ? Number(parsedAfterEscalation.points_available)
      : Number(question.points_available ?? 1) || 1,
    point_summary: shouldQualifyResult
      ? "Your response is saved, but at least one criterion needs a qualified review before this score should be treated as final."
      : asString(parsedAfterEscalation.point_summary) ?? "Criterion-level feedback is ready.",
    criteria: criteriaAfterEscalation,
    missing_concept: asString(parsedAfterEscalation.missing_concept) ?? "",
    next_fix: asString(parsedAfterEscalation.next_fix) ?? "",
    teaching_note: asString(parsedAfterEscalation.teaching_note) ?? "",
    confidence: shouldQualifyResult && normalizedConfidenceAfterEscalation === "high"
      ? "qualified"
      : normalizedConfidenceAfterEscalation,
    uncertainty_reason: shouldQualifyResult
      ? asString(parsedAfterEscalation.uncertainty_reason) ??
        (guardrailNotesAfterEscalation.length > 0
          ? "grader_output_guardrail_adjusted"
          : "criterion_unable_to_determine")
      : asString(parsedAfterEscalation.uncertainty_reason),
    guardrail_notes: guardrailNotesAfterEscalation,
    raw_model_response: graded.raw,
  };

  const gradeState = result.status === "graded"
    ? "graded_high_confidence"
    : "content_uncertain";

  const lockRows = criteriaAfterEscalation.filter((criterion) =>
    criterion.status !== "earned"
  );
  if (lockRows.length > 0) {
    await service.schema("public").from("student_lock_queue").insert(
      lockRows.map((criterion) => ({
        student_id: user.id,
        question_id: questionId,
        criterion_id: criterion.criterion_key,
        assistance_level: assistanceLevel === "exam" ? "cold" : assistanceLevel,
        result: "not_earned" as const,
        next_review_at: new Date(Date.now() + 24 * 60 * 60 * 1000)
          .toISOString(),
        review_count: 0,
        last_attempt_id: attemptId,
      })),
    );
  }

  await service.schema("public").from("student_attempts").update({
    response_text: responseText || attempt.response_text,
    assistance_level: assistanceLevel,
    submitted_at: new Date().toISOString(),
    grading_state: gradeState,
    grader_output: result,
  }).eq("id", attemptId);

  return respond(
    {
      status: result.status,
      function: "grade-frq",
      attempt_id: attemptId,
      question_id: questionId,
      lock_queue_created: lockRows.length > 0,
      result,
    },
    { status: 200 },
  );
});
