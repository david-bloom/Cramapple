// TOPIC labeler — TASK-0050 prerequisite pass.
//
// Sibling of label_skill_codes_mcp.mjs. That script assigns a skill WITHIN a
// known topic; this one assigns the topic itself, which most subjects still lack.
// Only AP Statistics and AP Biology have topic assignments today; the other
// eight subjects have zero, and a skill code cannot attach to an item whose
// topic is unknown.
//
// This is a materially harder judgment than the skill pass. The skill pass picks
// 1 of 2-6 candidates inside a fixed topic and measured 85.6% proposer agreement.
// This one picks 1 of ~81 topics, the granularity at which
// TAXONOMY_LABELING_PLAN_V3 measured only 44% two-model agreement. Expect a lower
// agreement rate and more held items, and do not read that as malfunction.
//
// The existing serving label supplies a UNIT prior, tagged by how much it can be
// trusted:
//   validated          - a human-ratified unit. Strong prior.
//   provisional_model  - an AI proposal. Weak prior.
//   held / none        - a previous pass could not even assign a unit. No prior,
//                        and these items are the least likely to resolve here.
//
// The prior is a HINT, never a constraint: the model may choose any topic in the
// subject. A wrong unit label must be overridable, not propagated. The script
// records whether the chosen topic agreed with the prior so that disagreement
// can be reviewed as a signal about the unit labels themselves.
//
// Same roster and promotion rule as DECISION-0085: proposers gpt-5.5 +
// gemini-2.5-pro, blind adjudicator claude-opus-5, all three on every item,
// >= 2 of 3 to write, no majority parks the item as held.
//
// Writes a SQL file and a report. Never applies anything.
//
// Usage:
//   node label_topics_mcp.mjs --packets=p.json --topics=t.json --subject=ap_calculus_ab \
//     [--out-dir=DIR] [--limit=N] [--concurrency=5]

import fs from "node:fs";
import path from "node:path";

const ROOT = process.cwd();
const arg = (n, d = null) => {
  const h = process.argv.find((a) => a.startsWith(`--${n}=`));
  return h ? h.slice(n.length + 3) : d;
};

const PACKETS = arg("packets");
const TOPICS = arg("topics");
const SUBJECT = arg("subject") || "ap_calculus_ab";
const OUT_DIR = path.resolve(arg("out-dir") || "/private/tmp/cramapple-topic-labels");
const LIMIT = Number(arg("limit") || 0);
const CONCURRENCY = Number(arg("concurrency") || 5);
const GATEWAY_ENV = path.resolve(
  arg("gateway-env") || path.join(ROOT, "scripts/vercel-gateway-check/.env.local"),
);

const PROPOSERS = ["openai/gpt-5.5", "google/gemini-2.5-pro"];
const ADJUDICATOR = "anthropic/claude-opus-5";
const ALL_MODELS = [...PROPOSERS, ADJUDICATOR];

const RUN_STARTED_AT = new Date().toISOString();
const RUN_ID = `topics-${SUBJECT}-${RUN_STARTED_AT.replace(/[-:.TZ]/g, "").slice(0, 14)}`;

function loadEnvFile(file) {
  if (!fs.existsSync(file)) throw new Error(`gateway env not found: ${file}`);
  for (const line of fs.readFileSync(file, "utf8").split("\n")) {
    const m = line.match(/^([A-Z0-9_]+)=(.*)$/);
    if (m && !process.env[m[1]]) process.env[m[1]] = m[2].trim().replace(/^["']|["']$/g, "");
  }
}
const requireEnv = (n) => {
  const v = process.env[n];
  if (!v) throw new Error(`missing env ${n}`);
  return v;
};

let TOPIC_LIST = [];
let TOPIC_SET = new Set();

function topicCatalogue() {
  const byUnit = new Map();
  for (const t of TOPIC_LIST) {
    if (!byUnit.has(t.u)) byUnit.set(t.u, []);
    byUnit.get(t.u).push(t);
  }
  const out = [];
  for (const [u, ts] of [...byUnit.entries()].sort((a, b) => a[0] - b[0])) {
    out.push(`Unit ${u}:`);
    for (const t of ts) out.push(`  ${t.c} — ${t.t}`);
  }
  return out.join("\n");
}

function priorLine(item) {
  const st = item.unit_status;
  if (st === "validated" && item.unit) {
    return `A human-ratified label places this item in Unit ${item.unit}. Treat that as a strong signal, but choose a topic from another unit if the item's content clearly belongs elsewhere.`;
  }
  if (st === "provisional_model" && item.unit) {
    const all = Array.isArray(item.units) && item.units.length ? ` (units touched: ${item.units.join(", ")})` : "";
    return `An unratified AI label suggests Unit ${item.unit}${all}. Treat that as a weak hint only — it has not been checked by a human and may be wrong.`;
  }
  return `No unit label exists for this item: a previous pass could not confidently place it. You have no prior. Judge only from the content, and say so honestly in your confidence if it is genuinely ambiguous.`;
}

function buildPrompt(item) {
  const body = [];
  body.push(`Item key: ${item.k}`);
  body.push(`Item type: ${item.t}`);
  body.push("");
  if (item.stim) body.push(`Context: ${item.stim}`);
  body.push(`Question: ${item.stem || "(none)"}`);
  if (Array.isArray(item.ch) && item.ch.length) {
    body.push("Answer choices:");
    item.ch.forEach((c, i) => body.push(`  ${String.fromCharCode(65 + i)}. ${c}`));
  }
  if (Array.isArray(item.cr) && item.cr.length) {
    body.push("Scoring criteria:");
    item.cr.forEach((c) => body.push(`  - ${c}`));
  }
  if (item.expl) body.push(`Worked explanation: ${item.expl}`);

  return `You are assigning the single AP course TOPIC that an exam item primarily assesses.

Choose exactly ONE topic code from this list. An answer outside the list is invalid.

${topicCatalogue()}

${priorLine(item)}

Judge by the mathematical work the item actually requires, not by vocabulary that
merely appears in it. Two cautions that matter here:
- An item can mention a concept from an early unit while assessing a later one. What
  the student must DO decides the topic.
- Where a topic exists specifically for "selecting procedures" or "connecting
  representations", prefer it only when selection or translation is the point of the
  item, not when the item simply requires a routine computation.

${body.join("\n")}

Reply with ONLY a JSON object, no prose and no code fence:
{"topic_code": "<one code from the list>", "confidence": <0.0-1.0>, "reason": "<one short sentence>"}`;
}

function extractJson(text) {
  if (typeof text !== "string") return null;
  const fenced = text.match(/```(?:json)?\s*([\s\S]*?)```/);
  const raw = fenced ? fenced[1] : text;
  const s = raw.indexOf("{"), e = raw.lastIndexOf("}");
  if (s < 0 || e <= s) return null;
  try { return JSON.parse(raw.slice(s, e + 1)); } catch { return null; }
}

async function callModel(model, item, attempt = 1) {
  const started = Date.now();
  const controller = new AbortController();
  const timeout = setTimeout(() => controller.abort(), 120_000);
  try {
    const res = await fetch("https://ai-gateway.vercel.sh/v1/chat/completions", {
      method: "POST",
      headers: {
        Authorization: `Bearer ${requireEnv("AI_GATEWAY_API_KEY")}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        model,
        messages: [{ role: "user", content: buildPrompt(item) }],
        stream: false, temperature: 0, max_tokens: 4000,
      }),
      signal: controller.signal,
    });
    const text = await res.text();
    if (!res.ok) {
      if (attempt === 1 && (res.status === 429 || res.status >= 500)) {
        clearTimeout(timeout);
        await new Promise((r) => setTimeout(r, 4000));
        return callModel(model, item, 2);
      }
      throw new Error(`HTTP ${res.status}: ${text.slice(0, 300)}`);
    }
    const data = JSON.parse(text);
    const parsed = extractJson(data.choices?.[0]?.message?.content);
    if (!parsed || typeof parsed.topic_code !== "string") throw new Error("unparseable model output");
    const code = parsed.topic_code.trim();
    if (!TOPIC_SET.has(code)) throw new Error(`off-list topic_code ${JSON.stringify(code)}`);
    return {
      ok: true, model, ms: Date.now() - started, topic_code: code,
      confidence: typeof parsed.confidence === "number" ? parsed.confidence : null,
      reason: typeof parsed.reason === "string" ? parsed.reason.slice(0, 300) : null,
      cost: data.usage?.cost ?? data.usage?.market_cost ?? 0,
    };
  } catch (err) {
    return { ok: false, model, ms: Date.now() - started, error: String(err?.message || err) };
  } finally { clearTimeout(timeout); }
}

const unitOf = (code) => TOPIC_LIST.find((t) => t.c === code)?.u ?? null;

function ident(item) {
  return {
    content_key: item.k, content_item_id: item.i, content_item_version_id: item.v,
    item_type: item.t, prior_unit: item.unit ?? null, prior_status: item.unit_status ?? null,
  };
}
function voteMap(calls) {
  const o = {};
  for (const c of calls) o[c.model] = c.ok
    ? { topic_code: c.topic_code, confidence: c.confidence, reason: c.reason }
    : { error: c.error };
  return o;
}

function decide(item, calls) {
  const votes = calls.filter((c) => c.ok);
  const tally = new Map();
  for (const v of votes) tally.set(v.topic_code, (tally.get(v.topic_code) || 0) + 1);
  let best = null;
  for (const [code, n] of tally) if (!best || n > best.n) best = { code, n };

  const proposerVotes = votes.filter((v) => PROPOSERS.includes(v.model));
  const base = { ...ident(item), votes: voteMap(calls) };

  if (votes.length < 2) {
    return { ...base, outcome: "held", reason: "fewer than two usable votes", topic_code: null, agreement: null };
  }
  if (best.n >= 2) {
    const unanimous = best.n === votes.length && votes.length === ALL_MODELS.length;
    const chosenUnit = unitOf(best.code);
    return {
      ...base, outcome: "accepted", topic_code: best.code,
      agreement: unanimous ? "unanimous" : "majority_earned",
      votes_for: best.n, votes_total: votes.length,
      proposers_agreed: proposerVotes.length === 2 && proposerVotes[0].topic_code === proposerVotes[1].topic_code,
      chosen_unit: chosenUnit,
      // Recorded so that disagreement with a *validated* unit can be reviewed as
      // evidence about the unit label, not silently absorbed.
      agrees_with_prior_unit: item.unit ? chosenUnit === item.unit : null,
    };
  }
  return { ...base, outcome: "held", reason: `no majority across ${tally.size} distinct answers`, topic_code: null, agreement: null };
}

const sqlStr = (v) => (v == null ? "null" : `'${String(v).replace(/'/g, "''")}'`);

function buildSql(results) {
  const ok = results.filter((r) => r.outcome === "accepted");
  const held = results.filter((r) => r.outcome === "held");
  const l = [];
  l.push(`-- TASK-0050 topic pass — ${SUBJECT}. Run ${RUN_ID}.`);
  l.push(`-- Generated ${RUN_STARTED_AT} by scripts/taxonomy/label_topics_mcp.mjs. NOT APPLIED.`);
  l.push(`-- ${ok.length} topic assignments; ${held.length} held and deliberately not written.`);
  l.push(`--`);
  l.push(`-- These are is_primary topic-only rows (skill_code NULL), the same shape AP`);
  l.push(`-- Biology's rows took in 20260927004600_biology_topic_labels_into_cells.sql.`);
  l.push(`-- assignment_status is provisional_model: this is an unratified AI proposal,`);
  l.push(`-- at the ~81-way granularity where two-model agreement was measured at 44%.`);
  l.push(`-- It should be reviewed before anything depends on it.`);
  l.push("");
  l.push("begin;");
  l.push("");
  for (const r of ok) {
    l.push(`insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)`);
    l.push(`select ${sqlStr(r.content_item_id)}, ${sqlStr(r.content_item_version_id)}, tsv.taxonomy_source_version, ${sqlStr(r.topic_code)}, null, true, 'provisional_model', 'topic_pass', ${sqlStr(`${RUN_ID}:${r.agreement}`)}`);
    l.push(`from app.taxonomy_source_versions tsv where tsv.subject_key = ${sqlStr(SUBJECT)}`);
    l.push(`on conflict do nothing;`);
    l.push("");
  }
  l.push("commit;");
  return l.join("\n");
}

function buildReport(results, costs) {
  const ok = results.filter((r) => r.outcome === "accepted");
  const held = results.filter((r) => r.outcome === "held");
  const unanimous = ok.filter((r) => r.agreement === "unanimous");
  const majority = ok.filter((r) => r.agreement === "majority_earned");
  const agreed = results.filter((r) => r.proposers_agreed);
  const byPrior = (s) => results.filter((r) => r.prior_status === s);
  const heldBy = (s) => held.filter((r) => r.prior_status === s);
  const okBy = (s) => ok.filter((r) => r.prior_status === s);
  const disagreeValidated = ok.filter((r) => r.prior_status === "validated" && r.agrees_with_prior_unit === false);
  const disagreeProvisional = ok.filter((r) => r.prior_status === "provisional_model" && r.agrees_with_prior_unit === false);

  const l = [];
  l.push(`# ${SUBJECT} — Topic Labelling Run (TASK-0050 prerequisite)`);
  l.push("");
  l.push(`**Run:** \`${RUN_ID}\` · **Started:** ${RUN_STARTED_AT}`);
  l.push(`**Models:** proposers \`${PROPOSERS.join("\`, \`")}\`; blind adjudicator \`${ADJUDICATOR}\`, all three on every item.`);
  l.push(`**Nothing was applied.** The SQL file is written, never executed.`);
  l.push("");
  l.push(`## Outcome`);
  l.push("");
  l.push(`| | Items |`);
  l.push(`| --- | --- |`);
  l.push(`| Accepted (>= 2 of 3 agreed) | ${ok.length} |`);
  l.push(`| — unanimous 3/3 | ${unanimous.length} |`);
  l.push(`| — majority-earned 2/3 | ${majority.length} |`);
  l.push(`| Held (no majority) — NOT written | ${held.length} |`);
  l.push(`| **Total** | **${results.length}** |`);
  l.push("");
  l.push(`**Proposer agreement:** ${agreed.length}/${results.length} = ${((100 * agreed.length) / Math.max(results.length, 1)).toFixed(1)}%.`);
  l.push(`Compare the skill pass on AP Statistics, which reached 85.6% choosing 1 of 2-6 inside a`);
  l.push(`fixed topic, and \`TAXONOMY_LABELING_PLAN_V3\`'s 44% at this ~${TOPIC_LIST.length}-way granularity.`);
  l.push("");
  l.push(`## Resolution by strength of the unit prior`);
  l.push("");
  l.push(`This is the number that says whether the pass is trustworthy where it has no help.`);
  l.push("");
  l.push(`| Prior | Items | Accepted | Held |`);
  l.push(`| --- | --- | --- | --- |`);
  for (const s of ["validated", "provisional_model", "held", null]) {
    const label = s ?? "(no label row)";
    const n = byPrior(s).length;
    if (!n) continue;
    l.push(`| ${label} | ${n} | ${okBy(s).length} | ${heldBy(s).length} |`);
  }
  l.push("");
  l.push(`## Where the chosen topic contradicts the existing unit label`);
  l.push("");
  l.push(`Recorded rather than absorbed: a disagreement with a **validated** unit is evidence`);
  l.push(`about that unit label, and should be looked at before either is trusted.`);
  l.push("");
  l.push(`- Contradicts a **validated** unit: **${disagreeValidated.length}**`);
  l.push(`- Contradicts a provisional unit: ${disagreeProvisional.length}`);
  if (disagreeValidated.length) {
    l.push("");
    l.push(`| Item | Validated unit | Chosen topic | Chosen unit |`);
    l.push(`| --- | --- | --- | --- |`);
    for (const r of disagreeValidated) {
      l.push(`| \`${r.content_key}\` | ${r.prior_unit} | ${r.topic_code} | ${r.chosen_unit} |`);
    }
  }
  if (held.length) {
    l.push("");
    l.push(`## Held items`);
    l.push("");
    l.push(`| Item | Prior | Votes |`);
    l.push(`| --- | --- | --- |`);
    for (const h of held) {
      const v = Object.entries(h.votes).map(([m, r]) => `${m.split("/")[1]}=${r.topic_code || "err"}`).join(", ");
      l.push(`| \`${h.content_key}\` | ${h.prior_status ?? "none"} | ${v} |`);
    }
  }
  l.push("");
  l.push(`**Gateway spend:** $${costs.toFixed(4)} across ${results.length * ALL_MODELS.length} calls.`);
  return l.join("\n");
}

async function pool(items, limit, worker) {
  const out = new Array(items.length);
  let next = 0;
  await Promise.all(Array.from({ length: Math.min(limit, items.length) }, async () => {
    while (true) {
      const i = next++;
      if (i >= items.length) return;
      out[i] = await worker(items[i]);
    }
  }));
  return out;
}

async function main() {
  loadEnvFile(GATEWAY_ENV);
  fs.mkdirSync(OUT_DIR, { recursive: true });
  TOPIC_LIST = JSON.parse(fs.readFileSync(path.resolve(TOPICS), "utf8"));
  TOPIC_SET = new Set(TOPIC_LIST.map((t) => t.c));

  let packets = JSON.parse(fs.readFileSync(path.resolve(PACKETS), "utf8"));
  const seen = new Set();
  packets = packets.filter((p) => (seen.has(p.v) ? false : (seen.add(p.v), true)));
  if (LIMIT > 0) packets = packets.slice(0, LIMIT);

  console.log(`[${RUN_ID}] ${packets.length} items, ${TOPIC_LIST.length} candidate topics`);

  const cachePath = path.join(OUT_DIR, "results.jsonl");
  const cached = new Map();
  if (fs.existsSync(cachePath)) {
    for (const line of fs.readFileSync(cachePath, "utf8").split("\n").filter(Boolean)) {
      try { const r = JSON.parse(line); cached.set(r.content_item_version_id, r); } catch {}
    }
    console.log(`[resume] reusing ${cached.size} cached results`);
  }
  const sink = fs.createWriteStream(cachePath, { flags: "a" });

  let done = 0, costs = 0;
  const results = await pool(packets, CONCURRENCY, async (item) => {
    if (cached.has(item.v)) { done++; return cached.get(item.v); }
    const calls = await Promise.all(ALL_MODELS.map((m) => callModel(m, item)));
    for (const c of calls) costs += c.cost || 0;
    const d = decide(item, calls);
    sink.write(JSON.stringify(d) + "\n");
    if (++done % 10 === 0) console.log(`  ... ${done}/${packets.length}`);
    return d;
  });
  sink.end();

  fs.writeFileSync(path.join(OUT_DIR, "write_topics.sql"), buildSql(results));
  fs.writeFileSync(path.join(OUT_DIR, "run_report.md"), buildReport(results, costs));
  fs.writeFileSync(path.join(OUT_DIR, "decisions.json"), JSON.stringify({ run_id: RUN_ID, results }, null, 2));

  const ok = results.filter((r) => r.outcome === "accepted").length;
  const held = results.filter((r) => r.outcome === "held").length;
  const agreed = results.filter((r) => r.proposers_agreed).length;
  console.log("");
  console.log(`accepted : ${ok}`);
  console.log(`held     : ${held}`);
  console.log(`proposers agreed: ${agreed}/${results.length} = ${((100 * agreed) / Math.max(results.length, 1)).toFixed(1)}%`);
  console.log(`spend    : $${costs.toFixed(4)}`);
  console.log(`out      : ${OUT_DIR}`);
}

main().catch((e) => { console.error("FAILED", e); process.exit(1); });
