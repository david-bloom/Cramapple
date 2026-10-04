# TASK-0060 — User Testing, Starting With Checkout

**Status:** In Progress (opened 2026-10-04). **Tier:** Hard-Gate for anything that touches payments, Production function deploys, Lovable publish, or secrets.
**Owner:** Claude. **Product Owner:** David Bloom.
**Area:** Checkout UX, return page, wallets, sign-in after purchase.
**Related:** `TASK-0058` (post-pilot checkout list; items A0, B, C, E overlap), `TASK-0041`, `DECISION-0094`, `docs/product/STRIPE_PRODUCTION_CUTOVER_CHECKLIST_2026_09_30.md`.

## Purpose

Run structured user testing of the live purchase and first-use path, record each observation with evidence, and send fixes to
the Lovable frontend (project `61dd6602-6991-4561-b418-e988bb7c8a0b`; the frontend is not in this repo). Nothing here changes
payment methods or pricing unless David says so.

## Evidence log

Evidence labels: **Observed** (David saw it), **Verified** (read in code or Production logs/DB this session).

### E1. Wallet availability by browser (2026-10-04) — working as designed
- Chrome: Google Pay renders (Observed). Safari: Apple Pay renders on `cramapple.com` (Observed). Firefox: no wallets, card form only (Observed).
- Stripe's Express Checkout Element shows only wallets the browser supports, so no device sniffing is needed. Wallets are not mobile-only.
- Still to confirm in the Stripe dashboard: `cramapple.com` listed under Payment method domains (Apple Pay works in Safari, which suggests it is).
- **Finding F1 (Observed):** in Firefox the "Express Checkout" heading stays with an empty gap, because the section does not know no wallets are coming.

### E2. Live Google Pay purchase, $39.99, Biology (2026-10-04, ~19:31 UTC)
- Backend (Verified, Production): session `cs_live_b1KV…` is `completed` / `paid`, `amount_total` 3999, one active paid entitlement,
  created ~2 s after payment. The webhook also sent the Supabase invite email (`/welcome` redirect) at 19:31:40.
- **Finding F2 — "Start Studying Now" does nothing (Observed; cause Verified).** The buyer is not signed in, so
  `StartStudying.tsx` calls `signInWithOtp`. Supabase returned **HTTP 429** at 19:31:48 and 19:31:56: the invite email had just
  used the one-auth-email-per-address-per-minute allowance. The idle-state button branch never renders `error`, so the failure is
  silent. Access itself was granted; the page just gave no way in and no explanation.
- **Finding F3 — no spinner while the wallet transaction completes (Observed).** Nothing shows between confirming in the wallet
  and the redirect. The return page's "Payment processing" view also has no spinner.

### Open from earlier in the session (not yet fixed)
- **F4 — wallet buttons ignore a promo code (hazard, from the cutover checklist, line 171).** The wallet row is live on page
  load; the promo is applied only after Apply. Backend already honours `promo_code` (`create-checkout-session/index.ts:221`).
  Mitigation until fixed: send pilot links as `cramapple.com/checkout?subject=<subject>&promo=<CODE>`.
- **F5 — no Dev-pointed checkout (`TASK-0058` A0).** Checkout changes can only be proven in Production with real charges.

## Fix prompts to Lovable

| # | Covers | State |
|---|---|---|
| P1 | F1 + loading/empty state for Express Checkout (spinner, `onReady` → `availablePaymentMethods`, hide block when empty, 4 s fallback) | Sent by David, Lovable running (2026-10-04) |
| P2 | F2 + F3: render errors in the idle state; treat 429 as "we just emailed you a link, retry in 60 s" with countdown; spinners for wallet confirm and return page; no auto-resend | Drafted, David to paste after P1 finishes |
| P3 | F4: read `?promo=` on load, promo field above wallets, rebuild session on promo change with wallets disabled meanwhile, real total | Drafted, not sent |

## Ideas parked (not decided)

- **QR / "continue on your phone" for desktop buyers** (same pattern as `capture_pairing_tokens`; needs a small backend piece), or the cheaper "text me the link" / existing Ask-a-Parent flow.
- **Return page without a second email:** the webhook already emails an invite, so the page could say "check your email" instead of sending an OTP. Decide after P2 is tested.
- **Venmo:** US-only, via PayPal, new async webhook paths; `TASK-0058` E pins methods to card and wallets. Not for the pilot.

## Test plan after each publish

Firefox (spinner then card only, no empty heading), Safari (spinner then Apple Pay), Chrome (spinner then Google Pay), Chrome on
Slow 3G (spinner stays, falls back after ~4 s). Return page: buy as a brand-new email, click Start Studying immediately and
confirm a visible message (not silence) and a working path in; then again after 60 s.

## Done when

F1–F4 are fixed and re-tested on the live site, the new-student path (pay, return page, get in) works first time, and each
Lovable publish and any Production change has David's approval recorded.
