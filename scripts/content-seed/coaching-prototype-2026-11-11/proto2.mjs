import { generateText, generateObject } from 'ai';
import { z } from 'zod';
import fs from 'node:fs';
import path from 'node:path';

// Coaching-arc prototype, second pass: 30 MCQs (T1 + some T2) and 10 FRQs (synthetic student responses with
// known missed criteria). No student data is sent. Usage: node proto2.mjs <out_dir> [--budget=5]

const HERE = path.dirname(new URL(import.meta.url).pathname);
const GATE = path.resolve(HERE, '../../vercel-gateway-check');
for (const raw of fs.readFileSync(path.join(GATE, '.env.local'), 'utf8').split(/\r?\n/)) {
  const l = raw.trim();
  if (!l || l.startsWith('#') || !l.includes('=')) continue;
  const i = l.indexOf('=');
  const k = l.slice(0, i).trim();
  if (!(k in process.env)) process.env[k] = l.slice(i + 1).trim().replace(/^["']|["']$/g, '');
}
const [outDir, ...rest] = process.argv.slice(2);
const BUDGET = Number((rest.find((a) => a.startsWith('--budget=')) || '--budget=5').slice(9));
fs.mkdirSync(outDir, { recursive: true });

const GENERATORS = ['anthropic/claude-haiku-5.5', 'openai/gpt-6-luna', 'deepseek/deepseek-v4-flash'];
const JUDGES = ['google/gemini-3.8-flash', 'zai/glm-5.3-flash'];
const RESPONDER = 'anthropic/claude-haiku-5.5'; // writes synthetic student FRQ responses (not judged)
const mcq = JSON.parse(fs.readFileSync(path.join(HERE, 'mcq30.json'), 'utf8'));
const frq = JSON.parse(fs.readFileSync(path.join(HERE, 'frq10.json'), 'utf8'));
const firstSample = JSON.parse(fs.readFileSync(path.join(HERE, 'sample.json'), 'utf8'));

// ---- pricing -------------------------------------------------------------------------------
const res = await fetch('https://ai-gateway.vercel.sh/v1/models', { headers: { Authorization: `Bearer ${process.env.AI_GATEWAY_API_KEY}` } });
const PRICE = {};
for (const m of (await res.json()).data) {
  const p = m.pricing || {};
  PRICE[m.id] = { in: parseFloat(p.input) || 0, out: parseFloat(p.output) || 0, cacheRead: parseFloat(p.input_cache_read) || null };
}
for (const m of [...GENERATORS, ...JUDGES, RESPONDER]) if (!PRICE[m]) { console.error('model missing from roster:', m); process.exit(2); }
const spend = { gen: 0, judge: 0, resp: 0, judgeCalls: 0 };
const total = () => spend.gen + spend.judge + spend.resp;
const cost = (model, u) => {
  const p = PRICE[model];
  const cached = u.cachedInputTokens ?? u.inputTokenDetails?.cacheReadTokens ?? 0;
  return Math.max((u.inputTokens ?? 0) - cached, 0) * p.in + cached * (p.cacheRead ?? p.in) + (u.outputTokens ?? 0) * p.out;
};
const guard = () => { if (total() > BUDGET) { console.error('budget exceeded', total()); process.exit(3); } };

// ---- prompts -------------------------------------------------------------------------------
const COMMON = `Rules:
- Second person, present tense. Concise. A longer idea, vocabulary term, formula or diagram may be referenced by name, not re-taught.
- Connect the miss to the exam point it cost: name the rubric habit or point (from the point brief or rubric) and say what to do next in one concrete move.
- Name the specific reasoning trap or gap. Do not just restate the authored rationale; explain it in your own words for this student.
- No exclamation marks. Praise only if STUDENT STATE says it is earned. Encouragement only if STUDENT STATE says so, and follow its framing. At most one emoji in the whole message; none is fine.
- Never state anything the item, its rationales, the rubric or the point brief do not support. Do not invent facts about the question or the student's work. If unsure, say less.
- Output only the coaching text.`;
const MCQ_RULES = `You are the coach inside Cramapple, an AP exam-prep app. A student just answered a multiple-choice question; the verdict ("Correct"/"Incorrect") is already shown and you write the coaching beneath it. Hard limit: 80 words.\n${COMMON}\n- You may state the correct answer and why, because the answer is revealed after grading.`;
const FRQ_RULES = `You are the coach inside Cramapple, an AP exam-prep app. A student just submitted a free-response answer that was graded per rubric criterion; the score is already shown and you write the coaching beneath it. Hard limit: 110 words.\n${COMMON}\n- Read the student's actual response. Point to what they wrote or left out, in their own words where useful. Never say they omitted something they wrote, and never credit something they did not write.\n- You may state in plain fact what they earned (this is not praise). Focus coaching on the missed criteria.`;

const mcqBlock = (it) => `SUBJECT: ${it.subject}\nTOPIC: ${it.topic}\nQUESTION:\n${it.stem}\nCHOICES (with the authored rationale for each):\n${it.choices.map((c) => `${c.k}. ${c.t}${c.ok ? '  [CORRECT]' : ''}\n   rationale: ${c.r}`).join('\n')}\nPOINT BRIEF:\n- How points are earned: ${it.brief.earned}\n- Answer move: ${it.brief.move}\n- Common point loss: ${it.brief.loss}\nTOPIC EXPLAINER (core idea): ${it.core || ''}`;
const frqBlock = (it) => `SUBJECT: ${it.subject}\nTOPIC: ${it.topic}\nQUESTION:\n${it.prompt}${it.stimulus ? `\nSTIMULUS:\n${it.stimulus}` : ''}\nRUBRIC CRITERIA (key, points, what earns it, the authored minimum fix):\n${it.criteria.map((c) => `- ${c.key} (${c.points} pt): ${c.text}  | fix: ${c.fix}`).join('\n')}\nPOINT BRIEF:\n- How points are earned: ${it.brief.earned}\n- Answer move: ${it.brief.move}\n- Common point loss: ${it.brief.loss}\nTOPIC EXPLAINER (core idea): ${it.core || ''}`;

const T1_STATE = 'first miss on this kind of question; no history. No praise, no encouragement.';
const T2_KINDS = [
  { kind: 'repeat', wrong: true, state: 'Struggling: third miss this session on the same slip. Give encouragement framed as persistence (they keep trying), then a different angle than the history.', history: 'The previous two misses this session were the same kind of slip. They opened the rubric hint on the last one. The last coaching restated the authored rationale.' },
  { kind: 'cross-session', wrong: true, state: 'No improvement but the student is trying again. Give encouragement framed as persistence, and do not repeat the earlier explanation.', history: 'Missed this same misconception in two earlier sessions and was told to check the key condition first.' },
  { kind: 'improving', wrong: true, state: 'Improving without full credit: they fixed an earlier slip but have a new one on the same topic. Give encouragement framed as progress, then fix only the new slip.', history: 'Earlier attempt on a similar item: a different error. This attempt: a different distractor.' },
  { kind: 'explain-more', wrong: true, state: 'The student pressed "Explain more" after the first coaching; it counts as a hint. Add a new angle, not a repeat. No praise.', history: 'The first coaching already stated the main correction. The student still seems unsure.' },
  { kind: 'praise', wrong: false, state: 'Praise is earned: the student missed this cell earlier and is now correct. Give one short, specific praise, then one sentence reinforcing why the reasoning works. No encouragement.', history: 'Missed this topic on two previous attempts; first correct answer now.' },
];

const rows = [];
const results = fs.createWriteStream(path.join(outDir, 'results.jsonl'));
const log = (r) => { rows.push(r); results.write(JSON.stringify(r) + '\n'); };
async function pool(tasks, n) { let i = 0; await Promise.all(Array.from({ length: n }, async () => { while (i < tasks.length) await tasks[i++](); })); }

async function call(model, system, user, meta, maxOut = 4000) {
  const t0 = Date.now();
  for (let a = 0; a < 2; a++) {
    try {
      const r = await generateText({ model, system, prompt: user, maxOutputTokens: maxOut, temperature: 0.4 });
      const c = cost(model, r.usage);
      if (meta.role === 'resp') spend.resp += c; else spend.gen += c;
      guard();
      const text = r.text.trim();
      return { ...meta, model, text, words: text ? text.split(/\s+/).length : 0, in: r.usage.inputTokens, out: r.usage.outputTokens, cached: r.usage.cachedInputTokens ?? 0, reasoning: r.usage.reasoningTokens ?? r.usage.outputTokenDetails?.reasoningTokens ?? 0, cost: c, ms: Date.now() - t0 };
    } catch (e) { if (a) return { ...meta, model, error: String(e).slice(0, 200) }; }
  }
}
const emojiCount = (t) => (t.match(/\p{Extended_Pictographic}/gu) || []).length;
const lint = (r) => (!r.text ? ['empty'] : [r.words > (r.item_type === 'frq' ? 110 : 80) + 10 ? 'too_long' : null, /!/.test(r.text) ? 'exclamation' : null, emojiCount(r.text) > 1 ? 'emoji>1' : null].filter(Boolean));

// ---- FRQ synthetic responses (known missed criteria by construction) -----------------------
const frqCases = [];
await pool(frq.map((it, idx) => async () => {
  const nMiss = idx % 2 === 0 ? 1 : 2;
  const order = [...it.criteria].sort((a, b) => (a.key > b.key ? 1 : -1));
  const missed = order.filter((_, i) => (i * 7 + idx) % order.length < nMiss).slice(0, nMiss);
  const earned = it.criteria.filter((c) => !missed.includes(c));
  const sys = 'You write realistic, imperfect AP student free-response answers for testing a coaching tool. Plain prose, 60-160 words, no headings, no meta commentary, written the way a decent but rushed student writes.';
  const user = `${frqBlock({ ...it, brief: { earned: '', move: '', loss: '' } })}\n\nWrite the student's answer so that it CLEARLY earns these criteria: ${earned.map((c) => c.key).join(', ') || 'none'}; and clearly does NOT earn these (leave the idea out entirely or get it wrong in a typical way): ${missed.map((c) => c.key).join(', ')}.`;
  const r = await call(RESPONDER, sys, user, { role: 'resp', item: it.id });
  if (r?.text) frqCases.push({ it, missed: missed.map((c) => c.key), earned: earned.map((c) => c.key), response: r.text });
}), 5);
fs.writeFileSync(path.join(outDir, 'frq_cases.json'), JSON.stringify(frqCases, null, 1));

// ---- generation ---------------------------------------------------------------------------
const tasks = [];
for (const it of mcq) {
  for (const c of it.choices.filter((x) => !x.ok)) {
    for (const model of GENERATORS) tasks.push(async () => log(await call(model, MCQ_RULES, `${mcqBlock(it)}\n\nSTUDENT PICKED: ${c.k}\nSTUDENT STATE: ${T1_STATE}`, { tier: 'T1', item_type: 'mcq', item: it.id, pick: c.k })));
  }
}
mcq.slice(0, 10).forEach((it, i) => {
  const t = T2_KINDS[i % T2_KINDS.length];
  const pick = (t.wrong ? it.choices.find((x) => !x.ok) : it.choices.find((x) => x.ok)).k;
  for (const model of GENERATORS) tasks.push(async () => log(await call(model, MCQ_RULES, `${mcqBlock(it)}\n\nSTUDENT PICKED: ${pick}\nSTUDENT STATE: ${t.state}\nHISTORY: ${t.history}`, { tier: 'T2', item_type: 'mcq', item: it.id, pick, case: t.kind })));
});
for (const fc of frqCases) {
  const crit = fc.it.criteria.map((c) => `- ${c.key}: ${fc.missed.includes(c.key) ? 'MISSED (0 pts)' : 'EARNED'}`).join('\n');
  for (const model of GENERATORS) tasks.push(async () => log(await call(model, FRQ_RULES, `${frqBlock(fc.it)}\n\nSTUDENT RESPONSE:\n"""${fc.response}"""\nGRADING RESULT PER CRITERION:\n${crit}\nSTUDENT STATE: first attempt on this question; partial credit. No praise; no encouragement.`, { tier: 'FRQ', item_type: 'frq', item: fc.it.id, pick: fc.missed.join('+') })));
}
await pool(tasks, 8);
const gens = rows.filter((r) => r.text !== undefined && r.role !== 'resp');
for (const r of gens) r.lint = lint(r);

// T0 floor for MCQ (approximation of TASK-0053 composition)
const t0 = [];
for (const it of mcq) for (const c of it.choices.filter((x) => !x.ok)) t0.push({ tier: 'T0', item_type: 'mcq', item: it.id, pick: c.k, model: 'none', text: `Not quite. Look again at the choice you picked: ${c.r} How would you answer it now?`, cost: 0, lint: [] });
// FRQ T0 floor: the authored fix lines of the missed criteria
for (const fc of frqCases) t0.push({ tier: 'T0', item_type: 'frq', item: fc.it.id, pick: fc.missed.join('+'), model: 'none', text: `You lost the following: ${fc.it.criteria.filter((c) => fc.missed.includes(c.key)).map((c) => c.fix).join(' ')}`, cost: 0, lint: [] });

// planted controls
const CONTROLS = [
  { item_type: 'mcq', item: 'APSTATS-MCQ-H-2.8-A', pick: 'B', text: 'Your 0.3 is P(X ≥ 3). Add k + 2k to get it: the probabilities for the larger values are the smaller ones, so 0.3 is right and the key is wrong.' },
  { item_type: 'mcq', item: 'apbio-mcq-b4-h-4.4-a', pick: 'B', text: 'You are right that low cortisol lowers ACTH, because cortisol stimulates the pituitary. This is positive feedback, so the loop amplifies the change.' },
  { item_type: 'mcq', item: 'APBIO-MCQ-136', pick: 'B', text: 'Moving into a cell always means moving against the gradient, so inward transport is active. The outside concentration being higher does not matter.' },
  { item_type: 'mcq', item: 'APSTATS-MCQ-H-4.5-A', pick: 'D', text: 'A p-value of 0.03 does mean there is a 3% chance the mean is 250 mg, so your reading is correct; the key mislabels it.' },
  ...frqCases.slice(0, 3).map((fc) => ({ item_type: 'frq', item: fc.it.id, pick: fc.missed.join('+'), text: `You left out this idea, so you lost the point: ${fc.it.criteria.find((c) => fc.earned.includes(c.key))?.text}`, control_kind: 'claims earned criterion missed' })),
].map((c) => ({ tier: 'CONTROL', model: 'planted', cost: 0, lint: [], ...c }));

// ---- judging ------------------------------------------------------------------------------
const BASE = { factually_correct: z.boolean().describe('false if ANY statement contradicts the question, key, rationales, rubric or point brief'), contradiction: z.string(), tone_ok: z.boolean().describe('no exclamation marks, at most one emoji, no unearned praise, respects STUDENT STATE'), would_help_student: z.number().describe('1-5'), actionable_move: z.number().describe('1-5, one concrete next action') };
const MCQ_JUDGE = z.object({ ...BASE, specific_to_pick: z.number().describe('1-5'), names_exam_point: z.number().describe('1-5'), uses_history: z.number().describe('0 if no history supplied, else 1-5') });
const FRQ_JUDGE = z.object({ ...BASE, targets_missed_criteria: z.number().describe('1-5: addresses the criteria marked MISSED'), faithful_to_response: z.boolean().describe('false if it claims the student omitted something they wrote or credits something they did not write'), label_consistent: z.boolean().describe('true if the MISSED/EARNED labels actually match the student response against the rubric') });
const JSYS = 'You are a strict AP teacher auditing coaching text written for a student. Judge only what you are shown. The authored rationales, rubric and point brief are ground truth; recompute arithmetic yourself.';
const find = (id) => mcq.find((x) => x.id === id) || firstSample.find((x) => x.id === id);
const judged = [...gens, ...t0, ...CONTROLS];
const jt = [];
for (const r of judged) {
  r.judgements = [];
  let prompt, schema;
  if (r.item_type === 'frq') {
    const fc = frqCases.find((x) => x.it.id === r.item);
    if (!fc) continue;
    const crit = fc.it.criteria.map((c) => `- ${c.key}: ${fc.missed.includes(c.key) ? 'MISSED' : 'EARNED'}`).join('\n');
    prompt = `${frqBlock(fc.it)}\n\nSTUDENT RESPONSE:\n"""${fc.response}"""\nGRADING LABELS:\n${crit}\nSTUDENT STATE: first attempt; partial credit. No praise or encouragement.\n\nCOACHING TEXT TO JUDGE:\n"""${r.text}"""`; schema = FRQ_JUDGE;
  } else {
    const it = find(r.item); if (!it) continue;
    const t2 = r.tier === 'T2' ? T2_KINDS.find((k) => k.kind === r.case) : null;
    prompt = `${mcqBlock(it)}\n\nSTUDENT PICKED: ${r.pick}\n${t2 ? `STUDENT STATE: ${t2.state}\nHISTORY: ${t2.history}` : `STUDENT STATE: ${T1_STATE}`}\n\nCOACHING TEXT TO JUDGE:\n"""${r.text}"""`; schema = MCQ_JUDGE;
  }
  for (const jm of JUDGES) jt.push(async () => {
    for (let a = 0; a < 2; a++) {
      try {
        const o = await generateObject({ model: jm, schema, system: JSYS, prompt, temperature: 0, maxOutputTokens: 4000 });
        const c = cost(jm, o.usage); spend.judge += c; spend.judgeCalls++; guard();
        r.judgements.push({ judge: jm, ...o.object, cost: c }); return;
      } catch (e) { if (a) r.judgements.push({ judge: jm, error: String(e).slice(0, 160) }); }
    }
  });
}
await pool(jt, 10);
fs.writeFileSync(path.join(outDir, 'judged.json'), JSON.stringify(judged, null, 1));

// ---- summary ------------------------------------------------------------------------------
const mean = (a, d = 2) => (a.length ? +(a.reduce((x, y) => x + y, 0) / a.length).toFixed(d) : null);
const okj = (r) => r.judgements.filter((j) => !j.error);
const flagged = (r) => okj(r).some((j) => !j.factually_correct || j.faithful_to_response === false);
const summary = {};
for (const key of new Set(judged.map((r) => `${r.tier}|${r.item_type}|${r.model}`))) {
  const [tier, type, model] = key.split('|');
  const rs = judged.filter((r) => r.tier === tier && r.item_type === type && r.model === model);
  const js = rs.flatMap(okj);
  summary[key] = {
    n: rs.length,
    any_judge_flag_rate: +(rs.filter(flagged).length / rs.length).toFixed(3),
    both_judges_clean_and_tone_ok: +(rs.filter((r) => okj(r).length === JUDGES.length && !flagged(r) && okj(r).every((j) => j.tone_ok)).length / rs.length).toFixed(3),
    lint_fail_rate: +(rs.filter((r) => r.lint?.length).length / rs.length).toFixed(3),
    would_help: mean(js.map((j) => j.would_help_student)), move: mean(js.map((j) => j.actionable_move)),
    specific: mean(js.filter((j) => j.specific_to_pick != null).map((j) => j.specific_to_pick)), names_point: mean(js.filter((j) => j.names_exam_point != null).map((j) => j.names_exam_point)),
    targets_missed: mean(js.filter((j) => j.targets_missed_criteria != null).map((j) => j.targets_missed_criteria)),
    uses_history: tier === 'T2' ? mean(js.map((j) => j.uses_history)) : undefined,
    avg_words: mean(rs.filter((r) => r.words).map((r) => r.words), 1), avg_out: mean(rs.filter((r) => r.out != null).map((r) => r.out), 0), avg_reasoning: mean(rs.filter((r) => r.reasoning != null).map((r) => r.reasoning), 0),
    avg_cost_usd: mean(rs.filter((r) => r.cost != null && r.model !== 'none' && r.model !== 'planted').map((r) => r.cost), 6), avg_ms: mean(rs.filter((r) => r.ms).map((r) => r.ms), 0),
    gen_errors: rows.filter((r) => r.error && `${r.tier}|${r.item_type}|${r.model}` === key).length,
  };
}
const controls = judged.filter((r) => r.tier === 'CONTROL').map((r) => ({ item: r.item, type: r.item_type, caught_by: okj(r).filter((j) => !j.factually_correct || j.faithful_to_response === false).length, of: r.judgements.length }));
const frqLabel = judged.filter((r) => r.tier === 'FRQ').flatMap((r) => okj(r).map((j) => j.label_consistent)).filter((x) => x != null);
const out = { spend: { generation_usd: +spend.gen.toFixed(4), responses_usd: +spend.resp.toFixed(4), judging_usd: +spend.judge.toFixed(4), judge_calls: spend.judgeCalls, avg_judge_call_usd: +(spend.judge / Math.max(spend.judgeCalls, 1)).toFixed(5), total_usd: +total().toFixed(4), budget_usd: BUDGET }, generated: gens.length, empty: gens.filter((r) => !r.text).length, frq_cases: frqCases.length, frq_label_consistent_rate: frqLabel.length ? +(frqLabel.filter(Boolean).length / frqLabel.length).toFixed(3) : null, controls, summary };
fs.writeFileSync(path.join(outDir, 'summary.json'), JSON.stringify(out, null, 1));
console.log(JSON.stringify(out, null, 1));
