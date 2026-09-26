# Codex Cross-QA — AP Statistics Tier 3 Labels + Difficulty

Date: 2026-09-25  
Reviewer: Codex  
Scope: read-only cross-QA of Claude's AP Statistics Tier 3 serving-label and difficulty work  
Production project checked: `pcntajvbdfqhbeewmdry`

## Verdict

AP Statistics Tier 3 is acceptable as a provisional launch-readiness pass for counts, contamination, and broad assignment quality. I found no Production contamination and no row-count mismatch against the documented run IDs.

I do not recommend changing Production rows as part of this QA task. I do recommend a follow-up cleanup pass for a small number of unit-label and difficulty-borderline rows before treating AP Statistics Tier 3 as fully ratified:

- Several held rows are legitimate scope/validity holds, especially regression-inference and chi-square goodness-of-fit items that conflict with the 2026-27 course model.
- Several held rows appear valid but unresolved under the current 5-unit taxonomy and should be reviewed by a human taxonomy owner rather than silently accepted as permanent holds.
- The difficulty run is honest as `calibrated_judgement`, but the Statistics methodology explicitly says the Easy/Medium split is weakly supported. My sample confirms the Hard band is much stronger than the Easy/Medium boundary.
- Two specific difficulty rows deserve follow-up review: `APSTAT-MOD5-M001` may be too easy, and `APSTAT-MOD6-H002-INV` may be too low at Medium.

## Source documents read

- `docs/content/CODEX_TASK_AP_STATISTICS_CROSS_QA_2026_09_25.md`
- `docs/product/TIER3_LABELS_DIFFICULTY_PAIRED_PLAN_2026_09_25.md`
- `docs/research/AP_STATISTICS_TAXONOMY_SERVING_LABEL_RUN_2026_09_25.md`
- `docs/research/apbio_difficulty_calibration_2026_09_22/STATISTICS_AND_CHEMISTRY.md`
- `docs/product/TIER3_PAIR1_STATUS_2026_09_25.md`

I also checked the current course-model context in `docs/teaching/COURSE_MODE_LEARNING_MODEL.md`, because legacy AP Statistics unit metadata still reflects an older 7/8/9-unit structure while the current 2026-27 model is a 5-unit course. That difference matters for rows marked `two_model_corrected_legacy_unit`.

## Production verification

### Serving-label counts

Production query target:

- Table: `content_item_serving_labels`
- Run: `serving-units-mcp-2026-09-25-20260925163249`
- Subject: AP Statistics live published items

Result:

| Label status | Count |
|---|---:|
| `provisional_model` | 107 |
| `held` | 19 |
| Total | 126 |

Reason buckets:

| Reason | Status | Count |
|---|---|---:|
| `two_model_corrected_legacy_unit` | `provisional_model` | 65 |
| `two_model_unit_agreement_no_usable_legacy` | `provisional_model` | 37 |
| `model_unit_disagreement` | `held` | 11 |
| `other` | `held` | 7 |
| `two_model_confirmed_legacy_unit` | `provisional_model` | 5 |
| `rubric_preflight_failure` | `held` | 1 |

Contamination check:

- New serving-label rows not joining to a live published AP Statistics item/version: 0.

### Difficulty counts

Production query target:

- Table: `content_item_difficulty`
- Proposal run: `apstats_structural_difficulty_2026_09_25`
- Subject: AP Statistics live published items

Result:

| Difficulty | Rationale | Count |
|---|---|---:|
| Easy | `calibrated_judgement` | 35 |
| Medium | `calibrated_judgement` | 83 |
| Hard | `calibrated_judgement` | 52 |
| Total |  | 170 |

Distribution:

- Easy: 20.6%
- Medium: 48.8%
- Hard: 30.6%

Contamination and coverage checks:

- Difficulty rows not joining to a live published AP Statistics item/version: 0.
- Current live published AP Statistics items: 170.
- Current live published AP Statistics items covered by this run: 170.
- Current live published AP Statistics items missing difficulty rows: 0.

The older narrative that there were 23 live-pack items missing difficulty is stale against current Production: at review time, the live published set is 170 items and all 170 are covered by the proposal run.

## Serving-label sample review

I reviewed all 19 held rows plus a weighted provisional sample:

- 8 rows from `two_model_corrected_legacy_unit`
- 5 rows from `two_model_unit_agreement_no_usable_legacy`
- 2 rows from `two_model_confirmed_legacy_unit`

That gave 34 sampled rows total.

### Held rows

| Content key | Reason | QA read |
|---|---|---|
| `APSTATS-HDG-2026-GRAPH-019` | `model_unit_disagreement` | Holding is reasonable. The item asks about a segmented bar graph and relative frequencies before/after; it plausibly touches Unit 1 and/or Unit 2 depending on the serving taxonomy's treatment of categorical displays and association. |
| `APSTATS-MCQ-002` | `model_unit_disagreement` | This looks resolvable to Unit 1 because it is a z-score/standardization comparison. The hold is safe, but likely conservative. |
| `APSTATS-MCQ-009` | `model_unit_disagreement` | CLT/sampling-distribution content. Because old metadata and current 5-unit taxonomy do not align cleanly, the hold is defensible. |
| `APSTATS-MCQ-013-CAL` | `model_unit_disagreement` | One-sample t-interval conditions for a mean. Likely current Unit 4, but the old unit metadata is stale enough that holding is acceptable. |
| `APSTATS-MCQ-020` | `model_unit_disagreement` | Z-score calculation. This likely belongs in Unit 1; the hold appears conservative rather than wrong. |
| `APSTATS-MCQ-055` | `model_unit_disagreement` | Standard error of a sample mean. Holding is acceptable pending final mapping of sampling distributions into the 5-unit serving taxonomy. |
| `APSTATS-MCQ-069` | `model_unit_disagreement` | Paired t-procedure. Likely Unit 4, but holding is acceptable. |
| `APSTATS-MCQ-079` | `model_unit_disagreement` | Sample size from standard error. Likely Unit 4/sampling distributions; hold is defensible. |
| `APSTATS-MCQ-096` | `model_unit_disagreement` | Confidence-interval width comparison. Likely Unit 4; hold is safe. |
| `APSTATS-MCQ-097` | `model_unit_disagreement` | Randomized experiment plus quantitative response/inference reasoning. Multi-unit ambiguity makes the hold appropriate. |
| `APSTATS-SFRQ-010` | `model_unit_disagreement` | Sampling-distribution mean/SD/CLT item. Hold is appropriate until the taxonomy owner confirms placement. |
| `APSTATS-MCQ-016-CAL` | `other` | Good hold. This is chi-square goodness-of-fit, which is outside the documented 2026-27 Statistics course model. |
| `APSTATS-MCQ-018-CAL` | `other` | Good hold. This is regression-slope inference/significance, and regression inference is explicitly out of scope in the current course model. |
| `APSTATS-MCQ-075` | `other` | The item appears valid: chi-square procedure choice for a contingency table. The hold is safe, but this should probably be retagged rather than treated as a content defect. |
| `APSTATS-MCQ-088` | `other` | Good hold. This is confidence-interval inference for a regression slope, which is out of scope. |
| `APSTATS-MCQ-094` | `other` | Good hold. This is hypothesis testing for a regression slope, which is out of scope. |
| `APSTATS-MCQ-098` | `other` | Good hold. This is regression-slope confidence-interval content, which is out of scope. |
| `APSTATS-MCQ-100` | `other` | The item appears valid as two-proportion inference. The hold is safe, but it likely needs retagging rather than exclusion. |
| `APSTAT-MOD4-H001-INV` | `rubric_preflight_failure` | Holding is appropriate. The item is coherent, but prior canonical-answer QA flagged a hypothesis/p-value mismatch: the key used a one-sided alternative while the reported p-value appears two-sided. |

### Provisional rows

| Content key | Reason bucket | Assigned unit read | QA read |
|---|---|---|---|
| `APSTATS-MCQ-004` | `two_model_corrected_legacy_unit` | Unit 5 | Agree. Residual-plot/linearity content belongs with regression/descriptive bivariate modeling. |
| `APSTATS-MCQ-014-CAL` | `two_model_corrected_legacy_unit` | Unit 4 | Agree. Paired before/after t-procedure belongs with quantitative inference. |
| `APSTATS-MCQ-046` | `two_model_corrected_legacy_unit` | Unit 2 | Agree. Conditional probability item. |
| `APSTATS-MCQ-056` | `two_model_corrected_legacy_unit` | Unit 4 | Agree. Sampling distribution of a sample mean fits the current inference/sampling-distribution placement. |
| `APSTATS-MCQ-058` | `two_model_corrected_legacy_unit` | Unit 3 | Needs follow-up. The item is margin-of-error/sample-size reasoning; Unit 3 may be right if Unit 3 owns proportion intervals, but it may belong in Unit 4 under the current inference mapping. |
| `APSTATS-MCQ-082` | `two_model_corrected_legacy_unit` | Unit 5 | Agree. Regression prediction within the observed explanatory range. |
| `APSTATS-MCQ-091` | `two_model_corrected_legacy_unit` | Units 3/4, primary 4 | Primary Unit 4 is right for two-sample mean inference. The secondary Unit 3 may be overbroad unless the taxonomy intentionally marks procedure-selection items across both inference units. |
| `APSTATS-MCQ-099` | `two_model_corrected_legacy_unit` | Units 3/4, primary 4 | Primary Unit 4 is right for two-sample quantitative inference. Same possible overbreadth concern as `APSTATS-MCQ-091`. |
| `APSTAT-MOD3-E002` | `two_model_unit_agreement_no_usable_legacy` | Unit 1 | Agree. Histogram shape interpretation. |
| `APSTAT-MOD6-H002-INV` | `two_model_unit_agreement_no_usable_legacy` | Unit 5 | Agree. Regression association, slope/intercept, residuals, prediction, and extrapolation. |
| `apstats-frq-u12-002` | `two_model_unit_agreement_no_usable_legacy` | Unit 2 | Agree. Probability/spinner item. |
| `apstats-frq-u12-017` | `two_model_unit_agreement_no_usable_legacy` | Units 1/2, primary 2 | Agree. Categorical variables, conditional distributions, segmented bars, and association. |
| `APSTATS-SFRQ-003` | `two_model_unit_agreement_no_usable_legacy` | Unit 5 | Agree. LSRL/correlation/prediction/residual content. |
| `APSTATS-MCQ-021` | `two_model_confirmed_legacy_unit` | Unit 1 | Agree. Mean change after one observation changes. |
| `APSTATS-MCQ-027` | `two_model_confirmed_legacy_unit` | Unit 1 | Agree. Mean/median comparison in a symmetric no-outlier distribution. |

Serving-label conclusion: the production run is mostly sound. The most important follow-up is not broad reversal; it is targeted human review of a few held-but-valid rows and one or two provisional rows where the current 5-unit taxonomy boundary is ambiguous.

## Difficulty-band review

The methodology document explicitly warns that AP Statistics question-level validation is limited:

- The available AP Statistics benchmark was only a small question-level sample.
- The Hard tier is supported better than the Easy/Medium split.
- The previous Investigative Task assumption was contradicted by evidence.

Given that caveat, the `calibrated_judgement` rationale is appropriate and more honest than claiming a fully validated structural ratio. However, the run should be understood as a provisional calibrated judgement pass, not as fully validated item-level difficulty truth.

Sample reviewed:

| Content key | Assigned band | QA read |
|---|---|---|
| `APSTAT-MOD3-E002` | Easy | Agree. Straightforward histogram-shape interpretation. |
| `APSTAT-MOD5-M001` | Easy | Borderline. Computing mean and sample standard deviation from five values has enough arithmetic burden that Medium may be more defensible. |
| `apstats-frq-u12-001` | Easy | Agree. Basic relative-frequency/bar-graph/variable-classification work. |
| `APSTAT-MOD4-M001` | Medium | Agree. Routine but nontrivial experimental-design construction. |
| `APSTAT-MOD6-H001` | Medium | Defensible. Source metadata was Hard, but the task is a relatively routine two-sample t-test after a randomized experiment. Medium is acceptable. |
| `APSTAT-MOD6-H002-INV` | Medium | Borderline low. The task combines regression association, slope/intercept interpretation, residual conditions, R², prediction uncertainty, and extrapolation. Hard may be more appropriate. |
| `APSTAT-MOD3-H001-INV` | Hard | Agree. Multi-part sampling-bias, sampling-plan, confidence-interval, and hypothesis-test reasoning. |
| `APSTAT-MOD4-H001-INV` | Hard | Agree. Multi-part experiment design, blocking, t-test, and significance/practical-significance reasoning; also has a separate keying/rubric caveat. |
| `APSTAT-MOD5-H001-INV` | Hard | Agree. Confounding/causation, experiment design, and t-inference assumptions. |
| `APSTAT-MOD7-H002-INV` | Hard | Agree. Multi-part contingency-table, chi-square-test, conditional-probability, and limitation reasoning. |

Difficulty conclusion: the Hard band appears credible in the sample. The Easy/Medium boundary remains the weak spot, matching the methodology caveat. The run is acceptable for provisional launch readiness if downstream users understand that `calibrated_judgement` is a judgemental tier assignment rather than a fully validated calibration.

## Migration-file reconstruction check

I inspected:

- `supabase/migrations/20260925180000_apstats_serving_labels_backfill.sql`
- `supabase/migrations/20260925190000_apstats_difficulty_backfill.sql`

Findings:

- The serving-label migration contains 126 value tuples, matching the 126 Production rows for the serving-label run.
- The difficulty migration contains 170 value tuples, matching the 170 Production rows for the difficulty proposal run.
- The serving-label migration is explicitly documented as reconstructed from a fresh Production query, joins by content key/current latest version, and guards against inserting duplicate rows for the same run/item.
- The difficulty migration joins by content key/current latest version and uses `on conflict (content_item_version_id) do nothing`, making it idempotent on current Production.
- Production counts and distributions match the reconstructed files.

I did not rerun either migration and did not make any Production writes.

## Required follow-up recommendations

Before calling AP Statistics Tier 3 fully closed, I recommend a narrow follow-up review list:

1. Review held-but-valid rows for final taxonomy placement:
   - `APSTATS-MCQ-002`
   - `APSTATS-MCQ-020`
   - `APSTATS-MCQ-075`
   - `APSTATS-MCQ-100`
   - plus the sampling-distribution/t-inference holds if the taxonomy owner wants to resolve all 11 `model_unit_disagreement` rows.

2. Confirm whether `APSTATS-MCQ-058` belongs in Unit 3 or Unit 4 under the 2026-27 serving taxonomy.

3. Decide whether secondary Unit 3 on `APSTATS-MCQ-091` and `APSTATS-MCQ-099` is intentional or overbroad.

4. Treat the following `other` holds as legitimate out-of-scope/content-model issues unless the product decision is to retain legacy coverage:
   - `APSTATS-MCQ-016-CAL`
   - `APSTATS-MCQ-018-CAL`
   - `APSTATS-MCQ-088`
   - `APSTATS-MCQ-094`
   - `APSTATS-MCQ-098`

5. Revisit two difficulty assignments if AP Statistics gets a higher-rigor difficulty pass:
   - `APSTAT-MOD5-M001`: consider Easy → Medium.
   - `APSTAT-MOD6-H002-INV`: consider Medium → Hard.

## Final status

Cross-QA complete. The work is safe to merge as a report-only QA artifact. No Production rows were changed, no migrations were run, and Pair 2 was not started.
