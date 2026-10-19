# TASK-0077 — Seven-Day Free Trial With a Saved Card

**Status:** Backend built and tested; **deployed to Development** 2026-10-18, QA fixes 2026-10-19. On Development, trial
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

## Frontend contract (for the Lovable work; not started)

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
9. **Production sign-in code email (David, Hard-Gate; before admission on).** Trials no longer send an invite (2026-10-19), so a
   new trial student's first auth email is **"Confirm sign up"**, sent when they first request a code. On Production, request a
   code for a brand-new, unconfirmed account and confirm the email carries the 6-digit code (and a plain `cramapple.com/welcome`
   link, never a one-browser confirmation link), then sign in with that code. Check whichever path Production uses: the
   dashboard "Confirm sign up" template over custom SMTP (recorded with `{{ .Token }}` on 2026-10-04), or, if the Send Email
   hook (`send-auth-email`) has been switched on, the published Loops **signup** template (`LOOPS_SIGNUP_TRANSACTIONAL_ID`).
   Development failed this check on 2026-10-19 (stock templates, Site URL the old Vercel site); see "New-student sign-in test".

## Known limits and open items

- **No account-deletion path exists** in the backend today. `trial_orders.user_id … on delete restrict` makes any deletion
  (including an operator's) fail until the learner's trials are cancelled with `cancel-trial` / `app.trial_cancel`.
- **Promo parity with Stripe** is tested against our own rules, not yet against Stripe test mode (plan §6.9 parity tests need A0 /
  Dev Stripe keys).
- **Unverified Stripe behaviours** (plan §9): setup + Elements rendering, wallets in setup mode, the hosted Terms checkbox, and
  `allowed_payment_method_types` at runtime on Dahlia.
- `refuse()` before activation clears `promo_use_state` to null (counted as released).
