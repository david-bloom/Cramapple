import type { AllowedOperation } from "./grading-contract.ts";
import { resolveFormulaRepairHint } from "./formula-notation.ts";

export function buildEvaluateAttemptResponse(input: {
  status: "graded" | "uncertain" | "failed";
  operation: AllowedOperation | string;
  result: Record<string, unknown>;
  runtimeContext: Record<string, unknown> | null;
}) {
  return {
    status: input.status,
    function: "evaluate-attempt",
    operation: input.operation,
    result: input.result,
    runtime_context: input.runtimeContext,
  };
}

export function buildEvaluateAttemptResult(input: {
  finalPayload: Record<string, unknown> & {
    points_earned: number | null;
    points_available: number | null;
    criteria: Array<Record<string, unknown>>;
    highest_value_gap?: Record<string, unknown> | null;
    predicted_improvement?: { label: string; predicted_point_gain: number } | null;
    confidence: string | null;
    uncertainty_reason: string | null;
    student_facing_summary: string;
    action_hint?: string | null;
    repair_hint?: string | null;
  };
  actualPointGain: number | null;
  predictionOutcome: string | null;
  routedModelId: string;
  promptVersion: string;
  rubricVersionId: string;
  gradingRoute: Record<string, unknown>;
  verificationProfile: Record<string, unknown> | null;
  verificationProfileSummary: Record<string, unknown> | null;
  feedbackPreview: string;
  actionHint: string | null;
  repairHint: string | null;
  repairPlan?: Record<string, unknown> | null;
  deterministicCheck: Record<string, unknown> | null;
  attemptId: string;
  responseVersionId: string;
  requestId: string;
  latencyMs: number;
}) {
  const highestValueGap = input.finalPayload.highest_value_gap ?? null;
  const deterministicRepairHint =
    input.deterministicCheck?.status === "flag"
      ? input.deterministicCheck?.repair_hint
      : null;
  const resolvedActionHint = input.finalPayload.action_hint ??
    (input.deterministicCheck?.status === "flag" ? "show_scaffold" : null) ??
    input.actionHint;
  const resolvedRepairHint = resolveFormulaRepairHint(
    input.finalPayload.repair_hint ?? deterministicRepairHint ?? input.repairHint,
    highestValueGap,
  );

  return {
    ...input.finalPayload,
    actual_point_gain: input.actualPointGain,
    prediction_outcome: input.predictionOutcome,
    model_id: input.routedModelId,
    prompt_version: input.promptVersion,
    rubric_version_id: input.rubricVersionId,
    grading_route: input.gradingRoute,
    verification_profile: input.verificationProfile,
    verification_profile_summary: input.verificationProfileSummary,
    feedback_preview: input.feedbackPreview,
    action_hint: resolvedActionHint,
    repair_hint: resolvedRepairHint,
    repair_plan: input.repairPlan ?? null,
    deterministic_check: input.deterministicCheck,
    attempt_id: input.attemptId,
    response_version_id: input.responseVersionId,
    request_id: input.requestId,
    latency_ms: input.latencyMs,
  };
}
