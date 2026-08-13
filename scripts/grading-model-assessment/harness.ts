import {
  type CriterionScoreOutcome,
  type FeedbackCriterionResult,
  type GoldLabel,
  scoreCriterionPair,
} from "../../supabase/functions/_shared/grading-contract.ts";

export type GoldCriterion = {
  criterion_key: string;
  gold_label: "earned" | "not_earned" | "partially_earned" | "unable_to_determine";
};
export type GoldCase = {
  content_key: string;
  response_index: number;
  response_text: string;
  criteria: GoldCriterion[];
  expected_repair_criterion_key?: string | null;
  forbidden_repair_phrases?: string[];
};
export type ResultCase = {
  content_key: string;
  response_index: number;
  criteria: Array<{ criterion_key: string; status: string; points_awarded: number; points_possible: number }>;
  repair?: { criterion_key?: string | null; prompt?: string | null };
  latency_ms?: number;
  cost_usd?: number;
};

// `partially_earned` must be listed here. The fallback is
// "unable_to_determine", so omitting a real status does not merely lose
// detail -- it silently reclassifies every partial award as an abstention,
// which moves those cases out of the accuracy denominator entirely.
function resultStatus(value: string | undefined) {
  return value === "earned" || value === "partially_earned" ||
      value === "not_yet_earned" ||
      value === "unable_to_determine" || value === "not_applicable"
    ? value
    : "unable_to_determine" as const;
}

export function caseId(value: { content_key: string; response_index: number }) {
  return `${value.content_key}#${value.response_index}`;
}

// --- Scoring policies ----------------------------------------------------
//
// "binary-v1" is the production contract's scoreCriterionPair: everything
// collapses to full_credit / not_full_credit, so a gold `partially_earned`
// can never be matched exactly -- any prediction short of full credit
// "agrees" with it. That collapse cannot evaluate the partial-credit
// behavior shipped 2026-07-28 (gradingSchema's `partially_earned` status).
//
// "partial-v2" scores three credit classes instead of two. Classes are
// derived from POINTS relative to points_possible, with status used only to
// detect abstention/not_applicable -- this makes the policy robust to
// status/points mismatches (the sanitizer reconciles those in production;
// the harness should not re-litigate them):
//   gold:      earned -> full | not_earned -> zero | partially_earned -> partial
//   predicted: points_awarded >= points_possible -> full
//              points_awarded <= 0               -> zero
//              otherwise                          -> partial
//   correct iff the classes are equal.
// Gold `unable_to_determine` is excluded from the accuracy denominator and
// predicted `unable_to_determine`/`not_applicable` count as incorrect
// non-selective outcomes, exactly as in v1 (the abstention-gaming rule is
// policy-independent).
export type ScoringPolicy = "binary-v1" | "partial-v2";

export function scoreCriterionPairV2(
  gold: GoldLabel,
  modelStatus: FeedbackCriterionResult["status"],
  pointsAwarded: number,
  pointsPossible: number,
): CriterionScoreOutcome {
  if (gold === "unable_to_determine") {
    return {
      inOverallDenominator: false,
      overallCorrect: null,
      inSelectiveDenominator: false,
      selectiveCorrect: null,
      goldAbstained: true,
      correctAbstention: modelStatus === "unable_to_determine",
    };
  }

  const goldClass = gold === "earned"
    ? "full"
    : gold === "partially_earned"
    ? "partial"
    : "zero";

  const predictionIsCreditDecision = modelStatus === "earned" ||
    modelStatus === "partially_earned" || modelStatus === "not_yet_earned";
  const predictedClass = !predictionIsCreditDecision
    ? null
    : pointsAwarded >= pointsPossible
    ? "full"
    : pointsAwarded <= 0
    ? "zero"
    : "partial";

  return {
    inOverallDenominator: true,
    overallCorrect: predictedClass !== null ? predictedClass === goldClass : false,
    inSelectiveDenominator: predictionIsCreditDecision,
    selectiveCorrect: predictedClass !== null
      ? predictedClass === goldClass
      : null,
    goldAbstained: false,
    correctAbstention: null,
  };
}

// Collapses per-response correctness (keys "CONTENT_KEY#response_index") to
// per-item correctness (keys "CONTENT_KEY", value = unweighted mean of the
// item's responses). This is the caller-side grouping layer the 2026-08-10
// exemplar pilot was missing: clusterBootstrapDifference resamples whatever
// keys it is handed, so handing it response-level keys treats responses to
// the same held-out item as independent draws (pseudoreplication; see
// exemplar_grading_pilot_2026_08/REPORT.md). Feed it THIS map when the
// design's sampling unit is the item.
export function collapseToItemClusters(
  itemCorrectness: Record<string, number>,
): Record<string, number> {
  const sums = new Map<string, { sum: number; n: number }>();
  for (const [key, value] of Object.entries(itemCorrectness)) {
    const hash = key.lastIndexOf("#");
    const itemKey = hash === -1 ? key : key.slice(0, hash);
    const entry = sums.get(itemKey) ?? { sum: 0, n: 0 };
    entry.sum += value;
    entry.n += 1;
    sums.set(itemKey, entry);
  }
  const collapsed: Record<string, number> = {};
  for (const [key, { sum, n }] of sums) collapsed[key] = sum / n;
  return collapsed;
}

export function validateCases(gold: GoldCase[], results: ResultCase[]) {
  const errors: string[] = [];
  const goldIds = new Set<string>();
  for (const item of gold) {
    const id = caseId(item);
    if (goldIds.has(id)) errors.push(`duplicate gold case: ${id}`);
    goldIds.add(id);
    const keys = new Set<string>();
    for (const criterion of item.criteria) {
      if (keys.has(criterion.criterion_key)) errors.push(`duplicate gold criterion: ${id}/${criterion.criterion_key}`);
      keys.add(criterion.criterion_key);
    }
  }
  const resultIds = new Set<string>();
  for (const item of results) {
    const id = caseId(item);
    if (resultIds.has(id)) errors.push(`duplicate result case: ${id}`);
    resultIds.add(id);
    if (!goldIds.has(id)) errors.push(`result without gold case: ${id}`);
  }
  for (const id of goldIds) if (!resultIds.has(id)) errors.push(`missing result case: ${id}`);
  return errors;
}

function percentile(values: number[], fraction: number) {
  if (!values.length) return null;
  const sorted = [...values].sort((a, b) => a - b);
  return sorted[Math.min(sorted.length - 1, Math.ceil(fraction * sorted.length) - 1)];
}

export function scoreRun(
  gold: GoldCase[],
  results: ResultCase[],
  policy: ScoringPolicy = "binary-v1",
) {
  const errors = validateCases(gold, results);
  if (errors.length) throw new Error(errors.join("\n"));
  const scorePair = policy === "partial-v2"
    ? scoreCriterionPairV2
    : scoreCriterionPair;
  const resultMap = new Map(results.map((item) => [caseId(item), item]));
  let overallCorrect = 0;
  let overallN = 0;
  let selectiveCorrect = 0;
  let selectiveN = 0;
  let abstentions = 0;
  let falsePositive = 0;
  let falseNegative = 0;
  let positiveN = 0;
  let negativeN = 0;
  let exactCases = 0;
  let repairTargetCorrect = 0;
  let repairTargetN = 0;
  let leakageCount = 0;
  const itemCorrectness: Record<string, number> = {};

  for (const goldCase of gold) {
    const result = resultMap.get(caseId(goldCase))!;
    const predicted = new Map(result.criteria.map((criterion) => [criterion.criterion_key, criterion]));
    let caseCorrect = true;
    let caseN = 0;
    let caseHits = 0;
    for (const goldCriterion of goldCase.criteria) {
      const prediction = predicted.get(goldCriterion.criterion_key);
      const scored = scorePair(
        goldCriterion.gold_label,
        resultStatus(prediction?.status),
        prediction?.points_awarded ?? 0,
        prediction?.points_possible ?? 1,
      );
      if (scored.goldAbstained) continue;
      overallN++;
      caseN++;
      if (scored.overallCorrect) {
        overallCorrect++;
        caseHits++;
      } else caseCorrect = false;
      if (scored.inSelectiveDenominator) {
        selectiveN++;
        if (scored.selectiveCorrect) selectiveCorrect++;
      } else abstentions++;
      const goldPositive = goldCriterion.gold_label === "earned";
      const predictedPositive = prediction?.status === "earned" &&
        prediction.points_awarded === prediction.points_possible;
      if (goldPositive) {
        positiveN++;
        if (!predictedPositive) falseNegative++;
      } else {
        negativeN++;
        if (predictedPositive) falsePositive++;
      }
    }
    if (caseCorrect) exactCases++;
    itemCorrectness[caseId(goldCase)] = caseN ? caseHits / caseN : 0;
    if (goldCase.expected_repair_criterion_key != null) {
      repairTargetN++;
      if (result.repair?.criterion_key === goldCase.expected_repair_criterion_key) repairTargetCorrect++;
    }
    const prompt = result.repair?.prompt?.toLowerCase() ?? "";
    if ((goldCase.forbidden_repair_phrases ?? []).some((phrase) => prompt.includes(phrase.toLowerCase()))) leakageCount++;
  }

  const latencies = results.map((item) => item.latency_ms).filter((value): value is number => Number.isFinite(value));
  return {
    scoring_policy: policy,
    criterion_count: overallN,
    case_count: gold.length,
    overall_accuracy: overallN ? overallCorrect / overallN : null,
    selective_accuracy: selectiveN ? selectiveCorrect / selectiveN : null,
    coverage: overallN ? selectiveN / overallN : null,
    abstention_count: abstentions,
    false_positive_rate: negativeN ? falsePositive / negativeN : null,
    false_negative_rate: positiveN ? falseNegative / positiveN : null,
    exact_case_accuracy: gold.length ? exactCases / gold.length : null,
    repair_target_accuracy: repairTargetN ? repairTargetCorrect / repairTargetN : null,
    repair_leakage_rate: repairTargetN ? leakageCount / repairTargetN : null,
    latency_ms: { p50: percentile(latencies, 0.5), p95: percentile(latencies, 0.95) },
    total_cost_usd: results.reduce((sum, item) => sum + (item.cost_usd ?? 0), 0),
    item_correctness: itemCorrectness,
  };
}

function seeded(seed: number) {
  let state = seed >>> 0;
  return () => ((state = (1664525 * state + 1013904223) >>> 0) / 2 ** 32);
}

export function clusterBootstrapDifference(
  candidate: Record<string, number>,
  baseline: Record<string, number>,
  iterations = 2000,
  seed = 20260711,
) {
  const keys = Object.keys(candidate).filter((key) => key in baseline).sort();
  if (!keys.length) throw new Error("candidate and baseline have no shared item clusters");
  const random = seeded(seed);
  const differences: number[] = [];
  for (let iteration = 0; iteration < iterations; iteration++) {
    let sum = 0;
    for (let draw = 0; draw < keys.length; draw++) {
      const key = keys[Math.floor(random() * keys.length)];
      sum += candidate[key] - baseline[key];
    }
    differences.push(sum / keys.length);
  }
  differences.sort((a, b) => a - b);
  return {
    estimate: keys.reduce((sum, key) => sum + candidate[key] - baseline[key], 0) / keys.length,
    ci95_low: differences[Math.floor(iterations * 0.025)],
    ci95_high: differences[Math.min(iterations - 1, Math.floor(iterations * 0.975))],
    clusters: keys.length,
    iterations,
    seed,
  };
}
