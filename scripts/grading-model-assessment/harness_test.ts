import { clusterBootstrapDifference, scoreRun, validateCases } from "./harness.ts";
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

Deno.test("manifest validation fails closed on missing and extra result cases", () => {
  const errors = validateCases(gold as GoldCase[], [candidate[0], { ...candidate[0], content_key: "EXTRA" }] as ResultCase[]);
  if (!errors.some((error) => error.includes("missing result case")) || !errors.some((error) => error.includes("without gold"))) throw new Error("coverage contract failures must be explicit");
});
