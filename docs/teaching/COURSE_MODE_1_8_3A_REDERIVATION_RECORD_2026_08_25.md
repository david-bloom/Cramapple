# Course Mode 1.8 x 3.A Re-Derivation Record

Date: 2026-08-25
Cell: 1.8 x 3.A
Track: B, authored conceptual slot-frame
Frame: FB-U1-8-3A-BOXPLOT-01
Difficulty: Medium
Serving/grading: MCQ choice-match

## Scope

This record supports the modified-boxplot slot frame added in `scripts/course_mode_stats_generator/slot_frames.py`. The frame gives a five-number summary plus the non-outlier whisker endpoints needed for text-only modified boxplot selection. Distractors are tied to cell-namespaced misconception tags.

No loader run, database write, release, serving switch, or production change was performed.

## Harness Evidence

Command: `python3 scripts/course_mode_stats_generator/slot_frames.py`

Result: PASS

- 1.8 x 3.A instances: 120
- 1.8 x 3.A checks: 1320
- 1.8 x 3.A rejects/failures: 0
- Distinct prompts: 20
- Correct answer positions observed: 0, 1, 2, 3
- Meta-tests green, including catalog self-checks and all new u1_8 misconception tags used

Catalog checks:

- `python3 scripts/course_mode_stats_generator/misconceptions.py`: ok true
- `python3 scripts/course_mode_stats_generator/scenarios.py`: ok true

## Gate 2: Independent Re-Derivation

Seed 18000 prompt summary: seedling heights, min 7, Q1 12, median 15, Q3 19, max 31; non-outlier whisker endpoints 7 and 25.

Hand derivation:

- IQR = Q3 - Q1 = 19 - 12 = 7.
- Lower fence = 12 - 1.5(7) = 1.5.
- Upper fence = 19 + 1.5(7) = 29.5.
- Min 7 is inside the lower fence, so the lower whisker can extend to 7.
- Max 31 is above 29.5, so it is an outlier and should be plotted separately.
- The supplied largest non-outlier is 25, so the upper whisker ends at 25.
- The box spans Q1 to Q3, 12 to 19, with the median line at 15.

Key: box from 12 to 19 cm, median at 15, whiskers to 7 and 25, plotted outlier at 31.

Distractor checks:

- `u1_8__whisker_to_extreme_ignores_outlier`: extends the upper whisker to 31 and says no outliers, contradicting the upper fence 29.5.
- `u1_8__quartile_median_positions_swapped`: puts the box from median 15 to Q3 19 and the median line at Q1 12.
- `u1_8__box_spans_range_not_iqr`: makes the box span min to max, 7 to 31, instead of Q1 to Q3.

## CED/Protocol Conformance

- Skill 3.A is served as an MCQ representation-selection task, not open graph construction.
- Context ids and misconception tags use the `u1_8__` namespace and are append-only.
- The prompt is text/numeric and original; no College Board wording is copied.
- Distractors are specific to the displayed summary and each carries catalog provenance.
