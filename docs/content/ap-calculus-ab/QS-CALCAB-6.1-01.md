# Short Question Set QS-CALCAB-6.1-01 — Integration and the FTC

**Set ID:** QS-CALCAB-6.1-01
**Set-Version:** v01
**State:** Drafted
**Subject:** CALCAB
**Applies to:** [CALCAB, CALCBC]
**Unit / Topic:** Unit 6 (Integration and Accumulation of Change)
**Intended use:** diagnostic
**Linked fact pack:** FP-CALCAB-6.1-01
**Status note:** Illustrative Draft items. NOT production content, NOT calibration
evidence. Each item would resolve to a full package before production release,
authored by a qualified tutor and independently reviewed.

> Format reference: `docs/product/FACT_PACKS_AND_QUESTION_SETS.md` §5.

## Items

### Item 1 — MCQ (Easy · Calculate)

Evaluate `∫₀¹ 4x³ dx`.

- **A. 1** ✔
- B. 4
- C. 12
- D. 1/4

*Key:* A. `[x⁴]₀¹ = 1 − 0 = 1`.

### Item 2 — MCQ (Easy · Calculate)

What is `∫ 6x² dx`?

- A. `12x + C`
- **B. `2x³ + C`** ✔
- C. `6x³ + C`
- D. `3x² + C`

*Key:* B. Raise the exponent and divide: `6·x³/3 = 2x³`, plus `C`.
*Distractor logic:* A differentiates (guards FP E5); C forgets to divide; D
mishandles the coefficient.

### Item 3 — MCQ (Medium · Determine)

By the Fundamental Theorem of Calculus, what is `d/dx [∫₀ˣ sin(t²) dt]`?

- A. `cos(x²)`
- **B. `sin(x²)`** ✔
- C. `2x·sin(x²)`
- D. `−cos(x²)`

*Key:* B. FTC Part 1: the derivative of the accumulation function is the
integrand evaluated at `x`.

### Item 4 — Short FRQ (Medium · Calculate)

Let `f(x) = 2x` on the interval `[1, 3]`.

(a) Evaluate `∫₁³ f(x) dx`.
(b) Find the average value of `f` on `[1, 3]`.

*Expected response (development fixture, not a gold label):*
(a) `∫₁³ 2x dx = [x²]₁³ = 9 − 1 = 8`.
(b) Average value `= (1/(3−1)) · 8 = 4`.

*Criterion sketch:* C1 — correct antiderivative `x²` evaluated top-minus-bottom to
`8` (guards FP E6); C2 — correct average-value formula applied to get `4`.
