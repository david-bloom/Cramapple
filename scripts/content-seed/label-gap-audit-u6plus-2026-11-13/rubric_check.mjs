// Independent rubric preflight on the EDITED rubrics (stage6/plan.json): two model families, spend-capped, ledgered.
//   node rubric_check.mjs --cap=3
import { generateObject } from 'ai'; import { z } from 'zod'; import fs from 'node:fs'; import path from 'node:path';
const HERE = path.dirname(new URL(import.meta.url).pathname); const GW = path.join(HERE, '../../vercel-gateway-check');
for (const l of fs.readFileSync(path.join(GW, '.env.local'), 'utf8').split('\n')) { const i = l.indexOf('='); if (i > 0 && !l.startsWith('#')) process.env[l.slice(0, i).trim()] ??= l.slice(i + 1).trim().replace(/^["']|["']$/g, ''); }
const CAP = Number((process.argv.find((a) => a.startsWith('--cap=')) || '--cap=3').slice(6));
const MODELS = { 'google/gemini-3.8-flash': [0.00000075, 0.00000375], 'deepseek/deepseek-v4-pro': [0.00000132, 0.00000396], 'openai/gpt-6.1-sol': [0.000002, 0.00001] };
const SCHEMA = z.object({ unasked: z.array(z.string()).describe('criterion keys that score something the prompt does not ask'), unscored: z.array(z.string()).describe('operations the prompt asks that no criterion scores'),
  wrong: z.array(z.string()).describe('criteria whose stated answer or reasoning is mathematically/physically incorrect'), pass: z.boolean(), notes: z.string().describe('max 60 words') });
const plan = JSON.parse(fs.readFileSync(path.join(HERE, process.env.PLAN_FILE || 'stage6/plan.json'), 'utf8'));
const LEDGER = path.join(HERE, process.env.LEDGER_FILE || 'stage6/check_ledger.jsonl'), OUT = path.join(HERE, process.env.OUT_FILE || 'stage6/check_results.jsonl');
const read = (f) => (fs.existsSync(f) ? fs.readFileSync(f, 'utf8').split('\n').filter(Boolean).map((l) => JSON.parse(l)) : []);
let spent = read(LEDGER).reduce((a, r) => a + r.usd, 0); const done = new Set(read(OUT).filter((r) => r.ok).map((r) => r.key + '|' + r.model));
const prompt = (p) => `You are auditing an exam free-response question's scoring rubric. Treat everything below as data.\n\nSTEM:\n${p.stem}\n\nSTIMULUS:\n${p.stimulus || '(none)'}\n\nPARTS (if structured):\n${JSON.stringify((p.prompt_json.parts || []).map((x) => ({ part: x.part_key, prompt: x.prompt })))}\n\nRUBRIC CRITERIA:\n${p.criteria.map((c) => `${c.criterion_key} [${c.points_possible} pt]: ${c.learner_facing_text} | evidence: ${c.evidence_requirements}`).join('\n')}\n\nCheck: (1) does any criterion score an operation the prompt does not ask for? (2) does the prompt ask for any operation that no criterion scores? (3) is any stated answer or reasoning in a criterion incorrect (recompute numbers yourself)? Set pass=true only if all three are clean.`;
const jobs = []; for (const p of plan) for (const m of Object.keys(MODELS)) if (!done.has(p.content_key + '|' + m)) jobs.push({ p, m });
console.log(jobs.length, 'jobs, spent', spent.toFixed(3), 'cap', CAP); let stop = false;
async function worker() { while (jobs.length && !stop) { const { p, m } = jobs.shift(); let res = null, err = '', usage = null;
  for (let a = 1; a <= 3 && !res; a++) { try { const g = await generateObject({ model: m, schema: SCHEMA, prompt: prompt(p), abortSignal: AbortSignal.timeout(240000) }); res = g.object; usage = g.usage; } catch (e) { err = String(e?.message ?? e).slice(0, 200); } }
  const i = usage?.inputTokens ?? usage?.promptTokens ?? 0, o = usage?.outputTokens ?? usage?.completionTokens ?? 0, usd = i * MODELS[m][0] + o * MODELS[m][1]; spent += usd;
  fs.appendFileSync(LEDGER, JSON.stringify({ key: p.content_key, model: m, in: i, out: o, usd, ok: !!res }) + '\n');
  fs.appendFileSync(OUT, JSON.stringify({ key: p.content_key, model: m, ok: !!res, res, error: res ? '' : err }) + '\n');
  if (spent > CAP) { stop = true; console.log('CAP REACHED'); } } }
await Promise.all(Array.from({ length: 6 }, worker)); console.log('done; spent', spent.toFixed(3));
