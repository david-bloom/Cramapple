import { buildFallbackCriteria, type FeedbackCriterionRow } from "./grading-feedback.ts";

type StatisticsCheckStatus = "pass" | "flag" | "abstain";

type StatisticsCheck = {
  content_key: string;
  status: StatisticsCheckStatus;
  reason: string;
  repair_hint: string | null;
};

type NumericTarget = {
  value: number;
  sign_sensitive?: boolean;
};

const DEFAULT_REL_TOL = 0.02;

const STATISTICS_TARGETS: Record<
  string,
  {
    reason: string;
    repair_hint: string;
    values: NumericTarget[];
  } | null
> = {
  "APSTAT-MOD3-H001-INV": {
    reason:
      "The response should include the confidence-interval bounds and test statistic from the keyed calculation.",
    repair_hint:
      "Recompute the standard error with sqrt(n), then update the confidence interval and t-statistic using that corrected value.",
    // SE (21.9089) intentionally NOT required as its own bare value here.
    // The rubric's own learner_facing_text only asks for the CI bounds --
    // "Correctly calculates 95% CI as 850 +/- 1.96(120/sqrt(30)) ~ (808,
    // 892)" -- not a separately-typed SE. A response that expresses SE
    // symbolically (e.g. "120/sqrt(30)") instead of evaluating it to a
    // decimal was being hard-flagged and zero-credited by this check even
    // when CI_low/CI_high were both numerically correct -- and correct CI
    // bounds mathematically imply a correct SE, since CI_low/CI_high are
    // computed directly from it, so the explicit SE check was redundant on
    // top of being over-strict. Confirmed against a real provisional-
    // labeled-"earned" case in provisional_labels.json (response_index 2)
    // that this check was wrongly flagging before this fix (2026-07-12).
    values: [
      { value: 807.05863 },
      { value: 892.94137 },
      { value: 2.28217 },
    ],
  },
  "APSTAT-MOD5-H001-INV": null,
  "APSTAT-MOD6-H001": {
    reason:
      "The response should include the keyed two-sample test statistic.",
    repair_hint:
      "Recompute the pooled standard error with the keyed sample sizes, then recalculate the t-statistic on that value.",
    // SE_diff (1.94079) intentionally not required as its own bare value,
    // same reasoning as APSTAT-MOD3-H001-INV above: the rubric only asks
    // for "t-statistic and degrees of freedom," and t_stat = (m1-m2)/SE_diff
    // with m1/m2 fixed constants means a correct t_stat mathematically
    // implies a correct SE_diff -- the explicit check was redundant and,
    // confirmed against a real provisional-labeled-"earned" case
    // (response_index 1, "sqrt(sum of variances)" expressed symbolically,
    // t given as a rounded range "2.0 to 2.1" -- only the 2.1 endpoint is
    // within the 2% tolerance on 2.06104 (2.0 misses it), but matchesTarget
    // only needs one number in the response to hit, so this response
    // already passes on t_stat alone), was wrongly zero-crediting a
    // correct response over an intermediate value the rubric never asked
    // to see restated. (Corrected 2026-07-12 after independent re-QA
    // caught the original comment overstating that both range endpoints
    // passed -- verified by hand: |2.0-2.06104|=0.061 > tol 0.041.)
    values: [
      { value: 2.06104 },
    ],
  },
  "APSTAT-MOD7-H001": {
    reason:
      "The response should include the keyed probability values for the Bayes calculation.",
    repair_hint:
      "Recompute the total probability first, then use it in the Bayes posterior.",
    values: [
      { value: 0.023 },
      { value: 0.65217 },
    ],
  },
  "APSTATS-SFRQ-008": {
    reason:
      "The response should include the keyed expected value and standard deviation for the raffle payoff.",
    repair_hint:
      "Recompute the expected value from the weighted payoffs, then use the same payoff table to find the standard deviation.",
    values: [
      { value: 1.8 },
      { value: 4.9 },
    ],
  },
  "APSTATS-SFRQ-003": {
    reason:
      "The response should include the keyed regression prediction and residual.",
    repair_hint:
      "Recompute the prediction from the regression line, then subtract it from the observed score to find the residual.",
    values: [
      { value: 76.6 },
      { value: -2.6, sign_sensitive: true },
    ],
  },
  "APSTATS-SFRQ-004": {
    reason:
      "The response should include the keyed regression prediction and residual.",
    repair_hint:
      "Recompute the prediction from the regression line, then subtract it from the observed sleep time to find the residual.",
    values: [
      { value: 5.25 },
      { value: -0.25, sign_sensitive: true },
    ],
  },
  "APSTATS-SFRQ-009": {
    reason:
      "The response should include the keyed mean and standard deviation of the sampling distribution.",
    repair_hint:
      "Recompute the sampling-distribution mean and standard deviation from the declared p and n.",
    values: [
      { value: 0.28 },
      { value: 0.0225 },
    ],
  },
  "APSTATS-SFRQ-010": {
    reason:
      "The response should include the keyed mean and standard deviation of the sampling distribution.",
    repair_hint:
      "Recompute the sampling-distribution mean and standard deviation from the declared mu and n.",
    values: [
      { value: 7.2 },
      { value: 0.3 },
    ],
  },
  "APSTAT-MOD8-H001": null,
  // The entries below (SFRQ-001, 002, 005, 006, 007, 011-018) extend
  // deterministic coverage to the remaining published AP Statistics SFRQ
  // items. Values are read directly off each item's published
  // canonical_answer_1 field. Freshly authored 2026-07-10, not yet reviewed
  // by Learning Quality and not yet run against an adjudicated gold set —
  // same development-tier caveat as the rest of this file.
  "APSTATS-SFRQ-001": {
    reason:
      "The response should include the keyed median and mean commute times.",
    repair_hint:
      "Recompute the median (middle value) and the mean (sum divided by count) from the data set.",
    values: [
      { value: 22 },
      { value: 23.7 },
    ],
  },
  "APSTATS-SFRQ-002": {
    reason: "The response should include both keyed z-scores.",
    repair_hint:
      "Recompute each z-score as (score - mean) / standard deviation for its own quiz.",
    values: [
      { value: 1.5 },
      { value: 2.5 },
    ],
  },
  "APSTATS-SFRQ-005": null,
  "APSTATS-SFRQ-006": null,
  "APSTATS-SFRQ-007": {
    reason:
      "The response should include the keyed binomial mean, standard deviation, and probability.",
    repair_hint:
      "Recompute the mean as n*p, the standard deviation as sqrt(n*p*(1-p)), and P(X=5) from the binomial formula.",
    values: [
      { value: 5 },
      { value: 1.94 },
      { value: 0.202 },
    ],
  },
  "APSTATS-SFRQ-011": {
    reason:
      "The response should include the keyed sample proportion and confidence-interval bounds.",
    repair_hint:
      "Recompute p-hat from the counts, then rebuild the interval as p-hat plus or minus the margin of error.",
    values: [
      { value: 0.70 },
      { value: 0.618 },
      { value: 0.782 },
    ],
  },
  "APSTATS-SFRQ-012": {
    reason: "The response should include the keyed z-statistic and p-value.",
    repair_hint:
      "Recompute z from the sample proportion and hypothesized proportion, then find the matching p-value.",
    values: [
      { value: 2.40 },
      { value: 0.008 },
    ],
  },
  "APSTATS-SFRQ-013": {
    reason:
      "The response should include the keyed t-statistic and confidence-interval bounds.",
    repair_hint:
      "Recompute t from x-bar, mu0, s, and n, then rebuild the interval as x-bar plus or minus the margin of error.",
    values: [
      { value: 2.00 },
      { value: 69.7 },
      { value: 78.3 },
    ],
  },
  "APSTATS-SFRQ-014": {
    reason:
      "The response should include the keyed matched-pairs t-statistic.",
    repair_hint:
      "Recompute t from the mean and standard deviation of the within-student differences.",
    values: [
      { value: 7.00 },
    ],
  },
  "APSTATS-SFRQ-015": {
    reason:
      "The response should include the keyed expected count and chi-square statistic.",
    repair_hint:
      "Recompute the expected count under equal probability, then sum (observed-expected)^2/expected across all categories.",
    values: [
      { value: 25 },
      { value: 3.12 },
    ],
  },
  "APSTATS-SFRQ-016": {
    reason:
      "The response should include the keyed expected count and chi-square statistic.",
    repair_hint:
      "Recompute the expected count from the row and column totals, then sum (observed-expected)^2/expected across all cells.",
    values: [
      { value: 15 },
      { value: 2.40 },
    ],
  },
  "APSTATS-SFRQ-017": {
    reason: "The response should include the keyed t-statistic and slope.",
    repair_hint:
      "Recompute t from the slope and its standard error, and restate the slope from the regression output.",
    values: [
      { value: 4.73 },
      { value: 5.2 },
    ],
  },
  "APSTATS-SFRQ-018": {
    reason:
      "The response should include the keyed confidence-interval bounds for the slope.",
    repair_hint:
      "Recompute the interval as the sample slope plus or minus the margin of error, keeping the sign of the slope.",
    values: [
      { value: -3.65, sign_sensitive: true },
      { value: -1.15, sign_sensitive: true },
    ],
  },
};

function extractNumbers(text: string) {
  const cleaned = text.replace(/,/g, "");
  const matches = cleaned.match(/[+-]?\d*\.?\d+(?:e[+-]?\d+)?/gi) ?? [];
  return matches
    .map((value) => Number(value))
    .filter((value) => Number.isFinite(value));
}

function matchesTarget(candidate: number, target: NumericTarget) {
  if (target.sign_sensitive && Math.sign(candidate) !== Math.sign(target.value)) {
    return false;
  }

  const base = Math.abs(target.value);
  if (base === 0) {
    return Math.abs(candidate) < 1e-12;
  }

  return Math.abs(Math.abs(candidate) - base) <= base * DEFAULT_REL_TOL;
}

export function checkStatisticsDeterministicEvidence(input: {
  contentKey?: string | null;
  responseText?: string | null;
}): StatisticsCheck | null {
  const contentKey = input.contentKey?.trim();
  if (!contentKey) return null;

  const target = STATISTICS_TARGETS[contentKey];
  if (target === undefined) return null;
  if (target === null) {
    return {
      content_key: contentKey,
      status: "abstain",
      reason: "This item is conceptual or corpus-defective for numeric checking.",
      repair_hint: null,
    };
  }

  const responseText = input.responseText?.trim();
  if (!responseText) {
    return {
      content_key: contentKey,
      status: "flag",
      reason: target.reason,
      repair_hint: target.repair_hint,
    };
  }

  const numbers = extractNumbers(responseText);
  const allPresent = target.values.every((item) =>
    numbers.some((candidate) => matchesTarget(candidate, item))
  );

  return {
    content_key: contentKey,
    status: allPresent ? "pass" : "flag",
    reason: target.reason,
    repair_hint: allPresent ? null : target.repair_hint,
  };
}

export function buildStatisticsDeterministicFallback(input: {
  contentKey?: string | null;
  responseText?: string | null;
  criteria: FeedbackCriterionRow[];
  pointsAvailable: number;
}) {
  const check = checkStatisticsDeterministicEvidence({
    contentKey: input.contentKey,
    responseText: input.responseText,
  });

  if (!check || check.status !== "flag") {
    return null;
  }

  // STATISTICS_TARGETS is item-level: one flat list of required values per
  // content_key, with no mapping of which value belongs to which rubric
  // criterion. That's safe when an item has exactly one gradable criterion
  // (the common case), but wrong when it has more than one -- a response
  // that fully earns criterion A but doesn't state a value needed only by
  // criterion B would otherwise have the ENTIRE response hard-blocked here
  // (zero credit, LLM never called), not just criterion B. Confirmed live
  // on APSTAT-MOD3-H001-INV (ci_calculation + hypothesis_test bundled into
  // one check) against a real provisional-labeled-"earned" response
  // (2026-07-12). Until this check is made criterion-aware, only let it
  // hard-block single-criterion items; for anything else, fall through to
  // the LLM grader, which still receives this flag as a soft repair-hint
  // signal via the separate checkStatisticsDeterministicEvidence() call in
  // evaluate-attempt/index.ts (statisticsCheck), not lost.
  //
  // KNOWN, DISCLOSED CONSEQUENCE (found by independent re-QA, 2026-07-12,
  // not caught before this guard was first committed): this counts TOTAL
  // rubric criteria on the item, not just numeric ones -- there's no
  // criterion "kind" (numeric vs conceptual) available at this call site
  // to filter on. Every content_key currently configured in
  // STATISTICS_TARGETS has 2+ TOTAL criteria (APSTAT-MOD3-H001-INV: 5,
  // APSTAT-MOD6-H001: 3, APSTAT-MOD7-H001: 2, all 18 APSTATS-SFRQ-* items:
  // 4 each, per docs/research/ap_statistics_phase4_mcq_smoke_batch_2026_07_01/
  // ap_statistics_frq_batch_2026_07_01.json's a/b/c/d structure -- contrary
  // to this guard's original commit message, which incorrectly claimed the
  // SFRQ items' structure "couldn't be confirmed without live DB access";
  // it's in that repo file). That means this guard currently returns null
  // for EVERY configured item -- the hard-block/cost-saving prefilter path
  // is presently unreachable for the whole catalog, not just the one
  // multi-numeric-criterion item that motivated the fix. This is SAFE (no
  // wrong zero-credit; every response now gets real LLM grading) but is a
  // real, disclosed side effect: the prefilter's cost-saving purpose is
  // dormant until this is made properly numeric-criterion-aware, not just
  // total-criterion-aware. Deliberately left this way rather than guessing
  // which of each item's criteria are numeric without a reliable "kind"
  // field at the call site -- that's the next real fix, not this one.
  if (input.criteria.length !== 1) {
    return null;
  }

  return {
    status: "uncertain" as const,
    points_earned: 0,
    points_available: input.pointsAvailable,
    criteria: buildFallbackCriteria(input.criteria, check.reason),
    highest_value_gap: null,
    predicted_improvement: null,
    confidence: "low" as const,
    uncertainty_reason:
      `Deterministic Statistics check flagged the response: ${check.reason}`,
    student_facing_summary:
      "The numeric part of this response needs correction before the grader can score it confidently.",
    action_hint: "show_scaffold" as const,
    repair_hint: check.repair_hint,
    deterministic_check: check,
  };
}
