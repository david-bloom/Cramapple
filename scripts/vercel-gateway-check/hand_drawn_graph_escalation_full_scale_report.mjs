// Recomputes exact match / per-criterion F1 / FAR / FRR across the FULL
// 200-photo real-photo corpus for the escalation-augmented policy:
// gpt-5.2 primary on everything, gpt-5.2-pro on gpt-5.2's medium-confidence
// responses (all 105, not the 21-photo controlled-test subsample).
//
// Per the handoff doc's "Concrete gap to production" item 1 -- this is the
// number the 21/105 controlled test could not give: whether escalation's
// gain holds at full scale and what it does to the whole-corpus DR-1
// metrics, not just the medium-confidence slice.
//
// Definitions (matching the research doc's usage, see
// "Per-criterion F1 | ... unable_to_determine excluded from either side"):
//   TP = gold earned, predicted earned
//   FP = gold not_earned, predicted earned  (a false ACCEPT)
//   FN = gold earned, predicted not_earned  (a false REJECT)
//   TN = gold not_earned, predicted not_earned
//   unable_to_determine (gold or predicted) excluded from all four buckets
//   FAR = FP / (FP + TN)   -- of truly-wrong criteria, how many got credit
//   FRR = FN / (FN + TP)   -- of truly-right criteria, how many got denied
//   F1  = harmonic mean of precision=TP/(TP+FP), recall=TP/(TP+FN)
//   Exact match (response-level) = every criterion on that response predicted
//     correctly (schema_valid AND all match), same field the run scripts
//     already compute per response.

import fs from 'node:fs';
import path from 'node:path';

const ROOT = path.resolve(new URL('.', import.meta.url).pathname, '..', '..');
const OUT_DIR = path.join(ROOT, 'docs', 'research', 'hand_drawn_graph_real_photo_benchmark_2026_08_18');
const BASELINE_JSONL = path.join(OUT_DIR, 'runs', 'real_photo_benchmark_gpt52_results.jsonl');
const ESCALATION_JSONL = path.join(OUT_DIR, 'runs', 'escalation_full_results.jsonl');

function loadJsonl(filePath) {
  return fs.readFileSync(filePath, 'utf8').trim().split('\n').filter(Boolean).map((l) => JSON.parse(l));
}

function keyOf(r) {
  return `${r.item_id} ${r.file_name}`;
}

function criterionBuckets(records) {
  let tp = 0, fp = 0, fn = 0, tn = 0, excluded = 0;
  for (const r of records) {
    for (const c of r.criterion_results || []) {
      const gold = c.gold;
      const pred = c.predicted;
      if (gold === 'unable_to_determine' || pred === 'unable_to_determine' || pred === null) {
        excluded += 1;
        continue;
      }
      if (gold === 'earned' && pred === 'earned') tp += 1;
      else if (gold === 'not_earned' && pred === 'earned') fp += 1;
      else if (gold === 'earned' && pred === 'not_earned') fn += 1;
      else if (gold === 'not_earned' && pred === 'not_earned') tn += 1;
    }
  }
  return { tp, fp, fn, tn, excluded };
}

function metricsFromBuckets({ tp, fp, fn, tn }) {
  const precision = tp + fp > 0 ? tp / (tp + fp) : null;
  const recall = tp + fn > 0 ? tp / (tp + fn) : null;
  const f1 = precision !== null && recall !== null && (precision + recall) > 0
    ? (2 * precision * recall) / (precision + recall)
    : null;
  const far = fp + tn > 0 ? fp / (fp + tn) : null;
  const frr = fn + tp > 0 ? fn / (fn + tp) : null;
  return { precision, recall, f1, far, frr };
}

function pct(x) {
  return x === null ? 'n/a' : `${(x * 100).toFixed(1)}%`;
}

function main() {
  const baseline = loadJsonl(BASELINE_JSONL); // all 200, gpt-5.2 alone
  const baselineByKey = new Map(baseline.map((r) => [keyOf(r), r]));

  let escalation = [];
  if (fs.existsSync(ESCALATION_JSONL)) {
    escalation = loadJsonl(ESCALATION_JSONL);
  }
  const escalationByKey = new Map(escalation.map((r) => [keyOf(r), r]));

  const mediumKeys = new Set(baseline.filter((r) => r.confidence === 'medium').map((r) => keyOf(r)));
  const missingEscalation = [...mediumKeys].filter((k) => !escalationByKey.has(k));

  // Escalated corpus: substitute gpt-5.2-pro result for every medium-
  // confidence response that has one; fall back to gpt-5.2 baseline for
  // anything not yet escalated (so partial runs still produce a real,
  // clearly-labeled number, not a crash).
  const escalatedCorpus = baseline.map((r) => {
    const k = keyOf(r);
    if (mediumKeys.has(k) && escalationByKey.has(k)) {
      return escalationByKey.get(k);
    }
    return r;
  });

  console.log(`baseline corpus: ${baseline.length} photos (${mediumKeys.size} medium-confidence)`);
  console.log(`escalation results available: ${escalation.length} / ${mediumKeys.size} medium-confidence photos`);
  if (missingEscalation.length > 0) {
    console.log(`NOT YET ESCALATED (falling back to gpt-5.2 baseline for these ${missingEscalation.length}):`);
    for (const k of missingEscalation.slice(0, 10)) console.log(`  - ${k}`);
    if (missingEscalation.length > 10) console.log(`  ... and ${missingEscalation.length - 10} more`);
  }
  console.log('');

  function report(label, records) {
    const buckets = criterionBuckets(records);
    const m = metricsFromBuckets(buckets);
    const exactMatches = records.filter((r) => r.exact_match).length;
    console.log(`-- ${label} (n=${records.length} photos) --`);
    console.log(`  exact match: ${exactMatches}/${records.length} = ${pct(exactMatches / records.length)}`);
    console.log(`  F1: ${pct(m.f1)}  (precision ${pct(m.precision)}, recall ${pct(m.recall)})`);
    console.log(`  FAR: ${pct(m.far)}  FRR: ${pct(m.frr)}`);
    console.log(`  criteria: TP=${buckets.tp} FP=${buckets.fp} FN=${buckets.fn} TN=${buckets.tn} excluded(unable_to_determine)=${buckets.excluded}`);
    console.log('');
    return { buckets, m, exactMatches, n: records.length };
  }

  console.log('=== Full 200-photo corpus ===\n');
  report('gpt-5.2 alone (baseline, no escalation)', baseline);
  report('gpt-5.2 + gpt-5.2-pro escalation on medium-confidence (full-scale)', escalatedCorpus);

  console.log('=== Medium-confidence subset only (the population escalation actually changes) ===\n');
  const baselineMedium = baseline.filter((r) => mediumKeys.has(keyOf(r)));
  const escalatedMedium = escalatedCorpus.filter((r) => mediumKeys.has(keyOf(r)));
  report('gpt-5.2 alone, medium-confidence subset', baselineMedium);
  report('escalated to gpt-5.2-pro, medium-confidence subset', escalatedMedium);

  console.log('DR-1 thresholds for reference: exact match >=95%, F1 >=90%, FAR <=2%, FRR <=5%.');
}

main();
