# TASK-0078 — Backend stability follow-ups from the 2026-10-21 assessments

**Status:** In Progress — A2, A3, A6, A7, A8, A9, A10, A11 live or closed (APPROVAL-0198/0199/0200); ruling 6 schema alignment delivered 2026-10-22 (§2d); A19 closed (DECISION-0128); open: A1 CI follow-through, A4/A5 source only (ruling 1 freeze on review functions), A12–A18, A20
**Tier:** Mixed. Edge-function and Lovable slices are Standard; anything that deploys to Production, adds a cron job or
re-applies a migration is Hard-Gate and needs its own `APPROVAL`.
**Owner:** TBD (Codex executing; Claude sessions reviewing)
**Product Owner:** David Bloom
**Date opened:** 2026-10-21
**Sources:** `docs/qa/REFACTOR_PLAN_REVIEW_2026_10_21.md`; Sonnet's four assessments merged in PR #532
(`DRIFT_REGISTER`, `SWALLOWED_ERROR_AUDIT`, `SCHEDULED_WORK_INVENTORY`, `SHARED_MODULE_DEPENDENCY_MAP`, all
`_2026_10_21.md` in `docs/qa/`); the Fable verification on PR #532.
**Related:** TASK-0063 (subject-switch refusal), TASK-0041 / TASK-0060 (add-on checkout), TASK-0074 (control characters),
TASK-0069 (`attempt-response` replay scoping).

## 1. Owner rulings (2026-10-21, David in chat; durable record, pending a DECISION number if David wants one)

1. **Human review is weeks away and will then use one reviewer per question, not two.** Consequence: the Production-only
   reviewer-qualification code in `assign-for-review` and `reviewer-invite` (commit `ad083b39`, reachable from tag
   `archive/codex-five-subject-20260727`) is **not ported now**. Both Production functions are **frozen**: no redeploy
   from `main`, no port to `main`, until human review is re-planned. The blind two-reviewer pairing that code assumes
   would be redesigned at that point, together with the qualification type it checks (`tutor_content_review`, which no
   Production row carries; the 17 existing rows are type `grading`).
2. **Schedule the learning-session sweep weekly, Saturday 1 am.** Recorded as Eastern time. Draft job in §3.
3. **The post-purchase add-on must be reachable by customers.** Today the page exists, the server returns the offer, and
   nothing shows the link; Production has never recorded an add-on checkout session. Work in §4.
4. **Fail the request when a grade write fails** (David, 2026-10-21, "Yes, fail the request when the grade write fails").
   Applies to A4; acceptance criteria below.
5. **Students may switch to any subject they hold an entitlement for** (David, 2026-10-22). Live behaviour since
   APPROVAL-0198: `public.set_active_exam_pack_version` refuses only unpublished packs; an active session on another
   pack no longer blocks the switch. Entitlement is enforced where it matters (the `attempts_entitled_owner_insert`
   policy and the grading path), and the app's subject picker lists entitled subjects. Recorded as the standing rule
   for any future change to the switch RPC.
6. **Production and Development are to be aligned** (David, 2026-10-22). Direction: Development is brought to
   Production's schema; Production changes only through the normal gated path. Drift inventory in §2d; this is the
   scope for A19 and supersedes "re-baseline or row-by-row repair" as the first question.
7. **A19 closed: the migration ledgers are history, not a source of truth** (David, 2026-10-22, "close A19 on that
   basis"; recorded as DECISION-0128). No re-baseline. `supabase db push` stays prohibited on both projects; every
   change goes through `apply_migration` of a reviewed file, renamed to the recorded version. Parity is verified by
   catalog digests (function bodies, columns, views, policies, triggers, cron, constraints, indexes, RLS flags, grants,
   effective function privileges), never by comparing ledgers. The eight `task0078_align_*` migrations are
   Development-only. Re-baselining becomes its own task only if the migration tooling is ever wanted back, and then
   the 124 Production-only ledger statements are exported to files first.

## 2. Checklist

| # | Item | Tier | State | Notes |
| --- | --- | --- | --- | --- |
| A1 | Extend the Minimal CI Deno allowlist with the `attempt-response`, `evaluate-attempt`, `capture-pairing` tests and the env names they need | Docs/CI | **Source merged in #520**; all 61 inventoried suites gated in two clean-environment permission groups | Haiku's proposed diff is in `qa/TEST_GATE_INVENTORY_2026_10_21.md` (38 files, 760 tests, 60 of 61 pass under `env -i`). Take its narrower option: keep the existing step, add a second step for the few files that need `--allow-net` (`byoq`, `capture-pairing`), `--allow-read` (`email-template-data`, `payer-email`) or unrestricted `--allow-env` (`create-post-purchase-addon/handler_test.ts`, Stripe SDK) |
| A2 | Replay ownership on `session-event` and `storage-sign-url` (actor-scoped lookup, read the audit-insert error, re-sign on replay, handler extraction, tests), no hash changes | Hard-Gate (migration and coordinated Edge release) | **LIVE on Development and Production 2026-10-21 (APPROVAL-0199):** migration applied (Dev `20261021211219`, Prod `20261021211427`), `session-event` v52 and `storage-sign-url` v47 deployed after it, bundles byte-identical to `main`, eight-step RPC replay test passed on both | spec in `REFACTOR_PLAN_REVIEW_2026_10_21.md` §5 |
| A3 | Retire `submit-response` (source directory and the Development function) | Standard | **Source merged in #522**; Development functions `submit-response`, `byoq-smoke-runner`, `byoq-ip-echo` already deleted (Opus verified Development lists 29) | not on Production, no caller |
| A4 | Read the error on the two grade writes in `evaluate-attempt` (`:1884`, `:2627`) and fail the request when the store fails | Standard | **Source merged in #535**; same-key retry writes the saved grade and submitted-attempt truth without regrading; failures surface with no score | Acceptance: both sites destructure `{ error }`; on error, log it and respond 5xx with a stable code (for example `grading_result_write_failed`) and no score in the body; decide and test what a retry with the same idempotency key does next, since today a replay finds the row at `processing` and answers 202, so either mark the row `failed` so the retry re-grades, or make the replay path re-attempt the write; the deterministic MCQ path and the model path both covered; test in `evaluate-attempt/index_test.ts` and add that file to CI (A1) |
| A5 | `review-decision`: replace the empty catch around `advanceWorkflow` with surfaced failures; `admin-content` 10 unread writes; `capture-pairing` cancel | Standard | **Source merged in #536**; note ruling 1 freezes deploys of the review functions, so the review-decision part lands in source only | can wait behind A4; review functions are otherwise frozen (ruling 1) |
| A6 | Redeploy `evaluate-attempt` and `attempt-response` from `main` (Development, verify bundle hash, then Production on approval) | Hard-Gate | **LIVE 2026-10-21 (APPROVAL-0200):** `evaluate-attempt` v82 (`a1336c20…`) and `attempt-response` v43 (`b80d8b32…`) on Production, equal to Development v60/v47, 41 bundled files identical to `main`; 49 local tests green incl. forced grade-store failure. Not done: a signed-in grade after the deploy | makes the TASK-0074 control-character strip live; clears stale `grading-feedback`, `student-memory`, `growth-events`, `math-verifier` |
| A7 | Redeploy `create-post-purchase-addon` from `main` (Development with Stripe test mode, then Production on approval) | Hard-Gate | **LIVE 2026-10-21 (APPROVAL-0200):** `create-post-purchase-addon` v9 (`11071d86…`) on Production, equal to Development v37; ownership check live. Not done: a signed-in Stripe test-mode add-on purchase; the first real add-on in `app.stripe_checkout_sessions` (`purchase_type = post_purchase_addon`) is the live confirmation | prerequisite for §4; Production v8 lacks `ownsAddonSource` (`fce40d1d`) |
| A8 | Lovable: show the add-on offer on the payment-result page | Standard (Lovable, David publishes) | **PUBLISHED 2026-10-21 (David):** marketing project at Lovable commit `db106773`; offer reachable from the payment-result page after a single-subject purchase | publish only after A7 reaches Production. One copy choice to confirm: after code sign-in, "Not now" goes to `/home?subject=…` without `welcome=1` (the prompt asked for the existing non-welcome redirect) |
| A9 | Migration: weekly `sweep_learning_sessions` cron job | Hard-Gate | **LIVE on both projects 2026-10-21 (APPROVAL-0199):** `task0078-sweep-learning-sessions`, `0 6 * * 6` UTC; Dev `20261021211255`, Prod `20261021211454`; first Production run Saturday 06:00 UTC | SQL in §3 |
| A10 | Migration: re-apply the `20260821011843` and `20260821014327` bodies to Production after a Development rehearsal | Hard-Gate | **CLOSED 2026-10-21:** Production applied under APPROVAL-0198 (ledger `20261021210131`) and David confirmed a signed-in subject switch works | removes the subject-switch refusal (TASK-0063); with a weekly sweep this is what keeps an abandoned session from blocking a student for up to a week |
| A11 | Scope `app.submit_response` replay probes to the actor | Hard-Gate | **LIVE on both projects 2026-10-21 (APPROVAL-0199):** `submit_response` now `49d382ff…` on both; Dev `20261021211251`, Prod `20261021211450` | can ride with A10's approval |
| A12 | Set `GRADING_ENTITLEMENTS_ENABLED=true` on Development | Config | open | so rehearsals match Production. From `qa/ENVIRONMENT_PARITY_2026_10_21.md`: also `FRQ_PHOTO_SUBJECTS` (Development only) and `start-trial` missing on Development. The `SERVICE_ROLE_KEY` secret being absent on Development is not a gap: both fallbacks in `byoq/index.ts:289` and `_shared/public-rate-limit.ts:132` try `SUPABASE_SERVICE_ROLE_KEY` first, which Supabase injects into every function |
| A13 | Find who invokes `trial-recovery`; check the 2 undelivered `growth_event_outbox` rows | Read-only | open | |
| A14 | Adopt or trim the shared-module release rule | Docs | open | proposal in `SHARED_MODULE_DEPENDENCY_MAP_2026_10_21.md` §4 |
| A15 | Run the Opus prompt (assessments 2, 7) and the Haiku prompt (5, 6) | Read-only | open | `docs/handoffs/PROMPT_ASSESSMENTS_*` |
| A16 | Helper consolidation, one family per PR; payments pure offer extraction | Standard | **Source merged in #525–#531**, one helper family per PR; Fable parity evidence recorded in each PR body. **Development deployed 2026-10-21** (`create-checkout-session` v48, `create-parent-payment-link` v45, both from `main` `acf054a7`, 17 bundled files each with zero diffs against `main`); the two Stripe test-mode checkouts in §2c remain required before Production release | last; each needs byte-parity evidence in its PR body before merge |
| — | Port `ad083b39` review code; redeploy `assign-for-review`, `reviewer-invite`, `review-decision` | — | **deferred by ruling 1** | revisit when human review is re-planned |
| A17 | Retire the hand-drawn pilot upload path: `/hand-drawn-pilot` route, `storage-sign-url` `sign_upload`/`sign_delete`, the `hand_drawn_pilot` item mode, `public.select_hand_drawn_pilot_items` | Standard + Lovable | open, decide (David) | From `qa/DORMANT_SURFACE_REVIEW_2026_10_21.md`. Verified 2026-10-21: Production's `learning_sessions_entry_path_check` has no `hand_drawn_pilot` value, so the page cannot start a session; `sign_upload` has never been used on Production. QR capture (DECISION-0050/0109) is untouched |
| A18 | Two RPCs the live app calls exist on neither project: `get_chosen_distractor_rationale` (migration `20260828170000`, never applied anywhere) and `get_graded_choice_feedback` | Decide (David) | open | Verified absent on Production and Development. The caller in `use-session.ts:901` swallows the error, so students see no rationale rather than an error. Either apply the migration (after confirming the flow is live) or delete the calls |
| A19 | Align Development to Production (ruling 6), then ledger strategy | Standard, Development first | **closed 2026-10-22**: schema alignment delivered (§2d, eight Development-only migrations); ledger strategy decided by ruling 7 / DECISION-0128 (ledgers are history; no re-baseline; `db push` prohibited; parity by catalog digests). Development's ledger carries the 8 `task0078_align_*` rows Production must never receive; Production keeps its 124 rows whose SQL no local file holds | `qa/MIGRATION_LEDGER_RECONCILIATION_2026_10_21.md`: Production 2 listed-not-effective, 124 rows with SQL no local file holds, 32 with no SQL, 94 local files live with no row; `db push` or `migration repair` against Production is unsafe until decided. Also decide the two never-applied files (`20260827120000`, `20260828170000`, see A18) |
| A20 | Hygiene: 11 `SECURITY DEFINER` functions in `app` are executable by `anon` on Production | Standard migration | open, low risk | Verified 2026-10-21: all 11 are trigger functions (`handle_new_user`, `tg_*`, `guard_*`, `response_versions_guard_submission`, `rollup_pre_submit_hint_count`, `servable_items_census`, `set_assistance_event_derived_fields`, `refuse_attempt_on_teaching_item`); none is in `public`, so PostgREST cannot call them, and trigger functions cannot be invoked directly. Revoke `anon`/`authenticated` execute for hygiene; not urgent |

## 2b. State after the Codex merges (Fable, 2026-10-21, late): deploy gates

All Codex PRs are merged (record: PR #545); `main` CI is green on Minimal CI and both SQL fixture workflows. Verified
after merge: the #535 review gap is closed (recovery now projects the recovered grade onto `app.attempts`, fenced on
`status = 'submitted'`, and returns `503 attempt_grade_store_failed` if that projection fails); the duplicate TASK-0078
record is gone; the `submit-response` source directory is gone. Nothing new is deployed, and no new migration is applied
anywhere except the TASK-0063 reconciliation on Development (`20261021202904`). Gates that now exist:

| Gate | Before deploying | Why |
| --- | --- | --- |
| `session-event`, `storage-sign-url` to any project | **discharged 2026-10-21 (APPROVAL-0199):** the replay-claims migration is applied on both projects and both functions are deployed after it | any future redeploy of these two needs no further gate; dropping the claims table would break them |
| `evaluate-attempt`, `attempt-response` to Production (A6) | **discharged 2026-10-21 (APPROVAL-0200)** on the strength of the 49-test local rehearsal; a signed-in grade after the deploy remains the live confirmation | #535 changed the grade-store path |
| `create-checkout-session`, `create-parent-payment-link` to Production | **Development is on the `main` build since 2026-10-21 (v48/v45)**; still owed: one student and one parent checkout on Development in Stripe test mode (§2c) | #531 touched the offer and promotion lookup |
| `review-decision`, `admin-content`, `assign-for-review`, `reviewer-invite` | ruling 1: frozen | human review re-planned later |
| `app.submit_response` scoping (A11) | **discharged 2026-10-21 (APPROVAL-0199)** | both projects on `49d382ff…` |
| Production session RPC apply (A10) | **discharged 2026-10-21 (APPROVAL-0198)** | one signed-in subject switch by an affected account or David remains the live confirmation |

The TASK-0063 file was renamed to Development's recorded `20261021202904` in PR #544 (its fixture path repaired in #547); the two TASK-0078 migrations and the sweep file follow in PR #549.

## 2c. A16 checkout gate on Development (Fable, 2026-10-21)

Deployed from `main` `acf054a7` with `--no-verify-jwt` (both functions already ran with `verify_jwt=false`):
`create-checkout-session` v47 → v48, `create-parent-payment-link` v44 → v45. Before the deploy, Development and
Production ran byte-identical bundles that predated #528–#531 (`index.ts`, `_shared/cors.ts`, `public-rate-limit.ts`,
`stripe.ts`, `supabase.ts` all differed from `main`). After it, every bundled file equals `main`. Local checks: 9 tests
pass (`_shared/checkout-offer_test.ts`, `_shared/public-rate-limit_test.ts`; neither function has its own test file);
unauthenticated `OPTIONS` 200 and empty-body `POST` 400 `invalid_mode` on both.

Still owed before Production (gate in §2b), run by David or a tester against the Development app with Stripe test mode:

1. One student checkout (single subject, Stripe test card `4242 4242 4242 4242`) completed to the success page.
2. One parent payment link created and paid the same way.

Baseline on Development before the deploy (2026-10-21), so success is a delta, not an absolute count:
`stripe_checkout_session_attempts` 2 (latest 2026-09-28), `stripe_checkout_sessions` 29 (latest 2026-10-19 21:07 UTC),
`parent_payment_links` 10 (latest 2026-10-20 23:32 UTC), `stripe_customers` 4.

Verification after the two checkouts (Development, service role):

```sql
select id, payment_status, payload->'metadata'->>'purchase_type' as purchase_type, created_at
from app.stripe_checkout_sessions where created_at > '2026-10-21 21:00+00' order by created_at;
select code, status, created_at, paid_at from app.parent_payment_links
where created_at > '2026-10-21 21:00+00' order by created_at;
select * from app.stripe_checkout_session_attempts where created_at > '2026-10-21 21:00+00';
```

Pass = one new `stripe_checkout_sessions` row at `paid` with `purchase_type = student_direct`, one new
`parent_payment_links` row that reaches `paid`, and no new `stripe_checkout_session_attempts` error rows. Then the
Production deploy follows the A6/A7 pattern (deploy from `main`, bundle diff, boot checks, APPROVAL file).

## 2d. Production ↔ Development schema drift (Fable, 2026-10-22, read-only; scope for ruling 6 / A19)

Measured from `pg_proc`, `information_schema`, `pg_policies`, `cron.job` on both projects (schemas `app`, `public`).
Views are identical (36). Everything below is Production-only unless marked.

| Bucket | Count | What | Suggested disposition |
| --- | --- | --- | --- |
| `pg_trgm` extension functions in `public` | 37 | `similarity`, `gtrgm_*`, `gin_*trgm*`, `set_limit`, `show_limit`, `show_trgm` | **closed 2026-10-22**: `20261022130854_task0078_align_pg_trgm.sql` applied to Development (pg_trgm 1.6 in `public`, same as Production) |
| Gold-set reader workflow | 4 tables, 2 `app` fns, 2 seeders, 5 `public` RPCs, 1 trigger fn | `gold_set_answers`, `gold_set_elements`, `gold_set_element_marks`, `gold_set_verification_assignments`; `gold_set_access`, `gold_set_admin_overview`, `gold_set_verification_next`, `gold_set_verification_progress`, `submit_gold_set_verification` | **closed 2026-10-22** (`20261022133222_task0078_align_prod_only_tables.sql`, `20261022133501_task0078_align_prod_only_functions.sql`): tables rebuilt from Production's catalogs with constraints, indexes, comments, forced RLS and grants; functions, the marks-immutable trigger and Production's ACLs applied |
| Taxonomy stale-label triggers | 3 fns | `mark_content_taxonomy_labels_stale_*` | **closed 2026-10-22**: functions plus the three triggers on `content_item_versions`, `frq_criteria`, `mcq_choices` |
| QA / census helpers | 6 fns | `qa_grade_frq`, `verify_qa_grader_token`, `servable_items_census`, `servable_items_census_selftest`, `taxonomy_scope_selftest`, `seed_taxonomy_units` | **closed 2026-10-22** with one deliberate deviation: Development's `qa_grade_frq` posts to Development's own `evaluate-attempt`, not Production's; its two vault secrets (`qa_grader_rpc_secret_v1`, `qa_grader_anon_jwt_v1`) are environment config, not copied, so it raises `QA bridge secrets are not configured` until they exist. Also installed: `http` 1.6 in `extensions` and the `ci_servable_items_reader` login role (no password) that Production carries |
| Other Production-only objects | 3 tables, 1 fn, 1 cron, 4 policies | `content_item_difficulty`, `content_taxonomy_validation_decisions`, `public.question_reports`; `public._epv_is_selectable`; cron `content-review-invariants`; their policies | **closed 2026-10-22** in the same two migrations, including the `content_taxonomy_labels → content_taxonomy_validation_decisions` FK Production carries and the daily `content-review-invariants` cron job |
| Development-only | 1 table, 2 policies | `public.scc_rehearsal_chunks_20261006` (rehearsal scratch); `review_decisions_insert_own`/`_select_own` where Production has `deny_authenticated_all` | **closed 2026-10-22**: `20261022131920_task0078_align_dev_only_objects.sql` dropped the scratch table (6 rows, no dependents) and set `review_decisions` to Production's single deny policy and service_role-only grants |
| Shared functions whose body or config differs | 25 | student-facing: `public.start_home_learning_session_for_user` (wrapper; the `app` body matches after APPROVAL-0198), `complete_learning_session`, `get_open_hand_item`, `get_student_progress_dashboard`, `select_student_practice_items`; plus 20 `app` internals (`check_content_review_invariants`, `claim_capture_pairing_upload`, `complete_model_usage`, `reserve_model_usage`, `enforce_content_items_frq_form`, `enforce_session_target_home_eligibility`, `home_exam_pack_is_eligible`, `invoke_trial_worker`, `prevent_profile_role_change`, `prevent_review_decision_mutation`, `progress_estimated_ap_score`, `progress_status_token`, `reserve_artifact_version_sequence`, `response_versions_guard_reserved_parts`, `revalidate_session_target_before_consumption`, `select_confirm_transfer_item`, `set_content_taxonomy_label_derived_fields`, `tg_content_pipeline_on_decision`, `tg_require_practice_format_at_publish`, `trial_record_attempt`) | **student-facing five closed 2026-10-22**: whitespace-normalised diff showed four identical and `get_student_progress_dashboard` lagging on Development (Production and `main`'s `20260821080000` null `pointsEarned` and add `pointsWithheld` for uncertain grades; Development's ledger rows `20260821153550`/`153751` predate that text). `20261022131017_task0078_align_student_rpcs.sql` applied Production's live text for all five to Development; all five `md5(prosrc)` now equal Production. **The 20 `app` internals closed 2026-10-22**: 17 differed only in whitespace or comments; 3 in substance (`enforce_content_items_frq_form` harness-plan branch, `prevent_profile_role_change` missing `current_user` guard, `tg_content_pipeline_on_decision` early single-score version) and on all three `main`'s baseline agrees with Production. `20261022132153_task0078_align_app_functions.sql` applied Production's text; 20 of 20 `md5(prosrc)` now equal Production |
| Shared tables whose columns differ | 5 | `app.profiles`, `app.content_review_decisions`, `app.review_decisions`, `app.validation_runs`, `app.validation_suites` | **closed 2026-10-22**: `20261022131543_task0078_align_shared_table_columns.sql` added the three baseline columns Development lacked (`profiles.notification_email`, `content_review_decisions.tutor_decision`/`difficulty_action`, with Production's checks and comment) and dropped the eleven Development-only columns on three empty tables; all five column-set hashes now equal Production |

**State after slice 4 (2026-10-22, ruling 6 delivered):** Development's schema equals Production's on every measured
axis: function bodies and configs (one deliberate exception, `qa_grade_frq` posts to Development's own URL), table
column sets, views, policies, triggers, cron jobs, constraints (837), indexes (358), RLS enable/force flags, table
grants to `anon`/`authenticated`/`service_role`/`ci_servable_items_reader` (1061 rows), and effective function
execute privileges (173 functions, compared after expanding default ACLs). Slice 4
(`20261022135035_task0078_align_constraints_indexes_grants.sql`) brought seven check constraints up to Production's
accepted values, added Production's four non-empty checks on `frq_criteria`/`mcq_choices` (after backfilling one
2026-06-22 smoke-test fixture row, done as a separate statement because the slice-3 stale-label trigger leaves pending
events that block a same-transaction ALTER), dropped one Development-only constraint and two indexes, added four
Production-only indexes, forced RLS on five tables, fixed three table grants, and set sixteen function ACLs.

**Standing rule from this work:** the eight `task0078_align_*` migration files are Development-only. Each is a no-op
on Production except `20261022133501_task0078_align_prod_only_functions.sql`, which would overwrite Production's
`qa_grade_frq` with the Development URL. They must never be `db push`ed or `apply_migration`ed to Production; the
existing rule (Production changes only through `apply_migration` of a reviewed file under an APPROVAL) already
prevents that, and A19 now records it explicitly.

Not aligned by design: data (Development keeps its own rows), vault secrets (`qa_grader_*`), edge-function secrets,
and the migration ledgers themselves (A19).

Method for the apply: one migration file per bucket, written from Production's live definitions (`pg_get_functiondef`,
`pg_get_viewdef`, `information_schema`), applied to Development with `apply_migration`, file renamed to the recorded
version (TASK-0077 convention), ledger row added. Production receives nothing from this work except where a bucket's
review shows Development is the newer side, and then only through an APPROVAL. Ledger strategy (A19) is decided
afterwards against the aligned state.

## 2a. Codex PR review (Fable, 2026-10-21): merge order and conditions

Reviews are posted on each PR. Code PRs are David's to merge. Evidence: diffs read in full; `deno check` and every touched
test run in throwaway worktrees at each PR head; Production and Development queried read-only where a claim depended on
live state.

| Order | PR | Row | Verdict | Condition before merge |
| --- | --- | --- | --- | --- |
| 1 | #524 | A10 | ready (Hard-Gate) | apply the single file with `apply_migration`/`execute_sql`, never `db push`; verify `md5(prosrc)` = `dbc35186…`/`5a71a24d…`; one real subject switch |
| 2 | #520 | A1 | ready | merge before every other code PR; all of them edit `minimal-ci.yml` |
| 3 | #535 | A4 | one gap | recovery stores the grade but never updates `app.attempts` (status/score), which `get_student_progress_dashboard` counts; run the attempt update in recovery or record the manual reconciliation |
| 4 | #523 | A11 | ready (Hard-Gate) | same apply-method rule as #524 |
| 5 | #521 | A2 | ready, re-tiered | now Hard-Gate: claims table + two RPCs; migration before both function deploys on each project (functions return 503 without it); pending claims never expire, so the packet needs a named reconciliation query; fold `TASK-0078-CAUTIOUS-BACKEND-REFACTOR.md` into this record |
| 6 | #522 | A3 | rebase | keep only the A3 cell edit of this file |
| 7 | #536 | A5 | rebase | conflicts with `main`; `review-decision` part lands in source only under ruling 1 |
| 8–11 | #525, #526, #527, #528 | A16 | pure extractions | stack cut before #520's CI rewrite; rebase onto current `replay-hardening`, re-place three one-line CI inserts; #527 needs no CI change; expect a source conflict with #536 on `admin-content`, `capture-pairing`, `review-decision` |
| 12–14 | #529, #530, #531 | A16 | pure extractions | stacked on #528; #531 must split its four doc edits (INDEX row conflicts with `main`; second TASK-0078 record) into a docs PR, and needs one student and one parent Development checkout in Stripe test mode before any Production deploy |

Merge follow-through: this table preserves Fable’s original review conditions. The current checklist above owns status. The older scope/authorization record is now a [historical handoff](../handoffs/TASK0078_REFACTOR_SCOPE_SNAPSHOT_2026_10_21.md), with no competing task state. Current integration evidence and remaining gates are in the [source integration handoff](../handoffs/TASK0078_REFACTOR_EXECUTION_2026_10_21.md).

## 3. Weekly session sweep (A9): draft migration

`pg_cron` on both projects runs in UTC. Saturday 01:00 Eastern is 05:00 UTC in summer and 06:00 UTC in winter; the job
below uses 06:00 UTC, which is 01:00 EST and 02:00 EDT, so it is overnight all year without a timezone dependency.

```sql
begin;

-- TASK-0078 A9: weekly reaper for learning sessions whose declared budget plus
-- grace has elapsed. app.sweep_learning_sessions(integer) exists since
-- 20260821050000 and has had no invoker. Saturday 06:00 UTC = 01:00 EST / 02:00 EDT.
select cron.schedule(
  'task0078-sweep-learning-sessions',
  '0 6 * * 6',
  'select app.sweep_learning_sessions(120);'
);

comment on function app.sweep_learning_sessions(integer) is
  'Archives learning sessions whose available_minutes budget plus a grace window has elapsed. Scheduled weekly by pg_cron (task0078-sweep-learning-sessions, Saturday 06:00 UTC) since 2026-10. Counterpart to app.sweep_session_targets().';

commit;
```

Rehearse on Development: apply, confirm `select jobname, schedule, active from cron.job`, run
`select app.sweep_learning_sessions(120);` once by hand and check the returned `archived` count, then Production on
approval. Rollback: `select cron.unschedule('task0078-sweep-learning-sessions');`. Note for the approval: while
Production still runs the July body of `set_active_exam_pack_version`, a student who abandons a session is blocked from
switching subjects until the next Saturday; A10 removes that refusal and should be approved in the same batch or the
schedule should be daily until it is.

## 4. Make the add-on reachable (A7 then A8)

**What exists (Verified 2026-10-21).** Marketing project `61dd6602`: `src/routes/checkout.add-on.tsx` is a complete page
that calls `createPostPurchaseAddon` and pays through Stripe Elements; `src/lib/payment-status.ts` already has
`eligibleOffer(server)` which validates the server's offer; `get-checkout-status` returns
`offer = {id: "bundle_2_upgrade", title, description, price_label: "$30.00", url: <APP_BASE_URL>/checkout/add-on?session_id=…}`
for a paid, entitled, single-subject, student-paid purchase when more subjects exist. `src/components/checkout/PaymentResult.tsx`
never calls `eligibleOffer` and, for a signed-in student, redirects to the app home the moment the payment is unlocked.
Production `get-checkout-status` and `stripe-webhook` are byte-identical to `main`; `create-post-purchase-addon` on
Production is the 2026-10-02 build without the ownership check.

**Order.** A7 first (backend), then A8 (Lovable), then David publishes. Do not publish the link while Production runs the
old add-on build.

**A7 steps.** `supabase functions deploy create-post-purchase-addon --project-ref wmgjsdkphcyhngaffbqf --no-verify-jwt
--use-api --workdir <repo root>`; on Development with Stripe test mode, create a single-subject purchase, open
`/checkout/add-on?session_id=<id>`, pay with a test card, confirm the webhook grants the second subject and that a second
signed-in user calling the function with the first user's session id gets `403 addon_not_available`. Then the same deploy
to Production under an `APPROVAL`, with the bundle hash recorded on both projects.

**A8: Lovable prompt (send to project `61dd6602-6991-4561-b418-e988bb7c8a0b`; David publishes).**

> In `src/components/checkout/PaymentResult.tsx`, surface the post-purchase add-on offer that the server already
> returns. Use the existing `eligibleOffer(server)` from `src/lib/payment-status.ts`; do not add fields, prices or new
> API calls, and do not change `src/routes/checkout.add-on.tsx`.
>
> Behaviour for `role === "student"` when `view === "unlocked"` and `eligibleOffer(server)` is non-null: do not
> auto-redirect to the app. Show the "Welcome to Cramapple" heading, then an offer block with the offer's `title`,
> `description` and a primary button labelled `Add another subject — ${price_label}` that navigates to the offer's
> `url` (it is same-site, `/checkout/add-on?session_id=…`), and a quiet link `Not now, go to my subjects` that performs
> the existing redirect to `subjectPath(false)`. If the student is not yet signed in, keep the existing `CodeSignIn`
> flow and show the offer block after sign-in succeeds, before redirecting. Fire `captureCheckout("addon_offer_viewed",
> { offer: offer.id })` once when the block renders. When `eligibleOffer` is null, behaviour is unchanged. The parent
> view is unchanged.
>
> Tests: extend the existing checkout tests so that (1) a paid single-subject student response with a valid offer
> renders the offer block and does not redirect, (2) the "Not now" link redirects, (3) a bundle purchase, a parent
> purchase, a $0 order and a missing or malformed offer all render exactly what they render today, (4) the offer link
> href equals the server URL unchanged. Run the full test suite and type check. Do not publish.

After Lovable reports done, review the real diff by commit SHA (not the plan commit), then David publishes.

## 5. Evidence for this record

- Session close 2026-10-22 (alignment, A16 Development deploy, branch cleanup): `handoffs/SESSION_CLOSE_2026_10_22_TASK0078_ALIGNMENT_AND_CLEANUP.md`.

- Reviewer qualification: Production `assign-for-review` bundle lines 106-164 (download 2026-10-21); Production
  `select qualification_type, status, count(*) from app.validator_qualifications group by 1,2` = `grading/active 16`,
  `grading/suspended 1`; last-30-day assignments: 1,959 rows, all `owner_remediation_approval`, one creator.
- Sweep: `cron.job` on Production has 6 jobs, none calling `sweep_learning_sessions`; 1 session `active` since
  2026-09-23; existing pattern `cron.schedule('task0019-sweep-session-targets', '17 3 * * *', …)` in
  `20260731170700_harden_server_issued_session_targets.sql`.
- Add-on: Production `select payload->'metadata'->>'purchase_type', payment_status, count(*) from
  app.stripe_checkout_sessions group by 1,2` shows `student_direct`, `parent_share` and null only, never
  `post_purchase_addon`; marketing files read 2026-10-21 at HEAD: `PaymentResult.tsx`, `checkout.add-on.tsx`,
  `checkout.success.tsx`, `purchase-api.ts`, `payment-status.ts`, `purchase-offer.ts`.
