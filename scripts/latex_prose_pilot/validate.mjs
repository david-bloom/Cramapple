#!/usr/bin/env node
// TASK-0073 / DECISION-0121 validator for LaTeX prose edits. Deterministic; no model.
//
// Input  (JSON array): records of
//   { table, column, row_id, subject_key, unit_number, original, classification, reason?,
//     replacements?: [{ find, latex, kind: "inline"|"display", occurrence?: 1 }] }
// Output (JSON): same records plus `edited` and `checks`, and a summary on stderr.
//
// The drafting model never rewrites prose. It states which exact span of `original` becomes
// which LaTeX, and this script builds `edited` itself, so text outside the spans cannot change.
//
// Usage: node validate.mjs in.json out.json        (needs `npm i katex` in this folder)
import fs from "node:fs";
import katex from "katex";

const CLASSES = new Set(["DISPLAY_LINE", "WHOLE_FIELD", "INLINE_KEEP", "EXEMPT", "FLAG"]);
const EDIT_CLASSES = new Set(["DISPLAY_LINE", "WHOLE_FIELD"]);
const OPEN = { inline: "\\(", display: "\\[" };
const CLOSE = { inline: "\\)", display: "\\]" };

function texParses(tex) {
  try {
    const html = katex.renderToString(`\\displaystyle ${tex}`, { throwOnError: true, strict: false });
    return !html.includes("katex-error");
  } catch {
    return false;
  }
}

/** Reduce a plain-text or LaTeX quotient to a paren-free token string, for a roundtrip FLAG (not a proof). */
function norm(s) {
  let t = s;
  for (let i = 0; i < 10; i++) {
    const n = t.replace(/\\[dt]?frac\s*\{([^{}]*)\}\s*\{([^{}]*)\}/g, "$1/$2");
    if (n === t) break;
    t = n;
  }
  t = t
    .replace(/\\left|\\right|\\,|\;|\\!|\\ /g, "")
    .replace(/\\cdot|\\times/g, "*")
    .replace(/\\sqrt\s*\{([^{}]*)\}/g, "√$1")
    .replace(/\\pi/g, "π")
    .replace(/[−–—]/g, "-")
    .replace(/[·×⋅]/g, "*")
    .replace(/²/g, "^2").replace(/³/g, "^3")
    .replace(/\^\{([^{}]*)\}/g, "^$1")
    .replace(/[(){}\s]/g, "")
    .replace(/\\/g, "");
  return t.toLowerCase();
}

function boundaryOk(original, start, end) {
  const before = start === 0 || original[start - 1] === "\n";
  let j = end;
  while (j < original.length && /[.,;:)]/.test(original[j])) j++;
  const after = j >= original.length || original[j] === "\n";
  return before && after;
}

function build(rec) {
  const errors = [];
  const spans = [];
  for (const r of rec.replacements ?? []) {
    const occ = r.occurrence ?? 1;
    let idx = -1;
    for (let k = 0; k < occ; k++) idx = rec.original.indexOf(r.find, idx + 1);
    if (!r.find || idx === -1) { errors.push(`find not in original: ${JSON.stringify(r.find)}`); continue; }
    if (r.kind !== "inline" && r.kind !== "display") { errors.push(`bad kind: ${r.kind}`); continue; }
    spans.push({ ...r, start: idx, end: idx + r.find.length });
  }
  spans.sort((a, b) => a.start - b.start);
  for (let i = 1; i < spans.length; i++) if (spans[i].start < spans[i - 1].end) errors.push("overlapping replacements");
  let edited = "";
  let pos = 0;
  const checks = { spans: [] };
  for (const sp of spans) {
    edited += rec.original.slice(pos, sp.start) + OPEN[sp.kind] + sp.latex.trim() + CLOSE[sp.kind];
    pos = sp.end;
    const c = {
      parses: texParses(sp.latex),
      noDollar: !sp.latex.includes("$"),
      noBarePipe: !sp.latex.includes("|"),
      noPromptDelimiter: !/\\\(|\\\)|\\\[|\\\]/.test(sp.latex),
      stacked: /\\d?frac/.test(sp.latex),
      kindOk: sp.kind === "display"
        ? boundaryOk(rec.original, sp.start, sp.end)
        : rec.original.trim() === sp.find.trim(),
      roundtrip: norm(sp.find) === norm(sp.latex),
    };
    checks.spans.push(c);
  }
  edited += rec.original.slice(pos);
  return { edited, errors, checks };
}

const [, , inFile, outFile] = process.argv;
if (!inFile || !outFile) { console.error("usage: node validate.mjs in.json out.json"); process.exit(2); }
const records = JSON.parse(fs.readFileSync(inFile, "utf8"));
const out = [];
const tally = { total: 0, byClass: {}, edits: 0, hardFail: 0, roundtripFlag: 0, kindFail: 0 };
for (const rec of records) {
  tally.total++;
  tally.byClass[rec.classification] = (tally.byClass[rec.classification] ?? 0) + 1;
  const errors = [];
  if (!CLASSES.has(rec.classification)) errors.push(`bad classification: ${rec.classification}`);
  if (rec.classification === "FLAG" && !rec.reason) errors.push("FLAG needs a reason");
  const isEdit = EDIT_CLASSES.has(rec.classification);
  if (isEdit && !(rec.replacements?.length)) errors.push("edit class with no replacements");
  if (!isEdit && rec.replacements?.length) errors.push("replacements on a non-edit class");
  const built = isEdit ? build(rec) : { edited: rec.original, errors: [], checks: { spans: [] } };
  errors.push(...built.errors);
  const hard = errors.length > 0 || built.checks.spans.some((c) => !c.parses || !c.noDollar || !c.noBarePipe || !c.noPromptDelimiter || !c.stacked);
  const kindFail = built.checks.spans.some((c) => !c.kindOk);
  const rtFlag = built.checks.spans.some((c) => !c.roundtrip);
  if (isEdit) tally.edits++;
  if (hard) tally.hardFail++;
  if (kindFail) tally.kindFail++;
  if (rtFlag) tally.roundtripFlag++;
  out.push({ ...rec, edited: built.edited, errors, checks: built.checks, hardFail: hard, kindFail, roundtripFlag: rtFlag });
}
fs.writeFileSync(outFile, JSON.stringify(out, null, 2));
console.error(JSON.stringify(tally));
process.exit(tally.hardFail || tally.kindFail ? 1 : 0);
