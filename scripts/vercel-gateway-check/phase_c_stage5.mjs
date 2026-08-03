import { streamObject } from 'ai';
import { z } from 'zod';
import fs from 'node:fs';
import path from 'node:path';
import crypto from 'node:crypto';

// TASK-0016 Phase C Stage 5 v2 -- repaired-Arm-B rerun on a FRESH n=20 slice
// (v1's set is burned per stage5_v1_burned_run_record.md; Arm A unchanged,
// Arm B uses arm_b_v2: brevity-constrained prompt + dynamic max_output_tokens).
// Hard paid cost ceiling: $1.00 total across both arms, enforced in real time.

const ROOT = '/Users/davidbloom/Documents/Cramapple';
const PHASE_C_DIR = path.join(ROOT, 'docs/research/grading_phase_c_calibration_2026_07_27');
const SCRATCH = '/private/tmp/claude-503/-Users-davidbloom-Documents-Cramapple/1b488fc3-9769-4bf0-b750-f8e409a3b774/scratchpad/phase_c';

const MANIFEST = JSON.parse(fs.readFileSync(path.join(PHASE_C_DIR, 'frozen_arm_manifest.json'), 'utf8'));
const SELECTED = JSON.parse(fs.readFileSync(path.join(SCRATCH, 'stage5v2_selected_20.json'), 'utf8'));
const STAT_KEYS = JSON.parse(fs.readFileSync(path.join(ROOT, 'docs/research/statistics_phase_b_2026_07_08/statistics_item_keys.json'), 'utf8'));

function dynamicMaxOutputTokensArmB(nCriteria) {
  return Math.min(180 + 160 * nCriteria, 2200);
}

const MODEL = MANIFEST.model_config.model_id;
const PROVIDER_OPTIONS = { google: { thinkingConfig: { thinkingBudget: 0, includeThoughts: false } } };
const PRICING = MANIFEST.pricing_table;
const HARD_CAP_USD = 1.00;

let cumulativeCostUsd = 0;
let stoppedForBudget = false;

function gatewayAvailable() {
  return Boolean(process.env.AI_GATEWAY_API_KEY || process.env.VERCEL_OIDC_TOKEN);
}
if (!gatewayAvailable()) {
  console.error('No AI_GATEWAY_API_KEY / VERCEL_OIDC_TOKEN in environment. Aborting before any paid call.');
  process.exit(1);
}

function usageCounts(usage) {
  usage = usage || {};
  const inputDetails = usage.inputTokenDetails || {};
  const outputDetails = usage.outputTokenDetails || {};
  return {
    inputTokens: Number(usage.inputTokens ?? 0),
    outputTokens: Number(usage.outputTokens ?? 0),
    cachedTokens: Number(usage.cachedInputTokens ?? inputDetails.cachedInputTokens ?? 0),
  };
}

function estimateCost(usage) {
  const uncached = Math.max(usage.inputTokens - usage.cachedTokens, 0);
  return ((uncached * PRICING.input_usd_per_1m_tokens) + (usage.cachedTokens * (PRICING.input_usd_per_1m_tokens * 0.1)) + (usage.outputTokens * PRICING.output_usd_per_1m_tokens)) / 1_000_000;
}

// Conservative pre-call estimate: ~4 chars/token for prompt, plus the arm's
// configured max_output_tokens as a worst-case output estimate.
function preCallEstimate(promptText, maxOutputTokens) {
  const estInputTokens = Math.ceil(promptText.length / 4);
  return ((estInputTokens * PRICING.input_usd_per_1m_tokens) + (maxOutputTokens * PRICING.output_usd_per_1m_tokens)) / 1_000_000;
}

function fillTemplate(template, vars) {
  let out = template;
  for (const [k, v] of Object.entries(vars)) {
    out = out.split(`{${k}}`).join(typeof v === 'string' ? v : JSON.stringify(v));
  }
  return out;
}

function promptHash(s) {
  return crypto.createHash('sha256').update(Buffer.from(s, 'utf8')).digest('hex').slice(0, 16);
}

// Minimal deterministic layer: only fires for the 5 already-keyed AP Statistics
// content_keys (reused from statistics_phase_b_2026_07_08/statistics_item_keys.json).
// Owns only the specific numeric sub-decision it can safely verify: does the
// canonical numeric answer appear, verbatim, in the response text. Abstains
// (returns null) on anything else, per "own only what it can safely decide."
const KEYED_ITEMS = new Map(STAT_KEYS.items.map((it) => [it.content_key, it]));
function deterministicCheck(contentKey, criterionKey, responseText) {
  const keyed = KEYED_ITEMS.get(contentKey);
  if (!keyed) return null;
  const part = (keyed.ecf_parts || []).find((p) => keyed.criteria && Object.values(keyed.criteria).some((c) => (c.parts || []).includes(p.id)));
  // Fall back: single-part items -- just check every ecf_part's canonical_answer.
  const parts = keyed.ecf_parts || [];
  for (const p of parts) {
    const ans = p.canonical_answer;
    if (ans === undefined || ans === null) continue;
    const asStr = String(ans);
    const rounded = typeof ans === 'number' ? String(Math.round(ans * 100) / 100) : asStr;
    if (responseText.includes(asStr) || responseText.includes(rounded)) {
      return { status: 'value_found', canonical_answer: ans, part_id: p.id, method: 'substring_match_of_canonical_numeric_answer' };
    }
  }
  return null; // abstain
}

const PER_CRITERION_SCHEMA = z.object({
  criterion_key: z.string(),
  status: z.enum(['earned', 'not_earned', 'unable_to_determine']),
  confidence: z.enum(['low', 'medium', 'high']),
  evidence_quote: z.string(),
  withheld_point_reason: z.string(),
  minimum_fix: z.string(),
  improved_answer: z.string(),
  error_classification: z.enum([
    'missing_evidence', 'conceptual_error', 'arithmetic_error', 'wrong_scope',
    'contradiction', 'equivalent_form_rejected_incorrectly', 'ambiguous', 'none',
  ]),
  gate_schema_status: z.enum(['valid', 'invalid']),
});

const ARM_B_SCHEMA = z.object({ criteria: z.array(PER_CRITERION_SCHEMA) });

async function callModel(promptText, schema, maxOutputTokens, label) {
  const preEst = preCallEstimate(promptText, maxOutputTokens);
  if (cumulativeCostUsd + preEst > HARD_CAP_USD) {
    stoppedForBudget = true;
    return { skipped: true, reason: 'projected cost would exceed $1.00 hard cap', preEst, cumulativeCostUsd };
  }
  const tStart = performance.now();
  let firstAt = null;
  try {
    const result = streamObject({
      model: MODEL,
      schema,
      prompt: promptText,
      providerOptions: PROVIDER_OPTIONS,
      maxOutputTokens,
    });
    for await (const _ of result.partialObjectStream) {
      if (firstAt === null) firstAt = performance.now();
    }
    const final = await result.object;
    const usage = usageCounts(await result.usage);
    const costUsd = estimateCost(usage);
    cumulativeCostUsd += costUsd;
    const end = performance.now();
    return {
      ok: true,
      final,
      usage,
      costUsd,
      latencyMs: end - tStart,
      ttfbMs: firstAt ? firstAt - tStart : null,
      schemaValid: true,
      label,
    };
  } catch (err) {
    const end = performance.now();
    let detail = err.message ?? String(err);
    try {
      if (err.cause?.responseBody) {
        const body = JSON.parse(err.cause.responseBody);
        detail = body?.error?.type ?? body?.error?.message ?? detail;
      }
    } catch {}
    return {
      ok: false,
      final: null,
      usage: { inputTokens: 0, outputTokens: 0, cachedTokens: 0 },
      costUsd: 0,
      latencyMs: end - tStart,
      ttfbMs: null,
      schemaValid: false,
      error: detail,
      label,
    };
  }
}

function armAPrompt(item, criterion, detResult) {
  return fillTemplate(MANIFEST.arm_a.prompt_template, {
    subject: item.subject,
    content_key: item.content_key,
    stem: item.stem || '',
    stimulus: item.stimulus || '',
    criterion_key: criterion.criterion_key,
    points_possible: criterion.points_possible,
    learner_facing_text: criterion.learner_facing_text,
    evidence_requirements: criterion.evidence_requirements || '',
    rubric_minimum_fix: criterion.minimum_fix || '',
    accepted_variants: criterion.accepted_variants || [],
    deterministic_check_result: detResult,
    response_text: item.response_text,
  });
}

function armBPrompt(item, detResultsByKey) {
  const block = item.criteria.map((c) =>
    `  - criterion_key: ${c.criterion_key}\n    points_possible: ${c.points_possible}\n    learner_facing_text: ${c.learner_facing_text}\n    evidence_requirements: ${c.evidence_requirements || ''}\n    minimum_fix (rubric-authored): ${c.minimum_fix || ''}\n    accepted_variants: ${JSON.stringify(c.accepted_variants || [])}`
  ).join('\n');
  return fillTemplate(MANIFEST.arm_b_v2.prompt_template, {
    subject: item.subject,
    content_key: item.content_key,
    stem: item.stem || '',
    stimulus: item.stimulus || '',
    criteria_contracts_block: block,
    deterministic_check_results: detResultsByKey,
    response_text: item.response_text,
  });
}

async function main() {
  console.log(`Stage 5 gate: ${SELECTED.length} items, model=${MODEL}, hard cap=$${HARD_CAP_USD.toFixed(2)}`);
  const armARecords = [];
  const armBRecords = [];

  for (const item of SELECTED) {
    if (stoppedForBudget) break;
    const detByKey = {};
    for (const c of item.criteria) detByKey[c.criterion_key] = deterministicCheck(item.content_key, c.criterion_key, item.response_text || '');

    // Arm A: one call per criterion, launched in parallel for this item.
    const armACalls = item.criteria.map((c) =>
      callModel(armAPrompt(item, c, detByKey[c.criterion_key]), PER_CRITERION_SCHEMA, MANIFEST.model_config.max_output_tokens_arm_a, `A:${item.content_key}:${c.criterion_key}`)
    );
    const armAResults = await Promise.all(armACalls);
    const armAMaxLatency = Math.max(...armAResults.map((r) => r.latencyMs || 0));
    for (let i = 0; i < item.criteria.length; i++) {
      armARecords.push({
        content_item_version_id: item.content_item_version_id,
        content_key: item.content_key,
        criterion_key: item.criteria[i].criterion_key,
        result: armAResults[i],
        item_end_to_end_latency_ms: armAMaxLatency,
      });
    }

    // Arm B (v2): one call for the whole item, dynamic token budget by criteria count.
    const armBMaxTokens = dynamicMaxOutputTokensArmB(item.criteria.length);
    const armBResult = await callModel(armBPrompt(item, detByKey), ARM_B_SCHEMA, armBMaxTokens, `B:${item.content_key}`);
    armBRecords.push({
      content_item_version_id: item.content_item_version_id,
      content_key: item.content_key,
      result: armBResult,
      item_end_to_end_latency_ms: armBResult.latencyMs,
    });

    console.log(`${item.content_key}: armA ${item.criteria.length} calls, armB 1 call, cumulative cost $${cumulativeCostUsd.toFixed(5)}`);
  }

  fs.mkdirSync(path.join(PHASE_C_DIR, 'raw'), { recursive: true });
  fs.writeFileSync(path.join(PHASE_C_DIR, 'raw', 'stage5v2_arm_a.jsonl'), armARecords.map((r) => JSON.stringify(r)).join('\n') + '\n');
  fs.writeFileSync(path.join(PHASE_C_DIR, 'raw', 'stage5v2_arm_b.jsonl'), armBRecords.map((r) => JSON.stringify(r)).join('\n') + '\n');

  console.log(`\nDone. Total cost: $${cumulativeCostUsd.toFixed(5)}. Stopped for budget: ${stoppedForBudget}`);
  console.log(`Arm A calls: ${armARecords.length}, Arm B calls: ${armBRecords.length}`);
}

main().catch((err) => {
  console.error('Fatal error:', err);
  process.exit(1);
});
