# Course Mode 1.6 x 4.A Re-Derivation Record

Date: 2026-08-24
Cell: 1.6 x 4.A
Track: B, authored conceptual slot-frame
Frame: FB-U1-6-4A-DISTRIBUTION-01
Difficulty: Medium
Serving/grading: MCQ choice-match

## Scope

This record supports the Unit 1 distribution-description slot frame added in `scripts/course_mode_stats_generator/slot_frames.py`. The frame asks students to choose the distribution description best supported by a five-number summary plus mean cue. The keyed option must align shape, center, spread, and outlier status. Distractors are tied to cell-namespaced misconception tags in `scripts/course_mode_stats_generator/misconceptions.py`.

No loader run, database write, release, serving switch, or production change was performed.

## Harness Evidence

Command: `python3 scripts/course_mode_stats_generator/slot_frames.py`

Result: PASS

- Distribution frame instances: 120
- Distribution frame property checks: 1560
- Distribution frame rejects/failures: 0
- Distinct prompts: 52
- Correct answer positions observed: 0, 1, 2, 3
- Meta-tests green: all frames ok; answer position varies; misconception catalog self-check; scenario catalog self-check; all new u1_6 misconception tags used

Catalog checks:

- `python3 scripts/course_mode_stats_generator/misconceptions.py`: ok true
- `python3 scripts/course_mode_stats_generator/scenarios.py`: ok true
- `git diff --check`: clean

## Gate 2: Independent Re-Derivation

### Seed 16000

Prompt summary: quiz scores, min 10, Q1 20, median 24, Q3 34, max 52, mean about 29.

Hand derivation:

- IQR = Q3 - Q1 = 34 - 20 = 14.
- Lower fence = 20 - 1.5(14) = -1.
- Upper fence = 34 + 1.5(14) = 55.
- Min 10 and max 52 are both inside the fences, so there are no outliers by the 1.5 x IQR rule.
- Mean 29 exceeds median 24 and the right-side tail from Q3 to max is 52 - 34 = 18, longer than the left-side tail from min to Q1, 20 - 10 = 10. The supported shape is right-skewed.
- Center is near the median 24; spread by IQR is 14.

Key: The distribution is right-skewed, centered near the median 24, with IQR 14, and there are no outliers by the 1.5 x IQR rule.

Distractor checks:

- `u1_6__skew_direction_reversed`: Says left-skewed while the long tail and mean/median cue indicate right-skewed.
- `u1_6__ignores_shape_reports_center_only`: Gives true median/IQR information but omits the required shape description, so it is incomplete for the prompt.
- `u1_6__outlier_from_range_not_fences`: Calls the maximum an outlier because it is far from the minimum, but the max 52 is below the upper fence 55.

### Seed 16001

Prompt summary: online order totals, min 10, Q1 20, median 24, Q3 34, max 52, mean about 29.

Hand derivation:

- IQR = 34 - 20 = 14.
- Lower fence = 20 - 21 = -1.
- Upper fence = 34 + 21 = 55.
- Min 10 and max 52 are inside the fences, so no outliers are present by the 1.5 x IQR rule.
- Mean 29 is greater than median 24 and the upper tail is longer than the lower tail, supporting right skew.
- Correct center/spread pairing is median 24 for center and IQR 14 for spread.

Key: The distribution is right-skewed, centered near the median 24, with IQR 14, and there are no outliers by the 1.5 x IQR rule.

Distractor checks:

- `u1_6__center_spread_confused`: Says the distribution is centered near the IQR and has spread about the median, reversing the roles of center and spread.
- `u1_6__outlier_from_range_not_fences`: Again labels the maximum as an outlier from range alone, contradicted by the upper fence 55.
- `u1_6__ignores_shape_reports_center_only`: Provides center and spread but omits shape.

Together, seeds 16000 and 16001 cover all four new misconception tags.

## CED/Protocol Conformance

- Skill 4.A is served through a describe/select MCQ frame, not a computational verifier.
- The frame uses realistic one-variable quantitative contexts from a cell-namespaced scenario pool.
- Distractors are cell-namespaced with prefix `u1_6__`, cited in the misconception catalog, and represent plausible student errors about shape, center/spread, and outlier rules.
- The content is synthetic and avoids verbatim College Board wording.
- The frame preserves the mastery model changed-surface requirement through varied contexts, distribution shapes, values, and answer positions.
