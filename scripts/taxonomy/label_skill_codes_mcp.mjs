// Phase B skill-code labeler — TASK-0050 / DECISION-0085.
//
// Forked from extend_serving_labels_mcp.mjs (2026-09-29), which labels serving
// UNITS. This one labels the skill dimension: it assigns one `skill_code` per
// published item, chosen from the (topic × skill) cells already registered for
// that item's topic in `app.taxonomy_cells`.
//
// Same division of labour as its parent: this script never touches a database.
// It reads pre-fetched packets from JSON (produced by running the packet SQL
// through the Supabase MCP tool), calls the models over the Vercel AI Gateway,
// decides the outcome, and writes a SQL file plus a markdown report for the
// caller to apply through the MCP apply_migration tool.
//
// Model roster and promotion rule are DECISION-0085:
//   proposers      openai/gpt-5.5 + google/gemini-2.5-pro   (different labs)
//   adjudicator    anthropic/claude-opus-5                  (must not propose)
//   `validated` is earned by >= 2 of 3 agreeing; no human review pass.
//   No majority (three distinct answers) parks the item as `held`.
//
// All three models run on EVERY item, not only on disagreements, so that
// "unanimous" and "majority-earned" stay distinguishable afterwards without
// re-running the subject. The adjudicator is blind by construction: it receives
// the same prompt as the proposers and never sees their answers.
//
// The candidate list is the FK safety net. A model may only choose from the
// skill codes already registered for that item's topic, and any answer outside
// that list is discarded as a failed call rather than written.
//
// Usage:
//   node label_skill_codes_mcp.mjs --packets=a.json,b.json --subject=ap_statistics \
//     [--out-dir=DIR] [--limit=N] [--concurrency=4] [--gateway-env=PATH]

import fs from "node:fs";
import path from "node:path";

const ROOT = process.cwd();

const arg = (name, fallback = null) => {
  const hit = process.argv.find((a) => a.startsWith(`--${name}=`));
  return hit ? hit.slice(name.length + 3) : fallback;
};

const PACKET_FILES = (arg("packets") || "").split(",").filter(Boolean);
const SUBJECT = arg("subject") || "ap_statistics";
const OUT_DIR = path.resolve(arg("out-dir") || "/private/tmp/cramapple-skill-labels");
const LIMIT = Number(arg("limit") || 0);
const CONCURRENCY = Number(arg("concurrency") || 4);
const GATEWAY_ENV = path.resolve(
  arg("gateway-env") || path.join(ROOT, "scripts/vercel-gateway-check/.env.local"),
);

const PROPOSERS = ["openai/gpt-5.5", "google/gemini-2.5-pro"];
const ADJUDICATOR = "anthropic/claude-opus-5";
const ALL_MODELS = [...PROPOSERS, ADJUDICATOR];

const RUN_STARTED_AT = new Date().toISOString();
const RUN_ID = `skill-codes-${SUBJECT}-${RUN_STARTED_AT.replace(/[-:.TZ]/g, "").slice(0, 14)}`;

// --- env -------------------------------------------------------------------

function loadEnvFile(file) {
  if (!fs.existsSync(file)) throw new Error(`gateway env not found: ${file}`);
  for (const line of fs.readFileSync(file, "utf8").split("\n")) {
    const m = line.match(/^([A-Z0-9_]+)=(.*)$/);
    if (m && !process.env[m[1]]) {
      process.env[m[1]] = m[2].trim().replace(/^["']|["']$/g, "");
    }
  }
}

function requireEnv(name) {
  const v = process.env[name];
  if (!v) throw new Error(`missing env ${name}`);
  return v;
}

// --- prompt ----------------------------------------------------------------

function buildPrompt(item) {
  const cands = item.cands.map((c) => `  ${c.c} — ${c.l}`).join("\n");
  const body = [];
  body.push(`Item key: ${item.k}`);
  body.push(`Item type: ${item.t}`);
  body.push(`Assessed topic: ${item.tc}${item.tt ? ` (${item.tt})` : ""}`);
  body.push("");
  body.push(`Stem: ${item.stem || "(none)"}`);
  if (Array.isArray(item.ch) && item.ch.length) {
    body.push("Answer choices:");
    item.ch.forEach((c, i) => body.push(`  ${String.fromCharCode(65 + i)}. ${c}`));
  }
  if (Array.isArray(item.cr) && item.cr.length) {
    body.push("Scoring criteria (what earns credit):");
    item.cr.forEach((c) => body.push(`  - ${c}`));
  }

  return `You are labelling AP Statistics items with the single AP course SKILL each item
primarily assesses. The topic is already fixed and correct — do not question it.

Choose exactly ONE skill code from this list. These are the only skills registered
as assessed against this topic, so an answer outside the list is invalid:

${cands}

Judge by what the student must actually DO to earn credit, not by the topic's
subject matter. Distinguishing guidance:
- A skill in the 2.x family is about identifying or selecting an approach.
- A skill in the 3.x family is about carrying out a construction or computation.
- A skill in the 4.x family is about describing, interpreting or justifying.
For a free-response item, the scoring criteria are the strongest evidence: they say
what the student is actually credited for doing.

${body.join("\n")}

Reply with ONLY a JSON object, no prose and no code fence:
{"skill_code": "<one code from the list>", "confidence": <0.0-1.0>, "reason": "<one short sentence>"}`;
}

// --- model calls -----------------------------------------------------------

function extractJson(text) {
  if (typeof text !== "string") return null;
  const fenced = text.match(/```(?:json)?\s*([\s\S]*?)```/);
  const raw = fenced ? fenced[1] : text;
  const start = raw.indexOf("{");
  const end = raw.lastIndexOf("}");
  if (start < 0 || end <= start) return null;
  try {
    return JSON.parse(raw.slice(start, end + 1));
  } catch {
    return null;
  }
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
        stream: false,
        temperature: 0,
        max_tokens: 4000,
      }),
      signal: controller.signal,
    });
    const text = await res.text();
    if (!res.ok) {
      // Retry once on a transient upstream/rate error; one failure must not
      // silently become a missing vote.
      if (attempt === 1 && (res.status === 429 || res.status >= 500)) {
        clearTimeout(timeout);
        await new Promise((r) => setTimeout(r, 4000));
        return callModel(model, item, 2);
      }
      throw new Error(`HTTP ${res.status}: ${text.slice(0, 300)}`);
    }
    const data = JSON.parse(text);
    const parsed = extractJson(data.choices?.[0]?.message?.content);
    if (!parsed || typeof parsed.skill_code !== "string") {
      throw new Error("unparseable model output");
    }
    const code = parsed.skill_code.trim();
    const legal = item.cands.some((c) => c.c === code);
    if (!legal) {
      // Off-list answers are discarded, never written. The composite FK would
      // reject them anyway; failing here keeps the reason legible.
      throw new Error(`off-list skill_code ${JSON.stringify(code)}`);
    }
    return {
      ok: true,
      model,
      ms: Date.now() - started,
      skill_code: code,
      confidence: typeof parsed.confidence === "number" ? parsed.confidence : null,
      reason: typeof parsed.reason === "string" ? parsed.reason.slice(0, 300) : null,
      cost: data.usage?.cost ?? data.usage?.market_cost ?? 0,
    };
  } catch (err) {
    return { ok: false, model, ms: Date.now() - started, error: String(err?.message || err) };
  } finally {
    clearTimeout(timeout);
  }
}

// --- consensus -------------------------------------------------------------

function decide(item, calls) {
  const votes = calls.filter((c) => c.ok);
  const tally = new Map();
  for (const v of votes) tally.set(v.skill_code, (tally.get(v.skill_code) || 0) + 1);

  let best = null;
  for (const [code, n] of tally) {
    if (!best || n > best.n) best = { code, n };
  }

  const distinct = tally.size;
  const proposerVotes = votes.filter((v) => PROPOSERS.includes(v.model));
  const adjudicator = votes.find((v) => v.model === ADJUDICATOR) || null;

  if (votes.length < 2) {
    return {
      ...item_id(item),
      outcome: "held",
      reason: "fewer than two usable votes",
      skill_code: null,
      agreement: null,
      votes: voteMap(calls),
    };
  }

  if (best.n >= 2) {
    const unanimous = best.n === votes.length && votes.length === ALL_MODELS.length;
    return {
      ...item_id(item),
      outcome: "validated",
      skill_code: best.code,
      agreement: unanimous ? "unanimous" : "majority_earned",
      votes_for: best.n,
      votes_total: votes.length,
      proposers_agreed: proposerVotes.length === 2 && proposerVotes[0].skill_code === proposerVotes[1].skill_code,
      adjudicator_broke_tie:
        proposerVotes.length === 2 &&
        proposerVotes[0].skill_code !== proposerVotes[1].skill_code &&
        !!adjudicator,
      votes: voteMap(calls),
    };
  }

  return {
    ...item_id(item),
    outcome: "held",
    reason: `no majority across ${distinct} distinct answers`,
    skill_code: null,
    agreement: null,
    votes: voteMap(calls),
  };
}

function item_id(item) {
  return {
    content_key: item.k,
    content_item_id: item.i,
    content_item_version_id: item.v,
    item_type: item.t,
    topic_code: item.tc,
    candidates: item.cands.map((c) => c.c),
  };
}

function voteMap(calls) {
  const out = {};
  for (const c of calls) {
    out[c.model] = c.ok
      ? { skill_code: c.skill_code, confidence: c.confidence, reason: c.reason }
      : { error: c.error };
  }
  return out;
}

// --- SQL -------------------------------------------------------------------

const sqlStr = (v) => (v === null || v === undefined ? "null" : `'${String(v).replace(/'/g, "''")}'`);

function buildSql(results, deterministic) {
  const writable = [
    ...deterministic.map((d) => ({ ...d, agreement: "deterministic_single_candidate" })),
    ...results.filter((r) => r.outcome === "validated"),
  ];
  const held = results.filter((r) => r.outcome === "held");

  const lines = [];
  lines.push(`-- TASK-0050 Phase B — AP Statistics skill codes. Run ${RUN_ID}.`);
  lines.push(`-- Generated ${RUN_STARTED_AT} by scripts/taxonomy/label_skill_codes_mcp.mjs.`);
  lines.push(`-- DECISION-0085: proposers ${PROPOSERS.join(" + ")}, blind adjudicator ${ADJUDICATOR};`);
  lines.push(`-- 'validated' earned by >= 2 of 3 agreeing. NOT APPLIED by the script.`);
  lines.push("--");
  lines.push(`-- Rows written here: ${writable.length} (${deterministic.length} deterministic single-candidate,`);
  lines.push(`-- ${results.filter((r) => r.outcome === "validated").length} model-consensus). Held, not written: ${held.length}.`);
  lines.push("--");
  lines.push("-- is_primary = false on every row: these items already carry a primary");
  lines.push("-- topic-only row, and content_item_cells_one_primary_per_version would");
  lines.push("-- reject a second primary. assignment_status is provisional_model, NOT");
  lines.push("-- validated, because content_item_cells_validation_check still requires a");
  lines.push("-- human validated_by (DECISION-0085's open item). Promotion is a later");
  lines.push("-- UPDATE once that gate clears; the consensus outcome is recorded in");
  lines.push("-- model_run_id so it can be promoted without re-running the subject.");
  lines.push("");
  lines.push("begin;");
  lines.push("");

  for (const r of writable) {
    const runTag = `${RUN_ID}:${r.agreement}`;
    lines.push(
      `insert into app.content_item_cells (content_item_id, content_item_version_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)`,
    );
    lines.push(
      `select ${sqlStr(r.content_item_id)}, ${sqlStr(r.content_item_version_id)}, tsv.taxonomy_source_version, ${sqlStr(r.topic_code)}, ${sqlStr(r.skill_code)}, false, 'provisional_model', 'skill_dimension_phase_b', ${sqlStr(runTag)}`,
    );
    lines.push(
      `from app.taxonomy_source_versions tsv where tsv.subject_key = ${sqlStr(SUBJECT)}`,
    );
    lines.push(`on conflict do nothing;`);
    lines.push("");
  }

  lines.push("commit;");
  lines.push("");
  if (held.length) {
    lines.push("-- Held (no majority), deliberately NOT written:");
    for (const h of held) {
      lines.push(`--   ${h.content_key} topic ${h.topic_code}: ${h.reason}`);
    }
  }
  return lines.join("\n");
}

// --- report ----------------------------------------------------------------

function buildReport(results, deterministic, costs) {
  const validated = results.filter((r) => r.outcome === "validated");
  const unanimous = validated.filter((r) => r.agreement === "unanimous");
  const majority = validated.filter((r) => r.agreement === "majority_earned");
  const tieBroken = validated.filter((r) => r.adjudicator_broke_tie);
  const held = results.filter((r) => r.outcome === "held");
  const proposerAgreed = validated.filter((r) => r.proposers_agreed);

  const l = [];
  l.push(`# AP Statistics Phase B — Skill-Code Labelling Run`);
  l.push("");
  l.push(`**Run:** \`${RUN_ID}\` · **Started:** ${RUN_STARTED_AT}`);
  l.push(`**Governing records:** \`DECISION-0085\`, \`APPROVAL-0060\`, \`TASK-0050\``);
  l.push(`**Models:** proposers \`${PROPOSERS.join("\`, \`")}\`; blind adjudicator \`${ADJUDICATOR}\`.`);
  l.push(`All three ran on every item, so unanimity and majority stay distinguishable.`);
  l.push("");
  l.push(`## Outcome`);
  l.push("");
  l.push(`| | Items |`);
  l.push(`| --- | --- |`);
  l.push(`| Deterministic (topic has one registered skill — no model call) | ${deterministic.length} |`);
  l.push(`| Model-decided, \`validated\` (>= 2 of 3) | ${validated.length} |`);
  l.push(`| — of those, unanimous 3/3 | ${unanimous.length} |`);
  l.push(`| — of those, majority-earned 2/3 | ${majority.length} |`);
  l.push(`| — of those, adjudicator broke a proposer split | ${tieBroken.length} |`);
  l.push(`| Held (no majority) — NOT written | ${held.length} |`);
  l.push(`| **Total** | **${deterministic.length + results.length}** |`);
  l.push("");
  l.push(`**Proposer agreement rate:** ${proposerAgreed.length}/${results.length} = ${((100 * proposerAgreed.length) / Math.max(results.length, 1)).toFixed(1)}%.`);
  l.push(`For context, \`TAXONOMY_LABELING_PLAN_V3\` measured 44% two-model agreement at topic`);
  l.push(`granularity with a ~55-way choice; this run's choice set averages 2.33 candidates, so a`);
  l.push(`materially higher rate is expected and is not by itself evidence of quality.`);
  l.push("");
  l.push(`**Gateway spend:** $${costs.toFixed(4)} across ${results.length * ALL_MODELS.length} calls.`);
  l.push("");
  if (held.length) {
    l.push(`## Held items (no majority)`);
    l.push("");
    l.push(`| Item | Topic | Candidates | Votes |`);
    l.push(`| --- | --- | --- | --- |`);
    for (const h of held) {
      const v = Object.entries(h.votes)
        .map(([m, r]) => `${m.split("/")[1]}=${r.skill_code || "err"}`)
        .join(", ");
      l.push(`| \`${h.content_key}\` | ${h.topic_code} | ${h.candidates.join(", ")} | ${v} |`);
    }
    l.push("");
  }
  l.push(`## What is NOT in this run`);
  l.push("");
  l.push(`- Nothing was applied. The SQL file is written, never executed.`);
  l.push(`- Labels land as \`provisional_model\`, not \`validated\`: \`content_item_cells_validation_check\``);
  l.push(`  still requires a human \`validated_by\` (\`DECISION-0085\`'s open item). The consensus tier is`);
  l.push(`  recorded in \`model_run_id\`, so promotion is one later UPDATE and not a re-run.`);
  l.push(`- These items exist **only in Production**. Development holds different AP Statistics content`);
  l.push(`  (pack \`4e54bb4f\`, 203 MCQ, already skill-labelled), so this cannot be rehearsed in Dev.`);
  l.push(`  Applying it is therefore a Production Hard Gate, outside \`APPROVAL-0060\`.`);
  return l.join("\n");
}

// --- runner ----------------------------------------------------------------

async function pool(items, limit, worker) {
  const out = new Array(items.length);
  let next = 0;
  await Promise.all(
    Array.from({ length: Math.min(limit, items.length) }, async () => {
      while (true) {
        const i = next++;
        if (i >= items.length) return;
        out[i] = await worker(items[i], i);
      }
    }),
  );
  return out;
}

async function main() {
  loadEnvFile(GATEWAY_ENV);
  fs.mkdirSync(OUT_DIR, { recursive: true });

  let packets = [];
  for (const f of PACKET_FILES) {
    packets = packets.concat(JSON.parse(fs.readFileSync(path.resolve(f), "utf8")));
  }
  const seen = new Set();
  packets = packets.filter((p) => {
    if (seen.has(p.v)) return false;
    seen.add(p.v);
    return true;
  });

  const deterministic = packets
    .filter((p) => p.cands.length === 1)
    .map((p) => ({ ...item_id(p), skill_code: p.cands[0].c, outcome: "validated" }));
  let needModel = packets.filter((p) => p.cands.length > 1);
  if (LIMIT > 0) needModel = needModel.slice(0, LIMIT);

  console.log(
    `[${RUN_ID}] ${packets.length} packets: ${deterministic.length} deterministic, ${needModel.length} need a model decision`,
  );

  const cachePath = path.join(OUT_DIR, "results.jsonl");
  const cached = new Map();
  if (fs.existsSync(cachePath)) {
    for (const line of fs.readFileSync(cachePath, "utf8").split("\n").filter(Boolean)) {
      try {
        const r = JSON.parse(line);
        cached.set(r.content_item_version_id, r);
      } catch { /* skip a torn line */ }
    }
    console.log(`[resume] ${cached.size} results already on disk, reusing`);
  }
  const sink = fs.createWriteStream(cachePath, { flags: "a" });

  let done = 0;
  let costs = 0;
  let checkpointed = false;

  const results = await pool(needModel, CONCURRENCY, async (item) => {
    if (cached.has(item.v)) {
      done++;
      return cached.get(item.v);
    }
    const calls = await Promise.all(ALL_MODELS.map((m) => callModel(m, item)));
    for (const c of calls) costs += c.cost || 0;
    const decision = decide(item, calls);
    sink.write(JSON.stringify(decision) + "\n");
    done++;
    if (done % 10 === 0) console.log(`  ... ${done}/${needModel.length}`);

    // Checkpoint the disagreement rate early, per TASK-0050's sizing note: if
    // proposers disagree far more than expected, the adjudication load is what
    // grows, and that is worth knowing at 30 items rather than at 139.
    if (!checkpointed && done >= 30) {
      checkpointed = true;
      const sofar = [...cached.values()];
      console.log(`[checkpoint at ${done}] see report for the agreement rate`);
    }
    return decision;
  });

  sink.end();

  const sql = buildSql(results, deterministic);
  const report = buildReport(results, deterministic, costs);
  fs.writeFileSync(path.join(OUT_DIR, "write_skill_codes.sql"), sql);
  fs.writeFileSync(path.join(OUT_DIR, "run_report.md"), report);
  fs.writeFileSync(
    path.join(OUT_DIR, "decisions.json"),
    JSON.stringify({ run_id: RUN_ID, deterministic, results }, null, 2),
  );

  const validated = results.filter((r) => r.outcome === "validated").length;
  const held = results.filter((r) => r.outcome === "held").length;
  const agreed = results.filter((r) => r.proposers_agreed).length;
  console.log("");
  console.log(`deterministic : ${deterministic.length}`);
  console.log(`validated     : ${validated}`);
  console.log(`held          : ${held}`);
  console.log(`proposers agreed: ${agreed}/${results.length} = ${((100 * agreed) / Math.max(results.length, 1)).toFixed(1)}%`);
  console.log(`gateway spend : $${costs.toFixed(4)}`);
  console.log(`out           : ${OUT_DIR}`);
}

main().catch((err) => {
  console.error("FAILED", err);
  process.exit(1);
});
