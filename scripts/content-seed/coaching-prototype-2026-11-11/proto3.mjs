import { generateText, generateObject } from 'ai';
import { z } from 'zod';
import fs from 'node:fs';
import path from 'node:path';

// Coaching-arc prototype, third pass: rewritten prompts per the voice rules (plan doc, 2026-11-12).
// 3 MCQs + 3 FRQs only, reusing pass-2 synthetic FRQ responses. Usage: node proto3.mjs <out_dir> [--budget=1]
const HERE = path.dirname(new URL(import.meta.url).pathname);
const GATE = path.resolve(HERE, '../../vercel-gateway-check');
for (const raw of fs.readFileSync(path.join(GATE, '.env.local'), 'utf8').split(/\r?\n/)) {
  const l = raw.trim(); if (!l || l.startsWith('#') || !l.includes('=')) continue;
  const i = l.indexOf('='); const k = l.slice(0, i).trim();
  if (!(k in process.env)) process.env[k] = l.slice(i + 1).trim().replace(/^["']|["']$/g, '');
}
const [outDir, ...rest] = process.argv.slice(2);
const BUDGET = Number((rest.find((a) => a.startsWith('--budget=')) || '--budget=1').slice(9));
fs.mkdirSync(outDir, { recursive: true });
const GENERATORS = ['anthropic/claude-haiku-5.5', 'openai/gpt-6-luna'];
const JUDGES = ['google/gemini-3.8-flash', 'zai/glm-5.3-flash'];
const mcqAll = JSON.parse(fs.readFileSync(path.join(HERE, 'mcq30.json'), 'utf8'));
const frqCases = JSON.parse(fs.readFileSync(path.join(HERE, 'out2pass/frq_cases.json'), 'utf8'));
const old = JSON.parse(fs.readFileSync(path.join(HERE, 'out2pass/judged.json'), 'utf8'));
const MCQS = [['APBIO-MCQ-SV-135-v2', 'A'], ['APSTATS-MCQ-SV-H-3.7-A-v3', 'D'], ['APSTATS-MCQ-SV-H-2.9-B-v1', 'C']];
const FRQS = ['apstats-frq-u13g-3-14', 'APBIO-FRQ-S-095', 'apstats-frq-u4z-4-6-1'];

const res = await fetch('https://ai-gateway.vercel.sh/v1/models', { headers: { Authorization: `Bearer ${process.env.AI_GATEWAY_API_KEY}` } });
const PRICE = {};
for (const m of (await res.json()).data) { const p = m.pricing || {}; PRICE[m.id] = { in: parseFloat(p.input) || 0, out: parseFloat(p.output) || 0, cacheRead: parseFloat(p.input_cache_read) || null }; }
let spend = 0;
const cost = (model, u) => { const p = PRICE[model]; const c = u.cachedInputTokens ?? 0; return Math.max((u.inputTokens ?? 0) - c, 0) * p.in + c * (p.cacheRead ?? p.in) + (u.outputTokens ?? 0) * p.out; };
const guard = () => { if (spend > BUDGET) { console.error('budget exceeded'); process.exit(3); } };

// ---- rewritten prompts ---------------------------------------------------------------------
const COMMON = `Organizing principle: you are showing the student how to earn points. Teach a concept or give information only when it serves that.
Voice rules:
- Plain language a high-school student understands. Do not use the words "move", "trap", "habit" or "pitfall". Say what to do as a direct instruction ("Next time, ...").
- Name the defect and the fix explicitly, as two clearly stated things: what was wrong or missing, and what the student must do to earn the point.
- Say which kind of fix it is: either "answer it differently" (restructure or reframe the answer) or "learn this first" (a fact, formula or concept the student needs; state it briefly).
- NEVER claim why the student picked a choice or wrote something ("you picked A because you thought..."). Say what the choice or response says and why that fails. You may say "a common mistake here is..." only if STUDENT STATE supplies history.
- Second person, concise. No exclamation marks. Praise only if STUDENT STATE says it is earned; encouragement only if it says so. At most one emoji; none is fine.
- Use only what the item, rationales, rubric and brief support. Do not invent facts. If unsure, say less.
- Output only the coaching text.`;
const MCQ_RULES = `You are the coach inside Cramapple, an AP exam-prep app. The verdict ("Incorrect") is already shown; you write the coaching beneath it. Hard limit: 100 words.
MCQs have no rubric. Each wrong choice shows how a point is lost. Structure:
1. What the question requires: say in plain words what a correct answer must show, taken from the question itself.
2. What the chosen option says and the specific error or gap in it (use the authored rationale for that choice, in your own words).
3. How the point is lost and how to earn it next time, naming the kind of fix.
You may state the correct answer and why.
${COMMON}`;
const FRQ_RULES = `You are the coach inside Cramapple, an AP exam-prep app. The score is shown; you write the coaching beneath it. Hard limit: 150 words.
The question's own parts are the guide to the points. Structure:
1. Anchor to the question: say what the question asks the student to do in the relevant parts ("Part (c) asks you to ... "). Name which parts/criteria were earned and which were lost, with the point values.
2. For each lost point: say what the response did instead of what the part requires, quote or paraphrase the student's own words, and explain WHY the part requires that piece for full credit (from the part's wording and the rubric line), not just that it is missing.
3. Say what to write to earn the point, and whether that is answering differently or learning something first.
Never say they omitted something they wrote; never credit something they did not write. State plainly what they earned (not praise).
${COMMON}`;
const mcqBlock = (it) => `SUBJECT: ${it.subject}\nTOPIC: ${it.topic}\nQUESTION:\n${it.stem}\nCHOICES (with the authored rationale for each):\n${it.choices.map((c) => `${c.k}. ${c.t}${c.ok ? '  [CORRECT]' : ''}\n   rationale: ${c.r}`).join('\n')}\nTOPIC BACKGROUND (do not cite as a rubric): ${it.brief.earned}\nTOPIC EXPLAINER (core idea): ${it.core || ''}`;
const frqBlock = (it) => `SUBJECT: ${it.subject}\nTOPIC: ${it.topic}\nQUESTION:\n${it.prompt}${it.stimulus ? `\nSTIMULUS:\n${it.stimulus}` : ''}\nRUBRIC (key, points, what earns it, authored minimum fix):\n${it.criteria.map((c) => `- ${c.key} (${c.points} pt): ${c.text}  | fix: ${c.fix}`).join('\n')}\nTOPIC EXPLAINER (core idea): ${it.core || ''}`;
const STATE = 'first miss on this question; no history. No praise, no encouragement.';

async function call(model, system, prompt, meta) {
  const t0 = Date.now();
  const r = await generateText({ model, system, prompt, maxOutputTokens: 4000, temperature: 0.4 });
  const c = cost(model, r.usage); spend += c; guard();
  const text = r.text.trim();
  return { ...meta, model, text, words: text.split(/\s+/).length, in: r.usage.inputTokens, out: r.usage.outputTokens, cost: c, ms: Date.now() - t0 };
}
const jobs = [];
for (const [id, pick] of MCQS) { const it = mcqAll.find((x) => x.id === id); for (const m of GENERATORS) jobs.push(() => call(m, MCQ_RULES, `${mcqBlock(it)}\n\nSTUDENT PICKED: ${pick}\nSTUDENT STATE: ${STATE}`, { item_type: 'mcq', item: id, pick })); }
for (const id of FRQS) {
  const fc = frqCases.find((x) => x.it.id === id);
  const crit = fc.it.criteria.map((c) => `- ${c.key}: ${fc.missed.includes(c.key) ? 'MISSED (0 pts)' : 'EARNED'}`).join('\n');
  for (const m of GENERATORS) jobs.push(() => call(m, FRQ_RULES, `${frqBlock(fc.it)}\n\nSTUDENT RESPONSE:\n"""${fc.response}"""\nGRADING RESULT PER CRITERION:\n${crit}\nSTUDENT STATE: ${STATE}`, { item_type: 'frq', item: id, pick: fc.missed.join('+') }));
}
const rows = await Promise.all(jobs.map((j) => j()));

// ---- judging (original criteria plus the new voice-rule criteria) --------------------------
const BASE = { factually_correct: z.boolean(), contradiction: z.string(), tone_ok: z.boolean(), would_help_student: z.number().describe('1-5'), actionable_move: z.number().describe('1-5'),
  no_unsupported_claim_about_student: z.boolean().describe('false if the text asserts why the student chose/wrote something, or any claim about the student not shown in the input'),
  defect_and_fix_named: z.number().describe('1-5: both the specific defect and what to do to earn the point are stated explicitly'),
  fix_kind_stated: z.boolean().describe('true if it says whether to answer differently or to learn something first'),
  jargon_free: z.boolean().describe('false if it uses "move", "trap", "habit" or similar internal jargon'),
  links_to_requirement: z.number().describe('1-5: connects the miss to what the question requires (and for FRQ, the rubric criterion / part)'),
  explains_why_required: z.number().describe('1-5: explains why the requirement is needed for the point, not just that it is missing') };
const FRQJ = z.object({ ...BASE, faithful_to_response: z.boolean() });
const JSYS = 'You are a strict AP teacher auditing coaching text written for a student. Judge only what you are shown. Authored rationales and rubric are ground truth; recompute arithmetic yourself.';
await Promise.all(rows.flatMap((r) => {
  r.judgements = [];
  let prompt;
  if (r.item_type === 'frq') { const fc = frqCases.find((x) => x.it.id === r.item); prompt = `${frqBlock(fc.it)}\n\nSTUDENT RESPONSE:\n"""${fc.response}"""\nLABELS: missed ${fc.missed.join(', ')}\n\nCOACHING TEXT TO JUDGE:\n"""${r.text}"""`; }
  else { const it = mcqAll.find((x) => x.id === r.item); prompt = `${mcqBlock(it)}\n\nSTUDENT PICKED: ${r.pick}\n\nCOACHING TEXT TO JUDGE:\n"""${r.text}"""`; }
  return JUDGES.map(async (jm) => { try { const o = await generateObject({ model: jm, schema: r.item_type === 'frq' ? FRQJ : z.object(BASE), system: JSYS, prompt, temperature: 0, maxOutputTokens: 4000 }); spend += cost(jm, o.usage); r.judgements.push({ judge: jm, ...o.object }); } catch (e) { r.judgements.push({ judge: jm, error: String(e).slice(0, 150) }); } });
}));
fs.writeFileSync(path.join(outDir, 'judged.json'), JSON.stringify(rows, null, 1));

// ---- readable side-by-side for the human read ----------------------------------------------
let md = '# Pass 3: rewritten prompts, 3 MCQs + 3 FRQs (old text from pass 2 shown for comparison)\n\n';
for (const r of rows.sort((a, b) => a.item.localeCompare(b.item))) {
  const o = old.find((x) => x.item === r.item && x.pick === r.pick && x.model === r.model && ['T1', 'FRQ'].includes(x.tier));
  const js = r.judgements.filter((j) => !j.error);
  md += `## ${r.item_type.toUpperCase()} ${r.item} (pick/missed: ${r.pick}), ${r.model.split('/')[1]}\n\n**OLD:**\n> ${(o?.text || '(no pass-2 text for this model)').replace(/\n/g, '\n> ')}\n\n**NEW (${r.words} words):**\n> ${r.text.replace(/\n/g, '\n> ')}\n\nJudges: factual ${js.map((j) => j.factually_correct).join('/')}, no-unsupported-claim ${js.map((j) => j.no_unsupported_claim_about_student).join('/')}, defect+fix ${js.map((j) => j.defect_and_fix_named).join('/')}, kind-stated ${js.map((j) => j.fix_kind_stated).join('/')}, jargon-free ${js.map((j) => j.jargon_free).join('/')}, links-to-requirement ${js.map((j) => j.links_to_requirement).join('/')}, why-required ${js.map((j) => j.explains_why_required).join('/')}${js.some((j) => j.contradiction && j.contradiction !== 'none') ? '\n\nContradiction noted: ' + js.map((j) => j.contradiction).filter((x) => x && x !== 'none').join(' | ') : ''}\n\n`;
}
fs.writeFileSync(path.join(outDir, 'PASS3_READ.md'), md);
console.log('spend', spend.toFixed(4), 'texts', rows.length, 'judge errors', rows.flatMap((r) => r.judgements).filter((j) => j.error).length);
