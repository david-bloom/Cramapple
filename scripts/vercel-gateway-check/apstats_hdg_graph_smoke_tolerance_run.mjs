// AP Statistics hand-drawn graph grading -- rubric-boundary-tolerance fix,
// tier-1 diagnostic (n=10: all 5 mosaic_plot_interpretation photos +
// all 5 scatterplot_regression_context photos from the 2026-08-19 smoke
// test's 20-photo set).
//
// Hypothesis, from the smoke test's cross-model comparison
// (apstats_hdg_graph_real_photo_smoke_2026_08_19/README.md "Cross-model
// comparison"): both models' worst disagreements trace to rubric criteria
// that use undefined qualifiers -- "proportional" (WIDTHS_BY_TOTAL),
// "recoverable locations" (POINTS_PLOTTED) -- forcing each model to invent
// its own tolerance. gpt-5.2 additionally showed a rationale/verdict
// self-contradiction specifically on WIDTHS_BY_TOTAL (reasoned "equal
// widths are correct" then emitted not_earned anyway on 2 of 4 cases).
//
// This script does NOT touch the corpus file (apstats_hdg_graph_corpus_2026_08_18/
// apstats_hdg_graph_questions_2026_08_18.jsonl) or the gold labels -- ground
// truth is unchanged. It only appends an explicit numeric tolerance clause
// to the two criteria's met_rule text at prompt-build time, mirroring the
// pattern of hand_drawn_graph_real_photo_benchmark_gpt52_plot_values_prompt_run.mjs
// (prompt-only variant, scored against the same fixed gold).
//
// Usage: SMOKE_MODEL=openai/gpt-5.2 node apstats_hdg_graph_smoke_tolerance_run.mjs
//        SMOKE_MODEL=anthropic/claude-sonnet-4.5 node apstats_hdg_graph_smoke_tolerance_run.mjs

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

const MODEL = process.env.SMOKE_MODEL || 'openai/gpt-5.2';
const MAX_OUTPUT_TOKENS = 600;

const TIER1_ITEM_IDS = new Set([
  // mosaic_plot_interpretation -- WIDTHS_BY_TOTAL fix
  'APSTATS-HDG-2026-GRAPH-023', 'APSTATS-HDG-2026-GRAPH-024', 'APSTATS-HDG-2026-GRAPH-025',
  'APSTATS-HDG-2026-GRAPH-026', 'APSTATS-HDG-2026-GRAPH-027',
  // scatterplot_regression_context -- POINTS_PLOTTED fix
  'APSTATS-HDG-2026-GRAPH-032', 'APSTATS-HDG-2026-GRAPH-033', 'APSTATS-HDG-2026-GRAPH-034',
  'APSTATS-HDG-2026-GRAPH-035', 'APSTATS-HDG-2026-GRAPH-036',
]);

const TOLERANCE_OVERRIDES = {
  WIDTHS_BY_TOTAL: (original) => `${original} Tolerance: widths are "proportional" if each column's share of ` +
    'total width is within about 5 percentage points of that bracket/group\'s true share of the combined total ' +
    '(e.g. if one group\'s total is 20% lower than the others, its column should look visibly, even if not ' +
    'perfectly, narrower -- equal totals should produce equal widths; unequal totals should produce visibly ' +
    'unequal widths, not equal ones).',
  POINTS_PLOTTED: (original) => `${original} Tolerance: a point is at a "recoverable location" if it falls within ` +
    'roughly 10% of the relevant axis range from its true value. Separately and more importantly: the plotted ' +
    'points as a set should reflect the real shape of the supplied data, including any non-monotonic bumps or ' +
    'dips -- a smooth idealized line that omits a real bump/dip the table shows does NOT satisfy this criterion, ' +
    'even if the overall trend direction looks right.',
};

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
    .map((c) => {
      const override = TOLERANCE_OVERRIDES[c.criterion_id];
      const rule = override ? override(c.met_rule) : c.met_rule;
      return `- ${c.criterion_id}: ${rule}`;
    })
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
    fail('AI_GATEWAY_API_KEY not set (check scripts/vercel-gateway-check/.env, run with env -u VERCEL_OIDC_TOKEN if stale)');
  }

  const corpus = loadCorpus();
  const goldByFilePath = loadGold();
  const subsample = JSON.parse(fs.readFileSync(SUBSAMPLE_JSON, 'utf8')).filter((p) => TIER1_ITEM_IDS.has(p.item_id));

  const modelSlug = MODEL.replace(/[^a-z0-9]+/gi, '_');
  const outPath = path.join(SMOKE_DIR, 'runs', `apstats_smoke_tolerance_${modelSlug}_results.jsonl`);
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
    const promptHash = stableHash('APSTATS_SMOKE_TOLERANCE', item.item_id, prompt);

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
