// PLOT_VALUES prompt fix, second attempt (v2) -- narrower than the reverted
// 2026-08-18 fix (hand_drawn_graph_real_photo_benchmark_gpt52_plot_values_prompt_run.mjs).
//
// Context: DECISION-0045's blind two-verifier pass (Gemini 2.5 Flash + Qwen3-VL,
// docs/research/hand_drawn_graph_real_photo_benchmark_2026_08_18/decision_0045_verification_2026_08_19/)
// flagged 11 PLOT_VALUES cases where gold said not_earned/unable_to_determine and
// both independent verifiers said earned. Cross-referencing those 11 exact photos
// against the UNMODIFIED gpt-5.2 baseline (real_photo_benchmark_gpt52_results.jsonl)
// showed the baseline grader ALREADY agrees with the verifier consensus (predicted
// earned) on 7 of 11 -- CAT-004, CAT-009, CAT-016, CAT-017(resp-02), SER-007,
// SER-013, SER-015 -- with no fix applied at all. The v1 "small-offset-ok /
// ordering-violation-must-fail" fix, when checked against these same 11 photos
// using its own already-existing run output, actually moved TWO of those
// already-verifier-matching cases (CAT-004, CAT-009) AWAY from the verifier
// consensus and toward strict gold, while only fixing one (SER-017) in the
// intended direction -- a net-negative move on the very cases it should have
// helped, using the v1 fix's own recorded output, no new calls needed to see this.
//
// Diagnosis: v1 bundled two instructions -- (a) small positional offset is fine
// (magnitude tolerance) and (b) a broken *required relative ordering* between
// points must fail even if each point looks plausible alone (an explicit
// strictness carve-out). (b) is the more likely source of the perverse flips:
// CAT-004/CAT-009 are exactly the ordering-violation examples used to justify
// (b) in the first place, and both verifiers -- blind to gold and to each other --
// disagree with gold's "ordering violation = fail" call on both. This does not
// prove (b) is wrong (only 2 data points), but it is not evidence (b) helps,
// and it demonstrably made the grader diverge further from two independent
// models' convergent judgment on the two cases it was written for.
//
// v2 fix: keep ONLY the magnitude-tolerance clause (small offset ~= one
// minor-gridline-subdivision is fine), and DROP the explicit ordering-violation
// strictness carve-out -- let the model's own default judgment handle ordering
// rather than instructing it to be stricter than it already is. This is a
// narrower change than v1 (removes an instruction rather than adding a second
// one), testable against the same 11 flagged photos (does it stop flipping
// CAT-004/CAT-009 away from verifier consensus, without breaking SER-037's
// correctly-caught missing point?) plus a stratified 30-photo control sample
// of currently-CORRECT baseline PLOT_VALUES judgments (10/archetype, mixed
// earned/not_earned) to check for regression.
//
// This script runs ONLY the 41-photo flagged+control subset (see
// docs/research/hand_drawn_graph_real_photo_benchmark_2026_08_18/plot_values_fix_v2_2026_08_19/
// for the subset lists), not the full 200-photo corpus -- deliberately, to stay
// well under the $10 autonomous cost cap while still getting a controlled
// before/after read on both the flagged and control sets.

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
const OLD_OUT_DIR = path.join(ROOT, 'docs', 'research', 'hand_drawn_graph_real_photo_benchmark_2026_08_18');
const REAL_GOLD_JSON = path.join(OLD_OUT_DIR, 'gold', 'real_photo_gold_labels_2026_08_18.json');
const OUT_DIR = path.join(OLD_OUT_DIR, 'plot_values_fix_v2_2026_08_19');
const OUTPUT_JSONL = path.join(OUT_DIR, 'runs', 'plot_values_v2_results.jsonl');
const SUBSET_JSON = path.join(OUT_DIR, 'subset_photos.json');

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
      fileName: path.relative(SAMPLES_ROOT, filePath),
    });
  }
  return records;
}

function buildPromptV2(gold) {
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
      'not_earned when a point is off by a materially larger amount --',
      'clearly closer to a different gridline/value than the correct one --',
      'or when a required point is missing/omitted entirely. Use your own',
      'judgment for everything else about what the drawn positions show.',
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
  const allPhotos = collectRealPhotos();
  const byFileName = new Map(allPhotos.map((p) => [p.fileName, p]));

  const flagged = JSON.parse(fs.readFileSync(path.join(OUT_DIR, 'flagged_plot_values.json'), 'utf8'))
    .map((r) => ({ ...r, set: 'flagged' }));
  const control = JSON.parse(fs.readFileSync(path.join(OUT_DIR, 'control_sample.json'), 'utf8'))
    .map((r) => ({ ...r, set: 'control' }));

  let subset = [...flagged, ...control].map((r) => {
    const photo = byFileName.get(r.file_name);
    if (!photo) fail(`could not locate photo for ${r.item_id} / ${r.file_name}`);
    return { ...r, filePath: photo.filePath, sha256: photo.sha256 };
  });
  if (args.limit) subset = subset.slice(0, args.limit);

  fs.mkdirSync(path.dirname(SUBSET_JSON), { recursive: true });
  fs.writeFileSync(SUBSET_JSON, JSON.stringify(subset, null, 2));

  console.log(`model=${MODEL} subset size: ${subset.length} (flagged=${flagged.length}, control=${control.length})`);

  fs.mkdirSync(path.dirname(OUTPUT_JSONL), { recursive: true });
  const output = fs.createWriteStream(OUTPUT_JSONL, { flags: 'w' });

  let totalCost = 0;
  for (const photo of subset) {
    const record = gold.get(photo.item_id);
    if (!record) fail(`no corpus gold for ${photo.item_id}`);
    const prompt = buildPromptV2(record);
    const imageBuffer = fs.readFileSync(photo.filePath);
    const promptHash = stableHash('GPT52_PLOT_VALUES_V2_PROMPT', photo.item_id, prompt);

    const final = await runCall(prompt, imageBuffer);
    totalCost += final.costUsd;

    const predictedStatuses = {};
    for (const entry of final.final?.criterion_statuses || []) {
      if (entry && entry.criterion_id) {
        predictedStatuses[entry.criterion_id] = entry.status;
      }
    }
    const realGoldRecord = realGoldByFilePath.get(path.resolve(photo.filePath));
    if (!realGoldRecord) fail(`no real-photo gold for ${photo.filePath}`);
    const goldMap = realGoldRecord.criterion_statuses;
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
      set: photo.set,
      item_id: photo.item_id,
      file_name: photo.file_name,
      sha256: photo.sha256,
      archetype: record.archetype,
      item_version: record.item_version,
      prompt_hash: promptHash,
      model_id: MODEL,
      schema_valid: schemaValid,
      exact_match: exactMatch,
      latency_ms: final.latencyMs,
      cost_usd: final.costUsd,
      output_tokens: final.usage?.outputTokens || 0,
      criterion_statuses: predictedStatuses,
      gold_criterion_statuses: goldMap,
      criterion_results: criterionResults,
      confidence: final.final?.confidence || 'low',
      rationale: final.final?.rationale || '',
      ok: final.ok,
      error: final.error || '',
    };
    output.write(`${JSON.stringify(result)}\n`);
    const plotValues = criterionResults.find((c) => c.criterion_id === 'PLOT_VALUES');
    process.stdout.write(
      `[${photo.set}] ${photo.item_id} ${final.ok ? 'ok' : 'ERR'} PLOT_VALUES gold=${plotValues?.gold} predicted=${plotValues?.predicted} correct=${plotValues?.correct} cost=$${final.costUsd.toFixed(4)} totalCost=$${totalCost.toFixed(3)}\n`,
    );
  }

  output.end();
  await new Promise((resolve) => output.on('finish', resolve));
  console.log(`wrote ${OUTPUT_JSONL}`);
  console.log(`total cost: $${totalCost.toFixed(4)}`);
}

main().catch((error) => {
  console.error(error);
  process.exit(1);
});
