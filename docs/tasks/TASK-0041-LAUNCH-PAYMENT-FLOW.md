# TASK-0041 — Purchase Funnel Implementation

**Task ID:** TASK-0041  
**Title:** Purchase Funnel — Mobile Checkout, Parent Pay, and Post-Purchase Add-On  
**Owner:** AI implementation agent — unassigned  
**Product Owner:** David Bloom  
**Tier:** Hard-Gate  
**Status:** In Progress  
**Priority:** Active — execute now per Product Owner direction, 2026-09-28  
**Created Date:** 2026-09-26  
**Reframed Date:** 2026-09-27  
**Approved Date:** 2026-09-28  
**Branch:** `chatgpt/task-0041-purchase-funnel`  
**PR:** Pending

> **TASK REFRAME — 2026-09-27.** The prior "post-launch verify-and-fix" framing is superseded.  
> TASK-0041 is now the implementation task for the redesigned Cramapple purchase funnel.  
> Existing Stripe/payment infrastructure is the foundation to verify and extend, not the endpoint of the task.

## Product Goal

Implement a friction-minimized, mobile-first purchase funnel that allows a student to:

- select one or more AP subjects;
- pay directly with Apple Pay, Google Pay, Stripe Link, or card;
- complete payment without creating a password first;
- use **Ask a Parent to Pay** when they do not have a payment method;
- have a parent pay without creating a Cramapple account;
- receive the purchased subject entitlement only after verified Stripe payment;
- optionally accept a non-blocking post-purchase add-on offer.

The implementation must preserve the distinction between payer and learner and must not grant access from client-side success redirects.

## Governing documents

Primary implementation sources:

1. `docs/product/PURCHASE_FUNNEL_TECHNICAL_SPEC_2026_09_27.md`
2. `docs/product/LAUNCH_PLAN_PAYMENT_FLOW_2026_09_26.md`
3. `docs/product/ARCHITECTURE_AND_DESIGN_DECISIONS_CURRENT.md`
4. `docs/new_design/`

Historical/backend reference:

- `docs/tasks/TASK-0023-STRIPE-SETUP-AND-LAUNCH-READINESS.md`

TASK-0023 does not govern the new funnel when it conflicts with this task or the new technical spec.

## Technical Scope

### Front-end

Target the current marketing Lovable project for the purchase experience.

Implement:

- mobile single-page checkout;
- compact order summary;
- Stripe Express Checkout Element;
- Stripe Payment Element fallback;
- student email collection;
- collapsed promo-code entry;
- sticky payment CTA;
- Ask a Parent to Pay drawer;
- parent share/copy/email actions;
- success/processing state;
- parent payer confirmation state;
- post-purchase add-on module;
- funnel analytics.

### Backend

Extend the existing Stripe/Supabase payment architecture.

Implement/refactor:

- anonymous `student_direct` Checkout Session creation;
- existing-account reconciliation;
- generalized student account resolution/provisioning;
- custom Checkout Session support for direct student checkout;
- server-authoritative subject/price validation;
- promo-code handling;
- `parent_share` hosted Checkout Session creation;
- parent-payment transactional email endpoint;
- webhook support for `student_direct` and `parent_share`;
- reusable Stripe Customer/payment-method association for add-on where permitted;
- post-purchase add-on payment endpoint;
- paid-without-access reconciliation path.

Preserve:

- webhook signature verification;
- webhook event idempotency;
- entitlement grants through verified webhook processing only;
- refund handling;
- async payment handling;
- existing `parent_gift` backward compatibility.

## Current product decisions

Pricing:

- Single subject: **$39.99**
- Two-subject bundle: **$69.99**
- Three-subject bundle: **$89.99**
- Unlimited: deferred / not marketed

The revised pricing above is approved by the Product Owner as of 2026-09-28.

Design:

- current Cramapple design system only;
- light-only;
- brand orange;
- square corners;
- current canonical typography;
- no use of superseded visual-system docs.

## Relationship to October 2 launch

The Product Owner explicitly directed immediate execution on 2026-09-28; the prior October 2 deferment no longer blocks this task.

That means:

- October 2 does not wait for TASK-0041;
- the free launch must not be converted to paid gating by this task without separate approval;
- TASK-0041 can still proceed as the next purchase-funnel implementation project once execution is approved.

## Routes / Components / Systems Affected

Backend:

- `supabase/functions/create-checkout-session`
- `supabase/functions/stripe-webhook`
- new parent-payment-link Edge Function
- new parent-email send path
- new post-purchase add-on Edge Function
- Stripe catalog / Checkout Sessions / Customers / PaymentIntents as applicable
- `app.subject_entitlements`
- `app.stripe_checkout_sessions`
- `app.stripe_webhook_events`
- any existing Stripe Customer mapping table, or a narrowly scoped new mapping if no equivalent exists

Front-end:

- marketing Lovable project `61dd6602`
- checkout route
- success/return route
- parent-payment handoff UX

External systems:

- Stripe
- Supabase
- Lovable
- PostHog / existing growth-event path

## Data / Security / Integration Impact

Hard requirements:

- client never chooses arbitrary amount or Stripe Price ID;
- server validates subject count and catalog membership;
- payment redirect never grants access;
- raw card data never enters Cramapple storage;
- Stripe secrets/client secrets are not durably logged;
- parent payer identity does not replace student entitlement identity;
- parent-share/email endpoints are rate-limited;
- webhook processing remains idempotent;
- paid-without-access failures remain durable and replayable/reconcilable.

## Acceptance Criteria

### Checkout UX

- [ ] Mobile single-page checkout implemented.
- [ ] Apple Pay / Google Pay / Link appear dynamically when available.
- [ ] Payment Element works as fallback.
- [ ] Student can purchase without prior password creation.
- [ ] No shipping UI.
- [ ] Promo entry collapsed by default.
- [ ] Sticky CTA displays authoritative total.
- [ ] Ask a Parent to Pay is visible from checkout.

### Direct purchase

- [ ] Anonymous new student can pay.
- [ ] Existing student can pay without duplicate account creation.
- [ ] Verified webhook grants correct entitlement(s).
- [ ] Redirect alone cannot grant access.
- [ ] Duplicate webhook replay does not double-grant.

### Parent payment

- [ ] Parent link is server-generated.
- [ ] Student can copy/share/email it.
- [ ] Parent pays without Cramapple login/account.
- [ ] Parent payer is not entitlement owner.
- [ ] Verified parent payment grants student access.

### Promotions

- [ ] Promo validation is server/Stripe authoritative.
- [ ] URL auto-apply supported if present.
- [ ] Invalid promo preserves checkout state.

### Confirmation

- [ ] Processing and confirmed-access states are distinct.
- [ ] Student receives activation/access guidance.
- [ ] Parent receives payer-appropriate confirmation.
- [ ] Paid-but-unprovisioned state is recoverable.

### Post-purchase add-on

- [ ] Eligible single-subject purchase can show an add-on.
- [ ] Add-on never blocks original purchase/access.
- [ ] Exact charge displayed before consent.
- [ ] Eligibility and price are server-controlled.
- [ ] Saved-payment reuse works where permitted.
- [ ] Authentication fallback works when required.
- [ ] Add-on entitlement grants only after verified success.

### Reliability / security

- [ ] Webhook signature verification preserved.
- [ ] Event idempotency preserved.
- [ ] Refund revocation still works.
- [ ] No raw card data stored.
- [ ] No secret leakage to logs.
- [ ] Stripe/Supabase entitlement reconciliation passes agreed tolerance.

## QA Plan

Independent QA must run in a fresh context.

Minimum test matrix:

- anonymous + card;
- authenticated + card;
- Apple Pay where testable;
- Google Pay where testable;
- Link;
- valid promo;
- invalid promo;
- new-student provisioning;
- existing-student provisioning;
- parent link copy/share/email;
- parent payment -> student entitlement;
- duplicate webhook replay;
- async success/failure;
- refund;
- delayed webhook;
- invite/provisioning failure after paid session;
- add-on success;
- add-on authentication;
- add-on failure with original entitlement preserved.

Evidence should include Stripe session/event IDs and resulting Supabase entitlement/session records.

## Out of Scope

Unless separately approved:

- October 2 free-entitlement path (TASK-0043);
- unlimited-tier enablement;
- general marketing homepage redesign;
- tutor/creator affiliate portal;
- subject-content readiness;
- replacing Stripe;
- unrelated session/auth architecture work.

## Approval State

**Approval Required:** Yes  
**Approval Type:** Hard Gate  
**Execution Decision:** Pending

The 2026-09-27 Product Owner instruction establishes the new TASK-0041 scope. It does not by itself bypass existing Hard Gates for Stripe writes, migrations, Production deployment, live-mode sales, pricing changes, or risk acceptance.

## Implementation Notes

**Implementation Summary:** _(To be filled by implementation agent.)_

**Test Results:** _(To be filled by implementation agent.)_

**Risks / Issues:**  
- Two-subject pricing anomaly must be resolved before catalog changes or savings claims.  
- Custom Checkout Sessions approach must be verified against installed Stripe SDK/API version.  
- Current paid-entitlement boundary must be re-verified before implementation changes.

## QA Review

**QA Verdict:** Pending

**QA Result:** _(Fresh independent QA context.)_

## Done Decision

**Decision:** Pending  
**Date:** YYYY-MM-DD

Only the Main Conductor may set this task to `Done` after QA evidence and required approvals are satisfied.
