# AP Calculus BC difficulty calibration — 2026-09-26

Status: **Complete artifact; base migration applied to Production 2026-09-26; method correction applied to Production 2026-09-27**

## Result

| Measure | Count |
|---|---:|
| Rows generated | 127 |
| Expected current published rows | 127 |
| FRQ | 64 |
| MCQ | 63 |
| Easy | 15 |
| Medium | 57 |
| Hard | 55 |
| Rows with a preserved authored source value | 95 |
| Rows with null `attainment_ratio` / `ratio_source` | 127 |

Basis counts: `calibrated_judgement` 12, `calibrated_task_verb` 20, `normalised_casing` 79, `translated` 16.

## Method and governance

- DECISION-0061's operative vocabulary is Easy / Medium / Hard.
- `Very Hard` is translated to `Hard`; the original is retained in `source_value`.
- Existing three-level source values are preserved with basis `normalised_casing`.
- Rows without authored difficulty use the approved task-verb method. FRQs use the modal
  criterion tier with an upward tie-break; cue-free items use a recorded low-confidence judgment.
- No item-level continuous attainment evidence was available for this corpus. In accordance with
  DECISION-0065, the generator emits honest null `attainment_ratio`, `ratio_source`, and
  `subject_cut_points` values.

## Artifacts

- Assignments: `docs/research/content_pipeline_difficulty_2026_09_26/AP_CALCULUS_BC_DIFFICULTY_ASSIGNMENTS_2026_09_26.csv`
- Base migration (applied to Production 2026-09-26): `supabase/migrations/20260926234400_apcalcbc_difficulty.sql`
- Corrective migration for the approved `predict` / `integrate` tier rule:
  `supabase/migrations/20260927112232_correct_remaining_difficulty_predict_integrate.sql`
- Rebuild script: `scripts/taxonomy/build_remaining_difficulty_artifacts.py`

## Gate note

The local artifact covers the complete current-published census supplied to this run.
