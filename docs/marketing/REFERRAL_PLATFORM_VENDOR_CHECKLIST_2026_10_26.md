# Referral platform: requirements and vendor demo guide

**Status:** Ready for vendor demos. Nothing bought, nothing built, no vendor contacted. **Updated:** 2026-10-27.
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

Candidate notes (from vendor pages, unverified): GrowSurf matches Stripe charges by email and can issue Stripe coupons, gift cards unconfirmed; Referral Factory pays gift cards and cash through Tremendous but requires the referrer to already be a Stripe customer; Partnero collects tax forms and pays PayPal/Wise, gift cards unchecked.

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
