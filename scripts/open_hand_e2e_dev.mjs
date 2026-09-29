// TASK-0051 end-to-end check, DEVELOPMENT ONLY.
//
// Proves, through the real deployed functions and a real student JWT:
//   1. an entitled student can read an item's answer key via
//      public.get_open_hand_item, and that writes exactly one exclusion row;
//   2. submitting an answer on that item is then refused by evaluate-attempt
//      with 409 open_hand_item_not_scorable;
//   3. an item the student never viewed still grades normally (200);
//   4. reading the same key again does not add a second exclusion row.
// Then it deletes everything it created and checks nothing is left.
//
// The project URL is hard-coded to Development so this cannot touch Production.
// The Dev secret key comes from SUPABASE_DEV_SECRET_KEY (environment variable,
// or a SUPABASE_DEV_SECRET_KEY= line in .secrets.env). It is never printed.
//
// Usage, from the repo root:
//   node scripts/open_hand_e2e_dev.mjs

import { readFileSync } from "node:fs";

const URL_BASE = "https://wmgjsdkphcyhngaffbqf.supabase.co"; // Development
const PUB = "sb_publishable_75zU2AprWByjZi83_Mzmqw_VdtqaAZt"; // Dev publishable
// Dev's AP Statistics pack: selectable, and 203 published MCQs with keys (2026-09-29).
const DEV_PACK_VERSION_ID = "4e54bb4f-695f-41be-ac06-745fe9ad8bcc";
const DEV_SUBJECT_ID = "19e1a256-df88-4f17-a69e-96052885a137";

function loadSecret() {
  if (process.env.SUPABASE_DEV_SECRET_KEY) {
    return process.env.SUPABASE_DEV_SECRET_KEY.trim();
  }
  try {
    const line = readFileSync(".secrets.env", "utf8").split("\n")
      .find((l) => l.trim().startsWith("SUPABASE_DEV_SECRET_KEY="));
    if (line) return line.split("=").slice(1).join("=").trim().replace(/^["']|["']$/g, "");
  } catch { /* no file */ }
  return null;
}

const SECRET = loadSecret();
if (!SECRET) {
  console.error(
    "No Dev secret key found. Add a line to .secrets.env:\n" +
      "  SUPABASE_DEV_SECRET_KEY=sb_secret_...\n" +
      "(the Dev project's key: Supabase → Dev project → Project Settings → API Keys → Secret keys)",
  );
  process.exit(2);
}

let failures = 0;
const check = (label, ok, detail = "") => {
  console.log(`${ok ? "PASS" : "FAIL"}  ${label}${ok ? "" : `\n      ${detail}`}`);
  if (!ok) failures++;
  return ok;
};

const svc = { apikey: SECRET, authorization: `Bearer ${SECRET}`, "content-type": "application/json" };
const uuid = () => crypto.randomUUID();

async function call(url, { method = "GET", headers = {}, body } = {}) {
  const res = await fetch(url, { method, headers, body: body ? JSON.stringify(body) : undefined });
  const text = await res.text();
  let json = null;
  try { json = JSON.parse(text); } catch { /* keep text */ }
  return { status: res.status, json, text };
}

const rest = (path, opts = {}) =>
  call(`${URL_BASE}/rest/v1/${path}`, {
    ...opts,
    headers: { ...svc, "accept-profile": "app", "content-profile": "app", ...(opts.headers ?? {}) },
  });

const fn = (name, body, token) =>
  call(`${URL_BASE}/functions/v1/${name}`, {
    method: "POST",
    headers: { apikey: PUB, authorization: `Bearer ${token}`, "content-type": "application/json" },
    body,
  });

const openHand = (versionId, token) =>
  call(`${URL_BASE}/rest/v1/rpc/get_open_hand_item`, {
    method: "POST",
    headers: { apikey: PUB, authorization: `Bearer ${token}`, "content-type": "application/json" },
    body: { p_content_item_version_id: versionId },
  });

const exclusionCount = async (userId) => {
  const r = await rest(`open_hand_scoring_exclusions?user_id=eq.${userId}&select=content_item_id`);
  return Array.isArray(r.json) ? r.json.length : -1;
};

// Submit an MCQ answer and grade it. Returns the evaluate-attempt response.
async function answerAndGrade(token, sessionId, versionId, choiceKey) {
  const created = await fn("attempt-response", {
    operation: "create_attempt", idempotency_key: uuid(),
    learning_session_id: sessionId, content_item_version_id: versionId, attempt_mode: "mcq",
  }, token);
  const attemptId = created.json?.result?.attempt?.id ?? created.json?.attempt?.id ?? created.json?.attempt_id;
  if (!attemptId) return { step: "create_attempt", ...created };

  const saved = await fn("attempt-response", {
    operation: "save_response", idempotency_key: uuid(),
    attempt_id: attemptId, response_parts: { selected_choice_key: choiceKey },
  }, token);
  const rvId = saved.json?.result?.response_version?.id ?? saved.json?.response_version?.id ?? saved.json?.response_version_id;
  if (!rvId) return { step: "save_response", ...saved };

  const submitted = await fn("submit-response", {
    operation: "submit", attempt_id: attemptId, response_version_id: rvId, idempotency_key: uuid(),
  }, token);
  if (submitted.status !== 200) return { step: "submit", ...submitted };

  const graded = await fn("evaluate-attempt", {
    attempt_id: attemptId, response_version_id: rvId, idempotency_key: uuid(), operation: "grade",
  }, token);
  return { step: "grade", attemptId, ...graded };
}

let userId = null;

async function main() {
  // --- 0. gate: the key must be Dev's -------------------------------------
  const gate = await call(`${URL_BASE}/auth/v1/admin/users?per_page=1`, { headers: svc });
  if (!check("the Dev secret key is accepted by Development", gate.status === 200,
    `${gate.status} ${gate.text.slice(0, 200)} — this is probably the Production key, not Dev's`)) return;

  // --- 1. a confirmed test student with a real JWT -------------------------
  const email = `smoke+oh-${Date.now()}@cramapple.test`;
  const password = `Smoke!${uuid().slice(0, 12)}`;
  const created = await call(`${URL_BASE}/auth/v1/admin/users`, {
    method: "POST", headers: svc, body: { email, password, email_confirm: true },
  });
  userId = created.json?.id ?? null;
  if (!check("create a confirmed test student", Boolean(userId), created.text.slice(0, 300))) return;
  console.log(`      ${email}`);

  const signin = await call(`${URL_BASE}/auth/v1/token?grant_type=password`, {
    method: "POST", headers: { apikey: PUB, "content-type": "application/json" }, body: { email, password },
  });
  const token = signin.json?.access_token;
  if (!check("the student signs in and holds a JWT", Boolean(token), signin.text.slice(0, 300))) return;

  // --- 2. entitlement + active subject (AP Statistics on Dev) ---------------
  const grant = await rest("subject_entitlements", {
    method: "POST", headers: { prefer: "return=representation" },
    body: { user_id: userId, subject_id: DEV_SUBJECT_ID, access_tier: "trial", source: "smoke_test_task0051" },
  });
  if (!check("grant the student an active AP Statistics entitlement", grant.status === 201,
    `${grant.status} ${grant.text.slice(0, 300)}`)) return;

  // A learning session starts from the profile's active pack
  // (home_session:active_subject_required otherwise).
  const pick = await rest(`profiles?user_id=eq.${userId}`, {
    method: "PATCH", headers: { prefer: "return=representation" },
    body: { active_exam_pack_version_id: DEV_PACK_VERSION_ID },
  });
  if (!check("set AP Statistics as the student's active subject",
    pick.status === 200 && Array.isArray(pick.json) && pick.json.length === 1,
    `${pick.status} ${pick.text.slice(0, 300)}`)) return;

  // --- 3. a learning session and two served MCQ items ----------------------
  const sess = await rest("rpc/start_home_learning_session_for_user", {
    method: "POST", body: { _user_id: userId, _minutes: 20, _idempotency_key: uuid() },
  });
  // The RPC returns a one-row table, so PostgREST sends an array.
  const sessRow = Array.isArray(sess.json) ? sess.json[0] : sess.json;
  const sessionId = typeof sessRow === "string" ? sessRow : sessRow?.learning_session_id ?? sessRow?.id ?? null;
  if (!check("a learning session starts", Boolean(sessionId), `${sess.status} ${sess.text.slice(0, 300)}`)) return;

  const items = await fn("student-session-items",
    { learning_session_id: sessionId, mode: "cell_scoped", item_type: "mcq", limit: 25 }, token);
  const list = (items.json?.result?.items ?? items.json?.items ?? items.json?.data ?? [])
    .map((i) => i.content_item_version_id ?? i.contentItemVersionId).filter(Boolean);
  const versions = [...new Set(list)];
  if (!check("the session serves at least two MCQ items", versions.length >= 2,
    `${items.status} ${items.text.slice(0, 300)}`)) return;

  const choices = await rest(
    `mcq_choices?content_item_version_id=in.(${versions.join(",")})&select=content_item_version_id,choice_key,is_correct`);
  const correctKey = (vid) => (choices.json ?? []).find((c) => c.content_item_version_id === vid && c.is_correct)?.choice_key;
  const usable = versions.filter((v) => correctKey(v));
  if (!check("two items with an answer key are available", usable.length >= 2,
    `${usable.length} usable of ${versions.length}`)) return;
  const [itemA, itemB] = usable;

  // --- 4. view item A's key through Open Hand ------------------------------
  const view1 = await openHand(itemA, token);
  check("the student can read item A's answer key", view1.status === 200 && view1.json?.exclusion_recorded === true
    && Array.isArray(view1.json?.mcq_choices) && view1.json.mcq_choices.some((c) => c.is_correct === true),
    `${view1.status} ${view1.text.slice(0, 300)}`);
  check("viewing writes exactly one exclusion row", (await exclusionCount(userId)) === 1,
    `found ${await exclusionCount(userId)}`);

  // --- 5. answer item A: must be refused -----------------------------------
  const gradedA = await answerAndGrade(token, sessionId, itemA, correctKey(itemA));
  check("evaluate-attempt refuses item A with 409 open_hand_item_not_scorable",
    gradedA.step === "grade" && gradedA.status === 409 && gradedA.json?.error === "open_hand_item_not_scorable",
    `stopped at ${gradedA.step}: ${gradedA.status} ${gradedA.text?.slice(0, 300)}`);

  // --- 6. answer item B (never viewed): must grade normally ----------------
  const gradedB = await answerAndGrade(token, sessionId, itemB, correctKey(itemB));
  check("item B (never viewed) grades normally", gradedB.step === "grade" && gradedB.status === 200,
    `stopped at ${gradedB.step}: ${gradedB.status} ${gradedB.text?.slice(0, 300)}`);
  if (gradedB.attemptId) {
    const gr = await rest(`grading_results?attempt_id=eq.${gradedB.attemptId}&select=status`);
    check("item B has a grading result row", Array.isArray(gr.json) && gr.json.length === 1, gr.text.slice(0, 200));
  }

  // --- 7. view item A again: still one row ---------------------------------
  const view2 = await openHand(itemA, token);
  check("viewing item A again still returns the key", view2.status === 200, `${view2.status} ${view2.text.slice(0, 200)}`);
  check("and still exactly one exclusion row", (await exclusionCount(userId)) === 1,
    `found ${await exclusionCount(userId)}`);
}

// --- cleanup: always runs --------------------------------------------------
async function cleanup() {
  if (!userId) return;
  // These rows either reference the user without ON DELETE CASCADE or block
  // the learning-session cascade (ON DELETE RESTRICT), so they go first.
  await rest(`open_hand_scoring_exclusions?user_id=eq.${userId}`, { method: "DELETE" });
  await rest(`session_targets?user_id=eq.${userId}`, { method: "DELETE" });
  await rest(`audit_events?or=(subject_user_id.eq.${userId},actor_user_id.eq.${userId})`, { method: "DELETE" });
  const del = await call(`${URL_BASE}/auth/v1/admin/users/${userId}`, { method: "DELETE", headers: svc });

  const left = {};
  for (const t of ["profiles", "attempts", "learning_sessions", "subject_entitlements", "open_hand_scoring_exclusions"]) {
    const r = await rest(`${t}?user_id=eq.${userId}&select=user_id`);
    left[t] = Array.isArray(r.json) ? r.json.length : `? (${r.status})`;
  }
  const clean = del.status === 200 && Object.values(left).every((n) => n === 0);
  check("cleanup: test student and all their rows deleted", clean,
    `auth delete ${del.status} ${del.text.slice(0, 200)}; remaining ${JSON.stringify(left)}; user_id ${userId}`);
}

main()
  .catch((e) => { console.error("ERROR", e); failures++; })
  .finally(async () => {
    try { await cleanup(); } catch (e) { console.error("CLEANUP ERROR", e); failures++; }
    console.log(failures === 0 ? "\nALL CHECKS PASSED" : `\n${failures} CHECK(S) FAILED`);
    process.exit(failures === 0 ? 0 : 1);
  });
