// Full-corpus (all 200) self-consistency ensemble report (2026-08-20).
// Confirms/refutes the n=39 FAR pilot at full scale. Same asymmetric policy:
// run #1 = existing gpt-5.2 baseline (real_photo_benchmark_gpt52_results.jsonl,
// ALL 200 rows this time), runs #2/#3 = self_consistency_fullcorpus_extra_runs_2026_08_20.jsonl.
// "not_earned" never needs consensus; only "earned" does (only ever downgrade
// earned->not_earned on disagreement, never invent not_earned->earned).
// Emits JSON to stdout.

import fs from 'node:fs';
import path from 'node:path';

const ROOT = path.resolve(new URL('.', import.meta.url).pathname, '..', '..');
const OUT_DIR = path.join(ROOT, 'docs', 'research', 'hand_drawn_graph_real_photo_benchmark_2026_08_18');
const GPT52_RESULTS = path.join(OUT_DIR, 'runs', 'real_photo_benchmark_gpt52_results.jsonl');
const EXTRA_RUNS = process.env.SC_EXTRA_RUNS
  ? path.resolve(process.env.SC_EXTRA_RUNS)
  : path.join(OUT_DIR, 'runs', 'self_consistency_fullcorpus_extra_runs_2026_08_20.jsonl');

const ARCH_SHORT = {
  categorical_comparison_supplied_uncertainty: 'CAT',
  continuous_measured_series_supplied_uncertainty: 'SER',
  continuous_relationship_graph_derived_estimate: 'EST',
};

function keyOf(itemId, fileName) { return `${itemId} ${fileName}`; }
function newB() { return { tp: 0, fp: 0, fn: 0, tn: 0, excluded: 0 }; }
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
  const round = (x) => (Number.isFinite(x) ? Number((x * 100).toFixed(1)) : null);
  return { f1: round(f1), precision: round(p), recall: round(r), far: round(far), frr: round(frr), ...b };
}

function main() {
  const baselineRows = fs.readFileSync(GPT52_RESULTS, 'utf8').trim().split('\n').filter(Boolean).map((l) => JSON.parse(l));
  const baselineByKey = new Map(baselineRows.map((r) => [keyOf(r.item_id, r.file_name), r]));

  const extraByKey = new Map();
  for (const line of fs.readFileSync(EXTRA_RUNS, 'utf8').trim().split('\n').filter(Boolean)) {
    const r = JSON.parse(line);
    const k = keyOf(r.item_id, r.file_name);
    if (!extraByKey.has(k)) extraByKey.set(k, []);
    extraByKey.get(k).push(r);
  }

  const baseB = newB(), majB = newB(), unaB = newB();
  const perArchMaj = {}; // archetype -> buckets (majority policy)
  const perArchBase = {};
  let baseExact = 0, majExact = 0, unaExact = 0, n = 0, missing = 0;

  for (const [key, baseline] of baselineByKey) {
    const extras = extraByKey.get(key);
    if (!extras || extras.length < 2) { missing += 1; continue; }
    n += 1;
    const arch = ARCH_SHORT[baseline.archetype] || baseline.archetype;
    perArchMaj[arch] = perArchMaj[arch] || newB();
    perArchBase[arch] = perArchBase[arch] || newB();

    const gold = baseline.criterion_results.reduce((a, c) => { a[c.criterion_id] = c.gold; return a; }, {});
    const run1 = baseline.criterion_statuses;
    const run2 = extras.find((e) => e.run_index === 2)?.criterion_statuses || {};
    const run3 = extras.find((e) => e.run_index === 3)?.criterion_statuses || {};

    let bE = true, mE = true, uE = true;
    for (const cid of Object.keys(gold)) {
      const g = gold[cid], v1 = run1[cid], v2 = run2[cid], v3 = run3[cid];
      const earned = [v1, v2, v3].filter((v) => v === 'earned').length;
      const maj = v1 === 'earned' && earned < 2 ? 'not_earned' : v1;
      const una = v1 === 'earned' && earned < 3 ? 'not_earned' : v1;
      tally(baseB, g, v1); tally(perArchBase[arch], g, v1);
      tally(majB, g, maj); tally(perArchMaj[arch], g, maj);
      tally(unaB, g, una);
      if (v1 !== g) bE = false;
      if (maj !== g) mE = false;
      if (una !== g) uE = false;
    }
    if (bE) baseExact += 1;
    if (mE) majExact += 1;
    if (uE) unaExact += 1;
  }

  const out = {
    n_photos: n,
    missing_extra_runs: missing,
    baseline_run1_alone: { ...metrics(baseB), exact_match_pct: Number(((baseExact / n) * 100).toFixed(1)), exact_count: baseExact },
    majority_earned_2of3: { ...metrics(majB), exact_match_pct: Number(((majExact / n) * 100).toFixed(1)), exact_count: majExact },
    unanimous_earned_3of3: { ...metrics(unaB), exact_match_pct: Number(((unaExact / n) * 100).toFixed(1)), exact_count: unaExact },
    per_archetype_majority: Object.fromEntries(Object.entries(perArchMaj).map(([k, v]) => [k, metrics(v)])),
    per_archetype_baseline: Object.fromEntries(Object.entries(perArchBase).map(([k, v]) => [k, metrics(v)])),
  };
  console.log(JSON.stringify(out, null, 2));
}

main();
