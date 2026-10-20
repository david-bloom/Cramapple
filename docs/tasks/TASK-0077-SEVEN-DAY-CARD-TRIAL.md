# TASK-0077 — Seven-Day Free Trial With a Saved Card

**Status:** Backend built and tested; **deployed to Development** 2026-10-18, QA fixes 2026-10-19; Production readiness check 2026-10-20 (Production blocked on the Loops email foundation and Loops itself). On Development, trial
admission and charges are **on** (Stripe test mode) and both workers are scheduled; trial notices are off (see "Development
deployment" below). Nothing in Production. App pages in ap-prep-blueprint PR #37, not published.
**Tier:** Hard-Gate. **Product Owner:** David Bloom. **Owner:** Claude. **Opened:** 2026-10-18.
**Governing decision:** `DECISION-0126` items 1–31. **Plan:** `docs/product/SEVEN_DAY_CARD_TRIAL_PLAN_2026_10_18.md` (v3).
**Reviews of the plan:** Codex PR #505 (v1, "Not ready", 13 findings, all addressed in v2); Fable (v2, "Ready with changes",
folded into v3). Codex has **not** reviewed v3 or the code; David asked for execution on 2026-10-18, so Codex reviews the
code PR instead.

## What is built (backend, by plan slice)

| Slice | What | Where | Evidence |
|---|---|---|---|
| 0 | Checkout sessions routed by Stripe's mode before any grant; setup/subscription/unknown modes held aside; a missing `payment_status` no longer grants | `_shared/checkout-routing.ts`, `stripe-webhook/index.ts` | `checkout-routing_test.ts` |
| 1 | `stripe-node` pinned to 22.0.0 (matches API `2026-03-25.dahlia`); the version cast removed; a card with no brand skips the receipt instead of throwing | `_shared/stripe.ts`, `_shared/payer-email.ts` | every Stripe-importing function type-checks; `payer-email_test.ts` |
| 2 | Order engine: `trial_orders`, hashed consumed-email ledger (legacy `trial_v1` backfilled), capability tokens, notice jobs, heartbeat; locked RPCs for activate, sweep, claim, attempt outcome, convert, cancel, refund, dispute; five analytics event names; Vault-backed worker invokers (no schedule) | `supabase/migrations/20261018191924_*`, `20261018191935_*` | `scripts/task0077/run_sql_tests.sh` on a throwaway local Postgres: all scenario checks pass (they caught two defects, fixed) |
| 3 | Quote/start service (server-decided billing mode, own promo evaluator, locked quote, quote-version and Terms-version checks, one pending order per email) used by both checkouts; webhook activation (setup verified, single unconfirmed PaymentIntent recorded with the grant), conversion, automatic refund after cancel, refunds, disputes; checkout status and parent short link report trials, never "paid"; `persistStripeCustomer` refuses payers who are not the learner | `_shared/trial-promo.ts`, `_shared/trial-core.ts`, `_shared/trial-checkout.ts`, `create-checkout-session`, `create-parent-payment-link`, `stripe-webhook/trial.ts`, `get-checkout-status`, `_shared/parent-short-link.ts` | `trial-promo_test.ts`, `trial-core_test.ts`, `trial-checkout_test.ts`, `stripe-webhook/trial_test.ts`, `parent-short-link_test.ts` |
| 4 | Charge worker (sweep always; claim and confirm the order's own PI only when `TRIAL_CHARGES_ENABLED`; transport errors reconcile, never retry; Stripe clean-up of finished orders); cancel, recovery and status endpoints | `charge-due-trials/`, `cancel-trial/`, `trial-recovery/`, `get-trial-status/`, `_shared/trial-actions.ts` | `charge-due-trials/handler_test.ts`, `trial-actions_test.ts` |
| 5 | Trial notices inside `deliver-transactional-email` (opt-in independent, state rechecked before send, both recipients on parent-pay, fresh hashed token per email, backoff) | `_shared/trial-notices.ts`, `deliver-transactional-email/index.ts` | `trial-notices_test.ts` |
| 9 prep | `start-trial` returns 410 when `CARDLESS_TRIAL_RETIRED=true` | `start-trial/index.ts` | `start-trial/index_test.ts` |

CI's Deno command (`.github/workflows/minimal-ci.yml`, now including the new tests) passes locally: 222 tests.

**Session record (2026-10-18 to 2026-10-20, QA, sandbox journeys, Loops):** `docs/handoffs/SESSION_CLOSE_2026_10_20_TASK0077_TRIAL_QA_SANDBOX_AND_LOOPS.md`.

## QA fixes (2026-10-19, PR #507 review)

Six findings from the independent review of `0dcf1639`, all reproduced and fixed. The SQL changes are a new migration,
`20261019142835_task0077_trial_qa_fixes.sql`, because the original was already applied on Development.

**Applied to Development 2026-10-19 (David approved).** Migration applied with `apply_migration` (Development recorded
`20261019142835`; the file was renamed to match). Read-back: the three changed behaviours present, `trial_delayed_notice_sent`
callable by `service_role` only, the 8 existing test orders unchanged. Before deploying, each target function was downloaded
from Development and diffed against the branch: all matched `0dcf1639` except an older `trial-notices.ts` (behind the branch,
nothing Development-only). Deployed `stripe-webhook`, `create-checkout-session`, `create-parent-payment-link`,
`deliver-transactional-email`, `cancel-trial`, `charge-due-trials` (`--no-verify-jwt`, as before); a fresh download of each
matched the branch file for file. Smoke: worker without secret 401; unknown cancel token 404; signed-out cancel 401; bad webhook
signature 400; `trial_quote` returns `billing_mode: trial` with the new mandate wording. The scheduled charge worker ran the new
code at 14:30 UTC (summary includes `resettled: 0`, no errors). `MANDATE_TEXT_VERSION` bumped to `trial-mandate-v2` for the
2026-10-18 wording change (it had been left at v1) and the two checkout functions redeployed.

1. **Refund before success (P1).** `trial_mark_refunded` makes a full refund terminal for any charged-or-chargeable order;
   `trial_convert` returns `already_refunded` (no grant, no second refund). A cancelled order records it as its cancel outcome.
2. **Checkout retry replayed the expired session (P1).** Each start uses a fresh idempotency key; resetting and linking the
   session are compare-and-set, so a concurrent start stops with `409 trial_start_in_progress` instead of overwriting.
3. **Delayed charge without 48 hours' notice (P1).** The sweep leaves `next_attempt_at` unset; the notice worker calls
   `trial_delayed_notice_sent` after the payer's email is accepted, which sets the attempt no sooner than 48 hours later and
   extends access past it. Until then the order is never claimable and access keeps rolling forward. A missed window cancels the
   unsent old notice and queues a new one. The student's copy waits for the payer's so both name the same date.
4. **Expired parent cancel link in a delayed notice (P1).** Expiry is three days after the latest charge the order can still
   face, and never less than three days from issue (`parentCancelExpiry`).
5. **Unfinished cancellation settlement (P2).** A repeat cancel with no recorded outcome re-runs the (idempotent) settlement;
   the parent's cancel link stays valid until the outcome is recorded; the charge worker resumes cancellations left unsettled for
   over five minutes, before its Stripe clean-up.
6. **Own reservation exhausted the promo code (P2).** Local promo use counts exclude this email's own pending reservation.

Tests: CI's Deno command 233/233; SQL scenarios 7–9 added and all pass on a local Postgres (they fail without the new
migration); Codex's four Deno probes and its refund SQL probe no longer reproduce.

## Paired sandbox journey (Development, 2026-10-19, David approved)

Stripe sandbox `acct_1U3K3SLrvKNd9sBp`, Development backend, the PR #37 app pages run locally against Development, Stripe's
published test cards. Approved changes: the Development webhook endpoint `we_1UKj4nLrvKNd9sBpasmGR65M` gained
`payment_intent.succeeded/payment_failed/processing/canceled` and `charge.dispute.created` (release checklist item 5, sandbox
only); day 7 reached by moving each test order's dates back 7 days; cancel/recovery tokens inserted by hash because
`TRIAL_NOTICES_ENABLED` is off. Student emails: `dbloom01+trial-{a,b,c}-20261019@gmail.com`.

| Journey | Path | Result |
| --- | --- | --- |
| A, order `0ba65ced` | Student direct, card 4242: quote/start → Elements setup → webhook activation → day 7 → worker charge → `payment_intent.succeeded` → full refund | **Pass.** Trial started at the setup event's time; one unconfirmed PI; worker charged off-session on the first attempt; converted, paid access open-ended, trial access expired, reminder cancelled; refund webhook → `refunded`, paid and trial access revoked. |
| B, order `87255cf7` | Parent link, card 4000 0000 0000 0341: hosted page with Terms consent → activation → day 7 → decline → recovery link → new card 4242 | **Pass.** Payer = parent email, `terms-2026-10-18` via `stripe_consent_collection`; parent card not mapped to the student; decline → `payment_failed`, 24 h grace with access extended, one retry 1 h before grace end, both recipients notified; recovery page paid on-session, page showed completion from Stripe's status; converted, one recovery attempt counted, retry cleared, link voided. A replayed setup event after conversion changed nothing. |
| C, order `9be34e2e` | Parent link, card 4242 → activation → parent opens cancel link → cancels | **Pass.** Opening the link changed nothing; cancel → "Cancelled. You won't be charged.", trial access revoked, PI `canceled` on Stripe, link voided, cancel notices for both recipients. |

Not covered: the signed-in student's Account-page cancel (needs a signed-in student session), 3D Secure, a dispute, trial
notice email delivery (templates not built), and a lost-webhook reconciliation.

**Findings:**
1. **Activation depends on the account-invite email.** *Fixed in code 2026-10-19, not yet deployed or reviewed:* a new
   student is created unconfirmed with no email (`_shared/trial-learner.ts`); an address auth rejects is a durable
   `activation_refused` (`student_email_invalid`, parent card detached); auth outages still retry. Original finding: `resolveCheckoutStudentUserId` invites the student before activation;
   an address Supabase rejects (`email_address_invalid`, seen with example.com) or the auth email rate limit
   (`over_email_send_rate_limit`) makes the webhook return 500. The card is saved, no trial starts, the buyer is told nothing,
   and activation waits on Stripe's retries (B and C waited about two hours here). Decide whether to create the account
   without blocking on the email and invite separately, and whether checkout should validate the address first.
2. **Development uses Supabase's built-in auth email** (about 2 emails per hour), which also limits any further sandbox runs.
3. *Fixed 2026-10-19 (`c7ae7dc5`, deployed to Development):* **Parent mandate names subject keys:** "for Sam's biology" instead of "AP Biology" (`parentMandateText` is passed
   `subjectKeys`).
4. *Fixed in code 2026-10-19 (`c7ae7dc5`, deployed; new PIs only, unverified on a fresh PI):* **The trial PaymentIntent is not card-only:** the recovery form offers Bank, Cash App Pay, Affirm and Klarna. Product call;
   if unwanted, pass `payment_method_types: ["card"]` when the PI is created.
5. **Setup forms offer Link's "Bank" option** although the sessions are card-only. *David 2026-10-19: Link off for trials.*
   Both trial setup sessions now set `wallet_options.link.display = "never"`, and activation refuses a non-card or
   Link-branded method (`payment_method_not_card`). Still open: whether the recovery page's Payment Element shows Link.
6. **The parent's Terms link points at Stripe's placeholder** (`accessible.stripe.com/terms-of-service`): the sandbox
   account's public business details have no Terms URL (checklist item 5). Verify on the live account before launch.
7. *Fixed 2026-10-19 (`c7ae7dc5`, deployed):* Queued `trial_started` notices stay eligible after conversion, so a late send could follow the conversion email.

## QA round 4 fixes (2026-10-20, Codex review of `fb1ace39`)

Codex confirmed F1–F4 fixed and found two P2s. Migration `20261020233210_task0077_trial_qa_round4.sql` (drops
`trial_orders.recovery_seen_error`; adds `trial_count_recovery_failure`). **On Development 2026-10-20** (below); not on
Production.

| Finding | Fix | Tests |
| --- | --- | --- |
| **F5** a clean-up snapshot can mark a late-saved card done | `cleanUpFinishedOrders` marks done only where status, PI, card and an unset marker still match what it read; no match → logged `trial_cleanup_snapshot_changed`, left for the next run | `handler_test.ts` (worker mock now honours filters; race test) |
| **F6** repeated authentication failures counted once | Attempts are counted by the webhook: each `payment_intent.payment_failed` for the order's PI adds one (`trial_count_recovery_failure`), once per event (the ledger runs an event once); events from the worker's own confirmations (idempotency key `trial-confirm:`) are excluded; the recovery page only checks the cap and never counts | `trial_test.ts` (8 same-card failures → 8), `trial-actions_test.ts`, SQL §11 |

Limit, unchanged by this fix: the cap stops the page handing out the client secret again; a payer who keeps the form open
can still retry within that page until Stripe's own confirmation limit.

Results: full CI Deno command (22 files) **254 passed**; SQL **88 checks + legacy backfill**; Codex's four probes against
this code: both regression probes pass, both defect probes now fail (the cleanup marker stays unset; the page no longer
counts, so the recovery probe reads 0, while the webhook path counts each event).

**Development deploy (2026-10-20, David approved).** Before: all nine trial functions matched `7135e6ae`; five change in
round 4. Deployed `stripe-webhook`, `charge-due-trials`, `trial-recovery`, `cancel-trial` (`--no-verify-jwt`) and
`get-trial-status` (JWT) from `cfbd59b1` first, then the migration (the old code wrote the dropped column), recorded as
**`20261020233210`** (file renamed). Read-back: column gone; only `service_role` can execute the new function. After: all
five match `cfbd59b1` file for file.

*Live check, parent order J (`5626f0aa`), card 4000 0027 6000 3184:* 3D Secure setup completed → day 7 → the worker's
off-session charge failed `authentication_required` (`requires_action`); its `payment_intent.payment_failed` event (key
`trial-confirm:…:1`) was processed and **not** counted (`recovery_attempts` 0). On the recovery page (localhost, app `main`)
two failed 3D Secure challenges on the same card → two events with Stripe's own keys → `recovery_attempts` **2** (3 failure
events in all). A third try with the challenge completed → converted; paid access active, trial access expired, recovery
link voided.

*Notices on Development (after the other session set `TRIAL_NOTICES_ENABLED=true`, 2026-10-20):* every trial notice
delivered in the last three days went through the round-3 stored path (`rendered_at` set, `delivery_payload` cleared): 14
delivered (trial started, requires action, converted, canceled, refunded), none pending, none flagged for review, no errors.
This is the normal path; the accepted-send-then-failed-acknowledgement path is still covered only by tests and Codex's probe.

## QA round 3 fixes (2026-10-20, Codex review of `0b6301f2` + readiness findings)

Migration `20261020224101_task0077_trial_qa_round3.sql` (new columns `trial_notice_jobs.delivery_payload`, `rendered_at`,
`trial_orders.recovery_seen_error`; replaces `trial_activate`, `trial_sweep`, `trial_delayed_notice_sent`). **On Development
2026-10-20** (see below); not on Production.

| Finding | Fix | Tests |
| --- | --- | --- |
| **F1** (P1) restart replaces a completed session | `retireSession`: a failed expiry is classified from the session; `complete` → `409 trial_setup_completing`, order untouched; unreadable or still open → `503 trial_start_unavailable`; `expired` → proceed | `trial-checkout_test.ts` (3 new) |
| **H** (readiness 1) card saved after the sweep | Setup sessions get `expires_at` = the quote's expiry; the sweep leaves session-linked pending orders to Stripe's `checkout.session.expired` and backstops only after 4 days; a completion on a `setup_expired` order records the card (`recordLateSetup`) and a parent's is detached; clean-up now covers `setup_expired` | `trial_test.ts` (2 new), SQL §10 |
| **F3** (P2) refusal after the PI loses clean-up | `trial_activate` stores the PI, SetupIntent and card on the `email_consumed` refusal, and on a late activation of a `setup_expired`/`activation_refused` order (clean-up re-armed) | SQL §10 |
| **F4** (P2) access gap after day 7 | The sweep extends active trial access in rolling hours for `trialing`/`charging` orders from 15 minutes before `trial_ends_at` until they convert, fail, are delayed or are cancelled; never shortens, never revives revoked rows | SQL §10 |
| **F2** (P2) accepted notice + failed acknowledgement | Each notice is rendered once and stored (`delivery_payload`, links included) before the first send; a retry resends it exactly under the same key, and a 409 on that repeat counts as delivered (a 409 on a first send is still an error); a stored delayed-charge email that would give under 48 hours is re-rendered under a new key; `trial_delayed_notice_sent(…, p_sent_at)` counts the 48 hours from the send; payload cleared on delivery | `trial-notices_test.ts` (3 new), SQL §10 |
| **Readiness 3** attempts counted per page open | `failureKey(pi)`: an attempt is a new failure on the order's intent (charge, code, method), stored in `recovery_seen_error`; reopening the page counts nothing | `trial-actions_test.ts` |
| **Readiness 2** recovery form not card-only | App: Payment Element mounted with `wallets: { link: "never" }` (sandbox probe: that option alone removes Bank, Klarna and Link) | ap-prep-blueprint PR #39 |

Results: SQL scenarios **86 checks + legacy backfill** passed on a throwaway local Postgres. *Correction (2026-10-20):* the
"235 passed" first recorded here came from a copy of the CI command that left out its last two test files; the full 22-file
CI command ran **252** at `fb1ace39` (Codex's count was right).
The marketing return page should show a "finishing your trial" message for `409 trial_setup_completing` (today it shows the
generic error); not yet sent to Lovable.

**Development deploy (2026-10-20, David approved).**
- *Before:* every Development copy of the nine affected functions matched a branch commit (no drift): `stripe-webhook`
  `e9a7d473`; `create-checkout-session`, `create-parent-payment-link`, `deliver-transactional-email` `e9a7d473`/`b92c5b1e`;
  `cancel-trial`, `charge-due-trials` `c7ae7dc5`; `trial-recovery`, `get-trial-status` `a7959a01`; `get-checkout-status` older.
- *Migration:* `apply_migration` recorded **`20261020224101`** (file renamed to match). Read-back: three new columns, the
  three-argument `trial_delayed_notice_sent`, `authenticated` cannot execute it, new sweep and activation bodies, sweep runs.
- *Functions:* `stripe-webhook`, `create-checkout-session`, `create-parent-payment-link`, `get-checkout-status`,
  `deliver-transactional-email`, `charge-due-trials`, `cancel-trial`, `trial-recovery` (`--no-verify-jwt`) and
  `get-trial-status` (JWT) from `7135e6ae`. *After:* all nine match `7135e6ae` file for file (98 files across the nine, 0 differ).
- *Live checks:* new parent order I (`db921beb`): the Stripe session's `expires_at` equals `quote_expires_at`
  (2026-10-21 22:43:31Z); with the quote pushed into the past the sweep left it `pending_setup`. Marked `setup_expired` (as
  the 4-day backstop would) and a card saved on the still-open session: the webhook recorded the card and SetupIntent,
  detached the parent's card at once (Stripe: no customer), started no trial, and the return page says "We couldn't start
  the trial. Nothing was charged." Old H (`20bda562`, from before the fix): a replayed event is ignored by the webhook ledger
  (processed events never run twice), so its card id was written to the order by hand; the 22:45 worker run detached it
  (Stripe: no customer) and marked both orders cleaned.
- *Development-only gap:* Stripe's return URL has no `backend=dev`, so a return page opened in a fresh tab asks Production
  and shows "We can't confirm your payment yet". Add `backend=dev` to Development's success/return URLs if this bites.
- Not live-testable on Development: F2 (`TRIAL_NOTICES_ENABLED` is off) and F1's race (the webhook lands in seconds).

## Production readiness check (2026-10-20, David asked: checklist items 1, 2, 4, 6 and the smaller items)

**Marketing checkout (Lovable `61dd6602`).** Audited `902b5833` against the contract above: quote, Terms tick, setup
Elements, 409 re-quote, return page, parent drawer, `/p/<code>`, `/trial` redirects and backend/key selection are done.
Fixed in **`f9a5e637`** (Lovable, not published): a promo could not be applied in trial mode (Apply went through the pay-now
path, which refuses while a trial quote is active); a failed quote froze checkout with no message (now an error with Try
again, never a pay-now fallback); the trial card form said "We'll charge your card once" (now "We'll save this card. Nothing
is charged today."); a pay-now `409 trial_required` was ignored (now re-quotes into the trial UI); the return page polled
after `trialing`. Checked on the preview with `?backend=dev`: an invalid code shows "That promo code isn't valid."; `TestCode`
shows −$38.99 and the mandate and Terms line change to $1.00; the card form shows the new line, card only, no Link.
The parent drawer's "started" check (`entitled`) is correct: `get-checkout-status` sets `entitled` while `trialing`.
*Product call, not changed:* "No subscriptions, no surprises" / "one-time" / "pay once" copy (home pricing,
`ap-biology-prep`, `SkuMarketingPage`, checkout meta) stays true of the day-7 charge, but the home meta still says
"Sign up free until November".

**Production sign-in email (item 9), read-only.** Auth config on `pcntajvbdfqhbeewmdry`: Send Email hook **off**; SMTP
`smtp.resend.com` from `no-reply@auth.cramapple.com`; "Confirm sign up", Magic Link and Invite all carry `{{ .Token }}`;
Confirm sign up has no `ConfirmationURL` and no links; 6-digit codes, 1 h expiry. So trial sign-in does **not** depend on
Loops. The live end-to-end check (a new account on Production) is still David's.

**Stripe live account `acct_1TddjmLwoRHzBJ1O` (item 5 of the checklist).**
- Payment method domains: `cramapple.com`, `checkout.cramapple.com` enabled since 2026-10-04 (Apple Pay done).
- Public details: Terms URL and Privacy URL were empty. The form is filled (`https://cramapple.com/terms`,
  `https://cramapple.com/privacy`, both 200) but **not saved**: the session's permission check refused the Save click.
- Radar "Use Radar on payment methods saved for future use": **off**. Not changed (same reason).
- Webhook "Cramapple Checkout" → Production `stripe-webhook`, 6 events, 0 % errors. **Add the five new events only after
  the new `stripe-webhook` is on Production:** the deployed and `main` versions throw `unsupported_stripe_event_type`
  (`stripe-webhook/index.ts:785`), so Stripe would retry and could disable the endpoint.

**Production is behind `main`, not only the trial (item 8).** Functions downloaded and diffed against `main`:
`stripe-webhook`, `send-parent-payment-email`, `start-trial` and three `_shared` files differ (Production lacks the Loops
payment emails, the outbox and PostHog `environment` tagging). `deliver-transactional-email` does not exist on
Production. Migrations missing on Production: `20261006084914_loops_transactional_email_outbox` and
`20261006143000_parent_email_lifecycle` (also `20261003000100_create_product_feedback_phase_b`, not checked further;
the two BYOQ files are timestamp drift, already applied). No cron jobs and no trial or email Vault entries. The trial
worker's email function always runs payment and parent-lifecycle delivery, and `main`'s webhook enqueues payment emails,
so **the trial cannot ship without the Loops email foundation** (`docs/product/LOOPS_TRANSACTIONAL_EMAIL_MIGRATION_2026_10_06.md`,
TASK-0060, never cut over). `growth_event_outbox_event_name_check` on Production matches the 17 names the trial migration
expects to replace. Production has no trial tables; last migration `20261016000100`.

**Loops is a launch blocker, not only a nicety.** The parent mandate says "You can cancel from the link in your
confirmation email". That link exists only in the Loops trial-started notice. With Loops down, a paying parent has no
cancel path, so admission must stay off until notices send.

**Smaller items, Development (Stripe sandbox, 2026-10-20).** Parent orders via `create-parent-payment-link`, cards entered
on Stripe's hosted test page; recovery and Account pages run locally (`localhost:8080`, PR #37 code) against Development.

| Journey | Path | Result |
| --- | --- | --- |
| F `9dfcb812` | Card 4000 0027 6000 3184: 3D Secure on setup → day 7 → off-session charge | **Pass.** Setup challenge completed; charge `authentication_required` → `requires_action`, 24 h grace; recovery page → 3D Secure on-session → converted, paid open-ended, trial expired, link voided. |
| G `afb35b82` | Card 4000 0000 0000 0259 → day 7 charge → dispute | **Pass.** Charged, then `charge.dispute.created` → `disputed`; trial and paid access revoked; Stripe cleanup done. |
| D `7dc46674` | Signed-in student, Account page → Cancel | **Pass.** "Cancelled. You won't be charged."; access revoked; PI `canceled` on Stripe. Sign-in used a Development admin-generated code (Development's templates have no code). |
| H `20bda562` | Late setup webhook: quote expired and swept before the parent saves the card | **Fail.** See finding 1. |

Findings:
1. **A setup that completes after the sweep strands the card.** The sweep marks `pending_setup` → `setup_expired` at
   `quote_expires_at` (24 h) but never expires the Stripe session, and Stripe retries a webhook for up to 3 days. On H the
   session was still `open` after the sweep; the parent saved a card, Stripe shows the SetupIntent `succeeded`
   (`off_session`) and the card attached to the parent's customer, the webhook logged `trial_setup_replay`, no trial started,
   and the return page said "We couldn't start the trial. Nothing was changed." The order has no `stripe_customer_id`, so
   Stripe cleanup never detaches it. Same outcome for any activation retried past the deadline. Suggested fix: the sweep
   expires the Stripe session itself, or leaves `pending_setup` orders for Stripe's `checkout.session.expired` event and
   only backstops after 3+ days; and a late completed setup on a swept order activates or explicitly refuses and detaches.
2. **The recovery form is not card-only on screen.** PI `pi_3USR4GLrvKNd9sBp1KCfaRaL` has `payment_method_types: ['card']`,
   yet the Payment Element (`elements({ clientSecret })`) shows Card, Bank ("$5 back"), Klarna and "Secure, fast checkout
   with Link" plus Link's save-my-info form. Cause not established; likely Link. Decide whether to hide Link on the recovery
   element.
3. **`recovery_attempts` counts form openings, not payments.** Each `pay` action (opening the form) adds one; the cap is 5
   (`MAX_RECOVERY_ATTEMPTS`). F reached 3 from two page loads and one direct call. A parent who reloads a few times is locked
   out with `too_many_attempts`.
4. Minor: the recovery success line says access "turns back on", but access never went off during grace. In Development
   mode the app's "Sign in" link points at Production `cramapple.com/login`, so a Development session can't be signed in
   from the app.

Left on Development: H (`setup_expired`, card attached to `cus_VTNovFug8qo0Cv` in the sandbox) for whoever fixes finding 1;
E (`475d914f`, `pending_setup`) expires by itself.

## Development deployment (2026-10-19, later rounds)

- **`c7ae7dc5`** (Codex live-QA fixes) deployed to all six trial functions; before-diff showed only the mandate-version line.
- **`e9a7d473`** (no-email activation, Link off, refused-card cleanup, template variables) deployed to `stripe-webhook`,
  `create-checkout-session`, `create-parent-payment-link`, `deliver-transactional-email`, after Codex reviewed `b92c5b1e`.
  Before-diff: all four matched `c7ae7dc5`; after: all four match `e9a7d473` file for file.
- **Quote/start check:** direct and parent quotes return `trial` / `trial-mandate-v3`; both starts return 200, so Stripe
  accepts `wallet_options.link.display = "never"`. Stripe shows both sessions card-only with Link `never`; the rendered
  parent page shows card only (no Link checkbox, no "Bank") and "for Sam's AP Biology". Both check sessions were expired on
  Stripe; the webhook moved both orders to `setup_expired`; no accounts were created.
- **New-student sign-in test (Journey D, order `7dc46674`, `dbloom01+trial-d-20261019@gmail.com`):** the student setup form
  rendered card only; activation completed within seconds with **no email** (account unconfirmed, `invited_at` and
  `confirmation_sent_at` empty; auth log shows only `user_signedup` by the server); profile created; trial access on; the
  fresh PaymentIntent is card-only (`allowed_payment_method_types: ['card']`). A code request for the unconfirmed account
  (`signInWithOtp`, `shouldCreateUser: false`, from the app's own client on localhost in Development mode) made Supabase send
  **"Confirm sign up"**. On Development that is Supabase's **stock template**: no code, only a PKCE link (single-browser)
  redirecting to the old `cramapple-dev-bloom-llc.vercel.app`, sent from `noreply@mail.app.supabase.io`. So the code step
  cannot be completed on Development. Production's "Confirm sign up" template carried `{{ .Token }}` as of 2026-10-04
  (Hard-Gate, David): **re-check it before launch**, because new trial students now meet that template first instead of
  "Invite user". Order D was left trialing (charge due 2026-10-26 in Stripe test mode) so the sign-in can be finished once
  Development's templates carry a code.
- Still unverified live: whether the recovery page's Payment Element shows Link.

## Development deployment (2026-10-18)

- **Migrations applied** with `apply_migration`; Development recorded them as `20261018191924` and `20261018191935`, and the files
  were renamed to match. Verified with a separate read-back query: 5 trial tables, 18 functions, RLS forced, no client role can
  read the tables or call the functions, `trial_sweep()` runs. No legacy `trial_v1` rows exist on Development, so the backfill
  inserted none.
- **Functions deployed** (`--project-ref wmgjsdkphcyhngaffbqf`): `stripe-webhook`, `create-checkout-session`,
  `create-parent-payment-link`, `get-checkout-status`, `resolve-parent-link`, `deliver-transactional-email`, `charge-due-trials`,
  `cancel-trial`, `trial-recovery` (all `--no-verify-jwt`, as before for the existing ones) and `get-trial-status` (JWT verified).
  `start-trial` was not deployed (Development never had it). Before deploying, Development's copies were compared with `main`:
  all matched except `create-checkout-session`, whose deployed `growth-events.ts` carried two PostHog key fallbacks that exist
  in no git branch; they were carried into the repo so the deploy did not remove them.
- **Smoke tests:** worker without its secret → 401; cancel and recovery with an unknown token → 404; trial status without a login
  → 401; webhook with a bad signature → 400; `trial_quote` → `pay_now` / `admission_off` with the $39.99 test price (stripe-node 22
  against Stripe test mode); the legacy pay-now checkout still creates a session with a client secret; checkout status for an
  unknown session → 404.
- **Development setup completed 2026-10-18/19 (David approved):**
  - Secrets: `TRIAL_ADMISSION_ENABLED=true`, `TRIAL_TERMS_VERSION=terms-2026-10-18` (David, 2026-10-18; update to the published Terms' "last updated" date whenever the Terms change materially),
    `TRIAL_CHARGES_ENABLED=true`, a new `TRIAL_CHARGE_WORKER_SECRET`, a rotated `TRANSACTIONAL_EMAIL_WORKER_SECRET`,
    `APP_BASE_URL` = the marketing Lovable preview, `STUDENT_APP_URL` = the app Lovable preview, `ALLOWED_ORIGINS` extended with
    both Lovable preview origins and `localhost:8080` (the five origins found allowed before were kept; an origin not probed may
    have been dropped).
  - **`TRIAL_NOTICES_ENABLED` left off** until the Loops templates exist; notice jobs queue and send once it is on.
  - Vault: the four entries from migration `20261018191935`, written without printing values.
  - Both workers invoked once through the Vault path (HTTP 200; charge heartbeat written, `charges_enabled: true`), then
    scheduled with `scripts/task0077/schedule_workers.sql` (`*/5` charge, `*/2` email).
  - `send-parent-payment-email` and `deliver-transactional-email` redeployed for the parent trial email and the app link base.
    `send-parent-payment-email`'s previous Development deploy was **not** compared with `main` before being replaced.

## Frontend contract (for the Lovable work)

*Status 2026-10-20:* built. Marketing `61dd6602` has the trial checkout, parent drawer, `/p/<code>` trial state and the
`/trial` redirects, behind `VITE_TRIAL_CHECKOUT_ENABLED` (unset, so the live site still sells pay-now). App pages are in
ap-prep-blueprint PR #37 (merged, not published). Audit and fixes: "Production readiness check (2026-10-20)".

**Direct checkout (`cramapple.com/checkout`, project `61dd6602`):**
1. `create-checkout-session` `{ action: "trial_quote", purchase_type: "student_direct", mode, subject_keys, student_email, promo_code }`
   → `quote`. If `quote.billing_mode` is not `"trial"`, use today's pay-now flow unchanged.
2. Show `quote.mandate_text` beside the button, a **required** "I agree to the Terms" checkbox (link `/terms`), button "Start free
   trial". Promo box as today (re-quote on change).
3. `create-checkout-session` `{ action: "trial_start", …same fields, quote_version, terms_accepted: true, student_ack: { version:
   quote.terms_version } }` → `client_secret` → `initCheckoutElementsSdk` (Payment Element + Express Checkout Element, setup mode).
   `409 quote_changed` / `billing_mode_changed` → re-quote and show the new terms.
4. A legacy pay-now call can answer `409 trial_required` with a `quote`: switch to the trial UI.
5. Return page: `get-checkout-status` answers `billing_mode: "trial"`, `trial_status`, `trial_ends_eastern`. **No invite email
   is sent for a trial** (2026-10-19): the return page sends the student to the app's email-code sign-in with the address they
   checked out with, and the trial-started email says the same.

**Parent link (share drawer):** the same `trial_quote` / `trial_start` actions on `create-parent-payment-link` (student applies the
code, acknowledges the Terms, enters their email first). The response carries `url` / `short_url`. The parent lands on Stripe's
hosted page (Terms checkbox and mandate text are Stripe's). `resolve-parent-link` answers `trial_started` after setup.

**App (`app.cramapple.com`, project `56cae479`):**
- Account: `get-trial-status` → trial card (subjects, amount, Eastern charge date, Cancel); Cancel → `cancel-trial { order_id,
  action: "cancel" }` and show the returned `message` verbatim.
- `/trial/cancel/:token` → `cancel-trial { token, action: "view" }`, confirm button → `{ token, action: "cancel" }`.
- `/trial/pay/:token` → `trial-recovery { token, action: "view" }`, Pay → `{ token, action: "pay" }` → Payment Element with the
  PaymentIntent `client_secret` → `stripe.confirmPayment`.
- Home: days-left banner while `status = trialing`.

**Marketing:** replace `/trial` and `/trial/verify` with redirects to checkout; remove the automatic `startTrial` on sign-in and
the "no credit card" copy (Codex finding 11 lists the exact files in snapshot `d4c78849`).

## Release checklist (each line needs David's approval; none given)

1. **Codex review of the code PR.**
2. **`TASK-0058` A0** (Dev-pointed checkout frontend) — prerequisite for proving setup in the browser with test cards.
3. **Development:** ~~apply both migrations; deploy~~ done 2026-10-18 (above). Still to do there: secrets, Vault, schedules,
   and the A0 browser test. Originally: deploy `stripe-webhook`, `create-checkout-session`, `create-parent-payment-link`,
   `get-checkout-status`, `resolve-parent-link`, `deliver-transactional-email`, `start-trial`, `charge-due-trials`,
   `cancel-trial`, `trial-recovery`, `get-trial-status` (`config.toml` sets `verify_jwt`). Claude's attempt to deploy slice 0 to
   Development on 2026-10-18 was blocked by the session's permission classifier; it was not retried.
4. **Secrets (each environment):** `TRIAL_ADMISSION_ENABLED`, `TRIAL_TERMS_VERSION`, `TRIAL_CHARGES_ENABLED`,
   `TRIAL_CHARGE_WORKER_SECRET`, `TRIAL_NOTICES_ENABLED`, `MARKETING_BASE_URL`, `STUDENT_APP_URL` (the app, `https://app.cramapple.com`, for
   trial email links), `CARDLESS_TRIAL_RETIRED`, `LOOPS_PARENT_TRIAL_REQUEST_TRANSACTIONAL_ID`, and 19 Loops template
   ids `LOOPS_TRIAL_<KIND>_<PAYER|STUDENT>_TRANSACTIONAL_ID` for kinds `TRIAL_STARTED, REMINDER, PAYMENT_FAILED,
   REQUIRES_ACTION, GRACE_ENDED, DELAYED_CHARGE, CANCELED, CONVERTED, REFUNDED`, plus
   `LOOPS_TRIAL_TRIAL_STARTED_LEARNER_TRANSACTIONAL_ID` (a student paying for their own trial). Vault: the four entries in migration
   `20261018191935`. Then `scripts/task0077/schedule_workers.sql`.
5. **Stripe dashboard:** add webhook events `payment_intent.succeeded`, `payment_intent.payment_failed`,
   `payment_intent.processing`, `payment_intent.canceled`, `charge.dispute.created`; turn on Radar "Use Radar on payment methods
   saved for future use"; Terms URL in public business details (for the parent's Terms checkbox); Apple Pay domain
   (`TASK-0058` E) for wallets.
6. **Loops:** design and publish the 19 templates (variables listed in `_shared/trial-notices.ts` `noticeVariables`).
7. **Lawyer:** the trial section of the Terms, the checkout mandate text (`mandateText`, `parentMandateText` in
   `_shared/trial-core.ts`) and the notice emails, if not already reviewed (`DECISION-0126` item 27). Terms §12.2
   (Free Trials) aligned by David 2026-10-18. Both mandate texts now also say "Cancelling ends trial access right
   away." (David, 2026-10-18), because DECISION-0126 ends access on cancel and buyers otherwise expect access until
   the trial's end date.
8. **Production** (plan §8 slices 7–9): verify the `growth_event_outbox_event_name_check` definition on Production matches the
   migration's list before applying; deploy dormant (`TRIAL_ADMISSION_ENABLED=false`, `TRIAL_CHARGES_ENABLED=true`, notices on,
   heartbeat green); Lovable publish of both checkouts + app + `/trial` retirement together; David's disclosed $1 live trial with a
   per-order exception, conversion, refund; then admission on (only after item 9 passes); then `CARDLESS_TRIAL_RETIRED=true`.
   *Order as found 2026-10-20 (see "Production readiness check"):* (a) PR #507 merged after Codex; (b) the Loops email
   foundation first: migrations `20261006084914` and `20261006143000`, `deliver-transactional-email`, its secrets
   (`LOOPS_PAYMENT_EMAILS_ENABLED=false` until templates exist) and Vault; (c) the three trial migrations, then every
   function from `main` (diff Production before each deploy), dormant secrets, Vault, `schedule_workers.sql`; (d) only
   then the five Stripe webhook events; (e) Loops reactivated and templates published, notices on; (f) Lovable publish
   of marketing (`VITE_TRIAL_CHECKOUT_ENABLED=true`) and app together; (g) the $1 live trial; (h) admission on.
9. **Production sign-in code email (David, Hard-Gate; before admission on).** Trials no longer send an invite (2026-10-19), so a
   new trial student's first auth email is **"Confirm sign up"**, sent when they first request a code. On Production, request a
   code for a brand-new, unconfirmed account and confirm the email carries the 6-digit code (and a plain `cramapple.com/welcome`
   link, never a one-browser confirmation link), then sign in with that code. Check whichever path Production uses: the
   dashboard "Confirm sign up" template over custom SMTP (recorded with `{{ .Token }}` on 2026-10-04), or, if the Send Email
   hook (`send-auth-email`) has been switched on, the published Loops **signup** template (`LOOPS_SIGNUP_TRANSACTIONAL_ID`).
   Development failed this check on 2026-10-19 (stock templates, Site URL the old Vercel site); see "New-student sign-in test".

## Known limits and open items

- **No account-deletion path exists** in the backend today. `trial_orders.user_id … on delete restrict` makes any deletion
  (including an operator's) fail while the learner has **any** trial order, cancelled or not: cancelling keeps the order row
  and its `user_id` (Codex, 2026-10-19, reproduced locally). A deletion path must be designed (what to keep for payment
  records, what to anonymise) before account deletion is offered.
- **Promo parity with Stripe** is tested against our own rules, not yet against Stripe test mode (plan §6.9 parity tests need A0 /
  Dev Stripe keys).
- **Unverified Stripe behaviours** (plan §9): setup + Elements rendering, wallets in setup mode, the hosted Terms checkbox, and
  `allowed_payment_method_types` at runtime on Dahlia.
- `refuse()` before activation clears `promo_use_state` to null (counted as released).
