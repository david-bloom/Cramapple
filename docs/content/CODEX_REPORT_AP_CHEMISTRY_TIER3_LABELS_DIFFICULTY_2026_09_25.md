# AP Chemistry Tier 3 Labels + Difficulty Report — 2026-09-25

## Outcome

Completed Production writes for AP Chemistry Tier 3 readiness via Supabase MCP only.

- Serving-label run: `serving-units-mcp-2026-09-25-20260925203431`
- Difficulty proposal run: `apchem_tier3_difficulty_2026_09_25`
- Production project ref: `pcntajvbdfqhbeewmdry`
- No Supabase CLI writes were used.

## Dry-run / pre-write verification

### Serving labels

- Live AP Chemistry pack count re-derived from Production: 136 items.
- Published label target re-derived from Production: 42 items.
- Target composition: 34 `stale`, 6 active Group A duplicate-current repairs, 2 clean `legacy_unvalidated`.
- Prefetched packet file verified before use: `/private/tmp/cramapple-math-taxonomy-serving/apchem_serving_packets_42_2026_09_25.json`.
- Packet key set matched the independently derived 42 target keys exactly: no missing, no extras, no duplicates.
- Generated model output: 42 rows from `scripts/taxonomy/extend_serving_labels_mcp.mjs`.
- Generated SQL was split programmatically; local applied SQL uses the same model decisions in compact Statistics-style provenance, with full model transcript retained in `/private/tmp/cramapple-math-taxonomy-serving/model_results.json` and the generated research artifact.

Serving target keys:

- apchem-frq-l-002
- apchem-frq-l-004
- apchem-frq-l-006
- apchem-frq-l-010
- apchem-frq-l-011
- apchem-frq-l-012
- apchem-frq-l-016
- apchem-frq-l-020
- apchem-frq-l-024
- apchem-frq-l-027
- apchem-mcq-001
- apchem-mcq-012
- apchem-mcq-018
- apchem-mcq-024
- apchem-mcq-030
- apchem-mcq-033
- apchem-mcq-039
- apchem-mcq-043
- apchem-mcq-046
- apchem-mcq-049
- apchem-mcq-055
- apchem-mcq-057
- apchem-mcq-062
- apchem-mcq-063
- apchem-mcq-068
- apchem-mcq-070
- apchem-sfrq-008
- apchem-sfrq-009
- apchem-sfrq-010
- apchem-sfrq-015
- apchem-sfrq-016
- apchem-sfrq-019
- apchem-sfrq-021
- apchem-sfrq-022
- apchem-sfrq-026
- apchem-sfrq-027
- apchem-sfrq-028
- apchem-sfrq-029
- apchem-sfrq-033
- apchem-sfrq-034
- apchem-sfrq-036
- apchem-sfrq-037

### Difficulty

- Live published AP Chemistry difficulty target re-derived from Production: 119 items.
- CSV coverage: 119/119 live published AP Chemistry items.
- Existing Production difficulty rows before load: 0.
- CSV source: `docs/research/apbio_difficulty_calibration_2026_09_22/apchem_difficulty_assignments.csv`.
- Difficulty distribution loaded: 53 Easy, 52 Medium, 14 Hard.
- Basis mapping used for table constraints:
  - FRQ rows: `calibrated_task_verb`
  - MCQ rows: `calibrated_judgement`
  - Detailed CSV cue preserved in `subject_cut_points.csv_basis` and rationale.
- No item-level continuous attainment ratio is available for this Chemistry CSV; `attainment_ratio` and `ratio_source` are intentionally null.

Difficulty target keys:

- apchem-frq-l-002
- apchem-frq-l-003
- apchem-frq-l-004
- apchem-frq-l-005
- apchem-frq-l-006
- apchem-frq-l-010
- apchem-frq-l-011
- apchem-frq-l-012
- apchem-frq-l-013
- apchem-frq-l-014
- apchem-frq-l-016
- apchem-frq-l-017
- apchem-frq-l-020
- apchem-frq-l-021
- apchem-frq-l-022
- apchem-frq-l-023
- apchem-frq-l-024
- apchem-frq-l-025
- apchem-frq-l-026
- apchem-frq-l-027
- apchem-frq-l-028
- apchem-sfrq-002
- apchem-sfrq-003
- apchem-sfrq-004
- apchem-sfrq-005
- apchem-sfrq-007
- apchem-sfrq-008
- apchem-sfrq-009
- apchem-sfrq-010
- apchem-sfrq-014
- apchem-sfrq-015
- apchem-sfrq-016
- apchem-sfrq-018
- apchem-sfrq-019
- apchem-sfrq-021
- apchem-sfrq-022
- apchem-sfrq-023
- apchem-sfrq-024
- apchem-sfrq-026
- apchem-sfrq-027
- apchem-sfrq-028
- apchem-sfrq-029
- apchem-sfrq-030
- apchem-sfrq-031
- apchem-sfrq-032
- apchem-sfrq-033
- apchem-sfrq-034
- apchem-sfrq-035
- apchem-sfrq-036
- apchem-sfrq-037
- apchem-sfrq-038
- apchem-mcq-001
- apchem-mcq-003
- apchem-mcq-004
- apchem-mcq-005
- apchem-mcq-006
- apchem-mcq-007
- apchem-mcq-008
- apchem-mcq-009
- apchem-mcq-010
- apchem-mcq-011
- apchem-mcq-012
- apchem-mcq-013
- apchem-mcq-014
- apchem-mcq-015
- apchem-mcq-016
- apchem-mcq-017
- apchem-mcq-018
- apchem-mcq-019
- apchem-mcq-020
- apchem-mcq-021
- apchem-mcq-022
- apchem-mcq-023
- apchem-mcq-024
- apchem-mcq-025
- apchem-mcq-026
- apchem-mcq-027
- apchem-mcq-028
- apchem-mcq-029
- apchem-mcq-030
- apchem-mcq-031
- apchem-mcq-032
- apchem-mcq-033
- apchem-mcq-034
- apchem-mcq-035
- apchem-mcq-036
- apchem-mcq-037
- apchem-mcq-038
- apchem-mcq-039
- apchem-mcq-040
- apchem-mcq-041
- apchem-mcq-042
- apchem-mcq-043
- apchem-mcq-044
- apchem-mcq-045
- apchem-mcq-046
- apchem-mcq-047
- apchem-mcq-048
- apchem-mcq-049
- apchem-mcq-051
- apchem-mcq-052
- apchem-mcq-053
- apchem-mcq-054
- apchem-mcq-055
- apchem-mcq-056
- apchem-mcq-057
- apchem-mcq-058
- apchem-mcq-059
- apchem-mcq-060
- apchem-mcq-061
- apchem-mcq-062
- apchem-mcq-063
- apchem-mcq-064
- apchem-mcq-065
- apchem-mcq-066
- apchem-mcq-067
- apchem-mcq-068
- apchem-mcq-069
- apchem-mcq-070

## Applied migrations

Serving labels:

- `supabase/migrations/20260925210100_apchem_serving_labels_batch_01.sql` — 25 rows, verified cumulative count 25.
- `supabase/migrations/20260925210200_apchem_serving_labels_batch_02.sql` — 17 rows, verified cumulative count 42.

Difficulty:

- `supabase/migrations/20260925211100_apchem_difficulty_batch_01.sql` — 30 rows, verified cumulative count 30.
- `supabase/migrations/20260925211200_apchem_difficulty_batch_02.sql` — 30 rows, verified cumulative count 60.
- `supabase/migrations/20260925211300_apchem_difficulty_batch_03.sql` — 30 rows, verified cumulative count 90.
- `supabase/migrations/20260925211400_apchem_difficulty_batch_04.sql` — 29 rows, verified cumulative/final count 119.

Each migration file is the SQL passed to `apply_migration` for that batch.

## Final Production verification

### Serving labels

Final row count for `model_run_id = 'serving-units-mcp-2026-09-25-20260925203431'`:

- `provisional_model`: 33
- `held`: 9
- Total: 42

Held items:

- apchem-frq-l-002: model_unit_disagreement
- apchem-mcq-012: model_unit_disagreement
- apchem-mcq-030: model_unit_disagreement
- apchem-mcq-070: model_unit_disagreement
- apchem-sfrq-010: model_unit_disagreement
- apchem-sfrq-015: model_unit_disagreement
- apchem-sfrq-022: model_call_failure
- apchem-sfrq-027: model_unit_disagreement
- apchem-sfrq-033: model_unit_disagreement

Contamination check: 0 serving-label rows from this run failed the live published AP Chemistry join.

Active Group A duplicate-current repairs were successful; each now has exactly one current serving row:

- `apchem-frq-l-002`
- `apchem-frq-l-006`
- `apchem-frq-l-012`
- `apchem-mcq-001`
- `apchem-mcq-070`
- `apchem-sfrq-010`

Explicit exclusions were untouched: Group B and the 13 non-published items all have 0 rows from this run. The remaining live-pack duplicate-current anomalies are the documented Group B items intentionally left out of this task:

- `apchem-frq-l-013`
- `apchem-frq-l-014`
- `apchem-sfrq-003`
- `apchem-sfrq-014`
- `apchem-sfrq-024`

### Difficulty

Final row count for `proposal_run = 'apchem_tier3_difficulty_2026_09_25'`:

- Easy: 53
- Medium: 52
- Hard: 14
- Total: 119

Difficulty contamination check: 0 rows failed the live published AP Chemistry join.

## Ready for cross-QA

Cross-QA should review:

1. The 42 new serving-label rows for `serving-units-mcp-2026-09-25-20260925203431`, especially the 9 held items and the 6 Group A duplicate-current repairs.
2. The 119 difficulty rows for `apchem_tier3_difficulty_2026_09_25`, with attention to the FRQ/MCQ basis mapping and null attainment-ratio design.
3. The intentionally untouched Group B duplicate-current gap, which remains separate from this work order.

## Notes

- The generated full model transcript remains local in `/private/tmp/cramapple-math-taxonomy-serving/model_results.json`.
- The generated run artifact is `docs/research/AP_CHEMISTRY_TAXONOMY_SERVING_LABEL_RUN_2026_09_25.md`.
- This work stopped after opening the implementation PR; no self cross-QA was started.
