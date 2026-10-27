# Referral platform: requirements and vendor test checklist

**Status:** Draft for David's review. Nothing bought, nothing built. **Date:** 2026-10-26.
**Decision so far (David, 2026-10-26):** buy, do not build. Stripe integration is the deciding factor.
**Related:** `AD_ATTRIBUTION_DECISIONS_AND_ACTIONS.md` (referral is the second channel category after paid ads).

## Requirements (from David)

| # | Requirement | Must / Nice |
| --- | --- | --- |
| R1 | Phone-to-phone sharing: a QR code and a share link, both from the referrer's own screen | Must |
| R2 | Two audiences with different payouts: students (peer to peer) and tutors/teachers | Must |
| R3 | Payout options: gift cards or cash | Must |
| R4 | Stripe integration: a referral is credited from a real Stripe payment | Must |
| R8 | Payout rule (David, 2026-10-26): a reward is paid **only after the 7-day trial ends and the payment succeeds, and then only 7 days later** (day 14 from trial start, assuming the day-7 charge succeeds). A trial start, a failed charge or a cancelled trial pays nothing; a refund or dispute inside the 7 days cancels the reward | Must |
| R9 | Referrer signup has a required **age attestation checkbox** (14 or older); signup cannot complete without it | Must |
| R10 | **Disclosure** of the referrer's benefit on the landing page and in the share text | Must |
| R11 | **Students' share link gives the friend $5 off automatically** (Stripe $5-off coupon / promotion code applied with no code typed) | Must |
| R5 | **Self-serve**: anyone can register as a referrer on a website and be rewarded by automation, with no manual step or interaction from David | Must |
| R6 | Easy to connect to Supabase, Lovable, and agent tooling (API, webhooks, no-code embed) | Nice |
| R7 | Referral conversions appear beside ad data (referrer id stored on the order) | Nice |

## How Cramapple's money flow constrains the choice

- Students start a **card trial** (Stripe setup session, no charge). The charge happens on **day 7**, off-session.
- The **conversion that earns a reward** is therefore the day-7 `payment_intent.succeeded`, or a pay-now purchase. A trial start alone must not pay out.
- Our backend creates the Stripe sessions itself (`create-checkout-session`, `create-parent-payment-link`). A vendor that tracks through a tag in Checkout needs that tag passed in by our code (small change).
- The checkout page already accepts `?promo=CODE`. A vendor that issues Stripe promotion codes can link straight to it.

## Candidates (Rewardful and FirstPromoter dropped, D10) (from vendor pages; every claim below is unverified until tested)

| Vendor | Audience fit | Stripe | Payouts seen | Price seen |
| --- | --- | --- | --- | --- |
| GrowSurf | Customer referral, double-sided | Matches charges by email; Stripe coupons/credits | Automated payouts; gift cards unconfirmed | $179-$449/mo (sources conflict) |
| Referral Factory | Customer referral widget | Referrer must already be a Stripe customer | Gift cards, cash via Tremendous | $95-$400/mo |
| Rewardful | Affiliate (tutors) | Stripe-first, Checkout tag | PayPal, Wise | From $49/mo |
| FirstPromoter | Affiliate (tutors) | Stripe and others | Mainly PayPal | From $49/mo |
| Partnero | Affiliate | Stripe | PayPal, Wise; collects W-9/W-8BEN | Not checked |

Decision D5: one vendor for both audiences, so it must pass every row below.

## Checklist (run for each vendor, in its sandbox or free trial)

Mark each: pass, fail, or unknown (ask the vendor in writing).

### A. Self-serve registration (R5)
- [ ] A public signup page or embeddable form exists, on our domain or an embed, with no invitation.
- [ ] Approval can be **automatic** (no manual approve click).
- [ ] The new referrer gets their link and QR code immediately, with no email from us.
- [ ] The referrer dashboard (earnings, status, payout details) needs no support from us.
- [ ] Signup can be limited to a role (student or tutor) or tagged by role so rates differ.
- [ ] Sign-in works for students without a password burden (email link or code is acceptable).

### B. Sharing (R1)
- [ ] QR code from the referrer's screen (or we can generate one from their link).
- [ ] Shareable link works in Messages/WhatsApp/Instagram on a phone.
- [ ] The link lands on `cramapple.com` with the code preserved (`?promo=` or the vendor's cookie/click id).
- [ ] Works when the visitor opens it on a different device from the referrer.

### C. Stripe attribution (R4), the deciding test
- [ ] Describe in writing how a referral is matched to a Stripe payment (tag, email, coupon, metadata).
- [ ] With our **card-trial** flow: a trial start earns nothing; the **day-7 off-session charge** earns the reward.
- [ ] A **pay-now** purchase earns the reward.
- [ ] Works with our server-created Checkout sessions in custom Elements mode (`ui_mode: "elements"`) and with Stripe-hosted parent links.
- [ ] Reward is **created only when the payment succeeds**: no reward on trial start, on a failed or declined day-7 charge, or when the trial is cancelled before day 7 (R8).
- [ ] Refund or dispute reverses or blocks the reward within the 7-day delay (R8).
- [ ] A **fixed 7-day delay** between the successful payment and the payout can be configured (a "lock" or "hold" period), and a reward cancelled by a refund in that window is never paid.
- [ ] Stripe Dev/test mode supported, so we can test without real money.
- [ ] No duplicate rewards if Stripe retries a webhook.

### D. Rewards and payouts (R2, R3)
- [ ] Different reward rates per audience (student, tutor), as a flat amount or percentage.
- [ ] **Flat $5 for students and 25% of the sale for tutors** in the same program (D1, D2).
- [ ] Students **choose** their gift card from a catalogue (Amazon, DoorDash and similar); list the brands and the countries.
- [ ] Tutors are paid **cash** (ACH, PayPal, Venmo or bank transfer); list the options.
- [ ] Reward for the referred friend too (for example a discount), if we choose that.
- [ ] Payout by **gift card**, by **cash** (PayPal, ACH, Venmo, prepaid card), or both; list the options.
- [ ] Payouts are **automatic** 7 days after the payment has succeeded (R8), with no manual batch from us.
- [ ] Who funds payouts and how (prepaid balance, card, invoice); list all fees (platform, payout, funding).
- [ ] Minimum payout, and what happens to small balances.

### E. Compliance, minors, fraud
- [ ] **Tax is handled by the platform (D9):** collects W-9/W-8BEN before the first cash payout, tracks totals, issues year-end forms (for example 1099-NEC) or hands us a ready report; says who is payer of record. Also states the tax treatment of **gift card** rewards.
- [ ] Identity checks for cash payouts.
- [ ] Behaviour for **under-18** referrers: can we restrict them to gift cards? (Legal question for the lawyer; see Open questions.)
- [ ] Self-referral blocked (same email, card, device, or IP).
- [ ] Controls to pause an abusive referrer without our manual work on every case.
- [ ] Terms of service for referrers, which the vendor hosts or lets us attach.
- [ ] Privacy: what data the vendor holds about students; data processing terms; deletion on request.

### F. Integration (R6, R7)
- [ ] REST API and webhooks for: referrer created, referral converted, reward earned, payout sent.
- [ ] We can store the vendor's referral id on `app.trial_orders.ad_attribution` so referrals join ad data.
- [ ] Embeddable in the Lovable marketing site without custom hosting.
- [ ] Pricing at 100, 1,000 and 10,000 referrers (some vendors charge by referrer or by tracked revenue).

### G. Age gate, disclosure and friend discount (R9-R11)
- [ ] A **required checkbox** with our exact attestation text can be added to the signup form; the form cannot submit unchecked; the acceptance is stored with a timestamp (and ideally the text version).
- [ ] Signup page and emails are **customisable** (our wording, our domain or an embed).
- [ ] The **landing page message** can show the referrer's name or code, and the reward wording, from the link.
- [ ] The **share text** (prefilled message on the referrer's phone) can be edited to our wording and includes the link.
- [ ] The link can **auto-apply a Stripe $5-off coupon** for the friend (or passes `?promo=` to our checkout, which already applies it). Works with our card-trial quote and the day-7 charge; the coupon is not reusable without a link and cannot be stacked with another code.
- [ ] Tutor links can be configured with **no friend discount** (or a different one).
- [ ] Commission math: the tutor's 25% uses the **charged price**; a student link's $5-off coupon does not change the $5 student reward.

## Scoring

Hard fails (any one rules a vendor out, since one vendor must serve both audiences): no auto-approval (A), cannot reward from the day-7 charge or would reward a trial start (C), no gift card or cash payout (D), refunds not handled (C), no way to restrict minors (E).

## Decisions (David, 2026-10-27)

| # | Decision |
| --- | --- |
| D1 | **Students:** $5 flat per converted trial, paid as a **gift card the student chooses** from a few options (Amazon, DoorDash and similar) |
| D2 | **Tutors/teachers:** **25%** of the sale, paid in **cash** |
| D3 | A refund after day 14 does **not** claw back the reward; the referrer keeps it. A refund or dispute **inside** the 7-day delay still cancels it (R8) |
| D4 | Gift cards for students, cash for tutors only |
| D5 | **One vendor** for both audiences. This removes the two-tool option and tightens the hard fails below |

Added checks that follow from these: the vendor must support a **flat amount for one audience and a percentage for the other** (D1, D2), a **student-chosen gift card catalogue** (D1), and **cash payout for tutors** (D2).

## Earlier open questions (answered above)

| # | Question |
| --- | --- |
| Q6 | (Answered: D6) |
| Q7 | (Answered: D7) |
| Q8 | (Answered: D8) |
| Q9 | **Lawyer:** cash to tutors needs tax forms (W-9/W-8BEN) and identity checks; student referrers may be minors; sharing student data with a referral vendor. |

## More decisions (David, 2026-10-27)

| # | Decision |
| --- | --- |
| D6 | The tutor's 25% is calculated on the **price actually charged** (after any discount) |
| D7 | Paid on **every sale** to a student that tutor referred (all subjects and add-ons), not only the first |
| D8 | ~~The referred friend gets no automatic benefit~~ **Superseded by D12** |
| D9 | **The platform must handle tax** (forms collection and reporting for cash payouts) |
| D11 | The student's $5 is paid **once per converted trial**, not on later sales (tutors differ: 25% on every sale, D7) |
| D12 | **Change of plan (2026-10-27):** anyone who uses a **student** share link gets **$5 off automatically**, through a $5-off Stripe coupon. Two-sided, so the referrer ($5 gift card) and the friend ($5 off) both benefit. Tutor links: unchanged (not stated; see Q12) |
| D13 | **Age gate:** the referrer signup page has a required checkbox attesting they are 14 or older. Wording in the copy section (general "laws which restrict people 13 and under", not a federal-standard claim) |
| D14 | **Disclosure copy:** the referrer's benefit is disclosed on the landing page and in the share text. Wording below |
| D10 | **Rewardful and FirstPromoter are out** (no gift cards). Candidates: GrowSurf, Referral Factory, Partnero, and any others found |

## Consumer-facing copy (David, 2026-10-27; light edits flagged)

**Age attestation checkbox (referrer signup), required.** The wording is deliberately general because the legal rules vary by state:
> There are laws which restrict people 13 and under from joining referral programs like this. Do not sign up if you are not at least 14 years old.

(Grammar fixed from "if you do not at least 14 years old". It no longer says "federal privacy standards", since the rules vary by state; the lawyer still confirms it, Q11.)

**Share text (referrer's phone), accurate mutual-benefit wording:**
> Use my Cramapple link: $5 off for you and $5 from [Gift Card] for me! [Link]

`[Gift Card]` is the brand the referrer will choose at payout (Amazon, DoorDash and similar). If the brand is not known when the text is generated, use "a $5 gift card" instead.

**Landing page (friend):** the same facts in the friend's voice:
> Your friend [Name/Code] invited you! Sign up with this link and you get $5 off. They get a $5 gift card.

(David's earlier line, "you both get [Reward]", is replaced because the two rewards differ.) A tutor link has a different reward (25% cash commission), so it needs its own copy or no mutual-benefit line (Q12).

## Open questions

| # | Question |
| --- | --- |
| Q10 | (Answered: D11) |
| Q12 | Do tutor links also give the friend $5 off, or no discount? |
| Q13 | Does the share/landing disclosure need the referrer's name, or is "your friend" enough? (Privacy for minors; the code can stand in for the name.) |
| Q11 | **David is finding out (owner: David).** Lawyer: also whether the general "laws restrict people 13 and under" wording is sufficient for a 14-and-older gate, and who verifies the attestation; student referrers may be minors; sharing student data with a referral vendor; who is the payer of record for tax (Cramapple or the vendor)? |

## Next steps

1. Q11 (legal: minors, data sharing, tax payer of record): David is finding out.
2. Claude requests written answers from 3 vendors on the unknown rows.
3. David starts free trials; Claude runs section C in Stripe test mode on Dev with a test trial and a day-7 charge.
4. Decision recorded in `docs/marketing`; implementation (tag in checkout, referral id in `ad_attribution`) planned separately.
