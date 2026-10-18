# Seven-Day Free Trial With a Saved Card — Implementation Plan v2

**Status:** v2 DRAFT for Codex re-review. **Nothing is built, deployed or configured.**
**Task:** `TASK-0077`. **Tier:** Hard-Gate (payments, Production migrations and function deploys, secrets, Stripe configuration,
Lovable publish, Terms change).
**Product Owner:** David Bloom. **Author:** Claude. v1 2026-10-18; v2 2026-10-18.
**Governing decision:** `DECISION-0126`, items 1–27 (item 9 amended).
**Review of v1:** Codex, PR #505, `docs/qa/TASK0077_CODEX_PLAN_REVIEW_2026_10_18.md` on `codex/task-0077-plan-review` (verdict
"Not ready", 13 findings). §10 maps each finding to its fix in this version.
**Related:** `DECISION-0090` (partly revised by item 2), `TASK-0026` (cardless trial, retired by item 12), `TASK-0058` A0,
`docs/product/PURCHASE_FUNNEL_TECHNICAL_SPEC_2026_09_27.md`.

Evidence labels:
- **Verified:** read in the repo at `f2b7bfbd`, in Stripe's docs, or in Codex's named Development or Lovable checks.
- **Unverified:** not demonstrated.
- **Proposed:** design, not existing behaviour.

---

## 1. What we are building, in one paragraph

Every checkout (the student's own and the parent link) saves a card without charging it. The selected subjects get 7 days of
access. On day 7, the saved card is charged once, off-session, for the price locked at signup, promo included. The student and
whoever pays both accept the Terms. A failed charge gets one day of grace and one retry, then 30 days to pay voluntarily. Cancelling
ends access at once and stops every future charge. One trial per student email, ever. The cardless trial is retired.

## 2. Product rules (`DECISION-0126`)

| # | Rule |
|---|---|
| 1, 7 | Every purchase gets the trial on what was bought, starting at checkout; $1 and 50%-off codes included; a $0 total skips the trial |
| 2 | Parent-pay gets the trial; the parent's card is saved only for this one charge (partly revises `DECISION-0090`) |
| 3 | Price is locked at signup; an expired or exhausted code never raises the day-7 charge |
| 4, 10, 19 | Cancel ends access immediately and stops future charges; a student may cancel a parent's trial; an in-flight charge that succeeds is refunded automatically; "cancelled, no charge" only once the outcome is known |
| 5, 15 | Failed charge: one day of grace and one retry, then access lapses; 30 days of voluntary recovery at the locked price, no automatic retries |
| 6, 9 | One trial per student email, ever; the payer's email is not checked (parents may trial for each child) |
| 8, 11, 17 | Student always acknowledges the Terms; whoever pays accepts them; one action on direct checkout, two on parent-pay |
| 11, 13 | On parent-pay, every trial email goes to both parent and student; the student's email is required before the link exists |
| 12 | Cardless `trial_v1` retired |
| 14, 25 | A parent whose own email already had a trial can still start trials for students: accepted, no handling |
| 16, 20 | If our system delays a charge: 48 hours' notice first, and access continues until then |
| 18 | Day-7 charge is a direct off-session PaymentIntent (no invoice) |
| 21 | Promo limits tracked in our own records for trials; the race with other Stripe redemptions is accepted |
| 22 | Parent-pay: the student applies the code before creating the link; it is fixed into the link |
| 23 | Pay-now add-on returns for direct single-subject conversions **after launch** (out of scope here) |
| 24 | Student and parent trials launch together, after both are proven in Development |

## 3. Current state (Verified at `f2b7bfbd`; corrections from Codex marked ✱)

- **Direct checkout** is `mode: "payment"`, `ui_mode: "elements"`, `customer_creation: "always"`, `setup_future_usage: "off_session"`.
  Sources: `create-checkout-session/index.ts:201,233,236-237`. The offers are `single`, `bundle_2` and `bundle_3` (no direct
  `unlimited`): `_shared/stripe-catalog.ts:16-82`, checkout `:48-80,149-152`.
- **Promo** lookup takes the first active match (`:82-95`; parent `create-parent-payment-link/index.ts:53-62`). Payment-mode Checkout
  enforces the restrictions.
- **Fulfilment** grants lifetime `paid` when `payment_status` is `paid` or `no_payment_required` (`_shared/checkout-access.ts:23-27`;
  `stripe-webhook/index.ts:204-229,435-458`).
  - ✱ The local Session type lacks Stripe `mode` and `setup_intent` (`:40-80`).
  - ✱ A missing `payment_status` passes the gate.
  - ✱ `stripe_checkout_sessions.mode` stores the **offer** from `metadata.mode` (`:183`, `:338`).
- **Customer mapping** `app.stripe_customers` holds one row per user (migration `20260928134000:61-75`).
  - The write helper `persistStripeCustomer` has **no payer guard**; only one call site checks (`stripe-webhook:293-317,403-405`).
  - ✱ The add-on creates a new **on-session Elements Checkout** for the mapped customer. It does not charge off-session
    (`create-post-purchase-addon/handler.ts:102-143`).
- **Refunds** map PaymentIntent → Checkout Session (`stripe-webhook:594-643`; refund email `:555-587`). Receipts need a paid Session
  (`:535-551`).
- **Events:** unknown event types throw (`:746-786`). The ledger dedupes **events, not obligations**; it can reclaim after 5 minutes
  (`20260928191213:29-55`).
- **Access gate:** `authorize_grading_access` checks status plus `starts_at`/`ends_at` (`20260815181856:25-36`).
  - Entitlement uniqueness is `(user_id, subject_id, access_tier, source)`.
  - Entitlements require `ends_at > starts_at` (`20260731160200:8-27`).
- **Cardless trial:**
  - `start-trial` sends its Loops event only when `marketing_email_opt_in` is true (`start-trial/index.ts:93-104`).
  - ✱ It is still called by the live marketing Lovable source (`61dd6602`, snapshot `d4c78849`): `src/lib/trial.ts:29-37`,
    `src/routes/trial.tsx:49` (auto-starts on sign-in; `:241` promises "no credit card"), and `src/routes/trial.verify.tsx:32`.
  - The app `56cae479` redirects `/trial` to marketing.
- **Scheduling, Development only:** ✱ `pg_cron 1.6.4`, `pg_net 0.20.3` and Vault are installed. Three jobs exist, and **none
  triggers `deliver-transactional-email`**. Production is Unverified.
- **Parent emails:** the lifecycle emails are unpaid-link reminder/expiry only; they need an integer `amount_total` and `unpaid`
  (`_shared/parent-email-lifecycle.ts:83-95,380-386`).
  - ✱ The short-link resolver treats any completed Session as paid (`_shared/parent-short-link.ts:57-67`).
  - ✱ Short codes are 8 random characters, unsigned and reusable (`:7-25`).
- ✱ **SDK:** `_shared/stripe.ts:1` imports floating `stripe@17` and casts the API version `2026-03-25.dahlia`. `stripe-node v22.0.0`
  matches that API version.

## 4. Slice 0 — fail-closed webhook routing (ships first, alone, safe with the trial off)

1. Extend the local Session type with Stripe `mode` and `setup_intent`. Rename internal uses so that `stripe_session_mode` (Stripe's)
   and `offer` (ours) are distinct. Keep a compatibility read of `metadata.mode` for existing sessions.
2. Route `checkout.session.*` **before** any persistence of fulfilment-style data, grant, email or event:
   - `mode === "payment"`: today's path, with `payment_status` **required** and one of `paid`/`no_payment_required` (keeps the $0
     coupon path).
   - `mode === "setup"`:
     - If the metadata has `kind === "trial_setup"` and a matching `trial_orders` row exists, use the trial handler (§6.4).
     - Otherwise **quarantine**: record the session, alert, no grant, no email. A valid signature alone never makes an eligible
       trial.
   - Anything else (`subscription`, unknown): record and ignore with an alert. Never grant.
3. Tests:
   - a setup session never reaches `grantEntitlements` and never emits `purchase_completed`, a receipt or an add-on offer;
   - an ordinary paid purchase still works;
   - an ordinary $0 purchase still works;
   - a parent-share purchase still works;
   - refunds are unchanged.

## 5. Slice 1 — SDK pin (before any new Stripe call)

- Pin an exact `stripe-node` version compatible with `2026-03-25.dahlia` (v22.0.0 per Codex) and remove the version cast.
- Use the pinned vocabulary: `hosted_page`, `elements`, `allowed_payment_method_types: ["card"]`, and the `PromotionCode` shape (top
  level `customer`, coupon under `promotion.coupon`).
- Run the regression suite for the paid, $0, parent, add-on and refund paths.
- First Development spike: confirm that `mode: "setup"` + `ui_mode: "elements"` renders the Payment Element and the Express Checkout
  Element on our page. **If it does not, stop and revise the frontend design before slice 3.**

## 6. Order engine (proposed)

### 6.1 Tables (one additive migration; RLS forced; service-role only; client grants revoked)

**`app.trial_orders`**

| Group | Columns |
|---|---|
| Identity | `id uuid pk`, `purchase_type` (`student_direct` / `parent_share`), `student_email`, `student_email_norm` (`lower(trim())`), `user_id null` |
| Purchase | `offer`, `subject_ids uuid[]` (real subject UUIDs) + `subject_keys text[]` (display snapshot), `price_id`, `currency` |
| Locked quote | `list_amount`, `discount_amount`, `charge_amount`, `quote_version`, `quote_expires_at`, `promotion_code_id`, `coupon_id`, `promo_code`; check constraint `list_amount - discount_amount = charge_amount`, amounts ≥ 0, `charge_amount ≥` Stripe minimum (50¢ USD) |
| Stripe | `checkout_session_id`, `setup_intent_id`, `stripe_customer_id`, `payment_method_id`, `card_fingerprint`, `payment_intent_id`; partial unique indexes on each non-null |
| Payer | `payer_email` (captured from completed setup, not from the request), `payer_is_learner bool` |
| Consent | `student_ack_version`, `student_ack_at`, `student_ack_source`; `payer_accept_version`, `payer_accept_at`, `payer_accept_source`; `mandate_text_version`, `mandate_shown_amount`, `mandate_shown_date_rule`; `consent_ip`, `consent_user_agent` (retention defined, never card data) |
| Clock | `trial_started_at` (immutable, from Stripe setup completion time), `trial_ends_at` (= start + 7 days, set once), `first_failure_at`, `grace_ends_at` (= `trial_ends_at` + 24 h, set once), `recovery_expires_at` (= `grace_ends_at` + 30 days), `canceled_at`, `converted_at` |
| State | `status`, `attempt_count` (business attempts only, max 2), `next_attempt_at`, `lease_token`, `lease_expires_at`, `last_error_code`, `last_decline_code`, `reconcile_reason` |

- **Eligibility:** unique index on `student_email_norm` `where trial_started_at is not null`. This covers every later status, so an
  email can never get a second trial.
- A second unique partial index allows one `pending_setup` row per `student_email_norm`.
- Pending rows expire at `quote_expires_at` (24 h, matching the Session lifetime) and are cleaned up by the job.

**`app.trial_promo_uses`** (`DECISION-0126` item 21)

- Columns: `order_id`, `promotion_code_id`, `coupon_id`, `state` (`reserved` / `redeemed` / `released`), timestamps.
- Reserve at quote time. Become `redeemed` when the trial starts (the price is locked from then). Release on pending expiry.
- Cancelled, failed and refunded trials keep their use. The code was granted; this avoids "unredeeming".

**`app.trial_capabilities`** (cancel and recovery links)

- Columns: `id`, `order_id`, `purpose` (`parent_cancel` / `payer_recovery`), `token_hash` (SHA-256 of a 32-byte random token; the raw
  token exists only in the email), `expires_at`, `used_at`.

### 6.2 State machine

| From | To | Trigger | Invariant |
|---|---|---|---|
| — | `pending_setup` | quote + Session created | eligible at creation; promo reserved; no access |
| `pending_setup` | `trialing` | verified setup completion (§6.4) | in **one transaction**: recheck eligibility under lock; set the clock once; create the PaymentIntent reference (§6.5); grant this order's trial rows; mark the promo use redeemed; enqueue notices for both recipients |
| `pending_setup` | `setup_expired` | Session expired or quote expired | release the reservation; the email is not consumed |
| `trialing` | `charging` | claim with lease token at `trial_ends_at` | only rows due; compare-and-set on `lease_token` |
| `charging` | `converted` | `payment_intent.succeeded` for this order's PI | in one transaction: grant `paid` (source `stripe_trial_conversion_<offer>`); **revoke this order's trial rows**; enqueue receipt and conversion notices |
| `charging` | `payment_failed` | definite decline | first failure only: set `first_failure_at`, extend this order's trial rows to `grace_ends_at`; schedule one retry at `grace_ends_at` − 1 h |
| `charging` | `requires_action` | `authentication_required` | same grace extension; no automatic retry; payer recovery notice |
| `payment_failed` / `requires_action` | `recovery_only` | grace ends unpaid | access lapses (the gate does it); no automatic attempts; recovery open until `recovery_expires_at` |
| `recovery_only` | `converted` | payer completes recovery | as above |
| `recovery_only` | `recovery_expired` | `recovery_expires_at` | cancel the PI; detach a parent card |
| any pre-conversion state | `canceled` | §6.7 | revoke this order's trial rows; stop collection; outcome-dependent message |
| `converted` | `refunded` | full refund | revoke this order's paid rows only; a partial refund keeps access |
| `charging` (lease expired) / any unknown outcome | `reconciling` | process death, network error, contradiction | **retrieve the order's PI and act on its real status**; never create another charge; operator alert if unresolved |
| `trialing` (overdue, scheduler down) | `delayed_notice` | §6.8 | access extended; 48 h notice queued |

- All transitions run in service-only, fixed-`search_path` RPCs: `app.trial_activate`, `app.trial_claim_due`, `app.trial_mark_*`,
  `app.trial_cancel`.
- Each RPC locks the order row, checks the expected `from` state, and writes the order, entitlements, promo use and outbox together.
- Stripe calls happen outside these transactions. Their results are written back by compare-and-set on `lease_token`, so an old
  worker cannot overwrite newer state.
- Late or out-of-order events never move a `converted`, `canceled` or `refunded` order backwards. A contradiction goes to
  `reconciling` with an alert.

### 6.3 Quote and start — direct checkout (`create-checkout-session`)

The **server** decides the billing mode; a client `trial` flag is not trusted. Steps:

1. Resolve the offer, the Price (retrieve `unit_amount`; require fixed USD one-time, quantity 1) and the student email.
2. Check eligibility: no `trial_orders` row with `trial_started_at` for `student_email_norm`, and no legacy `trial_v1` entitlement on
   the student's user (backfilled by email, §6.11).
3. Evaluate the promo with our own evaluator (§6.9). If the total is 0, return billing mode `pay_now_zero` and use today's
   payment-mode path.
4. If ineligible, return billing mode `pay_now` and use today's path. The page must show pay-now copy. The server rejects a confirm
   that carries a stale `quote_version` from a trial quote, so nobody is charged today after seeing trial copy.
5. If eligible, return billing mode `trial`, with a display contract the page must render:
   - list price, discount, charge amount;
   - the charge date rule ("7 days after you start");
   - `quote_version`;
   - `mandate_text_version`;
   - the Terms version.
6. On confirm, the request must carry `student_ack: true` with the shown versions. A **reused** `pending_setup` order for the same
   email is updated in place (idempotent edits), not duplicated. Then:
   - Get or create the Stripe Customer: the student's own mapping if signed in, otherwise a new Customer with an idempotency key
     `trial-cust:<order>`.
   - Create the Session (idempotency key `trial-setup:<order>:<quote_version>`):
     ```
     mode: "setup", ui_mode: "elements", currency: "usd", customer,
     allowed_payment_method_types: ["card"],
     return_url: …/checkout/return?session_id={CHECKOUT_SESSION_ID}&role=student,
     setup_intent_data: { description, metadata: { trial_order_id } },
     metadata: { kind: "trial_setup", trial_order_id, quote_version }
     ```
7. The page shows the mandate beside the button: "$0 today. On <date> we'll charge $X to this card unless you cancel. Cancel any
   time in Account." It also shows the required Terms checkbox. On direct checkout that one action is both the student
   acknowledgment and the payer acceptance (item 17).

### 6.4 Activation (webhook, `mode === "setup"`)

1. Retrieve the SetupIntent with `payment_method` expanded. Require all of:
   - `status === "succeeded"`;
   - `usage === "off_session"`;
   - `customer` equals the order's customer;
   - the PaymentMethod is attached to that customer.

   Any mismatch quarantines the order (`reconciling`). Never call `attach` to repair a mismatch.
2. Parent-pay only:
   - require `session.consent.terms_of_service === "accepted"` (or the fallback acceptance, §6.10);
   - capture `payer_email` from `customer_details.email`.
3. Resolve or invite the learner from `student_email`, exactly as today (`stripe-webhook:262-291`).
4. Call `app.trial_activate`:
   - `trial_started_at` = the Session's completion time from the event object, not handler time; replays cannot move it;
   - everything listed for `pending_setup → trialing` in §6.2.
5. Create the order's **single PaymentIntent** now, unconfirmed:
   ```
   paymentIntents.create(
     { amount: charge_amount, currency, customer, payment_method,
       description, statement_descriptor_suffix,
       metadata: { kind: "trial_conversion", trial_order_id } },
     { idempotencyKey: "trial-pi:<order>" })
   ```
   Persist `payment_intent_id`.
   - If the handler dies first, a replay uses the same idempotency key (inside Stripe's 24 h retention).
   - The claim job never charges an order without a persisted `payment_intent_id`. It reconciles via
     `paymentIntents.search` on `metadata['trial_order_id']` before creating one.
6. **Direct only:** upsert `stripe_customers` with the guard inside the helper (§6.10).
7. `get-checkout-status` and the parent short-link resolver report `trialing` (with the end date) for setup sessions. Never "paid";
   never an upsell.

### 6.5 Collection (new `charge-due-trials` function)

- **Trigger:** a pg_cron job every 5 minutes calls a service-only wrapper. The wrapper uses `pg_net` with the URL and Bearer token
  from Vault, following the `app.byoq_invoke_purge()` pattern.
  - The function verifies `TRIAL_CHARGE_WORKER_SECRET`. Gateway JWT verification must be configured compatibly; test that an
    unauthorized request is rejected.
  - Kill switch: `TRIAL_CHARGES_ENABLED`.
  - Heartbeat: every run writes `app.worker_heartbeats`. An alert fires if it is stale for more than 30 minutes.
- **Claim:** `app.trial_claim_due(limit, lease_seconds)` returns rows that are `trialing` and due, `payment_failed` and due for their
  one retry, or `charging` with an expired lease. Expired-lease rows go to reconciliation first.
- **Per claimed row:**
  - `retrieve` the PI.
  - If it is already `succeeded` or `processing`, write that back and stop.
  - Otherwise `paymentIntents.confirm(pi, { payment_method, off_session: true })`, with idempotency key
    `trial-confirm:<order>:<attempt_count>`. The confirm counts as a business attempt; HTTP retries reuse the same key and parameters.
- **One PaymentIntent per order, for life.** The retry, the payer's recovery and any outage-delayed charge all confirm **the same
  PI**. This is what prevents double charging (Codex finding 3).
- **Outcomes:**
  - `succeeded`: wait for the webhook to convert. The worker only records an "observed" note.
  - Card decline: `payment_failed` (first time, grace).
  - `authentication_required`: `requires_action`.
  - Network error or 5xx: `reconciling`. **A transport error is never treated as a decline and never triggers a new attempt.**
- **Webhook additions:** `payment_intent.succeeded`, `payment_intent.payment_failed`, `payment_intent.processing`,
  `payment_intent.canceled`, routed by `metadata.kind === "trial_conversion"` to an order-driven handler. `charge.refunded` is extended
  (§6.8). **The Stripe endpoint's event subscription must add these (David).**

### 6.6 Failure, grace and recovery (items 5, 15)

- Grace is applied once: `grace_ends_at = trial_ends_at + 24h`. This order's trial rows are extended to it, idempotently. Later
  failures and replays never extend it again.
- One automatic retry, at `grace_ends_at − 1h`, for retryable declines only (`insufficient_funds`, `processing_error`,
  `try_again_later`).
  - Hard declines (`stolen_card`, `lost_card`, `expired_card`, `incorrect_number`) and `authentication_required` get no automatic
    retry.
  - If the worker reaches a retry after `grace_ends_at`, it does not charge; the order goes to `recovery_only`.
- **Recovery page** `app.cramapple.com/trial/pay/<token>` (a `payer_recovery` capability, sent to the payer only):
  - `GET` shows the amount, the order and the status. It mutates nothing, so email scanners are safe.
  - `POST` returns the **same PI's** client secret. The page confirms it on-session with Stripe.js, either authenticating the saved
    card or entering a new one in the Payment Element.
  - Success goes through the same webhook conversion.
  - The capability works until conversion, cancel or `recovery_expires_at`. A browser or 3DS interruption can resume with the same
    token.
- Access after grace lapses through the gate. During the 30 days there are no automatic attempts. At expiry the PI is canceled and a
  parent's card detached.

### 6.7 Cancellation (items 4, 10, 19)

- **Routes:**
  - A signed-in student cancels from Account. This works for their own trial or a parent's: the order's `user_id` must match.
  - A parent uses a `parent_cancel` capability. `GET` confirms; `POST` acts.
- `app.trial_cancel` locks the order and **always** stops future collection: status `canceled`, no more claims, capabilities voided.
  It revokes this order's trial rows (`status='revoked'`, `ends_at=now()`). Then, by PI state (retrieved after the lock):

  | PI state | Action | Message |
  |---|---|---|
  | `requires_payment_method` / `requires_confirmation` / `requires_action` | cancel the PI | "Cancelled. You won't be charged." |
  | `processing`, or the order was `charging` with the outcome unknown | mark `cancel_pending_outcome` | "Cancelled. A charge was already being processed; if it goes through we'll refund it in full automatically." |
  | `succeeded` (charge landed first) | full refund (idempotency key `trial-cancel-refund:<order>`) | "Cancelled and refunded." Sent only after the refund is created |

- A late `payment_intent.succeeded` on a canceled order triggers the automatic full refund. It never grants access.
- Emails go to the payer and, on parent-pay, to the student. The cancel screen says buying again is pay-now (item 6).
- PaymentMethod cleanup is a retryable job:
  - **Parent cards:** always detached.
  - **Direct cards:** never detached, since they may back other direct purchases.

### 6.8 Refunds and the order resolver

- A shared resolver maps PI → `trial_orders` for receipts, refund emails and revocation. The order is found by
  `trial_orders.payment_intent_id`, and also by `metadata.trial_order_id` as a cross-check.
- It validates `amount_received`, currency and customer against the locked order.
- `charge.refunded`: a full refund revokes **this order's** conversion rows and sets `refunded`. A partial refund keeps access.
- Session-based refund handling stays as-is for pay-now orders.
- Receipts reuse the charge-based payer-receipt builder through an order adapter. Stripe's charge receipt is the receipt; no invoice
  (item 18).

### 6.9 Promo evaluation (our own; Stripe applies none in setup mode)

Against the pinned `PromotionCode`/`Coupon` schema:

- **Code:** `active`, `expires_at`, top-level `customer` restriction, `max_redemptions` vs `times_redeemed` + our `redeemed` +
  `reserved` uses.
- **Coupon** (`promotion.coupon`, expanded): `valid`, `redeem_by`, coupon `max_redemptions` vs `times_redeemed` + ours,
  `applies_to.products` (must include the Price's product), `currency` and `currency_options` for `amount_off`, and `percent_off`.
- **Restrictions:** `minimum_amount` + `minimum_amount_currency` (and currency options).
  - `first_time_transaction`: evaluated against the actual customer when known (signed-in direct). For a new customer or parent-pay,
    treat it as satisfied only when the customer has no prior Cramapple payment by email. Otherwise reject with a clear message.
- **Arithmetic:** integer cents. Percent discount = `round_half_up(list × pct / 100)`, clamped to `[0, list]`. A result between 1¢ and
  49¢ is rejected (Stripe's minimum charge).
- **Lookup:** `promotionCodes.list({ code, active: true })`, then choose the match whose `customer` is null or equals the known
  customer. Never blindly take `data[0]`.
- Unsupported shapes (non-USD price, recurring price, quantity > 1, `duration` other than `once`/`forever` semantics) fail with a clear
  error rather than a guess.
- **Parity tests** against Stripe in test mode: the same code and price in a payment-mode Session must produce the same
  `amount_total`.
- **Accepted race (item 21):** pay-now checkouts, dashboard redemptions and Stripe-side counts are not coordinated with our
  reservations. A small overshoot of `max_redemptions` is accepted.

### 6.10 Parent-pay (items 2, 11, 13, 17, 22)

**Creating the link (student, in the share drawer):**
1. The student picks subjects, applies any promo code (evaluated and **fixed into the link**, item 22) and sees the locked quote.
2. The student **acknowledges the Terms** (student ack recorded on the order).
3. The student enters their own email (required, as today: `create-parent-payment-link/index.ts:79-83`).
4. The server checks eligibility and creates the `pending_setup` order and the link.

**The parent's hosted page:**
- `mode: "setup"`, `ui_mode: "hosted_page"`, `currency: "usd"`, `customer_creation: "always"`, giving an isolated parent Customer.
- `allowed_payment_method_types: ["card"]`.
- `consent_collection: { terms_of_service: "required" }`, which needs the Terms URL in Stripe public details (David).
- `custom_text.submit`: "Free for 7 days. On <date> we'll charge $X to this card for <student first name>'s <subjects> unless you
  cancel."
- `metadata: { kind: "trial_setup", trial_order_id, quote_version }`.
- The parent cannot change the code.
- **Unverified:** that hosted setup mode renders the required Terms checkbox. Fallback if not: a one-step Cramapple page before the
  hosted page where the parent ticks the Terms (recorded with `payer_accept_source='cramapple_prepage'`).

**Isolation (Codex finding 2):**
- The parent's Customer and card live **only on `trial_orders`**.
- `persistStripeCustomer` gets an internal guard: it refuses unless `payer_is_learner` and `purchase_type` is a direct type, so every
  caller is protected.
- The parent customer is never looked up for any student checkout. The charge uses the order's explicit `payment_method`, never a
  customer default.
- The parent card is detached after conversion, cancel or recovery expiry (retryable job).
- Test: a student's existing `stripe_customers` row is unchanged throughout a parent trial.

**Links and emails:**
- The short-link resolver learns `trialing` / `canceled` / `converted` from the order. A completed setup Session is **not** "paid".
- The parent request email and the drawer say "Free for 7 days, then $X on the day the trial ends". They never compute $0 from a
  null `amount_total`.
- The old unpaid-link reminder/expiry jobs apply only to `pending_setup`, and are cancelled at activation.

### 6.11 Eligibility (items 6, 9, 14)

- One trial per `student_email_norm`, ever. Enforced by the unique index (§6.1) and rechecked under lock at activation, so a direct
  checkout and a parent link cannot both start.
- **Legacy backfill** (in the migration): for each user with any `trial_v1` entitlement (any status), insert a consumed marker for
  their current auth email. This means an `app.trial_consumed_emails(email_norm, source, consumed_at)` table that the index check
  also reads.
- Markers survive account email changes and deletion. Retention: indefinite, email-hash only (approved, item 26).
- No plus-address or dot folding, and no fingerprint check.
- The payer's email is not checked (item 9). Item 14 is accepted as is (item 25).

### 6.12 Billing delays caused by us (items 16, 20)

- An attempt may run only inside its window: first attempt `[trial_ends_at, trial_ends_at + 2h]`; retry `[grace_ends_at − 1h,
  grace_ends_at]`.
- If the worker finds a due row **outside** its window (scheduler down, kill switch, incident), it does not charge. It moves the row
  to `delayed_notice`:
  - extend this order's access to `notice_sent_at + 48h + 1h`;
  - send a notice to the payer (and the student on parent-pay): "We couldn't process your charge on <date> because of a problem on
    our side. We'll charge $X on <date + 48h> unless you cancel";
  - set `next_attempt_at = notice_sent_at + 48h`.

  The price stays locked.
- Turning `TRIAL_CHARGES_ENABLED` off therefore never silently charges late, and never cuts off access because of our outage.

### 6.13 Notifications (items 11, 13, 16, 19, 20)

New order-driven transactional jobs in `app.transactional_email_outbox`:
- independent of marketing opt-in;
- deduplicated on `(order, outcome, recipient)`;
- one email per order, not per subject;
- the state is **rechecked right before sending**, so a stale "please pay" never goes to a converted or canceled order.

| Outcome | Payer | Student (parent-pay) |
|---|---|---|
| Trial started | amount, date, last-4, how to cancel, Terms link | "Your parent started your 7-day free trial of <subjects>" + cancel route |
| Reminder, **day 5 (48 h before)** | amount, date, cancel | same, without payment details |
| Charge failed / action needed | recovery link (capability) | "There was a problem with your parent's payment; access continues until <grace end>" (no link, no card details) |
| Grace ended unpaid | recovery link, 30-day deadline | access paused notice |
| Delayed charge (our fault) | 48 h notice | same, without payment details |
| Cancelled | outcome-specific text (§6.7) | same |
| Converted | receipt | existing "your parent paid" template |
| Refunded | refund notice | access-ended notice when full |

On direct checkout the payer is the student, who gets the payer column.

**Delivery is a release gate:**
- `deliver-transactional-email` must be scheduled (pg_cron → `pg_net`, same pattern). Codex found **no scheduler** in the repo or in
  Development.
- Loops templates published.
- A controlled real-inbox test for every row above.

### 6.14 Retiring the cardless trial (item 12), in order

1. Lovable marketing (`61dd6602`): replace `/trial` and `/trial/verify` with redirects to checkout (handling old verification links).
   Remove the automatic `startTrial` on sign-in and every "no credit card" / every-subject promise.
2. Then deploy `start-trial` returning `410 trial_retired`, and revoke `EXECUTE` on `app.start_trial` from `service_role` too.
3. Existing `trial_v1` rows lapse on their own and count as consumed (§6.11).
4. Remove the opt-in-gated Loops trial event; the card-trial notices replace it.

### 6.15 App and status API

- New authenticated `get-trial-status` returns a sanitized view of the learner's orders: state, subjects, dates, amount, whether
  cancel is possible. The app cannot read `trial_orders` directly.
- No client endpoint can change money, subjects, customer or payment IDs, status or consent versions.
- **App:**
  - Account: trial card with date, amount and Cancel.
  - Home: days-left banner.
  - The recovery page.
  - The parent cancel confirmation page.
- Analytics: add the `trial_card_started`, `trial_converted`, `trial_canceled`, `trial_payment_failed` and `trial_recovered` events
  to `_shared/growth-events.ts:3-21` **and** the database event-name check, in the same migration slice. No `purchase_completed` for
  setup.

## 7. Testing and acceptance

**Prerequisite (`TASK-0058` A0):** a Development-pointed checkout frontend (marketing and app) with Stripe test keys and Dev short
links. Without it, setup can only be proven with live cards. A0 is tracked as its own task and must be done first.

**Development time control:** order timestamps are written through test-only RPCs available only in Development (guarded by a
database setting that is absent in Production), so day 7, grace and recovery expiry can be reached on demand while the real worker
and webhooks run. Stripe test clocks do not move our database clock. Production trial duration is fixed at 7 days.

**Acceptance matrix:** adopt Codex's matrix in full (review §"Acceptance matrix"): basic flows, eligibility races, pricing parity,
setup safety, consent, collection concurrency, cancellation and recovery, failure and grace, refund and replay, notices, app access
across every gated surface, operations, wallet/UI. Additions specific to v2:
- One PI per order across retry, recovery and a delayed charge.
- Kill switch off at day 7 → `delayed_notice` with access extended, no charge, then a charge 48 h after the notice.
- Cancel during `processing` → automatic refund on success, with the correct message sequence.
- A parent trial leaves the student's `stripe_customers` row byte-for-byte unchanged.

**Test cards:** each is validated in Development as setup-then-charge before it is relied on (`4000 0000 0000 9995` may fail at
setup rather than at charge).

## 8. Slices and rollout

| Slice | Content | Gate |
|---|---|---|
| 0 | Fail-closed webhook routing (§4) | Deploy alone to Dev, then Prod (approval) |
| 1 | SDK pin + regression + setup/Elements spike (§5) | Dev; Prod deploy (approval) |
| A0 | Dev checkout frontend (`TASK-0058`) | separate task |
| 2 | Migration: tables, RPCs, indexes, legacy backfill, analytics names, cron jobs **created unscheduled** (§6.1-6.2, §6.11, §6.15) | Dev, then Prod (approval) |
| 3 | Direct + parent setup, activation, status API, short-link and order states (§6.3-6.4, §6.10) | Dev only |
| 4 | Collection, grace, recovery, cancel, refunds, delayed-notice (§6.5-6.8, §6.12) | Dev only |
| 5 | Notifications + email worker schedule + real-inbox tests (§6.13); app UI (§6.15) | Dev only |
| 6 | Full Dev acceptance matrix for **both** flows (item 24) | Codex QA |
| 7 | Prod: deploy everything dormant (`TRIAL_ADMISSION_ENABLED=false`, `TRIAL_CHARGES_ENABLED=true`, worker and email schedules on, heartbeat green). Stripe event subscriptions. Terms published. Lovable publish of both checkouts + app + `/trial` retirement together. | David approvals |
| 8 | David's disclosed $1 live trial using a Production-only per-order exception (approved SQL setting that single order's `trial_ends_at`), conversion, then refund | David |
| 9 | `TRIAL_ADMISSION_ENABLED=true` for both flows at once; then retire `start-trial` (§6.14 step 2) | David |

**Rollback:**
- `TRIAL_ADMISSION_ENABLED=false` stops **new** trials only. Checkout returns to pay-now at once, and the server tells the page the
  billing mode, so copy and charge cannot disagree.
- Existing orders keep their handlers, cancel, status and recovery.
- Pausing charges (`TRIAL_CHARGES_ENABLED=false`) is safe because of §6.12: there are no silent late charges, and access continues
  until 48 h after a notice.
- Migrations are additive; nothing is dropped.

## 9. Still open

- **Unverified Stripe behaviours, settled by the slice 1 spike:**
  - setup + Elements rendering;
  - Express Checkout wallets in setup mode;
  - the hosted-setup Terms checkbox;
  - where `custom_text` appears on the hosted page.

**Closed 2026-10-18:**
- **Item 14:** accepted as is (`DECISION-0126` item 25).
- **Retention:** approved as proposed (item 26). Email markers are kept indefinitely as a hash; consent IP address and user agent are
  kept 2 years.
- **Legal:** the Terms and Privacy Policy are lawyer-reviewed (item 27). **Release-gate check:** if the trial section of the Terms,
  the checkout mandate wording (§6.3 step 7, §6.10) or the notice emails (§6.13) were not part of that review, send that text to the
  lawyer before slice 7.

## 10. Codex findings → v2 changes

| # | Finding | Fixed in |
|---|---|---|
| 1 | Setup guard must be a full routing boundary | §4 |
| 2 | Parent-card isolation contradiction; consent from both | §6.10, §6.3 step 7, §6.1 consent columns |
| 3 | Duplicate collection | §6.5 one PI per order for life; §6.2 lease CAS + `reconciling` |
| 4 | Option B empty invoice | Option A chosen (item 18); invoices removed |
| 5 | Promo evaluator and capacity | §6.9 pinned-schema evaluator; §6.1 `trial_promo_uses`; race accepted (item 21) |
| 6 | Atomic transitions, eligibility, entitlement revocation | §6.2 RPCs; §6.1/§6.11 consumed index + legacy backfill; conversion revokes trial rows |
| 7 | Notices contract and delivery | §6.13, worker scheduling as a release gate |
| 8 | Conversion, recovery and refunds can't reuse Session fulfilment | §6.8 order resolver; recovery confirms the same PI (§6.6) |
| 9 | Trial clock and grace precision | §6.1 clock columns; §6.4 step 4; §6.6; §6.12 windows |
| 10 | SDK pin and setup UI proof | §5 |
| 11 | Live cardless callers; ordered cutover | §6.14; slice 7/9 ordering |
| 12 | Capability links | §6.1 `trial_capabilities`; GET/POST split (§6.6, §6.7) |
| 13 | Launch order and rollback | §8 (both flows together, item 24; dormant deploy; delayed-notice rollback) |

## 11. Asks for Codex's re-review

1. Is "one PaymentIntent per order, created at activation, confirmed at day 7, re-confirmed for the retry and recovery" sound on
   `2026-03-25.dahlia`? Specifically:
   - Can a PI created unconfirmed with a saved PM sit for 7–38 days without expiring?
   - Is re-confirming it off-session after a decline supported?
   - Can it be confirmed on-session with a new card from the recovery page?
2. Is the `delayed_notice` window rule (§6.12) complete for every way the worker can be late?
3. Does §6.7's cancel table cover every PI state, including `requires_capture` (not used, but assert it never appears)?
4. Promo evaluator (§6.9): especially `first_time_transaction` handling for new and parent customers, and `duration` semantics for
   one-time charges.
5. Is the slice order (§8) right? In particular, is deploying slice 0 to Production ahead of everything else safe on its own?
