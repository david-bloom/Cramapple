// Dedicated-OCR probe -- tests whether a genuine, non-LLM OCR engine (macOS
// Vision framework's VNRecognizeTextRequest, .accurate recognition level,
// language correction off since these are numbers not words) reads axis
// tick numbers and the written estimate value more reliably than the VLMs
// tested all session. Every VLM (gpt-4o-mini through gpt-5.2-pro) does this
// task as one forward pass that never explicitly measures anything; OCR is
// a genuinely different tool -- real, dedicated text recognition, not a
// general vision-language model. See docs/research/HAND_DRAWN_REAL_PHOTO_GRADING_ACCURACY_2026_08_18.md,
// "Dedicated-OCR probe" section, for why this was tried and what it can/
// can't answer -- it has no point/marker-detection step, so it cannot
// score PLOT_VALUES directly, only axis calibration (axis_range_ok) and
// the written estimate annotation (estimate_ok), on the SAME 42-photo
// subsample and SAME scoring definitions as the original VLM extraction
// probe (spike 1: axis_range_ok 67.9%, estimate_ok 28.6%), for a fair,
// apples-to-apples comparison.
//
// Requires the compiled vision_ocr Swift binary (built from
// scripts/vercel-gateway-check/vision_ocr.swift, macOS Vision framework,
// no API key, no network call, no cost -- entirely local).

import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import { execFileSync } from 'node:child_process';
import sharp from 'sharp';

const ROOT = path.resolve(new URL('.', import.meta.url).pathname, '..', '..');
const GOLD_JSONL = path.join(
  ROOT, 'docs', 'research', 'hand_drawn_graph_corpus_2026_06_29',
  'hand_drawn_graph_questions_2026_06_29.jsonl',
);
const SUBSAMPLE_JSON = path.join(
  ROOT, 'docs', 'research', 'hand_drawn_graph_real_photo_benchmark_2026_08_18',
  'gold', process.env.OCR_PROBE_SUBSAMPLE || 'extraction_probe_subsample_2026_08_18.json',
);
const OUT_DIR = path.join(ROOT, 'docs', 'research', 'hand_drawn_graph_real_photo_benchmark_2026_08_18');
const OUTPUT_JSONL = path.join(OUT_DIR, 'runs', process.env.OCR_PROBE_OUTPUT || 'ocr_axis_probe_results.jsonl');
const OCR_BINARY = process.argv[2] || path.join(ROOT, 'scripts', 'vercel-gateway-check', 'vision_ocr');

function loadCorpusById() {
  const byItemId = new Map();
  const lines = fs.readFileSync(GOLD_JSONL, 'utf8').split('\n').filter(Boolean);
  for (const line of lines) {
    const record = JSON.parse(line);
    byItemId.set(record.item_id, record);
  }
  return byItemId;
}

function isCategorical(corpusRecord) {
  return corpusRecord.archetype === 'categorical_comparison_supplied_uncertainty';
}

async function runOcr(filePath) {
  // Swift's NSImage/CGImage load does NOT auto-apply EXIF orientation, so a
  // portrait-photographed-landscape-content page (common in this real-photo
  // corpus, see spike 2's crop preprocessing) comes out with axis text
  // running sideways -- breaking the left/bottom position heuristic below.
  // sharp().rotate() with no other args auto-corrects EXIF orientation
  // (same fix already proven in hand_drawn_graph_extraction_probe_crop_run.mjs).
  const normalizedPath = path.join(os.tmpdir(), `ocr_normalized_${Date.now()}_${Math.random().toString(36).slice(2)}.jpg`);
  await sharp(filePath).rotate().jpeg({ quality: 95 }).toFile(normalizedPath);
  try {
    const raw = execFileSync(OCR_BINARY, [normalizedPath], { maxBuffer: 10 * 1024 * 1024 }).toString('utf8');
    return JSON.parse(raw);
  } finally {
    fs.unlinkSync(normalizedPath);
  }
}

// Normalize OCR quirks seen in practice: '•' or a stray mid-digit '-' used
// in place of a decimal point (e.g. "25 . 652" OCR'd as "25 • 652", or
// "-37.312" OCR'd as "- 37-312"). Leading '-' is preserved as a real minus
// sign; only a '-' BETWEEN two digit groups (not at the very start) is
// treated as a mis-read decimal point.
function normalizeNumericText(text) {
  let s = text.trim();
  const isNegative = /^-/.test(s) || /^\s*-/.test(s);
  s = s.replace(/^-\s*/, ''); // strip leading minus, re-add after normalization
  s = s.replace(/•/g, '.');
  s = s.replace(/(\d)\s*-\s*(\d)/g, '$1.$2'); // mid-digit '-' -> '.'
  s = s.replace(/\s+/g, '');
  const num = Number(s);
  if (!Number.isFinite(num)) return null;
  return isNegative ? -Math.abs(num) : num;
}

function extractNumericTokens(ocrItems) {
  const out = [];
  for (const item of ocrItems) {
    const value = normalizeNumericText(item.text);
    if (value !== null) {
      out.push({ value, x: item.x, y: item.y, confidence: item.confidence, rawText: item.text });
    }
  }
  return out;
}

function scoreAxisAndEstimate(corpusRecord, ocrItems) {
  const categorical = isCategorical(corpusRecord);
  const table = corpusRecord.display_table;
  const numericTokens = extractNumericTokens(ocrItems);

  const out = { axis_range_ok: null, estimate_ok: null };

  if (!categorical) {
    const yKey = Object.keys(table[0]).find((k) => k.toLowerCase().includes('mean') || k.toLowerCase().includes('percent') || k.toLowerCase().includes(corpusRecord.expected_graph_spec.y_axis.toLowerCase().split(' ')[0]));
    const xValues = table.map((row) => row[Object.keys(row).find((k) => k !== yKey && !k.toLowerCase().includes('sem'))]);
    const yValues = table.map((row) => row[yKey]);
    const trueXMin = Math.min(...xValues), trueXMax = Math.max(...xValues);
    const trueYMin = Math.min(...yValues), trueYMax = Math.max(...yValues);

    // OCR gives no axis-membership label, so use position: y-axis tick text
    // sits along the left edge (low x, OCR coords 0=left..1=right), x-axis
    // tick text sits along the bottom (low y, OCR coords 0=bottom..1=top in
    // Vision's normalized space). Thresholds are generous since exact
    // layout varies by photo.
    const yAxisCandidates = numericTokens.filter((t) => t.x < 0.30);
    const xAxisCandidates = numericTokens.filter((t) => t.x >= 0.30 && t.y < 0.45);

    if (yAxisCandidates.length >= 2 && xAxisCandidates.length >= 2) {
      const detectedYMin = Math.min(...yAxisCandidates.map((t) => t.value));
      const detectedYMax = Math.max(...yAxisCandidates.map((t) => t.value));
      const detectedXMin = Math.min(...xAxisCandidates.map((t) => t.value));
      const detectedXMax = Math.max(...xAxisCandidates.map((t) => t.value));
      const margin = 0.35;
      const xSpan = Math.max(trueXMax - trueXMin, 1e-6);
      const ySpan = Math.max(trueYMax - trueYMin, 1e-6);
      const xOk = detectedXMin <= trueXMin + margin * xSpan && detectedXMax >= trueXMax - margin * xSpan;
      const yOk = detectedYMin <= trueYMin + margin * ySpan && detectedYMax >= trueYMax - margin * ySpan;
      out.axis_range_ok = xOk && yOk;
    } else {
      out.axis_range_ok = false; // couldn't even detect enough tick text
    }
  }

  if (corpusRecord.archetype === 'continuous_relationship_graph_derived_estimate') {
    const expected = corpusRecord.expected_graph_spec.expected_estimate_approx;
    // The estimate annotation is free text like "estimate ~0.34" -- pull the
    // last number-like token out of any OCR item containing "estimate".
    const estimateItem = ocrItems.find((it) => /estimate/i.test(it.text));
    let estimateValue = null;
    if (estimateItem) {
      const match = estimateItem.text.match(/-?[\d.]+/g);
      if (match) {
        const last = match[match.length - 1];
        const parsed = normalizeNumericText(last);
        if (parsed !== null) estimateValue = parsed;
      }
    }
    out.estimate_ok = estimateValue !== null && Math.abs(estimateValue - expected) / Math.max(Math.abs(expected), 1e-6) <= 0.25;
  }

  return out;
}

async function main() {
  const subsample = JSON.parse(fs.readFileSync(SUBSAMPLE_JSON, 'utf8'));
  const corpusById = loadCorpusById();

  console.log(`OCR axis probe: ${subsample.length} photos (local, no API cost)`);
  fs.mkdirSync(path.dirname(OUTPUT_JSONL), { recursive: true });
  const output = fs.createWriteStream(OUTPUT_JSONL, { flags: 'w' });

  for (const item of subsample) {
    const corpusRecord = corpusById.get(item.item_id);
    if (!corpusRecord) continue;
    let ocrItems = [];
    let ok = true;
    let error = '';
    try {
      ocrItems = await runOcr(item.file_path);
    } catch (e) {
      ok = false;
      error = e.message || String(e);
    }
    const score = ok ? scoreAxisAndEstimate(corpusRecord, ocrItems) : { axis_range_ok: null, estimate_ok: null };
    const result = {
      item_id: item.item_id,
      file_path: item.file_path,
      archetype: item.archetype,
      pool: item.pool,
      ok,
      error,
      ocr_item_count: ocrItems.length,
      score,
    };
    output.write(`${JSON.stringify(result)}\n`);
    process.stdout.write(`${item.item_id} (${item.pool}) ${ok ? 'ok' : 'ERR'} axis_ok=${score.axis_range_ok} estimate_ok=${score.estimate_ok ?? 'n/a'} items=${ocrItems.length}\n`);
  }

  output.end();
}

main().catch((error) => {
  console.error(error);
  process.exit(1);
});
