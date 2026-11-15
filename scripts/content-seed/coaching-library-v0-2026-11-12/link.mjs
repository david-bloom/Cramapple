import { generateText, generateObject } from 'ai';
import { z } from 'zod';
import fs from 'node:fs';
import path from 'node:path';

// Explainer-link labelling pilot: draft links, check, then ablation arm C (baseline + linked passage) vs existing arm A.
// Usage: node link.mjs <out_dir> [--limit=N] [--budget=3]
const HERE = path.dirname(new URL(import.meta.url).pathname);
for (const raw of fs.readFileSync(path.resolve(HERE, '../../vercel-gateway-check/.env.local'), 'utf8').split(/\r?\n/)) {
  const l = raw.trim(); if (!l || l.startsWith('#') || !l.includes('=')) continue;
  const i = l.indexOf('='); const k = l.slice(0, i).trim();
  if (!(k in process.env)) process.env[k] = l.slice(i + 1).trim().replace(/^["']|["']$/g, '');
}
const [outDir, ...rest] = process.argv.slice(2);
const arg = (n, d) => Number((rest.find((a) => a.startsWith(`--${n}=`)) || `--${n}=${d}`).split('=')[1]);
const BUDGET = arg('budget', 3), LIMIT = arg('limit', 9999), CEILING = 10;
fs.mkdirSync(outDir, { recursive: true });
const LEDGER = path.join(HERE, 'spend_ledger.json');
const prior = JSON.parse(fs.readFileSync(LEDGER, 'utf8'));
const GENS = ['anthropic/claude-haiku-5.5', 'openai/gpt-6-luna'];
const JUDGES = ['google/gemini-3.8-flash', 'alibaba/qwen3.8-flash'];
const res = await fetch('https://ai-gateway.vercel.sh/v1/models', { headers: { Authorization: `Bearer ${process.env.AI_GATEWAY_API_KEY}` } });
const PRICE = {};
for (const m of (await res.json()).data) { const p = m.pricing || {}; PRICE[m.id] = { in: parseFloat(p.input) || 0, out: parseFloat(p.output) || 0, c: parseFloat(p.input_cache_read) || null }; }
let spend = 0;
const cost = (m, u) => { const p = PRICE[m]; const c = u.cachedInputTokens ?? 0; return Math.max((u.inputTokens ?? 0) - c, 0) * p.in + c * (p.c ?? p.in) + (u.outputTokens ?? 0) * p.out; };
const guard = () => { if (spend > BUDGET || prior.total + spend > CEILING) { console.error('budget/ceiling exceeded'); process.exit(3); } };
async function retry(fn) { let err; for (let a = 0; a < 3; a++) { try { return { ok: true, ...(await fn()) }; } catch (e) { err = String(e).slice(0, 160); } } return { ok: false, error: err }; }
async function pool(items, n, fn) { const out = new Array(items.length); let i = 0; await Promise.all(Array.from({ length: n }, async () => { while (i < items.length) { const k = i++; out[k] = await fn(items[k], k); } })); return out; }

const COMMON = `Organizing principle: you are showing the student how to earn points. Teach a concept or give information only when it serves that.
Voice rules:
- Plain language a high-school student understands. Do not use the words "move", "trap", "habit" or "pitfall". Say what to do as a direct instruction ("Next time, ...").
- Name the defect and the fix explicitly, as two clearly stated things: what was wrong or missing, and what the student must do to earn the point.
- Say which kind of fix it is: either "answer it differently" (restructure or reframe the answer) or "learn this first" (a fact, formula or concept the student needs; state it briefly).
- NEVER claim why the student picked a choice ("you picked A because you thought..."). Say what the choice says and why that fails.
- Second person, concise. No exclamation marks, no praise, no encouragement. No emoji.
- Use only what the item and rationales support. Do not invent facts. If unsure, say less.
- Output only the coaching text.`;
const MCQ_RULES = `You are the coach inside Cramapple, an AP exam-prep app. The verdict ("Incorrect") is already shown; you write the coaching beneath it. Hard limit: 100 words.
MCQs have no rubric. Each wrong choice shows how a point is lost. Structure:
1. What the question requires: say in plain words what a correct answer must show, taken from the question itself.
2. What the chosen option says and the specific error or gap in it (use the authored rationale for that choice, in your own words).
3. How the point is lost and how to earn it next time, naming the kind of fix.
You may state the correct answer and why.
${COMMON}`;
const block = (it) => `SUBJECT: ${it.subject === 'biology' ? 'AP Biology' : 'AP Statistics'}\nQUESTION:\n${it.stem}${it.stimulus ? `\nSTIMULUS:\n${it.stimulus}` : ''}\nCHOICES (with the authored rationale for each):\n${it.choices.map((c) => `${c.k}. ${c.t}${c.ok ? '  [CORRECT]' : ''}\n   rationale: ${c.r}`).join('\n')}`;
const libBlock = (L) => `\nLIBRARY LABEL for the chosen choice (approved-tier source; use it, do not add to it):\n- error: ${L.error_summary}\n- error type: ${L.error_type}\n- what a correct answer must show: ${L.requirement_lost}\n- fix kind: ${L.fix_kind === 'learn_first' ? 'learn this first' : 'answer it differently'}`;
const STATE = 'first miss on this question; no history. No praise, no encouragement.';


const GEN_LINK = 'openai/gpt-6-luna';
const pilot = JSON.parse(fs.readFileSync(path.join(HERE, 'pilot_items.json'), 'utf8')).slice(0, LIMIT);
const ctx = JSON.parse(fs.readFileSync(path.join(HERE, 'link_items.json'), 'utf8'));
const ctxFor = (it) => ctx.find((c) => c.item === it.item);
const FIELDS = { 'explainer.core_idea': (c) => c.explainer?.core_idea, 'explainer.understand': (c) => c.explainer?.understand, 'explainer.points': (c) => c.explainer?.points, 'explainer.answer_move': (c) => c.explainer?.answer_move, 'explainer.common_point_loss': (c) => c.explainer?.common_point_loss, 'brief.what_it_is': (c) => c.brief?.what_it_is, 'brief.earned': (c) => c.brief?.earned, 'brief.answer_move': (c) => c.brief?.answer_move, 'brief.common_point_loss': (c) => c.brief?.common_point_loss };
const FKEYS = [...Object.keys(FIELDS), 'none'];
const norm = (s) => String(s || '').toLowerCase().replace(/[\s ]+/g, ' ').replace(/[“”"'’‘]/g, '').trim();
const passages = (c) => Object.entries(FIELDS).map(([k, f]) => [k, f(c)]).filter(([, v]) => v).map(([k, v]) => `[${k}] ${v}`).join('\n');
const LINK = z.object({
  supporting_field: z.enum(FKEYS).describe('the single approved topic field whose text best bears on this wrong choice or on what a correct answer must show; "none" if no field does'),
  quote: z.string().describe('a verbatim passage (at least 5 words) copied from that field; empty if none'),
  bears_on: z.enum(['this_error', 'correct_requirement', 'both', 'none']),
  adds_beyond_rationale: z.string().describe('what this passage tells the student that the choice rationales do not; "nothing" if it only repeats them'),
});
const LSYS = 'You link a wrong multiple-choice option to the approved topic explainer and point brief of the same topic. Use only the passages provided; copy the quote verbatim; never paraphrase into the quote. Prefer "none" over a weak link.';
const lblock = (it, c) => `${block(it)}\n\nWRONG CHOICE TO LINK: ${it.target}\n\nAPPROVED TOPIC PASSAGES (field name in brackets):\n${passages(c)}`;
const JL = z.object({
  relevant: z.boolean().describe('true only if the passage genuinely bears on why the wrong choice fails or on what a correct answer must show'),
  supported_claim: z.boolean().describe('true only if adds_beyond_rationale is a true statement about what the passage says'),
  accurate_to_item: z.boolean().describe('false if the passage, used for this item, would contradict the key or the question'),
  adds_new: z.boolean().describe('true if the passage tells the student something the choice rationales do not'),
  note: z.string(),
});
const JLSYS = 'You are a strict AP teacher auditing a link between a wrong answer choice and an approved topic passage. The question, key and rationales are ground truth. Judge only what you are shown.';
const ljprompt = (it, L) => `${block(it)}\n\nLINK FOR WRONG CHOICE ${it.target}:\n${JSON.stringify(L, null, 1)}`;
const lblocks = (j) => !j.relevant || !j.supported_claim || !j.accurate_to_item;

async function judgeLink(it, L) { return Promise.all(JUDGES.map(async (m) => ({ judge: m, ...(await retry(async () => { const o = await generateObject({ model: m, schema: JL, system: JLSYS, prompt: ljprompt(it, L), temperature: 0, maxOutputTokens: 4000, abortSignal: AbortSignal.timeout(120000) }); const c = cost(m, o.usage); spend += c; guard(); return { j: o.object, cost: c }; })) }))); }

// ---- 1. draft + check links --------------------------------------------------------------
const linked = await pool(pilot, 4, async (it) => {
  const c = ctxFor(it); const base = { item: it.item, target: it.target, subject: it.subject, held_out: it.held_out, topic: c.topic, skill: c.skill };
  const r = await retry(async () => { const o = await generateObject({ model: GEN_LINK, schema: LINK, system: LSYS, prompt: lblock(it, c), temperature: 0.2, maxOutputTokens: 4000, abortSignal: AbortSignal.timeout(120000) }); const cc = cost(GEN_LINK, o.usage); spend += cc; guard(); return { L: o.object }; });
  if (!r.ok) return { ...base, status: 'draft_failed', error: r.error };
  const L = r.L;
  if (L.supporting_field === 'none' || L.bears_on === 'none') return { ...base, status: 'no_link', link: L };
  const src = FIELDS[L.supporting_field](c);
  const det = [];
  if (!src || !norm(src).includes(norm(L.quote)) || norm(L.quote).split(' ').length < 5) det.push('quote_not_verbatim');
  if (/^\s*nothing/i.test(L.adds_beyond_rationale)) det.push('redundant_with_rationale');
  if (det.includes('quote_not_verbatim')) return { ...base, status: 'blocked', link: L, reasons: det };
  const js = await judgeLink(it, L);
  if (js.some((j) => !j.ok)) return { ...base, status: 'unjudged', link: L };
  const bl = js.filter((j) => lblocks(j.j)).map((j) => `${j.judge}: ${j.j.note}`);
  const reasons = [...det, ...bl];
  return { ...base, status: reasons.length ? (det.length && !bl.length ? 'redundant' : 'blocked') : 'checked', link: L, reasons, adds_new: js.map((j) => j.j.adds_new), judges: js.map((j) => ({ judge: j.judge, ...j.j })) };
});
console.error('links done; spend', spend.toFixed(3));
const cnt = (s) => linked.filter((x) => x.status === s).length;

// ---- 2. planted controls (judge-only) ------------------------------------------------------
const goodL = linked.filter((x) => x.status === 'checked' && !x.held_out).slice(0, 8);
const itemOf = (x) => pilot.find((i) => i.item === x.item && i.target === x.target);
const otherQuote = (x) => { const o = linked.find((y) => y.status === 'checked' && y.topic !== x.topic); return o.link.quote; };
const cmut = { irrelevant: (x) => ({ ...x.link, quote: otherQuote(x), adds_beyond_rationale: 'The passage explains how this topic is scored.' }), overclaim: (x) => ({ ...x.link, adds_beyond_rationale: 'The passage states the exact 2019 exam penalty of one point for this specific mistake.' }) };
const ckinds = Object.keys(cmut);
const ctl = await pool(goodL.map((x, i) => ({ x, kind: ckinds[i % 2] })), 4, async ({ x, kind }) => { const js = await judgeLink(itemOf(x), cmut[kind](x)); const caught = js.map((j) => j.ok && lblocks(j.j)); return { item: x.item, kind, caught_by_both: caught.every(Boolean), caught_by: JUDGES.filter((_, k) => caught[k]).map((m) => m.split('/')[0]) }; });

// ---- 3. ablation arm C vs existing arm A on held-out linked items ---------------------------
const prevA = JSON.parse(fs.readFileSync(path.join(HERE, 'out_ablation2/texts.json'), 'utf8')).filter((t) => t.arm === 'A');
const target = linked.filter((x) => x.status === 'checked' && x.held_out && prevA.some((t) => t.item === x.item && t.target === x.target));
const cjobs = target.flatMap((x) => GENS.map((g) => ({ x, g })));
const J = z.object({ factually_correct: z.boolean(), contradiction: z.string(), unsupported_claim: z.string(), no_unsupported_claim_about_student: z.boolean(), would_help_student: z.number(), actionable_move: z.number(), defect_and_fix_named: z.number(), fix_kind_stated: z.boolean(), jargon_free: z.boolean(), links_to_requirement: z.number(), explains_why_required: z.number() });
const JSYS = 'You are a strict AP teacher auditing coaching text written for a student. The question, key, authored rationales and the approved topic passage (if shown) are ground truth; recompute arithmetic. A claim is supported if the question, rationales or the topic passage state it. Judge only what you are shown.';
const flagged = (j) => !j.factually_correct || j.unsupported_claim !== 'none' || !j.no_unsupported_claim_about_student;
const passageBlock = (L, c) => `\nAPPROVED TOPIC PASSAGE (${L.supporting_field}; use where it helps, do not add to it): "${L.quote}"`;
const ctexts = await pool(cjobs, 4, async ({ x, g }) => {
  const it = itemOf(x); const t0 = Date.now();
  const r = await retry(async () => { const o = await generateText({ model: g, system: MCQ_RULES, prompt: `${block(it)}${passageBlock(x.link)}\n\nSTUDENT PICKED: ${it.target}\nSTUDENT STATE: ${STATE}`, temperature: 0.4, maxOutputTokens: 4000, abortSignal: AbortSignal.timeout(120000) }); const c = cost(g, o.usage); spend += c; guard(); return { text: o.text.trim(), cost: c, ms: Date.now() - t0, tin: o.usage.inputTokens }; });
  return { item: x.item, target: x.target, subject: x.subject, gen: g, arm: 'C', ...r, words: r.text ? r.text.split(/\s+/).length : 0, passage: x.link };
});
const cgood = ctexts.filter((t) => t.ok);
const cj = await pool(cgood.flatMap((t) => JUDGES.map((m) => ({ t, m }))), 4, async ({ t, m }) => { const it = itemOf(t); const r = await retry(async () => { const o = await generateObject({ model: m, schema: J, system: JSYS, prompt: `${block(it)}${passageBlock(t.passage)}\n\nSTUDENT PICKED: ${it.target}\n\nCOACHING TEXT TO JUDGE:\n"""${t.text}"""`, temperature: 0, maxOutputTokens: 4000, abortSignal: AbortSignal.timeout(120000) }); const c = cost(m, o.usage); spend += c; guard(); return { j: o.object }; }); return { t, judge: m, ...r }; });
cgood.forEach((t) => { t.judgements = cj.filter((x) => x.t === t).map((x) => ({ judge: x.judge, ...(x.ok ? x.j : { error: x.error }) })); });
// arm A comparison set: same items and generators; note A was judged without a passage (stricter on unsupported claims)
const A = target.flatMap((x) => prevA.filter((t) => t.item === x.item && t.target === x.target));
const m2 = (a) => (a.length ? +(a.reduce((s, v) => s + v, 0) / a.length).toFixed(2) : null);
const st = (arr) => { const js = arr.flatMap((t) => (t.judgements || []).filter((j) => !j.error)); return { texts: arr.length, flagged_by_either: arr.filter((t) => t.judgements.some((j) => !j.error && flagged(j))).length, factual_false: arr.filter((t) => t.judgements.some((j) => !j.error && !j.factually_correct)).length, would_help: m2(js.map((j) => j.would_help_student)), defect_fix: m2(js.map((j) => j.defect_and_fix_named)), links_req: m2(js.map((j) => j.links_to_requirement)), why_required: m2(js.map((j) => j.explains_why_required)), words: m2(arr.map((t) => t.words)), tokens_in: m2(arr.map((t) => t.tin)) }; };
const summary = {
  links: { n: linked.length, checked: cnt('checked'), no_link: cnt('no_link'), redundant: cnt('redundant'), blocked: cnt('blocked'), unjudged: cnt('unjudged'), draft_failed: cnt('draft_failed'), adds_new_by_both_judges: linked.filter((x) => x.adds_new && x.adds_new.every(Boolean)).length, skill_code_present: linked.filter((x) => x.skill).length, by_subject: Object.fromEntries(['biology', 'ap-statistics'].map((s) => [s, { n: linked.filter((x) => x.subject === s).length, checked: linked.filter((x) => x.subject === s && x.status === 'checked').length }])), by_field: Object.entries(linked.filter((x) => x.status === 'checked').reduce((mm, x) => (mm[x.link.supporting_field] = (mm[x.link.supporting_field] || 0) + 1, mm), {})) },
  controls: { n: ctl.length, caught_by_both: ctl.filter((c) => c.caught_by_both).length, rows: ctl.map((c) => `${c.kind}:${c.caught_by.join('+') || 'none'}`) },
  ablation: { items: target.length, A: st(A), C: st(cgood), pairs: A.length, text_failures: ctexts.length - cgood.length },
  spend: +spend.toFixed(4),
};
// paired would-help
const wh = (t) => m2(t.judgements.filter((j) => !j.error).map((j) => j.would_help_student)); const dd = [];
for (const c of cgood) { const a = A.find((t) => t.item === c.item && t.target === c.target && t.gen === c.gen); if (a) dd.push(wh(c) - wh(a)); }
summary.ablation.paired_would_help = { mean_C_minus_A: m2(dd), C_better: dd.filter((d) => d > 0).length, A_better: dd.filter((d) => d < 0).length, tie: dd.filter((d) => d === 0).length };
fs.writeFileSync(path.join(outDir, 'links.json'), JSON.stringify(linked, null, 1));
fs.writeFileSync(path.join(outDir, 'controls.json'), JSON.stringify(ctl, null, 1));
fs.writeFileSync(path.join(outDir, 'texts_C.json'), JSON.stringify(cgood, null, 1));
fs.writeFileSync(path.join(outDir, 'summary.json'), JSON.stringify(summary, null, 1));
const Lg = JSON.parse(fs.readFileSync(LEDGER, 'utf8'));
fs.writeFileSync(LEDGER, JSON.stringify({ total: +(Lg.total + spend).toFixed(4), runs: [...Lg.runs, { out: outDir, spend: +spend.toFixed(4), n: linked.length }] }, null, 1));
console.log(JSON.stringify(summary, null, 1));
