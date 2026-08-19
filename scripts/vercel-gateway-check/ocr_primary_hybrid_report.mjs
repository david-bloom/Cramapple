// Free (no new API calls) test of "OCR decides where confident, gpt-5.2's
// existing prediction fills in everywhere else" -- full 200-photo corpus.
// Per the design doc's note that this cannot reduce gpt-5.2 call volume in
// the current single-joint-call architecture (every response needs a
// vision call regardless of what OCR decides), this ONLY tests the
// accuracy question: does swapping in OCR's verdict on its answerable
// criteria help or hurt vs. gpt-5.2 alone, given gpt-5.2 already scores
// 94.8% F1 on that exact subset on its own.

import fs from 'node:fs';
import path from 'node:path';
import { runOcr, decideCriteria } from './ocr_criterion_decider.mjs';

const ROOT = path.resolve(new URL('.', import.meta.url).pathname, '..', '..');
const GOLD_JSONL = path.join(ROOT, 'docs', 'research', 'hand_drawn_graph_corpus_2026_06_29', 'hand_drawn_graph_questions_2026_06_29.jsonl');
const OUT_DIR = path.join(ROOT, 'docs', 'research', 'hand_drawn_graph_real_photo_benchmark_2026_08_18');
const SUBSAMPLE_JSON = path.join(OUT_DIR, 'gold', 'ocr_full_subsample_2026_08_18.json');
const GPT52_RESULTS = path.join(OUT_DIR, 'runs', 'real_photo_benchmark_gpt52_results.jsonl');
const OCR_BINARY = path.join(ROOT, 'scripts', 'vercel-gateway-check', 'vision_ocr');
const SAMPLES_ROOT = path.join(ROOT, 'docs', 'hand drawn samples');

const OCR_ANSWERABLE = new Set(['X_SCALE', 'Y_SCALE', 'X_UNIT', 'Y_UNIT', 'ESTIMATE_VALUE']);

function loadCorpusById() {
  const byId = new Map();
  for (const line of fs.readFileSync(GOLD_JSONL, 'utf8').split('\n').filter(Boolean)) {
    const r = JSON.parse(line);
    byId.set(r.item_id, r);
  }
  return byId;
}

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

async function main() {
  const corpusById = loadCorpusById();
  const subsample = JSON.parse(fs.readFileSync(SUBSAMPLE_JSON, 'utf8'));
  const gpt52ByKey = new Map();
  for (const line of fs.readFileSync(GPT52_RESULTS, 'utf8').trim().split('\n').filter(Boolean)) {
    const r = JSON.parse(line);
    gpt52ByKey.set(`${r.item_id} ${path.resolve(path.join(SAMPLES_ROOT, r.file_name))}`, r);
  }

  const baselineBuckets = { tp: 0, fp: 0, fn: 0, tn: 0, excluded: 0 };
  const hybridBuckets = { tp: 0, fp: 0, fn: 0, tn: 0, excluded: 0 };
  let baselineExact = 0, hybridExact = 0, n = 0;
  let ocrSubstitutions = 0, ocrAbstentions = 0;
  let swapHelped = 0, swapHurt = 0;

  for (const item of subsample) {
    const corpusRecord = corpusById.get(item.item_id);
    const key = `${item.item_id} ${path.resolve(item.file_path)}`;
    const gpt52Row = gpt52ByKey.get(key);
    if (!gpt52Row) continue;
    n += 1;

    let ocrVerdicts = {};
    try {
      const ocrItems = await runOcr(item.file_path, OCR_BINARY);
      ocrVerdicts = decideCriteria(ocrItems, corpusRecord).verdicts;
    } catch (e) {
      // Known Swift-binary JSON-parse failure on a single CAT photo (see
      // the full-scale OCR probe run) -- treat as "OCR found nothing,"
      // consistent with how a real pipeline would fail open to gpt-5.2.
    }

    const gpt52ByCriterion = {};
    for (const c of gpt52Row.criterion_results || []) gpt52ByCriterion[c.criterion_id] = c.predicted;
    const goldByCriterion = {};
    for (const c of gpt52Row.criterion_results || []) goldByCriterion[c.criterion_id] = c.gold;

    let baselineRowExact = true, hybridRowExact = true;
    for (const criterionId of Object.keys(goldByCriterion)) {
      const gold = goldByCriterion[criterionId];
      const gpt52Verdict = gpt52ByCriterion[criterionId];
      tally(baselineBuckets, gold, gpt52Verdict);
      if (gpt52Verdict !== gold) baselineRowExact = false;

      let hybridVerdict = gpt52Verdict;
      if (OCR_ANSWERABLE.has(criterionId)) {
        const ocrV = ocrVerdicts[criterionId];
        if (ocrV && ocrV !== 'unable_to_determine') {
          hybridVerdict = ocrV;
          ocrSubstitutions += 1;
          if (ocrV === gold && gpt52Verdict !== gold) swapHelped += 1;
          if (ocrV !== gold && gpt52Verdict === gold) swapHurt += 1;
        } else {
          ocrAbstentions += 1;
        }
      }
      tally(hybridBuckets, gold, hybridVerdict);
      if (hybridVerdict !== gold) hybridRowExact = false;
    }
    if (baselineRowExact) baselineExact += 1;
    if (hybridRowExact) hybridExact += 1;
    process.stdout.write(`${item.item_id} done (${n}/${subsample.length})\r`);
  }

  console.log(`\n\n=== OCR-primary-substitution hybrid vs gpt-5.2 alone, full ${n}-photo corpus ===\n`);
  console.log(`OCR substituted ${ocrSubstitutions} criterion verdicts, abstained ${ocrAbstentions} times`);
  console.log(`  Of substitutions: helped (fixed a gpt-5.2 error) ${swapHelped}, hurt (broke a gpt-5.2 correct) ${swapHurt}, net ${swapHelped - swapHurt}\n`);
  console.log('gpt-5.2 alone:', JSON.stringify(metrics(baselineBuckets)));
  console.log(`  exact match: ${baselineExact}/${n} = ${pct(baselineExact / n)}\n`);
  console.log('OCR-substituted hybrid:', JSON.stringify(metrics(hybridBuckets)));
  console.log(`  exact match: ${hybridExact}/${n} = ${pct(hybridExact / n)}`);
}

main().catch((e) => { console.error(e); process.exit(1); });
