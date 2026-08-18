// Real-capture-conditions extension of hand_drawn_graph_benchmark_run.mjs.
//
// The 2026-06-30 benchmark (see docs/research/hand_drawn_graph_benchmark_2026_06_30/)
// validated grading accuracy against clean, computer-rendered trace-set pages
// (97-100% exact match). TASK-0020 Program C did not accept that as sufficient
// evidence because real capture conditions (lighting, paper texture, camera
// angle, blur) were never tested. This script runs the same validated method
// (VISION_FAST_ESC) against the real photographed corpus in
// `docs/hand drawn samples/` instead -- real phone photos of real hand-drawn
// responses to the same 150-item HDG-2026-P1 item set, drawn across three
// separate drawer packets (root P1 files + "Other Bio HDR/Biology Packet 2"
// + "Other Bio HDR/Biology Packet 3"), owner-confirmed as the owner's/family's/
// contracted (Upwork) work with no consent issue (2026-08-18, in-session).
//
// Scope/limits, stated up front:
// - gold = per-image, per-criterion human-graded labels in
//   docs/research/hand_drawn_graph_real_photo_benchmark_2026_08_18/gold/real_photo_gold_labels_2026_08_18.json.
//   An earlier version of this script assumed gold = all-criteria-"earned"
//   for every record (mirroring the clean trace-set benchmark). That
//   assumption was wrong and was corrected in-session (2026-08-18): these
//   real photos are NOT all faithful/correct attempts -- some are genuinely
//   partial-credit, some have corpus defects (corrupted axis ticks on many
//   EST-archetype items, missing units, a handful of misfiled photos showing
//   the wrong item's content). The gold file was built by 20 independent
//   grading passes, one photo at a time, checking plotted values against
//   each item's display_table/expected_graph_spec rather than assuming
//   correctness. This is now a real accuracy measurement (both false-accept
//   and false-reject are measurable), not a recall-only proxy.
// - Only the HDG-2026-P1-named files are used (the AP Biology graph corpus
//   this benchmark package's gold data actually covers). The AP Statistics
//   set (Stats-HRD-2), the "DRG...MASTER_FULL_CREDIT" reference-key images
//   (root IMG_69xx), the unidentified "App Graphs from Pdf 1" images, and
//   the unrelated Calc/Chem formula samples are explicitly out of scope for
//   this run -- no gold rubric data has been located for them yet.
// - Byte-identical duplicates are dropped (keeps one copy per unique sha256).

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
const OUTPUT_JSONL = path.join(OUT_DIR, 'runs', 'real_photo_benchmark_results.jsonl');
const REAL_GOLD_JSON = path.join(OUT_DIR, 'gold', 'real_photo_gold_labels_2026_08_18.json');

const ARM = {
  model: 'openai/gpt-4o-mini',
  reasoningEffort: null,
  maxOutputTokens: 300,
  providerOptions: {},
  escalationModel: 'openai/gpt-5.5',
  escalationReasoningEffort: 'medium',
  escalationMaxOutputTokens: 350,
};

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
  // Only HDG-2026-P1-named files -- these are the ones with recoverable
  // item_id linkage and matching gold data. Everything else (Stats-HRD-2,
  // root IMG_69xx "DRG...MASTER" reference keys, "App Graphs from Pdf 1",
  // Calc AB HDR, Chem HDR, unnamed Bio-HRD raw duplicates) is out of scope.
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

function estimateCost(usage, modelName) {
  const pricing = modelName === 'openai/gpt-5.5'
    ? { input: 5.0, cached: 0.5, output: 30.0 }
    : { input: 0.15, cached: 0.075, output: 0.6 };
  const inputTokens = Number(usage.inputTokens || 0);
  const cachedTokens = Number(usage.cachedTokens || 0);
  const outputTokens = Number(usage.outputTokens || 0);
  const uncached = Math.max(inputTokens - cachedTokens, 0);
  return ((uncached * pricing.input) + (cachedTokens * pricing.cached) + (outputTokens * pricing.output)) / 1_000_000;
}

async function runCall(modelName, reasoningEffort, maxOutputTokens, prompt, imageBuffer, providerOptions = {}) {
  const started = performance.now();
  const result = streamObject({
    model: modelName,
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
    ...(reasoningEffort ? { providerOptions: { ...providerOptions, openai: { reasoningEffort } } } : { providerOptions }),
    maxOutputTokens,
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
      costUsd: estimateCost(
        {
          inputTokens: usage?.inputTokens ?? 0,
          outputTokens: usage?.outputTokens ?? 0,
          cachedTokens: usage?.cachedInputTokens ?? usage?.cachedTokens ?? 0,
        },
        modelName,
      ),
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
    `runnable real photos: ${photos.length} (unmatched against corpus gold: ${unmatched.length}, ` +
    `unmatched against real per-photo gold labels: ${unmatchedRealGold.length})`,
  );

  fs.mkdirSync(path.dirname(OUTPUT_JSONL), { recursive: true });
  const output = fs.createWriteStream(OUTPUT_JSONL, { flags: 'w' });

  for (const photo of photos) {
    const record = gold.get(photo.itemId);
    const prompt = buildPrompt(record);
    const imageBuffer = fs.readFileSync(photo.filePath);
    const promptHash = stableHash('VISION_FAST_ESC', photo.itemId, prompt);

    const primary = await runCall(ARM.model, ARM.reasoningEffort, ARM.maxOutputTokens, prompt, imageBuffer, ARM.providerOptions);
    let final = primary;
    let modelIdUsed = ARM.model;
    let escalationTriggered = false;
    let escalationModelId = '';
    let escalationLatencyMs = 0;
    let escalationCostUsd = 0;

    const primaryStatusesList = Array.isArray(primary.final?.criterion_statuses)
      ? primary.final.criterion_statuses.map((entry) => entry.status)
      : [];
    const needsEscalation = !primary.ok
      || primaryStatusesList.some((status) => status !== 'earned')
      || primary.final?.confidence === 'low';
    if (needsEscalation) {
      escalationTriggered = true;
      escalationModelId = ARM.escalationModel;
      const escalated = await runCall(
        ARM.escalationModel,
        ARM.escalationReasoningEffort,
        ARM.escalationMaxOutputTokens,
        prompt,
        imageBuffer,
      );
      escalationLatencyMs = escalated.latencyMs;
      escalationCostUsd = escalated.costUsd;
      if (escalated.ok) {
        final = escalated;
        modelIdUsed = ARM.escalationModel;
      }
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
      model_id: modelIdUsed,
      escalation_model_id: escalationModelId,
      escalation_triggered: escalationTriggered,
      schema_valid: schemaValid,
      exact_match: exactMatch,
      latency_ms: final.latencyMs + escalationLatencyMs,
      ttfb_ms: final.ttfbMs,
      cost_usd: final.costUsd + escalationCostUsd,
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
