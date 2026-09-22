# AP Physics C: Electricity and Magnetism Unit 9 Topic Point Briefs

Status: Draft content addendum, pending QA/application.

Deployment state is deliberately NOT asserted here. The canonical runtime record
is the migration
`supabase/migrations/20260825132113_ap_physics_c_em_unit9_topic_guides.sql` and
the `app.topic_point_briefs` / `app.topic_explainers` tables in each environment.

Purpose: add paired topic point briefs and Learn More explainers for AP Physics
C: Electricity and Magnetism Unit 9 (Electric Potential). Before this addendum,
Production and Development both had taxonomy rows for all three Unit 9 topics but
zero published topic-guide pairs for the unit.

Source basis: `docs/product/AP_PHYSICS_C_EM_CED_FACT_PACK.md` Unit 9. The batch
is grounded in electric potential energy `U = k q1 q2 / r`, scalar potential
superposition `V = kq/r`, potential difference via `deltaV = - integral E dot dr`,
energy change `deltaU = q deltaV`, the approved potential-integration geometry
boundary, and the vector-field/scalar-potential contrast.

## Coverage

| Topic | Title | Guide state |
|---|---|---|
| 9.1 | Electric Potential Energy | point brief + Learn More explainer |
| 9.2 | Electric Potential | point brief + Learn More explainer |
| 9.3 | Conservation of Electric Energy | point brief + Learn More explainer |

## Content Notes

- 9.1 emphasizes signed pair energy and scalar pair summation, not force-vector
  reasoning.
- 9.2 emphasizes potential as signed scalar superposition and contrasts it with
  electric field vector cancellation.
- 9.3 emphasizes `deltaU = q deltaV` before judging kinetic-energy changes,
  especially the sign difference for positive versus negative charges.
- The Learn More mini-examples are Cramapple-original and avoid copied released
  or official prompt language.
