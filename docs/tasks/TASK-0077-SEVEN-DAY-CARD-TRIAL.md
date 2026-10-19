# TASK-0077 — Seven-Day Free Trial With a Saved Card

**Status:** Backend built and tested; **deployed to Development 2026-10-18 with every trial switch off** (see "Development
deployment" below). Nothing in Production. Frontend (Lovable) not started.
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
5. Return page: `get-checkout-status` answers `billing_mode: "trial"`, `trial_status`, `trial_ends_eastern`.

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
   trial email links), `CARDLESS_TRIAL_RETIRED`, `LOOPS_PARENT_TRIAL_REQUEST_TRANSACTIONAL_ID`, and 18 Loops template
   ids `LOOPS_TRIAL_<KIND>_<PAYER|STUDENT>_TRANSACTIONAL_ID` for kinds `TRIAL_STARTED, REMINDER, PAYMENT_FAILED,
   REQUIRES_ACTION, GRACE_ENDED, DELAYED_CHARGE, CANCELED, CONVERTED, REFUNDED`. Vault: the four entries in migration
   `20261018191935`. Then `scripts/task0077/schedule_workers.sql`.
5. **Stripe dashboard:** add webhook events `payment_intent.succeeded`, `payment_intent.payment_failed`,
   `payment_intent.processing`, `payment_intent.canceled`, `charge.dispute.created`; turn on Radar "Use Radar on payment methods
   saved for future use"; Terms URL in public business details (for the parent's Terms checkbox); Apple Pay domain
   (`TASK-0058` E) for wallets.
6. **Loops:** design and publish the 18 templates (variables listed in `_shared/trial-notices.ts` `noticeVariables`).
7. **Lawyer:** the trial section of the Terms, the checkout mandate text (`mandateText`, `parentMandateText` in
   `_shared/trial-core.ts`) and the notice emails, if not already reviewed (`DECISION-0126` item 27).
8. **Production** (plan §8 slices 7–9): verify the `growth_event_outbox_event_name_check` definition on Production matches the
   migration's list before applying; deploy dormant (`TRIAL_ADMISSION_ENABLED=false`, `TRIAL_CHARGES_ENABLED=true`, notices on,
   heartbeat green); Lovable publish of both checkouts + app + `/trial` retirement together; David's disclosed $1 live trial with a
   per-order exception, conversion, refund; then admission on; then `CARDLESS_TRIAL_RETIRED=true`.

## Known limits and open items

- **No account-deletion path exists** in the backend today. `trial_orders.user_id … on delete restrict` makes any deletion
  (including an operator's) fail until the learner's trials are cancelled with `cancel-trial` / `app.trial_cancel`.
- **Promo parity with Stripe** is tested against our own rules, not yet against Stripe test mode (plan §6.9 parity tests need A0 /
  Dev Stripe keys).
- **Unverified Stripe behaviours** (plan §9): setup + Elements rendering, wallets in setup mode, the hosted Terms checkbox, and
  `allowed_payment_method_types` at runtime on Dahlia.
- `refuse()` before activation clears `promo_use_state` to null (counted as released).
