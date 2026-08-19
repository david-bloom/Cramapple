// Archetype-gated escalation policy check -- zero additional API spend,
// reuses the full-scale escalation results already computed
// (escalation_full_results.jsonl, 105/105).
//
// The full-scale blanket-escalation result
// (hand_drawn_graph_escalation_full_scale_report.mjs) showed escalation is a
// clean win for the `continuous_relationship_graph_derived_estimate` (EST)
// archetype but a net loss for CAT/SER (FN roughly doubles in both). This
// script tests the obvious next policy: escalate EST's medium-confidence
// responses only, leave CAT/SER on gpt-5.2's primary call.

import fs from 'node:fs';
import path from 'node:path';

const ROOT = path.resolve(new URL('.', import.meta.url).pathname, '..', '..');
const OUT_DIR = path.join(ROOT, 'docs', 'research', 'hand_drawn_graph_real_photo_benchmark_2026_08_18');
const BASELINE_JSONL = path.join(OUT_DIR, 'runs', 'real_photo_benchmark_gpt52_results.jsonl');
const ESCALATION_JSONL = path.join(OUT_DIR, 'runs', 'escalation_full_results.jsonl');
const GATED_ARCHETYPE = 'continuous_relationship_graph_derived_estimate'; // EST

function loadJsonl(filePath) {
  return fs.readFileSync(filePath, 'utf8').trim().split('\n').filter(Boolean).map((l) => JSON.parse(l));
}

function keyOf(r) {
  return `${r.item_id} ${r.file_name}`;
}

function metrics(records) {
  let tp = 0, fp = 0, fn = 0, tn = 0, excluded = 0, exact = 0;
  for (const r of records) {
    if (r.exact_match) exact += 1;
    for (const c of r.criterion_results || []) {
      if (c.gold === 'unable_to_determine' || c.predicted === 'unable_to_determine' || c.predicted === null) {
        excluded += 1;
        continue;
      }
      if (c.gold === 'earned' && c.predicted === 'earned') tp += 1;
      else if (c.gold === 'not_earned' && c.predicted === 'earned') fp += 1;
      else if (c.gold === 'earned' && c.predicted === 'not_earned') fn += 1;
      else if (c.gold === 'not_earned' && c.predicted === 'not_earned') tn += 1;
    }
  }
  const precision = tp / (tp + fp);
  const recall = tp / (tp + fn);
  const f1 = (2 * precision * recall) / (precision + recall);
  const far = fp / (fp + tn);
  const frr = fn / (fn + tp);
  return {
    n: records.length,
    exact_match: `${(exact / records.length * 100).toFixed(1)}%`,
    f1: `${(f1 * 100).toFixed(1)}%`,
    precision: `${(precision * 100).toFixed(1)}%`,
    recall: `${(recall * 100).toFixed(1)}%`,
    far: `${(far * 100).toFixed(1)}%`,
    frr: `${(frr * 100).toFixed(1)}%`,
    buckets: { tp, fp, fn, tn, excluded },
  };
}

function main() {
  const baseline = loadJsonl(BASELINE_JSONL);
  const escalation = loadJsonl(ESCALATION_JSONL);
  const escalationByKey = new Map(escalation.map((r) => [keyOf(r), r]));

  const gatedCorpus = baseline.map((r) => {
    const k = keyOf(r);
    if (r.confidence === 'medium' && r.archetype === GATED_ARCHETYPE && escalationByKey.has(k)) {
      return escalationByKey.get(k);
    }
    return r;
  });

  console.log(`Policy: escalate ${GATED_ARCHETYPE} medium-confidence responses only, gpt-5.2 primary for everything else.\n`);
  console.log('baseline (gpt-5.2 alone, full 200):', JSON.stringify(metrics(baseline), null, 1));
  console.log('\nEST-gated escalation (full 200):', JSON.stringify(metrics(gatedCorpus), null, 1));
  console.log('\nDR-1 thresholds for reference: exact match >=95%, F1 >=90%, FAR <=2%, FRR <=5%.');
}

main();
