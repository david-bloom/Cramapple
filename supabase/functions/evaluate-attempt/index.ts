import { createServiceClient } from "../_shared/supabase.ts";
import { jsonResponse, readJsonBody } from "../_shared/http.ts";
import { requireProfile } from "../_shared/auth.ts";
import { loadLearningRuntimeContext } from "../_shared/learning-context.ts";
import {
  asRecord,
  buildGradingMemoryState,
  recordStudentMemoryEvent,
} from "../_shared/student-memory.ts";

function requireEnv(name: string) {
  const value = Deno.env.get(name);
  if (!value) {
    throw new Error(`Missing required environment variable: ${name}`);
  }
  return value;
}

function requirePositiveIntegerEnv(name: string) {
  const raw = requireEnv(name);
  const value = Number(raw);
  if (!Number.isInteger(value) || value <= 0) {
    throw new Error(`Invalid required environment variable: ${name}`);
  }
  return value;
}

function requirePositiveNumberEnv(name: string) {
  const raw = requireEnv(name);
  const value = Number(raw);
  if (!Number.isFinite(value) || value <= 0) {
    throw new Error(`Invalid required environment variable: ${name}`);
  }
  return value;
}

// Fail fast on deployment misconfiguration instead of grading with silent defaults.
const OPENAI_API_KEY = requireEnv("OPENAI_API_KEY");
const OPENAI_MODEL = requireEnv("OPENAI_MODEL");
const OPENAI_MAX_OUTPUT_TOKENS = requirePositiveIntegerEnv(
  "OPENAI_MAX_OUTPUT_TOKENS",
);
const OPENAI_INPUT_PRICE_PER_1M = requirePositiveNumberEnv(
  "OPENAI_INPUT_PRICE_PER_1M",
);
const OPENAI_OUTPUT_PRICE_PER_1M = requirePositiveNumberEnv(
  "OPENAI_OUTPUT_PRICE_PER_1M",
);
const OPENAI_DAILY_CAP_USD = requirePositiveNumberEnv("OPENAI_DAILY_CAP_USD");
const EVALUATE_ATTEMPT_PROMPT_VERSION = requireEnv(
  "EVALUATE_ATTEMPT_PROMPT_VERSION",
);

// Timeout is configurable so we can tune for high-reasoning models without
// a code change. 90s accommodates reasoning: { effort: "high" } latency
// observed in pilot runs while still bounding requests so a hung connection
// can't tie up the function instance.
const OPENAI_REQUEST_TIMEOUT_MS = (() => {
  const raw = Deno.env.get("OPENAI_REQUEST_TIMEOUT_MS");
  if (!raw) return 90_000;
  const parsed = Number(raw);
  if (!Number.isInteger(parsed) || parsed <= 0) {
    throw new Error("Invalid environment variable: OPENAI_REQUEST_TIMEOUT_MS");
  }
  return parsed;
})();

type AllowedOperation =
  | "grade_initial_attempt"
  | "select_repair"
  | "grade_revision"
  | "grade_transfer_attempt";

type CriterionRow = {
  criterion_key: string;
  learner_facing_text: string;
  points_possible: number;
  evidence_requirements: string | null;
  minimum_fix: string | null;
  accepted_variants: unknown;
};

type OutputCriterion = {
  criterion_key: string;
  status:
    | "earned"
    | "not_yet_earned"
    | "unable_to_determine"
    | "not_applicable";
  points_awarded: number;
  evidence_quote: string | null;
  decision_explanation: string | null;
  minimum_fix: string | null;
};

const allowedOperations = new Set<AllowedOperation>([
  "grade_initial_attempt",
  "select_repair",
  "grade_revision",
  "grade_transfer_attempt",
]);

const gradingSchema = {
  type: "object",
  additionalProperties: false,
  properties: {
    status: {
      type: "string",
      enum: ["graded", "uncertain", "failed"],
    },
    points_earned: { type: "integer" },
    points_available: { type: "integer" },
    criteria: {
      type: "array",
      items: {
        type: "object",
        additionalProperties: false,
        properties: {
          criterion_key: { type: "string" },
          status: {
            type: "string",
            enum: [
              "earned",
              "not_yet_earned",
              "unable_to_determine",
              "not_applicable",
            ],
          },
          points_awarded: { type: "integer" },
          evidence_quote: { type: ["string", "null"] },
          decision_explanation: { type: ["string", "null"] },
          minimum_fix: { type: ["string", "null"] },
        },
        required: [
          "criterion_key",
          "status",
          "points_awarded",
          "evidence_quote",
          "decision_explanation",
          "minimum_fix",
        ],
      },
    },
    highest_value_gap: {
      anyOf: [
        { type: "null" },
        {
          type: "object",
          additionalProperties: false,
          properties: {
            criterion_key: { type: "string" },
            minimum_fix: { type: "string" },
            repair_prompt: { type: "string" },
          },
          required: ["criterion_key", "minimum_fix", "repair_prompt"],
        },
      ],
    },
    predicted_improvement: {
      anyOf: [
        { type: "null" },
        {
          type: "object",
          additionalProperties: false,
          properties: {
            label: {
              type: "string",
              enum: ["better", "much_better", "none"],
            },
            predicted_point_gain: { type: "integer" },
          },
          required: ["label", "predicted_point_gain"],
        },
      ],
    },
    confidence: {
      type: "string",
      enum: ["high", "medium", "low"],
    },
    uncertainty_reason: { type: ["string", "null"] },
    student_facing_summary: { type: "string" },
  },
  required: [
    "status",
    "points_earned",
    "points_available",
    "criteria",
    "highest_value_gap",
    "predicted_improvement",
    "confidence",
    "uncertainty_reason",
    "student_facing_summary",
  ],
} as const;

function getBodyField(body: Record<string, unknown>, ...keys: string[]) {
  for (const key of keys) {
    const value = body[key];
    if (value !== undefined && value !== null) {
      return value;
    }
  }
  return undefined;
}

function asString(value: unknown) {
  return typeof value === "string" ? value : null;
}

function asUuid(value: unknown) {
  return typeof value === "string" && /^[0-9a-fA-F-]{36}$/.test(value)
    ? value
    : null;
}

function sha256Hex(value: string) {
  return crypto.subtle.digest("SHA-256", new TextEncoder().encode(value)).then(
    (digest) => {
      const bytes = Array.from(new Uint8Array(digest));
      return bytes.map((byte) => byte.toString(16).padStart(2, "0")).join("");
    },
  );
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

async function persistGradingMemory(input: {
  service: ReturnType<typeof createServiceClient>;
  sessionId: string | null;
  attemptId: string;
  attemptMode: string;
  assistanceState: string;
  finalStatus: string;
  pointsEarned: number;
  pointsAvailable: number;
  confidence: string | null;
  highestValueGap: {
    criterion_key: string;
    minimum_fix: string;
    repair_prompt: string;
  } | null;
  criteria: Array<{
    criterion_key: string;
    status: string;
    points_awarded: number;
  }>;
  summary: string;
  examPackVersionId: string;
}) {
  if (!input.sessionId) {
    return null;
  }

  const context = await loadLearningRuntimeContext(input.service, input.sessionId);
  if (!context) {
    return null;
  }

  const subjectDefaults = asRecord(context.subject_defaults);
  const subject = asRecord(subjectDefaults.subject);
  const examPack = asRecord(subjectDefaults.exam_pack);
  const memory = asRecord(context.student_memory);
  const sessionState = asRecord(context.session_state);

  if (!subject.id || !sessionState.user_id) {
    return context;
  }

  const memoryState = buildGradingMemoryState({
    currentMemoryState: asRecord(memory.memory_state),
    subjectId: String(subject.id),
    subjectKey: String(subject.subject_key ?? ""),
    subjectName: String(subject.display_name ?? ""),
    examPackVersionId: input.examPackVersionId,
    sessionId: input.sessionId,
    attemptId: input.attemptId,
    attemptMode: input.attemptMode,
    assistanceState: input.assistanceState,
    finalStatus: input.finalStatus,
    pointsEarned: input.pointsEarned,
    pointsAvailable: input.pointsAvailable,
    confidence: input.confidence,
    highestValueGap: input.highestValueGap,
    criteria: input.criteria,
    summary: input.summary,
  });

  try {
    await recordStudentMemoryEvent(input.service, {
      userId: String(sessionState.user_id),
      subjectId: String(subject.id),
      eventKind: "grading_result",
      sourceSessionId: input.sessionId,
      sourceAttemptId: input.attemptId,
      memoryState,
      eventPayload: {
        exam_pack: examPack,
        session_state: context.session_state,
        grading_result: {
          attempt_id: input.attemptId,
          final_status: input.finalStatus,
          points_earned: input.pointsEarned,
          points_available: input.pointsAvailable,
          confidence: input.confidence,
          highest_value_gap: input.highestValueGap,
          summary: input.summary,
        },
      },
    });
  } catch (error) {
    console.error("grading_memory_persist_failed", error);
  }

  return (await loadLearningRuntimeContext(input.service, input.sessionId)) ?? context;
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

function normalizeCriterionStatus(
  status: unknown,
): OutputCriterion["status"] {
  return status === "earned" ||
      status === "not_yet_earned" ||
      status === "unable_to_determine" ||
      status === "not_applicable"
    ? status
    : "unable_to_determine";
}

function buildFallbackCriteria(criteria: CriterionRow[], reason: string) {
  return criteria.map((criterion) => ({
    criterion_key: criterion.criterion_key,
    status: "unable_to_determine" as const,
    points_awarded: 0,
    evidence_quote: null,
    decision_explanation: reason,
    minimum_fix: criterion.minimum_fix,
  }));
}

function pickHighestGap(
  criteria: OutputCriterion[],
  sourceCriteria: CriterionRow[],
) {
  const firstGap = criteria.find((criterion) => criterion.status !== "earned");

  if (!firstGap) {
    return null;
  }

  const source = sourceCriteria.find((item) =>
    item.criterion_key === firstGap.criterion_key
  );

  return {
    criterion_key: firstGap.criterion_key,
    minimum_fix: source?.minimum_fix ?? firstGap.minimum_fix ??
      "Provide the missing evidence.",
    repair_prompt: source?.minimum_fix ??
      firstGap.minimum_fix ??
      "Revise only the missing criterion and keep the rest of the response intact.",
  };
}

function summarizeSelectedChoice(responseJson: Record<string, unknown>) {
  const candidates = [
    responseJson.selected_choice_key,
    responseJson.selectedChoiceKey,
    responseJson.choice_key,
    responseJson.choiceKey,
    responseJson.selected_choice_id,
    responseJson.selectedChoiceId,
    responseJson.answer,
    responseJson.selected_answer,
    responseJson.selectedAnswer,
  ];

  for (const candidate of candidates) {
    if (typeof candidate === "string" && candidate.length > 0) {
      return candidate;
    }
  }

  return null;
}

function buildGradingPrompt(input: {
  operation: AllowedOperation;
  promptVersion: string;
  examName: string;
  itemTitle: string;
  itemType: string;
  stem: string;
  stimulus: string | null;
  responseText: string | null;
  responseParts: unknown;
  criteria: CriterionRow[];
}) {
  const rubricLines = input.criteria.map((criterion) => {
    const pieces = [
      `- ${criterion.criterion_key}: ${criterion.learner_facing_text}`,
      `  points_possible: ${criterion.points_possible}`,
    ];

    if (criterion.evidence_requirements) {
      pieces.push(
        `  evidence_requirements: ${criterion.evidence_requirements}`,
      );
    }

    if (criterion.minimum_fix) {
      pieces.push(`  minimum_fix: ${criterion.minimum_fix}`);
    }

    return pieces.join("\n");
  }).join("\n");

  return [
    `You are Cramapple's production grader for ${input.examName}.`,
    `Use only the released content and rubric provided below.`,
    `Do not invent facts, claims, or criteria that are not present in the rubric.`,
    `If evidence is insufficient, mark the relevant criteria unable_to_determine and explain why.`,
    `The operation is ${input.operation}.`,
    `Prompt version: ${input.promptVersion}.`,
    `Item title: ${input.itemTitle}.`,
    `Item type: ${input.itemType}.`,
    `Stem: ${input.stem}`,
    input.stimulus ? `Stimulus: ${input.stimulus}` : "Stimulus: none",
    `Rubric:`,
    rubricLines,
    `Student response text:`,
    input.responseText ?? "",
    `Student response parts JSON:`,
    JSON.stringify(input.responseParts ?? {}, null, 2),
    `Return JSON matching the schema exactly.`,
    `For select_repair, make highest_value_gap the single highest-value missing criterion and keep repair_prompt narrow and actionable.`,
  ].join("\n\n");
}

// Sentinel error thrown when a transient failure is worth retrying once.
// Non-transient errors (4xx other than 429, JSON parse failures, schema
// violations) are thrown directly and not retried.
class TransientGraderError extends Error {
  constructor(message: string, public override readonly cause?: unknown) {
    super(message);
    this.name = "TransientGraderError";
  }
}

async function attemptOpenAICall(input: {
  body: Record<string, unknown>;
  idempotencyKey: string;
  timeoutMs: number;
}) {
  const startedAt = Date.now();
  let response: Response;

  try {
    response = await fetch("https://api.openai.com/v1/responses", {
      method: "POST",
      headers: {
        Authorization: `Bearer ${OPENAI_API_KEY}`,
        "Content-Type": "application/json",
        // Send a stable idempotency key so a network-level retry against
        // the same logical grading request cannot be charged twice.
        "Idempotency-Key": input.idempotencyKey,
      },
      body: JSON.stringify(input.body),
      // AbortSignal.timeout bounds the entire fetch lifecycle including
      // connection + read. On timeout, fetch rejects with an AbortError
      // which we surface as a transient error so it can be retried once.
      signal: AbortSignal.timeout(input.timeoutMs),
    });
  } catch (error) {
    const elapsedMs = Date.now() - startedAt;
    if (error instanceof DOMException && error.name === "AbortError") {
      throw new TransientGraderError(
        `openai_timeout_after_${elapsedMs}ms`,
        error,
      );
    }
    // TypeError covers DNS, TLS handshake, connection-reset style failures.
    if (error instanceof TypeError) {
      throw new TransientGraderError("openai_network_error", error);
    }
    throw error;
  }

  const elapsedMs = Date.now() - startedAt;
  const raw = await response.json().catch(() => null);

  if (!response.ok) {
    const message = raw?.error?.message ?? `openai_http_${response.status}`;
    // Retry on 408/425/429/5xx. Other 4xx are validation problems where
    // the same request will keep failing — fail fast and let the caller's
    // catch produce a safe uncertainty response for the student.
    if (
      response.status === 408 ||
      response.status === 425 ||
      response.status === 429 ||
      response.status >= 500
    ) {
      throw new TransientGraderError(
        `openai_http_${response.status}: ${message}`,
      );
    }
    throw new Error(message);
  }

  const outputText = extractOutputText(raw ?? {});
  if (!outputText) {
    throw new Error("openai_missing_output_text");
  }

  const parsed = JSON.parse(outputText);
  return { raw, parsed, elapsedMs };
}

async function callOpenAIGrader(input: {
  modelId: string;
  maxOutputTokens: number;
  systemPrompt: string;
  userPrompt: string;
  userIdHash: string;
  idempotencyKey: string;
}) {
  const body = {
    model: input.modelId,
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
    reasoning: { effort: "high" },
    max_output_tokens: input.maxOutputTokens,
    text: {
      format: {
        type: "json_schema",
        name: "grading_result",
        strict: true,
        schema: gradingSchema,
      },
    },
    user: input.userIdHash.slice(0, 64),
  };

  // At most one retry on transient failures. The Idempotency-Key header
  // makes the retry safe against double-billing for requests that reached
  // the server but failed mid-response.
  try {
    return await attemptOpenAICall({
      body,
      idempotencyKey: input.idempotencyKey,
      timeoutMs: OPENAI_REQUEST_TIMEOUT_MS,
    });
  } catch (error) {
    if (!(error instanceof TransientGraderError)) {
      throw error;
    }
    // Brief backoff before the single retry. 500ms is small enough that
    // students do not feel it during a normal grading hop but large enough
    // to let a transient upstream blip clear.
    await new Promise((resolve) => setTimeout(resolve, 500));
    return await attemptOpenAICall({
      body,
      idempotencyKey: input.idempotencyKey,
      timeoutMs: OPENAI_REQUEST_TIMEOUT_MS,
    });
  }
}

function sanitizeModelResult(
  parsed: Record<string, unknown>,
  sourceCriteria: CriterionRow[],
) {
  const criteria = Array.isArray(parsed.criteria)
    ? parsed.criteria.map((item, index) => {
      const source = sourceCriteria[index];
      const rawItem = item && typeof item === "object"
        ? item as Record<string, unknown>
        : {};

      return {
        criterion_key: asString(rawItem.criterion_key) ??
          source?.criterion_key ??
          `criterion_${index + 1}`,
        status: normalizeCriterionStatus(rawItem.status),
        points_awarded: Number.isFinite(Number(rawItem.points_awarded))
          ? Number(rawItem.points_awarded)
          : 0,
        evidence_quote: asString(rawItem.evidence_quote),
        decision_explanation: asString(rawItem.decision_explanation),
        minimum_fix: asString(rawItem.minimum_fix) ?? source?.minimum_fix ??
          null,
      } as OutputCriterion;
    })
    : buildFallbackCriteria(sourceCriteria, "Unable to parse model output.");

  const pointsEarned = Number.isFinite(Number(parsed.points_earned))
    ? Number(parsed.points_earned)
    : criteria.reduce((sum, criterion) => sum + criterion.points_awarded, 0);

  const pointsAvailable = Number.isFinite(Number(parsed.points_available))
    ? Number(parsed.points_available)
    : sourceCriteria.reduce(
      (sum, criterion) => sum + criterion.points_possible,
      0,
    );

  const highestValueGap = parsed.highest_value_gap &&
      typeof parsed.highest_value_gap === "object" &&
      !Array.isArray(parsed.highest_value_gap)
    ? {
      criterion_key: asString(
        (parsed.highest_value_gap as Record<string, unknown>).criterion_key,
      ) ??
        pickHighestGap(criteria, sourceCriteria)?.criterion_key ??
        "criterion",
      minimum_fix: asString(
        (parsed.highest_value_gap as Record<string, unknown>).minimum_fix,
      ) ??
        pickHighestGap(criteria, sourceCriteria)?.minimum_fix ??
        "Provide the missing evidence.",
      repair_prompt: asString(
        (parsed.highest_value_gap as Record<string, unknown>).repair_prompt,
      ) ??
        pickHighestGap(criteria, sourceCriteria)?.repair_prompt ??
        "Revise the highest-value missing criterion.",
    }
    : pickHighestGap(criteria, sourceCriteria);

  const predictedImprovement = parsed.predicted_improvement &&
      typeof parsed.predicted_improvement === "object" &&
      !Array.isArray(parsed.predicted_improvement)
    ? {
      label: (
        asString(
              (parsed.predicted_improvement as Record<string, unknown>).label,
            ) === "better" ||
          asString(
              (parsed.predicted_improvement as Record<string, unknown>).label,
            ) === "much_better"
          ? asString(
            (parsed.predicted_improvement as Record<string, unknown>).label,
          )
          : "none"
      ) as "better" | "much_better" | "none",
      predicted_point_gain: Number.isFinite(
          Number(
            (parsed.predicted_improvement as Record<string, unknown>)
              .predicted_point_gain,
          ),
        )
        ? Number(
          (parsed.predicted_improvement as Record<string, unknown>)
            .predicted_point_gain,
        )
        : 0,
    }
    : null;

  return {
    status: asString(parsed.status) ?? "uncertain",
    points_earned: pointsEarned,
    points_available: pointsAvailable,
    criteria,
    highest_value_gap: highestValueGap,
    predicted_improvement: predictedImprovement,
    confidence: asString(parsed.confidence) === "high" ||
        asString(parsed.confidence) === "medium" ||
        asString(parsed.confidence) === "low"
      ? asString(parsed.confidence)
      : "medium",
    uncertainty_reason: asString(parsed.uncertainty_reason),
    student_facing_summary: asString(parsed.student_facing_summary) ??
      "Your response was scored successfully.",
  };
}

async function readBodyAsRecord(req: Request) {
  const body = await readJsonBody(req);
  return body && typeof body === "object" && !Array.isArray(body)
    ? body as Record<string, unknown>
    : null;
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

  const body = await readBodyAsRecord(req);
  if (!body) {
    return respond({ error: "invalid_json" }, { status: 400 });
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
  const contentItemVersionId = asUuid(
    getBodyField(body, "content_item_version_id", "contentItemVersionId"),
  );
  const rubricVersionId = asUuid(
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

  if (
    !idempotencyKey || !attemptId || !responseVersionId ||
    !contentItemVersionId || !rubricVersionId
  ) {
    return respond(
      {
        error: "missing_required_fields",
        required: [
          "idempotency_key",
          "attempt_id",
          "response_version_id",
          "content_item_version_id",
          "rubric_version_id",
        ],
      },
      { status: 400 },
    );
  }

  const profileResult = await requireProfile(req);
  if (!profileResult) {
    return respond({ error: "unauthorized" }, { status: 401 });
  }

  const { user, profile } = profileResult;
  if (profile.role !== "student" && profile.role !== "admin") {
    return respond({ error: "forbidden" }, { status: 403 });
  }

  const service = createServiceClient();

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

  const requestHashPayload = {
    operation,
    idempotencyKey,
    attemptId,
    responseVersionId,
    artifactVersionId,
    contentItemVersionId,
    rubricVersionId,
    assistanceCondition,
    promptVersion,
  };
  const requestHash = await sha256Hex(JSON.stringify(requestHashPayload));

  const { data: existingResult } = await service.schema("app")
    .from("grading_results")
    .select("*")
    .eq("request_id", idempotencyKey)
    .maybeSingle();

  if (existingResult) {
    if (existingResult.request_hash !== requestHash) {
      return respond({ error: "idempotency_conflict" }, { status: 409 });
    }

    return respond(
      {
        status: existingResult.status,
        function: "evaluate-attempt",
        operation,
        result: existingResult,
      },
      { status: existingResult.status === "processing" ? 202 : 200 },
    );
  }

  const [
    { data: attempt, error: attemptError },
    { data: responseVersion, error: responseError },
    { data: contentVersion, error: contentError },
  ] = await Promise.all([
    service.schema("app")
      .from("attempts")
      .select(
        "id, user_id, learning_session_id, exam_pack_version_id, content_item_version_id, artifact_version_id, attempt_mode, status, assistance_state, started_at, submitted_at, graded_at, score_points, score_possible",
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
    service.schema("app")
      .from("content_item_versions")
      .select(
        "id, content_item_id, version_num, stem, stimulus, prompt_json, explanation, help_text, content_hash, status, approved_at, approved_by, published_at",
      )
      .eq("id", contentItemVersionId)
      .maybeSingle(),
  ]);

  if (
    attemptError || responseError || contentError || !attempt ||
    !responseVersion || !contentVersion
  ) {
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

  if (
    contentItemVersionId && attempt.content_item_version_id !== contentVersion.id
  ) {
    return respond({ error: "content_version_mismatch" }, { status: 409 });
  }

  if (artifactVersionId && attempt.artifact_version_id !== artifactVersionId) {
    return respond({ error: "artifact_version_mismatch" }, { status: 409 });
  }

  const [
    { data: contentItem },
    { data: examPackVersion },
    { data: criteriaRows },
    { data: mcqChoices },
  ] = await Promise.all([
    service.schema("app")
      .from("content_items")
      .select("id, exam_pack_version_id, content_key, item_type, title, status")
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

  if (
    contentItem.status !== "published" ||
    contentVersion.status !== "published" ||
    examPackVersion.status !== "published"
  ) {
    return respond({ error: "content_not_published" }, { status: 409 });
  }

  // Subject-driven grading: examName comes from the exam pack the question
  // actually belongs to, not a literal. This is what makes grading prompts
  // work for any subject without a code change per subject (TASK-0013
  // Phase 1) — fails loudly rather than silently falling back to Biology if
  // the exam pack row is somehow missing.
  const { data: examPack, error: examPackError } = await service
    .schema("app")
    .from("exam_packs")
    .select("id, exam_code, exam_name")
    .eq("id", examPackVersion.exam_pack_id)
    .maybeSingle();

  if (examPackError || !examPack) {
    return respond({ error: "exam_pack_not_found" }, { status: 404 });
  }

  const responseParts = parseJsonSafe(
    typeof responseVersion.response_parts === "string"
      ? responseVersion.response_parts
      : JSON.stringify(responseVersion.response_parts),
  ) ?? {};
  const responseText = typeof responseVersion.response_text === "string"
    ? responseVersion.response_text
    : null;

  const attemptKind = attempt.attempt_mode as string;
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
    criteria: Array.isArray(criteriaRows) ? criteriaRows as CriterionRow[] : [],
  };

  const defaultPointsAvailable = promptBase.criteria.reduce(
    (sum, criterion) => sum + Number(criterion.points_possible || 0),
    0,
  ) || (contentItem.item_type === "mcq" ? 1 : 0);

  const requestRecord = {
    request_id: idempotencyKey,
    request_hash: requestHash,
    attempt_id: attempt.id,
    response_version_id: responseVersion.id,
    operation,
    status: "processing",
    points_available: defaultPointsAvailable,
    confidence: "medium",
    model_id: OPENAI_MODEL,
    prompt_version: promptVersion,
    rubric_version_id: rubricVersionId,
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

    if (conflictResult && conflictResult.request_hash === requestHash) {
      return respond(
        {
          status: conflictResult.status,
          function: "evaluate-attempt",
          operation,
          result: conflictResult,
        },
        { status: conflictResult.status === "processing" ? 202 : 200 },
      );
    }

    return respond({ error: "could_not_create_grading_record" }, {
      status: 409,
    });
  }

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

  let usageRow: Record<string, unknown> | null = null;
  const isMcq = contentItem.item_type === "mcq";

  if (!isMcq) {
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

    const criteria: OutputCriterion[] = [
      {
        criterion_key: "mcq_correct_choice",
        status: earned ? "earned" : "not_yet_earned",
        points_awarded: earned,
        evidence_quote: selectedChoice,
        decision_explanation: earned
          ? "The selected choice matches the published correct answer."
          : "The submitted choice does not match the published correct answer.",
        minimum_fix: earned
          ? null
          : "Select the answer choice that matches the published correct answer.",
      },
    ];

    const finalResult = {
      status: "graded",
      points_earned: earned,
      points_available: 1,
      criteria,
      highest_value_gap: earned ? null : {
        criterion_key: "mcq_correct_choice",
        minimum_fix:
          "Select the answer choice that matches the published correct answer.",
        repair_prompt:
          "Choose the answer that matches the published correct answer.",
      },
      predicted_improvement: null,
      confidence: "high",
      uncertainty_reason: null,
      student_facing_summary: earned
        ? "Correct."
        : "Not quite. Review the selected answer against the published choices.",
    };

    await service.schema("app").from("grading_results").update({
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
      rubric_version_id: rubricVersionId,
      input_tokens: 0,
      output_tokens: 0,
      estimated_cost_usd: 0,
      latency_ms: 0,
      raw_model_response: null,
    }).eq("request_id", idempotencyKey);

    await service.schema("app").from("attempts").update({
      status: "graded",
      graded_at: new Date().toISOString(),
      score_points: finalResult.points_earned,
      score_possible: finalResult.points_available,
      confidence_level: finalResult.confidence,
      result_state: "graded",
      result_summary: finalResult.student_facing_summary,
    }).eq("id", attempt.id);

    const runtimeContext = await persistGradingMemory({
      service,
      sessionId: attempt.learning_session_id as string | null,
      attemptId: attempt.id,
      attemptMode: attempt.attempt_mode as string,
      assistanceState: attempt.assistance_state as string,
      finalStatus: "graded",
      pointsEarned: finalResult.points_earned,
      pointsAvailable: finalResult.points_available,
      confidence: finalResult.confidence,
      highestValueGap: finalResult.highest_value_gap,
      criteria,
      summary: finalResult.student_facing_summary,
      examPackVersionId: attempt.exam_pack_version_id as string,
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

  const systemPrompt = [
    `You are Cramapple's production criterion-based grader for ${examPack.exam_name}.`,
    "Use only the provided released content, rubric, and student response.",
    "Score each criterion independently.",
    "Do not invent evidence.",
    "When the response is ambiguous or unsupported, mark the criterion unable_to_determine.",
    "Return only the JSON object that matches the schema.",
  ].join(" ");

  let modelResponse: {
    raw: Record<string, unknown>;
    parsed: Record<string, unknown>;
    elapsedMs: number;
  } | null = null;
  let finalStatus: "graded" | "uncertain" | "failed" = "failed";
  let finalPayload: ReturnType<typeof sanitizeModelResult> | null = null;
  let inputTokens = estimatedInputTokens;
  let outputTokens = 0;
  let actualCost = 0;

  try {
    await service.schema("app").from("grading_results").update({
      status: "processing",
      model_id: modelId,
      estimated_cost_usd: reservedCost,
      prompt_version: promptVersion,
      rubric_version_id: rubricVersionId,
    }).eq("request_id", idempotencyKey);

    if (usageRow) {
      await service.schema("app").from("model_usage_ledger").update({
        status: "running",
      }).eq("request_id", idempotencyKey);
    }

    modelResponse = await callOpenAIGrader({
      modelId,
      maxOutputTokens: OPENAI_MAX_OUTPUT_TOKENS,
      systemPrompt,
      userPrompt: buildGradingPrompt(promptBase),
      userIdHash: await sha256Hex(user.id),
      idempotencyKey: idempotencyKey,
    });

    finalPayload = sanitizeModelResult(
      modelResponse.parsed,
      promptBase.criteria,
    );
    finalStatus = finalPayload.status === "graded" ? "graded" : "uncertain";

    const usage = modelResponse.raw.usage as
      | Record<string, unknown>
      | undefined;
    inputTokens = Number.isFinite(Number(usage?.input_tokens))
      ? Number(usage?.input_tokens)
      : inputTokens;
    outputTokens = Number.isFinite(Number(usage?.output_tokens))
      ? Number(usage?.output_tokens)
      : outputTokens;

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
    model_id: modelId,
    prompt_version: promptVersion,
    rubric_version_id: rubricVersionId,
    input_tokens: inputTokens,
    output_tokens: outputTokens,
    estimated_cost_usd: actualCost || reservedCost,
    latency_ms: modelResponse?.elapsedMs ?? 0,
    raw_model_response: modelResponse?.raw ?? null,
  };

  await service.schema("app")
    .from("grading_results")
    .update(updatePayload)
    .eq("request_id", idempotencyKey);

  await service.schema("app")
    .from("attempts")
    .update({
      status: finalStatus === "graded" ? "graded" : "uncertain",
      graded_at: new Date().toISOString(),
      score_points: finalPayload.points_earned,
      score_possible: finalPayload.points_available,
      confidence_level: finalPayload.confidence,
      result_state: finalStatus,
      result_summary: finalPayload.student_facing_summary,
    })
    .eq("id", attempt.id);

  const runtimeContext = await persistGradingMemory({
    service,
    sessionId: attempt.learning_session_id as string | null,
    attemptId: attempt.id,
    attemptMode: attempt.attempt_mode as string,
    assistanceState: attempt.assistance_state as string,
    finalStatus,
    pointsEarned: finalPayload.points_earned,
    pointsAvailable: finalPayload.points_available,
    confidence: finalPayload.confidence,
    highestValueGap,
    criteria: finalPayload.criteria,
    summary: finalPayload.student_facing_summary,
    examPackVersionId: attempt.exam_pack_version_id as string,
  });

  return respond(
    {
      status: finalStatus,
      function: "evaluate-attempt",
      operation,
      result: {
        ...finalPayload,
        actual_point_gain: actualPointGain,
        prediction_outcome: predictionOutcome,
        model_id: modelId,
        prompt_version: promptVersion,
        rubric_version_id: rubricVersionId,
        attempt_id: attempt.id,
        response_version_id: responseVersion.id,
        request_id: idempotencyKey,
        latency_ms: modelResponse?.elapsedMs ?? 0,
      },
      runtime_context: runtimeContext,
    },
    { status: finalStatus === "graded" ? 200 : 202 },
  );
});
