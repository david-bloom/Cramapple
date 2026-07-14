# Fact Pack FP-PHYSCEM-1.1-01 — Coulomb's Law and the Electric Field

**Pack ID:** FP-PHYSCEM-1.1-01
**Pack-Version:** v01
**State:** Drafted
**Subject:** PHYSCEM
**Applies to:** [PHYSCEM]
**Unit / Topic:** Electrostatics — Coulomb's law, the electric field of a point
charge, and superposition *(confirm exact official unit/topic id against the
current AP Physics C: E&M CED before Approved)*
**Author class:** ai_draft_human_reviewed (illustrative format example)
**Source status:** cramapple_authored
**Official-material boundary checked:** yes — established public-domain physics in
original wording
**Status note:** Illustrative Draft. NOT production content, NOT calibration
evidence.

> Format reference: `docs/product/FACT_PACKS_AND_QUESTION_SETS.md` §4. Calculus-based
> — grading reuses the symbolic-equivalence verifier scoped in `TASK-0015`
> (Calculus); integral forms (e.g. Gauss's law) appear at this level.

## Entries

### E1 — concept `teaching_safe` (learner_visible_summary, authoring_brief)

Two point charges exert equal and opposite electrostatic forces on each other,
proportional to the product of the charges and inversely proportional to the
square of their separation (Coulomb's law). The electric field is the force per
unit charge a test charge would feel; the field of a point charge points radially
away from a positive charge and toward a negative charge. Fields from multiple
charges add as vectors (superposition).

### E2 — formula_rule `teaching_safe` (grading_only, learner_visible_summary, authoring_brief)

- **Coulomb's law:** `F = k·|q₁·q₂| / r²`, with `k ≈ 8.99 × 10⁹ N·m²/C²`.
- **Electric field of a point charge:** `E = k·|Q| / r² = F/q`.
- **Superposition:** the net field is the vector sum of the individual fields.
- **Gauss's law:** `∮ E·dA = Q_enc / ε₀` (useful for symmetric charge
  distributions).

### E3 — method `teaching_after_attempt` (grading_only, authoring_brief)

```text
1. Identify the source charge(s) and the point of interest.
2. Compute each field/force magnitude with k·Q/r² (or k·q₁q₂/r²).
3. Assign direction (away from +, toward −) and add as vectors.
4. For high symmetry, consider Gauss's law instead of direct summation.
5. Check units (N, N/C) and the inverse-square dependence.
```

### E4 — misconception `grading_sensitive` (grading_only, repair_after_grade)

- **Misconception hypothesis:** the student treats the distance dependence as
  linear (`1/r`) instead of inverse-square (`1/r²`).
- **Response signal:** halving the field when distance doubles (should quarter).
- **Discriminating probe:** ask how the force changes when separation doubles.
- **Repair move:** "Coulomb's law is inverse-**square**: doubling `r` divides the
  force by four."
- **Minimum fix:** use `1/r²`, not `1/r`.

### E5 — misconception `grading_sensitive` (grading_only, repair_after_grade)

- **Misconception hypothesis:** the electric field and the electric force are
  conflated (units N/C vs N).
- **Response signal:** reports a field in newtons, or omits dividing force by the
  test charge.
- **Repair move:** "Field is force per unit charge: `E = F/q` (N/C)."

### E6 — boundary `grading_sensitive` (grading_only) — criterion "inverse-square relationship applied correctly"

- **Required evidence:** the response uses `k·Q/r²` (or `k·q₁q₂/r²`) with the `r²`
  in the denominator and correct direction reasoning.
- **Accepted:** any correct inverse-square computation with proper direction/sign.
- **Insufficient:** a linear `1/r` dependence; a magnitude with no direction where
  the criterion requires it.

## Views

- **authoring_view:** E1–E6, full fields.
- **learner_view:** E1, E2, E3 (post-attempt); excludes E4–E6 pre-attempt.
- **grading_view:** E2, E4, E5, E6.
