// Analysis for FAR-reduction experiment 2 (adversarial re-check pass).
// Baseline vs baseline-with-overturns: any originally-"earned" criterion
// the adversarial pass did NOT uphold is downgraded to not_earned.
// "not_earned" verdicts are untouched (never re-examined).

import fs from 'node:fs';
import path from 'node:path';

const ROOT = path.resolve(new URL('.', import.meta.url).pathname, '..', '..');
const SAMPLES_ROOT = path.join(ROOT, 'docs', 'hand drawn samples');
const OUT_DIR = path.join(ROOT, 'docs', 'research', 'hand_drawn_graph_real_photo_benchmark_2026_08_18');
const GPT52_RESULTS = path.join(OUT_DIR, 'runs', 'real_photo_benchmark_gpt52_results.jsonl');
const RECHECK_RESULTS = path.join(OUT_DIR, 'runs', 'adversarial_recheck_results.jsonl');
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

  const recheckByKey = new Map();
  for (const line of fs.readFileSync(RECHECK_RESULTS, 'utf8').trim().split('\n').filter(Boolean)) {
    const r = JSON.parse(line);
    recheckByKey.set(keyOf(r.item_id, r.file_name), r);
  }

  const baselineBuckets = { tp: 0, fp: 0, fn: 0, tn: 0, excluded: 0 };
  const recheckedBuckets = { tp: 0, fp: 0, fn: 0, tn: 0, excluded: 0 };
  let baselineExact = 0, recheckedExact = 0, n = 0, missing = 0;
  let overturnsTotal = 0, overturnsCorrect = 0, overturnsWrong = 0; // correct = gold was not_earned; wrong = gold was earned

  for (const key of subsampleKeys) {
    const baseline = baselineByKey.get(key);
    const recheck = recheckByKey.get(key);
    if (!baseline || !recheck) { missing += 1; continue; }
    n += 1;

    const gold = baseline.criterion_results.reduce((acc, c) => { acc[c.criterion_id] = c.gold; return acc; }, {});
    const run1 = baseline.criterion_statuses;

    let baselineRowExact = true, recheckedRowExact = true;
    for (const criterionId of Object.keys(gold)) {
      const g = gold[criterionId];
      const v1 = run1[criterionId];
      tally(baselineBuckets, g, v1);
      if (v1 !== g) baselineRowExact = false;

      let recheckedVerdict = v1;
      if (v1 === 'earned' && recheck.verdicts && criterionId in recheck.verdicts) {
        const upheld = recheck.verdicts[criterionId].upheld;
        if (!upheld) {
          recheckedVerdict = 'not_earned';
          overturnsTotal += 1;
          if (g === 'not_earned') overturnsCorrect += 1; else if (g === 'earned') overturnsWrong += 1;
        }
      }
      tally(recheckedBuckets, g, recheckedVerdict);
      if (recheckedVerdict !== g) recheckedRowExact = false;
    }
    if (baselineRowExact) baselineExact += 1;
    if (recheckedRowExact) recheckedExact += 1;
  }

  console.log(`n=${n} photos (${missing} missing recheck data, skipped)\n`);
  console.log(`Overturns: ${overturnsTotal} total (${overturnsCorrect} correct -- gold was not_earned, real FAR catches; ${overturnsWrong} wrong -- gold was earned, false negatives introduced)\n`);

  console.log('-- baseline (no re-check) --');
  console.log(JSON.stringify(metrics(baselineBuckets)));
  console.log(`exact match: ${baselineExact}/${n} = ${pct(baselineExact / n)}\n`);

  console.log('-- with adversarial re-check applied --');
  console.log(JSON.stringify(metrics(recheckedBuckets)));
  console.log(`exact match: ${recheckedExact}/${n} = ${pct(recheckedExact / n)}`);
}

main();
