// AP Statistics mosaic-plot WIDTHS_BY_TOTAL fix, take 2: precompute the
// correct column-width ratios deterministically from display_table (plain
// arithmetic, no model call) and hand them to the model as a given fact,
// instead of asking it to both derive the totals AND visually judge the
// drawn widths in one pass.
//
// Motivation: docs/research/apstats_hdg_graph_real_photo_smoke_2026_08_19/README.md
// "Cross-model comparison" + "Tier-1 follow-up" sections. Across 15
// independent gpt-5.2 samples (3 runs x 5 mosaic photos), the model's own
// rationale computed the group totals correctly 15/15 times -- the failure
// is entirely in comparing the drawn image against that (correctly
// computed) expectation, then emitting a verdict that doesn't even match
// its own stated premise. A prior fix attempt (appending a prose tolerance
// clause, apstats_hdg_graph_smoke_tolerance_run.mjs) did not fix this. This
// script removes the arithmetic step from the model's job entirely instead
// of describing it more precisely.
//
// Does NOT touch the corpus file or gold labels -- computed ratios are
// prompt-only, derived fresh from the same display_table already in the
// (unmodified) corpus, so nothing here is hand-tuned to the answer.

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

const MOSAIC_ITEM_IDS = new Set([
  'APSTATS-HDG-2026-GRAPH-023', 'APSTATS-HDG-2026-GRAPH-024', 'APSTATS-HDG-2026-GRAPH-025',
  'APSTATS-HDG-2026-GRAPH-026', 'APSTATS-HDG-2026-GRAPH-027',
]);

// Different image type (dotplot, not mosaic) -- same underlying mechanism
// (turn implicit table arithmetic into an explicit precomputed fact), to
// test whether the fix generalizes past the one archetype it was found on.
const DOTPLOT_ITEM_IDS = new Set([
  'APSTATS-HDG-2026-GRAPH-028', 'APSTATS-HDG-2026-GRAPH-029', 'APSTATS-HDG-2026-GRAPH-030',
  'APSTATS-HDG-2026-GRAPH-031',
]);
const TARGET_ITEM_IDS = new Set([...MOSAIC_ITEM_IDS, ...DOTPLOT_ITEM_IDS]);

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

// Pure arithmetic, no model call: sum the numeric fields per row, express
// each row's share of the grand total as a percentage width.
function computeWidthRatios(item) {
  const rows = item.display_table;
  const labelKey = Object.keys(rows[0]).find((k) => typeof rows[0][k] === 'string');
  const rowTotals = rows.map((row) => {
    const label = row[labelKey];
    const total = Object.entries(row)
      .filter(([k, v]) => k !== labelKey && typeof v === 'number')
      .reduce((sum, [, v]) => sum + v, 0);
    return { label, total };
  });
  const grand = rowTotals.reduce((sum, r) => sum + r.total, 0);
  return rowTotals.map((r) => ({ label: r.label, total: r.total, widthPct: (100 * r.total) / grand }));
}

function widthsClauseFromComputed(computed) {
  const parts = computed.map((r) => `${r.label} should be ${r.widthPct.toFixed(1)}% of the total width (raw total ${r.total})`);
  return ` The correct column widths, computed directly from the table (do not re-derive them yourself): ` +
    `${parts.join('; ')}. Compare the drawn column widths against these exact percentages, allowing roughly ` +
    `5 percentage points of hand-drawn tolerance.`;
}

// Pure arithmetic, no model call: count occurrences of each value in the
// flat list of raw data points.
function computeDotCounts(item) {
  const rows = item.display_table;
  const valueKey = Object.keys(rows[0])[0];
  const counts = new Map();
  for (const row of rows) {
    const v = row[valueKey];
    counts.set(v, (counts.get(v) || 0) + 1);
  }
  return [...counts.entries()].sort((a, b) => a[0] - b[0]).map(([value, count]) => ({ value, count }));
}

function dotCountsClauseFromComputed(computed) {
  const total = computed.reduce((sum, r) => sum + r.count, 0);
  const parts = computed.map((r) => `${r.value}: ${r.count} dot${r.count === 1 ? '' : 's'}`);
  return ` The correct dot counts, computed directly from the raw data list (do not re-derive them yourself; ` +
    `${total} data points total): ${parts.join(', ')}.`;
}

function buildPrompt(item) {
  const widthsComputed = MOSAIC_ITEM_IDS.has(item.item_id) ? computeWidthRatios(item) : null;
  const dotCountsComputed = DOTPLOT_ITEM_IDS.has(item.item_id) ? computeDotCounts(item) : null;
  const criteria = item.criterion_definitions
    .map((c) => {
      let rule = c.met_rule;
      if (c.criterion_id === 'WIDTHS_BY_TOTAL' && widthsComputed) {
        rule = `${rule}${widthsClauseFromComputed(widthsComputed)}`;
      }
      if (c.criterion_id === 'DOT_COUNTS' && dotCountsComputed) {
        rule = `${rule}${dotCountsClauseFromComputed(dotCountsComputed)}`;
      }
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
  const subsample = JSON.parse(fs.readFileSync(SUBSAMPLE_JSON, 'utf8')).filter((p) => TARGET_ITEM_IDS.has(p.item_id));

  // Print the computed facts up front so they're auditable in the log.
  for (const iid of MOSAIC_ITEM_IDS) {
    const item = corpus.get(iid);
    const computed = computeWidthRatios(item);
    console.log(`${iid} computed widths: ${computed.map((r) => `${r.label}=${r.widthPct.toFixed(1)}%`).join(', ')}`);
  }
  for (const iid of DOTPLOT_ITEM_IDS) {
    const item = corpus.get(iid);
    const computed = computeDotCounts(item);
    console.log(`${iid} computed dot counts: ${computed.map((r) => `${r.value}=${r.count}`).join(', ')}`);
  }

  const runTag = process.env.SMOKE_RUN_TAG ? `_${process.env.SMOKE_RUN_TAG}` : '';
  const modelSlug = MODEL.replace(/[^a-z0-9]+/gi, '_');
  const outPath = path.join(SMOKE_DIR, 'runs', `apstats_smoke_precomputed_facts_${modelSlug}${runTag}_results.jsonl`);
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
    const promptHash = stableHash('APSTATS_SMOKE_PRECOMPUTED_WIDTHS', item.item_id, prompt);

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
      `${result.item_id} ${final.ok ? 'ok' : 'ERR'} exact=${exactMatch} widths=${predictedStatuses.WIDTHS_BY_TOTAL} ${Math.round(result.latency_ms)}ms\n`,
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
