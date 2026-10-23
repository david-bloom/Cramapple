# Session Close — TASK-0078 Development/Production Alignment, A16 Development Deploy, Branch Cleanup (2026-10-21 to 2026-10-22)

**Task:** `TASK-0078` backend stability follow-ups. **Product Owner:** David Bloom. **Closed at David's request** ("Document according to the end of session protocol and end the session").
**Read with:** `docs/tasks/TASK-0078-BACKEND-STABILITY-FOLLOW-UPS.md` (canonical checklist, rulings 1–7, §2d drift inventory and closure), `DECISION-0128`, and the earlier close of the same task's first day, `handoffs/TASK0078_REFACTOR_EXECUTION_2026_10_21.md`.
**Agent:** Claude Fable 5.1 in the Claude desktop app. Production project `pcntajvbdfqhbeewmdry`, Development `wmgjsdkphcyhngaffbqf`.

## 1. Current task or issue

`TASK-0078` remains In Progress. This session delivered ruling 6 (Development aligned to Production) and closed A19 (ledger strategy, `DECISION-0128`), deployed the two checkout functions to Development for A16, and finished the branch cleanup. Nothing in this session touched Production's schema or functions.

## 2. What changed this session

| Change | Where | Record |
| --- | --- | --- |
| `create-checkout-session` v47→v48, `create-parent-payment-link` v44→v45 deployed to Development from `main` `acf054a7` (17 bundled files each, zero diffs) | Development | PR #552, `TASK-0078` §2c |
| 19 merged `claude/*` branches and the remote `approval-0199` branch deleted; tip SHAs appended to `.git/deleted_branches_2026-10-21.txt` | local + GitHub | PR #553 |
| Seven `archive/*` branches converted to annotated tags of the same name, branches deleted; GitHub now holds one branch, `main` | GitHub | PR #554 |
| Rulings 5 (students may switch to any entitled subject) and 6 (align Development to Production) recorded; drift inventory measured | `TASK-0078` §1, §2d | PR #559 |
| Alignment slice 1: `pg_trgm`; five student-facing RPCs | Development migrations `20261022130854`, `20261022131017` | PR #560 |
| Slice 2: three baseline columns added, eleven Development-only columns dropped, scratch table and stray `review_decisions` policies removed, 20 `app` functions | `20261022131543`, `20261022131920`, `20261022132153` | PR #561 |
| Slice 3: seven Production-only tables, 19 functions, four triggers, the invariants cron, `http` extension, `ci_servable_items_reader` role | `20261022133222`, `20261022133501` | PR #562 |
| Slice 4: constraints, indexes, forced RLS, table grants, function ACLs; one fixture row backfilled separately | `20261022135035` | PR #563 |
| A19 closed: ledgers are history, no re-baseline, `db push` prohibited, parity by catalog digests | `DECISION-0128`, `TASK-0078` ruling 7 | PR #564 |

Behaviour changes on Development, each to what Production and `main` already run: `get_student_progress_dashboard` reports `pointsWithheld`; `enforce_content_items_frq_form`, `prevent_profile_role_change` and `tg_content_pipeline_on_decision` on their Production bodies; seven status/enum checks accept Production's values; the taxonomy stale-label triggers now fire on Development.

## 3. What was verified

- Each alignment migration's local file md5 equals its Development ledger statement md5 (`69e6bcbf`, `0e2e0809`, `1b7870e8`, `dfbc9d12`, `5db8829a`, `1e725a44`, `650c2f88`, `bd58d319`).
- After slice 4, Production and Development digests are equal for: function bodies and configs (173 non-extension functions; one deliberate exception, `app.qa_grade_frq` posts to Development's own `evaluate-attempt`), column sets per table, views (36), policies (148), triggers (75), cron jobs (7), constraints (837), indexes (358), RLS enable/force flags (139 tables), table grants to `anon`/`authenticated`/`service_role`/`ci_servable_items_reader` (1061 rows), and effective function execute privileges (ACLs expanded with `acldefault`).
- Checkout functions on Development: unauthenticated `OPTIONS` 200, empty-body `POST` 400 `invalid_mode`; 9 helper tests pass locally. Neither function has its own test file.
- All seven archive tags verified on GitHub to point at the former branch tips before the branches were deleted.
- `main` at `ee542089` after PR #564; shared checkout clean on `main`; zero open non-Dependabot PRs.

## 4. What remains open (TASK-0078)

- **A16:** one student checkout and one parent payment link on the Development app in Stripe test mode (4242 card), then Production deploy of both checkout functions under an APPROVAL. Verification SQL and the Development baseline counts are in `TASK-0078` §2c. Owner of the checkouts: David or a signed-in tester.
- **A12** `GRADING_ENTITLEMENTS_ENABLED` on Development; **A13** trial-recovery invoker and the 2 undelivered growth events; **A14** shared-module release rule; **A17** retire the hand-drawn pilot upload path; **A18** `get_chosen_distractor_rationale` / `get_graded_choice_feedback` missing on both projects; **A20** anon-executable trigger-function hygiene; **A1** CI follow-through; **A4/A5** source-only under ruling 1 (review functions frozen).
- Development `qa_grade_frq` needs vault secrets `qa_grader_rpc_secret_v1` and `qa_grader_anon_jwt_v1` before it can run (environment config, not copied).
- Four Dependabot PRs for `web/` (#555–#558), David's.
- `~/Documents/Cramapple-trial-impl` worktree (branch merged by #509, only an empty untracked `-` file): the sandbox could not remove it; command in the 2026-10-21 branch-cleanup activity entry.

## 5. Open blockers or risks

- The eight `supabase/migrations/*_task0078_align_*.sql` files are **Development-only**. Seven are no-ops on Production; `20261022133501_task0078_align_prod_only_functions.sql` would overwrite Production's `qa_grade_frq` URL. The `apply_migration`-only rule and `DECISION-0128` prevent this; do not relax them.
- Production's `profiles_active_epv_idx` duplicates `profiles_active_exam_pack_version_idx` (replicated to Development for parity). Hygiene, not a defect.
- Live confirmations only real use gives: first signed-in grade after the A6 deploy; first real add-on purchase; first weekly sweep run (Saturday 06:00 UTC).

## 6. Files changed or checked

Changed: `supabase/migrations/2026102213{0854,1017,1543,1920,2153,3222,3501,5035}_task0078_align_*.sql`; `docs/tasks/TASK-0078-BACKEND-STABILITY-FOLLOW-UPS.md`; `docs/activity_log/ACTIVITY_LOG.md` (three entries); `docs/activity_log/DECISIONS_LOG.md` (`DECISION-0128`); `docs/INDEX.md`; this file. Checked, unchanged: `supabase/functions/create-checkout-session`, `create-parent-payment-link`, `_shared/*`, the review-side functions, `supabase/migrations/20260731160000_schema_baseline.sql`, `20260821080000_progress_dashboard_v1.sql`.

## 7. Commands, queries, tests run

`supabase functions deploy … --project-ref wmgjsdkphcyhngaffbqf --use-api --no-verify-jwt --workdir <repo>` (two functions); `supabase functions download … --use-api` and file-by-file `cmp` against `main` (four bundles: two before, two after); `deno test` on the checkout helper suites (9 pass); `apply_migration` on Development ×9 (one rolled back on "pending trigger events" and was re-applied without its UPDATE); catalog digest queries on both projects (functions, columns, views, policies, triggers, cron, constraints, indexes, RLS, grants, ACLs); `git tag -a` ×7, `git push --tags`, branch deletions; `gh pr merge` for #552–#554, #559–#564. No Production write of any kind.

## 8. Approval state

No APPROVAL number was consumed: nothing was released to Production. Rulings 5, 6 and 7 are recorded in `TASK-0078` §1; ruling 7 is also `DECISION-0128`. Still requiring owner approval: the A16 Production deploy of the two checkout functions after the test-mode checkouts.

## 9. Exact next step for the next session

David (or a tester) completes one student checkout and one parent payment link on the Development app in Stripe test mode. Then the next agent runs the §2c verification SQL, and on a pass deploys `create-checkout-session` and `create-parent-payment-link` to Production from `main`, with bundle diff, boot checks and an APPROVAL file, as for APPROVAL-0200.

## 10. Do not touch next session

- The four review-side functions (`review-decision`, `admin-content`, `assign-for-review`, `reviewer-invite`): frozen by ruling 1.
- The eight `task0078_align_*` migrations: never apply to Production.
- The migration ledgers: no re-baseline (`DECISION-0128`).
- Production `qa_grade_frq`, `grade-frq` and `seed-stimulus-images-2026-07-19`: their retirement is still David's decision (Opus assessment 7).

Restart note: the single best next action is the A16 Stripe test-mode checkouts on Development; everything else on `TASK-0078` waits on an owner decision.
