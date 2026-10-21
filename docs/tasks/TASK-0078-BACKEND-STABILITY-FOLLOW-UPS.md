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

## 2. Checklist

| # | Item | Tier | State | Notes |
| --- | --- | --- | --- | --- |
| A1 | Extend the Minimal CI Deno allowlist with the `attempt-response`, `evaluate-attempt`, `capture-pairing` tests and the env names they need | Docs/CI | open | Haiku assessment 5 produces the diff |
| A2 | Replay ownership on `session-event` and `storage-sign-url` (actor-scoped lookup, read the audit-insert error, re-sign on replay, handler extraction, tests), no hash changes | Standard | open | spec in `REFACTOR_PLAN_REVIEW_2026_10_21.md` §5 |
| A3 | Retire `submit-response` (source directory and the Development function) | Standard | source ready for review; Dev retirement verified | [PR #522](https://github.com/david-bloom/Cramapple/pull/522): three retire-row Development endpoints deleted on David’s explicit action-6 request; source removal unmerged. Diagnostics preserved; send-auth-email/open-hand-item retained. [Receipts](../qa/TASK0078_SUBMIT_RESPONSE_RETIREMENT.md). Production unchanged. |
| A4 | Read the error on the two grade writes in `evaluate-attempt` (`:1884`, `:2627`) and fail the request when the store fails | Standard | open | must-fail rows; student sees a score the database did not keep |
| A5 | `review-decision`: replace the empty catch around `advanceWorkflow` with surfaced failures; `admin-content` 10 unread writes; `capture-pairing` cancel | Standard | open | can wait behind A4; review functions are otherwise frozen (ruling 1) |
| A6 | Redeploy `evaluate-attempt` and `attempt-response` from `main` (Development, verify bundle hash, then Production on approval) | Hard-Gate | open | makes the TASK-0074 control-character strip live; clears stale `grading-feedback`, `student-memory`, `growth-events`, `math-verifier` |
| A7 | Redeploy `create-post-purchase-addon` from `main` (Development with Stripe test mode, then Production on approval) | Hard-Gate | open | prerequisite for §4; Production v8 lacks `ownsAddonSource` (`fce40d1d`) |
| A8 | Lovable: show the add-on offer on the payment-result page | Standard (Lovable, David publishes) | open | prompt in §4; ship after A7 |
| A9 | Migration: weekly `sweep_learning_sessions` cron job | Hard-Gate | open | SQL in §3 |
| A10 | Migration: re-apply the `20260821011843` and `20260821014327` bodies to Production after a Development rehearsal | Hard-Gate | open | removes the subject-switch refusal (TASK-0063); with a weekly sweep this is what keeps an abandoned session from blocking a student for up to a week |
| A11 | Scope `app.submit_response` replay probes to the actor | Hard-Gate | open | can ride with A10's approval |
| A12 | Set `GRADING_ENTITLEMENTS_ENABLED=true` on Development | Config | open | so rehearsals match Production |
| A13 | Find who invokes `trial-recovery`; check the 2 undelivered `growth_event_outbox` rows | Read-only | open | |
| A14 | Adopt or trim the shared-module release rule | Docs | open | proposal in `SHARED_MODULE_DEPENDENCY_MAP_2026_10_21.md` §4 |
| A15 | Run the Opus prompt (assessments 2, 7) and the Haiku prompt (5, 6) | Read-only | open | `docs/handoffs/PROMPT_ASSESSMENTS_*` |
| A16 | Helper consolidation, one family per PR; payments pure offer extraction | Standard | open | last |
| — | Port `ad083b39` review code; redeploy `assign-for-review`, `reviewer-invite`, `review-decision` | — | **deferred by ruling 1** | revisit when human review is re-planned |

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
