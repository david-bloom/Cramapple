# Launch Plan — Payment Flow — 2026-09-26

**Status:** Draft, wraps existing work | **Owner:** David Bloom | **Tier:** Hard-Gate
**Part of:** `APP_LAUNCH_READINESS_INDEX_2026_09_26.md`
**Primary source:** `docs/tasks/TASK-0023-STRIPE-SETUP-AND-LAUNCH-READINESS.md` — read that task in
full before touching this plan. This document is a launch-readiness wrapper around it, not a
replacement.

## Product Goal

A student can pay for one or more AP subjects (single, 2-bundle, 3-bundle, or unlimited) and be
correctly entitled, in both the dev and production environments, with no path that grants access
without a verified payment and no path that takes payment without granting access.

## Current State (as of TASK-0023, 2026-08-11 entries)

Mostly built. Live and sandbox Stripe catalogs exist (10 single-subject Products, 3 bundle Products).
`create-checkout-session` and `stripe-webhook` Edge Functions are code-complete and deployed to both
Supabase projects. Entitlement schema is extended (not new), with idempotency via a webhook-events
ledger. **Nothing has been exercised end-to-end yet in either environment** — the blockers below are
why.

## Acceptance Criteria

- [ ] `STRIPE_WEBHOOK_SECRET` is set in `Cramapple-Development` (sandbox webhook endpoint registered,
      test-mode secret obtained and set as an Edge Function secret).
- [ ] `STRIPE_WEBHOOK_SECRET` is set in `Cramapple-Production` (live webhook endpoint registered,
      live-mode secret obtained and set). **Hard Gate** — this touches the live Stripe account and
      real money; requires David's explicit go per `TASK-0023`'s own out-of-scope note.
- [ ] `APP_BASE_URL` confirmed set in both environments.
- [ ] `Cramapple-Development`'s `app.subjects` table seeded with the remaining 6 subjects (currently
      only 4 of 10 present) — OR explicitly confirmed that dev testing only needs to cover the 4
      seeded subjects for this launch, if that's David's call. Do not seed a subject into a dev
      environment ahead of that subject's own content-readiness decision without checking with
      whoever owns that call (per TASK-0023's own flag on this exact point).
- [ ] A full checkout-to-entitlement walkthrough is run and passes in sandbox: create checkout session
      → complete payment in Stripe test mode → webhook receives and verifies signature → entitlement
      row(s) granted correctly for single, bundle, and unlimited purchase types.
- [ ] Duplicate webhook delivery is tested and confirmed idempotent (no double-grant) — the unique
      constraint plus the events ledger should both cover this; verify with an actual replayed event,
      not by reading the schema.
- [ ] Coupon + Promotion Code for the "add another subject" incentive is built, with the
      shared-vs-per-customer decision made (still open in TASK-0023).
- [ ] Reconciliation check confirms Supabase entitlement records match Stripe purchase records within
      the 5% tolerance target, run against real or simulated sandbox transactions.
- [ ] BIZ-001 (pricing and access policy) has moved from `Proposed` to a recorded decision — **Hard
      Gate, owned by David with the Strategy Advisor.** No live-mode sale should be enabled before this
      exists, and no subject bundle should be sellable before every subject in it has passed
      `LAUNCH_PLAN_SUBJECT_ONBOARDING_GATE_2026_09_26.md` (BIZ-001's own stated requirement).
- [ ] Lovable-side frontend calls to `create-checkout-session` and the `/checkout/success` /
      `/checkout/cancel` routes exist and work (outside this repo's edit surface — verify via Lovable
      or via the live app, not by inspecting this repo).
- [ ] Refund handling and referral-reward reconciliation — explicitly deferred in TASK-0023 until the
      above is exercised. Not required for initial launch unless David says otherwise; flag as a known
      gap in the go-live index rather than silently marking Done.

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
