#!/usr/bin/env node

import { createHash } from "node:crypto";
import { appendFileSync, existsSync, readFileSync } from "node:fs";
import { resolve } from "node:path";

const PROJECT_URL = "https://pcntajvbdfqhbeewmdry.supabase.co";
const SESSION_FILE = process.env.PILOT_SESSION_FILE ??
  "/tmp/cramapple_grading_pilot_session.json";
const OUTPUT_FILE = process.env.PILOT_OUTPUT_FILE ??
  "/tmp/cramapple_grading_pilot_raw.jsonl";
const API_KEY = process.env.SUPABASE_PUBLISHABLE_KEY;

// Each pilot run creates and then deletes its own synthetic student, so the
// user id cannot be hardcoded -- the 2026-07-27 identity was removed by that
// run's cleanup. It is read from the session file instead, and RUN_LABEL keeps
// the deterministic attempt/response/idempotency UUIDs distinct per run so a
// re-run never silently collides with (or resumes) an earlier one.
const RUN_LABEL = process.env.PILOT_RUN_LABEL ?? "20260728";

if (!API_KEY) {
  throw new Error("SUPABASE_PUBLISHABLE_KEY is required");
}

const session = JSON.parse(readFileSync(SESSION_FILE, "utf8"));
const USER_ID = session.user?.id;
if (!session.access_token || !USER_ID) {
  throw new Error("Session file is missing the isolated pilot user's bearer token");
}
console.log(`pilot user=${USER_ID} run_label=${RUN_LABEL} output=${OUTPUT_FILE}`);

const corpusPath = resolve(
  "docs/research/grading_repair_pilot_2026_07_27/candidate_answers.json",
);
const corpus = JSON.parse(readFileSync(corpusPath, "utf8"));

function deterministicUuid(label) {
  const hex = createHash("sha256").update(`grading-pilot-${RUN_LABEL}:${label}`)
    .digest("hex");
  return [
    hex.slice(0, 8),
    hex.slice(8, 12),
    `4${hex.slice(13, 16)}`,
    `a${hex.slice(17, 20)}`,
    hex.slice(20, 32),
  ].join("-");
}

const calls = corpus.answers.flatMap((item, itemIndex) =>
  item.responses.map((response, responseIndex) => {
    const label = `${itemIndex + 1}:${responseIndex + 1}:${item.content_key}:tier-${response.quality_tier}`;
    return {
      ordinal: itemIndex * 5 + responseIndex + 1,
      content_key: item.content_key,
      content_item_id: item.content_item_id,
      content_item_version_id: item.content_item_version_id,
      subject_key: item.subject_key,
      quality_tier: response.quality_tier,
      response_text: response.text,
      attempt_id: deterministicUuid(`${label}:attempt`),
      response_version_id: deterministicUuid(`${label}:response`),
      idempotency_key: deterministicUuid(`${label}:grade`),
    };
  })
);

const completed = new Set();
if (existsSync(OUTPUT_FILE)) {
  for (const line of readFileSync(OUTPUT_FILE, "utf8").split("\n")) {
    if (!line.trim()) continue;
    const record = JSON.parse(line);
    if (record.idempotency_key) completed.add(record.idempotency_key);
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
  const existing = await rest(
    `attempts?id=eq.${call.attempt_id}&select=id`,
  );
  if (existing.length) return;

  const contentRows = await rest(
    `content_items?id=eq.${call.content_item_id}&select=exam_pack_version_id`,
  );
  if (contentRows.length !== 1) {
    throw new Error(`Content item lookup failed for ${call.content_key}`);
  }

  await rest("attempts", {
    method: "POST",
    headers: { Prefer: "return=minimal" },
    body: JSON.stringify({
      id: call.attempt_id,
      user_id: USER_ID,
      exam_pack_version_id: contentRows[0].exam_pack_version_id,
      content_item_version_id: call.content_item_version_id,
      attempt_mode: "frq",
      status: "draft",
      assistance_state: "independent",
    }),
  });
}

async function ensureResponse(call) {
  const existing = await rest(
    `response_versions?id=eq.${call.response_version_id}&select=id`,
  );
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
  const response = await fetch(
    `${PROJECT_URL}/functions/v1/evaluate-attempt`,
    {
      method: "POST",
      headers,
      body: JSON.stringify({
        operation: "grade_initial_attempt",
        attempt_id: call.attempt_id,
        response_version_id: call.response_version_id,
        content_item_version_id: call.content_item_version_id,
        rubric_version_id: call.content_item_version_id,
        idempotency_key: call.idempotency_key,
        assistance_condition: "independent",
      }),
    },
  );
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
    const rows = await rest(
      `grading_results?request_id=eq.${call.idempotency_key}&select=*`,
    );
    gradingRow = rows[0] ?? null;
  } catch (error) {
    gradingRow = { capture_error: String(error) };
  }

  const record = {
    ...call,
    response_text: undefined,
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
    `CALL ${String(call.ordinal).padStart(2, "0")}/30 ${call.content_key} tier=${call.quality_tier} http=${response.status} wall_ms=${wallMs}`,
  );

  if (!response.ok) {
    throw new Error(
      `evaluate-attempt failed for ${call.content_key} tier ${call.quality_tier}: ${response.status} ${responseText}`,
    );
  }
}

for (const call of calls) {
  if (completed.has(call.idempotency_key)) {
    console.log(
      `SKIP ${String(call.ordinal).padStart(2, "0")}/30 ${call.content_key} tier=${call.quality_tier}`,
    );
    continue;
  }
  await runCall(call);
}

console.log(`COMPLETE output=${OUTPUT_FILE}`);
