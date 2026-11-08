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
