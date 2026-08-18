// Retry pass for google/gemini-3.1-pro-preview's failed extraction-probe
// calls (35/42 failed with "No object generated: could not parse the
// response" in the first pass -- a single manual retry on one failed photo
// succeeded immediately, suggesting intermittent structured-output flakiness
// rather than a systematic incompatibility). Retries each failed row up to
// 2 additional times before giving up, reusing the same cropped image and
// prompt/schema as hand_drawn_graph_extraction_probe_multimodel_run.mjs.

import { streamObject } from 'ai';
import fs from 'node:fs';
import path from 'node:path';
import sharp from 'sharp';
import { z } from 'zod';

function loadEnvFile(envPath) {
  if (!fs.existsSync(envPath)) return;
  const lines = fs.readFileSync(envPath, 'utf8').split(/\r?\n/);
  for (const rawLine of lines) {
    const line = rawLine.trim();
    if (!line || line.startsWith('#') || !line.includes('=')) continue;
    const idx = line.indexOf('=');
    const key = line.slice(0, idx).trim();
    let value = line.slice(idx + 1).trim();
    if ((value.startsWith('"') && value.endsWith('"')) || (value.startsWith("'") && value.endsWith("'"))) {
      value = value.slice(1, -1);
    }
    if (key && !(key in process.env)) {
      process.env[key] = value;
    }
  }
}

const ROOT = path.resolve(new URL('.', import.meta.url).pathname, '..', '..');
const GOLD_JSONL = path.join(ROOT, 'docs', 'research', 'hand_drawn_graph_corpus_2026_06_29', 'hand_drawn_graph_questions_2026_06_29.jsonl');
const OUT_DIR = path.join(ROOT, 'docs', 'research', 'hand_drawn_graph_real_photo_benchmark_2026_08_18');
const RESULTS_PATH = path.join(OUT_DIR, 'runs', 'extraction_probe_model_google_gemini-3.1-pro-preview_results.jsonl');

const MODEL = 'google/gemini-3.1-pro-preview';
const MAX_OUTPUT_TOKENS = 500;
const CROP_MARGIN_FRACTION = 0.10;
const UPSCALE_FACTOR = 1.5;
const MAX_RETRIES = 2;

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

async function cropAndUpscale(filePath) {
  const rotatedBuffer = await sharp(filePath).rotate().toBuffer();
  const meta = await sharp(rotatedBuffer).metadata();
  const w = meta.width;
  const h = meta.height;
  const left = Math.round(w * CROP_MARGIN_FRACTION);
  const top = Math.round(h * CROP_MARGIN_FRACTION);
  const cropW = Math.round(w * (1 - 2 * CROP_MARGIN_FRACTION));
  const cropH = Math.round(h * (1 - 2 * CROP_MARGIN_FRACTION));
  return sharp(rotatedBuffer)
    .extract({ left, top, width: cropW, height: cropH })
    .resize(Math.round(cropW * UPSCALE_FACTOR), Math.round(cropH * UPSCALE_FACTOR), { kernel: sharp.kernel.lanczos3 })
    .jpeg({ quality: 92 })
    .toBuffer();
}

function buildPrompt(corpusRecord) {
  const table = corpusRecord.display_table;
  const categorical = isCategorical(corpusRecord);
  const lines = [
    `Item ID: ${corpusRecord.item_id}`,
    'You are transcribing a hand-drawn graph, NOT grading it. Do not judge',
    'correctness. Only report what is visibly drawn/printed on the page.',
    'Note: this image has been cropped tighter around the graph and may not',
    'show the full original page.',
    '',
    `The graph has these axes: x-axis = "${corpusRecord.expected_graph_spec.x_axis}",`,
    `y-axis = "${corpusRecord.expected_graph_spec.y_axis}".`,
    '',
  ];
  if (categorical) {
    lines.push(
      'The x-axis is categorical (no numeric scale). For each category bar/point',
      'visible on the page, report the category label as printed and the y-axis',
      'numeric value where its marker/bar-top sits, read directly off the printed',
      'y-axis tick numbers nearest to it.',
    );
  } else {
    lines.push(
      'Report the numeric value of the smallest and largest printed tick label',
      'on the x-axis, and the smallest and largest printed tick label on the',
      'y-axis, exactly as printed (do not infer or correct them).',
      'Then for each plotted point/marker visible on the page, report its (x, y)',
      'value read directly off those printed axis ticks.',
    );
  }
  if (corpusRecord.archetype === 'continuous_relationship_graph_derived_estimate') {
    lines.push(
      '',
      'If there is a written numeric estimate annotation on the page (e.g. an',
      '"x ≈ ..." label marking where a best-fit line crosses zero), report that',
      'number as annotated_estimate_value. If none is visible, report null.',
    );
  }
  lines.push(
    '',
    `The page should have ${table.length} data points/categories. Report exactly`,
    'what you can see -- if a point is illegible, omit it rather than guessing.',
  );
  return lines.join('\n');
}

async function runExtraction(prompt, imageBuffer) {
  const started = performance.now();
  const result = streamObject({
    model: MODEL,
    schema: z.object({
      x_axis_min_tick: z.number().nullable(),
      x_axis_max_tick: z.number().nullable(),
      y_axis_min_tick: z.number().nullable(),
      y_axis_max_tick: z.number().nullable(),
      plotted_points: z.array(z.object({ label: z.string().nullable(), x: z.number().nullable(), y: z.number() })),
      annotated_estimate_value: z.number().nullable(),
      transcription_confidence: z.enum(['high', 'medium', 'low']),
    }),
    messages: [{ role: 'user', content: [{ type: 'text', text: prompt }, { type: 'image', image: imageBuffer }] }],
    maxOutputTokens: MAX_OUTPUT_TOKENS,
  });
  try {
    for await (const _chunk of result.partialObjectStream) {
      // drain
    }
    const final = await result.object;
    return { ok: true, final, latencyMs: performance.now() - started, error: '' };
  } catch (error) {
    return { ok: false, final: null, latencyMs: performance.now() - started, error: error?.message || String(error) };
  }
}

function relErr(actual, expected) {
  const denom = Math.max(Math.abs(expected), 1e-6);
  return Math.abs(actual - expected) / denom;
}

function scoreExtraction(corpusRecord, extracted) {
  const categorical = isCategorical(corpusRecord);
  const table = corpusRecord.display_table;
  const yKey = Object.keys(table[0]).find((k) => k.toLowerCase().includes('mean') || k.toLowerCase().includes('percent') || k.toLowerCase().includes(corpusRecord.expected_graph_spec.y_axis.toLowerCase().split(' ')[0]));
  const catKey = categorical ? Object.keys(table[0]).find((k) => k === 'Treatment') : null;
  const yValues = table.map((row) => row[yKey]);
  const xValues = categorical ? null : table.map((row) => row[Object.keys(row).find((k) => k !== yKey && !k.toLowerCase().includes('sem'))]);

  const out = { axis_range_ok: null, point_match_rate: null, estimate_ok: null, points_matched: 0, points_total: table.length };
  if (!categorical) {
    const trueXMin = Math.min(...xValues);
    const trueXMax = Math.max(...xValues);
    const trueYMin = Math.min(...yValues);
    const trueYMax = Math.max(...yValues);
    const margin = 0.35;
    const xSpan = Math.max(trueXMax - trueXMin, 1e-6);
    const ySpan = Math.max(trueYMax - trueYMin, 1e-6);
    const xOk = extracted.x_axis_min_tick != null && extracted.x_axis_max_tick != null
      && extracted.x_axis_min_tick <= trueXMin + margin * xSpan
      && extracted.x_axis_max_tick >= trueXMax - margin * xSpan;
    const yOk = extracted.y_axis_min_tick != null && extracted.y_axis_max_tick != null
      && extracted.y_axis_min_tick <= trueYMin + margin * ySpan
      && extracted.y_axis_max_tick >= trueYMax - margin * ySpan;
    out.axis_range_ok = xOk && yOk;
  }
  const tolerance = 0.20;
  let matched = 0;
  for (let i = 0; i < table.length; i += 1) {
    const trueY = yValues[i];
    let best = null;
    if (categorical) {
      const trueLabel = table[i][catKey];
      best = extracted.plotted_points.find((p) => (p.label || '').toLowerCase().trim() === String(trueLabel).toLowerCase().trim());
    } else {
      const trueX = xValues[i];
      let bestDist = Infinity;
      for (const p of extracted.plotted_points) {
        if (p.x == null) continue;
        const dist = Math.abs(p.x - trueX);
        if (dist < bestDist) { bestDist = dist; best = p; }
      }
    }
    if (best && relErr(best.y, trueY) <= tolerance) matched += 1;
  }
  out.points_matched = matched;
  out.point_match_rate = matched / table.length;
  if (corpusRecord.archetype === 'continuous_relationship_graph_derived_estimate') {
    const expected = corpusRecord.expected_graph_spec.expected_estimate_approx;
    out.estimate_ok = extracted.annotated_estimate_value != null && relErr(extracted.annotated_estimate_value, expected) <= 0.25;
  }
  return out;
}

async function main() {
  loadEnvFile(path.join(ROOT, 'scripts', 'vercel-gateway-check', '.env.local'));
  if (!process.env.AI_GATEWAY_API_KEY && process.env.VERCEL_OIDC_TOKEN) {
    process.env.AI_GATEWAY_API_KEY = process.env.VERCEL_OIDC_TOKEN;
  }
  const corpusById = loadCorpusById();
  const rows = fs.readFileSync(RESULTS_PATH, 'utf8').trim().split('\n').map((l) => JSON.parse(l));

  let rescued = 0;
  let stillFailed = 0;
  const updatedRows = [];
  for (const row of rows) {
    if (row.ok) {
      updatedRows.push(row);
      continue;
    }
    const corpusRecord = corpusById.get(row.item_id);
    const prompt = buildPrompt(corpusRecord);
    let finalRow = row;
    for (let attempt = 0; attempt < MAX_RETRIES; attempt += 1) {
      const croppedBuffer = await cropAndUpscale(row.file_path);
      const extraction = await runExtraction(prompt, croppedBuffer);
      if (extraction.ok) {
        const score = scoreExtraction(corpusRecord, extraction.final);
        finalRow = { ...row, ok: true, error: '', latency_ms: extraction.latencyMs, extracted: extraction.final, score, retried: attempt + 1 };
        rescued += 1;
        break;
      }
      finalRow = { ...row, error: extraction.error, retried: attempt + 1 };
    }
    if (!finalRow.ok) stillFailed += 1;
    console.log(`${row.item_id} retry -> ${finalRow.ok ? 'RESCUED' : 'still failed'} (attempts=${finalRow.retried})`);
    updatedRows.push(finalRow);
  }

  fs.writeFileSync(RESULTS_PATH, updatedRows.map((r) => JSON.stringify(r)).join('\n') + '\n');
  console.log(`\nrescued: ${rescued}, still failed: ${stillFailed}`);
  console.log(`updated ${RESULTS_PATH}`);
}

main().catch((error) => {
  console.error(error);
  process.exit(1);
});
