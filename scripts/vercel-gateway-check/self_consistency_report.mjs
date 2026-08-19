// Analysis for FAR-reduction experiment 1 (self-consistency ensemble).
// Combines: run #1 = existing gpt-5.2 baseline
// (real_photo_benchmark_gpt52_results.jsonl, restricted to the pilot
// subsample), runs #2/#3 = self_consistency_extra_runs_results.jsonl.
// Reports baseline (run #1 alone) vs two asymmetric ensemble policies:
// majority-earned (2 of 3) and unanimous-earned (3 of 3) -- "not_earned"
// never needs consensus in either policy, only "earned" does.

import fs from 'node:fs';
import path from 'node:path';

const ROOT = path.resolve(new URL('.', import.meta.url).pathname, '..', '..');
const SAMPLES_ROOT = path.join(ROOT, 'docs', 'hand drawn samples');
const OUT_DIR = path.join(ROOT, 'docs', 'research', 'hand_drawn_graph_real_photo_benchmark_2026_08_18');
const GPT52_RESULTS = path.join(OUT_DIR, 'runs', 'real_photo_benchmark_gpt52_results.jsonl');
const EXTRA_RUNS = path.join(OUT_DIR, 'runs', 'self_consistency_extra_runs_results.jsonl');
const SUBSAMPLE_JSON = path.join(OUT_DIR, 'gold', 'far_experiment_subsample_2026_08_18.json');

function keyOf(itemId, fileName) { return `${itemId} ${fileName}`; }

function tally(b, gold, pred) {
  if (pred === undefined || pred === 'unable_to_determine' || gold === 'unable_to_determine') { b.excluded += 1; return; }
  if (gold === 'earned' && pred === 'earned') b.tp += 1;
  else if (gold === 'not_earned' && pred === 'earned') b.fp += 1;
  else if (gold === 'earned' && pred === 'not_earned') b.fn += 1;
  else if (gold === 'not_earned' && pred === 'not_earned') b.tn += 1;
}
function metrics(b) {
  const p = b.tp / (b.tp + b.fp), r = b.tp / (b.tp + b.fn), f1 = (2 * p * r) / (p + r);
  const far = b.fp / (b.fp + b.tn), frr = b.fn / (b.fn + b.tp);
  return { f1: pct(f1), precision: pct(p), recall: pct(r), far: pct(far), frr: pct(frr), ...b };
}
function pct(x) { return Number.isFinite(x) ? `${(x * 100).toFixed(1)}%` : 'n/a'; }

function main() {
  const subsample = JSON.parse(fs.readFileSync(SUBSAMPLE_JSON, 'utf8'));
  const subsampleKeys = new Set(subsample.map((p) => keyOf(p.item_id, path.relative(SAMPLES_ROOT, p.file_path))));

  const baselineByKey = new Map();
  for (const line of fs.readFileSync(GPT52_RESULTS, 'utf8').trim().split('\n').filter(Boolean)) {
    const r = JSON.parse(line);
    const k = keyOf(r.item_id, r.file_name);
    if (subsampleKeys.has(k)) baselineByKey.set(k, r);
  }

  const extraByKey = new Map(); // key -> [run2rec, run3rec]
  if (fs.existsSync(EXTRA_RUNS)) {
    for (const line of fs.readFileSync(EXTRA_RUNS, 'utf8').trim().split('\n').filter(Boolean)) {
      const r = JSON.parse(line);
      const k = keyOf(r.item_id, r.file_name);
      if (!extraByKey.has(k)) extraByKey.set(k, []);
      extraByKey.get(k).push(r);
    }
  }

  const baselineBuckets = { tp: 0, fp: 0, fn: 0, tn: 0, excluded: 0 };
  const majorityBuckets = { tp: 0, fp: 0, fn: 0, tn: 0, excluded: 0 };
  const unanimousBuckets = { tp: 0, fp: 0, fn: 0, tn: 0, excluded: 0 };
  let baselineExact = 0, majorityExact = 0, unanimousExact = 0, n = 0;
  let missingExtra = 0;

  for (const key of subsampleKeys) {
    const baseline = baselineByKey.get(key);
    const extras = extraByKey.get(key);
    if (!baseline || !extras || extras.length < 2) { missingExtra += 1; continue; }
    n += 1;

    const gold = baseline.criterion_results.reduce((acc, c) => { acc[c.criterion_id] = c.gold; return acc; }, {});
    const run1 = baseline.criterion_statuses;
    const run2 = extras.find((e) => e.run_index === 2)?.criterion_statuses || {};
    const run3 = extras.find((e) => e.run_index === 3)?.criterion_statuses || {};

    let baselineRowExact = true, majorityRowExact = true, unanimousRowExact = true;
    for (const criterionId of Object.keys(gold)) {
      const g = gold[criterionId];
      const v1 = run1[criterionId], v2 = run2[criterionId], v3 = run3[criterionId];
      const votes = [v1, v2, v3];
      const earnedCount = votes.filter((v) => v === 'earned').length;

      tally(baselineBuckets, g, v1);
      if (v1 !== g) baselineRowExact = false;

      // Asymmetric: "earned" needs consensus; if not met, the criterion
      // falls back to whatever run #1 said IF it wasn't "earned" (i.e. we
      // only ever downgrade earned->not_earned on disagreement, never
      // invent a new not_earned->earned).
      const majorityVerdict = v1 === 'earned' && earnedCount < 2 ? 'not_earned' : v1;
      const unanimousVerdict = v1 === 'earned' && earnedCount < 3 ? 'not_earned' : v1;

      tally(majorityBuckets, g, majorityVerdict);
      if (majorityVerdict !== g) majorityRowExact = false;
      tally(unanimousBuckets, g, unanimousVerdict);
      if (unanimousVerdict !== g) unanimousRowExact = false;
    }
    if (baselineRowExact) baselineExact += 1;
    if (majorityRowExact) majorityExact += 1;
    if (unanimousRowExact) unanimousExact += 1;
  }

  console.log(`n=${n} photos with all 3 runs (${missingExtra} missing extra runs, skipped)\n`);
  console.log('-- baseline (run #1 alone) --');
  console.log(JSON.stringify(metrics(baselineBuckets)));
  console.log(`exact match: ${baselineExact}/${n} = ${pct(baselineExact / n)}\n`);

  console.log('-- majority-earned (2 of 3 runs must say earned) --');
  console.log(JSON.stringify(metrics(majorityBuckets)));
  console.log(`exact match: ${majorityExact}/${n} = ${pct(majorityExact / n)}\n`);

  console.log('-- unanimous-earned (3 of 3 runs must say earned) --');
  console.log(JSON.stringify(metrics(unanimousBuckets)));
  console.log(`exact match: ${unanimousExact}/${n} = ${pct(unanimousExact / n)}`);
}

main();
