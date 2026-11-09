# Paywall sample: decisions only David can make (2026-11-09)

**Status:** request for owner decisions. Nothing here is decided, deployed or released. Authority so far is `APPROVAL-0206` (Development/draft only), `DECISION-0134` (backend rules P1–P8) and `APPROVAL-0207` step A (Production dark apply, executed 2026-11-09; switches off). Step B (activation) needs your separate approval in `APPROVAL-0207` §5.
**How to use:** answer each numbered item in chat ("N1: yes", "N3: option b"). Each answer should be recorded as a DECISION or APPROVAL entry by the session that acts on it; I have not created any.
**Parents:** `PAYWALL_CHANGE_PLAN_2026_10_31.md`, `PAYWALL_BACKEND_DESIGN_SPEC_2026_11_08.md`, `PAYWALL_PRODUCTION_RELEASE_PLAN_2026_11_09.md`.

Plan §8's old "still open" list (anonymous switching, consumption, uploads, identity, trial precedence, rollback) was settled by `DECISION-0134` P1–P8 and is no longer open. What remains is below, ordered by what blocks release first.

## A. Blocks the first Production release (needed before any release request)

| # | Decision | Options | My recommendation | What it unblocks |
| --- | --- | --- | --- | --- |
| N1 | **DECIDED, no action: uploaded-FRQ grading.** `DECISION-0134` P6 = option (a): the first release ships the Cramapple FRQ only; the backend refuses uploaded-question grading. The app now hides the upload option. | | | **David confirmed 2026-11-09 (chat: "N1- yes").** |
| N2 | **DECIDED 2026-11-09 (chat: "app confirmed").** The anonymous first question runs in the app project (56cae479) at `/sample`; marketing only links to it. | | | Marketing `/try` becomes a link or redirect, not a second implementation. |
| N3 | **Measured 2026-11-09, Production, read-only, via the backend's own `app.sample_unit_availability`:** of 48 selectable units across 10 subjects, **31 eligible and 17 not** (a same-day report of 30 eligible, with Calculus AB Unit 1 ineligible, was a paging artefact and is withdrawn; on the corrected serving basis all 31 stay eligible once the A.1 patch is applied). Ineligible: Calc AB U3 (0 usable FRQ); Calc BC U5, 6, 7, 8, 10; Chemistry U4–9; Biology U4–8 (all short of 8 MCQs, some also lacking an FRQ). Eligibility is per unit, so topics inside an ineligible unit are unavailable too. Calc AB Units 4–8 do not appear in the function's list at all (the Phase 0 audit counts them), so a student cannot pick them; I have not established why. Note: the backend's rule is stricter than the audit (it excludes image-stimulus, hand-drawn, photo-required and unreleased items). **Original question:** | **Units that cannot deliver the sample.** The audit shows only Units 1–3 per subject reliably have 8 MCQs and a non-photo FRQ. The backend marks other units ineligible. | (a) Show only eligible units (the picker already greys out the rest). (b) Offer only Units 1–3 in the first release. (c) Fill content gaps first. | (a), with the Production unit list re-audited on release day. | Whether the picker looks sparse; whether any subject has no eligible unit at all. |
| N4 | **Partly addressed 2026-11-09:** the app now shows "By checking your answer, you agree to our Terms of Service and acknowledge our Privacy Policy" at the first answer and "By registering, ..." at registration (app PR #48), the same pattern the app already uses for BYOQ and photo submissions. That is a notice at the point of collection. It does not by itself answer the review questions below (a possibly-minor student before any parent step; the stored hashed IP and email hash; retention). **Original item:** | **Minors' data review for the earlier collection point.** The sample now collects an anonymous try, then an account, earlier than checkout did. Plan §7 says prior checkout collection is not sufficient evidence. | Name the reviewer (counsel or yourself) and confirm the path against the existing privacy work. | Do it before any Production flag is enabled. | The Production approval for enabling the sample. |
| N12 | **Photo-answer flags for the sample (new, from `APPROVAL-0207` §3 item 8).** `FRQ_PHOTO_RESPONSES_ENABLED` and `FRQ_PHOTO_SUBJECTS` are off in Production, so a sample student cannot photograph an answer. | (a) A separate Hard-Gate approval enables the photo flow for the sample subjects (covers transcript ops, `capture-pairing`, spend caps, `DECISION-0110`/`0111` retention). (b) First activation ships a typed-answer FRQ and the copy says so. | (b) for the first activation; (a) afterwards. The app copy already defaults to typed-answer wording. | The FRQ copy, and whether the photo-extraction cap matters at launch. |
| N5 | **DECIDED 2026-11-09 (chat: "I will approve each step").** Per-step approvals, as `APPROVAL-0207` §5 and the release plan already assume. | | | Everything in the release plan. |

## B. Needed before the experiment, not before the first release

| # | Decision | Options | My recommendation |
| --- | --- | --- | --- |
| N6 | **D6 experiment design.** Allocation, primary metric, exposure counts, stopping rules, cohort maturity (see plan §6 for the review concerns). | Adopt a design, or release the sample to a small approved test population with no experiment. | Release to a small approved population first, and define the experiment from what that shows. |
| N7 | **D7 nurture emails: whether, when, content, classification, preferences.** Drafts exist but are not approved and not labelled transactional. | (a) None in the first release. (b) Activation notice only. (c) Full activation, day-2 and expiry sequence. | (a) or (b) for the first release. Anything promotional needs a classification and unsubscribe decision first. |
| N8 | **Analytics events: adopt the contract in `PAYWALL_ANALYTICS_AND_EMAIL_DRAFTS_2026_11_08.md`?** It adds allow-list properties to the app's PostHog wrapper but no Production schema change. | Approve as is, edit, or defer. | Approve as is so the first population is measurable. |

## C. Small follow-ups that can wait

| # | Decision | Note |
| --- | --- | --- |
| N9 | Grace resume UX (`DECISION-0134` P8 deferred `session_resume` during grace). | App reads `learning_session_id` from the state; fine for launch. |
| N10 | Checkout first-paint fix: live checkout shows "Total due today $39.99" while the landing page says nothing is due today (audit §1). | This makes the control clean for any experiment. A Lovable prompt is drafted and unsent; it needs your go-ahead to send. |
| N11 | Whether the anonymous first MCQ may include image stimuli. | Backend excludes them for anonymous callers; fine for launch. |

## What I will not decide for you

D6, D7, the domain, the Production approvals, or whether to send any Lovable prompt or email. Until you answer, those stay as marked placeholders.
