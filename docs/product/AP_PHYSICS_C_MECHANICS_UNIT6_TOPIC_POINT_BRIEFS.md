# AP Physics C: Mechanics Unit 6 Topic Point Briefs

Status: Draft content addendum, pending QA/application.

Deployment state is deliberately NOT asserted here. The canonical runtime record
is the migration
`supabase/migrations/20260825142708_ap_physics_c_mechanics_unit6_rotating_systems_topic_guides.sql`
and the `app.topic_point_briefs` / `app.topic_explainers` tables in each
environment.

Purpose: add paired topic point briefs and Learn More explainers for AP Physics
C: Mechanics Unit 6 (Energy and Momentum of Rotating Systems). Before this
addendum, Production and Development both had taxonomy rows for all six Unit 6
topics but zero published topic-guide pairs for the unit.

Source basis: `docs/product/AP_PHYSICS_C_MECHANICS_CED_FACT_PACK.md` Unit 6. The
batch is grounded in rotational kinetic energy `K_rot = 1/2 I omega^2`, total
kinetic energy as translational plus rotational terms, torque work
`W = integral tau dtheta`, torque-vs-angle area, angular momentum as `I omega`
and vector `r cross p`, angular impulse as `integral tau dt` and `Delta L`,
angular momentum conservation, rolling-without-slipping constraints, slipping
analysis with kinetic-friction energy loss, circular and elliptical satellite
energy/angular-momentum behavior, `U = -GMm/r`, circular-orbit `K = -1/2 U` and
`E_total = -GMm/2r`, and escape-speed energy reasoning. The content preserves
Physics C: Mechanics scope: angular momentum and angular impulse vector direction
are in scope, rolling friction is out of scope, and the AP Physics 1 qualitative-
only slipping boundary does not apply here.

## Coverage

| Topic | Title | Guide state |
|---|---|---|
| 6.1 | Rotational Kinetic Energy | point brief + Learn More explainer |
| 6.2 | Torque and Work | point brief + Learn More explainer |
| 6.3 | Angular Momentum and Angular Impulse | point brief + Learn More explainer |
| 6.4 | Conservation of Angular Momentum | point brief + Learn More explainer |
| 6.5 | Rolling | point brief + Learn More explainer |
| 6.6 | Motion of Orbiting Satellites | point brief + Learn More explainer |

## Content Notes

- 6.1 emphasizes including translational and rotational kinetic energy for rigid
  systems that both translate and rotate.
- 6.2 distinguishes torque-angle work from torque-time angular impulse.
- 6.3 emphasizes full vector angular momentum and angular impulse treatment,
  including reference point and right-hand-rule direction.
- 6.4 emphasizes conserving total system angular momentum only after checking
  external torque about the chosen axis.
- 6.5 separates rolling without slipping from slipping and allows Physics C
  quantitative force/torque slipping analysis when supported by the prompt.
- 6.6 distinguishes circular and elliptical orbit constants and uses the zero of
  gravitational potential energy at infinite separation.
- The Learn More mini-examples are Cramapple-original and avoid copied released
  or official prompt language.
