import { generateText, generateObject } from 'ai';
import { z } from 'zod';
import fs from 'node:fs';
import path from 'node:path';

// Coaching-arc prototype (docs/product/COACHING_ARC_PLAN_DRAFT_2026_11_11.md, Phase 2).
// No student data is sent: items come from published content, misses are synthetic (every distractor of
// each sample item), and T2 histories are invented. Measures quality, tokens, cost and latency per tier.
// Usage: node proto.mjs <out_dir> [--budget=2]

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
const BUDGET = Number((rest.find((a) => a.startsWith('--budget=')) || '--budget=2').slice(9));
fs.mkdirSync(outDir, { recursive: true });

const GENERATORS = ['anthropic/claude-haiku-5.5', 'openai/gpt-6-luna', 'deepseek/deepseek-v4-flash'];
const JUDGES = ['google/gemini-3.8-flash', 'zai/glm-5.3-flash']; // never a generator family
const items = JSON.parse(fs.readFileSync(path.join(HERE, 'sample.json'), 'utf8'));

// ---- pricing -------------------------------------------------------------------------------
const res = await fetch('https://ai-gateway.vercel.sh/v1/models', { headers: { Authorization: `Bearer ${process.env.AI_GATEWAY_API_KEY}` } });
const PRICE = {};
for (const m of (await res.json()).data) {
  const p = m.pricing || {};
  PRICE[m.id] = { in: parseFloat(p.input) || 0, out: parseFloat(p.output) || 0, cacheRead: parseFloat(p.input_cache_read) || null };
}
for (const m of [...GENERATORS, ...JUDGES]) if (!PRICE[m]) { console.error('model missing from gateway roster:', m); process.exit(2); }
let spent = 0;
const cost = (model, u) => {
  const p = PRICE[model];
  const cached = u.cachedInputTokens ?? u.inputTokenDetails?.cacheReadTokens ?? 0;
  const inTok = u.inputTokens ?? 0;
  return (Math.max(inTok - cached, 0) * p.in + cached * (p.cacheRead ?? p.in) + (u.outputTokens ?? 0) * p.out);
};
const guard = () => { if (spent > BUDGET) { console.error('budget exceeded', spent); process.exit(3); } };

// ---- prompts -------------------------------------------------------------------------------
const RULES = `You are the coach inside Cramapple, an AP exam-prep app. A student just answered a multiple-choice question incorrectly. The verdict ("Incorrect") is already shown; you write the coaching shown beneath it.
Rules:
- Second person, present tense. Concise: at most 90 words. A longer idea, vocabulary term, formula or diagram may be referenced by name, not re-taught.
- Connect the miss to the exam point it cost: name the rubric habit or point (from the point brief) that the student's choice broke, then say what to do next in one concrete move.
- Name the specific reasoning trap behind the choice the student picked. Do not just restate the rationale; explain it in your own words for this student.
- You may state the correct answer and why, because the answer is revealed after grading.
- No exclamation marks. Praise only if STUDENT STATE says it is earned. Encouragement only if STUDENT STATE says so, and follow its framing. At most one emoji in the whole message, and none is fine.
- Never state anything the item, its rationales or the point brief do not support. If unsure, say less.
- Output only the coaching text.`;

const itemBlock = (it) => `SUBJECT: ${it.subject}\nTOPIC: ${it.topic}\nQUESTION:\n${it.stem}\nCHOICES (with the authored rationale for each):\n${it.choices.map((c) => `${c.k}. ${c.t}${c.ok ? '  [CORRECT]' : ''}\n   rationale: ${c.r}`).join('\n')}\nPOINT BRIEF:\n- How points are earned: ${it.brief.earned}\n- Answer move: ${it.brief.move}\n- Common point loss: ${it.brief.loss}\nTOPIC EXPLAINER (core idea): ${it.core}`;

const t1User = (it, k) => `${itemBlock(it)}\n\nSTUDENT PICKED: ${k}\nSTUDENT STATE: first miss on this kind of question; no history. No praise, no encouragement.`;
const t2User = (it, k, hist) => `${itemBlock(it)}\n\nSTUDENT PICKED: ${k}\nSTUDENT STATE: ${hist.state}\nHISTORY: ${hist.history}`;

const T2_CASES = [
  { id: 'APSTATS-MCQ-H-4.5-A', pick: 'B', kind: 'repeat', state: 'Struggling: third miss this session on the same slip. Give encouragement framed as persistence (they keep trying), then a different angle than the history below.', history: 'Previous two misses this session were also tail-count errors (two-sided versus one-sided). They opened the rubric hint on the last one. The last coaching said: "The alternative hypothesis decides how many tails count."' },
  { id: 'APBIO-MCQ-136', pick: 'A', kind: 'cross-session', state: 'No improvement but the student is trying again. Give encouragement framed as persistence, and do not repeat the earlier explanation.', history: 'Missed this misconception (membrane proteins always mean active transport) in two earlier sessions. Last time they were told gradient direction decides it. They have asked for no extra help.' },
  { id: 'apstats-mcq-b6-h-1.12-a', pick: 'A', kind: 'improving', state: 'Improving without full credit: earlier they mislabeled the bias type, now they name nonresponse bias correctly but get the direction wrong. Give encouragement framed as progress, then fix only the direction.', history: 'Earlier attempt on a similar item: chose voluntary response bias. This attempt: nonresponse bias, wrong direction.' },
  { id: 'APBIO-MCQ-128', pick: 'C', kind: 'explain-more', state: 'The student pressed "Explain more" after seeing the first coaching; it counts as a hint. Add a new angle, not a repeat. No praise.', history: 'First coaching already said: oxygen comes from water, not CO2. Student still seems confused about which stage makes what.' },
];

// ---- run -----------------------------------------------------------------------------------
const rows = [];
const results = fs.createWriteStream(path.join(outDir, 'results.jsonl'));
const log = (r) => { rows.push(r); results.write(JSON.stringify(r) + '\n'); };

async function pool(tasks, n) {
  let i = 0;
  await Promise.all(Array.from({ length: n }, async () => { while (i < tasks.length) { const t = tasks[i++]; await t(); } }));
}

async function gen(model, system, user, meta) {
  const t0 = Date.now();
  for (let a = 0; a < 2; a++) {
    try {
      const r = await generateText({ model, system, prompt: user, maxOutputTokens: 4000, temperature: 0.4 });
      const c = cost(model, r.usage);
      spent += c; guard();
      return { ...meta, kind: 'gen', model, text: r.text.trim(), words: r.text.trim().split(/\s+/).length, in: r.usage.inputTokens, out: r.usage.outputTokens, cached: r.usage.cachedInputTokens ?? 0, reasoning: r.usage.reasoningTokens ?? r.usage.outputTokenDetails?.reasoningTokens ?? 0, cost: c, ms: Date.now() - t0 };
    } catch (e) { if (a) return { ...meta, kind: 'gen', model, error: String(e).slice(0, 200) }; }
  }
}

const genTasks = [];
for (const it of items) {
  for (const c of it.choices.filter((x) => !x.ok)) {
    for (const model of GENERATORS) genTasks.push(async () => log(await gen(model, RULES, t1User(it, c.k), { tier: 'T1', item: it.id, pick: c.k })));
  }
}
for (const t of T2_CASES) {
  const it = items.find((x) => x.id === t.id);
  for (const model of GENERATORS) genTasks.push(async () => log(await gen(model, RULES, t2User(it, t.pick, t), { tier: 'T2', item: t.id, pick: t.pick, case: t.kind })));
}
await pool(genTasks, 6);
const gens = rows.filter((r) => r.kind === 'gen' && r.text);
const emptyGens = rows.filter((r) => r.kind === 'gen' && !r.text).length;

// T0 floor: TASK-0053-style composed text (authored rationale of the chosen choice, then a question), no model.
const t0 = [];
for (const it of items) for (const c of it.choices.filter((x) => !x.ok)) t0.push({ tier: 'T0', item: it.id, pick: c.k, model: 'none', text: `Not quite. Look again at the choice you picked: ${c.r.replace(/^[A-Za-z–\- ]+: /, '')} How would you answer it now?`, cost: 0 });

// planted wrong-teaching controls: judges must mark these not factually correct.
const CONTROLS = [
  { item: 'APSTATS-MCQ-H-2.8-A', pick: 'B', text: 'Your 0.3 is P(X ≥ 3). Add k + 2k to get it: the probabilities for the larger values are the smaller ones, so 0.3 is right and the key is wrong.' },
  { item: 'apbio-mcq-b4-h-4.4-a', pick: 'B', text: 'You are right that low cortisol lowers ACTH, because cortisol stimulates the pituitary. This is positive feedback, so the loop amplifies the change.' },
  { item: 'APBIO-MCQ-136', pick: 'B', text: 'Moving into a cell always means moving against the gradient, so inward transport is active. The outside concentration being higher does not matter.' },
  { item: 'APSTATS-MCQ-H-4.5-A', pick: 'D', text: 'A p-value of 0.03 does mean there is a 3% chance the mean is 250 mg, so your reading is correct; the key mislabels it.' },
].map((c) => ({ tier: 'CONTROL', model: 'planted', cost: 0, ...c }));

// ---- judging -------------------------------------------------------------------------------
const JUDGE = z.object({
  factually_correct: z.boolean().describe('false if ANY statement contradicts the question, the key, the rationales or the point brief'),
  contradiction: z.string().describe('empty if none'),
  specific_to_pick: z.number().describe('addresses the reasoning trap behind the picked choice, not generic advice'),
  names_exam_point: z.number().describe('names the rubric habit or point the miss cost'),
  actionable_move: z.number().describe('gives one concrete next action'),
  tone_ok: z.boolean().describe('no exclamation marks, at most one emoji, no unearned praise, respects the STUDENT STATE'),
  uses_history: z.number().describe('0 if no history was supplied; otherwise how well it responds to history without repeating earlier coaching'),
  would_help_student: z.number(),
});
const JUDGE_SYS = 'You are a strict AP teacher auditing coaching text written for a student who answered a multiple-choice question wrong. Judge only what you are shown. The authored rationales and point brief are ground truth; recompute any arithmetic yourself.';
const judgeUser = (it, r, hist) => `${itemBlock(it)}\n\nSTUDENT PICKED: ${r.pick}\n${hist ? `STUDENT STATE: ${hist.state}\nHISTORY: ${hist.history}\n` : 'STUDENT STATE: first miss; no history.\n'}\nCOACHING TEXT TO JUDGE:\n"""${r.text}"""`;

const judged = [...gens, ...t0, ...CONTROLS];
const jTasks = [];
for (const r of judged) {
  const it = items.find((x) => x.id === r.item);
  const hist = r.tier === 'T2' ? T2_CASES.find((t) => t.kind === r.case) : null;
  r.judgements = [];
  for (const jm of JUDGES) {
    jTasks.push(async () => {
      for (let a = 0; a < 2; a++) {
        try {
          const o = await generateObject({ model: jm, schema: JUDGE, system: JUDGE_SYS, prompt: judgeUser(it, r, hist), temperature: 0, maxOutputTokens: 4000 });
          const c = cost(jm, o.usage); spent += c; guard();
          r.judgements.push({ judge: jm, ...o.object, cost: c });
          return;
        } catch (e) { if (a) r.judgements.push({ judge: jm, error: String(e).slice(0, 160) }); }
      }
    });
  }
}
await pool(jTasks, 8);

fs.writeFileSync(path.join(outDir, 'judged.json'), JSON.stringify(judged, null, 1));

// ---- summary -------------------------------------------------------------------------------
const mean = (a, d = 2) => (a.length ? +(a.reduce((x, y) => x + y, 0) / a.length).toFixed(d) : null);
const ok = (r) => r.judgements.filter((j) => !j.error);
const sum = {};
for (const key of new Set(judged.map((r) => `${r.tier}|${r.model}`))) {
  const [tier, model] = key.split('|');
  const rs = judged.filter((r) => r.tier === tier && r.model === model);
  const js = rs.flatMap(ok);
  sum[key] = {
    n: rs.length,
    factual_fail_rate: js.length ? +(js.filter((j) => !j.factually_correct).length / js.length).toFixed(3) : null,
    both_judges_pass_rate: +(rs.filter((r) => ok(r).length === JUDGES.length && ok(r).every((j) => j.factually_correct && j.tone_ok)).length / rs.length).toFixed(3),
    specific: mean(js.map((j) => j.specific_to_pick)), names_point: mean(js.map((j) => j.names_exam_point)), move: mean(js.map((j) => j.actionable_move)), helps: mean(js.map((j) => j.would_help_student)),
    uses_history: tier === 'T2' ? mean(js.map((j) => j.uses_history)) : undefined,
    avg_words: mean(rs.filter((r) => r.words).map((r) => r.words)),
    avg_in: mean(rs.filter((r) => r.in != null).map((r) => r.in)), avg_out: mean(rs.filter((r) => r.out != null).map((r) => r.out)), avg_reasoning: mean(rs.filter((r) => r.reasoning != null).map((r) => r.reasoning)),
    avg_cost_usd: mean(rs.filter((r) => r.cost != null).map((r) => r.cost), 6), avg_ms: mean(rs.filter((r) => r.ms).map((r) => r.ms)),
    gen_errors: rows.filter((r) => r.kind === 'gen' && r.error && r.model === model && r.tier === tier).length,
  };
}
const controlsCaught = CONTROLS.map((c) => ({ item: c.item, caught_by: c.judgements.filter((j) => !j.error && !j.factually_correct).length, of: c.judgements.length }));
const judgeErrors = Object.fromEntries(JUDGES.map((jm) => [jm, judged.flatMap((r) => r.judgements).filter((j) => j.judge === jm && j.error).length]));
fs.writeFileSync(path.join(outDir, 'summary.json'), JSON.stringify({ emptyGens, judgeErrors, spent_usd: +spent.toFixed(4), budget_usd: BUDGET, summary: sum, controlsCaught }, null, 1));
console.log(JSON.stringify({ spent_usd: +spent.toFixed(4), summary: sum, controlsCaught }, null, 1));
