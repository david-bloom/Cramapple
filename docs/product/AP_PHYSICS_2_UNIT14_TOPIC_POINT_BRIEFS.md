# AP Physics 2 Unit 14 Topic Point Briefs

Status: Draft content addendum, pending QA/application.

Deployment state is deliberately NOT asserted here. The canonical runtime record
is the migration
`supabase/migrations/20260825144510_ap_physics_2_unit14_waves_sound_physical_optics_topic_guides.sql`
and the `app.topic_point_briefs` / `app.topic_explainers` tables in each
environment.

Purpose: add paired topic point briefs and Learn More explainers for AP Physics
2 Unit 14 (Waves, Sound, and Physical Optics). Before this addendum, Production
and Development both had taxonomy rows for all nine Unit 14 topics but zero
published topic-guide pairs for the unit.

Source basis: `docs/product/AP_PHYSICS_2_CED_FACT_PACK.md` Unit 14. The batch is
grounded in wave energy transfer without matter transfer, mechanical versus
electromagnetic waves, periodic-wave quantities and `lambda = v/f`, boundary
behavior and unchanged frequency, polarization, electromagnetic spectrum
ordering, qualitative-only Doppler effect, interference, beats, standing waves,
diffraction, single-slit minima, double-slit interference, diffraction gratings,
thin-film phase shifts, and thin-film normal-incidence quantitative scope. The
2025 double-slit released-item evidence is used only as misconception grounding
for path-length-difference and fringe-spacing reasoning.

## Coverage

| Topic | Title | Guide state |
|---|---|---|
| 14.1 | Properties of Wave Pulses and Waves | point brief + Learn More explainer |
| 14.2 | Periodic Waves | point brief + Learn More explainer |
| 14.3 | Boundary Behavior of Waves and Polarization | point brief + Learn More explainer |
| 14.4 | Electromagnetic Waves | point brief + Learn More explainer |
| 14.5 | The Doppler Effect | point brief + Learn More explainer |
| 14.6 | Wave Interference and Standing Waves | point brief + Learn More explainer |
| 14.7 | Diffraction | point brief + Learn More explainer |
| 14.8 | Double-Slit Interference and Diffraction Gratings | point brief + Learn More explainer |
| 14.9 | Thin-Film Interference | point brief + Learn More explainer |

## Content Notes

- 14.1 distinguishes energy transfer from matter transfer and mechanical waves
  from electromagnetic waves.
- 14.2 emphasizes graph-axis reading before extracting period or wavelength.
- 14.3 preserves unchanged frequency across boundaries and applies polarization
  only to transverse waves.
- 14.4 emphasizes EM spectrum and visible-color ordering without exact ranges.
- 14.5 keeps Doppler treatment qualitative only.
- 14.6 emphasizes superposition, nodes/antinodes, beats, and boundary conditions.
- 14.7 separates diffraction spreading from simply blocking less or more light.
- 14.8 uses path-length-difference reasoning and the documented double-slit
  misconception pattern.
- 14.9 tracks reflection phase shifts and the normal-incidence quantitative
  boundary for thin films.
- The Learn More mini-examples are Cramapple-original and avoid copied released
  or official prompt language.
