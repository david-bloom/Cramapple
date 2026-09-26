# Launch Plan — Payment Flow — 2026-09-26

**Status:** Draft, wraps existing work | **Owner:** David Bloom | **Tier:** Hard-Gate
**Part of:** `APP_LAUNCH_READINESS_INDEX_2026_09_26.md`
**Primary source:** `docs/tasks/TASK-0023-STRIPE-SETUP-AND-LAUNCH-READINESS.md` — read that task in
full before touching this plan. This document is a launch-readiness wrapper around it, not a
replacement.

## CORRECTION, 2026-09-26 (same day, after a second AI review)

**This plan's original "Current State" was six weeks stale and wrong on the central point: it said
"nothing has been exercised end-to-end yet." A real customer paid via live Stripe 2026-08-13 to
2026-08-15** — `docs/product/UNCERTAINTY_LOG.md` records this as a correction to an earlier "zero
purchases" claim: "One real user purchased... Stripe shows 2 completed checkout sessions and 3
expired." That means the production webhook signing secret was, at minimum, working at that point
(the webhook fail-closes without it, per TASK-0023's own design) — treat that criterion as **verify**,
not **obtain approval to set**, unless verification shows otherwise.

Since 2026-08-11, `supabase/functions/stripe-webhook/index.ts` has also grown well past what this plan
described: it now handles `charge.refunded` (refund processing exists, is not "explicitly deferred"),
parent-gift checkout attribution, and `checkout.session.async_payment_succeeded`/`_failed`. A live,
separate bug was found and fixed 2026-08-24 (`ACTIVITY_LOG.md`) in the parent-gift attribution path.

**A real, separate launch-blocking bug exists and belongs on this plan's radar, found 2026-09-20
(`ACTIVITY_LOG.md`):** nothing currently gates `attempt-response` on entitlement — an unentitled
student can submit an answer and hits a generic "Couldn't score that" error loop instead of a clear
paywall message. This is a student-facing defect on the payment/entitlement boundary and was not
in any plan until now.

The acceptance criteria below are corrected to verify-and-QA the flow that already took real money,
rather than treat it as unbuilt.

## Product Goal

A student can pay for one or more AP subjects (single, 2-bundle, 3-bundle, or unlimited) and be
correctly entitled, in both the dev and production environments, with no path that grants access
without a verified payment and no path that takes payment without granting access.

## Current State (corrected 2026-09-26; verify against live systems before trusting either version)

Substantially built and already exercised once for real. Live and sandbox Stripe catalogs exist (10
single-subject Products, 3 bundle Products — bundle prices need updating per `DECISION-0068`, see
below). `create-checkout-session` and `stripe-webhook` Edge Functions are deployed to both Supabase
projects and now include refund handling, parent-gift checkout, and async-payment event handling —
more than TASK-0023's 2026-08-11 entries describe. At least one real transaction has cleared end-to-end
in production. Treat every claim in TASK-0023 itself as needing a fresh live check before relying on
it — it has not been updated to reflect the 2026-08-13+ activity.

## Acceptance Criteria

- [ ] Verify (do not assume) whether `STRIPE_WEBHOOK_SECRET` is set in `Cramapple-Production` — the
      2026-08-13 real transaction suggests it already is. If verification shows it is not set, treat
      setting it as a **Hard Gate** requiring David's explicit go (live account, real money). If it's
      already set and working, mark this Done with the evidence (a real webhook delivery log) and move
      on — do not re-seek an approval that's already moot.
- [ ] Same verification for `Cramapple-Development` (sandbox webhook secret).
- [ ] `APP_BASE_URL` confirmed set in both environments.
- [ ] **Fix or escalate the entitlement-gating gap**: `attempt-response` does not currently check
      entitlement before scoring, producing a generic error for unentitled students instead of a clear
      paywall message (found 2026-09-20, `ACTIVITY_LOG.md`). Confirm current status live — this may
      already be fixed — and if not, this is launch-blocking for the payment surface regardless of
      Stripe's own state.
- [ ] Confirm current status of refund handling and parent-gift checkout (both now appear built per
      the correction above) — do not re-defer or re-build either; verify and QA what exists.
- [ ] `Cramapple-Development`'s `app.subjects` table seeded with the remaining 6 subjects (currently
      only 4 of 10 present) — OR explicitly confirmed that dev testing only needs to cover the 4
      seeded subjects for this launch, if that's David's call. Do not seed a subject into a dev
      environment ahead of that subject's own content-readiness decision without checking with
      whoever owns that call (per TASK-0023's own flag on this exact point).
- [ ] A full checkout-to-entitlement walkthrough is run and passes in sandbox: create checkout session
      → complete payment in Stripe test mode → webhook receives and verifies signature → entitlement
      row(s) granted correctly for single and bundle purchase types. Unlimited is deferred (see below) —
      do not block this criterion on testing a tier that isn't launching yet.
- [ ] Duplicate webhook delivery is tested and confirmed idempotent (no double-grant) — the unique
      constraint plus the events ledger should both cover this; verify with an actual replayed event,
      not by reading the schema.
- [ ] Coupon + Promotion Code for the "add another subject" incentive is built, with the
      shared-vs-per-customer decision made (still open in TASK-0023).
- [ ] Reconciliation check confirms Supabase entitlement records match Stripe purchase records within
      the 5% tolerance target, run against real or simulated sandbox transactions.
- [x] Pricing decided (`DECISION-0068`, 2026-09-26): $39.99 single subject (matches the built catalog,
      no change needed), $79.99 two-subject bundle (**changes** the built catalog's current $69.99),
      $99.99 three-subject bundle (**changes** the built catalog's current $89.99).
- [x] Unlimited tier **deferred by decision, not open** (`DECISION-0069`, 2026-09-26): will be priced
      and enabled once all 10 subjects are live, not at initial launch. Leave the built catalog's
      $139.99 Price untouched and unmarketed until that condition is reached — this is not a blocker
      for launch.
- [ ] **Flag before implementing:** the decided 2-bundle price ($79.99) is $0.01 more than buying two
      singles separately ($79.98) — essentially no bundle discount. Confirm with David this is
      intentional before updating the live/sandbox Stripe 2-bundle Price; do not silently "fix" it to a
      discounted price without confirming that's what he wants.
- [ ] Update the live and sandbox Stripe 2-bundle and 3-bundle Prices to $79.99 / $99.99. **Hard
      Gate** for the live account — requires David's explicit go, same as any other live Stripe change.
      The sandbox update can proceed under Standing Approval once the 2-bundle flag above is resolved.
- [ ] BIZ-001 (pricing and access policy) — access duration, refunds/discounts, and parent-purchaser
      handling remain open, still a **Hard Gate, owned by David with the Strategy Advisor.** No
      live-mode sale should be enabled before these close, and no subject bundle should be sellable
      before every subject in it has passed `LAUNCH_PLAN_SUBJECT_ONBOARDING_GATE_2026_09_26.md`
      (BIZ-001's own stated requirement) — concretely, no Biology+Statistics bundle until Statistics'
      criterion-6 hazard is resolved.
- [ ] Lovable-side frontend calls to `create-checkout-session` and the `/checkout/success` /
      `/checkout/cancel` routes exist and work (outside this repo's edit surface — verify via Lovable
      or via the live app, not by inspecting this repo).
- [ ] Referral-reward reconciliation specifically (distinct from refund handling, which now appears
      built) — verify current status live before assuming TASK-0023's 2026-08-11 "not yet built" note
      still holds.

## Out of Scope

Same as TASK-0023: setting the actual price/refund policy (BIZ-001 itself), launch messaging (GTM-001,
covered by the marketing-home-page plan), non-payment cutover plumbing (TASK-0012), the tutor/creator
affiliate portal.

## Hard Gates in this plan

Registering the live webhook endpoint, setting any live-mode secret, enabling live-mode sales, and
closing BIZ-001 all require David's explicit approval. An implementation agent can complete every
sandbox/test-mode criterion above without a gate; do not touch anything in the live Stripe account
(`acct_1TddjmLwoRHzBJ1O`) without confirming approval first.

## Method Note

Verify entitlement grants by querying `app.subject_entitlements` directly after a real (sandbox)
purchase, not by reading the webhook code and assuming it works. TASK-0023's own history shows secrets
being "documented as needed" without actually being set — confirm secret existence with a live check
(e.g. an intentionally-triggered webhook call), not by reading the environment-variable matrix.
