// Extraction-only diagnostic probe -- Step 2 of the lean experiment sequence
// following up on docs/research/HAND_DRAWN_REAL_PHOTO_GRADING_ACCURACY_2026_08_18.md.
//
// That report found the production-candidate grading method (VISION_FAST_ESC)
// fails all four DR-1 thresholds against real photos, with error concentrated
// in the numeric-quantification criterion families (Y_SCALE, X_SCALE,
// PLOT_VALUES, ESTIMATE_VALUE). The open question: is that a perception
// failure (the model can't read the numbers off the page) or a judgment
// failure (it reads fine, but the joint read+compare+classify call breaks)?
//
// This probe asks the model to ONLY transcribe what's on the page -- axis
// tick range, plotted point values, any annotated estimate -- with no rubric
// judgment, no earned/not_earned classification. A separate deterministic
// (non-LLM) comparator then scores the transcription against the corpus's
// display_table ground truth. If extraction accuracy on the target families
// is meaningfully higher than the original joint-call accuracy, the fix is
// architectural (decompose perception from judgment, mirroring Engine 3's
// existing transcription-then-deterministic-check design). If extraction is
// just as bad, the bottleneck is genuinely perceptual and decomposition
// alone won't fix it.
//
// Scope (deliberately narrow -- this is a cheap spike, not the full harness):
// - 42-photo stratified subsample, not the full 200: 30 photos where the
//   original joint run got at least one of {Y_SCALE, X_SCALE, PLOT_VALUES,
//   ESTIMATE_VALUE} wrong ("error pool", 10 per archetype), plus 12 where
//   the joint run got all of those right ("control pool", 4 per archetype),
//   drawn from docs/research/hand_drawn_graph_real_photo_benchmark_2026_08_18/gold/
//   and .../runs/real_photo_benchmark_results.jsonl. Selection is
//   deterministic (sorted by item_id, no randomness), reproducible from
//   scripts/vercel-gateway-check/select_extraction_probe_subsample.mjs.
// - The 7 likely-misfiled photos are excluded from selection (same
//   exclusion as the defect-adjusted comparison in the accuracy report).
// - Single model, no escalation (gpt-4o-mini, matching the production
//   candidate's primary arm) -- the question is whether *that* model's
//   perception is the bottleneck, not whether a stronger model helps.

import { streamObject } from 'ai';
import fs from 'node:fs';
import path from 'node:path';
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
const OUTPUT_JSONL = path.join(OUT_DIR, 'runs', 'extraction_probe_results.jsonl');

const MODEL = 'openai/gpt-4o-mini';
const MAX_OUTPUT_TOKENS = 500;

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

function buildPrompt(corpusRecord) {
  const table = corpusRecord.display_table;
  const columns = Object.keys(table[0]);
  const categorical = isCategorical(corpusRecord);

  const lines = [
    `Item ID: ${corpusRecord.item_id}`,
    'You are transcribing a hand-drawn graph, NOT grading it. Do not judge',
    'correctness. Only report what is visibly drawn/printed on the page.',
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

async function runExtraction(prompt, imageBuffer) {
  const started = performance.now();
  const result = streamObject({
    model: MODEL,
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
  const xValues = categorical ? null : table.map((row) => row[Object.keys(row).find((k) => k !== yKey && k !== 'SEM (a.u.)' && !k.toLowerCase().includes('sem'))]);

  const out = { axis_range_ok: null, point_match_rate: null, estimate_ok: null, points_matched: 0, points_total: table.length };

  // Axis range check (numeric x-axis archetypes only).
  if (!categorical) {
    const trueXMin = Math.min(...xValues);
    const trueXMax = Math.max(...xValues);
    const trueYMin = Math.min(...yValues);
    const trueYMax = Math.max(...yValues);
    const margin = 0.35; // generous -- hand-drawn axes rarely start/end exactly at data min/max
    const xSpan = Math.max(trueXMax - trueXMin, 1e-6);
    const ySpan = Math.max(trueYMax - trueYMin, 1e-6);
    const xOk = extracted.x_axis_min_tick != null && extracted.x_axis_max_tick != null
      && extracted.x_axis_min_tick <= trueXMin + margin * xSpan
      && extracted.x_axis_max_tick >= trueXMax - margin * xSpan;
    const yOk = extracted.y_axis_min_tick != null && extracted.y_axis_max_tick != null
      && extracted.y_axis_min_tick <= trueYMin + margin * ySpan
      && extracted.y_axis_max_tick >= trueYMax - margin * ySpan;
    out.axis_range_ok = xOk && yOk;
    out.axis_detail = { trueXMin, trueXMax, trueYMin, trueYMax, extracted: { x: [extracted.x_axis_min_tick, extracted.x_axis_max_tick], y: [extracted.y_axis_min_tick, extracted.y_axis_max_tick] } };
  }

  // Point match: for each true row, find the closest extracted point and check y (and x, if numeric) within 20% relative tolerance.
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
    out.estimate_detail = { expected, extracted: extracted.annotated_estimate_value };
  }

  return out;
}

async function main() {
  loadEnvFile(path.join(ROOT, 'scripts', 'vercel-gateway-check', '.env.local'));
  if (!process.env.AI_GATEWAY_API_KEY && process.env.VERCEL_OIDC_TOKEN) {
    process.env.AI_GATEWAY_API_KEY = process.env.VERCEL_OIDC_TOKEN;
  }

  if (!fs.existsSync(SUBSAMPLE_JSON)) {
    fail(`subsample manifest not found: ${SUBSAMPLE_JSON} -- run select_extraction_probe_subsample.mjs first`);
  }
  const subsample = JSON.parse(fs.readFileSync(SUBSAMPLE_JSON, 'utf8'));
  const corpusById = loadCorpusById();

  console.log(`extraction probe: ${subsample.length} photos (${subsample.filter((s) => s.pool === 'error').length} error-pool, ${subsample.filter((s) => s.pool === 'control').length} control-pool)`);

  fs.mkdirSync(path.dirname(OUTPUT_JSONL), { recursive: true });
  const output = fs.createWriteStream(OUTPUT_JSONL, { flags: 'w' });

  for (const item of subsample) {
    const corpusRecord = corpusById.get(item.item_id);
    if (!corpusRecord) {
      console.log(`${item.item_id} SKIP -- no corpus record`);
      continue;
    }
    const prompt = buildPrompt(corpusRecord);
    const imageBuffer = fs.readFileSync(item.file_path);
    const extraction = await runExtraction(prompt, imageBuffer);

    let score = null;
    if (extraction.ok) {
      score = scoreExtraction(corpusRecord, extraction.final);
    }

    const result = {
      item_id: item.item_id,
      file_path: item.file_path,
      archetype: item.archetype,
      pool: item.pool,
      ok: extraction.ok,
      error: extraction.error,
      latency_ms: extraction.latencyMs,
      extracted: extraction.final,
      score,
    };
    output.write(`${JSON.stringify(result)}\n`);
    process.stdout.write(
      `${item.item_id} (${item.pool}) ${extraction.ok ? 'ok' : 'ERR'} axis_ok=${score?.axis_range_ok} points=${score?.points_matched}/${score?.points_total} estimate_ok=${score?.estimate_ok ?? 'n/a'}\n`,
    );
  }

  output.end();
  await new Promise((resolve) => output.on('finish', resolve));
  console.log(`wrote ${OUTPUT_JSONL}`);
}

main().catch((error) => {
  console.error(error);
  process.exit(1);
});
