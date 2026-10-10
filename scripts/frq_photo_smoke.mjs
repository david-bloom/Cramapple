// End-to-end smoke test for photographed FRQ answers
// (docs/product/HAND_DRAWN_RESPONSES_ALL_FRQS_PLAN_2026_10_09.md, DECISION-0109/0110/0111).
//
// Drives the REAL deployed functions with a REAL new student and a real JWT:
//   serve an FRQ (response_policy present) → create attempt + draft version →
//   mint a capture pairing → phone leg with access_path SAME_DEVICE → upload
//   the fixture page → submit_capture binds it → submit_response is REFUSED
//   until the transcript is confirmed → propose_transcript reads the page →
//   confirm_transcript (with one line the student adds) → submit_response →
//   evaluate-attempt grades the confirmed text → an admin reads the grading
//   context (transcript + judgement kinds) → the admin redacts the photo and
//   the row survives with redacted_at set.
//
// Usage (Development):
//   SMOKE_URL=https://<ref>.supabase.co \
//   SMOKE_PUBLISHABLE_KEY=sb_publishable_... \
//   SMOKE_SECRET_KEY=sb_secret_... \
//   [SMOKE_SUBJECT_KEY=ap-statistics] [SMOKE_FIXTURE=scripts/frq-photo-smoke/fixtures/answer-page.png] \
//   node scripts/frq_photo_smoke.mjs
//
// Exits non-zero if any check fails. Creates one student user and
// leaves it in place so the run is inspectable; emails are prefixed
// `smoke+frqphoto-`. Admin checks need an existing admin (SMOKE_ADMIN_EMAIL /
// SMOKE_ADMIN_PASSWORD); profile roles cannot be set through REST. Prints no
// secrets.
import { readFile } from "node:fs/promises";

const URL_BASE = process.env.SMOKE_URL;
const PUB = process.env.SMOKE_PUBLISHABLE_KEY;
const SECRET = process.env.SMOKE_SECRET_KEY;
const SUBJECT_KEY = process.env.SMOKE_SUBJECT_KEY ?? "ap-statistics";
const FIXTURE = process.env.SMOKE_FIXTURE ?? new URL("./frq-photo-smoke/fixtures/answer-page.png", import.meta.url).pathname;
if (!URL_BASE || !PUB || !SECRET) {
  console.error("SMOKE_URL, SMOKE_PUBLISHABLE_KEY and SMOKE_SECRET_KEY are required");
  process.exit(2);
}

let failures = 0;
const check = (label, ok, detail = "") => {
  console.log(`${ok ? "PASS" : "FAIL"}  ${label}${ok ? "" : `\n      ${String(detail).slice(0, 600)}`}`);
  if (!ok) failures++;
  return Boolean(ok);
};
let completed = false;

// Secret keys are not JWTs: apikey header, not a bearer token alone.
const svcHeaders = { apikey: SECRET, authorization: `Bearer ${SECRET}`, "content-type": "application/json" };
async function rest(path, { method = "GET", body, headers, schema } = {}) {
  const res = await fetch(`${URL_BASE}/rest/v1/${path}`, {
    method,
    headers: { ...svcHeaders, ...(schema ? { "accept-profile": schema, "content-profile": schema } : {}), ...headers },
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
    headers: { apikey: PUB, authorization: `Bearer ${token ?? PUB}`, "content-type": "application/json", origin: "https://app.cramapple.com" },
    body: JSON.stringify(body),
  });
  const text = await res.text();
  let json = null;
  try { json = JSON.parse(text); } catch { /* keep text */ }
  return { status: res.status, json, text };
}
const uuid = () => crypto.randomUUID();
const result = (r) => r.json?.result ?? {};

async function newUser(tag) {
  const email = `smoke+frqphoto-${tag}-${Date.now()}@cramapple.test`;
  const password = `Smoke!${crypto.randomUUID().slice(0, 12)}`;
  const created = await fetch(`${URL_BASE}/auth/v1/admin/users`, {
    method: "POST", headers: svcHeaders, body: JSON.stringify({ email, password, email_confirm: true }),
  });
  const createdJson = await created.json();
  if (!createdJson?.id) return { error: JSON.stringify(createdJson).slice(0, 300) };
  const signin = await fetch(`${URL_BASE}/auth/v1/token?grant_type=password`, {
    method: "POST", headers: { apikey: PUB, "content-type": "application/json" }, body: JSON.stringify({ email, password }),
  });
  const auth = await signin.json();
  if (!auth?.access_token) return { error: JSON.stringify(auth).slice(0, 300) };
  return { token: auth.access_token, userId: auth.user?.id ?? createdJson.id, email };
}

async function main() {
  const png = await readFile(FIXTURE);
  check("fixture page is readable", png.length > 1024, FIXTURE);

  // --- a student ---------------------------------------------------------
  const student = await newUser("student");
  if (!check("a new student signs in", Boolean(student.token), student.error)) return;
  const subj = await rest(`subjects?subject_key=eq.${SUBJECT_KEY}&select=id,display_name`, { schema: "app" });
  const subjectId = subj.json?.[0]?.id;
  if (!check(`subject ${SUBJECT_KEY} exists`, Boolean(subjectId), subj.text)) return;
  const grant = await rest("subject_entitlements", {
    method: "POST", schema: "app", headers: { prefer: "return=representation" },
    body: { user_id: student.userId, subject_id: subjectId, access_tier: "trial", source: "smoke_test" },
  });
  check("the student is entitled", grant.status === 201, `${grant.status} ${grant.text}`);

  // A pack with published, servable FRQs.
  const packs = await rest(`exam_packs?subject_id=eq.${subjectId}&select=id`, { schema: "app" });
  const packIds = (packs.json ?? []).map((p) => p.id);
  const versions = packIds.length
    ? await rest(`exam_pack_versions?exam_pack_id=in.(${packIds.join(",")})&status=eq.published&retired_at=is.null&select=id`, { schema: "app" })
    : { json: [] };
  let packVersionId = null;
  for (const v of versions.json ?? []) {
    const frqs = await rest(`content_items?exam_pack_version_id=eq.${v.id}&status=eq.published&item_type=eq.frq&select=id`, { schema: "app" });
    if (Array.isArray(frqs.json) && frqs.json.length) { packVersionId = v.id; break; }
  }
  if (!check(`a ${SUBJECT_KEY} pack with published FRQs exists`, Boolean(packVersionId))) return;
  const pick = await rest(`profiles?user_id=eq.${student.userId}`, {
    method: "PATCH", schema: "app", headers: { prefer: "return=representation" },
    body: { active_exam_pack_version_id: packVersionId },
  });
  if (!check("the student's active subject is set", pick.status === 200, pick.text)) return;

  // The Practice FRQ screen's session: focused mode, targeted_drill format.
  const sess = await fn("session-event", {
    operation: "session_start", idempotency_key: uuid(), exam_pack_version_id: packVersionId,
    entry_path: "self_guided_format", session_mode: "focused", available_minutes: 20, practice_format: "targeted_drill",
  }, student.token);
  const sessionId = result(sess).id ?? null;
  if (!check("a practice session starts", Boolean(sessionId), `${sess.status} ${sess.text}`)) return;

  // --- serve ---------------------------------------------------------------
  const items = await fn("student-session-items", { learning_session_id: sessionId, mode: "unit_gated", item_type: "frq", limit: 10 }, student.token);
  const list = result(items).items ?? [];
  let item = null;
  if (Array.isArray(list) && list.length > 0) {
    check("unit-gated practice serves FRQ items", true);
    check("every served FRQ carries response_policy", list.every((i) => ["typed_only", "photo_allowed", "photo_required"].includes(i.response_policy)), JSON.stringify(list.map((i) => [i.content_key, i.response_policy])));
    item = list.find((i) => i.response_policy === "photo_allowed" && i.parts_source === "prompt") ?? list.find((i) => i.response_policy !== "typed_only");
  } else {
    // Development has no labelled, servable FRQs (no validated serving labels,
    // no release manifest), so the serving contract is checked in Production
    // and the rest of the path is exercised against a published FRQ directly.
    console.log(`SKIP  unit-gated practice serves FRQ items (none servable here: ${items.status} ${(result(items).reason ?? items.json?.error ?? "").toString().slice(0, 120)})`);
    const direct = await rest(`content_items?exam_pack_version_id=eq.${packVersionId}&status=eq.published&item_type=eq.frq&select=id,content_key,response_policy,content_item_versions(id,status)`, { schema: "app" });
    const row = (direct.json ?? []).find((r) => (r.content_item_versions ?? []).some((v) => v.status === "published") && r.response_policy !== "typed_only");
    if (row) {
      const version = row.content_item_versions.find((v) => v.status === "published");
      item = { content_item_version_id: version.id, content_key: row.content_key, response_policy: row.response_policy, parts: [], parts_source: "criteria" };
      check("a published FRQ carries response_policy after the backfill", ["photo_allowed", "photo_required"].includes(row.response_policy), JSON.stringify(row));
    }
  }
  if (!check("an FRQ that allows a photo is available", Boolean(item))) return;
  console.log(`  item: ${item.content_key} policy=${item.response_policy} parts=${(item.parts ?? []).map((p) => p.part_key).join(",") || "(single response)"}`);

  // --- attempt + draft version (the slot a capture binds to) ------------------
  const created = await fn("attempt-response", {
    operation: "create_attempt", idempotency_key: uuid(), learning_session_id: sessionId,
    content_item_version_id: item.content_item_version_id, attempt_mode: "frq",
  }, student.token);
  const attemptId = result(created).attempt?.id;
  if (!check("create_attempt", Boolean(attemptId), `${created.status} ${created.text}`)) return;
  const draft = await fn("attempt-response", {
    operation: "save_response", idempotency_key: uuid(), attempt_id: attemptId, response_parts: { capture: "pending" },
  }, student.token);
  const rvId = result(draft).response_version?.id;
  if (!check("save_response creates the draft version", Boolean(rvId), `${draft.status} ${draft.text}`)) return;

  // --- capture: mint (student) then the phone leg on the SAME device ---------
  const minted = await fn("capture-pairing", {
    operation: "mint_pairing", idempotency_key: uuid(), attempt_id: attemptId, response_version_id: rvId, submission_slot_id: "slot-1",
  }, student.token);
  const handle = result(minted).pairing_handle;
  if (!check("mint_pairing", Boolean(handle), `${minted.status} ${minted.text}`)) return;
  const described = await fn("capture-pairing", { operation: "describe_capture", pairing_handle: handle, access_path: "SAME_DEVICE" });
  check("describe_capture (capability only)", described.status === 200, `${described.status} ${described.text}`);
  const ticket = await fn("capture-pairing", { operation: "create_capture_upload", pairing_handle: handle, media_type: "image/png", access_path: "SAME_DEVICE" });
  if (!check("create_capture_upload accepts access_path SAME_DEVICE", ticket.status === 200, `${ticket.status} ${ticket.text}`)) return;
  const put = await fetch(result(ticket).signed_url, {
    method: "PUT", headers: { "content-type": "image/png", "x-upsert": "true", authorization: `Bearer ${result(ticket).upload_token}` }, body: png,
  });
  if (!check("signed PUT of the page", put.ok, String(put.status))) return;
  const bound = await fn("capture-pairing", {
    operation: "submit_capture", pairing_handle: handle, storage_path: result(ticket).storage_path, media_type: "image/png", explicit_confirmation: true,
  });
  const attachmentId = result(bound).attachment_id;
  if (!check("submit_capture binds the photo", Boolean(attachmentId), `${bound.status} ${bound.text}`)) return;
  console.log(`  quality=${result(bound).capture_quality_state} failure_class=${result(bound).failure_class}`);
  const tokenRow = await rest(`capture_pairing_tokens?bound_attachment_id=eq.${attachmentId}&select=access_path,state`, { schema: "app" });
  check("the token records access_path SAME_DEVICE", tokenRow.json?.[0]?.access_path === "SAME_DEVICE", tokenRow.text);

  // --- the gate: no submit before confirmation --------------------------------
  const early = await fn("attempt-response", { operation: "submit_response", idempotency_key: uuid(), attempt_id: attemptId, response_version_id: rvId }, student.token);
  check("submit_response is refused until the transcript is confirmed", early.status === 409 && early.json?.error === "transcript_confirmation_required", `${early.status} ${early.text}`);

  // --- propose -----------------------------------------------------------------
  const t0 = Date.now();
  const proposed = await fn("attempt-response", { operation: "propose_transcript", idempotency_key: uuid(), attempt_id: attemptId, response_version_id: rvId }, student.token);
  const transcript = result(proposed).transcript;
  check("propose_transcript returns a record", proposed.status === 200 && transcript && typeof transcript.status === "string", `${proposed.status} ${proposed.text}`);
  console.log(`  transcript: status=${transcript?.status ?? "-"} failure=${transcript?.failure ?? "-"} warnings=${JSON.stringify(transcript?.warnings ?? [])} (${Date.now() - t0} ms, model ${transcript?.model ?? "-"})`);
  if (!transcript) { console.log(`  propose body: ${proposed.text.slice(0, 300)}`); return; }
  const proposedParts = {};
  for (const p of transcript?.proposed?.parts ?? []) proposedParts[p.part_key] = p.text;
  check("the reader proposed text", transcript?.status === "proposed" && Object.values(proposedParts).some((t) => t && t.trim()), JSON.stringify(transcript).slice(0, 400));
  if (transcript?.status === "proposed") {
    for (const [k, v] of Object.entries(proposedParts)) console.log(`    (${k}) ${v.replace(/\n/g, " | ").slice(0, 160)}`);
    const again = await fn("attempt-response", { operation: "propose_transcript", idempotency_key: uuid(), attempt_id: attemptId, response_version_id: rvId }, student.token);
    check("a second propose reuses the stored proposal (no model call)", result(again).reused === true, again.text);
  }

  // --- confirm: student completes one part -------------------------------------
  const itemParts = result(proposed).parts ?? [];
  const firstKey = itemParts[0]?.part_key ?? "response";
  const confirmedParts = { ...proposedParts };
  const addedLine = "Added at review: the units are bubbles per minute.";
  confirmedParts[firstKey] = `${(confirmedParts[firstKey] ?? "").trim()}\n${addedLine}`.trim();
  const bad = await fn("attempt-response", { operation: "confirm_transcript", idempotency_key: uuid(), attempt_id: attemptId, response_version_id: rvId, parts: { not_a_part: "x" } }, student.token);
  check("confirm_transcript refuses an unknown part", bad.status === 422 && bad.json?.error === "unknown_part", `${bad.status} ${bad.text}`);
  const confirmed = await fn("attempt-response", { operation: "confirm_transcript", idempotency_key: uuid(), attempt_id: attemptId, response_version_id: rvId, parts: confirmedParts }, student.token);
  const rv = result(confirmed).response_version;
  check("confirm_transcript writes the response text", confirmed.status === 200 && typeof rv?.response_text === "string" && rv.response_text.includes(addedLine), `${confirmed.status} ${confirmed.text}`);
  check("student-added text is recorded against its part", Array.isArray(rv?.student_added_parts) && rv.student_added_parts.includes(firstKey), JSON.stringify(rv?.student_added_parts));

  // --- a student cannot forge a confirmation through PostgREST (review M2) -----
  const forged = await fetch(`${URL_BASE}/rest/v1/response_versions?id=eq.${rvId}`, {
    method: "PATCH",
    headers: { apikey: PUB, authorization: `Bearer ${student.token}`, "content-type": "application/json", "accept-profile": "app", "content-profile": "app", prefer: "return=representation" },
    body: JSON.stringify({ response_parts: { _confirmed_at: new Date().toISOString(), _confirmed_digest: "0".repeat(64), response: "forged" } }),
  });
  const forgedText = await forged.text();
  check("a student cannot write reserved transcript keys through PostgREST", forged.status >= 400 && /reserved_keys_are_server_only/.test(forgedText), `${forged.status} ${forgedText.slice(0, 200)}`);

  // --- (Codex QA P1-a) the owner edits the confirmed text directly; submit is refused --
  const edited = await fetch(`${URL_BASE}/rest/v1/response_versions?id=eq.${rvId}`, {
    method: "PATCH",
    headers: { apikey: PUB, authorization: `Bearer ${student.token}`, "content-type": "application/json", "accept-profile": "app", "content-profile": "app", prefer: "return=representation" },
    body: JSON.stringify({ response_text: "an answer the student never confirmed" }),
  });
  const editedText = await edited.text();
  check("the owner can still edit a draft through PostgREST (the attack precondition)", edited.status === 200, `${edited.status} ${editedText.slice(0, 200)}`);
  const afterEdit = await fn("attempt-response", { operation: "submit_response", idempotency_key: uuid(), attempt_id: attemptId, response_version_id: rvId }, student.token);
  check("submit after a post-confirm edit is refused", afterEdit.status === 409 && afterEdit.json?.error === "transcript_confirmation_required", `${afterEdit.status} ${afterEdit.text}`);
  const reconfirmAfterEdit = await fn("attempt-response", { operation: "confirm_transcript", idempotency_key: uuid(), attempt_id: attemptId, response_version_id: rvId, parts: confirmedParts }, student.token);
  check("re-confirming restores the confirmed text", reconfirmAfterEdit.status === 200 && result(reconfirmAfterEdit).response_version?.response_text?.includes(addedLine), `${reconfirmAfterEdit.status} ${reconfirmAfterEdit.text.slice(0, 200)}`);

  // --- a retake after confirming re-closes the gate (review H1) -----------------
  const minted2 = await fn("capture-pairing", { operation: "mint_pairing", idempotency_key: uuid(), attempt_id: attemptId, response_version_id: rvId, submission_slot_id: "slot-1" }, student.token);
  const handle2 = result(minted2).pairing_handle;
  if (check("a second pairing (retake) can be minted", Boolean(handle2), `${minted2.status} ${minted2.text}`)) {
    await fn("capture-pairing", { operation: "describe_capture", pairing_handle: handle2, access_path: "SAME_DEVICE" });
    const ticket2 = await fn("capture-pairing", { operation: "create_capture_upload", pairing_handle: handle2, media_type: "image/png", access_path: "SAME_DEVICE" });
    // A different page: flip one byte region of the PNG by re-encoding? Simplest: upload the same bytes plus a trailing comment chunk is invalid PNG; instead reuse the fixture but with one extra zero-length tEXt chunk is complex -- so use the digest change produced by appending nothing is impossible. Use a second fixture if present, else the same bytes (digest unchanged -> gate stays open; checked below).
    let png2 = png;
    try { png2 = await readFile(new URL("./frq-photo-smoke/fixtures/answer-page-2.png", import.meta.url).pathname); } catch { /* same page */ }
    const put2 = await fetch(result(ticket2).signed_url, { method: "PUT", headers: { "content-type": "image/png", "x-upsert": "true", authorization: `Bearer ${result(ticket2).upload_token}` }, body: png2 });
    const bound2 = await fn("capture-pairing", { operation: "submit_capture", pairing_handle: handle2, storage_path: result(ticket2).storage_path, media_type: "image/png", explicit_confirmation: true });
    check("the retake binds as the new current original", put2.ok && Boolean(result(bound2).attachment_id), `${bound2.status} ${bound2.text}`);
    const differentPage = png2 !== png;
    const afterRetake = await fn("attempt-response", { operation: "submit_response", idempotency_key: uuid(), attempt_id: attemptId, response_version_id: rvId }, student.token);
    if (differentPage) {
      check("submit after a retake is refused until the new photo is confirmed", afterRetake.status === 409 && afterRetake.json?.error === "transcript_confirmation_required", `${afterRetake.status} ${afterRetake.text}`);
      const reread = await fn("attempt-response", { operation: "propose_transcript", idempotency_key: uuid(), attempt_id: attemptId, response_version_id: rvId }, student.token);
      check("re-propose after a retake is a fresh read", reread.status === 200 && result(reread).reused !== true, `${reread.status} ${reread.text.slice(0, 200)}`);
      const reconfirm = await fn("attempt-response", { operation: "confirm_transcript", idempotency_key: uuid(), attempt_id: attemptId, response_version_id: rvId, parts: confirmedParts }, student.token);
      check("re-confirm after a retake succeeds", reconfirm.status === 200, `${reconfirm.status} ${reconfirm.text.slice(0, 200)}`);
    } else {
      console.log("SKIP  retake-with-a-different-page gate check (no second fixture; same bytes keep the same digest)");
      check("submit after a same-photo retake is still allowed (digest unchanged)", afterRetake.status === 200, `${afterRetake.status} ${afterRetake.text}`);
    }
  }

  // --- submit + grade ----------------------------------------------------------
  const submitted = await fn("attempt-response", { operation: "submit_response", idempotency_key: uuid(), attempt_id: attemptId, response_version_id: rvId }, student.token);
  if (!check("submit_response succeeds after confirmation", submitted.status === 200 || submitted.json?.error === "response_already_submitted", `${submitted.status} ${submitted.text}`)) return;
  const graded = await fn("evaluate-attempt", {
    operation: "grade_initial_attempt", idempotency_key: uuid(), attempt_id: attemptId, response_version_id: rvId,
    content_item_version_id: item.content_item_version_id, rubric_version_id: item.content_item_version_id,
    assistance_condition: "independent", assistance_state: { attempt_condition: "cold", independent_diagnostic_evidence: true, help_level_used: null },
  }, student.token);
  const gradeStatus = result(graded).status ?? graded.json?.status;
  // "graded" or "uncertain" both mean the grader ran (the fixture page does not
  // answer whichever FRQ this environment served, so an honest "unable to
  // determine" is expected). What matters is that it graded the CONFIRMED
  // version: a grading_results row exists for this attempt and this response
  // version, whose response_text is the confirmed transcript.
  const gradedRow = await rest(`grading_results?attempt_id=eq.${attemptId}&response_version_id=eq.${rvId}&select=id,status,response_version_id`, { schema: "app" });
  const versionRow = await rest(`response_versions?id=eq.${rvId}&select=is_submitted,response_text`, { schema: "app" });
  const gradedConfirmed = Array.isArray(gradedRow.json) && gradedRow.json.length === 1 && versionRow.json?.[0]?.is_submitted === true && (versionRow.json?.[0]?.response_text ?? "").includes(addedLine);
  check("evaluate-attempt grades the confirmed transcript", (graded.status === 200 || graded.status === 202) && (gradeStatus === "graded" || gradeStatus === "uncertain") && gradedConfirmed, `${graded.status} ${graded.text.slice(0, 300)} | rows=${gradedRow.text.slice(0, 200)}`);
  console.log(`  grade: ${result(graded).points_earned}/${result(graded).points_available} (${gradeStatus})`);

  // --- admin: context + redaction ------------------------------------------------
  // Profile roles are server-side only (app.prevent_profile_role_change refuses
  // REST role changes, secret key or legacy JWT alike), so an existing admin is
  // used when provided; otherwise the admin checks are skipped.
  let adminToken = null;
  if (process.env.SMOKE_ADMIN_EMAIL && process.env.SMOKE_ADMIN_PASSWORD) {
    const signin = await fetch(`${URL_BASE}/auth/v1/token?grant_type=password`, {
      method: "POST", headers: { apikey: PUB, "content-type": "application/json" },
      body: JSON.stringify({ email: process.env.SMOKE_ADMIN_EMAIL, password: process.env.SMOKE_ADMIN_PASSWORD }),
    });
    adminToken = (await signin.json())?.access_token ?? null;
    check("the admin signs in", Boolean(adminToken));
  } else {
    console.log("SKIP  admin checks (set SMOKE_ADMIN_EMAIL / SMOKE_ADMIN_PASSWORD for an existing admin; roles are server-side only)");
  }
  if (adminToken) {
    const ctx = await fn("attempt-response", { operation: "get_manual_grading_context", idempotency_key: uuid(), attempt_id: attemptId }, adminToken);
    const c = result(ctx);
    check("grading context carries the confirmed transcript", ctx.status === 200 && c.response_source === "photo_transcript" && typeof c.transcript_parts === "object" && Boolean(c.transcript_confirmed_at), `${ctx.status} ${(ctx.text ?? "").slice(0, 400)}`);
    check("grading context carries judgement_kind per criterion", Array.isArray(c.criteria) && c.criteria.length > 0 && c.criteria.every((k) => k.judgement_kind === "text" || k.judgement_kind === "image"), JSON.stringify(c.criteria ?? null).slice(0, 300));
    const queue = await fn("attempt-response", { operation: "list_manual_grading_queue", idempotency_key: uuid() }, adminToken);
    check("a graded photo answer is not in the human queue", queue.status === 200 && !(result(queue).items ?? []).some((q) => q.attempt_id === attemptId), (queue.text ?? "").slice(0, 300));
  }
  const studentRedact = await fn("attempt-response", { operation: "redact_attachment", idempotency_key: uuid(), attachment_id: attachmentId }, student.token);
  check("a student cannot redact", studentRedact.status === 403, `${studentRedact.status} ${studentRedact.text}`);
  if (adminToken) {
    const redacted = await fn("attempt-response", { operation: "redact_attachment", idempotency_key: uuid(), attachment_id: attachmentId }, adminToken);
    check("the admin redacts the photo lineage", redacted.status === 200 && (result(redacted).redacted ?? []).includes(attachmentId), `${redacted.status} ${redacted.text}`);
    const row = await rest(`response_attachments?id=eq.${attachmentId}&select=id,redacted_at,sha256_digest,storage_path`, { schema: "app" });
    check("the row survives with redacted_at set and its digest intact", Boolean(row.json?.[0]?.redacted_at) && row.json?.[0]?.sha256_digest?.length === 64, row.text);
    const gone = await fetch(`${URL_BASE}/storage/v1/object/learner-uploads/${row.json?.[0]?.storage_path ?? ""}`, { headers: { apikey: SECRET, authorization: `Bearer ${SECRET}` } });
    check("the storage object is gone", gone.status === 400 || gone.status === 404, `storage GET returned ${gone.status}`);
  }
  completed = true;
}

main().then(() => {
  if (!completed && failures === 0) { console.log("FAIL  run ended early"); failures++; }
  console.log(failures === 0 ? "\nALL CHECKS PASSED" : `\n${failures} CHECK(S) FAILED`);
  process.exit(failures === 0 ? 0 : 1);
}).catch((e) => { console.error("smoke crashed:", e); process.exit(1); });
