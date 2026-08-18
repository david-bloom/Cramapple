// Model-backbone ablation -- follow-up to the resolution/crop ablation.
// See docs/research/HAND_DRAWN_REAL_PHOTO_GRADING_ACCURACY_2026_08_18.md,
// "Follow-up spike 2" section.
//
// The extraction probe and resolution/crop ablation both used gpt-4o-mini
// only (matching the production candidate's primary arm) and both found the
// dominant failure (reading plotted point values) unmoved. This tests
// whether that's a gpt-4o-mini-specific weakness or a cross-model ceiling,
// using three models flagged by the owner as known for image-analysis
// proficiency. Slugs confirmed live against the Vercel AI Gateway's model
// catalog (347 models) before running:
//   - google/gemini-3.1-pro-preview (the vision-input "gemini-3-pro" the
//     owner meant -- google/gemini-3-pro-image is a same-named but
//     DIFFERENT endpoint that generates images, not a vision-input model;
//     confirmed via this repo's own convention in apbio_image_smoke_test.mjs)
//   - openai/gpt-5.2 (read "GPR 5.2" as GPT-5.2)
//   - alibaba/qwen3-vl-instruct -- DROPPED from this run: a single-photo
//     smoke test showed it can describe the graph correctly in free text
//     but returns an empty result under structured/schema-constrained
//     output (tried both streamObject and non-streaming generateObject).
//     That's a structured-output/tool-calling compatibility gap via this
//     route, not a vision failure -- flagged, not debugged further, to keep
//     this a cheap spike.
//
// Uses the SAME cropped+upscaled images as the resolution/crop ablation
// (same crop pipeline, re-generated here rather than cached, since crop is
// cheap and this keeps the script self-contained) so model backbone is the
// only variable changing versus that baseline (gpt-4o-mini crop results:
// axis_range_ok 75.0%, point_match 20.8%, estimate_ok 57.1%).

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
const GOLD_JSONL = path.join(
  ROOT, 'docs', 'research', 'hand_drawn_graph_corpus_2026_06_29',
  'hand_drawn_graph_questions_2026_06_29.jsonl',
);
const SUBSAMPLE_JSON = path.join(
  ROOT, 'docs', 'research', 'hand_drawn_graph_real_photo_benchmark_2026_08_18',
  'gold', 'extraction_probe_subsample_2026_08_18.json',
);
const OUT_DIR = path.join(ROOT, 'docs', 'research', 'hand_drawn_graph_real_photo_benchmark_2026_08_18');

const MODELS = ['google/gemini-3.1-pro-preview', 'openai/gpt-5.2'];
const MAX_OUTPUT_TOKENS = 500;
const CROP_MARGIN_FRACTION = 0.10;
const UPSCALE_FACTOR = 1.5;

function fail(message) {
  console.error(`error: ${message}`);
  process.exit(1);
}

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

function buildMessages(prompt, imageBuffer) {
  return [
    {
      role: 'user',
      content: [
        { type: 'text', text: prompt },
        { type: 'image', image: imageBuffer },
      ],
    },
  ];
}

async function runExtraction(model, prompt, imageBuffer) {
  const started = performance.now();
  const result = streamObject({
    model,
    schema: z.object({
      x_axis_min_tick: z.number().nullable(),
      x_axis_max_tick: z.number().nullable(),
      y_axis_min_tick: z.number().nullable(),
      y_axis_max_tick: z.number().nullable(),
      plotted_points: z.array(
        z.object({
          label: z.string().nullable(),
          x: z.number().nullable(),
          y: z.number(),
        }),
      ),
      annotated_estimate_value: z.number().nullable(),
      transcription_confidence: z.enum(['high', 'medium', 'low']),
    }),
    messages: buildMessages(prompt, imageBuffer),
    maxOutputTokens: MAX_OUTPUT_TOKENS,
  });
  try {
    for await (const _chunk of result.partialObjectStream) {
      // drain stream
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
  if (!fs.existsSync(SUBSAMPLE_JSON)) {
    fail(`subsample manifest not found: ${SUBSAMPLE_JSON}`);
  }
  const subsample = JSON.parse(fs.readFileSync(SUBSAMPLE_JSON, 'utf8'));
  const corpusById = loadCorpusById();

  for (const model of MODELS) {
    const slug = model.replace('/', '_');
    const outputPath = path.join(OUT_DIR, 'runs', `extraction_probe_model_${slug}_results.jsonl`);
    console.log(`\n=== ${model}: ${subsample.length} photos ===`);
    fs.mkdirSync(path.dirname(outputPath), { recursive: true });
    const output = fs.createWriteStream(outputPath, { flags: 'w' });

    for (const item of subsample) {
      const corpusRecord = corpusById.get(item.item_id);
      if (!corpusRecord) continue;
      const prompt = buildPrompt(corpusRecord);
      const croppedBuffer = await cropAndUpscale(item.file_path);
      const extraction = await runExtraction(model, prompt, croppedBuffer);
      let score = null;
      if (extraction.ok) {
        score = scoreExtraction(corpusRecord, extraction.final);
      }
      const result = {
        model, item_id: item.item_id, file_path: item.file_path, archetype: item.archetype, pool: item.pool,
        ok: extraction.ok, error: extraction.error, latency_ms: extraction.latencyMs,
        extracted: extraction.final, score,
      };
      output.write(`${JSON.stringify(result)}\n`);
      process.stdout.write(
        `${item.item_id} (${item.pool}) ${extraction.ok ? 'ok' : 'ERR'} axis_ok=${score?.axis_range_ok} points=${score?.points_matched}/${score?.points_total} estimate_ok=${score?.estimate_ok ?? 'n/a'}\n`,
      );
    }
    output.end();
    await new Promise((resolve) => output.on('finish', resolve));
    console.log(`wrote ${outputPath}`);
  }
}

main().catch((error) => {
  console.error(error);
  process.exit(1);
});
