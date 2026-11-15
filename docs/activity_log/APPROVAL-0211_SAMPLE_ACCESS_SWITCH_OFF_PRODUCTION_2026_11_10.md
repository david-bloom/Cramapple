# APPROVAL-0211 — Production: set `sample_access_enabled=false` (DRAFT, NOT GRANTED)

- **Status:** **GRANTED by David in chat ("I approve 0211", 2026-11-10) and EXECUTED 2026-11-10 02:44 UTC** by the paywall-to-prod session; see Execution record. Hold on Codex's migration-version reconciliation was lifted first (David: all four Production versions match main, PR #616 merged; I confirmed the ledger).
- **Tier:** Hard-Gate (Production access control).
- **Basis:** `DECISION-0136` (sample on hold indefinitely, no claimants; per the coordinating session, relayed).
- **Former hold (cleared):** do not run until Codex finishes reconciling the generated Production migration versions with the repo files (`supabase/migrations/` is being touched) and David says so.

## Scope (config row only)
`update app.config set config_value='false'::jsonb, updated_at=now() where config_key='sample_access_enabled';` in Production (`pcntajvbdfqhbeewmdry`). No migration, no function deploy, no secret change. The edge secret `SAMPLE_ACCESS_ENABLED` is left as is (the database switch alone closes `claim_sample_try` and anonymous tries; leaving the secret true keeps rollback to one row).

## Pre-checks (read-only, record values)
1. `sample_access_enabled` currently `true` (verified 2026-11-10 before the row was ever changed); `sample_access_honor_existing=true`.
2. Claimants: `select count(*) from app.sample_grants;` and `app.sample_tries` rows (expect none real; list any test rows before touching anything).
3. md5 of `public.claim_sample_try`, `app.authorize_grading_access`, `public.get_trial_state` (record).
4. A paid student's `authorize_grading_access` result (pick an active paid entitlement) is `entitled`.

## Post-checks
1. Row reads `false`; `updated_at` moved; no other config row changed.
2. Sample claim path dead: as an authenticated test user in a rollback-only transaction, call `public.claim_sample_try(<any token>)` and expect `sample:disabled`; call the anonymous `sample-try` endpoint and expect `sample_try:disabled`. `get_sample_access_state()` does not raise when disabled (it returns the state with phase `disabled` only for an existing grant), so it is not a denial check. Confirm no new rows in `sample_tries`/`sample_grants`.
3. The three function md5s unchanged.
4. `get_trial_state()` returns the same `blocked`/`disabled` (switch `cardless_trial_enabled` still false) as before.
5. Paid student check from pre-check 4 unchanged; checkout unaffected.

## Rollback
Set the row back to `true`. Readback of any student's own graded sample work is never withdrawn by this switch.

## Record on execution
Time (ET), executor, before/after values, post-check evidence. Update this file's status line and the INDEX row.

## Execution record (2026-11-10, 02:44 UTC)
- **Before:** `sample_access_enabled=true` (updated 2026-11-09 20:11 UTC), `sample_access_honor_existing=true`, `cardless_trial_enabled=false`; `sample_grants`=0, `sample_tries`=1 (one unclaimed anonymous try, untouched), `sample_consumptions`=0; 3 active paid entitlements. Function md5: `claim_sample_try` c2660562…, `get_sample_access_state` dd0853db…, `get_trial_state` b93d59c9…, `authorize_grading_access` 58a13d1c…, `has_study_subject_access` 960c6b21….
- **Write:** one statement, `update app.config set config_value='false'::jsonb, updated_at=now() where config_key='sample_access_enabled'`; returned one row, `updated_at` 2026-11-10 02:44:21 UTC. No migration, deploy, secret or Lovable change.
- **After (verified):** the row reads `false`; `honor_existing` still true and `cardless_trial_enabled` still false; every md5 above identical; grants 0, tries 1, consumptions 0 (no new rows); 3 active paid entitlements; the only config row updated in the last 10 minutes was this one.
- **Sample claim path dead (verified):** as an authenticated paid student in a rolled-back DO block, `public.claim_sample_try(<40-char token>)` raised `sample:disabled`. (A first call with a token shorter than 32 characters raised `sample:try_not_found` from the length check, which is before the switch; ignore it.)
- **Anonymous `sample-try` endpoint: inferred, not called.** Its database guard raises `sample_try:disabled` from the same switch (migration lines 658 and 718); the edge secret `SAMPLE_ACCESS_ENABLED` was deliberately left as is.
- **Trial and paid access:** `get_trial_state` and `authorize_grading_access` bodies unchanged, so the trial state (`blocked`/`disabled`, its own switch is false) and paid grading are unchanged; I did not execute a paid grading call.
- **Rollback:** set `sample_access_enabled` back to `true`.
