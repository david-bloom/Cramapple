# TASK-0060 — User Testing, Starting With Checkout

**Status:** In Progress (opened 2026-10-04). **Tier:** Hard-Gate for anything that touches payments, Production function deploys, Lovable publish, or secrets.
**Owner:** Claude. **Product Owner:** David Bloom.
**Area:** Checkout UX, return page, wallets, sign-in after purchase.
**Related:** `TASK-0058` (post-pilot checkout list; items A0, A, B, C, E overlap), `TASK-0041`, `DECISION-0090`, `DECISION-0094`,
`docs/product/STRIPE_PRODUCTION_CUTOVER_CHECKLIST_2026_09_30.md`, `docs/product/PURCHASE_FUNNEL_TECHNICAL_SPEC_2026_09_27.md` §12.

## Purpose

Run structured user testing of the live purchase and first-use path, record each observation with evidence, and send fixes to
the Lovable frontend (project `61dd6602-6991-4561-b418-e988bb7c8a0b`; the frontend is not in this repo). Nothing here changes
payment methods or pricing unless David says so. Lovable publishes are David's step; Claude reads each diff before David tests.

Evidence labels: **Observed** (David saw it), **Verified** (read in code, Lovable source, or Production logs/DB by Claude).

## Evidence log

### E1. Wallet availability by browser (2026-10-04) — working as designed
- Chrome: Google Pay renders. Safari: Apple Pay renders on `cramapple.com` (so the Apple Pay domain is registered; still worth a
  look in Stripe Payment method domains). Firefox: no wallets, card form only. (All Observed.)
- Stripe's Express Checkout Element shows only wallets the browser supports, so no device sniffing is needed. Wallets are not mobile-only.
- **F1 (Observed):** in Firefox the "Express Checkout" heading stayed with an empty gap. Fixed by P1.
- **Observed after P3b:** Safari shows the Apple Pay button about 2 s after the page is ready (session creation, Stripe load, Element ready).

### E2. Live Google Pay purchase, $39.99, Biology (2026-10-04, ~19:31 UTC)
- Verified (Production): session `cs_live_b1KV…` is `completed` / `paid`, `amount_total` 3999, one active paid entitlement, created
  ~2 s after payment. The webhook also sent the Supabase invite email (`/welcome` redirect) at 19:31:40.
- **F2 — "Start Studying Now" did nothing (Observed; cause Verified).** The buyer is not signed in, so `StartStudying.tsx` calls
  `signInWithOtp`. Supabase returned **HTTP 429** at 19:31:48 and 19:31:56: the invite email had just used the one-auth-email-per-
  address-per-minute allowance. The idle-state button never rendered `error`, so the failure was silent. Fixed by P2.
- **F3 — no spinner while the wallet transaction completes (Observed).** Fixed by P2.

### E3. Promo behaviour after P3b (Observed, 2026-10-04)
- The promo field now sits above the wallets. Applying a coupon shows the discount in the order summary; removing it restores full price.
- **F6 — after removing a coupon NO payment option renders (Observed; cause Verified).** The page showed "Apple Pay, Google Pay, or
  Pay by credit card once steps 1 and 2 are complete" and "1 step left: add a payment method" although both steps were complete.
  Cause: `removePromo` only dispatched `promoRemoved`; the auto-session effect skips a key already recorded in `autoSessionKey`
  (the original no-promo key), and applying a promo does not update it, so no session was rebuilt. On a `?promo=` link the key
  differs, so the effect fell back to `search.promo` and silently re-applied the removed code. Fixed by P4.
- The promo guard (typed, unapplied code blocks wallets, card and Place order) was **not** reported as tested. Check 1 below still open.

### E4. Copy and layout feedback (Observed, 2026-10-04)
- "Pick up to three AP subjects. Every option is a single payment." read as a confusing upsell to a buyer who had picked one subject
  for $39.99. The tier price list ("One $39.99, two $69.99, three $89.99") and "0 of 3 picked" line did not respond to the selection.
- The persistent bottom checkout bar was far too large.
- **Product Owner decisions (David, chat, 2026-10-04):** no upsell copy on checkout (intro follows the number of subjects in the URL:
  "Pick your subject" / "Pick your two subjects" / "Pick your three subjects"); thin sticky bar with total, Place order and an
  "Ask a parent to pay" link; payment options in the order **Express Checkout, card, parent pay**; card is always an option in
  every browser and for every subject combination; wallet skeleton from first paint. Fixed by P4 and P4b.

### E5. Second live purchase, $1 promo, Biology (2026-10-04, 20:50 UTC)
- Verified (Production): session `cs_live_a1g1…` `completed` / `paid`, `amount_total` 100, `amount_discount` 3899, one active paid
  entitlement, written ~2 s after the session was created. The webhook created the account at 20:50:11 (invited, **email not
  confirmed, never signed in**).
- Not reported: what the return page's Start Studying showed. **F9 (below, decided):** why a paid buyer cannot go straight in. **F10 (below):** no confirmation email arrived.

### Review findings from reading the published source (Verified)
- **F7:** after P4 the picker no longer disabled tiles at three picks, so a fourth click was silently ignored by the reducer. Fixed by P4b.
- **F8:** after P4 the wallet slot appeared only once a session was being created, so the card and parent buttons were pushed down
  ~48 px in Chrome and Safari. Fixed by P4b.

## F9 (DECIDED 2026-10-04): must a paid buyer verify their email before entering the app?

**Product Owner decision (David, chat, 2026-10-04): layered, with the email code as the fallback.** Keep the rule that payment alone
never signs a device in (`DECISION-0090`). Remove the friction by layering the three options below, and always keep the email code
as the fallback underneath, because it is the only path that works for every buyer:
1. **Google sign-in at checkout** (`TASK-0058` A) where the buyer uses it: verified email, no code.
2. **Else the wallet's email as proof** (`TASK-0058` C), only when it is a Google Pay email that matches the typed checkout email
   (an Apple Pay relay address does not count unless the student confirms it).
3. **Else one email instead of two:** the purchase email carries the 6-digit code as well as the link, and the return page shows the
   code box immediately with no second send.

Suggested build order, cheapest first: (3) the one-email path (a Supabase Auth template change, Hard Gate, David approves), then
(1) Google (needs David's Google Cloud branding and verification, which can take days), then (2) the wallet path last (it needs
session creation and the webhook to stop stamping the typed email, `TASK-0058` C). Each layer needs its own approval and a Dev test first.

**Delivery comes first (see F10).** None of the layers helps if Supabase cannot deliver email to real recipients (unverified, see F10).

**Original analysis and the options considered (kept for the record):**

**Today (`DECISION-0090`, spec §12.2/§12.4):** payment clearing never signs the device in. A buyer who is not already signed in must
prove the email with a 6-digit code (`signInWithOtp` with `shouldCreateUser: false`, then `verifyOtp`) before "Start Studying Now"
opens the app. Stated reason: otherwise anyone could pay to enter another person's account by typing their email.

**Claude's reading of the risk (for David's decision):** the rule is needed even for brand-new accounts, because the account
is created at purchase from a *typed* email. If a buyer were signed in without proving the address, (1) a typo such as an
invalid domain gives a paid account that nobody can reach, (2) a buyer using someone else's address on an existing account would
land inside that person's account, and (3) on a new account the buyer would hold a live session in an account that the address's
real owner later logs into (a pre-hijacking pattern). The friction is real, and E2 shows the current implementation adds a second
failure on top (the invite email and the code email collide on the one-email-per-minute limit).

**Options that keep the check but remove the friction (not decided):**
1. **One email, not two.** Make the purchase email carry the 6-digit code as well as the link (Supabase template `{{ .Token }}`,
   a Production auth-config change, Hard Gate), and have the return page show the code box immediately ("Enter the code we just
   emailed"), with no second send and no 429.
2. **Sign in with Google at checkout** (`TASK-0058` A, ID-token flow). Google already verified the email, so no code is needed.
3. **Wallet email as proof** (`TASK-0058` C). Google Pay returns a verified account email; Apple Pay's can be a relay address, so
   treat it as a convenience, not proof, unless the student confirms it.
Not recommended: signing the buyer in on payment alone.

## F10 (open, unverified launch risk): no confirmation email arrived on the second live purchase

**Observed (David, 2026-10-04):** no confirmation email after the $1 purchase `cs_live_a1g1…` (E5).
**Explained (David, chat):** the checkout used a placeholder address, not a real inbox, and David had forgotten. So the missing
email is almost certainly that, **not** a delivery failure.

**Verified (Production auth logs, 20:50 UTC):** Supabase accepted the invite (`POST /auth/v1/invite` returned 200, `user_invited`
logged at 20:50:11), so nothing failed in Cramapple's code. Twelve seconds later the page's code request returned 429 ("only after
48 seconds"), which P2 now handles with a countdown.

**Still open, not demonstrated:** until a custom SMTP provider is configured, Supabase's built-in email service delivers only to
addresses of the project's own team members, with a very low send limit. If Production has no custom SMTP, real students would
receive neither the invite nor the sign-in code (`TASK-0058` F lists custom SMTP as unverified). Whether Production has custom
SMTP enabled is **not verified**; Claude cannot read the Auth config, and no real-inbox purchase has been tested yet.

**Next steps (David):** (1) open Supabase Production → Authentication → Emails → SMTP Settings and note whether custom SMTP is
enabled and which sender domain it uses; (2) re-test a purchase with an inbox David controls, checking spam; (3) if custom SMTP
is off, set it up before the pilot goes to real students (sender on a verified `cramapple.com` domain, Hard Gate).

## Fix prompts to Lovable

| # | Covers | State |
|---|---|---|
| P1 | F1: Express Checkout loading and empty state (spinner, `onReady` → `availablePaymentMethods`, hide block when empty, 4 s fallback) | Published. Source read: matches. |
| P2 | F2 + F3: render errors in the idle state; 429 → "we just emailed you a link" with 60 s countdown; spinners for wallet confirm and return page; no auto-resend | Published. Source read: matches. |
| P3 | Promo control above wallets and visible before a session exists; typed-but-unapplied code blocks wallets, card and Place order | Published. Source read: matches. Wallet-bypass hazard (cutover checklist line 171) closed in code, not yet browser-tested. |
| P3b | Guard no longer depends on the promo panel being open; panel reopens; pending message suppressed for a `?promo=` code about to auto-apply | Published. Diff read: correct. Leftover: message can flash ~1 s after a valid email. |
| P4 | F6 remove-coupon fix; preload Stripe.js; no-upsell intro copy and selection summary; thin sticky bar; payment order wallet, card, parent with buttons disabled-with-reason until steps 1 and 2 | Built (diff read: matches). Publish not confirmed. |
| P4b | F7 picker disabled at 3; F8 wallet slot reserved from first paint | Built, Lovable head `a605ff12` at 20:44:50 UTC, diff read: matches. David reported the publish did not take; not confirmed since. |

## Test status

Done (Observed): wallet availability by browser (E1); promo apply/remove display (E3); live purchases E2 and E5 reached `paid` with access.
**Not yet tested after P4/P4b are live:**
1. Remove coupon, plain link and `?promo=<code>` link: payment options return and Remove stays removed.
2. Promo guard (Check 1): type a code, do not apply, try to collapse the panel; wallets, card and Place order stay blocked.
3. Check 3: type a code, fill email, wait over 4 s, clear the field; do wallets come back in Chrome?
4. Chrome and Safari: wallet placeholder from first paint, no layout shift, becomes the wallet row in place.
5. Firefox: no placeholder after load, no gap; watch for a brief flash before hydration (page is server-rendered).
6. Picker: pick three, others disable; deselect one, they re-enable.
7. Intro copy for `?subject=` and `?subjects=` URLs; sticky bar thin and clear of content at phone width.
8. Brand-new email purchase, click Start Studying immediately: a visible message with countdown (not silence), a working way in, and a working code after 60 s.

## Ideas parked (not decided)

- **QR / "continue on your phone" for desktop buyers** (same pattern as `capture_pairing_tokens`; needs a small backend piece), or "text me the link".
- **Venmo:** US-only, via PayPal, new async webhook paths; `TASK-0058` E pins methods to card and wallets. Not for the pilot.
- Placeholder caption such as "Available after you add your email" if the empty grey wallet box looks broken to a student.

## Done when

F1–F8 are re-tested on the live site, F10 is resolved (email delivers to a real inbox), F9's layers are built in the order above, the new-student path (pay, return page, get in)
works first time, and each Lovable publish and any Production change has David's approval recorded.
