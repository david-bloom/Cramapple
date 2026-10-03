# Refund Policy — Draft for David's Review

**Status:** DRAFT (support address decided 2026-10-02: an alias `support@cramapple.com` that forwards to David; the alias must exist before the Terms are published). Not in the Terms. Not reviewed by counsel (the Terms themselves are marked "Draft for product and counsel review"; I am not a lawyer).
**Date:** 2026-10-02. **Direction (David):** "refunds gladly given within 7 days of purchase."
**Governs:** closes the "refund / terms position" prerequisite in `STRIPE_PRODUCTION_CUTOVER_CHECKLIST_2026_09_30.md` (Gate C, tranche 2) once adopted.
**Where it goes:** the live Terms are `src/content/terms-and-conditions.md` in the Lovable marketing project (`61dd6602`); the repo copy is `docs/legal/TERMS_AND_CONDITIONS.md`. Both currently say, in §12, only: *"refunds, if any, are governed by the purchase terms shown at checkout or in the applicable sales policy."*

## 1. Proposed text

**Replace the refund bullet in §12** with:

> - refunds are described in Section 12.1;

**Add a new subsection after the §12 bullets:**

> ### 12.1 Refunds
>
> We gladly refund purchases within 7 days of the date you buy. You don't need to give a reason.
>
> - **How to ask.** Email support@cramapple.com within 7 days of your purchase. Include the email address you used at checkout and the subject or subjects you bought.
> - **What you get back.** The full amount you actually paid for that order, including any promotional or discounted price. We refund to the card or payment method used, and it usually appears within 5 to 10 business days, depending on your bank.
> - **Refunds cover the whole order.** A refund ends access to everything that order bought. If you bought several subjects together, a refund ends access to all of them.
> - **If a parent or guardian paid.** The refund goes to the person who paid, to the card they used. Either the student or the person who paid may ask for it, and the student's access for that purchase ends when the refund is processed.
> - **Add-on subjects.** An add-on subject has its own 7 days, counted from the day you bought the add-on.
> - **After 7 days.** We may still help, for example if a technical problem kept you from using Cramapple, but we can't promise a refund after 7 days.
> - **Misuse.** We may decline a request that looks like misuse, such as repeatedly buying and refunding the same subject.
> - **Your legal rights.** Nothing in this section limits any refund rights you have under applicable law.
>
> Please email us before disputing a charge with your bank. We can usually fix it faster.

**Also:** bump "Last updated" to the adoption date. **Checkout line** (one short sentence under the total, optional): *"Refunds gladly given within 7 days of purchase."* linking to §12.1.

## 2. Why the text says what it says (checked against the system)

| Policy wording | What the system actually does |
|---|---|
| Refund ends access | `charge.refunded` → `handleChargeRefunded` sets `subject_entitlements.status = revoked` (proven live on Dev 2026-10-02: `evt_3ULty7…`). |
| **Refunds cover the whole order** | The handler revokes **every** active paid entitlement on the checkout session and **never compares the refunded amount** to the charge. A *partial* Stripe refund on a bundle would still revoke all subjects. So the policy promises whole-order refunds only. |
| Full amount actually paid, incl. promos | Stripe refunds what was charged (a $1.00 coupon purchase refunds $1.00). |
| Parent-paid: refund to the payer | Parent-share sessions charge the parent's card and never save it (`DECISION-0090`); a refund goes back to that card. |
| Add-on has its own 7 days | The add-on is a separate Checkout Session (`create-post-purchase-addon`), so it has its own charge and date. |

## 3. Problems this exposed (not fixed here)

1. **Nobody receives refund requests today.** The Contact Us page (`src/routes/contact-us.tsx`) validates the form and then shows "Thanks — we've got it. A real human will reply" **without sending anything** (no network call). The Terms' own contact line ("the support channel listed on the site or in the app") has no email behind it. **A real support email address must exist and be printed in §12.1 before anyone is charged**, and the contact form should either send or be replaced with a `mailto:` link. Needs a Lovable change (David's call) and an address from David.
2. **Refunds are manual in the Stripe dashboard.** Nothing automates them. Who watches the support inbox and issues refunds during the pilot and launch month?
3. **Price changes.** The policy doesn't promise price-matching. A stranger who pays $39.99 now and sees 50% off next week can get a refund within 7 days and rebuy at the new price; after 7 days they can't. Decide whether that is acceptable (it follows from "7 days").
4. **Minors.** Students buy directly; the Terms say under-13s shouldn't use the service without parental consent and don't address under-18 contracting. Counsel question, not a blocker for this wording.
5. **Terms mismatch.** The live Terms say "Last updated 2026-08-22", the repo copy says 2026-06-22. They are already out of sync; adopting this should update both.


## 3a. Decisions (David, 2026-10-02) and how the all-or-nothing issue is handled

- **Support address:** use an alias, `support@cramapple.com`, forwarding to David. David's personal address stays out of the public Terms. The alias must receive mail (and ideally be a Gmail "send as" so replies come from it) before the Terms are published.
- **Contact Us form:** replace the do-nothing form with a working path (a `mailto:support@cramapple.com` link is the fastest; a form that really sends is the alternative). Lovable change; David's call.
- **All-or-nothing refunds, two options:**
  - **A. Policy only (works today, no code):** refunds are whole-order. During the pilot, issue **full refunds only** in Stripe. If a customer wants one subject of a bundle refunded, refund the whole order and let them rebuy the subject they want.
  - **B. Small webhook fix (recommended before the public 50% launch):** in `handleChargeRefunded`, revoke access only when Stripe reports the charge **fully refunded** (`charge.refunded === true`); for a **partial** refund, log it and leave access alone. A partial refund then works as a goodwill or price-adjustment refund (for example giving a full-price buyer the difference after 50% off) without cutting access. The data is already on the event (`ChargeObject` has `refunded` and `amount_refunded`). Needs a unit test, a Dev proof (partial refund keeps access, full refund revokes), and a Production redeploy of `stripe-webhook`, so a new approval.
  - Until B ships, **never issue a partial refund in Stripe** for a Cramapple order: it would revoke the whole order.

## 4. To adopt

1. David approves or edits §1 above, and supplies the support email.
2. The Terms change goes through Lovable (David pastes the section into `src/content/terms-and-conditions.md` in the Code view and publishes), and the repo copy is updated to match. I will not edit the live Lovable project without being asked.
3. A decision is recorded (it changes a customer-facing commitment) and this draft is marked adopted.
