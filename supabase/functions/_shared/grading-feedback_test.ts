import {
  buildShadowReviewPayload,
  pickHighestGap,
  sanitizeModelResult,
} from "./grading-feedback.ts";

const sourceCriteria = [
  {
    criterion_key: "setup",
    learner_facing_text: "Set up the calculation.",
    points_possible: 1,
    evidence_requirements: "A valid setup",
    minimum_fix: "Write the correct setup.",
    accepted_variants: [],
    prerequisite_leverage: 3,
  },
  {
    criterion_key: "answer",
    learner_facing_text: "Give the final answer.",
    points_possible: 2,
    evidence_requirements: "The answer 20",
    minimum_fix: "Correct the final answer.",
    accepted_variants: [],
  },
];

Deno.test("buildShadowReviewPayload preserves deterministic check provenance", () => {
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
      reason:
        "The response should include the confidence-interval bounds and test statistic from the keyed calculation.",
      repair_hint:
        "Recompute the standard error with sqrt(n), then update the confidence interval and t-statistic using that corrected value.",
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

Deno.test("sanitizeModelResult reconciles reordered criteria by canonical key", () => {
  const result = sanitizeModelResult({
    status: "graded",
    points_earned: 999,
    points_available: 999,
    criteria: [
      {
        criterion_key: "answer",
        status: "earned",
        points_awarded: 2,
        evidence_quote: "20",
      },
      {
        criterion_key: "setup",
        status: "earned",
        points_awarded: 1,
        evidence_quote: "10 + 10",
      },
    ],
  }, sourceCriteria, { responseText: "10 + 10 = 20" });

  if (result.criteria[0].criterion_key !== "setup") {
    throw new Error("criteria must retain canonical rubric order");
  }
  if (result.points_earned !== 3 || result.points_available !== 3) {
    throw new Error("totals must be recomputed from sanitized canonical criteria");
  }
  if (result.status !== "graded" || result.integrity_issues.length !== 0) {
    throw new Error("valid reordered output should grade cleanly");
  }
});

Deno.test("sanitizeModelResult fails closed on duplicate keys and ignores unknown keys", () => {
  const result = sanitizeModelResult({
    criteria: [
      { criterion_key: "setup", status: "earned", points_awarded: 1, evidence_quote: "setup" },
      { criterion_key: "setup", status: "earned", points_awarded: 1, evidence_quote: "setup" },
      { criterion_key: "invented", status: "earned", points_awarded: 50, evidence_quote: "setup" },
      { criterion_key: "answer", status: "earned", points_awarded: 2, evidence_quote: "20" },
    ],
  }, sourceCriteria, { responseText: "setup gives 20" });

  if (result.points_earned !== 2 || result.status !== "uncertain") {
    throw new Error("ambiguous and unknown criteria must not influence credit");
  }
  const codes = result.integrity_issues.map((issue) => issue.code);
  if (!codes.includes("criterion_duplicate") || !codes.includes("criterion_unknown")) {
    throw new Error("duplicate and unknown keys must be reported");
  }
});

Deno.test("sanitizeModelResult requires exact grounded evidence for earned credit", () => {
  const result = sanitizeModelResult({
    criteria: [
      { criterion_key: "setup", status: "earned", points_awarded: 1, evidence_quote: "fabricated setup" },
      { criterion_key: "answer", status: "earned", points_awarded: 1, evidence_quote: "20" },
    ],
  }, sourceCriteria, { responseText: "The answer is 20." });

  if (result.points_earned !== 0 || result.status !== "uncertain") {
    throw new Error("ungrounded evidence and earned/points contradictions must fail closed");
  }
  const codes = result.integrity_issues.map((issue) => issue.code);
  if (!codes.includes("evidence_not_found") || !codes.includes("earned_points_mismatch")) {
    throw new Error("both evidence and point-integrity failures should be visible");
  }
});

Deno.test("pickHighestGap uses value, prerequisite leverage, and effort", () => {
  const gap = pickHighestGap([
    {
      criterion_key: "setup",
      status: "not_yet_earned",
      points_awarded: 0,
      evidence_quote: null,
      decision_explanation: null,
      minimum_fix: null,
    },
    {
      criterion_key: "answer",
      status: "not_yet_earned",
      points_awarded: 0,
      evidence_quote: null,
      decision_explanation: null,
      minimum_fix: null,
    },
  ], sourceCriteria);

  if (gap?.criterion_key !== "setup") {
    throw new Error("the prerequisite criterion should outrank the larger downstream point");
  }
});
