// FAR-reduction experiment 2: adversarial re-check pass, "earned" verdicts
// only. Takes the EXISTING gpt-5.2 baseline run's "earned" criteria for
// each pilot photo (no re-grading of everything -- only what was already
// credited) and asks a fresh call to specifically try to REFUTE each one,
// shown the same photo. This is the asymmetric-cost idea: only accepts
// verdicts get a second look, "not_earned" verdicts are left alone since
// they aren't the metric of concern (FAR = false accepts).
//
// Checkpointed, resumable.

import { streamObject } from 'ai';
import fs from 'node:fs';
import path from 'node:path';
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
const GPT52_RESULTS = path.join(OUT_DIR, 'runs', 'real_photo_benchmark_gpt52_results.jsonl');
const SUBSAMPLE_JSON = path.join(OUT_DIR, 'gold', 'far_experiment_subsample_2026_08_18.json');
const OUTPUT_JSONL = path.join(OUT_DIR, 'runs', 'adversarial_recheck_results.jsonl');

const MODEL = 'openai/gpt-5.2';
const MAX_OUTPUT_TOKENS = 500;

function loadGold() {
  const byItemId = new Map();
  for (const line of fs.readFileSync(GOLD_JSONL, 'utf8').split('\n').filter(Boolean)) {
    const record = JSON.parse(line);
    byItemId.set(record.item_id, record);
  }
  return byItemId;
}

function buildAdversarialPrompt(gold, earnedCriteria) {
  const criteriaText = earnedCriteria
    .map((c) => `- ${c.criterion_id}: "${c.met_rule}" (a previous pass judged this EARNED)`)
    .join('\n');
  return [
    `Item ID: ${gold.item_id}`,
    `Archetype: ${gold.archetype}`,
    'Prompt:',
    gold.student_prompt || gold.stem || '',
    '',
    'A prior grading pass judged the following criteria as EARNED. Your job is',
    'to adversarially re-examine ONLY these specific criteria against the',
    'photographed response -- actively look for any reason the credit is NOT',
    'justified (e.g. the drawn evidence is approximate, missing, ambiguous, or',
    'the prior pass over-credited). Do not re-grade criteria not listed below.',
    'Default to UPHOLD only when the evidence is clearly, unambiguously',
    'sufficient; if you have real doubt, do not uphold.',
    '',
    criteriaText,
    '',
    'For each criterion listed above, return whether the EARNED verdict should',
    'be upheld or overturned, with a short reason.',
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
      verdicts: z.array(z.object({
        criterion_id: z.string(),
        upheld: z.boolean(),
        reason: z.string(),
      })),
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

async function main() {
  loadEnvFile(path.join(ROOT, 'scripts', 'vercel-gateway-check', '.env.local'));
  if (!process.env.AI_GATEWAY_API_KEY && process.env.VERCEL_OIDC_TOKEN) process.env.AI_GATEWAY_API_KEY = process.env.VERCEL_OIDC_TOKEN;

  const gold = loadGold();
  const realGoldByFilePath = new Map(JSON.parse(fs.readFileSync(REAL_GOLD_JSON, 'utf8')).map((r) => [path.resolve(r.file_path), r]));
  let subsample = JSON.parse(fs.readFileSync(SUBSAMPLE_JSON, "utf8"));
  if (process.env.FAR_TEST_LIMIT) subsample = subsample.slice(0, Number(process.env.FAR_TEST_LIMIT));

  const baselineByKey = new Map();
  for (const line of fs.readFileSync(GPT52_RESULTS, 'utf8').trim().split('\n').filter(Boolean)) {
    const r = JSON.parse(line);
    baselineByKey.set(`${r.item_id} ${path.resolve(path.join(SAMPLES_ROOT, r.file_name))}`, r);
  }

  fs.mkdirSync(path.dirname(OUTPUT_JSONL), { recursive: true });
  const done = new Set();
  if (fs.existsSync(OUTPUT_JSONL)) {
    for (const line of fs.readFileSync(OUTPUT_JSONL, 'utf8').trim().split('\n').filter(Boolean)) {
      done.add(JSON.parse(line).item_id + ' ' + JSON.parse(line).file_name);
    }
  }

  const output = fs.createWriteStream(OUTPUT_JSONL, { flags: 'a' });
  let completed = 0;
  let skippedNoEarned = 0;

  for (const photo of subsample) {
    const fileName = path.relative(SAMPLES_ROOT, photo.file_path);
    const key = `${photo.item_id} ${fileName}`;
    if (done.has(key)) continue;

    const baselineRow = baselineByKey.get(`${photo.item_id} ${path.resolve(photo.file_path)}`);
    const record = gold.get(photo.item_id);
    const earnedCriteria = record.criterion_definitions.filter((c) => baselineRow.criterion_statuses[c.criterion_id] === 'earned');

    if (earnedCriteria.length === 0) {
      skippedNoEarned += 1;
      output.write(`${JSON.stringify({ item_id: photo.item_id, file_name: fileName, archetype: photo.archetype, no_earned_criteria: true })}\n`);
      continue;
    }

    const prompt = buildAdversarialPrompt(record, earnedCriteria);
    const imageBuffer = fs.readFileSync(photo.file_path);
    const result = await runCall(prompt, imageBuffer);

    const verdictsByCriterion = {};
    for (const v of result.final?.verdicts || []) verdictsByCriterion[v.criterion_id] = { upheld: v.upheld, reason: v.reason };

    const goldRow = realGoldByFilePath.get(path.resolve(photo.file_path));
    const rec = {
      item_id: photo.item_id, file_name: fileName, archetype: photo.archetype,
      ok: result.ok, error: result.error || '', cost_usd: result.costUsd, latency_ms: result.latencyMs,
      earned_criteria_checked: earnedCriteria.map((c) => c.criterion_id),
      verdicts: verdictsByCriterion,
      gold_criterion_statuses: goldRow.criterion_statuses,
      baseline_criterion_statuses: baselineRow.criterion_statuses,
    };
    output.write(`${JSON.stringify(rec)}\n`);
    completed += 1;
    process.stdout.write(`[${completed}] ${photo.item_id} ${result.ok ? 'ok' : 'ERR'} checked=${earnedCriteria.length} $${result.costUsd.toFixed(4)}\n`);
  }
  output.end();
  await new Promise((resolve) => output.on('finish', resolve));
  console.log(`wrote ${OUTPUT_JSONL} (${skippedNoEarned} photos had no earned criteria to check)`);
}

main().catch((e) => { console.error(e); process.exit(1); });
