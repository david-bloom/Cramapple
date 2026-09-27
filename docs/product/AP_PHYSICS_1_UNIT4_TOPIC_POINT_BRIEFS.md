# AP Physics 1 Unit 4 Topic Point Briefs

Status: Draft content addendum, pending QA/application.

Deployment state is deliberately NOT asserted here. The canonical runtime record
is the migration
`supabase/migrations/20260825132818_ap_physics_1_unit4_topic_guides.sql` and the
`app.topic_point_briefs` / `app.topic_explainers` tables in each environment.

Purpose: add paired topic point briefs and Learn More explainers for AP Physics
1 Unit 4 (Linear Momentum). Before this addendum, Production and Development
both had taxonomy rows for all four Unit 4 topics but zero published topic-guide
pairs for the unit.

Source basis: `docs/product/AP_PHYSICS_1_CED_FACT_PACK.md` Unit 4. The batch is
grounded in linear momentum `p = mv`, impulse as `delta p` and force-time graph
area, conservation of system momentum when net external impulse is zero, AP
Physics 1's one-dimensional quantitative / two-dimensional semiquantitative
momentum boundary, center-of-mass invariance, and elastic/inelastic collision
classification by kinetic-energy behavior.

## Coverage

| Topic | Title | Guide state |
|---|---|---|
| 4.1 | Linear Momentum | point brief + Learn More explainer |
| 4.2 | Change in Momentum and Impulse | point brief + Learn More explainer |
| 4.3 | Conservation of Linear Momentum | point brief + Learn More explainer |
| 4.4 | Elastic and Inelastic Collisions | point brief + Learn More explainer |

## Content Notes

- 4.1 emphasizes momentum as a signed/vector quantity, not a magnitude-only
  number.
- 4.2 emphasizes impulse as change in momentum and force-time graph area, not
  momentum itself.
- 4.3 emphasizes system selection and external impulse before using conservation.
- 4.4 separates momentum conservation from kinetic-energy conservation when
  classifying elastic, inelastic, and perfectly inelastic collisions.
- The Learn More mini-examples are Cramapple-original and avoid copied released
  or official prompt language.
