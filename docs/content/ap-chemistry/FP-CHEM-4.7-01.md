# Fact Pack FP-CHEM-4.7-01 — Stoichiometry and the Ideal Gas Law

**Pack ID:** FP-CHEM-4.7-01
**Pack-Version:** v01
**State:** Drafted
**Subject:** CHEM
**Applies to:** [CHEM]
**Unit / Topic:** Unit 4 (Chemical Reactions) — mole ratios, limiting reactant,
and gas stoichiometry *(confirm exact official topic id against the current AP
Chemistry CED before Approved)*
**Author class:** ai_draft_human_reviewed (illustrative format example)
**Source status:** cramapple_authored
**Official-material boundary checked:** yes — no official question text, scoring
material, or figures used; content is established public-domain chemistry in
original wording
**Status note:** Illustrative Draft demonstrating the fact-pack format. NOT
production content, NOT calibration evidence. Subject to replacement by
tutor-authored, Learning-Quality-reviewed material.

> Format reference: `docs/product/FACT_PACKS_AND_QUESTION_SETS.md` §4.

## Entries

### E1 — concept `teaching_safe` (learner_visible_summary, authoring_brief)

A balanced chemical equation gives whole-number **mole ratios** between species.
Stoichiometry uses those ratios to convert between amounts (in moles) of any two
species in a reaction. Mass is converted to moles with molar mass; a gas amount
can be related to volume, pressure, and temperature through the ideal gas law.

### E2 — formula_rule `teaching_safe` (grading_only, learner_visible_summary, authoring_brief)

- Moles from mass: `n = m / M`, where `M` is molar mass (g·mol⁻¹).
- Mole ratio: from balanced coefficients, `n_B = n_A × (coeff_B / coeff_A)`.
- Ideal gas law: `PV = nRT`, with `R = 0.08206 L·atm·mol⁻¹·K⁻¹` (use
  `8.314 J·mol⁻¹·K⁻¹` for energy units). Temperature must be in kelvin.
- Molar volume of an ideal gas at STP (0 °C, 1 atm) ≈ `22.4 L·mol⁻¹`.

### E3 — method `teaching_after_attempt` (grading_only, authoring_brief)

Ordered procedure that typically earns full credit on a gas-stoichiometry item:

```text
1. Balance the equation.
2. Convert the given quantity to moles (mass ÷ molar mass, or PV = nRT).
3. Apply the mole ratio from the balanced coefficients.
4. Convert the result to the requested unit (grams, liters, molecules, or a
   pressure/volume via PV = nRT).
5. Check units and significant figures.
```

### E4 — misconception `grading_sensitive` (grading_only, repair_after_grade)

- **Misconception hypothesis:** the student uses the *mass* ratio (or coefficient
  ratio applied to grams) instead of the *mole* ratio.
- **Response signal:** multiplies grams of A by a coefficient ratio without first
  dividing by molar mass.
- **Discriminating probe:** ask for the amount in moles as an intermediate step.
- **Repair move:** "Convert to moles before using the coefficient ratio —
  coefficients relate moles, not grams."
- **Minimum fix:** insert the `n = m / M` step before the ratio.

### E5 — misconception `grading_sensitive` (grading_only, repair_after_grade)

- **Misconception hypothesis:** temperature left in °C in `PV = nRT`.
- **Response signal:** uses a Celsius value for T.
- **Repair move:** "Convert to kelvin: `T(K) = T(°C) + 273.15`."

### E6 — boundary `grading_sensitive` (grading_only) — criterion "limiting reactant identified"

- **Required evidence:** the response computes the available moles of *each*
  reactant, divides by its coefficient, and identifies the smallest result as
  the limiting reactant.
- **Accepted:** any correct method that compares per-coefficient mole
  availability (e.g. moles ÷ coefficient, or "moles of product each reactant
  could make").
- **Insufficient:** naming the reactant with the smaller *mass* or smaller
  *moles* without dividing by its coefficient; asserting the limiting reactant
  with no comparison shown.

## Views

- **authoring_view:** E1–E6 (all entries), full fields — feeds MCQ/short-FRQ
  authoring for this topic.
- **learner_view:** E1, E2, E3 (post-attempt) — concept, formulas, and worked
  method; excludes E4–E6 pre-attempt (no answer leakage).
- **grading_view:** E2, E4, E5, E6 — formula rule and boundary/misconception
  entries the grader may use to interpret a response; adds no scoring criterion
  beyond the rubric.
