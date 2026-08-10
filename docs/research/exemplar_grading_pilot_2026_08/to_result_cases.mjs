#!/usr/bin/env node
//
// Maps run_pilot.mjs's raw_calls.jsonl (full-matrix mode: N trials per
// case x arm) into one ResultCase[] per arm, matching harness.ts's
// scoreRun()/caseId() keying exactly: one entry per (content_key,
// response_index), never per trial.
//
// This is the pseudoreplication fix the plan was revised around:
// clusterBootstrapDifference (harness.ts) has no internal grouping -- it
// treats every key in item_correctness as an independent cluster. Emitting
// one ResultCase per trial (instead of aggregating trials first) would make
// each trial its own "independent" cluster and silently narrow the
// bootstrap CI below what the data supports. Aggregating here, before
// main.ts ever sees the data, is what keeps the true cluster count at one
// per held-out case (~5), not one per (case x trial).
//
// Aggregation rule per (content_key, response_index, arm, criterion_key):
//   - status: the majority (modal) status across trials; ties broken by
//     first-appearance order in the input file (deterministic, but a real
//     tie -- not resolved by evidence -- so tie occurrences are logged).
//   - points_awarded: the median across trials, rounded to the nearest
//     integer and clamped to [0, points_possible].
//   - points_possible: NOT taken from the API response -- evaluate-attempt's
//     sanitized criterion object (grading-feedback.ts's Te()) only echoes
//     back criterion_key/status/points_awarded/evidence_quote/
//     decision_explanation/minimum_fix, never points_possible. It has to
//     come from the rubric directly, so it's read from
//     held_out_items.json's criteria_points_possible (itself from a
//     read-only app.frq_criteria audit, see that file's note).
//
// Also writes raw_trial_variance.json: per (case, arm, criterion) the modal
// agreement fraction across trials -- the descriptive noise diagnostic
// Phase 5's REPORT.md reports separately from the aggregated/bootstrapped
// accuracy numbers.
//
// Usage:
//   node docs/research/exemplar_grading_pilot_2026_08/to_result_cases.mjs \
//     [docs/research/exemplar_grading_pilot_2026_08/raw_calls.jsonl]

import { readFileSync, writeFileSync } from "node:fs";
import { resolve } from "node:path";

const RAW_PATH = process.argv[2] ??
  resolve("docs/research/exemplar_grading_pilot_2026_08/raw_calls.jsonl");
const OUT_DIR = resolve("docs/research/exemplar_grading_pilot_2026_08");

const lines = readFileSync(RAW_PATH, "utf8").split("\n").filter((line) => line.trim());
const records = lines.map((line) => JSON.parse(line));
if (records.length === 0) throw new Error(`No records in ${RAW_PATH}`);

const heldOutItems = JSON.parse(
  readFileSync(resolve(OUT_DIR, "held_out_items.json"), "utf8"),
).items;
const pointsPossibleByContentKey = new Map(
  heldOutItems.map((item) => [item.content_key, item.criteria_points_possible]),
);

function median(values) {
  const sorted = [...values].sort((a, b) => a - b);
  const mid = Math.floor(sorted.length / 2);
  return sorted.length % 2 === 0 ? (sorted[mid - 1] + sorted[mid]) / 2 : sorted[mid];
}

// groups: Map<"content_key#response_index#arm", record[]>
const groups = new Map();
for (const record of records) {
  if (record.http_status !== 200 && record.http_status !== 202) {
    console.warn(
      `WARN skipping non-2xx call: ${record.content_key}#${record.response_index} arm=${record.arm} trial=${record.trial} http=${record.http_status}`,
    );
    continue;
  }
  const key = `${record.content_key}#${record.response_index}#${record.arm}`;
  if (!groups.has(key)) groups.set(key, []);
  groups.get(key).push(record);
}

const resultsByArm = { off: [], with_exemplar: [] };
const variance = [];

for (const [key, trials] of groups) {
  const [contentKey, responseIndexStr, arm] = key.split("#");
  const responseIndex = Number(responseIndexStr);
  if (!(arm in resultsByArm)) {
    console.warn(`WARN unexpected arm "${arm}" for ${contentKey}#${responseIndex}, skipping`);
    continue;
  }

  const pointsPossibleMap = pointsPossibleByContentKey.get(contentKey);
  if (!pointsPossibleMap) throw new Error(`No criteria_points_possible entry for ${contentKey} in held_out_items.json`);

  const byCriterion = new Map(); // criterion_key -> {statuses: [], points: []}
  for (const trial of trials) {
    const criteria = trial.api_response?.result?.criteria ?? [];
    for (const criterion of criteria) {
      if (!byCriterion.has(criterion.criterion_key)) {
        byCriterion.set(criterion.criterion_key, { statuses: [], points: [] });
      }
      const entry = byCriterion.get(criterion.criterion_key);
      entry.statuses.push(criterion.status);
      entry.points.push(Number(criterion.points_awarded) || 0);
    }
  }

  const criteria = [];
  for (const [criterionKey, entry] of byCriterion) {
    const counts = new Map();
    entry.statuses.forEach((status) => counts.set(status, (counts.get(status) ?? 0) + 1));
    const sorted = [...counts.entries()].sort((a, b) => b[1] - a[1]);
    const [modalStatus, modalCount] = sorted[0];
    const isTie = sorted.length > 1 && sorted[1][1] === modalCount;
    if (isTie) {
      console.warn(
        `WARN tied modal status for ${contentKey}#${responseIndex} arm=${arm} ${criterionKey}: ${sorted.map(([s, c]) => `${s}=${c}`).join(", ")} -- using first-seen order`,
      );
    }
    const pointsPossible = pointsPossibleMap[criterionKey];
    if (pointsPossible == null) {
      console.warn(
        `WARN no points_possible recorded for ${contentKey} criterion ${criterionKey} -- defaulting to 1`,
      );
    }
    const pointsAwarded = Math.max(0, Math.min(pointsPossible ?? 1, Math.round(median(entry.points))));
    criteria.push({
      criterion_key: criterionKey,
      status: modalStatus,
      points_awarded: pointsAwarded,
      points_possible: pointsPossible ?? 1,
    });
    variance.push({
      content_key: contentKey,
      response_index: responseIndex,
      arm,
      criterion_key: criterionKey,
      trial_count: entry.statuses.length,
      modal_status: modalStatus,
      modal_agreement_fraction: modalCount / entry.statuses.length,
      status_distribution: Object.fromEntries(counts),
      points_awarded_values: entry.points,
    });
  }

  const latencies = trials
    .map((trial) => trial.grading_result?.latency_ms ?? trial.wall_latency_ms)
    .filter((value) => Number.isFinite(value));
  const costs = trials
    .map((trial) => Number(trial.grading_result?.estimated_cost_usd))
    .filter((value) => Number.isFinite(value));

  resultsByArm[arm].push({
    content_key: contentKey,
    response_index: responseIndex,
    criteria,
    latency_ms: latencies.length ? median(latencies) : undefined,
    cost_usd: costs.length ? costs.reduce((sum, value) => sum + value, 0) / costs.length : undefined,
  });
}

for (const arm of ["off", "with_exemplar"]) {
  resultsByArm[arm].sort((a, b) =>
    a.content_key === b.content_key ? a.response_index - b.response_index : a.content_key.localeCompare(b.content_key)
  );
  const outPath = resolve(
    OUT_DIR,
    arm === "off" ? "results_without_exemplar.json" : "results_with_exemplar.json",
  );
  writeFileSync(outPath, `${JSON.stringify(resultsByArm[arm], null, 2)}\n`);
  console.log(`Wrote ${outPath} (${resultsByArm[arm].length} cases)`);
}

variance.sort((a, b) =>
  a.content_key === b.content_key
    ? (a.arm === b.arm ? a.criterion_key.localeCompare(b.criterion_key) : a.arm.localeCompare(b.arm))
    : a.content_key.localeCompare(b.content_key)
);
const variancePath = resolve(OUT_DIR, "raw_trial_variance.json");
writeFileSync(variancePath, `${JSON.stringify(variance, null, 2)}\n`);
console.log(`Wrote ${variancePath} (${variance.length} case x arm x criterion rows)`);

const lowAgreement = variance.filter((row) => row.modal_agreement_fraction < 0.75);
if (lowAgreement.length) {
  console.log(
    `\n${lowAgreement.length} case x arm x criterion combinations had <75% trial agreement -- see raw_trial_variance.json:`,
  );
  for (const row of lowAgreement) {
    console.log(
      `  ${row.content_key}#${row.response_index} arm=${row.arm} ${row.criterion_key}: ${(row.modal_agreement_fraction * 100).toFixed(0)}% (${JSON.stringify(row.status_distribution)})`,
    );
  }
}
