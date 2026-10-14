#!/usr/bin/env node
// TASK-0075 / DECISION-0123 validator for ASCII -> LaTeX edits. Deterministic; no model.
//
// Input  (JSON array): { before, n?, skip?: string, spans?: [{ find, latex, occurrence? }] }
// Output (JSON):       the same records plus `after` and `checks`; a summary goes to stderr.
// Usage: node validate.mjs drafts.json validated.json     (needs katex: see ../latex_prose_pilot)
//
// The drafter never rewrites prose: it states which exact span becomes which LaTeX, and this script builds `after`,
// so nothing outside a span can change. Hard failures (exit 1): a span not found or overlapping; LaTeX that does not
// parse; `$` or a bare `|` in the LaTeX; the edited text unchanged; ASCII notation still present outside the maths.
// A `roundtripFlag` (not a failure) means the paren-free, multiplication-free form of the LaTeX differs from the
// original span: usually a changed digit, sign or letter, so a human must look.
//
// Record files hold published exam text. Do not commit them to this public repository.
import fs from "node:fs";
import { createRequire } from "node:module";
import { buildFromSpans } from "./convert.mjs";

const require = createRequire(import.meta.url);
let katex;
try { katex = require("../latex_prose_pilot/node_modules/katex"); } catch { katex = require("katex"); }

const G = "alpha|beta|gamma|delta|epsilon|theta|lambda|mu|pi|rho|sigma|tau|phi|omega";
export const ASCII_PATTERNS = {
  greek: new RegExp(`(\\d|[*/^=(+\\-]|_)\\s*(${G})\\b|\\b(${G})\\s*[*/^=_(<>+]`),
  subscript: /[A-Za-z]_[A-Za-z0-9{]/,
  caret: /[A-Za-z0-9)]\^[-+(]?[A-Za-z0-9]/,
  star: /[0-9A-Za-z)]\s?\*\s?[0-9A-Za-z(]/,
  sqrt: /sqrt\(/,
};

function texParses(tex) {
  try {
    const html = katex.renderToString(`\\displaystyle ${tex}`, { throwOnError: true, strict: false });
    return !html.includes("katex-error");
  } catch { return false; }
}

/** LaTeX to a plain, comparable string. Brace-aware, so nested \frac, ^{} and _{} are handled exactly. */
function latexToPlain(s) {
  let i = 0;
  const skipWs = () => { while (i < s.length && /\s/.test(s[i])) i++; };
  const group = () => {
    skipWs();
    if (s[i] !== "{") { const ch = s[i++]; return ch ?? ""; }
    let depth = 0; const start = i + 1;
    for (; i < s.length; i++) {
      if (s[i] === "{") depth++;
      else if (s[i] === "}") { depth--; if (depth === 0) { const inner = s.slice(start, i); i++; return inner; } }
    }
    throw new Error("unbalanced braces");
  };
  let out = "";
  while (i < s.length) {
    const c = s[i];
    if (c === "\\") {
      const m = /^\\([A-Za-z]+|.)/.exec(s.slice(i)); const name = m[1]; i += m[0].length;
      if (name === "frac" || name === "dfrac" || name === "tfrac") { const a = group(); const b = group(); out += `(${latexToPlain(a)})/(${latexToPlain(b)})`; }
      else if (name === "sqrt") { out += `√(${latexToPlain(group())})`; }
      else if (name === "mathrm" || name === "text") { out += latexToPlain(group()); }
      else if (["left", "right", ",", ";", "!", " "].includes(name)) { /* spacing and sizing only */ }
      else if (name === "cdot" || name === "times") out += "*";
      else if (name === "to") out += "->";
      else if (name === "approx") out += "~";
      else if (name === "propto") out += "∝";
      else if (name === "int") out += "∫";
      else out += name;
    } else if (c === "^" || c === "_") {
      out += c; i++;
      if (s[i] === "{") out += `(${latexToPlain(group())})`;
    } else { out += c; i++; }
  }
  return out;
}

function finishNorm(t) {
  return t
    .replace(/\u2212|–|—/g, "-")
    .replace(/\u2212/g, "-")
    .replace(/[·×⋅]/g, "*")
    .replace(/\s+x\s+(?=\d)/g, "*")
    .replace(/(\d)\s*x\s*(10\^)/g, "$1*$2")
    .replace(/sqrt/g, "√")
    .replace(/²/g, "^2").replace(/³/g, "^3").replace(/⁻¹/g, "^-1").replace(/₀/g, "_0")
    .replace(/π/g, "pi").replace(/λ/g, "lambda").replace(/ν/g, "nu").replace(/ε/g, "epsilon").replace(/μ/g, "mu")
    .replace(/≈|~/g, "~")
    .replace(/lim_/g, "lim")
    .replace(/[{}()\s*_]/g, "")
    .toLowerCase();
}

/** Comparable form of the ASCII original and of the LaTeX: no spaces, brackets, underscores or multiplication signs. */
export function normAscii(s) { return finishNorm(s.replace(/\u2212/g, "-")); }
export function normLatex(s) { return finishNorm(latexToPlain(s)); }
export const norm = normAscii;

function stripMath(after) { return after.replace(/\\\(.*?\\\)/gs, " ").replace(/\\\[.*?\\\]/gs, " "); }

export function validate(records) {
  const out = [];
  let hard = 0, flags = 0;
  for (const r of records) {
    const rec = { ...r, checks: {} };
    if (r.skip) { rec.after = r.before; rec.checks.skipped = r.skip; out.push(rec); continue; }
    const errs = [];
    let after = r.before;
    try { after = buildFromSpans(r.before, r.spans); } catch (e) { errs.push(String(e.message)); }
    rec.after = after;
    const flagsHere = [];
    for (const sp of r.spans ?? []) {
      if (!texParses(sp.latex)) errs.push(`LaTeX does not parse: ${sp.latex}`);
      if (/\$/.test(sp.latex)) errs.push(`dollar sign in LaTeX: ${sp.latex}`);
      if (/(^|[^\\])\|/.test(sp.latex)) errs.push(`bare | in LaTeX: ${sp.latex}`);
      if (normAscii(sp.find) !== normLatex(sp.latex)) flagsHere.push({ find: sp.find, latex: sp.latex, a: normAscii(sp.find), b: normLatex(sp.latex) });
    }
    if (after === r.before) errs.push("edited text equals the original");
    const residual = stripMath(after);
    for (const [name, re] of Object.entries(ASCII_PATTERNS)) if (re.test(residual)) errs.push(`ASCII ${name} notation left outside the maths: ${residual.slice(0, 80)}`);
    rec.checks.errors = errs;
    rec.checks.roundtripFlags = flagsHere;
    hard += errs.length ? 1 : 0;
    flags += flagsHere.length ? 1 : 0;
    out.push(rec);
  }
  return { out, hard, flags };
}

if (import.meta.url === `file://${process.argv[1]}`) {
  const [inp, outp] = process.argv.slice(2);
  const { out, hard, flags } = validate(JSON.parse(fs.readFileSync(inp, "utf8")));
  fs.writeFileSync(outp, JSON.stringify(out, null, 1));
  const edited = out.filter((r) => !r.checks.skipped);
  console.error(`records ${out.length} | edited ${edited.length} | skipped ${out.length - edited.length} | hard failures ${hard} | roundtrip flags ${flags}`);
  process.exit(hard ? 1 : 0);
}
