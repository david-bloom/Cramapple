# AP Physics 1 Unit 7 Topic Point Briefs

Status: Draft content addendum, pending QA/application.

Deployment state is deliberately NOT asserted here. The canonical runtime record
is the migration
`supabase/migrations/20260825134141_ap_physics_1_unit7_oscillations_topic_guides.sql` and the
`app.topic_point_briefs` / `app.topic_explainers` tables in each environment.

Purpose: add paired topic point briefs and Learn More explainers for AP Physics
1 Unit 7 (Oscillations). Before this addendum, Production and Development both
had taxonomy rows for all four Unit 7 topics but zero published topic-guide
pairs for the unit.

Source basis: `docs/product/AP_PHYSICS_1_CED_FACT_PACK.md` Unit 7. The batch is
grounded in SHM as periodic motion from a restoring force proportional to and
opposite displacement from equilibrium, `T = 1/f`, spring-object and small-angle
pendulum period equations, sinusoidal SHM representations, amplitude-independent
period behavior, graph extrema/zeros, and oscillator energy exchange with
`E_total = 1/2 k A^2` for spring-object systems.

## Coverage

| Topic | Title | Guide state |
|---|---|---|
| 7.1 | Defining Simple Harmonic Motion (SHM) | point brief + Learn More explainer |
| 7.2 | Frequency and Period of SHM | point brief + Learn More explainer |
| 7.3 | Representing and Analyzing SHM | point brief + Learn More explainer |
| 7.4 | Energy of Simple Harmonic Oscillators | point brief + Learn More explainer |

## Content Notes

- 7.1 distinguishes any periodic motion from SHM by requiring a restoring force
  proportional to displacement and directed toward equilibrium.
- 7.2 emphasizes oscillator-type selection, reciprocal period/frequency, square
  roots in the period formulas, and amplitude not being part of the ideal SHM
  period equations.
- 7.3 emphasizes graph reading: amplitude vertically, period horizontally, and
  maxima/zeros for displacement, velocity, and acceleration.
- 7.4 emphasizes conservation of total mechanical energy, K/U exchange, and the
  squared-amplitude relationship for spring-object oscillator energy.
- The Learn More mini-examples are Cramapple-original and avoid copied released
  or official prompt language.
