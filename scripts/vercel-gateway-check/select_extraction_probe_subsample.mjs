// Deterministic (no randomness) selection of the 42-photo stratified
// subsample used by hand_drawn_graph_extraction_probe_run.mjs. See that
// script's header comment for why this subsample and not the full 200.
//
// error pool: photos where the original joint VISION_FAST_ESC run got at
// least one of {Y_SCALE, X_SCALE, PLOT_VALUES, ESTIMATE_VALUE} wrong --
// 10 per archetype, sorted by item_id then file_path, first 10 taken.
// control pool: photos where all of those families were correct -- 4 per
// archetype, same deterministic ordering.
// Likely-misfiled photos (per the accuracy report's rationale-keyword scan)
// are excluded from both pools.

import fs from 'node:fs';
import path from 'node:path';

const ROOT = path.resolve(new URL('.', import.meta.url).pathname, '..', '..');
const OUT_DIR = path.join(ROOT, 'docs', 'research', 'hand_drawn_graph_real_photo_benchmark_2026_08_18');
const GOLD_JSON = path.join(OUT_DIR, 'gold', 'real_photo_gold_labels_2026_08_18.json');
const RESULTS_JSONL = path.join(OUT_DIR, 'runs', 'real_photo_benchmark_results.jsonl');
const SUBSAMPLE_OUT = path.join(OUT_DIR, 'gold', 'extraction_probe_subsample_2026_08_18.json');

const TARGET_FAMILIES = new Set(['Y_SCALE', 'X_SCALE', 'PLOT_VALUES', 'ESTIMATE_VALUE']);
const MISFILED_PATTERN = /does not match|different graph|not .*, shows|mislabel/i;

function famOf(criterionId) {
  return criterionId.replace(/_\d+$/, '');
}

function topPerArchetype(pool, nPerArch) {
  const byArch = {};
  for (const r of pool) {
    (byArch[r.archetype] = byArch[r.archetype] || []).push(r);
  }
  let out = [];
  for (const arch of Object.keys(byArch)) {
    const sorted = byArch[arch].slice().sort(
      (a, b) => a.item_id.localeCompare(b.item_id) || a.file_path.localeCompare(b.file_path),
    );
    out = out.concat(sorted.slice(0, nPerArch));
  }
  return out;
}

function main() {
  const gold = JSON.parse(fs.readFileSync(GOLD_JSON, 'utf8'));
  const results = fs.readFileSync(RESULTS_JSONL, 'utf8').trim().split('\n').map((l) => JSON.parse(l));

  const misfiledFilePaths = new Set(
    gold.filter((r) => MISFILED_PATTERN.test(r.rationale || '')).map((r) => r.file_path),
  );

  const withFilePath = results
    .map((r) => {
      const g = gold.find((entry) => entry.file_path.endsWith(r.file_name));
      return { ...r, file_path: g ? g.file_path : null };
    })
    .filter((r) => r.file_path && !misfiledFilePaths.has(r.file_path));

  const errorPool = withFilePath.filter((r) =>
    r.criterion_results.some((cr) => TARGET_FAMILIES.has(famOf(cr.criterion_id)) && !cr.correct),
  );
  const controlPool = withFilePath.filter((r) => !errorPool.includes(r));

  const errorSample = topPerArchetype(errorPool, 10);
  const controlSample = topPerArchetype(controlPool, 4);

  const subsample = errorSample.concat(controlSample).map((r) => ({
    item_id: r.item_id,
    file_path: r.file_path,
    archetype: r.archetype,
    pool: errorSample.includes(r) ? 'error' : 'control',
  }));

  fs.mkdirSync(path.dirname(SUBSAMPLE_OUT), { recursive: true });
  fs.writeFileSync(SUBSAMPLE_OUT, JSON.stringify(subsample, null, 2));
  console.log(`wrote ${SUBSAMPLE_OUT}: ${subsample.length} photos (${errorSample.length} error-pool, ${controlSample.length} control-pool)`);
}

main();
