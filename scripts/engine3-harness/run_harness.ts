/**
 * Engine 3 harness — checker-level test.
 *
 * Runs the SymPy-computed fixtures through the REAL production module
 * (supabase/functions/_shared/math-verifier.ts), exercising the same
 * coerceEcfQuestion -> buildEcfResult path that evaluate-attempt uses.
 *
 * This is the checker/profile layer only. It deliberately does NOT test:
 *   - routing (0 items are tagged evaluator_strategy='symbolic_ecf')
 *   - the authoritative-output layer (hard-codes finalStatus="uncertain")
 *   - real structured input from students (no producer exists)
 * Those need the integration test and its write decisions.
 *
 * Run:  deno run --allow-read scripts/engine3-harness/run_harness.ts
 */
import {
  buildEcfResult,
  coerceEcfQuestion,
  type EcfPartSpec,
} from "../../supabase/functions/_shared/math-verifier.ts";

const HERE = new URL(".", import.meta.url).pathname;
const ROOT = new URL("../../", import.meta.url).pathname;

const fixtures = JSON.parse(await Deno.readTextFile(`${HERE}fixtures.json`));
const profiles = JSON.parse(
  await Deno.readTextFile(
    `${ROOT}docs/research/statistics_phase_b_2026_07_08/statistics_item_keys.json`,
  ),
).items as Array<{ content_key: string; ecf_parts: EcfPartSpec[] }>;
const byKey = new Map(profiles.map((p) => [p.content_key, p]));

type Row = {
  content_key: string;
  case_id: string;
  part: string;
  expected: string;
  actual: string;
  ok: boolean;
  latency_ms: number;
  note?: string;
};

const rows: Row[] = [];
let coerceNulls = 0;
const latencies: number[] = [];

for (const c of fixtures.cases) {
  const prof = byKey.get(c.content_key);
  if (!prof) {
    rows.push({
      content_key: c.content_key, case_id: c.case_id, part: "*",
      expected: "(profile)", actual: "PROFILE_NOT_FOUND", ok: false, latency_ms: 0,
    });
    continue;
  }

  // Shape exactly as evaluate-attempt does: response_parts -> coerceEcfQuestion
  const responseParts: Record<string, unknown> = {};
  for (const [pid, sp] of Object.entries(c.student as Record<string, unknown>)) {
    responseParts[pid] = sp;
  }

  const t0 = performance.now();
  const q = coerceEcfQuestion(prof, responseParts);
  if (!q) {
    coerceNulls++;
    const dt = performance.now() - t0;
    latencies.push(dt);
    for (const [pid, exp] of Object.entries(c.expected as Record<string, string>)) {
      rows.push({
        content_key: c.content_key, case_id: c.case_id, part: pid,
        expected: exp, actual: "COERCE_NULL", ok: false, latency_ms: dt,
        note: "coerceEcfQuestion returned null — response_parts rejected",
      });
    }
    continue;
  }
  const res = buildEcfResult(q);
  const dt = performance.now() - t0;
  latencies.push(dt);

  const actualByPart = new Map(res.parts.map((p) => [p.part, p.verdict]));
  for (const [pid, exp] of Object.entries(c.expected as Record<string, string>)) {
    const actual = actualByPart.get(pid) ?? "MISSING_FROM_RESULT";
    rows.push({
      content_key: c.content_key, case_id: c.case_id, part: pid,
      expected: exp, actual, ok: actual === exp, latency_ms: dt,
    });
  }
}

// ---------- report ----------
const total = rows.length;
const pass = rows.filter((r) => r.ok).length;
const pct = (n: number) => `${(n / total * 100).toFixed(1)}%`;

console.log("=".repeat(72));
console.log("ENGINE 3 HARNESS — checker-level test against production math-verifier.ts");
console.log("=".repeat(72));
console.log(`fixtures      : ${fixtures.cases.length} cases, ${total} part-level expectations`);
console.log(`expectations  : ${fixtures.expectation_engine}`);
console.log(`PASS          : ${pass}/${total} = ${pct(pass)}`);
console.log(`coerce nulls  : ${coerceNulls}`);

latencies.sort((a, b) => a - b);
const p = (q: number) => latencies[Math.min(latencies.length - 1, Math.floor((latencies.length - 1) * q))];
console.log(
  `latency/case  : p50=${p(0.5).toFixed(3)}ms p90=${p(0.9).toFixed(3)}ms max=${latencies[latencies.length - 1].toFixed(3)}ms`,
);

// per-verdict accuracy
const byVerdict = new Map<string, { n: number; ok: number }>();
for (const r of rows) {
  const e = byVerdict.get(r.expected) ?? { n: 0, ok: 0 };
  e.n++; if (r.ok) e.ok++;
  byVerdict.set(r.expected, e);
}
console.log("\nby expected verdict:");
for (const [v, s] of [...byVerdict].sort((a, b) => b[1].n - a[1].n)) {
  const flag = s.ok === s.n ? "" : "   <-- MISMATCH";
  console.log(`  ${v.padEnd(20)} ${String(s.ok).padStart(3)}/${String(s.n).padEnd(3)} = ${(s.ok / s.n * 100).toFixed(1)}%${flag}`);
}

const fails = rows.filter((r) => !r.ok);
if (fails.length) {
  console.log(`\nmismatches (${fails.length}):`);
  const grouped = new Map<string, Row[]>();
  for (const f of fails) {
    const k = `${f.expected} -> ${f.actual}`;
    grouped.set(k, [...(grouped.get(k) ?? []), f]);
  }
  for (const [k, fs] of [...grouped].sort((a, b) => b[1].length - a[1].length)) {
    console.log(`\n  [${fs.length}] expected ${k}`);
    for (const f of fs.slice(0, 6)) {
      console.log(`      ${f.content_key}/${f.case_id}/${f.part}${f.note ? "  (" + f.note + ")" : ""}`);
    }
    if (fs.length > 6) console.log(`      ... +${fs.length - 6} more`);
  }
}

await Deno.writeTextFile(
  `${HERE}harness_results.json`,
  JSON.stringify({
    pass, total, pass_rate: pass / total, coerce_nulls: coerceNulls,
    latency_ms: { p50: p(0.5), p90: p(0.9), max: latencies[latencies.length - 1] },
    by_verdict: Object.fromEntries([...byVerdict].map(([k, v]) => [k, v])),
    rows,
  }, null, 1),
);
console.log(`\nwrote ${HERE}harness_results.json`);
