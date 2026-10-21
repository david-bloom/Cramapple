# TASK-0078 — Backend stability follow-ups from the 2026-10-21 assessments

**Status:** Open — rulings recorded, no slice started
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

## 2. Checklist

| # | Item | Tier | State | Notes |
| --- | --- | --- | --- | --- |
| A1 | Extend the Minimal CI Deno allowlist with the `attempt-response`, `evaluate-attempt`, `capture-pairing` tests and the env names they need | Docs/CI | **Codex PR #520 open** | Haiku's proposed diff is in `qa/TEST_GATE_INVENTORY_2026_10_21.md` (38 files, 760 tests, 60 of 61 pass under `env -i`). Take its narrower option: keep the existing step, add a second step for the few files that need `--allow-net` (`byoq`, `capture-pairing`), `--allow-read` (`email-template-data`, `payer-email`) or unrestricted `--allow-env` (`create-post-purchase-addon/handler_test.ts`, Stripe SDK) |
| A2 | Replay ownership on `session-event` and `storage-sign-url` (actor-scoped lookup, read the audit-insert error, re-sign on replay, handler extraction, tests), no hash changes | Standard | **Codex PR #521 open** | spec in `REFACTOR_PLAN_REVIEW_2026_10_21.md` §5 |
| A3 | Retire `submit-response` (source directory and the Development function) | Standard | **Codex PR #522 open**; Development functions `submit-response`, `byoq-smoke-runner`, `byoq-ip-echo` already deleted (Opus verified Development lists 29) | not on Production, no caller |
| A4 | Read the error on the two grade writes in `evaluate-attempt` (`:1884`, `:2627`) and fail the request when the store fails | Standard | **ruled; Codex PR #535 open** | Acceptance: both sites destructure `{ error }`; on error, log it and respond 5xx with a stable code (for example `grading_result_write_failed`) and no score in the body; decide and test what a retry with the same idempotency key does next, since today a replay finds the row at `processing` and answers 202, so either mark the row `failed` so the retry re-grades, or make the replay path re-attempt the write; the deterministic MCQ path and the model path both covered; test in `evaluate-attempt/index_test.ts` and add that file to CI (A1) |
| A5 | `review-decision`: replace the empty catch around `advanceWorkflow` with surfaced failures; `admin-content` 10 unread writes; `capture-pairing` cancel | Standard | **Codex PR #536 open**; note ruling 1 freezes deploys of the review functions, so the review-decision part lands in source only | can wait behind A4; review functions are otherwise frozen (ruling 1) |
| A6 | Redeploy `evaluate-attempt` and `attempt-response` from `main` (Development, verify bundle hash, then Production on approval) | Hard-Gate | open | makes the TASK-0074 control-character strip live; clears stale `grading-feedback`, `student-memory`, `growth-events`, `math-verifier` |
| A7 | Redeploy `create-post-purchase-addon` from `main` (Development with Stripe test mode, then Production on approval) | Hard-Gate | **Development done 2026-10-21** (v36, `ezbr_sha256 f605bbcb…`, every bundled file byte-identical to `main` `73206cde`; unauthenticated POST returns 401); the signed-in Stripe test-mode purchase on Development is not yet run; **Production pending approval** | prerequisite for §4; Production v8 lacks `ownsAddonSource` (`fce40d1d`) |
| A8 | Lovable: show the add-on offer on the payment-result page | Standard (Lovable, David publishes) | **Built 2026-10-21, not published**: Lovable commit `db106773` on project `61dd6602`; `PaymentResult.tsx` read at that commit and matches the prompt; new `PaymentResult.test.tsx`; Lovable reports 250 tests and type check clean; 3 credits | publish only after A7 reaches Production. One copy choice to confirm: after code sign-in, "Not now" goes to `/home?subject=…` without `welcome=1` (the prompt asked for the existing non-welcome redirect) |
| A9 | Migration: weekly `sweep_learning_sessions` cron job | Hard-Gate | open | SQL in §3 |
| A10 | Migration: re-apply the `20260821011843` and `20260821014327` bodies to Production after a Development rehearsal | Hard-Gate | **PR #524 merged 2026-10-21 (David: "Merge #524"); its base was the #520 branch, so the file is on `codex/task-0078-refactor-ci` and reaches `main` with #520. Development applied 2026-10-21 via `apply_migration`: guards passed, hashes unchanged (`dbc35186…`, `5a71a24d…`), ledger version `20261021202904` (file to be renamed on the #520 branch). Production apply still pending approval.** Earlier note: ESCALATED 2026-10-21: two real student accounts (created 2026-09-23 and 2026-10-06, 6 and 2 attempts) hold `active` sessions on their current pack, so Production refuses them a subject switch today.** Codex PR #524 (`20261021153710_task0063_reconcile_session_rpc_bodies.sql`, SQL tests, release packet) is the fix; success = Production hashes `5a71a24d…` and `dbc35186…` | removes the subject-switch refusal (TASK-0063); with a weekly sweep this is what keeps an abandoned session from blocking a student for up to a week |
| A11 | Scope `app.submit_response` replay probes to the actor | Hard-Gate | **Codex PR #523 open** | can ride with A10's approval |
| A12 | Set `GRADING_ENTITLEMENTS_ENABLED=true` on Development | Config | open | so rehearsals match Production. From `qa/ENVIRONMENT_PARITY_2026_10_21.md`: also `FRQ_PHOTO_SUBJECTS` (Development only) and `start-trial` missing on Development. The `SERVICE_ROLE_KEY` secret being absent on Development is not a gap: both fallbacks in `byoq/index.ts:289` and `_shared/public-rate-limit.ts:132` try `SUPABASE_SERVICE_ROLE_KEY` first, which Supabase injects into every function |
| A13 | Find who invokes `trial-recovery`; check the 2 undelivered `growth_event_outbox` rows | Read-only | open | |
| A14 | Adopt or trim the shared-module release rule | Docs | open | proposal in `SHARED_MODULE_DEPENDENCY_MAP_2026_10_21.md` §4 |
| A15 | Run the Opus prompt (assessments 2, 7) and the Haiku prompt (5, 6) | Read-only | open | `docs/handoffs/PROMPT_ASSESSMENTS_*` |
| A16 | Helper consolidation, one family per PR; payments pure offer extraction | Standard | **Codex PRs #525 (SHA-256/Base64), #526 (input parsing), #527 (env), #528 (request IP), #529 (response envelope), #530 (storage primitives), #531 (checkout offer/promotion) open** | last; each needs byte-parity evidence in its PR body before merge |
| — | Port `ad083b39` review code; redeploy `assign-for-review`, `reviewer-invite`, `review-decision` | — | **deferred by ruling 1** | revisit when human review is re-planned |
| A17 | Retire the hand-drawn pilot upload path: `/hand-drawn-pilot` route, `storage-sign-url` `sign_upload`/`sign_delete`, the `hand_drawn_pilot` item mode, `public.select_hand_drawn_pilot_items` | Standard + Lovable | open, decide (David) | From `qa/DORMANT_SURFACE_REVIEW_2026_10_21.md`. Verified 2026-10-21: Production's `learning_sessions_entry_path_check` has no `hand_drawn_pilot` value, so the page cannot start a session; `sign_upload` has never been used on Production. QR capture (DECISION-0050/0109) is untouched |
| A18 | Two RPCs the live app calls exist on neither project: `get_chosen_distractor_rationale` (migration `20260828170000`, never applied anywhere) and `get_graded_choice_feedback` | Decide (David) | open | Verified absent on Production and Development. The caller in `use-session.ts:901` swallows the error, so students see no rationale rather than an error. Either apply the migration (after confirming the flow is live) or delete the calls |
| A19 | Ledger strategy: re-baseline or row-by-row repair | Decide (David) | open | `qa/MIGRATION_LEDGER_RECONCILIATION_2026_10_21.md`: Production 2 listed-not-effective, 124 rows with SQL no local file holds, 32 with no SQL, 94 local files live with no row; `db push` or `migration repair` against Production is unsafe until decided. Also decide the two never-applied files (`20260827120000`, `20260828170000`, see A18) |
| A20 | Hygiene: 11 `SECURITY DEFINER` functions in `app` are executable by `anon` on Production | Standard migration | open, low risk | Verified 2026-10-21: all 11 are trigger functions (`handle_new_user`, `tg_*`, `guard_*`, `response_versions_guard_submission`, `rollup_pre_submit_hint_count`, `servable_items_census`, `set_assistance_event_derived_fields`, `refuse_attempt_on_teaching_item`); none is in `public`, so PostgREST cannot call them, and trigger functions cannot be invoked directly. Revoke `anon`/`authenticated` execute for hygiene; not urgent |

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

Two TASK-0078 records now exist in the Codex stack (`TASK-0078-CAUTIOUS-BACKEND-REFACTOR.md`); this file is canonical.
Decide: fold the Codex execution record into §2 here, or keep it as a linked handoff. Do not let both carry status.

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
