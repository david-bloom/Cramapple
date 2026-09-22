# AP Physics 2 Unit 13 Topic Point Briefs

Status: Draft content addendum, pending QA/application.

Deployment state is deliberately NOT asserted here. The canonical runtime record
is the migration
`supabase/migrations/20260825135534_ap_physics_2_unit13_geometric_optics_topic_guides.sql` and the
`app.topic_point_briefs` / `app.topic_explainers` tables in each environment.

Purpose: add paired topic point briefs and Learn More explainers for AP Physics
2 Unit 13 (Geometric Optics). Before this addendum, Production and Development
both had taxonomy rows for all four Unit 13 topics but zero published
topic-guide pairs for the unit.

Source basis: `docs/product/AP_PHYSICS_2_CED_FACT_PACK.md` Unit 13. The batch is
grounded in the ray model and wavefronts, the law of reflection,
diffuse/specular reflection, plane/concave/convex spherical mirror scope, mirror
equation and magnification, refraction from light-speed changes, `n = c/v`,
Snell's law, total internal reflection and critical angle, thin convex/concave
lens scope, thin-lens equation, magnification, and ray-diagram image
classification. The fact pack explicitly notes that no released FRQ-level Unit
13 misconception evidence was available in the checked 2025/2026 sources, so
this batch avoids released-exam pattern claims.

## Coverage

| Topic | Title | Guide state |
|---|---|---|
| 13.1 | Reflection | point brief + Learn More explainer |
| 13.2 | Images Formed by Mirrors | point brief + Learn More explainer |
| 13.3 | Refraction | point brief + Learn More explainer |
| 13.4 | Images Formed by Lenses | point brief + Learn More explainer |

## Content Notes

- 13.1 emphasizes the normal line as the angle reference and distinguishes
  specular from diffuse reflection.
- 13.2 emphasizes actual versus apparent ray intersections, mirror scope,
  principal rays, mirror equation, and magnification.
- 13.3 emphasizes index comparison, Snell's law, angle measurement from the
  normal, and high-to-low-index conditions for total internal reflection.
- 13.4 emphasizes transmitted/refracted lens rays, convex/concave lens behavior,
  thin-lens equation, magnification, and real/virtual classification.
- The Learn More mini-examples are Cramapple-original and avoid copied released
  or official prompt language.
