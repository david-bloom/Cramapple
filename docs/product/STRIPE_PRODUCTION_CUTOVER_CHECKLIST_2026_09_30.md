# Stripe Production Cutover Checklist

**Status:** DRAFT — scope recorded in `DECISION-0094`; Production steps not approved. No Production change, secret, or Stripe live-mode action has been taken.
**Tier:** Hard-Gate (payments, Production deploys/migrations, secrets)
**Owner:** David Bloom (Product Owner, final approver). Drafted by Claude.
**Date:** 2026-09-30
**Governing records:** `TASK-0041`, `DECISION-0083`, `DECISION-0090`, `DECISION-0091`, `docs/product/LAUNCH_RUNBOOK_2026_10_02.md`
**Supersedes for this purpose:** `TASK-0023` (background only; TASK-0041 governs where they differ)

## 0. Scope decided (David, in chat, 2026-09-30 / 10-01 — to be recorded as a DECISION)

**Revised plan (supersedes the $0-coupon shape of `DECISION-0091`; amends `DECISION-0071`):**

1. **Phase 1 — paid-flow pilot.** Orly gives a **$1 coupon, capped at 10 redemptions**, to a small group of friends, who
   sign up promptly. It is "basically free" but a **real card charge**, so it exercises the live payment path.
2. **Phase 2 — public launch at 50% off through October**, after the pilot shows checkout works.
3. **Parent-pays is live** (all six functions go to Production).
4. The code is **entered by the student** (not auto-applied) and **emailed by Orly**.

> Record as a DECISION (next free ID — `DECISION-0093` already exists; verify at write time) that supersedes
> `DECISION-0091` and amends the runbook's Oct 2 shape. Until recorded it is chat-only direction.

**What changes because the pilot uses $1 instead of $0:**
- The unproven $0 / `no_payment_required` path (H6) is **no longer on the critical path** — keep it as optional Dev work.
- The real-card, `paid` webhook path is what gets proven. That is the exact path the 50% launch depends on.
- The 10 charges are an opportunity to test **refund → entitlement revocation** live (refund one deliberately).

**Constraints this creates (see §4 and §7):**
- `create-checkout-session` supports student-entered codes (`allow_promotion_codes: true` when none is passed;
  `index.ts:221-223`), and `create-parent-payment-link` accepts a `promo_code` too.
- **The $1 total only holds for a single-subject cart.** A fixed `amount_off` coupon removes a fixed amount, so it can
  only land on exactly $1.00 against one $39.99 price. On a 2- or 3-subject bundle it would leave ~$31 or ~$51.
  Restrict the coupon to the single-subject products (Stripe `applies_to`) so bundle carts reject it.
- **The $30 add-on will be offered to the pilot group, and it charges for real.** `create-post-purchase-addon` charges a
  fixed `ADDON_AMOUNT_CENTS = 3000` off-session against the card saved at checkout, and the offer appears after any
  single-subject `student_direct` **paid** purchase. Decide deliberately whether pilot users see it (see §7).
- The code leaves our control when emailed: the 10-use cap and an expiry are the only access control. The code string
  must never be written into this repo (docs, logs, tests, commits).
- Pilot users pay with real cards. Terms, refund handling, and receipts must exist before the first charge (§7).

## 1. Verified state (2026-09-30, read-only against Supabase)

| Item | Production (`pcntajvbdfqhbeewmdry`) | Dev (`wmgjsdkphcyhngaffbqf`) |
|---|---|---|
| `create-checkout-session` | v21, Aug, **verify_jwt = true** | v19, verify_jwt = false |
| `stripe-webhook` | v20, Aug, verify_jwt = false | v24 |
| `get-checkout-status` | **not deployed** | v18 |
| `create-parent-payment-link` | **not deployed** | v15 |
| `send-parent-payment-email` | **not deployed** | v12 |
| `create-post-purchase-addon` | **not deployed** | v15 |
| `app.stripe_customers` | **missing** | present |
| `app.parent_payment_email_requests` | **missing** | present |
| `app.stripe_webhook_events` replay columns (`status`, `attempt_count`, `last_attempt_at`) | **missing** | present |
| `app.claim_stripe_webhook_event()` | **missing** | present |
| `stripe_checkout_sessions`, `stripe_checkout_session_attempts`, `subject_entitlements` | present, **column-for-column identical to Dev** | present |
| Row counts | 5 webhook events, 5 checkout sessions, 253 entitlements | — |

Production is running the pre-redesign Stripe code (August). The redesign work in TASK-0041 has only ever run in Dev.

## 2. Hazards — read before touching anything

- **H1 — Order matters: migrations before functions.** The new `stripe-webhook` calls `claim_stripe_webhook_event` and
  `persistStripeCustomer` (`index.ts:282-303`), which ends `if (error) throw error`. Deploying the new webhook before the
  migrations makes every student checkout fail in the webhook, so **no entitlement is granted**.
- **H2 — JWT setting.** Dev runs the checkout/payment functions with `verify_jwt = false` (anonymous checkout, parent
  links, Stripe's webhook). Production's `create-checkout-session` is `true`. Every deploy must pass `--no-verify-jwt`, or
  anonymous checkout and parent links return 401. Re-check the flag on all six after deploy.
- **H3 — Do not apply `20260929034129_open_hand_entitlement_scoped_contract.sql` to Production** (TASK-0051 gate). Apply
  only the three migrations in §5 phase D, by name.
- **H4 — Do not run `supabase db push`** (TASK-0055 ledger drift). Production is migrated with `apply_migration`, which
  records a different version than the filename; rename the local file to the recorded version afterwards or a later push
  breaks on a non-idempotent migration.
- **H5 — Do not deploy `student-session-items` from `main`.** Production is v28 with TASK-0051's change deliberately excluded.
- **H6 — The $0 checkout is unproven anywhere.** PR #284 changed the grant logic (`no_payment_required` counts as settled)
  but was never run. The unknown is whether the Elements checkout confirms a $0 order with no payment method, given that
  `create-checkout-session` also sets `payment_intent_data.setup_future_usage` (`index.ts:237`) and a fully discounted
  session may create no PaymentIntent. If it does not, the fix is code, and it must land and be proven in Dev first.
- **H7 — Existing Production Stripe rows.** The 5 events / 5 sessions are from the earlier live purchase and tests. Classify
  them (live vs. test) before live mode is enabled, so smoke-test cleanup can't touch real-customer records.
- **H8 — Parent-paid cards are never saved** (`DECISION-0090`). Do not change `create-parent-payment-link` or the webhook's
  parent branch during cutover. Verify `app.stripe_customers` stays empty for parent-share purchases in Production.

## 3. Gate A — Prove it in Dev (test mode). Nothing in Production until this passes.

Owner: David deploys; Claude verifies against the database.

1. Deploy to Dev (command in PR #284): `stripe-webhook`, `get-checkout-status`.
   - 1.0 **$1 coupon, single-subject cart, real test card** (the pilot path): code typed into the promo field → total
     $1.00 → `payment_status = paid` → one entitlement → `get-checkout-status` = `paid`. Also confirm a **bundle cart
     rejects** the $1 code.
   - *Optional now (not pilot-critical):* 1a/1b below test the $0 path.
   - 1a. **$0, code passed at session creation.** Sandbox 100%-off promo code → session completes → `payment_status =
     no_payment_required` → entitlements active → `get-checkout-status` reports `paid`.
   - 1b. **$0, code typed into the Elements promo field** (the real student path). Same expectations.
   - 1c. If either fails: stop, fix in code, redeploy, rerun. Record the failure mode (this settles H6).
2. **Paid card checkout** (student-direct): webhook grants entitlements once; `stripe_customers` row written.
3. **Parent-share:** student creates link → `send-parent-payment-email` delivers (Loops) → parent pays → student gets
   entitlement → `stripe_customers` has **no** row for the parent. Note the email audit table
   (`parent_payment_email_requests`) stores only a hash.
4. **Add-on** (`create-post-purchase-addon`): offered only after a real `paid` charge, never after a $0 order.
5. **Replay/idempotency:** resend a webhook; no double grant. **Refund:** `charge.refunded` revokes.
6. Anonymous caller can't read another student's checkout status.

### Gate A evidence — 2026-10-02 (Dev, Stripe sandbox, `stripe-webhook` v25, `get-checkout-status` v19)

**Path tested: parent-share hosted checkout** (`create-parent-payment-link`). The student-direct Elements path was **not** tested
(no Dev-pointed frontend; Stripe's Elements UI can't be driven from here).

| Test | Result | Evidence |
|---|---|---|
| Full-price paid purchase | **Pass** | `cs_test_b1Rmx…` ($39.99, AP Statistics): `evt_1ULtu6…` `checkout.session.completed` processed, attempt 1; 1 active entitlement (`stripe_checkout_single`); status `paid`/`entitled`; no `stripe_customers` row |
| $1 coupon typed on the checkout page | **Pass** | `cs_test_b1IkM…` (AP Chemistry): subtotal 3999, discount 3899, **total 100**, promotion code recorded; `evt_1ULty9…` processed, attempt 1; entitlement source `stripe_checkout_single_coupon`; status `paid` |
| First attempt (code entered but not applied) | n/a | `cs_test_b1Rmx…` was charged $39.99 with `disc=0` — operator error, not a defect |
| Refund → revoke | **Pass** | `evt_3ULty7…` `charge.refunded` processed, attempt 1; the coupon entitlement `revoked`; status `refunded`/`entitled:false`; the other (full-price) entitlement untouched |
| Parent card not saved | **Pass** | `app.stripe_customers` gained no rows in either purchase |
| Parent-share add-on offer | **Pass** (offer `null`, correct) | `get-checkout-status` |

**Observations (not blockers):** `stripe_checkout_sessions.coupon_ids` stays empty even when a promotion code and discount are recorded;
report coupon usage from `promotion_codes` / `amount_discount`, or from the `*_coupon` entitlement source.

**Not yet proven:** student-direct Elements checkout; the $30 add-on (needs a student-direct paid single-subject purchase);
bundle cart with the $38.99 coupon; $0 path (optional); replay of a duplicate webhook on the new code; anonymous caller can't read another
student's status.

Exit: steps 1.0 and 2-6 green (1a/1b optional), with session/event IDs written into this doc.

### Frontend findings — read-only, 2026-10-02 (Lovable marketing project `61dd6602`, source at `be89e6a`, plus the live page)

- **The frontend talks only to Production Supabase** (`pcntajvbdfqhbeewmdry`, hardcoded in `.env`). There is no Dev-pointed build, so the
  student-direct Elements path **cannot be tested against Dev**. Its first real run will be the Production smoke test (Gate D).
- **Live student card payment is currently OFF.** `cramapple.com/checkout` shows "Online payment isn't switched on yet. You can still
  ask a parent to pay below." The Stripe publishable key is read from `VITE_STRIPE_PUBLISHABLE_KEY`, which is not in `.env` (it lives in
  Lovable's environment). Turning payment on = set it to the **live** publishable key and publish. Do this **last**, after Gate C-E.
- **"Ask a parent to pay" is visible today but cannot work:** it calls `create-parent-payment-link`, which is not deployed in Production.
- **Promo codes are applied at session creation.** The page validates the code, then recreates the session with `promo_code`, so
  `create-checkout-session` takes its `discounts` path (not the in-Elements path). `?promo=` in the URL is also supported. The $0
  in-Elements question (H6) is therefore moot for the pilot.
- **Conflicting public copy:** the homepage says "Sign up for free until November. Then a one-time $39.99 per subject after that."
  That contradicts `DECISION-0094` (strangers pay full price during the pilot, then 50% off through October). Fix before payment is switched on.
- Pricing shown on the page ($39.99 / $69.99 / $89.99) matches `DECISION-0083`.

### Production secrets findings — read-only, 2026-10-02

- **`STRIPE_SECRET_KEY` and `STRIPE_WEBHOOK_SECRET` have the identical digest in Production** (`998b04ba…`), so they hold the **same value**. In Dev the two digests differ, as they must (a secret key and a webhook signing secret are different strings). At least one of the two Production values is wrong, so the Production webhook cannot be trusted to verify live Stripe signatures, and/or Stripe API calls would fail. I cannot tell which is wrong or when it changed. **Do not enable payment until both are re-set from the Stripe live dashboard.**
- **The key *was* live in August:** all 5 stored Production webhook events and all 5 stored sessions carry `livemode: true`.
- **`STRIPE_PRICE_CATALOG_JSON` must contain an `unlimited` price ID** or the whole catalog fails to load and every checkout function errors (`stripe-catalog.ts`: `unlimited` is in the required bundle keys). Unlimited is deferred and the UI never offers it, so use an inert placeholder (an existing live price ID, e.g. the 3-bundle's). The Production catalog digest differs from Dev's; its contents (live vs test IDs, `unlimited` present) are unverified.
- Subject keys the catalog should use (must match the app's slugs): `biology`, `ap-statistics`, `ap-chemistry`, `ap-physics-1`, `ap-physics-2`, `ap-physics-c-mechanics`, `ap-physics-c-em`, `ap-precalculus`, `ap-calculus-ab`, `ap-calculus-bc`. A subject with no price shows the student "One of those subjects isn't available yet", which is graceful; Day-1 needs `biology` and `ap-statistics`.
- Confirmed by David 2026-10-02: live prices in Stripe match $39.99 / $69.99 / $89.99. Refund text is live in the Terms; the "free until November" homepage line is removed.

**Resolved 2026-10-02 (David, from the Stripe live dashboard; verified by Claude from Supabase secret fingerprints only):**
- Live webhook endpoint now subscribes to all 5 events (David added `charge.refunded`; it had 4).
- `STRIPE_SECRET_KEY` and `STRIPE_WEBHOOK_SECRET` re-set; fingerprints now differ from each other and from before (`68bf1848…`, `c7eb7e38…`). *Not verifiable by Claude:* that the key is a live key and the signing secret belongs to the live endpoint. Gate D proves both.
- `STRIPE_PRICE_CATALOG_JSON` re-set to the 10 subject prices + `bundle_2` + `bundle_3` + `unlimited` (placeholder). Validated with `parsePriceCatalog`; Production fingerprint `4cebcef0…` equals the SHA-256 of the validated JSON. All 13 IDs carry the live-account fragment. Amounts confirmed by David. "AP Calculus AP" was read as `ap-calculus-ab`.
- `APP_BASE_URL` = `https://cramapple.com` (fingerprint match). `ALLOWED_ORIGINS` allows `https://cramapple.com` and `https://app.cramapple.com` (header probe).

### Gate D evidence, part 1 — Production, live mode, existing student (2026-10-02)

David, signed in as an existing admin student, paid **$39.99** for AP Biology with **Link** on `cramapple.com/checkout` (live Stripe). The promo code was **not** applied (see "hazard" below), so this was a full-price charge, then refunded by David.

| Check | Result | Evidence |
|---|---|---|
| Live key, live signing secret, live webhook | **Pass** | `evt_1UM9arLwoRHzBJ1O…` `checkout.session.completed` (`livemode: true`) processed, attempt 1 |
| Session recorded | **Pass** | `cs_live_b1SCeh…`: single, biology, paid, subtotal 3999, discount 0, `student_direct` |
| Entitlement | **Pass** | paid/biology `stripe_checkout_single` active, tied to the live session (the August row re-activated by upsert) |
| Card saved for the add-on | **Pass** | `app.stripe_customers` row with a payment method; `get-checkout-status` returned the $30 add-on offer |
| **Partial refund keeps access** (fix from PR #310, first run in Production) | **Pass** | $10.00 refund: `evt_3UM9anLwoRHzBJ1O16quYKf4` processed; entitlement still active; status paid/entitled |
| **Full refund revokes** | **Pass** | remaining $29.99: `evt_3UM9anLwoRHzBJ1O1BM5hyVr` processed; entitlement `revoked`; status `refunded` / not entitled |

**Not yet proven:** (1) the **$1 coupon on a live checkout**; (2) the **new-student path** (the webhook creates the auth user with `inviteUserByEmail`; "Start Studying Now" then emails a 6-digit code with `shouldCreateUser: false`), which also depends on Supabase email delivery; (3) a graded attempt after payment; (4) the add-on purchase itself.

**Hazard found:** the Link / Apple Pay / Google Pay buttons are live as soon as the page loads, but the promo field is below them and the checkout is built without a code until the student presses Apply. Paying with a wallet first charges full price. Mitigation: send the pilot as `cramapple.com/checkout?subject=<subject>&promo=<CODE>`, which the page applies when it creates the checkout (verified in `checkout.index.tsx`). Test that link in a private window first.

**Fixed along the way (Lovable, `230e0670`):** the card form failed to load with "You cannot update the email because a `customer_email` … is already set" because the page re-sent the email Stripe already had. Removed from `defaultValues` and both `confirm()` calls.

**Stripe live settings (David):** only Cards, Apple Pay, Google Pay and Link are enabled; Bank, Cash App Pay, Klarna and Amazon Pay were switched off.

## 4. Gate B — Stripe live-mode setup (David, in the Stripe dashboard)

Claude has no Stripe access this session and cannot verify any of this. Everything below needs David to confirm.

- [ ] **Account activation** complete for live charges (business details, bank, identity).
- [ ] **Live catalog** matches `DECISION-0083` prices: **$39.99 single / $69.99 two-bundle / $89.99 three-bundle**. (The
      older `DECISION-0069` prices of $79.99/$99.99 are superseded — confirm none were created.) Day-1 subjects are AP
      Biology and AP Statistics; any other subject the checkout can sell needs a live price or must be hidden.
- [x] **Pilot coupon created by David in live mode (2026-10-01):** promotion code `promo_1ULmINLwoRHzBJ1OIjwp6dwH`, **$38.99 off, 1 use,
      10 redemptions max, first-time orders only; not yet shared.** Not restricted to single-subject products, so a bundle cart
      costs $31.00 (2) or $51.00 (3). **Risk accepted by David** (10 people max; errors handled manually). No expiry set.
      Original spec, for reference:
- [ ] **Pilot coupon:** fixed **`amount_off` = single-subject price − $1.00** (e.g. $38.99 off a $39.99 price), `duration: once`,
      **restricted via `applies_to` to the single-subject products** (confirm bundles are separate products), **max
      redemptions = 10**, **expiry date**, one redemption per customer. Create the **promotion code** string students type.
      Do not paste the string into logs or this repo. Stripe's card minimum ($0.50) is satisfied at $1.00; expect ~$0.33
      in fees per charge.
- [ ] **Phase 2 coupon** (50% off through October): create later, after the pilot; `percent_off: 50`, expiry Oct 31.
- [ ] **Live webhook endpoint:** `https://pcntajvbdfqhbeewmdry.supabase.co/functions/v1/stripe-webhook`, subscribed to
      exactly the events the handler processes: `checkout.session.completed`,
      `checkout.session.async_payment_succeeded`, `checkout.session.async_payment_failed`, `checkout.session.expired`,
      `charge.refunded`. Dev showed signing-secret mismatches before (TASK-0041 L273-282): **one endpoint only** per mode.
- [ ] Stripe Radar / receipt-email / statement-descriptor settings reviewed.
- [ ] Apple Pay domain registered for the checkout domain (cramapple.com) — the funnel depends on Apple/Google Pay.

## 5. Gate C — Production changes (each needs David's explicit approval; request as one APPROVAL, itemized)

Phases run in this order. Do not reorder (H1).

**A. Secrets (David only; Claude never sees values).** Set on Production edge functions:

| Secret | Value |
|---|---|
| `STRIPE_SECRET_KEY` | live secret key |
| `STRIPE_WEBHOOK_SECRET` | signing secret of the *live* endpoint from Gate B |
| `STRIPE_PRICE_CATALOG_JSON` | live price IDs: `{"subjects":{"biology":"price_…","ap-statistics":"price_…"},"bundle_2":"price_…","bundle_3":"price_…"}` — match key names to `_shared/stripe-catalog.ts` and Dev's catalog |
| `APP_BASE_URL` | the origin that actually serves `/checkout` and `/checkout/cancel` (success/cancel/return URLs are built from it). Confirm cramapple.com vs app.cramapple.com against the live Lovable project — checkout is in the **marketing** project `61dd6602`. |
| `ALLOWED_ORIGINS` | include the checkout origin(s) |
| `LOOPS_SECRET_KEY` | Production Loops key (parent email) |

- [ ] Confirm which Stripe mode the *current* Production `STRIPE_SECRET_KEY` is in, before overwriting (it served the Aug purchase).

**B. Rehearse migrations.** Dry-run the three SQL files against a Production-shaped copy or read them line by line against
§1. All three are idempotent / additive (`create table if not exists`, `add column if not exists`, one backfill `update`
on a 5-row table).

**C. Back up** the five `app.stripe_*` rows and `subject_entitlements` (253) — a SELECT export is enough; nothing is destructive.

**D. Apply to Production, in order** (via `apply_migration`; Claude executes after approval):
1. `20260928134000_task0041_payment_runtime_repair.sql` — adds `stripe_customers` (the two session tables already exist)
2. `20260928135500_task0041_parent_email_audit.sql` — `parent_payment_email_requests`
3. `20260928191213_task0041_webhook_replay.sql` — replay columns, check constraint, `claim_stripe_webhook_event`

Then verify: tables exist, RLS on and service-role-only, `claim_stripe_webhook_event` executable by `service_role` and by
nobody else, the five existing events backfilled to `processed`/`failed`/`received` correctly. Fix ledger version drift (H4).

**E. Deploy six functions to Production (David's Mac — cloud sessions can't reach the Supabase API).** Deploy from a clean
`main`, one at a time, each with `--no-verify-jwt`:
`stripe-webhook`, `create-checkout-session`, `get-checkout-status`, `create-parent-payment-link`,
`send-parent-payment-email`, `create-post-purchase-addon`.
Claude then re-downloads each deployed source and diffs against `main` (byte-identical, as was done for TASK-0056), and
confirms `verify_jwt = false` on all six.

**F. Lovable marketing frontend (`61dd6602`, David publishes).** Verify, by reading source first (never by guessing):
live Stripe **publishable** key, `/checkout` and `/checkout/cancel` routes, the promo-code field, "Ask a parent to pay",
parent confirmation screen, passwordless login, the post-checkout "Start studying now" gate (verified session only).
Test-mode keys must not ship in the published build.

## 6. Gate D — Production smoke test (stop condition for launch)

Labeled launch-QA student, real public route, live mode. David must perform any step that charges a card.

- [ ] David, as a launch-QA student: `/checkout` → one subject → **types the live $1 code** → total shows $1.00 →
      pays with his own card.
- [ ] `payment_status = paid`; `stripe_checkout_sessions` row; **active entitlement for that subject**;
      `get-checkout-status` = `paid`; a graded attempt is accepted (the runbook's entitlement-to-grading stop condition).
- [ ] Bundle cart with the $1 code is rejected; wrong/expired/over-cap code shows a clear error and charges nothing.
- [ ] **Refund that $1 charge** → entitlement revoked (`charge.refunded`).
- [ ] Parent-share path: a parent (David on a second card/device) pays via the link; student receives the entitlement;
      no `stripe_customers` row for the parent. Claude cannot make payments.
- [ ] Add-on behavior is what §7 decided (offered and charges $30, or hidden).
- [ ] Webhook delivery log in Stripe shows 2xx; `stripe_webhook_events` rows `processed`; no `failed` rows.
- [ ] Clean up the QA student's records only after checking H7 classification.

## 7. Open questions (David)

1. ~~How do students get the code?~~ **Answered:** Orly emails it. Send only after Gate D passes.
2. ~~Add-on for the pilot group~~ **Answered (David):** pilot users who pay $1 for one subject **do** see the $30 "add another
   subject" offer (single-subject buyers only; `get-checkout-status/index.ts:134`). It charges the saved card for real.
3. **Refund policy and terms must exist before live mode is enabled** (BIZ-001: access duration, refunds, parent
   purchasers) — not just before the 50% launch, because of item 4. Include what happens to a full-price buyer when the
   50% offer starts (refund, credit, or nothing).
4. ~~Is `/checkout` publicly reachable?~~ **Answered (David):** yes; strangers may reach it and pay full price ($39.99)
   during the pilot. Accepted. Consequence: real money from the public starts the moment live mode is on (item 3).
5. **Coupon expiry** and which single-subject products it covers (Biology and Statistics?).
6. ~~Phase 2 trigger~~ **Answered (David):** success is the Product Owner's judgment call; no automated gate. Claude reports
   the evidence (paid sessions, `failed` webhook rows, entitlement + graded attempt confirmed, refund result).
7. **D-6, D-9, D-10, D-11** (Payment flow's four open decisions) — which, if any, now sit on the Phase 2 path? D-9
   (promo code) is clearly relevant to the 50% launch.
8. Price anchor: confirm the public price list is **$39.99 / $69.99 / $89.99** (`DECISION-0083`), since "50% off" will
   advertise it.

## 8. Rollback

- **Stop new redemptions instantly:** deactivate the promotion code in Stripe (no deploy needed).
- **Stop all payments:** disable the live webhook endpoint (grants stop; sessions still record) or revert the Lovable publish.
- **Functions:** redeploy the previous commit's source (the August code is `main` history; the pre-cutover Production
  source should be downloaded and kept before step E).
- **Migrations:** additive; no rollback required. Don't drop tables with live rows.
- Entitlements granted by mistake are revoked through the existing `charge.refunded` path or a David-approved SQL fix.

## 9. Approval summary

| Needs | Who | Status |
|---|---|---|
| Record §0 decisions | David | pending |
| Gate A pass (Dev test-mode, all 6 steps) | David + Claude | not started |
| Stripe live-mode setup + live coupon (Gate B) | David | not started |
| Production secrets (Gate C-A) | David | not approved |
| Production migrations (Gate C-D) | David approves, Claude applies | not approved |
| Production function deploys (Gate C-E) | David | not approved |
| Lovable publish (Gate C-F) | David | not approved |
| Final go/no-go | David | not approved |

## 10. Not verified in this draft

No Stripe tooling was available: live-mode account state, the current Production key mode, Loops configuration, the Apple Pay
domain, and the Lovable frontend source were **not** read. Everything in §1 is from Supabase and the repo only.
