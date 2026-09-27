# AP Physics C: Mechanics Unit 4 Topic Point Briefs

Status: Draft content addendum, pending QA/application.

Deployment state is deliberately NOT asserted here. The canonical runtime record
is the migration
`supabase/migrations/20260825133310_ap_physics_c_mechanics_unit4_topic_guides.sql`
and the `app.topic_point_briefs` / `app.topic_explainers` tables in each
environment.

Purpose: add paired topic point briefs and Learn More explainers for AP Physics
C: Mechanics Unit 4 (Linear Momentum). Before this addendum, Production and
Development both had taxonomy rows for all four Unit 4 topics but zero published
topic-guide pairs for the unit.

Source basis: `docs/product/AP_PHYSICS_C_MECHANICS_CED_FACT_PACK.md` Unit 4. The
batch is grounded in vector momentum `p = mv`, impulse as `integral F dt`,
`F_net = dp/dt`, variable-mass systems as in-scope, component-wise conservation
of system momentum in one- and two-dimensional collisions, and elastic/inelastic
collision classification by kinetic-energy behavior.

## Coverage

| Topic | Title | Guide state |
|---|---|---|
| 4.1 | Linear Momentum | point brief + Learn More explainer |
| 4.2 | Change in Momentum and Impulse | point brief + Learn More explainer |
| 4.3 | Conservation of Linear Momentum | point brief + Learn More explainer |
| 4.4 | Elastic and Inelastic Collisions | point brief + Learn More explainer |

## Content Notes

- 4.1 emphasizes vector/component momentum rather than magnitude-only addition.
- 4.2 emphasizes the calculus form of impulse and the documented difficulty of
  executing definite force-time integrals.
- 4.3 emphasizes full quantitative two-dimensional momentum conservation, which
  is in scope for Physics C: Mechanics.
- 4.4 separates momentum conservation from kinetic-energy conservation and uses
  kinetic energy only when the collision is elastic or classification requires it.
- The Learn More mini-examples are Cramapple-original and avoid copied released
  or official prompt language.
