# QA packet: paywall sample access backend (Development, 2026-11-08)

**For:** Codex (independent QA). **Author:** Claude backend session (did not QA its own work).
**Status:** Development implementation merged to `main` (PR #595). **QA round 1 (2026-11-09): two findings,
both confirmed in source and fixed on Development the same day; see §7 for the fixes and the re-test scope.**
**Tier:** Hard-Gate. **Production:** untouched; nothing here authorizes it.
**Spec and contract:** [`docs/product/PAYWALL_BACKEND_DESIGN_SPEC_2026_11_08.md`](../product/PAYWALL_BACKEND_DESIGN_SPEC_2026_11_08.md)
(§10 is the API/RPC contract the app session builds against; §14 lists the PROPOSED rules awaiting David).

## 1. What changed

| Area | Files | Summary |
| --- | --- | --- |
| Migration | `supabase/migrations/20261108201632_paywall_sample_access.sql` (applied to Development under that ledger version); `supabase/migrations/down/paywall_sample_access_down.sql` | Tables `app.sample_tries`, `sample_grants`, `sample_consumptions`, `sample_consumed_emails`; config switches (both off / honor-existing on); 20+ `app.sample_*` functions; `app.has_study_subject_access` gains the sample branch (admission while phase `active`); new `app.has_study_readback_access` patched into `public.get_question_experience`; `public.get_study_topic_point_guides` unit lock; `app.authorize_grading_access` sample branch (clock, fixed grace, 3 grading requests, no revision); BEFORE INSERT trigger `sample_gate_attempt_insert` on `app.attempts`; AFTER trigger `sample_supersede_on_entitlement` on `app.subject_entitlements`; `learning_sessions.entry_path` accepts `'sample'`; public RPCs `claim_sample_try`, `get_sample_access_state`, `claim_sample_frq_source` (stub) |
| Development alignment | ledger row `20261031143302 subject_access_before_study` | `main`'s subject-access migration (Production `20261104125832`) was missing from Development; applied by hand 2026-11-08 with the file's exact body so the sample migration's anchor patch had its target |
| New edge function | `supabase/functions/sample-try/` (`index.ts`, `index_test.ts`, `_test_setup.ts`) | Public anonymous first MCQ: `list_units`, `start`, `answer`, `status`; env `SAMPLE_ACCESS_ENABLED` (default off); per-IP rate limit `sampleTry` (60/h, 2 000/h global) |
| Edited edge functions | `attempt-response/index.ts` | `create_attempt`: `sample:<code>` trigger refusals → `403 {error, access:'sample', state}`; `propose_transcript`: `app.sample_take_photo_run` guard (3 runs per sample FRQ) |
| | `student-session-items/index.ts`, `_shared/student-item-delivery.ts` | `app.sample_serving_scope` read (fail closed 503); queue filtered to the grant's unit/allowance; `omitted[].reason='sample_scope'`; `result.sample`; `reason='sample_allowance'` |
| | `_shared/public-rate-limit.ts` | `PUBLIC_ENDPOINT_LIMITS.sampleTry` |
| Tests | `supabase/tests/sample_access.integration.sql` (Development, rollback-only, 22 checks since 2026-11-09); `sample-try/index_test.ts` (13); `student-session-items/index_test.ts` (+4); `attempt-response/index_test.ts` (+3 `propose_transcript` sample-cap tests, 2026-11-09); `.github/workflows/minimal-ci.yml` runs the new suite | |
| QA round 1 fixes (2026-11-09) | `supabase/migrations/20261109131921_paywall_sample_access_qa_fixes.sql`; `attempt-response/index.ts`, `_test_setup.ts` | See §7 |

Development function versions after this branch's deploy are recorded in the PR description (`supabase functions list`).

## 2. How to run the tests

Deterministic (no network), from the repo root — same command shape as `minimal-ci.yml`:

```bash
env -i PATH="$PATH" HOME="$HOME" deno test --allow-env=ALLOWED_ORIGINS,SUPABASE_URL,SUPABASE_ANON_KEY,SUPABASE_SERVICE_ROLE_KEY,SERVICE_ROLE_KEY,GRADING_ENTITLEMENTS_ENABLED,FRQ_PHOTO_RESPONSES_ENABLED,FRQ_PHOTO_SUBJECTS,FRQ_TRANSCRIPT_MODEL,OPENAI_MODEL,OPENAI_API_KEY,FRQ_TRANSCRIPT_TIMEOUT_MS,FRQ_TRANSCRIPT_RESERVED_COST_USD,OPENAI_DAILY_CAP_USD,FRQ_TRANSCRIPT_DAILY_RUNS,FRQ_PHOTO_DAILY_CAP_USD,SAMPLE_ACCESS_ENABLED,PUBLIC_RATE_LIMIT_HMAC_KEY,BYOQ_IP_HMAC_KEY supabase/functions/sample-try/index_test.ts supabase/functions/student-session-items/index_test.ts supabase/functions/attempt-response/index_test.ts supabase/functions/_shared/public-rate-limit_test.ts
```

Expected: 81 passed, 0 failed for the four files (78 on 2026-11-08; +3 `attempt-response` tests on 2026-11-09). The full CI list in `minimal-ci.yml` gives 819 passed. `deno check` and `deno lint` on the three edited/new functions are clean.

Development SQL integration test (always rolls back; the result **is** the exception text):

```bash
supabase db query --linked --workdir /Users/davidbloom/Documents/Cramapple.nosync -f /Users/davidbloom/Documents/Cramapple.nosync/supabase/tests/sample_access.integration.sql
```

Expected: `ERROR: P0001: SAMPLE_ACCESS_TESTS_PASSED (22 checks)` (21 before 2026-11-09). Confirm the project ref is `wmgjsdkphcyhngaffbqf` (`--debug`) before running; never run against Production. The same body pasted into the Supabase MCP `execute_sql` for the Development project gives the same result. It flips `app.config.sample_access_enabled` inside the transaction only; §5 query 1 confirms it is back to `false` afterwards.

## 3. Development state to confirm first

- Ledger: versions `20261031143302`, `20261108201632` and (since 2026-11-09) `20261109131921` present (§5 query 0).
- `app.config`: `sample_access_enabled=false`, `sample_access_honor_existing=true`.
- Zero rows in all four `sample_*` tables; zero `learning_sessions.entry_path='sample'`.
- `sample-try` deployed with `--no-verify-jwt`; `SAMPLE_ACCESS_ENABLED` **not** set on Development (so the function answers `503 sample_disabled`). To exercise it, set the env var on the function and `update app.config set config_value='true' where config_key='sample_access_enabled'` on Development, then set both back.
- Development content: only `ap-statistics` unit 1 is `eligible` in `app.sample_unit_availability` (199 MCQs, 1 FRQ); Development's topic resolution is sparse compared with Production, so unit-availability behaviour should be judged by the function's rule, not by Development's numbers. The Production availability table is in the spec §1.

## 4. Risk areas and what to attack

1. **Entitlement bypass** — a sample grant must never widen access beyond its subject/unit/phase:
   - Open Hand (`get_open_hand_teaching_topics`), progress dashboard, More help, `get_study_topic_point_guides` for another unit, `student-session-items` for another pack, `session_start` for another subject, any `subject_entitlements`-based check: all must still deny a sample-only user. The spec's claim is that only three gates read the grant; verify by grepping Development function bodies for `sample_` (§5 query 6) and by exercising the others.
   - `has_study_subject_access` is true only in phase `active`. Try grace/expired/superseded/disabled via the time-travel updates in the integration test.
   - `sample_gate_attempt_insert` fires only when the user has **no** regular entitlement; confirm a trial/paid/beta/staff user is untouched (no `sample_consumptions` row, no refusal).
2. **Answer-key leakage** — `sample_try_start`/`status` (while `served`) must never include `is_correct`, `rationale`, `explanation`, or `prompt_json`; `select_sample_mcq` must exclude Open Hand teaching items, hand-drawn items, image-stimulus items; the anon role must have no execute on any `sample_*` function (§5 query 7) and no table grants. The `answer` response does carry the key (by design, after the answer is recorded). `DECISION-0089`/`0117` direct reads: nothing new is granted on `mcq_choices`.
3. **Double consumption / concurrency** — two concurrent `create_attempt` for different items near the allowance edge (the grant row is locked `for update` in the trigger); two concurrent `claim_sample_try` for the same user (advisory lock) and for the same token by two users; re-creating an attempt on an already-consumed item must not consume; `authorize_grading_access` replay with the same request id must not count against the 3-request cap.
4. **Clock / grace edges** — `expires_at` and `grace_ends_at` are stored at claim and never recomputed; `sample_consumptions.grace_deadline` is copied at consumption and governs grading (the test moves it independently); no new attempt in grace; readback in every phase; `honor_existing=false` → phase `disabled` everywhere except readback.
5. **Trial precedence** — inserting an active trial/paid/beta row supersedes the grant permanently; revoking that row (how `trial_cancel` does it) must not revive sample admission or grading; the `DECISION-0126` functions (`trial_activate`, `trial_cancel`, `trial_set_trial_access`, `trial_convert`) are unchanged (compare md5 against `main`).
6. **Eligibility** — `claim_sample_try` refuses: non-student role, existing grant, consumed sample email, any `subject_entitlements` row (any status), consumed trial email, unanswered try, expired claim window, token claimed by another user; a refused claim leaves no grant, session, attempt, or consumed-email row.
7. **Typed denial path** — every refusal is `sample:*` / `grading_access:sample_*` / `sample_try:*` with the HTTP shapes in spec §8; `attempt-response` 403 bodies carry `access:'sample'` and `state`; nothing degrades to `attempt_create_failed`/500.
8. **Minors' data** — `sample_tries` holds no email/name/raw IP; `attribution` only ever contains `sanitizeAdAttribution` keys and drops click ids when `ad_tracking_allowed=false` (`sample-try` test covers this; confirm in Development after a real `start`).
9. **Imported first MCQ** — `claim_sample_try` writes graded `attempts`/`response_versions`/`grading_results` rows directly. Check that `get_question_experience`, `get_graded_mcq_feedback`, the progress dashboard and the question page tolerate `model_id='sample_try_deterministic'`, `request_id='sample-try:<uuid>'`, and `entry_path='sample'`; check the weekly session sweep does not misclassify the session.
10. **Fail-closed paths** — `student-session-items` returns 503 when `sample_serving_scope` errors (regular students included); confirm that is acceptable and that the RPC exists on Development with service grants only.

## 5. Exact Development verification queries

Run as the service/postgres role on `wmgjsdkphcyhngaffbqf` (MCP `execute_sql` or `supabase db query --linked --workdir <repo>`).

```sql
-- 0. ledger
select version, name from supabase_migrations.schema_migrations where version in ('20261031143302','20261108201632');
-- 1. switches (expect false / true)
select config_key, config_value from app.config where config_key like 'sample_access_%' and config_key <> 'sample_access_prior_definitions';
-- 2. no residue
select (select count(*) from app.sample_tries) tries, (select count(*) from app.sample_grants) grants,
       (select count(*) from app.sample_consumptions) consumptions, (select count(*) from app.sample_consumed_emails) emails,
       (select count(*) from app.learning_sessions where entry_path='sample') sample_sessions,
       (select count(*) from auth.users where email like 'sample-test-%@example.invalid') test_users;
-- 3. triggers in place
select tgrelid::regclass, tgname from pg_trigger where tgname in ('sample_gate_attempt_insert','sample_supersede_on_entitlement','require_learning_session_subject_access');
-- 4. patched bodies
select strpos(pg_get_functiondef('public.get_question_experience(uuid,integer)'::regprocedure),'has_study_readback_access')>0 as qx_readback,
       strpos(pg_get_functiondef('app.has_study_subject_access(uuid,text)'::regprocedure),'sample_study_access')>0 as hssa_sample,
       strpos(pg_get_functiondef('app.authorize_grading_access(uuid,uuid,text,text)'::regprocedure),'sample_grading_limit_reached')>0 as aga_sample;
-- 5. entry_path check
select pg_get_constraintdef(oid) from pg_constraint where conname='learning_sessions_entry_path_check';
-- 6. which functions read the grant (expect only the sample_* family, has_study_subject_access, has_study_readback_access, authorize_grading_access, get_study_topic_point_guides, get_question_experience via readback)
select n.nspname, p.proname from pg_proc p join pg_namespace n on n.oid=p.pronamespace
where n.nspname in ('app','public') and pg_get_functiondef(p.oid) ilike '%sample_grants%' order by 1,2;
-- 7. privileges: anon none; authenticated only the three public RPCs
select p.proname, has_function_privilege('anon', p.oid, 'execute') anon_exec, has_function_privilege('authenticated', p.oid, 'execute') auth_exec
from pg_proc p join pg_namespace n on n.oid=p.pronamespace where n.nspname in ('app','public') and p.proname like '%sample%' order by 1;
select grantee, table_name, privilege_type from information_schema.role_table_grants where table_schema='app' and table_name like 'sample%' and grantee in ('anon','authenticated');
-- 8. RLS forced
select relname, relrowsecurity, relforcerowsecurity from pg_class where relname like 'sample_%' and relnamespace='app'::regnamespace;
-- 9. unit availability rule (eligible = >=8 MCQ and >=1 non-photo FRQ)
select app.sample_unit_availability('ap-statistics');
-- 10. trial functions unchanged vs main (compare these md5s to a fresh checkout of main applied locally, or to Production read-only)
select proname, md5(pg_get_functiondef(oid)) from pg_proc where proname in ('trial_activate','trial_cancel','trial_set_trial_access','trial_convert','trial_sweep') order by 1;
```

Edge smoke (Development only, after enabling both switches; then disable both):

```bash
curl -s -X POST "https://wmgjsdkphcyhngaffbqf.supabase.co/functions/v1/sample-try" -H "apikey: <dev publishable key>" -H "content-type: application/json" -d '{"operation":"list_units","subject_key":"ap-statistics"}'
curl -s -X POST "https://wmgjsdkphcyhngaffbqf.supabase.co/functions/v1/sample-try" -H "apikey: <dev publishable key>" -H "content-type: application/json" -d '{"operation":"start","subject_key":"ap-statistics","unit_number":1}'
```

Expect `503 sample_disabled` while either switch is off; with both on, `start` returns a `try_token` once and a `question` with no `is_correct`.

## 6. Known gaps and non-goals (do not report as defects)

- Student-uploaded FRQ grading is a recorded **blocker** (spec §11): `public.claim_sample_frq_source` always raises `sample:byoq_grading_not_available`. BYOQ itself is unchanged.
- `session-event` `session_resume` denies during grace (spec §5.6, P8); the app reads `learning_session_id` from `get_sample_access_state()` instead. Not implemented in this slice.
- Photo-answer flow for the sample FRQ depends on `FRQ_PHOTO_SUBJECTS` / `FRQ_PHOTO_RESPONSES_ENABLED`, both dark on Development and Production.
- `app.sample_pack_for_subject` picks the newest published, non-retired pack version; `ap-statistics` on Development has two published versions (a 2026-07-15 fixture and the 2026-08-23 one); the newer one carries the unit-1 content and is the one used.
- The anonymous `start` excludes image-stimulus MCQs (PROPOSED P5).
- All rule values (24h/7d try windows, 3 switches, 3 grading requests, 3 photo runs, per-IP 60/h) are PROPOSED defaults; verify behaviour against the spec, not against the plan's silence.

## 7. QA round 1 (2026-11-09): findings, fixes, re-test scope

Codex reported two source-backed findings and recommended **block release pending fixes and retesting**. Both
were confirmed in source by the backend session and fixed on Development the same day. Neither had been
reproduced live by QA; the integration test now reproduces finding 1 (it fails against the old trigger body) and
the Deno suite reproduces finding 2 (the 503 test fails against the old handler).

| # | Finding (Codex) | Confirmed cause | Fix | Pinned by |
| --- | --- | --- | --- | --- |
| 1 | A future-start regular entitlement can become active without permanently superseding the sample, so sample access may revive later | `app.sample_supersede_on_entitlement` required `new.starts_at <= now()`; a row inserted/updated with a future `starts_at` never fired the supersede, the regular path won while it was active, and the still-`active` grant revived when the row ended | Migration `20261109131921_paywall_sample_access_qa_fixes.sql`: the trigger supersedes on any `status='active'` trial/paid/beta row that has not ended, regardless of `starts_at`; one-off backfill of any `active` grant beside such a row (Development had none) | `sample_access.integration.sql` check 22 (future-start `paid` row supersedes at insert; revoking it later does not revive admission; phase stays `superseded`; readback kept) |
| 2 | If the photo-limit RPC fails unexpectedly, transcription continues without enforcing the three-run sample cap | `propose_transcript` logged a non-`sample:*` error from `app.sample_take_photo_run` and fell through to the shared caps and the model call | `attempt-response/index.ts` returns `503 {error:'sample_photo_check_failed'}` on any non-`sample:*` error (fail closed, same posture as `student-session-items`); Development `attempt-response` v51 | `attempt-response/index_test.ts`: `sample:*` → 403 typed; unexpected error → 503 and no cap/model path reached; `'not_sample'` → continues |

Verification run by the backend session (not independent QA): full CI Deno suite 819 passed / 0 failed with
`minimal-ci.yml`'s exact `--allow-env` list; `deno check`/`deno lint` clean on `attempt-response`; Development
integration test `SAMPLE_ACCESS_TESTS_PASSED (22 checks)` via MCP `execute_sql`, rolled back; Development afterwards:
0 grants, 0 tries, 0 test users, `sample_access_enabled=false`, trigger body no longer contains `starts_at <= now()`.

**Re-test scope for Codex:** (a) §5 query 0 shows version `20261109131921`; (b) re-run the integration test
(expect 22 checks); (c) attack finding 1 directly: with the flag on, claim a grant for a fresh test user, insert a
`paid` row with `starts_at = now() + interval '1 day'`, confirm `sample_grants.status='superseded'`, revoke the
row, confirm `app.has_study_subject_access` is false and `app.sample_grant_phase` is `superseded`; also try an
`update` that flips a `pending` row to `active` with a future start; (d) attack finding 2 on Development:
temporarily `revoke execute on function app.sample_take_photo_run(uuid,uuid) from service_role` (or rename it),
call `propose_transcript` as an admin with a photo attached, expect `503 sample_photo_check_failed` and no
`model_usage_ledger` row, then restore the grant; (e) confirm the 503 is acceptable for regular (non-sample)
students too, since the RPC is called for everyone and `'not_sample'` is the pass value. `FRQ_PHOTO_*` remain dark
on Development; (d) needs them set on the function for the duration of the test and reset afterwards.
