import { streamObject } from 'ai';
import { z } from 'zod';
import fs from 'node:fs';
import path from 'node:path';

// TASK-0016 Phase C beta-2A -- the abstention / escalation-avoidance measurement.
//
// beta-1 proved boundary strengthening raises ACCURACY on fresh answers (+6.5pp, p=0.0004)
// but could not test the owner's escalation-avoidance claim at all: the fresh gold contained
// zero unable_to_determine labels, and genuine ambiguity in Engine 1's domain is ~0.7%
// (3 of 409 non-graph criteria in Stage 3) -- too rare to observe. So it is seeded here.
//
// Two cells, Arm A only (Arm B closed per ARM_B_ROOT_CAUSE_ANALYSIS.md):
//   amb_pre  : ORIGINAL contracts x ambiguity-seeded corpus
//   amb_post : REVISED  contracts x ambiguity-seeded corpus   (adds abstention_policy)
//
// The corpus is deliberately half ambiguous / half decisive-control. Controls carry surface
// features that mimic ambiguity (hedging, self-correction, disorganisation, confident
// wrongness) but are decidable. Without them a grader that abstained on everything would
// score perfectly, so both failure directions are measurable:
//   UNDER-abstention: gold ambiguous, grader commits  -> silently wrong, nothing escalates
//   OVER-abstention : gold decidable, grader abstains -> wasteful human escalation
//
// Corpus generation was blind to the revised contracts, and gold adjudication was blind to
// both the seed labels and the revisions, so the post cell cannot win by construction.
//
// Hard paid ceiling: $2.50, enforced before every call.

const ROOT = '/Users/davidbloom/Documents/Cramapple';
const PHASE_C = path.join(ROOT, 'docs/research/grading_phase_c_calibration_2026_07_27');
const S = '/private/tmp/claude-503/-Users-davidbloom-Documents-Cramapple/1b488fc3-9769-4bf0-b750-f8e409a3b774/scratchpad/phase_c';

const MANIFEST = JSON.parse(fs.readFileSync(path.join(PHASE_C, 'frozen_arm_manifest.json'), 'utf8'));
const ITEMS = JSON.parse(fs.readFileSync(path.join(S, 'stage3_items.json'), 'utf8'));
const REVISIONS = JSON.parse(fs.readFileSync(path.join(S, 'b1_revisions.json'), 'utf8'));
const ANSWERS = JSON.parse(fs.readFileSync(path.join(S, 'b2_answers.json'), 'utf8'));

const itemById = new Map(ITEMS.map((i) => [i.content_item_version_id, i]));
const revByKey = new Map(REVISIONS.map((r) => [`${r.content_item_version_id}::${r.criterion_key}`, r]));

const MODEL = MANIFEST.model_config.model_id;
const PROVIDER_OPTIONS = { google: { thinkingConfig: { thinkingBudget: 0, includeThoughts: false } } };
const P = MANIFEST.pricing_table;
const MAX_TOK = MANIFEST.model_config.max_output_tokens_arm_a;
const CAP = 2.50;
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

// Byte-identical to the beta-1 POST block. Reused verbatim so beta-2 measures the same
// treatment beta-1 did -- no new prompt engineering is introduced by this run.
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

const work = [];
for (const a of ANSWERS) {
  const item = itemById.get(a.content_item_version_id);
  for (const c of item.criteria) {
    for (const post of [false, true]) {
      work.push({ cell: post ? 'amb_post' : 'amb_pre', a, item, c, post });
    }
  }
}
console.log(`beta-2A: ${work.length} calls over ${ANSWERS.length} responses / ${new Set(ANSWERS.map((x) => x.content_item_version_id)).size} items (cap $${CAP.toFixed(2)})`);

// group by (cell, response) so an item's criteria run in parallel -- the Arm A definition
const groups = new Map();
for (const w of work) {
  const k = `${w.cell}::${w.a.content_item_version_id}::${w.a.variant}`;
  if (!groups.has(k)) groups.set(k, []);
  groups.get(k).push(w);
}

// Checkpoint incrementally and resume. A long paid run must never lose completed work to a
// timeout or a crash -- an interrupted run that wrote nothing is money spent for no data.
fs.mkdirSync(path.join(PHASE_C, 'raw'), { recursive: true });
const CKPT = path.join(PHASE_C, 'raw', 'b2_ambiguity_cells.jsonl');
const out = [];
const doneGroups = new Set();
if (fs.existsSync(CKPT)) {
  for (const line of fs.readFileSync(CKPT, 'utf8').trim().split('\n')) {
    if (!line) continue;
    const r = JSON.parse(line);
    out.push(r);
    doneGroups.add(`${r.cell}::${r.content_item_version_id}::${r.variant}`);
    cost += r.result?.costUsd || 0;
  }
  console.log(`resuming: ${out.length} rows / ${doneGroups.size} groups already done, $${cost.toFixed(4)} already spent`);
}
const sink = fs.createWriteStream(CKPT, { flags: 'a' });

let n = 0;
for (const [gk, ws] of groups) {
  if (stopped) { console.log('STOPPED for budget'); break; }
  if (doneGroups.has(gk)) { n++; continue; }
  const res = await Promise.all(ws.map((w) => call(buildPrompt(w.item, w.c, w.a.response_text, w.post))));
  const maxLat = Math.max(...res.map((r) => r.latencyMs || 0));
  ws.forEach((w, i) => {
    const row = {
      cell: w.cell,
      content_item_version_id: w.a.content_item_version_id, content_key: w.item.content_key,
      subject: w.item.subject, variant: w.a.variant,
      seed_kind: w.a.seed_kind, seed_class: w.a.seed_class,
      target_criterion_key: w.a.target_criterion_key,
      is_target: w.c.criterion_key === w.a.target_criterion_key,
      criterion_key: w.c.criterion_key, points_possible: w.c.points_possible,
      boundary_revised: w.post && revByKey.has(`${w.a.content_item_version_id}::${w.c.criterion_key}`),
      result: res[i], item_end_to_end_latency_ms: maxLat,
    };
    out.push(row);
    sink.write(JSON.stringify(row) + '\n');
  });
  n++;
  if (n % 25 === 0) console.log(`  ${n}/${groups.size} response-groups, cumulative $${cost.toFixed(4)}`);
}

sink.end();
const byCell = {};
for (const r of out) byCell[r.cell] = (byCell[r.cell] || 0) + 1;
console.log(`\nDone. calls=${out.length} ${JSON.stringify(byCell)} cost=$${cost.toFixed(4)} stopped=${stopped}`);
