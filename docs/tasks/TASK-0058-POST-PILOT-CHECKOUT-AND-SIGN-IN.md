# TASK-0058 — After the Pilot: Checkout, Sign-In and Payment-Setup Improvements

**Status:** Not Started. **Post-pilot** (not gating the $1 pilot or the Oct 2 launch).
**Tier:** Hard-Gate (payments; Production function deploys; Lovable publish; secrets)
**Owner:** TBD
**Product Owner:** David Bloom
**Date opened:** 2026-10-02
**Area:** Checkout UX / authentication / Stripe configuration / test infrastructure
**Parent decisions:** `DECISION-0094`, `DECISION-0090`; **evidence:** `docs/product/STRIPE_PRODUCTION_CUTOVER_CHECKLIST_2026_09_30.md` (Gate D)

## Why this exists

The $1 pilot (then 50% off through October) ships with the current checkout: email first, then payment, and the student types
their email. Live testing on 2026-10-02 showed that checkout works and is safe to pilot, and also surfaced a list of
improvements David wants. They are collected here so none is lost. **Do not start any of them until the pilot has run and
David has judged it a success (`DECISION-0094`).**

## Constraint that shapes everything below

The card form and wallet buttons need a Stripe Checkout Session, and today the server builds that session with the student's
email already on it (`customer_email`), because the webhook uses that email to decide who gets access. So payment cannot show
before an email exists, and the page re-creates the session whenever subjects, email or promo change. **There is no Dev
frontend:** the Lovable marketing project points only at Production (`.env`), so any checkout change can only be proven in
Production with real charges. Work A0 below removes that constraint first.

## Work items (in suggested order)

### A0. A Dev-pointed frontend for checkout testing (do first)
Make the marketing build switchable to the Dev Supabase project and Stripe test keys (a separate Lovable preview or
branch/env), so the Elements flow, wallets and the new-student path can be tested with test cards before Production.
*Done when:* a test-card purchase by a brand-new email completes on the Dev build end to end.

### A. Google sign-in the recommended way (replaces the redirect)
Google sign-in was **removed from `/checkout` on 2026-10-02** (Lovable `18666296`; the redirect flow showed the Supabase project
URL on Google's screen and left the page). Re-introduce it using what Chrome and Google recommend:
- Sign in with Google **button / One Tap with FedCM**, passing the Google ID token to Supabase with `signInWithIdToken` (hashed
  nonce; `use_fedcm_for_prompt: true`), so the student stays on the page and their **verified email fills step 3 immediately**.
- Use the shared `.cramapple.com` cookie-backed client (`supabase-browser`), so the app on `app.cramapple.com` sees the session.
- Google client: authorized JavaScript origins `https://cramapple.com` and `https://app.cramapple.com`; Supabase Google provider
  with the nonce check on.
- Confirm browser support (Safari, Firefox, Chrome) for FedCM before relying on it; fall back to the button.
*Done when:* a new student signs in with one tap, stays on `/checkout`, email is filled and locked, and payment proceeds.
*Sources:* Chrome identity docs (`developer.chrome.com/docs/identity`), FedCM, Sign in with Google (GIS), Supabase "Login with Google".

### B. Layout changes David asked for
1. Order the steps by their real dependency: **1 Subjects → 2 Email → 3 Payment**, each opening when the previous is done
   (signed-in students: payment opens as soon as a subject is picked).
2. **Wallets side by side:** Apple Pay, Google Pay and Link as separate buttons, never grouped under "2 payment methods"
   (Stripe's Express Checkout `layout` option: more columns, no overflow grouping).
3. **"Pay with card" is a secondary text link** that reveals the card form.
4. Optional (design decision): greyed placeholder logos for the three wallets before a subject is chosen, swapped for Stripe's
   real buttons when ready. Risk: showing Apple Pay on a device that cannot use it.
5. Show the **real total and the discount** from Stripe (see "Pre-pilot, small" below; do it before the pilot, not here).

### C. Wallets first, email from the payment (needs backend)
Collect the student's email from Apple Pay / Google Pay / Link (the wallet returns it; the paid session carries
`customer_details.email`) instead of a form field, and fill step 3 from it. Requires:
- `create-checkout-session`: allow creating a session without a student email;
- `stripe-webhook`: resolve the student from the paid session's email (not the stamped metadata);
- the page: create the session on subject pick, apply promos to the existing session, fill and confirm the email after payment;
- decision: the wallet's email may not be the student's (parent's device, personal address), so the student confirms it.
Depends on A0. *Done when:* a new student pays first with a wallet and ends with a confirmed account and access.

### D. One checkout per attempt, not per keystroke
Stop creating a new Stripe session each time subjects, email or promo change. Stripe supports updating an existing session
(promo code, email, and line items for custom-UI sessions in newer API versions). Needs a newer Stripe library/API version than
the functions use (`stripe-node` v17). Low customer value; do after C if at all.

### E. Stripe configuration hardening
- Pin `payment_method_types` in code (card + link; Apple/Google Pay ride on card) so a dashboard change cannot re-enable Bank,
  Klarna or Cash App by accident. Today the dashboard is the control (only Cards, Apple Pay, Google Pay, Link enabled).
- Register `cramapple.com` as an Apple Pay domain (verification file on the site) so Apple Pay shows in Safari.
- Check Link's own bank-account option and turn it off if present; David saw a "Bank" prompt after only four methods were enabled.
- Decide whether to enable more methods later (each needs the async-payment webhook paths proven).

### F. Email, support and account setup
- `support@cramapple.com` alias receiving mail (David, in progress; the refund text in the Terms names it).
- Make **Contact Us actually send** (today it shows "we've got it" and sends nothing), or replace it with a `mailto:` link.
- Supabase Auth **custom SMTP** and branded invite email (invite and 6-digit-code emails depend on it; unverified), plus a
  Supabase custom auth domain (`auth.cramapple.com`) if desired.
- **Google Auth Platform branding and verification** (below, David-owned, can start now).

### G. Passkeys
Chrome recommends passkeys as the primary sign-in. Supabase's passkey support is experimental (needs `supabase-js` ≥ 2.105.0;
registration requires an existing session). Revisit when it leaves experimental.

### H. Refund follow-ups
Per-subject partial refunds on bundles (today a *full* refund revokes the whole order, a partial one keeps access, per the
fix in PR #310); the BIZ-001 remainder (access duration, parent-purchaser handling).

## Google Auth Platform branding and verification (David; start now, takes business days)

Claude did not do this: it needs David's signed-in Google Cloud account and changes his identity configuration. Prepared values,
in **Google Cloud Console → Google Auth Platform → Branding**:

| Field | Value |
|---|---|
| App name | Cramapple |
| User support email | `support@cramapple.com` (the alias must receive mail first) |
| App logo | square PNG, 120×120 or larger, under 1 MB (needs the brand mark) |
| Application home page | `https://cramapple.com` |
| Privacy policy link | `https://cramapple.com/privacy` |
| Terms of service link | `https://cramapple.com/terms` |
| Authorized domains | `cramapple.com` **and** `supabase.co` (the OAuth callback lives on `<project>.supabase.co`) |
| Developer contact email | `support@cramapple.com` or David's address |

Also: set the app to **In production** (not "Testing"); keep scopes to `openid`, `email`, `profile` (non-sensitive, so only brand
verification applies); verify `cramapple.com` ownership in Google Search Console if Google asks; make sure the home page links to
the privacy policy. Per Supabase's guide, branding and verification replace the Supabase project ID on the consent screen with
the logo and name, and brand verification can take a few business days. (The Search Console and home-page-link points are
Google's usual requirements; confirm them in Google's own checklist.)

## Pre-pilot, small (NOT part of this task; do before Orly sends the code)

1. Show Stripe's **real total and the discount** on the page. Today "Total due today" and "Place order · $39.99" are fixed
   labels, so a $1 or 50%-off purchase still reads $39.99. (Lovable; display-only.)
2. Send the pilot as `cramapple.com/checkout?subject=<subject>&promo=<CODE>` so the code is applied before any wallet button is
   usable. Test it in a private window first.
3. Tell friends to **type their email** (Google sign-in is removed).
4. A brand-new-student test (invite email, 6-digit code, access, a graded question).

## Gates and approvals

Each code deploy to Production needs its own approval (as `APPROVAL-0069/0070/0071`). Any Lovable publish, Stripe dashboard
change, secret change or Supabase Auth change is David's. Prove each item on the A0 Dev build first; after A0, run a $1 live
test per release.

## Out of scope

Pricing and coupon strategy (`DECISION-0094`), the Phase 2 launch, the open-hand migration, `student-session-items`.
