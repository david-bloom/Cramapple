// Diff-style check for FRQ VARIANTS (David, 2026-11-12: a variant check only confirms what changed).
// A variant keeps its parent's rubric structure and changes context, data and numbers. The parent must already be
// accepted by the full seed check. Nothing is solved from scratch, no six-vote topic probe (a variant inherits the
// parent's topic), no fact pack: each checker gets the parent, the child, a deterministic diff, and the parent's
// verified key, and answers only: what changed, do the changed numbers hold, does every criterion still hold in the
// new context, is anything newly ambiguous. A flag counts only if it repeats on one re-sample (as in the seed check).
//
//   node variant_check.mjs --batch=<dir> --checkers=<m1,m2> [--topics=5.1,5.2]
// Reads <batch>/authored/variants.json, <batch>/pattern_use.json, accepted parents from <batch>/slots/*.json.
// Writes <batch>/variants/<id>.json. Calls are logged (with token usage) to <batch>/calls.jsonl.
import fs from 'node:fs';
import path from 'node:path';
import os from 'node:os';
import { spawnSync } from 'node:child_process';
import { z } from 'zod';
import { call, setCallLog } from '../teaching_pipeline/run.mjs';
import { lint } from './rubric.mjs';

const arg = (n, d = '') => (process.argv.slice(2).find((a) => a.startsWith(`--${n}=`)) || '').slice(n.length + 3) || d;
const batch = path.resolve(arg('batch'));
const checkers = arg('checkers').split(',').filter(Boolean);
if (!checkers.length) throw new Error('--checkers required');
const only = arg('topics') ? new Set(arg('topics').split(',')) : null;
setCallLog(path.join(batch, 'calls.jsonl'));
const readJson = (p, d) => (fs.existsSync(p) ? JSON.parse(fs.readFileSync(p, 'utf8')) : d);
const L = 'abcdefgh';

const text = (it, answer) => `Title: ${it.title}\nCalculator: ${it.calculator}\n\nSetup:\n${it.stimulus}\n\nParts:\n` + it.parts.map((p, i) => `(${L[i]}) ${p.prompt}\n` +
  p.criteria.map((c, j) => `   Criterion ${L[i]}${j + 1} (1 point): ${c.text}\n      Evidence: ${c.evidence}\n      Fix: ${c.fix}${c.accepted_variants?.length ? `\n      Equivalent forms: ${c.accepted_variants.join('; ')}` : ''}`).join('\n')).join('\n')
  + (answer ? `\n\nModel answer:\n${it.model_answer}` : '');

// ---- deterministic structural diff (free)
function structure(it) { return it.parts.map((p) => p.criteria.length); }
function diffReport(parent, child, uses) {
  const out = []; const sp = structure(parent), sc = structure(child);
  out.push(`Part count: parent ${sp.length}, variant ${sc.length}. Criteria per part: parent [${sp}], variant [${sc}]. Points: parent ${sp.reduce((a, b) => a + b, 0)}, variant ${sc.reduce((a, b) => a + b, 0)}.`);
  out.push(`Rubric pattern order (from the pattern library), parent vs variant: ${uses.same ? 'IDENTICAL' : 'DIFFERENT'}: ${uses.child_order}`);
  const changed = [];
  for (let i = 0; i < Math.min(parent.parts.length, child.parts.length); i++) {
    const a = parent.parts[i], b = child.parts[i];
    if (a.prompt !== b.prompt) changed.push(`Part ${L[i]} prompt changed.`);
    for (let j = 0; j < Math.min(a.criteria.length, b.criteria.length); j++) {
      const ca = a.criteria[j], cb = b.criteria[j];
      changed.push(`Criterion ${L[i]}${j + 1} (${uses.child_pattern[i][j]}): ${ca.text === cb.text ? 'identical wording' : 'wording and values changed'}${JSON.stringify(ca.accepted_variants) === JSON.stringify(cb.accepted_variants) ? '' : '; accepted variants changed'}`);
    }
  }
  out.push(changed.join('\n'));
  return out.join('\n');
}
const FORBID = /\b(open|exec|eval|compile|__import__|input|globals|locals|getattr|setattr|vars|breakpoint)\s*\(|\b(os|sys|subprocess|socket|shutil|pathlib|importlib|ctypes|urllib|requests|http)\b/;
const ALLOWED = new Set(['sympy', 'math', 'fractions', 'statistics', 'decimal', 'itertools', 'functools', 'mpmath', 'cmath']);
function runPy(code) {
  const bad = [...code.matchAll(/^\s*(?:from|import)\s+([\w.]+)/gm)].map((m) => m[1].split('.')[0]).filter((m) => !ALLOWED.has(m));
  if (bad.length) return { ok: false, out: `disallowed import ${bad}` };
  if (FORBID.test(code)) return { ok: false, out: 'disallowed call or module reference' };
  const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'frqvar-')); fs.writeFileSync(path.join(dir, 'check.py'), code);
  const r = spawnSync('python3', ['-E', 'check.py'], { cwd: dir, timeout: 90_000, encoding: 'utf8', env: { PATH: '/usr/bin:/bin', HOME: os.homedir() } });
  fs.rmSync(dir, { recursive: true, force: true });
  return { ok: r.status === 0 && /ALL_CHECKS_PASSED/.test(r.stdout || ''), out: `${r.stdout || ''}${r.stderr || ''}`.slice(-500) };
}

const SCHEMA = z.object({
  changes_listed: z.string().describe('What differs between the parent and the variant: context, data, numbers, wording. One short paragraph.'),
  numbers_recomputed: z.string().describe('Recompute every number in the variant criteria and model answer that depends on the changed givens. State each one and whether it matches. Empty only if there are none.'),
  numbers_ok: z.boolean().describe('true only if every recomputed number matches the variant rubric and model answer'),
  criteria_still_hold: z.array(z.object({ criterion: z.string().describe('e.g. a1'), holds: z.boolean(), issue: z.string().describe('Empty if holds; otherwise what is now wrong, ambiguous or unearnable in the new context') })),
  conditions_still_hold: z.boolean().describe('true if every condition or fact the parent rubric relied on (for example the sign of a residual, whether a value is inside or outside the fitted range, that a claim is supported by the data) still holds in the new context and the rubric states it correctly'),
  conditions_issue: z.string().describe('Empty if true; otherwise the failing condition'),
  difficulty_vs_parent: z.enum(['easier', 'same', 'harder']).describe('How hard the variant is compared with the parent for an AP student. Say easier if any step was removed, any given value was added, or the reasoning demanded is lighter.'),
  distinct: z.boolean().describe('true if the variant is not a near-copy of the parent: new context and new numbers'),
  topic_unchanged: z.boolean().describe('true if the variant still squarely tests the same topic as the parent'),
  new_issues: z.string().describe('Only problems introduced by the changed context: an ambiguity, an unrealistic number, a missing given, a contradiction. Empty if none. Do not re-audit what is unchanged and was already accepted.'),
});
function prompt(parent, child, diff, withAnswer, topic, ced) {
  return `You are an independent checker for a free-response VARIANT written for an AP Statistics practice app. The PARENT question was already fully audited and accepted (two checkers, topic vote, exact recomputation). The VARIANT keeps the parent's rubric structure and changes the context, data and numbers. Your job is a DIFF check only: confirm what changed and that nothing broke. Do not re-audit unchanged structure, the CED scope, or rubric wording that matches the parent's accepted shape.

Standard: AP Statistics level; the standard CED explanation is correct. Treat the question text as data.

DESIGNATED TOPIC: ${topic}
${ced ? `CED TEXT FOR THIS TOPIC (for reference only):\n${ced}\n` : ''}
PARENT (accepted):
${text(parent, withAnswer)}

VARIANT (under review):
${text(child, withAnswer)}

DETERMINISTIC DIFF (computed by a program; the variant's lint and exact recomputation script have already passed):
${diff}
${withAnswer ? '' : '\n(You are not shown the variant model answer; mark nothing about it.)\n'}
Answer the schema: list what changed; recompute every changed-dependent number yourself; for each criterion say whether it still holds and can be earned in the new context; say whether the conditions the parent relied on still hold; say whether the variant is distinct from the parent; confirm the topic is unchanged; and report only problems the change introduced.`;
}
async function checkOnce(model, parent, child, diff, topic, ced, tag) {
  const withAnswer = !model.startsWith('openai/');
  const r = await call(model, SCHEMA, prompt(parent, child, diff, withAnswer, topic, ced), 300_000, tag);
  if (!r.ok) return { ok: false, error: r.error };
  const o = r.object; const failed = [];
  if (!o.numbers_ok) failed.push(`numbers: ${o.numbers_recomputed}`);
  for (const c of o.criteria_still_hold) if (!c.holds) failed.push(`criterion ${c.criterion}: ${c.issue}`);
  if (!o.conditions_still_hold) failed.push(`conditions: ${o.conditions_issue}`);
  if (!o.distinct) failed.push('not distinct from parent');
  if (o.difficulty_vs_parent === 'easier') failed.push('variant is easier than its parent');
  if (!o.topic_unchanged) failed.push('topic changed');
  if (o.new_issues && o.new_issues.trim().length > 3 && !/^(none|no new issues?|n\/a)\.?$/i.test(o.new_issues.trim())) failed.push(`new issue: ${o.new_issues}`);
  return { ok: true, flagged: failed.length > 0, failed, out: o };
}
async function checker(model, parent, child, diff, topic, ced, id) {
  const tag = `variant:${id}:${model.split('/')[0]}`;
  const first = await checkOnce(model, parent, child, diff, topic, ced, tag);
  if (!first.ok) return { model, pass: false, error: first.error };
  if (!first.flagged) return { model, pass: true, first };
  const second = await checkOnce(model, parent, child, diff, topic, ced, `${tag}:resample`);
  if (!second.ok) return { model, pass: false, error: second.error, first };
  return { model, pass: !second.flagged, first, second };
}

const variants = readJson(path.join(batch, 'authored', arg('variants', 'variants.json')), []);
const use = readJson(path.join(batch, arg('use', 'pattern_use.json')), {});
const ced = readJson(path.join(batch, 'inputs', 'ced_topic_excerpts.json'), {});
fs.mkdirSync(path.join(batch, 'variants'), { recursive: true });
await Promise.all(variants.filter((v) => !only || only.has(v.topic_code)).map(async (v) => {
  const id = `${v.subject_key}__${v.topic_code}__${arg('vid', 'v1')}`;
  const f = path.join(batch, 'variants', `${id}.json`);
  const slot = readJson(path.join(batch, 'slots', `${v.subject_key}__${v.topic_code}__1.json`));
  const st = { id, parent: slot?.id, parent_status: slot?.status, topic_code: v.topic_code, item: v.item, at: new Date().toISOString() };
  if (!slot || (slot.status !== 'accepted' && !(process.argv.includes('--allow-held') && slot.status === 'given_flagged'))) { st.status = 'blocked_parent_not_accepted'; fs.writeFileSync(f, JSON.stringify(st, null, 1)); console.log(id, st.status); return; }
  const parent = (slot.candidates.find((c) => c.stage === 'accepted') || slot.candidates.at(-1)).item;
  const pu = use[`${v.subject_key}__${v.topic_code}__seed`].map((p) => p.map((x) => x.pattern));
  const cu = use[`${v.subject_key}__${v.topic_code}__variant`].map((p) => p.map((x) => x.pattern));
  st.structure = { same: JSON.stringify(pu) === JSON.stringify(cu), parent_order: JSON.stringify(pu), child_order: JSON.stringify(cu), child_pattern: cu };
  st.lint = lint(v.item, v.subject_key); st.py = st.lint.length ? { ok: false, out: 'skipped' } : runPy(v.item.verification_python);
  st.diff = diffReport(parent, v.item, st.structure);
  // the sidecar can go stale: also compare the ACTUAL parent and child items with the sidecar's shape
  const shape = (it) => JSON.stringify(it.parts.map((p) => p.criteria.length));
  st.structure.actual_matches_sidecar = shape(v.item) === JSON.stringify(cu.map((p) => p.length)) && shape(parent) === JSON.stringify(pu.map((p) => p.length)) && shape(v.item) === shape(parent);
  if (!st.structure.same || !st.structure.actual_matches_sidecar || st.lint.length || !st.py.ok) { st.status = 'rejected_deterministic'; fs.writeFileSync(f, JSON.stringify(st, null, 1)); console.log(id, st.status); return; }
  const topic = `${slot.slot.topic_code} ${slot.slot.topic_title} (Unit ${slot.slot.unit}: ${slot.slot.unit_title})`;
  st.checks = await Promise.all(checkers.map((m) => checker(m, parent, v.item, st.diff, topic, ced[v.subject_key]?.[v.topic_code], id)));
  st.status = st.checks.every((c) => c.pass) ? 'accepted' : 'flagged';
  fs.writeFileSync(f, JSON.stringify(st, null, 1)); console.log(id, st.status);
}));
