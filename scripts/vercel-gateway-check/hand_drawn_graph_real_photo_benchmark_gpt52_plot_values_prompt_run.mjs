// Targeted PLOT_VALUES prompt-clarification retest, same method as the
// ZERO_INTERCEPT_ANNOTATION fix.
//
// PLOT_VALUES is gpt-5.2's largest-volume remaining error (57/200 wrong,
// 28.5%, across all three archetypes -- see
// docs/research/HAND_DRAWN_REAL_PHOTO_GRADING_ACCURACY_2026_08_18.md).
// Read a sample of false-rejects AND false-accepts, plus directly inspected
// one underlying photo (CAT-008), before writing a fix -- same discipline as
// the ZIA diagnosis, since a careless "just be more lenient" prompt change
// risks making false-accept rate (already the worst-performing metric)
// worse rather than better.
//
// Finding: the model's PERCEPTION is generally accurate (it reads what's
// actually drawn correctly) -- the disagreement with gold is about
// TOLERANCE. The rubric's own wording is "recoverable positions/coordinates",
// not "exact positions", and gold consistently credits small deviations
// (roughly one gridline-subdivision worth of normal hand-drawing/reading
// imprecision -- e.g. CAT-008: true 23/25/40/42, drawn ~20/~24/~40/~40-41,
// credited) while still correctly failing larger deviations or, more
// importantly, deviations that invert or erase the REQUIRED RELATIVE
// ORDERING between points (e.g. CAT-004: warm should sit clearly above cool,
// drawn at/below it -- gold explicitly calls this "a genuine value mismatch
// rather than just imprecision" and fails it; CAT-009: two points that
// should differ by 12 units drawn nearly on top of each other -- failed).
// The fix teaches this same two-part standard (small offset = imprecision,
// ok; broken relative ordering/separation = real mismatch, not ok) instead
// of either an implicit exact-match standard or an indiscriminate "be more
// lenient" instruction that would blur the two together.
//
// Applies to all three archetypes (PLOT_VALUES appears in all of them,
// unlike ZERO_INTERCEPT_ANNOTATION which was EST-only) -- run against the
// full 200-photo corpus, same gold, same output shape as the original
// gpt-5.2 benchmark, with only this one clarifying paragraph added.

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
const OUTPUT_JSONL = path.join(OUT_DIR, 'runs', 'real_photo_benchmark_gpt52_plot_values_prompt_results.jsonl');
const REAL_GOLD_JSON = path.join(OUT_DIR, 'gold', 'real_photo_gold_labels_2026_08_18.json');

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
  if (gold.criterion_definitions.some((c) => c.criterion_id === 'PLOT_VALUES')) {
    lines.push(
      'Note on PLOT_VALUES: "recoverable position/coordinates" means',
      'approximately correct, not pixel-exact -- this is a hand-drawn photo,',
      'not a precision plot. A point drawn off from the exact table value by',
      'roughly one minor-gridline-subdivision (normal hand-drawing and photo-',
      'reading imprecision) still counts as earned. Only mark PLOT_VALUES',
      'not_earned when either: (a) one or more points are off by a materially',
      'larger amount -- clearly closer to a different gridline/value than the',
      'correct one -- or (b) the drawn positions invert or erase a REQUIRED',
      'RELATIVE relationship between points from the table (e.g. a point that',
      'should sit clearly higher than another is drawn at or below it, or two',
      'points that the table requires to be clearly separated are drawn at',
      'essentially the same position). Case (b) changes the actual finding',
      'the graph shows and should fail even if each individual point looks',
      'plausible in isolation; small uniform offset alone should not.',
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
    const promptHash = stableHash('GPT52_PLOT_VALUES_PROMPT_CLARIFIED', photo.itemId, prompt);

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
