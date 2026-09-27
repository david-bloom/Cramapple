# AP Physics 1 Unit 6 Topic Point Briefs

Status: Draft content addendum, pending QA/application.

Deployment state is deliberately NOT asserted here. The canonical runtime record
is the migration
`supabase/migrations/20260825141535_ap_physics_1_unit6_rotating_systems_topic_guides.sql` and the
`app.topic_point_briefs` / `app.topic_explainers` tables in each environment.

Purpose: add paired topic point briefs and Learn More explainers for AP Physics
1 Unit 6 (Energy and Momentum of Rotating Systems). Before this addendum,
Production and Development both had taxonomy rows for all six Unit 6 topics but
zero published topic-guide pairs for the unit.

Source basis: `docs/product/AP_PHYSICS_1_CED_FACT_PACK.md` Unit 6. The batch is
grounded in rotational kinetic energy `K = 1/2 I omega^2`, total kinetic energy
as translational plus rotational terms, torque work `W = tau Delta theta`, area
under torque-vs-angle and torque-vs-time graphs, angular momentum magnitudes
`L = I omega` and `L = rmv sin(theta)`, angular impulse as `Delta L`, angular
momentum conservation, rolling-without-slipping constraints, qualitative slipping
reasoning, satellite orbital energy behavior, `U_g = -Gm1m2/r`, and escape-speed
energy reasoning. The content preserves AP Physics 1 scope boundaries: angular
momentum and angular impulse vector direction are out of scope, rolling friction
is out of scope, and slipping rolling is qualitative rather than quantitative.

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

- 6.1 emphasizes including both translational and rotational kinetic energy when
  a rigid object both translates and rotates.
- 6.2 distinguishes torque-angle work from torque-time angular impulse.
- 6.3 emphasizes the reference axis or point and keeps angular momentum direction
  within AP Physics 1 one-dimensional sign conventions.
- 6.4 emphasizes conserving total angular momentum, not angular speed, when
  rotational inertia changes.
- 6.5 separates rolling without slipping from slipping and avoids quantitative
  slipping kinematics beyond course scope.
- 6.6 distinguishes circular and elliptical orbit constants and uses the zero of
  gravitational potential energy at infinite separation.
- The Learn More mini-examples are Cramapple-original and avoid copied released
  or official prompt language.
