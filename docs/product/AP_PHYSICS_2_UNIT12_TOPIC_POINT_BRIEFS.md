# AP Physics 2 Unit 12 Topic Point Briefs

Status: Draft content addendum, pending QA/application.

Deployment state is deliberately NOT asserted here. The canonical runtime record
is the migration
`supabase/migrations/20260825135101_ap_physics_2_unit12_magnetism_topic_guides.sql` and the
`app.topic_point_briefs` / `app.topic_explainers` tables in each environment.

Purpose: add paired topic point briefs and Learn More explainers for AP Physics
2 Unit 12 (Magnetism and Electromagnetism). Before this addendum, Production
and Development both had taxonomy rows for all four Unit 12 topics but zero
published topic-guide pairs for the unit.

Source basis: `docs/product/AP_PHYSICS_2_CED_FACT_PACK.md` Unit 12. The batch is
grounded in magnetic dipoles and field maps, the no-monopole model, material
magnetism, magnetic force `FB = qvB sin(theta)` and its 0/90/180 degree
quantitative boundary, magnetic fields and forces for current-carrying wires,
vector addition of magnetic fields, magnetic flux `PhiB = BA cos(theta)`,
Faraday's law, Lenz's law, and motional emf `E = Blv`.

## Coverage

| Topic | Title | Guide state |
|---|---|---|
| 12.1 | Magnetic Fields | point brief + Learn More explainer |
| 12.2 | Magnetism and Moving Charges | point brief + Learn More explainer |
| 12.3 | Magnetism and Current-Carrying Wires | point brief + Learn More explainer |
| 12.4 | Electromagnetic Induction and Faraday's Law | point brief + Learn More explainer |

## Content Notes

- 12.1 emphasizes dipoles, closed-loop field lines, material response, and the
  no-monopole misconception.
- 12.2 emphasizes force direction from the right-hand rule, charge sign, angle
  dependence, and separate electric/magnetic forces.
- 12.3 emphasizes circular field geometry around straight wires, `B` scaling
  with `I/r`, and vector addition of wire fields.
- 12.4 emphasizes magnetic flux change, area-vector reasoning, Faraday's law,
  and Lenz's law direction from opposing the change.
- The Learn More mini-examples are Cramapple-original and avoid copied released
  or official prompt language.
