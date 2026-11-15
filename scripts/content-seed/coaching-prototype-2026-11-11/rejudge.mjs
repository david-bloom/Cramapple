import { generateObject } from 'ai';
import { z } from 'zod';
import fs from 'node:fs';
import path from 'node:path';
// Re-score existing texts with candidate replacement judges (no regeneration). Usage:
//   node rejudge.mjs test <out> model1,model2,...   (control + flagged + sample of clean texts, pass 2 + pass 3)
//   node rejudge.mjs all  <out> model                (every pass-2 and pass-3 text)
const HERE = path.dirname(new URL(import.meta.url).pathname);
for (const raw of fs.readFileSync(path.resolve(HERE, '../../vercel-gateway-check/.env.local'), 'utf8').split(/\r?\n/)) {
  const l = raw.trim(); if (!l || l.startsWith('#') || !l.includes('=')) continue;
  const i = l.indexOf('='); const k = l.slice(0, i).trim(); if (!(k in process.env)) process.env[k] = l.slice(i + 1).trim().replace(/^["']|["']$/g, '');
}
const [mode, outDir, modelsArg] = process.argv.slice(2);
const MODELS = modelsArg.split(','); const BUDGET = 3;
fs.mkdirSync(outDir, { recursive: true });
const mcq = JSON.parse(fs.readFileSync(path.join(HERE, 'mcq30.json'), 'utf8'));
const first = JSON.parse(fs.readFileSync(path.join(HERE, 'sample.json'), 'utf8'));
const frqCases = JSON.parse(fs.readFileSync(path.join(HERE, 'out2pass/frq_cases.json'), 'utf8'));
const p2 = JSON.parse(fs.readFileSync(path.join(HERE, 'out2pass/judged.json'), 'utf8'));
const p3 = JSON.parse(fs.readFileSync(path.join(HERE, 'out3pass/judged.json'), 'utf8'));
const res = await fetch('https://ai-gateway.vercel.sh/v1/models', { headers: { Authorization: `Bearer ${process.env.AI_GATEWAY_API_KEY}` } });
const PRICE = {}; for (const m of (await res.json()).data) { const p = m.pricing || {}; PRICE[m.id] = { in: parseFloat(p.input) || 0, out: parseFloat(p.output) || 0, c: parseFloat(p.input_cache_read) || null }; }
for (const m of MODELS) if (!PRICE[m]) { console.error('missing', m); process.exit(2); }
let spend = 0; const cost = (m, u) => { const p = PRICE[m]; const c = u.cachedInputTokens ?? 0; return Math.max((u.inputTokens ?? 0) - c, 0) * p.in + c * (p.c ?? p.in) + (u.outputTokens ?? 0) * p.out; };

const T1_STATE = 'first miss on this kind of question; no history. No praise, no encouragement.';
const T2 = { repeat: ['Struggling: third miss this session on the same slip. Give encouragement framed as persistence (they keep trying), then a different angle than the history.', 'The previous two misses this session were the same kind of slip. They opened the rubric hint on the last one. The last coaching restated the authored rationale.'], 'cross-session': ['No improvement but the student is trying again. Give encouragement framed as persistence, and do not repeat the earlier explanation.', 'Missed this same misconception in two earlier sessions and was told to check the key condition first.'], improving: ['Improving without full credit: they fixed an earlier slip but have a new one on the same topic. Give encouragement framed as progress, then fix only the new slip.', 'Earlier attempt on a similar item: a different error. This attempt: a different distractor.'], 'explain-more': ['The student pressed "Explain more" after the first coaching; it counts as a hint. Add a new angle, not a repeat. No praise.', 'The first coaching already stated the main correction. The student still seems unsure.'], praise: ['Praise is earned: the student missed this cell earlier and is now correct. Give one short, specific praise, then one sentence reinforcing why the reasoning works. No encouragement.', 'Missed this topic on two previous attempts; first correct answer now.'] };
const mcqBlock = (it, bg = true) => `SUBJECT: ${it.subject}\nTOPIC: ${it.topic}\nQUESTION:\n${it.stem}\nCHOICES (with the authored rationale for each):\n${it.choices.map((c) => `${c.k}. ${c.t}${c.ok ? '  [CORRECT]' : ''}\n   rationale: ${c.r}`).join('\n')}\nPOINT BRIEF:\n- How points are earned: ${it.brief.earned}\n- Answer move: ${it.brief.move}\n- Common point loss: ${it.brief.loss}\nTOPIC EXPLAINER (core idea): ${it.core || ''}`;
const frqBlock = (it) => `SUBJECT: ${it.subject}\nTOPIC: ${it.topic}\nQUESTION:\n${it.prompt}${it.stimulus ? `\nSTIMULUS:\n${it.stimulus}` : ''}\nRUBRIC CRITERIA (key, points, what earns it, the authored minimum fix):\n${it.criteria.map((c) => `- ${c.key} (${c.points} pt): ${c.text}  | fix: ${c.fix}`).join('\n')}\nPOINT BRIEF:\n- How points are earned: ${it.brief.earned}\n- Answer move: ${it.brief.move}\n- Common point loss: ${it.brief.loss}\nTOPIC EXPLAINER (core idea): ${it.core || ''}`;
const findMcq = (id) => mcq.find((x) => x.id === id) || first.find((x) => x.id === id);
const num = z.number().describe('1-5');
const BASE = { factually_correct: z.boolean().describe('false if ANY statement contradicts the question, key, rationales, rubric or point brief'), contradiction: z.string(), tone_ok: z.boolean(), would_help_student: num, actionable_move: num };
const MCQJ = z.object({ ...BASE, specific_to_pick: num, names_exam_point: num, uses_history: z.number() });
const FRQJ = z.object({ ...BASE, targets_missed_criteria: num, faithful_to_response: z.boolean() });
const JSYS = 'You are a strict AP teacher auditing coaching text written for a student. Judge only what you are shown. The authored rationales, rubric and point brief are ground truth; recompute arithmetic yourself.';
const mk = (r, pass) => {
  if (r.item_type === 'frq') { const fc = frqCases.find((x) => x.it.id === r.item); if (!fc) return null; const crit = fc.it.criteria.map((c) => `- ${c.key}: ${fc.missed.includes(c.key) ? 'MISSED' : 'EARNED'}`).join('\n'); return { schema: FRQJ, prompt: `${frqBlock(fc.it)}\n\nSTUDENT RESPONSE:\n"""${fc.response}"""\nGRADING LABELS:\n${crit}\nSTUDENT STATE: first attempt; partial credit. No praise or encouragement.\n\nCOACHING TEXT TO JUDGE:\n"""${r.text}"""` }; }
  const it = findMcq(r.item); if (!it) return null; const t2 = r.tier === 'T2' ? T2[r.case] : null;
  return { schema: MCQJ, prompt: `${mcqBlock(it)}\n\nSTUDENT PICKED: ${r.pick}\n${t2 ? `STUDENT STATE: ${t2[0]}\nHISTORY: ${t2[1]}` : `STUDENT STATE: ${T1_STATE}`}\n\nCOACHING TEXT TO JUDGE:\n"""${r.text}"""` };
};
const ok = (j) => j && !j.error;
const gem = (r) => r.judgements.find((j) => j.judge.includes('gemini'));
let set = [...p2.filter((r) => r.text).map((r) => ({ ...r, src: 'p2' })), ...p3.map((r) => ({ ...r, src: 'p3' }))].filter((r) => r.tier !== 'T0');
if (mode === 'test') {
  const flagged = set.filter((r) => r.src === 'p2' && r.tier !== 'CONTROL' && r.judgements.some((j) => j.factually_correct === false));
  const ctrl = set.filter((r) => r.tier === 'CONTROL');
  const clean = set.filter((r) => r.src === 'p2' && !['CONTROL'].includes(r.tier) && !flagged.includes(r)).filter((_, i) => i % 14 === 0).slice(0, 20);
  set = [...ctrl, ...flagged, ...clean, ...set.filter((r) => r.src === 'p3')];
}
const SH = (process.env.SHARD||'0/1').split('/').map(Number); set = set.filter((_, k) => k % SH[1] === SH[0]);
const jobs = [];
for (const r of set) { const m = mk(r); if (!m) continue; for (const model of MODELS) jobs.push({ r, model, ...m }); }
const out = []; let i = 0;
await Promise.all(Array.from({ length: 10 }, async () => { while (i < jobs.length) { const j = jobs[i++]; let rec; for (let a = 0; a < 2 && !rec; a++) { try { const o = await generateObject({ model: j.model, schema: j.schema, system: JSYS, prompt: j.prompt, temperature: 0, maxOutputTokens: 4000, abortSignal: AbortSignal.timeout(60000) }); const c = cost(j.model, o.usage); spend += c; if (spend > BUDGET) { console.error('budget'); process.exit(3); } rec = { judge: j.model, ...o.object, cost: c }; } catch (e) { if (a) rec = { judge: j.model, error: String(e).slice(0, 140) }; } } out.push({ src: j.r.src, tier: j.r.tier, item: j.r.item, pick: j.r.pick, gen: j.r.model, text: j.r.text, judgements: j.r.judgements, newj: rec }); } }));
fs.writeFileSync(path.join(outDir, `${mode}${SH[1]>1?'-'+SH[0]:''}.json`), JSON.stringify(out, null, 1));
const report = {};
for (const model of MODELS) {
  const rs = out.filter((x) => x.newj.judge === model); const good = rs.filter((x) => ok(x.newj));
  const incoherent = good.filter((x) => x.newj.factually_correct && x.newj.would_help_student === 1 && x.newj.actionable_move === 1).length;
  const ctrl = good.filter((x) => x.tier === 'CONTROL'); const caught = ctrl.filter((x) => x.newj.factually_correct === false || x.newj.faithful_to_response === false).length;
  const both = good.filter((x) => x.tier !== 'CONTROL' && gem(x) && ok(gem(x)));
  const agreeFlag = both.filter((x) => (x.newj.factually_correct === false) === (gem(x).factually_correct === false)).length;
  const flaggedByGem = both.filter((x) => gem(x).factually_correct === false); const alsoFlagged = flaggedByGem.filter((x) => x.newj.factually_correct === false).length;
  const diff = both.map((x) => Math.abs(x.newj.would_help_student - gem(x).would_help_student));
  report[model] = { n: rs.length, errors: rs.length - good.length, incoherent_all1_but_factual: incoherent, controls_caught: `${caught}/${ctrl.length}`, factual_flag_agreement_with_gemini: +(agreeFlag / Math.max(both.length, 1)).toFixed(3), gemini_flags_also_flagged: `${alsoFlagged}/${flaggedByGem.length}`, mean_abs_diff_would_help_vs_gemini: +(diff.reduce((a, b) => a + b, 0) / Math.max(diff.length, 1)).toFixed(2), mean_would_help: +(good.reduce((a, x) => a + x.newj.would_help_student, 0) / Math.max(good.length, 1)).toFixed(2), avg_cost_usd: +(good.reduce((a, x) => a + x.newj.cost, 0) / Math.max(good.length, 1)).toFixed(5) };
}
console.log(JSON.stringify({ spend: +spend.toFixed(4), texts: set.length, report }, null, 1));
