// End-to-end smoke test for the student submit-to-grade path.
//
// Why this exists: as of 2026-09-29 no brand-new student has ever been taken
// from signup to a graded answer against a deployed environment. Every
// component of this path has been tested in isolation; the path itself has
// not. This drives the REAL deployed edge functions with a REAL new user and a
// real JWT -- nothing is stubbed and nothing is asserted from source.
//
// It deliberately answers a multiple-choice question WRONG, because the wrong
// answer is the interesting case: it is the branch that produces student-facing
// feedback. The test reads the answer key with the secret key purely to pick a
// choice that is not the correct one; the student's own calls never see it.
//
// Usage (Development):
//   SMOKE_URL=https://<ref>.supabase.co \
//   SMOKE_PUBLISHABLE_KEY=sb_publishable_... \
//   SMOKE_SECRET_KEY=sb_secret_... \
//   node scripts/student_grade_smoke.mjs
//
// Exits non-zero if any check fails. Creates one user and leaves it in place so
// the run is inspectable; the email is prefixed so such accounts are findable.

const URL_BASE = process.env.SMOKE_URL;
const PUB = process.env.SMOKE_PUBLISHABLE_KEY;
const SECRET = process.env.SMOKE_SECRET_KEY;
const PRIVACY = process.env.SMOKE_PRIVACY_VERSION ?? "2026-08-01";
// The subject the student practises. A session starts from the profile's
// active pack, so the test must pick one (the app does this in onboarding).
const SUBJECT_KEY = process.env.SMOKE_SUBJECT_KEY ?? "ap-statistics";

if (!URL_BASE || !PUB || !SECRET) {
  console.error("SMOKE_URL, SMOKE_PUBLISHABLE_KEY and SMOKE_SECRET_KEY are required");
  process.exit(2);
}

let failures = 0;
const check = (label, ok, detail = "") => {
  console.log(`${ok ? "PASS" : "FAIL"}  ${label}${ok ? "" : `\n      ${detail}`}`);
  if (!ok) failures++;
  return Boolean(ok);
};

// Set only when main() runs to its last check. An early return must never
// read as a pass.
let completed = false;

// Secret keys are not JWTs, so they go in the apikey header. Sending one as a
// bearer token authenticates as anon and the call silently under-reads.
const svcHeaders = {
  apikey: SECRET,
  authorization: `Bearer ${SECRET}`,
  "content-type": "application/json",
};

async function rest(path, { method = "GET", body, headers, schema } = {}) {
  const res = await fetch(`${URL_BASE}/rest/v1/${path}`, {
    method,
    headers: {
      ...svcHeaders,
      ...(schema ? { "accept-profile": schema, "content-profile": schema } : {}),
      ...headers,
    },
    body: body ? JSON.stringify(body) : undefined,
  });
  const text = await res.text();
  let json = null;
  try { json = JSON.parse(text); } catch { /* keep text */ }
  return { status: res.status, json, text };
}

async function fn(name, body, token) {
  const res = await fetch(`${URL_BASE}/functions/v1/${name}`, {
    method: "POST",
    headers: {
      apikey: PUB,
      authorization: `Bearer ${token}`,
      "content-type": "application/json",
    },
    body: JSON.stringify(body),
  });
  const text = await res.text();
  let json = null;
  try { json = JSON.parse(text); } catch { /* keep text */ }
  return { status: res.status, json, text };
}

const uuid = () => crypto.randomUUID();

async function main() {
  // --- 1. a brand-new student, created through the public signup path -------
  const email = `smoke+grade-${Date.now()}@cramapple.test`;
  const password = `Smoke!${crypto.randomUUID().slice(0, 12)}`;

  let signup = await fetch(`${URL_BASE}/auth/v1/signup`, {
    method: "POST",
    headers: { apikey: PUB, "content-type": "application/json" },
    body: JSON.stringify({ email, password }),
  });
  let auth = await signup.json();
  let token = auth?.access_token ?? null;

  if (!token) {
    // Email confirmation is on. Fall back to an admin-created, pre-confirmed
    // user and say so, because that is a WEAKER test than the public path.
    console.log("NOTE  public signup returned no session (email confirmation on); using admin-created user");
    const created = await fetch(`${URL_BASE}/auth/v1/admin/users`, {
      method: "POST",
      headers: svcHeaders,
      body: JSON.stringify({ email, password, email_confirm: true }),
    });
    const createdJson = await created.json();
    if (!createdJson?.id) {
      check("create a new student", false, JSON.stringify(createdJson).slice(0, 300));
      return;
    }
    const signin = await fetch(`${URL_BASE}/auth/v1/token?grant_type=password`, {
      method: "POST",
      headers: { apikey: PUB, "content-type": "application/json" },
      body: JSON.stringify({ email, password }),
    });
    auth = await signin.json();
    token = auth?.access_token ?? null;
  }
  check("a brand-new student can sign up and hold a session", Boolean(token),
    JSON.stringify(auth).slice(0, 300));
  if (!token) return;
  const userId = auth?.user?.id;

  // --- 2. entitlement ------------------------------------------------------
  // Production grants a trial on every active subject through start-trial.
  // Development has no start-trial function; there the test grants the chosen
  // subject directly and says so, because that is a weaker test.
  const subj = await rest(`subjects?subject_key=eq.${SUBJECT_KEY}&select=id`, { schema: "app" });
  const subjectId = subj.json?.[0]?.id;
  if (!check(`subject ${SUBJECT_KEY} exists`, Boolean(subjectId), subj.text.slice(0, 200))) return;

  const trial = await fn("start-trial", { privacy_notice_version: PRIVACY }, token);
  if (trial.status === 404) {
    console.log("NOTE  no start-trial function here (Development); granting the subject directly");
    const grant = await rest("subject_entitlements", {
      method: "POST", schema: "app", headers: { prefer: "return=representation" },
      body: { user_id: userId, subject_id: subjectId, access_tier: "trial", source: "smoke_test" },
    });
    check("the new student is entitled", grant.status === 201, `${grant.status} ${grant.text.slice(0, 300)}`);
  } else {
    check("start-trial grants the new student access", trial.status === 200,
      `${trial.status} ${trial.text.slice(0, 300)}`);
  }

  // --- 3. pick the subject, then a learning session ------------------------
  const packs = await rest(`exam_packs?subject_id=eq.${subjectId}&select=id`, { schema: "app" });
  const packIds = (packs.json ?? []).map((p) => p.id);
  const versions = packIds.length ? await rest(
    `exam_pack_versions?exam_pack_id=in.(${packIds.join(",")})&status=eq.published&retired_at=is.null&select=id`,
    { schema: "app" },
  ) : { json: [] };
  // Of the selectable versions, take the one with the most published MCQs
  // (Development carries a near-empty fixture pack alongside the real one).
  let packVersionId = null;
  let bestCount = 0;
  for (const v of versions.json ?? []) {
    const ok = await rest("rpc/exam_pack_version_is_selectable", {
      method: "POST", schema: "app", body: { _version_id: v.id },
    });
    if (ok.json !== true) continue;
    const mcqs = await rest(
      `content_items?exam_pack_version_id=eq.${v.id}&status=eq.published&item_type=eq.mcq&select=id`,
      { schema: "app" },
    );
    const n = Array.isArray(mcqs.json) ? mcqs.json.length : 0;
    if (n > bestCount) { bestCount = n; packVersionId = v.id; }
  }
  if (!check(`a selectable ${SUBJECT_KEY} pack exists`, Boolean(packVersionId),
    `${(versions.json ?? []).length} published version(s), none selectable`)) return;

  const pick = await rest(`profiles?user_id=eq.${userId}`, {
    method: "PATCH", schema: "app", headers: { prefer: "return=representation" },
    body: { active_exam_pack_version_id: packVersionId },
  });
  if (!check("the student's active subject is set", pick.status === 200,
    `${pick.status} ${pick.text.slice(0, 300)}`)) return;

  const sess = await rest("rpc/start_home_learning_session_for_user", {
    method: "POST", schema: "app",
    body: { _user_id: userId, _minutes: 20, _idempotency_key: uuid() },
  });
  // The RPC returns a one-row table, so PostgREST sends an array.
  const sessRow = Array.isArray(sess.json) ? sess.json[0] : sess.json;
  const sessionId = typeof sessRow === "string"
    ? sessRow
    : sessRow?.learning_session_id ?? sessRow?.id ?? null;
  check("a learning session starts", Boolean(sessionId),
    `${sess.status} ${sess.text.slice(0, 300)}`);
  if (!sessionId) return;

  // --- 4. items are served -------------------------------------------------
  const items = await fn("student-session-items",
    { learning_session_id: sessionId, mode: "cell_scoped", item_type: "mcq", limit: 25 }, token);
  // Functions reply as {status, function, result}.
  const list = items.json?.result?.items ?? items.json?.items ?? items.json?.data ?? [];
  check("the session serves MCQ items", Array.isArray(list) && list.length > 0,
    `${items.status} ${items.text.slice(0, 400)}`);
  if (!Array.isArray(list) || list.length === 0) return;

  // --- 5. pick an item whose distractors carry rationales, and answer WRONG -
  const versionIds = list
    .map((i) => i.content_item_version_id ?? i.contentItemVersionId)
    .filter(Boolean);
  const choices = await rest(
    `mcq_choices?content_item_version_id=in.(${versionIds.join(",")})` +
    `&select=content_item_version_id,choice_key,is_correct,rationale`,
    { schema: "app" },
  );
  if (!Array.isArray(choices.json)) {
    check("answer key readable for choosing a wrong answer", false,
      `${choices.status} ${choices.text.slice(0, 300)}`);
    return;
  }
  const byVersion = new Map();
  for (const c of choices.json) {
    if (!byVersion.has(c.content_item_version_id)) byVersion.set(c.content_item_version_id, []);
    byVersion.get(c.content_item_version_id).push(c);
  }
  let target = null;
  for (const [vid, cs] of byVersion) {
    const wrong = cs.find((c) => !c.is_correct && c.rationale && c.rationale.trim());
    if (wrong) { target = { versionId: vid, wrong }; break; }
  }
  check("an item with an authored distractor rationale is available", Boolean(target),
    `${byVersion.size} item(s) inspected, none had a rationale-bearing distractor`);
  if (!target) return;

  // --- 6. attempt -> response -> submit -> grade ---------------------------
  const created = await fn("attempt-response", {
    operation: "create_attempt",
    idempotency_key: uuid(),
    learning_session_id: sessionId,
    content_item_version_id: target.versionId,
    attempt_mode: "mcq",
  }, token);
  const attemptId = created.json?.result?.attempt?.id ?? created.json?.attempt?.id ?? created.json?.attempt_id;
  check("an attempt is created", Boolean(attemptId),
    `${created.status} ${created.text.slice(0, 400)}`);
  if (!attemptId) return;

  const saved = await fn("attempt-response", {
    operation: "save_response",
    idempotency_key: uuid(),
    attempt_id: attemptId,
    response_parts: { selected_choice_key: target.wrong.choice_key },
  }, token);
  const responseVersionId = saved.json?.result?.response_version?.id ??
    saved.json?.response_version?.id ?? saved.json?.response_version_id;
  check("the answer is saved", Boolean(responseVersionId),
    `${saved.status} ${saved.text.slice(0, 400)}`);
  if (!responseVersionId) return;

  // The app submits through attempt-response. Production has no
  // submit-response function deployed.
  const submitted = await fn("attempt-response", {
    operation: "submit_response",
    attempt_id: attemptId,
    response_version_id: responseVersionId,
    idempotency_key: uuid(),
  }, token);
  check("the answer is submitted", submitted.status === 200,
    `${submitted.status} ${submitted.text.slice(0, 400)}`);

  const graded = await fn("evaluate-attempt", {
    attempt_id: attemptId,
    response_version_id: responseVersionId,
    idempotency_key: uuid(),
    operation: "grade_initial_attempt",
  }, token);
  check("evaluate-attempt grades the answer", graded.status === 200,
    `${graded.status} ${graded.text.slice(0, 500)}`);

  // --- 7. the thing this is all for: what does the student actually read? ---
  const results = await rest(
    `grading_results?attempt_id=eq.${attemptId}` +
    `&select=status,points_earned,points_available,highest_value_gap,criterion_results`,
    { schema: "app" },
  );
  const row = Array.isArray(results.json) ? results.json[0] : null;
  check("a grading result is persisted", Boolean(row),
    `${results.status} ${results.text.slice(0, 300)}`);
  if (!row) return;

  const summary = graded.json?.result?.student_facing_summary ??
    graded.json?.student_facing_summary ?? null;
  const gapFix = row.highest_value_gap?.minimum_fix ?? "";

  console.log("\n--- what the student reads ---");
  console.log(summary ?? "(no student_facing_summary in the response)");
  console.log(`--- highest_value_gap.minimum_fix: ${gapFix || "(none)"}`);
  console.log(`--- authored rationale for the chosen distractor: ${target.wrong.rationale}\n`);

  check("the wrong answer scored zero", row.points_earned === 0,
    `points_earned=${row.points_earned}`);
  check("feedback is NOT the retired placeholder",
    !`${summary} ${gapFix}`.includes("published correct answer"),
    "the placeholder string is still being emitted");
  check("feedback reflects the distractor the student actually chose",
    Boolean(summary) && summary.includes(target.wrong.rationale.replace(/\.$/, "").slice(0, 40)),
    `summary did not contain the authored rationale`);
  completed = true;
}

main()
  .then(() => {
    if (!completed && failures === 0) {
      check("the test ran to completion", false, "main() returned before the final checks");
    }
    console.log(failures === 0 ? "\nALL CHECKS PASSED" : `\n${failures} CHECK(S) FAILED`);
    process.exit(failures === 0 ? 1 * 0 : 1);
  })
  .catch((e) => { console.error("SMOKE ERROR", e); process.exit(1); });
