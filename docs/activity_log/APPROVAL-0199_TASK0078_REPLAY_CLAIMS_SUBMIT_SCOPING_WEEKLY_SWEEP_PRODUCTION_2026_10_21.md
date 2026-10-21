# APPROVAL-0199 — TASK-0078 batch to Production: replay claims (migration + two function deploys), submission replay scoping, weekly session sweep (executed)

- **Date:** 2026-10-21 (Development about 21:12 UTC; Production about 21:14–21:16 UTC).
- **Granted by:** David Bloom (Product Owner), in session: "apply and deploy for all three to development, then check success, then merge collectively to production", after the Fable reviews of PRs #521 and #523 and the ruling-2 sweep design in TASK-0078 §3.
- **Related:** TASK-0078 rows A2, A9, A11; PR #521 (replay claims migration, `session-event` and `storage-sign-url` handlers, fixture, release packet `docs/qa/TASK0078_REPLAY_RELEASE_PACKET.md`); PR #523 (submission replay scoping, fixture, packet `docs/qa/TASK0078_SUBMISSION_RPC_RELEASE_PACKET.md`); rulings 2 and (for A2's tier) the Fable review on #521; repository renames in PR #549.

## Scope, in the order applied on each project

| # | Change | Development ledger | Production ledger |
| --- | --- | --- | --- |
| 1 | `app.operation_replay_claims` table (RLS on, `service_role` only) plus `app.claim_operation_replay` and `app.complete_operation_replay` (`service_role` execute only) | `20261021211219` | `20261021211427` |
| 2 | `app.submit_response` replay probes scoped to the actor; unique-index collision on `audit_events_request_id_reason_code_unique` mapped to `submit_response:idempotency_conflict` with the whole transaction rolled back | `20261021211251` | `20261021211450` |
| 3 | `cron.schedule('task0078-sweep-learning-sessions', '0 6 * * 6', 'select app.sweep_learning_sessions(120);')` (Saturday 06:00 UTC = 01:00 EST / 02:00 EDT) and the function comment | `20261021211255` | `20261021211454` |
| 4 | `session-event` and `storage-sign-url` deployed from `main` `515e0f81` (after the migrations, as the packet requires); `verify_jwt` left `true` on both | v41 (`667e3f30…`), v44 (`58363d53…`) | v52 (`667e3f30…`), v47 (`58363d53…`) |

Each migration was applied with the Supabase MCP `apply_migration` as a single file; no `db push`, no ledger repair. The
repository files are named for the Development versions (PR #549), per the TASK-0077 convention.

## Pre-apply state (Verified)

- Production `app.submit_response` `024e412aacf07cfd7ed0c0e03ef70d89` (the hash the guard accepts); no `operation_replay_claims` table; no `task0078-*` cron job. Development `submit_response` `f15074ff69f68948034ab6d0e8f72615`.

## Post-apply verification (Verified on both projects)

- Objects: table present with RLS on; both claim RPCs `{postgres,service_role}` execute only; `submit_response` now `49d382fff1a9572bbde5bbb2e8838ba7` with grants unchanged (`{postgres,service_role}`); cron job present with the schedule and command above.
- Behaviour: an eight-step `DO` block run as `postgres` and rolled back by a final `raise` on each project: claim → `claimed`; same actor and hash again → `pending`; other actor → `conflict`; completion inserts exactly one `audit_events` row; same actor again → `replay` with the stored result; changed hash → `conflict`; other actor after completion → `conflict`; completion carrying `signed_url` → `bearer_result_forbidden`. All eight passed on Development and on Production.
- Functions: both bundles downloaded from each project and diffed file by file against `main`: 12 files, zero differences, on both projects. Unauthenticated POST returns 401 on both functions on both projects. Production hashes equal Development hashes.
- Sweep: run once by hand on Development (`archived: 76`). **Not run by hand on Production**; the job fires Saturday 06:00 UTC and will archive Production's active sessions whose budget plus two hours has elapsed (four such sessions at the time of writing, including the two students' sessions and David's).

## Not done, by design

- No signed-in end-to-end replay through the deployed functions (needs a student session; the RPC test above covers the database contract and the handler tests on `main` cover the Edge logic).
- No Production run of the sweep.

## Rollback

- Functions: redeploy `session-event` and `storage-sign-url` from `main` at `515e0f81^` is not meaningful (those bodies are the same); the pre-change bundles are Production v51 (`f0d8b1a8…`) and v46 (`058eadf6…`), redeployable from commit `df39cd09`. Redeploying them does not need the claims table.
- Migrations: `cron.unschedule('task0078-sweep-learning-sessions')`; `create or replace` `app.submit_response` with the `024e412a…` body (schema baseline); `drop function app.claim_operation_replay, app.complete_operation_replay; drop table app.operation_replay_claims` only after the functions are rolled back, since the deployed handlers require them. Pending claim rows are evidence of in-flight actions and should be read before any drop.
