# Course Mode Stats 1.3 x 3.A Re-Derivation Record

Date: 2026-08-26
Cell: 1.3 x 3.A
Track: B, authored conceptual slot-frame
Frame: FB-U1-3-3A-CAT-TABLE-01
Difficulty: Easy-Medium
Serving/grading: MCQ choice-match

## Scope

This record supports the one-categorical-variable table representation slot frame added in `scripts/course_mode_stats_generator/slot_frames.py`. The frame gives category counts and asks for the matching relative-frequency representation. Distractors are tied to cell-namespaced misconception tags in `scripts/course_mode_stats_generator/misconceptions.py`.

No loader run against a database, database write, release, serving switch, edge deploy, or production change was performed.

## Harness Evidence

Command: `python3 scripts/course_mode_stats_generator/slot_frames.py`

Result: PASS

- 1.3 x 3.A instances: 120
- 1.3 x 3.A checks: 1200
- 1.3 x 3.A rejects/failures: 0
- Distinct prompts: 20
- Correct answer positions observed: 0, 1, 2, 3
- Meta-tests green, including catalog self-checks and all frame expected tags used

Catalog checks:

- `python3 scripts/course_mode_stats_generator/misconceptions.py`: ok true
- `python3 scripts/course_mode_stats_generator/scenarios.py`: ok true
- `python3 scripts/course_mode_stats_generator/generator.py`: OVERALL PASS for existing computational procedures

## Gate 2: Independent Re-Derivation

Seed 13000 prompt: 100 students classified by after-school activity choice. Counts: sports 42, music 28, service 18, none 12.

Hand derivation:

- Total = 42 + 28 + 18 + 12 = 100.
- Sports relative frequency = 42 / 100 = 0.42 = 42%.
- Music relative frequency = 28 / 100 = 0.28 = 28%.
- Service relative frequency = 18 / 100 = 0.18 = 18%.
- None relative frequency = 12 / 100 = 0.12 = 12%.

Key: relative-frequency table with sports 42%, music 28%, service 18%, none 12%.

Distractor checks:

- `u1_3__count_percent_confusion`: reports the raw frequency table 42, 28, 18, 12 instead of relative frequencies.
- `u1_3__relative_frequency_denominator_error`: divides each category by the largest category count, 42, yielding sports 100%, music about 67%, service about 43%, none about 29%, instead of using the total sample size.
- `u1_3__quantitative_display_for_categories`: puts category codes on a number line, treating category labels as quantitative positions rather than preserving category counts/relative frequencies.

## CED/Protocol Conformance

- Skill 3.A is served as read/choose representation by MCQ, not open construction.
- Context ids and misconception tags use the `u1_3__` namespace and are append-only.
- Contexts are synthetic and realistic; no College Board wording is copied.
- Distractors are specific to the displayed categorical summary and each carries catalog provenance.
