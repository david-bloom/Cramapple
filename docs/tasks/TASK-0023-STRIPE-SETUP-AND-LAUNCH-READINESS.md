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
- Stripe Checkout flow is implemented (`create-checkout-session` Edge
  Function). **Referral metadata is not yet wired in** — see
  **Entitlement Schema, Webhook, and Checkout Implementation** below.
- Stripe webhook handler is implemented (`stripe-webhook` Edge Function) as
  the sole trigger for entitlement grants and the `purchase_completed`
  growth event. `referred_purchase` and refund events are not yet handled
  — see below.
- Entitlement-granting logic is implemented, triggered only by the verified
  webhook signature — never by client-side checkout completion.
- Stripe secret/key inventory (`STRIPE_SECRET_KEY`, `STRIPE_WEBHOOK_SECRET`,
  `STRIPE_PRICE_CATALOG_JSON`, `APP_BASE_URL`) has been added to the
  `TASK-0012` environment-variable matrix
  (`docs/architecture/PRODUCTION_PLUMBING_AND_CUTOVER_PLAN.md` §5.3/§5.4).
  None of these secrets have actually been set in either Supabase project
  yet — that remains a deployment step.
- Refund handling and its interaction with referral-reward reconciliation
  (`CRAMAPPLE_MARKETING_STACK_REPORT_2026.md` referral section: rewards
  reconcile only after the refund window) is **not yet built** — explicitly
  deferred until Checkout/webhook/entitlements are deployed and exercised.
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

## Sandbox (Test-Mode) Catalog Inventory (Confirmed 2026-08-11)

David Bloom set up a separate Stripe **sandbox account**
(`acct_1U3K3SLrvKNd9sBp`, confirmed `livemode: false`) and built a full
test-mode catalog there, structurally identical to the live catalog — same
10 single-subject Products at $39.99 each, same 2-subject/3-subject/
unlimited bundles at $69.99/$89.99/$139.99. This resolves the "no test-mode
Stripe catalog exists" gap flagged below and in the `TASK-0012`
environment-variable matrix. No Promotion Code exists in the sandbox either
(same gap as live — `GET /v1/promotion_codes` returned zero results).

Sandbox `subject_key`-mapped catalog (`STRIPE_PRICE_CATALOG_JSON` value for
beta), matched against `app.subjects.subject_key` in `Cramapple-Production`
since that's the full 10-subject reference:

```json
{
  "subjects": {
    "biology": "price_1U3K8YLrvKNd9sBpxWXkeLrY",
    "ap-chemistry": "price_1U3K90LrvKNd9sBpRLF53BDY",
    "ap-calculus-ab": "price_1U3K9SLrvKNd9sBpEa2DGRKS",
    "ap-calculus-bc": "price_1U3K9uLrvKNd9sBpuynttET4",
    "ap-precalculus": "price_1U3KALLrvKNd9sBpWJ7JtFVS",
    "ap-physics-1": "price_1U3KAkLrvKNd9sBpYN4rV3k3",
    "ap-physics-2": "price_1U3KBELrvKNd9sBpzIIjp6Eb",
    "ap-physics-c-em": "price_1U3KBpLrvKNd9sBpTBgu6Cpw",
    "ap-physics-c-mechanics": "price_1U3KCHLrvKNd9sBppivXoWWz",
    "ap-statistics": "price_1U3KCfLrvKNd9sBpJaqrzf7m"
  },
  "bundle_2": "price_1U3KDDLrvKNd9sBpkZVzARmd",
  "bundle_3": "price_1U3KE0LrvKNd9sBpB8oSe9qL",
  "unlimited": "price_1U3KEXLrvKNd9sBp4BJ44dRg"
}
```

**The subject-parity gap is narrower than originally flagged, and doesn't
block all testing.** `Cramapple-Development`'s `app.subjects` table still
only has 4 of these 10 rows (`biology`, `ap-chemistry`, `ap-physics-1`,
`ap-statistics`). Concretely, in beta:

- **Single-subject and bundle purchases** for those 4 subject keys will
  complete end-to-end (Checkout → webhook → entitlement grant) once secrets
  are set and the functions are deployed.
- **Single-subject or bundle purchases** for the other 6 subject keys
  (Calc AB/BC, Precalculus, Physics 2, Physics C E&M/Mechanics) will create
  a valid Checkout Session — the Stripe catalog has all 10 — but the
  webhook's `app.subjects` lookup will fail with
  `checkout_session_unknown_subject_keys` and the entitlement grant for
  that subject will not be created, since `Cramapple-Development` doesn't
  have a matching row yet.
- **Unlimited purchases work regardless**, since the webhook grants access
  by querying `app.subjects` directly (not the Stripe catalog) — in beta
  today that correctly grants the 4 subjects that actually exist there, not
  10, which is expected scoping rather than a bug.

Backfilling the missing 6 subject rows into `Cramapple-Development` would
close this gap, but that's a content/course-readiness decision (does a
`subjects` row without the underlying content pipeline being ready create a
misleading "available" subject?), not a Stripe or schema question — flagging
it rather than doing it as part of this task.

## Entitlement Schema, Webhook, and Checkout Implementation (2026-08-11)

Code-complete; **not yet deployed or configured with live secrets**. Nothing
in this section has touched the live Stripe account or been applied to
either Supabase project — it is committed migrations and Edge Function
code only. Deployment (`supabase db push`, `supabase functions deploy`,
setting the actual secret values) is a separate, later step.

**Entitlement table: extended `app.subject_entitlements`, not a new table.**
That table already existed (`supabase/migrations/20260731160200_free_score_check_growth_funnel.sql`,
built for the beta/free-score-check flow) with exactly the shape this task
needed — `user_id`, `subject_id`, `access_tier`, `status`, `source`, plus a
unique `(user_id, subject_id, access_tier, source)` constraint that already
gives entitlement grants natural idempotency. Migration
`supabase/migrations/20260811160000_stripe_entitlement_support.sql` adds:

- `stripe_checkout_session_id` and `stripe_event_id` columns, so every
  Stripe-granted row traces back to the purchase that created it;
- `all_subjects boolean not null default false`, tagging rows created by an
  unlimited purchase.

**Unlimited access: per-subject expansion at purchase time, not a nullable
wildcard row.** The design doc originally floated a wildcard entitlement row
with a null `subject_id`. Built it instead as one entitlement row *per
existing subject* (all tagged `all_subjects = true`), because: (1) it
requires zero changes to any existing reader of `subject_entitlements`,
including whatever Lovable-side code already queries this table expecting
one row per owned subject; (2) it keeps `subject_id not null`, so no FK/check
constraint rework. The "does unlimited cover subjects added after purchase"
policy question is answered by a trigger
(`app.grant_unlimited_holders_new_subject`, same migration): whenever a new
row is inserted into `app.subjects`, every user with an active
`all_subjects = true` entitlement is automatically backfilled with an
entitlement for it. Unlimited genuinely means unlimited, including future
subjects, without any Lovable-side change required.

**Webhook idempotency: an explicit ledger table, in addition to the
entitlement unique constraint.** Migration
`supabase/migrations/20260811160100_stripe_webhook_events.sql` adds
`app.stripe_webhook_events` (Stripe event id as primary key). The webhook
receiver inserts a row keyed by `event.id` before doing any entitlement
writes; a primary-key conflict on redelivery means the event was already
handled, and the receiver acknowledges without reprocessing. This matches
the idempotency rule in `PRODUCTION_PLUMBING_AND_CUTOVER_PLAN.md` ("retry
paths must be idempotent") and gives an audit trail Postgres can be queried
against directly.

**New Edge Functions** (`supabase/functions/`):

- `create-checkout-session/index.ts` — authenticated (student/admin only,
  via the existing `requireProfile` helper), takes
  `{ mode: "single"|"bundle_2"|"bundle_3"|"unlimited", subject_keys?: string[] }`,
  resolves the Price ID from the environment-provided catalog (see below),
  creates the Checkout Session server-side with `client_reference_id` set to
  the Supabase user id, `allow_promotion_codes: true`, and
  `metadata.mode`/`metadata.subject_ids`, and fires the `checkout_started`
  growth event. Returns `{ url }` for the frontend to redirect to — no
  Stripe.js/publishable key needed, since this uses hosted Stripe Checkout
  rather than Stripe Elements.
- `stripe-webhook/index.ts` — verifies the raw-body signature
  (`Stripe-Signature` header) via `stripe.webhooks.constructEventAsync`
  (the async variant, required because Deno has no synchronous Node
  crypto), records the event in the idempotency ledger, and on
  `checkout.session.completed` grants one entitlement row per subject (or
  expands to all active subjects for `unlimited`), then fires
  `purchase_completed`. All other event types are acknowledged with no
  action taken (so Stripe doesn't retry them), including refund events —
  refund handling is explicitly deferred, not silently dropped.
- `_shared/stripe.ts` — Stripe client (fails fast on missing
  `STRIPE_SECRET_KEY` at module load, matching `_shared/supabase.ts`'s
  pattern) and the signature-verification wrapper (`STRIPE_WEBHOOK_SECRET`
  required lazily, only when the webhook receiver actually calls it, so
  `create-checkout-session` doesn't need that secret defined).
- `_shared/stripe-catalog.ts` (+ `_shared/stripe-catalog_test.ts`) — parses
  and validates the `STRIPE_PRICE_CATALOG_JSON` environment variable into a
  `{ subjects: Record<subject_key, price_id>, bundle_2, bundle_3, unlimited }`
  shape. The catalog is read from an environment variable, not a database
  table or hardcoded IDs, because the mapping is environment-specific (test
  vs. live Stripe Price IDs) and must never be cross-wired between beta and
  production — see the `TASK-0012` environment-variable matrix update below.

**Referral metadata is not yet wired in.** `create-checkout-session` does
not currently accept or forward a referral code/identifier into Checkout
metadata. This was explicitly scoped out of this pass — the referral ledger
design (`CRAMAPPLE_MARKETING_STACK_REPORT_2026.md` referral section) hasn't
been built yet on the Supabase side, so there's nothing to attribute to.
Follow-up work, not forgotten scope.

**Two environment gaps found while wiring the config, not introduced by
this change:**

- **Production's `app.subjects` table has all 10 launch subjects with
  `subject_key` values matching the Stripe catalog exactly** (confirmed by
  direct read-only query against `Cramapple-Production`, 2026-08-11) — the
  production `STRIPE_PRICE_CATALOG_JSON` value is recorded verbatim in the
  `TASK-0012` environment-variable matrix update.
- **`Cramapple-Development` (beta) only has 4 of the 10 subjects seeded**
  (`biology`, `ap-chemistry`, `ap-physics-1`, `ap-statistics`). A full
  test-mode Stripe catalog now exists (see **Sandbox (Test-Mode) Catalog
  Inventory** above, `acct_1U3K3SLrvKNd9sBp`) — that half of the gap is
  closed. What remains is narrower: purchases of the other 6 subject keys
  will create a valid test-mode Checkout Session but fail entitlement grant
  at the webhook's `app.subjects` lookup until those rows are backfilled in
  `Cramapple-Development`. Unlimited purchases are unaffected by this gap.

**Not built in this pass, and why:**

- Refund handling and referral-reward reconciliation — explicitly deferred;
  depends on Checkout/webhook/entitlements actually being deployed and
  exercised first.
- The Coupon/Promotion Code for the "add another subject" incentive, and
  `lookup_key`/`metadata` on existing Prices — both still open from the
  Live Catalog Inventory gaps above; unrelated to schema/Edge Function work.
- The Lovable-side frontend changes needed to actually call
  `create-checkout-session` and handle the `/checkout/success` and
  `/checkout/cancel` routes — outside this repository's edit surface per
  `LOVABLE_FREE_SCORE_CHECK_FUNNEL.md`.

## Dev/Beta Deployment Log (2026-08-11)

Deployed to `Cramapple-Development` (`wmgjsdkphcyhngaffbqf`) with David
Bloom's explicit go-ahead. **This is the first live deployment under this
task** — everything before this point was code/docs only.

- `STRIPE_SECRET_KEY` (sandbox test-mode restricted key, scoped to
  Checkout Sessions write) and `STRIPE_PRICE_CATALOG_JSON` (the sandbox
  catalog value from **Sandbox (Test-Mode) Catalog Inventory** above) set
  as Supabase Edge Function secrets by David Bloom.
- Both migrations applied directly via the Supabase SQL Editor:
  `20260811160000_stripe_entitlement_support.sql` and
  `20260811160100_stripe_webhook_events.sql`. `app.subject_entitlements`
  now has the Stripe columns; `app.stripe_webhook_events` exists.
- Both Edge Functions deployed: `create-checkout-session` (`verify_jwt:
  true` — students authenticate via Supabase JWT) and `stripe-webhook`
  (`verify_jwt: false` — Stripe's request carries its own HMAC signature,
  not a Supabase JWT, so requiring one would make Supabase's gateway
  reject every legitimate webhook delivery before the function ever runs).
- Live dev webhook URL: `https://wmgjsdkphcyhngaffbqf.supabase.co/functions/v1/stripe-webhook`.

**Still open before dev is fully wired:** `STRIPE_WEBHOOK_SECRET` — this
requires registering the URL above as a webhook endpoint against the
**sandbox** Stripe account (`acct_1U3K3SLrvKNd9sBp`, test mode) for the
`checkout.session.completed` event, which only produces a signing secret
once the endpoint exists; and `APP_BASE_URL`, not yet confirmed set.

**Production has not been touched by this task.** `STRIPE_SECRET_KEY` was
set on `Cramapple-Production` by David Bloom directly (restricted key,
outside this task's tool access), but the migrations are not applied and
the Edge Functions are not deployed there.

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

- Checkout initiation (frontend, wherever it is hosted — Lovable/Vercel;
  not yet built — needs to call `create-checkout-session`).
- `supabase/functions/create-checkout-session/index.ts` (built).
- `supabase/functions/stripe-webhook/index.ts` (built).
- `supabase/functions/_shared/stripe.ts`,
  `supabase/functions/_shared/stripe-catalog.ts` (built).
- `app.subject_entitlements` (extended, not replaced) and
  `app.stripe_webhook_events` (new) — see
  `supabase/migrations/20260811160000_stripe_entitlement_support.sql` and
  `supabase/migrations/20260811160100_stripe_webhook_events.sql`.
- Environment-variable matrix defined under `TASK-0012` (updated).
- Referral ledger (student/parent "refer a friend" system) — not yet built,
  referral metadata plumbing depends on it.

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
- [x] Checkout flow creates sessions server-side (`create-checkout-session`
      Edge Function, code-complete, not yet deployed). Referral metadata is
      **not** attached yet — the referral ledger this depends on doesn't
      exist yet; tracked as follow-up, not closed.
- [x] Webhook handler verifies signatures and is the sole trigger for
      entitlement grants and `purchase_completed` (`stripe-webhook` Edge
      Function, code-complete, not yet deployed). `referred_purchase` is
      not yet handled — same referral-ledger dependency as above.
- [ ] Refund handling is implemented and reconciled against referral
      rewards per the refund-window rule. Explicitly deferred.
- [x] All Stripe secrets are inventoried in the `TASK-0012`
      environment-variable matrix with correct environment scoping
      (`STRIPE_SECRET_KEY`, `STRIPE_WEBHOOK_SECRET`,
      `STRIPE_PRICE_CATALOG_JSON`, `APP_BASE_URL`, beta and production
      tables). None of the actual secret values have been set yet — the
      matrix documents what's needed, not that it's live.
- [ ] A reconciliation check (manual or automated) confirms Supabase
      entitlement records match Stripe purchase records within the 5%
      target.
- [ ] A consolidated pre-launch checklist exists cross-referencing
      `BIZ-001`, `GTM-001`, and `TASK-0012` blocker status.

## QA Plan

- Manual QA: Full checkout-to-entitlement walkthrough in Stripe test mode,
  including a simulated webhook failure/retry and a simulated refund.
  **Not yet run** — blocked on the beta test-mode-catalog gap noted above;
  nothing has been exercised against a live Stripe endpoint.
- Automated tests: `supabase/functions/_shared/stripe-catalog_test.ts`
  covers the price-catalog parsing/validation logic (added). Webhook
  signature verification and entitlement-grant idempotency (duplicate
  webhook delivery must not double-grant) still need tests — signature
  verification specifically needs a real webhook secret to test against, so
  it's realistically a post-deployment check rather than a pure unit test.
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

The entitlement schema, webhook receiver, and Checkout Session creation
function are now code-complete — see **Entitlement Schema, Webhook, and
Checkout Implementation** above for what was built and the design decisions
made (extending the existing `subject_entitlements` table rather than a new
one, per-subject expansion plus a backfill trigger for unlimited access
instead of a nullable wildcard row, and an explicit idempotency ledger for
the webhook).

Remaining, in rough order:

1. Deploy: apply the two new migrations, set the four new secrets per
   environment, deploy the two new Edge Functions, register the live
   webhook endpoint with Stripe. Not done in this pass — see the "Not built
   in this pass" list above for why.
2. Close the beta/dev environment gaps found while wiring this up: seed the
   remaining 6 subjects into `Cramapple-Development`, and build a test-mode
   Stripe catalog before beta can safely exercise Checkout.
3. Build the Coupon + Promotion Code for the "add another subject" incentive
   (not yet created), and decide the shared-vs-per-customer promo code
   question.
4. Build the Lovable-side frontend calls to `create-checkout-session` and
   the `/checkout/success` / `/checkout/cancel` routes — outside this
   repository's edit surface.
5. Build the referral ledger, then wire referral metadata into
   `create-checkout-session` and handle `referred_purchase` in the webhook.
6. Refund handling and referral-reward reconciliation, last, since it
   depends on all of the above existing and being exercised first.

## QA Review

Pending.

## Done Decision

**Decision:** Pending
**Date:** Pending
