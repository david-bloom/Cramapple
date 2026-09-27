# AP Physics C: E&M Unit 12 Topic Point Briefs

Status: Draft content addendum, pending QA/application.

Deployment state is deliberately NOT asserted here. The canonical runtime record
is the migration
`supabase/migrations/20260825135935_ap_physics_c_em_unit12_magnetic_fields_topic_guides.sql` and the
`app.topic_point_briefs` / `app.topic_explainers` tables in each environment.

Purpose: add paired topic point briefs and Learn More explainers for AP Physics
C: Electricity and Magnetism Unit 12 (Magnetic Fields and Electromagnetism).
Before this addendum, Production and Development both had taxonomy rows for all
four Unit 12 topics but zero published topic-guide pairs for the unit.

Source basis: `docs/product/AP_PHYSICS_C_EM_CED_FACT_PACK.md` Unit 12. The batch
is grounded in Gauss's law for magnetism, magnetic force on moving charges
`F_B = q(v x B)`, Biot-Savart law and its limited quantitative geometries,
force on current-carrying wires, Ampere's law, derived fields for long straight
wires and long solenoids, enclosed current from current density, the
qualitative-only displacement-current term, and documented scoring risks around
mixing point-charge and wire-force formulas or substituting the wrong enclosed
current.

## Coverage

| Topic | Title | Guide state |
|---|---|---|
| 12.1 | Magnetic Fields | point brief + Learn More explainer |
| 12.2 | Magnetism and Moving Charges | point brief + Learn More explainer |
| 12.3 | Magnetic Fields of Current-Carrying Wires and the Biot-Savart Law | point brief + Learn More explainer |
| 12.4 | Ampere's Law | point brief + Learn More explainer |

## Content Notes

- 12.1 emphasizes closed-loop magnetic field lines and zero net magnetic flux
  through closed surfaces.
- 12.2 emphasizes the point-charge cross-product force law and the real scoring
  risk of using wire-force formulas for charged particles.
- 12.3 emphasizes Biot-Savart setup geometry, `dl x rhat` direction, and the
  limited quantitative conductor cases.
- 12.4 emphasizes Amperian-loop symmetry, `I_enc`, current-density integration,
  and the displacement-current boundary.
- The Learn More mini-examples are Cramapple-original and avoid copied released
  or official prompt language.
