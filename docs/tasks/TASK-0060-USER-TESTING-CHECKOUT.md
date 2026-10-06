# TASK-0060 — User Testing, Starting With Checkout

**Status:** Substantially complete as of 2026-10-04 (session close); the remaining checks are listed under "Still to test" and need a signed-in session or a real inbox, so David runs them. Handoff: `docs/handoffs/SESSION_CLOSE_2026_10_04_CHECKOUT_USER_TESTING.md`. **Tier:** Hard-Gate for anything that touches payments, Production function deploys, Lovable publish, or secrets.
**Owner:** Claude. **Product Owner:** David Bloom.
**Area:** Checkout UX, return page, wallets, sign-in after purchase.
**Related:** `TASK-0058` (post-pilot checkout list; items A0, A, B, C, E overlap), `TASK-0041`, `DECISION-0090`, `DECISION-0094`,
`docs/product/STRIPE_PRODUCTION_CUTOVER_CHECKLIST_2026_09_30.md`, `docs/product/PURCHASE_FUNNEL_TECHNICAL_SPEC_2026_09_27.md` §12.

## Purpose

**2026-10-06 follow-on, David-authorized:** consolidate transactional templates and
delivery in Loops. Plan and execution evidence:
`docs/product/LOOPS_TRANSACTIONAL_EMAIL_MIGRATION_2026_10_06.md`.
Branch: `codex/loops-transactional-email`; draft PR #341. Backend built; new handlers and queue
deployed in Development only. Designs/published IDs, inbox QA and live cutover
remain pending. This does not close the checkout checks below.

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

### E7. Third live purchase and the redesigned post-purchase flow (2026-10-04, ~21:55 UTC)
- **Verified (Production logs and DB):** Physics 1, $1 promo, paid, entitlement active. The invite link was opened on an **iPhone** at 21:56:25 and worked (the account confirmed and signed in, then redirected to `/welcome`, which did not exist, so even that success landed on a 404). The **same link** opened on a **Mac** 79 s later returned "One-time token not found" and `#error=otp_expired`, which is the error David saw. David confirmed he did not use the code first, so the cause is a single-use link opened on two devices, not a code and not a mail scanner. A real inbox received the invite within seconds, which closes most of F10.
- **F11:** the emailed link is single-use and device-bound (PKCE links also need the same browser); `/welcome` did not exist. **F12:** the post-purchase add-on card ("Add another AP subject / Complete your 2-subject bundle for $30.00") read as a bundle purchase to a one-subject buyer. **F13:** the **Confirm sign up** template (sent to an *unconfirmed* student who asks for a code) was still link-only; its `?code=` link is a PKCE code that the marketing home page never exchanges.
- **Product Owner decisions (David, chat):** remove the post-purchase upsell; the return page says "Welcome to Cramapple. Check your email for the 6-digit code to get started." with an inline code box; a signed-in returning student goes straight to the hub; a new student lands on the hub with a dismissible welcome banner; every student email carries the 6-digit code; the link in those emails is a plain link to `/welcome`, never Supabase's one-time link.
- **Built:** P5 (return page, `CodeSignIn`, `/welcome` with three states: session in hash, error in hash, plain), P6 (hub welcome banner in the App project), P8 (login page copy and 429 handling). **Supabase templates (David, Production auth config):** Invite user and Magic Link or OTP carry `{{ .Token }}`; **Confirm sign up** was told to carry it too (its state is not verified by Claude, see "Still to test").

### E8. Student hub 400: "We couldn't load your home right now" (2026-10-04, ~22:27 UTC)
- **Observed:** after signing in, picking a subject failed. **Verified:** the Production API returned HTTP 400 for `student_course_positions?select=unit_id,source,topic_code,topic_source`. The public view listed six columns; migration `20260927211703` added `topic_code` and `topic_source` to `app.student_course_positions` but not to the view.
- **Fixed under `APPROVAL-0120`** (David approved it in chat as "0118"; renumbered because another PR claimed 0118 first): the view was recreated with the two columns, same options and grants, rehearsed in a rolled-back transaction, applied and verified (the same request went from 400 "column does not exist" to 401 "permission denied" for an anonymous caller). A read-only scan of 17 public mirror views found no other view producing API errors; `topic_explainers` and `topic_point_briefs` omit `topic_code`, `status` and `source_note` and need a deliberate look before student topic pages launch.

### E9. Parent pay: wrong price and a link too long for SMS (2026-10-04)
- **Observed:** the "Ask a parent to pay" modal showed $39.99 with a $38.99 coupon applied (the real parent page was correctly $1.00), and the link was Stripe's ~450-character hosted URL.
- **Fixed under `APPROVAL-0119`:** table `app.parent_payment_links` (8-character code, service role only), new public function `resolve-parent-link`, and `create-parent-payment-link` / `send-parent-payment-email` now return and use `cramapple.com/p/<code>`. Tested in Dev (12 cases, including that a code can never reach a student session), then live in Production with no payment. Frontend (P7): modal price line from Stripe's real total, charged amount after creation, short link in copy/share/SMS, and the `/p/<code>` page.

### E10. Final end-to-end QA (Claude, live site, ~23:35 UTC, no payment details entered)
| Check | Result |
|---|---|
| Student checkout with `?promo=FRIENDSSPECIAL` and an email | Total $1.00, discount line −$38.99, sticky total $1.00 |
| "Ask a parent to pay" modal before creating | "Your parent pays $1.00 on a secure page." |
| Create payment link | "Your parent will pay $1.00." (the server's charged amount) |
| What Copy Payment Link puts on the clipboard | `https://cramapple.com/p/<8 chars>` (32 characters) |
| Open the short link | Redirects to `checkout.cramapple.com/c/pay/cs_live_…` with the `#` fragment; page shows Pay Cramapple $1.00, AP Biology $39.99, FRIENDSSPECIAL −$38.99, Total due $1.00 |
| Unknown short code `/p/abcdefgh` | "This payment link has expired" |
| `/welcome` plain and with the old `#error=…otp_expired` hash | Code-entry page; "Let's get you in" page with no raw error and the hash cleared |
| Earlier checks (E6) | Intro copy, payment order, picker limit, promo guard, phone-width sticky bar all pass |
Test data left behind: unpaid live sessions (expire on their own) and no Supabase rows (test rows deleted).

**Could not be verified by Claude** (needs a signed-in session, a real inbox or a wallet): the hub banner and the post-login hub load after the view fix; the login page's code step and cooldown; the return page's code box after a real purchase; Confirm sign up template content; Check 3; the wallet row appearing in place in Chrome and Safari without a shift; a real parent email through Loops.

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

## F10 (largely closed 2026-10-04): no confirmation email arrived on the second live purchase

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

**Update (E7):** the third live purchase used a real inbox and the invite email arrived within seconds, so custom SMTP delivers. What remains is confirming that the code emails (Invite, Magic Link, Confirm sign up) land in the inbox and not in spam, covered by "Still to test" items 1, 3 and 4.

## Fix prompts to Lovable

| # | Project | Covers | State |
|---|---|---|---|
| P1 | Marketing `61dd6602` | F1 Express Checkout loading and empty state | Published, verified |
| P2 | Marketing | F2/F3 silent Start Studying button (429), spinners | Published, verified (superseded in part by P5) |
| P3, P3b | Marketing | Promo above wallets; typed-but-unapplied code blocks payment | Published, browser-tested (E6) |
| P4, P4b | Marketing | Remove-coupon fix, no-upsell copy, thin sticky bar, wallet, card, parent order, wallet slot from first paint, picker limit | Published, browser-tested (E6) |
| P5 | Marketing | Remove upsell; return-page welcome and code box; `/welcome` (commit `28a5cc1b`) | Published; `/welcome` verified live (E10); return page awaits a real purchase |
| P6 | App `56cae479` | Dismissible hub welcome banner on `?welcome=1` (commit `7193c3b2`) | Built, diff read; **publish and behavior unverified** (needs sign-in) |
| P7 | Marketing | Parent modal price, short link, `/p/<code>` (commit `0e177df2`) | Published, verified live end to end (E10) |
| P8 | Marketing | Login page: remove "sign-in link" copy, 429 handling, resend cooldown (commit `1ee055f3`) | Built, diff read; **publish unverified** |

Known leftover: the return page's rate-limit notice (`AUTH_EMAIL_RATE_LIMIT_NOTICE` in `StartStudying.tsx`) still says "a link"; the login page has its own "a code" wording.

## Still to test (David; none blocks the others)

1. **Real-inbox purchase, end to end** (the $1 `?promo=` link, an inbox David controls, a *new* email): the invite email shows the 6-digit code in the subject and body; the return page says "Check your email for the 6-digit code" and accepts it; you land on the hub with the welcome banner; dismiss it and reload (it must not return).
2. **Hub load after the view fix:** sign in, pick a subject, confirm the home loads (the request that returned 400 now resolves its columns). Also confirm the hub banner and that the hub no longer bounces to a bare `/home`.
3. **Login code path (confirmed account):** `cramapple.com/login`, request a code; the email shows only the code; enter it. Press "Resend" within 60 s: a countdown, not an error.
4. **Confirm sign up template (unconfirmed account):** on the return page of a new purchase wait 60 s and press "Email me a new code"; the email must show a code, not "Confirm your email address" with a link.
5. **Second purchase while signed in:** the return page goes straight to the hub, no banner, no code.
6. **Real parent email:** "Send Parent Email" delivers the short link (Loops `checkoutUrl` now carries it) and a real parent payment completes and unlocks the student.
7. **Check 3 and the wallet row in place** (Chrome with Google Pay, Safari with Apple Pay): wallets return after a typed code is cleared; the buttons do not move when the wallet row appears. Firefox: no flash of the wallet placeholder before the page hydrates.
8. **"Ask a parent to pay" waiting panel:** its old "Start Studying Now" button still sends a second email (the 429 problem); approval to switch it to the code box is still pending from David.

## Ideas parked (not decided)

- **QR / "continue on your phone" for desktop buyers** (same pattern as `capture_pairing_tokens`; needs a small backend piece), or "text me the link".
- **Venmo:** US-only, via PayPal, new async webhook paths; `TASK-0058` E pins methods to card and wallets. Not for the pilot.
- **Student hub redesign (`TASK-0048`, "Planned — not started", `O17`):** `app.cramapple.com/home` still has the old design; David noticed this during testing. Decision pending: start it now or after the pilot.
- **F9 layers 1 and 2** (Google sign-in at checkout; wallet email as proof) are decided but not built; layer 3 (one email with the code) is built through the three templates.
- **Dormant:** `create-post-purchase-addon` and `/checkout/add-on` remain deployed but nothing links to them; decide whether to remove.
- **Safety net (optional):** send a visitor with `?code=` on the home page to `/welcome` for old Confirm-sign-up emails already in inboxes.
- Placeholder caption such as "Available after you add your email" if the empty grey wallet box looks broken to a student.

## Done when

Every item under "Still to test" passes on the live site, the Confirm sign up template carries the code, the hub banner is published and seen, and the hub redesign (`TASK-0048`) is scheduled or deferred by David. Production changes made under this task: `APPROVAL-0119` (parent short links) and `APPROVAL-0120` (student course positions view).
