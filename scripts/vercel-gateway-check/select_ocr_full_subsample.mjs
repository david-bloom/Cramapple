// Full-scale companion to the OCR axis probe's 42-photo subsample. Builds
// a 200-entry subsample (item_id, file_path, archetype, pool) from the
// full real-photo gold set, in the same shape ocr_axis_probe.mjs expects,
// so the probe can run at the same scale as the escalation test instead of
// the original 42-photo error/OK split.

import fs from 'node:fs';
import path from 'node:path';

const ROOT = path.resolve(new URL('.', import.meta.url).pathname, '..', '..');
const GOLD_JSONL = path.join(
  ROOT, 'docs', 'research', 'hand_drawn_graph_corpus_2026_06_29',
  'hand_drawn_graph_questions_2026_06_29.jsonl',
);
const OUT_DIR = path.join(ROOT, 'docs', 'research', 'hand_drawn_graph_real_photo_benchmark_2026_08_18');
const REAL_GOLD_JSON = path.join(OUT_DIR, 'gold', 'real_photo_gold_labels_2026_08_18.json');
const SUBSAMPLE_OUT = path.join(OUT_DIR, 'gold', 'ocr_full_subsample_2026_08_18.json');

function main() {
  const corpusById = new Map();
  for (const line of fs.readFileSync(GOLD_JSONL, 'utf8').split('\n').filter(Boolean)) {
    const record = JSON.parse(line);
    corpusById.set(record.item_id, record);
  }

  const realGold = JSON.parse(fs.readFileSync(REAL_GOLD_JSON, 'utf8'));
  const out = realGold
    .map((r) => {
      const corpusRecord = corpusById.get(r.item_id);
      if (!corpusRecord) return null;
      return {
        item_id: r.item_id,
        file_path: r.file_path,
        archetype: corpusRecord.archetype,
        pool: 'full_200',
      };
    })
    .filter(Boolean)
    .sort((a, b) => a.item_id.localeCompare(b.item_id) || a.file_path.localeCompare(b.file_path));

  fs.mkdirSync(path.dirname(SUBSAMPLE_OUT), { recursive: true });
  fs.writeFileSync(SUBSAMPLE_OUT, JSON.stringify(out, null, 2));
  console.log(`wrote ${SUBSAMPLE_OUT}: ${out.length} photos (${realGold.length - out.length} skipped, no corpus match)`);
}

main();
