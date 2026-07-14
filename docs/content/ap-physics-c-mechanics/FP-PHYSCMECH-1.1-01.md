# Fact Pack FP-PHYSCMECH-1.1-01 — Kinematics with Calculus

**Pack ID:** FP-PHYSCMECH-1.1-01
**Pack-Version:** v01
**State:** Drafted
**Subject:** PHYSCMECH
**Applies to:** [PHYSCMECH]
**Unit / Topic:** Kinematics — velocity and acceleration as derivatives and
integrals of position *(confirm exact official unit/topic id against the current
AP Physics C: Mechanics CED before Approved)*
**Author class:** ai_draft_human_reviewed (illustrative format example)
**Source status:** cramapple_authored
**Official-material boundary checked:** yes — established public-domain physics in
original wording
**Status note:** Illustrative Draft. NOT production content, NOT calibration
evidence.

> Format reference: `docs/product/FACT_PACKS_AND_QUESTION_SETS.md` §4. Calculus-based
> — this subject's grading reuses the symbolic-equivalence verifier scoped in
> `TASK-0015` (Calculus).

## Entries

### E1 — concept `teaching_safe` (learner_visible_summary, authoring_brief)

In calculus-based mechanics, velocity is the derivative of position and
acceleration is the derivative of velocity. Reversing the process, integrating
acceleration gives velocity and integrating velocity gives position — each
integration needs an initial condition. The constant-acceleration equations are a
special case, not the definition.

### E2 — formula_rule `teaching_safe` (grading_only, learner_visible_summary, authoring_brief)

- **Velocity:** `v = dx/dt`.
- **Acceleration:** `a = dv/dt = d²x/dt²`.
- **Integrals:** `v(t) = ∫ a dt` (+ `v₀`); `x(t) = ∫ v dt` (+ `x₀`).
- **Work–energy:** `W = ∫ F dx`; `KE = ½·m·v²`; `W_net = ΔKE`.

### E3 — method `teaching_after_attempt` (grading_only, authoring_brief)

```text
Given x(t): differentiate once for v(t), again for a(t).
Given a(t): integrate for v(t) (apply v₀), integrate again for x(t) (apply x₀).
To find when the object is momentarily at rest: solve v(t) = 0.
```

### E4 — misconception `grading_sensitive` (grading_only, repair_after_grade)

- **Misconception hypothesis:** the student uses average rates (`Δx/Δt`) when
  position is nonlinear in time, instead of the derivative.
- **Response signal:** reports a single "velocity" from endpoints when `x(t)` is
  quadratic or higher.
- **Discriminating probe:** ask for `v(t)`, then evaluate at the instant.
- **Repair move:** "For a non-constant rate, differentiate: `v = dx/dt`, then
  evaluate at the instant you need."
- **Minimum fix:** differentiate rather than divide differences.

### E5 — misconception `grading_sensitive` (grading_only, repair_after_grade)

- **Misconception hypothesis:** the constant of integration / initial condition is
  dropped when integrating acceleration or velocity.
- **Response signal:** `v(t)` or `x(t)` omits `v₀`/`x₀`.
- **Repair move:** "Apply the initial condition to fix the constant of
  integration."

### E6 — boundary `grading_sensitive` (grading_only) — criterion "derivative/integral relationship applied correctly"

- **Required evidence:** the response uses `v = dx/dt` and `a = dv/dt` (or the
  correct integration with initial conditions), not constant-acceleration formulas
  on a non-constant-acceleration motion.
- **Accepted:** any correct differentiation/integration, in equivalent algebraic
  form (verified by symbolic equivalence).
- **Insufficient:** applying `v = v₀ + at` when `a` is not constant; omitting the
  initial condition on an integration.

## Views

- **authoring_view:** E1–E6, full fields.
- **learner_view:** E1, E2, E3 (post-attempt); excludes E4–E6 pre-attempt.
- **grading_view:** E2, E4, E5, E6.
