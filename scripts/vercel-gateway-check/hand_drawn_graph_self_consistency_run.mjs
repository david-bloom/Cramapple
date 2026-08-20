// FAR-reduction experiment 1: self-consistency ensemble, gated
// asymmetrically. Run gpt-5.2 two MORE times per photo (the existing
// full-corpus baseline run already provides run #1), same
// buildPrompt/schema/model as hand_drawn_graph_real_photo_benchmark_gpt52_run.mjs,
// so results are directly comparable. Only "earned" verdicts need
// consensus across the 3 runs; a single "not_earned" is not overridden --
// this asymmetry is applied at analysis time (hand_drawn_graph_self_consistency_report.mjs),
// not in this collection script, which just gathers runs #2 and #3.
//
// Checkpointed: writes one line per photo per extra run, resumable.

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
    if (key && !(key in process.env)) process.env[key] = value;
  }
}

const ROOT = path.resolve(new URL('.', import.meta.url).pathname, '..', '..');
const SAMPLES_ROOT = path.join(ROOT, 'docs', 'hand drawn samples');
const GOLD_JSONL = path.join(ROOT, 'docs', 'research', 'hand_drawn_graph_corpus_2026_06_29', 'hand_drawn_graph_questions_2026_06_29.jsonl');
const OUT_DIR = path.join(ROOT, 'docs', 'research', 'hand_drawn_graph_real_photo_benchmark_2026_08_18');
const REAL_GOLD_JSON = path.join(OUT_DIR, 'gold', 'real_photo_gold_labels_2026_08_18.json');
const SUBSAMPLE_JSON = path.join(OUT_DIR, 'gold', 'far_experiment_subsample_2026_08_18.json');
const OUTPUT_JSONL = path.join(OUT_DIR, 'runs', 'self_consistency_extra_runs_results.jsonl');

const MODEL = 'openai/gpt-5.2';
const MAX_OUTPUT_TOKENS = 600;
const RUNS_PER_PHOTO = 2; // runs #2 and #3 (run #1 = existing baseline)

function loadGold() {
  const byItemId = new Map();
  for (const line of fs.readFileSync(GOLD_JSONL, 'utf8').split('\n').filter(Boolean)) {
    const record = JSON.parse(line);
    byItemId.set(record.item_id, record);
  }
  return byItemId;
}

function buildPrompt(gold) {
  const criteria = gold.criterion_definitions.map((c) => `- ${c.criterion_id}: ${c.met_rule}`).join('\n');
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
  return [{ role: 'user', content: [{ type: 'text', text: prompt }, { type: 'image', image: imageBuffer }] }];
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
      criterion_statuses: z.array(z.object({ criterion_id: z.string(), status: z.enum(['earned', 'not_earned', 'unable_to_determine']) })),
      confidence: z.enum(['high', 'medium', 'low']),
      rationale: z.string(),
    }),
    messages: buildMessages(prompt, imageBuffer),
    maxOutputTokens: MAX_OUTPUT_TOKENS,
  });
  try {
    for await (const _chunk of result.partialObjectStream) { /* drain */ }
    const final = await result.object;
    const usage = await result.usage;
    return {
      ok: true, final,
      costUsd: estimateCost({ inputTokens: usage?.inputTokens ?? 0, outputTokens: usage?.outputTokens ?? 0, cachedTokens: usage?.cachedInputTokens ?? usage?.cachedTokens ?? 0 }),
      latencyMs: performance.now() - started,
    };
  } catch (error) {
    return { ok: false, error: error?.message || String(error), final: null, costUsd: 0, latencyMs: performance.now() - started };
  }
}

function photoKey(itemId, fileName, runIndex) {
  return `${itemId} ${fileName} run${runIndex}`;
}

async function main() {
  loadEnvFile(path.join(ROOT, 'scripts', 'vercel-gateway-check', '.env.local'));
  if (!process.env.AI_GATEWAY_API_KEY && process.env.VERCEL_OIDC_TOKEN) process.env.AI_GATEWAY_API_KEY = process.env.VERCEL_OIDC_TOKEN;

  const gold = loadGold();
  const realGoldByFilePath = new Map(JSON.parse(fs.readFileSync(REAL_GOLD_JSON, 'utf8')).map((r) => [path.resolve(r.file_path), r]));
  // Optional full-corpus override (2026-08-20): point at all 200 photos + a
  // separate output file, leaving the n=39 pilot invocation untouched when unset.
  const inputJson = process.env.SC_INPUT_JSON ? path.resolve(process.env.SC_INPUT_JSON) : SUBSAMPLE_JSON;
  const outputJsonl = process.env.SC_OUTPUT_JSONL ? path.resolve(process.env.SC_OUTPUT_JSONL) : OUTPUT_JSONL;
  let subsample = JSON.parse(fs.readFileSync(inputJson, "utf8"));
  if (process.env.FAR_TEST_LIMIT) subsample = subsample.slice(0, Number(process.env.FAR_TEST_LIMIT));

  fs.mkdirSync(path.dirname(outputJsonl), { recursive: true });
  const done = new Set();
  if (fs.existsSync(outputJsonl)) {
    for (const line of fs.readFileSync(outputJsonl, 'utf8').trim().split('\n').filter(Boolean)) {
      const rec = JSON.parse(line);
      done.add(photoKey(rec.item_id, rec.file_name, rec.run_index));
    }
  }
  console.log(`${done.size} already completed (resume), ${subsample.length} photos x ${RUNS_PER_PHOTO} extra runs = ${subsample.length * RUNS_PER_PHOTO} total needed`);

  const output = fs.createWriteStream(outputJsonl, { flags: 'a' });
  let completed = 0;
  const totalNeeded = subsample.length * RUNS_PER_PHOTO;

  for (const photo of subsample) {
    const record = gold.get(photo.item_id);
    const fileName = path.relative(SAMPLES_ROOT, photo.file_path);
    const goldRecord = realGoldByFilePath.get(path.resolve(photo.file_path));
    const prompt = buildPrompt(record);
    const imageBuffer = fs.readFileSync(photo.file_path);

    for (let runIndex = 2; runIndex <= RUNS_PER_PHOTO + 1; runIndex += 1) {
      const key = photoKey(photo.item_id, fileName, runIndex);
      if (done.has(key)) continue;

      const result = await runCall(prompt, imageBuffer);
      const predictedStatuses = {};
      for (const entry of result.final?.criterion_statuses || []) {
        if (entry?.criterion_id) predictedStatuses[entry.criterion_id] = entry.status;
      }
      const rec = {
        item_id: photo.item_id, file_name: fileName, archetype: photo.archetype, run_index: runIndex,
        ok: result.ok, error: result.error || '', cost_usd: result.costUsd, latency_ms: result.latencyMs,
        criterion_statuses: predictedStatuses, gold_criterion_statuses: goldRecord.criterion_statuses,
        confidence: result.final?.confidence || 'low',
      };
      output.write(`${JSON.stringify(rec)}\n`);
      completed += 1;
      process.stdout.write(`[${completed}] ${photo.item_id} run${runIndex} ${result.ok ? 'ok' : 'ERR'} $${result.costUsd.toFixed(4)}\n`);
    }
  }
  output.end();
  await new Promise((resolve) => output.on('finish', resolve));
  console.log(`wrote ${outputJsonl}`);
}

main().catch((e) => { console.error(e); process.exit(1); });
