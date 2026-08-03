import { streamObject } from 'ai';
import { z } from 'zod';
import fs from 'node:fs';
import path from 'node:path';

// FRQ02 boundary diagnostic — Step 0 of the planning-memo follow-up suite
// (docs/research/bio_reference_layer_next_planning_memo.md, 2026-06-18).
//
// Serves three of the memo's asks in one run:
//   #1 compact boundary memory vs no memory
//   #5 the boundary-vs-reviewer-note diagnostic extended to C1, C3 and C4, which the memo
//      makes a precondition for ANY promotion decision (previously only C2 was studied)
//   + the headroom check that β3 skipped. β3 spent $1.18 on a test with 6 discordant pairs,
//     which could not reach significance at any effect size (Lesson 22). The no-memory arm IS
//     the baseline, so running both arms measures headroom and the effect together.
//
// Corpus: docs/research/frq02_generated_answer_labels_codex_provisional.jsonl
//   100 answers, all label_status=learning_quality_approved, all use_as_ground_truth=true,
//   4 gold criterion labels each = 400 gold labels, with reviewer_note and boundary_tags.
//
// Two arms, IDENTICAL in every respect except the presence of the criterion boundary table:
//   no_memory       : criterion text only
//   boundary_memory : criterion text + the compact boundary table from sp1_pilot.mjs
//
// Model choice is deliberately held fixed here. Model/provider swaps (memo #2, #4) are a
// separate step, sized by what this one shows — comparing models before knowing whether the
// boundary contrast even has headroom would repeat the β3 mistake.
//
// Hard paid ceiling: $2.00, enforced before every call. Checkpoints and resumes.

const ROOT = '/Users/davidbloom/Documents/Cramapple';
const OUT_DIR = path.join(ROOT, 'docs/research/frq02_boundary_diagnostic_2026_07_28');
const CORPUS = path.join(ROOT, 'docs/research/frq02_generated_answer_labels_codex_provisional.jsonl');

const MODEL = 'google/gemini-2.5-flash';
const PROVIDER_OPTIONS = { google: { thinkingConfig: { thinkingBudget: 0, includeThoughts: false } } };
const PRICING = { input_usd_per_1m_tokens: 0.30, output_usd_per_1m_tokens: 2.50 };
const MAX_TOK = 700;
const CAP = 2.00;
let cost = 0, stopped = false;

if (!(process.env.AI_GATEWAY_API_KEY || process.env.VERCEL_OIDC_TOKEN)) {
  console.error('No gateway credentials. Aborting before any paid call.'); process.exit(1);
}

// Criterion text + boundary tables, lifted verbatim from scripts/vercel-gateway-check/sp1_pilot.mjs
// so this measures the boundary language that actually exists, not a fresh authoring pass.
const { CRITERIA } = await import('./frq02_criteria.mjs');
const CRITERION_IDS = Object.keys(CRITERIA);

const STEM = `A large population of a flowering plant species includes plants with red flowers and plants with white flowers. A construction project destroys most of the plants in the population. After the construction, the small surviving population is isolated and the frequency of the allele for white flowers is much higher than it was before.`;

const SCHEMA = z.object({
  status: z.enum(['earned', 'not_earned', 'unable_to_determine']),
  confidence: z.enum(['low', 'medium', 'high']),
  evidence_quote: z.string(),
  reason: z.string(),
});

function buildPrompt(criterionId, answerText, withBoundary) {
  const c = CRITERIA[criterionId];
  return [
    `You are grading one criterion of an AP Biology free-response question.`,
    ``,
    `Question stem:`,
    STEM,
    ``,
    `Criterion ${criterionId}: ${c.text}`,
    withBoundary ? `\n${c.boundary}\n` : ``,
    `Student response:`,
    answerText,
    ``,
    `Decide whether this response earns ${criterionId}.`,
    `Judge only what is actually written. Do not award credit for what the student probably meant.`,
    `evidence_quote must be a verbatim span from the response, or empty if nothing relevant is present.`,
    `Use unable_to_determine only when the response is genuinely ambiguous, not merely wrong or vague.`,
  ].filter(Boolean).join('\n');
}

function preEst(p) {
  return ((Math.ceil(p.length / 4) * PRICING.input_usd_per_1m_tokens) + (MAX_TOK * PRICING.output_usd_per_1m_tokens)) / 1e6;
}

async function call(prompt) {
  if (cost + preEst(prompt) > CAP) { stopped = true; return { ok: false, skipped: true }; }
  const t0 = performance.now();
  try {
    const res = streamObject({ model: MODEL, schema: SCHEMA, prompt, providerOptions: PROVIDER_OPTIONS, maxOutputTokens: MAX_TOK });
    for await (const _ of res.partialObjectStream) {}
    const final = await res.object;
    const u = await res.usage;
    const inT = Number(u.inputTokens ?? 0), outT = Number(u.outputTokens ?? 0);
    const c = ((inT * PRICING.input_usd_per_1m_tokens) + (outT * PRICING.output_usd_per_1m_tokens)) / 1e6;
    cost += c;
    return { ok: true, final, inputTokens: inT, outputTokens: outT, costUsd: c, latencyMs: performance.now() - t0, promptChars: prompt.length };
  } catch (e) {
    return { ok: false, final: null, costUsd: 0, latencyMs: performance.now() - t0, promptChars: prompt.length, error: e.message ?? String(e) };
  }
}

const corpus = fs.readFileSync(CORPUS, 'utf8').trim().split('\n').map((l) => JSON.parse(l))
  .filter((r) => r.use_as_ground_truth);
console.log(`corpus: ${corpus.length} answers x ${CRITERION_IDS.length} criteria x 2 arms = ${corpus.length * CRITERION_IDS.length * 2} calls (cap $${CAP.toFixed(2)})`);

const work = [];
for (const row of corpus) {
  for (const cid of CRITERION_IDS) {
    if (!row.criterion_labels?.[cid]) continue;
    for (const withB of [false, true]) {
      work.push({ arm: withB ? 'boundary_memory' : 'no_memory', row, cid, withB });
    }
  }
}

fs.mkdirSync(OUT_DIR, { recursive: true });
const CKPT = path.join(OUT_DIR, 'raw_cells.jsonl');
const out = [];
const done = new Set();
if (fs.existsSync(CKPT)) {
  for (const line of fs.readFileSync(CKPT, 'utf8').trim().split('\n')) {
    if (!line) continue;
    const r = JSON.parse(line);
    out.push(r); done.add(`${r.arm}::${r.response_id}::${r.criterion_id}`);
    cost += r.result?.costUsd || 0;
  }
  console.log(`resuming: ${out.length} rows, $${cost.toFixed(4)} already spent`);
}
const sink = fs.createWriteStream(CKPT, { flags: 'a' });

// group by (arm, answer) so an answer's 4 criteria run in parallel
const groups = new Map();
for (const w of work) {
  const k = `${w.arm}::${w.row.response_id}`;
  if (!groups.has(k)) groups.set(k, []);
  groups.get(k).push(w);
}

let n = 0;
for (const [, ws] of groups) {
  if (stopped) { console.log('STOPPED for budget'); break; }
  const pending = ws.filter((w) => !done.has(`${w.arm}::${w.row.response_id}::${w.cid}`));
  if (!pending.length) { n++; continue; }
  const res = await Promise.all(pending.map((w) => call(buildPrompt(w.cid, w.row.answer_text, w.withB))));
  const maxLat = Math.max(...res.map((r) => r.latencyMs || 0));
  pending.forEach((w, i) => {
    const row = {
      arm: w.arm, response_id: w.row.response_id, criterion_id: w.cid,
      gold: w.row.criterion_labels[w.cid],
      reviewer_note: w.row.reviewer_note ?? null,
      boundary_tags: w.row.boundary_tags ?? [],
      intended_error_pattern: w.row.generator_intended_error_pattern ?? null,
      target_points: w.row.generation_target_points_0_to_4 ?? null,
      result: res[i], answer_end_to_end_latency_ms: maxLat,
    };
    out.push(row); sink.write(JSON.stringify(row) + '\n');
  });
  n++;
  if (n % 25 === 0) console.log(`  ${n}/${groups.size} answer-groups, cumulative $${cost.toFixed(4)}`);
}
sink.end();
const byArm = {};
for (const r of out) byArm[r.arm] = (byArm[r.arm] || 0) + 1;
console.log(`\nDone. calls=${out.length} ${JSON.stringify(byArm)} cost=$${cost.toFixed(4)} stopped=${stopped}`);
