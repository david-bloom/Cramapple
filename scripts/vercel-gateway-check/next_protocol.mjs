import { streamObject } from 'ai';
import { createOpenAI } from '@ai-sdk/openai';
import { z } from 'zod';
import fs from 'node:fs';
import path from 'node:path';
import crypto from 'node:crypto';

const directOpenAI = process.env.OPENAI_API_KEY ? createOpenAI({ apiKey: process.env.OPENAI_API_KEY }) : null;

const ROOT = path.resolve(new URL('.', import.meta.url).pathname, '..', '..');
const LABELS_PATH = path.join(ROOT, 'docs', 'research', 'frq02_generated_answer_labels_codex_provisional.jsonl');
const DEFAULT_OUTPUT = '/private/tmp/cramapple-bio-ref-next/pilot_results_2026-06-18.jsonl';

const QUESTION_ID = 'SPIKE-FRQ-02';
const CRITERION_ID = 'FRQ02-C2';
const CRITERION_TEXT = 'Explains that the construction event is random/non-selective with respect to flower-color fitness.';

const PROMPT = `A population of wild wildflowers exhibits a single gene locus with two alleles (\`F\` and \`f\`) controlling flower color. A construction project randomly destroys 90% of the wildflower population. The remaining individual plants are left to randomly interbreed.

A. Identify the specific evolutionary mechanism responsible for the sudden alteration of allele frequencies in this small population.

B. Explain how the genetic diversity of this isolated population will compare to the original ancestral population over subsequent generations, assuming no mutation or gene flow occurs.`;

const BOUNDARY_TABLE = `FRQ02-C2 boundary table:

Earned:
- says the construction destruction/survival was random, by chance, a random sample, or unrelated to flower-color fitness;
- says alleles were lost by chance in the bottleneck;
- says the event was not natural selection or not based on plant fitness.

Not earned:
- only says the population got smaller or allele frequencies changed;
- only identifies bottleneck/genetic drift without explaining random or non-selective survival;
- says construction selected the stronger/fitter/better-adapted flowers;
- says natural selection caused the allele-frequency change;
- says random mating caused the change rather than random survival/destruction.`;

const Arms = {
  'BM-Control': {
    model: 'openai/gpt-5.5',
    reasoningEffort: 'medium',
    boundaryMemory: false,
    maxOutputTokens: 160,
  },
  'Boundary-Table': {
    model: 'openai/gpt-5.5',
    reasoningEffort: 'medium',
    boundaryMemory: true,
    maxOutputTokens: 160,
  },
  'Boundary-Table-Low': {
    model: 'openai/gpt-5.5',
    reasoningEffort: 'low',
    boundaryMemory: true,
    maxOutputTokens: 160,
  },
  'SP-FAST': {
    model: 'openai/gpt-4o-mini',
    boundaryMemory: true,
    maxOutputTokens: 80,
  },
  'SP-FAST-ESC': {
    model: 'openai/gpt-4o-mini',
    boundaryMemory: true,
    maxOutputTokens: 80,
  },
  'SP-FAST-Haiku': {
    model: 'anthropic/claude-haiku-4-5',
    boundaryMemory: true,
    maxOutputTokens: 80,
  },
  'SP-FAST-Gemini': {
    model: 'google/gemini-2.5-flash',
    boundaryMemory: true,
    maxOutputTokens: 80,
  },
};

const SCHEMA = z.object({
  status: z.enum(['earned', 'not_earned', 'unable_to_determine']),
  confidence: z.number().min(0).max(1),
  evidence_quote: z.string(),
  minimal_fix: z.string(),
  gate: z.enum(['pass', 'fail']),
});

function fail(message) {
  console.error(`error: ${message}`);
  process.exit(1);
}

function loadRows(filePath) {
  const rows = fs
    .readFileSync(filePath, 'utf8')
    .split('\n')
    .filter(Boolean)
    .map((line) => JSON.parse(line));
  for (const row of rows) {
    if (row.label_status !== 'learning_quality_approved' || row.use_as_ground_truth !== true) {
      fail(`row ${row.response_id} is not approved ground truth`);
    }
  }
  return rows;
}

function selectHardSet(rows, limit = 10) {
  const hardScore = (row) => {
    const tags = new Set(row.boundary_tags || []);
    const text = String(row.answer_text || '').toLowerCase();
    let score = 0;
    if (tags.has('identifies_genetic_drift')) score += 3;
    if (tags.has('identifies_bottleneck')) score += 2;
    if (tags.has('random_nonselective_event_explicit')) score += 3;
    if (tags.has('chance_sampling_or_allele_loss')) score += 2;
    if (tags.has('random_survivor_sample')) score += 2;
    if (tags.has('fitness_based_selection_language')) score += 3;
    if (tags.has('selection_mechanism_error')) score += 2;
    if (tags.has('random_mating_fallacy') || tags.has('random_mating_mechanism_error')) score += 2;
    if (text.includes('random') || text.includes('chance') || text.includes('nonselective') || text.includes('not based')) score += 1;
    return [-score, row.response_id];
  };

  const earned = rows.filter((row) => row.criterion_labels[CRITERION_ID] === 'earned');
  const notEarned = rows.filter((row) => row.criterion_labels[CRITERION_ID] === 'not_earned');
  const selectedEarned = [...earned].sort((a, b) => {
    const [sa, ia] = hardScore(a);
    const [sb, ib] = hardScore(b);
    return sa - sb || ia.localeCompare(ib);
  }).slice(0, Math.floor(limit / 2));
  const selectedNotEarned = [...notEarned].sort((a, b) => {
    const [sa, ia] = hardScore(a);
    const [sb, ib] = hardScore(b);
    return sa - sb || ia.localeCompare(ib);
  }).slice(0, Math.floor(limit / 2));
  return [...selectedEarned, ...selectedNotEarned].sort((a, b) => a.response_id.localeCompare(b.response_id));
}

function compact(text, maxChars = 260) {
  const oneLine = String(text).replace(/\s+/g, ' ').trim();
  return oneLine.length <= maxChars ? oneLine : `${oneLine.slice(0, maxChars - 3).trimEnd()}...`;
}

function buildInstructions(armName) {
  const arm = Arms[armName];
  const memory = arm.boundaryMemory
    ? `\nUse the boundary table to calibrate C2. Do not add criteria. Do not require exact wording.`
    : '';
  return `You are Cramapple's AP Biology FRQ grader for an internal boundary-memory diagnostic.
Grade only criterion ${CRITERION_ID}.
Criterion: ${CRITERION_TEXT}${memory}

Return only valid JSON with this shape:
{
  "status": "earned|not_earned|unable_to_determine",
  "confidence": 0,
  "evidence_quote": "verbatim phrase or empty string",
  "minimal_fix": "short repair move or empty string",
  "gate": "pass|fail"
}`;
}

function buildInput(row, armName) {
  const arm = Arms[armName];
  const context = arm.boundaryMemory ? `\n${BOUNDARY_TABLE}\n` : '';
  return `Question ID: ${QUESTION_ID}

Prompt:
${PROMPT}

Criterion to grade:
${CRITERION_ID}: ${CRITERION_TEXT}
${context}
Student response ID: ${row.response_id}
Student response:
${row.answer_text}`.trim();
}

function resolveModel(modelName) {
  if (process.env.AI_GATEWAY_API_KEY) return modelName;
  if (modelName.startsWith('openai/')) {
    if (!directOpenAI) fail('OPENAI_API_KEY is not set for direct OpenAI fallback');
    return directOpenAI(modelName.slice('openai/'.length));
  }
  return null;
}

function routingFor(modelName) {
  if (process.env.AI_GATEWAY_API_KEY) return 'vercel_ai_gateway';
  if (modelName.startsWith('openai/')) return 'direct_openai_fallback';
  return 'unavailable';
}

function promptHash(instructions, input) {
  const data = Buffer.from(`${instructions}\n\n${input}`, 'utf8');
  return crypto.createHash('sha256').update(data).digest('hex');
}

function extractOutputText(result) {
  if (typeof result.output_text === 'string') return result.output_text;
  const chunks = [];
  for (const item of result.output || []) {
    for (const content of item.content || []) {
      if (content.type === 'output_text' || content.type === 'text') {
        chunks.push(String(content.text || ''));
      }
    }
  }
  return chunks.join('\n').trim();
}

function usageCounts(result) {
  const usage = result || {};
  const inputDetails = usage.inputTokenDetails || usage.input_tokens_details || {};
  const outputDetails = usage.outputTokenDetails || usage.output_tokens_details || {};
  return {
    inputTokens: Number(usage.inputTokens ?? usage.input_tokens ?? 0),
    outputTokens: Number(usage.outputTokens ?? usage.output_tokens ?? 0),
    reasoningTokens: Number(
      outputDetails.reasoningTokens ??
      outputDetails.reasoning_tokens ??
      usage.reasoningTokens ??
      usage.reasoning_tokens ??
      0
    ),
    cachedTokens: Number(
      usage.cachedInputTokens ??
      usage.cached_input_tokens ??
      inputDetails.cachedInputTokens ??
      inputDetails.cached_tokens ??
      0
    ),
  };
}

function estimateCost(usage, modelName) {
  const pricing = modelName === 'openai/gpt-5.5'
    ? { input: 5.0, cached: 0.5, output: 30.0 }
    : modelName === 'openai/gpt-4o-mini'
      ? { input: 0.15, cached: 0.075, output: 0.6 }
      : modelName === 'anthropic/claude-haiku-4-5'
        ? { input: 0.8, cached: 0.08, output: 4.0 }
        : { input: 0.3, cached: 0.03, output: 2.5 };
  const uncached = Math.max(usage.inputTokens - usage.cachedTokens, 0);
  return ((uncached * pricing.input) + (usage.cachedTokens * pricing.cached) + (usage.outputTokens * pricing.output)) / 1_000_000;
}

async function runCall(modelName, instructions, input, reasoningEffort, maxOutputTokens = 200) {
  const model = resolveModel(modelName);
  if (!model) {
    return {
      final: null,
      usage: { inputTokens: 0, outputTokens: 0, reasoningTokens: 0, cachedTokens: 0 },
      costUsd: 0,
      ttfbMs: null,
      totalMs: 0,
      rawText: '',
      ok: false,
      error: `model ${modelName} unavailable without gateway auth`,
      skipped: true,
    };
  }
  const started = performance.now();
  let firstChunkAt = null;
  let buffer = '';
  const result = streamObject({
    model,
    schema: SCHEMA,
    prompt: `${instructions}\n\n${input}`,
    ...(reasoningEffort ? { providerOptions: { openai: { reasoningEffort } } } : {}),
    maxOutputTokens,
  });
  try {
    for await (const chunk of result.partialObjectStream) {
      if (firstChunkAt === null) firstChunkAt = performance.now();
      if (chunk && typeof chunk === 'object') {
        buffer = JSON.stringify(chunk);
      }
    }
    const end = performance.now();
    const final = await result.object;
    const usage = usageCounts(await result.usage);
    const costUsd = estimateCost(usage, modelName);
    return {
      final,
      usage,
      costUsd,
      ttfbMs: firstChunkAt ? firstChunkAt - started : null,
      totalMs: end - started,
      rawText: buffer,
      ok: true,
      error: '',
      skipped: false,
    };
  } catch (err) {
    const end = performance.now();
    return {
      final: null,
      usage: { inputTokens: 0, outputTokens: 0, reasoningTokens: 0, cachedTokens: 0 },
      costUsd: 0,
      ttfbMs: firstChunkAt ? firstChunkAt - started : null,
      totalMs: end - started,
      rawText: '',
      ok: false,
      error: err?.message ?? String(err),
      skipped: false,
    };
  }
}

function parseArgs(argv) {
  const out = { limit: 10, output: DEFAULT_OUTPUT, arms: Object.keys(Arms) };
  for (let i = 2; i < argv.length; i += 1) {
    const arg = argv[i];
    if (arg === '--limit') out.limit = Number(argv[++i]);
    else if (arg === '--output') out.output = argv[++i];
    else if (arg === '--arms') out.arms = argv[++i].split(',').map((s) => s.trim()).filter(Boolean);
    else if (arg === '--dry-run') out.dryRun = true;
    else fail(`unknown argument ${arg}`);
  }
  return out;
}

async function main() {
  const args = parseArgs(process.argv);
  const modelAuthPresent = Boolean(process.env.AI_GATEWAY_API_KEY || process.env.OPENAI_API_KEY);
  if (!modelAuthPresent && !args.dryRun) {
    fail('AI_GATEWAY_API_KEY or OPENAI_API_KEY is not set');
  }

  const rows = selectHardSet(loadRows(LABELS_PATH), args.limit);
  if (args.dryRun) {
    console.log(`Dry run OK. Answers: ${rows.length}. Planned calls: ${rows.length * args.arms.length}.`);
    console.log(`Arms: ${args.arms.join(', ')}`);
    console.log(`Response IDs: ${rows.map((row) => row.response_id).join(', ')}`);
    return;
  }

  fs.mkdirSync(path.dirname(args.output), { recursive: true });
  const done = new Set();
  if (fs.existsSync(args.output)) {
    for (const line of fs.readFileSync(args.output, 'utf8').split('\n').filter(Boolean)) {
      const row = JSON.parse(line);
      done.add(`${row.experiment_arm}:${row.response_id}`);
    }
  }

  const stream = fs.createWriteStream(args.output, { flags: 'a' });
  try {
    for (const row of rows) {
      for (const armName of args.arms) {
        if (!Arms[armName]) fail(`unknown arm ${armName}`);
        const key = `${armName}:${row.response_id}`;
        if (done.has(key)) continue;

        const arm = Arms[armName];
        if (!process.env.AI_GATEWAY_API_KEY && !arm.model.startsWith('openai/')) {
          console.log(`${armName} ${row.response_id}: skipped (gateway auth unavailable for ${arm.model})`);
          continue;
        }
        const instructions = buildInstructions(armName);
        const input = buildInput(row, armName);
        const first = await runCall(arm.model, instructions, input, arm.reasoningEffort, arm.maxOutputTokens);

        let final = first.final;
        let finalUsage = first.usage;
        let finalOk = first.ok;
        let finalCostUsd = first.costUsd;
        let escalationTriggered = false;
        let escalationReason = '';
        let totalMs = first.totalMs;
        let ttfbMs = first.ttfbMs;
        let rawText = first.rawText;
        let error = first.error;
        let skipped = first.skipped || false;

        if (armName === 'SP-FAST-ESC') {
          const parsed = final || {};
          const needsEscalation =
            !first.ok ||
            parsed.status === 'unable_to_determine' ||
            (typeof parsed.confidence === 'number' ? parsed.confidence < 0.7 : true) ||
            parsed.gate === 'fail';

          if (needsEscalation) {
            escalationTriggered = true;
            escalationReason = !first.ok ? 'primary_error' : parsed.gate === 'fail' ? 'gate_fail' : parsed.confidence < 0.7 ? 'low_confidence' : 'schema_or_status';
            const escInstructions = `${buildInstructions('Boundary-Table')}\n\nPrimary model response:\n${rawText || error}`;
            const escInput = buildInput(row, 'Boundary-Table');
            const escalated = await runCall('openai/gpt-5.5', escInstructions, escInput, 'medium', 200);
            final = escalated.final;
            finalUsage = {
              inputTokens: first.usage.inputTokens + escalated.usage.inputTokens,
              outputTokens: first.usage.outputTokens + escalated.usage.outputTokens,
              reasoningTokens: first.usage.reasoningTokens + escalated.usage.reasoningTokens,
              cachedTokens: first.usage.cachedTokens + escalated.usage.cachedTokens,
            };
            finalOk = first.ok && escalated.ok;
            finalCostUsd = first.costUsd + escalated.costUsd;
            totalMs += escalated.totalMs;
            if (ttfbMs === null && escalated.ttfbMs !== null) ttfbMs = escalated.ttfbMs;
            rawText = escalated.rawText || rawText;
            error = escalated.error || error;
          }
        }

        const parsed = final || {};
        const humanStatus = row.criterion_labels[CRITERION_ID];
        const modelStatus = parsed.status || 'unable_to_determine';
        const qualityFlags = [];
        if (humanStatus === 'earned' && modelStatus !== 'earned') qualityFlags.push(`under_credit:${CRITERION_ID}`);
        if (humanStatus !== 'earned' && modelStatus === 'earned') qualityFlags.push(`over_credit:${CRITERION_ID}`);

        const record = {
          experiment_arm: armName,
          model_id: armName === 'SP-FAST-ESC' && escalationTriggered ? 'openai/gpt-5.5' : arm.model,
          primary_model_id: arm.model,
          escalation_model_id: escalationTriggered ? 'openai/gpt-5.5' : '',
          routing: routingFor(arm.model),
          reasoning_effort: armName === 'SP-FAST-ESC' && escalationTriggered ? 'medium' : (arm.reasoningEffort || 'n/a'),
          prompt_version: `${armName}:draft-v1`,
          prompt_hash: promptHash(instructions, input),
          output_schema_version: 'bio-ref-next-protocol-v1',
          prompt_caching_status: 'unknown',
          cached_tokens: finalUsage.cachedTokens,
          question_id: QUESTION_ID,
          response_id: row.response_id,
          answer_text: row.answer_text,
          human_status: humanStatus,
          model_status: modelStatus,
          schema_valid: Boolean(parsed && typeof parsed === 'object' && typeof parsed.status === 'string' && typeof parsed.confidence === 'number'),
          timeout_or_retry: !finalOk,
          quality_flags: qualityFlags,
          input_tokens: finalUsage.inputTokens,
          output_tokens: finalUsage.outputTokens,
          reasoning_tokens: finalUsage.reasoningTokens,
          total_latency_ms: totalMs,
          provider_latency_ms: totalMs,
          ttfb_ms: ttfbMs,
          estimated_initial_grade_cost_usd: finalCostUsd,
          confidence: typeof parsed.confidence === 'number' ? parsed.confidence : 0,
          evidence_quote: parsed.evidence_quote || '',
          minimal_fix: parsed.minimal_fix || '',
          gate: parsed.gate || 'fail',
          escalation_triggered: escalationTriggered,
          escalation_reason: escalationReason,
          boundary_memory: arm.boundaryMemory,
          boundary_tags: row.boundary_tags || [],
          reviewer_note: row.reviewer_note || '',
          error: error || '',
          skipped,
        };

        stream.write(`${JSON.stringify(record)}\n`);
        done.add(key);
        console.log(
          `${armName} ${row.response_id}: schema=${record.schema_valid} ` +
          `status=${record.model_status} flags=${qualityFlags.length} ` +
          `cost=$${record.estimated_initial_grade_cost_usd.toFixed(5)} ` +
          `latency=${Math.round(totalMs)}ms`
        );
      }
    }
  } finally {
    stream.end();
  }

  console.log(`Wrote pilot JSONL: ${args.output}`);
}

await main();
