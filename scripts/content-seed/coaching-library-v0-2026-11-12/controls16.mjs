import { generateObject } from 'ai';
import { z } from 'zod';
import fs from 'node:fs';
import path from 'node:path';
import crypto from 'node:crypto';

// Layer 3 pilot: draft distractor error labels, check them (deterministic + two judges + planted controls).
// Usage: node labels.mjs <out_dir> [--limit=N] [--budget=3]
// Cumulative spend ledger: spend_ledger.json; hard stop at the owner's $10 ceiling (recorded 2026-11-12).
const HERE = path.dirname(new URL(import.meta.url).pathname);
for (const raw of fs.readFileSync(path.resolve(HERE, '../../vercel-gateway-check/.env.local'), 'utf8').split(/\r?\n/)) {
  const l = raw.trim(); if (!l || l.startsWith('#') || !l.includes('=')) continue;
  const i = l.indexOf('='); const k = l.slice(0, i).trim();
  if (!(k in process.env)) process.env[k] = l.slice(i + 1).trim().replace(/^["']|["']$/g, '');
}
const [outDir, ...rest] = process.argv.slice(2); // outDir = new output dir; reads out_pilot/labels.json
const arg = (n, d) => Number((rest.find((a) => a.startsWith(`--${n}=`)) || `--${n}=${d}`).split('=')[1]);
const BUDGET = arg('budget', 3), LIMIT = arg('limit', 9999), CEILING = 10;
fs.mkdirSync(outDir, { recursive: true });
const LEDGER = path.join(HERE, 'spend_ledger.json');
const prior = JSON.parse(fs.readFileSync(LEDGER, 'utf8'));
const GEN = 'openai/gpt-6-luna';
const JUDGES = ['google/gemini-3.8-flash', 'alibaba/qwen3.8-flash'];

const res = await fetch('https://ai-gateway.vercel.sh/v1/models', { headers: { Authorization: `Bearer ${process.env.AI_GATEWAY_API_KEY}` } });
const PRICE = {};
for (const m of (await res.json()).data) { const p = m.pricing || {}; PRICE[m.id] = { in: parseFloat(p.input) || 0, out: parseFloat(p.output) || 0, c: parseFloat(p.input_cache_read) || null }; }
for (const m of [GEN, ...JUDGES]) if (!PRICE[m]) { console.error('missing model', m); process.exit(2); }
let spend = 0;
const cost = (m, u) => { const p = PRICE[m]; const c = u.cachedInputTokens ?? 0; return Math.max((u.inputTokens ?? 0) - c, 0) * p.in + c * (p.c ?? p.in) + (u.outputTokens ?? 0) * p.out; };
const guard = () => { if (spend > BUDGET || prior.total + spend > CEILING) { console.error('budget/ceiling exceeded', spend, prior.total); fs.writeFileSync(LEDGER, JSON.stringify({ total: prior.total + spend, runs: [...prior.runs, { out: outDir, spend, aborted: true }] })); process.exit(3); } };

// retry per judging recipe: 120 s cap, up to 3 attempts, at most 4 parallel
async function gen(model, schema, system, prompt) {
  let err;
  for (let a = 0; a < 3; a++) {
    try {
      const o = await generateObject({ model, schema, system, prompt, temperature: model === GEN ? 0.3 : 0, maxOutputTokens: 4000, abortSignal: AbortSignal.timeout(120000) });
      const c = cost(model, o.usage); spend += c; guard();
      return { ok: true, obj: o.object, cost: c };
    } catch (e) { err = String(e).slice(0, 160); }
  }
  return { ok: false, error: err };
}
async function pool(items, n, fn) { const out = new Array(items.length); let i = 0; await Promise.all(Array.from({ length: n }, async () => { while (i < items.length) { const k = i++; out[k] = await fn(items[k], k); } })); return out; }

// ---- source block --------------------------------------------------------------------
const items = JSON.parse(fs.readFileSync(path.join(HERE, 'pilot_items.json'), 'utf8')).slice(0, LIMIT);
const choice = (it, k) => it.choices.find((c) => c.k === k);
const correct = (it) => it.choices.find((c) => c.ok);
const block = (it) => `SUBJECT: ${it.subject === 'biology' ? 'AP Biology' : 'AP Statistics'}\nQUESTION:\n${it.stem}${it.stimulus ? `\nSTIMULUS:\n${it.stimulus}` : ''}\nCHOICES with the authored rationale for each:\n${it.choices.map((c) => `${c.k}. ${c.t}${c.ok ? '  [CORRECT]' : ''}\n   rationale: ${c.r}`).join('\n')}`;
const norm = (s) => String(s || '').toLowerCase().replace(/[\s ]+/g, ' ').replace(/[“”"'’‘]/g, '').trim();
const fingerprint = (it) => crypto.createHash('sha256').update(JSON.stringify([it.stem, it.stimulus, it.choices.map((c) => [c.k, c.t, c.ok, c.r])])).digest('hex').slice(0, 16);

// ---- drafting ------------------------------------------------------------------------
const LABEL = z.object({
  insufficient_source: z.boolean().describe('true if the authored rationales do not say enough to state the error and the requirement without adding facts'),
  error_summary: z.string().describe('One plain sentence, student-facing: what the wrong choice claims and why that fails. Restate the authored rationale; add nothing.'),
  error_type: z.string().describe('2-4 word snake_case label for the kind of error, e.g. wrong_direction, misapplied_formula, confuses_two_concepts, incomplete_condition'),
  requirement_lost: z.string().describe('What a correct answer must show to earn the point, taken from the correct choice rationale and the question. One sentence.'),
  fix_kind: z.enum(['answer_differently', 'learn_first']).describe('answer_differently: reframe or restructure the answer; learn_first: a fact, formula or concept is needed'),
  support_error: z.string().describe('A verbatim phrase (at least 4 words) copied from the wrong choice\'s own rationale that supports error_summary'),
  support_requirement: z.string().describe('A verbatim phrase (at least 4 words) copied from the correct choice rationale or the question that supports requirement_lost'),
});
const DSYS = `You write error labels for the wrong choices of AP multiple-choice questions, for a coaching library. Ground every statement ONLY in the question, the choices and their authored rationales. Never add a fact, number, rule or exam claim that those do not state. Never say why the student chose it ("you thought..."); say what the choice claims and why it fails. Plain language, no words "move", "trap", "habit". If the rationales do not say enough, set insufficient_source=true and keep the other fields minimal rather than inventing.`;
const draftPrompt = (it, feedback) => `${block(it)}\n\nLABEL THIS WRONG CHOICE: ${it.target}${feedback ? `\n\nYOUR PREVIOUS DRAFT WAS BLOCKED. Reasons: ${feedback}\nWrite a corrected label that uses only what the rationales state.` : ''}`;

// ---- deterministic checks --------------------------------------------------------------
const BANNED = /\b(move|trap|habit|pitfall)s?\b/i;
const MOTIVE = /\byou (picked|chose|selected|thought|assumed|forgot|rushed|probably|may have|likely)\b/i;
function detChecks(it, L) {
  const f = [];
  const t = choice(it, it.target), c = correct(it);
  if (L.insufficient_source) return f;
  const srcErr = norm(t.r), srcReq = norm(`${c.r} ${it.stem} ${it.stimulus || ''}`);
  if (norm(L.support_error).split(' ').length < 4 || !srcErr.includes(norm(L.support_error))) f.push('support_error_not_verbatim');
  if (norm(L.support_requirement).split(' ').length < 4 || !srcReq.includes(norm(L.support_requirement))) f.push('support_requirement_not_verbatim');
  if (BANNED.test(L.error_summary + ' ' + L.requirement_lost)) f.push('banned_word');
  if (MOTIVE.test(L.error_summary + ' ' + L.requirement_lost)) f.push('motive_language');
  if (!/^[a-z]+(_[a-z]+){0,3}$/.test(L.error_type)) f.push('error_type_format');
  return f;
}

// ---- judges --------------------------------------------------------------------------
const JUDGE = z.object({
  supported: z.boolean().describe('true only if EVERY substantive claim in error_summary and requirement_lost follows from the question, choices and authored rationales shown'),
  unsupported_claim: z.string().describe('"none" or quote the claim that does not follow from the source'),
  consistent_with_key: z.boolean().describe('false if the label treats the correct choice as wrong or the wrong choice as right'),
  accurate_to_choice: z.boolean().describe('true if error_summary describes what the labelled wrong choice actually says, not a different choice'),
  motive_claim: z.boolean().describe('true ONLY if the label itself states or implies the student\'s own reasoning or state of mind (for example "you picked this because", "you assumed", "you probably thought"). Describing what the wrong choice claims ("Choice D says...", "the choice treats X as Y") is NOT a motive claim: answer false.'),
  fix_kind_reasonable: z.boolean(),
  useful_to_coach: z.number().describe('1-5: would a coach find this label useful for explaining the lost point'),
  source_rationale_suspect: z.boolean().describe('true if the AUTHORED rationales themselves look wrong, contradict the stem, or disagree with the key'),
  source_note: z.string().describe('"none" or one sentence on what looks wrong in the authored source'),
});
const JSYS = 'You are a strict AP teacher auditing a coaching-library label. The question, key and authored rationales are the ground truth for what the label may say; recompute any arithmetic. Judge only what you are shown.';
const judgePrompt = (it, L) => `${block(it)}\n\nLABEL (for wrong choice ${it.target}):\n${JSON.stringify({ error_summary: L.error_summary, error_type: L.error_type, requirement_lost: L.requirement_lost, fix_kind: L.fix_kind }, null, 1)}`;
const blocks = (j) => !j.supported || !j.consistent_with_key || !j.accurate_to_choice || j.motive_claim;
async function judgeLabel(it, L) {
  const rs = await Promise.all(JUDGES.map((m) => gen(m, JUDGE, JSYS, judgePrompt(it, L)).then((r) => ({ judge: m, ...r }))));
  return rs;
}



const labels = JSON.parse(fs.readFileSync(path.join(HERE, 'out_merged/labels.json'), 'utf8'));
const allItems = JSON.parse(fs.readFileSync(path.join(HERE, 'pilot_items.json'), 'utf8'));
const itemFor = (x) => allItems.find((i) => i.item === x.item && i.target === x.target);
// controls on the corrected criterion: 2 each of the four kinds, built from checked dev labels
const chk = labels.filter((x) => x.status === 'checked' && !x.held_out && !x.recovered_by_rejudge).slice(16, 32);
const mut = {
  wrong_key: (it, L) => ({ ...L, error_summary: `Choice ${it.target} is actually the correct answer: ${choice(it, it.target).t}.` }),
  unsupported: (it, L) => ({ ...L, requirement_lost: `${L.requirement_lost} The College Board scoring guideline 4.2(b) deducts one point whenever this is omitted.` }),
  motive: (it, L) => ({ ...L, error_summary: `You picked this because you rushed and did not read the question. ${L.error_summary}` }),
  wrong_choice: (it, L) => { const o = it.choices.find((c) => !c.ok && c.k !== it.target); return { ...L, error_summary: o.r.split(/(?<=[.!?])\s/)[0] }; },
};
const kinds = Object.keys(mut);
const ctl = await pool(chk.map((x, i) => ({ x, kind: kinds[i % 4] })), 3, async ({ x, kind }) => {
  const it = itemFor(x); const js = await judgeLabel(it, mut[kind](it, x.label));
  const caught = js.map((j) => j.ok && blocks(j.obj));
  return { item: x.item, kind, caught_by: JUDGES.filter((_, k) => caught[k]), caught_all: caught.every(Boolean), judges_ok: js.every((j) => j.ok) };
});

const summary = { n: ctl.length, caught_by_both: ctl.filter((c) => c.caught_all).length, caught_by_either: ctl.filter((c) => c.caught_by.length > 0).length, judges_ok: ctl.filter((c) => c.judges_ok).length, by_kind: Object.fromEntries(kinds.map((k) => [k, ctl.filter((c) => c.kind === k).map((c) => c.caught_by.map((m) => m.split('/')[0]).join('+') || 'none')])), spend: +spend.toFixed(4) };
fs.writeFileSync(path.join(outDir, 'controls16.json'), JSON.stringify(ctl, null, 1));
fs.writeFileSync(path.join(outDir, 'summary16.json'), JSON.stringify(summary, null, 1));
const L2 = JSON.parse(fs.readFileSync(LEDGER, 'utf8'));
fs.writeFileSync(LEDGER, JSON.stringify({ total: +(L2.total + spend).toFixed(4), runs: [...L2.runs, { out: outDir + '/controls16', spend: +spend.toFixed(4), n: ctl.length }] }, null, 1));
console.log(JSON.stringify(summary, null, 1));
