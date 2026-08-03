import { streamObject } from 'ai';
import { z } from 'zod';
import fs from 'node:fs';
import path from 'node:path';

// TASK-0016 Phase C Stage 6 -- full paired calibration, n=100.
// Both arms, all 100 frozen FRQ responses, same order, sequential across items
// (parallel only WITHIN Arm A's criteria, which is its architectural definition
// -- running items concurrently would contend and corrupt latency measurement).
// Hard paid cost ceiling: $5.00, enforced pre-call in real time.
//
// Arm B runs with a CORRECTED token cap (see ARM_B_ROOT_CAUSE_ANALYSIS.md):
// the Stage 5 v2 dynamic cap min(180+160n,2200) caused truncation at 92-105%
// of cap on 3/20 items; a diagnostic rerun at 4000 recovered 3/3. Running the
// broken cap here would reproduce a known self-inflicted artifact rather than
// measure Arm B. Prompt text is UNCHANGED from arm_b_v2 (hash-verified).

const ROOT = '/Users/davidbloom/Documents/Cramapple';
const PHASE_C_DIR = path.join(ROOT, 'docs/research/grading_phase_c_calibration_2026_07_27');
const SCRATCH = '/private/tmp/claude-503/-Users-davidbloom-Documents-Cramapple/1b488fc3-9769-4bf0-b750-f8e409a3b774/scratchpad/phase_c';

const MANIFEST = JSON.parse(fs.readFileSync(path.join(PHASE_C_DIR, 'frozen_arm_manifest.json'), 'utf8'));
const ITEMS = JSON.parse(fs.readFileSync(path.join(SCRATCH, 'stage3_items.json'), 'utf8'));
const RESPONSES = fs.readFileSync(path.join(PHASE_C_DIR, 'candidate_responses.jsonl'), 'utf8')
  .trim().split('\n').map((l) => JSON.parse(l));
const STAT_KEYS = JSON.parse(fs.readFileSync(path.join(ROOT, 'docs/research/statistics_phase_b_2026_07_08/statistics_item_keys.json'), 'utf8'));

// Track gate-exposure so the report can separate a clean held-out subset from
// the 40 items already seen in the Stage 5 v1/v2 gates.
const seen = new Set();
for (const f of ['stage5_selected_20.json', 'stage5v2_selected_20.json']) {
  for (const it of JSON.parse(fs.readFileSync(path.join(SCRATCH, f), 'utf8'))) seen.add(it.content_item_version_id);
}

const respById = new Map(RESPONSES.map((r) => [r.content_item_version_id, r]));
const WORK = ITEMS.map((it) => ({
  ...it,
  response_text: respById.get(it.content_item_version_id)?.response_text ?? null,
  gate_exposed: seen.has(it.content_item_version_id),
})).filter((it) => it.response_text);

const MODEL = MANIFEST.model_config.model_id;
const PROVIDER_OPTIONS = { google: { thinkingConfig: { thinkingBudget: 0, includeThoughts: false } } };
const P = MANIFEST.pricing_table;
const HARD_CAP_USD = 5.00;
const ARM_A_MAX_TOK = MANIFEST.model_config.max_output_tokens_arm_a;
const ARM_B_MAX_TOK = 4000; // corrected; see header

let cost = 0;
let stopped = false;

if (!(process.env.AI_GATEWAY_API_KEY || process.env.VERCEL_OIDC_TOKEN)) {
  console.error('No gateway credentials. Aborting before any paid call.');
  process.exit(1);
}

const PER_CRITERION_SCHEMA = z.object({
  criterion_key: z.string(),
  status: z.enum(['earned', 'not_earned', 'unable_to_determine']),
  confidence: z.enum(['low', 'medium', 'high']),
  evidence_quote: z.string(),
  withheld_point_reason: z.string(),
  minimum_fix: z.string(),
  improved_answer: z.string(),
  error_classification: z.enum(['missing_evidence','conceptual_error','arithmetic_error','wrong_scope','contradiction','equivalent_form_rejected_incorrectly','ambiguous','none']),
  gate_schema_status: z.enum(['valid', 'invalid']),
});
const ARM_B_SCHEMA = z.object({ criteria: z.array(PER_CRITERION_SCHEMA) });

const KEYED = new Map(STAT_KEYS.items.map((it) => [it.content_key, it]));
function deterministicCheck(contentKey, responseText) {
  const keyed = KEYED.get(contentKey);
  if (!keyed) return null;
  for (const p of keyed.ecf_parts || []) {
    const ans = p.canonical_answer;
    if (ans === undefined || ans === null) continue;
    const asStr = String(ans);
    const rounded = typeof ans === 'number' ? String(Math.round(ans * 100) / 100) : asStr;
    if (responseText.includes(asStr) || responseText.includes(rounded)) {
      return { status: 'value_found', canonical_answer: ans, part_id: p.id, method: 'substring_match_of_canonical_numeric_answer' };
    }
  }
  return null;
}

function fill(t, vars) {
  let out = t;
  for (const [k, v] of Object.entries(vars)) out = out.split(`{${k}}`).join(typeof v === 'string' ? v : JSON.stringify(v));
  return out;
}
function preEst(prompt, maxTok) {
  return ((Math.ceil(prompt.length / 4) * P.input_usd_per_1m_tokens) + (maxTok * P.output_usd_per_1m_tokens)) / 1e6;
}

async function call(prompt, schema, maxTok, label) {
  if (cost + preEst(prompt, maxTok) > HARD_CAP_USD) { stopped = true; return { ok: false, skipped: true, error: 'budget cap', label }; }
  const t0 = performance.now(); let firstAt = null;
  try {
    const res = streamObject({ model: MODEL, schema, prompt, providerOptions: PROVIDER_OPTIONS, maxOutputTokens: maxTok });
    for await (const _ of res.partialObjectStream) { if (firstAt === null) firstAt = performance.now(); }
    const final = await res.object;
    const u = await res.usage;
    const inTok = Number(u.inputTokens ?? 0), outTok = Number(u.outputTokens ?? 0);
    const cachedTok = Number(u.cachedInputTokens ?? 0);
    const c = ((Math.max(inTok - cachedTok, 0) * P.input_usd_per_1m_tokens) + (cachedTok * P.input_usd_per_1m_tokens * 0.1) + (outTok * P.output_usd_per_1m_tokens)) / 1e6;
    cost += c;
    return { ok: true, final, inputTokens: inTok, outputTokens: outTok, costUsd: c, latencyMs: performance.now() - t0, ttfbMs: firstAt ? firstAt - t0 : null, schemaValid: true, label };
  } catch (e) {
    let d = e.message ?? String(e);
    try { if (e.cause?.responseBody) { const b = JSON.parse(e.cause.responseBody); d = b?.error?.type ?? b?.error?.message ?? d; } } catch {}
    return { ok: false, final: null, inputTokens: 0, outputTokens: 0, costUsd: 0, latencyMs: performance.now() - t0, ttfbMs: null, schemaValid: false, error: d, label };
  }
}

function armAPrompt(item, c, det) {
  return fill(MANIFEST.arm_a.prompt_template, {
    subject: item.subject, content_key: item.content_key, stem: item.stem || '', stimulus: item.stimulus || '',
    criterion_key: c.criterion_key, points_possible: c.points_possible, learner_facing_text: c.learner_facing_text,
    evidence_requirements: c.evidence_requirements || '', rubric_minimum_fix: c.minimum_fix || '',
    accepted_variants: c.accepted_variants || [], deterministic_check_result: det, response_text: item.response_text,
  });
}
function armBPrompt(item, detByKey) {
  const block = item.criteria.map((c) =>
    `  - criterion_key: ${c.criterion_key}\n    points_possible: ${c.points_possible}\n    learner_facing_text: ${c.learner_facing_text}\n    evidence_requirements: ${c.evidence_requirements || ''}\n    minimum_fix (rubric-authored): ${c.minimum_fix || ''}\n    accepted_variants: ${JSON.stringify(c.accepted_variants || [])}`
  ).join('\n');
  return fill(MANIFEST.arm_b_v2.prompt_template, {
    subject: item.subject, content_key: item.content_key, stem: item.stem || '', stimulus: item.stimulus || '',
    criteria_contracts_block: block, deterministic_check_results: detByKey, response_text: item.response_text,
  });
}

const aRecs = [], bRecs = [];
let i = 0;
for (const item of WORK) {
  i++;
  if (stopped) { console.log('STOPPED for budget cap'); break; }
  const det = deterministicCheck(item.content_key, item.response_text);
  const detByKey = {}; for (const c of item.criteria) detByKey[c.criterion_key] = det;

  const aRes = await Promise.all(item.criteria.map((c) => call(armAPrompt(item, c, det), PER_CRITERION_SCHEMA, ARM_A_MAX_TOK, `A:${item.content_key}:${c.criterion_key}`)));
  const aMax = Math.max(...aRes.map((r) => r.latencyMs || 0));
  item.criteria.forEach((c, k) => aRecs.push({
    content_item_version_id: item.content_item_version_id, content_key: item.content_key, subject: item.subject,
    archetype: item.archetype, mechanism: item.mechanism ?? null, n_criteria: item.criteria.length,
    gate_exposed: item.gate_exposed, criterion_key: c.criterion_key, points_possible: c.points_possible,
    deterministic_fired: det !== null, result: aRes[k], item_end_to_end_latency_ms: aMax,
  }));

  const bRes = await call(armBPrompt(item, detByKey), ARM_B_SCHEMA, ARM_B_MAX_TOK, `B:${item.content_key}`);
  bRecs.push({
    content_item_version_id: item.content_item_version_id, content_key: item.content_key, subject: item.subject,
    archetype: item.archetype, mechanism: item.mechanism ?? null, n_criteria: item.criteria.length,
    gate_exposed: item.gate_exposed, deterministic_fired: det !== null, result: bRes,
    item_end_to_end_latency_ms: bRes.latencyMs,
  });

  if (i % 10 === 0 || i === WORK.length) console.log(`[${i}/${WORK.length}] ${item.content_key} cumulative $${cost.toFixed(4)}`);
}

fs.mkdirSync(path.join(PHASE_C_DIR, 'raw'), { recursive: true });
fs.writeFileSync(path.join(PHASE_C_DIR, 'raw', 'stage6_arm_a.jsonl'), aRecs.map((r) => JSON.stringify(r)).join('\n') + '\n');
fs.writeFileSync(path.join(PHASE_C_DIR, 'raw', 'stage6_arm_b.jsonl'), bRecs.map((r) => JSON.stringify(r)).join('\n') + '\n');
console.log(`\nDone. items=${i} armA_calls=${aRecs.length} armB_calls=${bRecs.length} total_cost=$${cost.toFixed(4)} stopped=${stopped}`);
