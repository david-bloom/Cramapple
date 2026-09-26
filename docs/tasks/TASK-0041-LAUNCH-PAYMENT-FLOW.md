# TASK-0041 — Launch: Payment Flow

**Task ID:** TASK-0041
**Title:** Payment Flow — Post-Launch Verify-and-Fix (retained as post-launch Hard-Gate)
**Owner:** AI agent (implementation) — unassigned; candidate: Codex or Claude
**Product Owner:** David Bloom
**Tier:** Hard-Gate
**Status:** Not Started
**Priority:** Medium — **deferred, not on the October 2, 2026 launch-critical path** (`DECISION-0071`)
**Created Date:** 2026-09-26
**Approved Date:** Pending
**Branch:** Not yet created — assign per R1 (`<agent>/task-0041-<slug>`) when an agent starts execution
**PR:** None yet

## Codex QA note (2026-09-26, pre-execution review)

Codex reviewed this task record before any work started and returned **Fail — revision required**.
Findings folded into this revision: date corrected to October 2, 2026; retained as post-launch
Hard-Gate (Codex confirmed this disposition, no change to critical-path status); corrected the
entitlement-defect description and its ownership (see below — the new-student free-entitlement smoke
test is TASK-0043's scope for October 2; this task tracks only the paid/Stripe-side entitlement
reconciliation, post-launch); removed the assumption that Stripe sandbox changes automatically carry
Standing Approval. This is still a pre-execution draft — no implementation agent has been assigned, and
per `DECISION-0071` this task must not be picked up for the October 2 push regardless.

## Product Goal

A student can pay for one or more AP subjects (single, 2-bundle, 3-bundle, or unlimited) and be
correctly entitled, in both dev and production, with no path that grants access without a verified
payment and no path that takes payment without granting access.

## Technical Scope

Primary source: `docs/product/LAUNCH_PLAN_PAYMENT_FLOW_2026_09_26.md`, which itself wraps
`docs/tasks/TASK-0023-STRIPE-SETUP-AND-LAUNCH-READINESS.md` — read both in full before starting. Also
read `docs/product/LAUNCH_RUNBOOK_2026_10_02.md`'s "Explicitly post-launch" section, which lists
"Stripe checkout, webhook, bundles, promotions, refunds, and paid entitlement reconciliation" as
post-October-2 work — this task is that work.

**Do not pick this up for the October 2, 2026 launch push** (`DECISION-0071`: launches free, no Stripe
gating). Work it only once there's dedicated time post-launch. Current state (verify live, do not trust
either source doc's dated claims): substantially built and already exercised once for real (one
customer paid via live Stripe 2026-08-13/15); `stripe-webhook` now handles refunds, parent-gift
attribution, and async payment events beyond what TASK-0023 describes.

**Entitlement-gating ownership, corrected:** the October 2 launch grants entitlement to new students
through the free/trial signup path, not through Stripe — verifying that free-entitlement grant and the
resulting submit-to-grade round trip is **TASK-0043's scope** (runbook §2–4), and is launch-critical.
**This task (TASK-0041) owns only the paid-entitlement path**: confirming `attempt-response`'s
entitlement check behaves correctly for a *paid* subject once payment flow resumes, and the broader
Stripe-side entitlement reconciliation. Do not duplicate TASK-0043's free-entitlement smoke test here,
and do not let this task's post-launch status be read as meaning the free-entitlement question is also
deferred — it isn't; TASK-0043 owns it and it is launch-critical.

## Out of Scope

Same as TASK-0023: setting the actual price/refund policy (BIZ-001 itself), launch messaging (GTM-001,
covered by TASK-0040), non-payment cutover plumbing (TASK-0012), the tutor/creator affiliate portal.
The free-entitlement smoke test for October 2 (TASK-0043's scope, not this task's).

## Routes / Components / Systems Affected

- `supabase/functions/create-checkout-session`, `supabase/functions/stripe-webhook`
- `app.subject_entitlements`, `app.subjects` (Dev seeding gap: only 4 of 10 subjects present)
- Live and sandbox Stripe catalogs (`acct_1TddjmLwoRHzBJ1O` — live account, requires explicit approval
  for any change)
- Lovable-side `create-checkout-session` calls, `/checkout/success`, `/checkout/cancel` (outside this
  repo's edit surface — verify via Lovable or the live app)

## Data / Security / Integration Impact

Live Stripe account changes, live-mode secrets, and live-mode sales all require David's explicit
approval — see Hard Gates below. **No Stripe sandbox change carries Standing Approval by default** —
every write against the sandbox catalog or webhook config in this task requires the same explicit,
recorded approval as a live-account change, scoped down only in blast radius, not in approval
requirement.

## Acceptance Criteria

(Full detail and rationale in `LAUNCH_PLAN_PAYMENT_FLOW_2026_09_26.md` — this list mirrors it; that doc
governs if they drift.)

- [ ] Verify `STRIPE_WEBHOOK_SECRET` set/working in `Cramapple-Production` (evidence: real webhook
      delivery log) and `Cramapple-Development`.
- [ ] `APP_BASE_URL` confirmed set in both environments.
- [ ] Verify current live behavior of `attempt-response`'s entitlement check **for a paid subject**
      specifically (the free-entitlement path is TASK-0043's scope, not this one) — confirm whether the
      generic-error defect found 2026-09-20 still reproduces on the paid path, and fix or escalate if so.
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
- [ ] Update live and sandbox Stripe 2-bundle/3-bundle Prices to $79.99/$99.99. **Hard Gate for both** —
      requires David's explicit go for the live account, and for the sandbox per the corrected
      approval note above (no default Standing Approval for sandbox changes).
- [ ] BIZ-001 (access duration, refunds/discounts, parent-purchaser handling) closed — **Hard Gate**,
      owned by David with the Strategy Advisor. No bundle sellable before every subject in it passes
      TASK-0046 (full six-criteria Subject Onboarding Gate, post-launch).
- [ ] Lovable-side checkout routes confirmed working (verify via Lovable/live app).
- [ ] Referral-reward reconciliation verified live (don't assume TASK-0023's stale note still holds).

## QA Plan

- Manual QA: sandbox checkout-to-entitlement walkthrough, replayed webhook event for idempotency.
- Automated tests: none beyond what TASK-0023 already specifies.
- Regression areas: refund handling, parent-gift attribution, async payment events.
- Failure cases: double-grant on duplicate webhook; unentitled paid-tier student reaching scoring.
- Security/data/integration checks: query `app.subject_entitlements` directly after a real sandbox
  purchase; do not infer correctness from reading webhook code.
- **QA independence:** QA on this task must run in a fresh context, separate from the implementer
  (`AGENT_OPERATING_MODEL.md`). QA returns a proposed verdict only; it does not close this task.

## Approval State

**Approval Required:** Yes
**Approval Type:** Hard Gate (live Stripe account changes, live-mode secrets, live-mode sales, sandbox
Stripe changes, and BIZ-001 closure — none of these carry Standing Approval)
**Decision:** Pending — Codex reviewed this task record 2026-09-26 (Fail, revision required); this
revision folds in that feedback. Still awaiting Codex's re-review before being finalized; execution has
not started and must not start before the October 2 launch per `DECISION-0071`.

## Implementation Notes

**Implementation Summary:** _(To be filled by the implementation agent.)_

**Test Results:** _(To be filled by the implementation agent — sandbox walkthrough evidence, webhook
replay results.)_

**Risks / Issues:** _(To be filled by the implementation agent — e.g. the 2-bundle pricing flag, any
unresolved BIZ-001 item.)_

## QA Review

**QA Verdict:** Pending (Pass / Fail) — must come from a fresh, independent QA context.

**QA Result:** _(To be filled by the QA agent.)_

## Done Decision

**Decision:** Pending
**Date:** YYYY-MM-DD

Only the Main Conductor may set this task's status to `Done`, after integrating the QA Agent's
recommended verdict and verifying evidence (`AI_COLLABORATION_RULES.md`).
