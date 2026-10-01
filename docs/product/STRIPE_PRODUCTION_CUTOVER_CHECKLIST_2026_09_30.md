# Stripe Production Cutover Checklist

**Status:** DRAFT — not approved. No Production change, secret, or Stripe live-mode action has been taken.
**Tier:** Hard-Gate (payments, Production deploys/migrations, secrets)
**Owner:** David Bloom (Product Owner, final approver). Drafted by Claude.
**Date:** 2026-09-30
**Governing records:** `TASK-0041`, `DECISION-0083`, `DECISION-0090`, `DECISION-0091`, `docs/product/LAUNCH_RUNBOOK_2026_10_02.md`
**Supersedes for this purpose:** `TASK-0023` (background only; TASK-0041 governs where they differ)

## 0. Scope decided 2026-09-30 (David, in chat — to be recorded as a DECISION)

1. **Parent-pays is live on October 2.** All six checkout functions go to Production, not two.
2. **The 100%-off coupon is entered by the student.** It is not auto-applied. This refines `DECISION-0091`'s open
   "auto-applied vs. entered" question.

> Record both as a DECISION entry (next free ID — `DECISION-0093` already exists; verify at write time). Until recorded,
> they are chat-only direction (session-start rule: a new owner decision must be recorded durably).

Consequences of "entered by student":
- `create-checkout-session` already supports it: with no `promo_code` input it sets `allow_promotion_codes: true`
  (`create-checkout-session/index.ts:221-223`). With a code supplied it validates via `promotionCodes.list` and applies it
  as a `discount`. **Both paths must be tested at $0** (§3, step 1b).
- The student must be told the code. How it reaches them (landing copy, email, Orly's class) is **undecided** — see §7.
- A coupon that anyone can enter is, in effect, public. Cap redemptions and set an expiry (§4).

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

Exit: all of the above green, with session/event IDs written into this doc.

## 4. Gate B — Stripe live-mode setup (David, in the Stripe dashboard)

Claude has no Stripe access this session and cannot verify any of this. Everything below needs David to confirm.

- [ ] **Account activation** complete for live charges (business details, bank, identity).
- [ ] **Live catalog** matches `DECISION-0083` prices: **$39.99 single / $69.99 two-bundle / $89.99 three-bundle**. (The
      older `DECISION-0069` prices of $79.99/$99.99 are superseded — confirm none were created.) Day-1 subjects are AP
      Biology and AP Statistics; any other subject the checkout can sell needs a live price or must be hidden.
- [ ] **Live coupon:** 100% off, `duration: once`, **restricted to the Day-1 subject products**, with a
      **max-redemptions cap** and **expiry date**. Create the **promotion code** (the string students type); consider
      one redemption per customer. The code string is a Hard-Gate secret-ish value: do not paste it into logs.
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

- [ ] New student → `/checkout` → picks Biology + Statistics → **types the live code** → total shows $0.00 → completes.
- [ ] `payment_status = no_payment_required`; `stripe_checkout_sessions` row; **active Biology and Statistics entitlements**;
      `get-checkout-status` = `paid`; a graded attempt is accepted (the runbook's entitlement-to-grading stop condition).
- [ ] Wrong/expired/over-cap code shows a clear error and charges nothing.
- [ ] Parent-share path with a live $0 code, or one real charge by David on his own card, then refunded to prove revocation
      (David's decision; Claude cannot make payments).
- [ ] Webhook delivery log in Stripe shows 2xx; `stripe_webhook_events` rows `processed`; no `failed` rows.
- [ ] Clean up the QA student's records only after checking H7 classification.

## 7. Open questions (David)

1. **How do students get the code?** (landing copy, email, class distribution). Needed before Gate D passes.
2. Redemption cap and expiry date for the live coupon.
3. **D-6, D-9, D-10, D-11** (Payment flow's four open decisions, David-only per the activity log) — are any of them on the
   Oct 2 path, or all post-launch?
4. Does the 2-bundle / 3-bundle matter on Oct 2, or can the Day-1 catalog be the single-subject prices only?
5. Refund/access-duration/parent-purchaser terms (BIZ-001) — still undecided; deferred past launch unless you say otherwise.

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
