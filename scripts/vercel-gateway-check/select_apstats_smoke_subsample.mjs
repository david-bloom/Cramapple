// Deterministic 20-photo smoke-test subsample for AP Statistics hand-drawn
// graph grading (Engine 4) -- the first-ever accuracy measurement attempt
// for this subject. Selects from the 28 Stats-HRD-2 photos already matched
// to item IDs in hand_drawn_samples_item_id_manifest_2026_08_18.json
// (scan_unlabeled_photos.mjs, OCR-based). Sorted ascending by filename for
// reproducibility, first 20 of 28 -- same convention as
// select_far_experiment_subsample.mjs.
//
// NOTE: item-ID matches here are OCR-derived and unverified by a human/model
// visual pass. This script only selects file paths; gold construction (a
// separate, required step) must visually confirm each item ID against the
// corpus's expected_graph_spec/display_table before trusting it, the same
// way the Biology real-photo gold was built by direct visual inspection.

import fs from 'node:fs';
import path from 'node:path';

const ROOT = path.resolve(new URL('.', import.meta.url).pathname, '..', '..');
const MANIFEST_PATH = path.join(ROOT, 'docs', 'research', 'hand_drawn_samples_item_id_manifest_2026_08_18.json');
const CORPUS_PATH = path.join(ROOT, 'docs', 'research', 'apstats_hdg_graph_corpus_2026_08_18', 'apstats_hdg_graph_questions_2026_08_18.jsonl');
const SAMPLES_ROOT = path.join(ROOT, 'docs', 'hand drawn samples');
const OUT_DIR = path.join(ROOT, 'docs', 'research', 'apstats_hdg_graph_real_photo_smoke_2026_08_19');
const SUBSAMPLE_OUT = path.join(OUT_DIR, 'gold', 'apstats_smoke_subsample_2026_08_19.json');
const N = 20;

function loadCorpus() {
  const byItemId = new Map();
  const lines = fs.readFileSync(CORPUS_PATH, 'utf8').trim().split('\n').filter(Boolean);
  for (const line of lines) {
    const record = JSON.parse(line);
    byItemId.set(record.item_id, record);
  }
  return byItemId;
}

function main() {
  const manifest = JSON.parse(fs.readFileSync(MANIFEST_PATH, 'utf8'));
  const corpus = loadCorpus();

  const statsEntries = manifest
    .filter((r) => (r.rel_path || '').startsWith('Stats-HRD-2/'))
    .filter((r) => Array.isArray(r.candidates ?? r.matched_item_ids ?? null) || true);

  // Manifest shape observed: each record has rel_path + a candidates-like
  // array of matched item ids under a key that varies by record type --
  // normalize by reading whichever array field is present and non-empty.
  const normalized = statsEntries.map((r) => {
    const candidateArr = Object.values(r).find((v) => Array.isArray(v) && v.length && typeof v[0] === 'string' && v[0].startsWith('APSTATS-'));
    return {
      rel_path: r.rel_path,
      item_id: candidateArr ? candidateArr[0] : null,
    };
  }).filter((r) => r.item_id && corpus.has(r.item_id));

  normalized.sort((a, b) => a.rel_path.localeCompare(b.rel_path));
  const selected = normalized.slice(0, N);

  const out = selected.map((r) => {
    const item = corpus.get(r.item_id);
    return {
      item_id: r.item_id,
      file_path: path.join(SAMPLES_ROOT, r.rel_path),
      archetype: item.archetype,
      manifest_match_source: 'ocr_scan_unlabeled_photos_2026_08_18_unverified',
    };
  });

  fs.mkdirSync(path.dirname(SUBSAMPLE_OUT), { recursive: true });
  fs.writeFileSync(SUBSAMPLE_OUT, JSON.stringify(out, null, 2));
  console.log(`wrote ${SUBSAMPLE_OUT}: ${out.length} photos (of ${normalized.length} matched, ${statsEntries.length} total Stats-HRD-2 files)`);
  for (const r of out) console.log(`  ${r.item_id}  ${path.basename(r.file_path)}  [${r.archetype}]`);
}

main();
