# Paywall sample: Production release plan (DRAFT, 2026-11-09)

**Status:** DRAFT. **The authoritative Production record is `docs/activity_log/APPROVAL-0207_PAYWALL_SAMPLE_PHASE3_PRODUCTION_RELEASE_2026_11_09.md`** (owned by the backend session). Step A (dark apply: migrations `20261109155919`, `20261109155941`; functions `sample-try` v1, `attempt-response` v45, `student-session-items` v47; switches off; verified dark) was approved and executed on 2026-11-09. **Step B (activation) is not approved.** This document is the app/docs-side view and must follow 0207 if they differ.
**Tier:** Hard-Gate. **Backend facts** come from `PAYWALL_BACKEND_DESIGN_SPEC_2026_11_08.md` and its QA records; backend execution facts are taken from `APPROVAL-0207` §6.

## 1. Preconditions (all must be true before requesting Step 1)

| # | Precondition | State on 2026-11-09 |
| --- | --- | --- |
| P-1 | Owner decisions N2–N5, N12 answered (N1 settled by P6) (`PAYWALL_PRODUCT_OWNER_DECISIONS_2026_11_09.md`) | Open |
| P-2 | Backend independent QA passed, including the two round-2 fixes | Round 2 reported both reproduced-fixed (migration `20261109131921`); a final pass on the as-released migration set is still needed |
| P-3 | App fixes (ap-prep-blueprint PR #48, successor to merged #47) pass independent Codex QA (static, then Development walk) | Round 1 and round 2 done: shape, claim-refusal and focus fixes verified; two misleading claim outcomes fixed after round 2, not yet re-verified. Development walk with a real sign-in not run |
| P-4 | Development end-to-end walk passed (anonymous try, claim, replay, second account, grace, expiry, read-only) | **Partly done (author smoke, 2026-11-09, `docs/qa/PAYWALL_APP_DEV_SMOKE_2026_11_09.md`)**: anonymous try, claim, replay and readback verified; one real response-shape bug found and fixed. Not run: browser sign-in walk, questions 2–8, FRQ and grading, grace, expiry. Independent run still required |
| P-5 | Remaining app work built and QA'd for the chosen scope: Cramapple FRQ path (new `session_start` session, `practice_format:'targeted_drill'`), questions 2 to 8 via `student-session-items`, `sample_photo_check_failed` retry handling, analytics if N8 approved. Photo answer and transcript confirmation are required **only if** N12 chooses option (a); `APPROVAL-0207` §3 item 8 allows a typed-answer first activation (option b) | `sample_photo_check_failed` done; FRQ path, later questions and analytics not built |
| P-6 | Minors' data review done (N4) | Open |
| P-7 | Dev and Prod schema/function parity checked on release day: Dev has lagged main before (`feedback_dev_lags_main_check_before_building`), and the Supabase CLI resolves to **Production** when run from the home directory (`feedback_supabase_cli_home_dir_links_prod`) | Must be rechecked |
| P-8 | Per-unit availability re-audited against Production on release day (the Phase 0 table is a snapshot) | Snapshot only |
| P-8b | **Sample serving works through the app's unit-gated path in Production**: claim sets (or serving derives) the course position for the grant unit; Physics 2 and Physics C E&M units do not error; availability counts equal what serving can deliver (Calc AB U1 is short); the imported session's format does not starve the queue. See smoke record, round 3 | **Open, backend decision**; found 2026-11-09 |
| P-9 | Rollback rehearsed in Development (levels 1 and 2, spec §9) | Not run |

## 2. Ordered release steps (each is a separate approval request)

| Step | Action | Environment | Reversible by |
| --- | --- | --- | --- |
| R1 | **DONE 2026-11-09 (0207 step A).** Apply the sample migrations (`20261108201632_…`, `20261109131921_…`) and confirm `app.config` switches are **false**. (execution record: `APPROVAL-0207` §6) | Production | Down script (spec §9 level 3); data is empty while flags are off |
| R2 | **DONE 2026-11-09 (0207 step A).** Deploy edge functions `sample-try`, `attempt-response`, `student-session-items` with `SAMPLE_ACCESS_ENABLED=false`. Versions deployed: `sample-try` v1, `attempt-response` v45, `student-session-items` v47 (`APPROVAL-0207` §6); no new secret was needed. | Production | Redeploy prior versions |
| R3 | **Verified dark by the backend session on 2026-11-09; a normal day of traffic is still required (0207 §3 item 7).** Verify the **dark** state: `sample-try` returns `503 sample_disabled`; existing signed-in practice, trial and checkout behave exactly as before (regression pass on `get_study_subject_keys`, session items, attempt creation, grading access) | Production, read-only calls | n/a |
| R4 | Lovable publish of the app with `VITE_SAMPLE_JOURNEY` still off: confirm `/sample` is a 404 | Production | Lovable rollback |
| R5 | Marketing link or redirect to the app's `/sample` (N2 decided: the app runs the anonymous question), still pointing nowhere live | Production | Lovable rollback |
| R6 | Enable for an **approved test population only**: admin/own account first, then a named small group. Both switches (`app.config` and edge env) plus the app flag. **Not** public ad traffic. | Production | Spec §9 levels 1–2, in under a minute |
| R7 | Watch window: grants, claims, refusals by code, grading and extraction spend, error rates; compare with rollback criteria below | Production | n/a |
| R8 | Widen, tune or revert (separate owner decision; the experiment is N6) | Production | per level |

## 3. Rollback criteria (propose; David to confirm)

Go to level 1 (stop admissions) if any: a sample student can reach full-access content after expiry; a grant is created without its first answer saved; an anonymous response exposes `is_correct`/rationale before an answer; grading or extraction spend exceeds the per-sample caps; any existing paying or trial student loses access; claim errors for more than a handful of students are not typed `sample:*` codes. Go to level 2 for any data-exposure issue.

## 4. What this release deliberately does not do

No change to the seven-day card trial (`DECISION-0126`), BYOQ's identity-agnostic policy, entitlement tiers, email sending, or PostHog Production schema. Nurture emails (D7) and the experiment (D6) are separate approvals.

## 5. Approval requests to draft once preconditions pass

One `APPROVAL-xxxx` per step R1–R6 (check open PRs for number collisions first), each naming the exact commands, the environment, the verification afterwards and the rollback. Do not batch Production migration, deploy and flag enablement into one approval.
