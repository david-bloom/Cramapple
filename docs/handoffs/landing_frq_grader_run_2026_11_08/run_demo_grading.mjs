// Grades the authored landing-page demo answers through the REAL deployed
// attempt-response + evaluate-attempt functions in Development (same bundle
// hashes as Production on 2026-11-01). Modelled on scripts/frq_photo_smoke.mjs.
// Env: URL_BASE, PUB, SECRET, ANSWERS (path to answers.json), OUT. Prints no secrets.
import { readFile, writeFile } from "node:fs/promises";

const URL_BASE = process.env.URL_BASE;
const PUB = process.env.PUB;
const SECRET = process.env.SECRET;
const OUT = process.env.OUT ?? "grading_run.json";
if (!URL_BASE || !PUB || !SECRET) { console.error("URL_BASE, PUB, SECRET required"); process.exit(2); }

const svcHeaders = { apikey: SECRET, authorization: `Bearer ${SECRET}`, "content-type": "application/json" };
async function rest(path, { method = "GET", body, headers, schema } = {}) {
  const res = await fetch(`${URL_BASE}/rest/v1/${path}`, {
    method, headers: { ...svcHeaders, ...(schema ? { "accept-profile": schema, "content-profile": schema } : {}), ...(headers ?? {}) },
    body: body ? JSON.stringify(body) : undefined,
  });
  const text = await res.text(); let json = null; try { json = JSON.parse(text); } catch {}
  return { status: res.status, json, text };
}
async function fn(name, body, token) {
  const res = await fetch(`${URL_BASE}/functions/v1/${name}`, {
    method: "POST",
    headers: { apikey: PUB, authorization: `Bearer ${token ?? PUB}`, "content-type": "application/json", origin: "https://app.cramapple.com" },
    body: JSON.stringify(body),
  });
  const text = await res.text(); let json = null; try { json = JSON.parse(text); } catch {}
  return { status: res.status, json, text };
}
const uuid = () => crypto.randomUUID();
const result = (r) => r.json?.result ?? r.json ?? {};

async function newUser() {
  const email = `smoke+demofrq-${Date.now()}@cramapple.test`;
  const password = `Smoke!${crypto.randomUUID().slice(0, 12)}`;
  const created = await fetch(`${URL_BASE}/auth/v1/admin/users`, { method: "POST", headers: svcHeaders, body: JSON.stringify({ email, password, email_confirm: true }) });
  const cj = await created.json();
  if (!cj?.id) throw new Error("create user: " + JSON.stringify(cj).slice(0, 300));
  const signin = await fetch(`${URL_BASE}/auth/v1/token?grant_type=password`, { method: "POST", headers: { apikey: PUB, "content-type": "application/json" }, body: JSON.stringify({ email, password }) });
  const auth = await signin.json();
  if (!auth?.access_token) throw new Error("sign in: " + JSON.stringify(auth).slice(0, 300));
  return { token: auth.access_token, userId: auth.user?.id ?? cj.id, email };
}

const SUBJECTS = {
  "ap-statistics": { subjectId: "19e1a256-df88-4f17-a69e-96052885a137", epv: "4e54bb4f-695f-41be-ac06-745fe9ad8bcc" },
  "ap-calculus-ab": { subjectId: "464fd1df-6be7-477e-abf0-707f23ced2ea", epv: "83efef8e-0819-4dcf-9bb8-a8ae32468f65" },
  "ap-chemistry": { subjectId: "96dd769e-09ae-4779-9197-7be97526e09f", epv: "1f2d6d5b-1d90-4d08-b323-93fddd773bcd" },
  "ap-physics-1": { subjectId: "4c0e85b4-e650-4f4c-a4b8-7ca60a5165cb", epv: "e7c3815e-0888-4a7c-8a04-b697c2906b45" },
};

async function main() {
  const answers = JSON.parse(await readFile(process.env.ANSWERS, "utf8")); // [{subject_key, content_key, answer}]
  const student = await newUser();
  console.log("student", student.userId);
  const out = [];
  for (const [subjectKey, cfg] of Object.entries(SUBJECTS)) {
    const mine = answers.filter((a) => a.subject_key === subjectKey);
    if (!mine.length) continue;
    const grant = await rest("subject_entitlements", { method: "POST", schema: "app", headers: { prefer: "return=representation" }, body: { user_id: student.userId, subject_id: cfg.subjectId, access_tier: "trial", source: "smoke_test" } });
    console.log(subjectKey, "entitled", grant.status);
    const pick = await rest(`profiles?user_id=eq.${student.userId}`, { method: "PATCH", schema: "app", headers: { prefer: "return=representation" }, body: { active_exam_pack_version_id: cfg.epv } });
    console.log(subjectKey, "active pack", pick.status, pick.status !== 200 ? pick.text.slice(0, 200) : "");
    const sess = await fn("session-event", { operation: "session_start", idempotency_key: uuid(), exam_pack_version_id: cfg.epv, entry_path: "self_guided_format", session_mode: "focused", available_minutes: 20, practice_format: "targeted_drill" }, student.token);
    const sessionId = result(sess).id ?? null;
    console.log(subjectKey, "session", sess.status, sessionId ?? sess.text.slice(0, 200));
    if (!sessionId) continue;
    for (const a of mine) {
      const ver = await rest(`content_item_versions?select=id,content_item_id,content_items!inner(content_key,exam_pack_version_id)&status=eq.published&content_items.content_key=eq.${encodeURIComponent(a.content_key)}&content_items.exam_pack_version_id=eq.${cfg.epv}`, { schema: "app" });
      const versionId = ver.json?.[0]?.id;
      const rec = { subject_key: subjectKey, content_key: a.content_key, version_id: versionId, steps: {} };
      out.push(rec);
      if (!versionId) { rec.error = "version not found: " + ver.text.slice(0, 200); console.log(a.content_key, rec.error); continue; }
      const created = await fn("attempt-response", { operation: "create_attempt", idempotency_key: uuid(), learning_session_id: sessionId, content_item_version_id: versionId, attempt_mode: "frq" }, student.token);
      const attemptId = result(created).attempt?.id; rec.attempt_id = attemptId; rec.steps.create = created.status;
      if (!attemptId) { rec.error = "create_attempt: " + created.text.slice(0, 300); console.log(a.content_key, rec.error); continue; }
      const draft = await fn("attempt-response", { operation: "save_response", idempotency_key: uuid(), attempt_id: attemptId, response_text: a.answer }, student.token);
      const rvId = result(draft).response_version?.id; rec.response_version_id = rvId; rec.steps.save = draft.status;
      if (!rvId) { rec.error = "save_response: " + draft.text.slice(0, 300); console.log(a.content_key, rec.error); continue; }
      const submitted = await fn("attempt-response", { operation: "submit_response", idempotency_key: uuid(), attempt_id: attemptId, response_version_id: rvId }, student.token);
      rec.steps.submit = submitted.status;
      if (submitted.status !== 200) { rec.error = "submit_response: " + submitted.text.slice(0, 300); console.log(a.content_key, rec.error); continue; }
      const graded = await fn("evaluate-attempt", {
        operation: "grade_initial_attempt", idempotency_key: uuid(), attempt_id: attemptId, response_version_id: rvId,
        content_item_version_id: versionId, rubric_version_id: versionId,
        assistance_condition: "independent", assistance_state: { attempt_condition: "cold", independent_diagnostic_evidence: true, help_level_used: null },
      }, student.token);
      rec.steps.grade = graded.status; rec.grade_response = graded.json ?? graded.text.slice(0, 500);
      const row = await rest(`grading_results?attempt_id=eq.${attemptId}&order=created_at.desc&limit=1&select=id,status,model_id,prompt_version,points_earned,points_available,confidence,uncertainty_reason,feedback_preview,action_hint,repair_hint,highest_value_gap,criterion_results,deterministic_verifier_version,boundary_contract_version,created_at`, { schema: "app" });
      rec.grading_result = row.json?.[0] ?? null;
      const crit = await rest(`frq_criteria?content_item_version_id=eq.${versionId}&select=criterion_key,learner_facing_text,points_possible,minimum_fix,judgement_kind&order=created_at`, { schema: "app" });
      rec.criteria = crit.json ?? [];
      console.log(a.content_key, "grade", graded.status, rec.grading_result ? `${rec.grading_result.status} ${rec.grading_result.points_earned}/${rec.grading_result.points_available} ${rec.grading_result.model_id} ${rec.grading_result.prompt_version}` : graded.text.slice(0, 200));
    }
  }
  await writeFile(OUT, JSON.stringify({ student: student.userId, run_at: new Date().toISOString(), results: out }, null, 2));
  console.log("wrote", OUT);
}
main().catch((e) => { console.error(e); process.exit(1); });
