import {
  clusterBootstrapDifference,
  collapseToItemClusters,
  scoreCriterionPairV2,
  scoreRun,
  validateCases,
} from "./harness.ts";
import type { GoldCase, ResultCase } from "./harness.ts";
import gold from "./fixtures/gold.json" with { type: "json" };
import candidate from "./fixtures/candidate-results.json" with { type: "json" };
import baseline from "./fixtures/baseline-results.json" with { type: "json" };

Deno.test("benchmark scores quality, repair, speed, and cost without rewarding abstention", () => {
  const score = scoreRun(gold as GoldCase[], candidate as ResultCase[]);
  if (score.overall_accuracy !== 1 || score.coverage !== 1) throw new Error("candidate fixture should be fully correct");
  if (score.repair_target_accuracy !== 1 || score.repair_leakage_rate !== 0) throw new Error("repair fixture should be targeted and non-leaking");
  if (score.latency_ms.p95 !== 120 || score.total_cost_usd !== 0.003) throw new Error("operational metrics should aggregate deterministically");
  const baselineScore = scoreRun(gold as GoldCase[], baseline as ResultCase[]);
  if (baselineScore.overall_accuracy !== 0.5 || baselineScore.coverage !== 0.5) throw new Error("abstention must reduce overall accuracy and coverage");
});

Deno.test("cluster bootstrap is deterministic and resamples whole response clusters", () => {
  const candidateScore = scoreRun(gold as GoldCase[], candidate as ResultCase[]);
  const baselineScore = scoreRun(gold as GoldCase[], baseline as ResultCase[]);
  const first = clusterBootstrapDifference(candidateScore.item_correctness, baselineScore.item_correctness, 500, 7);
  const second = clusterBootstrapDifference(candidateScore.item_correctness, baselineScore.item_correctness, 500, 7);
  if (JSON.stringify(first) !== JSON.stringify(second) || first.estimate !== 0.5 || first.clusters !== 2) throw new Error("bootstrap must be reproducible at the item-response level");
});

Deno.test("partial-v2 pair scoring distinguishes full, partial, and zero credit", () => {
  // gold partially_earned + predicted partial award (0 < pa < pp) is CORRECT
  // under v2 -- the case binary v1 cannot express.
  const partialHit = scoreCriterionPairV2("partially_earned", "partially_earned", 1, 2);
  if (!partialHit.overallCorrect || !partialHit.inSelectiveDenominator) {
    throw new Error("gold partial + predicted partial must score correct under v2");
  }
  // gold partially_earned + predicted zero is INCORRECT under v2 (binary v1
  // would call both "not_full_credit" and score it correct).
  const partialMissedAsZero = scoreCriterionPairV2("partially_earned", "not_yet_earned", 0, 2);
  if (partialMissedAsZero.overallCorrect) {
    throw new Error("v2 must not collapse partial and zero credit");
  }
  // gold partially_earned + predicted full is INCORRECT under both policies.
  if (scoreCriterionPairV2("partially_earned", "earned", 2, 2).overallCorrect) {
    throw new Error("over-credit against a partial gold label must be incorrect");
  }
  // Classes come from points, not status labels: an "earned" status with a
  // partial award counts as partial credit.
  const statusPointsMismatch = scoreCriterionPairV2("partially_earned", "earned", 1, 2);
  if (!statusPointsMismatch.overallCorrect) {
    throw new Error("v2 classifies by points_awarded relative to points_possible");
  }
  // Abstention rules are policy-independent: predicted abstention on
  // determinable gold counts against overall accuracy, outside selective.
  const abstained = scoreCriterionPairV2("earned", "unable_to_determine", 0, 1);
  if (abstained.overallCorrect || abstained.inSelectiveDenominator) {
    throw new Error("abstention must not be excluded from the overall denominator");
  }
  const goldAbstained = scoreCriterionPairV2("unable_to_determine", "unable_to_determine", 0, 1);
  if (!goldAbstained.goldAbstained || goldAbstained.correctAbstention !== true) {
    throw new Error("gold abstention is scored as the separate correct-abstention question");
  }
});

Deno.test("scoreRun policies diverge exactly on partial-credit gold labels", () => {
  const goldCases: GoldCase[] = [{
    content_key: "ITEM-1",
    response_index: 0,
    response_text: "x",
    criteria: [
      { criterion_key: "a", gold_label: "partially_earned" },
      { criterion_key: "b", gold_label: "earned" },
    ],
  }];
  const results: ResultCase[] = [{
    content_key: "ITEM-1",
    response_index: 0,
    criteria: [
      // Zero awarded against gold partial: v1 scores it correct (both are
      // not_full_credit), v2 scores it incorrect (zero != partial).
      { criterion_key: "a", status: "not_yet_earned", points_awarded: 0, points_possible: 2 },
      { criterion_key: "b", status: "earned", points_awarded: 1, points_possible: 1 },
    ],
  }];
  const v1 = scoreRun(goldCases, results);
  const v2 = scoreRun(goldCases, results, "partial-v2");
  if (v1.scoring_policy !== "binary-v1" || v2.scoring_policy !== "partial-v2") {
    throw new Error("reports must carry the policy they were scored under");
  }
  if (v1.overall_accuracy !== 1) throw new Error("binary v1 cannot see the partial miss");
  if (v2.overall_accuracy !== 0.5) throw new Error("partial v2 must see the partial miss");
});

Deno.test("item-cluster collapse averages responses per item and drives the coarser bootstrap", () => {
  const collapsed = collapseToItemClusters({
    "ITEM-A#0": 1,
    "ITEM-A#1": 0,
    "ITEM-B#0": 1,
  });
  if (
    Object.keys(collapsed).length !== 2 || collapsed["ITEM-A"] !== 0.5 ||
    collapsed["ITEM-B"] !== 1
  ) {
    throw new Error("collapse must average per content_key");
  }
  // The item-level bootstrap must report the item count as its cluster
  // count -- the exact number the 2026-08-10 exemplar pilot pre-registered
  // and failed (30 response clusters vs 4 items).
  const candidate = { "ITEM-A#0": 1, "ITEM-A#1": 1, "ITEM-B#0": 1 };
  const baseline = { "ITEM-A#0": 0, "ITEM-A#1": 1, "ITEM-B#0": 1 };
  const itemLevel = clusterBootstrapDifference(
    collapseToItemClusters(candidate),
    collapseToItemClusters(baseline),
    200,
    7,
  );
  if (itemLevel.clusters !== 2) throw new Error("item-level bootstrap must cluster per item");
  if (Math.abs(itemLevel.estimate - 0.25) > 1e-9) {
    throw new Error("estimate must be the mean per-item difference");
  }
});

Deno.test("manifest validation fails closed on missing and extra result cases", () => {
  const errors = validateCases(gold as GoldCase[], [candidate[0], { ...candidate[0], content_key: "EXTRA" }] as ResultCase[]);
  if (!errors.some((error) => error.includes("missing result case")) || !errors.some((error) => error.includes("without gold"))) throw new Error("coverage contract failures must be explicit");
});
