// DECISION-0045 gold-verification pass for Engine 4 (per DECISION-0050),
// applied to the existing 200-photo real-Biology-graph gold corpus at
// docs/research/hand_drawn_graph_real_photo_benchmark_2026_08_18/gold/real_photo_gold_labels_2026_08_18.json.
//
// The grader under test (per ENGINE4_PRODUCTION_DESIGN_2026_08_18.md) is OpenAI.
// The existing gold was WRITTEN by Claude (Anthropic) -- Anthropic is therefore
// "consumed" as the writer family and cannot also verify. This script runs ONE
// independent, blind verifier model (passed via --model) over all 200 photos,
// using the exact same prompt-construction / output-schema shape as
// hand_drawn_graph_real_photo_benchmark_gpt52_run.mjs, so results are directly
// comparable. The verifier NEVER sees: the existing gold labels, the other
// verifier's output, or any grader (gpt-5.2) output -- buildPrompt() only ever
// includes item_id / archetype / student prompt / rubric criteria, exactly as
// in the original gold-writing and grading passes.
//
// Usage:
//   node decision_0045_verify_run.mjs --model google/gemini-2.5-flash --out <path> [--limit N]
//   node decision_0045_verify_run.mjs --model moonshotai/kimi-k2 --out <path> [--limit N]

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
const SAMPLES_ROOT = path.join(ROOT, 'docs', 'hand drawn samples');
const GOLD_JSONL = path.join(
  ROOT, 'docs', 'research', 'hand_drawn_graph_corpus_2026_06_29',
  'hand_drawn_graph_questions_2026_06_29.jsonl',
);
const BENCH_DIR = path.join(ROOT, 'docs', 'research', 'hand_drawn_graph_real_photo_benchmark_2026_08_18');
const REAL_GOLD_JSON = path.join(BENCH_DIR, 'gold', 'real_photo_gold_labels_2026_08_18.json');

// gpt-5.2's original run used 600 -- raised here after validation showed
// google/gemini-2.5-flash spends a large, UNPREDICTABLE chunk of the output
// budget on internal reasoning ("thoughts") tokens before emitting the JSON
// object (observed range: ~1050 to ~4316 thinking tokens for different
// photos of the same 9-criterion item), truncating the structured output at
// 2500 and even at 4500 on some photos. 8000 was confirmed clean on the
// worst-case observed photo (4316 thinking + ~250 text) with real headroom
// to spare; used for every archetype/model for consistency.
const MAX_OUTPUT_TOKENS = 8000;

function fail(message) {
  console.error(`error: ${message}`);
  process.exit(1);
}

function stableHash(...parts) {
  return crypto.createHash('sha256').update(parts.join('\0')).digest('hex');
}

function sha256File(filePath) {
  return crypto.createHash('sha256').update(fs.readFileSync(filePath)).digest('hex');
}

function loadGold() {
  const byItemId = new Map();
  const lines = fs.readFileSync(GOLD_JSONL, 'utf8').split('\n').filter(Boolean);
  for (const line of lines) {
    const record = JSON.parse(line);
    byItemId.set(record.item_id, record);
  }
  return byItemId;
}

function loadRealGoldByFilePath() {
  const records = JSON.parse(fs.readFileSync(REAL_GOLD_JSON, 'utf8'));
  const byFilePath = new Map();
  for (const record of records) {
    byFilePath.set(path.resolve(record.file_path), record);
  }
  return byFilePath;
}

function walk(dir) {
  const out = [];
  for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
    const full = path.join(dir, entry.name);
    if (entry.isDirectory()) {
      out.push(...walk(full));
    } else if (entry.isFile()) {
      out.push(full);
    }
  }
  return out;
}

function collectRealPhotos() {
  const exts = new Set(['.jpg', '.jpeg', '.png']);
  const all = walk(SAMPLES_ROOT).filter((p) => exts.has(path.extname(p).toLowerCase()));
  const named = all.filter((p) => path.basename(p).includes('HDG-2026-P1'));

  const bySha = new Map();
  for (const filePath of named) {
    const sha = sha256File(filePath);
    if (!bySha.has(sha)) {
      bySha.set(sha, filePath);
    }
  }

  const records = [];
  for (const [sha, filePath] of bySha) {
    const base = path.basename(filePath);
    const match = base.match(/^(HDG-2026-P1-[A-Z]+-\d+)__response-(\d+)\./);
    if (!match) continue;
    records.push({
      itemId: match[1],
      responseIndex: match[2],
      filePath,
      sha256: sha,
      packet: filePath.includes('Biology Packet 2')
        ? 'packet_2'
        : filePath.includes('Biology Packet 3')
        ? 'packet_3'
        : 'packet_1_root',
    });
  }
  return records.sort((a, b) => a.itemId.localeCompare(b.itemId) || a.responseIndex.localeCompare(b.responseIndex));
}

// IMPORTANT: this prompt is identical in shape/content to the original
// gold-writing / grading prompts -- item_id, archetype, student prompt, and
// rubric criteria (criterion_id + met_rule) only. It never includes
// criterion_statuses (the existing gold labels), any other model's output,
// or anything from a grading pass.
function buildPrompt(gold) {
  const criteria = gold.criterion_definitions
    .map((c) => `- ${c.criterion_id}: ${c.met_rule}`)
    .join('\n');
  return [
    `Item ID: ${gold.item_id}`,
    `Archetype: ${gold.archetype}`,
    'Prompt:',
    gold.student_prompt || gold.stem || '',
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

// Rough per-model pricing for cost tracking only ($/1M tokens).
const PRICING = {
  'google/gemini-2.5-flash': { input: 0.30, cached: 0.075, output: 2.50 },
  'moonshotai/kimi-k2': { input: 0.60, cached: 0.15, output: 2.50 },
  'moonshotai/kimi-k2-thinking': { input: 0.60, cached: 0.15, output: 2.50 },
  // Conservative (likely-high) placeholder -- no gateway-reported cost field
  // for this model at probe time; erred high on purpose for the cost-cap check.
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

  const gold = loadGold();
  const realGoldByFilePath = loadRealGoldByFilePath();
  let photos = collectRealPhotos();
  const unmatched = photos.filter((p) => !gold.has(p.itemId));
  const unmatchedRealGold = photos.filter((p) => gold.has(p.itemId) && !realGoldByFilePath.has(path.resolve(p.filePath)));
  photos = photos.filter((p) => gold.has(p.itemId) && realGoldByFilePath.has(path.resolve(p.filePath)));
  const totalRunnable = photos.length;
  if (args.skip) photos = photos.slice(args.skip);
  if (args.limit) photos = photos.slice(0, args.limit);

  if (photos.length === 0) {
    fail('no runnable real-photo records found (after --skip/--limit)');
  }
  console.log(
    `model=${args.model} runnable real photos: ${totalRunnable} (unmatched against corpus gold: ${unmatched.length}, ` +
    `unmatched against real per-photo gold labels: ${unmatchedRealGold.length}); processing ${photos.length} starting at skip=${args.skip}`,
  );

  // Append-only within a single logical run: this script is invoked
  // repeatedly in bounded synchronous chunks (via --skip) to cover all 200
  // photos without a background/async wait pattern. skip=0 must not clobber
  // a file left by a DIFFERENT prior run -- it refuses if the target
  // already exists. skip>0 chunks append to the file the skip=0 call created.
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

  for (const photo of photos) {
    const record = gold.get(photo.itemId);
    const prompt = buildPrompt(record);
    const imageBuffer = fs.readFileSync(photo.filePath);
    const promptHash = stableHash('DECISION_0045_VERIFY', args.model, photo.itemId, prompt);

    const final = await runCall(args.model, prompt, imageBuffer);
    totalCost += final.costUsd;
    if (final.ok) okCount += 1; else errCount += 1;

    const predictedStatuses = {};
    for (const entry of final.final?.criterion_statuses || []) {
      if (entry && entry.criterion_id) {
        predictedStatuses[entry.criterion_id] = entry.status;
      }
    }

    const result = {
      item_id: photo.itemId,
      packet: photo.packet,
      response_index: photo.responseIndex,
      file_path: photo.filePath,
      file_name: path.relative(SAMPLES_ROOT, photo.filePath),
      sha256: photo.sha256,
      archetype: record.archetype,
      item_version: record.item_version,
      prompt_hash: promptHash,
      model_id: args.model,
      schema_valid: final.ok && Object.keys(record.criterion_definitions.reduce((m, c) => (m[c.criterion_id] = 1, m), {}))
        .every((cid) => predictedStatuses[cid]),
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
      `${photo.itemId} (${photo.packet}) ${final.ok ? 'ok' : 'ERR'} cost=$${final.costUsd.toFixed(5)} ${Math.round(result.latency_ms)}ms\n`,
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
