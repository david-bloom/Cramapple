import { streamObject } from 'ai';
import { createOpenAI } from '@ai-sdk/openai';
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
loadEnvFile(path.join(ROOT, 'scripts', 'vercel-gateway-check', '.env.local'));

const directOpenAI = process.env.OPENAI_API_KEY ? createOpenAI({ apiKey: process.env.OPENAI_API_KEY }) : null;

const DEFAULT_PACKET = '/private/tmp/cramapple-bio-ref-nuanced/apbio_nuanced_packet.md';
const DEFAULT_CANONICALS = '/private/tmp/cramapple-bio-ref-nuanced/apbio_nuanced_canonicals.json';
const DEFAULT_OUTPUT = '/private/tmp/cramapple-bio-ref-nuanced/apbio_primary_fallback_results.jsonl';
const DEFAULT_REPORT = path.join(ROOT, 'docs', 'research', 'apbio_primary_fallback_report.md');

const PRIMARY_MODEL = 'openai/gpt-4o-mini';
const FALLBACK_MODEL = 'openai/gpt-5.5';
const DEFAULT_THRESHOLD = 0.90;

function fail(message) {
  console.error(`error: ${message}`);
  process.exit(1);
}

function parseTableRows(block) {
  const rows = [];
  for (const line of block.split('\n')) {
    const stripped = line.trim();
    if (!stripped.startsWith('|') || stripped.includes('---')) continue;
    rows.push(stripped.slice(1, -1).split('|').map((cell) => cell.trim().replace(/^`|`$/g, '')));
  }
  return rows;
}

function sectionBetween(text, start, endPattern) {
  const startIndex = text.indexOf(start);
  if (startIndex === -1) return '';
  const body = text.slice(startIndex + start.length);
  const match = body.match(endPattern);
  const endIndex = match ? startIndex + start.length + match.index : text.length;
  return text.slice(startIndex + start.length, endIndex).trim();
}

function parsePacket(filePath) {
  const text = fs.readFileSync(filePath, 'utf8');
  const matches = [...text.matchAll(/^## \d+\.\s+(SPIKE-FRQ-\d+)\s+-\s+(.+)$/gm)];
  const frqs = [];
  for (let i = 0; i < matches.length; i += 1) {
    const questionId = matches[i][1];
    const title = matches[i][2].trim();
    const start = matches[i].index;
    const end = i + 1 < matches.length ? matches[i + 1].index : text.length;
    const block = text.slice(start, end);
    const prompt = sectionBetween(block, '### Prompt', /^### Draft Rubric Criteria/m);
    const rubricBlock = sectionBetween(block, '### Draft Rubric Criteria', /^### Response Set/m);
    const criteria = [];
    for (const row of parseTableRows(rubricBlock)) {
      if (row[0]?.startsWith('FRQ')) {
        criteria.push({
          criterion_id: row[0],
          text: row[1] || '',
        });
      }
    }
    const labelBlock = sectionBetween(block, '### Confirmed Label Matrix', /^##|\Z/m);
    const labels = {};
    for (const row of parseTableRows(labelBlock)) {
      if (row[0]?.startsWith('FRQ')) {
        labels[row[0]] = {};
        criteria.forEach((criterion, index) => {
          if (row[index + 1]) labels[row[0]][criterion.criterion_id] = row[index + 1];
        });
      }
    }
    const responses = [...block.matchAll(/^#### (FRQ\d+-R\d+)\n([\s\S]*?)```text\n([\s\S]*?)\n```/gm)].map((m) => {
      const metaBlock = m[2];
      const difficultyMatch = metaBlock.match(/difficulty:\s*(clear|ambiguous|hard|borderline)/i);
      return {
        response_id: m[1],
        difficulty: difficultyMatch ? difficultyMatch[1].toLowerCase() : 'unknown',
        text: m[3].trim(),
        labels: labels[m[1]] || {},
      };
    });
    frqs.push({ questionId, title, prompt, criteria, responses });
  }
  return frqs;
}

function loadCanonicals(filePath) {
  return JSON.parse(fs.readFileSync(filePath, 'utf8'));
}

function canonicalKey(questionId) {
  const m = questionId.match(/SPIKE-FRQ-(\d+)$/);
  return m ? `APBIO-FRQ-S-${String(Number(m[1])).padStart(3, '0')}` : questionId;
}

function buildSchema(criteria) {
  const statusEnum = z.enum(['earned', 'not_earned', 'unable_to_determine']);
  const statuses = {};
  for (const criterion of criteria) statuses[criterion.criterion_id] = statusEnum;
  return z.object({
    status: statusEnum,
    confidence: z.number().min(0).max(1),
    evidence_quote: z.string(),
    minimal_fix: z.string(),
    gate: z.enum(['pass', 'fail']),
    criterion_statuses: z.object(statuses),
  });
}

function buildInstructions() {
  return `You are Cramapple's AP Biology FRQ grader for an internal fallback diagnostic.
Grade only the rubric criteria shown below.
Use the canonical answers only as boundary memory, not extra rubric.
Do not broaden the rubric or copy the canonical answers blindly.

Return only valid JSON with this shape:
{
  "status": "earned|not_earned|unable_to_determine",
  "confidence": number from 0 to 1,
  "evidence_quote": "verbatim phrase or empty string",
  "minimal_fix": "short repair move or empty string",
  "gate": "pass|fail",
  "criterion_statuses": {"CRITERION_ID": "earned|not_earned|unable_to_determine"}
}`.trim();
}

function buildInput(frq, response, canonicals) {
  const canonical = canonicals[canonicalKey(frq.questionId)] || {};
  const rubric = frq.criteria.map((c) => `- ${c.criterion_id}: ${c.text}`).join('\n');
  const difficulty = response.difficulty === 'unknown' ? '' : `\nDifficulty tag: ${response.difficulty}`;
  return `Question ID: ${frq.questionId}
Question title: ${frq.title}

Prompt:
${frq.prompt}

Rubric criteria:
${rubric}

Canonical answers:
- canonical_answer_1: ${canonical.canonical_answer_1 || ''}
- canonical_answer_2: ${canonical.canonical_answer_2 || ''}${difficulty}

Student response ID: ${response.response_id}
Student response:
${response.text}`.trim();
}

function promptHash(instructions, input) {
  return crypto.createHash('sha256').update(`${instructions}\n\n${input}`).digest('hex');
}

function usageCounts(result) {
  const usage = result || {};
  const inputDetails = usage.inputTokenDetails || usage.input_tokens_details || {};
  const outputDetails = usage.outputTokenDetails || usage.output_tokens_details || {};
  return {
    inputTokens: Number(usage.inputTokens ?? usage.input_tokens ?? 0),
    outputTokens: Number(usage.outputTokens ?? usage.output_tokens ?? 0),
    reasoningTokens: Number(outputDetails.reasoningTokens ?? outputDetails.reasoning_tokens ?? usage.reasoningTokens ?? usage.reasoning_tokens ?? 0),
    cachedTokens: Number(usage.cachedInputTokens ?? usage.cached_input_tokens ?? inputDetails.cachedInputTokens ?? inputDetails.cached_tokens ?? 0),
  };
}

function estimateCost(usage, model) {
  const pricing = model === PRIMARY_MODEL
    ? { input: 0.15, cached: 0.075, output: 0.6 }
    : { input: 5.0, cached: 0.5, output: 30.0 };
  const uncached = Math.max(usage.inputTokens - usage.cachedTokens, 0);
  return ((uncached * pricing.input) + (usage.cachedTokens * pricing.cached) + (usage.outputTokens * pricing.output)) / 1_000_000;
}

async function runCall(modelName, instructions, input, schema, reasoningEffort = null, maxOutputTokens = 180) {
  const started = performance.now();
  let firstChunkAt = null;
  const model = process.env.AI_GATEWAY_API_KEY || process.env.VERCEL_OIDC_TOKEN
    ? modelName
    : (modelName.startsWith('openai/') ? directOpenAI?.(modelName.slice('openai/'.length)) : null);
  if (!model) {
    return { ok: false, schemaValid: false, error: `model ${modelName} unavailable`, final: null, usage: { inputTokens: 0, outputTokens: 0, reasoningTokens: 0, cachedTokens: 0 }, totalMs: 0 };
  }
  const providerOptions = reasoningEffort ? { openai: { reasoningEffort } } : undefined;
  const result = streamObject({
    model,
    schema,
    prompt: `${instructions}\n\n${input}`,
    ...(providerOptions ? { providerOptions } : {}),
    maxOutputTokens,
  });
  try {
    for await (const _chunk of result.partialObjectStream) {
      if (firstChunkAt === null) firstChunkAt = performance.now();
    }
    const final = await result.object;
    const usage = usageCounts(await result.usage);
    return {
      ok: true,
      schemaValid: Boolean(final && typeof final === 'object'),
      final,
      usage,
      error: '',
      totalMs: performance.now() - started,
    };
  } catch (err) {
    return {
      ok: false,
      schemaValid: false,
      final: null,
      usage: { inputTokens: 0, outputTokens: 0, reasoningTokens: 0, cachedTokens: 0 },
      error: err?.message ?? String(err),
      totalMs: performance.now() - started,
    };
  }
}

function accuracyForRecord(record) {
  let correct = 0;
  let total = 0;
  for (const [criterionId, human] of Object.entries(record.labels || {})) {
    total += 1;
    if (record.criterion_statuses?.[criterionId] === human) correct += 1;
  }
  return { correct, total };
}

async function main() {
  const args = process.argv.slice(2);
  const packetPath = args[args.indexOf('--packet') + 1] || DEFAULT_PACKET;
  const canonicalsPath = args[args.indexOf('--canonicals') + 1] || DEFAULT_CANONICALS;
  const outputPath = args[args.indexOf('--output') + 1] || DEFAULT_OUTPUT;
  const reportPath = args[args.indexOf('--report') + 1] || DEFAULT_REPORT;
  const mode = args[args.indexOf('--mode') + 1] || 'primary_then_fallback';
  const threshold = Number(args[args.indexOf('--threshold') + 1] || DEFAULT_THRESHOLD);

  const packet = parsePacket(packetPath);
  const canonicals = loadCanonicals(canonicalsPath);
  const rows = packet.flatMap((frq) => frq.responses.map((response) => ({ frq, response })));
  const schemaByFrq = new Map(packet.map((frq) => [frq.questionId, buildSchema(frq.criteria)]));
  const instructions = buildInstructions();

  if (!process.env.AI_GATEWAY_API_KEY && !process.env.VERCEL_OIDC_TOKEN && !process.env.OPENAI_API_KEY) {
    fail('AI_GATEWAY_API_KEY, VERCEL_OIDC_TOKEN, or OPENAI_API_KEY is required');
  }

  fs.mkdirSync(path.dirname(outputPath), { recursive: true });
  const handle = fs.createWriteStream(outputPath, { flags: 'w' });
  const records = [];

  for (const { frq, response } of rows) {
    const input = buildInput(frq, response, canonicals);
    const schema = schemaByFrq.get(frq.questionId);
    const base = {
      question_id: frq.questionId,
      response_id: response.response_id,
      difficulty: response.difficulty,
      labels: response.labels || {},
      prompt_hash: promptHash(instructions, input),
    };

    let finalResult = null;
    let primaryCall = null;
    let fallbackCall = null;
    let fallbackTriggered = false;
    let modelUsed = mode === 'fallback_only' ? FALLBACK_MODEL : PRIMARY_MODEL;

    if (mode !== 'fallback_only') {
      primaryCall = await runCall(PRIMARY_MODEL, instructions, input, schema, null, 180);
      finalResult = primaryCall;
      modelUsed = PRIMARY_MODEL;
      if (mode === 'primary_then_fallback') {
        const confidence = Number(primaryCall.final?.confidence ?? 0);
        const gateFail = primaryCall.final?.gate === 'fail';
        const schemaFail = !primaryCall.schemaValid || !primaryCall.ok;
        if (schemaFail || gateFail || confidence < threshold) {
          fallbackTriggered = true;
          fallbackCall = await runCall(FALLBACK_MODEL, instructions, input, schema, 'medium', 220);
          finalResult = fallbackCall;
          modelUsed = FALLBACK_MODEL;
        }
      }
    } else {
      fallbackCall = await runCall(FALLBACK_MODEL, instructions, input, schema, 'medium', 220);
      finalResult = fallbackCall;
      modelUsed = FALLBACK_MODEL;
    }

    const usage = {
      inputTokens: (primaryCall?.usage.inputTokens || 0) + (fallbackCall?.usage.inputTokens || 0),
      outputTokens: (primaryCall?.usage.outputTokens || 0) + (fallbackCall?.usage.outputTokens || 0),
      reasoningTokens: (primaryCall?.usage.reasoningTokens || 0) + (fallbackCall?.usage.reasoningTokens || 0),
      cachedTokens: (primaryCall?.usage.cachedTokens || 0) + (fallbackCall?.usage.cachedTokens || 0),
    };
    const costUsd = (primaryCall ? estimateCost(primaryCall.usage, PRIMARY_MODEL) : 0) + (fallbackCall ? estimateCost(fallbackCall.usage, FALLBACK_MODEL) : 0);
    const final = finalResult?.final || null;
    const record = {
      mode,
      threshold,
      primary_model: PRIMARY_MODEL,
      fallback_model: FALLBACK_MODEL,
      model_id_used: modelUsed,
      fallback_triggered: fallbackTriggered,
      question_id: base.question_id,
      response_id: base.response_id,
      difficulty: base.difficulty,
      prompt_hash: base.prompt_hash,
      labels: base.labels,
      primary_ok: primaryCall?.ok ?? false,
      primary_schema_valid: primaryCall?.schemaValid ?? false,
      primary_confidence: Number(primaryCall?.final?.confidence ?? 0),
      primary_gate: primaryCall?.final?.gate ?? '',
      primary_status: primaryCall?.final?.status ?? '',
      primary_criterion_statuses: primaryCall?.final?.criterion_statuses ?? {},
      fallback_ok: fallbackCall?.ok ?? false,
      fallback_schema_valid: fallbackCall?.schemaValid ?? false,
      fallback_confidence: Number(fallbackCall?.final?.confidence ?? 0),
      fallback_gate: fallbackCall?.final?.gate ?? '',
      fallback_status: fallbackCall?.final?.status ?? '',
      fallback_criterion_statuses: fallbackCall?.final?.criterion_statuses ?? {},
      final_ok: finalResult?.ok ?? false,
      final_schema_valid: finalResult?.schemaValid ?? false,
      final_confidence: Number(final?.confidence ?? 0),
      final_gate: final?.gate ?? '',
      final_status: final?.status ?? '',
      criterion_statuses: final?.criterion_statuses ?? {},
      evidence_quote: final?.evidence_quote ?? '',
      minimal_fix: final?.minimal_fix ?? '',
      total_latency_ms: (primaryCall?.totalMs || 0) + (fallbackCall?.totalMs || 0),
      estimated_cost_usd: costUsd,
      usage,
      timeout_or_retry: false,
    };
    const accuracy = accuracyForRecord(record);
    record.criterion_correct = accuracy.correct;
    record.criterion_total = accuracy.total;
    record.criterion_accuracy = accuracy.total ? accuracy.correct / accuracy.total : 0;
    handle.write(`${JSON.stringify(record)}\n`);
    records.push(record);
    console.log(`${mode} ${response.response_id}: used=${modelUsed} fallback=${fallbackTriggered} acc=${record.criterion_accuracy.toFixed(2)} conf=${record.final_confidence.toFixed(2)} cost=$${record.estimated_cost_usd.toFixed(5)} latency=${Math.round(record.total_latency_ms)}ms`);
  }
  handle.end();

  const summary = {};
  for (const modeName of [...new Set(records.map((r) => r.mode))]) {
    const rowsByMode = records.filter((r) => r.mode === modeName);
    let correct = 0;
    let total = 0;
    let escalated = 0;
    let fixed = 0;
    let newErrors = 0;
    const lats = rowsByMode.map((r) => r.total_latency_ms).sort((a, b) => a - b);
    const p = (q) => lats[Math.floor((lats.length - 1) * q)];
    for (const row of rowsByMode) {
      const finalAcc = accuracyForRecord({ labels: row.labels, criterion_statuses: row.criterion_statuses });
      const primaryAcc = accuracyForRecord({ labels: row.labels, criterion_statuses: row.primary_criterion_statuses });
      correct += finalAcc.correct;
      total += finalAcc.total;
      if (row.fallback_triggered) escalated += 1;
      if (finalAcc.correct > primaryAcc.correct) fixed += 1;
      if (finalAcc.correct < primaryAcc.correct) newErrors += 1;
    }
    summary[modeName] = {
      calls: rowsByMode.length,
      criterion_accuracy: total ? correct / total : 0,
      fallback_rate: rowsByMode.length ? escalated / rowsByMode.length : 0,
      fixed_rows: fixed,
      new_error_rows: newErrors,
      p50_latency_ms: p(0.5),
      p95_latency_ms: p(0.95),
      avg_cost: rowsByMode.reduce((s, r) => s + r.estimated_cost_usd, 0) / rowsByMode.length,
      criterion_correct: correct,
      criterion_total: total,
    };
  }

  const lines = [
    '# AP Biology Primary/Fallback Diagnostic',
    '',
    '**Status:** Generated aggregate report',
    '',
    `**Raw JSONL:** \`${outputPath}\``,
    '',
    `Primary model: \`${PRIMARY_MODEL}\``,
    `Fallback model: \`${FALLBACK_MODEL}\``,
    `Escalation threshold: \`${threshold}\``,
    '',
    '| Mode | Calls | Criterion accuracy | Fallback rate | p50 latency ms | p95 latency ms | Avg cost | Criterion correct / total |',
    '| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |',
  ];
  for (const modeName of Object.keys(summary)) {
    const s = summary[modeName];
    lines.push(`| ${modeName} | ${s.calls} | ${s.criterion_accuracy.toFixed(4)} | ${s.fallback_rate.toFixed(4)} | ${s.p50_latency_ms.toFixed(1)} | ${s.p95_latency_ms.toFixed(1)} | ${s.avg_cost.toFixed(6)} | ${s.criterion_correct} / ${s.criterion_total} |`);
  }
  fs.writeFileSync(reportPath, `${lines.join('\n')}\n`, 'utf8');
  console.log(`Wrote JSONL results: ${outputPath}`);
  console.log(`Wrote report: ${reportPath}`);
}

await main();
