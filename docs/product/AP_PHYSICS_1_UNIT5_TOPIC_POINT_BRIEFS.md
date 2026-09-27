# AP Physics 1 Unit 5 Topic Point Briefs

Status: Draft content addendum, pending QA/application.

Deployment state is deliberately NOT asserted here. The canonical runtime record
is the migration
`supabase/migrations/20260825140904_ap_physics_1_unit5_torque_rotational_dynamics_topic_guides.sql` and the
`app.topic_point_briefs` / `app.topic_explainers` tables in each environment.

Purpose: add paired topic point briefs and Learn More explainers for AP Physics
1 Unit 5 (Torque and Rotational Dynamics). Before this addendum, Production and
Development both had taxonomy rows for all six Unit 5 topics but zero published
topic-guide pairs for the unit.

Source basis: `docs/product/AP_PHYSICS_1_CED_FACT_PACK.md` Unit 5. The batch is
grounded in rotational kinematics analogs, `s = r theta`, `v = r omega`,
`a_T = r alpha`, torque magnitude `rF_perp = rF sin(theta)`, lever arm reasoning,
point-mass rotational inertia and the parallel-axis theorem, rotational
equilibrium, and `alpha = tau_net/I`. The content preserves AP Physics 1 scope
boundaries: CW/CCW direction descriptions, torque-vector direction out of scope,
five-or-fewer point-mass inertia calculations, provided extended-body inertias,
and no multiple-plane rotation analysis.

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

- 5.1 emphasizes axis choice, radians, and CW/CCW sign consistency.
- 5.2 separates shared angular quantities from point-specific linear quantities.
- 5.3 emphasizes lever arm and perpendicular force component, without torque
  vector direction beyond Physics 1 scope.
- 5.4 emphasizes mass distribution and per-object `m r^2` contributions.
- 5.5 keeps translational and rotational equilibrium as separate conditions.
- 5.6 emphasizes `tau_net/I` for angular acceleration and independent rotational
  analysis when needed.
- The Learn More mini-examples are Cramapple-original and avoid copied released
  or official prompt language.
