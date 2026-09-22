# AP Chemistry Unit 6 Topic Point Briefs

Status: Draft content addendum, pending QA/application.

Deployment state is deliberately NOT asserted here. The canonical runtime record
is the migration
`supabase/migrations/20260826130523_ap_chemistry_unit6_thermochemistry_topic_guides.sql`
and the `app.topic_point_briefs` / `app.topic_explainers` tables in each
environment.

Purpose: add paired topic point briefs and Learn More explainers for AP
Chemistry Unit 6 (Thermochemistry). Before this addendum, Production had
taxonomy rows for all nine Unit 6 topics but zero published topic-guide pairs
for the unit.

Source basis: `docs/product/AP_CHEMISTRY_CED_FACT_PACK.md` Unit 6. The batch is
grounded in endothermic/exothermic processes, energy diagrams, heat transfer and
thermal equilibrium, `q = mc Delta T`, calorimetry sign conventions,
phase-change energy, reaction enthalpy at constant pressure, bond enthalpy
estimates, enthalpy of formation, Hess's law, and the 2025 FRQ Q3 misconception
trail for significant figures, total solution mass, exothermic sign,
limiting-reactant heat release, and checking Hess-law equation sums before
adding `Delta H` values.

## Coverage

| Topic | Title | Guide state |
|---|---|---|
| 6.1 | Endothermic and Exothermic Processes | point brief + Learn More explainer |
| 6.2 | Energy Diagrams | point brief + Learn More explainer |
| 6.3 | Heat Transfer and Thermal Equilibrium | point brief + Learn More explainer |
| 6.4 | Heat Capacity and Calorimetry | point brief + Learn More explainer |
| 6.5 | Energy of Phase Changes | point brief + Learn More explainer |
| 6.6 | Introduction to Enthalpy of Reaction | point brief + Learn More explainer |
| 6.7 | Bond Enthalpies | point brief + Learn More explainer |
| 6.8 | Enthalpy of Formation | point brief + Learn More explainer |
| 6.9 | Hess's Law | point brief + Learn More explainer |

## Content Notes

- 6.1 anchors signs in system-surroundings energy flow.
- 6.2 reads endothermic/exothermic character from product versus reactant energy.
- 6.3 distinguishes equal temperature from equal total thermal energy.
- 6.4 uses the documented total-solution-mass, sign, and significant-figures
  pitfalls from 2025 FRQ Q3.
- 6.5 separates phase-change plateaus from `q = mc Delta T` temperature-change
  regions.
- 6.6 reports reaction enthalpy from the system perspective.
- 6.7 uses broken-minus-formed bond enthalpy reasoning.
- 6.8 uses products-minus-reactants formation enthalpy setup with coefficients.
- 6.9 uses the documented Hess-law equation-summing misconception from 2025 FRQ
  Q3.
- The Learn More mini-examples are Cramapple-original and avoid copied released
  or official prompt language.
