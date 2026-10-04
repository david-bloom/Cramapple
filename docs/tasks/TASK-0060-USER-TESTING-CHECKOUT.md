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

### E6. Browser tests after P4/P4b were published (2026-10-04)

**Claude, built-in Chromium pane on the live site (Verified; no payment details entered):**
- Intro copy: `?subject=biology` shows "Pick your subject"; `?subjects=biology,statistics` shows "Pick your two subjects". No tier price list and no "N of 3 picked" line; the selection line reads "1 subject · $39.99" / "2 subjects · $69.99".
- Payment area before an email: Express Checkout slot as a static grey placeholder with no spinner, then "Pay with card" and "Ask a parent to pay", both disabled with "Add your email".
- Picker limit: at three picks the other seven tiles disable and the selected three stay clickable; a fourth click is ignored; deselecting re-enables all.
- Promo guard: typing an unapplied code hides the whole payment area (`display: none`, so the `hidden` attribute does win over the grid class), disables Place order, shows "Apply your promo code, or clear the field, to continue.", and clicking the panel toggle does not collapse it.
- Sticky bar at 375 px: one 64 px row (total, Place order, "Ask a parent to pay"), no horizontal scroll, last page content clear of the bar.
- With a made-up email (no payment): the buttons enabled, the slot showed a spinner while the session was created and held the buttons still while Stripe loaded; Stripe reported no wallets in this pane about 3.3 s after the session started (inside the 4 s timeout) and the slot collapsed, moving the buttons up 100 px (the shift accepted for "hint says wallet, Stripe says none"). "Pay with card" opened the card form (Stripe card frame, 289 px). Place order stayed disabled ("1 step left").
- Side effects: one unpaid Stripe session for the made-up address, which expires on its own; no Supabase row, account or payment (rows are written by the webhook).

**David, real browsers (Observed):** intro copy, payment order, picker limit and promo guard are all correct. A $38.99 discount coupon on a multi-subject order
calculates correctly in the order summary and recalculates as subjects are added or removed; applying and removing coupons works (F6 confirmed fixed).
Google Pay renders in a normal, signed-in Chrome window and does not render in an anonymous Chrome window (expected: no signed-in Google account).
Apple Pay renders in Safari, including an anonymous Safari window. Nothing renders in Firefox (expected).

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

**Delivery comes first (see F10).** None of the layers helps if Supabase cannot deliver email to real recipients (custom SMTP is on; real-inbox delivery still to test, see F10).

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

## F10 (open until a real-inbox test): no confirmation email arrived on the second live purchase

**Observed (David, 2026-10-04):** no confirmation email after the $1 purchase `cs_live_a1g1…` (E5).
**Explained (David, chat):** the checkout used a placeholder address, not a real inbox, and David had forgotten. So the missing
email is almost certainly that, **not** a delivery failure.

**Verified (Production auth logs, 20:50 UTC):** Supabase accepted the invite (`POST /auth/v1/invite` returned 200, `user_invited`
logged at 20:50:11), so nothing failed in Cramapple's code. Twelve seconds later the page's code request returned 429 ("only after
48 seconds"), which P2 now handles with a countdown.

**Observed (David, 2026-10-04): custom SMTP is enabled in Production.** So the built-in-service limit (team members only) does not
apply. Not yet known: the sender domain, and whether mail actually reaches a real student inbox (and not spam). No real-inbox
purchase has been tested.

**Next steps (David):** (1) note the sender address and domain in Authentication → Emails → SMTP Settings (a verified
`cramapple.com` sender is the goal); (2) buy with an inbox David controls (the $1 `?promo=` link), check inbox and spam, and
confirm both the invite email and a 6-digit code email arrive; (3) F10 closes when both arrive in the inbox.

## Fix prompts to Lovable

| # | Covers | State |
|---|---|---|
| P1 | F1: Express Checkout loading and empty state (spinner, `onReady` → `availablePaymentMethods`, hide block when empty, 4 s fallback) | Published. Source read: matches. |
| P2 | F2 + F3: render errors in the idle state; 429 → "we just emailed you a link" with 60 s countdown; spinners for wallet confirm and return page; no auto-resend | Published. Source read: matches. |
| P3 | Promo control above wallets and visible before a session exists; typed-but-unapplied code blocks wallets, card and Place order | Published. Source read: matches. Wallet-bypass hazard (cutover checklist line 171) closed and browser-tested (E6). |
| P3b | Guard no longer depends on the promo panel being open; panel reopens; pending message suppressed for a `?promo=` code about to auto-apply | Published. Diff read: correct. Leftover: message can flash ~1 s after a valid email. |
| P4 | F6 remove-coupon fix; preload Stripe.js; no-upsell intro copy and selection summary; thin sticky bar; payment order wallet, card, parent with buttons disabled-with-reason until steps 1 and 2 | Published (David). Diff read: matches. Browser-tested, see E6. |
| P4b | F7 picker disabled at 3; F8 wallet slot reserved from first paint | Published (David), Lovable head `a605ff12`. Diff read: matches. Browser-tested, see E6. |

## Test status

**Done and passing (E1, E3, E6):** wallet availability by browser; coupon apply/remove and multi-subject recalculation; intro copy; payment order and
disabled-with-reason buttons; picker limit; promo guard; phone-width sticky bar; card form opens; live purchases E2 and E5 reached `paid` with access.
F1, F3 (checkout side), F6, F7 are confirmed fixed.

**Still to test (none blocks the others):**
1. **Check 3:** type a code, fill the email, wait over 4 s, clear the field; do the wallets come back in Chrome? (Needs a Chrome window with Google Pay.)
2. **Wallet row appears in place** with no layout shift in normal Chrome (Google Pay) and Safari (Apple Pay). David confirmed the payment order but not the absence of a shift.
3. **Firefox:** no brief flash of the wallet placeholder before the page hydrates (the page is server-rendered).
4. **Brand-new real-inbox purchase** (the $1 `?promo=` link, an inbox David controls): the invite email and a 6-digit code email both arrive and are not in spam; clicking Start Studying immediately shows the 429 notice with a countdown, then works after the wait. Closes F10 and the F2 check.
5. **"Ask a parent to pay"** from step 3 and from the sticky bar: the drawer opens, and the payment link and its waiting state behave as before.
6. Phone width on a real device (the emulated 375 px check passed).

## Ideas parked (not decided)

- **QR / "continue on your phone" for desktop buyers** (same pattern as `capture_pairing_tokens`; needs a small backend piece), or "text me the link".
- **Venmo:** US-only, via PayPal, new async webhook paths; `TASK-0058` E pins methods to card and wallets. Not for the pilot.
- Placeholder caption such as "Available after you add your email" if the empty grey wallet box looks broken to a student.

## Done when

F1–F8 are re-tested on the live site (F1, F3, F6, F7 done; the rest are in the list above), F10 is resolved (email delivers to a real inbox), F9's layers are built in the order above, the new-student path (pay, return page, get in)
works first time, and each Lovable publish and any Production change has David's approval recorded.
