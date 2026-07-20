// TASK-0016 AP Statistics launch-bar verdict.
//
// Layered on top of scoreRun() so harness.ts stays untouched (and its tests
// stay green). The bar, from TASK-0016 "Resolved Decisions" and Acceptance
// Criteria:
//   - accuracy: >= 95% criterion-level agreement with adjudicated labels  (GATE)
//   - latency:  end-to-end p50 <= 1000 ms                                 (GATE)
//               p90 / p99 measured-and-reported (no hard gate yet)        (report)
//   - cost:     <= $0.01 / item, reported not gated (BYOK is a CAC)       (report)
//
// Targets are ceilings -- "stay under". A grader over a ceiling fails that gate.

import type { ResultCase } from "./harness.ts";

export type LaunchBarConfig = {
  accuracy_floor: number; // default 0.95
  latency_p50_ceiling_ms: number; // default 1000
  cost_per_item_ceiling_usd: number; // default 0.01 (reported, not gated)
};

export const DEFAULT_LAUNCH_BAR: LaunchBarConfig = {
  accuracy_floor: 0.95,
  latency_p50_ceiling_ms: 1000,
  cost_per_item_ceiling_usd: 0.01,
};

function percentile(values: number[], fraction: number): number | null {
  if (!values.length) return null;
  const sorted = [...values].sort((a, b) => a - b);
  return sorted[Math.min(sorted.length - 1, Math.ceil(fraction * sorted.length) - 1)];
}

export type LaunchBarVerdict = {
  pass: boolean; // all GATES pass
  gates: {
    accuracy: { value: number | null; floor: number; pass: boolean };
    latency_p50_ms: { value: number | null; ceiling: number; pass: boolean };
  };
  reported: {
    latency_p90_ms: number | null;
    latency_p99_ms: number | null;
    mean_cost_per_item_usd: number | null;
    cost_per_item_ceiling_usd: number;
    cost_within_target: boolean | null;
    latency_measured_n: number;
    cost_measured_n: number;
  };
  notes: string[];
};

export function evaluateLaunchBar(
  input: {
    overall_accuracy: number | null;
    results: ResultCase[];
  },
  config: LaunchBarConfig = DEFAULT_LAUNCH_BAR,
): LaunchBarVerdict {
  const latencies = input.results
    .map((r) => r.latency_ms)
    .filter((v): v is number => Number.isFinite(v));
  const costs = input.results
    .map((r) => r.cost_usd)
    .filter((v): v is number => Number.isFinite(v));

  const p50 = percentile(latencies, 0.5);
  const p90 = percentile(latencies, 0.9);
  const p99 = percentile(latencies, 0.99);
  const meanCost = costs.length
    ? costs.reduce((s, v) => s + v, 0) / costs.length
    : null;

  const accuracyPass = input.overall_accuracy != null &&
    input.overall_accuracy >= config.accuracy_floor;
  // A missing p50 (no latency captured) cannot pass a latency ceiling gate.
  const latencyPass = p50 != null && p50 <= config.latency_p50_ceiling_ms;

  const notes: string[] = [];
  if (input.overall_accuracy == null) {
    notes.push("No scorable criteria -- accuracy gate cannot be evaluated.");
  }
  if (p50 == null) {
    notes.push("No latency captured -- latency gate cannot pass until end-to-end timings are recorded.");
  }
  if (meanCost == null) {
    notes.push("No cost captured -- cost is reported, not gated.");
  }

  return {
    pass: accuracyPass && latencyPass,
    gates: {
      accuracy: {
        value: input.overall_accuracy,
        floor: config.accuracy_floor,
        pass: accuracyPass,
      },
      latency_p50_ms: {
        value: p50,
        ceiling: config.latency_p50_ceiling_ms,
        pass: latencyPass,
      },
    },
    reported: {
      latency_p90_ms: p90,
      latency_p99_ms: p99,
      mean_cost_per_item_usd: meanCost,
      cost_per_item_ceiling_usd: config.cost_per_item_ceiling_usd,
      cost_within_target: meanCost == null
        ? null
        : meanCost <= config.cost_per_item_ceiling_usd,
      latency_measured_n: latencies.length,
      cost_measured_n: costs.length,
    },
    notes,
  };
}
