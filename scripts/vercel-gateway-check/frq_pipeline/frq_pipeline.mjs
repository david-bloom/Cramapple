// FRQ gap-fill pipeline for Units 1-3 (content authoring protocol v0.6: FRQs follow sections 4-6 and 9; seeded
// protocol class A for topics that already have one FRQ). Nothing is written to any database.
//
// Per slot (one missing FRQ on one topic), up to --rounds candidates, each accepted whole or rejected whole (no edits):
//   1. author      Claude Opus 5.5 (non-OpenAI: the model answer must not be written by the grader's family)
//   2. lint        deterministic rules (rubric.mjs)
//   3. recompute   the author's sympy script, run in an empty directory with an import allowlist
//   4. topic vote  runbook six-vote probe (gemini-3.8-flash, deepseek-v4-pro, gpt-6.1-sol x2): >=5 of 6 on the target
//                  topic, and no required unit later than the topic's unit
//   5. checkers    each checker solves blind, then audits scope (section 4) and re-derives the rubric (section 9);
//                  a flag counts only if it repeats on one re-sample. OpenAI checkers never see the model answer.
//
//   node frq_pipeline.mjs run    --batch=<dir> --checkers=<m1,m2> [--subjects=a,b] [--topics=sk:code,..] [--rounds=3] [--conc=6] [--first-only]
//   node frq_pipeline.mjs report --batch=<dir>
import fs from 'node:fs';
import path from 'node:path';
import os from 'node:os';
import { spawnSync } from 'node:child_process';
import { z } from 'zod';
import { call, scopedPack, setCallLog } from '../teaching_pipeline/run.mjs';
import { SPEC, RULES_TEXT, AUTHOR_SCHEMA, SOLVE_SCHEMA, auditSchema, lint } from './rubric.mjs';

const arg = (n, d = '') => (process.argv.slice(3).find((a) => a.startsWith(`--${n}=`)) || '').slice(n.length + 3) || d;
const flag = (n) => process.argv.includes(`--${n}`);
const AUTHOR = 'anthropic/claude-opus-5.5';
const PROBE_MODELS = ['google/gemini-3.8-flash', 'deepseek/deepseek-v4-pro', 'openai/gpt-6.1-sol'];
const RUN_KEY = { ap_biology: 'biology' };
const runKey = (sk) => RUN_KEY[sk] ?? sk.replace(/_/g, '-');
const LETTERS = 'abcdefgh';
const readJson = (p, d) => (fs.existsSync(p) ? JSON.parse(fs.readFileSync(p, 'utf8')) : d);
const writeJson = (p, v) => { fs.mkdirSync(path.dirname(p), { recursive: true }); fs.writeFileSync(p, JSON.stringify(v, null, 1)); };

// ---------------------------------------------------------------- inputs
function loadInputs(batch) {
  const I = (f) => JSON.parse(fs.readFileSync(path.join(batch, 'inputs', f), 'utf8'));
  const seedData = I('seed_items.json');
  return { slots: I('slots.json'), ced: I('ced_topic_excerpts.json'), tax: I('taxonomy_topics.json'),
    items: Object.fromEntries(seedData.items.map((x) => [x.content_key, x])), exemplars: seedData.exemplars };
}
const U13 = { ap_physics_2: [9, 10, 11], ap_physics_c_em: [8, 9, 10] };
const u13 = (sk) => U13[sk] ?? [1, 2, 3];
function unitTopicList(IN, sk) {
  return IN.tax.filter((t) => t.sk === sk && u13(sk).includes(t.u)).map((t) => `${t.c} ${t.t} (Unit ${t.u}: ${t.ut})`).join('\n');
}
function itemText(it, { rubric = true, answer = true } = {}) {
  const parts = it.parts.map((p, i) => `(${LETTERS[i]}) ${p.prompt}` + (rubric ? '\n' + p.criteria.map((c, j) =>
    `   Criterion ${LETTERS[i]}${j + 1} (1 point): ${c.text}\n      Evidence: ${c.evidence}\n      Fix: ${c.fix}${c.accepted_variants?.length ? `\n      Equivalent forms of the key value (the evidence requirement still applies): ${c.accepted_variants.join('; ')}` : ''}`).join('\n') : '')).join('\n');
  return `Title: ${it.title}\nCalculator: ${it.calculator}\n\nSetup:\n${it.stimulus}\n\nParts:\n${parts}` + (answer ? `\n\nModel answer:\n${it.model_answer}` : '');
}
function storedText(x) { // an existing published FRQ, as stored
  const crit = (x.criteria || []).map((c) => `   - ${c.text}`).join('\n');
  return `${x.title ? `Title: ${x.title}\n` : ''}${x.stimulus ? `Setup:\n${x.stimulus}\n` : ''}Question:\n${x.stem}\nScoring criteria:\n${crit}`;
}
function existingFor(IN, slot, siblings) {
  const ex = slot.existing.map((k) => IN.items[k]).filter(Boolean).map(storedText);
  const sib = siblings.map((it) => itemText(it, { answer: false }));
  return [...ex, ...sib];
}
const pack = (sk, unit) => scopedPack(runKey(sk), unit);
function cedText(IN, slot) { return IN.ced[slot.subject_key]?.[slot.topic_code] || '(official CED text for this topic not extracted; use the fact pack)'; }

// ---------------------------------------------------------------- prompts
function authorPrompt(IN, slot, siblings) {
  const s = SPEC[slot.subject_key];
  const exemplar = Object.values(IN.items).find((x) => IN.exemplars.includes(x.content_key) && subjectOf(x.content_key) === slot.subject_key);
  const prefix = `You are an experienced ${s.name} teacher and AP exam item writer. You write one original short free-response question (FRQ) for a practice app. Students type their answers; an automated grader awards each scoring criterion, and the student then sees the criteria and the fix for any point they missed.

Format for ${s.name}: ${s.note}
- HARD LIMITS (checked by a program; any breach discards the question): ${s.parts[0] === s.parts[1] ? `exactly ${s.parts[0]} parts` : `no fewer than ${s.parts[0]} and no more than ${s.parts[1]} parts`}; ${s.crit[0] === s.crit[1] ? `exactly ${s.crit[0]}` : `${s.crit[0]} to ${s.crit[1]}`} scoring criteria in total, each worth exactly 1 point; every fix at most 25 words; the words figure and diagram never appear.
- Each criterion awards one specific element (a correct value with its supporting work, a correct claim with its justification, a required condition or step).
- Calculator: say "not_permitted" when the work is exact or symbolic, "permitted" when the numbers need one, "not_applicable" when nothing is computed.

Rules the question, rubric and model answer must meet (independent checkers apply exactly these):
${RULES_TEXT}

Verification script: write Python that recomputes every number that appears in the rubric and the model answer from the givens, using only sympy, math, fractions, statistics, decimal or itertools. Assert each value (use tolerances for decimals), then print ALL_CHECKS_PASSED. No file, network or system access.

OFFICIAL ${s.name.toUpperCase()} CED FACT PACK (course-wide sections and units up to this one):
${pack(slot.subject_key, slot.unit)}`;
  const existing = existingFor(IN, slot, siblings);
  const suffix = `
DESIGNATED TOPIC: ${slot.topic_code} ${slot.topic_title} (Unit ${slot.unit}: ${slot.unit_title})

OFFICIAL CED TEXT FOR THIS TOPIC (governs over the fact pack where they differ):
${cedText(IN, slot)}

TOPICS IN UNITS ${u13(slot.subject_key).join(', ')} (stay inside the designated topic; use earlier topics only as background):
${unitTopicList(IN, slot.subject_key)}

${existing.length ? `QUESTIONS THAT ALREADY EXIST FOR THIS TOPIC. Yours must be clearly different: a new scenario, function or data set, and where possible a different learning objective or angle within the topic.
${existing.map((e, i) => `--- Existing question ${i + 1} ---\n${e}`).join('\n')}
` : 'No question exists for this topic yet.\n'}
${exemplar ? `HOUSE FORMAT EXAMPLE (from another topic; copy its format and level of detail, never its content):
${storedText(exemplar)}
` : ''}
Write the question for the designated topic now.`;
  return { prefix, suffix };
}
function subjectOf(key) {
  const k = key.toLowerCase();
  if (k.startsWith('apbio')) return 'ap_biology'; if (k.startsWith('apcalcab')) return 'ap_calculus_ab'; if (k.startsWith('apcalcbc')) return 'ap_calculus_bc';
  if (k.startsWith('apchem')) return 'ap_chemistry'; if (k.startsWith('apphycem')) return 'ap_physics_c_em'; if (k.startsWith('apphycm')) return 'ap_physics_c_mechanics';
  if (k.startsWith('apphy1')) return 'ap_physics_1'; if (k.startsWith('apphy2')) return 'ap_physics_2'; if (k.startsWith('apprecalc')) return 'ap_precalculus';
  if (k.startsWith('apstat') || k.startsWith('stats')) return 'ap_statistics'; return null;
}
function solvePrompt(slot, it) {
  return `You are an expert ${SPEC[slot.subject_key].name} teacher. Solve this free-response question yourself, completely and carefully, as a full-credit answer. Show the key work and give final values with units where relevant. If any part is ambiguous, inconsistent, missing information or needs content outside the course, say so in question_issues.

${itemText(it, { rubric: false, answer: false })}`;
}
function auditPrompt(IN, slot, it, solution, withAnswer, siblings) {
  const s = SPEC[slot.subject_key];
  const prefix = `You are an independent checker for ${s.name} free-response questions written for a practice app. Judge the question, its scoring criteria${withAnswer ? ' and its model answer' : ''} against every rule below. Be strict about correctness and scope; do not flag style preferences.

Rules:
${RULES_TEXT}
${withAnswer ? '' : '\n(You are not shown the model answer; mark nothing about it.)\n'}
OFFICIAL ${s.name.toUpperCase()} CED FACT PACK (course-wide sections and units up to this one):
${pack(slot.subject_key, slot.unit)}`;
  const existing = existingFor(IN, slot, siblings);
  const suffix = `
DESIGNATED TOPIC: ${slot.topic_code} ${slot.topic_title} (Unit ${slot.unit}: ${slot.unit_title})

OFFICIAL CED TEXT FOR THIS TOPIC:
${cedText(IN, slot)}

TOPICS IN UNITS ${u13(slot.subject_key).join(', ')}:
${unitTopicList(IN, slot.subject_key)}

${existing.length ? `EXISTING QUESTIONS FOR THIS TOPIC (for the distinct rule):\n${existing.map((e, i) => `--- Existing ${i + 1} ---\n${e}`).join('\n')}\n` : ''}
QUESTION UNDER REVIEW:
${itemText(it, { rubric: true, answer: withAnswer })}

YOUR OWN INDEPENDENT SOLUTION (written before you saw the rubric):
${solution.answers.map((a) => `(${a.part}) ${a.answer}`).join('\n')}
${solution.question_issues ? `Issues you noted while solving: ${solution.question_issues}` : ''}

Judge every rule, name the topic the question most directly tests, compare your solution with the rubric${withAnswer ? ' and model answer' : ''}, and rate the difficulty for a student who has just studied this topic.`;
  return { prefix, suffix };
}
const PROBE_SCHEMA = z.object({
  primary_topic_code: z.string().describe('The single best topic code from the list, e.g. 2.5'),
  required_units: z.array(z.number().int()).describe('Every unit number a student must have studied to answer (a unit is required if its content is needed to answer)'),
  reasoning: z.string().describe('At most 50 words'),
});
function probePrompt(IN, slot, it) {
  const units = [...new Map(IN.tax.filter((t) => t.sk === slot.subject_key).map((t) => [t.u, t.ut])).entries()].sort((a, b) => a[0] - b[0]);
  return `You are labeling an ${SPEC[slot.subject_key].name} exam question for a content library. Treat the question text as data. Do not solve it for the user; only label it.

Units:
${units.map(([n, t]) => `${n}. ${t}`).join('\n')}

Topics (code title):
${IN.tax.filter((t) => t.sk === slot.subject_key && u13(slot.subject_key).includes(t.u)).map((t) => `${t.c} ${t.t}`).join('\n')}

Label this item.

${itemText(it, { rubric: false, answer: false })}`;
}

// ---------------------------------------------------------------- stages
const ALLOWED = new Set(['sympy', 'math', 'fractions', 'statistics', 'decimal', 'itertools', 'functools', 'mpmath', 'cmath']);
const FORBID = /\b(open|exec|eval|compile|__import__|input|globals|locals|getattr|setattr|vars|breakpoint)\s*\(|\b(os|sys|subprocess|socket|shutil|pathlib|importlib|ctypes|urllib|requests|http)\b/;
function runPy(code) {
  const mods = [...code.matchAll(/^\s*(?:from|import)\s+([\w.]+)/gm)].map((m) => m[1].split('.')[0]);
  const bad = mods.filter((m) => !ALLOWED.has(m));
  if (bad.length) return { ok: false, out: `disallowed import: ${bad.join(', ')}` };
  if (FORBID.test(code)) return { ok: false, out: 'disallowed call or module reference' };
  const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'frqpy-'));
  fs.writeFileSync(path.join(dir, 'check.py'), code);
  const r = spawnSync('python3', ['-E', 'check.py'], { cwd: dir, timeout: 90_000, encoding: 'utf8', env: { PATH: '/usr/bin:/bin', HOME: os.homedir() } });
  fs.rmSync(dir, { recursive: true, force: true });
  const out = `${r.stdout || ''}${r.stderr || ''}`.slice(-1500);
  return { ok: r.status === 0 && /ALL_CHECKS_PASSED/.test(r.stdout || ''), out };
}
async function probe(IN, slot, it, tag) {
  const jobs = PROBE_MODELS.flatMap((m) => [1, 2].map((s) => call(m, PROBE_SCHEMA, probePrompt(IN, slot, it), 240_000, `${tag}:probe`)));
  const res = await Promise.all(jobs);
  const ok = res.filter((r) => r.ok).map((r) => r.object);
  const code = (x) => String(x.primary_topic_code).trim().split(/\s/)[0];
  const votes = ok.reduce((m, x) => ((m[code(x)] = (m[code(x)] || 0) + 1), m), {});
  const onTarget = votes[slot.topic_code] || 0;
  const unitCount = {}; for (const x of ok) for (const u of new Set(x.required_units)) unitCount[u] = (unitCount[u] || 0) + 1;
  const required = [...new Set([slot.unit, ...Object.entries(unitCount).filter(([, n]) => n >= 4).map(([u]) => Number(u))])].sort((a, b) => a - b);
  const pass = ok.length === 6 && onTarget >= 5 && Math.max(...required) <= slot.unit && required.every((u) => u13(slot.subject_key).includes(u) || u < slot.unit);
  return { pass, votes, onTarget, n: ok.length, required_units: required, unitCount };
}
async function checkOnce(IN, slot, it, model, siblings, tag) {
  const sol = await call(model, SOLVE_SCHEMA, solvePrompt(slot, it), 300_000, `${tag}:solve`);
  if (!sol.ok) return { ok: false, error: `solve: ${sol.error}` };
  const withAnswer = !model.startsWith('openai/');
  const aud = await call(model, auditSchema(withAnswer), auditPrompt(IN, slot, it, sol.object, withAnswer, siblings), 300_000, `${tag}:audit`);
  if (!aud.ok) return { ok: false, error: `audit: ${aud.error}` };
  const a = aud.object;
  const failed = Object.entries(a.rules).filter(([, v]) => !v.pass).map(([k, v]) => `${k}: ${v.issue}`);
  const topicOk = String(a.primary_topic_code).trim().split(/\s/)[0] === slot.topic_code;
  if (!topicOk) failed.push(`topic: checker says ${a.primary_topic_code}`);
  if (a.solution_disagreements && a.solution_disagreements.trim().length > 3 && !/^(none|no disagreements?|n\/a)\.?$/i.test(a.solution_disagreements.trim())) failed.push(`solution: ${a.solution_disagreements}`);
  return { ok: true, flagged: failed.length > 0, failed, difficulty: a.difficulty, solve_issues: sol.object.question_issues, audit: a };
}
async function checker(IN, slot, it, model, siblings, tag) {
  const first = await checkOnce(IN, slot, it, model, siblings, tag);
  if (!first.ok) return { model, pass: false, error: first.error, first };
  if (!first.flagged) return { model, pass: true, difficulty: first.difficulty, first };
  const second = await checkOnce(IN, slot, it, model, siblings, `${tag}:resample`);
  if (!second.ok) return { model, pass: false, error: second.error, first, second };
  return { model, pass: !second.flagged, difficulty: second.difficulty, first, second };
}
function assemble(o) {
  return { title: o.title.trim(), calculator: o.calculator, stimulus: o.stimulus.trim(), model_answer: o.model_answer.trim(),
    verification_python: o.verification_python, parts: o.parts.map((p) => ({ prompt: p.prompt.trim().replace(/^\(?[a-h]\)\s*/i, ''),
      criteria: p.criteria.map((c) => ({ text: c.text.trim(), evidence: c.evidence.trim(), fix: c.fix.trim(), accepted_variants: c.accepted_variants || [] })) })) };
}


// ---------------------------------------------------------------- planted-defect controls
// Each control is a copy of a pilot-accepted item with exactly one planted defect (written by the author model and
// recorded). Both batch checkers run on every control; if any control passes BOTH checkers, the batch is void.
const DEFECTS = {
  wrong_value: 'Change exactly one correct numeric value or claim in one scoring criterion AND in the model answer so that it is wrong (for example an arithmetic slip or a sign error). Change nothing else.',
  later_unit: 'Rewrite exactly one part so that answering it requires a concept, rule or theorem from a later unit of the course (outside the designated topic and earlier units). Update that part\'s criteria and the model answer to match. Change nothing else.',
  bare_value_and_unasked: 'In one part, change one criterion so it awards something the part never asks for, and give another criterion an accepted variant that is a bare final value although the part asks the student to justify or show work. Change nothing else.',
  insufficient: 'Delete one given quantity or condition from the setup that is needed to answer one part, leaving the parts, rubric and model answer unchanged, so that part can no longer be answered from the information given.',
};
const CTRL_SCHEMA = AUTHOR_SCHEMA.extend({ planted_defect: z.string().describe('Exactly what you changed, naming the part and criterion') });
async function cmdControls() {
  const batch = path.resolve(arg('batch')); const pilot = path.resolve(arg('pilot')); const checkers = arg('checkers').split(',').filter(Boolean);
  const IN = loadInputs(batch); setCallLog(path.join(batch, 'calls.jsonl'));
  const base = fs.readdirSync(path.join(pilot, 'slots')).map((f) => readJson(path.join(pilot, 'slots', f))).filter((x) => x.status === 'accepted');
  const out = [];
  for (const st of base) {
    const it = st.candidates.find((c) => c.stage === 'accepted').item;
    for (const [kind, instr] of Object.entries(DEFECTS)) {
      const p = `You are preparing a planted-defect CONTROL item to test question checkers. Below is a correct free-response question for ${SPEC[st.slot.subject_key].name}, topic ${st.slot.topic_code} ${st.slot.topic_title}. Return the same question with exactly one planted defect, as instructed, and describe the change in planted_defect. Keep the verification_python field as given.\n\nInstruction: ${instr}\n\n${itemText(it)}\n\nverification_python:\n${it.verification_python}`;
      const r = await call(AUTHOR, CTRL_SCHEMA, p, 400_000, `control:${st.id}:${kind}:plant`);
      if (!r.ok) { out.push({ base: st.id, kind, error: r.error }); continue; }
      const ci = assemble(r.object);
      const checks = await Promise.all(checkers.map((m) => checker(IN, st.slot, ci, m, [], `control:${st.id}:${kind}:${m.split('/')[0]}`)));
      const caughtBy = checks.filter((c) => !c.pass).map((c) => c.model);
      out.push({ base: st.id, kind, planted: r.object.planted_defect, caught_by: caughtBy, accepted_by_pair: caughtBy.length === 0, item: ci,
        flags: Object.fromEntries(checks.map((c) => [c.model, (c.second || c.first)?.failed || c.error])) });
      console.log(`${st.id} ${kind}: caught by [${caughtBy.join(', ')}]`);
    }
  }
  const voided = out.some((o) => o.accepted_by_pair || o.error);
  writeJson(path.join(batch, 'controls_result.json'), { checkers, at: new Date().toISOString(), batch_void: voided, controls: out });
  console.log(voided ? 'CONTROLS FAILED: batch void' : `CONTROLS PASSED: ${out.length}/${out.length} caught`);
}

// ---------------------------------------------------------------- model-answer grading (pre-publish)
// The production grader's QA path (app.qa_grade_frq) grades only published AP Biology FRQs, so before publishing each
// accepted model answer is graded criterion by criterion by a third, non-OpenAI, non-author family, using the fields the
// production grader reads (criterion text, evidence, accepted variants). Every criterion must be earned.
const ANSWER_GRADER = 'google/gemini-3.8-flash';
const GRADE_SCHEMA = z.object({ criteria: z.array(z.object({ criterion: z.string(), earned: z.boolean(), reason: z.string() })) });
async function cmdAnswers() {
  const batch = path.resolve(arg('batch')); setCallLog(path.join(batch, 'calls.jsonl'));
  const files = fs.readdirSync(path.join(batch, 'slots')).filter((f) => f.endsWith('.json'));
  const out = readJson(path.join(batch, 'answer_grades.json'), {});
  const todo = files.map((f) => readJson(path.join(batch, 'slots', f))).filter((s) => s.status === 'accepted' && !out[s.id]);
  const q = [...todo];
  await Promise.all(Array.from({ length: 8 }, async () => { while (q.length) { const st = q.shift();
    const it = st.candidates.find((c) => c.stage === 'accepted').item;
    const list = it.parts.flatMap((p, i) => p.criteria.map((c, j) => `${LETTERS[i]}${j + 1}. ${c.text}\n    Evidence required: ${c.evidence}${c.accepted_variants?.length ? `\n    Equivalent forms of the key value (the evidence requirement still applies): ${c.accepted_variants.join('; ')}` : ''}`)).join('\n');
    const prompt = `You are grading a student's response to a ${SPEC[st.slot.subject_key].name} free-response question against its scoring criteria. Each criterion is worth 1 point. Award a point only if the response clearly shows the required evidence; do not give credit for work that is not on the page. Grade every criterion in order.\n\nQUESTION\n${itemText(it, { rubric: false, answer: false })}\n\nSCORING CRITERIA\n${list}\n\nSTUDENT RESPONSE\n${it.model_answer}`;
    const r = await call(ANSWER_GRADER, GRADE_SCHEMA, prompt, 240_000, `${st.id}:answer_grade`);
    const n = it.parts.reduce((a, p) => a + p.criteria.length, 0);
    out[st.id] = r.ok ? { grader: ANSWER_GRADER, possible: n, earned: r.object.criteria.filter((c) => c.earned).length, full: r.object.criteria.length === n && r.object.criteria.every((c) => c.earned), detail: r.object.criteria }
                      : { grader: ANSWER_GRADER, error: r.error };
    writeJson(path.join(batch, 'answer_grades.json'), out);
    console.log(`${st.id}: ${out[st.id].error ? 'ERROR' : `${out[st.id].earned}/${n}`}`); } }));
  const vals = Object.values(out); console.log(`full credit ${vals.filter((v) => v.full).length}/${vals.length}`);
}
// ---------------------------------------------------------------- runner
async function runSlot(IN, batch, slot, n, checkers, rounds, siblings) {
  const id = `${slot.subject_key}__${slot.topic_code}__${n}`;
  const f = path.join(batch, 'slots', `${id}.json`);
  const st = readJson(f, { id, slot: { ...slot }, n, status: 'open', candidates: [] });
  if (st.status !== 'open') return st;
  while (st.candidates.length < rounds) {
    const r = st.candidates.length + 1; const tag = `${id}:r${r}`;
    const c = { round: r, at: new Date().toISOString() };
    const au = await call(AUTHOR, AUTHOR_SCHEMA, authorPrompt(IN, slot, siblings), 400_000, `${tag}:author`);
    if (!au.ok) { c.stage = 'author_error'; c.error = au.error; st.candidates.push(c); writeJson(f, st); continue; }
    const it = assemble(au.object); c.item = it;
    c.lint = lint(it, slot.subject_key);
    if (c.lint.length) { c.stage = 'lint'; st.candidates.push(c); writeJson(f, st); continue; }
    c.py = runPy(it.verification_python);
    if (!c.py.ok) { c.stage = 'recompute'; st.candidates.push(c); writeJson(f, st); continue; }
    c.probe = await probe(IN, slot, it, tag);
    if (!c.probe.pass) { c.stage = 'topic_vote'; st.candidates.push(c); writeJson(f, st); continue; }
    c.checks = await Promise.all(checkers.map((m) => checker(IN, slot, it, m, siblings, `${tag}:${m.split('/')[0]}`)));
    if (c.checks.some((x) => !x.pass)) { c.stage = 'checkers'; st.candidates.push(c); writeJson(f, st); continue; }
    const d = c.checks.map((x) => x.difficulty); const cnt = d.reduce((m, x) => ((m[x] = (m[x] || 0) + 1), m), {});
    c.difficulty = Object.entries(cnt).sort((a, b) => b[1] - a[1])[0][1] > d.length / 2 ? Object.entries(cnt).sort((a, b) => b[1] - a[1])[0][0] : 'Medium';
    c.stage = 'accepted'; st.candidates.push(c); st.status = 'accepted'; st.accepted_round = r; writeJson(f, st); return st;
  }
  st.status = 'escalated'; writeJson(f, st); return st;
}
async function runTopic(IN, batch, slot, checkers, rounds, firstOnly) {
  const siblings = []; const out = [];
  for (let n = 1; n <= (firstOnly ? 1 : slot.need); n++) {
    const st = await runSlot(IN, batch, slot, n, checkers, rounds, siblings);
    if (st.status === 'accepted') siblings.push(st.candidates.find((c) => c.stage === 'accepted').item);
    out.push(st); console.log(`${st.id}: ${st.status} after ${st.candidates.length} candidate(s)`);
  }
  return out;
}
async function cmdRun() {
  const batch = path.resolve(arg('batch')); const checkers = arg('checkers').split(',').filter(Boolean);
  if (!checkers.length) throw new Error('--checkers=<m1,m2> is required');
  if (checkers.some((m) => m.startsWith('anthropic/'))) throw new Error('a checker may not share the author family (Anthropic)');
  const IN = loadInputs(batch); setCallLog(path.join(batch, 'calls.jsonl'));
  const subj = arg('subjects') ? new Set(arg('subjects').split(',')) : null;
  const tps = arg('topics') ? new Set(arg('topics').split(',')) : null;
  let slots = IN.slots.filter((s) => (!subj || subj.has(s.subject_key)) && (!tps || tps.has(`${s.subject_key}:${s.topic_code}`)));
  if (arg('limit')) slots = slots.slice(0, Number(arg('limit')));
  const rounds = Number(arg('rounds', '3')); const conc = Number(arg('conc', '6'));
  writeJson(path.join(batch, 'run_config.json'), { author: AUTHOR, checkers, probe_models: PROBE_MODELS, rounds, at: new Date().toISOString(), slots: slots.length });
  const q = [...slots];
  await Promise.all(Array.from({ length: conc }, async () => { while (q.length) { const s = q.shift(); try { await runTopic(IN, batch, s, checkers, rounds, flag('first-only')); } catch (e) { console.error(s.subject_key, s.topic_code, e.message); } } }));
}
async function cmdReport() {
  const batch = path.resolve(arg('batch'));
  const { gateway } = await import('ai');
  const price = Object.fromEntries((await gateway.getAvailableModels()).models.map((m) => [m.id, m.pricing || {}]));
  const calls = fs.existsSync(path.join(batch, 'calls.jsonl')) ? fs.readFileSync(path.join(batch, 'calls.jsonl'), 'utf8').trim().split('\n').filter(Boolean).map(JSON.parse) : [];
  const costOf = (c) => { const p = price[c.model] || {}; const u = c.usage || {}; return (u.inputTokens || 0) * Number(p.input || 0) + (u.outputTokens || 0) * Number(p.output || 0); };
  const byStage = {}; let total = 0; const byModel = {};
  for (const c of calls) { const x = costOf(c); total += x; const st = (c.tag || '').split(':').slice(-1)[0]; byStage[st] = (byStage[st] || 0) + x; byModel[c.model] = (byModel[c.model] || 0) + x; }
  const files = fs.existsSync(path.join(batch, 'slots')) ? fs.readdirSync(path.join(batch, 'slots')).filter((f) => f.endsWith('.json')) : [];
  const sts = files.map((f) => readJson(path.join(batch, 'slots', f)));
  const per = {}; const stages = {}; const checkerStats = {};
  for (const s of sts) {
    const k = s.slot.subject_key; per[k] ??= { accepted: 0, escalated: 0, open: 0, candidates: 0 }; per[k][s.status]++; per[k].candidates += s.candidates.length;
    for (const c of s.candidates) {
      stages[c.stage] = (stages[c.stage] || 0) + 1;
      for (const ch of c.checks || []) { checkerStats[ch.model] ??= { pass: 0, fail: 0, error: 0 }; checkerStats[ch.model][ch.error ? 'error' : ch.pass ? 'pass' : 'fail']++; }
    }
  }
  const acc = sts.filter((s) => s.status === 'accepted').length;
  const summary = { slots: sts.length, accepted: acc, escalated: sts.filter((s) => s.status === 'escalated').length, candidate_outcomes: stages, per_subject: per,
    checker_verdicts: checkerStats, cost_usd: +total.toFixed(2), cost_per_accepted: acc ? +(total / acc).toFixed(2) : null,
    cost_by_stage: Object.fromEntries(Object.entries(byStage).map(([k, v]) => [k, +v.toFixed(2)])), cost_by_model: Object.fromEntries(Object.entries(byModel).map(([k, v]) => [k, +v.toFixed(2)])), calls: calls.length };
  writeJson(path.join(batch, 'summary.json'), summary); console.log(JSON.stringify(summary, null, 1));
}
const cmd = process.argv[2];
if (cmd === 'run') await cmdRun(); else if (cmd === 'report') await cmdReport(); else if (cmd === 'controls') await cmdControls(); else if (cmd === 'answers') await cmdAnswers();
else console.error('usage: node frq_pipeline.mjs run|report --batch=<dir> ...');
