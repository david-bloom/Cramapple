# AP Physics C: Mechanics Unit 5 Topic Point Briefs

Status: Draft content addendum, pending QA/application.

Deployment state is deliberately NOT asserted here. The canonical runtime record
is the migration
`supabase/migrations/20260825142143_ap_physics_c_mechanics_unit5_torque_rotational_dynamics_topic_guides.sql`
and the `app.topic_point_briefs` / `app.topic_explainers` tables in each
environment.

Purpose: add paired topic point briefs and Learn More explainers for AP Physics
C: Mechanics Unit 5 (Torque and Rotational Dynamics). Before this addendum,
Production and Development both had taxonomy rows for all six Unit 5 topics but
zero published topic-guide pairs for the unit.

Source basis: `docs/product/AP_PHYSICS_C_MECHANICS_CED_FACT_PACK.md` Unit 5. The
batch is grounded in derivative definitions `omega = d theta/dt` and
`alpha = d omega/dt`, constant-angular-acceleration rotational kinematics,
`Delta s = r Delta theta`, `v = r omega`, `a_T = r alpha`, torque magnitude
`rF_perp = rF sin(theta)`, lever-arm reasoning, torque as `r cross F` with
right-hand-rule direction in scope, point-mass rotational inertia sums,
continuous-body `I = integral r^2 dm`, rotational equilibrium, and
`alpha_sys = tau_net/I_sys`. The content preserves the Physics C: Mechanics
boundary that rotational-kinematics vector directions are limited to CW/CCW with
respect to a chosen axis, while torque vector direction is assessable; it also
preserves the no simultaneous multiple-plane rotation boundary.

## Coverage

| Topic | Title | Guide state |
|---|---|---|
| 5.1 | Rotational Kinematics | point brief + Learn More explainer |
| 5.2 | Connecting Linear and Rotational Motion | point brief + Learn More explainer |
| 5.3 | Torque | point brief + Learn More explainer |
| 5.4 | Rotational Inertia | point brief + Learn More explainer |
| 5.5 | Rotational Equilibrium and Newton's First Law in Rotational Form | point brief + Learn More explainer |
| 5.6 | Newton's Second Law in Rotational Form | point brief + Learn More explainer |

## Content Notes

- 5.1 emphasizes derivative/integral reasoning and avoids constant-alpha
  equations when angular acceleration varies.
- 5.2 separates shared angular quantities from point-specific linear quantities
  and treats `a_T = r alpha` as tangential acceleration only.
- 5.3 emphasizes Physics C torque as a vector cross product with right-hand-rule
  direction, not just CW/CCW tendency.
- 5.4 emphasizes axis choice and continuous-body rotational inertia integrals.
- 5.5 keeps translational and rotational equilibrium as separate conditions.
- 5.6 emphasizes matching torque and rotational inertia to the same axis and
  using constraints only when the geometry justifies them.
- The Learn More mini-examples are Cramapple-original and avoid copied released
  or official prompt language.
