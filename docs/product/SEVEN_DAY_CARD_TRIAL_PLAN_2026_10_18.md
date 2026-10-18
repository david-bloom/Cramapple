# Seven-Day Free Trial With a Saved Card — Implementation Plan (for Codex review)

**Status:** DRAFT for Codex review. **Nothing is built, deployed or configured.**
**Proposed task:** `TASK-0077` (number unverified against open PRs at review time; renumber if taken).
**Tier:** Hard-Gate (payments, Production migrations and function deploys, secrets, Stripe webhook configuration, Lovable publish, Terms change).
**Product Owner:** David Bloom. **Author:** Claude, 2026-10-18.
**Related:** `TASK-0026` (the existing cardless 7-day trial), `TASK-0041`, `TASK-0058`, `DECISION-0090`, `DECISION-0094`,
`docs/product/PURCHASE_FUNNEL_TECHNICAL_SPEC_2026_09_27.md`, `docs/product/STRIPE_PRODUCTION_CUTOVER_CHECKLIST_2026_09_30.md`.

Evidence labels: **Verified** = read in the repo (file:line) or in Stripe's docs on 2026-10-18. **Unverified** = not checked
against live Production, the live Lovable source or the Stripe dashboard.

---

## 1. What David asked for

A 7-day free trial. **Promo codes must keep working.** The method is Stripe's guidance, which David pasted:

1. A Checkout Session in `mode: 'setup'` saves the card without charging it.
2. `checkout.session.completed` delivers the SetupIntent and its PaymentMethod.
3. We store the trial end date and the customer and payment-method IDs.
4. When the trial ends, a scheduled job charges the card off-session (`off_session: true`, `confirm: true`).

The same guidance comes with three requirements: authenticate the card for off-session use, record explicit consent to the future
charge, and provide a way back for charges that need authentication.

## 2. What exists today (Verified unless marked)

| Area | Current state | Where |
|---|---|---|
| Direct checkout | `mode: "payment"`, `ui_mode: "elements"`, `customer_creation: "always"`, `setup_future_usage: "off_session"` (the card is already saved for reuse) | `supabase/functions/create-checkout-session/index.ts:201`, `:227-238` |
| Pricing | Stripe Price IDs from the `STRIPE_PRICE_CATALOG_JSON` secret. Offers: `single`, `bundle_2`, `bundle_3`, `unlimited` (no `unlimited` on `student_direct`) | `_shared/stripe-catalog.ts:16-82`, `create-checkout-session/index.ts:48-80` |
| Promo codes | Server checks the code with `promotionCodes.list({code, active:true})` and applies `discounts:[{promotion_code}]`; otherwise sets `allow_promotion_codes:true`. **Stripe applies the restrictions** (product limits, minimum amount, max redemptions). No coupon table of our own. | `create-checkout-session/index.ts:82-95`, `:221-223` |
| Fulfilment | Webhook grants `subject_entitlements` `access_tier='paid'`, `ends_at=null` (lifetime), when `payment_status` is `paid` **or `no_payment_required`** | `stripe-webhook/index.ts:204-229`, `:437`; `_shared/checkout-access.ts:23-27` |
| Saved customer | `app.stripe_customers` (one per user: `stripe_customer_id`, `default_payment_method_id`), written only when the payer is the learner | migration `20260928134000:61-75`; `stripe-webhook/index.ts:293-317` |
| Saved-card reuse | Post-purchase add-on already charges the saved card | `create-post-purchase-addon/handler.ts` (~:94-131) |
| Webhook events | `checkout.session.*`, `charge.refunded`, `refund.*`. **Any other event type throws.** | `stripe-webhook/index.ts:746-786` |
| Idempotency | `app.stripe_webhook_events` ledger + `claim_stripe_webhook_event()` | `stripe-webhook/index.ts:694-810`; migration `20260928191213` |
| Access gate | `app.authorize_grading_access`: any `active` entitlement with `starts_at<=now()` and `ends_at` null or in the future, any tier. **An expired trial row loses access without a job.** | migration `20260815181856:1-38` |
| Existing trial | `app.start_trial` grants a **cardless** 7-day `trial` row per active subject (`source='trial_v1'`); `start-trial` edge function; Loops day-5/6/7 emails keyed off `ends_at`. Its frontend went to the legacy `exam-buddy-wireframe` repo. Whether the live Lovable app calls it is **Unverified**. | migration `20260815175854`; `functions/start-trial/index.ts:93-104`; `TASK-0026` |
| Scheduling | `pg_cron` + `pg_net` with an edge-function call pattern (`app.byoq_invoke_purge()` reads URL and token from Vault, cron every 15 min). A due-job queue with leases exists: `parent_email_lifecycle_jobs` + `claim_parent_email_lifecycle_jobs()`. A migration comment says pg_cron is not installed, which contradicts this: **check the live database.** | migrations `20260928160000:193-215`, `20261006143000:67`, `20260821050000:36` |
| Email | Loops via `app.transactional_email_outbox`. The `deliver-transactional-email` worker is not scheduled anywhere in the repo. | `stripe-webhook/index.ts:495-555` |
| Stripe API | Pinned to `2026-03-25.dahlia` | `_shared/stripe.ts:22` |

### 2.1 Stripe facts that shape the design (Verified, Stripe docs 2026-10-18)

- `mode: 'setup'` works with `ui_mode: 'elements'`, our current custom checkout. `currency` is required in setup mode. Pass
  `customer` and Stripe attaches the PaymentMethod to it automatically. Source: "Save a customer's payment method without making a
  payment" (Checkout Sessions variant).
- `line_items` belong to `payment`/`subscription` mode only, so **a setup session has no amount and nothing to discount.** Promo
  codes cannot ride on the setup session; we must evaluate them ourselves.
- `custom_text`, `custom_fields` and `submit_type` are **not allowed with `ui_mode: 'elements'`.** The mandate wording has to live on
  our own page.
- An off-session charge that fails returns HTTP 402 and leaves the PaymentIntent in `requires_payment_method`. Stripe's suggested
  recovery: bring the customer back to a new payment-mode Checkout Session.

---

## 3. Blocking finding: today's webhook would give trial signups lifetime access

A completed setup-mode session reports `payment_status: "no_payment_required"`. `isSettledPaymentStatus` treats that as settled
(it exists for 100%-off coupons), so today's `checkout.session.completed` handler would grant a **lifetime `paid` entitlement** to
anyone who saved a card.

The naming makes this worse: the code uses `metadata.mode` for the offer (`single`/`bundle_2`…; `stripe-webhook/index.ts:338`), and
that is easy to confuse with Stripe's `session.mode`.

**Required before any setup session exists in any environment:** the webhook branches on `session.mode === "setup"` **before** the
payment-status gate and sends those sessions to the trial handler. A unit test asserts that a setup session never reaches
`grantEntitlements`.

---

## 4. Proposed design

### 4.1 Scope

- **In:** `student_direct` (the student's own checkout on `cramapple.com/checkout`).
- **Out, stays pay-now:**
  - `parent_share` / `parent_gift`. `DECISION-0090` says a parent's card is never saved, and a trial needs a saved card. Changing
    that is David's decision (§7, Q2).
  - The post-purchase add-on. The upsell keys on `payment_status='paid'` (`get-checkout-status:133-153`), so it stays hidden during a
    trial without any change.
  - `legacy_authenticated`.
- **100%-off codes:** if the code brings the total to $0, skip the trial and use today's payment-mode path (it already grants on
  `no_payment_required`). Saving a card for a $0 charge adds friction for nothing.

### 4.2 Data model (one additive migration)

New table `app.trial_orders`, service-role only, RLS forced. It mirrors the pattern of `parent_email_lifecycle_jobs`.

| Column | Purpose |
|---|---|
| `id uuid pk` | |
| `user_id uuid null` | Filled at fulfilment (anonymous buyers are resolved or invited by email, as today) |
| `student_email text not null` | |
| `offer text`, `subject_ids text[]`, `price_id text` | What is being bought |
| `list_amount int`, `discount_amount int`, `charge_amount int`, `currency text` | **Server-computed price, locked at signup.** This is the amount stated in the mandate. |
| `promotion_code_id text null`, `coupon_id text null`, `promo_code text null` | |
| `checkout_session_id text unique`, `setup_intent_id text`, `stripe_customer_id text`, `payment_method_id text`, `card_fingerprint text` | |
| `mandate_version text`, `mandate_accepted_at timestamptz`, `mandate_ip inet`, `mandate_user_agent text` | Consent record (Stripe: "keep a record of your customer's written agreement") |
| `trial_started_at`, `trial_ends_at timestamptz` | |
| `status text` | `pending_setup` → `trialing` → `charging` → `converted` / `requires_action` / `payment_failed` / `canceled` / `refunded` / `expired_unpaid` |
| `attempt_count int`, `next_attempt_at timestamptz`, `lease_owner`, `lease_expires_at` | Charge-job claim |
| `payment_intent_id text`, `invoice_id text`, `last_error_code text`, `last_decline_code text` | |
| `created_at`, `updated_at` | |

- Partial unique index: at most one row in a live status (`pending_setup`, `trialing`, `charging`, `requires_action`) per
  `student_email`.
- New function `app.claim_due_trial_charges(limit, lease_seconds)`: `FOR UPDATE SKIP LOCKED` over rows with
  `status='trialing' and trial_ends_at<=now()` or `status='payment_failed' and next_attempt_at<=now()`.
- Entitlements reuse `subject_entitlements`: `access_tier='trial'`, new `source='stripe_trial_v1'`,
  `ends_at = trial_ends_at`, `external_reference = trial_orders.id`.
- On conversion, the existing `paid` grant runs with a new source, `stripe_trial_conversion_<offer>`. The unique key
  `(user_id,subject_id,access_tier,source)` lets the trial and paid rows sit side by side.

### 4.3 Step 1: start the trial (`create-checkout-session`)

Add a `trial: true` request flag, honoured only when `TRIAL_CHECKOUT_ENABLED=true`, `purchase_type='student_direct'` and the buyer is
eligible (§4.8). Server steps:

1. Resolve the offer and Price as today, and **retrieve the Price's `unit_amount`** (needs one Stripe read; the catalog stores IDs
   only).
2. If a promo code is present, look it up as today, then **evaluate it ourselves**, since Stripe will not in setup mode. Checks:
   `active`, `expires_at`, `max_redemptions` against `times_redeemed` **plus our own live trial reservations**, `restrictions`
   (`minimum_amount`, `first_time_transaction`, `customer`), `coupon.valid`, `coupon.applies_to.products` (expand), currency, and
   `percent_off`/`amount_off`. Compute `discount_amount` and `charge_amount`. Return the same `promo_code_invalid` errors as today.
3. If `charge_amount == 0`, fall through to the existing payment-mode path (§4.1).
4. Get or create the Stripe Customer: the `stripe_customers` row for a signed-in user, otherwise `customers.create({email})`.
5. Insert `trial_orders` with `status='pending_setup'` and the locked amounts.
6. Create the session:
   ```
   mode: "setup", ui_mode: "elements", currency: "usd", customer,
   return_url: …/checkout/return?session_id={CHECKOUT_SESSION_ID}&role=student&trial=1,
   setup_intent_data: { description, metadata: { trial_order_id } },
   metadata: { kind: "trial_setup", trial_order_id, offer, subject_ids, student_email, … },
   allowed_payment_method_types (or payment_method_types): ["card"]   // pin it; see TASK-0058 E
   ```
7. Return `client_secret` plus a display summary from the server: list price, discount, amount due on `<date>`, and $0 today.

**SetupIntent `usage`:** Checkout's `setup_intent_data` cannot set `usage`. The SetupIntent default is `off_session`, which is what we
need. The webhook asserts `setup_intent.usage === 'off_session'` and alerts if not. Codex should confirm this default for setup-mode
Checkout on `2026-03-25.dahlia`.

### 4.4 Step 2: fulfil the trial (`stripe-webhook`)

New branch, taken first when `session.mode === 'setup'` (§3):

1. Retrieve the SetupIntent with `expand: ['payment_method']`. Require `status === 'succeeded'`.
2. The PaymentMethod should already be attached to `session.customer`. If not, call `paymentMethods.attach`.
3. Set the customer's `invoice_settings.default_payment_method`.
4. Resolve or invite the learner exactly as `student_direct` does today (`:262-291`).
5. Upsert `stripe_customers`.
6. Update `trial_orders`: `trialing`, PM and fingerprint, `trial_started_at=now()`, `trial_ends_at=now()+TRIAL_DURATION`.
7. Grant the `trial` entitlement rows.
8. Queue the Loops **"trial started" confirmation**: the amount, the charge date, how to cancel and the last-4 of the card. This
   doubles as the mandate confirmation.
9. Emit a `trial_card_started` growth event.

Idempotency comes from the existing event ledger plus `checkout_session_id unique`.

`get-checkout-status` must recognise setup sessions. It should report `trialing` with the trial end date, not "pending payment",
and offer no upsell.

`checkout.session.expired` on a setup session sets the order to `expired_unpaid` and releases its promo reservation.

### 4.5 Step 3: charge at trial end (new `charge-due-trials` function + cron)

- **Trigger:** a pg_cron job every 15 minutes calls `app.invoke_charge_due_trials()`, which uses `pg_net` with the URL and Bearer
  token from Vault. This copies `app.byoq_invoke_purge()`. The function is guarded by a new `TRIAL_CHARGE_WORKER_SECRET` and the
  kill switch `TRIAL_CHARGES_ENABLED`.
- **Per claimed row:** skip if canceled or refunded, then charge. **Two options for Codex to choose between:**
  - **Option A (Stripe's pasted guidance):** `paymentIntents.create({ amount: charge_amount, currency, customer, payment_method,
    off_session: true, confirm: true, description, metadata: { kind: "trial_conversion", trial_order_id, user_id, offer,
    subject_ids, promotion_code_id } }, { idempotencyKey: "trial-charge:<id>:<attempt>" })`.
    - Pro: simplest, and exactly the guidance.
    - Con: Stripe never records the promo redemption (`times_redeemed` does not move), so we enforce `max_redemptions` in our own
      table.
    - Con: no Stripe receipt or invoice beyond the charge receipt.
  - **Option B (recommended by Claude):** charge through an **Invoice**: `invoiceItems.create({customer, pricing: {price}})`,
    `invoices.create({customer, discounts: [{promotion_code}], collection_method: 'charge_automatically', default_payment_method,
    metadata})`, then `finalizeInvoice` and `invoices.pay(id, {off_session: true})`. Underneath it is still an off-session
    PaymentIntent.
    - Pro: Stripe applies and **counts** the promo redemption, and coupon reporting in the dashboard stays correct.
    - Pro: a **hosted invoice page** (`hosted_invoice_url`) is a ready-made recovery page where the customer can authenticate or use
      a new card.
    - Pro: a proper invoice and receipt.
    - Con: if the promo has expired or run out between signup and day 7, Stripe rejects the discount. We then charge the **locked
      `charge_amount`** with a price-data item instead, because the mandate promised that amount.
    - Con: more API calls, and the webhook must handle `invoice.paid` / `invoice.payment_failed`.
  - Either way, `charge_amount` from `trial_orders` is authoritative. Never recompute the price at charge time.
- **Webhook additions:** `payment_intent.succeeded` / `payment_intent.payment_failed` (Option A) or `invoice.paid` /
  `invoice.payment_failed` (Option B), routed by `metadata.kind='trial_conversion'`. The **endpoint's event subscription in the Stripe
  dashboard must add these** (David), or the handler never sees them; today unknown types throw.
- **On success, in the webhook, never the job:**
  - grant the `paid` entitlements;
  - mark the trial rows `expired` (or leave them to lapse);
  - set the order to `converted`;
  - queue the existing payer receipt email;
  - emit `trial_converted`.
- **On failure:**
  - `authentication_required`: set `requires_action` and send a recovery email (§4.6). No automatic retry, since it will fail the
    same way.
  - Other declines (`insufficient_funds`, `card_declined`, `expired_card`…): set `payment_failed`, `next_attempt_at` at +1 day then
    +3 days (max 3 attempts, proposal), and send a recovery email each time. After the last attempt, `expired_unpaid`.
  - Access during failure: the trial row expires at `trial_ends_at` as it does today, so the student loses access until payment
    succeeds. Grace period: David's call (§7, Q5).

### 4.6 Recovery flow

The recovery email links to `app.cramapple.com/trial/complete?order=<opaque token>`, which is a signed, single-use, expiring short
code like `parent_payment_links`, never the raw order ID.

- **Option A:** the page calls a new `create-trial-recovery-session` function. It creates a normal **payment-mode** Checkout Session
  (`ui_mode: elements`, `customer`, a `price_data` line at `charge_amount`, `metadata.kind='trial_recovery'`, `trial_order_id`). The
  existing payment-mode fulfilment then grants, keyed off `trial_order_id` so it cannot double-grant.
- **Option B:** redirect to the invoice's `hosted_invoice_url`.

### 4.7 Cancellation and reminders

- **Cancel before the charge:** an Account page button calls a new `cancel-trial` function (signed-in learner only). It sets
  `canceled`, keeps access until `trial_ends_at` (proposal), stops the charge, and sends a confirmation email.
- **Reminder before charging:** the existing Loops day-5/6/7 trial sequence already keys off `ends_at`. Reword it for card trials
  (amount, date, cancel link). Several US state auto-renewal and free-trial laws expect a clear pre-charge notice and easy online
  cancellation. **This is a legal question for David, not something this plan settles.**

### 4.8 Eligibility and abuse

- **One card trial per student email and per user.** Anyone who had a `trial_v1` or `stripe_trial_v1` row pays now.
- **Card fingerprint:** if a fingerprint was used on a trial that was canceled or failed, refuse a second trial on that card.
  (Proposal; the fingerprint is only known after setup, so the webhook would mark the order "no trial" and charge immediately, or
  ask for payment. Codex: is this worth the complexity for v1?)
- **Promo reservations:** a live trial holds one use of its code, so 10 trials cannot all redeem a 10-use code that has only 1 use
  left. With Option B, Stripe counts the use only at conversion, so our reservation count has to be added on top.

### 4.9 Refunds

Today's refund path keys off the Checkout Session. A conversion charge has no session, so `charge.refunded` must also resolve
`charge → payment_intent → trial_orders` (Option A) or `charge → invoice → trial_orders` (Option B), then revoke the conversion grant
and set `refunded`. A partial refund keeps access, as today (PR #310 behaviour).

### 4.10 The existing cardless trial (`trial_v1`)

The card trial replaces it in the checkout funnel. `app.start_trial` and `start-trial` stay in place (not dropped) until it is
confirmed nothing live calls them. Unverified: does the live Lovable app (`56cae479`/`61dd6602`) call `start-trial` today?

### 4.11 Frontend (Lovable, `61dd6602` checkout and `56cae479` app; David publishes)

- **Checkout, in trial mode:**
  - Headline "Start your 7-day free trial".
  - "$0 today · then **$X on <date>** unless you cancel"; the discounted amount when a code is applied.
  - Mandate text next to the button.
  - A **required consent checkbox**.
  - Button "Start free trial".
  - Payment Element and Express Checkout Element in setup mode.
  - Promo box unchanged. The URL `?promo=` still auto-applies.
- **Return page:** a trialing state ("Trial active until <date>").
- **App:**
  - Account shows the trial status, charge date and amount, and a Cancel button.
  - Home shows a trial-days-left banner.
  - The `/trial/complete` recovery page.
- **Unverified:**
  - Whether the Express Checkout Element shows Apple Pay and Google Pay in setup mode. Apple Pay may need a deferred or
    recurring payment request.
  - What the Payment Element's built-in `terms` text shows in setup mode.

### 4.12 Terms and copy (David)

The Terms and checkout copy must state the trial length, the exact amount and date of the charge, how to cancel, and the refund
policy after conversion. This overlaps `BIZ-001` (access duration, refunds), which the cutover checklist still lists as open (§7.3).

---

## 5. Testing

- **Dev first**, with Stripe test keys:
  - Make trial length configurable through `TRIAL_DURATION_SECONDS` (Production = 604800; Dev = 600) so conversion can be exercised
    in minutes.
  - Or use Stripe **test clocks** for Option B invoices.
- **Test cards:**
  - `4242…4242` (succeeds);
  - `4000 0025 0000 3155` (authenticates on setup, then off-session succeeds);
  - `4000 0027 6000 3184` (always requires authentication: exercises `requires_action` and recovery);
  - `4000 0000 0000 9995` (insufficient funds: exercises retries);
  - `4000 0000 0000 0341` (saves, then the charge fails).
- **Unit tests:**
  - setup session never reaches `grantEntitlements` (§3);
  - promo evaluation table (percent, amount, product-restricted, expired, minimum amount, exhausted with reservations);
  - claim function concurrency (two workers, one charge);
  - idempotency-key reuse;
  - refund mapping.
- **Blocker inherited from `TASK-0058` A0:** there is no Dev-pointed checkout frontend, so the setup flow in the browser can only be
  proven in Production with live cards unless A0 is done first. **Recommend doing A0 first or alongside.**
- **Production:**
  - a $1 promo trial by David with `TRIAL_DURATION_SECONDS` overridden for that one order (or a manual `trial_ends_at` update by
    approved SQL), then a refund;
  - one `4000…3184`-style live authentication test is not possible; use a real 3DS card if available.

## 6. Rollout and rollback

1. Migration (`trial_orders`, claim function, cron job **unscheduled**): Dev, then Prod (approval).
2. Webhook guard (§3) shipped **first and on its own**. It is safe even with the trial off.
3. Functions behind `TRIAL_CHECKOUT_ENABLED=false` and `TRIAL_CHARGES_ENABLED=false`. Add Stripe webhook event subscriptions.
4. Lovable checkout behind its own toggle. David publishes.
5. Turn on `TRIAL_CHECKOUT_ENABLED`, then schedule the cron and turn on `TRIAL_CHARGES_ENABLED` before the first trial reaches day 7.

**Rollback:**
- `TRIAL_CHECKOUT_ENABLED=false` returns checkout to pay-now immediately.
- Existing trialers still convert unless `TRIAL_CHARGES_ENABLED=false`, which pauses charges (rows stay `trialing`; access lapses at
  `ends_at`).
- Migrations are additive; nothing is dropped.

## 7. Questions for David (block implementation)

1. **Trial on what?** Trial the subjects being bought (card-trial natural fit) or all subjects (the TASK-0026 cardless design)?
   Recommendation: the purchased offer.
2. **Parents:** keep parent-pay as pay-now (recommended), or revise `DECISION-0090` to allow a saved parent card for trials?
3. **Price lock:** if a code expires mid-trial, does the trialer still pay the discounted price? Recommendation: yes, it is the
   amount they agreed to.
4. **Cancel behaviour:** keep access until day 7 (recommended), or end it immediately?
5. **Failed charge:** grace period after day 7 while retrying (e.g., 48 h), or lose access at day 7?
6. **Eligibility:** one trial per email only, or also per card fingerprint?
7. **$1 pilot / 50%-off codes:** do they get the trial too? (The design supports it.)
8. **Terms and legal review** of the mandate and auto-charge copy, and whether a pre-charge reminder email is required.
9. **Retire `trial_v1`** from any live entry point?

## 8. Questions for Codex (review asks)

- Option A vs B for the conversion charge (§4.5), especially promo redemption counting and the price-lock fallback.
- Confirm the setup-mode SetupIntent `usage` default and Express Checkout Element support in setup mode on `2026-03-25.dahlia` /
  `stripe-node` in use.
- Is the §3 guard complete? Are there other places that read `payment_status` or assume a session has a PaymentIntent?
  (`get-checkout-status`, refund reconciliation `:473-492`, `enqueueCheckoutPayerReceipt`.)
- Is the promo self-evaluation (§4.3 step 2) complete against Stripe's promotion-code and coupon restrictions?
- pg_cron availability on Prod (the contradictory migration comment), and whether `deliver-transactional-email` is actually being
  triggered so the trial emails send.
- Anything that should be its own task (A0 Dev frontend, Apple Pay domain).

## 9. Approvals needed (none granted)

| Step | Who |
|---|---|
| Record the §7 product decisions (new DECISION) | David |
| Prod migration | David approves, Claude/Codex applies |
| Prod function deploys (webhook guard, checkout, charge worker, cancel, recovery) | David |
| Secrets (`TRIAL_*`, Vault entries) and the Stripe webhook event subscription | David |
| Lovable publish (checkout + app) | David |
| Terms update | David |
