import { streamObject } from 'ai';
import { z } from 'zod';
import fs from 'node:fs';
import path from 'node:path';

// TASK-0016 Phase C beta-2B -- verdict stability, and whether disagreement can serve as the
// escalation signal that prompt-based abstention failed to provide (see B2_ABSTENTION_RESULTS.md).
//
// beta-2A established that Engine 1 never abstains: 54 of 56 genuinely-undecidable labels got a
// confident verdict, unchanged by 30 authored abstention_policy fields (p=1.00). But the pre and
// post conditions DISAGREED with each other on 25.5% of ambiguous labels versus 1.8% of decidable
// ones -- a 14.5x enrichment. That suggests routing on disagreement rather than on the model's
// own introspection.
//
// The confound: pre and post used DIFFERENT prompts. This run removes that. Two additional
// replicates of the amb_pre condition, byte-identical prompts, so combined with the existing
// amb_pre we have three replicates of exactly the same input.
//
// It answers one question with two very different consequences:
//   * if identical prompts DISAGREE  -> disagreement is free; sample k times and route on it
//   * if identical prompts AGREE     -> temp-0 self-consistency is high, disagreement must be
//                                       deliberately INDUCED (e.g. paraphrased boundary text),
//                                       and the 14.5x lift above is the evidence that works
//
// Hard paid ceiling: $2.00, enforced before every call. Checkpoints and resumes.

const ROOT = '/Users/davidbloom/Documents/Cramapple';
const PHASE_C = path.join(ROOT, 'docs/research/grading_phase_c_calibration_2026_07_27');
const S = '/private/tmp/claude-503/-Users-davidbloom-Documents-Cramapple/1b488fc3-9769-4bf0-b750-f8e409a3b774/scratchpad/phase_c';

const MANIFEST = JSON.parse(fs.readFileSync(path.join(PHASE_C, 'frozen_arm_manifest.json'), 'utf8'));
const ITEMS = JSON.parse(fs.readFileSync(path.join(S, 'stage3_items.json'), 'utf8'));
const ANSWERS = JSON.parse(fs.readFileSync(path.join(S, 'b2_answers.json'), 'utf8'));
const itemById = new Map(ITEMS.map((i) => [i.content_item_version_id, i]));

const MODEL = MANIFEST.model_config.model_id;
const PROVIDER_OPTIONS = { google: { thinkingConfig: { thinkingBudget: 0, includeThoughts: false } } };
const P = MANIFEST.pricing_table;
const MAX_TOK = MANIFEST.model_config.max_output_tokens_arm_a;
const CAP = 2.00;
const REPLICATES = ['r2', 'r3'];   // r1 is the existing amb_pre cell
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

// Identical to the beta-2A PRE prompt. No revised block, no other change.
function buildPrompt(item, c, responseText) {
  return fill(MANIFEST.arm_a.prompt_template, {
    subject: item.subject, content_key: item.content_key,
    stem: item.stem || '', stimulus: item.stimulus || '',
    criterion_key: c.criterion_key, points_possible: c.points_possible,
    learner_facing_text: c.learner_facing_text,
    evidence_requirements: c.evidence_requirements || '',
    rubric_minimum_fix: c.minimum_fix || '',
    accepted_variants: c.accepted_variants || [],
    deterministic_check_result: null,
    response_text: responseText,
  });
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
for (const rep of REPLICATES) {
  for (const a of ANSWERS) {
    const item = itemById.get(a.content_item_version_id);
    for (const c of item.criteria) work.push({ rep, a, item, c });
  }
}
console.log(`beta-2B: ${work.length} calls (${REPLICATES.length} replicates x ${ANSWERS.length} responses), cap $${CAP.toFixed(2)}`);

const groups = new Map();
for (const w of work) {
  const k = `${w.rep}::${w.a.content_item_version_id}::${w.a.variant}`;
  if (!groups.has(k)) groups.set(k, []);
  groups.get(k).push(w);
}

fs.mkdirSync(path.join(PHASE_C, 'raw'), { recursive: true });
const CKPT = path.join(PHASE_C, 'raw', 'b2b_stability.jsonl');
const out = [];
const done = new Set();
if (fs.existsSync(CKPT)) {
  for (const line of fs.readFileSync(CKPT, 'utf8').trim().split('\n')) {
    if (!line) continue;
    const r = JSON.parse(line);
    out.push(r); done.add(`${r.replicate}::${r.content_item_version_id}::${r.variant}`);
    cost += r.result?.costUsd || 0;
  }
  console.log(`resuming: ${out.length} rows, $${cost.toFixed(4)} already spent`);
}
const sink = fs.createWriteStream(CKPT, { flags: 'a' });

let n = 0;
for (const [gk, ws] of groups) {
  if (stopped) { console.log('STOPPED for budget'); break; }
  if (done.has(gk)) { n++; continue; }
  const res = await Promise.all(ws.map((w) => call(buildPrompt(w.item, w.c, w.a.response_text))));
  const maxLat = Math.max(...res.map((r) => r.latencyMs || 0));
  ws.forEach((w, i) => {
    const row = {
      replicate: w.rep,
      content_item_version_id: w.a.content_item_version_id, content_key: w.item.content_key,
      subject: w.item.subject, variant: w.a.variant,
      seed_kind: w.a.seed_kind, seed_class: w.a.seed_class,
      is_target: w.c.criterion_key === w.a.target_criterion_key,
      criterion_key: w.c.criterion_key, points_possible: w.c.points_possible,
      result: res[i], item_end_to_end_latency_ms: maxLat,
    };
    out.push(row); sink.write(JSON.stringify(row) + '\n');
  });
  n++;
  if (n % 25 === 0) console.log(`  ${n}/${groups.size} groups, cumulative $${cost.toFixed(4)}`);
}
sink.end();
console.log(`\nDone. calls=${out.length} cost=$${cost.toFixed(4)} stopped=${stopped}`);
