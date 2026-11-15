import { generateText, generateObject } from 'ai';
import { z } from 'zod';
import fs from 'node:fs';
import path from 'node:path';

// Layer 3 pilot ablation on the frozen held-out MCQ families: baseline (item fields only) vs +label.
// Usage: node coach.mjs <labels_dir> <out_dir> [--limit=N] [--budget=3]
const HERE = path.dirname(new URL(import.meta.url).pathname);
for (const raw of fs.readFileSync(path.resolve(HERE, '../../vercel-gateway-check/.env.local'), 'utf8').split(/\r?\n/)) {
  const l = raw.trim(); if (!l || l.startsWith('#') || !l.includes('=')) continue;
  const i = l.indexOf('='); const k = l.slice(0, i).trim();
  if (!(k in process.env)) process.env[k] = l.slice(i + 1).trim().replace(/^["']|["']$/g, '');
}
const [labelsDir, outDir, ...rest] = process.argv.slice(2);
const PREV = (rest.find((a) => a.startsWith('--prev=')) || '').slice(7);
const prevTexts = PREV ? JSON.parse(fs.readFileSync(path.join(PREV, 'texts.json'), 'utf8')) : [];
const prevItems = new Set(prevTexts.map((t) => t.item + '|' + t.target));
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

const items = JSON.parse(fs.readFileSync(path.join(HERE, 'pilot_items.json'), 'utf8'));
const labels = JSON.parse(fs.readFileSync(path.join(labelsDir, 'labels.json'), 'utf8'));
const pop = items.filter((i) => i.held_out);
const used = pop.map((it) => ({ it, lab: labels.find((l) => l.item === it.item && l.target === it.target && l.status === 'checked') })).filter((x) => x.lab && !prevItems.has(x.it.item + '|' + x.it.target)).slice(0, LIMIT);
const excluded = pop.length - used.length - prevItems.size;
console.error('held-out', pop.length, 'with checked label', used.length);

const jobs = [];
for (const { it, lab } of used) for (const g of GENS) for (const arm of ['A', 'B']) jobs.push({ it, lab, g, arm });
const texts = await pool(jobs, 4, async (j) => {
  const prompt = `${block(j.it)}${j.arm === 'B' ? libBlock(j.lab.label) : ''}\n\nSTUDENT PICKED: ${j.it.target}\nSTUDENT STATE: ${STATE}`;
  const t0 = Date.now();
  const r = await retry(async () => { const o = await generateText({ model: j.g, system: MCQ_RULES, prompt, temperature: 0.4, maxOutputTokens: 4000, abortSignal: AbortSignal.timeout(120000) }); const c = cost(j.g, o.usage); spend += c; guard(); return { text: o.text.trim(), cost: c, ms: Date.now() - t0, tin: o.usage.inputTokens }; });
  return { item: j.it.item, subject: j.it.subject, bucket: j.it.bucket, target: j.it.target, gen: j.g, arm: j.arm, ...r, words: r.text ? r.text.split(/\s+/).length : 0 };
});
console.error('generated', texts.filter((t) => t.ok).length, 'spend', spend.toFixed(3));

// ---- judging ------------------------------------------------------------------------
const J = z.object({
  factually_correct: z.boolean().describe('false if any statement contradicts the question, key or authored rationales'),
  contradiction: z.string(),
  unsupported_claim: z.string().describe('"none" or quote any claim that is not stated by, or does not follow from, the question and authored rationales'),
  no_unsupported_claim_about_student: z.boolean().describe('false if it says why the student chose it'),
  would_help_student: z.number().describe('1-5'), actionable_move: z.number().describe('1-5'),
  defect_and_fix_named: z.number().describe('1-5'), fix_kind_stated: z.boolean(), jargon_free: z.boolean(),
  links_to_requirement: z.number().describe('1-5'), explains_why_required: z.number().describe('1-5'),
});
const JSYS = 'You are a strict AP teacher auditing coaching text written for a student. The question, key and authored rationales are ground truth; recompute arithmetic. Judge only what you are shown.';
const jprompt = (it, text) => `${block(it)}\n\nSTUDENT PICKED: ${it.target}\n\nCOACHING TEXT TO JUDGE:\n"""${text}"""`;
const flagged = (j) => !j.factually_correct || j.unsupported_claim !== 'none' || !j.no_unsupported_claim_about_student;
const find = (t) => items.find((i) => i.item === t.item && i.target === t.target);
async function judgeAll(arr) {
  return pool(arr.flatMap((t) => JUDGES.map((m) => ({ t, m }))), 4, async ({ t, m }) => {
    const r = await retry(async () => { const o = await generateObject({ model: m, schema: J, system: JSYS, prompt: jprompt(find(t), t.text), temperature: 0, maxOutputTokens: 4000, abortSignal: AbortSignal.timeout(120000) }); const c = cost(m, o.usage); spend += c; guard(); return { j: o.object, cost: c }; });
    return { key: t, judge: m, ...r };
  });
}
const newGood = texts.filter((t) => t.ok);
const judged = await judgeAll(newGood);
newGood.forEach((t) => { t.judgements = judged.filter((x) => x.key === t).map((x) => ({ judge: x.judge, ...(x.ok ? x.j : { error: x.error }) })); });
const good = [...prevTexts, ...newGood];
console.error('judged; spend', spend.toFixed(3), 'combined texts', good.length);

// ---- planted controls (coaching texts) -----------------------------------------------------
const base = newGood.filter((t) => t.arm === 'A').slice(0, 8);
const cm = {
  wrong_key: (it, tx) => `${tx}\n\nIn fact, choice ${it.target} is the correct answer, so you should have kept it.`,
  unsupported: (it, tx) => `${tx} The College Board scoring guideline 4.2(b) deducts one point whenever this is omitted.`,
  motive: (it, tx) => `You picked ${it.target} because you rushed and did not read the question. ${tx}`,
  wrong_choice: (it, tx) => { const o = it.choices.find((c) => !c.ok && c.k !== it.target); return `Choice ${it.target} says something different: ${o.r}`; },
};
const kinds = Object.keys(cm);
const ctl = base.map((t, i) => ({ item: t.item, target: t.target, kind: kinds[i % 4], text: cm[kinds[i % 4]](find(t), t.text) }));
const cj = await judgeAll(ctl);
const controls = ctl.map((c) => { const js = cj.filter((x) => x.key === c); return { ...c, caught: js.map((x) => x.ok && flagged(x.j)), judges_ok: js.every((x) => x.ok) }; });

// ---- outputs -------------------------------------------------------------------------
const mean = (a) => (a.length ? +(a.reduce((s, x) => s + x, 0) / a.length).toFixed(2) : null);
const stats = (arr) => {
  const js = arr.flatMap((t) => (t.judgements || []).filter((j) => !j.error));
  return { texts: arr.length, judge_records: js.length, flagged_by_either: arr.filter((t) => (t.judgements || []).some((j) => !j.error && flagged(j))).length, unsupported_claims: arr.filter((t) => (t.judgements || []).some((j) => !j.error && j.unsupported_claim !== 'none')).length, factual_false: arr.filter((t) => (t.judgements || []).some((j) => !j.error && !j.factually_correct)).length, would_help: mean(js.map((j) => j.would_help_student)), defect_fix: mean(js.map((j) => j.defect_and_fix_named)), links_req: mean(js.map((j) => j.links_to_requirement)), why_required: mean(js.map((j) => j.explains_why_required)), kind_stated: mean(js.map((j) => (j.fix_kind_stated ? 1 : 0))), jargon_free: mean(js.map((j) => (j.jargon_free ? 1 : 0))), words: mean(arr.map((t) => t.words)), cost: mean(arr.map((t) => t.cost)), ms: mean(arr.map((t) => t.ms)), tokens_in: mean(arr.map((t) => t.tin)) };
};
const summary = { held_out_total: pop.length, excluded_no_checked_label: excluded, spend: +spend.toFixed(4), controls: { n: controls.length, caught_by_both: controls.filter((c) => c.caught.every(Boolean)).length, caught_by_either: controls.filter((c) => c.caught.some(Boolean)).length, judges_ok: controls.filter((c) => c.judges_ok).length }, arms: {} };
for (const g of GENS) for (const arm of ['A', 'B']) summary.arms[`${g.split('/')[1]}/${arm}`] = stats(good.filter((t) => t.gen === g && t.arm === arm));
for (const s of ['biology', 'ap-statistics']) for (const arm of ['A', 'B']) summary.arms[`${s}/${arm}`] = stats(good.filter((t) => t.subject === s && t.arm === arm));
summary.text_failures = texts.length - good.length; summary.judge_errors = good.flatMap((t) => t.judgements).filter((j) => j.error).length;
fs.writeFileSync(path.join(outDir, 'texts.json'), JSON.stringify(good, null, 1));
fs.writeFileSync(path.join(outDir, 'controls.json'), JSON.stringify(controls, null, 1));
fs.writeFileSync(path.join(outDir, 'summary.json'), JSON.stringify(summary, null, 1));

// ---- blinded human paired packet (haiku texts, 20 items, balanced subjects, randomized order) ---------
let seed = 7; const rnd = () => (seed = (seed * 1103515245 + 12345) % 2147483648) / 2147483648;
const hk = good.filter((t) => t.gen.includes('haiku'));
const itemsH = [...new Set(hk.map((t) => t.item))];
const pick = ['biology', 'ap-statistics'].flatMap((s) => itemsH.filter((i) => hk.find((t) => t.item === i).subject === s).sort(() => rnd() - 0.5).slice(0, 10));
let md = '# Blinded paired read, MCQ coaching, library label pilot\n\nFor each pair choose the better text for a student who just missed the question (or "tie"), and say why in a few words. Read the item first. Key at the end.\n\n';
const key = [];
pick.forEach((id, n) => {
  const it = items.find((i) => i.item === id && i.target === hk.find((t) => t.item === id).target);
  const a = hk.find((t) => t.item === id && t.arm === 'A'), b = hk.find((t) => t.item === id && t.arm === 'B'); if (!a || !b) return;
  const flip = rnd() < 0.5; const [x, y] = flip ? [b, a] : [a, b]; key.push(`${n + 1}: text 1 = ${x.arm === 'A' ? 'baseline' : 'with label'}`);
  md += `## ${n + 1}. ${it.subject === 'biology' ? 'AP Biology' : 'AP Statistics'} (student picked ${it.target})\n\n${it.stem}\n\n${it.choices.map((c) => `- ${c.k}. ${c.t}${c.ok ? ' (correct)' : ''}`).join('\n')}\n\n**Text 1** (${x.words} words)\n> ${x.text.replace(/\n/g, '\n> ')}\n\n**Text 2** (${y.words} words)\n> ${y.text.replace(/\n/g, '\n> ')}\n\nYour pick: ____  Why: ____\n\n`;
});
md += '\n---\n\n## Key (do not read until you have marked all pairs)\n\n' + key.join('\n') + '\n';
fs.writeFileSync(path.join(outDir, 'BLINDED_PAIRS.md'), md);
const L = JSON.parse(fs.readFileSync(LEDGER, 'utf8'));
fs.writeFileSync(LEDGER, JSON.stringify({ total: +(L.total + spend).toFixed(4), runs: [...L.runs, { out: outDir, spend: +spend.toFixed(4), n: texts.length }] }, null, 1));
console.log(JSON.stringify(summary, null, 1));
