# TASK-0023 — Stripe Setup and Commercial Launch Readiness

**Task ID:** TASK-0023
**Title:** Stripe Setup and Commercial Launch Readiness
**Owner:** Main Conductor (Claude)
**Product Owner:** David Bloom
**Tier:** Standard
**Status:** Not Started
**Priority:** P1
**Created Date:** 2026-08-10
**Approved Date:** Pending
**Branch:** `claude/stripe-setup-launch-2u3rru`
**PR:** Pending

## Product Goal

Stand up a governed, production-ready Stripe integration and close the
remaining commercial-readiness gaps so Cramapple can take real payment for
the AP Biology launch. This task consolidates the previously scattered
Stripe references (`CRAMAPPLE_MARKETING_STACK_REPORT_2026.md`,
`CRAMAPPLE_FREE_SCORE_CHECK_IMPLEMENTATION_2026.md`, `BIZ-001` in
`MASTER_TODO.md`, and the cutover blockers in `TASK-0012`) into one owned
task with explicit scope and acceptance criteria, rather than leaving Stripe
work implied across multiple documents.

## Technical Scope

- Inventory the current state of the "existing Stripe integration" referenced
  in `CRAMAPPLE_MARKETING_STACK_REPORT_2026.md` (line 438): confirm what, if
  anything, is actually configured in the Stripe dashboard and in the
  Lovable/Supabase codebase today, since this repository contains no Stripe
  account IDs, product/price IDs, or webhook code.
- Define the product/price catalog in Stripe for the AP Biology one-time
  purchase (depends on `BIZ-001` price and access-duration decisions).
- Define and implement the Stripe Checkout flow (session creation, success/
  cancel routes, referral/promo-code metadata per
  `CRAMAPPLE_MARKETING_STACK_REPORT_2026.md` referral section).
- Define and implement the Stripe webhook handler as the sole source of
  truth for `purchase_completed`, `referred_purchase`, and refund events,
  per the event contract in `CRAMAPPLE_FREE_SCORE_CHECK_IMPLEMENTATION_2026.md`
  §Events and `growth-events.ts`'s `"stripe"` event source.
- Define entitlement-granting logic triggered only by the verified webhook
  (never by client-side checkout completion).
- Define the Stripe secret/key inventory (publishable key, secret key,
  webhook signing secret) and where each lives across local, beta, preview,
  and production, folding into the environment-variable matrix owned by
  `TASK-0012`.
- Define refund handling and its interaction with referral-reward
  reconciliation (`CRAMAPPLE_MARKETING_STACK_REPORT_2026.md` referral
  section: rewards reconcile only after the refund window).
- Define reconciliation checks so Stripe-reported revenue and
  Supabase-recorded entitlements stay within the 5% tolerance target in
  `CRAMAPPLE_MARKETING_STACK_REPORT_2026.md`.
- Produce a launch-readiness checklist covering the non-Stripe-specific
  blockers already tracked elsewhere (`BIZ-001` pricing/refund policy,
  `GTM-001` launch messaging, `TASK-0012` cutover blockers) so this task can
  serve as the single pre-launch gate index rather than duplicating them.

## Out of Scope

- Setting the actual AP Biology launch price or refund policy — that is
  `BIZ-001`, owned by David Bloom with the Strategy Advisor.
- Launch messaging, positioning, or campaign content — that is `GTM-001`.
- General production cutover plumbing not specific to payments (auth,
  content publishing, hosting) — that remains under `TASK-0012`.
- Building the tutor/creator affiliate portal — explicitly deferred in
  `CRAMAPPLE_MARKETING_STACK_REPORT_2026.md`.
- Any change to live Stripe account settings, keys, or webhooks without
  Product Owner approval, since this is a Hard-Gate-adjacent financial
  system.

## Routes / Components / Systems Affected

- Checkout initiation (frontend, wherever it is hosted — Lovable/Vercel).
- Stripe Checkout Session creation (server-side function).
- Stripe webhook receiver (Supabase Edge Function per
  `growth-events.ts` conventions).
- Supabase entitlement and purchase-attribution tables.
- Environment-variable matrix defined under `TASK-0012`.
- Referral ledger (student/parent "refer a friend" system).

## Data / Security / Integration Impact

Stripe keys and webhook signing secrets are production-sensitive credentials
and must never live client-side or in this repository. Entitlements must
only be granted from a verified webhook signature, never from a client
redirect. Purchase records touch billing data (not full card data — Stripe
handles PCI scope) and must be isolated between beta and production Supabase
projects per the `TASK-0012` environment split. Refund and referral-reward
logic must not create a payout path that inadvertently triggers reward
issuance before the refund window closes.

## Acceptance Criteria

- [ ] Current Stripe account/integration state is confirmed and documented
      (what exists today vs. what `CRAMAPPLE_MARKETING_STACK_REPORT_2026.md`
      assumed exists).
- [ ] Stripe product/price catalog matches the approved `BIZ-001` pricing
      decision.
- [ ] Checkout flow creates sessions server-side with referral metadata
      attached.
- [ ] Webhook handler verifies signatures and is the sole trigger for
      entitlement grants and `purchase_completed`/`referred_purchase`
      events.
- [ ] Refund handling is implemented and reconciled against referral
      rewards per the refund-window rule.
- [ ] All Stripe secrets are inventoried in the `TASK-0012`
      environment-variable matrix with correct environment scoping.
- [ ] A reconciliation check (manual or automated) confirms Supabase
      entitlement records match Stripe purchase records within the 5%
      target.
- [ ] A consolidated pre-launch checklist exists cross-referencing
      `BIZ-001`, `GTM-001`, and `TASK-0012` blocker status.

## QA Plan

- Manual QA: Full checkout-to-entitlement walkthrough in Stripe test mode,
  including a simulated webhook failure/retry and a simulated refund.
- Automated tests: Webhook signature verification unit tests; entitlement
  grant idempotency tests (duplicate webhook delivery must not double-grant).
- Regression areas: Free-score-check funnel (`LOVABLE_FREE_SCORE_CHECK_FUNNEL.md`
  explicitly excludes Stripe logic from Lovable-side changes), referral
  attribution, growth-event outbox.
- Failure cases: Webhook signature mismatch, duplicate webhook delivery,
  checkout session created but never completed, refund issued after reward
  already paid out, missing/empty Stripe secret at startup (must fail fast
  per `TASK-0012`'s known blockers, not default silently).
- Security/data/integration checks: No Stripe secret key or webhook signing
  secret ever appears client-side, in logs, or in this repository; test-mode
  and live-mode keys are never cross-wired between beta and production.

## Approval State

**Approval Required:** Yes
**Approval Type:** Hard Gate
**Decision:** Pending

## Implementation Notes

This task is being opened as a scoping/inventory record first. No live
Stripe account, key, or webhook changes have been made under this task yet.
This repository is documentation- and Supabase-migration-first; the actual
Stripe integration code (if any already exists) lives in the Lovable-managed
frontend and/or Supabase Edge Functions referenced in
`docs/architecture/SUPABASE_EDGE_FUNCTIONS_DRAFT.md`, which is outside this
repository's direct edit surface per `LOVABLE_FREE_SCORE_CHECK_FUNNEL.md`
("Do not create or alter ... Stripe logic ... in Lovable").

Next step is to confirm with David Bloom what currently exists in the live
Stripe dashboard and Lovable/Supabase codebase before drafting the detailed
execution plan, since `CRAMAPPLE_MARKETING_STACK_REPORT_2026.md` assumes an
"existing Stripe integration" that this repository has no record of.

## QA Review

Pending.

## Done Decision

**Decision:** Pending
**Date:** Pending
