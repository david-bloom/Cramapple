import { createServiceClient } from "../_shared/supabase.ts";
import { jsonResponse, readJsonBody } from "../_shared/http.ts";
import { requireProfile } from "../_shared/auth.ts";
import { resolveGradingRoute } from "../_shared/grading-router.ts";
import { detectAmbiguousTypedFormulaText } from "../_shared/formula-notation.ts";
import { resolveFormulaActionHint } from "../_shared/formula-notation.ts";
import { resolveFormulaRepairHint } from "../_shared/formula-notation.ts";
import {
  formatVerificationProfileSummary,
  getVerificationProfile,
  summarizeVerificationProfile,
} from "../_shared/verification-profiles.ts";
import {
  buildEcfResult,
  coerceEcfQuestion,
  findStatisticsItem,
} from "../_shared/math-verifier.ts";
import {
  buildStatisticsDeterministicFallback,
  checkStatisticsDeterministicEvidence,
} from "../_shared/statistics-verifier.ts";
import {
  buildFallbackCriteria,
  buildShadowReviewPayload,
  pickHighestGap,
} from "../_shared/grading-feedback.ts";
import {
  type AllowedOperation,
  buildCriterionGradingPrompt,
  buildCriterionRequestBody,
  buildCriterionSystemPrompt,
  buildGradingPrompt,
  buildGradingRequestBody,
  buildSystemPrompt,
  composeStudentFacingSummary,
  extractOutputText,
  extractUsage,
  type FeedbackCriterionRow,
  type GradingExemplar,
  isTransientHttpStatus,
  mergeCriterionResults,
  sanitizeModelResult,
} from "../_shared/grading-contract.ts";
import { loadLearningRuntimeContext } from "../_shared/learning-context.ts";
import {
  asRecord,
  buildGradingMemoryState,
  recordStudentMemoryEvent,
} from "../_shared/student-memory.ts";
import {
  buildEvaluateAttemptResponse,
  buildEvaluateAttemptResult,
} from "../_shared/evaluate-attempt-response.ts";
import {
  buildRepairPlan,
  lockGradeDecision,
} from "../_shared/grading-repair.ts";

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
// Entitlement gating ships ahead of its schema. The `authorize_grading_access`
// RPC lives in migration 20260720122542_free_score_check_growth_funnel.sql,
// which is NOT applied to Production (verified 2026-07-28) -- so calling it
// there fails and every non-admin grading request 403s with
// `entitlement_required`. Deploying this file without the flag took Production
// grading from "broken by two transport bugs" to "rejects every caller", which
// is strictly worse.
//
// Default OFF, which reproduces the pre-2026-07-28 deployed behaviour (v23 had
// no gate at all). This is NOT a silent bypass: the check is skipped only when
// explicitly disabled, and turning it on is a one-line env change once the
// migration is applied. Code and schema must ship together; until they do, the
// flag makes the mismatch explicit instead of fatal.
const GRADING_ENTITLEMENTS_ENABLED =
  (Deno.env.get("GRADING_ENTITLEMENTS_ENABLED") ?? "false").toLowerCase() ===
    "true";

// Request architecture for LLM text grading.
//
// "b" (default) is what Production runs today: ONE call grading every criterion
// of an item, measured at 0.58 s + 3.89 s x n_criteria, so ~16 s on a
// 4-criterion Biology FRQ. "a" grades each criterion in its own parallel call,
// which is flat in criterion count and should land near Production's own
// 1-criterion figure of ~4.5 s.
//
// Defaulting to "b" so the new path deploys dark. Arm A changes the request
// shape, the output schema, and the student-facing summary all at once, on a
// grader that had never completed a Production grading until 2026-07-28 --
// flipping it blind is how the entitlement-gate outage happened. Deploy, then
// flip the flag, then measure with the narrow pilot.
const GRADING_ARM = (Deno.env.get("GRADING_ARM") ?? "b").toLowerCase() === "a"
  ? "a"
  : "b";

// Bumped 2026-07-28: three checker defects fixed (supplied inputs now win over
// the built-in `e`/`pi` constants; CORRECT_VIA_ECF requires a real upstream
// divergence; `erf`/`factorial` parse). Verdicts from this build are not
// comparable to 2026-07-08 ones, so the stamp recorded in
// grading_results.deterministic_verifier_version has to move with it.
const MATH_VERIFIER_VERSION = "math-verifier-ts-2026-07-28";

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

export type { AllowedOperation };

type OutputCriterion = {
  criterion_key: string;
  status:
    | "earned"
    | "partially_earned"
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
  gradingRoute?: Record<string, unknown> | null;
  verificationProfile?: Record<string, unknown> | null;
  verificationProfileSummary?: Record<string, unknown> | null;
  feedbackPreview?: string | null;
  actionHint?: string | null;
  repairHint?: string | null;
  deterministicCheck?: Record<string, unknown> | null;
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
        grading_route: input.gradingRoute ?? null,
        verification_profile: input.verificationProfile ?? null,
        verification_profile_summary: input.verificationProfileSummary ?? null,
        feedback_preview: input.feedbackPreview ?? null,
        action_hint: input.actionHint ?? null,
        repair_hint: input.repairHint ?? null,
        deterministic_check: input.deterministicCheck ?? null,
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
    if (isTransientHttpStatus(response.status)) {
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
  const body = buildGradingRequestBody({
    modelId: input.modelId,
    maxOutputTokens: input.maxOutputTokens,
    systemPrompt: input.systemPrompt,
    userPrompt: input.userPrompt,
    userIdHash: input.userIdHash,
  });

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

// Arm A: grade each criterion in its own call, in parallel.
//
// Aggregation rules that matter:
//   - latency is the MAX of the calls, not the sum. They overlap; summing them
//     would report an item as slower than the student experienced and would
//     make Arm A look like the thing it replaces.
//   - tokens and cost are the SUM. The stem and stimulus are re-sent once per
//     criterion, so input tokens rise ~3.6x (Phase C). Accepted under the
//     standing Speed > Quality > Cost order, but it is a real increase and the
//     ledger must show it.
//   - each call gets its own idempotency key. Reusing the item's key across
//     the fan-out would let the provider serve one criterion's cached response
//     for every criterion on the item.
//   - one criterion failing does not fail the item. Its slot resolves to null,
//     mergeCriterionResults turns that into unable_to_determine, and the
//     sanitizer marks the grading uncertain. Under Arm B the same failure lost
//     every criterion.
async function callOpenAIGraderPerCriterion(input: {
  modelId: string;
  maxOutputTokens: number;
  systemPrompt: string;
  criteria: FeedbackCriterionRow[];
  buildUserPrompt: (criterion: FeedbackCriterionRow) => string;
  userIdHash: string;
  idempotencyKey: string;
}) {
  const settled = await Promise.all(
    input.criteria.map(async (criterion) => {
      const body = buildCriterionRequestBody({
        modelId: input.modelId,
        // The item-sized cap is reused deliberately. A single criterion cannot
        // approach it, so truncation is impossible -- and truncation at a
        // hand-tuned per-criterion cap is exactly what was misdiagnosed as an
        // architectural failure in Phase C (ARM_B_ROOT_CAUSE_ANALYSIS.md 1).
        // A cap costs nothing unless it is hit.
        maxOutputTokens: input.maxOutputTokens,
        systemPrompt: input.systemPrompt,
        userPrompt: input.buildUserPrompt(criterion),
        userIdHash: input.userIdHash,
      });
      const idempotencyKey = `${input.idempotencyKey}:${criterion.criterion_key}`;

      try {
        return await attemptOpenAICall({
          body,
          idempotencyKey,
          timeoutMs: OPENAI_REQUEST_TIMEOUT_MS,
        });
      } catch (error) {
        if (!(error instanceof TransientGraderError)) {
          return { failed: true as const, error };
        }
        await new Promise((resolve) => setTimeout(resolve, 500));
        try {
          return await attemptOpenAICall({
            body,
            idempotencyKey,
            timeoutMs: OPENAI_REQUEST_TIMEOUT_MS,
          });
        } catch (retryError) {
          return { failed: true as const, error: retryError };
        }
      }
    }),
  );

  const parsed: Array<Record<string, unknown> | null> = [];
  const raws: unknown[] = [];
  const failures: unknown[] = [];
  let inputTokens = 0;
  let outputTokens = 0;
  let maxElapsedMs = 0;

  for (const outcome of settled) {
    if ("failed" in outcome) {
      parsed.push(null);
      failures.push(outcome.error);
      continue;
    }
    parsed.push(
      outcome.parsed && typeof outcome.parsed === "object"
        ? outcome.parsed as Record<string, unknown>
        : null,
    );
    raws.push(outcome.raw);
    const usage = extractUsage(outcome.raw as Record<string, unknown>);
    inputTokens += usage.inputTokens ?? 0;
    outputTokens += usage.outputTokens ?? 0;
    maxElapsedMs = Math.max(maxElapsedMs, outcome.elapsedMs);
  }

  // Every criterion failing is an item-level failure, not a gradeable result
  // with N abstentions. Throwing puts it on the same error path Arm B uses.
  if (failures.length === input.criteria.length && input.criteria.length > 0) {
    throw failures[0];
  }

  return { parsed, raws, inputTokens, outputTokens, elapsedMs: maxElapsedMs };
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
  const exemplarMode = exemplarModeRaw === "with_exemplar" ? "with_exemplar" : "off";
  const requestExemplars = exemplarMode === "with_exemplar"
    ? (Array.isArray(getBodyField(body, "exemplars"))
      ? getBodyField(body, "exemplars") as GradingExemplar[]
      : undefined)
    : undefined;

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

    const { data: existingAttempt } = await service.schema("app")
      .from("attempts")
      .select("user_id")
      .eq("id", existingResult.attempt_id)
      .maybeSingle();
    if (
      !existingAttempt ||
      (existingAttempt.user_id !== user.id && profile.role !== "admin")
    ) {
      return respond({ error: "forbidden" }, { status: 403 });
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
        "id, content_item_id, version_num, stem, stimulus, prompt_json, rubric_type, evaluator_strategy, explanation, help_text, content_hash, status, approved_at, approved_by, published_at",
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
  const statisticsCheck = checkStatisticsDeterministicEvidence({
    contentKey: contentItem.content_key as string | null,
    responseText,
  });

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
    evaluatorStrategy: (contentVersion as Record<string, unknown>).evaluator_strategy,
    itemType: contentItem.item_type as string | null,
    promptJson: contentVersion.prompt_json,
  });

  const defaultPointsAvailable = promptBase.criteria.reduce(
    (sum, criterion) => sum + Number(criterion.points_possible || 0),
    0,
  ) || (contentItem.item_type === "mcq" ? 1 : 0);
  const statisticsDeterministicFallback = routing.target === "llm_text"
    ? buildStatisticsDeterministicFallback({
      contentKey: contentItem.content_key as string | null,
      responseText,
      criteria: promptBase.criteria,
      pointsAvailable: defaultPointsAvailable,
    })
    : null;

  const routedModelId = routing.target === "mcq_rule"
    ? "rule-based-mcq"
    : routing.target === "llm_text"
    ? statisticsDeterministicFallback
      ? "deterministic-statistics-prefilter"
      : OPENAI_MODEL
    : routing.target === "symbolic_ecf"
    ? "symbolic-ecf-verifier"
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
    rubric_version_id: rubricVersionId,
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
      deterministic_verifier_version: MATH_VERIFIER_VERSION,
      boundary_contract_version: verificationProfile?.profile_version ?? null,
      feedback_preview: finalResult.student_facing_summary,
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
      feedbackPreview: finalResult.student_facing_summary,
      actionHint: null,
      repairHint: finalResult.highest_value_gap?.repair_prompt ?? null,
      deterministicCheck: statisticsCheck,
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

  let modelResponse: {
    raw: Record<string, unknown>;
    parsed: Record<string, unknown>;
    elapsedMs: number;
  } | null = null;
  let finalStatus: "graded" | "uncertain" | "failed" = "failed";
  let finalPayload: ReturnType<typeof sanitizeModelResult> |
    ReturnType<typeof buildShadowReviewPayload> |
    NonNullable<ReturnType<typeof buildStatisticsDeterministicFallback>> |
    null = null;
  let inputTokens = estimatedInputTokens;
  let outputTokens = 0;
  let actualCost = 0;

  if (routing.target === "symbolic_ecf") {
    const statisticsItem = findStatisticsItem(
      contentItem.content_key as string | null,
    );
    const typedFormulaAmbiguity = detectAmbiguousTypedFormulaText(responseText);
    const ecfQuestion = coerceEcfQuestion(
      statisticsItem,
      responseParts,
    );
    const ecfResult = ecfQuestion ? buildEcfResult(ecfQuestion) : null;
    const ecfCriteria = ecfResult?.parts.map((part) => ({
      criterion_key: part.part,
      learner_facing_text:
        statisticsItem?.ecf_parts.find((item) => item.id === part.part)?.note ??
          `ECF part ${part.part}`,
      points_possible:
        statisticsItem?.ecf_parts.find((item) => item.id === part.part)?.points ??
          part.points_possible,
      evidence_requirements: null,
      minimum_fix:
        statisticsItem?.ecf_parts.find((item) => item.id === part.part)?.note ??
          "Show the formula and substitutions for this step.",
      accepted_variants: [],
    })) ?? promptBase.criteria;
    const ecfHighestGap = ecfResult?.parts.find((part) =>
      part.verdict !== "CORRECT"
    ) ?? null;
    const ecfSummary = ecfResult
      ? ecfResult.parts.map((part) =>
        `${part.part}: ${part.verdict} (${part.points_awarded}/${part.points_possible})`
      ).join("; ")
      : "The symbolic verifier could not reconstruct a structured ECF payload from the submitted response.";
    const resolvedActionHint = typedFormulaAmbiguity.ambiguous
      ? "show_scaffold"
      : ecfResult?.parts.some((part) =>
          part.verdict === "NAKED_ANSWER" || part.verdict === "CONCEPTUAL_COLLAPSE"
        )
      ? "show_scaffold"
      : "review_context";
    const resolvedRepairHint = typedFormulaAmbiguity.repair_hint ??
      ecfHighestGap?.feedback ??
      null;
    const deterministicCheck = ecfResult
      ? {
        status: ecfResult.parts.every((part) => part.verdict === "CORRECT")
          ? "pass"
          : "flag",
        version: MATH_VERIFIER_VERSION,
        content_key: contentItem.content_key,
        result: ecfResult,
        reason: ecfSummary,
      }
      : statisticsCheck;
    const shadowSummary = statisticsItem
      ? `${statisticsItem.content_key} symbolic/ECF grading is saved for follow-up. ${ecfSummary}`
      : "This response is saved and routed for reviewer follow-up.";
    const shadowReason = [
      routing.reason,
      statisticsItem
        ? `Symbolic formula and ECF boundary executed for ${statisticsItem.content_key}.`
        : "No symbolic verification profile was available for this item, so the response is routed for follow-up.",
      typedFormulaAmbiguity.ambiguous ? typedFormulaAmbiguity.reason : null,
    ].filter(Boolean).join(" ");

    finalPayload = buildShadowReviewPayload({
      criteria: ecfCriteria,
      pointsAvailable: ecfResult?.possible ?? defaultPointsAvailable,
      reason: shadowReason,
      actionHint: resolvedActionHint,
      repairHint: resolveFormulaRepairHint(
        resolvedRepairHint ?? statisticsCheck?.repair_hint,
        ecfHighestGap
          ? {
            minimum_fix:
              statisticsItem?.ecf_parts.find((item) => item.id === ecfHighestGap.part)
                ?.note ?? "Show the missing work.",
            repair_prompt:
              statisticsItem?.ecf_parts.find((item) => item.id === ecfHighestGap.part)
                ?.note ?? "Show the missing work.",
          }
          : null,
      ),
      deterministicCheck,
      summary: `${shadowSummary}${typedFormulaAmbiguity.ambiguous ? ` ${typedFormulaAmbiguity.reason}` : ""}`,
      verificationProfileSummary,
    });
    finalStatus = "uncertain";
    modelResponse = null;
    inputTokens = 0;
    outputTokens = 0;
    actualCost = 0;
  } else if (routing.target === "shadow_review") {
    const verificationProfileSummary = summarizeVerificationProfile(
      verificationProfile,
    );
    const readableVerificationSummary = formatVerificationProfileSummary(
      verificationProfile,
    );
    const typedFormulaAmbiguity = detectAmbiguousTypedFormulaText(responseText);
    const actionHint = statisticsCheck?.status === "flag"
      ? "show_scaffold"
      : resolveFormulaActionHint(typedFormulaAmbiguity.ambiguous);
    const repairHint = resolveFormulaRepairHint(
      statisticsCheck?.repair_hint ?? typedFormulaAmbiguity.repair_hint,
      null,
    );
    const shadowSummary = verificationProfile
      ? `${verificationProfile.display_name} formula feedback is saved and routed for reviewer follow-up. The symbolic verifier is declared but not wired in this phase, so we are holding the item instead of guessing.${typedFormulaAmbiguity.ambiguous ? ` ${typedFormulaAmbiguity.reason}` : ""}`
      : "This response is saved and routed for reviewer follow-up.";
    const shadowReason =
      `${routing.reason} The item is held for human/shadow review until the declared verifier is wired in.${typedFormulaAmbiguity.ambiguous ? ` ${typedFormulaAmbiguity.reason}` : ""}${statisticsCheck?.status === "flag" ? ` Deterministic statistics check: ${statisticsCheck.reason}` : ""}`;
    finalPayload = buildShadowReviewPayload({
      criteria: promptBase.criteria,
      pointsAvailable: defaultPointsAvailable,
      reason: shadowReason,
      actionHint,
      repairHint,
      deterministicCheck: statisticsCheck,
      summary: readableVerificationSummary
        ? `${shadowSummary} Expected checks: ${verificationProfile?.required_checks.map((check) => check.check).join(", ")}.${statisticsCheck?.status === "flag" ? ` Deterministic check flagged the keyed Statistics evidence.` : ""}`
        : shadowSummary,
      verificationProfileSummary,
    });
    finalStatus = "uncertain";
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
      const systemPrompt = GRADING_ARM === "a"
        ? buildCriterionSystemPrompt(examPack.exam_name as string)
        : buildSystemPrompt(examPack.exam_name as string);

      try {
        await service.schema("app").from("grading_results").update({
          status: "processing",
          model_id: routedModelId,
          estimated_cost_usd: reservedCost,
          prompt_version: promptVersion,
          rubric_version_id: rubricVersionId,
          deterministic_verifier_version: MATH_VERIFIER_VERSION,
          boundary_contract_version: verificationProfile?.profile_version ?? null,
        }).eq("request_id", idempotencyKey);

        if (usageRow) {
          await service.schema("app").from("model_usage_ledger").update({
            status: "running",
          }).eq("request_id", idempotencyKey);
        }

        if (GRADING_ARM === "a") {
          const fanOut = await callOpenAIGraderPerCriterion({
            modelId,
            maxOutputTokens: OPENAI_MAX_OUTPUT_TOKENS,
            systemPrompt,
            criteria: promptBase.criteria,
            buildUserPrompt: (criterion) =>
              buildCriterionGradingPrompt({ ...promptBase, criterion }),
            userIdHash: await sha256Hex(user.id),
            idempotencyKey,
          });

          const merged = mergeCriterionResults(
            fanOut.parsed,
            promptBase.criteria,
          );
          finalPayload = sanitizeModelResult(
            merged,
            promptBase.criteria,
            { responseText, responseParts },
          );
          // The summary is composed after sanitization, from the points that
          // actually survived grounding and partial-credit reconciliation --
          // not from the model's raw claims, which those checks may have
          // revised downward.
          finalPayload = {
            ...finalPayload,
            student_facing_summary: composeStudentFacingSummary(
              finalPayload.criteria,
              finalPayload.points_earned,
              finalPayload.points_available,
              finalPayload.highest_value_gap?.minimum_fix ?? null,
            ),
          };

          // One entry per criterion: raw_model_response has to stay auditable,
          // and an item's grading is now N provider responses, not one.
          modelResponse = {
            raw: { arm: "a", criterion_responses: fanOut.raws },
            parsed: merged as Record<string, unknown>,
            elapsedMs: fanOut.elapsedMs,
          };
          inputTokens = fanOut.inputTokens;
          outputTokens = fanOut.outputTokens;
        } else {
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
            { responseText, responseParts },
          );

          const usage = extractUsage(modelResponse.raw);
          inputTokens = usage.inputTokens ?? inputTokens;
          outputTokens = usage.outputTokens ?? outputTokens;
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
      gradeFingerprint: `${idempotencyKey}:${promptVersion}:${rubricVersionId}`,
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
    rubric_version_id: rubricVersionId,
    deterministic_verifier_version: MATH_VERIFIER_VERSION,
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
    repairHint,
    feedbackPreview,
    examPackVersionId: attempt.exam_pack_version_id as string,
    gradingRoute: routing,
    verificationProfile,
    verificationProfileSummary,
    actionHint,
    deterministicCheck: statisticsCheck,
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
        rubricVersionId,
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
});
