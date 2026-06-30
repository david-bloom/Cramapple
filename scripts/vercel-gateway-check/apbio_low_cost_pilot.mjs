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

loadEnvFile(path.join(path.resolve(new URL('.', import.meta.url).pathname, '..', '..'), 'scripts', 'vercel-gateway-check', '.env.local'));

if (!process.env.AI_GATEWAY_API_KEY && process.env.VERCEL_OIDC_TOKEN) {
  process.env.AI_GATEWAY_API_KEY = process.env.VERCEL_OIDC_TOKEN;
}

const ROOT = path.resolve(new URL('.', import.meta.url).pathname, '..', '..');
const PACKET = path.join(ROOT, 'docs', 'research', 'bio_reference_layer_spike_input_packet.md');
const CANONICALS = '/private/tmp/apbio_short_frq_canonical_pairs.json';
const OUTPUT = '/private/tmp/cramapple-bio-ref-next/apbio_low_cost_pilot_results.jsonl';

const MODELS = [
  'deepseek/deepseek-v4-flash',
  'alibaba/qwen3.5-flash',
];

const DEFAULT_REPORT = path.join(ROOT, 'docs', 'research', 'apbio_low_cost_pilot_report.md');

function fail(message) {
  console.error(`error: ${message}`);
  process.exit(1);
}

function parseTableRows(block) {
  const rows = [];
  for (const line of block.split('\n')) {
    const stripped = line.trim();
    if (!stripped.startsWith('|') || stripped.includes('---')) continue;
    const cells = stripped.slice(1, -1).split('|').map((c) => c.trim().replace(/^`|`$/g, ''));
    if (cells.length) rows.push(cells);
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
          minimum_fix: row[2] || '',
          evidence_requirements: row[4] || '',
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
    const responses = [];
    const responseRegex = /^#### (FRQ\d+-R\d+)\n+(?:difficulty:\s*([^\n]+)\n+)?```text\n([\s\S]*?)\n```/gm;
    for (const m of block.matchAll(responseRegex)) {
      responses.push({
        response_id: m[1],
        difficulty: (m[2] || '').trim(),
        text: m[3].trim(),
        labels: labels[m[1]] || {},
      });
    }
    frqs.push({ questionId, title, prompt, criteria, responses });
  }
  return frqs;
}

function loadCanonicals(filePath) {
  const rows = JSON.parse(fs.readFileSync(filePath, 'utf8'));
  const out = {};
  for (const row of rows) {
    out[row.content_key] = {
      a1: row.canonical_answer_1 || '',
      a2: row.canonical_answer_2 || '',
    };
  }
  return out;
}

function canonicalKey(questionId) {
  const m = questionId.match(/SPIKE-FRQ-(\d+)$/);
  return m ? `APBIO-FRQ-S-${String(Number(m[1])).padStart(3, '0')}` : questionId;
}

function buildInstructions(model) {
  return `You are Cramapple's AP Biology FRQ grader for a low-cost provider pilot.
Grade only against the rubric criteria shown below.
The canonical answers are boundary memory only, not extra rubric.
Do not broaden the rubric or copy the canonical answers blindly.

Model under test: ${model}

Return only valid JSON with this shape:
{
  "points_earned": number,
  "criterion_statuses": {"CRITERION_ID": "earned|not_earned|unable_to_determine"},
  "highest_value_gap": "short string",
  "minimum_fix_length": "short string",
  "confidence": "high|medium|low",
  "uncertainty_reason": "short string or empty",
  "student_feedback": "string",
  "reviewer_rationale": "string"
}`.trim();
}

function buildSchema(criteria) {
  const statusEnum = z.enum(['earned', 'not_earned', 'unable_to_determine']);
  const statusShape = {};
  for (const criterion of criteria) {
    statusShape[criterion.criterion_id] = statusEnum;
  }
  return z.object({
    points_earned: z.number(),
    criterion_statuses: z.object(statusShape),
    highest_value_gap: z.string(),
    minimum_fix_length: z.string(),
    confidence: z.enum(['high', 'medium', 'low']),
    uncertainty_reason: z.string(),
    student_feedback: z.string(),
    reviewer_rationale: z.string(),
  });
}

function buildInput(frq, response, canonicals, model) {
  const canonical = canonicals[canonicalKey(frq.questionId)] || {};
  const rubric = frq.criteria.map((c) => `- ${c.criterion_id}: ${c.text}`).join('\n');
  const canonicalBlock = `Canonical answers provided for this arm:
- canonical_answer_1: ${canonical.a1}
- canonical_answer_2: ${canonical.a2}`;
  const prompt = `Question ID: ${frq.questionId}
Question title: ${frq.title}

Prompt:
${frq.prompt}

Rubric criteria:
${rubric}

${canonicalBlock}

Student response ID: ${response.response_id}
Student response:
${response.text}`.trim();
  return { prompt, referenceTokens: canonicalBlock.split(/\s+/).filter(Boolean).length };
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
    cachedTokens: Number(usage.cachedInputTokens ?? usage.cached_input_tokens ?? inputDetails.cachedTokens ?? inputDetails.cached_tokens ?? 0),
  };
}

function estimateCost(usage, model) {
  const pricing = model.startsWith('deepseek/')
    ? { input: 0.14, cached: 0.0028, output: 0.28 }
    : { input: 0.10, cached: 0.01, output: 0.40 };
  const uncached = Math.max(usage.inputTokens - usage.cachedTokens, 0);
  return ((uncached * pricing.input) + (usage.cachedTokens * pricing.cached) + (usage.outputTokens * pricing.output)) / 1_000_000;
}

async function runCall(model, instructions, input, schema) {
  const started = performance.now();
  let firstChunkAt = null;
  const result = streamObject({
    model,
    schema,
    prompt: `${instructions}\n\n${input}`,
  });
  try {
    for await (const chunk of result.partialObjectStream) {
      if (firstChunkAt === null) firstChunkAt = performance.now();
      void chunk;
    }
    const end = performance.now();
    const final = await result.object;
    const usage = usageCounts(await result.usage);
    return {
      ok: true,
      final,
      usage,
      ttfbMs: firstChunkAt ? firstChunkAt - started : null,
      totalMs: end - started,
      error: '',
    };
  } catch (err) {
    const end = performance.now();
    return {
      ok: false,
      final: null,
      usage: { inputTokens: 0, outputTokens: 0, reasoningTokens: 0, cachedTokens: 0 },
      ttfbMs: firstChunkAt ? firstChunkAt - started : null,
      totalMs: end - started,
      error: err?.message ?? String(err),
    };
  }
}

function qualityFlags(modelStatuses, labels) {
  const flags = [];
  for (const [criterionId, human] of Object.entries(labels)) {
    const model = modelStatuses?.[criterionId];
    if (human === 'earned' && model !== 'earned') flags.push(`under_credit:${criterionId}`);
    if (human !== 'earned' && model === 'earned') flags.push(`over_credit:${criterionId}`);
  }
  return flags;
}

function aggregate(records) {
  const byArm = {};
  for (const record of records) {
    (byArm[record.experiment_arm] ||= []).push(record);
  }
  const summary = {};
  for (const [arm, rows] of Object.entries(byArm)) {
    const metric = (f) => rows.reduce((sum, r) => sum + (r[f] || 0), 0) / rows.length;
    const latencies = rows.map((r) => r.total_latency_ms).sort((a, b) => a - b);
    const p50 = latencies[Math.floor((latencies.length - 1) * 0.5)];
    const p95 = latencies[Math.floor((latencies.length - 1) * 0.95)];
    let correct = 0;
    let total = 0;
    let flags = 0;
    for (const row of rows) {
      for (const [criterionId, human] of Object.entries(row.labels || {})) {
        total += 1;
        if (row.criterion_statuses?.[criterionId] === human) correct += 1;
      }
      flags += (row.quality_flags || []).length;
    }
    summary[arm] = {
      count: rows.length,
      criterion_accuracy: total ? correct / total : 0,
      strict_success_rate: rows.filter((r) => r.schema_valid && !r.timeout_or_retry && !(r.quality_flags || []).length).length / rows.length,
      p50_latency_ms: p50,
      p95_latency_ms: p95,
      avg_cost: metric('estimated_initial_grade_cost_usd'),
      avg_input_tokens: metric('input_tokens'),
      avg_output_tokens: metric('output_tokens'),
      avg_reference_tokens: metric('reference_tokens'),
      avg_cached_tokens: metric('cached_tokens'),
      criterion_correct: correct,
      criterion_total: total,
      quality_flags_per_call: flags / rows.length,
      under_credit: rows.reduce((sum, r) => sum + (r.quality_flags || []).filter((x) => x.startsWith('under_credit')).length, 0),
      over_credit: rows.reduce((sum, r) => sum + (r.quality_flags || []).filter((x) => x.startsWith('over_credit')).length, 0),
    };
  }
  return summary;
}

function fmt(n) {
  if (n == null) return 'n/a';
  return typeof n === 'number' ? n.toFixed(4) : String(n);
}

function writeReport(reportPath, summary, outputPath) {
  const lines = [
    '# AP Biology Low-Cost Provider Pilot',
    '',
    '**Status:** Generated aggregate report',
    '',
    `**Raw JSONL:** \`${outputPath}\``,
    '',
    'This pilot compares low-cost gateway models on the AP Biology short-FRQ held-out set using the 2-canonical-answer prompt configuration.',
    '',
    '| Arm | Calls | Criterion accuracy | Strict success rate | p50 latency ms | p95 latency ms | Avg cost | Avg input tokens | Avg output tokens | Avg reference tokens | Avg cached tokens |',
    '| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |',
  ];
  for (const arm of MODELS) {
    const data = summary[arm] || {};
    lines.push(`| ${arm} | ${fmt(data.count)} | ${fmt(data.criterion_accuracy)} | ${fmt(data.strict_success_rate)} | ${fmt(data.p50_latency_ms)} | ${fmt(data.p95_latency_ms)} | ${fmt(data.avg_cost)} | ${fmt(data.avg_input_tokens)} | ${fmt(data.avg_output_tokens)} | ${fmt(data.avg_reference_tokens)} | ${fmt(data.avg_cached_tokens)} |`);
  }
  lines.push('', '## Criterion-Level Comparison', '', '| Arm | Correct / Total | Over-credit | Under-credit | Quality flags / call |', '| --- | ---: | ---: | ---: | ---: |');
  for (const arm of MODELS) {
    const data = summary[arm] || {};
    lines.push(`| ${arm} | ${fmt(data.criterion_correct)} / ${fmt(data.criterion_total)} | ${fmt(data.over_credit)} | ${fmt(data.under_credit)} | ${fmt(data.quality_flags_per_call)} |`);
  }
  fs.mkdirSync(path.dirname(reportPath), { recursive: true });
  fs.writeFileSync(reportPath, `${lines.join('\n')}\n`, 'utf8');
}

async function main() {
  const args = process.argv.slice(2);
  const dryRun = args.includes('--dry-run');
  const modelsIndex = args.indexOf('--models');
  const packetIndex = args.indexOf('--packet');
  const canonicalsIndex = args.indexOf('--canonicals');
  const outputIndex = args.indexOf('--output');
  const reportIndex = args.indexOf('--report');
  const models = modelsIndex >= 0
    ? args[modelsIndex + 1].split(',').map((s) => s.trim()).filter(Boolean)
    : MODELS;
  const packetPath = packetIndex >= 0 ? args[packetIndex + 1] : PACKET;
  const canonicalsPath = canonicalsIndex >= 0 ? args[canonicalsIndex + 1] : CANONICALS;
  const outputPath = outputIndex >= 0 ? args[outputIndex + 1] : OUTPUT;
  const reportPath = reportIndex >= 0 ? args[reportIndex + 1] : DEFAULT_REPORT;
  const packet = parsePacket(packetPath);
  const canonicals = loadCanonicals(canonicalsPath);
  const rows = packet.flatMap((frq) => frq.responses.map((response) => ({ frq, response })));

  if (dryRun) {
    console.log(`Dry run OK. Planned calls: ${rows.length * models.length}`);
    console.log(`Models: ${models.join(', ')}`);
    return;
  }

  if (!process.env.AI_GATEWAY_API_KEY) {
    fail('AI_GATEWAY_API_KEY or VERCEL_OIDC_TOKEN is required');
  }

  fs.mkdirSync(path.dirname(outputPath), { recursive: true });
  const records = [];
  const handle = fs.createWriteStream(outputPath, { flags: 'w' });

  try {
    for (const { frq, response } of rows) {
      for (const model of models) {
        const instructions = buildInstructions(model);
        const schema = buildSchema(frq.criteria);
        const { prompt: input, referenceTokens } = buildInput(frq, response, canonicals, model);
        const call = await runCall(model, instructions, input, schema);
        const labels = response.labels || {};
        const criterion_statuses = call.final?.criterion_statuses || {};
        const record = {
          experiment_arm: model,
          model_id: model,
          reasoning_effort: 'n/a',
          prompt_version: `apbio-low-cost-pilot:${model}`,
          prompt_hash: promptHash(instructions, input),
          output_schema_version: 'apbio-low-cost-pilot-v1',
          prompt_caching_status: 'unknown',
          cached_tokens: call.usage.cachedTokens,
          question_id: frq.questionId,
          response_id: response.response_id,
          input_tokens: call.usage.inputTokens,
          output_tokens: call.usage.outputTokens,
          reasoning_tokens: call.usage.reasoningTokens,
          reference_tokens: referenceTokens,
          app_latency_ms: call.totalMs,
          provider_latency_ms: call.totalMs,
          total_latency_ms: call.totalMs,
          estimated_initial_grade_cost_usd: estimateCost(call.usage, model),
          estimated_full_attempt_cost_usd: estimateCost(call.usage, model),
          schema_valid: Boolean(call.ok && call.final && typeof call.final.points_earned === 'number' && call.final.criterion_statuses && typeof call.final.criterion_statuses === 'object'),
          timeout_or_retry: !call.ok,
          points_earned: call.final?.points_earned ?? 0,
          criterion_statuses,
          highest_value_gap: call.final?.highest_value_gap ?? '',
          minimum_fix_length: call.final?.minimum_fix_length ?? '',
          confidence: call.final?.confidence ?? 'low',
          uncertainty_reason: call.final?.uncertainty_reason ?? call.error ?? '',
          quality_flags: qualityFlags(criterion_statuses, labels),
          labels,
          error: call.error,
        };
        handle.write(`${JSON.stringify(record)}\n`);
        records.push(record);
        console.log(`${model} ${response.response_id}: schema=${record.schema_valid} flags=${record.quality_flags.length} cost=$${record.estimated_initial_grade_cost_usd.toFixed(5)} latency=${Math.round(record.total_latency_ms)}ms`);
      }
    }
  } finally {
    handle.end();
  }

  const summary = aggregate(records);
  writeReport(reportPath, summary, outputPath);
  console.log(`Wrote JSONL results: ${outputPath}`);
  console.log(`Wrote report: ${reportPath}`);
}

await main();
