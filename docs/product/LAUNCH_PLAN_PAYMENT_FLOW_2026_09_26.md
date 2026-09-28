# Launch Plan — Purchase Funnel / Payment Flow — 2026-09-26

**Status:** Draft  
**Owner:** David Bloom  
**Tier:** Hard-Gate  
**Implementation Task:** `docs/tasks/TASK-0041-LAUNCH-PAYMENT-FLOW.md`  
**Technical Spec:** `docs/product/PURCHASE_FUNNEL_TECHNICAL_SPEC_2026_09_27.md`  
**Historical foundation:** `docs/tasks/TASK-0023-STRIPE-SETUP-AND-LAUNCH-READINESS.md`

> **REWRITTEN 2026-09-27.** This plan now governs implementation of the **new TASK-0041 purchase funnel**.  
> The prior framing of this document as a wrapper around TASK-0023 / a narrow "verify-and-fix" pass is superseded.  
> TASK-0023 remains historical implementation context for the existing Stripe, webhook, entitlement, refund, and parent-gift plumbing.  
> TASK-0041 is the active implementation task for the redesigned purchase experience.

## 1. Product goal

Build the new Cramapple purchase funnel described in the Product Owner's 2026-09-27 checkout brief and in
`PURCHASE_FUNNEL_TECHNICAL_SPEC_2026_09_27.md`.

The result should let a student:

1. select one or more AP subjects;
2. enter a mobile-first, single-page checkout;
3. pay directly using Apple Pay, Google Pay, Stripe Link, or card; or
4. choose **Ask a Parent to Pay**, share a parent-payment link, and have the parent complete payment without creating a Cramapple account;
5. receive the purchased student entitlement only after verified Stripe payment;
6. see an immediate confirmation / activation state;
7. optionally accept a non-blocking post-purchase add-on offer when eligible.

This is an implementation project, not merely a verification exercise.

---

## 2. Relationship to the October 2 free launch

`DECISION-0071` remains in force: the October 2, 2026 launch is free and does not depend on paid checkout.

Therefore:

- TASK-0041 is **not a blocker for the October 2 free launch**;
- the purchase funnel may be designed and implemented independently of that launch;
- no paid gating should be introduced into the October 2 free-launch path unless separately approved;
- production enablement of the new paid funnel remains a Hard Gate.

"Not launch-critical" does **not** mean "do not implement." It only means the free launch does not wait for this task.

---

## 3. Source of truth

Implementation agents should use these sources in this order:

1. `docs/tasks/TASK-0041-LAUNCH-PAYMENT-FLOW.md` — active governed task.
2. `docs/product/PURCHASE_FUNNEL_TECHNICAL_SPEC_2026_09_27.md` — implementation-level product/technical specification.
3. This plan — sequencing, dependencies, gates, and QA expectations.
4. `docs/product/ARCHITECTURE_AND_DESIGN_DECISIONS_CURRENT.md` — current architecture/design constraints.
5. `docs/new_design/` — visual design system.
6. `docs/tasks/TASK-0023-STRIPE-SETUP-AND-LAUNCH-READINESS.md` — historical/backend reference only.

If TASK-0023 conflicts with TASK-0041 or the technical spec, TASK-0041 / the technical spec govern for the new funnel unless a higher-authority decision says otherwise.

---

## 4. Current state to preserve

The purchase system is **not greenfield**.

Existing backend behavior already includes:

- `supabase/functions/create-checkout-session`;
- `supabase/functions/stripe-webhook`;
- Stripe Checkout Session creation;
- Stripe webhook signature verification;
- webhook event idempotency via `app.stripe_webhook_events`;
- checkout-session persistence via `app.stripe_checkout_sessions`;
- paid entitlement grants via `app.subject_entitlements`;
- parent-gift attribution;
- refund entitlement revocation;
- async payment success/failure handling;
- growth-event recording.

A real production purchase previously cleared the system. Treat that as evidence the historical path worked at least once, not as evidence the new funnel is complete.

The implementation goal is to **reuse and extend this fulfillment architecture** while replacing the customer-facing purchase experience with the new funnel.

---

## 5. Scope of TASK-0041

### 5.1 Student checkout

Implement a mobile-first, single-page checkout on the marketing surface.

Required:

- compact order summary;
- current subject selection and authoritative total;
- Stripe Express Checkout Element above card entry;
- Apple Pay / Google Pay / Link when available;
- Stripe Payment Element as fallback;
- student email as the only Cramapple-owned required identity field before payment;
- no password before payment;
- no shipping UI;
- hidden/collapsible promo code entry;
- sticky bottom purchase CTA;
- visible **Ask a Parent to Pay** secondary action.

### 5.2 Anonymous direct purchase

The new direct checkout must allow an unsigned-in student to pay.

After verified payment:

- resolve an existing student account by normalized email or create/invite one;
- associate the Checkout Session with the student;
- grant the purchased subject entitlement(s);
- send activation/access instructions.

An existing signed-in student should reuse the verified account identity rather than create a duplicate account.

### 5.3 Ask a Parent to Pay

Implement a first-class parent-payment path.

Required:

- student generates a server-created Stripe hosted Checkout Session;
- student can copy the link, use native share, or send it by transactional email;
- parent opens the link without Cramapple authentication;
- parent pays without creating a Cramapple account;
- payer identity remains distinct from student entitlement ownership;
- verified webhook grants access to the student.

Preserve backwards compatibility with the existing `parent_gift` path while introducing the new `parent_share` behavior where appropriate.

### 5.4 Promo codes

Required:

- promo field collapsed by default;
- Stripe promotion-code support;
- optional URL auto-apply behavior;
- server-authoritative price calculation;
- invalid/expired codes fail gracefully without losing subject selection.

### 5.5 Confirmation

Required:

- success/processing state that does not trust the redirect as proof of payment;
- server-confirmed entitlement/payment state before showing final "Access Unlocked";
- student activation guidance;
- payer-specific parent confirmation when a parent completes payment.

### 5.6 Post-purchase add-on

Implement the proposed non-blocking add-on path for eligible single-subject purchases.

Required:

- original purchase remains complete regardless of add-on;
- exact add-on charge shown before consent;
- offer eligibility and amount resolved server-side;
- reuse saved Stripe Customer/payment method where permitted;
- authentication fallback when issuer requires it;
- separate verified payment before granting the new entitlement.

The specific add-on subject and discount are configurable product inputs, not hard-coded assumptions.

---

## 6. Pricing and offers

Current decided prices remain:

- **Single subject:** $39.99
- **Two-subject bundle:** $79.99
- **Three-subject bundle:** $99.99
- **Unlimited:** deferred / not marketed

The technical implementation must not substitute the $29 examples from the external design brief.

### Open pricing issue

$79.99 for two subjects is one cent more than two $39.99 single purchases ($79.98).

Do not silently change this.

Before updating Stripe catalog prices or presenting bundle-savings language, Product Owner confirmation is required.

---

## 7. Technical approach

The preferred implementation is defined in `PURCHASE_FUNNEL_TECHNICAL_SPEC_2026_09_27.md`.

Core architecture:

- direct student checkout: Stripe Checkout Sessions with custom UI / Elements where supported;
- express wallets: Stripe Express Checkout Element;
- fallback card/other methods: Stripe Payment Element;
- parent share: Stripe-hosted Checkout Session;
- entitlement authority: existing Stripe webhook;
- client redirect: never authoritative for entitlement;
- server: resolves all Price IDs and validates subject selection;
- existing refund and webhook-idempotency behavior: preserved;
- post-purchase add-on: server-created follow-on payment using saved customer/payment method where permitted.

If the installed Stripe SDK/API version cannot support the specified custom Checkout Sessions approach, the implementation agent must document the incompatibility and propose the smallest compatible alternative before changing architecture.

---

## 8. Implementation phases

### Phase A — Read-only verification

Before code changes:

1. verify current marketing checkout routes in Lovable project `61dd6602`;
2. verify authenticated app handoff where relevant in `56cae479-f7c9-4988-b536-56538c38ee4e`;
3. verify Stripe SDK/API version;
4. verify sandbox/live catalog IDs and current prices;
5. inspect current Supabase schema for Stripe Customer mappings;
6. verify current parent-gift implementation;
7. verify current paid entitlement-gating behavior;
8. verify `APP_BASE_URL` and webhook configuration without changing secrets;
9. record deviations from the technical spec.

### Phase B — Backend implementation in Development

Implement/refactor:

- anonymous `student_direct` Checkout Session creation;
- generalized student account resolution;
- custom-ui Checkout Session support;
- server-authoritative promo handling;
- `parent_share` session creation;
- parent-share transactional email endpoint;
- webhook support for the new purchaser types;
- reusable Stripe Customer/payment-method association needed for add-on;
- post-purchase add-on endpoint;
- paid-without-access reconciliation path.

Do not duplicate entitlement logic outside the webhook.

### Phase C — Front-end implementation

In the marketing Lovable project:

- mobile single-page checkout;
- order summary;
- Express Checkout Element;
- Payment Element;
- collapsed promo entry;
- sticky CTA;
- parent-share drawer;
- success/processing page;
- parent confirmation state;
- add-on module;
- required analytics events.

Follow the current Cramapple design system, not older visual-system docs.

### Phase D — Development QA

At minimum test:

- anonymous student + card;
- signed-in student + card;
- Apple Pay where testable;
- Google Pay where testable;
- Link;
- valid promo;
- invalid promo;
- direct payment -> new student account -> entitlement;
- direct payment -> existing account -> entitlement;
- parent link copy/share/email;
- parent payment -> student entitlement;
- duplicate webhook replay;
- async payment success/failure;
- refund revocation;
- delayed webhook / processing state;
- account-invite failure after successful payment;
- add-on success;
- add-on requiring authentication;
- add-on failure without affecting original access.

### Phase E — Production readiness

Before Production enablement:

- independent QA in a fresh context;
- paid entitlement reconciliation evidence;
- Stripe catalog/price confirmation;
- BIZ-001 closure where still applicable;
- Product Owner approval for live Stripe changes;
- Product Owner approval for Production deployment / paid sales.

---

## 9. Acceptance criteria

TASK-0041 is ready for independent QA when the following are complete.

### Purchase experience

- [ ] Single-page mobile checkout implemented.
- [ ] Express wallet options render dynamically above card payment.
- [ ] Payment Element fallback works.
- [ ] Student can purchase without prior account/password creation.
- [ ] No shipping fields or cart-management friction.
- [ ] Promo code input is collapsed by default.
- [ ] Sticky CTA displays authoritative current price.
- [ ] Ask a Parent to Pay is visible directly from checkout.

### Direct student purchase

- [ ] New unsigned-in student can pay.
- [ ] Existing student can pay without duplicate account creation.
- [ ] Verified webhook grants correct entitlement(s).
- [ ] Redirect alone cannot grant access.
- [ ] Duplicate webhook delivery cannot double-grant.

### Parent payment

- [ ] Parent-payment link is server-generated.
- [ ] Link can be copied/shared/emailed.
- [ ] Parent can pay without Cramapple login/account.
- [ ] Payer identity never becomes the student entitlement owner.
- [ ] Verified payment unlocks the student's selected subjects.

### Promotions

- [ ] Promotion code validation is server/Stripe authoritative.
- [ ] URL auto-apply is supported if present.
- [ ] Invalid code does not destroy checkout state.

### Confirmation / activation

- [ ] Confirmation distinguishes processing from confirmed access.
- [ ] Student receives activation/access path.
- [ ] Parent receives payer-appropriate confirmation.
- [ ] Paid-but-not-provisioned failures are durable and recoverable.

### Add-on

- [ ] Eligible single-subject purchase can surface add-on.
- [ ] Add-on never blocks original access.
- [ ] Offer amount and eligibility are server-controlled.
- [ ] Exact charge is disclosed before consent.
- [ ] Authentication fallback works where required.
- [ ] New entitlement is granted only after verified payment.

### Reliability / security

- [ ] Existing webhook signature verification preserved.
- [ ] Existing webhook event idempotency preserved.
- [ ] Refund revocation still works.
- [ ] No raw card data is stored.
- [ ] No secret or client-secret leakage to logs.
- [ ] Client cannot choose arbitrary Stripe Price IDs or amounts.
- [ ] Stripe/Supabase entitlement reconciliation passes the agreed tolerance.

---

## 10. QA evidence

Independent QA should capture:

- screenshots of the key mobile checkout states;
- Stripe test Checkout Session IDs;
- relevant Stripe webhook event IDs;
- resulting `app.stripe_checkout_sessions` rows;
- resulting `app.subject_entitlements` rows;
- duplicate webhook replay evidence;
- parent-share metadata and entitlement ownership;
- new-vs-existing student provisioning evidence;
- promotion-code calculations;
- refund/revocation evidence;
- add-on payment + entitlement evidence;
- key growth/PostHog funnel events.

QA returns a proposed verdict only. Final Done remains governed by the Cramapple operating model.

---

## 11. Hard gates

TASK-0041 remains Hard-Gate.

This plan does **not** itself authorize:

- Stripe sandbox catalog/config writes where current governance requires explicit approval;
- live Stripe catalog/config writes;
- live-mode secret changes;
- Production migrations;
- Production deployment;
- enabling paid sales;
- closing BIZ-001;
- changing decided prices;
- final add-on discount policy;
- risk acceptance;
- task closure.

The Product Owner's instruction to implement the new TASK-0041 defines the desired task scope, but agents must still honor the explicit approval boundary before protected external-system changes or Production enablement.

---

## 12. Out of scope

Unless separately added to TASK-0041:

- October 2 free-launch entitlement path (TASK-0043);
- unlimited-tier enablement;
- tutor/creator affiliate portal;
- general marketing homepage redesign;
- subject-content readiness work;
- unrelated auth/session-mode changes;
- replacing Stripe as payment processor.

---

## 13. Historical notes from the prior plan

The following remain useful context but no longer define the task:

- a real Stripe production purchase previously succeeded;
- refund handling exists;
- parent-gift handling exists;
- async payment event handling exists;
- older TASK-0023 assumptions are stale and must be verified live before reuse;
- a prior entitlement-boundary defect was reported and should be rechecked during Phase A.

These are starting-state facts to verify, not substitutes for implementing the new funnel.

---

## 14. Next action

After this plan and TASK-0041 are approved for execution:

1. assign the implementation agent;
2. create/record the implementation branch per R1;
3. run Phase A read-only verification;
4. compare the live/current implementation against `PURCHASE_FUNNEL_TECHNICAL_SPEC_2026_09_27.md`;
5. implement in Development;
6. run independent QA;
7. return to the Product Owner at the Production/live-payment hard gate.
