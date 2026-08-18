// Controlled escalation test -- second-pass model on gpt-5.2's medium-
// confidence responses only.
//
// Follow-up to docs/research/HAND_DRAWN_REAL_PHOTO_GRADING_ACCURACY_2026_08_18.md.
// The ORIGINAL VISION_FAST_ESC benchmark's escalation design (gpt-4o-mini
// primary -> gpt-5.5 on low confidence) looked bad in its very first result,
// but that comparison was confounded: escalation only ever ran on the hard
// subset by construction, so "escalated cases score worse" never isolated
// escalation's actual effect from the fact that the escalated subset was
// already harder going in. This script runs google/gemini-3.1-pro-preview
// (the model that scored highest raw quality in the extraction-only probe,
// but has an unresolved structured-output reliability problem -- only 52%
// of calls succeeded even after one retry pass in that earlier test) on
// EXACTLY the 21-photo subsample selected by
// select_escalation_test_subsample.mjs: gpt-5.2's medium-confidence
// responses, 7 per archetype, deterministic. Retry-on-failure (up to 2
// additional attempts) is built in from the start, since a smaller escalated
// volume can afford retries in a way running gemini on the full corpus
// couldn't. Same buildPrompt/schema/scoring shape as
// hand_drawn_graph_real_photo_benchmark_gpt52_run.mjs, so gemini's result on
// these 21 photos can be directly compared against gpt-5.2's already-
// recorded result on the SAME 21 photos -- a clean before/after on the
// actual population a real escalation policy would trigger on, not a
// confounded correlational read.

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
const OUT_DIR = path.join(ROOT, 'docs', 'research', 'hand_drawn_graph_real_photo_benchmark_2026_08_18');
const OUTPUT_JSONL = path.join(OUT_DIR, 'runs', 'escalation_gemini_results.jsonl');
const REAL_GOLD_JSON = path.join(OUT_DIR, 'gold', 'real_photo_gold_labels_2026_08_18.json');
const SUBSAMPLE_JSON = path.join(OUT_DIR, 'gold', 'escalation_test_subsample_2026_08_18.json');

// Pivoted from google/gemini-3.1-pro-preview: it failed all 3 photos in a
// pilot run even with 2 retries each, at multiple token budgets (600/1200/
// 2000) -- the raw stream showed premature termination after only a few
// dozen output tokens, not truncation, meaning its reliability problem is
// WORSE on this heavier joint-judgment schema than the simpler extraction
// schema it was tested on before (~52% success there). Not worth debugging
// further as part of this test. openai/gpt-5.2-pro is a genuinely heavier/
// more capable tier from the same family gpt-5.2 already proved 100%
// reliable on this exact task -- a clean escalation candidate without
// inheriting an unresolved reliability confound.
const MODEL = 'openai/gpt-5.2-pro';
const MAX_OUTPUT_TOKENS = 1200;
const MAX_RETRIES = 2;

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

function loadEscalationSubsample() {
  const entries = JSON.parse(fs.readFileSync(SUBSAMPLE_JSON, 'utf8'));
  return entries.map((entry) => ({
    itemId: entry.item_id,
    filePath: entry.file_path,
    sha256: sha256File(entry.file_path),
    packet: entry.file_path.includes('Biology Packet 2')
      ? 'packet_2'
      : entry.file_path.includes('Biology Packet 3')
      ? 'packet_3'
      : 'packet_1_root',
  }));
}

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

function estimateCost(usage) {
  // Approximate -- gpt-5.2 pricing treated as the same frontier tier as
  // gpt-5.5 for this diagnostic script's rough cost tracking only.
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
        reasoningTokens: usage?.reasoningTokens ?? 0,
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
      usage: { inputTokens: 0, outputTokens: 0, reasoningTokens: 0, cachedTokens: 0 },
      latencyMs: performance.now() - started,
      ttfbMs: null,
      costUsd: 0,
    };
  }
}

function goldStatuses(realGoldRecord) {
  return realGoldRecord.criterion_statuses;
}

function parseArgs(argv) {
  const out = { limit: null };
  for (let i = 2; i < argv.length; i += 1) {
    if (argv[i] === '--limit' && argv[i + 1]) {
      out.limit = Number(argv[++i]);
    }
  }
  return out;
}

async function main() {
  const args = parseArgs(process.argv);
  loadEnvFile(path.join(ROOT, 'scripts', 'vercel-gateway-check', '.env.local'));
  if (!process.env.AI_GATEWAY_API_KEY && process.env.VERCEL_OIDC_TOKEN) {
    process.env.AI_GATEWAY_API_KEY = process.env.VERCEL_OIDC_TOKEN;
  }

  const gold = loadGold();
  const realGoldByFilePath = loadRealGoldByFilePath();
  let photos = loadEscalationSubsample();
  if (args.limit) photos = photos.slice(0, args.limit);

  if (photos.length === 0) {
    fail('no runnable real-photo records found');
  }
  console.log(`model=${MODEL} escalation subsample: ${photos.length} photos (gpt-5.2 medium-confidence)`);

  fs.mkdirSync(path.dirname(OUTPUT_JSONL), { recursive: true });
  const output = fs.createWriteStream(OUTPUT_JSONL, { flags: 'w' });

  for (const photo of photos) {
    const record = gold.get(photo.itemId);
    const prompt = buildPrompt(record);
    const imageBuffer = fs.readFileSync(photo.filePath);
    const promptHash = stableHash('ESCALATION_GEMINI', photo.itemId, prompt);

    let final = await runCall(prompt, imageBuffer);
    let retries = 0;
    while (!final.ok && retries < MAX_RETRIES) {
      retries += 1;
      final = await runCall(prompt, imageBuffer);
    }

    const predictedStatuses = {};
    for (const entry of final.final?.criterion_statuses || []) {
      if (entry && entry.criterion_id) {
        predictedStatuses[entry.criterion_id] = entry.status;
      }
    }
    const realGoldRecord = realGoldByFilePath.get(path.resolve(photo.filePath));
    const goldMap = goldStatuses(realGoldRecord);
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
      item_id: photo.itemId,
      packet: photo.packet,
      response_index: photo.responseIndex,
      file_name: path.relative(SAMPLES_ROOT, photo.filePath),
      sha256: photo.sha256,
      archetype: record.archetype,
      item_version: record.item_version,
      prompt_hash: promptHash,
      model_id: MODEL,
      retries,
      schema_valid: schemaValid,
      exact_match: exactMatch,
      latency_ms: final.latencyMs,
      ttfb_ms: final.ttfbMs,
      cost_usd: final.costUsd,
      output_tokens: final.usage?.outputTokens || 0,
      criterion_statuses: predictedStatuses,
      gold_criterion_statuses: goldMap,
      gold_confidence: realGoldRecord.confidence,
      gold_rationale: realGoldRecord.rationale,
      criterion_results: criterionResults,
      confidence: final.final?.confidence || 'low',
      rationale: final.final?.rationale || '',
      ok: final.ok,
      error: final.error || '',
    };
    output.write(`${JSON.stringify(result)}\n`);
    process.stdout.write(
      `${photo.itemId} (${photo.packet}) ${final.ok ? 'ok' : 'ERR'} exact=${exactMatch} ${Math.round(result.latency_ms)}ms\n`,
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
