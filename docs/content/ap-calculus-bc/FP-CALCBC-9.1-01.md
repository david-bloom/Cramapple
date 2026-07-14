# Fact Pack FP-CALCBC-9.1-01 — Parametric and Polar Calculus

**Pack ID:** FP-CALCBC-9.1-01
**Pack-Version:** v01
**State:** Drafted
**Subject:** CALCBC
**Applies to:** [CALCBC]  *(BC-only: parametric/polar/vector are not in the AB
scope)*
**Unit / Topic:** Unit 9 (Parametric Equations, Polar Coordinates, and
Vector-Valued Functions) — parametric derivatives and polar area *(confirm exact
official topic id against the current AP Calculus CED before Approved)*
**Author class:** ai_draft_human_reviewed (illustrative format example)
**Source status:** cramapple_authored
**Official-material boundary checked:** yes — established public-domain calculus in
original wording
**Status note:** Illustrative Draft. NOT production content, NOT calibration
evidence.

> Format reference: `docs/product/FACT_PACKS_AND_QUESTION_SETS.md` §4. BC-only —
> demonstrates the `applies_to: [CALCBC]` tagging in the AB/BC subset model.

## Entries

### E1 — concept `teaching_safe` (learner_visible_summary, authoring_brief)

Parametric equations describe `x` and `y` separately as functions of a parameter
`t`. Polar coordinates describe a point by a distance `r` and angle `θ`. Calculus
extends to both: slopes come from parametric derivatives, and polar regions have
their own area formula.

### E2 — formula_rule `teaching_safe` (grading_only, learner_visible_summary, authoring_brief)

- **Parametric derivative:** `dy/dx = (dy/dt) / (dx/dt)` (for `dx/dt ≠ 0`).
- **Parametric second derivative:** `d²y/dx² = [d/dt(dy/dx)] / (dx/dt)`.
- **Parametric arc length:** `∫ₐᵇ √((dx/dt)² + (dy/dt)²) dt`.
- **Polar ↔ rectangular:** `x = r cos θ`, `y = r sin θ`.
- **Polar area:** `A = ½ ∫_α^β r² dθ`.

### E3 — method `teaching_after_attempt` (grading_only, authoring_brief)

Finding horizontal/vertical tangents of a parametric curve:

```text
1. Compute dx/dt and dy/dt.
2. Horizontal tangent: dy/dt = 0 AND dx/dt ≠ 0.
3. Vertical tangent: dx/dt = 0 AND dy/dt ≠ 0.
4. Substitute the qualifying t values back to get (x, y) points.
```

### E4 — misconception `grading_sensitive` (grading_only, repair_after_grade)

- **Misconception hypothesis:** the student computes `dy/dx` as `(dx/dt)/(dy/dt)`
  (inverted) or as `(dy/dt)·(dx/dt)`.
- **Response signal:** the ratio is upside-down or multiplied.
- **Discriminating probe:** ask what quantity `dy/dx` represents (rise over run).
- **Repair move:** "`dy/dx = (dy/dt) ÷ (dx/dt)` — the y-rate over the x-rate."
- **Minimum fix:** invert the ratio.

### E5 — misconception `grading_sensitive` (grading_only, repair_after_grade)

- **Misconception hypothesis:** the polar area factor `½` or the squaring of `r`
  is omitted.
- **Response signal:** uses `∫ r dθ` instead of `½ ∫ r² dθ`.
- **Repair move:** "Polar area is `½ ∫ r² dθ` — square `r` and keep the ½."

### E6 — boundary `grading_sensitive` (grading_only) — criterion "parametric slope set up correctly"

- **Required evidence:** `dy/dx` is written as `(dy/dt)/(dx/dt)` with both
  derivatives computed correctly.
- **Accepted:** the correct ratio in any equivalent simplified form.
- **Insufficient:** an inverted or multiplied ratio; differentiating `y` with
  respect to `x` directly without the parameter.

## Views

- **authoring_view:** E1–E6, full fields.
- **learner_view:** E1, E2, E3 (post-attempt); excludes E4–E6 pre-attempt.
- **grading_view:** E2, E4, E5, E6.
