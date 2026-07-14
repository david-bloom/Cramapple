# Short Question Set QS-PHYSCMECH-1.1-01 — Kinematics with Calculus

**Set ID:** QS-PHYSCMECH-1.1-01
**Set-Version:** v01
**State:** Drafted
**Subject:** PHYSCMECH
**Applies to:** [PHYSCMECH]
**Unit / Topic:** Kinematics (calculus-based)
**Intended use:** diagnostic
**Linked fact pack:** FP-PHYSCMECH-1.1-01
**Status note:** Illustrative Draft items. NOT production content, NOT calibration
evidence. Each item would resolve to a full package before production release,
authored by a qualified tutor and independently reviewed.

> Format reference: `docs/product/FACT_PACKS_AND_QUESTION_SETS.md` §5.

## Items

### Item 1 — MCQ (Medium · Calculate)

A particle moves so that `x(t) = 3t²` (meters, seconds). What is its velocity at
`t = 2 s`?

- A. 6 m/s
- **B. 12 m/s** ✔
- C. 3 m/s
- D. 24 m/s

*Key:* B. `v = dx/dt = 6t`, so `v(2) = 12 m/s`.
*Distractor logic:* C uses `x/t`; the difference between that and the derivative is
the point (guards FP E4).

### Item 2 — MCQ (Easy · Calculate)

If `v(t) = 4t³`, what is the acceleration `a(t)`?

- A. `t⁴`
- **B. `12t²`** ✔
- C. `4t²`
- D. `12t³`

*Key:* B. `a = dv/dt = 12t²`.

### Item 3 — MCQ (Medium · Calculate)

A particle starts from rest and has acceleration `a(t) = 6t`. What is `v(t)`?

- A. `6`
- B. `6t²`
- **C. `3t²`** ✔
- D. `3t² + v₀` with `v₀ ≠ 0`

*Key:* C. `v(t) = ∫ 6t dt = 3t² + C`; starts from rest ⇒ `C = 0` (guards FP E5).

### Item 4 — Short FRQ (Hard · Calculate)

A particle moves along a line with `x(t) = 2t³ − 3t²` (meters, seconds).

(a) Find `v(t)` and `a(t)`.
(b) Find all times at which the particle is momentarily at rest.

*Expected response (development fixture, not a gold label):*
(a) `v(t) = dx/dt = 6t² − 6t`; `a(t) = dv/dt = 12t − 6`.
(b) At rest when `v = 0`: `6t² − 6t = 6t(t − 1) = 0 ⇒ t = 0 s` or `t = 1 s`.

*Criterion sketch:* C1 — correct `v(t)` and `a(t)` by differentiation (guards FP
E6; equivalent forms accepted via symbolic check); C2 — `v = 0` solved to
`t = 0` and `t = 1 s`.
