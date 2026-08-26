/**
 * Course Mode — END-TO-END loop proof harness (Dev), the REAL deployed path.
 *
 * Proves serve -> grade -> cell promotion for all 10 AP Stats Unit-1 pilot cells,
 * both grading outcomes, by driving the actual deployed edge functions:
 *   attempt-response (create_attempt -> save_response -> submit_response)
 *   evaluate-attempt (deterministic MCQ choice-match grade -> persistCellState)
 * then reading back app.student_cell_state to confirm the tier transition.
 *
 * WHY THIS IS A SEPARATE, RUN-ELSEWHERE SCRIPT
 * The session that authored it could reach Dev only over SQL (Supabase MCP); the
 * org egress policy blocks the Dev Supabase host, so the HTTP calls below (GoTrue
 * auth + edge functions) could not run there. Run this from an environment whose
 * egress policy allows https://<project-ref>.supabase.co. The pure promotion
 * engine was proven offline by run_local_engine_proof.ts; this proves the
 * deployed grader + DB write that the local proof cannot reach.
 *
 * REQUIRED ENV
 *   SB_URL                 e.g. https://wmgjsdkphcyhngaffbqf.supabase.co  (Dev)
 *   SB_ANON_KEY            the project's anon/publishable key
 *   SB_SERVICE_ROLE_KEY    service_role key (setup + verification only; never sent to edge fns)
 * OPTIONAL ENV
 *   EXAM_PACK_VERSION_ID   default 4e54bb4f-695f-41be-ac06-745fe9ad8bcc (ap_statistics 2026-27)
 *   AP_STATS_SUBJECT_ID    default 19e1a256-df88-4f17-a69e-96052885a137
 *   STUDENT_EMAIL          default cm-loop-proof+<ts>@example.com (a throwaway test student)
 *   STUDENT_PASSWORD       default a generated strong password
 *   KEEP_STUDENT=1         do not delete the test student + its rows at the end
 *
 * SAFETY: writes only to Dev, only under a throwaway test student it provisions
 * (never David's profile unless you point STUDENT_EMAIL at it). Prod is never touched.
 *
 * Install dep + run:
 *   bun add @supabase/supabase-js
 *   bun run scripts/course_mode_loop_proof/run_e2e_harness.ts
 * (Node: `npm i @supabase/supabase-js`, then `npx tsx scripts/course_mode_loop_proof/run_e2e_harness.ts`.)
 */
import { createClient, type SupabaseClient } from "@supabase/supabase-js";

// ── config ──────────────────────────────────────────────────────────────────
const SB_URL = reqEnv("SB_URL");
const SB_ANON_KEY = reqEnv("SB_ANON_KEY");
const SB_SERVICE_ROLE_KEY = reqEnv("SB_SERVICE_ROLE_KEY");
const EPV = env("EXAM_PACK_VERSION_ID", "4e54bb4f-695f-41be-ac06-745fe9ad8bcc");
const SUBJECT_ID = env("AP_STATS_SUBJECT_ID", "19e1a256-df88-4f17-a69e-96052885a137");
const TS = Math.floor(Date.now() / 1000);
const STUDENT_EMAIL = env("STUDENT_EMAIL", `cm-loop-proof+${TS}@example.com`);
const STUDENT_PASSWORD = env("STUDENT_PASSWORD", `Cm-LoopProof-${TS}-${Math.random().toString(36).slice(2)}!Aa`);
const KEEP_STUDENT = process.env.KEEP_STUDENT === "1";

const TEMPLATE_IDS = [
  "summary_stats", "compare_stats", "slotframe_u1_2_variables", "slotframe_u1_5_graphs",
  "slotframe_u1_6_distribution", "slotframe_u1_8_boxplots", "slotframe_u1_11_sampling",
  "slotframe_u1_12_bias", "slotframe_u1_13_design", "slotframe_4b_compare",
];

function env(k: string, d: string) { return process.env[k] ?? d; }
function reqEnv(k: string): string {
  const v = process.env[k];
  if (!v) { console.error(`Missing required env: ${k}`); process.exit(2); }
  return v;
}
function uid() { return crypto.randomUUID(); }

const svc: SupabaseClient = createClient(SB_URL, SB_SERVICE_ROLE_KEY, {
  auth: { autoRefreshToken: false, persistSession: false },
});

// ── edge-function call as the student (real deployed path) ────────────────────
async function callFn(fn: string, body: unknown, jwt: string) {
  const res = await fetch(`${SB_URL}/functions/v1/${fn}`, {
    method: "POST",
    headers: {
      "apikey": SB_ANON_KEY,
      "Authorization": `Bearer ${jwt}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify(body),
  });
  const text = await res.text();
  let json: any = null;
  try { json = text ? JSON.parse(text) : null; } catch { /* keep text */ }
  if (!res.ok) throw new Error(`${fn} -> HTTP ${res.status}: ${text}`);
  return json;
}

// ── setup: throwaway entitled student + a home session ────────────────────────
async function provisionStudent(): Promise<{ userId: string }> {
  const { data: created, error } = await svc.auth.admin.createUser({
    email: STUDENT_EMAIL,
    password: STUDENT_PASSWORD,
    email_confirm: true,
  });
  if (error || !created?.user) throw new Error(`createUser failed: ${error?.message}`);
  const userId = created.user.id;

  // profiles: role student + active exam pack (session assembly reads this).
  const { error: pErr } = await svc.schema("app").from("profiles").upsert({
    user_id: userId,
    role: "student",
    active_exam_pack_version_id: EPV,
    onboarding_completed_at: new Date().toISOString(),
  }, { onConflict: "user_id" });
  if (pErr) throw new Error(`profile upsert failed: ${pErr.message}`);

  // subject_entitlements: mirror an active beta grant so the grading gate passes.
  const { error: eErr } = await svc.schema("app").from("subject_entitlements").insert({
    user_id: userId, subject_id: SUBJECT_ID, access_tier: "beta", status: "active",
    source: "cm_loop_proof_harness", starts_at: new Date().toISOString(), all_subjects: false,
  });
  if (eErr) throw new Error(`entitlement insert failed: ${eErr.message}`);

  return { userId };
}

async function signIn(): Promise<string> {
  const res = await fetch(`${SB_URL}/auth/v1/token?grant_type=password`, {
    method: "POST",
    headers: { "apikey": SB_ANON_KEY, "Content-Type": "application/json" },
    body: JSON.stringify({ email: STUDENT_EMAIL, password: STUDENT_PASSWORD }),
  });
  const j = await res.json();
  if (!res.ok || !j.access_token) throw new Error(`password grant failed: ${JSON.stringify(j)}`);
  return j.access_token as string;
}

async function startSession(userId: string): Promise<string> {
  const { data, error } = await svc.schema("app").rpc("start_home_learning_session_for_user", {
    _user_id: userId, _minutes: 30, _idempotency_key: `cm-loop-${TS}-${userId.slice(0, 8)}`,
  });
  if (error) throw new Error(`start_home_learning_session_for_user failed: ${error.message}`);
  const row = Array.isArray(data) ? data[0] : data;
  if (!row?.learning_session_id) throw new Error(`no session id: ${JSON.stringify(data)}`);
  return row.learning_session_id as string;
}

// ── discovery: two published instances per cell + correct/distractor keys ─────
type CellPick = {
  template_id: string; topic_code: string; skill_code: string; tsv: string;
  a: { civ: string; correct: string }; b: { civ: string; distractor: string };
};

async function discoverCells(): Promise<CellPick[]> {
  const picks: CellPick[] = [];
  for (const tid of TEMPLATE_IDS) {
    const { data: versions, error } = await svc.schema("app")
      .from("content_item_versions")
      .select("id, content_items!inner(exam_pack_version_id, status), item_package_payload, status")
      .eq("status", "published")
      .eq("content_items.exam_pack_version_id", EPV)
      .filter("item_package_payload->provenance->>template_id", "eq", tid)
      .limit(2);
    if (error) throw new Error(`discover ${tid} failed: ${error.message}`);
    if (!versions || versions.length < 2) throw new Error(`need 2 published instances for ${tid}, got ${versions?.length ?? 0}`);
    const [va, vb] = versions;

    const cell = await svc.schema("app").from("content_item_cells")
      .select("topic_code, skill_code, taxonomy_source_version")
      .eq("content_item_version_id", va.id).maybeSingle();
    if (cell.error || !cell.data) throw new Error(`no cell tag for ${tid}: ${cell.error?.message}`);

    const ca = await svc.schema("app").from("mcq_choices")
      .select("choice_key, is_correct").eq("content_item_version_id", va.id);
    const cb = await svc.schema("app").from("mcq_choices")
      .select("choice_key, is_correct").eq("content_item_version_id", vb.id);
    if (ca.error || cb.error) throw new Error(`mcq_choices read failed for ${tid}`);
    const correct = ca.data!.find((c: any) => c.is_correct)?.choice_key;
    const distractor = cb.data!.find((c: any) => !c.is_correct)?.choice_key;
    if (!correct || !distractor) throw new Error(`missing correct/distractor key for ${tid}`);

    picks.push({
      template_id: tid, topic_code: cell.data.topic_code, skill_code: cell.data.skill_code,
      tsv: cell.data.taxonomy_source_version,
      a: { civ: va.id, correct }, b: { civ: vb.id, distractor },
    });
  }
  return picks;
}

// ── one graded attempt through the deployed functions ─────────────────────────
async function gradeOne(jwt: string, sessionId: string, civ: string, selectedChoiceKey: string) {
  const created = await callFn("attempt-response", {
    operation: "create_attempt", idempotency_key: uid(),
    learning_session_id: sessionId, content_item_version_id: civ,
    attempt_mode: "mcq", assistance_state: "independent",
  }, jwt);
  const attemptId = created.result.attempt.id;

  const saved = await callFn("attempt-response", {
    operation: "save_response", idempotency_key: uid(),
    attempt_id: attemptId, response_parts: { selected_choice_key: selectedChoiceKey },
  }, jwt);
  const responseVersionId = saved.result.response_version.id;

  await callFn("attempt-response", {
    operation: "submit_response", idempotency_key: uid(),
    attempt_id: attemptId, response_version_id: responseVersionId,
  }, jwt);

  const graded = await callFn("evaluate-attempt", {
    operation: "grade_attempt", idempotency_key: uid(),
    attempt_id: attemptId, response_version_id: responseVersionId,
  }, jwt);
  return { attemptId, pointsEarned: graded?.result?.points_earned ?? null, status: graded?.status };
}

async function readCellState(userId: string, tsv: string, topic: string, skill: string) {
  const { data } = await svc.schema("app").from("student_cell_state")
    .select("tier, fragile, last_event, last_weight, due_reason")
    .eq("user_id", userId).eq("taxonomy_source_version", tsv)
    .eq("topic_code", topic).eq("skill_code", skill).maybeSingle();
  return data;
}

async function cleanup(userId: string) {
  if (KEEP_STUDENT) { console.log(`KEEP_STUDENT=1 — left test student ${STUDENT_EMAIL} (${userId}) in place.`); return; }
  // attempts/response_versions/grading_results/cell-state cascade or are dev-only;
  // remove entitlement + profile + auth user. Ignore FK-order errors best-effort.
  await svc.schema("app").from("subject_entitlements").delete().eq("user_id", userId);
  await svc.auth.admin.deleteUser(userId).catch(() => {});
  console.log(`cleaned up test student ${STUDENT_EMAIL} (${userId}).`);
}

// ── main ─────────────────────────────────────────────────────────────────────
const rows: string[] = [];
let failures = 0;
rows.push(["cell (topic×skill)".padEnd(20), "correct→tier".padEnd(14), "pts".padEnd(4), "miss→tier".padEnd(12), "fragile".padEnd(8), "verdict"].join(" | "));

const { userId } = await provisionStudent();
try {
  const jwt = await signIn();
  const sessionId = await startSession(userId);
  console.log(`student=${userId} session=${sessionId}\n`);
  const cells = await discoverCells();

  for (const c of cells) {
    const label = `${c.topic_code}×${c.skill_code}`;
    // [1] correct -> promotion
    const g1 = await gradeOne(jwt, sessionId, c.a.civ, c.a.correct);
    const s1 = await readCellState(userId, c.tsv, c.topic_code, c.skill_code);
    // [2] wrong -> fragile + tier unchanged
    const g2 = await gradeOne(jwt, sessionId, c.b.civ, c.b.distractor);
    const s2 = await readCellState(userId, c.tsv, c.topic_code, c.skill_code);

    const ok =
      g1.pointsEarned === 1 && s1?.tier === "independent" && s1?.fragile === false &&
      g2.pointsEarned === 0 && s2?.tier === s1?.tier && s2?.fragile === true;
    if (!ok) failures++;
    rows.push([
      label.padEnd(20), String(s1?.tier).padEnd(14), String(g1.pointsEarned).padEnd(4),
      String(s2?.tier).padEnd(12), String(s2?.fragile).padEnd(8), ok ? "PASS" : "FAIL",
    ].join(" | "));
  }
} finally {
  await cleanup(userId);
}

console.log("\nCourse Mode — END-TO-END loop proof (deployed attempt-response + evaluate-attempt on Dev)\n");
console.log(rows.join("\n"));
console.log("");
if (failures) { console.error(`FAILED — ${failures} cell(s) did not complete serve→grade→promotion as expected.`); process.exit(1); }
console.log(`OK — all ${TEMPLATE_IDS.length} cells: correct→independent, miss→fragile (tier unchanged), via the deployed grader.`);
