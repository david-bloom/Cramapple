# Codex QA prompt: paywall sample access — Production dark apply and activation readiness (2026-11-09)

Paste the block below into Codex as the task. It is self-contained; the files it names are on `main`.

---

**Task: independent QA of the paywall sample-access backend in Production (dark) and its readiness for
activation. You are the independent reviewer; the backend session that built and deployed it must not QA its
own work. Report verified / inferred / not-reproducible for every item, with evidence, and end with a verdict on
(A) the dark apply as executed and (B) whether the backend side is ready for activation.**

**Read first (on `main`):**
- `docs/activity_log/APPROVAL-0207_PAYWALL_SAMPLE_PHASE3_PRODUCTION_RELEASE_2026_11_09.md` — step A executed
  (§6), step B not granted (§3 preconditions 1–8).
- `docs/product/PAYWALL_BACKEND_DESIGN_SPEC_2026_11_08.md` — §5 gates, §8 typed denials, §9 rollback, §10 contract,
  §11 uploaded-FRQ blocker, §12 trial precedence, §14 decided rules (`DECISION-0134`).
- `docs/qa/QA_PACKET_PAYWALL_SAMPLE_BACKEND_2026_11_08.md` — §4 risk areas, §5 verification queries, §7–§9 prior
  QA rounds and the Development end-to-end record.

**Environments.** Production is `pcntajvbdfqhbeewmdry`; Development is `wmgjsdkphcyhngaffbqf`. The Supabase CLI
home-dir link is Production: pin `--workdir` to the repo and confirm the ref with `--debug` before anything.
Production is **read-only for you** except where part C says otherwise. Development may be written, but leave it
as you found it (part B lists the reset).

## Part A — Production dark state (read-only)

1. Ledger has `paywall_sample_access` (`20261109155919`) and `paywall_sample_access_qa_fixes` (`20261109155941`);
   `app.config`: `sample_access_enabled=false`, `sample_access_honor_existing=true`,
   `sample_access_prior_definitions` with 5 keys. Four `app.sample_*` tables, 0 rows each, RLS enabled **and
   forced**, no `anon`/`authenticated` table grants; no `anon`/`authenticated` execute on any `app.sample_*`
   function; `authenticated` can execute `public.claim_sample_try`, `public.get_sample_access_state`,
   `public.claim_sample_frq_source`; `anon` cannot.
2. `app.sample_supersede_on_entitlement` body has **no** `starts_at <= now()` condition (QA round-1 fix present).
3. Function fidelity: compare `md5(pg_get_functiondef(...))` of every `app.sample_*`, `app.has_study_subject_access`,
   `app.has_study_readback_access`, `app.authorize_grading_access`, `public.get_study_topic_point_guides`,
   `public.get_question_experience`, `public.claim_sample_try`, `public.get_sample_access_state`,
   `public.claim_sample_frq_source` between Production and Development. Expected: identical except four plpgsql
   bodies that differ only by inline `--` comments (strip `--[^\n]*` and whitespace, then compare). Any other
   difference is a finding.
4. Functions: `sample-try` v1 (`verify_jwt` false), `attempt-response` v45, `student-session-items` v47. Download
   each with `supabase functions download --project-ref pcntajvbdfqhbeewmdry` and `diff` against `main`: expect
   byte-identical `index.ts`. `evaluate-attempt` is still v83 (unchanged by this release) — confirm it was not
   redeployed.
5. Regular students unchanged: for every currently entitled student–subject pair, `app.has_study_subject_access`
   is true and `app.sample_study_access` is false; unentitled student profiles are not admitted to any subject.
   `get_sample_access_state()` under a simulated JWT of an entitled student returns `enabled:false, has_grant:false,
   offer_context.has_regular_entitlement:true`.
6. Live smoke with the anon key: `POST /functions/v1/sample-try {"operation":"list_units","subject_key":"ap-statistics"}`
   → `503 {"error":"sample_disabled"}`; `attempt-response` and `student-session-items` without a JWT → 401.
7. Confirm `GRADING_ENTITLEMENTS_ENABLED` is **set** on Production (`supabase secrets list`; value not readable,
   so confirm by behaviour only if a safe unentitled test identity already exists — otherwise record as "set,
   value inferred from `APPROVAL-0205`/`minimal-ci` convention").
8. Serving alignment (APPROVAL-0207 §8): ledger has `paywall_sample_serving_alignment`; `app.claim_sample_try`
   contains the `student_course_positions` upsert and inserts the imported session with `practice_format` null;
   `app.sample_unit_availability('ap-calculus-ab')` → unit 1 `basis:'serving'`, `mcq_available:10`, `eligible:true`
   (4/false means Production still has the first, paging form of `app.sample_serving_deliverable` — a finding);
   `('ap-physics-2')` → units 9, 10, 11 eligible; every active subject reports `basis:'serving'`. For three units of
   your choice page `public.select_student_practice_items(pack, N, '00000000-0000-0000-0000-000000000000', null,
   'mcq', null, 51, offset)` to exhaustion and confirm the unit-N count (topic resolution unit = N) equals
   `select count(*) from app.sample_serving_deliverable(pack, N, 'mcq')`.
9. Security advisor (`get_advisors security`): the four sample tables appear under the pre-existing INFO lint
   "RLS enabled, no policy" alongside ~36 other service-role-only tables, and the three public RPCs appear under the
   pre-existing WARN "authenticated can execute SECURITY DEFINER" alongside every other public RPC. Expected: no
   **new lint category**, no ERROR-level finding. Report any that is new.

## Part B — Development end-to-end (writable; reset afterwards)

Reproduce the backend session's 2026-11-09 walk (QA packet §9) **independently**, with your own throwaway
`auth.users` row and your own `sample-try` token. Switch on first: `update app.config set
config_value='true'::jsonb where config_key='sample_access_enabled'` and `supabase secrets set
SAMPLE_ACCESS_ENABLED=true --project-ref wmgjsdkphcyhngaffbqf`. `GRADING_ENTITLEMENTS_ENABLED=true` is already set
on Development (set 2026-11-09 to match Production); leave it.

Expected sequence and results:
1. `list_units` → only unit 1 of `ap-statistics` `eligible` on Development.
2. `start` → `try_token` once; `question` has `choices` without `is_correct`/`rationale`/`explanation`.
3. `answer` → `outcome:answered`, `register_to_save:true`, feedback with truth; same choice again → `replayed`;
   a different choice → `409 sample_try:already_answered`.
4. Create a user via the auth admin API (service role, `email_confirm:true`), sign in for a JWT.
5. `rpc/claim_sample_try {p_try_token}` → `has_grant:true`, `grant.phase:active`, `mcq.used:1`, `frq.remaining:1`,
   `expires_at = activated_at + 72h`, `grace_ends_at = expires_at + 72h`; replay → same state, one grant row.
6. `student-session-items {learning_session_id}` → `result.sample = {unit_number:1, phase:'active',
   mcq_remaining:7, frq_remaining:1}`; served items all unit 1.
7. `attempt-response create_attempt` on a served item → 200 and `mcq.used:2`; on an out-of-unit item →
   `403 {error:'sample:item_outside_unit', access:'sample', state:{…}}`.
8. `save_response` → `submit_response` → `evaluate-attempt grade_initial_attempt` on the MCQ → `graded`.
9. **FRQ needs a drill session:** `create_attempt` with `attempt_mode:'frq'` inside the imported session (practice
   format `mcq`) is refused `409 practice_format_mismatch` — expected, not a sample defect. Start a session with
   `session-event session_start {exam_pack_version_id, entry_path:'topic', session_mode:'quick',
   available_minutes:15, practice_format:'targeted_drill'}` (admitted because the sample grant is active), then
   `create_attempt frq` on the unit-1 FRQ → 200, `frq.used:1`; a retry on the same FRQ consumes nothing.
10. `evaluate-attempt grade_initial_attempt` on the FRQ three times with distinct idempotency keys → `graded`
    three times; the fourth → `403 sample_grading_limit_reached`; `grade_revision` →
    `403 sample_operation_not_included`.
11. `rpc/get_study_topic_point_guides {_subject_key:'ap-statistics', _unit_number:3}` → `403 sample:unit_locked`.
12. `rpc/get_question_experience {p_learning_session_id, p_ordinal:1}` → `mcqFeedback` present (readback).
13. A second `start`/`answer` with a new token, then `claim_sample_try` as the same user → `403 sample:already_sampled`.
14. Insert an active `paid` row for the user with `starts_at = now() + interval '1 day'` (direct SQL) → grant
    `superseded`, `superseded_by='paid'`; revoke it → `has_study_subject_access` false, readback still true.
15. Anon key on `rpc/get_sample_access_state` → `401 permission denied`.

**Reset, in this order** (the tables reference each other both ways): `sample_consumptions` → set
`sample_tries.grant_id` and `claimed_by_user_id` to null → `sample_grants` → `sample_consumed_emails` →
`grading_results` → `response_versions` (also `created_by`) → `attempts` → `learning_session_items` →
`learning_sessions` → all `sample_tries` → `audit_events` (`subject_user_id`, `actor_user_id`, `actor_id`) → then the
user via the admin API. Then `sample_access_enabled=false` and
`supabase secrets unset SAMPLE_ACCESS_ENABLED`. Confirm 0 rows in all four `sample_*` tables and 0
`learning_sessions` with `entry_path='sample'`.

## Part C — Activation readiness (judgement, read-only)

For each `APPROVAL-0207` §3 precondition say met / not met / not your call, with the evidence you saw:
1 Development end-to-end (part B); 2 app Cramapple-FRQ path (check `ap-prep-blueprint` `main` for an FRQ picker
and a `targeted_drill` session start on the sample route); 3 analytics; 4 §13 minors'-data check; 5 D7; 6 P8 grace
resume; 7 a day of dark Production traffic without regressions (query `app.attempts`/`learning_sessions` created
after 2026-11-09 16:00 UTC and look for failures in the Supabase dashboard function logs); 8 photo flags.

**Verdict format:** (A) dark apply: PASS / FAIL with findings; (B) backend ready for activation: YES / NO /
CONDITIONAL with the exact open items. Do not flip any Production switch, deploy, or secret.

---
