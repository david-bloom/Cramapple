import { buildEvaluateAttemptResult } from "./evaluate-attempt-response.ts";

Deno.test("evaluate-attempt result exposes grade-locked repair provenance", () => {
  const result = buildEvaluateAttemptResult({
    finalPayload: {
      points_earned: 0,
      points_available: 1,
      criteria: [],
      confidence: "high",
      uncertainty_reason: null,
      student_facing_summary: "Revise one part.",
    },
    actualPointGain: null,
    predictionOutcome: null,
    routedModelId: "model",
    promptVersion: "prompt",
    rubricVersionId: "rubric",
    gradingRoute: {},
    verificationProfile: null,
    verificationProfileSummary: null,
    feedbackPreview: "Revise one part.",
    actionHint: null,
    repairHint: null,
    repairPlan: { grade_fingerprint: "grade-1", criterion_key: "c1" },
    deterministicCheck: null,
    attemptId: "attempt",
    responseVersionId: "response",
    requestId: "request",
    latencyMs: 1,
  });
  const repair = result.repair_plan as Record<string, unknown>;
  if (repair.grade_fingerprint !== "grade-1" || repair.criterion_key !== "c1") {
    throw new Error("repair provenance must survive the response boundary");
  }
});
