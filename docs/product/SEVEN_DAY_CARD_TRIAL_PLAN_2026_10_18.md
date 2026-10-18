# Seven-Day Free Trial With a Saved Card — Implementation Plan (for Codex review)

**Status:** DRAFT for Codex review. **Nothing is built, deployed or configured.** Product questions answered by David 2026-10-18
and recorded as `DECISION-0126` (§7), follow-ups a–d answered the same day; the design below reflects all of them.
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

### 4.1 Scope (`DECISION-0126` items 1, 2, 7)

- **In:** every checkout. That means `student_direct` (Elements checkout on `cramapple.com/checkout`) and `parent_share` (the
  Stripe-hosted page from `create-parent-payment-link`), for `single` and bundle offers. The `$1` pilot and 50%-off codes included.
  The trial covers what was bought and starts at checkout.
- **Out, stays pay-now:**
  - **Any purchase by a student email that has already had a trial.** Item 6 allows one trial per email. This covers the post-purchase
    add-on, which in any case stays hidden during a trial because the upsell keys on `payment_status='paid'`
    (`get-checkout-status:133-153`).
  - `legacy_authenticated` (no live entry point; confirm in review).
  - `parent_gift` (legacy; confirm no live caller).
- **100%-off codes:** a code that brings the total to $0 skips the trial and uses today's payment-mode path, which already grants on
  `no_payment_required`. Saving a card for a $0 charge adds friction for nothing.

### 4.1a Parent-pay with a trial (revises `DECISION-0090` in part)

- `create-parent-payment-link` creates a **hosted** `mode: "setup"` session with `currency: "usd"` and a new parent Stripe Customer
  (`customer_creation: "always"` is allowed in setup mode, or the function creates the Customer from the email Stripe collects).
  `metadata.kind = "trial_setup"`, `purchase_type = "parent_share"`, plus the student fields used today.
- Hosted Checkout **does** allow `custom_text`, so the mandate wording goes in `custom_text.submit`/`after_submit`. Consent is
  recorded from the parent. Whether hosted setup mode can require a consent checkbox (`consent_collection.terms_of_service`) is
  Unverified; Codex to confirm.
- The parent's Customer and PaymentMethod are stored **only on the `trial_orders` row**, never in `app.stripe_customers` against the
  student. They are used for this one charge only, and the PaymentMethod is detached after conversion, cancellation or final failure.
- **The student's email stays required** before a parent link is created (today: `create-parent-payment-link/index.ts:79-83`). The
  student must be told about every parent-pay outcome (`DECISION-0126` item 13), and the email is also the trial-eligibility key.
- Every trial email (start confirmation, pre-charge reminder, failure and recovery, cancellation, conversion) goes to **both the
  parent and the student** (`DECISION-0126` items 11 and 13). The student's copy of the start email says plainly that their parent
  started their access ("Your parent started your 7-day free trial of <subjects>"); the conversion email reuses today's "your
  parent paid" template. The recovery and cancel links in the student's copy act for the student
  (cancel is allowed, item 10); payment recovery links go to the parent only, since it is the parent's card.
- The parent has no Cramapple account, so they **cancel through a signed, single-use link** in their emails (the same short-code
  pattern as `parent_payment_links`). A signed-in student can also cancel a trial a parent started (`DECISION-0126` item 10); the parent is emailed.
- `send-parent-payment-email` and the parent lifecycle emails assume a payment session with `amount_total`. They need trial wording
  ("$0 today, then $X on <date>") from `trial_orders`.
### 4.2 Data model (one additive migration)

New table `app.trial_orders`, service-role only, RLS forced. It mirrors the pattern of `parent_email_lifecycle_jobs`.

| Column | Purpose |
|---|---|
| `id uuid pk` | |
| `user_id uuid null` | Filled at fulfilment (anonymous buyers are resolved or invited by email, as today) |
| `student_email text not null` | The trial-eligibility key (`DECISION-0126` item 6) |
| `purchase_type text`, `payer_email text`, `payer_is_learner bool` | Parent-pay support; trial emails go to the payer and, on parent-pay, the student too |
| `terms_version text`, `terms_accepted_at timestamptz` | The required Terms and Conditions acknowledgment (`DECISION-0126` item 11) |
| `offer text`, `subject_ids text[]`, `price_id text` | What is being bought |
| `list_amount int`, `discount_amount int`, `charge_amount int`, `currency text` | **Server-computed price, locked at signup.** This is the amount stated in the mandate. |
| `promotion_code_id text null`, `coupon_id text null`, `promo_code text null` | |
| `checkout_session_id text unique`, `setup_intent_id text`, `stripe_customer_id text`, `payment_method_id text`, `card_fingerprint text` | |
| `mandate_version text`, `mandate_accepted_at timestamptz`, `mandate_ip inet`, `mandate_user_agent text` | Consent record (Stripe: "keep a record of your customer's written agreement") |
| `trial_started_at`, `trial_ends_at timestamptz` | |
| `status text` | `pending_setup` → `trialing` → `charging` → `converted` / `requires_action` / `payment_failed` (in grace) / `canceled` / `refunded` / `expired_unpaid` |
| `attempt_count int`, `next_attempt_at timestamptz`, `lease_owner`, `lease_expires_at` | Charge-job claim |
| `payment_intent_id text`, `invoice_id text`, `last_error_code text`, `last_decline_code text` | |
| `created_at`, `updated_at` | |

- Eligibility: a unique index on `lower(student_email)` over every row that **reached** `trialing` (any later status), so a student
  email gets one trial ever (`DECISION-0126` item 6; item 9 as amended). The payer's email is not checked. A second partial index allows only one `pending_setup` row per email at a time.
- New function `app.claim_due_trial_charges(limit, lease_seconds)`: `FOR UPDATE SKIP LOCKED` over rows with
  `status='trialing' and trial_ends_at<=now()` or `status='payment_failed' and next_attempt_at<=now()`.
- Entitlements reuse `subject_entitlements`: `access_tier='trial'`, new `source='stripe_trial_v1'`,
  `ends_at = trial_ends_at`, `external_reference = trial_orders.id`.
- On conversion, the existing `paid` grant runs with a new source, `stripe_trial_conversion_<offer>`. The unique key
  `(user_id,subject_id,access_tier,source)` lets the trial and paid rows sit side by side.

### 4.3 Step 1: start the trial (`create-checkout-session`)

Add a `trial: true` request flag, honoured only when `TRIAL_CHECKOUT_ENABLED=true` and the student email is
eligible (§4.8). The parent link applies the same steps in `create-parent-payment-link` (§4.1a). Server steps:

1. Resolve the offer and Price as today, and **retrieve the Price's `unit_amount`** (needs one Stripe read; the catalog stores IDs
   only).
2. If a promo code is present, look it up as today, then **evaluate it ourselves**, since Stripe will not in setup mode. Checks:
   `active`, `expires_at`, `max_redemptions` against `times_redeemed` **plus our own live trial reservations**, `restrictions`
   (`minimum_amount`, `first_time_transaction`, `customer`), `coupon.valid`, `coupon.applies_to.products` (expand), currency, and
   `percent_off`/`amount_off`. Compute `discount_amount` and `charge_amount`. Return the same `promo_code_invalid` errors as today.
3. If `charge_amount == 0`, fall through to the existing payment-mode path (§4.1).
   The price computed here is **locked** (`DECISION-0126` item 3): it is never recomputed at charge time, even if the code later
   expires or runs out.
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
- **On failure, with one day of grace (`DECISION-0126` item 5):**
  - First failure, any reason: set `payment_failed` and **extend the trial entitlement's `ends_at` by 24 hours** so access carries on
    through the grace day. Send the recovery email (§4.6) to the payer.
  - `authentication_required`: no automatic retry, since it would fail the same way. The grace day is for the payer to complete the
    recovery page.
  - Other declines (`insufficient_funds`, `card_declined`, `expired_card`…): **one** automatic retry near the end of grace
    (`next_attempt_at = trial_ends_at + 23h`).
  - Grace ends unpaid: set `expired_unpaid`. The entitlement lapses by itself at the extended `ends_at` (the access gate needs no job).
    The recovery link stays valid for 30 days (proposal) and paying restores access through the normal conversion grant.

### 4.6 Recovery flow

The recovery email links to `app.cramapple.com/trial/complete?order=<opaque token>`, which is a signed, single-use, expiring short
code like `parent_payment_links`, never the raw order ID.

- **Option A:** the page calls a new `create-trial-recovery-session` function. It creates a normal **payment-mode** Checkout Session
  (`ui_mode: elements`, `customer`, a `price_data` line at `charge_amount`, `metadata.kind='trial_recovery'`, `trial_order_id`). The
  existing payment-mode fulfilment then grants, keyed off `trial_order_id` so it cannot double-grant.
- **Option B:** redirect to the invoice's `hosted_invoice_url`.

### 4.7 Cancellation and reminders

- **Cancel before the charge (`DECISION-0126` items 4 and 10): access ends immediately.**
  - A student cancels from an Account page button, including a trial their parent started. A parent cancels through the signed link
    in their email (§4.1a). Both call a new `cancel-trial` function.
  - It sets `canceled`, sets the trial entitlements' `status='revoked'` and `ends_at=now()`, stops the charge, detaches the
    PaymentMethod, and emails the payer and, on parent-pay, the student.
  - The student's email has used its one trial (item 6), so buying again later is pay-now. The cancel screen should say so.
- **Reminder before charging:** the existing Loops day-5/6/7 trial sequence already keys off `ends_at`. Reword it for card trials
  (amount, date, cancel link). Several US state auto-renewal and free-trial laws expect a clear pre-charge notice and easy online
  cancellation. **This is a legal question for David, not something this plan settles.**

### 4.8 Eligibility and abuse (`DECISION-0126` item 6)

- **One trial per student email, ever** (`DECISION-0126` item 6; item 9 as amended). Normalise to lower case, then check
  `trial_orders` (any row that reached `trialing`) and `subject_entitlements` with `source in ('trial_v1','stripe_trial_v1')` for the
  student's user. If the student's email has had a trial, the checkout is pay-now.
  - **Parents are not limited.** A parent may start a trial for each child taking APs ("they may have multiple kids taking APs").
  - Because the student's email is required before the session is created (both checkouts), eligibility is always known **before**
    the card is entered. No post-checkout ineligibility path is needed.
  - **Open, not designed (`DECISION-0126` item 14):** a parent whose own email has already had a trial. Left open at David's request;
    it mattered only while the payer's email counted.
- **No card-fingerprint check.** Store the fingerprint anyway, for reporting.
- **Promo reservations:** a live trial holds one use of its code, so 10 trials cannot all redeem a 10-use code that has only 1 use
  left. With Option B, Stripe counts the use only at conversion, so our reservation count has to be added on top. Because the price
  is locked (item 3), a trial that began while the code was valid still converts at the discount.

### 4.9 Refunds

Today's refund path keys off the Checkout Session. A conversion charge has no session, so `charge.refunded` must also resolve
`charge → payment_intent → trial_orders` (Option A) or `charge → invoice → trial_orders` (Option B), then revoke the conversion grant
and set `refunded`. A partial refund keeps access, as today (PR #310 behaviour).

### 4.10 Retire the cardless trial (`trial_v1`, `DECISION-0126` item 12)

- `start-trial` returns `410 trial_retired` (code change and deploy) and `EXECUTE` on `app.start_trial` is revoked in the trial
  migration. The function and its rows are kept, not dropped, for history.
- The Loops day-5/6/7 trial sequence keyed off `trial_v1` is reworded for card trials and re-pointed at `stripe_trial_v1`. Existing
  `trial_v1` rows lapse on their own at `ends_at`.
- `trial_v1` history counts as a used trial (§4.8).
- Before deploying: check whether the live Lovable apps (`56cae479`, `61dd6602`) call `start-trial`, and remove any button that
  does. A 410 must not surface as a broken page.

### 4.11 Frontend (Lovable, `61dd6602` checkout and `56cae479` app; David publishes)

- **Checkout, in trial mode:**
  - Headline "Start your 7-day free trial".
  - "$0 today · then **$X on <date>** unless you cancel"; the discounted amount when a code is applied.
  - Mandate text next to the button.
  - A **required consent checkbox**.
  - Button "Start free trial".
  - Payment Element and Express Checkout Element in setup mode.
  - Promo box unchanged. The URL `?promo=` still auto-applies.
- **Parent page (hosted):** mandate copy in `custom_text`. The share drawer and parent email say "free for 7 days, then $X".
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

`DECISION-0126` items 8 and 11:

- **A required Terms and Conditions acknowledgment on every trial checkout.**
  - Direct checkout (Elements): a required checkbox linking `/terms`, next to the mandate text. The button stays disabled until it
    is ticked. The server rejects a `trial: true` request without `terms_accepted: true` and a `terms_version`. The webhook copies
    them onto `trial_orders` at fulfilment (they travel in session metadata, set server-side).
  - Parent hosted page: `consent_collection: { terms_of_service: "required" }`. This needs the Terms URL set in the Stripe
    dashboard's public business details (David). Stripe then returns `session.consent.terms_of_service = "accepted"`, which the
    webhook requires before starting the trial and stores.
- **The start confirmation email repeats the terms**: amount, charge date, how to cancel and a Terms link. On parent-pay it goes to
  both the parent and the student.
- The Terms page must describe the trial, the charge and cancellation (overlaps `BIZ-001`).
- **Still not named:** a reviewer for the Terms wording against state auto-renewal and free-trial rules.

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
   Parent-pay trial ships after the direct-checkout trial is proven (proposal), behind `TRIAL_PARENT_ENABLED`.
3. Functions behind `TRIAL_CHECKOUT_ENABLED=false` and `TRIAL_CHARGES_ENABLED=false`. Add Stripe webhook event subscriptions.
4. Lovable checkout behind its own toggle. David publishes.
5. Turn on `TRIAL_CHECKOUT_ENABLED`, then schedule the cron and turn on `TRIAL_CHARGES_ENABLED` before the first trial reaches day 7.

**Rollback:**
- `TRIAL_CHECKOUT_ENABLED=false` returns checkout to pay-now immediately.
- Existing trialers still convert unless `TRIAL_CHARGES_ENABLED=false`, which pauses charges (rows stay `trialing`; access lapses at
  `ends_at`).
- Migrations are additive; nothing is dropped.

## 7. David's answers (2026-10-18, recorded as `DECISION-0126`)

| # | Question | Answer | Effect on the design |
|---|---|---|---|
| 1 | Trial on what? | "Trial covers any purchase from the time of the purchase." | Every purchase gets the trial on what was bought, starting at checkout (§4.1) |
| 2 | Parent-pay? | "Parent-pay is also 7 day free trial." | Parent hosted setup session; `DECISION-0090` partly revised (§4.1a) |
| 3 | Price lock if code expires | "Yes" | Locked `charge_amount` is authoritative (§4.3, §4.5) |
| 4 | Keep access after cancel? | "No" | Cancel revokes access immediately (§4.7) |
| 5 | Grace after failed charge | "1 day grace" | `ends_at` +24 h, one retry, then lapse (§4.5) |
| 6 | Eligibility | "1 trial per email" | One trial per student email ever; no fingerprint check (§4.8) |
| 7 | $1 / 50%-off codes | "Yes" | Codes work with the trial; $0 totals skip it (§4.1) |
| 8 | Terms / legal | "whomever is paying" | Payer gives consent and gets the emails (§4.12) |

**Follow-ups, answered 2026-10-18 (`DECISION-0126` items 9–12):**

| # | Question | Answer | Effect on the design |
|---|---|---|---|
| a | Does the payer's email count toward one trial? | "yes", then amended: "I am not worried about parents buying for more than one student" | Eligibility is per student email only; parents may trial for each child (§4.8) |
| b | Can a student cancel a parent's trial? | "yes" | `cancel-trial` allows it; parent is emailed (§4.7) |
| c | Who checks the legal side? | "acknowledgment of Ts and Cs on checkout and email to both parent and student" | Required Terms acknowledgment on both checkouts, stored; trial emails to both on parent-pay (§4.12, §4.1a) |
| d | Retire the cardless trial? | "retire the old trial that needs no card" | `start-trial` switched off, `app.start_trial` revoked (§4.10) |
| e | Student notification on parent-pay | "notify the student that their parent paid … We need the student's email" | Student email stays required; the student is emailed on every parent-pay outcome (§4.1a) |
| f | Edge case: parent's own email already had a trial | "Leave the edge case open." | Not designed; open (§4.8) |

**Still open:** the parent-email edge case (item 14), and no reviewer is named for the Terms wording against state auto-renewal and free-trial rules.

## 8. Questions for Codex (review asks)

- Option A vs B for the conversion charge (§4.5), especially promo redemption counting and the price-lock fallback.
- Confirm the setup-mode SetupIntent `usage` default and Express Checkout Element support in setup mode on `2026-03-25.dahlia` /
  `stripe-node` in use.
- Is the §3 guard complete? Are there other places that read `payment_status` or assume a session has a PaymentIntent?
  (`get-checkout-status`, refund reconciliation `:473-492`, `enqueueCheckoutPayerReceipt`.)
- Is the promo self-evaluation (§4.3 step 2) complete against Stripe's promotion-code and coupon restrictions?
- pg_cron availability on Prod (the contradictory migration comment), and whether `deliver-transactional-email` is actually being
  triggered so the trial emails send.
- Parent hosted setup mode: `customer_creation` vs a pre-created Customer, `consent_collection` support, and `custom_text` mandate
  placement.
- Is the `DECISION-0090` boundary (parent card only on `trial_orders`, detached after use) enough, or does any existing code path
  (refund reconciliation, `persistStripeCustomer`) still write the parent's card against the student?
- Anything that should be its own task (A0 Dev frontend, Apple Pay domain).

## 9. Approvals needed (none granted)

| Step | Who |
|---|---|
| §7 product decisions | David — answered 2026-10-18 (`DECISION-0126`, items 1–14) |
| Terms URL in Stripe public details (for `consent_collection`) and the Terms text | David |
| Prod migration | David approves, Claude/Codex applies |
| Prod function deploys (webhook guard, checkout, charge worker, cancel, recovery) | David |
| Secrets (`TRIAL_*`, Vault entries) and the Stripe webhook event subscription | David |
| Lovable publish (checkout + app) | David |
| Terms update | David |
