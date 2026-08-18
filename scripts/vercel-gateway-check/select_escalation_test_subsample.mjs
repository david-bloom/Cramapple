// Deterministic (no randomness) selection of the escalation controlled-test
// subsample. The population is deliberately gpt-5.2's MEDIUM-confidence
// responses -- exactly what a real confidence-gated escalation policy would
// route to a second-pass model -- not a random or archetype-only sample.
// 7 per archetype (21 total), sorted by item_id/file_name for reproducibility.
// See docs/research/HAND_DRAWN_REAL_PHOTO_GRADING_ACCURACY_2026_08_18.md,
// "Escalation controlled test" section for why this population was chosen.

import fs from 'node:fs';
import path from 'node:path';

const ROOT = path.resolve(new URL('.', import.meta.url).pathname, '..', '..');
const OUT_DIR = path.join(ROOT, 'docs', 'research', 'hand_drawn_graph_real_photo_benchmark_2026_08_18');
const GPT52_RESULTS = path.join(OUT_DIR, 'runs', 'real_photo_benchmark_gpt52_results.jsonl');
const SUBSAMPLE_OUT = path.join(OUT_DIR, 'gold', 'escalation_test_subsample_2026_08_18.json');
const PER_ARCHETYPE = 7;

function main() {
  const records = fs.readFileSync(GPT52_RESULTS, 'utf8').trim().split('\n').map((l) => JSON.parse(l));
  const medium = records.filter((r) => r.confidence === 'medium');

  const byArch = {};
  for (const r of medium) {
    (byArch[r.archetype] = byArch[r.archetype] || []).push(r);
  }

  let subsample = [];
  for (const arch of Object.keys(byArch).sort()) {
    const sorted = byArch[arch].slice().sort((a, b) => a.item_id.localeCompare(b.item_id) || a.file_name.localeCompare(b.file_name));
    subsample = subsample.concat(sorted.slice(0, PER_ARCHETYPE));
  }

  const SAMPLES_ROOT = path.join(ROOT, 'docs', 'hand drawn samples');
  const out = subsample.map((r) => ({
    item_id: r.item_id,
    file_path: path.join(SAMPLES_ROOT, r.file_name),
    archetype: r.archetype,
    gpt52_confidence: r.confidence,
    gpt52_exact_match: r.exact_match,
  }));

  fs.mkdirSync(path.dirname(SUBSAMPLE_OUT), { recursive: true });
  fs.writeFileSync(SUBSAMPLE_OUT, JSON.stringify(out, null, 2));
  console.log(`wrote ${SUBSAMPLE_OUT}: ${out.length} photos (${PER_ARCHETYPE} per archetype, all gpt-5.2 medium-confidence)`);
}

main();
