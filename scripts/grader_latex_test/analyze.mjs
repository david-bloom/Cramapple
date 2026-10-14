// TASK-0074 analysis. Usage: node analyze.mjs results.jsonl
// For each (item, response) cell: decision = status + points. Compares plain-vs-latex agreement with each form's
// run-to-run agreement, and scans every model-written string for LaTeX markup.
import { readFileSync } from "node:fs";
const rows = readFileSync(process.argv[2], "utf8").split("\n").filter(Boolean).map((l) => JSON.parse(l)).filter((r) => r.result?.parsed);
const dec = (r) => `${r.result.parsed.status}/${r.result.parsed.points_awarded}`;
const cells = {};
for (const r of rows) ((cells[`${r.item}/${r.resp}`] ??= { plain: [], latex: [] })[r.form]).push(dec(r));
const pairAgree = (a) => { let n = 0, k = 0; for (let i = 0; i < a.length; i++) for (let j = i + 1; j < a.length; j++) { n++; if (a[i] === a[j]) k++; } return [k, n]; };
let within = [0, 0], cross = [0, 0];
console.log("cell".padEnd(16), "plain".padEnd(34), "latex".padEnd(34), "within-plain within-latex cross");
for (const [cell, c] of Object.entries(cells)) {
  const wp = pairAgree(c.plain), wl = pairAgree(c.latex);
  let cr = [0, 0]; for (const p of c.plain) for (const l of c.latex) { cr[1]++; if (p === l) cr[0]++; }
  within[0] += wp[0] + wl[0]; within[1] += wp[1] + wl[1]; cross[0] += cr[0]; cross[1] += cr[1];
  console.log(cell.padEnd(16), c.plain.join(",").padEnd(34), c.latex.join(",").padEnd(34), `${wp[0]}/${wp[1]}`, `${wl[0]}/${wl[1]}`, `${cr[0]}/${cr[1]}`);
}
console.log(`\nrun-to-run agreement (within a form): ${within[0]}/${within[1]}`);
console.log(`plain-vs-latex agreement (across forms): ${cross[0]}/${cross[1]}`);
const pat = [/\\\(/, /\\\[/, /\\frac/, /\\mathrm/, /\\,/, /\$/];
let hits = 0;
for (const r of rows) for (const f of ["evidence_quote", "decision_explanation", "minimum_fix"]) {
  const s = r.result.parsed[f]; if (typeof s !== "string") continue;
  if (pat.some((p) => p.test(s))) { hits++; console.log(`MARKUP in ${f} [${r.item}/${r.resp}/${r.form}/rep${r.rep}]: ${s}`); }
}
console.log(`\nmodel-written strings containing LaTeX markup: ${hits} (of ${rows.length * 3} fields in ${rows.length} graded calls)`);
