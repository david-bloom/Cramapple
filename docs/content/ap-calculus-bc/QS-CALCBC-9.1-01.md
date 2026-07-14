# Short Question Set QS-CALCBC-9.1-01 — Parametric and Polar

**Set ID:** QS-CALCBC-9.1-01
**Set-Version:** v01
**State:** Drafted
**Subject:** CALCBC
**Applies to:** [CALCBC]
**Unit / Topic:** Unit 9 (Parametric Equations, Polar Coordinates, and
Vector-Valued Functions)
**Intended use:** diagnostic
**Linked fact pack:** FP-CALCBC-9.1-01
**Status note:** Illustrative Draft items. NOT production content, NOT calibration
evidence. Each item would resolve to a full package before production release,
authored by a qualified tutor and independently reviewed.

> Format reference: `docs/product/FACT_PACKS_AND_QUESTION_SETS.md` §5.

## Items

### Item 1 — MCQ (Medium · Calculate)

A curve is given by `x = t²`, `y = t³`. What is `dy/dx`?

- A. `3t²`
- **B. `3t/2`** ✔
- C. `2/(3t)`
- D. `6t³`

*Key:* B. `dy/dx = (dy/dt)/(dx/dt) = 3t²/(2t) = 3t/2`.
*Distractor logic:* C inverts the ratio (guards FP E4); D multiplies the
derivatives; A differentiates `y` w.r.t. `t` only.

### Item 2 — MCQ (Medium · Calculate)

What is the area enclosed by the polar curve `r = 2` (a circle) for
`0 ≤ θ ≤ 2π`?

- A. `2π`
- **B. `4π`** ✔
- C. `8π`
- D. `π`

*Key:* B. `A = ½ ∫₀^{2π} (2)² dθ = ½ · 4 · 2π = 4π` (matches `πr² = 4π`).
*Distractor logic:* A drops the squaring/uses `∫ r dθ` (guards FP E5); C omits
the ½.

### Item 3 — MCQ (Easy · Determine)

For a parametric curve, the slope `dy/dx` is given by:

- A. `(dx/dt)/(dy/dt)`
- **B. `(dy/dt)/(dx/dt)`** ✔
- C. `(dy/dt)·(dx/dt)`
- D. `dy/dt − dx/dt`

*Key:* B.

### Item 4 — Short FRQ (Hard · Calculate, Justify)

A curve is given by `x = t²`, `y = t³ − 3t`.

(a) Find `dy/dx` in terms of `t`.
(b) Find the coordinates of every point where the tangent line is horizontal.

*Expected response (development fixture, not a gold label):*
(a) `dx/dt = 2t`, `dy/dt = 3t² − 3`, so `dy/dx = (3t² − 3)/(2t)`.
(b) Horizontal tangent where `dy/dt = 0` and `dx/dt ≠ 0`: `3t² − 3 = 0 ⇒ t = ±1`
(at both, `dx/dt = ±2 ≠ 0`). Points: `t = 1 → (1, −2)`; `t = −1 → (1, 2)`.

*Criterion sketch:* C1 — correct `dy/dx = (3t² − 3)/(2t)` set up as the parametric
ratio (guards FP E6); C2 — `dy/dt = 0` solved to `t = ±1` with `dx/dt ≠ 0`
checked; C3 — correct points `(1, −2)` and `(1, 2)`.
