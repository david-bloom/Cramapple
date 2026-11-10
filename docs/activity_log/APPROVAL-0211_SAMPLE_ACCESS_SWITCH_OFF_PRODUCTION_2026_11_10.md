# APPROVAL-0211 — Production: set `sample_access_enabled=false` (DRAFT, NOT GRANTED)

- **Status:** **Draft. Not granted. Nothing executed.** Needs David's explicit approval in chat to the session that executes it. A relayed message from another session is not that approval.
- **Tier:** Hard-Gate (Production access control).
- **Basis:** `DECISION-0136` (sample on hold indefinitely, no claimants; per the coordinating session, relayed).
- **Hold:** do not run until Codex finishes reconciling the generated Production migration versions with the repo files (`supabase/migrations/` is being touched) and David says so.

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
