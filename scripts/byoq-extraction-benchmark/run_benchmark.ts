// TASK-0068 benchmark runner. Calls the production extraction module
// (supabase/functions/_shared/byoq-extraction.ts) against the rendered fixture
// pages, exactly as the byoq function does, and scores against ground truth.
//
//   deno run --allow-read --allow-write --allow-net --allow-env \
//     scripts/byoq-extraction-benchmark/run_benchmark.ts --model gpt-4.1-mini [--limit 40] [--cohort clean]
//
// The OpenAI key is read from scripts/vercel-gateway-check/.env.local
// (OPENAI_API_KEY) and never printed. Results: fixtures/results-<model>.json
// and fixtures/report-<model>.md.

import { runByoqExtraction, type ExtractionTopicOption } from "../../supabase/functions/_shared/byoq-extraction.ts";
import { detectAnswerLeaks } from "../../supabase/functions/_shared/byoq.ts";

const args = Object.fromEntries(Deno.args.map((a, i, all) => a.startsWith("--") ? [a.slice(2), all[i + 1] ?? "true"] : []).filter((x) => x.length));
const MODEL = args.model ?? "gpt-4.1-mini";
const LIMIT = Number(args.limit ?? 0);
const COHORT = args.cohort ?? null;
const CONCURRENCY = Number(args.concurrency ?? 4);
const HERE = new URL(".", import.meta.url).pathname;
const FIX = HERE + "fixtures/";

const envText = await Deno.readTextFile("/Users/davidbloom/Documents/Cramapple.nosync/scripts/vercel-gateway-check/.env.local");
const env: Record<string, string> = {};
for (const line of envText.split("\n")) {
  const m = line.match(/^\s*(?:export\s+)?([A-Z_]+)\s*=\s*"?([^"\n]*)"?\s*$/);
  if (m) env[m[1]] = m[2];
}
const apiKey = env.OPENAI_API_KEY ?? null;
if (!apiKey) throw new Error("OPENAI_API_KEY not found in .env.local");

const SUBJECT_KEY: Record<string, string> = { biology: "ap_biology" };
const subjectName = (k: string) => ({
  ap_biology: "AP Biology", ap_calculus_ab: "AP Calculus AB", ap_calculus_bc: "AP Calculus BC", ap_chemistry: "AP Chemistry",
  ap_physics_1: "AP Physics 1", ap_physics_2: "AP Physics 2", ap_physics_c_em: "AP Physics C: Electricity and Magnetism",
  ap_physics_c_mechanics: "AP Physics C: Mechanics", ap_precalculus: "AP Precalculus", ap_statistics: "AP Statistics",
} as Record<string, string>)[k] ?? k;

type Topic = { s: string; u: number; ut: string; c: string; t: string };
const topics: Topic[] = JSON.parse(await Deno.readTextFile(FIX + "topics.json"));
type Manifest = { page: string; cohort: string; item_id: string | null; planted: string | null; truth: { subject: string; type: string; unit: number; topic: string; stem: string; choices: { k: string; t: string }[] | null } | null };
let manifest: Manifest[] = JSON.parse(await Deno.readTextFile(FIX + "manifest.json"));
if (COHORT) manifest = manifest.filter((m) => m.cohort === COHORT);
if (LIMIT) manifest = manifest.slice(0, LIMIT);

function norm(s: string) {
  return s.toLowerCase().replace(/[\s ]+/g, " ").replace(/[“”"']/g, "").replace(/[−–]/g, "-").replace(/\s*([.,;:()?!])\s*/g, "$1").trim();
}
function levenshtein(a: string, b: string) {
  const m = a.length, n = b.length;
  if (!m) return n; if (!n) return m;
  let prev = new Array(n + 1).fill(0).map((_, i) => i);
  for (let i = 1; i <= m; i++) {
    const cur = [i];
    for (let j = 1; j <= n; j++) cur[j] = Math.min(prev[j] + 1, cur[j - 1] + 1, prev[j - 1] + (a[i - 1] === b[j - 1] ? 0 : 1));
    prev = cur;
  }
  return prev[n];
}
function similarity(a: string, b: string) {
  const x = norm(a), y = norm(b);
  if (!x && !y) return 1;
  return 1 - levenshtein(x, y) / Math.max(x.length, y.length, 1);
}

async function scoreOne(m: Manifest) {
  const bytes = await Deno.readFile(FIX + m.page);
  const subj = m.truth ? (SUBJECT_KEY[m.truth.subject] ?? m.truth.subject.replaceAll("-", "_")) : null;
  const unitTopics = m.truth ? topics.filter((t) => t.s === subj && t.u === m.truth!.unit) : [];
  const list: ExtractionTopicOption[] = unitTopics.map((t) => ({ code: t.c, title: t.t }));
  const unitLabel = unitTopics[0] ? `Unit ${unitTopics[0].u}: ${unitTopics[0].ut}` : null;
  const t0 = Date.now();
  const out = await runByoqExtraction({
    pages: [{ bytes, mediaType: "image/png" }],
    subjectName: subj ? subjectName(subj) : null,
    unitLabel,
    topics: list,
    apiKey,
    modelId: MODEL,
    timeoutMs: 60_000,
    reserveCost: async () => true,
  });
  const latency = Date.now() - t0;
  const r: Record<string, unknown> = { page: m.page, cohort: m.cohort, planted: m.planted, kind: out.kind, latency_ms: latency };
  if (out.kind !== "proposed") {
    r.failure = out.kind === "failed" ? `${out.failure}:${out.detail}` : out.failure;
    return r;
  }
  const p = out.proposal;
  r.usage = out.usage;
  r.warnings = out.warnings;
  r.is_question = p.is_question;
  r.item_type = p.item_type;
  r.topic_code = p.topic_code;
  r.alternatives = p.alternatives;
  r.answer_key_present = p.answer_key_present;
  r.pii = p.possible_personal_information;
  r.captured_work = p.captured_work;
  r.stem = p.stem;
  r.choices = p.choices;
  if (m.truth) {
    r.type_ok = p.item_type === m.truth.type;
    r.stem_similarity = similarity(p.stem, m.truth.stem);
    if (m.truth.choices) {
      const truthChoices = m.truth.choices.map((c) => c.t);
      r.choice_count_ok = p.choices.length === truthChoices.length;
      const sims = truthChoices.map((t, i) => (p.choices[i] ? similarity(p.choices[i], t) : 0));
      r.choices_ok = r.choice_count_ok && sims.every((s) => s >= 0.9);
      r.choice_min_similarity = Math.min(...sims);
    }
    r.topic_top1 = p.topic_code === m.truth.topic;
    r.topic_top3 = p.topic_code === m.truth.topic || p.alternatives.includes(m.truth.topic);
    // Backstop: proposed text through the leak regex.
    r.leak_flags = detectAnswerLeaks(p.stem, p.choices.map((c, i) => ({ choice_key: String.fromCharCode(65 + i), choice_text: c }))).length;
    const plantedKey = m.planted?.match(/:(\w)$/)?.[1] ?? null;
    r.planted_answer_in_text = plantedKey ? new RegExp(`answer\\s*(?:key)?\\s*[:=]\\s*\\(?${plantedKey}\\)?`, "i").test(p.stem + "\n" + p.choices.join("\n")) : false;
  } else {
    r.abstained = !p.is_question && !p.stem;
  }
  return r;
}

const results: Record<string, unknown>[] = [];
let i = 0;
async function worker() {
  while (i < manifest.length) {
    const m = manifest[i++];
    try {
      results.push(await scoreOne(m));
    } catch (e) {
      results.push({ page: m.page, cohort: m.cohort, kind: "runner_error", failure: String(e) });
    }
    if (results.length % 10 === 0) console.log(`${results.length}/${manifest.length}`);
  }
}
await Promise.all(Array.from({ length: CONCURRENCY }, worker));
await Deno.writeTextFile(FIX + `results-${MODEL}.json`, JSON.stringify(results, null, 1));

// ---- report ----
const pct = (n: number, d: number) => d ? `${(100 * n / d).toFixed(1)}% (${n}/${d})` : "n/a";
const by = (c: string) => results.filter((r) => r.cohort === c && r.kind === "proposed");
const lines: string[] = [`# BYOQ extraction benchmark — model ${MODEL} — ${new Date().toISOString()}`, ""];
lines.push(`Pages: ${results.length}; proposed ${results.filter((r) => r.kind === "proposed").length}; failed ${results.filter((r) => r.kind !== "proposed").length}`);
const lat = results.map((r) => r.latency_ms as number).sort((a, b) => a - b);
lines.push(`Latency median ${lat[Math.floor(lat.length / 2)] ?? 0} ms, p90 ${lat[Math.floor(lat.length * 0.9)] ?? 0} ms`);
const tokens = results.reduce((a, r) => { const u = r.usage as { input_tokens: number | null; output_tokens: number | null } | undefined; return [a[0] + (u?.input_tokens ?? 0), a[1] + (u?.output_tokens ?? 0)]; }, [0, 0]);
lines.push(`Tokens: input ${tokens[0]}, output ${tokens[1]} (per page avg ${Math.round(tokens[0] / Math.max(1, results.length))} in / ${Math.round(tokens[1] / Math.max(1, results.length))} out)`);
lines.push("", "| cohort | n | type ok | stem ≥0.95 | stem ≥0.85 | mean stem sim | choices exact | topic top-1 | topic top-3 | leak flags | planted answer in text |", "|---|---|---|---|---|---|---|---|---|---|---|");
for (const c of ["clean", "degraded", "control"]) {
  const rs = by(c).filter((r) => r.type_ok !== undefined);
  const mcq = rs.filter((r) => r.choices_ok !== undefined);
  const mean = rs.length ? (rs.reduce((a, r) => a + (r.stem_similarity as number), 0) / rs.length).toFixed(3) : "n/a";
  lines.push(`| ${c} | ${rs.length} | ${pct(rs.filter((r) => r.type_ok).length, rs.length)} | ${pct(rs.filter((r) => (r.stem_similarity as number) >= 0.95).length, rs.length)} | ${pct(rs.filter((r) => (r.stem_similarity as number) >= 0.85).length, rs.length)} | ${mean} | ${pct(mcq.filter((r) => r.choices_ok).length, mcq.length)} | ${pct(rs.filter((r) => r.topic_top1).length, rs.length)} | ${pct(rs.filter((r) => r.topic_top3).length, rs.length)} | ${rs.filter((r) => (r.leak_flags as number) > 0).length} | ${rs.filter((r) => r.planted_answer_in_text).length} |`);
}
lines.push("", "## Planted controls");
for (const r of results.filter((x) => x.cohort === "control")) {
  const planted = String(r.planted);
  let verdict = "";
  if (planted.startsWith("circled") || planted.startsWith("handwritten") || planted.startsWith("answer_line")) verdict = `captured_work=${r.captured_work ? "yes" : "NO"}; leak_flags=${r.leak_flags}; in_text=${r.planted_answer_in_text}`;
  else if (planted.startsWith("answer_key")) verdict = `answer_key_present=${r.answer_key_present}; captured_work=${r.captured_work ? "LEAKED" : "none"}; in_text=${r.planted_answer_in_text}`;
  else if (planted === "name") verdict = `pii=${r.pii}`;
  else if (planted === "blank" || planted === "notes") verdict = `abstained=${r.abstained}`;
  lines.push(`- ${planted} (${r.page}): ${r.kind === "proposed" ? verdict : r.failure}`);
}
lines.push("", "## Per-subject (clean + degraded)");
const subjects = [...new Set(manifest.filter((m) => m.truth).map((m) => m.truth!.subject))];
for (const s of subjects) {
  const rs = results.filter((r) => r.kind === "proposed" && r.cohort !== "control" && manifest.find((m) => m.page === r.page)?.truth?.subject === s);
  if (!rs.length) continue;
  const mean = (rs.reduce((a, r) => a + (r.stem_similarity as number), 0) / rs.length).toFixed(3);
  lines.push(`- ${s}: n=${rs.length}, type ${pct(rs.filter((r) => r.type_ok).length, rs.length)}, mean stem sim ${mean}, topic top-1 ${pct(rs.filter((r) => r.topic_top1).length, rs.length)}, top-3 ${pct(rs.filter((r) => r.topic_top3).length, rs.length)}`);
}
await Deno.writeTextFile(FIX + `report-${MODEL}.md`, lines.join("\n") + "\n");
console.log(lines.join("\n"));
