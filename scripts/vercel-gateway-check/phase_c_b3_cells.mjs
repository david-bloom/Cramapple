import { streamObject } from 'ai';
import { z } from 'zod';
import fs from 'node:fs';
import path from 'node:path';

// TASK-0016 Phase C beta-3 -- second-generation boundary contracts.
//
// beta-1 raised accuracy (+6.5pp on fresh answers, p=0.0004) by enumerating accepted_variants.
// beta-2 then showed it OVER-corrected: under-credit fell 13->8 but over-credit rose 11->14,
// and 5 of the 7 still-failing revised criteria were over-credit. Moving a boundary is not the
// same as sharpening it. beta-3 authors from 94 observed grading errors with three changes:
//   * negative-side pass on already-revised criteria (near-misses only, no new accepted variants)
//   * balanced first-generation contracts for untouched error-carrying criteria
//   * explicit conjunction language for compound criteria, and charitable-notation rules
//
// Four cells. The `same_*` pair answers "did the fix land"; the `fresh_*` pair is the honest
// number, because contracts authored from beta-2's errors will score beta-2's corpus well by
// construction. beta-1 hit this exact hazard and solved it the same way.
//
//   same_post  : v2 contracts x the beta-2 corpus      (paired against beta-2's amb_post, reused free)
//   fresh_pre  : CURRENT contracts x fresh answers      (b1 revision where one exists, else original)
//   fresh_post : v2 contracts x fresh answers           <- generalisation
//
// Hard paid ceiling: $3.00, enforced before every call. Checkpoints and resumes.

const ROOT = '/Users/davidbloom/Documents/Cramapple';
const PHASE_C = path.join(ROOT, 'docs/research/grading_phase_c_calibration_2026_07_27');
const S = '/private/tmp/claude-503/-Users-davidbloom-Documents-Cramapple/1b488fc3-9769-4bf0-b750-f8e409a3b774/scratchpad/phase_c';

const MANIFEST = JSON.parse(fs.readFileSync(path.join(PHASE_C, 'frozen_arm_manifest.json'), 'utf8'));
const ITEMS = JSON.parse(fs.readFileSync(path.join(S, 'stage3_items.json'), 'utf8'));
const B1 = JSON.parse(fs.readFileSync(path.join(S, 'b1_revisions.json'), 'utf8'));
const B3 = JSON.parse(fs.readFileSync(path.join(S, 'b3_revisions.json'), 'utf8'));
const B2_ANSWERS = JSON.parse(fs.readFileSync(path.join(S, 'b2_answers.json'), 'utf8'));
const FRESH = JSON.parse(fs.readFileSync(path.join(S, 'b3_fresh_answers.json'), 'utf8'));

const itemById = new Map(ITEMS.map((i) => [i.content_item_version_id, i]));
const b1By = new Map(B1.map((r) => [`${r.content_item_version_id}::${r.criterion_key}`, r]));
const b3By = new Map(B3.map((r) => [`${r.content_item_version_id}::${r.criterion_key}`, r]));

const MODEL = MANIFEST.model_config.model_id;
const PROVIDER_OPTIONS = { google: { thinkingConfig: { thinkingBudget: 0, includeThoughts: false } } };
const P = MANIFEST.pricing_table;
const MAX_TOK = MANIFEST.model_config.max_output_tokens_arm_a;
const CAP = 3.00;
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

// beta-1's block, extended with the two fields beta-3 adds. Same wording elsewhere so the only
// variable between pre and post remains the boundary text itself.
function contractBlock(rev) {
  const compound = rev.compound_requirement &&
      String(rev.compound_requirement).toLowerCase() !== 'null' &&
      String(rev.compound_requirement).trim() !== ''
    ? `\n  Compound requirement (ALL parts must be satisfied; partial satisfaction does NOT earn): ${rev.compound_requirement}`
    : '';
  return `

REVISED BOUNDARY CONTRACT (authoritative for this criterion — it supersedes any narrower reading of the fields above):
  Accepted variants (these DO earn):
${rev.accepted_variants.map((s) => `    - ${s}`).join('\n')}
  Insufficient near-misses (these do NOT earn):
${rev.insufficient_near_misses.map((s) => `    - ${s}`).join('\n')}${compound}
  Scope: ${rev.scope_note}
  Polarity (negation / hedging / self-correction): ${rev.polarity_note}
  Contradiction policy: ${rev.contradiction_policy}
  ECF policy: ${rev.ecf_policy}
  Abstention policy: ${rev.abstention_policy}`;
}

function buildPrompt(item, c, responseText, generation) {
  const key = `${item.content_item_version_id}::${c.criterion_key}`;
  // "pre" = whatever is in place today: the b1 revision if one exists, otherwise the original.
  const rev = generation === 'v2' ? (b3By.get(key) ?? b1By.get(key)) : b1By.get(key);
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
  return rev ? base + contractBlock(rev) : base;
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
    return { ok: true, final, inputTokens: inT, outputTokens: outT, costUsd: c, latencyMs: performance.now() - t0, promptChars: prompt.length, schemaValid: true };
  } catch (e) {
    return { ok: false, final: null, costUsd: 0, latencyMs: performance.now() - t0, promptChars: prompt.length, schemaValid: false, error: e.message ?? String(e) };
  }
}

// Only items that actually carry a beta-3 authored criterion are in scope.
const scopedItems = new Set(B3.map((r) => r.content_item_version_id));

const work = [];
for (const a of B2_ANSWERS) {
  if (!scopedItems.has(a.content_item_version_id)) continue;
  const item = itemById.get(a.content_item_version_id);
  for (const c of item.criteria) work.push({ cell: 'same_post', a, item, c, gen: 'v2' });
}
for (const a of FRESH) {
  const item = itemById.get(a.content_item_version_id);
  for (const c of item.criteria) {
    work.push({ cell: 'fresh_pre', a, item, c, gen: 'v1' });
    work.push({ cell: 'fresh_post', a, item, c, gen: 'v2' });
  }
}
console.log(`beta-3: ${work.length} calls (cap $${CAP.toFixed(2)})`);

const groups = new Map();
for (const w of work) {
  const k = `${w.cell}::${w.a.content_item_version_id}::${w.a.variant}`;
  if (!groups.has(k)) groups.set(k, []);
  groups.get(k).push(w);
}

fs.mkdirSync(path.join(PHASE_C, 'raw'), { recursive: true });
const CKPT = path.join(PHASE_C, 'raw', 'b3_cells.jsonl');
const out = [];
const done = new Set();
if (fs.existsSync(CKPT)) {
  for (const line of fs.readFileSync(CKPT, 'utf8').trim().split('\n')) {
    if (!line) continue;
    const r = JSON.parse(line);
    out.push(r); done.add(`${r.cell}::${r.content_item_version_id}::${r.variant}`);
    cost += r.result?.costUsd || 0;
  }
  console.log(`resuming: ${out.length} rows, $${cost.toFixed(4)} already spent`);
}
const sink = fs.createWriteStream(CKPT, { flags: 'a' });

let n = 0;
for (const [gk, ws] of groups) {
  if (stopped) { console.log('STOPPED for budget'); break; }
  if (done.has(gk)) { n++; continue; }
  const res = await Promise.all(ws.map((w) => call(buildPrompt(w.item, w.c, w.a.response_text, w.gen))));
  const maxLat = Math.max(...res.map((r) => r.latencyMs || 0));
  ws.forEach((w, i) => {
    const key = `${w.a.content_item_version_id}::${w.c.criterion_key}`;
    const row = {
      cell: w.cell, generation: w.gen,
      content_item_version_id: w.a.content_item_version_id, content_key: w.item.content_key,
      subject: w.item.subject, variant: w.a.variant,
      seed_kind: w.a.seed_kind ?? null, seed_class: w.a.seed_class ?? null,
      criterion_key: w.c.criterion_key, points_possible: w.c.points_possible,
      has_b1: b1By.has(key), has_b3: b3By.has(key),
      b3_pass_type: b3By.get(key)?.pass_type ?? null,
      result: res[i], item_end_to_end_latency_ms: maxLat,
    };
    out.push(row); sink.write(JSON.stringify(row) + '\n');
  });
  n++;
  if (n % 25 === 0) console.log(`  ${n}/${groups.size} groups, cumulative $${cost.toFixed(4)}`);
}
sink.end();
const byCell = {};
for (const r of out) byCell[r.cell] = (byCell[r.cell] || 0) + 1;
console.log(`\nDone. calls=${out.length} ${JSON.stringify(byCell)} cost=$${cost.toFixed(4)} stopped=${stopped}`);
