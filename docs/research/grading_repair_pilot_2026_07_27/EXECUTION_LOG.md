# Engine 1 Grading + Repair Pilot Execution Log — 2026-07-27

## Scope

- Production Supabase project: `pcntajvbdfqhbeewmdry`
- Branch: `claude/cramapple-grading-experiments-9lkjqc`
- Starting commit: `0c5fc162ab6bb590d32695da7bc9bcddd4558353`
- Runner: `run_pilot.mjs`
- Run window: 2026-07-27 15:33:03–15:46:19 UTC
- Calls: 30 authenticated `grade_initial_attempt` requests

## Pre-flight

Confirmed before creating test data:

- All six exact `content_item_version_id` values still existed.
- All six content items, content versions, and parent exam-pack versions were
  `published`.
- All six versions had a real `content_review_decisions` row with
  `tutor_decision in ('approve', 'approve_with_edits')`.
- Production `evaluate-attempt` v23 was `ACTIVE` with JWT verification enabled.
- The deployed v23 source contained grading routing and repair planning.
- The deployed v23 function predates the local, unapplied entitlement
  migration, so the synthetic student did not need an entitlement or admin
  role.
- No content status, review decision, rubric, canonical answer, or content row
  was modified.

## Synthetic identity

| Field | Value |
|---|---|
| Email | `grading-pilot-20260727+test@cramapple-internal.test` |
| Auth user / profile ID | `edc8592c-28df-4094-a2fd-3788652b3536` |
| Profile name | `Synthetic Grading Pilot 2026-07-27` |
| Profile role | `student` |

Production email confirmation is enabled. The isolated synthetic account was
created through the Auth signup endpoint, then only that exact UUID/email was
confirmed so a real student bearer token could be obtained. No existing user
was reused or modified.

## Rows created

- 1 Auth user
- 1 `app.profiles` row
- 30 `app.attempts` rows
- 30 `app.response_versions` rows
- 30 `app.grading_results` rows
- 30 `app.model_usage_ledger` rows
- 0 learning sessions
- 0 student-memory events

Attempts and response IDs were deterministic, pilot-namespaced UUIDs generated
by `run_pilot.mjs`. Each grading call used a separate deterministic UUID
idempotency key. The runner executed calls sequentially and captured the full
API response plus the persisted grading row locally for analysis.

No `learning_session_id` was supplied because it was not required by the live
schema. Consequently, `persistGradingMemory` returned without creating
student-memory/session state.

## Call completion

- 30/30 calls reached a terminal persisted result.
- 20 returned HTTP 200 / `graded`.
- 10 returned HTTP 202 / `uncertain`.
- No call was retried or duplicated.
- Full findings are in `RESULTS_2026_07_27.md`.

## Cleanup

Cleanup was executed immediately after the result snapshot. Deletion counts:

| Data | Deleted |
|---|---:|
| `app.grading_results` | 30 |
| `app.model_usage_ledger` | 30 |
| `app.response_versions` | 30 |
| `app.attempts` | 30 |
| `app.student_memory_events` | 0 (none created) |
| `app.learning_sessions` | 0 (none created) |
| `app.profiles` | 1 |
| `auth.users` | 1 |

The model-usage ledger was included even though the kickoff's cleanup bullet
list did not name it, because it was a Production write created by the pilot.

## Final verification

After cleanup, a schema-wide scan checked every UUID, text, and JSONB column in
`app.*` for the synthetic user UUID. It returned no matches.

Explicit exact checks also returned zero for:

- the Auth user UUID;
- all 30 grading request/idempotency keys in `app.grading_results`;
- all 30 request keys in `app.model_usage_ledger`;
- all 30 attempt IDs;
- all 30 response-version IDs.

**Final state: no pilot test identity or pilot-generated application/model
usage data remains in Production.**
