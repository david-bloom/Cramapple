# TASK-0077 — Codex review of the seven-day saved-card trial plan

**Verdict: Not ready.** The product direction is implementable, but the draft contains a parent-card isolation contradiction, an unsafe invoice sequence, and incomplete financial concurrency, recovery, promotion and notification contracts. Resolve the blocking findings before implementation approval. This verdict concerns the plan, not the desirability of the trial.

**Status:** Proposed review and plan amendments; no implementation approval.
**Date:** 2026-10-18, America/New_York.
**Reviewed branch / PR:** `claude/task-0077-card-trial-plan`, [draft PR #504](https://github.com/david-bloom/Cramapple/pull/504).
**Pinned source:** `f2b7bfbd3f0c62836e088c24d80d12f0f4496f1e`. All backend file:line references below refer to this commit.
**Review branch:** `codex/task-0077-plan-review`, based on that commit; PR targets Claude's branch.
**Scope:** Review only. No code, migrations, deployments, Stripe configuration, Lovable edits/publication or Production database queries. Only this review document is proposed for the repository.
**Tier:** Standard documentation/QA slice reviewing a Hard-Gate implementation. Existing product decisions and David's latest clarifications below govern. Execution remains separately gated.

**Evidence convention:** **Verified** means read in pinned source, current authoritative documentation, a named Lovable source snapshot, or the explicitly identified Development read-only check. **Unverified** means not demonstrated, including design-risk inferences; an inference is not a report of an incident. **Proposed change** is a recommendation, not approved implementation. A source-level check does not certify a deployed environment.

The full plan, `DECISION-0126` items 1–14 including amended item 9, `DECISION-0090`, purchase-funnel spec §4/§7–9, TASK-0058 A0, TASK-0026 and the named migrations were reviewed. Routing and operating rules came from `AGENTS.md`, `docs/INDEX.md`, the session-start/tier-first documents and relevant charter sections. The index has a payments entry but no TASK-0077 entry; the expressly named plan and decision govern this review. Two focused independent source/Stripe reviewers supported the conductor, as the operating model directs.

**Owner clarifications during this review — durable record, not a silent edit of DECISION-0126:**

- **Verified, David's answer:** After grace, allow **30 days of voluntary recovery at the locked price**. No further automatic collection is authorized by this recovery window. Proposed implementation anchor: `recovery_expires_at = grace_ends_at + 30 days`.
- **Verified, David's answer:** **Notify before any delayed charge** following a billing outage. Notice lead time and access during a service-caused interruption still need a precise policy.
- **Verified, David's latest clarifications:** **"whoever pays accepts the terms"** and **"student always acknowledges the terms"**. Both requirements apply: the student acknowledges the Terms on every trial, including parent-paid trials; whoever pays also accepts them. On direct checkout, one student acknowledgment/acceptance can satisfy both requirements. On parent-paid checkout, record the student's acknowledgment and the parent's separate acceptance. This supersedes the earlier student-only/optional-parent wording and preserves DECISION-0126's payer-acceptance rule. Neither person's action substitutes for the other's on parent-pay.
- **Verified, Stripe requirement, not a new owner ruling:** The parent must still authorize storage and the specified future charge against their own card. General Terms review and the cardholder's payment mandate are distinct. A disclosed affirmative setup action can be the authorization mechanism; the cited Stripe guidance does not prescribe a separate off-session-consent checkbox. See finding 2.

## Findings, most severe first

### 1. Blocking — the setup guard is necessary, but must be a complete routing boundary

**Plan:** §2–3, §4.4, §4.6.

**Verified:** Stripe defines `no_payment_required` to include setup-mode Sessions in its [Session object reference](https://docs.stripe.com/api/checkout/sessions/object). The repository's `isSettledPaymentStatus` accepts that value (`supabase/functions/_shared/checkout-access.ts:23–27`). `handleCheckoutSessionEvent` passes it into paid fulfilment (`stripe-webhook/index.ts:435–458`), whose grant is `access_tier='paid'`, `ends_at=null` (`:204–229`). With the normal recipient/subject metadata, a completed setup Session would therefore take the lifetime grant path. The plan correctly identifies this defect; no actual setup signup or deployed incident was demonstrated.

**Verified:** The handler currently retrieves and records a Session before the payment gate (`:432–433`); its local Session type lacks Stripe `mode` and `setup_intent` (`:40–80`). The gate also lets a missing `payment_status` through. `metadata.mode` means offer (`:338`), and the stored `stripe_checkout_sessions.mode` is populated from that metadata (`:183`), not Stripe's mode.

**Unverified — design risk:** Adding only an `if (session.mode === 'setup')` around the grant leaves expiry, emails, status reporting and recovery on incompatible paths. A setup without a matching trial order must not be treated as an eligible trial merely because its Stripe signature is valid.

**Proposed change:** Before ordinary fulfilment/email handling, route all setup Session events by Stripe mode plus recognized purpose and a matching stored order. Require the expected Session, customer, SetupIntent, student/subject scope, environment, succeeded setup and recorded mandate. Unexpected usage/customer/metadata must quarantine the order, not attach an arbitrary method and proceed. Explicitly handle setup expiry. Ordinary paid fulfilment must require `session.mode === 'payment'` and an accepted settlement value; preserve the existing $0 payment-mode path. Reject or safely ignore unsupported modes according to an explicit event policy. Distinguish `stripe_session_mode` from `offer`, with a compatibility adapter for existing `metadata.mode`.

Test that setup never grants paid access, emits `purchase_completed`, sends a paid receipt, or exposes an add-on. The complete consumer inventory is below.

### 2. Blocking — parent-card isolation is contradicted by the proposed fulfilment steps

**Plan:** §4.1a, §4.3 steps 4/6, §4.4 steps 2–5, §4.7, §4.12.

**Verified:** §4.1a prohibits saving a parent's customer in the student's `app.stripe_customers`; §4.4 step 5 unconditionally says to upsert it. Existing code protects the student mapping only at the caller (`stripe-webhook/index.ts:403–405`); `persistStripeCustomer` itself has no payer-type guard (`:293–317`). Add-on checkout reads the customer's mapping (`create-post-purchase-addon/handler.ts:102–109`). DECISION-0126 item 2 prohibits parent reuse.

**Unverified — design risk:** A literal implementation exposes the parent customer to subsequent student checkout during the trial, even if the payment method is detached later. Applying the direct flow's customer lookup to parent-share has the same problem. Conversely, indiscriminately detaching a direct student's method can break a legitimate shared customer/default mapping.

**Proposed change:** Parent setup always uses an isolated parent/order customer; no student-customer reuse or mapping write on setup, conversion, recovery, retry or refund. Guard the persistence helper itself, not only one call site. Parent method cleanup must be a retryable job with evidence of completion. Direct customer/default handling must be separately specified; never detach a method still legitimately referenced by another direct purchase.

Capture the actual payer email from completed setup; the address entered to send a parent request is not proof of who supplied the card. Use the order's explicit method when charging rather than depending on a mutable customer default. Require SetupIntent/customer/PaymentMethod ownership consistency instead of treating `attach` as a repair for any mismatch. Test that a pre-existing student mapping remains byte-for-byte unchanged throughout a parent trial.

**Verified:** Stripe requires cardholder permission for future off-session use and a record of the agreement ([SetupIntents](https://docs.stripe.com/payments/setup-intents), [save/reuse agreement](https://docs.stripe.com/payments/save-and-reuse?payment-ui=elements)). David requires the student always to acknowledge the Terms and whoever pays to accept them. **Proposed change:** collect the student's acknowledgment on direct checkout or before creating a parent trial request. On direct checkout, that student's acknowledgment/acceptance can also satisfy payer acceptance; on parent-paid checkout, additionally require the parent's separate Terms acceptance. Retain the plan's required parent Terms checkbox, subject to the hosted setup compatibility test below. Show the payer the one-time amount, timing and cancellation terms beside their affirmative setup action. Persist separate student and payer actor/version/timestamp/source evidence on parent-pay, together with the displayed mandate/version and payment authorization. A student cannot accept on the parent's behalf, and a parent's acceptance cannot substitute for the student's acknowledgment. No legal-compliance certification is made here.

### 3. Blocking — a queue lease and per-attempt keys do not prevent duplicate collection

**Plan:** §4.2, §4.5–4.7.

**Verified:** The copied job pattern uses `FOR UPDATE SKIP LOCKED`, expiring leases and a fresh lease token (`20261006143000_parent_email_lifecycle.sql:67–84`). The existing webhook ledger claims an event ID and can reclaim after five minutes (`20260928191213_task0041_webhook_replay.sql:29–55`). Stripe's [idempotency reference](https://docs.stripe.com/api/idempotent_requests) says retained keys can be removed after at least 24 hours. Webhook event delivery is not an order-level financial lock ([webhook behavior](https://docs.stripe.com/webhooks)).

**Unverified — design risk:** Worker A charges successfully and dies before persisting the result; worker B reclaims and increments `attempt_count`, then creates a second PaymentIntent with a different key. A separately created recovery Checkout can also charge while the original retry succeeds. Idempotent access grants do not undo either duplicate charge. The proposed selector does not explain how a crashed `charging` row is ever reclaimed.

**Proposed change:** Specify a durable order/payment state machine with **one authoritative PaymentIntent per obligation**, separate business attempts from HTTP retries/lease claims, and persist the payment-object identity. Network retries reuse the same operation and parameters. Unknown outcomes enter reconciliation; they never authorize a new charge. Reclaiming an expired `charging` lease retrieves/reconciles the existing object. Use lease-token compare-and-set writes so an old worker cannot overwrite newer state. Idempotency keys must cover customer/setup/recovery creation as well as charging; never rely on their retention for permanent uniqueness.

Recovery must atomically take over collection, stop automatic retry, and preferably complete the same intent on-session. If a new payment-mode Checkout is used, conclusively retire the original cancelable intent, persist one live recovery Session and expire superseded Sessions before enabling another payment path. A processing/unknown payment cannot be assumed canceled. See [PaymentIntent cancellation](https://docs.stripe.com/api/payment_intents/cancel).

Cancellation must serialize with the claim and recovery paths. A successful pre-charge cancel revokes only this order's trial, suppresses future attempts and cannot be reversed by a late setup/success event. Define the handling when a payment is already in flight; a database status change alone cannot guarantee that a network request already accepted by Stripe never settles. Do not report “canceled, no charge” until the financial state is known. This boundary needs the decision identified at the end.

### 4. Blocking — Option B's actual sequence can finalize an empty invoice

**Plan:** §4.5 Option B; §4.9.

**Verified:** The [invoice-create reference](https://docs.stripe.com/api/invoices/create) defaults `pending_invoice_items_behavior` to `exclude`. The draft creates a pending invoice item, then creates an invoice without including it. The [invoice-item API](https://docs.stripe.com/api/invoiceitems/create) supports explicitly attaching an item to a particular invoice.

**Unverified — design risk:** The invoice is empty, can become paid at $0, and `invoice.paid` is incorrectly treated as the agreed nonzero purchase. The unattached item can remain for a later invoice. The fallback may also accidentally retain an inherited customer discount or an earlier draft/item.

**Proposed change if B is retained:** Create one invoice per order with `auto_advance:false`, explicitly attach its item, control inherited discounts and pending items, and check the final currency, line ownership, amount and actual settlement against the locked quote. Idempotently persist every intermediate object. If a promotion cannot be applied, replace the draft's pricing with the exact locked net amount without leaving duplicate items/invoices. Automatic collection and dunning must not exceed the agreed one retry/one-day policy; Cramapple owns reminders when automation is off. See [invoice advancement](https://docs.stripe.com/invoicing/integration/automatic-advancement-collection).

**Verified:** Basil removed `Charge.invoice`, `PaymentIntent.invoice` and the old single-payment fields from Invoice; the pinned Dahlia API is later. The proposed `charge → invoice` refund pointer is invalid. Use stored PaymentIntent/order associations or the InvoicePayment relationship described in [Stripe's breaking-change notice](https://docs.stripe.com/changelog/basil/2025-03-31/add-support-for-multiple-partial-payments-on-invoices). A paid invoice alone is not evidence that the expected nonzero card charge was collected for this order.

### 5. Blocking — the promotion evaluator and capacity ledger are incomplete

**Plan:** §4.3, §4.5, §4.8.

**Verified:** Current code only looks up one active code (`create-checkout-session/index.ts:82–95`; parent equivalent `create-parent-payment-link/index.ts:53–62`) and lets payment-mode Checkout enforce restrictions. The matching Dahlia SDK's [PromotionCode schema](https://raw.githubusercontent.com/stripe/stripe-node/v22.0.0/src/resources/PromotionCodes.ts) puts `customer` at the top level and the coupon under expandable `promotion.coupon`, not under `restrictions` or an assumed old top-level coupon field. [Stripe's coupon/promotion rules](https://docs.stripe.com/billing/subscriptions/coupons) distinguish coupon and code limits and first-transaction restrictions.

**Unverified — design risk:** “Stripe redemptions plus live trial reservations” stops counting Option A conversions after their reservations disappear. Multiple codes sharing a coupon can exceed its separate cap. Customer-restricted codes cannot always be checked before parent card entry because the actual payer/customer is not yet known. A local hold does not reserve capacity in Stripe's separate hosted/pay-now paths.

**Proposed change:** Specify the evaluator against the pinned schema and parity-test it against Stripe. Include:

- Code activation/expiry, customer scope and both code-level and coupon-level maximum/redemption counts; coupon `valid` and `redeem_by`.
- All minimum-amount currency restrictions/options, amount-off currency options, percent/fixed amount arithmetic, deterministic minor-unit rounding/clamping and product applicability. Check the actual Stripe Price/product, fixed USD one-time pricing, supported quantity and minimum charge amount. Unsupported pricing/discount shapes fail explicitly.
- Resolve the actual payer/customer before customer-specific checks; do not use a new Customer to pretend an existing payer has no transaction history. `list().data[0]` is insufficient when matching customer-scoped promotions exist. Stripe “first transaction” and “never had a Cramapple trial” are separate rules.
- Atomic capacity accounting at both coupon and code level, with one reservation per pending/active order. Conversion moves the reservation to a **permanent local redemption** for Option A; cancellation/abandonment releases it. Define failed/recovered/refunded consumption without decrementing a use merely because a payment object changes.
- Expiring pending quotes, idempotent edits, session-creation failure cleanup, Stripe/local reconciliation and protection against an email/promo reservation being held indefinitely by abandoned sessions.
- A defined policy for ordinary pay-now checkouts, $0 checkouts and external/dashboard redemptions. If any route can redeem outside the same admission control, strict global `max_redemptions` cannot be promised using local holds alone. Dedicate trial codes or bring all relevant Cramapple routes under coordinated accounting, and explicitly resolve residual external-race risk with David. Never count the same native redemption twice.

For Option B, applying a native discount is not proof of successful collection; fallback pricing is still local-only discount usage. Do not advertise B as eliminating the ledger. Freeze the accepted price and discount calculation; expiry/exhaustion at day 7 never raises the charge. Parent hosted setup has no native promo box to preserve: define how a parent requests a revised quote/code before confirming setup.

### 6. Blocking — eligibility, order state, entitlements and notifications need atomic transitions

**Plan:** §4.2, §4.4–4.5, §4.8–4.9.

**Verified:** Existing entitlement uniqueness is `(user_id, subject_id, access_tier, source)`; its dates require `ends_at > starts_at` (`20260731160200_free_score_check_growth_funnel.sql:8–27`). Existing cardless history is keyed to a user and `source='trial_v1'` (`20260815175854_trial_entitlement.sql:38–43`). The grading gate checks current status and time window (`20260815181856_retire_free_score_check.sql:25–36`).

**Unverified — design risk:** “Rows that reached trialing” is history, not a current-status predicate. A partial index that drops canceled/expired/refunded rows reopens eligibility. `expired_unpaid` currently means both never completed setup and used a trial but failed payment. Independent Supabase API writes can leave `trialing` without all subjects or leave grants without the required notifications. Per-event deduplication does not prevent later events from resetting seven days.

**Proposed change:** Define an immutable `trial_started_at`/consumed marker and enforce a unique normalized student-email key whenever it is present, across every terminal status. Normalize consistently with `trim` and case folding; do not silently invent plus-address/dot or fingerprint rules. Backfill retained legacy `trial_v1` eligibility by its student email before allowing new trials, including canceled/expired history. Preserve the consumed key through account email changes/deletion according to an explicit retention policy; the old entitlement FK currently cascades on profile deletion. Never count the parent's email. Item 14 remains open as David directed.

Reserve one pending setup per student email atomically; bind eligibility, quote, Session and promo reservation so a direct checkout and parent link cannot both start trials. Abandoned pending rows need expiry/cleanup. Recheck under lock at activation: knowing an email before card entry does not eliminate concurrent eligibility races. Preserve an existing pending attempt or explicitly expire/replace it rather than creating a new Session on each frontend edit.

Use service-only transactional RPCs for activation and terminal transitions: lock the order, validate expected state, write all entitlement changes, consumption and notification-outbox intents together. External Stripe calls remain a durable reconciled workflow outside that transaction. Do not make email-provider availability part of the entitlement transaction. Provide an authenticated, sanitized Account/status API because the service-only table cannot be read directly by the app. Reject client updates to money, subjects, payer/customer IDs, status and consent versions.

At conversion, **end/revoke this order's trial rows**, rather than “leave them to lapse.” A prompt refund during grace must not leave residual trial access. Refunds/cancel must identify this order's grants, never every entitlement for the user or an unrelated paid/beta purchase.

### 7. Blocking — required trial notices have neither a complete contract nor demonstrated delivery

**Plan:** §2, §4.1a, §4.4–4.7, §4.10–4.12, §6.

**Verified:** The legacy Loops event is sent only with `marketing_email_opt_in === true` (`start-trial/index.ts:93–104`), and the helper can return without sending or only log a failure (`_shared/loops-client.ts:15–41`). This is not a guaranteed transactional notice. The current parent lifecycle is an unpaid Checkout-link reminder/expiry flow: it requires an integer Session amount and `unpaid` (`_shared/parent-email-lifecycle.ts:83–95`) and cancels jobs on Session completion (`:380–386`). It is not a day-7 trial-charge reminder.

**Verified, Development read-only:** `pg_cron 1.6.4`, `pg_net 0.20.3` and Vault `0.3.1` are installed. The three cron jobs are session-target sweeping, BYOQ pairing expiry and BYOQ purge. None directly calls the email worker; their referenced app functions contain no email-worker call. Source has no scheduled invocation in the reviewed runtime/migration/workflow paths. `deliver-transactional-email/index.ts:19–23` processes payment and parent-link jobs only. **Unverified:** external schedulers, live Loops journey state, Production worker schedule/configuration and actual trial notice delivery.

**Proposed change:** Make protected worker scheduling, templates/flags, retries and real controlled-inbox delivery explicit release gates. Implement new order-driven transactional trial jobs independent of marketing opt-in. Separate setup-link abandonment from trial reminders. Deduplicate by order, outcome and recipient; send one email per bundle, not per entitlement. Recheck state immediately before sending so a paid/canceled order gets no stale demand for payment.

The notification contract must cover both recipients for parent-pay at start, pre-charge reminder, failure/recovery status, cancel and conversion, plus expiry/final-failure and refund outcomes under item 13. Parent receives payment recovery; the student's failure notice must not expose the parent's recovery credential/card details. Both can cancel through their permitted route. Capture exact amount/date and clear “parent started your trial” / “parent paid” wording. Define notice timing (recommend day 5, 48 hours before collection), delivery escalation and behavior if required notice cannot be delivered. The owner now requires a fresh notice before delayed collection after an outage.

### 8. Blocking — conversion/recovery/refunds cannot reuse Session-based fulfilment unchanged

**Plan:** §4.5–4.6, §4.9.

**Verified:** Ordinary fulfilment resolves identity from `client_reference_id` or supported purchase metadata (`stripe-webhook/index.ts:325–335`), reads offer from `metadata.mode` (`:338`) and subjects from `subject_ids` (`:357–367`). The proposed recovery metadata contains only purpose/order ID. Refund revocation maps PaymentIntent to Checkout Session (`:612–643`); refund email independently repeats that lookup (`:567–580`). Receipt enqueue requires a paid Session/PaymentIntent (`:539–546`). Current completion reconciles a refunded charge before sending confirmations (`:473–492`).

**Unverified — design risk:** Recovery fails, a bundle defaults to the wrong offer, parent identity is lost, sessionless refund emails disappear, or a late success regrants an already refunded order.

**Proposed change:** Build a common order/payment resolver used by conversion, recovery, receipts, refund notifications and revocation. Validate current Stripe amount received/currency/customer/payment identity against the immutable order, not client metadata alone. Share lower-level grant code through an order-driven adapter; do not fabricate a Checkout Session to get through the existing path. Link every replacement payment to the same obligation and reconcile terminal order/current refund state on all success events. Full refund revokes this conversion grant; partial refunds keep access as today. A late failure must not downgrade a converted order, and a late success must not silently restore a canceled/refunded order. Add operator-visible reconciliation for contradictions.

### 9. Should-fix — define the trial clock and grace precisely

**Plan:** §4.1, §4.3, §4.4 step 6, §4.5, §5.

**Verified:** The draft says trial starts at purchase but sets dates from webhook-handler `now()`. The existing grading gate denies access when `ends_at <= now()` (`20260815181856:25–36`). A 15-minute billing poll can therefore leave an access gap before a failed charge is processed; webhook delay adds more.

**Unverified — design risk:** A delayed/replayed event moves the charge date or extends the trial; a parent completes a link many hours after its displayed charge date was computed; repeated failures add another grace day; the proposed retry at original end +23h is already overdue after a long delay.

**Proposed change:** Persist one authoritative completed-setup timestamp from verified Stripe completion evidence, not delivery/retry time, and derive the seven-day end once. Define quote validity and explain “seven days after you finish setup” before completion when a parent link's actual completion time is unknown; the confirmed exact date goes in the result and email. Never charge earlier than the disclosed date. Bind the displayed quote/mandate to the confirmation, including after a subject or promo edit.

Record immutable `first_payment_failed_at`, `grace_ends_at` and maximum business retry count. Implement the handoff's specified rule: `grace_ends_at = original_trial_ends_at + 24 hours`, applied **once**, atomically and idempotently to this order's entitlements; no further extension on retry/replay. Preserve the planned retry near original end +23 hours and define handling when processing is already too late; do not silently move it beyond grace. Handle the pre-webhook access boundary explicitly. Authentication failures enter `requires_action` with the same grace and no blind automatic retry. Distinguish retryable declines, hard declines, processing, API outages and unknown outcomes; an HTTP/network error is not evidence of a declined card.

After grace, access lapses and only the owner-approved voluntary recovery remains. No automatic retry is authorized during those 30 days. The outage policy must say how long after notice a delayed charge can occur and what happens to access while billing is paused.

### 10. Should-fix — pin an SDK compatible with the API and verify the exact setup UI

**Plan:** §2.1, §4.1a, §4.3, §4.11, §5.

**Verified:** `_shared/stripe.ts:1,22` imports floating `stripe@17` and casts `2026-03-25.dahlia` to its old API type. Stripe-node [v22.0.0's version source](https://raw.githubusercontent.com/stripe/stripe-node/v22.0.0/src/apiVersion.ts) matches that API exactly. Its [Session schema](https://raw.githubusercontent.com/stripe/stripe-node/v22.0.0/src/resources/Checkout/Sessions.ts) exposes `elements` and `hosted_page`, setup customer creation and setup data. Old types are not evidence that a later schema/resource relationship is correct.

**Proposed change:** Pin an exact compatible SDK and Deno dependency resolution; retain the agreed API version unless separately changed. Include ordinary paid/$0/parent/add-on/refund regression in that prerequisite. Use the pinned API's vocabulary (`hosted_page`, not a copied old `hosted` value) and an explicit supported card allowlist (`allowed_payment_method_types`), removing the draft's “or payment_method_types” ambiguity. See the fact-check table below for the boundary between documented parameters and unproven combinations. The plan's blanket “Verified” label for exact setup + Elements support should be qualified until demonstrated.

### 11. Should-fix — retirement has confirmed frontend callers and needs an ordered cutover

**Plan:** §4.1, §4.10–4.11, §6.

**Verified, Lovable source:** Marketing project `61dd6602-6991-4561-b418-e988bb7c8a0b`, snapshot `d4c78849ebbde94cee1fd16ae954f3399589d38d`, still has:

- `src/lib/trial.ts:29–37`: `startTrial()` invokes `start-trial`.
- `src/routes/trial.tsx:49`: signed-in route automatically calls `startTrial`; `:241` still promises no credit card.
- `src/routes/trial.verify.tsx:32`: verification route calls `startTrial`.
- `src/routeTree.gen.ts:46,99`: both routes are registered.

**Verified, Lovable source:** App project `56cae479-f7c9-4988-b536-56538c38ee4e`, snapshot `d3cd9b0443ed19d6845835276a94d18bd244cea7`, redirects its `/trial` and `/trial/verify` routes to marketing (`src/routes/trial.tsx:4–5`, `trial.verify.tsx:4–5`); they are not proof the path is retired.

**Unverified:** These are editor source snapshots, not a verified published-commit mapping or a completed public-browser flow. Public `/trial` retrieval did not succeed through the web tool. No trial was started. No comprehensive published-bundle/CTA inventory was performed, and absence of callers for `legacy_authenticated`/`parent_gift` has not been established.

**Proposed change:** Replace/redirect both cardless routes and handle old verification links before making `start-trial` return 410. Stop automatic grants on authentication, remove no-card/every-subject promises, preserve only existing access, and test saved links plus both domains. Revoke RPC execute from `service_role` as well as client roles when retiring it; existing client roles were already revoked (`20260815175854:98–99`). Keep historical consumption. Define pay-now behavior for retained legacy purchase types instead of assuming they have no caller.

### 12. Should-fix — cancellation/recovery links need a new capability design

**Plan:** §4.1a, §4.6–4.7.

**Verified:** The copied short-link helper generates an eight-character random code (`_shared/parent-short-link.ts:7–25`); it does not sign it or enforce single use. The resolver classifies a completed Session as paid (`:57–67`), even if it only saved a card.

**Unverified — design risk:** An email preview/scanner consumes a “single-use” recovery link, repeated opens create multiple payable Sessions, or a generic order token allows a student to act as the parent payer. A successful setup reopened through the parent link falsely says paid.

**Proposed change:** Define scoped, high-entropy, expiring capabilities stored safely, with separate cancel and payer-recovery purposes. GET displays a confirmation/status page without mutating or consuming the action; an explicit authenticated/capability-authorized POST performs an idempotent action. Student cancellation requires verified order ownership; a parent capability permits only its intended order/action. Redact credentials from logs/analytics/referrers and rate-limit endpoints. Single-use redemption must allow a safe resume of the already-created recovery operation after browser/authentication interruption. Expire recovery after the 30-day window and on cancel/refund/payment. Parent short-link resolution needs `trialing` and terminal order states, not just open/paid/expired.

### 13. Should-fix — launch order, rollback and acceptance tests do not yet protect existing trialers

**Plan:** §4.3, §5–6, §9.

**Verified:** TASK-0058 A0 explicitly requires a Development-connected frontend before checkout acceptance. The plan enables trial admission before enabling the charge worker. Its rollback can leave trialers' access expired while billing is paused. New analytics names are absent from `_shared/growth-events.ts:3–21`; the database also enforces an event-name check (`20260731160200:166–170`, subsequently extended by named migrations).

**Unverified — design risk:** New trials are admitted before there is a working cancellation/recovery/notice/collection system; frontend and backend disagree about whether a request is trial or pay-now; an SDK/event-name mismatch leaves partial fulfilment. Stripe test clocks do not by themselves advance Cramapple's PostgreSQL deadlines or cron worker.

**Proposed change:** Finish A0 first as a separately tracked prerequisite, then prove direct and parent flow end to end in Development. Server eligibility and launch flags must determine billing behavior, not an optional client `trial:true` flag under a universal-trial policy. The server returns the billing mode and exact display contract; reject a stale/mismatched frontend rather than unexpectedly charging a visitor who saw trial copy. Bundle the analytics type/database contract update with the additive data work.

Ship and verify the fail-closed webhook guard first. Then deploy dormant schema, order handlers, status, cancellation, recovery, scheduled transactional notices, collection/reconciliation and observability. Verify credentials/gateway authentication, scheduler heartbeat and the complete browser flow **before admitting the first trial**. A custom worker bearer secret requires compatible Edge gateway/JWT configuration; copying the handler check alone is insufficient. Worker RPCs/wrappers must be service-only with fixed search paths and bounded batches. No public invoke/claim grants or printed Vault values.

Direct-first/parent-second may be a test sequence; excluding parent trials in a public rollout while advertising a universal trial requires an explicit staged-launch decision. Retire cardless grants only with the compatible frontend change. Production trial duration stays 604800 seconds; accelerated live smoke tests must be explicit per-order exceptions with matching disclosures, not a global duration switch or casual timestamp edit.

Rollback must distinguish stopping **new admissions** from managing existing obligations. Preserve the compatible handlers and cancel/status/recovery paths for existing orders; quarantine uncertain payments, suppress stale scheduled messages, notify before delayed charging and reconcile before reenabling workers. Define outage access policy. Additive migrations alone are not a complete rollback.

## Consumer inventory: required setup/conversion changes

All locations below are **Verified in source**; the last column is a **proposed change**. No deployed behavior is asserted.

| Consumer | Evidence | Required plan coverage |
|---|---|---|
| Settlement helper / lifetime grant | `_shared/checkout-access.ts:23–27`; `stripe-webhook/index.ts:204–229,437` | Branch by Stripe mode; keep $0 payment fulfilment. |
| Session retrieval/persistence | `stripe-webhook/index.ts:154–164,175–198` | SetupIntent expansion; separate offer/Stripe mode; nullable amount/PI. |
| Offer/identity/subject resolution | `stripe-webhook/index.ts:325–389` | Explicit order-driven adapter for conversion/recovery; preserve parent type. |
| Customer persistence | `stripe-webhook/index.ts:293–317,403–405` | Direct-only guard inside helper; setup PM ownership checks. |
| Post-grant refund reconciliation | `stripe-webhook/index.ts:473–492` | Current charge/order state for sessionless success/replay. |
| Learner confirmation | `stripe-webhook/index.ts:495–502`; `_shared/payment-email.ts:25–38,53–67` | Separate start/conversion messages; student recipient plus payer notice. |
| Payer receipt | `stripe-webhook/index.ts:535–551`; `_shared/payer-email.ts:117–138` | Reuse charge builder with authoritative order; handle missing payer email explicitly. |
| Payer refund notification | `stripe-webhook/index.ts:555–587` | Resolve sessionless order; maintain refund-ID dedupe. |
| Refund revocation | `stripe-webhook/index.ts:594–643` | PI/order association, or InvoicePayment graph for B; revoke only correct grant. |
| Before-webhook status fallback | `get-checkout-status/index.ts:80–95` | Setup processing is distinct from payment success; never grant from redirect. |
| Persisted checkout status/upsell | `get-checkout-status/index.ts:120–153,176–178` | Order state plus active time window; no paid-row-only polling or trial upsell. |
| Parent-link response | `create-parent-payment-link/index.ts:194–195` | Separate $0 today, locked future amount and date. |
| Parent request email | `send-parent-payment-email/index.ts:116–118,125–152` | No null-amount-to-$0 claim about the future charge; surface lifecycle failures. |
| Parent lifecycle | `_shared/parent-email-lifecycle.ts:83–95,261–283,380–412` | Separate setup abandonment from charge notices; locked order pricing. |
| Parent short-link resolution | `_shared/parent-short-link.ts:57–67`; `resolve-parent-link/index.ts:64–73` | Completed setup means trialing, not paid. |
| Add-on source eligibility | `create-post-purchase-addon/handler.ts:53–70,102–143` | Define source-order eligibility after conversion; preserve parent prohibition. |
| Cardless start/Loops journey | `start-trial/index.ts:65,93–104` | Retire grant/callers; do not reuse marketing-gated notices. |
| Analytics | `_shared/growth-events.ts:3–21,67`; migration `20260731160200:166–170` | Add/verify trial event contracts without duplicate purchase events. |

## Audit of the plan's §2 “Verified” assertions

| Assertion | Result and corrected evidence |
|---|---|
| Direct payment/Elements/customer creation/off-session saving | **Verified:** `create-checkout-session/index.ts:201,233,236–237`. |
| Catalog offers and no direct unlimited | **Verified:** `_shared/stripe-catalog.ts:16–82`; checkout `:48–80,149–152`. Some plan line offsets have drifted. |
| Promo lookup/application | **Verified in code:** checkout `:82–95,221–223`; restriction enforcement is a separate Stripe fact, not proven by lookup source. |
| Lifetime grant / no-payment-required gate | **Verified:** finding 1 and Stripe object docs. |
| One customer mapping per user, direct-only current caller | **Verified:** migration `20260928134000:61–75`; webhook `:293–317,403–405`. Helper itself is not guarded. |
| Add-on already charges saved card | **Correction:** it creates another **on-session Elements Checkout using the customer**, not a raw off-session charge; `create-post-purchase-addon/handler.ts:115–143`. It does not read the saved default-PM column. |
| Event handling throws on unknown types | **Verified:** webhook `:746–786`. Adding subscriptions without routes creates failures. |
| Webhook ledger/claim | **Verified:** webhook `:694–810`; migration `20260928191213`. It dedupes events, not obligations. |
| Expired trial loses grading access by time predicate | **Verified:** migration `20260815181856:25–36`. Other serving surfaces still need acceptance tests; this one function does not prove whole-app gating. |
| Cardless seven-day grant and Loops timing hook | **Verified:** migration `20260815175854`; `start-trial/index.ts:93–104`. **Unverified:** live journey timing/delivery. Marketing opt-in gate omitted from the plan. |
| Cron/lease patterns | **Verified in source:** migrations `20260928160000:194–223`, `20261006143000:67–84`; Dev extensions separately verified. The 20260821050000 comment is historical, not proof of today's availability. |
| Email outbox / no worker schedule in reviewed source | **Verified, bounded source search and Dev cron inspection. Unverified:** external/Production schedule. Queueing is not delivery. |
| API pin | **Verified:** `_shared/stripe.ts:22`; **correction:** imported SDK is floating major 17 at `:1`, with an API-version cast. |

## Stripe fact-check and limits of verification

No Stripe account API calls or test Sessions were made. Current docs can differ from an older pinned API; matching v22.0.0 SDK source was used to check its schema. The Stripe CLI could not run because its config chmod was outside the sandbox; the docs connector returned authentication-retry messages. Public official docs/SDK sources were the read-only fallback. Exact account/browser behavior remains a Development test.

| Question | Evidence and conclusion |
|---|---|
| Completed setup `payment_status` | **Verified:** [Session object](https://docs.stripe.com/api/checkout/sessions/object) explicitly describes setup under `no_payment_required`. No charge is implied. |
| SetupIntent usage | **Verified:** default is `off_session` ([SetupIntents](https://docs.stripe.com/payments/setup-intents)). Matching [Session types](https://raw.githubusercontent.com/stripe/stripe-node/v22.0.0/src/resources/Checkout/Sessions.ts) expose no `setup_intent_data.usage`. Assert actual succeeded intent usage/customer; quarantine unexpected values. |
| Setup + `ui_mode:'elements'` | **Verified:** matching Session schema exposes both values, setup data and currency. **Unverified:** an affirmative retrieved guide/example or executed test proving this exact combination for the pinned Cramapple integration. The requested Checkout save/reuse guide variant could not be fetched. Do not treat enum availability alone as browser proof. Make this the first Dev spike and stop/revise UI routing if unsupported. |
| Payment Element / Express Checkout / wallets | **Verified:** the lower-level SetupIntent flow supports Payment Element and [Express Checkout setup](https://docs.stripe.com/elements/express-checkout-element/accept-a-payment?payment-ui=elements). This does not independently verify Checkout Sessions + setup + both Elements in this app. **Unverified:** actual Apple/Google display and setup/mandate behavior across registered domains/devices. |
| Apple recurring/deferred request | **Verified:** [Apple merchant-token guidance](https://docs.stripe.com/apple-pay/merchant-tokens) says Checkout and Elements backed by Checkout Sessions request merchant tokens when needed. Do not transplant manual deferred/recurring Intents options into this integration without checking its API. This is one deferred purchase, not a recurring subscription. |
| Hosted setup/customer creation | **Verified:** [Session-create](https://docs.stripe.com/api/checkout/sessions/create) allows `customer_creation` in payment and setup; `always` creates at confirmation. Parent email can be collected then. Explicit pre-created parent Customer is an alternative, not a required post-completion repair. |
| Hosted consent checkbox | **Verified:** Session consent fields exist in matching schema. **Unverified:** exact hosted setup + required checkbox rendered with these settings. David's latest correction requires parent acceptance on parent-paid checkout; prove the required checkbox works, or provide another explicit payer-acceptance flow before admitting parent trials. |
| Hosted custom text | **Verified:** Session schema supports text near the submit button and after it; custom text is disallowed for Elements UI ([Session-create](https://docs.stripe.com/api/checkout/sessions/create)). `after_submit` is a location after the button, not proof of a post-completion page. **Unverified:** chosen text/layout in Dev hosted setup. |
| Discounts / setup amount | **Verified in matching schema:** setup has no payable line-item purchase; do not attach native checkout discounts as if charging today. **Unverified:** parity of our new evaluator until tested. |
| Off-session failures | **Verified:** the raw-Intents [save/reuse guide](https://docs.stripe.com/payments/save-and-reuse?payment-ui=elements) describes HTTP 402 with `requires_payment_method` and recovery by confirming the **same intent**, including authentication or a new method. The plan's claim that Stripe universally recommends a new payment-mode Checkout is too broad. Reconcile actual state; transport errors/processing are not this documented card-decline case. |
| Hosted invoice recovery | **Verified:** [hosted invoice page](https://docs.stripe.com/invoicing/hosted-invoice-page) provides payment/recovery. URL lifetime is not the app's 30-day policy; close/void unpaid collectible invoices when recovery ends, not only the application token. |
| Test clocks/cards | **Unverified:** exact proposed card sequence under this setup. Validate setup-then-decline fixtures; `4000…9995` must not be assumed to save successfully first. Test clocks do not run this app's PostgreSQL scheduler. Use controllable Dev order time and real worker/webhook execution. |

## Proposed state/data contract to add before coding

This section is **proposed**, not an existing schema or an approved new product rule. It makes findings 3/6/9 testable.

| State or transition | Required invariant |
|---|---|
| `pending_setup` | One live reservation per normalized student email; finite quote/setup expiry; no access or consumed trial yet. Store server quote/version, setup-creation idempotency and student Terms acknowledgment; additionally collect and bind the parent's required payer acceptance before parent-hosted setup completion. On direct checkout, the student's acknowledgment/acceptance satisfies both roles. |
| `pending_setup → trialing` | Verify Stripe setup/payer mandate, consume student-email eligibility once, persist fixed start/end, grant selected subjects and enqueue both-recipient intents atomically. |
| `trialing → charging` | Claim atomically with lease token; retain the same obligation/payment object. Include expired-lease reconciliation, not only fresh trialing rows. |
| `charging → converted` | Verified expected payment actually collected; paid grant + ended trial + order + outbox transition together. One paid conversion per order. |
| `charging → payment_failed` or `requires_action` | First definite failure records one grace boundary and one entitlement extension; preserve that boundary on every retry/event. `requires_action` is an explicit usable state, not an unreachable enum. |
| Retry | At most one additional automatic business attempt within grace for a permitted failure; no new business attempt for transport retries/claims, no blind auth retry. |
| Grace expiry | Access lapses; mark unpaid/recovery-only. Preserve consumed eligibility. No auto retry during 30-day voluntary recovery. |
| Recovery takeover | Serialize with charge/cancel; no second live payable path; preserve locked price and parent/student identities. |
| Cancel | Immediate revocation only of this order's trial; permanently stops its future collection and invalidates payment recovery; known in-flight outcome handled explicitly. |
| Refund | Partial retains paid access; full revokes only this order's conversion; no active grace/trial residue; no replay resurrection. |
| Never-completed setup expiry | Distinguish from a consumed-but-unpaid trial; release pending reservations and no consumed key. |
| Paused/unknown collection | Operational reconciliation state; no new charge object after ambiguous outcome; delayed charge requires notice under David's answer. |

Add constraints for allowed purchase types/statuses/currency, nonempty unique subject IDs, nonnegative amounts and `list_amount - discount_amount = charge_amount`, valid time ordering and phase-specific required Stripe IDs. Use actual subject UUIDs plus a display-key snapshot; current `subject_ids` metadata holds keys, not UUIDs. Store student Terms acknowledgment and actual payer Terms acceptance with their respective actor, version, timestamp and source, separately from payer mandate evidence; one direct-student action can populate both roles, while parent-pay requires both actors. Also retain immutable consent/quote versions, first failure/grace/recovery/cancel/conversion timestamps and reconciliation state. IP/user-agent records need defined access and retention; never put raw card data in this table.

Add unique partial indexes for non-null SetupIntent/PaymentIntent and one active recovery operation, due/lease indexes for trial and retry scans, and lookups for customer/refund reconciliation. Use immutable `trial_started_at is not null` or a separate consumption ledger for the used-email unique constraint; include every later state. Add bounded pending cleanup and terminal method-cleanup jobs. RLS plus explicit revoked client grants and service-only RPC execute permissions are required; RLS alone is not the entire privilege design.

## Development scheduling evidence and future read-only preflight

**Verified:** The MCP project listing identifies Development as `wmgjsdkphcyhngaffbqf` and Production as `pcntajvbdfqhbeewmdry`. All database queries in this review explicitly targeted **Development only**. No Supabase CLI project resolution was used. No secrets or cron command bodies were printed.

**Verified Dev result:** extensions `pg_cron=1.6.4`, `pg_net=0.20.3`, `supabase_vault=0.3.1`; `cron.job`, `app.transactional_email_outbox` and `app.parent_email_lifecycle_jobs` exist. Jobs: `task0019-sweep-session-targets` (`17 3 * * *`), `task0039-expire-byoq-pairings` (`*/15 * * * *`), `task0039-byoq-purge` (`7,22,37,52 * * * *`), all active. Their referenced functions do not contain an email-worker invocation. **Unverified:** arbitrary external schedules, all deployed worker source, live feature flags, downstream HTTP success and Production state.

The following is a **proposed future read-only preflight**, not a Production query performed or authorized by this review. First verify extensions; query `cron.job` only if present. In a later authorized Production inspection, an operator must explicitly select Production; never rely on a CLI default. If CLI is used for Dev, discover syntax via `--help` and pin `--workdir` to the verified Dev-linked repo.

```sql
select extname, extversion
from pg_extension
where extname in ('pg_cron', 'pg_net', 'supabase_vault');

select to_regclass('cron.job') as cron_job_table;

-- Deliberately do not return command bodies or Vault secret values.
select jobid, jobname, schedule, active,
       position('deliver-transactional-email' in command) > 0 as direct_email_call,
       position('charge-due-trials' in command) > 0 as direct_trial_charge_call
from cron.job order by jobid;
```

A wrapper can conceal an indirect call; inspect only its dependency/name and safe boolean source checks, then confirm recent job/HTTP status without returning credentials or response bodies. Provider delivery/inbox evidence is still needed. The old “pg_cron not installed” comment (`20260821050000:36–40`) cannot override these current Dev observations. Supabase documents the job and run-status tables in its [Cron guide](https://supabase.com/docs/guides/cron).

## Acceptance matrix and implementation slices

All items here are **proposed required evidence**, not tests run by this review. No new-flow test could pass because the flow is unbuilt.

| Area | Acceptance evidence missing from the draft |
|---|---|
| Basic flows | New/existing, signed-in/out, direct/parent, single/two/three subjects; selected-subject-only access; authenticated entry still requires verified session. |
| Eligibility | Simultaneous direct/parent starts, case/whitespace variants, legacy history including expired/canceled rows, pending abandonment/replacement, parent with multiple children, two purchases after one consumed trial. |
| Pricing | $1, 50%, $0 bypass, fixed/percent rounding, below-minimum nonzero amount, product and currency mismatch, shared-coupon cap, code/customer/first-time restrictions, expiry after locked signup and ordinary-pay-now/external redemption race. |
| Setup safety | Setup completed/expired/unknown/malformed purpose; succeeded SetupIntent ownership/usage; zero paid grants/emails/events; ordinary $0 paid purchase still works. |
| Consent | Student Terms acknowledgment on every trial, including before a parent request; payer Terms acceptance on every checkout. One direct-student action can satisfy both roles; parent-pay requires separate student acknowledgment and parent acceptance, with neither substituting for the other. Verify future-charge disclosure/action, stale quote re-consent and separate actor/version/timestamp/source evidence. |
| Collection concurrency | Two workers; stale lease; process death before/after Stripe acceptance and before DB write; repeat after idempotency retention; exact amount; only one collected obligation. |
| Cancellation/recovery | Student and parent cancellation; wrong student/token/purpose; cancel vs claim/webhook/recovery; retry vs recovery; scanner GET; resumed 3DS; superseded sessions; no new collection after effective cancellation/expiry, with in-flight payments reconciled under the boundary/refund policy. |
| Failure/grace | Setup-then-fail, authentication, soft/hard decline, unknown/processing; exactly one extension/retry; repeated/out-of-order failure does not extend or downgrade paid; end-boundary serving behavior. |
| Refund/replay | Refund before success, success after full refund, partial then full, old setup replay after cancel, event duplication across different IDs, charge/invoice/recovery mapping and truthful receipt/refund notices. |
| Notices | Both parent/student outcomes; correct payer identity; reminders independent of opt-in; canceled jobs suppressed; email outage/retry/ambiguous delivery; real controlled inbox receipts and correct Dev links. |
| App access/status | Grading, practice creation, Open Hand, notes/other gated APIs, Account, parent short link, return/polling, expired/read-only behavior; unrelated paid/beta access preserved. |
| Operations | Worker unauthorized request rejected, gateway configuration, heartbeat/lag, stuck/unknown order alerts, reconciliation drill, kill switches and outage/delayed-notice rollback. |
| Wallet/UI | Setup integration on pinned API first; supported Apple/Google devices/domains; authentication redirects; no-wallet fallback; accessible consent/cancel/recovery on narrow/mobile screens. |

Suggested independently reviewable slices:

1. **TASK-0058 A0 prerequisite:** isolated Dev checkout/auth/short links and Stripe test environment. Keep broad wallet-first/email redesign out of TASK-0077; only take session-lifecycle fixes required for stable reservations. Check its recorded post-pilot prerequisite before execution.
2. **Compatibility and safety:** exact SDK pin, fail-closed webhook routing, current payment/$0/parent/add-on/refund regressions. Prove exact setup UI support before committing to the frontend design.
3. **Data and order engine:** migration, consumption/promo ledger, transactional transitions, due/retry/reconcile/cleanup jobs; concurrency tests before any collection.
4. **Direct and parent setup:** identity, quote, required student Terms acknowledgment on every trial, payer Terms acceptance and mandate, order-aware status/short links and selected-subject trial grants. Parent-pay records both student and parent actions.
5. **Collection and recovery:** one payment obligation, cancel, grace/retry, 30-day voluntary recovery, refunds/receipts and parent credential cleanup.
6. **Notifications and app experience:** transactional templates/worker/delivery, account/banner, both-recipient matrix and cardless-route retirement. Existing Loops rollout gaps are dependencies, not solved by changing copy.
7. **Release/rollback evidence:** Dev full-flow and failure matrix; owner-approved Production changes and disclosed $1 smoke/refund; admit no trial until its complete lifecycle is operating. Apple Pay domain/configuration work can be separately tracked without blocking card fallback if the owner accepts that wallet availability scope.

## Option A/B recommendation

**Recommend Option A for v1:** a saved-card setup followed by one authoritative off-session PaymentIntent for the locked order. This matches the agreed one-time purchase and avoids reapplying a discount that can expire before collection. Reuse the charge-based receipt/refund builders through an order adapter. Correct the draft's implication that A lacks any receipt: a Charge can supply receipt information; an Invoice is a separate feature.

| Concern | Option A | Corrected Option B |
|---|---|---|
| Locked price | Exact stored amount is the charge input. | Must control native pricing/discounts and validate/fallback to locked amount. |
| Promotions | Requires permanent local redemption ledger; Stripe counters do not move for the PI discount. | Native application can update reporting, but expiry/cap fallback and reservations still require the ledger; not proof of collection. |
| Recovery | App-owned on-session recovery, preferably same PI; replacement Checkout must be fenced. | Hosted invoice page helps, but collection/automation and expiry must match app policy. |
| Refunds | Charge → stored PI/order association. | Stored mapping or InvoicePayment graph, not removed invoice pointers. |
| Events | PI success/failure plus explicit authentication/processing/reconciliation handling; preserve charge/refund events. | Invoice paid/failure plus action-required/finalization/void/collection reconciliation as applicable; preserve charge/refund events. |
| Retry control | App owns exactly one retry and no post-grace auto collection. | Disable Stripe automatic advancement/dunning; app owns the same controls. |
| Implementation surface | Smaller, but still requires order-based fulfilment/notice/refund design. | More API objects/partial-failure states; choose if invoices are a separately desired feature. |

This is a **recommendation**, not an owner decision to implement A. Both options need webhook subscription/version verification in the test and live environments, application reconciliation and the same parent/consent safeguards. Do not substitute a subscription trial: the product is a single deferred purchase.

## Decisions still needed from David

The settled DECISION-0126 rulings are not reopened. Record the three review-session clarifications above before implementation; the following details remain **Unverified/open**, with recommendations provided so the plan can be finalized:

1. **Option selection:** approve Option A, or require invoices as a feature and accept corrected B's scope.
2. **Cancellation at the collection boundary:** define the latest point at which “cancel with no charge” can be promised and the treatment if Stripe already accepted an in-flight payment. Recommend stopping all new collection immediately, reconciling, and a documented refund remedy where needed; never falsely confirm no charge while outcome is unknown.
3. **Delayed-charge notice:** choose the notice lead time and whether access remains available while our billing is paused. Recommend a clear re-notice period before any late automatic attempt, keeping the price locked. The ordinary failed-payment rule stays original trial end +24 hours; an outage remedy is a separate case.
4. **Promotion capacity across systems:** choose dedicated/coordinated trial-code accounting or explicitly accept the remaining race with Stripe/dashboard/external pay-now redemption. Recommend coordinated accounting; do not claim strict caps based solely on local reservations.
5. **Parent promo editing:** confirm where a parent can enter/change a code before setup, since hosted setup has no native discount box. Recommend an order quote/review step before the hosted page, without changing the already-set student-email requirement.
6. **Post-conversion add-on:** retain no add-on during trial and none for parent-pay. Decide whether direct single-subject conversions should regain the existing pay-now add-on using an order-based eligibility source; it will not work automatically from the original setup Session.
7. **Release scope and readiness:** if public parent trial admission follows direct trial admission, approve that temporary exception to every-checkout scope. Approve final wording/refund/access promises and the required live-change gates after the Dev evidence exists. Required payer acceptance does not itself establish wording accuracy; no legal reviewer or legal-compliance result was established here.
8. **Item 14:** the parent's own-email edge case remains open at David's express request. Do not invent an extra payer-email restriction while implementing student-email eligibility.

**Review verification:** A fresh independent reviewer read the integrated report, full plan, DECISION-0126 and targeted source and found no material unsupported claim or owner-decision mismatch. The suggested cancellation-test wording was clarified above. David subsequently clarified both Terms requirements: student acknowledgment always, plus acceptance by whoever pays. All affected findings, schema guidance and acceptance tests were updated consistently. Local document validation and `git diff --check` passed. No application tests, new trial execution, payments or sends were run; acceptance evidence above remains prospective.

**Next owner/action:** Claude/conductor revises the plan against these findings and David's open answers; Codex reviews the corrected plan before implementation approval. The original plan is unchanged. This report approves no migration, deployment, Stripe change, Terms publication or Lovable publication.
