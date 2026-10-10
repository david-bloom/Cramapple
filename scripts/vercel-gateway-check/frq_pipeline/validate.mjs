// Free local validation for hand-authored FRQs: lint (rubric.mjs) + the sympy recompute. No model calls.
//   node validate.mjs <authored.json>     file: [{ subject_key, topic_code, item: {title, calculator, stimulus, parts, model_answer, verification_python} }]
import fs from 'node:fs'; import os from 'node:os'; import path from 'node:path'; import { spawnSync } from 'node:child_process';
import { lint } from './rubric.mjs';
const ALLOWED = new Set(['sympy', 'math', 'fractions', 'statistics', 'decimal', 'itertools', 'functools', 'mpmath', 'cmath']);
const FORBID = /\b(open|exec|eval|compile|__import__|input|globals|locals|getattr|setattr|vars|breakpoint)\s*\(|\b(os|sys|subprocess|socket|shutil|pathlib|importlib|ctypes|urllib|requests|http)\b/;
function runPy(code) {
  const bad = [...code.matchAll(/^\s*(?:from|import)\s+([\w.]+)/gm)].map((m) => m[1].split('.')[0]).filter((m) => !ALLOWED.has(m));
  if (bad.length) return { ok: false, out: `disallowed import: ${bad.join(', ')}` };
  if (FORBID.test(code)) return { ok: false, out: 'disallowed call or module reference' };
  const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'frqpy-')); fs.writeFileSync(path.join(dir, 'check.py'), code);
  const r = spawnSync('python3', ['-E', 'check.py'], { cwd: dir, timeout: 90_000, encoding: 'utf8', env: { PATH: '/usr/bin:/bin', HOME: os.homedir() } });
  fs.rmSync(dir, { recursive: true, force: true });
  return { ok: r.status === 0 && /ALL_CHECKS_PASSED/.test(r.stdout || ''), out: `${r.stdout || ''}${r.stderr || ''}`.slice(-600) };
}
const file = process.argv[2]; const rows = JSON.parse(fs.readFileSync(file, 'utf8')); let ok = 0;
for (const r of rows) {
  const l = lint(r.item, r.subject_key); const p = l.length ? { ok: false, out: 'skipped (lint failed)' } : runPy(r.item.verification_python);
  const pass = !l.length && p.ok; ok += pass;
  console.log(`${pass ? 'PASS' : 'FAIL'} ${r.subject_key} ${r.topic_code}${l.length ? ' lint: ' + l.join('; ') : ''}${!l.length && !p.ok ? ' recompute: ' + p.out.trim().split('\n').slice(-3).join(' | ') : ''}`);
}
console.log(`${ok}/${rows.length} pass`);
