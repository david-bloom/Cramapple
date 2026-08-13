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

// Exported (2026-08-11) so scripts/grading-model-assessment/
// verify_deterministic_keys.ts can audit every entry against the repo
// gold-set answers and the item's canonical answer -- the standing
// invariant harness added after the APSTATS-SFRQ-008 key defect (values
// transcribed from a retired canonical answer, see that entry). Export
// only; behavior unchanged.
export const STATISTICS_TARGETS: Record<
  string,
  {
    reason: string;
    repair_hint: string;
    values: NumericTarget[];
  } | null
> = {
  // PROVENANCE NOTE 2026-08-11: entries below annotated from the key audit
  // (docs/research/DETERMINISTIC_KEY_AUDIT_2026_08_11.md; harness
  // scripts/grading-model-assessment/verify_deterministic_keys.ts). Where a
  // "derived:" line appears, the value was independently recomputed from the
  // item's published stem/stimulus givens (never transcribed), and
  // "canonical vN (hash ...)" cites the content_item_versions row whose
  // canonical_answer_1 states the same value. "gold: x/y" is the audit's
  // expect-pass/expect-flag agreement over the repo gold-set answers.
  //
  // MOD3: no canonical_answer_1 recorded on any version (v2 published, hash
  // 9142c9c1b830a08cc330a15a45d68f81). derived: SE = 120/sqrt(30) = 21.9089
  // and t = (850-800)/SE = 2.28217 both check out; the CI bounds
  // [807.05863, 892.94137] assume z* = 1.96 where the AP-expected
  // t-interval (t*_29 = 2.045) gives (805.19, 894.81) -- those correct
  // t-bounds still land inside the 2% tolerance of the keyed values, so
  // this is a method-provenance concern, not a live false-flag. No gold
  // coverage.
  "APSTAT-MOD3-H001-INV": {
    reason:
      "The response should include the confidence-interval bounds and test statistic from the keyed calculation.",
    repair_hint:
      "Recompute the standard error with sqrt(n), then update the confidence interval and t-statistic using that corrected value.",
    values: [
      { value: 21.9089 },
      { value: 807.05863 },
      { value: 892.94137 },
      { value: 2.28217 },
    ],
  },
  "APSTAT-MOD5-H001-INV": null,
  // MOD6: no canonical_answer_1 recorded (v1 published). derived:
  // SE = sqrt(8^2/30 + 7^2/30) = 1.94079; t = (76-72)/SE = 2.06104. Both
  // validate. No gold coverage.
  "APSTAT-MOD6-H001": {
    reason:
      "The response should include the keyed two-sample standard error and test statistic.",
    repair_hint:
      "Recompute the pooled standard error with the keyed sample sizes, then recalculate the t-statistic on that value.",
    values: [
      { value: 1.94079 },
      { value: 2.06104 },
    ],
  },
  // MOD7: derived: P(defective) = .3(.02)+.5(.03)+.2(.01) = 0.023;
  // P(B|defective) = 0.015/0.023 = 0.65217. Values validate, BUT the item's
  // only version is status reviewed_disapproved (2026-08-11 audit) -- this
  // key cannot fire in production until the item is republished.
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
  // CORRECTED 2026-08-11 (pending O1 approval; do not deploy without it).
  // The previous values [1.8, 4.9] were transcribed from the item's RETIRED
  // v1 canonical_answer_1 (content_item_version d640d4b6-cb2e-4921-9b0a-
  // f9bf3ebd6ad3, content_hash 863d9416c7672e296bf57d61e561daad...); the
  // published v3 item (content_hash 975e2fdf9139370feef4597f46c61d73) uses
  // the payoff table (10, 0.10), (2, 0.20), (-4, 0.70), so every correct
  // response was deterministically flagged and zeroed (8/8 pilot gold
  // responses for this item scored 0 through the gate -- see
  // docs/research/DETERMINISTIC_KEY_AUDIT_2026_08_11.md).
  // Derived, not transcribed:
  //   E(X)  = 0.10*10 + 0.20*2 + 0.70*(-4) = -1.40
  //   Var   = 0.10*(10+1.4)^2 + 0.20*(2+1.4)^2 + 0.70*(-4+1.4)^2 = 20.04
  //   SD    = sqrt(20.04) = 4.4766... (published canonical states "about
  //           4.48"; the 2% relative tolerance covers 4.48 and 4.5)
  // Sign policy: E(X) is negative, but sign_sensitive is deliberately NOT
  // set -- matching is on |value|, so "loses $1.40", "-1.40", and "a $1.40
  // loss" all pass. All 8 gold answers write the sign lexically or
  // numerically; requiring the literal "-" would false-flag the lexical
  // form, which is the learner-harming direction this fix exists to close.
  "APSTATS-SFRQ-008": {
    reason:
      "The response should include the keyed expected value and standard deviation for the raffle payoff.",
    repair_hint:
      "Recompute the expected value from the weighted payoffs, then use the same payoff table to find the standard deviation.",
    values: [
      { value: -1.40 },
      { value: 4.477 },
    ],
  },
  // SFRQ-003: canonical v2 published (hash 917d06ff15ac79f4d45adf603c6563a8).
  // derived: y-hat = 52 + 4.1(6) = 76.6; residual = 74 - 76.6 = -2.6.
  // gold: 4/4 expect-pass, 3/4 expect-flag (A8 is a script-contested
  // discard whose text does reach both values).
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
  // SFRQ-004: canonical v2 published (hash fd47d4f34df01375863cc06d5024cc8b).
  // derived: y-hat = 9.8 - 0.65(7) = 5.25; residual = 5.0 - 5.25 = -0.25.
  // gold: 4/4 expect-pass; two documented false passes (A4 script-contested,
  // A5 ECF-style mention of 5.25 inside a wrong computation).
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
  // SFRQ-009: canonical v2 published (hash e46c5e174443493771ff23baeaa42fa0).
  // derived: mean = p = 0.28; SD = sqrt(0.28*0.72/400) = 0.02245.
  // gold: 4/4 expect-pass. Known limitation: 0.28 equals the stimulus's
  // given p, so an answer quoting the given inside the SD formula passes
  // without stating the mean (documented false pass A4).
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
  // SFRQ-010: canonical v2 published (hash 63f49475c8786d6d4635c7f071a6555b).
  // derived: mean = mu = 7.2; SD = 1.8/sqrt(36) = 0.3. gold: 4/4 and 4/4 --
  // the cleanest-discriminating entry in the audit.
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
  // SFRQ-001: canonical v1 published (hash 99ffea1ddbf2afa69ad769a9ed32fa
  // c92f54df845a9cf90d91a4f2161e07a692). derived: median of the ordered
  // 9-value set = 22; mean = 213/9 = 23.67. gold: 6/6 and 2/2.
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
  // SFRQ-002: canonical v2 published (hash 50eef52c04477af06c5ae08b0fc8ce6f).
  // derived: z_A = (86-74)/8 = 1.5; z_B = (62-52)/4 = 2.5. gold: 4/4
  // expect-pass; two false passes are script-contested discards (A4, A8)
  // whose text computes both z-scores anyway.
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
  // SFRQ-007: canonical v2 published (hash 3ba3324d7c28269173ba04f14bcddeef).
  // derived: mean = 20(0.25) = 5; SD = sqrt(3.75) = 1.9365 ("about 1.94");
  // P(X=5) = C(20,5)(.25)^5(.75)^15 = 0.2023. gold: 2/2 expect-pass. Known
  // limitation: the keyed mean 5 collides with the literal "5" in
  // "P(X = 5)", so answers that never compute the mean can pass (A5, A7).
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
  // SFRQ-011..018: no gold-set answers exist in the repo, so these are
  // canonical-only validations (2026-08-11 audit): each value below was
  // re-derived from the published stimulus givens and matches the current
  // published canonical_answer_1. Status caveats where noted.
  //
  // SFRQ-011: canonical v2 published (hash 4b7e82bf0246c544fd5e2d89bec18c98).
  // derived: p-hat = 84/120 = 0.70; 0.70 +/- 1.96*sqrt(.7*.3/120) =
  // (0.618, 0.782).
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
  // SFRQ-012: canonical v2 published (hash b87b0955f3227162203ba16f4740c348).
  // derived: z = (0.62-0.50)/sqrt(.5*.5/100) = 2.40; P(Z>2.40) = 0.0082.
  "APSTATS-SFRQ-012": {
    reason: "The response should include the keyed z-statistic and p-value.",
    repair_hint:
      "Recompute z from the sample proportion and hypothesized proportion, then find the matching p-value.",
    values: [
      { value: 2.40 },
      { value: 0.008 },
    ],
  },
  // SFRQ-013: canonical v2 published (hash ee083bca99b24c50a19b1b2f66676565).
  // derived: t = (74-70)/(8/sqrt(16)) = 2.00; 74 +/- 2.131*(2) =
  // (69.74, 78.26) ~ (69.7, 78.3).
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
  // SFRQ-014: canonical v2 published (hash 9508393411f53bb4a50c218fbacb01c0).
  // derived: t = 4.2/(3.0/sqrt(25)) = 7.00.
  "APSTATS-SFRQ-014": {
    reason:
      "The response should include the keyed matched-pairs t-statistic.",
    repair_hint:
      "Recompute t from the mean and standard deviation of the within-student differences.",
    values: [
      { value: 7.00 },
    ],
  },
  // SFRQ-015: derived: expected = 100/4 = 25; chi-sq = (49+4+0+25)/25 =
  // 3.12. Values validate, BUT the item's only version is status
  // reviewed_disapproved (2026-08-11 audit) -- key cannot fire until
  // republished.
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
  // SFRQ-016: canonical v2 published (hash c841b2a88e6a383515d19015a246f53f).
  // derived: expected freshman-likes = 30*30/60 = 15; chi-sq = 4*(3^2/15)
  // = 2.40.
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
  // SFRQ-017: derived: t = 5.2/1.1 = 4.727. Values validate, BUT (a) the
  // only version is status reviewed_disapproved, and (b) the keyed slope
  // 5.2 is itself a stimulus given -- the same given-value collision class
  // as SFRQ-009's 0.28, so this key checks little beyond restating the
  // prompt.
  "APSTATS-SFRQ-017": {
    reason: "The response should include the keyed t-statistic and slope.",
    repair_hint:
      "Recompute t from the slope and its standard error, and restate the slope from the regression output.",
    values: [
      { value: 4.73 },
      { value: 5.2 },
    ],
  },
  // SFRQ-018: derived: -2.4 +/- 2.086*(0.6) = (-3.65, -1.15). Values
  // validate, BUT the item's only version is status retired -- dead weight
  // until republished.
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
