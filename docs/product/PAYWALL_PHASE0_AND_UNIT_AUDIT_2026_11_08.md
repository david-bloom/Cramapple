# Paywall plan — Phase 0 verification and per-unit sample audit (2026-11-08)

**Status:** Evidence record, read-only. Nothing was changed in Production, Lovable, Stripe, Loops or PostHog.
**Parent plan:** `PAYWALL_CHANGE_PLAN_2026_10_31.md` (Phase 0; §3 "verify every selectable unit").
**Method labels:** **[Verified]** = observed directly on 2026-11-08. **[Inferred]** = reasoned, not observed.

## 1. Phase 0 — what is actually live

| Check | Result |
| --- | --- |
| Marketing Lovable project `61dd6602` HEAD | **[Verified]** `d678c77` ("Set AP calc criterion partial", 2026-11-08 15:10Z), `is_published: true`. |
| App Lovable project `56cae479` HEAD | **[Verified]** `b52cf2c` (2026-11-08), identical to `david-bloom/ap-prep-blueprint` `main` HEAD, so the local clone matches Lovable. |
| Landing hero offer | **[Verified]** Live `cramapple.com/` reads "You pay nothing today. After your 7-day trial it's $39.99, once. Cancel whenever." and lists $39.99 / $69.99 / $89.99 for one / two / three courses. The Oct 31 price-disclosure prompts are therefore **reflected on the live landing page**. |
| Checkout offer consistency | **[Verified — inconsistent]** Live `cramapple.com/checkout?subjects=ap-biology` (before any email is entered) shows "AP Biology · $39.99", "Order summary … $39.99", and "**Total due today $39.99**", with no trial wording. This contradicts the landing page's "pay nothing today." **Diagnosis from live source [Verified]:** marketing `src/components/checkout/TrialOffer.tsx` renders the trial heading and mandate only for a server-confirmed trial quote (which needs an email and an eligibility check); with no quote the page shows the pay-now summary. So the mismatch is the pre-email first paint, by design today, not a regression. Whether the trial wording appears after an email is entered is **[unverified]** (submitting an email is a form submission I did not make). Treat the checkout first-paint/offer fix as **not shipped**; the plan's "verify the checkout first-paint fix" check fails. |
| `/try` | **[Verified]** `cramapple.com/try` returns 404. Every landing CTA links to `/checkout` (email + card). The new journey does not exist anywhere live. |
| Attribution | **[Not verified]** Needs an ad-landing test with UTM/promo parameters and a look at what persists through `/checkout` to the app; not done read-only. Owner doc: `marketing/AD_ATTRIBUTION_DECISIONS_AND_ACTIONS.md`. |
| Mobile journey | **[Partly verified]** Checkout rendered at 375×812 with the same content as desktop. Landing mobile layout and the full flow were not walked. |
| Reddit/Oct 31 "prompts sent" | The Lovable edit list for the marketing project shows no checkout-specific commit after 2026-10-31 apart from landing/branding commits; this is consistent with, but does not prove, an unfixed checkout. |

**Control-group implication (plan §1, §6):** the experiment control is not yet clean; landing and checkout disagree about what is due today.

## 2. Per-unit sample audit (Production, read-only)

Question asked: can each subject/unit deliver the promised sample — **8 published MCQs with complete feedback, an FRQ option, explainer/reference pages**?

**Definitions (Production queries run 2026-11-08):**
- *Published MCQ/FRQ*: item status `published` and its version status `published`. Unit comes from the item's primary, unsuperseded topic cell via `app.taxonomy_topics`.
- *Complete MCQ feedback*: exactly four choices, exactly one correct, every choice has a non-empty rationale (this is what `public.get_graded_mcq_feedback` returns).
- *FRQ with answer*: published FRQ with a non-empty `canonical_answer_1`.
- *Explainers*: published rows in `public.topic_explainers`. *Reference*: published rows in `public.unit_reference_entries`.
- **Not checked:** whether each item currently has a validated serving label (an item can be published but not servable), difficulty spread, image dependence, and whether the item is eligible under the sample's serving contract. These limit how far "published" implies "servable."
- "Selectable unit" is not yet defined by the plan. Units with **zero** published MCQs do not appear in the table at all; they are listed below the table.

| Subject | Unit | Pub MCQ | Complete | Pub FRQ | FRQ w/ answer | Explainers | Reference | Verdict |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| AP Calculus AB | 1 | 136 | 136 | 39 | 39 | 16 | 24 | OK |
| | 2 | 96 | 96 | 11 | 11 | 10 | 17 | OK |
| | 3 | 76 | 76 | 9 | 9 | 6 | 10 | OK |
| | 4 | 11 | 11 | 5 | 5 | 7 | 0 | **No reference** |
| | 5 | 12 | 12 | 11 | 11 | 12 | 0 | **No reference** |
| | 6 | 11 | 11 | 6 | 6 | 11 | 0 | **No reference** |
| | 7 | **4** | 4 | 3 | 3 | 7 | 0 | **Short MCQ; no reference** |
| | 8 | 9 | 9 | 8 | 8 | 12 | 0 | **No reference** |
| AP Calculus BC | 1 | 127 | 127 | 21 | 21 | 16 | 0 | **No reference** |
| | 2 | 94 | 94 | 11 | 11 | 10 | 0 | **No reference** |
| | 3 | 81 | 81 | 9 | 9 | 6 | 0 | **No reference** |
| | 5 | **3** | 3 | 1 | 1 | 12 | 0 | **Short MCQ; no reference** |
| | 6 | **4** | 4 | 2 | 2 | 14 | 0 | **Short MCQ; no reference** |
| | 7 | **2** | 2 | **0** | 0 | 9 | 0 | **Short MCQ; no FRQ; no reference** |
| | 8 | **1** | 1 | **0** | 0 | 13 | 0 | **Short MCQ; no FRQ; no reference** |
| | 10 | **7** | 7 | 2 | 2 | 15 | 0 | **Short MCQ (7 < 8); no reference** |
| AP Chemistry | 1 | 51 | 51 | 8 | 8 | 8 | 26 | OK |
| | 2 | 44 | 44 | 7 | 7 | 7 | 22 | OK |
| | 3 | 71 | 71 | 16 | 16 | 13 | 32 | OK |
| | 4 | **5** | 5 | 1 | 1 | 9 | 22 | **Short MCQ** |
| | 5 | **4** | 4 | **0** | 0 | 11 | 29 | **Short MCQ; no FRQ** |
| | 6 | **5** | 5 | 3 | 3 | 9 | 20 | **Short MCQ** |
| | 7 | **6** | 6 | 1 | 1 | 12 | 21 | **Short MCQ** |
| | 8 | **7** | 7 | 3 | 3 | 11 | 32 | **Short MCQ (7 < 8)** |
| | 9 | **6** | 6 | 3 | 3 | 11 | 24 | **Short MCQ** |
| AP Physics 1 | 1 | 36 | 36 | 14 | 14 | 5 | 31 | OK |
| | 2 | 56 | 56 | 19 | 19 | 9 | 43 | OK |
| | 3 | 55 | 55 | 14 | 14 | 5 | 25 | OK |
| AP Physics 2 | 9 | 24 | 24 | 10 | 10 | 6 | 27 | OK |
| | 10 | 22 | 22 | 7 | 7 | 7 | 37 | OK |
| | 11 | 26 | 26 | 11 | 11 | 8 | 38 | OK |
| AP Physics C: E&M | 8 | 38 | 38 | 19 | 19 | 6 | 33 | OK |
| | 9 | 25 | 25 | 8 | 8 | 3 | 16 | OK |
| | 10 | 24 | 24 | 6 | 6 | 4 | 20 | OK |
| AP Physics C: Mechanics | 1 | 43 | 43 | 7 | 7 | 5 | 32 | OK |
| | 2 | 77 | 77 | 14 | 14 | 10 | 47 | OK |
| | 3 | 53 | 53 | 7 | 7 | 5 | 34 | OK |
| AP Precalculus | 1 | 108 | 108 | 25 | 25 | 14 | 49 | OK |
| | 2 | 110 | 110 | 28 | 28 | 15 | 53 | OK |
| | 3 | 95 | 95 | 28 | 28 | 15 | 43 | OK |
| AP Statistics | 1 | 298 | 298 | 32 | 32 | 13 | 80 | OK |
| | 2 | 54 | 54 | 24 | 24 | 12 | 42 | OK |
| | 3 | 60 | 60 | 16 | 16 | 15 | 60 | OK |
| | 4 | 23 | 23 | 17 | 17 | 10 | 0 | **No reference** |
| | 5 | 21 | 21 | 6 | 6 | 5 | 0 | **No reference** |
| AP Biology | 1 | 96 | 96 | 8 | 8 | 7 | 22 | OK |
| | 2 | 73 | 73 | 15 | 15 | 10 | 44 | OK |
| | 3 | 26 | 26 | 11 | 10 | 5 | 29 | OK (1 FRQ lacks canonical answer) |
| | 4 | 8 | 8 | 8 | 8 | 6 | 0 | **Exactly 8; no reference** |
| | 5 | **5** | 5 | 10 | 10 | 5 | 0 | **Short MCQ; no reference** |
| | 6 | **5** | 5 | 10 | 10 | 8 | 0 | **Short MCQ; no reference** |
| | 7 | **5** | 5 | 15 | 13 | 12 | 0 | **Short MCQ; no reference** |
| | 8 | **5** | 5 | 12 | 11 | 7 | 0 | **Short MCQ; no reference** |

**Published but without a unit** (no resolvable primary cell, so they cannot serve a unit-chosen sample): MCQs — Calc AB 0, Calc BC 33, Chemistry 10, Physics 1 29, Physics 2 21, Physics C E&M 22, Physics C Mechanics 22, Precalculus 0; FRQs — Calc AB 1, Calc BC 31, Chemistry 27, Physics 1 15, Physics 2 14, Physics C E&M 20, Physics C Mechanics 19, Precalculus 6. These may be unlabelled or labelled to a topic with no unit; **[Inferred]** they are unusable for unit selection until labelled.

**Subjects/units absent from the table (zero published MCQ with a resolvable unit) [Inferred from absence]:** Calc AB 9–10; Calc BC 4, 9; Statistics 6–9; Biology 9; Physics 1 units 4–8 (their items appear only in the unit-less line above); Precalculus has only units 1–3; Physics 2 and Physics C subjects cover only the units shown. Whether those units are "selectable" is a product decision the plan has not made.

### 2.1 Findings

1. **Sample-ready on published counts alone (all four checks green):** Calc AB 1–3; Chemistry 1–3; Physics 1 1–3; Physics 2 9–11; Physics C E&M 8–10; Physics C Mechanics 1–3; Precalculus 1–3; Statistics 1–3; Biology 1–3. That is the "Units 1–3 per subject" pipeline, as expected.
2. **A student who picks any later unit cannot get 8 MCQs** in Calc AB 7, Calc BC 5/6/7/8/10, Chemistry 4–9, Biology 5–8 (and Bio 4 only just reaches 8). Calc BC 7–8 and Chemistry 5 also have **no published FRQ**.
3. **Reference pages are missing** in Calc AB 4–8, all of Calc BC, Statistics 4–5 and Biology 4–8. Explainers exist in all units listed; the plan says "explainer/reference pages," so the content product must say which are required.
4. **Complete-feedback check passed for 100%** of published MCQs in every row (complete = published). This is a structural check, not a correctness review.
5. **Biology 9 and the several subjects with no later-unit content mean a unit picker that lists the full CED would over-promise.** Product options (for David, not decided here): limit the picker to units that pass the audit; or let the sample fall back to the subject's other units with a visible notice; or accept a smaller allowance for thin units. A picker must read per-unit availability from the backend, never hard-code it.
6. **Serving contract gap [Verified from source]:** `public.get_graded_mcq_feedback(p_attempt_id)` requires `auth.uid()` and an attempt owned by the caller, and raises `not_authenticated` otherwise. An anonymous student therefore cannot receive feedback through any existing path. The anonymous-MCQ serving/feedback/save-on-registration contract belongs to the backend session and is the first dependency of the app work.

## 3. What this audit does not cover

Serving-label validity per item; image-dependent items (the anonymous path may need to exclude them); difficulty mix; whether Open Hand teaching items are accidentally counted (the queries used published Practice items by status only); per-item correctness; Development versus Production differences (Production only was read); and current traffic by unit. Re-run after the backend contract defines what "eligible for the sample" means.
