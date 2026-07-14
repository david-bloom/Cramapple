# Fact Pack FP-CALCAB-6.1-01 — Integration and the Fundamental Theorem

**Pack ID:** FP-CALCAB-6.1-01
**Pack-Version:** v01
**State:** Drafted
**Subject:** CALCAB
**Applies to:** [CALCAB, CALCBC]  *(BC reuses AB integration content)*
**Unit / Topic:** Unit 6 (Integration and Accumulation of Change) — antiderivatives,
definite integrals, and the Fundamental Theorem of Calculus *(confirm exact
official topic id against the current AP Calculus CED before Approved)*
**Author class:** ai_draft_human_reviewed (illustrative format example)
**Source status:** cramapple_authored
**Official-material boundary checked:** yes — established public-domain calculus in
original wording
**Status note:** Illustrative Draft. NOT production content, NOT calibration
evidence.

> Format reference: `docs/product/FACT_PACKS_AND_QUESTION_SETS.md` §4.

## Entries

### E1 — concept `teaching_safe` (learner_visible_summary, authoring_brief)

Integration reverses differentiation. The indefinite integral (antiderivative) of
`f` is a family of functions differing by a constant; the definite integral
`∫ₐᵇ f(x) dx` is a number — the net signed area between `f` and the x-axis from `a`
to `b`. The Fundamental Theorem of Calculus links the two.

### E2 — formula_rule `teaching_safe` (grading_only, learner_visible_summary, authoring_brief)

- **Power rule (integration):** `∫ xⁿ dx = xⁿ⁺¹/(n+1) + C` for `n ≠ −1`
  (`∫ x⁻¹ dx = ln|x| + C`).
- **FTC Part 1:** `d/dx [∫ₐˣ f(t) dt] = f(x)`.
- **FTC Part 2:** `∫ₐᵇ f(x) dx = F(b) − F(a)`, where `F' = f`.
- Common antiderivatives: `∫ eˣ dx = eˣ + C`; `∫ cos x dx = sin x + C`;
  `∫ sin x dx = −cos x + C`.
- **Average value:** `(1/(b−a)) ∫ₐᵇ f(x) dx`.

### E3 — worked_method `teaching_after_attempt` (authoring_brief)

Neutral worked example of FTC Part 2:

```text
∫₁³ 2x dx = [x²]₁³ = (3²) − (1²) = 9 − 1 = 8
```

### E4 — misconception `grading_sensitive` (grading_only, repair_after_grade)

- **Misconception hypothesis:** the constant of integration is dropped on an
  indefinite integral, or the antiderivative is evaluated in the wrong order.
- **Response signal:** writes `∫ 6x² dx = 2x³` (no `+ C`), or computes
  `F(a) − F(b)` instead of `F(b) − F(a)`.
- **Repair move:** "Include `+ C` for an indefinite integral; for a definite
  integral evaluate `F(top) − F(bottom)`."
- **Minimum fix:** add `+ C`, or reverse the subtraction order.

### E5 — misconception `grading_sensitive` (grading_only, repair_after_grade)

- **Misconception hypothesis:** the power rule for integration is confused with
  differentiation (student multiplies by the exponent instead of raising it).
- **Response signal:** writes `∫ x² dx = 2x`.
- **Repair move:** "To integrate, raise the exponent by one and divide:
  `xⁿ⁺¹/(n+1)`."

### E6 — boundary `grading_sensitive` (grading_only) — criterion "FTC applied correctly"

- **Required evidence:** a correct antiderivative is found and evaluated as
  `F(b) − F(a)` with the bounds substituted in the correct order.
- **Accepted:** any correct antiderivative (with or without `+ C` for a definite
  integral, since it cancels) evaluated top-minus-bottom.
- **Insufficient:** correct antiderivative with bounds reversed or not
  substituted; differentiating instead of integrating.

## Views

- **authoring_view:** E1–E6, full fields.
- **learner_view:** E1, E2, E3 (post-attempt); excludes E4–E6 pre-attempt.
- **grading_view:** E2, E4, E5, E6.
