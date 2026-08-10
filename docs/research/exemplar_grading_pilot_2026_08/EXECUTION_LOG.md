# Execution log — exemplar-grading pilot — 2026-08-10

## Synthetic pilot identity

- `user_id`: `60646a2f-9ec3-4ed3-9f33-2b7c9b9eb069`
- `email`: `exemplar-pilot-20260810-3c8f61b5+test@cramapple-internal.test`
- Created via `create_pilot_session.mjs` by the repo owner; email-confirmed
  and given an `active` `app.subject_entitlements` row (`ap-statistics`,
  `beta` tier, `source: 'exemplar_grading_pilot_2026_08'`) directly in the DB
  to satisfy `attempts_entitled_owner_insert`'s RLS policy, which the
  original plan didn't anticipate needing.

## Runs

- Sizing run (`PILOT_MODE=size`): 20/20 calls succeeded, 100% trial
  agreement on all 4 criteria of `APSTATS-SFRQ-001#0` (`arm=off`).
- Full run (`PILOT_MODE=full PILOT_TRIALS=5`): 300 calls attempted.
  - First attempt: 1 call failed with `409 content_not_published`
    (`APSTATS-SFRQ-003`, later confirmed `content_item_versions.status =
    'retired'`) before the item-exclusion fix; corpus corrected to 30
    gradable responses (300 → 300 calls after exclusion, since the corpus
    filter runs before the call list is built).
  - Second attempt (post-fix): 271/300 succeeded, then 29 failed with `401
    UNAUTHORIZED_ASYMMETRIC_JWT` — the pilot session's 1-hour access token
    expired mid-run.
  - Third attempt (after `--signin` refresh): all 29 remaining calls
    succeeded. Final: 300/300 real grading calls completed across both runs
    combined (300 unique calls once size-run overlap and failed retries are
    accounted for).

## Cleanup (completed 2026-08-10, same session as the run)

Deleted, scoped strictly to `user_id = 60646a2f-9ec3-4ed3-9f33-2b7c9b9eb069`:
- `app.grading_results` (315 rows, via `attempt_id` join)
- `app.response_versions` (31 rows, via `attempt_id` join)
- `app.attempts` (31 rows)
- `app.subject_entitlements` (1 row)
- `app.profiles` (1 row)
- `auth.users` (1 row)

No `app.student_memory_events` or `app.student_memory_snapshots` rows
existed for this user (checked before cleanup — 0 in both).

Verified post-cleanup: a query across `auth.users`, `app.profiles`,
`app.attempts`, `app.subject_entitlements`, and `app.grading_results` (via
join) for this `user_id` returns 0 rows in every table.

## Data kept (intentionally, per the plan's Files list)

`raw_calls.jsonl`, `results_with_exemplar.json`,
`results_without_exemplar.json`, `raw_trial_variance.json`, `report.json`,
`REPORT.md`, `gold_cases_gradable.json` — all in this directory, all derived
from a synthetic account's grading calls against real published content, no
real student data involved.
