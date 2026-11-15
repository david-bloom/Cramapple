import { generateObject } from 'ai';
import { z } from 'zod';
import fs from 'node:fs';
import path from 'node:path';

// Re-judge arm-C texts (explainer-link pilot) with the SAME judge schema as arm A. Usage: node judgeC.mjs <out_dir>
const HERE = path.dirname(new URL(import.meta.url).pathname);
for (const raw of fs.readFileSync(path.resolve(HERE, '../../vercel-gateway-check/.env.local'), 'utf8').split(/\r?\n/)) {
  const l = raw.trim(); if (!l || l.startsWith('#') || !l.includes('=')) continue;
  const i = l.indexOf('='); const k = l.slice(0, i).trim();
  if (!(k in process.env)) process.env[k] = l.slice(i + 1).trim().replace(/^["']|["']$/g, '');
}
const [outDir] = process.argv.slice(2);
const BUDGET = 1, CEILING = 10;
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

const items = JSON.parse(fs.readFileSync(path.join(HERE, 'pilot_items.json'), 'utf8'));
const block = (it) => `SUBJECT: ${it.subject === 'biology' ? 'AP Biology' : 'AP Statistics'}\nQUESTION:\n${it.stem}${it.stimulus ? `\nSTIMULUS:\n${it.stimulus}` : ''}\nCHOICES (with the authored rationale for each):\n${it.choices.map((c) => `${c.k}. ${c.t}${c.ok ? '  [CORRECT]' : ''}\n   rationale: ${c.r}`).join('\n')}`;
// Identical to the arm-A judge schema (coach.mjs), including the scale descriptions that link.mjs lost.
const J = z.object({
  factually_correct: z.boolean().describe('false if any statement contradicts the question, key or authored rationales'),
  contradiction: z.string(),
  unsupported_claim: z.string().describe('"none" or quote any claim that is not stated by, or does not follow from, the question and authored rationales'),
  no_unsupported_claim_about_student: z.boolean().describe('false if it says why the student chose it'),
  would_help_student: z.number().describe('1-5'), actionable_move: z.number().describe('1-5'),
  defect_and_fix_named: z.number().describe('1-5'), fix_kind_stated: z.boolean(), jargon_free: z.boolean(),
  links_to_requirement: z.number().describe('1-5'), explains_why_required: z.number().describe('1-5'),
});
const JSYS = 'You are a strict AP teacher auditing coaching text written for a student. The question, key and authored rationales are ground truth; recompute arithmetic. An approved topic passage is also shown for this text; a claim the passage states is supported. Judge only what you are shown.';
const jprompt = (it, t) => `${block(it)}\nAPPROVED TOPIC PASSAGE (${t.passage.supporting_field}): "${t.passage.quote}"\n\nSTUDENT PICKED: ${it.target}\n\nCOACHING TEXT TO JUDGE:\n"""${t.text}"""`;
const flagged = (j) => !j.factually_correct || j.unsupported_claim !== 'none' || !j.no_unsupported_claim_about_student;

const C = JSON.parse(fs.readFileSync(path.join(HERE, 'out_link/texts_C.json'), 'utf8'));
const prevA = JSON.parse(fs.readFileSync(path.join(HERE, 'out_ablation2/texts.json'), 'utf8')).filter((t) => t.arm === 'A');
const itemOf = (t) => items.find((i) => i.item === t.item && i.target === t.target);
const rj = await pool(C.flatMap((t) => JUDGES.map((m) => ({ t, m }))), 4, async ({ t, m }) => {
  const r = await retry(async () => { const o = await generateObject({ model: m, schema: J, system: JSYS, prompt: jprompt(itemOf(t), t), temperature: 0, maxOutputTokens: 4000, abortSignal: AbortSignal.timeout(120000) }); const c = cost(m, o.usage); spend += c; guard(); return { j: o.object }; });
  return { t, judge: m, ...r };
});
C.forEach((t) => { t.judgements = rj.filter((x) => x.t === t).map((x) => ({ judge: x.judge, ...(x.ok ? x.j : { error: x.error }) })); });
const A = C.flatMap((c) => prevA.filter((t) => t.item === c.item && t.target === c.target && t.gen === c.gen));
const m2 = (a) => (a.length ? +(a.reduce((s, v) => s + v, 0) / a.length).toFixed(2) : null);
const st = (arr) => { const js = arr.flatMap((t) => (t.judgements || []).filter((j) => !j.error)); return { texts: arr.length, flagged_by_either: arr.filter((t) => t.judgements.some((j) => !j.error && flagged(j))).length, unsupported: arr.filter((t) => t.judgements.some((j) => !j.error && j.unsupported_claim !== 'none')).length, factual_false: arr.filter((t) => t.judgements.some((j) => !j.error && !j.factually_correct)).length, would_help: m2(js.map((j) => j.would_help_student)), defect_fix: m2(js.map((j) => j.defect_and_fix_named)), links_req: m2(js.map((j) => j.links_to_requirement)), why_required: m2(js.map((j) => j.explains_why_required)), words: m2(arr.map((t) => t.words)), tokens_in: m2(arr.map((t) => t.tin)) }; };
const wh = (t) => m2(t.judgements.filter((j) => !j.error).map((j) => j.would_help_student));
const dd = [];
for (const c of C) { const a = A.find((t) => t.item === c.item && t.target === c.target && t.gen === c.gen); if (a) dd.push(wh(c) - wh(a)); }
const byGen = Object.fromEntries(GENS.map((g) => [g.split('/')[1], { A: st(A.filter((t) => t.gen === g)), C: st(C.filter((t) => t.gen === g)) }]));
const summary = { A: st(A), C: st(C), by_generator: byGen, paired_would_help: { mean_C_minus_A: m2(dd), C_better: dd.filter((d) => d > 0).length, A_better: dd.filter((d) => d < 0).length, tie: dd.filter((d) => d === 0).length }, judge_errors: C.flatMap((t) => t.judgements).filter((j) => j.error).length, spend: +spend.toFixed(4) };
fs.writeFileSync(path.join(outDir, 'texts_C_rejudged.json'), JSON.stringify(C, null, 1));
fs.writeFileSync(path.join(outDir, 'summary_C_rejudged.json'), JSON.stringify(summary, null, 1));
const Lg = JSON.parse(fs.readFileSync(LEDGER, 'utf8'));
fs.writeFileSync(LEDGER, JSON.stringify({ total: +(Lg.total + spend).toFixed(4), runs: [...Lg.runs, { out: outDir + '/rejudgeC', spend: +spend.toFixed(4), n: C.length }] }, null, 1));
console.log(JSON.stringify(summary, null, 1));
