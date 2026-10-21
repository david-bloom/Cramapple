# Dormant-surface review (Assessment 7, 2026-10-21)

**Verdict: seven operations that student-facing functions accept are sent by no live screen, and about a dozen live-app routes are reachable only by typing a URL. Two of those dormant paths are broken in Production, and nobody noticed because nobody uses them.**

- **Broken path 1: the admin-only `/hand-drawn-pilot` page.** It starts its session with `entry_path: "hand_drawn_pilot"`, a value Production's `learning_sessions_entry_path_check` constraint rejects. So the pilot cannot reach the `storage-sign-url` `sign_upload` mode behind it, which has never been used on Production.
- **Broken path 2: two RPCs the live app calls do not exist on Production.** They are `get_chosen_distractor_rationale` and `get_graded_choice_feedback`. Both calls fail silently, and both sit in flows that signed-in students are redirected away from.

**What I would retire first:** the hand-drawn pilot upload path (route, `sign_upload` and `sign_delete` modes, the `hand_drawn_pilot` item mode and its selector RPC). It is the only code path that signs uploads into learner storage outside the mandated QR capture flow, it has zero recorded uses, it cannot work in Production, and it sits on a function whose replay lookup is unscoped (REFACTOR_PLAN_REVIEW F1).

**Already in flight (do not redo):** `submit-response` retirement is in PR #522. That PR has already deleted `submit-response`, `byoq-smoke-runner` and `byoq-ip-echo` from Development: Development now lists 29 functions and none of the three (Verified). The source deletion is still unmerged.

**What a decision keeps alive despite the evidence:** the confirm-transfer chain, which `DECISION-0075` D11 keeps as a component, and the `web/` prototype, which D6 names as the in-repo rebuild target. In both cases the decision and the usage disagree. I leave them to David.

**Status:** read-only assessment; proposals only. Nothing was changed in either Supabase project, in Lovable or in the repository beyond this document.
**Date:** 2026-10-21. **Author:** Claude (Opus 5.5), with a read-only code-search subagent for the operation and route inventory (its citations were spot-checked).
**Reviewed against:** Cramapple `main` `c4896e9e`; live app `david-bloom/ap-prep-blueprint` `main` at `4f71acb` (exported read-only; the local clone `.worktrees/cramapple-app` sits on an older branch at `e73445d`); Production `pcntajvbdfqhbeewmdry`; Development `wmgjsdkphcyhngaffbqf`. The published Lovable bundle was not read, so reachability is from source, not from what is deployed.
**Settled inputs (TASK-0078 §1):** ruling 1 freezes `assign-for-review` and `reviewer-invite` and does not port `ad083b39` (reachable from tag `archive/codex-five-subject-20260727`); ruling 2 sets the weekly sweep; ruling 3 makes the add-on reachable; ruling 4 fails a request when the grade write fails. None of these is re-opened here.
**Evidence convention:** **Verified** = read at the pinned commit, or returned by a read-only query in the appendix. **Inferred** = concluded from verified facts. **Not verified** = not demonstrated.

---

## 1. Candidate table

Abbreviations: **B** = backend repo, **A** = live app repo. "Last Production use" is from `app.audit_events`, table rows or function metadata; every number is Production unless named.

| # | Candidate | What it does | Last Production use | Live-app reachability | Decision that keeps it | Cost of keeping | Proposal |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | **Hand-drawn pilot upload path.** A `/hand-drawn-pilot`; B `storage-sign-url` modes `sign_upload` and `sign_delete`; B `student-session-items` mode `hand_drawn_pilot`; `public.select_hand_drawn_pilot_items` | Admin page that starts a session, signs an upload into `learner-uploads` and attaches a photo | `sign_upload`: **0 audit rows ever**; `sign_delete` never sent by any client; `learning_sessions` has **no** `hand_drawn_pilot` rows; `response_attachments` 0 rows | Route exists (`A routes/hand-drawn-pilot.tsx:16`), no inbound link, client-side admin check only (`:87-99`). It sends `entry_path: "hand_drawn_pilot"` (`:115`), which **Production's `learning_sessions_entry_path_check` does not allow** (7 values, Verified), so session start fails before any upload (Inferred from constraint + `B session-event/index.ts:337` insert) | None. TASK-0038's pilot frontend was stranded; hand-drawn answers on every FRQ go through capture-pairing (`DECISION-0109`/TASK-0069) | An unused signed-upload surface on a function with an unscoped replay lookup (REFACTOR F1) and a swallowed audit error (F2); no tests; an extra student-item mode | **Retire.** Delete the route in A; remove `sign_upload`/`sign_delete` from `storage-sign-url` (keep `sign_download`, see #2); remove the `hand_drawn_pilot` mode from `student-session-items`; drop `public.select_hand_drawn_pilot_items` in a migration. Rollback: restore from git and redeploy |
| 2 | `storage-sign-url` `sign_download` | Signs reviewer and admin downloads | 55 rows, all by `tutor`-role accounts, last **2026-08-13** | A `use-signed-asset-url.ts:32-36` (reviewer routes), `admin.grade-response.$attemptId.tsx:141` | Reviewer portal is live per INDEX (rebuild §10); review functions frozen by ruling 1 | Shares F1/F2 with #1 | **Keep** (frozen with review); include in TASK-0078 A2 |
| 3 | `session-event` authoritative Home start (`entry_path='recommend'`, MCQ or no format) and `public.start_home_learning_session_for_user` wrapper → `app.start_home_learning_session_for_user` | Server-issued Home session with idempotent start key | 13 audit rows marked authoritative, **2026-08-14 to 2026-08-26** (7 by an admin, 6 by accounts with no profile row); 22 `recommend` sessions, last **2026-07-29**; 0 sessions carry a start key | `"recommend"` is sent only by `A _ux.setup.index.tsx:184`, `_ux.session.mcq.tsx:113,261` and `_ux.session.frq.tsx:334` via `A src/lib/use-grade-practice.ts:182`. All three sit behind `RetiredRouteGate`, which sends signed-in users to `/home` (`A components/auth/RetiredRouteGate.tsx:11-23`, Verified). Live `/question` sends `topic`/`self_guided_*` | None (D14 retires the legacy routes) | Production runs the July body under an August ledger (reconciliation F1). Reviews keep re-deriving it. PR #524 would re-apply its body although nothing calls it | **Retire after A10.** Remove the branch at `B session-event/index.ts:262-273`, drop `public.start_home_learning_session_for_user` and `app.start_home_learning_session_for_user` in one migration once PR #524 has landed (or drop `start_home` from #524 and re-apply only `set_active_exam_pack_version`). Rollback: re-create from `20260821014327` |
| 4 | `session-event` `attach_anonymous_session` | Returns 501 `unsupported` before any lookup (`B :210-221`) | never sent by any client | none | none | dead branch in an untested function | **Retire** (remove from the allowed set at `B :12-18`) |
| 5 | `session-event` `session_save` | Rewrites the row's own `status` to bump `updated_at` and writes an audit row (`B :431-468`) | 45 rows, 44 in the last 30 days, **all by one admin account** | A `lib/parked-sessions.ts:104`, `runtime-context-store.tsx:184` | none | low; untested | **Cover** with the handler test planned in TASK-0078 A2 (same-actor replay; no-op save) |
| 6 | `submit-response` | Legacy submit endpoint | **not deployed to Production**; Development copy deleted by PR #522 (absent from today's Development list, Verified) | no app caller; `B scripts/open_hand_e2e_dev.mjs:108` still calls it | none | confusion in reviews (REFACTOR F4) | **Retire: confirmed.** Merge PR #522 and update or delete `scripts/open_hand_e2e_dev.mjs` |
| 7 | `content-intake` | Source-only intake function | on **neither** project (DRIFT_REGISTER note 6) | no app caller; only `B prototypes/ux-002/index.html:1626` | none | dead source | **Retire** the source directory (and the prototype reference) |
| 8 | `send-auth-email` | Supabase auth-email hook sending through Loops | Development only (v22, identical to `main`) | not an app call; an auth hook | `docs/product/LOOPS_TRANSACTIONAL_EMAIL_MIGRATION_2026_10_06.md` plans it; TASK-0077 runbook: "Do **not** deploy or enable `send-auth-email`" on Production yet | no tests; absent from `supabase/config.toml` | **Keep (planned).** Cover with tests before it is enabled |
| 9 | `grade-frq` (Production v38, 2026-07-10; Development v38, 2026-06-25), `seed-stimulus-images-2026-07-19` (Production only) | Pre-rebuild grader; one-off image seeding | No invocations in the last 24 hours of Production function logs. Older use not verified (log retention). No source directory | no caller in A or B (tracked non-docs search) | none | deployed code with no source on `main` (the dangerous drift direction) | **Retire** after downloading each bundle into an archive (`supabase functions download … --use-api`). Production deletion is a Hard-Gate step |
| 10 | `open-hand-item` (Development only, no source) | Pre-`DECISION-0086` Open Hand key function | n/a (Development) | none; the app's `fetchOpenHandKey` (`A lib/open-hand/client.ts:90-100`) calls the RPC `get_open_hand_item` and is itself imported by nothing | `DECISION-0086` keeps the **RPC** `public.get_open_hand_item`, not this function | stray Development endpoint | **Retire** the Development function. Remove `fetchOpenHandKey` in A. Keep the RPC |
| 11 | Confirm-transfer chain: `evaluate-attempt` `grade_transfer_attempt`, `student-session-items` `confirm_transfer`, `app.select_confirm_transfer_item`, A `ConfirmTransferBeat` | Course-mode "transfer" check after a learn sequence | 3 `grading_results` with `operation='grade_transfer_attempt'`, **all by one admin**, last **2026-08-28** | Rendered only inside `SessionFrame` (`A SessionFrame.tsx:995`) on `/session`, which is retired except `/session?intent=learn&skill=…` (`A lib/retired-routes.ts:30`). Nothing in A builds that URL (search for `intent=`, `skill=`), so it is reachable by deep link only | **`DECISION-0075` D11: "Generalize `ConfirmTransferBeat`'s trigger"** keeps the component | an operation and a selector kept alive with no path. The selector depends on the `20261006005950` rewrite (reconciliation F5) | **Decision and evidence disagree: David.** Either schedule the D11 generalisation (then **cover**: `evaluate-attempt` transfer test, `confirm_transfer` mode test), or amend D11 and retire the chain |
| 12 | `evaluate-attempt` `select_repair`, `grade_revision` | Course-mode repair and revision grading | no `grading_results` rows for either | accepted (`B evaluate-attempt/index.ts:192-197`), never sent; types only in A `runtime-context.ts:74-75` | none (D1 retires Course Mode as a mode) | untested branches in the grading function | **Retire** (remove from the allowed set) |
| 13 | `/ask` "Ask for help" (AP Statistics Unit 1 pilot), with calls to `homework-classify` and `homework-followup`, and `get_graded_choice_feedback` via `GradedResponseCard` | Outside-question help flow | the two edge functions do not exist on either project; `get_graded_choice_feedback` is defined by no migration and absent on Production | Route has no inbound link and no gate (`A routes/ask.tsx`; only `__root.tsx:23` lists it as a feedback prefix); `classify.ts:106-115` falls back to a mock | none (`more-help` is the live help surface) | a reachable-by-URL page that calls three missing backends | **Retire** in A |
| 14 | `get_chosen_distractor_rationale` and `get_graded_choice_feedback` calls in `A hooks/use-session.ts:901` and `lib/homework-help/graded-feedback.ts:53` | Post-grade feedback for the legacy `/session` flow | functions **absent on Production** (`20260828170000` never applied; no migration defines the second) | `/session` flow only (retired, see #11) and `/ask` (#13). The live `/question` flow uses `get_graded_mcq_feedback` | `TASK-0053` is met by `get_graded_mcq_feedback` | silent failures; misleads reviews into thinking the feedback ships | **Retire** with #11/#13, and archive `20260828170000` (reconciliation R5) |
| 15 | Legacy `RetiredRouteGate` routes: `/session/mcq`, `/session/frq`, `/session/uncertain`, `/setup`, `/setup/subject`, `/topic`, `/open-hand-frq`, `_ux.home` | Pre-rebuild flows | (client-side) | signed-in students are redirected to `/home`; **signed-out visitors still see the pages** (`RetiredRouteGate.tsx:21-23`) | D14 decides the retirement; **O10 (scope) is open** | dead UI that still issues `recommend` starts and legacy reads | **Retire in one pass** (recommendation for O10) |
| 16 | Legacy reads: `/resume`, `/plan`, `/attempt/$id` via `A lib/progress-queries.ts:29,39` (`from("sessions")`, `from("attempts")`); tables `public.sessions` (0 rows), `public.student_attempts` (0), `public.questions` (0), `public.student_lock_queue` (0) | Pre-rebuild progress pages and tables | tables empty | no gate; inbound links only from each other and `__root.tsx:23` | none | RLS policies and grants on four empty tables | **Retire** the routes and tables (`public.exam_specs`, 1 row, is still read by `A lib/subjects-catalog.ts:1` and stays). Whether these pages are reachable from navigation is Not verified beyond the link search |
| 17 | `public.question_reports` (0 rows), `public.grade_disputes` (0 rows) | Report and dispute writes from `SessionFrame` (`A use-session.ts:1201`, `ReportQuestionButton.tsx`) | 0 rows each | `/session` flow only | none; question reports moved to `app.question_issue_reports` (`report-question`, live) | two empty public tables reachable by insert | **Retire** with #11 |
| 18 | `web/` prototype | In-repo three-pane prototype (`B web/README.md:1-5`) | not deployed: no workflow, Vercel or Netlify config references it | none | **D6: "In-repo rebuild target is `web/`"** | Dependabot noise; three prototype defects (REFACTOR F10) | **Decision and evidence disagree: David.** Keep while D6 stands, or retire `web/` and its Dependabot entry if the Lovable app is the target |
| 19 | `exam-buddy-wireframe` reviewer-portal holdover | Legacy front end kept for reviewer routes | Not verified (separate repository, not read) | reviewer routes also exist in the live app (`A reviewer.review.$assignmentId.tsx`, `reviewer.gold-set.verify.tsx`) | INDEX: "Still live — NOT legacy" (rebuild §10); session start: "retained only for the reviewer/admin portal until it is rehomed" | possible duplicate reviewer UI | **Keep (frozen with review, ruling 1).** Question for David: is it still deployed now that the app carries reviewer routes? |
| — | Not candidates: `capture-pairing` (QR capture mandated by `DECISION-0050`/`0109`; 1 token ever, 0 attachments, `FRQ_PHOTO_SUBJECTS` unset on Production); `byoq` `purge` (retention job); review functions (frozen, ruling 1) | | | | | | `capture-pairing`: **cover** (its tests exist but are not in CI, TASK-0078 A1) |

**Operations accepted but never sent by the live app** (source inventory; full table from the subagent pass, spot-checked):
- `session-event`: `attach_anonymous_session`.
- `storage-sign-url`: `sign_delete` (and `sign_upload` from the pilot only).
- `evaluate-attempt`: `select_repair`, `grade_revision`.
- `student-session-items`: mode `hand_drawn_pilot`.
- `byoq`: `purge` (operator only).

Every operation of `attempt-response` and `capture-pairing` is sent.

**Functions the live app never calls:**
- marketing or server-side, as expected: `get-checkout-status`, `create-checkout-session`, `create-post-purchase-addon`, `start-trial`, `resolve-parent-link`, `create-parent-payment-link`, `send-parent-payment-email`, `charge-due-trials`, `deliver-transactional-email`, `stripe-webhook`, `send-auth-email`;
- admin tooling: `admin-content`;
- dormant: `submit-response`, `content-intake`.

The app calls two edge functions that exist on neither project: `homework-classify` and `homework-followup` (#13).

---

## 2. Retire now (ordered by risk removed per hour of work)

| Order | What | Work | Gate | Why this order |
| --- | --- | --- | --- | --- |
| 1 | **Hand-drawn pilot upload path (#1)** | ~2 h: app route delete; two mode removals in `storage-sign-url`; one mode removal in `student-session-items`; one `drop function` migration | Standard for code; Hard-Gate for the Production redeploys and the migration | Removes the only non-QR signed-upload path into learner storage, which is broken in Production anyway. Ride with TASK-0078 A2, which already touches `storage-sign-url` |
| 2 | `attach_anonymous_session` (#4), `select_repair`/`grade_revision` (#12) | ~30 min | Standard (redeploys Hard-Gate) | Shrinks untested input surface in two student-facing functions; fold into the A2 and A4 PRs that already redeploy them |
| 3 | `submit-response` (#6) | merge PR #522; fix `scripts/open_hand_e2e_dev.mjs` | Standard | Already done in Development |
| 4 | `/ask`, `homework-help`, the missing-RPC calls (#13, #14) | ~1 h in Lovable | Standard (Lovable, David publishes) | Removes a URL-reachable page that calls three missing backends |
| 5 | `content-intake` source, `open-hand-item` Development function, app `fetchOpenHandKey` (#7, #10) | ~30 min | Standard; Development delete | Cleanup; nothing calls them |
| 6 | `grade-frq` and `seed-stimulus-images-2026-07-19` on Production (#9) | ~30 min after archiving the bundles | Hard-Gate (Production function deletion) | Deployed code with no source |
| 7 | Authoritative Home start (#3) | ~1 h + migration | Hard-Gate | Depends on the A10/PR #524 decision |
| 8 | Legacy routes, reads and tables (#15–#17) | ~2–3 h | Standard (Lovable) + Hard-Gate (drop tables) | Needs the O10 scope call |

**Rollback for every row:** restore the deleted files from git and redeploy the previous bundle (record each function's `ezbr_sha256` before deleting). For dropped database objects, re-create them from the migration that defined them (named in each row). Download any no-source function's bundle before deleting it.

---

## 3. Questions for David

1. Retire the hand-drawn pilot upload path (#1) as part of TASK-0078 A2?
2. D11 versus the evidence (#11): schedule the confirm-transfer generalisation, or amend D11 and retire the chain?
3. D6 versus the evidence (#18): is `web/` still the rebuild target?
4. O10: retire all legacy `RetiredRouteGate` routes and the `/resume`/`/plan`/`/attempt` pages in one pass (#15, #16)?
5. Authoritative Home start (#3): after PR #524, retire it, or re-apply only `set_active_exam_pack_version` and drop the start function now?
6. Is `exam-buddy-wireframe` still deployed (#19)?
7. Delete `grade-frq` and `seed-stimulus-images-2026-07-19` from Production after archiving their bundles (#9)?

---

## Appendix. Evidence

**Production queries (read-only, `pcntajvbdfqhbeewmdry`):**
- `select reason_code, count(*), count(distinct actor_id), max(occurred_at)::date, count(*) filter (where occurred_at > now()-interval '30 days'), count(distinct actor_id) filter (where occurred_at > now()-interval '30 days') from app.audit_events group by 1 order by 2 desc` →

  | reason_code | rows (all time) | last | rows (30 days) |
  | --- | ---: | --- | ---: |
  | `session_start` | 276 | 2026-10-20 | 150 |
  | `session_resume` | 230 | 2026-10-20 | 200 |
  | `session_end` | 122 | 2026-10-20 | 104 |
  | `create_attempt` | 114 | 2026-10-17 | 40 |
  | `save_response` | 90 | 2026-10-17 | 33 |
  | `submit_response` | 88 | 2026-10-17 | 32 |
  | `sign_download` | 55 | 2026-08-13 | 0 |
  | `session_save` | 45 | 2026-10-17 | 44 |
  | `mint_pairing` | 3 | 2026-08-22 | 0 |
  | `bulk_import` | 1 | 2026-07-11 | 0 |

  No `sign_upload`, `sign_delete` or `attach_anonymous_session` rows.
- Authoritative starts: `select reason_code, count(*), min(occurred_at), max(occurred_at) from app.audit_events where coalesce(metadata::text,'')||coalesce(payload::text,'') ilike '%authoritative%' group by 1` → `session_start` 13, 2026-08-14 to 2026-08-26.
- `select entry_path, practice_format, count(*), max(created_at) from app.learning_sessions group by 1,2` → `recommend` 22, last 2026-07-29; no `hand_drawn_pilot`.
- `select pg_get_constraintdef(oid) from pg_constraint where conname='learning_sessions_entry_path_check'` → `recommend`, `topic`, `check_work`, `bring_question`, `recommendation`, `self_guided_topic`, `self_guided_format`.
- `select operation, count(*), max(created_at) from app.grading_results group by 1` → `grade_initial_attempt` 105 (last 2026-10-17); `grade_transfer_attempt` 3 (last 2026-08-28).
- Row counts:
  - `capture_pairing_tokens` 1 (2026-08-21)
  - `response_attachments` 0
  - `byoq_items` 36 (2026-10-18)
  - `open_hand_scoring_exclusions` 0
  - `public.grade_disputes` 0
  - `public.question_reports` 0
  - `public.sessions` 0
  - `public.student_attempts` 0
  - `public.questions` 0
  - `public.student_lock_queue` 0
  - `public.exam_specs` 1
- Actor roles, joined to `app.profiles`:
  - `session_save` (30 days): admin 44.
  - `grade_transfer_attempt`: admin 3.
  - Authoritative starts: admin 7, no profile 6.
  - `sign_download`: tutor 55.
- Function existence: `public.get_chosen_distractor_rationale` and `public.get_graded_choice_feedback` absent from the 171-function inventory (reconciliation A.3).
- Function logs (`query_logs`, `function_edge_logs`, last 24 hours, grouped by URL path): `deliver-transactional-email` 554, `charge-due-trials` 224, `byoq` 95, `get-checkout-status` 25, `get-trial-status` 22, `create-checkout-session` 20, `stripe-webhook` 7, `cancel-trial` 1, `trial-recovery` 1. None of the candidates in this review.

**Development:** `list_edge_functions` → 29 functions; `submit-response`, `byoq-smoke-runner` and `byoq-ip-echo` absent; `grade-frq`, `open-hand-item`, `send-auth-email` and legacy-build `session-event` v40 present.

**Source:**
- Operation sets and call sites from the subagent's citations in B and A.
- Spot-checked by reading: `A lib/retired-routes.ts:23-34`, `A components/auth/RetiredRouteGate.tsx:11-23`, `A routes/hand-drawn-pilot.tsx:84-118`, `A lib/use-grade-practice.ts:182`, `A hooks/use-session.ts:885-925`, `A lib/homework-help/graded-feedback.ts:35-75`, `A routes/ask.tsx:1-40`, `B session-event/index.ts:227-262`.
- Decision records: `docs/product/ARCHITECTURE_AND_DESIGN_DECISIONS_CURRENT.md` D1, D6, D11, D14 and O10; `docs/INDEX.md` reviewer-portal row; `docs/team_charter/CRAMAPPLE_SESSION_START.md:15,77`.
- Open PRs: #522 (submit-response retirement) and #524 (session RPC reconciliation), read with `gh pr view`.

**DRIFT_REGISTER rows reused:** §1.1 Production rows for `grade-frq`, `seed-stimulus-images-2026-07-19`, `session-event`, `storage-sign-url`; §1.2 Development rows for `grade-frq`, `open-hand-item`, `send-auth-email`, `session-event`, `submit-response`, `byoq-smoke-runner`, `byoq-ip-echo`; note 6 (`content-intake` on neither project). Since then the last three Development functions have been deleted by PR #522 (Verified today).
