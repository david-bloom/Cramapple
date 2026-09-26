# TASK-0041 — Launch: Payment Flow

**Task ID:** TASK-0041
**Title:** Payment Flow — Post-Launch Verify-and-Fix (deferred from Friday's critical path)
**Owner:** AI agent (implementation) — unassigned; candidate: Codex or Claude
**Product Owner:** David Bloom
**Tier:** Hard-Gate
**Status:** Not Started
**Priority:** Medium — **deferred, not on Friday's launch-critical path** (`DECISION-0071`)
**Created Date:** 2026-09-26
**Approved Date:** Pending
**Branch:** Not yet created — assign per R1 (`<agent>/task-0041-<slug>`) when an agent starts execution
**PR:** None yet

## Product Goal

A student can pay for one or more AP subjects (single, 2-bundle, 3-bundle, or unlimited) and be
correctly entitled, in both dev and production, with no path that grants access without a verified
payment and no path that takes payment without granting access.

## Technical Scope

Primary source: `docs/product/LAUNCH_PLAN_PAYMENT_FLOW_2026_09_26.md`, which itself wraps
`docs/tasks/TASK-0023-STRIPE-SETUP-AND-LAUNCH-READINESS.md` — read both in full before starting.

**Do not pick this up for the Friday launch push** (`DECISION-0071`: Friday launches free, no Stripe
gating). Work it only once there's dedicated time post-launch. Current state (verify live, do not
trust either source doc's dated claims): substantially built and already exercised once for real (one
customer paid via live Stripe 2026-08-13/15); `stripe-webhook` now handles refunds, parent-gift
attribution, and async payment events beyond what TASK-0023 describes.

A real, separate launch-relevant bug lives on this plan's radar: `attempt-response` does not gate on
entitlement, producing a generic error instead of a paywall message for unentitled students (found
2026-09-20). Confirm current status live before assuming fixed or unfixed.

## Out of Scope

Same as TASK-0023: setting the actual price/refund policy (BIZ-001 itself), launch messaging (GTM-001,
covered by TASK-0040), non-payment cutover plumbing (TASK-0012), the tutor/creator affiliate portal.

## Routes / Components / Systems Affected

- `supabase/functions/create-checkout-session`, `supabase/functions/stripe-webhook`
- `app.subject_entitlements`, `app.subjects` (Dev seeding gap: only 4 of 10 subjects present)
- Live and sandbox Stripe catalogs (`acct_1TddjmLwoRHzBJ1O` — live account, requires explicit approval
  for any change)
- Lovable-side `create-checkout-session` calls, `/checkout/success`, `/checkout/cancel` (outside this
  repo's edit surface — verify via Lovable or the live app)

## Data / Security / Integration Impact

Live Stripe account changes, live-mode secrets, and live-mode sales all require David's explicit
approval — see Hard Gates below. Entitlement-gating gap is a student-facing defect on a security/access
boundary.

## Acceptance Criteria

(Full detail and rationale in `LAUNCH_PLAN_PAYMENT_FLOW_2026_09_26.md` — this list mirrors it; that doc
governs if they drift.)

- [ ] Verify `STRIPE_WEBHOOK_SECRET` set/working in `Cramapple-Production` (evidence: real webhook
      delivery log) and `Cramapple-Development`.
- [ ] `APP_BASE_URL` confirmed set in both environments.
- [ ] Fix or escalate the entitlement-gating gap (`attempt-response` doesn't check entitlement before
      scoring) — confirm current live status first.
- [ ] Confirm current status of refund handling and parent-gift checkout (verify and QA what exists,
      don't rebuild).
- [ ] `Cramapple-Development`'s `app.subjects` seeded with remaining 6 subjects, or explicit
      confirmation that dev testing only needs the 4 already seeded.
- [ ] Full checkout-to-entitlement walkthrough passes in sandbox for single and bundle purchase types.
- [ ] Duplicate webhook delivery tested and confirmed idempotent (actual replayed event, not a schema
      read).
- [ ] Coupon + Promotion Code for "add another subject" built, shared-vs-per-customer decision made.
- [ ] Reconciliation check: Supabase entitlement records match Stripe purchase records within 5%
      tolerance.
- [x] Pricing decided (`DECISION-0069`): $39.99 single (no change), $79.99 two-bundle (change from
      $69.99), $99.99 three-bundle (change from $89.99).
- [x] Unlimited tier deferred by decision (`DECISION-0070`) — not a blocker.
- [ ] **Flag before implementing:** the 2-bundle price ($79.99) is $0.01 more than two singles
      ($79.98) — confirm with David this is intentional before updating live/sandbox Prices.
- [ ] Update live and sandbox Stripe 2-bundle/3-bundle Prices to $79.99/$99.99 (**Hard Gate** for live;
      sandbox can proceed under Standing Approval once the flag above is resolved).
- [ ] BIZ-001 (access duration, refunds/discounts, parent-purchaser handling) closed — **Hard Gate**,
      owned by David with the Strategy Advisor. No bundle sellable before every subject in it passes
      TASK-0044 (Subject Onboarding Gate).
- [ ] Lovable-side checkout routes confirmed working (verify via Lovable/live app).
- [ ] Referral-reward reconciliation verified live (don't assume TASK-0023's stale note still holds).

## QA Plan

- Manual QA: sandbox checkout-to-entitlement walkthrough, replayed webhook event for idempotency.
- Automated tests: none beyond what TASK-0023 already specifies.
- Regression areas: refund handling, parent-gift attribution, async payment events.
- Failure cases: double-grant on duplicate webhook; unentitled student reaching scoring.
- Security/data/integration checks: query `app.subject_entitlements` directly after a real sandbox
  purchase; do not infer correctness from reading webhook code.

## Approval State

**Approval Required:** Yes
**Approval Type:** Hard Gate (live Stripe account changes, live-mode secrets, live-mode sales, BIZ-001
closure)
**Decision:** Pending — this task record itself is a draft awaiting Codex's review before being
finalized; execution has not started and should not start before Friday's launch per `DECISION-0071`.

## Implementation Notes

_(To be filled by the implementation agent.)_

## QA Review

**QA Verdict:** Pending (Pass / Fail)

## Done Decision

**Decision:** Pending
**Date:** YYYY-MM-DD
