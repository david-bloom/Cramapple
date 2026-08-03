# AP Statistics Phase C Remediation Log — 2026-07-09

**Scope:** closes `CODEX_TASK0016_PHASE_C_REMEDIATION_2026_07_09.md` R1-R4 for
the AP Statistics 100-item calibration candidate. MCQ bank and FRQ count
consistency were not changed.

## R1 Content Defects Corrected

- `APSTAT-MOD6-H007`: corrected the rubric and `fully_correct` synthetic
  response from approximately 67% confidence to approximately 58.9% confidence.
  Reason: halving the width halves `z*`, so `z*_new = 1.645/2 = 0.8225` and
  `2Phi(0.8225)-1 ≈ 0.5892`. Existing deterministic key remains
  `canonical_answer: 0.58921`.
- `STATS-MOD1-M002`: numeric scan found the same wrong-answer-labeled-gold
  shape. Corrected the `fully_correct` synthetic response to use squared
  deviation sum `40`, sample variance `40/(5-1)=10`, and sample SD
  `sqrt(10) ≈ 3.16`. Reframed the population-denominator response as
  adjudication-worthy partial credit (`2.83`, not `3.16`).

## R2 Key Coverage And Triage

Validator result after remediation:
`python3 docs/research/statistics_phase_b_2026_07_08/validate_keys.py` passes
with `31/31` canonical integrity checks and `7/7` ECF templates.

Newly keyed in this pass:

| Item | Triage | Boundary rule / note |
|---|---|---|
| `APSTAT-MOD4-H001-INV` | `numeric+ecf` | Two-sample t magnitude keyed (`SE_diff`, `t_stat`). The alternative is directional, but sign remains convention-dependent if students write treatment-control vs. control-treatment; deterministic key grades magnitude while prose/conclusion handles direction. |
| `APSTAT-MOD4-M002` | `numeric` | Stratified allocation: `0.35 * 400 = 140`. |
| `APSTAT-MOD5-M001` | `numeric+ecf` | Keyed to the existing rubric's population-SD value `7.07`; flagged because the item says sample SD, which would be `7.91`. |
| `APSTAT-MOD7-M002` | `numeric` | Independent intersection probability: `0.3 * 0.4 = 0.12`. |
| `STATS-MOD1-E004` | `numeric` | Arithmetic mean: `90/5 = 18`. |
| `STATS-MOD1-M002` | `numeric+ecf` | Sample mean and sample SD keyed after correcting the synthetic response. |
| `STATS-MOD3-M006` | `numeric` | 84th percentile z-score keyed as approximately `1`. |

Previously keyed and still validated: `APSTAT-MOD3-E003`,
`APSTAT-MOD3-E004`, `APSTAT-MOD3-H001-INV`, `APSTAT-MOD6-M001`,
`APSTAT-MOD6-M003`, `APSTAT-MOD6-H001`, `APSTAT-MOD6-H003`,
`APSTAT-MOD6-H007`, `APSTAT-MOD7-M001`, `APSTAT-MOD7-M004`,
`APSTAT-MOD7-M005`, `APSTAT-MOD7-H001`, `APSTAT-MOD7-H005`,
`APSTAT-MOD7-H007`.

Explicit ABSTAIN/conceptual triage from the QA candidate list:

| Item | Triage | Reason |
|---|---|---|
| `APSTAT-MOD3-E005` | `conceptual` | Correlation-vs-causation explanation only. |
| `APSTAT-MOD4-M005` | `conceptual` | Confounding-variable explanation only. |
| `APSTAT-MOD6-M005` | `conceptual` | Explains inverse-square-root sample-size effect; no fixed numeric response. |
| `APSTAT-MOD6-H002-INV` | `symbolic_only` / corpus-defect excluded | Regression task references SAT/GPA data, graph, residual plot, and summaries that are not attached. |
| `APSTAT-MOD7-H003` | `conceptual` | Permutation/combination distinction with examples; no fixed prompt values. |
| `APSTAT-MOD7-H004` | `symbolic_only` / corpus-defect excluded | Refers to a probability distribution that is not provided; fixed variance cannot be keyed. |
| `APSTAT-MOD7-H010` | `conceptual` | Correlation-structure inference explanation. |
| `APSTAT-MOD7-H002-INV` | `symbolic_only` / corpus-defect excluded | Complete contingency table and chi-square statistic are not derivable from the provided percentages alone. |
| `APSTAT-MOD8-H003` | `conceptual` | Outlier-removal reasoning. |
| `APSTAT-MOD8-VH001` | `conceptual` | Multiple-regression model specification and interpretation; no dataset. |
| `STATS-MOD1-M005` | `conceptual` | Unbiased-estimator definition. |
| `STATS-MOD3-M007` | `conceptual` | CLT/standardization explanation. |
| `STATS-MOD9-H016` | `conceptual` | Significance vs. effect-size explanation. |
| `STATS-MOD9-H018` | `conceptual` | Power/sample-size explanation. |
| `STATS-MOD9-VH005` | `conceptual` | Frequentist-vs-Bayesian interval interpretation. |

## R3 Deterministic Target Schema

`ap_statistics_gold_set_candidate_2026_07_09/provisional_labels.json` now uses
the original list-of-objects shape for `deterministic_check_targets`:
`{item, response, criterion, note}`. It no longer uses the collapsed integer
form.

## R4 Package Relationship

Both candidate READMEs now state that the 2026-07-09 package supersedes the
2026-07-08 5-item package for calibration runs, while the older package remains
useful as a historical/smoke-test slice.
