# Course Mode 1.5 x 3.A Re-Derivation Record

Date: 2026-08-25
Cell: 1.5 x 3.A
Track: B, authored conceptual slot-frame
Frame: FB-U1-5-3A-GRAPH-01
Difficulty: Medium
Serving/grading: MCQ choice-match

## Scope

This record supports the one-variable graph representation slot frame added in `scripts/course_mode_stats_generator/slot_frames.py`. The frame gives a small quantitative data set and asks which text-described representation correctly displays it. Distractors are tied to cell-namespaced misconception tags in `scripts/course_mode_stats_generator/misconceptions.py`.

No loader run, database write, release, serving switch, or production change was performed.

## Harness Evidence

Command: `python3 scripts/course_mode_stats_generator/slot_frames.py`

Result: PASS

- 1.5 x 3.A instances: 120
- 1.5 x 3.A checks: 960
- 1.5 x 3.A rejects/failures: 0
- Distinct prompts: 120
- Correct answer positions observed: 0, 1, 2, 3
- Meta-tests green, including catalog self-checks and all new u1_5 misconception tags used

Catalog checks:

- `python3 scripts/course_mode_stats_generator/misconceptions.py`: ok true
- `python3 scripts/course_mode_stats_generator/scenarios.py`: ok true

## Gate 2: Independent Re-Derivation

Seed 15000 prompt data: battery life values 9, 8, 10, 10, 11, 10, 12, 14, 12, 14, 16, 17; bin width 5.

Hand counts:

- 5-9 hours: 8 and 9, so count 2.
- 10-14 hours: 10, 10, 11, 10, 12, 14, 12, 14, so count 8.
- 15-19 hours: 16 and 17, so count 2.
- 20-24 hours: no values, so count 0.

Key: histogram counts 5-9: 2; 10-14: 8; 15-19: 2; 20-24: 0.

Distractor checks:

- `u1_5__miscounted_bin_frequency`: reports 5-9 as 1 and 10-14 as 9, moving one value into the wrong bin.
- `u1_5__stem_leaf_place_value_error`: shows stems/leaves for values ten times too large, so place value is wrong.
- `u1_5__wrong_plot_type_for_data`: describes a categorical bar chart rather than a graph on a numeric axis for quantitative data.

## CED/Protocol Conformance

- Skill 3.A is served as an MCQ representation-selection task, not open construction.
- Context ids and misconception tags use the `u1_5__` namespace and are append-only.
- Contexts are synthetic and realistic; no College Board wording is copied.
- Distractors are specific to the displayed data and each carries catalog provenance.
