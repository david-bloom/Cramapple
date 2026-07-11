# AP Statistics Phase C Calibration Dry-Run

**Date:** 2026-07-11
**Task:** TASK-0016 Phase C deterministic-layer calibration dry-run
**Runner:** `deno run --allow-read --allow-write docs/research/ap_statistics_phase_c_calibration_dryrun_2026_07_11/calibration_runner.ts`

This is a tooling and measurement pass against AI-provisional labels, not the launch-gate calibration against human-adjudicated gold labels. Agreement rates below are dry-run diagnostics only.

## Inputs

- FRQ labels: `docs/research/ap_statistics_gold_set_candidate_2026_07_09/provisional_labels.json`
- MCQ bank: `docs/research/ap_statistics_mcq_launch_bank_2026_07_09/ap_statistics_mcq_launch_bank_2026_07_09.json`
- deterministic keys: `docs/research/statistics_phase_b_2026_07_08/statistics_item_keys.json`
- verification profile: `docs/research/AP_STATISTICS_VERIFICATION_PROFILE.json`
- profile status: development — 28 of 100 FRQ items have deterministic key parts validated (validate_keys.py: 44/44 integrity, 7/7 ECF); 68 items are explicitly conceptual (verbal/qualitative, no fixed numeric target derivable from a text response); 4 excluded or method-only because fixed numeric data is absent/defective; full 100-item corpus now has an explicit disposition. Not yet wired to production, not yet on an adjudicated gold set.

## R1/R3 Staleness Check

- `APSTAT-MOD6-H007` R1 fix in `provisional_labels.json`: landed.
- `provisional_labels.json.deterministic_check_targets`: restored list-of-objects shape.
- `manifest.json.deterministic_check_targets`: still stale (3).

## Coverage

| bucket | FRQ items |
| --- | --- |
| at least one non-conceptual deterministic key | 28 |
| fully conceptual / correctly abstaining | 68 |
| excluded or method-only corpus defect | 4 |
| possible checkable criterion with no key | 0 |

The key file currently contains 30 item entries; 28 have at least one non-conceptual criterion in the local key payload. The profile's `items_keyed` list has 28 entries, which excludes conceptual-only `APSTAT-MOD5-H001-INV` and excluded/method-only `APSTAT-MOD8-H001` even though both appear in `statistics_item_keys.json`.

No keyword-suspected unkeyed numeric coverage gaps were found beyond the profile's stated conceptual/excluded dispositions.

## Agreement Against Provisional Labels

Comparable deterministic verdicts exclude abstains. Raw comparable agreement: 60/70 (85.7%).

| deterministic verdict | criterion rows | agreement rows | agreement |
| --- | --- | --- | --- |
| pass | 39 | 32 | 82.1% |
| flag | 31 | 28 | 90.3% |
| abstain | 250 | 0 | 0.0% |

Important caveat: this is not the >=95% launch-bar criterion-agreement number. The label source is AI-provisional rather than adjudicated gold, and plain-text synthetic responses do not provide the structured typed-response object needed for a full production ECF cascade.

## Disagreements

| content_key | response | criterion | deterministic | provisional | keyed targets | arithmetic read |
| --- | --- | --- | --- | --- | --- | --- |
| APSTAT-MOD3-H001-INV | 2 | ci_calculation | flag | earned | SE=21.9089; CI_low=807.05855; CI_high=892.94145 | Response recomputes 120/sqrt(30) and gives (807, 893), which is arithmetically correct within rounding; deterministic flag is too strict because the SE value is not separately stated. |
| APSTAT-MOD4-H001-INV | 1 | hypothesis_test_execution | flag | earned | SE_diff=1.56205; t_stat=2.56074 | Exact SE is about 1.56 and t is about -2.56; the response's 't approx -2.5' is arithmetically acceptable, so the deterministic flag is a missing-exact-SE artifact. |
| APSTAT-MOD6-M001 | 1 | margin_of_error | pass | partially_earned | n_required=384.16 | n approx 384 is the standard conservative 95%/5% sample-size result; partial provisional credit appears to reflect missing explanation rather than arithmetic error. |
| APSTAT-MOD6-M001 | 3 | margin_of_error | pass | not_earned | n_required=384.16 | n approx 385 is arithmetically correct for the margin calculation; the not-earned label likely conflates this criterion with the separate bad sampling-design response. |
| APSTAT-MOD6-H001 | 1 | test_calculation | flag | earned | SE_diff=1.94079; t_stat=2.06104 | Exact SE is about 1.94 and \|t\| is about 2.06; the response's '2.0 to 2.1' is a reasonable rounded statistic, so the deterministic flag is too exacting for prose. |
| APSTAT-MOD7-M005 | 1 | expected_value | pass | not_earned | expected=5 | The keyed value 5 appears only inside a guess list ('4, 5, or 6'), not as a computed expected value; provisional not-earned is more likely correct. |
| APSTAT-MOD7-H001 | 2 | calculation | pass | partially_earned | P_D=0.023; P_BgivenD=0.65217 | P(D)=0.023 and P(B\|D) approx 0.65 are the keyed arithmetic values; provisional partial may be under-crediting a terse but numerically correct calculation. |
| APSTAT-MOD8-M002 | 1 | r_squared_interpretation | pass | not_earned | r_squared_pct=0.64 | 0.64 is present, but the interpretation says x explains x's variance instead of response-variable variance; provisional not-earned is more likely correct. |
| APSTAT-MOD8-M004 | 1 | slope_interpretation | pass | not_earned | slope_value=3 | The slope value 3 is present, but the interpretation is not contextual rate-of-change language; provisional not-earned is more likely correct. |
| STATS-MOD1-E004 | 1 | mean_calculation | pass | not_earned | mean=18 | 18 appears as one raw data value, but the response divides by 4 and gives 22.5; provisional not-earned is more likely correct. |

## Deterministic Abstains On Non-Unknown Labels

These rows are abstains, not agreement failures. They are useful because they identify criteria where the current deterministic layer or this plain-text dry-run adapter cannot produce a comparable verdict.

| content_key | response | criterion | source | provisional | detail |
| --- | --- | --- | --- | --- | --- |
| APSTAT-MOD4-H001-INV | 0 | experimental_design | no_key | earned | No criterion-level deterministic key is present. |
| APSTAT-MOD4-H001-INV | 0 | blocking_decision | no_key | earned | No criterion-level deterministic key is present. |
| APSTAT-MOD4-H001-INV | 0 | significance_interpretation | no_key | earned | No criterion-level deterministic key is present. |
| APSTAT-MOD4-H001-INV | 1 | experimental_design | no_key | earned | No criterion-level deterministic key is present. |
| APSTAT-MOD4-H001-INV | 1 | blocking_decision | no_key | earned | No criterion-level deterministic key is present. |
| APSTAT-MOD4-H001-INV | 1 | significance_interpretation | no_key | partially_earned | No criterion-level deterministic key is present. |
| APSTAT-MOD4-H001-INV | 2 | experimental_design | no_key | partially_earned | No criterion-level deterministic key is present. |
| APSTAT-MOD4-H001-INV | 2 | blocking_decision | no_key | earned | No criterion-level deterministic key is present. |
| APSTAT-MOD4-H001-INV | 2 | significance_interpretation | no_key | partially_earned | No criterion-level deterministic key is present. |
| APSTAT-MOD4-H001-INV | 3 | experimental_design | no_key | not_earned | No criterion-level deterministic key is present. |
| APSTAT-MOD4-H001-INV | 3 | blocking_decision | no_key | partially_earned | No criterion-level deterministic key is present. |
| APSTAT-MOD4-H001-INV | 3 | significance_interpretation | no_key | not_earned | No criterion-level deterministic key is present. |
| APSTAT-MOD8-H001 | 0 | correlation_calculation | no_numeric_part | earned | The key marks this criterion numeric but has no canonical numeric part for this harness to compare. |
| APSTAT-MOD8-H001 | 0 | regression_equation | symbolic_only_plain_text | earned | slope STRUCTURE b=r*(sy/sx) is checkable; numeric value is not (no data). LLM grader checks self-consistency against the response's own asserted r/sy/sx. |
| APSTAT-MOD8-H001 | 1 | correlation_calculation | no_numeric_part | earned | The key marks this criterion numeric but has no canonical numeric part for this harness to compare. |
| APSTAT-MOD8-H001 | 1 | regression_equation | symbolic_only_plain_text | earned | slope STRUCTURE b=r*(sy/sx) is checkable; numeric value is not (no data). LLM grader checks self-consistency against the response's own asserted r/sy/sx. |
| APSTAT-MOD8-H001 | 2 | correlation_calculation | no_numeric_part | partially_earned | The key marks this criterion numeric but has no canonical numeric part for this harness to compare. |
| APSTAT-MOD8-H001 | 2 | regression_equation | symbolic_only_plain_text | partially_earned | slope STRUCTURE b=r*(sy/sx) is checkable; numeric value is not (no data). LLM grader checks self-consistency against the response's own asserted r/sy/sx. |
| APSTAT-MOD8-H001 | 3 | correlation_calculation | no_numeric_part | partially_earned | The key marks this criterion numeric but has no canonical numeric part for this harness to compare. |
| APSTAT-MOD8-H001 | 3 | regression_equation | symbolic_only_plain_text | partially_earned | slope STRUCTURE b=r*(sy/sx) is checkable; numeric value is not (no data). LLM grader checks self-consistency against the response's own asserted r/sy/sx. |

## Router Dispatch

| FRQ route target | count |
| --- | --- |
| mcq_rule | 0 |
| llm_text | 100 |
| symbolic_ecf | 0 |
| shadow_review | 0 |

No FRQ items routed to shadow_review.
All 100 FRQ corpus entries used the legacy `codex.question_type: "frq"` fallback and therefore route to `llm_text`; no item currently declares `rubric_type: "structured_formula"` in the provisional corpus JSON.

## MCQ Sanity

- MCQ route check: 100/100 route to `mcq_rule`.
- MCQ answer-key shape: 100/100 have exactly one `is_correct: true` choice.

No MCQ sanity failures.

## ECF Harness Note

The runner imports `findStatisticsItem()`, `coerceEcfQuestion()`, and `buildEcfResult()`. The 2026-07-09 provisional FRQ corpus stores synthetic responses as prose strings, not structured per-part typed-response JSON, so 12 ECF-capable response rows were not coercible into the production ECF input shape. The comparable numeric rows above therefore use a plain-text numeric adapter that checks whether keyed canonical part values appear in the response text within the same broad tolerance style as the statistics verifier. Re-pointing the harness at adjudicated labels later only requires changing `LABELS_PATH` (and preserving the same item/response/criteria shape).
