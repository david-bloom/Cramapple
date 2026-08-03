import { streamObject } from 'ai';
import { z } from 'zod';
import fs from 'node:fs';
import path from 'node:path';

// TASK-0016 Phase C beta-1 -- boundary-strengthening mechanism test.
//
// Three cells, Arm A only (Arm B closed as a dead end per ARM_B_ROOT_CAUSE_ANALYSIS.md):
//   fresh_pre    : ORIGINAL contracts x FRESH held-out answers   (baseline)
//   fresh_post   : REVISED  contracts x FRESH held-out answers   (treatment)
//   original_post: REVISED  contracts x ORIGINAL answers         (overfitting regression check)
//
// The ONLY thing that differs between pre and post is criterion boundary text.
// Model, temperature, thinking mode, token caps, schema, and concurrency are identical.
// Hard paid ceiling: $2.00.

const ROOT = '/Users/davidbloom/Documents/Cramapple';
const PHASE_C = path.join(ROOT, 'docs/research/grading_phase_c_calibration_2026_07_27');
const S = '/private/tmp/claude-503/-Users-davidbloom-Documents-Cramapple/1b488fc3-9769-4bf0-b750-f8e409a3b774/scratchpad/phase_c';

const MANIFEST = JSON.parse(fs.readFileSync(path.join(PHASE_C, 'frozen_arm_manifest.json'), 'utf8'));
const ITEMS = JSON.parse(fs.readFileSync(path.join(S, 'stage3_items.json'), 'utf8'));
const REVISIONS = JSON.parse(fs.readFileSync(path.join(S, 'b1_revisions.json'), 'utf8'));
const FRESH = JSON.parse(fs.readFileSync(path.join(S, 'b1_fresh_answers.json'), 'utf8'));
const DOSSIERS = JSON.parse(fs.readFileSync(path.join(S, 'b1_error_dossiers.json'), 'utf8'));
const ORIGINAL = fs.readFileSync(path.join(PHASE_C, 'candidate_responses.jsonl'), 'utf8')
  .trim().split('\n').map((l) => JSON.parse(l));

const TARGET_IDS = new Set(DOSSIERS.map((d) => d.content_item_version_id));
const itemById = new Map(ITEMS.map((i) => [i.content_item_version_id, i]));
const origById = new Map(ORIGINAL.map((r) => [r.content_item_version_id, r]));
const revByKey = new Map(REVISIONS.map((r) => [`${r.content_item_version_id}::${r.criterion_key}`, r]));

const MODEL = MANIFEST.model_config.model_id;
const PROVIDER_OPTIONS = { google: { thinkingConfig: { thinkingBudget: 0, includeThoughts: false } } };
const P = MANIFEST.pricing_table;
const MAX_TOK = MANIFEST.model_config.max_output_tokens_arm_a;
const CAP = 2.00;
let cost = 0, stopped = false;

if (!(process.env.AI_GATEWAY_API_KEY || process.env.VERCEL_OIDC_TOKEN)) {
  console.error('No gateway credentials. Aborting before any paid call.'); process.exit(1);
}

const SCHEMA = z.object({
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

function fill(t, vars) {
  let o = t;
  for (const [k, v] of Object.entries(vars)) o = o.split(`{${k}}`).join(typeof v === 'string' ? v : JSON.stringify(v));
  return o;
}

// POST condition: swap in the revised accepted_variants and append the rest of the
// revised contract. Everything else about the prompt is byte-identical to PRE.
function revisedBlock(rev) {
  return `

REVISED BOUNDARY CONTRACT (authoritative for this criterion — it supersedes any narrower reading of the fields above):
  Accepted variants (these DO earn):
${rev.accepted_variants.map((s) => `    - ${s}`).join('\n')}
  Insufficient near-misses (these do NOT earn):
${rev.insufficient_near_misses.map((s) => `    - ${s}`).join('\n')}
  Scope: ${rev.scope_note}
  Polarity (negation / hedging / self-correction): ${rev.polarity_note}
  Contradiction policy: ${rev.contradiction_policy}
  ECF policy: ${rev.ecf_policy}
  Abstention policy: ${rev.abstention_policy}`;
}

function buildPrompt(item, c, responseText, usePost) {
  const rev = usePost ? revByKey.get(`${item.content_item_version_id}::${c.criterion_key}`) : null;
  const base = fill(MANIFEST.arm_a.prompt_template, {
    subject: item.subject, content_key: item.content_key,
    stem: item.stem || '', stimulus: item.stimulus || '',
    criterion_key: c.criterion_key, points_possible: c.points_possible,
    learner_facing_text: c.learner_facing_text,
    evidence_requirements: c.evidence_requirements || '',
    rubric_minimum_fix: c.minimum_fix || '',
    accepted_variants: rev ? rev.accepted_variants : (c.accepted_variants || []),
    deterministic_check_result: null,
    response_text: responseText,
  });
  return rev ? base + revisedBlock(rev) : base;
}

function preEst(p) { return ((Math.ceil(p.length / 4) * P.input_usd_per_1m_tokens) + (MAX_TOK * P.output_usd_per_1m_tokens)) / 1e6; }

async function call(prompt) {
  if (cost + preEst(prompt) > CAP) { stopped = true; return { ok: false, skipped: true }; }
  const t0 = performance.now();
  try {
    const res = streamObject({ model: MODEL, schema: SCHEMA, prompt, providerOptions: PROVIDER_OPTIONS, maxOutputTokens: MAX_TOK });
    for await (const _ of res.partialObjectStream) {}
    const final = await res.object;
    const u = await res.usage;
    const inT = Number(u.inputTokens ?? 0), outT = Number(u.outputTokens ?? 0);
    const c = ((inT * P.input_usd_per_1m_tokens) + (outT * P.output_usd_per_1m_tokens)) / 1e6;
    cost += c;
    return { ok: true, final, inputTokens: inT, outputTokens: outT, costUsd: c, latencyMs: performance.now() - t0, schemaValid: true };
  } catch (e) {
    return { ok: false, final: null, costUsd: 0, latencyMs: performance.now() - t0, schemaValid: false, error: e.message ?? String(e) };
  }
}

// build the work list for all three cells
const work = [];
for (const civ of TARGET_IDS) {
  const item = itemById.get(civ);
  for (const c of item.criteria) {
    for (const f of FRESH.filter((x) => x.content_item_version_id === civ)) {
      work.push({ cell: 'fresh_pre',  civ, variant: f.variant, item, c, text: f.response_text, post: false });
      work.push({ cell: 'fresh_post', civ, variant: f.variant, item, c, text: f.response_text, post: true });
    }
    work.push({ cell: 'original_post', civ, variant: 'original', item, c, text: origById.get(civ).response_text, post: true });
  }
}
console.log(`beta-1 cells: ${work.length} calls across ${TARGET_IDS.size} items (cap $${CAP.toFixed(2)})`);

const out = [];
let n = 0;
// group by (cell,civ,variant) so each response's criteria run in parallel (Arm A definition)
const groups = new Map();
for (const w of work) {
  const k = `${w.cell}::${w.civ}::${w.variant}`;
  if (!groups.has(k)) groups.set(k, []);
  groups.get(k).push(w);
}
for (const [k, ws] of groups) {
  if (stopped) { console.log('STOPPED for budget'); break; }
  const res = await Promise.all(ws.map((w) => call(buildPrompt(w.item, w.c, w.text, w.post))));
  const maxLat = Math.max(...res.map((r) => r.latencyMs || 0));
  ws.forEach((w, i) => out.push({
    cell: w.cell, content_item_version_id: w.civ, content_key: w.item.content_key,
    subject: w.item.subject, archetype: w.item.archetype, mechanism: w.item.mechanism ?? null,
    variant: w.variant, criterion_key: w.c.criterion_key, points_possible: w.c.points_possible,
    boundary_revised: w.post && revByKey.has(`${w.civ}::${w.c.criterion_key}`),
    result: res[i], item_end_to_end_latency_ms: maxLat,
  }));
  n++;
  if (n % 20 === 0) console.log(`  ${n}/${groups.size} response-groups, cumulative $${cost.toFixed(4)}`);
}

fs.mkdirSync(path.join(PHASE_C, 'raw'), { recursive: true });
fs.writeFileSync(path.join(PHASE_C, 'raw', 'b1_cells.jsonl'), out.map((r) => JSON.stringify(r)).join('\n') + '\n');
const byCell = {};
for (const r of out) byCell[r.cell] = (byCell[r.cell] || 0) + 1;
console.log(`\nDone. calls=${out.length} ${JSON.stringify(byCell)} cost=$${cost.toFixed(4)} stopped=${stopped}`);
