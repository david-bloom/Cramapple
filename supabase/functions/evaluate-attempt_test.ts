import {
  buildFallbackCriteria,
  buildShadowReviewPayload,
  pickHighestGap,
  sanitizeModelResult,
} from "./_shared/grading-feedback.ts";
import {
  buildEvaluateAttemptResponse,
  buildEvaluateAttemptResult,
} from "./_shared/evaluate-attempt-response.ts";

Deno.test("buildShadowReviewPayload carries feedback hints into shadow review", () => {
  const payload = buildShadowReviewPayload({
    criteria: [
      {
        criterion_key: "c1",
        learner_facing_text: "Explain the mechanism.",
        points_possible: 1,
        evidence_requirements: null,
        minimum_fix: "Name the missing mechanism.",
        accepted_variants: [],
      },
    ],
    pointsAvailable: 1,
    reason: "Declared verifier is not wired in yet.",
    summary: "Your response is saved and routed for follow-up.",
    actionHint: "show_scaffold",
    repairHint: "Rewrite the fraction with parentheses.",
    deterministicCheck: {
      content_key: "APSTAT-MOD3-H001-INV",
      status: "flag",
      reason: "The response should include the confidence-interval bounds and test statistic from the keyed calculation.",
      repair_hint: "Recompute the standard error with sqrt(n), then update the confidence interval and t-statistic using that corrected value.",
    },
    verificationProfileSummary: {
      subject_key: "ap-statistics",
    },
  });

  if (payload.status !== "uncertain") throw new Error("expected uncertain");
  if (payload.action_hint !== "show_scaffold") {
    throw new Error("expected show_scaffold");
  }
  if (payload.repair_hint !== "Rewrite the fraction with parentheses.") {
    throw new Error("expected repair hint");
  }
  if (!payload.uncertainty_reason?.includes("Verification profile")) {
    throw new Error("expected verification profile summary");
  }
  if (!payload.uncertainty_reason?.includes("Deterministic check")) {
    throw new Error("expected deterministic check summary");
  }
  if (payload.deterministic_check?.status !== "flag") {
    throw new Error("expected deterministic check to be preserved");
  }
});

Deno.test("buildEvaluateAttemptResponse preserves deterministic check in the returned envelope", () => {
  const payload: any = buildEvaluateAttemptResponse({
    status: "uncertain",
    operation: "grade_initial_attempt",
    result: {
      status: "uncertain",
      feedback_preview: "Saved for follow-up.",
      deterministic_check: {
        content_key: "APSTAT-MOD3-H001-INV",
        status: "flag",
      },
    },
    runtimeContext: {
      last_feedback_summary: "Saved for follow-up.",
    },
  });

  if (payload.status !== "uncertain") {
    throw new Error("expected uncertain status");
  }
  if (payload.operation !== "grade_initial_attempt") {
    throw new Error("expected operation");
  }
  if (payload.result.feedback_preview !== "Saved for follow-up.") {
    throw new Error("expected feedback preview");
  }
  if (payload.result.deterministic_check?.status !== "flag") {
    throw new Error("expected deterministic check in the response envelope");
  }
  if (payload.runtime_context?.last_feedback_summary !== "Saved for follow-up.") {
    throw new Error("expected runtime context");
  }
});

Deno.test("buildEvaluateAttemptResult falls back to deterministic check guidance", () => {
  const result: any = buildEvaluateAttemptResult({
    finalPayload: {
      status: "uncertain",
      points_earned: 0,
      points_available: 1,
      criteria: [],
      highest_value_gap: null,
      confidence: "low",
      uncertainty_reason: "Declared verifier is not wired in yet.",
      student_facing_summary: "Saved for follow-up.",
      action_hint: null,
      repair_hint: null,
    },
    actualPointGain: null,
    predictionOutcome: null,
    routedModelId: "shadow-review-placeholder",
    promptVersion: "2026-07-08",
    rubricVersionId: "rubric_1",
    gradingRoute: { target: "shadow_review" },
    verificationProfile: null,
    verificationProfileSummary: null,
    feedbackPreview: "Saved for follow-up.",
    actionHint: null,
    repairHint: null,
    deterministicCheck: {
      content_key: "APSTAT-MOD3-H001-INV",
      status: "flag",
      reason: "The response should include the confidence-interval bounds.",
      repair_hint: "Recompute the interval with the keyed standard error.",
    },
    attemptId: "attempt_1",
    responseVersionId: "response_1",
    requestId: "request_1",
    latencyMs: 0,
  });

  if (result.action_hint !== "show_scaffold") {
    throw new Error("expected deterministic scaffold action");
  }
  if (result.repair_hint !== "Recompute the interval with the keyed standard error.") {
    throw new Error("expected deterministic repair hint");
  }
  if (result.deterministic_check?.status !== "flag") {
    throw new Error("expected deterministic check to be preserved");
  }
});

Deno.test("buildEvaluateAttemptResult stays conservative when deterministic check is not flagged", () => {
  const result: any = buildEvaluateAttemptResult({
    finalPayload: {
      status: "uncertain",
      points_earned: 0,
      points_available: 1,
      criteria: [],
      highest_value_gap: {
        criterion_key: "c1",
        minimum_fix: "Use the keyed interval bounds.",
        repair_prompt: "Use the keyed interval bounds.",
      },
      confidence: "medium",
      uncertainty_reason: "Unable to verify the key calculation.",
      student_facing_summary: "Saved for follow-up.",
      action_hint: null,
      repair_hint: null,
    },
    actualPointGain: null,
    predictionOutcome: null,
    routedModelId: "shadow-review-placeholder",
    promptVersion: "2026-07-08",
    rubricVersionId: "rubric_1",
    gradingRoute: { target: "shadow_review" },
    verificationProfile: null,
    verificationProfileSummary: null,
    feedbackPreview: "Saved for follow-up.",
    actionHint: null,
    repairHint: null,
    deterministicCheck: {
      content_key: "APSTAT-MOD3-H001-INV",
      status: "pass",
      reason: "The keyed check matches the response.",
      repair_hint: "This hint should not be used when the check passes.",
    },
    attemptId: "attempt_1",
    responseVersionId: "response_1",
    requestId: "request_1",
    latencyMs: 0,
  });

  if (result.action_hint !== null) {
    throw new Error("expected no scaffold hint");
  }
  if (result.repair_hint !== "Use the keyed interval bounds.") {
    throw new Error("expected repair hint to come from the gap");
  }
  if (result.deterministic_check?.status !== "pass") {
    throw new Error("expected deterministic check to be preserved");
  }
});

Deno.test("buildEvaluateAttemptResult keeps explicit grader hints over deterministic fallback", () => {
  const result: any = buildEvaluateAttemptResult({
    finalPayload: {
      status: "graded",
      points_earned: 1,
      points_available: 1,
      criteria: [],
      highest_value_gap: {
        criterion_key: "c1",
        minimum_fix: "Use the labeled interval.",
        repair_prompt: "Use the labeled interval.",
      },
      confidence: "high",
      uncertainty_reason: null,
      student_facing_summary: "Correct.",
      action_hint: "review_context",
      repair_hint: "Follow the instructor's labeled interval.",
    },
    actualPointGain: 1,
    predictionOutcome: "matched",
    routedModelId: "deterministic-statistics-prefilter",
    promptVersion: "2026-07-08",
    rubricVersionId: "rubric_1",
    gradingRoute: { target: "llm_text" },
    verificationProfile: null,
    verificationProfileSummary: null,
    feedbackPreview: "Correct.",
    actionHint: "show_scaffold",
    repairHint: "Use the keyed interval bounds.",
    deterministicCheck: {
      content_key: "APSTAT-MOD3-H001-INV",
      status: "flag",
      reason: "The response should include the confidence-interval bounds.",
      repair_hint: "Recompute the interval with the keyed standard error.",
    },
    attemptId: "attempt_1",
    responseVersionId: "response_1",
    requestId: "request_1",
    latencyMs: 0,
  });

  if (result.action_hint !== "review_context") {
    throw new Error("expected explicit grader hint to win");
  }
  if (result.repair_hint !== "Follow the instructor's labeled interval.") {
    throw new Error("expected explicit repair hint to win");
  }
  if (result.deterministic_check?.status !== "flag") {
    throw new Error("expected deterministic check to be preserved");
  }
});

Deno.test("sanitizeModelResult normalizes feedback hints from the model", () => {
  const result = sanitizeModelResult(
    {
      status: "graded",
      points_earned: 1,
      points_available: 1,
      criteria: [
        {
          criterion_key: "c1",
          status: "earned",
          points_awarded: 1,
          evidence_quote: "Correct",
          decision_explanation: "Meets the criterion.",
          minimum_fix: "No fix needed.",
        },
      ],
      highest_value_gap: null,
      predicted_improvement: null,
      confidence: "high",
      uncertainty_reason: null,
      student_facing_summary: "Correct.",
      action_hint: "show_scaffold",
      repair_hint: "  Rewrite with parentheses.  ",
    },
    [
      {
        criterion_key: "c1",
        learner_facing_text: "Explain the mechanism.",
        points_possible: 1,
        evidence_requirements: null,
        minimum_fix: "Name the missing mechanism.",
        accepted_variants: [],
      },
    ],
  );

  if (result.action_hint !== "show_scaffold") {
    throw new Error("expected show_scaffold");
  }
  // grading-sanitizer-v2 intentionally discards the model's free-text
  // repair_hint and derives it only from the validated highest-value gap.
  // With every criterion earned there is no gap, so repair_hint is null.
  if (result.repair_hint !== null) {
    throw new Error("expected model repair_hint to be discarded (gap-derived only)");
  }
  if (result.status !== "graded") {
    throw new Error("expected graded status");
  }
});

Deno.test("pickHighestGap selects the first missing criterion for repair", () => {
  const highestGap = pickHighestGap(
    [
      {
        criterion_key: "c1",
        status: "earned",
        points_awarded: 1,
        evidence_quote: "Correct",
        decision_explanation: "Met.",
        minimum_fix: "No fix needed.",
      },
      {
        criterion_key: "c2",
        status: "not_yet_earned",
        points_awarded: 0,
        evidence_quote: null,
        decision_explanation: "Missing the mechanism.",
        minimum_fix: null,
      },
    ],
    [
      {
        criterion_key: "c1",
        learner_facing_text: "Explain the mechanism.",
        points_possible: 1,
        evidence_requirements: null,
        minimum_fix: "Name the missing mechanism.",
        accepted_variants: [],
      },
      {
        criterion_key: "c2",
        learner_facing_text: "Add the support.",
        points_possible: 1,
        evidence_requirements: null,
        minimum_fix: "Include the supporting step.",
        accepted_variants: [],
      },
    ],
  );

  if (!highestGap) throw new Error("expected highest gap");
  if (highestGap.criterion_key !== "c2") {
    throw new Error("expected first missing criterion");
  }
  if (highestGap.repair_prompt !== "Include the supporting step.") {
    throw new Error("expected source minimum_fix to win");
  }
});

Deno.test("buildFallbackCriteria preserves criterion-specific minimum fixes", () => {
  const fallback = buildFallbackCriteria(
    [
      {
        criterion_key: "c1",
        learner_facing_text: "Explain the mechanism.",
        points_possible: 1,
        evidence_requirements: null,
        minimum_fix: "Name the missing mechanism.",
        accepted_variants: [],
      },
    ],
    "No reliable score is available.",
  );

  if (fallback.length !== 1) throw new Error("expected one fallback row");
  if (fallback[0].decision_explanation !== "No reliable score is available.") {
    throw new Error("expected fallback reason");
  }
  if (fallback[0].minimum_fix !== "Name the missing mechanism.") {
    throw new Error("expected minimum fix");
  }
});
