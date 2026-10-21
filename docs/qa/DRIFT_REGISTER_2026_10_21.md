# Deployed-versus-source drift register (Assessment 1)

**Verdict: Production drifts from `main` in a small, nameable set of places, and in two of them Production is ahead of `main`.** Edge functions: 19 of 29 Production bundles are byte-identical to `main` (`index.ts` and every bundled `_shared` file). `attempt-response` has an identical `index.ts` but three older `_shared` files; `storage-sign-url` bundles two older `_shared` files; `evaluate-attempt`, `admin-content`, `review-decision` and `create-post-purchase-addon` differ because `main` has moved on (mostly commits from today); two functions have no source directory (`grade-frq`, `seed-stimulus-images-2026-07-19`); and **`assign-for-review` and `reviewer-invite` on Production contain code that `main` does not have** (for example a reviewer-qualification check in `assign-for-review`). That code exists only in commit `ad083b39` (2026-07-14), which is on no branch and is not an ancestor of `main`. Database functions: 28 same-named functions have different bodies on Production and Development, 19 functions exist only on Production, and none exist only on Development. For the migration-defined ones I could parse, Production usually matches the latest migration and Development often matches none, so Development, not Production, is the odd one out; the two known cases where Production runs the July bodies under an August ledger (F6) reproduce, and Production's ledger also lacks `20260821080000`, `20260826120000` and `20260928023843`.

**Status:** read-only assessment, proposals only; I executed no disposition. **Date:** 2026-10-21. **Author:** Claude (Sonnet 5.5).
**Reviewed against:** Cramapple `main` at `df39cd09` (the branch `claude/assessments-1-3-4-8-2026-10-21` was cut from it); Production `pcntajvbdfqhbeewmdry`; Development `wmgjsdkphcyhngaffbqf`.
**Evidence convention:** **Verified** = downloaded from the function store and diffed, or returned by a read-only query quoted in the appendix. **Inferred** = a conclusion from verified facts. **Not verified** = not demonstrated.

## 1. Edge functions

Metadata from the Supabase MCP `list_edge_functions`. Bundles from `supabase functions download <slug> --project-ref <ref> --use-api` into a scratch directory, compared with `cmp`/`diff` against `supabase/functions/<slug>/index.ts` and each bundled `_shared/*.ts`. "Bundle vs `main`" lists only files that differ. Dispositions are proposals.

### 1.1 Production (29 functions)

| Slug | Version | Updated | verify_jwt | `ezbr_sha256` | Source dir? | Bundle vs `main` | Proposed disposition |
| --- | --- | --- | --- | --- | --- | --- | --- |
| `admin-content` | v43 | 2026-07-11 | true | `93ebdf02` | yes | index differs (35 lines); shared differ: supabase.ts | redeploy from main (decide: behaviour-neutral cleanup 2026-10-21, `f6230286`) |
| `assign-for-review` | v39 | 2026-07-12 | true | `26ba4111` | yes | index differs (63 lines); shared differ: http, cors, supabase, auth | decide (David): Production is AHEAD of main (note 1) |
| `attempt-response` | v42 | 2026-10-10 | false | `a8cb95c7` | yes | index identical; shared differ: student-memory, grading-feedback, growth-events | redeploy from main |
| `byoq` | v19 | 2026-10-17 | false | `cff01858` | yes | identical | keep |
| `cancel-trial` | v2 | 2026-10-21 | false | `86dc75e1` | yes | identical | keep |
| `capture-pairing` | v17 | 2026-10-10 | false | `47944b63` | yes | identical | keep |
| `charge-due-trials` | v2 | 2026-10-21 | false | `930374ce` | yes | identical | keep |
| `create-checkout-session` | v33 | 2026-10-21 | false | `9e99a6cc` | yes | identical | keep |
| `create-parent-payment-link` | v11 | 2026-10-21 | false | `4c745456` | yes | identical | keep |
| `create-post-purchase-addon` | v8 | 2026-10-02 | false | `fc503329` | yes | index differs (152 lines); shared differ: stripe, addon-checkout | redeploy from main (payments; note 4) |
| `deliver-transactional-email` | v3 | 2026-10-21 | false | `83ad2026` | yes | identical | keep |
| `evaluate-attempt` | v81 | 2026-10-10 | false | `6e91564f` | yes | index differs (7 lines); shared differ: student-memory, grading-feedback, math-verifier, growth-events | redeploy from main (decide David) |
| `get-checkout-status` | v13 | 2026-10-21 | false | `052ff87a` | yes | identical | keep |
| `get-trial-status` | v2 | 2026-10-21 | true | `f749063b` | yes | identical | keep |
| `grade-frq` | v38 | 2026-07-10 | true | `20994a16` | no | no source | retire or decide (David): no source directory |
| `more-help` | v8 | 2026-10-17 | true | `45a197cd` | yes | identical | keep |
| `report-question` | v5 | 2026-10-13 | true | `a5c6f8ba` | yes | identical | keep |
| `resolve-parent-link` | v9 | 2026-10-21 | false | `4ecfcb66` | yes | identical | keep |
| `review-decision` | v49 | 2026-08-13 | true | `32bc35e7` | yes | index differs (53 lines); shared identical | redeploy from main (PR #518, `9b7b31a5`, merged to main today, not deployed) |
| `review-queue` | v56 | 2026-08-02 | true | `bde105b9` | yes | identical | keep |
| `reviewer-invite` | v36 | 2026-07-12 | true | `00ce59d7` | yes | index differs (104 lines); shared differ: http, cors, supabase, auth | decide (David): Production is AHEAD of main (note 1) |
| `seed-stimulus-images-2026-07-19` | v31 | 2026-07-19 | true | `fa0f06ee` | no | no source | retire or decide (David): one-off seeding function with no source |
| `send-parent-payment-email` | v13 | 2026-10-21 | false | `5133aafa` | yes | identical | keep |
| `session-event` | v51 | 2026-08-03 | true | `f0d8b1a8` | yes | identical | keep |
| `start-trial` | v21 | 2026-10-21 | false | `d2b6e0e3` | yes | identical | keep |
| `storage-sign-url` | v46 | 2026-09-23 | true | `058eadf6` | yes | index identical; shared differ: cors.ts, supabase.ts | keep (see note 3) |
| `stripe-webhook` | v33 | 2026-10-21 | false | `95b91119` | yes | identical | keep |
| `student-session-items` | v44 | 2026-10-16 | true | `65b0b33b` | yes | identical | keep |
| `trial-recovery` | v2 | 2026-10-21 | false | `8d8a3a01` | yes | identical | keep |

### 1.2 Development (32 functions)

| Slug | Version | Updated | verify_jwt | `ezbr_sha256` | Source dir? | Bundle vs `main` | Proposed disposition |
| --- | --- | --- | --- | --- | --- | --- | --- |
| `admin-content` | v41 | 2026-06-22 | true | `5ebe07e8` | yes | index differs (64 lines); shared differ: cors, supabase, auth | redeploy from main |
| `assign-for-review` | v37 | 2026-07-14 | true | `f442fc61` | yes | index differs (61 lines) | decide (David): differs from Production and from main |
| `attempt-response` | v46 | 2026-10-10 | false | `a8cb95c7` | yes | index identical; shared differ: student-memory, grading-feedback, growth-events | redeploy from main |
| `byoq` | v37 | 2026-10-10 | false | `44eb3650` | yes | index differs (3 lines); shared differ: byoq.ts | redeploy from main |
| `byoq-ip-echo` | v29 | 2026-09-28 | true | `aee234a1` | no | no source | retire (diagnostic scaffold; decide) |
| `byoq-smoke-runner` | v30 | 2026-09-28 | true | `d759d09e` | no | no source | retire (smoke-test scaffold; decide) |
| `cancel-trial` | v12 | 2026-10-20 | false | `86dc75e1` | yes | identical | keep |
| `capture-pairing` | v34 | 2026-10-09 | false | `47944b63` | yes | identical | keep |
| `charge-due-trials` | v12 | 2026-10-20 | false | `930374ce` | yes | identical | keep |
| `create-checkout-session` | v47 | 2026-10-20 | false | `9e99a6cc` | yes | identical | keep |
| `create-parent-payment-link` | v44 | 2026-10-20 | false | `4c745456` | yes | identical | keep |
| `create-post-purchase-addon` | v35 | 2026-09-29 | false | `fc503329` | yes | index differs (152 lines); shared differ: stripe, addon-checkout | redeploy from main |
| `deliver-transactional-email` | v30 | 2026-10-20 | false | `83ad2026` | yes | identical | keep |
| `evaluate-attempt` | v59 | 2026-10-10 | false | `6e91564f` | yes | index differs (7 lines); shared differ: student-memory, grading-feedback, math-verifier, growth-events | redeploy from main |
| `get-checkout-status` | v42 | 2026-10-20 | false | `052ff87a` | yes | identical | keep |
| `get-trial-status` | v10 | 2026-10-20 | true | `f749063b` | yes | identical | keep |
| `grade-frq` | v38 | 2026-06-25 | true | `74ceab19` | no | no source | decide (David) |
| `more-help` | v29 | 2026-10-17 | true | `45a197cd` | yes | identical | keep |
| `open-hand-item` | v30 | 2026-09-27 | true | `4e59bd2c` | no | no source | decide (David) |
| `report-question` | v10 | 2026-10-13 | true | `a7803cff` | yes | index differs (6 lines) | redeploy from main |
| `resolve-parent-link` | v22 | 2026-10-18 | false | `4ecfcb66` | yes | identical | keep |
| `review-decision` | v38 | 2026-07-21 | true | `c7094d8f` | yes | index differs (280 lines); shared differ: cors, supabase | redeploy from main |
| `review-queue` | v37 | 2026-07-14 | true | `72c40b8c` | yes | index differs (397 lines) | redeploy from main or retire; differs from Production |
| `reviewer-invite` | v37 | 2026-07-14 | true | `760572eb` | yes | index differs (102 lines) | decide (David) |
| `send-auth-email` | v22 | 2026-10-07 | false | `a348a2e2` | yes | identical | keep |
| `send-parent-payment-email` | v36 | 2026-10-19 | false | `5133aafa` | yes | identical | keep |
| `session-event` | v40 | 2026-06-22 | true | `—` | yes | not downloadable (legacy build) | redeploy from main (or retire) |
| `storage-sign-url` | v43 | 2026-09-23 | true | `058eadf6` | yes | index identical; shared differ: cors, supabase | keep |
| `stripe-webhook` | v55 | 2026-10-20 | false | `95b91119` | yes | identical | keep |
| `student-session-items` | v45 | 2026-10-16 | true | `65b0b33b` | yes | identical | keep |
| `submit-response` | v40 | 2026-06-22 | true | `—` | yes | not downloadable (legacy build) | retire (REFACTOR_PLAN_REVIEW slice 3) |
| `trial-recovery` | v10 | 2026-10-20 | false | `8d8a3a01` | yes | identical | keep |

**Notes**

1. **Production is ahead of `main` for `assign-for-review` and `reviewer-invite` (Verified for the first, Inferred for the second).** The Production `assign-for-review` selects `content_item_id`, resolves the content's exam pack, and checks both reviewers are qualified for it (`diff` lines 76 and 106-164); `main` has none of that. `git log --all -S"exam_pack_not_found"` and `-S"validator_qualifications"` over `supabase/functions` find it only in `ad083b39`, which is not an ancestor of `origin/main` and is on no branch. Development's copies differ from both Production and `main`. The reviewer-invite bundle diff is 104 lines against `main`; I did not read it. This is drift in the dangerous direction (deployed code with no committed source on `main`), though it concerns the reviewer portal, not students.
2. **Dev `session-event` and `submit-response` returned `expected multipart response, got application/octet-stream`** (legacy build format), recorded as "not downloadable"; I did not retry. This reproduces the known result.
3. **`storage-sign-url`:** bytes of `cors.ts` and `supabase.ts` are older than `main` on both projects, although `git log --since=2026-08-01` on those two files returns nothing; so the bundled copies date from a deploy before August. Whether the difference is functional is **Not verified**.
4. **`create-post-purchase-addon`:** v8 on Production, updated 2026-10-02, never touched since; `main`'s last source change is `fce40d1d` (2026-10-06, "require verified ownership before add-on customer reuse"). Production lacks that fix. Whether any customer path reaches this function is **Not verified**.
5. **Known results reproduced (Verified):** Production `session-event`, `storage-sign-url`, `attempt-response` `index.ts` are byte-identical to `main`; Production `attempt-response` bundles older `growth-events.ts` and `grading-feedback.ts` (and `student-memory.ts`, since `f6230286` on 2026-10-21); Development `session-event` and `submit-response` are legacy builds; `submit-response`, `content-intake` and `send-auth-email` are not on Production.
6. **Source directories on neither project:** `content-intake` (exists on neither; the review doc says it is outside this plan's scope). Functions on one project only: Development has `submit-response`, `open-hand-item`, `byoq-smoke-runner`, `byoq-ip-echo`, `send-auth-email`; Production has `seed-stimulus-images-2026-07-19`. The three trial/email functions are on both.
7. **Why many `index.ts` differ today:** `f6230286` (2026-10-21, "Remove dead code from edge functions and web/") touched `evaluate-attempt`, `admin-content`, `_shared/student-memory.ts` and `_shared/math-verifier.ts`, and `9b7b31a5` (PR #518) changed `review-decision` the same day. Whether either is behaviour-neutral is **Not verified**.
8. **Environment secret differences recorded by the REFACTOR_PLAN_REVIEW (not re-checked here):** `GRADING_ENTITLEMENTS_ENABLED` set on Production only; `FRQ_PHOTO_SUBJECTS` set on Development only.

## 2. Database functions, Production against Development

Counts (both projects, `app` and `public`): 130 + 72 = 202 on Production and 117 + 35 = 152 on Development. 28 of the Production functions belong to the `pg_trgm` extension (installed on Production only) and are excluded below; 171 − 152 = 19 are Production-only. For each function I compared `md5(prosrc)`, `prosecdef` and `md5(proacl::text)` prefixes (full query in the appendix).

**Same name, different `md5(prosrc)` (28):** `app.check_content_review_invariants`, `claim_capture_pairing_upload`, `complete_model_usage`, `enforce_content_items_frq_form`, `enforce_session_target_home_eligibility`, `home_exam_pack_is_eligible`, `invoke_trial_worker`, `prevent_profile_role_change`, `prevent_review_decision_mutation`, `progress_estimated_ap_score`, `progress_status_token`, `reserve_artifact_version_sequence`, `reserve_model_usage`, `response_versions_guard_reserved_parts`, `revalidate_session_target_before_consumption`, `select_confirm_transfer_item`, `set_content_taxonomy_label_derived_fields`, `start_home_learning_session_for_user`, `submit_response`, `tg_content_pipeline_on_decision`, `tg_require_practice_format_at_publish`, `trial_record_attempt`; `public.complete_learning_session`, `get_open_hand_item`, `get_student_progress_dashboard`, `select_student_practice_items`, `set_active_exam_pack_version`, `start_home_learning_session_for_user` (`submit_response`'s bodies differ in comments and whitespace only per the REFACTOR_PLAN_REVIEW; I did not re-diff it). **Same body, different ACL hash (privileges):** `app.content_item_is_published`, `app.tg_content_pipeline_guard_publish`, `public.content_review_invariant_report`, `public.select_practice_frqs`, `public.select_unit_gated_practice_items`.

**Production-only (19):** `app.gold_set_marks_are_immutable`, `gold_set_reader_is_eligible`, `mark_content_taxonomy_labels_stale_for_version`, `…_from_child_trigger`, `…_from_version_trigger`, `qa_grade_frq`, `seed_gold_set_elements_single_point`, `seed_gold_set_verification_assignments`, `seed_taxonomy_units`, `servable_items_census`, `servable_items_census_selftest`, `taxonomy_scope_selftest`, `verify_qa_grader_token`; `public._epv_is_selectable`, `gold_set_access`, `gold_set_admin_overview`, `gold_set_verification_next`, `gold_set_verification_progress`, `submit_gold_set_verification`. **Development-only:** none found (a Development function absent from Production would appear as a name missing from the Production list; I found none by reading both lists).

## 3. Which of Production, Development and the latest migration agree

For each differing function that a `create or replace function` in `supabase/migrations/*.sql` defines, a script extracted the `$$ … $$` body of every definition, took its `md5`, and compared with each environment's `md5(prosrc)` (script in the appendix). Parsing limits: only `create or replace function <schema>.<name>(` followed by a dollar-quoted body is recognised, so functions defined another way show `None`.

| Function | Latest migration defining it | Production matches | Development matches | Reading |
| --- | --- | --- | --- | --- |
| `app.start_home_learning_session_for_user` | `20260821014327` | an older definition (July) | the latest | **Production runs the 07-31 body; ledger lists `20260821014327`** (known) |
| `public.set_active_exam_pack_version` | `20260821011843` | an older definition | the latest | **Production runs an older body; ledger lists `20260821011843`** (known) |
| `public.start_home_learning_session_for_user` | `20260731171000` | the latest (07-31) | none (`6f3ce2e3`) | Development differs from every migration |
| `public.complete_learning_session` | `20260731171000` | the latest | none | Production current; Development differs from all migrations |
| `app.enforce_session_target_home_eligibility`, `app.revalidate_session_target_before_consumption` | `20260731171100` | the latest | none | Same pattern |
| `app.home_exam_pack_is_eligible` | `20260731171200` (fix) | the latest | none | Same pattern |
| `app.check_content_review_invariants` | `20260822190000` | the latest | none | Development differs |
| `app.claim_capture_pairing_upload`, `app.response_versions_guard_reserved_parts`, `app.tg_require_practice_format_at_publish` | `20261009231314`, `20261009233521`, `20261009230917` | the latest | none | Development differs from every migration (likely hand-applied variants; **Inferred**) |
| `app.progress_estimated_ap_score`, `app.progress_status_token` | `20260821080000` | **none** | the latest | **Production does not match `progress_dashboard_v1`; the migration version `20260821080000` is not in Production's ledger** |
| `public.get_student_progress_dashboard` | `20260821080000` | **none** (`5c72430a`) | none (`f0e25b5b`) | Neither environment matches the migration text; Not verified why (a later hand edit, or a definition form my parser misses) |
| `app.select_confirm_transfer_item` | `20260826120000` | none | none (`647b01af` vs migration `cdf97735`) | Neither matches; the version `20260826120000` is in Development's ledger but not Production's |
| `public.get_open_hand_item` | `20260928023843` | none | none | The version is in Development's ledger and not Production's |
| `public.select_student_practice_items` | `20261008113000` | none | none | The version is in both ledgers; neither body matches the migration text |
| `app.set_content_taxonomy_label_derived_fields`, `public.set_active_exam_pack_version`, `app.start_home_learning_session_for_user` | several definitions | an older one | the latest | Production behind Development |
| `app.invoke_trial_worker`, `app.trial_record_attempt` | `20261018191935`, `20261018191924` | none parsed | none parsed | Bodies not recoverable by my parser (the migration uses a different form); the versions are in Development's ledger and **not** in Production's, though Production's trial cron jobs work. Production's ledger probably carries a different version stamp (`apply_migration` drift in the memory index), **Inferred** |
| `app.enforce_content_items_frq_form`, `prevent_profile_role_change`, `prevent_review_decision_mutation` | `20260822160000` (security advisor hardening) | none parsed | none parsed | Not recoverable by my parser |
| `app.complete_model_usage`, `reserve_artifact_version_sequence`, `reserve_model_usage`, `tg_content_pipeline_on_decision`, `submit_response`, `app.progress_status_token` (Prod side) | no `create or replace` found | n/a | n/a | Defined by the schema baseline or by a form not recognised; `submit_response` is described in the REFACTOR_PLAN_REVIEW |

**What this adds to the REFACTOR_PLAN_REVIEW.** F6 named two Production functions that hold 2026-07-31 bodies while the ledger lists the 2026-08-21 migrations; both reproduce (first two rows). I found no *additional* Production function that the ledger says was updated but that still holds an older parsed body. The broader pattern is the reverse: for roughly a dozen functions Development matches no migration (rows marked "none"), which is consistent with the standing warning that Development's ledger and bodies cannot be trusted. Separately, Production's ledger is missing three migrations that Development lists or that exist on `main` (`20260821080000`, `20260826120000`, `20260928023843`), and the Production bodies of the functions those define do not match them.

Ledger totals (Verified): Production 358 versions, latest `20261021010547`; Development 192 versions, latest `20261020235937`. Ledger rows present on Production: `20260731171000`, `…171100`, `…171200`, `20260821011843`, `20260821014327`, `20260821050000`, `20261008113000`, `20261009230917`, `20261009231314`. Present on Development and **absent from Production**: `20260826120000`, `20260928023843`, `20261018191924`, `20261018191935`. Absent from both: `20260821080000`.

## 4. Proposed dispositions (summary)

| Disposition | Items |
| --- | --- |
| keep | 19 identical Production functions, plus `storage-sign-url` pending the `cors.ts`/`supabase.ts` question |
| redeploy from main | Production: `attempt-response`, `evaluate-attempt`, `admin-content`, `review-decision`, `create-post-purchase-addon`. Development: the same plus `byoq`, `report-question`, `session-event`, `review-queue`, `reviewer-invite` (Development bundles that differ from `main`) |
| re-apply migration | Production: `20260821011843` and `20260821014327` bodies (already identified; needs a Development rehearsal and a Hard-Gate approval); investigate `20260821080000` (progress dashboard) separately |
| retire | Development `submit-response` (and its source directory), `byoq-smoke-runner`, `byoq-ip-echo` |
| decide (David) | `assign-for-review` and `reviewer-invite` (Production ahead of `main`), `grade-frq`, `seed-stimulus-images-2026-07-19`, `open-hand-item`, and whether Development should be rebuilt from migrations rather than patched |

## 5. Questions for David

1. `assign-for-review` / `reviewer-invite`: is the Production behaviour (reviewer-qualification check) the intended one? If so, the source should be committed from `ad083b39` through a reviewed PR, and `main` should not redeploy over Production until it is.
2. Should the progress-dashboard migration `20260821080000` (and `20260826120000`, `20260928023843`) be treated as unapplied on Production? A student-facing progress surface may depend on `get_student_progress_dashboard`; I did not test it.
3. Do you want Development rebuilt from the migrations (a clean reconstruction) since about a dozen of its function bodies match no migration?
4. Is `create-post-purchase-addon` reachable by customers? If so, the missing 10-06 ownership fix is a payments item.

## 6. Appendix: commands and queries

```text
git fetch; git rev-parse --short origin/main            -> df39cd09
git checkout -b claude/assessments-1-3-4-8-2026-10-21 origin/main
mcp list_edge_functions (both projects)                  # version, updated_at, verify_jwt, ezbr_sha256
mkdir -p <scratch>/<env>/w_<slug>
supabase functions download <slug> --project-ref <ref> --workdir <scratch>/<env>/w_<slug> --use-api
   # --use-api avoids Docker (not installed); the workdir must exist
cmp / diff of <bundle>/supabase/functions/<slug>/index.ts against supabase/functions/<slug>/index.ts
cmp of each bundled _shared/*.ts against supabase/functions/_shared/<file>
```

```sql
-- both projects (function inventory; Production list compared to the Development list by name, md5(prosrc), prosecdef, ACL hash)
select n.nspname||'.'||p.proname||'('||left(md5(pg_get_function_identity_arguments(p.oid)),6)||')'||'|'||left(md5(p.prosrc),8)||'|'||p.prosecdef::int||'|'||left(md5(coalesce(p.proacl::text,'')),4)
from pg_proc p join pg_namespace n on n.oid=p.pronamespace
where n.nspname in ('app','public') order by 1;
-- Development: the pg_trgm names (gin_*, gtrgm_*, *similarity*, set_limit, show_limit, show_trgm) excluded; the Production count with the same exclusion is 171.
-- ledger
select version, name from supabase_migrations.schema_migrations where version in ('20260821080000','20260731171000','20260731171100','20260731171200','20261008113000','20260928023843','20260826120000','20260821011843','20260821014327','20260821050000','20261009230917','20261009231314','20261018191924','20261018191935') order by version;
select count(*) total, max(version) latest from supabase_migrations.schema_migrations;
```

Migration cross-check: a small script (`mig.py`, scratchpad) loops over the differing names, extracts every `create or replace function <schema>.<name>(… ) … as $tag$ BODY $tag$` from `supabase/migrations/*.sql` in filename order, and compares `md5(BODY)[:8]` with each environment's `md5(prosrc)[:8]`. Limits: other definition forms are not recognised, and a function with the same name in a later `create or replace` that uses a non-dollar-quoted body would be missed. The raw per-function printout is in the session scratchpad and was not committed.

`git log --all --oneline -S"exam_pack_not_found" -- supabase/functions/assign-for-review`; `git log --all --oneline -S"validator_qualifications" -- supabase/functions`; `git merge-base --is-ancestor ad083b39 origin/main` (exit non-zero: not in `main`); `git branch -a --contains ad083b39` (no branch).
