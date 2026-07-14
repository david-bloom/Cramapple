# Fact Pack FP-PHYS1-2.1-01 — Newton's Second Law and Kinematics

**Pack ID:** FP-PHYS1-2.1-01
**Pack-Version:** v01
**State:** Drafted
**Subject:** PHYS1
**Applies to:** [PHYS1]
**Unit / Topic:** Force and Translational Dynamics — Newton's second law with
constant-acceleration kinematics *(confirm exact official unit/topic id against
the current AP Physics 1 CED before Approved; the framework was revised for recent
school years)*
**Author class:** ai_draft_human_reviewed (illustrative format example)
**Source status:** cramapple_authored
**Official-material boundary checked:** yes — established public-domain physics in
original wording
**Status note:** Illustrative Draft. NOT production content, NOT calibration
evidence.

> Format reference: `docs/product/FACT_PACKS_AND_QUESTION_SETS.md` §4.

## Entries

### E1 — concept `teaching_safe` (learner_visible_summary, authoring_brief)

Newton's second law states that the net force on an object equals its mass times
its acceleration. Acceleration is caused by the **net** (total) force, not any
single applied force. Once acceleration is known and constant, the kinematics
equations relate position, velocity, time, and acceleration.

### E2 — formula_rule `teaching_safe` (grading_only, learner_visible_summary, authoring_brief)

- **Newton's second law:** `F_net = m·a` (vector sum of all forces).
- **Weight:** `W = m·g`, with `g ≈ 9.8 m/s²` (≈ 10 for estimation).
- **Friction:** `f = μ·N` (N = normal force).
- **Kinematics (constant a):** `v = v₀ + a·t`; `x = x₀ + v₀·t + ½·a·t²`;
  `v² = v₀² + 2·a·Δx`.

### E3 — method `teaching_after_attempt` (grading_only, authoring_brief)

Ordered procedure for a dynamics problem:

```text
1. Draw a free-body diagram; label every force.
2. Choose axes and resolve forces into components.
3. Sum forces per axis and set equal to m·a (Newton's second law).
4. Solve for the unknown (a, a force, or the normal force).
5. If motion over time/distance is asked, feed a into the kinematics equations.
6. Check units and direction (sign).
```

### E4 — misconception `grading_sensitive` (grading_only, repair_after_grade)

- **Misconception hypothesis:** the student uses an applied force in place of the
  **net** force (ignores friction or opposing forces).
- **Response signal:** sets `a = F_applied / m` when other forces act.
- **Discriminating probe:** ask for the free-body diagram and the sum of forces.
- **Repair move:** "Use the net force — subtract friction and other opposing
  forces before dividing by mass."
- **Minimum fix:** compute `F_net` first, then `a = F_net / m`.

### E5 — misconception `grading_sensitive` (grading_only, repair_after_grade)

- **Misconception hypothesis:** mass and weight are treated as the same quantity.
- **Response signal:** uses the mass (kg) directly as a force (N), or vice versa.
- **Repair move:** "Weight is a force, `W = m·g`; mass is in kilograms."

### E6 — boundary `grading_sensitive` (grading_only) — criterion "net force used correctly"

- **Required evidence:** the response identifies all forces and uses their vector
  sum (net force) in `F_net = m·a`.
- **Accepted:** any correct net-force computation, including correct sign/direction
  handling.
- **Insufficient:** dividing a single applied force by mass while other forces act;
  omitting friction/normal contributions that the scenario specifies.

## Views

- **authoring_view:** E1–E6, full fields.
- **learner_view:** E1, E2, E3 (post-attempt); excludes E4–E6 pre-attempt.
- **grading_view:** E2, E4, E5, E6.
