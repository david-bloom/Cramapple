# AP Physics C: Mechanics Unit 7 Topic Point Briefs

Status: Draft content addendum, pending QA/application.

Deployment state is deliberately NOT asserted here. The canonical runtime record
is the migration
`supabase/migrations/20260825140430_ap_physics_c_mechanics_unit7_oscillations_topic_guides.sql` and the
`app.topic_point_briefs` / `app.topic_explainers` tables in each environment.

Purpose: add paired topic point briefs and Learn More explainers for AP Physics
C: Mechanics Unit 7 (Oscillations). Before this addendum, Production and
Development both had taxonomy rows for all five Unit 7 topics but zero published
topic-guide pairs for the unit.

Source basis: `docs/product/AP_PHYSICS_C_MECHANICS_CED_FACT_PACK.md` Unit 7. The
batch is grounded in SHM from restoring force proportional to displacement,
`T = 2pi/omega = 1/f`, spring-object and small-angle pendulum periods,
sinusoidal position as a second-order differential-equation solution,
oscillator energy exchange and `E_total = 1/2 k A^2`, physical-pendulum torque
and small-angle derivation, and documented 2025 spring period/energy
mass-dependence misconceptions. The fact pack notes that topic 7.5 has no
released-FRQ misconception evidence in the checked sources, so that topic stays
CED-derivation grounded.

## Coverage

| Topic | Title | Guide state |
|---|---|---|
| 7.1 | Defining Simple Harmonic Motion (SHM) | point brief + Learn More explainer |
| 7.2 | Frequency and Period of SHM | point brief + Learn More explainer |
| 7.3 | Representing and Analyzing SHM | point brief + Learn More explainer |
| 7.4 | Energy of Simple Harmonic Oscillators | point brief + Learn More explainer |
| 7.5 | Simple and Physical Pendulums | point brief + Learn More explainer |

## Content Notes

- 7.1 emphasizes proving SHM from a linear restoring force, not naming repeated
  motion as SHM.
- 7.2 emphasizes reading `omega` from the differential equation before converting
  to period.
- 7.3 emphasizes phase, derivatives, and the sinusoidal solution to SHM.
- 7.4 separates period mass-dependence from spring energy at fixed amplitude.
- 7.5 emphasizes rotational dynamics, small-angle torque, physical-pendulum
  inertia, and center-of-mass distance from the pivot.
- The Learn More mini-examples are Cramapple-original and avoid copied released
  or official prompt language.
