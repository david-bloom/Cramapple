# Short Question Set QS-CALCAB-2.1-01 — Differentiation Rules

**Set ID:** QS-CALCAB-2.1-01
**Set-Version:** v01
**State:** Drafted
**Subject:** CALCAB
**Applies to:** [CALCAB, CALCBC]
**Unit / Topic:** Unit 2 (Differentiation) — power, product, chain rules, tangent
lines
**Intended use:** diagnostic
**Linked fact pack:** FP-CALCAB-2.1-01
**Status note:** Illustrative Draft items demonstrating the short-question-set
format. NOT production content, NOT calibration evidence. Each item would resolve
to a full package before any production release, authored by a qualified tutor
and independently reviewed.

> Format reference: `docs/product/FACT_PACKS_AND_QUESTION_SETS.md` §5.

## Items

### Item 1 — MCQ (Easy · Calculate)

If `f(x) = x³`, what is `f'(x)`?

- A. `x²`
- **B. `3x²`** ✔
- C. `3x³`
- D. `x²/3`

*Key:* B, by the power rule `n·xⁿ⁻¹`.

### Item 2 — MCQ (Medium · Calculate)

If `f(x) = x²·eˣ`, what is `f'(x)`?

- A. `2x·eˣ`
- **B. `eˣ(x² + 2x)`** ✔
- C. `2x·eˣ + x²`
- D. `2eˣ`

*Key:* B. Product rule: `2x·eˣ + x²·eˣ = eˣ(x² + 2x)`.
*Distractor logic:* A takes the product of derivatives (guards FP E4); C
differentiates only the first factor; D over-simplifies.

### Item 3 — MCQ (Medium · Calculate)

What is `d/dx [sin(x²)]`?

- A. `cos(x²)`
- B. `2x·sin(x²)`
- **C. `2x·cos(x²)`** ✔
- D. `cos(2x)`

*Key:* C. Chain rule: `cos(x²)·2x`.
*Distractor logic:* A omits the inner derivative (guards FP E5/E6); B keeps the
wrong outer function; D mishandles the composition.

### Item 4 — Short FRQ (Medium · Calculate, Represent)

Let `f(x) = x³ − 4x`.

(a) Find `f'(x)`.
(b) Write the equation of the line tangent to `f` at `x = 2`.

*Expected response (development fixture, not a gold label):*
(a) `f'(x) = 3x² − 4`.
(b) `f(2) = 8 − 8 = 0`; `f'(2) = 12 − 4 = 8`. Tangent line:
`y − 0 = 8(x − 2)`, i.e. `y = 8x − 16`.

*Criterion sketch:* C1 — correct derivative `3x² − 4`; C2 — correct point
`(2, 0)` and slope `8`; C3 — correct tangent-line equation.
