# AP Physics C: Mechanics Unit 2 Topic Point Briefs

Status: Draft content addendum, pending QA/application.

Deployment state is deliberately NOT asserted here. The canonical runtime record
is the migration
`supabase/migrations/20260825143233_ap_physics_c_mechanics_unit2_force_translational_dynamics_topic_guides.sql`
and the `app.topic_point_briefs` / `app.topic_explainers` tables in each
environment.

Purpose: add paired topic point briefs and Learn More explainers for AP Physics
C: Mechanics Unit 2 (Force and Translational Dynamics). Before this addendum,
Production and Development both had taxonomy rows for all ten Unit 2 topics but
zero published topic-guide pairs for the unit.

Source basis: `docs/product/AP_PHYSICS_C_MECHANICS_CED_FACT_PACK.md` Unit 2. The
batch is grounded in system boundaries, discrete and continuous center of mass,
free-body diagram arrow conventions, Newton's laws, massive-string tension,
universal gravitation, gravitational field and apparent weight, shell-theorem
results, kinetic friction as an equality, static friction as an inequality,
spring forces and series/parallel equivalent constants, resistive-force
differential equations and terminal velocity, and circular-motion radial and
tangential force models. The content preserves Physics C: Mechanics scope:
continuous center-of-mass integrals, massive-string tension, resistive-force
separation-of-variables reasoning, and quantitative banked-curve/friction cases
are in scope; proving Newton's shell theorem and using Kepler's first or second
laws are not expected.

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
| 2.9 | Resistive Forces | point brief + Learn More explainer |
| 2.10 | Circular Motion | point brief + Learn More explainer |

## Content Notes

- 2.1 emphasizes system boundary choice and continuous center-of-mass integrals.
- 2.2 preserves the FBD convention: force arrows only, not component arrows.
- 2.3 separates third-law pairs from force balance and notes massive-string
  tension is not automatically uniform.
- 2.4 and 2.5 keep equilibrium and acceleration as component-specific claims.
- 2.6 separates gravitational force, gravitational field, weight, and apparent
  weight while keeping shell-theorem proof out of scope.
- 2.7 emphasizes static friction as an inequality, not automatic maximum static
  friction.
- 2.8 keeps series and parallel spring combinations distinct.
- 2.9 emphasizes differential-equation setup for velocity-dependent resistive
  forces and terminal velocity from net force zero.
- 2.10 treats centripetal acceleration as the radial net-force requirement, not
  a separate force.
- The Learn More mini-examples are Cramapple-original and avoid copied released
  or official prompt language.
