# AP Physics 1 Unit 8 Topic Point Briefs

Status: Draft content addendum, pending QA/application.

Deployment state is deliberately NOT asserted here. The canonical runtime record
is the migration
`supabase/migrations/20260825134642_ap_physics_1_unit8_fluids_topic_guides.sql` and the
`app.topic_point_briefs` / `app.topic_explainers` tables in each environment.

Purpose: add paired topic point briefs and Learn More explainers for AP Physics
1 Unit 8 (Fluids). Before this addendum, Production and Development both had
taxonomy rows for all four Unit 8 topics but zero published topic-guide pairs
for the unit.

Source basis: `docs/product/AP_PHYSICS_1_CED_FACT_PACK.md` Unit 8. The batch is
grounded in density `rho = m/V`, ideal-fluid assumptions of incompressibility
and no viscosity, pressure as `P = F_perp/A`, hydrostatic pressure
`P = P0 + rho gh`, gauge pressure `rho gh`, buoyant force as displaced-fluid
weight, continuity `A1 v1 = A2 v2`, Bernoulli's equation, Torricelli's theorem,
and the ideal-fluid / completely filled pipe boundary. The fact pack explicitly
notes that no released FRQ-level Fluids misconception evidence was available in
the checked sources, so this batch avoids released-exam pattern claims.

## Coverage

| Topic | Title | Guide state |
|---|---|---|
| 8.1 | Internal Structure and Density | point brief + Learn More explainer |
| 8.2 | Pressure | point brief + Learn More explainer |
| 8.3 | Fluids and Newton's Laws | point brief + Learn More explainer |
| 8.4 | Fluids and Conservation Laws | point brief + Learn More explainer |

## Content Notes

- 8.1 emphasizes density as a ratio and the two-part ideal-fluid model:
  incompressible and nonviscous.
- 8.2 emphasizes perpendicular force per area, scalar pressure, and absolute
  versus gauge pressure.
- 8.3 emphasizes Newton's-law force diagrams and buoyant force as displaced
  fluid weight, not object weight by default.
- 8.4 emphasizes when to use continuity, Bernoulli, and Torricelli, including
  the ideal-fluid and filled-pipe assumptions.
- The Learn More mini-examples are Cramapple-original and avoid copied released
  or official prompt language.
