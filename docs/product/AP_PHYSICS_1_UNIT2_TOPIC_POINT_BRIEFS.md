# AP Physics 1 Unit 2 Topic Point Briefs

Status: Draft content addendum, pending QA/application.

Deployment state is deliberately NOT asserted here. The canonical runtime record
is the migration
`supabase/migrations/20260825143908_ap_physics_1_unit2_force_translational_dynamics_topic_guides.sql`
and the `app.topic_point_briefs` / `app.topic_explainers` tables in each
environment.

Purpose: add paired topic point briefs and Learn More explainers for AP Physics
1 Unit 2 (Force and Translational Dynamics). Before this addendum, Production
and Development both had taxonomy rows for all nine Unit 2 topics but zero
published topic-guide pairs for the unit.

Source basis: `docs/product/AP_PHYSICS_1_CED_FACT_PACK.md` Unit 2. The batch is
grounded in systems and center of mass, free-body diagram conventions, Newton's
laws, gravitational force/field/weight/apparent weight, kinetic and static
friction, Hooke's-law spring force, and circular-motion radial/tangential force
models. The content preserves AP Physics 1 scope boundaries: center-of-mass
calculation is capped to five or fewer particles or high symmetry; FBDs show
forces rather than components; massive-string tension is qualitative only;
action-at-distance forces are gravity-only; banked curves with friction are
qualitative only; Kepler's first and second laws are out of scope; circular
motion belongs in Unit 2 and satellite/orbital energy belongs in Unit 6.

## Coverage

| Topic | Title | Guide state |
|---|---|---|
| 2.1 | Systems and Center of Mass | point brief + Learn More explainer |
| 2.2 | Forces and Free-Body Diagrams | point brief + Learn More explainer |
| 2.3 | Newton's Third Law | point brief + Learn More explainer |
| 2.4 | Newton's First Law | point brief + Learn More explainer |
| 2.5 | Newton's Second Law | point brief + Learn More explainer |
| 2.6 | Gravitational Force | point brief + Learn More explainer |
| 2.7 | Kinetic and Static Friction | point brief + Learn More explainer |
| 2.8 | Spring Forces | point brief + Learn More explainer |
| 2.9 | Circular Motion | point brief + Learn More explainer |

## Content Notes

- 2.1 emphasizes system boundaries and mass-weighted averages within the AP
  Physics 1 center-of-mass calculation boundary.
- 2.2 preserves the FBD convention: draw real force arrows, not components.
- 2.3 separates third-law pairs from balanced forces on one object.
- 2.4 and 2.5 keep force equations tied to the same object or system.
- 2.6 separates mass, weight, gravitational field, and apparent weight.
- 2.7 emphasizes static friction as an inequality and not automatically maximum.
- 2.8 emphasizes displacement from equilibrium and restoring direction.
- 2.9 uses the documented vertical-loop normal-force misconception and rejects a
  fake separate centripetal-force arrow.
- The Learn More mini-examples are Cramapple-original and avoid copied released
  or official prompt language.
