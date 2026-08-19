// Deterministic 20-photo smoke-test subsample for Experiment 1 (OCR alone)
// in docs/research/OCR_VALUE_ASSESSMENT_EXPERIMENT_DESIGN_2026_08_18.md.
// Stratified across all three archetypes, sorted for reproducibility --
// same convention as the escalation subsample scripts.

import fs from 'node:fs';
import path from 'node:path';

const ROOT = path.resolve(new URL('.', import.meta.url).pathname, '..', '..');
const GOLD_JSONL = path.join(ROOT, 'docs', 'research', 'hand_drawn_graph_corpus_2026_06_29', 'hand_drawn_graph_questions_2026_06_29.jsonl');
const OUT_DIR = path.join(ROOT, 'docs', 'research', 'hand_drawn_graph_real_photo_benchmark_2026_08_18');
const REAL_GOLD_JSON = path.join(OUT_DIR, 'gold', 'real_photo_gold_labels_2026_08_18.json');
const SUBSAMPLE_OUT = path.join(OUT_DIR, 'gold', 'ocr_smoke_subsample_2026_08_18.json');
const PER_ARCHETYPE = 7; // 3 archetypes x 7 (capped at available) ~= 20

function main() {
  const corpusById = new Map();
  for (const line of fs.readFileSync(GOLD_JSONL, 'utf8').split('\n').filter(Boolean)) {
    const r = JSON.parse(line);
    corpusById.set(r.item_id, r);
  }
  const realGold = JSON.parse(fs.readFileSync(REAL_GOLD_JSON, 'utf8'));

  const byArch = {};
  for (const r of realGold) {
    const corpusRecord = corpusById.get(r.item_id);
    if (!corpusRecord) continue;
    const a = corpusRecord.archetype;
    (byArch[a] = byArch[a] || []).push({ item_id: r.item_id, file_path: r.file_path, archetype: a });
  }

  let out = [];
  for (const a of Object.keys(byArch).sort()) {
    const sorted = byArch[a].slice().sort((x, y) => x.item_id.localeCompare(y.item_id) || x.file_path.localeCompare(y.file_path));
    out = out.concat(sorted.slice(0, PER_ARCHETYPE));
  }

  fs.mkdirSync(path.dirname(SUBSAMPLE_OUT), { recursive: true });
  fs.writeFileSync(SUBSAMPLE_OUT, JSON.stringify(out, null, 2));
  console.log(`wrote ${SUBSAMPLE_OUT}: ${out.length} photos (${PER_ARCHETYPE}/archetype cap)`);
}

main();
