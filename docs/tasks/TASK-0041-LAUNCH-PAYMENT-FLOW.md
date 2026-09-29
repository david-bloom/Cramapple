# TASK-0041 — Purchase Funnel Implementation

**Task ID:** TASK-0041  
**Title:** Purchase Funnel — Mobile Checkout, Parent Pay, and Post-Purchase Add-On  
**Owner:** AI implementation agent — unassigned  
**Product Owner:** David Bloom  
**Tier:** Hard-Gate  
**Status:** In Progress — implementation begun 2026-09-28 (`DECISION-0083`); independent QA
(2026-09-28/29) verified the parent-share purchase → webhook → entitlement round trip, the
refund → revocation round trip, and fixes for the three blocking defects QA found (see QA Review
below). PR #253 merged to `main` on 2026-09-28 at merge commit `31ff3418`; frontend/mobile
verification and one more clean forward-looking regression pass remain follow-ups.
**Priority:** Medium — still not on the October 2, 2026 free-launch critical path (`DECISION-0071`
unchanged: October 2 remains free, no payment gating), but building starts now rather than waiting
for a post-launch follow-up  
**Created Date:** 2026-09-26  
**Reframed Date:** 2026-09-27  
**Approved Date:** 2026-09-28 (`DECISION-0083` / `APPROVAL-0059`) — execution of Phase A/B begins now  
**Branch:** `chatgpt/task-0041-purchase-funnel`  
**PR:** [#253](https://github.com/david-bloom/Cramapple/pull/253) — merged 2026-09-28 (`31ff3418`)

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
- Two-subject bundle: **$79.99**
- Three-subject bundle: **$99.99**
- Unlimited: deferred / not marketed

The $79.99 two-subject price is one cent more than two $39.99 singles ($79.98). Product Owner confirmation is required before catalog changes or bundle-savings claims.

Design:

- current Cramapple design system only;
- light-only;
- brand orange;
- square corners;
- current canonical typography;
- no use of superseded visual-system docs.

## Relationship to October 2 launch

This task remains outside the October 2 free-launch critical path under `DECISION-0071`.

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

- [ ] Anonymous new student can pay. _(code path exists and is server-authoritative; not yet
  exercised end-to-end in Development with a brand-new email — only existing-student
  reconciliation has live evidence so far.)_
- [x] Existing student can pay without duplicate account creation. Verified live: student email
  `dbloom_01@yahoo.com` resolved to the existing account, no duplicate created
  (`stripe-webhook/index.ts` `findAuthUserByEmail`/`resolveCheckoutStudentUserId`).
- [x] Verified webhook grants correct entitlement(s). Verified live: `cs_test_b13BEt...` →
  `evt_1UKjMkLrvKNd9sBphORgW40h` → active Biology entitlement, `source=stripe_checkout_single`.
- [x] Redirect alone cannot grant access. Confirmed by code: `get-checkout-status` gates
  `entitled` strictly on `app.subject_entitlements` rows, never on Stripe redirect/session status;
  frontend `PaymentResult.tsx` polls this same server endpoint and never unlocks from the URL alone.
- [x] Duplicate webhook replay does not double-grant. Two independent layers confirmed: DB-level
  `UNIQUE(user_id,subject_id,access_tier,source)` on `subject_entitlements`, plus the webhook
  ledger's insert-first idempotency check on the Stripe event id.

### Parent payment

- [x] Parent link is server-generated. `create-parent-payment-link` builds the Checkout Session
  and URL server-side; no client-supplied price or amount is accepted.
- [ ] Student can copy/share/email it. `send-parent-payment-email` is deployed with server-side
  rate limiting (5/hour/session, confirmed by code) and pulls student metadata from the live Stripe
  session; the copy/share UI itself has not been click-tested this session.
- [x] Parent pays without Cramapple login/account. Verified live: the parent-share purchase
  completed via Apple Pay with no Cramapple authentication step.
- [x] Parent payer is not entitlement owner. Confirmed by code: entitlement ownership is always
  resolved from `metadata.student_email`, never from the Stripe payer/customer identity
  (`resolveCheckoutStudentUserId`). Note: the one live parent-share test used the same email for
  payer and student, so this specific test did not itself exercise payer ≠ student in practice —
  a follow-up test with genuinely distinct payer/student emails is recommended.
- [x] Verified parent payment grants student access. Verified live (see Direct purchase, above —
  same transaction).

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

- [ ] Eligible single-subject purchase can show an add-on. Code confirms eligibility gating
  (`payment_status='paid' AND mode='single'`); not yet exercised with a live paid add-on purchase.
- [x] Add-on never blocks original purchase/access. Confirmed by code: `create-post-purchase-addon`
  only ever creates a new Checkout Session; it never reads or mutates the original entitlement row.
- [x] Exact charge displayed before consent. `ADDON_AMOUNT_CENTS = 3000` ($30.00) is a server
  constant, returned to the client in the response; never client-supplied.
- [x] Eligibility and price are server-controlled. Same as above plus subject/eligibility lookups
  are all server-side.
- [x] Saved-payment reuse works where permitted. **QA defect found and fixed this session**: the
  original implementation required a `stripe_customers` row and hard-failed
  (`saved_payment_unavailable`) for any entitlement originating from parent-share, because
  `create-parent-payment-link` never set `customer_creation`, so Stripe (one-time payment mode
  default) created no Customer object — confirmed live on the one existing parent-share purchase
  (`payload.customer = null`, no `stripe_customers` row). Fixed in commit `09b3124`:
  `create-parent-payment-link` now sets `customer_creation: "always"`, and
  `create-post-purchase-addon` falls back to `customer_creation: "always"` on the add-on session
  itself when no saved customer exists (new `_shared/addon-checkout.ts` helper). Deployed to
  Development (functions v11/v11). Not yet exercised with a live add-on payment.
- [x] Authentication fallback works when required. Same fix as above — the add-on no longer
  hard-fails without a saved card; it reports `payment_method_reuse: "card_entry_required"` and
  lets the student enter a new card.
- [ ] Add-on entitlement grants only after verified success. Entitlement grant path is shared with
  the main webhook handler (same `grantEntitlement`/ledger logic), so this is expected to hold by
  construction, but no live add-on payment has been run to confirm it directly.

### Reliability / security

- [x] Webhook signature verification preserved. Uses Stripe SDK `constructEventAsync` with the
  Deno-compatible `SubtleCrypto` provider; confirmed live — a mismatched signing secret produced
  `invalid_signature`/400 on one delivery, and once the secret was corrected the same event
  verified and processed successfully.
- [x] Event idempotency preserved. See Direct purchase, above.
- [x] Refund revocation still works. **QA defect found and fixed this session**: the Stripe
  sandbox webhook endpoint was not reliably delivering `charge.refunded` (stale/mismatched signing
  secret after a secret rotation, plus a stray second endpoint from earlier troubleshooting that
  has since been deleted). Reproduced live: a real refund (`amount_refunded: 3999`,
  `refunded: true` on `ch_3UKjMiLrvKNd9sBp28xTz5jC`) left the paid Biology entitlement `active`
  with no webhook trace in Development. After the Product Owner corrected
  `STRIPE_WEBHOOK_SECRET` and confirmed only one endpoint remains, resending
  `evt_3UKjMiLrvKNd9sBp2uaRVBRK` (`charge.refunded`) was verified live: ledger row
  `status=processed`, entitlement `99c428dd-1f64-46a1-9324-98d0997c0b84` flipped to
  `status=revoked` at the same timestamp. This is a Stripe sandbox config item, not an application
  bug — `handleChargeRefunded` in `stripe-webhook/index.ts` was already correct.
- [x] No raw card data stored. Confirmed by code review — only Stripe object IDs/last4/brand are
  ever persisted, never PAN/CVC.
- [x] No secret leakage to logs. Confirmed by code review — error logging never includes
  `STRIPE_SECRET_KEY`/`STRIPE_WEBHOOK_SECRET`/raw payment method data.
- [ ] Stripe/Supabase entitlement reconciliation passes agreed tolerance. Not evaluated this
  session — no defined tolerance/reconciliation job was reviewed.

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
**Execution Decision:** Approved — `DECISION-0083` / `APPROVAL-0059` (2026-09-28). Development/
task-branch implementation is approved; Production deployment, migrations, live Stripe writes,
secrets, and paid-sales enablement remain separate Hard Gates, not yet sought or granted.

The 2026-09-27 Product Owner instruction establishes the new TASK-0041 scope. It does not by itself bypass existing Hard Gates for Stripe writes, migrations, Production deployment, live-mode sales, pricing changes, or risk acceptance.

## Implementation Notes

**Implementation Summary:** Implemented on `chatgpt/task-0041-purchase-funnel` (PR #253):
anonymous `student_direct` Stripe Elements checkout, `parent_share` hosted Checkout, checkout-status
API, webhook recipient resolution for `student_direct`/`parent_share`/legacy `parent_gift`, Stripe
Customer/payment-method persistence, $30 post-purchase add-on, parent-payment email endpoint with
rate-limit audit, and the Development schema/RLS for six new `app.stripe_*`/`subject_entitlements`
tables. Pricing approved at $39.99 / $69.99 / $89.99 (`DECISION-0083`, supersedes `DECISION-0069`'s
$79.99/$99.99). Frontend implemented in Lovable project `61dd6602` ("New Cramapple Marketing"),
not in this repo — routes confirmed present: `checkout.index`, `checkout.start`, `checkout.return`,
`checkout.success`, `checkout.cancel`, `checkout.add-on`, `ask-parent` (redirects to
`/checkout?ask=parent`).

**Test Results:** See QA Review below for the full independent verification record. Summary:
parent-share purchase via Apple Pay → webhook → existing-student entitlement grant verified live;
duplicate/replay idempotency verified live and by DB constraint; refund → entitlement revocation
verified live after a Stripe sandbox webhook config fix; two QA-blocking defects (webhook
failed-event recovery, add-on customer reuse for parent-share purchases) found and fixed in commit
`09b3124`, fixes verified live in Development. Frontend has not had a live browser/mobile
click-through test.

**Risks / Issues:**  
- Two-subject pricing anomaly (noted under `DECISION-0069`) is resolved by `DECISION-0083`'s
  $69.99 bundle price, which is a deliberate Product Owner decision, not an oversight — no action
  needed unless revisited.
- Custom Checkout Sessions approach verified against the pinned Stripe API version
  (`2026-03-25.dahlia`/`2026-05-27.dahlia`); Elements `ui_mode` checkout confirmed working live.
- Frontend/mobile UX has not been functionally tested (code review only — see QA Review).
- Stripe/Supabase entitlement reconciliation tooling (for ongoing drift, not just the paid-without-
  access replay path) has not been reviewed or built.

## QA Review

**QA Verdict:** PASS WITH FOLLOW-UPS (2026-09-29, independent Claude QA session, fresh context —
verified against live Development (`wmgjsdkphcyhngaffbqf`) and Stripe Cramapple Sandbox, not
against prior agents' claims)

**QA Result:**

Initial pass (2026-09-28) found the durable task record stale relative to verified state (this
file showed "Not Started"/no branch/no PR while PR #253 was already open with 27 commits) and
returned **FAIL / BLOCKED** on three defects:

1. **Failed webhook events could not be recovered.** The idempotency ledger's insert-only design
   meant a failed/unprocessed Stripe event (e.g. `evt_1UKf1RLrvKNd9sBpHp1wEkTp`, stuck on
   `student_invite_failed`) could never be reprocessed by a Stripe retry or manual resend — it
   would always hit the same primary-key conflict and be swallowed as `{duplicate: true}`.
2. **Post-purchase add-on unusable for parent-share purchases.** No `stripe_customers` row is
   created for parent-share Checkout Sessions (no `customer_creation` param), and the add-on
   endpoint hard-required one, with no fallback.
3. **Decision/approval ID collision.** The branch's `DECISION-0083`/`APPROVAL-0058` collided with
   different, already-canonical entries of the same IDs recorded on `main` (TASK-0039 BYOQ) after
   the PR's base commit.

All three were fixed in commit `09b3124` ("Fix TASK-0041 QA blockers") and independently
re-verified live in Development in this same QA session:

- **(1) Fixed and proven live.** Migration `20260928191344_task0041_webhook_replay` adds
  `status`/`attempt_count`/`last_attempt_at` to `app.stripe_webhook_events` plus a
  `SECURITY DEFINER` RPC `app.claim_stripe_webhook_event` that reclaims a `received`/`failed`
  row (or a stale `processing` row after 5 minutes) instead of silently no-opping. Confirmed live:
  the stuck test event's `attempt_count` advanced from 1 to 6 across multiple reclaim/retry cycles.
- **(2) Fixed, deployed.** `create-parent-payment-link` now sets `customer_creation: "always"`;
  `create-post-purchase-addon` falls back to `customer_creation: "always"` on the add-on session
  when no saved customer exists (new `_shared/addon-checkout.ts`). Deployed to Development
  (`create-parent-payment-link` v11, `create-post-purchase-addon` v11). Not yet exercised with a
  live add-on payment.
- **(3) Fixed.** Branch merge-base with `main` is now `main`'s current tip; `DECISION-0083` is
  uniquely TASK-0041's pricing decision, and the TASK-0039 BYOQ entries were renumbered to
  `DECISION-0084`/`APPROVAL-0058`, matching `main`'s own canonical numbering.
  `mergeable_state: clean`.

A fourth issue was found and resolved during re-verification, not part of the original three:

4. **Stripe sandbox webhook delivery gap (config, not code).** A stray second webhook endpoint
   (created during earlier troubleshooting) was deleted by the team, and a signing-secret mismatch
   after a rotation caused `charge.refunded` to fail signature verification
   (confirmed live: `invalid_signature`/400 on delivery `req_uX8wAnrHfNH7zp`). Reproduced with a
   real refund: entitlement `99c428dd-1f64-46a1-9324-98d0997c0b84` stayed `active` after Stripe
   showed the charge fully refunded. After the Product Owner re-synced
   `STRIPE_WEBHOOK_SECRET` with the (now single) Stripe endpoint's current secret and resent the
   event, verified live: `evt_3UKjMiLrvKNd9sBp2uaRVBRK` processed successfully and the entitlement
   flipped to `status=revoked` at the matching timestamp. `handleChargeRefunded` in
   `stripe-webhook/index.ts` required no code change — this was purely a Stripe sandbox
   configuration issue.

**Independently verified live in Development (evidence IDs):**
- Parent-share purchase via Apple Pay: `cs_test_b13BEtdKtJTqdmRbPmFeaSXxIzwlv4HVjPPmU2I1BUMQuAmWddrMh7N35n`
  / `evt_1UKjMkLrvKNd9sBphORgW40h` / `pi_3UKjMiLrvKNd9sBp2INwVhiu` → active Biology entitlement
  `99c428dd-1f64-46a1-9324-98d0997c0b84`, `source=stripe_checkout_single`.
- Parent-share purchase via Stripe test card (Visa 4242): `pi_3UKf1QLrvKNd9sBp2SAJWHnQ` /
  `evt_1UKf1RLrvKNd9sBpHp1wEkTp` — deliberately left as an unresolved fixture (synthetic invalid/
  rate-limited test email) to prove the D1 fix's reclaim behavior; `attempt_count` confirmed
  advancing across retries.
- Refund → revocation: `evt_3UKjMiLrvKNd9sBp2uaRVBRK` (`charge.refunded`) → entitlement
  `99c428dd-1f64-46a1-9324-98d0997c0b84` `status: active → revoked`.
- RLS confirmed enabled with policies on all six new tables (`stripe_checkout_sessions`,
  `stripe_webhook_events`, `stripe_checkout_session_attempts`, `stripe_customers`,
  `subject_entitlements`, `parent_payment_email_requests`); none flagged by Supabase's security
  advisor.
- Frontend code (Lovable `61dd6602`) reviewed read-only: checkout/add-on/return routes exist and
  are wired to the same server-authoritative contract as the backend (`PaymentResult.tsx` never
  unlocks from the redirect alone). Not functionally/mobile tested.

**Outstanding before this can be called fully clean (not blocking, follow-up):**
- One more forward-looking parent-share purchase → refund cycle, and one live add-on payment, now
  that the webhook/secret/endpoint issues are resolved — to confirm today's fixes hold on a fresh
  transaction rather than only on retroactive replay of the original one.
- A live click-through/mobile test of the checkout, parent-share, and add-on UX in the Lovable
  preview (not done this session — code-level review only).
- `pi_3UKez9LrvKNd9sBp2yS9EpjR` (one of the transaction IDs the Product Owner reported) was never
  reconciled against a `checkout.session.completed` delivery record — low priority given the root
  cause (secret/endpoint) is now fixed, but worth a final check.
- Stripe/Supabase entitlement reconciliation tooling for ongoing drift (distinct from the
  paid-without-access replay path, which is fixed) was not reviewed.

## Done Decision

**Decision:** Pending  
**Date:** YYYY-MM-DD

Only the Main Conductor may set this task to `Done` after QA evidence and required approvals are satisfied.
