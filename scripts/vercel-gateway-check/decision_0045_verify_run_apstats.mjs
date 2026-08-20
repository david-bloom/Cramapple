// DECISION-0045 gold-verification pass for Engine 4 (per DECISION-0050),
// applied to the AP Statistics real-photo gold corpus at
// docs/research/apstats_hdg_graph_real_photo_smoke_2026_08_19/gold/apstats_smoke_gold_labels_2026_08_19.json
// (28 photos, "tier 2" / full real-photo corpus for this subject).
//
// Adapted from decision_0045_verify_run.mjs (the Biology-corpus version).
// Same independence reasoning: grader under test is OpenAI (gpt-5.2). The
// existing Statistics gold was written by direct visual inspection during
// Claude-Code (Anthropic) agent sessions -- same method as the Biology
// 200-photo gold ("Grade them yourself first", confirmed in
// docs/research/HAND_DRAWN_REAL_PHOTO_GRADING_ACCURACY_2026_08_18.md and
// referenced by docs/research/apstats_hdg_graph_real_photo_smoke_2026_08_19/README.md).
// So Anthropic is "consumed" as the writer family here too, and the same
// already-validated verifier pair (google/gemini-2.5-flash,
// alibaba/qwen3-vl-235b-a22b-instruct) is reused without re-probing Kimi.
//
// Unlike the Biology script, this one does NOT need to discover photos by
// filename pattern -- the Statistics gold file already carries one record
// per photo with an explicit absolute file_path. We iterate that file
// directly and pull item/criteria data from the Statistics item corpus.
//
// Usage:
//   node decision_0045_verify_run_apstats.mjs --model google/gemini-2.5-flash --out <path> [--limit N] [--skip N]

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

const ROOT = '/Users/davidbloom/Documents/Cramapple.nosync';
const CORPUS_JSONL = path.join(
  ROOT, 'docs', 'research', 'apstats_hdg_graph_corpus_2026_08_18',
  'apstats_hdg_graph_questions_2026_08_18.jsonl',
);
const SMOKE_DIR = path.join(ROOT, 'docs', 'research', 'apstats_hdg_graph_real_photo_smoke_2026_08_19');
const GOLD_JSON = path.join(SMOKE_DIR, 'gold', 'apstats_smoke_gold_labels_2026_08_19.json');

// Same token-budget lesson as the Biology verify script: google/gemini-2.5-flash
// spends an unpredictable chunk of its output budget on internal thinking
// tokens before emitting JSON. Use the same settled value (8000) up front
// rather than rediscovering the truncation issue on this corpus.
const MAX_OUTPUT_TOKENS = 8000;

function fail(message) {
  console.error(`error: ${message}`);
  process.exit(1);
}

function stableHash(...parts) {
  return crypto.createHash('sha256').update(parts.join('\0')).digest('hex');
}

function loadCorpusItems() {
  const byItemId = new Map();
  const lines = fs.readFileSync(CORPUS_JSONL, 'utf8').split('\n').filter(Boolean);
  for (const line of lines) {
    const record = JSON.parse(line);
    byItemId.set(record.item_id, record);
  }
  return byItemId;
}

function loadGold() {
  return JSON.parse(fs.readFileSync(GOLD_JSON, 'utf8'));
}

// IMPORTANT: identical shape/content to the Biology verify script's prompt --
// item_id, archetype, student prompt, and rubric criteria (criterion_id +
// met_rule) only. Never includes criterion_statuses (gold labels), any other
// model's output, or anything from a grading pass.
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

// Same pricing table as the Biology script (Qwen's rate is a deliberately
// conservative placeholder -- see that script's note; carried forward here
// unchanged for consistency).
const PRICING = {
  'google/gemini-2.5-flash': { input: 0.30, cached: 0.075, output: 2.50 },
  'alibaba/qwen3-vl-235b-a22b-instruct': { input: 1.00, cached: 0.25, output: 3.00 },
};

function estimateCost(model, usage) {
  const pricing = PRICING[model] || { input: 1.0, cached: 0.25, output: 3.0 };
  const inputTokens = Number(usage.inputTokens || 0);
  const cachedTokens = Number(usage.cachedTokens || 0);
  const outputTokens = Number(usage.outputTokens || 0);
  const uncached = Math.max(inputTokens - cachedTokens, 0);
  return ((uncached * pricing.input) + (cachedTokens * pricing.cached) + (outputTokens * pricing.output)) / 1_000_000;
}

async function runCall(model, prompt, imageBuffer) {
  const started = performance.now();
  const result = streamObject({
    model,
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
        reasoningTokens: usage?.reasoningTokens ?? 0,
        cachedTokens: usage?.cachedInputTokens ?? usage?.cachedTokens ?? 0,
      },
      latencyMs: total,
      ttfbMs: firstChunkAt === null ? total : firstChunkAt - started,
      costUsd: estimateCost(model, {
        inputTokens: usage?.inputTokens ?? 0,
        outputTokens: usage?.outputTokens ?? 0,
        cachedTokens: usage?.cachedInputTokens ?? usage?.cachedTokens ?? 0,
      }),
    };
  } catch (error) {
    let detail = error?.message || String(error);
    try {
      if (error.cause?.responseBody) {
        const body = JSON.parse(error.cause.responseBody);
        detail = body?.error?.type ?? body?.error?.message ?? detail;
      }
    } catch {}
    return {
      ok: false,
      error: detail,
      final: null,
      usage: { inputTokens: 0, outputTokens: 0, reasoningTokens: 0, cachedTokens: 0 },
      latencyMs: performance.now() - started,
      ttfbMs: null,
      costUsd: 0,
    };
  }
}

function parseArgs(argv) {
  const out = { limit: null, model: null, out: null, skip: 0 };
  for (let i = 2; i < argv.length; i += 1) {
    if (argv[i] === '--limit' && argv[i + 1]) {
      out.limit = Number(argv[++i]);
    } else if (argv[i] === '--model' && argv[i + 1]) {
      out.model = argv[++i];
    } else if (argv[i] === '--out' && argv[i + 1]) {
      out.out = argv[++i];
    } else if (argv[i] === '--skip' && argv[i + 1]) {
      out.skip = Number(argv[++i]);
    }
  }
  return out;
}

async function main() {
  const args = parseArgs(process.argv);
  if (!args.model) fail('--model is required (e.g. google/gemini-2.5-flash)');
  if (!args.out) fail('--out is required (output JSONL path)');

  loadEnvFile(path.join(ROOT, 'scripts', 'vercel-gateway-check', '.env'));
  if (!process.env.AI_GATEWAY_API_KEY && process.env.VERCEL_OIDC_TOKEN) {
    process.env.AI_GATEWAY_API_KEY = process.env.VERCEL_OIDC_TOKEN;
  }

  const corpusItems = loadCorpusItems();
  let goldRecords = loadGold();
  const unmatched = goldRecords.filter((r) => !corpusItems.has(r.item_id));
  if (unmatched.length) {
    console.log(`WARNING: ${unmatched.length} gold records have no matching corpus item: ${unmatched.map((r) => r.item_id).join(', ')}`);
  }
  goldRecords = goldRecords.filter((r) => corpusItems.has(r.item_id));
  const missingFile = goldRecords.filter((r) => !fs.existsSync(r.file_path));
  if (missingFile.length) {
    console.log(`WARNING: ${missingFile.length} gold records point to a missing photo file: ${missingFile.map((r) => r.file_path).join(', ')}`);
  }
  goldRecords = goldRecords.filter((r) => fs.existsSync(r.file_path));

  const totalRunnable = goldRecords.length;
  if (args.skip) goldRecords = goldRecords.slice(args.skip);
  if (args.limit) goldRecords = goldRecords.slice(0, args.limit);

  if (goldRecords.length === 0) {
    fail('no runnable gold records found (after --skip/--limit)');
  }
  console.log(
    `model=${args.model} runnable AP Stats real photos: ${totalRunnable}; processing ${goldRecords.length} starting at skip=${args.skip}`,
  );

  // Append-only, same discipline as the Biology script.
  if (args.skip === 0) {
    if (fs.existsSync(args.out)) {
      fail(`refusing to overwrite existing output file: ${args.out} (append-only -- pass a new --out path, or use --skip to continue it)`);
    }
    fs.mkdirSync(path.dirname(args.out), { recursive: true });
  } else if (!fs.existsSync(args.out)) {
    fail(`--skip=${args.skip} but ${args.out} does not exist yet -- run with --skip 0 first`);
  }
  const output = fs.createWriteStream(args.out, { flags: args.skip === 0 ? 'wx' : 'a' });

  let totalCost = 0;
  let okCount = 0;
  let errCount = 0;

  for (const goldRec of goldRecords) {
    const item = corpusItems.get(goldRec.item_id);
    const prompt = buildPrompt(item);
    const imageBuffer = fs.readFileSync(goldRec.file_path);
    const promptHash = stableHash('DECISION_0045_VERIFY_APSTATS', args.model, goldRec.item_id, prompt);

    const final = await runCall(args.model, prompt, imageBuffer);
    totalCost += final.costUsd;
    if (final.ok) okCount += 1; else errCount += 1;

    const predictedStatuses = {};
    for (const entry of final.final?.criterion_statuses || []) {
      if (entry && entry.criterion_id) {
        predictedStatuses[entry.criterion_id] = entry.status;
      }
    }

    const expectedCriteria = item.criterion_definitions.map((c) => c.criterion_id);
    const result = {
      item_id: goldRec.item_id,
      file_path: goldRec.file_path,
      archetype: item.archetype,
      content_item_version_id: item.content_item_version_id,
      prompt_hash: promptHash,
      model_id: args.model,
      schema_valid: final.ok && expectedCriteria.every((cid) => predictedStatuses[cid]),
      latency_ms: final.latencyMs,
      ttfb_ms: final.ttfbMs,
      cost_usd: final.costUsd,
      output_tokens: final.usage?.outputTokens || 0,
      input_tokens: final.usage?.inputTokens || 0,
      criterion_statuses: predictedStatuses,
      confidence: final.final?.confidence || 'low',
      rationale: final.final?.rationale || '',
      ok: final.ok,
      error: final.error || '',
    };
    output.write(`${JSON.stringify(result)}\n`);
    process.stdout.write(
      `${goldRec.item_id} ${final.ok ? 'ok' : 'ERR'} cost=$${final.costUsd.toFixed(5)} ${Math.round(result.latency_ms)}ms\n`,
    );
  }

  output.end();
  await new Promise((resolve) => output.on('finish', resolve));
  console.log(`\nmodel=${args.model} done. ok=${okCount} err=${errCount} totalCost=$${totalCost.toFixed(4)}`);
  console.log(`wrote ${args.out}`);
}

main().catch((error) => {
  console.error(error);
  process.exit(1);
});
