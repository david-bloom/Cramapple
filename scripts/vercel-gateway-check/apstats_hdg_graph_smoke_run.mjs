// AP Statistics hand-drawn graph grading -- 20-photo smoke test, first-ever
// accuracy measurement for this subject (see docs/GRADING_ENGINES_TO_PRODUCTION_HANDOFF.md
// UPDATE 2026-08-18d section 3: "Stats is far more archetype-diverse than
// Bio... Zero benchmark work has been run on this corpus").
//
// Same method as the Biology real-photo benchmark
// (hand_drawn_graph_real_photo_benchmark_gpt52_run.mjs): single-pass
// openai/gpt-5.2, full-page uncropped images, joint-judgment prompt asking
// for a status per rubric criterion. Gold labels are genuine per-photo
// labels built by direct visual inspection this session (20 photos across
// 5 archetypes: graph_annotation_marking_value, scatterplot_regression_context,
// dotplot_distribution_shape, mosaic_plot_interpretation,
// segmented_bar_graph_construction), not the earlier-treated-as-decided
// "all earned" assumption.

import { streamObject } from 'ai';
import fs from 'node:fs';
import path from 'node:path';
import crypto from 'node:crypto';
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
const CORPUS_JSONL = path.join(ROOT, 'docs', 'research', 'apstats_hdg_graph_corpus_2026_08_18', 'apstats_hdg_graph_questions_2026_08_18.jsonl');
const SMOKE_DIR = path.join(ROOT, 'docs', 'research', 'apstats_hdg_graph_real_photo_smoke_2026_08_19');
const SUBSAMPLE_JSON = path.join(SMOKE_DIR, 'gold', 'apstats_smoke_subsample_2026_08_19.json');
const GOLD_JSON = path.join(SMOKE_DIR, 'gold', 'apstats_smoke_gold_labels_2026_08_19.json');
const OUTPUT_JSONL = path.join(SMOKE_DIR, 'runs', 'apstats_smoke_gpt52_results.jsonl');

const MODEL = process.env.SMOKE_MODEL || 'openai/gpt-5.2';
const MAX_OUTPUT_TOKENS = 600;
const ONLY_ITEM_IDS = process.env.SMOKE_ONLY_ITEMS
  ? new Set(process.env.SMOKE_ONLY_ITEMS.split(',').map((s) => s.trim()))
  : null;
const OUTPUT_OVERRIDE = process.env.SMOKE_OUTPUT || null;

function fail(message) {
  console.error(`error: ${message}`);
  process.exit(1);
}

function stableHash(...parts) {
  return crypto.createHash('sha256').update(parts.join('\0')).digest('hex');
}

function loadCorpus() {
  const byItemId = new Map();
  const lines = fs.readFileSync(CORPUS_JSONL, 'utf8').trim().split('\n').filter(Boolean);
  for (const line of lines) {
    const record = JSON.parse(line);
    byItemId.set(record.item_id, record);
  }
  return byItemId;
}

function loadGold() {
  const records = JSON.parse(fs.readFileSync(GOLD_JSON, 'utf8'));
  const byFilePath = new Map();
  for (const record of records) {
    byFilePath.set(path.resolve(record.file_path), record);
  }
  return byFilePath;
}

function buildPrompt(item) {
  const criteria = item.criterion_definitions
    .map((c) => `- ${c.criterion_id}: ${c.met_rule}`)
    .join('\n');
  return [
    `Item ID: ${item.item_id}`,
    `Archetype: ${item.archetype}`,
    'Prompt:',
    item.student_prompt || '',
    '',
    'Rubric criteria (evaluate strictly against these rules):',
    criteria,
    '',
    'Inspect the photographed hand-drawn response and return a criterion status',
    '(earned / not_earned / unable_to_determine) for every criterion listed above,',
    'based only on what is visible in the image.',
  ].join('\n');
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

function estimateCost(usage) {
  const pricing = { input: 5.0, cached: 0.5, output: 30.0 };
  const inputTokens = Number(usage.inputTokens || 0);
  const cachedTokens = Number(usage.cachedTokens || 0);
  const outputTokens = Number(usage.outputTokens || 0);
  const uncached = Math.max(inputTokens - cachedTokens, 0);
  return ((uncached * pricing.input) + (cachedTokens * pricing.cached) + (outputTokens * pricing.output)) / 1_000_000;
}

async function runCall(prompt, imageBuffer) {
  const started = performance.now();
  const result = streamObject({
    model: MODEL,
    schema: z.object({
      criterion_statuses: z.array(
        z.object({
          criterion_id: z.string(),
          status: z.enum(['earned', 'not_earned', 'unable_to_determine']),
        }),
      ),
      confidence: z.enum(['high', 'medium', 'low']),
      rationale: z.string(),
    }),
    messages: buildMessages(prompt, imageBuffer),
    maxOutputTokens: MAX_OUTPUT_TOKENS,
  });
  let firstChunkAt = null;
  try {
    for await (const _chunk of result.partialObjectStream) {
      if (firstChunkAt === null) firstChunkAt = performance.now();
    }
    const final = await result.object;
    const usage = await result.usage;
    const total = performance.now() - started;
    return {
      ok: true,
      final,
      usage: {
        inputTokens: usage?.inputTokens ?? 0,
        outputTokens: usage?.outputTokens ?? 0,
        cachedTokens: usage?.cachedInputTokens ?? usage?.cachedTokens ?? 0,
      },
      latencyMs: total,
      ttfbMs: firstChunkAt === null ? total : firstChunkAt - started,
      costUsd: estimateCost({
        inputTokens: usage?.inputTokens ?? 0,
        outputTokens: usage?.outputTokens ?? 0,
        cachedTokens: usage?.cachedInputTokens ?? usage?.cachedTokens ?? 0,
      }),
    };
  } catch (error) {
    return {
      ok: false,
      error: error?.message || String(error),
      final: null,
      usage: { inputTokens: 0, outputTokens: 0, cachedTokens: 0 },
      latencyMs: performance.now() - started,
      ttfbMs: null,
      costUsd: 0,
    };
  }
}

async function main() {
  loadEnvFile(path.join(ROOT, 'scripts', 'vercel-gateway-check', '.env.local'));
  loadEnvFile(path.join(ROOT, 'scripts', 'vercel-gateway-check', '.env'));
  if (!process.env.AI_GATEWAY_API_KEY && process.env.VERCEL_OIDC_TOKEN) {
    process.env.AI_GATEWAY_API_KEY = process.env.VERCEL_OIDC_TOKEN;
  }
  if (!process.env.AI_GATEWAY_API_KEY) {
    fail('AI_GATEWAY_API_KEY not set (check scripts/vercel-gateway-check/.env, run with env -u VERCEL_OIDC_TOKEN if it is stale)');
  }

  const corpus = loadCorpus();
  const goldByFilePath = loadGold();
  let subsample = JSON.parse(fs.readFileSync(SUBSAMPLE_JSON, 'utf8'));
  if (ONLY_ITEM_IDS) {
    subsample = subsample.filter((p) => ONLY_ITEM_IDS.has(p.item_id));
  }

  const outPath = OUTPUT_OVERRIDE || OUTPUT_JSONL;
  console.log(`model=${MODEL} photos=${subsample.length} out=${outPath}`);
  fs.mkdirSync(path.dirname(outPath), { recursive: true });
  const output = fs.createWriteStream(outPath, { flags: 'w' });

  for (const photo of subsample) {
    const goldRecord = goldByFilePath.get(path.resolve(photo.file_path));
    if (!goldRecord) {
      console.log(`SKIP no gold for ${photo.file_path}`);
      continue;
    }
    const item = corpus.get(goldRecord.item_id);
    if (!item) {
      console.log(`SKIP no corpus item for ${goldRecord.item_id}`);
      continue;
    }
    const prompt = buildPrompt(item);
    const imageBuffer = fs.readFileSync(photo.file_path);
    const promptHash = stableHash('APSTATS_SMOKE_GPT52', item.item_id, prompt);

    const final = await runCall(prompt, imageBuffer);

    const predictedStatuses = {};
    for (const entry of final.final?.criterion_statuses || []) {
      if (entry && entry.criterion_id) {
        predictedStatuses[entry.criterion_id] = entry.status;
      }
    }
    const goldMap = goldRecord.criterion_statuses;
    const schemaValid = final.ok && Object.keys(goldMap).every((criterionId) => predictedStatuses[criterionId]);
    const exactMatch = schemaValid
      && Object.keys(goldMap).every((criterionId) => predictedStatuses[criterionId] === goldMap[criterionId]);
    const criterionResults = Object.keys(goldMap).map((criterionId) => ({
      criterion_id: criterionId,
      gold: goldMap[criterionId],
      predicted: predictedStatuses[criterionId] || null,
      correct: predictedStatuses[criterionId] === goldMap[criterionId],
    }));

    const result = {
      item_id: goldRecord.item_id,
      file_name: path.basename(photo.file_path),
      archetype: item.archetype,
      prompt_hash: promptHash,
      model_id: MODEL,
      schema_valid: schemaValid,
      exact_match: exactMatch,
      latency_ms: final.latencyMs,
      ttfb_ms: final.ttfbMs,
      cost_usd: final.costUsd,
      output_tokens: final.usage?.outputTokens || 0,
      criterion_statuses: predictedStatuses,
      gold_criterion_statuses: goldMap,
      gold_confidence: goldRecord.confidence,
      gold_rationale: goldRecord.rationale,
      criterion_results: criterionResults,
      confidence: final.final?.confidence || 'low',
      rationale: final.final?.rationale || '',
      ok: final.ok,
      error: final.error || '',
    };
    output.write(`${JSON.stringify(result)}\n`);
    process.stdout.write(
      `${result.item_id} ${final.ok ? 'ok' : 'ERR'} exact=${exactMatch} ${Math.round(result.latency_ms)}ms\n`,
    );
  }

  output.end();
  await new Promise((resolve) => output.on('finish', resolve));
  console.log(`wrote ${outPath}`);
}

main().catch((error) => {
  console.error(error);
  process.exit(1);
});
