import { checkStatisticsDeterministicEvidence } from "./statistics-verifier.ts";
import { buildStatisticsDeterministicFallback } from "./statistics-verifier.ts";

Deno.test("passes the canonical AP Statistics numeric response", () => {
  const result = checkStatisticsDeterministicEvidence({
    contentKey: "APSTAT-MOD3-H001-INV",
    responseText:
      "SE = 120/sqrt(30) = 21.9; CI = 850 ± 1.96(21.9) = (807, 893); t = 2.28.",
  });

  if (!result) throw new Error("expected result");
  if (result.status !== "pass") throw new Error("expected pass");
});

Deno.test("passes a t*-based AP Statistics confidence interval (z-vs-t boundary)", () => {
  const result = checkStatisticsDeterministicEvidence({
    contentKey: "APSTAT-MOD3-H001-INV",
    responseText:
      "SE = 120/sqrt(30) = 21.9; CI = 850 ± 2.045(21.9) = (805.2, 894.8); t = 2.28.",
  });

  if (!result) throw new Error("expected result");
  if (result.status !== "pass") {
    throw new Error("expected pass: t* (df=29) is within tolerance of z*");
  }
});

Deno.test("flags the known wrong AP Statistics confidence-interval response", () => {
  const result = checkStatisticsDeterministicEvidence({
    contentKey: "APSTAT-MOD3-H001-INV",
    responseText:
      "SE = 120/30 = 4; CI = 850 ± 1.96(4) = 850 ± 7.84 = (842.16, 857.84).",
  });

  if (!result) throw new Error("expected result");
  if (result.status !== "flag") throw new Error("expected flag");
  if (!result.repair_hint?.includes("sqrt")) {
    throw new Error("expected repair hint");
  }
});

Deno.test("builds a deterministic fallback for the known wrong Statistics response", () => {
  const result = buildStatisticsDeterministicFallback({
    contentKey: "APSTAT-MOD3-H001-INV",
    responseText:
      "SE = 120/30 = 4; CI = 850 ± 1.96(4) = 850 ± 7.84 = (842.16, 857.84).",
    criteria: [
      {
        criterion_key: "ci_calculation",
        learner_facing_text: "Compute the interval.",
        points_possible: 1,
        evidence_requirements: null,
        minimum_fix: "Use sqrt(n).",
        accepted_variants: [],
      },
    ],
    pointsAvailable: 1,
  });

  if (!result) throw new Error("expected fallback");
  if (result.status !== "uncertain") throw new Error("expected uncertain");
  if (result.action_hint !== "show_scaffold") {
    throw new Error("expected scaffold hint");
  }
  if (!result.deterministic_check || result.deterministic_check.status !== "flag") {
    throw new Error("expected deterministic check");
  }
});

Deno.test("does not build a deterministic fallback for the canonical Statistics response", () => {
  const result = buildStatisticsDeterministicFallback({
    contentKey: "APSTAT-MOD3-H001-INV",
    responseText:
      "SE = 120/sqrt(30) = 21.9; CI = 850 ± 1.96(21.9) = (807, 893); t = 2.28.",
    criteria: [
      {
        criterion_key: "ci_calculation",
        learner_facing_text: "Compute the interval.",
        points_possible: 1,
        evidence_requirements: null,
        minimum_fix: "Use sqrt(n).",
        accepted_variants: [],
      },
    ],
    pointsAvailable: 1,
  });

  if (result !== null) throw new Error("expected no fallback");
});

Deno.test("flags the known wrong AP Statistics t statistic response", () => {
  const result = checkStatisticsDeterministicEvidence({
    contentKey: "APSTAT-MOD6-H001",
    responseText:
      "t = (76-72)/sqrt((8^2/30)+(7^2/30)) ≈ 1.86, so fail to reject H0.",
  });

  if (!result) throw new Error("expected result");
  if (result.status !== "flag") throw new Error("expected flag");
});

Deno.test("passes a flipped-sign t-statistic (non-directional H1, order-of-subtraction artifact)", () => {
  const result = checkStatisticsDeterministicEvidence({
    contentKey: "APSTAT-MOD6-H001",
    responseText:
      "t = (76-72)/sqrt((8^2/30)+(7^2/30)) ≈ 1.94; t = +2.06, so reject H0.",
  });

  if (!result) throw new Error("expected result");
  if (result.status !== "pass") {
    throw new Error("expected pass: sign is arbitrary for a two-tailed test");
  }
});

Deno.test("still flags a wrong-magnitude t-statistic regardless of sign", () => {
  const result = checkStatisticsDeterministicEvidence({
    contentKey: "APSTAT-MOD6-H001",
    responseText:
      "t = -1.86, so fail to reject H0.",
  });

  if (!result) throw new Error("expected result");
  if (result.status !== "flag") throw new Error("expected flag");
});

Deno.test("passes the AP Statistics raffle payoff numeric response", () => {
  const result = checkStatisticsDeterministicEvidence({
    contentKey: "APSTATS-SFRQ-008",
    responseText: "EV = 1.8 and SD ≈ 4.9.",
  });

  if (!result) throw new Error("expected result");
  if (result.status !== "pass") throw new Error("expected pass");
});

Deno.test("flags the raffle payoff response against the previously-wrong keyed values", () => {
  // Regression test for a real bug: the deterministic key used to be
  // [3.2, 5.0], which did not match the published canonical_answer_1
  // ([1.8, 4.9]) and would have flagged a fully correct student response.
  const result = checkStatisticsDeterministicEvidence({
    contentKey: "APSTATS-SFRQ-008",
    responseText: "EV = 3.2 and SD ≈ 5.0.",
  });

  if (!result) throw new Error("expected result");
  if (result.status !== "flag") {
    throw new Error("expected flag: 3.2/5.0 no longer matches the corrected key");
  }
});

Deno.test("passes the AP Statistics regression prediction and residual response", () => {
  const result = checkStatisticsDeterministicEvidence({
    contentKey: "APSTATS-SFRQ-003",
    responseText: "Prediction = 76.6 and residual = -2.6.",
  });

  if (!result) throw new Error("expected result");
  if (result.status !== "pass") throw new Error("expected pass");
});

Deno.test("passes the AP Statistics screen-time regression response", () => {
  const result = checkStatisticsDeterministicEvidence({
    contentKey: "APSTATS-SFRQ-004",
    responseText: "Prediction = 5.25 and residual = -0.25.",
  });

  if (!result) throw new Error("expected result");
  if (result.status !== "pass") throw new Error("expected pass");
});

Deno.test("passes the AP Statistics sampling-distribution proportion response", () => {
  const result = checkStatisticsDeterministicEvidence({
    contentKey: "APSTATS-SFRQ-009",
    responseText: "Mean = 0.28 and SD = 0.0225.",
  });

  if (!result) throw new Error("expected result");
  if (result.status !== "pass") throw new Error("expected pass");
});

Deno.test("passes the AP Statistics sampling-distribution mean response", () => {
  const result = checkStatisticsDeterministicEvidence({
    contentKey: "APSTATS-SFRQ-010",
    responseText: "Mean = 7.2 and SD = 0.3.",
  });

  if (!result) throw new Error("expected result");
  if (result.status !== "pass") throw new Error("expected pass");
});

Deno.test("passes the AP Statistics descriptive-stats median/mean response", () => {
  const result = checkStatisticsDeterministicEvidence({
    contentKey: "APSTATS-SFRQ-001",
    responseText: "Median = 22 minutes; mean ≈ 23.7 minutes.",
  });

  if (!result) throw new Error("expected result");
  if (result.status !== "pass") throw new Error("expected pass");
});

Deno.test("passes the AP Statistics z-score comparison response", () => {
  const result = checkStatisticsDeterministicEvidence({
    contentKey: "APSTATS-SFRQ-002",
    responseText: "z_A = 1.5 and z_B = 2.5, so Quiz B was relatively better.",
  });

  if (!result) throw new Error("expected result");
  if (result.status !== "pass") throw new Error("expected pass");
});

Deno.test("passes the AP Statistics binomial mean/sd/probability response", () => {
  const result = checkStatisticsDeterministicEvidence({
    contentKey: "APSTATS-SFRQ-007",
    responseText: "mean = 5, SD ≈ 1.94, P(X=5) ≈ 0.202.",
  });

  if (!result) throw new Error("expected result");
  if (result.status !== "pass") throw new Error("expected pass");
});

Deno.test("passes the AP Statistics one-proportion CI response", () => {
  const result = checkStatisticsDeterministicEvidence({
    contentKey: "APSTATS-SFRQ-011",
    responseText: "p-hat = 0.70, interval = (0.618, 0.782).",
  });

  if (!result) throw new Error("expected result");
  if (result.status !== "pass") throw new Error("expected pass");
});

Deno.test("passes the AP Statistics one-proportion z-test response", () => {
  const result = checkStatisticsDeterministicEvidence({
    contentKey: "APSTATS-SFRQ-012",
    responseText: "z = 2.40, p-value ≈ 0.008, reject H0.",
  });

  if (!result) throw new Error("expected result");
  if (result.status !== "pass") throw new Error("expected pass");
});

Deno.test("passes the AP Statistics one-sample t-test and CI response", () => {
  const result = checkStatisticsDeterministicEvidence({
    contentKey: "APSTATS-SFRQ-013",
    responseText: "t = 2.00, interval = (69.7, 78.3).",
  });

  if (!result) throw new Error("expected result");
  if (result.status !== "pass") throw new Error("expected pass");
});

Deno.test("passes the AP Statistics matched-pairs t response", () => {
  const result = checkStatisticsDeterministicEvidence({
    contentKey: "APSTATS-SFRQ-014",
    responseText: "t ≈ 7.00, p-value very small, reject H0.",
  });

  if (!result) throw new Error("expected result");
  if (result.status !== "pass") throw new Error("expected pass");
});

Deno.test("passes the AP Statistics goodness-of-fit chi-square response", () => {
  const result = checkStatisticsDeterministicEvidence({
    contentKey: "APSTATS-SFRQ-015",
    responseText: "Expected count = 25 for each color; chi-square = 3.12.",
  });

  if (!result) throw new Error("expected result");
  if (result.status !== "pass") throw new Error("expected pass");
});

Deno.test("passes the AP Statistics independence chi-square response", () => {
  const result = checkStatisticsDeterministicEvidence({
    contentKey: "APSTATS-SFRQ-016",
    responseText: "Expected count = 15; chi-square = 2.40.",
  });

  if (!result) throw new Error("expected result");
  if (result.status !== "pass") throw new Error("expected pass");
});

Deno.test("passes the AP Statistics regression slope t-test response", () => {
  const result = checkStatisticsDeterministicEvidence({
    contentKey: "APSTATS-SFRQ-017",
    responseText: "t ≈ 4.73, slope ≈ 5.2 points per hour.",
  });

  if (!result) throw new Error("expected result");
  if (result.status !== "pass") throw new Error("expected pass");
});

Deno.test("passes the AP Statistics regression slope CI response", () => {
  const result = checkStatisticsDeterministicEvidence({
    contentKey: "APSTATS-SFRQ-018",
    responseText: "95% CI for the slope: (-3.65, -1.15).",
  });

  if (!result) throw new Error("expected result");
  if (result.status !== "pass") throw new Error("expected pass");
});

Deno.test("flags a sign-flipped AP Statistics regression slope CI response", () => {
  const result = checkStatisticsDeterministicEvidence({
    contentKey: "APSTATS-SFRQ-018",
    responseText: "95% CI for the slope: (1.15, 3.65).",
  });

  if (!result) throw new Error("expected result");
  if (result.status !== "flag") {
    throw new Error("expected flag: the slope CI is sign-sensitive");
  }
});

Deno.test("abstains on the purely conceptual AP Statistics SFRQ items", () => {
  const sampling = checkStatisticsDeterministicEvidence({
    contentKey: "APSTATS-SFRQ-005",
    responseText: "This is a convenience sample with self-selection bias.",
  });
  if (!sampling) throw new Error("expected result");
  if (sampling.status !== "abstain") throw new Error("expected abstain");

  const experiment = checkStatisticsDeterministicEvidence({
    contentKey: "APSTATS-SFRQ-006",
    responseText: "Random assignment supports a cause-and-effect conclusion.",
  });
  if (!experiment) throw new Error("expected result");
  if (experiment.status !== "abstain") throw new Error("expected abstain");
});

Deno.test("abstains on the conceptual Statistics item and corpus defect item", () => {
  const conceptual = checkStatisticsDeterministicEvidence({
    contentKey: "APSTAT-MOD5-H001-INV",
    responseText: "Correlation does not imply causation.",
  });
  if (!conceptual) throw new Error("expected conceptual result");
  if (conceptual.status !== "abstain") throw new Error("expected abstain");

  const defect = checkStatisticsDeterministicEvidence({
    contentKey: "APSTAT-MOD8-H001",
    responseText: "r = 0.82",
  });
  if (!defect) throw new Error("expected defect result");
  if (defect.status !== "abstain") throw new Error("expected abstain");
});
