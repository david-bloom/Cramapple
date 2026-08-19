// One-off hand-verification harness for ocr_criterion_decider.mjs -- runs
// it on the specific photos already hand-checked in
// HAND_DRAWN_REAL_PHOTO_GRADING_ACCURACY_2026_08_18.md ("Hand-verified on 3
// photos") plus known gold, dumps clusters + verdicts so a human can eyeball
// whether the orientation-invariant fix actually resolves the axis-role
// misassignment before trusting it on anything at scale.

import fs from 'node:fs';
import path from 'node:path';
import { runOcr, decideCriteria } from './ocr_criterion_decider.mjs';

const ROOT = path.resolve(new URL('.', import.meta.url).pathname, '..', '..');
const GOLD_JSONL = path.join(ROOT, 'docs', 'research', 'hand_drawn_graph_corpus_2026_06_29', 'hand_drawn_graph_questions_2026_06_29.jsonl');
const REAL_GOLD_JSON = path.join(ROOT, 'docs', 'research', 'hand_drawn_graph_real_photo_benchmark_2026_08_18', 'gold', 'real_photo_gold_labels_2026_08_18.json');
const OCR_BINARY = path.join(ROOT, 'scripts', 'vercel-gateway-check', 'vision_ocr');

const TARGETS = ['HDG-2026-P1-EST-016', 'HDG-2026-P1-SER-001', 'HDG-2026-P1-SER-002'];

function loadCorpusById() {
  const byId = new Map();
  for (const line of fs.readFileSync(GOLD_JSONL, 'utf8').split('\n').filter(Boolean)) {
    const r = JSON.parse(line);
    byId.set(r.item_id, r);
  }
  return byId;
}

async function main() {
  const corpusById = loadCorpusById();
  const realGold = JSON.parse(fs.readFileSync(REAL_GOLD_JSON, 'utf8'));

  for (const id of TARGETS) {
    const goldRow = realGold.find((r) => r.item_id === id);
    const corpusRecord = corpusById.get(id);
    const ocrItems = await runOcr(goldRow.file_path, OCR_BINARY);
    const { verdicts, clusters, numericTokenCount, totalOcrItemCount } = decideCriteria(ocrItems, corpusRecord);

    console.log(`\n=== ${id} (${corpusRecord.archetype}) ===`);
    console.log(`OCR items: ${totalOcrItemCount}, numeric tokens: ${numericTokenCount}, clusters.ok=${clusters.ok}`);
    console.log(`y-axis cluster: ${JSON.stringify(clusters.yAxisTokens.map((t) => t.rawText))}`);
    console.log(`x-axis cluster: ${JSON.stringify(clusters.xAxisTokens.map((t) => t.rawText))}`);
    for (const [k, v] of Object.entries(verdicts)) {
      const gold = goldRow.criterion_statuses[k];
      console.log(`  ${k}: OCR=${v}  gold=${gold}  ${v === gold ? 'MATCH' : 'DIFFER'}`);
    }
  }
}

main().catch((e) => { console.error(e); process.exit(1); });
