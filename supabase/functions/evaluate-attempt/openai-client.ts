import {
  buildCriterionRequestBody,
  buildGradingRequestBody,
  extractOutputText,
  extractUsage,
  type FeedbackCriterionRow,
  isTransientHttpStatus,
} from "../_shared/grading-contract.ts";
import { OPENAI_API_KEY, OPENAI_REQUEST_TIMEOUT_MS } from "./config.ts";

// OpenAI Responses API client for the grader (TASK-0079 S1: moved verbatim
// from index.ts).

// Sentinel error thrown when a transient failure is worth retrying once.
// Non-transient errors (4xx other than 429, JSON parse failures, schema
// violations) are thrown directly and not retried.
export class TransientGraderError extends Error {
  constructor(message: string, public override readonly cause?: unknown) {
    super(message);
    this.name = "TransientGraderError";
  }
}

export async function attemptOpenAICall(input: {
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

export async function callOpenAIGrader(input: {
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
export async function callOpenAIGraderPerCriterion(input: {
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
      const idempotencyKey =
        `${input.idempotencyKey}:${criterion.criterion_key}`;

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
  // Null until any call reports the field: "the provider said 0 cached"
  // and "the provider said nothing" must stay distinguishable (extractUsage
  // convention).
  let cachedTokens: number | null = null;
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
    if (usage.cachedTokens !== null) {
      cachedTokens = (cachedTokens ?? 0) + usage.cachedTokens;
    }
    maxElapsedMs = Math.max(maxElapsedMs, outcome.elapsedMs);
  }

  // Every criterion failing is an item-level failure, not a gradeable result
  // with N abstentions. Throwing puts it on the same error path Arm B uses.
  if (failures.length === input.criteria.length && input.criteria.length > 0) {
    throw failures[0];
  }

  return {
    parsed,
    raws,
    inputTokens,
    outputTokens,
    cachedTokens,
    elapsedMs: maxElapsedMs,
  };
}
