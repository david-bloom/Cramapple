// Targeted ZERO_INTERCEPT_ANNOTATION prompt-clarification retest.
//
// Follow-up to docs/research/HAND_DRAWN_REAL_PHOTO_GRADING_ACCURACY_2026_08_18.md,
// "ZERO_INTERCEPT_ANNOTATION diagnosis" section: this criterion got WORSE in
// absolute terms with gpt-5.2 vs the gpt-4o-mini baseline (9->13 wrong).
// Manual review of all 12 false-reject rationales, PLUS direct visual
// inspection of two of the underlying photos (EST-010, EST-016), confirmed
// the cause: the model is conflating two separate rubric criteria on this
// archetype --
//   Y_SCALE: "Y-axis includes zero and all observations"
//   ZERO_INTERCEPT_ANNOTATION: "Annotation visibly links the zero crossing
//     to the x-axis"
// -- and using a missing y=0 printed tick (a real Y_SCALE fact) to ALSO
// fail ZERO_INTERCEPT_ANNOTATION, even when a correctly-drawn vertical line
// clearly connects the annotation to the x-axis (visually confirmed present
// in both inspected photos, which gold correctly credited).
//
// This script is identical to hand_drawn_graph_real_photo_benchmark_gpt52_run.mjs
// except: (a) filtered to the continuous_relationship_graph_derived_estimate
// (EST) archetype only -- the only archetype with this criterion, 67 photos,
// the full natural population, not a further subsample; (b) one clarifying
// sentence added to the prompt, scoped narrowly to this exact conflation so
// it doesn't loosen any other criterion's standard. Scored against the
// ORIGINAL gold (unchanged -- see the "open question, not corrected" note
// in the research doc) so the prompt effect is isolated cleanly.

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
const OUTPUT_JSONL = path.join(OUT_DIR, 'runs', 'real_photo_benchmark_gpt52_zia_prompt_results.jsonl');
const REAL_GOLD_JSON = path.join(OUT_DIR, 'gold', 'real_photo_gold_labels_2026_08_18.json');
const TARGET_ARCHETYPE = 'continuous_relationship_graph_derived_estimate';

const MODEL = 'openai/gpt-5.2';
const MAX_OUTPUT_TOKENS = 600;

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

function buildPrompt(gold) {
  const criteria = gold.criterion_definitions
    .map((c) => `- ${c.criterion_id}: ${c.met_rule}`)
    .join('\n');
  const lines = [
    `Item ID: ${gold.item_id}`,
    `Archetype: ${gold.archetype}`,
    'Prompt:',
    gold.student_prompt || gold.stem || '',
    '',
    'Rubric criteria (evaluate strictly against these rules):',
    criteria,
    '',
  ];
  if (gold.criterion_definitions.some((c) => c.criterion_id === 'ZERO_INTERCEPT_ANNOTATION')) {
    lines.push(
      'Note: ZERO_INTERCEPT_ANNOTATION and Y_SCALE are separate, independent',
      'criteria -- grade them independently. ZERO_INTERCEPT_ANNOTATION only',
      'requires a vertical line or mark that visibly connects the written',
      'estimate to the correct x-axis position; it does NOT require the',
      'y-axis to show a printed "0" tick label (that is Y_SCALE\'s concern,',
      'not this one). If a vertical line clearly runs from the x-axis up to',
      'the fitted line/curve at the estimated x-value, with the estimate',
      'written next to it, credit ZERO_INTERCEPT_ANNOTATION regardless of',
      'whether the y-axis explicitly labels zero.',
      '',
    );
  }
  lines.push(
    'Inspect the photographed hand-drawn response and return a criterion status',
    '(earned / not_earned / unable_to_determine) for every criterion listed above,',
    'based only on what is visible in the image.',
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
  let photos = collectRealPhotos();
  const unmatched = photos.filter((p) => !gold.has(p.itemId));
  const unmatchedRealGold = photos.filter((p) => gold.has(p.itemId) && !realGoldByFilePath.has(path.resolve(p.filePath)));
  photos = photos.filter((p) => gold.has(p.itemId) && realGoldByFilePath.has(path.resolve(p.filePath)));
  photos = photos.filter((p) => gold.get(p.itemId).archetype === TARGET_ARCHETYPE);
  if (args.limit) photos = photos.slice(0, args.limit);

  if (photos.length === 0) {
    fail('no runnable real-photo records found');
  }
  console.log(
    `model=${MODEL} runnable real photos: ${photos.length} (unmatched against corpus gold: ${unmatched.length}, ` +
    `unmatched against real per-photo gold labels: ${unmatchedRealGold.length})`,
  );

  fs.mkdirSync(path.dirname(OUTPUT_JSONL), { recursive: true });
  const output = fs.createWriteStream(OUTPUT_JSONL, { flags: 'w' });

  for (const photo of photos) {
    const record = gold.get(photo.itemId);
    const prompt = buildPrompt(record);
    const imageBuffer = fs.readFileSync(photo.filePath);
    const promptHash = stableHash('GPT52_ZIA_PROMPT_CLARIFIED', photo.itemId, prompt);

    const final = await runCall(prompt, imageBuffer);

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
