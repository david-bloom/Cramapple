# Lovable prompt DRAFT — marketing `/try` route and checkout first paint (NOT SENT, 2026-11-08)

**Status:** Draft, **not sent to Lovable, not published.** Authority: `APPROVAL-0206` (Development/draft only). Target: marketing project `61dd6602-6991-4561-b418-e988bb7c8a0b` (head `d678c77`).
**Blocked on:** (1) the backend contract for the anonymous first MCQ (where it is served, how the answer is saved to the account at registration); (2) David's choice of where the anonymous question runs (marketing domain vs app domain; the cookie-split architecture means app features do not live on the marketing project); (3) the open §8 rules. Diagnose before sending: read `src/routes/checkout*.tsx` and `src/lib/purchase-api.ts` / `trial-checkout.ts`; only `src/components/checkout/TrialOffer.tsx` was read in this pass.

## Diagnosis so far (read-only)
- `cramapple.com/try` is 404 [verified]. Every landing CTA links to `/checkout` or `/checkout?subjects=<key>` [verified].
- `/checkout` shows "Total due today $39.99" before any email because trial wording renders only for a server-confirmed trial quote (`TrialOffer.tsx`); the landing hero says "You pay nothing today" [verified].

## Proposed prompt (edit after diagnosis)
> Add a `/try` route. `/try?subjects=<key>` must open on subject-and-unit selection (subject preselected from `subjects` when it is a known key), then the first anonymous multiple-choice question with full feedback. No email field, no card field and no sign-in before the question and its feedback are shown. After the feedback, show a registration step whose purpose is "save your answer and keep going". Keep UTM, promo and click-id parameters through every step and into registration (do not drop them on navigation). Keep a clearly secondary link "Skip to the seven-day card trial" to `/checkout` with the same parameters. Do not state a price, trial length or deadline in code or copy that did not come from the backend's offer response. Name the 72-hour free sample and the seven-day card trial separately everywhere. Use the existing Cramapple design system only. Behind a flag that defaults off; do not change any existing route's behavior while the flag is off.
>
> Separately, change `/checkout` first paint so it never shows "Total due today $39.99" as a settled fact before an eligibility quote exists: show a neutral "Checking your offer" state, then the server-confirmed trial or pay-now summary.

## Checks before it is sent
Backend contract exists; D6 (experiment) and D7 (emails) are not needed by this prompt; privacy/counsel review of the earlier collection path (plan §7) is recorded; Codex reviews by commit SHA after Lovable returns.


---

## Revision 2026-11-09 (after owner answers; still NOT SENT, needs David's go-ahead)

Decisions that change this draft: **N2** the anonymous question runs in the app at `app.cramapple.com/sample` (live since 2026-11-09, hidden link, flag on), so **no `/try` implementation is built on marketing**; **population** is a hidden link, so no marketing page links to the sample yet. Backend contract, N4 and N12 are settled. Two separable prompts remain:

**Prompt 1: checkout first paint (owner item N10; safe to send alone, independent of the sample).** Target: marketing project `61dd6602-6991-4561-b418-e988bb7c8a0b`. Observed live on 2026-11-09 (David): "Start free trial" leads to `/checkout` showing Pay with card / Ask a parent to pay, an Order Summary of $39.99, "1 step left: add a payment method", and Place order disabled. That is the existing card-trial checkout (`DECISION-0126`: card collected now, charge after the trial) and has not changed. The defect is the wording: the page presents $39.99 as due before any eligibility quote while the landing hero says "You pay nothing today".
> Change `/checkout` so it never shows "Total due today $39.99" (or any amount as due today) before an eligibility quote exists. Show a neutral "Checking your offer" state, then the server-confirmed summary. When the server confirms a seven-day card trial, show the amount due today as the server states it (zero) and the later charge and date as the server states them; when it confirms pay-now, say pay now. Do not hard-code any price, trial length or date. Do not change payment, entitlement or sign-in behavior. Behind no flag; if the quote call fails show a plain error and the existing retry, never a price.

**Prompt 2: entry to the sample (do NOT send until David ends the hidden-link phase).** Add a secondary link on the landing CTA area, "Try 8 free questions first", to `https://app.cramapple.com/sample?subject=<key>` carrying UTM, promo and click-id parameters, naming the 72-hour free sample and the seven-day card trial separately and stating no price. The app side does not yet forward attribution into checkout (known gap).

**Checks before sending either:** David approves sending; Codex reviews the Lovable result by commit SHA; the first-paint fix is verified on a real checkout (no payment) before publish.
