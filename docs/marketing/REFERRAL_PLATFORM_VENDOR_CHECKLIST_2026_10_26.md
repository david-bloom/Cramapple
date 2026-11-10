# Referral platform: requirements and vendor demo guide

**Status:** Ready for vendor demos. Desk research on public vendor pages added 2026-10-29 (section 9). Nothing bought, nothing built, no vendor contacted. **Updated:** 2026-10-29.
**Owner:** David. **Decision so far:** buy, do not build; Stripe integration is the deciding factor; one vendor for both audiences.
**Related:** `AD_ATTRIBUTION_DECISIONS_AND_ACTIONS.md` (referral is the second channel category after paid ads).

## 1. The program in one page

| | Student referrer (peer to peer) | Tutor / teacher referrer |
| --- | --- | --- |
| Signs up | Self-serve on a website, **no manual step from Cramapple**; must be 14 or older (checkbox) | Same |
| Shares | A **QR code** or **share link**, phone to phone | Same |
| Referrer earns | **$5 gift card**, brand chosen at signup (Amazon, DoorDash and similar). **Once per converted trial** | **25% cash** of the **price actually charged**, on **every sale** to a student they referred (all subjects and add-ons) |
| Friend gets | **$5 off automatically** (a $5-off Stripe coupon, nothing to type) | Not decided (Q12) |
| Paid when | **7 days after the day-7 trial payment succeeds** (day 14 from trial start) | Same, per sale |
| Not paid | A trial start, a failed charge, a cancelled trial, or a refund/dispute **inside the 7-day delay**. A refund **after** the delay does not claw the reward back | Same |
| Tax | **The platform handles it** (forms, reporting) | Same; cash payouts |

Why the timing matters: students start a **card trial** (no charge), and the charge happens on **day 7**, off-session. The conversion that earns a reward is the day-7 payment, or a pay-now purchase. A vendor that rewards at signup, at "customer created" or at card setup would pay too early.

## 2. Requirements

**Must** unless marked Nice. Use the IDs in the scorecard (section 5).

| ID | Requirement |
| --- | --- |
| R1 | Phone-to-phone sharing: **QR code and share link**, both available from the referrer's own screen |
| R2 | **Two audiences, different rewards in one program:** flat $5 (students), 25% (tutors) |
| R3 | **Payout choices:** gift card of the referrer's choice (students), cash (tutors) |
| R4 | **Stripe integration:** a referral is credited from a real Stripe payment (details in section 3) |
| R5 | **Self-serve:** anyone registers as a referrer on a website and is approved and rewarded by automation. No manual approval, no support email, no payout batch from us |
| R6 | **Gift card brand chosen at signup**; stored on the profile, changeable later, and available as a variable in the share text and landing page |
| R7 | **Payout rule:** reward created only when the payment succeeds; paid **7 days later**; refund or dispute in that window cancels it; later refunds do not |
| R8 | **Age gate:** required checkbox on referrer signup with our exact wording; cannot submit unchecked; acceptance stored with a timestamp |
| R9 | **Disclosure:** the referrer's benefit is shown on the friend's landing page and in the share text, with our wording |
| R10 | **Friend discount:** a student link applies a **$5-off Stripe coupon** automatically; no stacking with other codes |
| R11 | **Tax handled by the platform:** collects W-9/W-8BEN before the first cash payout, tracks yearly totals, issues year-end forms or a ready report, states who is payer of record, and states the tax treatment of gift-card rewards |
| R12 | **Fraud controls:** self-referral blocked (same email, card, device, IP); pause an abusive referrer without manual work on every case |
| R13 | **Minors:** referrers may be under 18; students can be restricted to gift cards; clear data-handling terms (what the vendor stores about students; deletion on request) |
| R14 | **Integration (Nice):** REST API and webhooks (referrer created, referral converted, reward earned, payout sent); embeddable in our Lovable marketing site; vendor referral id storable on `app.trial_orders.ad_attribution` so referrals join ad data |
| R15 | **Cost** (Nice to compare): total price at 100, 1,000 and 10,000 referrers; all fees (platform, payout, funding) listed |

## 3. How it must connect to Cramapple's Stripe flow (ask every vendor)

- Our backend creates the Stripe sessions itself (`create-checkout-session`, `create-parent-payment-link`), in custom Elements mode (`ui_mode: "elements"`) and Stripe-hosted parent links. A vendor that tracks through a tag in Checkout needs our code to pass it (a small change). Ask exactly what is passed and where.
- The day-7 charge is an **off-session PaymentIntent** (`payment_intent.succeeded` on a `trial_conversion` intent). Ask the vendor to show a reward being created by that charge and by nothing before it.
- The checkout page already accepts `?promo=CODE`, so a vendor that issues a Stripe promotion code can link straight to it.
- Tutor commissions must be 25% of the **charged** price (after any coupon).
- Stripe **test mode** must work, so we can run a trial without real money.
- No duplicate rewards if Stripe retries a webhook.

## 4. Copy the platform must display

**Age checkbox (referrer signup), required.** Deliberately general because the rules vary by state:
> There are laws which restrict people 13 and under from joining referral programs like this. Do not sign up if you are not at least 14 years old.

**Share text (referrer's phone):**
> Use my Cramapple link: $5 off for you and $5 from [Gift Card] for me! [Link]

**Landing page (friend):**
> Your friend [Name/Code] invited you! Sign up with this link and you get $5 off. They get a $5 [Gift Card] gift card.

`[Gift Card]` is the brand chosen at signup. A tutor link has a different reward (25% cash), so it needs its own wording or no mutual-benefit line (Q12).

## 5. Demo script and scorecard

Ask each vendor to **show it live in a sandbox**, not describe it. Mark each row **Pass / Fail / Unknown** (unknown = ask in writing, ask for a date). Candidates still open: **GrowSurf, Referral Factory, Partnero**. Rewardful and FirstPromoter are out (no gift cards).

| # | Ask the vendor to show... | Req | GrowSurf | Referral Factory | Partnero |
| --- | --- | --- | --- | --- | --- |
| 1 | A new person signs up on a public page, is **approved automatically**, and sees their link and QR code at once, with no email from us | R1, R5 | | | |
| 2 | The signup form with **our age checkbox** (exact text), refusing to submit unchecked, acceptance stored with a timestamp | R8 | | | |
| 3 | The signup form letting the referrer **pick a gift card brand**; changing it later | R6 | | | |
| 4 | The **share text** and **landing page** with our wording, the referrer's name/code and gift card brand filled in | R9, R6 | | | |
| 5 | A link that **auto-applies a $5-off Stripe coupon** for the friend, working with a Stripe card trial | R10 | | | |
| 6 | A **Stripe test trial** through our flow: the **trial start earns nothing** | R4, R7 | | | |
| 7 | The **day-7 off-session charge** creating the reward | R4, R7 | | | |
| 8 | A **pay-now** purchase creating the reward | R4 | | | |
| 9 | A **failed charge** and a **cancelled trial**: nothing earned | R7 | | | |
| 10 | A **refund inside the 7-day delay** cancelling the reward; a **refund after** the delay leaving it paid | R7 | | | |
| 11 | A **fixed 7-day payout delay** configured, with payout running automatically afterwards | R7, R5 | | | |
| 12 | **$5 flat** (students) and **25% of charged price on every sale** (tutors) in the **same program** | R2 | | | |
| 13 | A **student paid by gift card** (choice of brands, with the list) and a **tutor paid cash** (ACH/PayPal/Venmo; list options) | R3 | | | |
| 14 | **Tax:** W-9/W-8BEN collected before first cash payout, yearly totals, year-end form or report, payer of record, gift-card treatment | R11 | | | |
| 15 | **Self-referral blocked**; a referrer paused in one click | R12 | | | |
| 16 | **Under-18** handling: students restricted to gift cards; what data is stored; deletion on request; referrer terms attached | R13 | | | |
| 17 | **API and webhooks** list; embed in a Lovable site; our referral id stored on our order | R14 | | | |
| 18 | **Total price** at 100 / 1,000 / 10,000 referrers; every fee, who funds payouts, minimum payout | R15 | | | |
| 19 | The program running **without any manual step** from our side, end to end | R5 | | | |

**Hard fails** (any one rules a vendor out, since one vendor serves both audiences): rows 1 (no auto-approval), 2 (no age checkbox), 6 or 7 (rewards too early or not from the day-7 charge), 10 (refunds not handled), 12 (cannot do flat and percentage together), 13 (no gift card or no cash), 14 (tax not handled).

Candidate notes (2026-10-27, from vendor pages, unverified; superseded by the evidence-labeled findings in section 9): GrowSurf matches Stripe charges by email and can issue Stripe coupons, gift cards unconfirmed; Referral Factory pays gift cards and cash through Tremendous but requires the referrer to already be a Stripe customer; Partnero collects tax forms and pays PayPal/Wise, gift cards unchecked.

## 6. Decisions log (David)

| # | Decision | Date |
| --- | --- | --- |
| D1 | Students: $5 per converted trial, gift card of their choice | 10-27 |
| D2 | Tutors: 25% cash | 10-27 |
| D3 | A refund after the 7-day delay does not claw back the reward; a refund or dispute inside it cancels | 10-27 |
| D4 | Gift cards for students, cash for tutors only | 10-27 |
| D5 | One vendor for both audiences | 10-27 |
| D6 | Tutor 25% is on the price actually charged | 10-27 |
| D7 | Tutor is paid on every sale to a student they referred | 10-27 |
| D8 | ~~Friend gets no automatic benefit~~ Superseded by D12 | 10-27 |
| D9 | The platform must handle tax | 10-27 |
| D10 | Rewardful and FirstPromoter are out (no gift cards) | 10-27 |
| D11 | Student $5 is paid once per converted trial | 10-27 |
| D12 | Anyone using a student share link gets $5 off automatically (Stripe coupon) | 10-27 |
| D13 | Age checkbox on referrer signup, state-neutral wording (section 4) | 10-27 |
| D14 | Referrer's benefit disclosed on landing page and in share text, accurate wording (section 4) | 10-27 |
| D15 | Referrer picks the gift card brand at signup | 10-27 |
| D16 | Payout 7 days after the day-7 payment succeeds; nothing for a trial start | 10-26/27 |
| D17 | Buy, do not build; Stripe integration is the deciding factor | 10-26 |

## 7. Open questions

| # | Question | Owner |
| --- | --- | --- |
| Q11 | **Legal:** is the general "laws restrict people 13 and under" wording enough for a 14-and-older gate, and who verifies it? Student referrers may be minors. Sharing student data with a referral vendor. Who is payer of record for tax (Cramapple or the vendor)? | David (finding out) |
| Q12 | Do tutor links also give the friend $5 off, or no discount? (A coupon lowers the price charged, so it lowers the 25% slightly.) | David |
| Q13 | Does the landing page show the referrer's name, or is the code enough? (Privacy when the referrer is a minor.) | David |

## 8. Next steps

1. David runs the vendor demos with section 5 as the script and records pass/fail/unknown per vendor.
2. Claude can turn the unknown rows into written questions for each vendor and, once a trial account exists, run rows 6-11 in Stripe test mode on Dev with a real test trial and a day-7 charge.
3. The choice is recorded in `docs/marketing`; the checkout change (pass the referral tag, store the vendor id in `ad_attribution`) is planned separately.

## 9. Desk research on public vendor pages (2026-10-29)

**Method and limits.** Public documentation and pricing pages only, read 2026-10-29 by Claude. No account created, no vendor contacted, no sandbox run. Labels: **[Doc]** stated on a vendor page (URL given); **[Not found]** not on the pages read, which is **not** evidence the feature is missing; **[Inference]** my reading. Nothing here replaces the live demo (section 5), and vendor docs drift, so re-check before relying on a row. Prices and plan limits are as shown on the pages that day.

### 9.1 Row-by-row status (prior to any demo)

Legend: Doc-yes = vendor page says it can; ? = not found, must be shown or answered in writing; Risk = page evidence points to a possible hard fail.

| # | Ask | GrowSurf | Referral Factory | Partnero |
| --- | --- | --- | --- | --- |
| 1 | Auto-approved signup, link and QR at once | ? approval wording covers affiliates ("you approve them"); referral participants "can be added automatically"; QR not found | ? auto-issue is about payouts, not signups; QR not found | ? "approval workflows" on Partner plan; auto-approval and QR not found |
| 2 | Age checkbox with timestamp | ? not found | ? not found | ? not found |
| 3 | Gift card brand chosen by referrer | Doc-yes: Tremendous, recipient picks from "hundreds of brands", you do not pick for them | Doc-yes: Tremendous catalog, recipient picks (examples Amazon, Uber, Starbucks) | Risk: only Amazon gift cards named on pricing page |
| 4 | Share text / landing page wording | ? not checked | ? not checked | ? not checked |
| 5 | Auto-applied $5 Stripe coupon for friend | Doc-yes: double-sided rewards can coupon the friend; "Upfront Discounts" append a promo code to Payment Links (needs Stripe "Allow promotion codes"). Not shown for custom Elements checkout | ? referrer-specific promo codes only; link pre-apply not stated | ? coupons for friends mentioned in a feature article; link behaviour not stated |
| 6 | Trial start earns nothing | ? "new Stripe charges" and checkout.session.completed; trial-start behaviour not stated | ? payment/invoice/subscription milestones; trials not stated | ? "Rewards fire when the referral pays, not when they sign up"; trials not stated |
| 7 | Day-7 off-session charge earns the reward | ? not stated for off-session charges | ? "successful renewal" named as a milestone | ? recurring payments captured; off-session not stated |
| 8 | Pay-now purchase earns reward | Doc-yes (checkout success) | Doc-yes (successful payment) | Doc-yes (one-time payments) |
| 9 | Failed charge / cancelled trial earns nothing | ? | ? | ? |
| 10 | Refund inside window cancels; after window stays paid | Doc-yes: optional hold period; refund or chargeback inside it "cancels completely"; already-paid commissions are not taken back. Default length not found | Risk: no hold or refund handling found; rewards sit in "Due Rewards" until you issue them manually; auto-issue "not recommended" | Doc: "adjusts for refunds automatically", chargebacks supported; hold period not found |
| 11 | Fixed 7-day delay, then automatic payout | ? hold period exists; 7 days and automatic payout after it unconfirmed | Risk: manual issuing is the recommended path | ? not found |
| 12 | $5 flat and 25% of charged price in one program | ? flat or % both exist, but referral vs affiliate are separate program types; mixing not found. Double-sided amounts can differ | ? flat and % are separate rewards; "multiple rewards" per campaign; combination not stated | ? percentage, fixed, tiered all listed; separate audiences/groups not found |
| 13 | Gift cards (students) and cash (tutors) | Doc-yes: gift cards via Tremendous; cash via PayPal/Wise/Venmo for affiliates; ACH not found | Doc-yes: Tremendous gift cards, PayPal, ACH, Venmo, prepaid Visa; you prefund Tremendous | Partial: Amazon gift cards; cash via PayPal or Wise; ACH not found |
| 14 | Tax forms and year-end reporting | Doc-yes (strongest): "Tax Forms & 1099 Filing" listed in plans; gift card amounts count to the winner's yearly total and the reward is held until a W-9/W-8 is on file; filings charged separately. Payer of record not found | Risk: nothing on tax found | Partial: W-9, W-8BEN, W-8BEN-E upload by partner, enabled by owner; 1099 filing and payer of record not found |
| 15 | Self-referral blocked; pause in one click | ? Fraud Protection listed; self-referral and pause not found | ? same-IP and suspect-email tracking listed; self-referral and pause not found | Doc-yes (self-referral): flagged fraud when emails match, toggle to allow; pause not found |
| 16 | Under-18 handling and data terms | ? GDPR/CCPA listed; minors not found | ? not found | ? "GDPR compliant"; minors not found |
| 17 | API, webhooks, our id on our order | Doc-yes: REST API, webhooks, MCP | Doc-yes: webhooks and API (Basic plan) | Doc: API and webhooks listed; plan checkmarks not read |
| 18 | Price | see 9.2 | see 9.2 | see 9.2 |
| 19 | No manual step | ? | Risk: manual reward issuing recommended | ? |

### 9.2 Price (R15), as listed 2026-10-29 [Doc]

- **GrowSurf** (growsurf.com/pricing/referral-programs): priced per participant (unique email). Startup covers "up to 5,000" (price not captured in the fetch); Business $449/mo to 10,000 participants, $649 to 25,000. Stripe integration is documented as paid-plan only; Tax Forms & 1099 Filing is listed in Startup. Affiliate programs: free base plan plus a **3% success fee** on referral revenue, with Stripe, tax forms and 1099 filing listed. GrowSurf charges no payout processing fee; Tremendous gift cards cost face value; PayPal/Wise fees are theirs. **Cost grows with participants, not with sales.**
- **Referral Factory** (referral-factory.com/pricing): Basic $200/mo for 20,000 users, Pro $400/mo for 40,000, Enterprise from $1,000/mo; a "user" is anyone who joins a campaign (referrers **and** invitees). Tremendous is free to use; rewards prefunded.
- **Partnero** (partnero.com/pricing): Starter $49/mo billed annually ($59 monthly), Partner $159 annual ($199 monthly), Enterprise from $599/mo; unlimited partners on every plan; 30-day free trial; Stripe included from Starter. PayPal/Wise payouts: no Partnero fee on your own account; **7% processing fee** if Partnero manages payouts. Gift card fees not found.
- [Inference] At 100 and 1,000 referrers the monthly platform cost is roughly Partnero ($49-59) < GrowSurf Startup (not captured) ≈ Referral Factory ($200). At 10,000 referrers GrowSurf Business is $449/mo. Reward cost itself ($5 per convert, 25% to tutors) will dwarf platform fees, so price should not drive the choice.

### 9.3 What the research changes

1. **Nothing is eliminated yet, but two candidates carry hard-fail risk.** Referral Factory shows no tax handling and no refund/hold logic (rows 10, 14). Partnero looks limited to Amazon gift cards, which conflicts with D15 (brand chosen by the referrer). GrowSurf is the only one with page evidence for rows 3, 10 and 14 together. [Inference]
2. **Row 12 (flat $5 and 25% in one program) is the likeliest hard fail for every vendor.** Vendors split referral and affiliate programs. Ask in writing before spending demo time. If no vendor does both in one program, D5 (one vendor) forces a decision: two programs on one vendor (e.g. GrowSurf referral + affiliate), or revisit D5.
3. **Tax friction for minors.** GrowSurf holds a gift-card reward until a W-9/W-8 is on file when tax forms are on. For a $5 reward to a 14-year-old that may block payouts. Ask whether the hold can be limited to cash payouts or to a yearly threshold (Q14).
4. **Timing evidence is weak everywhere.** No vendor page addresses a card trial followed by an off-session day-7 charge. GrowSurf's Stripe flow is documented around `checkout.session.completed` and "new Stripe charges", matched by customer **email**. Our trials create the customer at card setup and charge later, so rows 6 and 7 can only be settled in a Stripe test-mode trial. [Inference]
5. **Friend coupon (R10).** GrowSurf's documented auto-coupon is via Payment Links. Our student checkout uses custom Elements, so the likely route is our existing `?promo=CODE` plus a Stripe promotion code the vendor issues or we create. Ask each vendor how a referral link reaches `?promo=`.

### 9.4 Written questions to send (draft only, not sent)

Same questions to all three, starting with the ones that decide hard fails:
1. Can one program pay a flat $5 reward to one participant group and 25% of the charged price on every sale to another group? If not, what is your supported setup for two audiences?
2. Our customers start a card trial (no charge); the first payment is an off-session charge on day 7. Which Stripe event triggers the reward, and does card setup or trial start ever trigger it?
3. Can the payout be delayed exactly 7 days after the payment, then paid automatically, with refunds/chargebacks in the window cancelling it and later refunds leaving it paid?
4. Does the signup form support a required custom checkbox with stored acceptance and timestamp? Is signup approved automatically? Do referrers get a QR code?
5. Who is payer of record for tax; do you file 1099-NEC; are gift cards reported; can the W-9 hold apply to cash payouts only?
6. Can referrers be under 18 (14+)? What data about them do you store, and how is deletion handled?
7. Can referrers choose the gift card brand, and which brands (Partnero: beyond Amazon)?
8. How is a self-referral blocked, and how do we pause a referrer?
9. Price at 100, 1,000 and 10,000 referrers including payout and tax-filing fees.

### 9.5 Needs David

| # | Decision | Why it is yours |
| --- | --- | --- |
| Q11 | Legal call on the age wording, minors as referrers, vendor data sharing, tax payer of record | Open; needs the lawyer |
| Q12 | Tutor-link friend discount | Product |
| Q13 | Show referrer name on landing page | Privacy, minors |
| Q14 | If no vendor does flat + percentage in one program: two programs on one vendor, or two vendors, or change D5/the program design | Reopens D5 |
| Q15 | If a vendor holds gift-card rewards until a W-9 exists: accept for $5 gift cards, or restrict tax forms to tutors only | Affects minors and conversion |
| Q16 | Permission to open free trial/sandbox accounts (Partnero offers 30 days; GrowSurf trial exists) and to send the section 9.4 questions | Contacting vendors and creating accounts need owner approval; none done |
