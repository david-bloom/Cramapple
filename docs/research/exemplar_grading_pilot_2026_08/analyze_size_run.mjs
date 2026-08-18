#!/usr/bin/env node
//
// Reads a PILOT_MODE=size run's raw JSONL (repeated calls on ONE
// case/arm) and reports, per criterion, how often the modal (most common)
// status/points outcome was hit across trials -- the noise signal the plan's
// Phase 4 step 3(a) verification step exists to check before picking a trial
// count N for the full matrix.
//
// Usage:
//   node docs/research/exemplar_grading_pilot_2026_08/analyze_size_run.mjs \
//     [/tmp/cramapple_exemplar_pilot_size_raw.jsonl]

import { readFileSync } from "node:fs";

const path = process.argv[2] ?? "/tmp/cramapple_exemplar_pilot_size_raw.jsonl";
const lines = readFileSync(path, "utf8").split("\n").filter((line) => line.trim());
const records = lines.map((line) => JSON.parse(line));

if (records.length === 0) throw new Error(`No records in ${path}`);

const { content_key, response_index, arm } = records[0];
console.log(`${records.length} trials of ${content_key}#${response_index} arm=${arm}\n`);

const byCriterion = new Map();
for (const record of records) {
  const criteria = record.api_response?.result?.criteria ?? [];
  for (const criterion of criteria) {
    if (!byCriterion.has(criterion.criterion_key)) byCriterion.set(criterion.criterion_key, []);
    byCriterion.get(criterion.criterion_key).push({
      status: criterion.status,
      points_awarded: criterion.points_awarded,
    });
  }
}

let minModalFraction = 1;
for (const [criterionKey, outcomes] of byCriterion) {
  const statusCounts = new Map();
  for (const outcome of outcomes) {
    statusCounts.set(outcome.status, (statusCounts.get(outcome.status) ?? 0) + 1);
  }
  const sorted = [...statusCounts.entries()].sort((a, b) => b[1] - a[1]);
  const [modalStatus, modalCount] = sorted[0];
  const modalFraction = modalCount / outcomes.length;
  minModalFraction = Math.min(minModalFraction, modalFraction);
  const distribution = sorted.map(([status, count]) => `${status}=${count}`).join(", ");
  console.log(`${criterionKey}: modal=${modalStatus} (${(modalFraction * 100).toFixed(0)}%)  [${distribution}]`);
}

console.log(`\nMinimum modal-status agreement across criteria: ${(minModalFraction * 100).toFixed(0)}%`);

let recommendation;
if (minModalFraction >= 0.9) {
  recommendation = "N=3 (near-unanimous; a few repeats will average out the rare disagreement)";
} else if (minModalFraction >= 0.75) {
  recommendation = "N=5 (mild disagreement; the plan's default trial count is enough)";
} else {
  recommendation = "N>=8, and consider re-running this size check on a second case before committing " +
    "-- agreement is low enough that the grader itself is genuinely unstable on this response, not just " +
    "sampling noise, and averaging over more trials is the correct response but the noise should be " +
    "documented in REPORT.md's variance diagnostic either way";
}
console.log(`Recommendation: ${recommendation}`);
