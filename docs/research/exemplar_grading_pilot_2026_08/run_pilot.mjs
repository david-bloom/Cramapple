#!/usr/bin/env node
//
// Capture script for the exemplar-grading pilot
// (docs/research/exemplar_grading_pilot_2026_08/). Calls the real, live
// evaluate-attempt against a synthetic pilot student for every
// (held-out response, arm, trial) combination and records the raw result as
// JSONL. Structurally adapted from
// docs/research/grading_repair_pilot_2026_07_27/run_pilot.mjs, extended with
// an arm dimension ("off" / "with_exemplar") and a trial dimension (repeated
// calls per arm, since evaluate-attempt's OpenAI call sets no
// temperature/top_p -- see the plan's confirmed-before-finalizing note).
//
// Two modes, selected by PILOT_MODE:
//   "size" (default false) -- runs PILOT_SIZE_REPEATS (default 20) trials on
//     ONE case/arm, to look at the spread of per-criterion outcomes before
//     committing to a trial count for the full run. See analyze_size_run.mjs.
//   "full" -- runs every held-out response x every arm in PILOT_ARMS x
//     PILOT_TRIALS repeats, order shuffled by a seeded PRNG (same LCG
//     constants as scripts/grading-model-assessment/harness.ts's seeded(),
//     duplicated here since that function is not exported) so ordering/
//     caching artifacts cannot systematically favor one arm.
//
// Usage:
//   PILOT_MODE=size node docs/research/exemplar_grading_pilot_2026_08/run_pilot.mjs
//   PILOT_MODE=full PILOT_TRIALS=5 node docs/research/exemplar_grading_pilot_2026_08/run_pilot.mjs
//
// Re-running with the same PILOT_RUN_LABEL resumes: completed
// (case, arm, trial) idempotency keys are skipped, matching the 2026-07-27
// precedent's resume behavior.

import { createHash } from "node:crypto";
import { appendFileSync, existsSync, readFileSync } from "node:fs";
import { resolve } from "node:path";
import { pathToFileURL } from "node:url";

// SHA-256 of the exact serialized request body sent to evaluate-attempt,
// recorded per call as `request_body_sha256`. This is the smallest capture
// change that makes future arm-diff verification possible offline: two
// calls with the same hash provably sent byte-identical requests, and an
// arm=off vs arm=with_exemplar pair differing only in the exemplar section
// can be verified without re-rendering prompts. (Added 2026-08-11 per the
// replan's 1.2 capture-tooling item; the 2026-08-10 capture predates it, so
// its records do not carry the field.)
export function requestBodySha256(serializedBody) {
  return createHash("sha256").update(serializedBody, "utf8").digest("hex");
}

const IS_MAIN = globalThis.Deno
  ? import.meta.main
  : import.meta.url === pathToFileURL(globalThis.process?.argv?.[1] ?? "").href;

const PROJECT_URL = "https://pcntajvbdfqhbeewmdry.supabase.co";
const SESSION_FILE = process.env.PILOT_SESSION_FILE ??
  "/tmp/cramapple_exemplar_pilot_session.json";
const API_KEY = process.env.SUPABASE_PUBLISHABLE_KEY;
const MODE = process.env.PILOT_MODE === "size" ? "size" : "full";
const RUN_LABEL = process.env.PILOT_RUN_LABEL ?? "20260810";
const SEED = Number(process.env.PILOT_SEED ?? "20260810");
const TRIALS = Number(process.env.PILOT_TRIALS ?? "5");
const SIZE_REPEATS = Number(process.env.PILOT_SIZE_REPEATS ?? "20");
const SIZE_ARM = process.env.PILOT_SIZE_ARM === "with_exemplar" ? "with_exemplar" : "off";
const SIZE_CASE = process.env.PILOT_SIZE_CASE ?? null; // "content_key:response_index"
const ARMS = (process.env.PILOT_ARMS ?? "off,with_exemplar")
  .split(",").map((value) => value.trim()).filter(Boolean);
const OUTPUT_FILE = process.env.PILOT_OUTPUT_FILE ??
  (MODE === "size"
    ? "/tmp/cramapple_exemplar_pilot_size_raw.jsonl"
    : "docs/research/exemplar_grading_pilot_2026_08/raw_calls.jsonl");

// Everything below runs only when executed as a script -- the guard lets
// tests import requestBodySha256 without needing env/session files.
if (IS_MAIN) {
if (!API_KEY) throw new Error("SUPABASE_PUBLISHABLE_KEY is required");

const session = JSON.parse(readFileSync(SESSION_FILE, "utf8"));
const USER_ID = session.user?.id;
if (!session.access_token || !USER_ID) {
  throw new Error("Session file is missing the isolated pilot user's bearer token");
}

const heldOutItems = JSON.parse(
  readFileSync(
    resolve("docs/research/exemplar_grading_pilot_2026_08/held_out_items.json"),
    "utf8",
  ),
).items;
const itemByContentKey = new Map(heldOutItems.map((item) => [item.content_key, item]));

const goldCases = JSON.parse(
  readFileSync(resolve("docs/research/exemplar_grading_pilot_2026_08/gold_cases.json"), "utf8"),
);

const exemplarsByItemVersion = JSON.parse(
  readFileSync(resolve("docs/research/exemplar_grading_pilot_2026_08/exemplars.json"), "utf8"),
).exemplars;

function exemplarPayloadFor(contentItemVersionId) {
  const exemplar = exemplarsByItemVersion[contentItemVersionId];
  if (!exemplar) {
    throw new Error(`No exemplar recorded for content_item_version_id=${contentItemVersionId}`);
  }
  return [{
    answer_text: exemplar.answer_text,
    criteria: exemplar.criteria.map((criterion) => ({
      criterion_key: criterion.criterion_key,
      gold_label: criterion.gold_label,
      evidence_quote: criterion.evidence_quote ?? null,
    })),
  }];
}

function deterministicUuid(label) {
  const hex = createHash("sha256").update(`exemplar-pilot-${RUN_LABEL}:${label}`)
    .digest("hex");
  return [
    hex.slice(0, 8),
    hex.slice(8, 12),
    `4${hex.slice(13, 16)}`,
    `a${hex.slice(17, 20)}`,
    hex.slice(20, 32),
  ].join("-");
}

// Same LCG constants as harness.ts's seeded() (not exported there, so
// duplicated here -- see this file's header comment).
function seeded(seed) {
  let state = seed >>> 0;
  return () => ((state = (1664525 * state + 1013904223) >>> 0) / 2 ** 32);
}

function shuffle(list, seed) {
  const random = seeded(seed);
  const copy = [...list];
  for (let i = copy.length - 1; i > 0; i -= 1) {
    const j = Math.floor(random() * (i + 1));
    [copy[i], copy[j]] = [copy[j], copy[i]];
  }
  return copy;
}

function buildCall(goldCase, arm, trial) {
  const item = itemByContentKey.get(goldCase.content_key);
  if (!item) throw new Error(`No held_out_items.json entry for ${goldCase.content_key}`);
  const base = `${goldCase.content_key}:${goldCase.response_index}`;
  const label = `${base}:${arm}:trial-${trial}`;
  return {
    content_key: goldCase.content_key,
    response_index: goldCase.response_index,
    arm,
    trial,
    content_item_version_id: item.content_item_version_id,
    content_item_id: item.content_item_id,
    exam_pack_version_id: item.exam_pack_version_id,
    response_text: goldCase.response_text,
    attempt_id: deterministicUuid(`${base}:attempt`),
    response_version_id: deterministicUuid(`${base}:response`),
    idempotency_key: deterministicUuid(`${label}:grade`),
    exemplars: arm === "with_exemplar" ? exemplarPayloadFor(item.content_item_version_id) : undefined,
  };
}

let calls;
if (MODE === "size") {
  const sizeCase = SIZE_CASE
    ? goldCases.find((c) => `${c.content_key}:${c.response_index}` === SIZE_CASE)
    : goldCases.find((c) => c.content_key === heldOutItems[0].content_key && c.response_index === 0);
  if (!sizeCase) throw new Error(`PILOT_SIZE_CASE not found in gold_cases.json: ${SIZE_CASE}`);
  calls = Array.from({ length: SIZE_REPEATS }, (_, trial) => buildCall(sizeCase, SIZE_ARM, trial));
  console.log(
    `SIZE MODE: ${SIZE_REPEATS} repeats of ${sizeCase.content_key}:${sizeCase.response_index} arm=${SIZE_ARM}`,
  );
} else {
  const gradableCases = goldCases.filter((goldCase) => itemByContentKey.has(goldCase.content_key));
  const allKeys = [...new Set(goldCases.map((c) => c.content_key))];
  for (const key of allKeys) {
    if (!itemByContentKey.has(key)) {
      console.log(`SKIP-ITEM ${key}: not in held_out_items.json (see its "excluded" entry)`);
    }
  }
  const flat = [];
  for (const goldCase of gradableCases) {
    for (const arm of ARMS) {
      for (let trial = 0; trial < TRIALS; trial += 1) {
        flat.push(buildCall(goldCase, arm, trial));
      }
    }
  }
  calls = shuffle(flat, SEED);
  console.log(
    `FULL MODE: ${gradableCases.length} cases (of ${goldCases.length} in gold_cases.json) x ${ARMS.length} arms x ${TRIALS} trials = ${calls.length} calls (seed=${SEED})`,
  );
}
calls.forEach((call, index) => { call.ordinal = index + 1; });

// Only a genuinely successful (2xx) call counts as "completed" for resume
// purposes -- a call that failed (e.g. content_not_published, a transient
// 5xx) must be retried on the next run, not silently treated as done.
const completed = new Set();
if (existsSync(OUTPUT_FILE)) {
  for (const line of readFileSync(OUTPUT_FILE, "utf8").split("\n")) {
    if (!line.trim()) continue;
    const record = JSON.parse(line);
    if (record.idempotency_key && (record.http_status === 200 || record.http_status === 202)) {
      completed.add(record.idempotency_key);
    }
  }
}

const headers = {
  apikey: API_KEY,
  Authorization: `Bearer ${session.access_token}`,
  "Content-Type": "application/json",
};

async function rest(path, init = {}) {
  const response = await fetch(`${PROJECT_URL}/rest/v1/${path}`, {
    ...init,
    headers: {
      ...headers,
      "Accept-Profile": "app",
      "Content-Profile": "app",
      ...(init.headers ?? {}),
    },
  });
  const text = await response.text();
  let body = null;
  try {
    body = text ? JSON.parse(text) : null;
  } catch {
    body = text;
  }
  if (!response.ok) {
    throw new Error(`REST ${response.status}: ${JSON.stringify(body)}`);
  }
  return body;
}

async function ensureAttempt(call) {
  const existing = await rest(`attempts?id=eq.${call.attempt_id}&select=id`);
  if (existing.length) return;
  await rest("attempts", {
    method: "POST",
    headers: { Prefer: "return=minimal" },
    body: JSON.stringify({
      id: call.attempt_id,
      user_id: USER_ID,
      exam_pack_version_id: call.exam_pack_version_id,
      content_item_version_id: call.content_item_version_id,
      attempt_mode: "frq",
      status: "draft",
      assistance_state: "independent",
    }),
  });
}

async function ensureResponse(call) {
  const existing = await rest(`response_versions?id=eq.${call.response_version_id}&select=id`);
  if (existing.length) return;
  await rest("response_versions", {
    method: "POST",
    headers: { Prefer: "return=minimal" },
    body: JSON.stringify({
      id: call.response_version_id,
      attempt_id: call.attempt_id,
      response_text: call.response_text,
      response_parts: {},
      version_number: 1,
      is_submitted: true,
      created_by: USER_ID,
      submitted_at: new Date().toISOString(),
    }),
  });
}

async function runCall(call) {
  await ensureAttempt(call);
  await ensureResponse(call);

  const startedAt = new Date();
  const wallStart = performance.now();
  const requestBody = {
    operation: "grade_initial_attempt",
    attempt_id: call.attempt_id,
    response_version_id: call.response_version_id,
    content_item_version_id: call.content_item_version_id,
    rubric_version_id: call.content_item_version_id,
    idempotency_key: call.idempotency_key,
    assistance_condition: "independent",
    exemplar_mode: call.arm,
  };
  if (call.exemplars) requestBody.exemplars = call.exemplars;

  const serializedBody = JSON.stringify(requestBody);
  const response = await fetch(`${PROJECT_URL}/functions/v1/evaluate-attempt`, {
    method: "POST",
    headers,
    body: serializedBody,
  });
  const responseText = await response.text();
  let responseBody = null;
  try {
    responseBody = responseText ? JSON.parse(responseText) : null;
  } catch {
    responseBody = responseText;
  }
  const finishedAt = new Date();
  const wallMs = Math.round(performance.now() - wallStart);

  let gradingRow = null;
  try {
    const rows = await rest(`grading_results?request_id=eq.${call.idempotency_key}&select=*`);
    gradingRow = rows[0] ?? null;
  } catch (error) {
    gradingRow = { capture_error: String(error) };
  }

  const record = {
    ordinal: call.ordinal,
    content_key: call.content_key,
    response_index: call.response_index,
    arm: call.arm,
    trial: call.trial,
    content_item_version_id: call.content_item_version_id,
    attempt_id: call.attempt_id,
    response_version_id: call.response_version_id,
    idempotency_key: call.idempotency_key,
    request_body_sha256: requestBodySha256(serializedBody),
    response_length_chars: call.response_text.length,
    started_at: startedAt.toISOString(),
    finished_at: finishedAt.toISOString(),
    wall_latency_ms: wallMs,
    http_status: response.status,
    api_response: responseBody,
    grading_result: gradingRow,
  };
  appendFileSync(OUTPUT_FILE, `${JSON.stringify(record)}\n`, "utf8");
  console.log(
    `CALL ${String(call.ordinal).padStart(3, "0")}/${calls.length} ${call.content_key}#${call.response_index} arm=${call.arm} trial=${call.trial} http=${response.status} wall_ms=${wallMs}`,
  );

  if (!response.ok) {
    throw new Error(
      `evaluate-attempt failed for ${call.content_key}#${call.response_index} arm=${call.arm} trial=${call.trial}: ${response.status} ${responseText}`,
    );
  }
}

console.log(`pilot user=${USER_ID} mode=${MODE} output=${OUTPUT_FILE}`);
const failures = [];
for (const call of calls) {
  if (completed.has(call.idempotency_key)) {
    console.log(
      `SKIP ${String(call.ordinal).padStart(3, "0")}/${calls.length} ${call.content_key}#${call.response_index} arm=${call.arm} trial=${call.trial}`,
    );
    continue;
  }
  // A single call's failure (transient 5xx, a rate limit, one bad item) must
  // not abort a run of hundreds of other independent calls -- record it and
  // move on. The failed call is still written to OUTPUT_FILE with its real
  // http_status by runCall itself, and (per the resume logic above) will be
  // retried on the next invocation rather than silently skipped.
  try {
    await runCall(call);
  } catch (error) {
    console.error(`FAILED ${call.content_key}#${call.response_index} arm=${call.arm} trial=${call.trial}: ${error.message}`);
    failures.push({ content_key: call.content_key, response_index: call.response_index, arm: call.arm, trial: call.trial, error: error.message });
  }
}

console.log(`COMPLETE output=${OUTPUT_FILE} failures=${failures.length}`);
if (failures.length) {
  console.log("Failed calls (retry by re-running the same command):");
  for (const failure of failures) {
    console.log(`  ${failure.content_key}#${failure.response_index} arm=${failure.arm} trial=${failure.trial}: ${failure.error}`);
  }
}
} // end IS_MAIN
