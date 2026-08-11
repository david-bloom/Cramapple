# TASK-0023 — Stripe Setup and Commercial Launch Readiness

**Task ID:** TASK-0023
**Title:** Stripe Setup and Commercial Launch Readiness
**Owner:** Main Conductor (Claude)
**Product Owner:** David Bloom
**Tier:** Standard
**Status:** In Progress
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
  Lovable/Supabase codebase today. **Done for the Stripe-side catalog** — see
  **Live Catalog Inventory** below; the Lovable/Supabase codebase side is
  still unconfirmed.
- Product/price catalog is built (see **Live Catalog Inventory**). Remaining:
  create the Coupon/Promotion Code for the "add another subject" incentive,
  and consider adding `lookup_key`/`metadata` to existing Prices so
  Checkout/webhook code isn't hardcoding opaque Price IDs.
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

## Pricing and Catalog Design (Settled 2026-08-10)

Cramapple sells per-subject access, with three additional multi-subject
options: a 2-subject bundle, a 3-subject bundle, and an unlimited-subjects
option. The catalog and purchase-flow shape below is settled, and the
Product/Price catalog has now been built live in Stripe by David Bloom (see
**Live Catalog Inventory** below); the Coupon/Promotion Code for the
"add another subject" incentive has not been built yet.

**Catalog shape — no combinatorial SKUs.** The catalog holds `N + 3` Prices,
not one per subject-combination:

- one Product+Price per subject (the single-subject SKU), e.g. AP Biology,
  AP Chemistry, AP Statistics;
- one flat Price for the 2-subject bundle;
- one flat Price for the 3-subject bundle;
- one flat Price for unlimited access.

Bundle Prices are priced by subject **count**, not subject **identity**.
Stripe never encodes which specific subjects are in a bundle. When a student
buys a bundle, the app collects which subjects they want (a checkbox picker
built in-app, not a Stripe UI) and the Checkout Session is created
server-side with one bundle-price line item plus `subject_ids` metadata
(e.g. `"biology,chemistry"`) and a `bundle_tier` metadata value. The
`checkout.session.completed` webhook reads `subject_ids` and grants one
Supabase entitlement row per listed subject — the app-side entitlement
check never needs to know whether a subject came from a bundle or a single
purchase. Unlimited access should be stored as a wildcard
(`all_subjects_access`-style) entitlement rather than an explicit subject
list, so it automatically covers subjects added after purchase; confirm this
policy (does "unlimited" cover future subjects, or only subjects that exist
at purchase time?) before implementation.

**Single-subject purchases always pay the individual price.** There is no
bundle-building-up-from-singles path and no dynamically computed "upgrade"
price. A student who already owns one subject and buys a second pays the
same single-subject Price as their first purchase (subject to the coupon
mechanism below). This removes the need for any ad-hoc/computed pricing,
per-owned-subject-count Price tiers, or upgrade-specific refund attribution
that earlier drafts of this design considered.

**"Add another subject" incentive uses a Stripe Coupon/Promotion Code, not a
special price tier.** The marketing nudge ("add another subject and use
coupon code `upgrade123` for a special price") is implemented as:

- a Stripe **Coupon** (percent-off or amount-off), scoped via
  `applies_to.products` to the single-subject Prices only, so it cannot be
  applied to a bundle purchase;
- a Stripe **Promotion Code** (the human-typeable code, e.g. `upgrade123`)
  pointing at that coupon;
- `allow_promotion_codes: true` on the relevant Checkout Sessions so the
  student can redeem it directly in Stripe Checkout.

Entitlement-granting logic needs no special case for a coupon-discounted
purchase — it is a normal single-subject `checkout.session.completed` event
at a lower `amount_total`, same `subject_ids` metadata contract as any other
single-subject buy.

**Two open items, deferred to the product-code build:**

1. **Shared vs. per-customer promo code.** A single shared code (e.g.
   `upgrade123` for everyone) is simplest but can leak or be reused by
   students who don't qualify, since Stripe promo codes don't know about
   Cramapple's own entitlement state — the app controls *who sees* the
   prompt, not *who can redeem* the code. A per-customer one-time code
   (generated via the Stripe API when the upgrade prompt is shown, with
   `max_redemptions: 1`) closes that gap at the cost of more implementation
   work. Not yet decided.
2. **Bundle-vs-discounted-singles economics.** Confirm the discounted
   second-subject price (single price + coupon discount) does not end up
   cheaper than the 2-subject bundle price, or the bundle stops making sense
   as an option. This is a `BIZ-001` pricing decision, not a Stripe
   mechanics question.

## Live Catalog Inventory (Confirmed 2026-08-10)

Read directly from the Stripe account (`acct_1TddjmLwoRHzBJ1O`, **live
mode** — this is the production account, not a test/sandbox account).
Confirms the "current Stripe account state" acceptance criterion below for
the catalog piece specifically.

**Single-subject Products/Prices — all $39.99, matching the catalog-shape
design (uniform single-subject pricing):**

| Subject | Product ID | Price ID |
| --- | --- | --- |
| AP Biology | `prod_V3PCLFKw9P2cq8` | `price_1U3INlLwoRHzBJ1OyQ39k1pa` |
| AP Chemistry | `prod_V3PCYJ3LVzwQoX` | `price_1U3IOKLwoRHzBJ1OFiAhGBSp` |
| AP Calculus AB | `prod_V3PD2wvS3QgXfd` | `price_1U3IPVLwoRHzBJ1ORy4CtabU` |
| AP Calculus BC | `prod_V3PEED57royCpT` | `price_1U3IPvLwoRHzBJ1OD3HluYsw` |
| AP Precalculus | `prod_V3PEOrdKvybQk5` | `price_1U3IQQLwoRHzBJ1Oyt5XMyww` |
| AP Physics 1 | `prod_V3PFChjrxgp8HC` | `price_1U3IQuLwoRHzBJ1O0amAJ5AI` |
| AP Physics 2 | `prod_V3PGwdj56Fx7Eo` | `price_1U3IRmLwoRHzBJ1OdjKrTZMK` |
| AP Physics C (E&M) | `prod_V3PHmt2mR8vjtV` | `price_1U3ISaLwoRHzBJ1OrHupALNo` |
| AP Physics C (Mechanics) | `prod_V3PHAMr9IgCdip` | `price_1U3IT5LwoRHzBJ1OGNddcGk1` |
| AP Statistics | `prod_V3PIFj8Wsbsf0A` | `price_1U3ITWLwoRHzBJ1O4WFXqTsj` |

**Bundle Products/Prices:**

| Bundle | Price | Product ID | Price ID | vs. buying singles |
| --- | --- | --- | --- | --- |
| Two-subject | $69.99 | `prod_V3PKr0pjRGW2pX` | `price_1U3IVNLwoRHzBJ1OFc4H9iVD` | saves $9.99 vs. $79.98 |
| Three-subject | $89.99 | `prod_V3PKIt6XwjeDsm` | `price_1U3IW8LwoRHzBJ1Oxew8VHHI` | saves $29.98 vs. $119.97 |
| Unlimited | $139.99 | `prod_V3PObx87qoA9x8` | `price_1U3Ia0LwoRHzBJ1OBG1vlN1b` | flat, no per-subject comparison |

**Other existing product (pre-dates this task, not part of the AP-subject
catalog):** Parent Portal, `prod_Uctlu9DThoL5LQ` / `price_1TddxjLwoRHzBJ1OIhFbAkko`,
$19.99.

**Gaps found against the settled design:**

- **No Coupon or Promotion Code exists yet** (`GET /v1/promotion_codes`
  returned zero results). The "add another subject, use code `upgrade123`"
  incentive described above is designed but not built. This is the
  remaining catalog-side gap before Checkout/webhook work can exercise the
  full purchase-flow design.
- **No `lookup_key` set on any Price and no `metadata` on any Product or
  Price.** Checkout/webhook code will currently have to hardcode Price IDs
  or maintain a separate ID-to-subject mapping table in Supabase. Setting a
  `lookup_key` (e.g. `subject_ap_biology`) and/or `metadata.subject_code` on
  each Price would let that code reference subjects by stable key instead
  of opaque Price IDs — worth doing before Checkout-session code is
  written, since it is far cheaper to add now than to retrofit later.
- **One orphaned active Price**: `price_1TddwxLwoRHzBJ1OXK7XDGhZ` ($29.99)
  references product `prod_UctkNAK45kubxy`, which did not appear in the
  active-products list — likely an inactive/archived product with a
  still-active Price attached. Not blocking; worth a look in the Stripe
  dashboard to confirm it's intentionally retired and not something a
  Checkout Session could still accidentally reference.

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

- [x] Current Stripe account/integration state is confirmed and documented
      for the catalog (Live Catalog Inventory, 2026-08-10); Lovable/Supabase
      codebase side still unconfirmed.
- [x] Stripe product/price catalog is built and matches the settled
      catalog-shape design (10 single-subject Prices + 3 bundle Prices, all
      uniform single pricing). Confirmation against a formally approved
      `BIZ-001` price is still open since `BIZ-001` itself is still
      "Proposed" in `MASTER_TODO.md`.
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

This task opened as a scoping/inventory record. David Bloom has since built
the live Stripe Product/Price catalog directly (Product Owner action, not
executed through this repository) — see **Live Catalog Inventory** above,
read directly from the Stripe account on 2026-08-10. No writes have been
made to the live Stripe account from this task; all catalog inspection was
read-only.

This repository is documentation- and Supabase-migration-first; the actual
Checkout/webhook integration code (if any already exists) lives in the
Lovable-managed frontend and/or Supabase Edge Functions referenced in
`docs/architecture/SUPABASE_EDGE_FUNCTIONS_DRAFT.md`. Backend logic
specifically (webhook receiver, Checkout Session creation, entitlement
grants) belongs in Supabase Edge Functions per the `TASK-0012` rule against
authoritative logic living in Lovable-hosted `_serverFn` infrastructure —
this repository owns that surface (`supabase/functions/`,
`supabase/migrations/`), so those pieces can be built here once scoped.

Remaining before Checkout/webhook implementation can start:

1. Build the Coupon + Promotion Code for the "add another subject" incentive
   (not yet created).
2. Decide the shared-vs-per-customer promo code question (open item above).
3. Add an entitlement schema migration (`subject_entitlements`-style table
   with a wildcard flag for unlimited access) — not yet started.
4. Build the webhook receiver Edge Function and the Checkout Session
   creation Edge Function — not yet started.
5. Fold Stripe secrets into the `TASK-0012` environment-variable matrix —
   not yet started.

## QA Review

Pending.

## Done Decision

**Decision:** Pending
**Date:** Pending
