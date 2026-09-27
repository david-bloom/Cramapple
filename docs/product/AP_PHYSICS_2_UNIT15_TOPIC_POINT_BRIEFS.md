# AP Physics 2 Unit 15 Topic Point Briefs

Status: Draft content addendum, pending QA/application.

Deployment state is deliberately NOT asserted here. The canonical runtime record
is the migration
`supabase/migrations/20260825145507_ap_physics_2_unit15_modern_physics_topic_guides.sql`
and the `app.topic_point_briefs` / `app.topic_explainers` tables in each
environment.

Purpose: add paired topic point briefs and Learn More explainers for AP Physics
2 Unit 15 (Modern Physics). Before this addendum, Production and Development
both had taxonomy rows for all eight Unit 15 topics but zero published
topic-guide pairs for the unit.

Source basis: `docs/product/AP_PHYSICS_2_CED_FACT_PACK.md` Unit 15. The batch is
grounded in photon energy `E = hf`, `lambda = c/f`, de Broglie wavelength
`lambda = h/p`, wave-particle duality, discrete bound states, Bohr standing-wave
states, single-electron energy-level diagrams, emission and absorption spectra,
blackbody radiation with Wien and Stefan-Boltzmann reasoning, photoelectric
threshold and stopping-potential reasoning, Compton wavelength shift and 2-D
momentum expectations, nuclear conservation laws, mass-energy equivalence,
half-life equations, and radioactive-decay mode boundaries including the
Fall-2026 gamma clarification.

## Coverage

| Topic | Title | Guide state |
|---|---|---|
| 15.1 | Quantum Theory and Wave-Particle Duality | point brief + Learn More explainer |
| 15.2 | The Bohr Model of Atomic Structure | point brief + Learn More explainer |
| 15.3 | Emission and Absorption Spectra | point brief + Learn More explainer |
| 15.4 | Blackbody Radiation | point brief + Learn More explainer |
| 15.5 | The Photoelectric Effect | point brief + Learn More explainer |
| 15.6 | Compton Scattering | point brief + Learn More explainer |
| 15.7 | Fission, Fusion, and Nuclear Decay | point brief + Learn More explainer |
| 15.8 | Types of Radioactive Decay | point brief + Learn More explainer |

## Content Notes

- 15.1 separates photon relations from matter-wave de Broglie reasoning.
- 15.2 keeps Bohr-model language to allowed states, standing-wave circular
  orbits, and single-electron diagrams; it avoids orbital and probability
  function scope.
- 15.3 emphasizes exact energy-level differences for emission and absorption.
- 15.4 treats blackbody spectra as continuous and temperature dependent.
- 15.5 separates threshold frequency and maximum kinetic energy from intensity.
- 15.6 preserves photon speed at c while using energy, wavelength, and momentum
  changes after scattering.
- 15.7 emphasizes conservation laws before mass-energy or half-life calculations.
- 15.8 includes alpha, beta-minus, beta-plus, and gamma decay while excluding
  neutron emission, electron capture, isotope-specific memorization, neutrino
  type distinctions, and weak-force mechanism explanation.
- The Learn More mini-examples are Cramapple-original and avoid copied released
  or official prompt language.
