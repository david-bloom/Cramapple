# AP Physics 2 Unit 10 Topic Point Briefs

Status: Draft content addendum, pending QA/application.

Deployment state is deliberately NOT asserted here. The canonical runtime record
is the migration
`supabase/migrations/20260825213049_ap_physics_2_unit10_electric_force_field_potential_topic_guides.sql`
and the `app.topic_point_briefs` / `app.topic_explainers` tables in each
environment.

Purpose: add paired topic point briefs and Learn More explainers for AP Physics
2 Unit 10 (Electric Force, Field, and Potential). Before this addendum,
Production and Development both had taxonomy rows for all seven Unit 10 topics
but zero published topic-guide pairs for the unit.

Source basis: `docs/product/AP_PHYSICS_2_CED_FACT_PACK.md` Unit 10. The batch is
grounded in electric charge, Coulomb law, conductors and insulators, charge
conservation, charging by friction/contact/induction/grounding, electric fields,
field-line maps, electrostatic-equilibrium conductor behavior, electric
potential energy, electric potential, equipotential lines, parallel-plate
capacitors, capacitor energy, dielectrics, and conservation of electric energy.
It preserves the fact-pack boundaries: four-or-fewer charge calculations unless
symmetry is present, qualitative-only field analysis inside insulators, no
extended-charge potential-energy calculations, and required capacitor analysis
limited to parallel plates with edge effects ignored unless explicitly stated.

## Coverage

| Topic | Title | Guide state |
|---|---|---|
| 10.1 | Electric Charge and Electric Force | point brief + Learn More explainer |
| 10.2 | Conservation of Electric Charge and the Process of Charging | point brief + Learn More explainer |
| 10.3 | Electric Fields | point brief + Learn More explainer |
| 10.4 | Electric Potential Energy | point brief + Learn More explainer |
| 10.5 | Electric Potential | point brief + Learn More explainer |
| 10.6 | Capacitors | point brief + Learn More explainer |
| 10.7 | Conservation of Electric Energy | point brief + Learn More explainer |

## Content Notes

- 10.1 separates Coulomb-law magnitude from force direction based on charge
  signs.
- 10.2 distinguishes charge transfer from polarization and grounding.
- 10.3 uses a positive test charge for field direction and preserves conductor
  equilibrium facts.
- 10.4 emphasizes signed pairwise electric potential energy.
- 10.5 treats potential as a signed scalar and equipotentials as perpendicular
  to electric-field vectors.
- 10.6 keeps capacitor reasoning within parallel-plate scope and emphasizes
  fixed-charge versus fixed-voltage cases.
- 10.7 uses signed `Delta U_E = q Delta V` before applying energy conservation.
- The Learn More mini-examples are Cramapple-original and avoid copied released
  or official prompt language.
