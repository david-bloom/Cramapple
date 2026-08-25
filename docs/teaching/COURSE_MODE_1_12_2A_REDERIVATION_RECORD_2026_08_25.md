# Course Mode 1.12 x 2.A Re-Derivation Record

Date: 2026-08-25
Cell: 1.12 x 2.A
Track: B, authored conceptual slot-frame
Frame: FB-U1-12-2A-BIAS-01
Difficulty: Medium
Serving/grading: MCQ choice-match

## Scope

This record supports the sampling-bias slot frame added in `scripts/course_mode_stats_generator/slot_frames.py`. The frame presents a realistic data-collection scenario and asks for the supported bias classification, including an explicit no-clear-bias case so the `u1_12__no_bias_called_biased` tag is used in the correct direction.

No loader run, database write, release, serving switch, or production change was performed.

## Harness Evidence

Command: `python3 scripts/course_mode_stats_generator/slot_frames.py`

Result: PASS

- 1.12 x 2.A instances: 120
- 1.12 x 2.A checks: 960
- 1.12 x 2.A rejects/failures: 0
- Distinct prompts: 6
- Correct answer positions observed: 0, 1, 2, 3
- Meta-tests green, including catalog self-checks and all new u1_12 misconception tags used

Catalog checks:

- `python3 scripts/course_mode_stats_generator/misconceptions.py`: ok true
- `python3 scripts/course_mode_stats_generator/scenarios.py`: ok true

## Gate 2: Independent Re-Derivation

### Seed 11200

Scenario: A news website posts an open poll asking visitors to click if they support a proposed rule.

Key derivation: Participants self-select into the sample by choosing whether to click. That is voluntary-response bias, not random sampling and not merely nonresponse.

Distractor checks:

- `u1_12__bias_type_confused`: calling this nonresponse focuses on people who never answered, but the defining flaw is self-selection into an open poll.
- `u1_12__bias_type_confused`: calling this simple random sampling mistakes availability to all visitors for random selection.
- `u1_12__sampling_vs_nonsampling_error`: calling it response bias only invents a measurement/wording problem not stated in the scenario.

### Seed 11208

Scenario: A registrar uses a random-number generator to select 80 students from the complete roster; all selected students answer a neutral question.

Key derivation: The frame is complete, the selection is random, all selected students respond, and the wording is neutral. No clear bias is described by the facts given.

Distractor checks:

- `u1_12__no_bias_called_biased`: undercoverage is wrong because the complete roster was used; a sample being smaller than the population is not itself bias.
- `u1_12__no_bias_called_biased`: voluntary response is wrong because students were selected; merely answering is not self-selection.
- `u1_12__no_bias_called_biased`: nonresponse is wrong because all selected students answered.

Together, these two seeds cover all three new misconception tags.

## CED/Protocol Conformance

- Skill 2.A is served as scenario classification by MCQ.
- Context ids and misconception tags use the `u1_12__` namespace and are append-only.
- Scenarios are synthetic and realistic; no College Board wording is copied.
- Distractors are specific to the scenario and tag direction is honest.
