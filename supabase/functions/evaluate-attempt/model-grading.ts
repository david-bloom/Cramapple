import {
  buildCriterionGradingPrompt,
  buildCriterionSystemPrompt,
  buildGradingPrompt,
  buildSystemPrompt,
  composeStudentFacingSummary,
  extractUsage,
  mergeCriterionResults,
  sanitizeModelResult,
} from "../_shared/grading-contract.ts";
import { OPENAI_MAX_OUTPUT_TOKENS } from "./config.ts";
import {
  callOpenAIGrader,
  callOpenAIGraderPerCriterion,
} from "./openai-client.ts";

// One LLM grading pass, shared by the live path and the QA no-persist path
// (TASK-0079 S2). Both used to carry their own copy of the arm A / arm B branch.
//
// Arm "b" sends one request grading every criterion. Arm "a" sends one request
// per criterion in parallel, merges them, and composes the student-facing
// summary from the points that survived sanitization.

export type GradingArm = "a" | "b";
type PromptBase = Parameters<typeof buildGradingPrompt>[0];

export type ModelResponse = {
  raw: Record<string, unknown>;
  parsed: Record<string, unknown>;
  elapsedMs: number;
};

// Fired once the provider has answered and before sanitization, which can
// throw (for example on a response that is valid JSON but not an object). The
// live path records what it already knows at that point, so a later throw
// keeps exactly the evidence it kept before this function existed: arm B keeps
// the raw response and latency, arm A keeps only the cached-token telemetry.
export type ModelReturnedEvent =
  | { arm: "a"; cachedTokens: number | null }
  | { arm: "b"; response: ModelResponse };

export function buildGraderSystemPrompt(arm: GradingArm, examName: string) {
  return arm === "a"
    ? buildCriterionSystemPrompt(examName)
    : buildSystemPrompt(examName);
}

export async function runModelGrading(input: {
  arm: GradingArm;
  modelId: string;
  systemPrompt: string;
  promptBase: PromptBase;
  sanitizeContext: { responseText: string | null; responseParts: unknown };
  userIdHash: string;
  idempotencyKey: string;
  onModelReturned?: (event: ModelReturnedEvent) => void;
}) {
  const criteria = input.promptBase.criteria;

  if (input.arm === "a") {
    const fanOut = await callOpenAIGraderPerCriterion({
      modelId: input.modelId,
      maxOutputTokens: OPENAI_MAX_OUTPUT_TOKENS,
      systemPrompt: input.systemPrompt,
      criteria,
      buildUserPrompt: (criterion) =>
        buildCriterionGradingPrompt({ ...input.promptBase, criterion }),
      userIdHash: input.userIdHash,
      idempotencyKey: input.idempotencyKey,
    });
    input.onModelReturned?.({ arm: "a", cachedTokens: fanOut.cachedTokens });

    const merged = mergeCriterionResults(fanOut.parsed, criteria);
    const sanitized = sanitizeModelResult(
      merged,
      criteria,
      input.sanitizeContext,
    );
    // The summary is composed after sanitization, from the points that
    // actually survived grounding and partial-credit reconciliation -- not
    // from the model's raw claims, which those checks may have revised
    // downward.
    const finalPayload = {
      ...sanitized,
      student_facing_summary: composeStudentFacingSummary(
        sanitized.criteria,
        sanitized.points_earned,
        sanitized.points_available,
        sanitized.highest_value_gap?.minimum_fix ?? null,
      ),
    };

    return {
      finalPayload,
      // One entry per criterion: raw_model_response has to stay auditable, and
      // an item's grading is N provider responses, not one.
      response: {
        raw: { arm: "a", criterion_responses: fanOut.raws },
        parsed: merged as Record<string, unknown>,
        elapsedMs: fanOut.elapsedMs,
      } as ModelResponse,
      inputTokens: fanOut.inputTokens as number | null,
      outputTokens: fanOut.outputTokens as number | null,
      cachedTokens: fanOut.cachedTokens,
    };
  }

  const response: ModelResponse = await callOpenAIGrader({
    modelId: input.modelId,
    maxOutputTokens: OPENAI_MAX_OUTPUT_TOKENS,
    systemPrompt: input.systemPrompt,
    userPrompt: buildGradingPrompt(input.promptBase),
    userIdHash: input.userIdHash,
    idempotencyKey: input.idempotencyKey,
  });
  input.onModelReturned?.({ arm: "b", response });

  const finalPayload = sanitizeModelResult(
    response.parsed,
    criteria,
    input.sanitizeContext,
  );
  // Null means the provider did not report the field; each caller picks its
  // own fallback, as before.
  const usage = extractUsage(response.raw);
  return {
    finalPayload,
    response,
    inputTokens: usage.inputTokens,
    outputTokens: usage.outputTokens,
    cachedTokens: usage.cachedTokens,
  };
}
