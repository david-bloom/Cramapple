# Session close: no-card trial Production QA and migration reconciliation (2026-11-10 UTC)

**Status:** Codex QA and migration-reconciliation companion to the [live Production session closeout](SESSION_CLOSE_2026_11_10_NO_CARD_TRIAL_LIVE_IN_PRODUCTION.md), which is the primary restart document. Production changes through `APPROVAL-0213` and David's real signed-out trial walk are recorded on `main` in PR #621. The checkout *page* was seen, but a live checkout after the card-trial secret change has **not** been exercised. The earlier [pre-release handoff](SESSION_CLOSE_2026_11_09_CARDLESS_TRIAL_TO_PRODUCTION.md) is historical. Read the [release packet](../product/NO_CARD_TRIAL_PRODUCTION_RELEASE_PACKET_2026_11_10.md) and approval records before any further Production action.

## 1. Current task or issue

Release and certify the seven-day, one-subject, no-card trial chosen in `DECISION-0135`. `DECISION-0136` makes it the new-student path and puts the 72-hour sample on hold indefinitely. This is a Hard-Gate release involving entitlements, authentication, payments adjacency and student data. David requested this Codex session's thorough closeout after the independent QA, dark Production apply and migration-version reconciliation.

## 2. What changed this session and in the coordinated release

- This Codex session independently checked the app and Development backend, rehearsed the four-file rollback/reapply, and applied four reviewed migrations to Production under David's exact approval: “I approve applying the four no-card trial migrations to Production with the trial switch kept off.” The Production apply was at 02:20–02:23 UTC. The SQL files were renamed to the versions stamped by Production without changing their bodies. PR [#616](https://github.com/david-bloom/Cramapple/pull/616) passed six checks and merged as `02ce7420`.
- Other coordinated sessions subsequently recorded `DECISION-0136`, switched the sample off under `APPROVAL-0211` (02:44 UTC), ran [dark verification](../qa/NO_CARD_TRIAL_PRODUCTION_DARK_VERIFICATION_2026_11_10.md), turned the no-card trial switch on for self-test under `APPROVAL-0212` (03:24:49 UTC), and set the card-trial admission secret false under `APPROVAL-0213`. David's [real Production walk](../qa/NO_CARD_TRIAL_PRODUCTION_REAL_WALK_2026_11_10.md) is merged in PR [#621](https://github.com/david-bloom/Cramapple/pull/621) (`2f4eb779`). That record reports email-code signup, AP Chemistry trial, four graded MCQs, one graded FRQ, saved-work review, live marketing/pay-now page checks and test-account cleanup; app fixes #54–#56 were published during the walk. This closeout did not independently repeat those browser steps.
- No Production write was made while preparing this closeout. The live database read at about 04:22 UTC showed `cardless_trial_enabled=true`, `sample_access_enabled=false`, `sample_access_honor_existing=true`, and `trial_daily_grading_cap=40`; there were zero `trial_v2` subject entitlements, zero `trial_v2` consumed-email rows, and zero trial grading-log rows. The card-trial secret value is known from `APPROVAL-0213`'s digest check, not from this read.

## 3. What was verified

| Area | Evidence and limit |
| --- | --- |
| App source | In `ap-prep-blueprint` source checkpoint `a812100d`, TypeScript `tsc --noEmit`, 1,350 Vitest tests in 137 files, and `vite build` passed. Later app PRs #54–#56 were merged/published during the real walk; those changes were not part of this earlier source test run. |
| Development SQL | `supabase/tests/cardless_trial.integration.sql`: 46 checks; `get_my_learning_sessions.integration.sql`: 10 checks. Both ran in rollback-only transactions. Two real two-connection races proved the same-email loser gets `trial:already_used` and the concurrent grader loser gets `grading_access:trial_daily_cap` at cap 1. Four-file down/up rehearsal passed. Development was left with the trial switch false, cap 40 and no test grants/logs. |
| Production dark apply | `APPROVAL-0210` records the before/after catalog and function hashes, `blocked/disabled` fresh state, zero trial data and paid grading still `entitled`. The independent dark check later passed. Supabase advisor's new INFO/WARN findings are documented and intentional; no ERROR finding was reported. |
| Production self-test switch | `APPROVAL-0212` records a fresh account as `none/can_start=true`, paid/admin as `superseded/can_start=false`, with zero grants after the switch. The 04:22 UTC live read above confirms the switch remains on and the data counts remain zero. |
| Real student walk, coordinated session | [PR #621's QA record](../qa/NO_CARD_TRIAL_PRODUCTION_REAL_WALK_2026_11_10.md) reports the signup, grant, grading and saved-work path passing; four MCQs and one FRQ produced five grading-log rows before David authorized deletion of that test account and its trial data. It also reports live marketing links and checkout-page pay-now wording. The record's header says the walk ended around **04:50 UTC**, although its commit is timestamped **04:21 UTC** and merge **04:23 UTC**; reconcile that time range before using it as an audit timestamp. The steps and cleanup are reported by that session, not independently re-run here. |
| Sample and card trial | `APPROVAL-0211` records the sample database switch false and `sample:disabled` from the claim RPC. `APPROVAL-0213` records the card-trial secret's digest changing from `true` to `false`; the next cold-start checkout behavior was inferred there, not tested with a live checkout. |

## 4. Migration versions: trial slice reconciled, whole repository not reconciled

| Migration | Development ledger | Production ledger and `main` file |
| --- | --- | --- |
| `cardless_trial_v2` | `20261109215704` | `20261110022023` |
| `get_my_learning_sessions` | `20261109221340` | `20261110022041` |
| `cardless_trial_v2_qa_fixes` | `20261110011605` | `20261110022049` |
| `cardless_trial_v2_email_race` | `20261110013137` | `20261110022059` |

At about 04:22 UTC, a complete filename comparison of Production `list_migrations` against `git ls-tree -r --name-only origin/main supabase/migrations` (direct `14-digit_version_name.sql` files only; excludes `down/`) found **370 ledger rows, 383 files, 126 exact version-and-name matches, 244 ledger rows without an exact file match, and 257 files without an exact ledger match**. The four rows above all matched. This corrects my earlier incomplete repo-file count of 329 and unmatched-file count of 203. These counts describe *names and versions*, not migration effects or live schema parity: an unmatched row is not necessarily an unapplied change. The [2026-10-21 effect-level assessment](../qa/MIGRATION_LEDGER_RECONCILIATION_2026_10_21.md) and `DECISION-0128` govern the older divergence. `db push` remains prohibited on both projects; use reviewed `apply_migration` plus catalog checks and the recorded ledger version.

## 5. What remains open

1. **First live checkout after secret switch:** `APPROVAL-0213` did not create a checkout, and PR #621 only reports the pay-now checkout page. Confirm the next real checkout/session is pay-now and uses `TRIAL_ADMISSION_ENABLED=false` after an edge-function cold start; do not describe that as observed until checked.
2. **Live-traffic watch:** the real signed-out walk and marketing/page checks are recorded in PR #621. Continue watching OTP delivery against the 30 emails/hour cap, 40/day grading cap, costs and error/denial logs. Day-seven expiry remains a Development rehearsal. Reconcile the QA record's inconsistent end timestamp.
3. **Remaining UX/content:** PR #621 records optional “No card needed” code-step wording, a broader empty-state wording/backend answered-count issue, and thin AP Chemistry 2.2 content. App fixes #54–#56 were published according to that record; check their current live state before further edits.
4. **Operational/product decisions:** funnel analytics and Reddit day-seven conversion definition; notice version accepts any `YYYY-MM-DD` by current design; trial-data retention. Resolve or explicitly accept before broader traffic.

## 6. Open blockers and risks

The release sequence moved ahead of its planned real-student verification, but David's subsequent walk in PR #621 covered signup, trial, grading and saved work and found app issues fixed in #54–#56. The first live checkout/session after the card-trial secret switch remains untested. A signed-in paid/admin account redirects from `/start` to `/home` and is `superseded`; it cannot substitute for a fresh signed-out test. The 72-hour sample remains deployed but dark under `DECISION-0136`; there is no D12 code change to make. Legacy card-trial code remains deployed for possible future use. PR #621's end timestamp is inconsistent with its Git timestamps and should be corrected.

## 7. Files, systems, commands and tests

- Source and durable records: [approval 0210](../activity_log/APPROVAL-0210_NO_CARD_TRIAL_PRODUCTION_DARK_MIGRATIONS_2026_11_09.md), [approvals 0211](../activity_log/APPROVAL-0211_SAMPLE_ACCESS_SWITCH_OFF_PRODUCTION_2026_11_10.md), [0212](../activity_log/APPROVAL-0212_NO_CARD_TRIAL_SELF_TEST_SWITCH_ON_PRODUCTION_2026_11_10.md), [0213](../activity_log/APPROVAL-0213_CARD_TRIAL_ADMISSION_OFF_PRODUCTION_2026_11_10.md), [real walk](../qa/NO_CARD_TRIAL_PRODUCTION_REAL_WALK_2026_11_10.md), [release packet](../product/NO_CARD_TRIAL_PRODUCTION_RELEASE_PACKET_2026_11_10.md), four Production-stamped SQL files in `supabase/migrations/`, their `down/` scripts and two integration suites. This closeout updates this file, the release packet, the index and the activity log only.
- Commands/queries: app `tsc --noEmit`, `vitest run`, `vite build`; rollback-only Development SQL integration and two-connection concurrency calls; four-file rollback/reapply rehearsal; Production SQL catalog/config/count/function checks; Supabase `list_migrations`; `git ls-tree` exact filename comparison; PR #616 checks. The latest read-only Production query returned the switches and zero-row counts in §2. No new code or SQL test was needed for this docs-only closeout.

## 8. Approval state and next owner action

David granted `APPROVAL-0208` (Development authority), `APPROVAL-0209` (retire legacy start-trial), `APPROVAL-0210` (four dark Production migrations), and the coordinated sessions recorded his separate grants for `APPROVAL-0211`, `0212` and `0213`. He performed and authorized cleanup of the real trial walk recorded in PR #621. The documentation here grants no new Production authority. **David or a tester he names owns the next action:** verify and record the first real pay-now checkout after `APPROVAL-0213`, then monitor the now-public trial. Any corrective Production write or new launch step needs its own explicit approval and record under the Hard-Gate rules.

## 9. Do not touch in the next session without a new decision/approval

Do not `db push`, rename or replay the four applied migration bodies, treat historical ledger mismatches as instructions to backfill, re-enable the 72-hour sample or card trial, or change entitlement/grade gates. Preserve existing paid and legacy entitlements; use read-only checks first. The trial switch is **currently on**; if live monitoring finds a failure, follow the release packet's rollback path and record David's authorization and the effect on already-started trials. Do not infer a live checkout pass from the pay-now page alone.

## 10. Restart note

Open the [primary live-release closeout](SESSION_CLOSE_2026_11_10_NO_CARD_TRIAL_LIVE_IN_PRODUCTION.md), this companion and the latest approvals; verify current switches and deployments, watch first real traffic, then verify the first real pay-now checkout. Recommended next-session prompt: “Continue the no-card trial Production release from both 2026-11-10 closeouts. Check current main and live switches, inspect first-traffic OTP and grading signals, verify the first post-0213 checkout outcome, reconcile the real-walk QA record's timestamp, and document results before further changes.”
