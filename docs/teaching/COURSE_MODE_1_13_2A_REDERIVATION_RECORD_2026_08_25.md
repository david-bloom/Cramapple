# Course Mode 1.13 x 2.A Re-Derivation Record

Date: 2026-08-25
Cell: 1.13 x 2.A
Track: B, authored conceptual slot-frame
Frame: FB-U1-13-2A-DESIGN-01
Difficulty: Medium
Serving/grading: MCQ choice-match

## Scope

This record supports the study-design slot frame added in `scripts/course_mode_stats_generator/slot_frames.py`. The frame presents an experiment or observational study and asks for the supported design element or flaw. Distractors are tied to cell-namespaced misconception tags.

No loader run, database write, release, serving switch, or production change was performed.

## Harness Evidence

Command: `python3 scripts/course_mode_stats_generator/slot_frames.py`

Result: PASS

- 1.13 x 2.A instances: 120
- 1.13 x 2.A checks: 960
- 1.13 x 2.A rejects/failures: 0
- Distinct prompts: 6
- Correct answer positions observed: 0, 1, 2, 3
- Meta-tests green, including catalog self-checks and all new u1_13 misconception tags used

Catalog checks:

- `python3 scripts/course_mode_stats_generator/misconceptions.py`: ok true
- `python3 scripts/course_mode_stats_generator/scenarios.py`: ok true

## Gate 2: Independent Re-Derivation

### Seed 11300

Scenario: A researcher records students' usual screen time and usual sleep hours, then compares sleep between high and low screen-time students.

Key derivation: The researcher records existing habits and does not impose screen-time treatments, so this is observational.

Distractor checks:

- `u1_13__observational_treated_as_experiment`: says it is an experiment merely because two groups are compared; comparison alone is not treatment assignment.
- `u1_13__control_blinding_randomization_confused`: says natural variation in schedules is randomization; randomization requires assignment by the researcher.
- `u1_13__control_blinding_randomization_confused`: calls the lower-screen-time comparison group a placebo group; no inactive treatment or placebo is described.

### Seed 11301

Scenario: Volunteers with headaches are randomly assigned to receive a new pill or an identical-looking inactive pill, then pain ratings are compared.

Key derivation: Researchers impose treatments, so this is an experiment. The identical-looking inactive pill is a placebo control because it gives a baseline while accounting for expectation or natural improvement.

Distractor checks:

- `u1_13__control_blinding_randomization_confused`: says the inactive pill is the randomization method, but random assignment is the allocation process; the inactive pill is the placebo/control condition.
- `u1_13__observational_treated_as_experiment`: says the study is observational because pain ratings are observed; observing outcomes after assigned treatment does not make the study observational.
- `u1_13__confounding_vs_lurking_confused`: claims confounding because one group receives an inactive pill; that is the intended control comparison, not a mixed explanatory variable.

Together, these two seeds cover all three new misconception tags.

## CED/Protocol Conformance

- Skill 2.A is served as scenario classification by MCQ.
- Context ids and misconception tags use the `u1_13__` namespace and are append-only.
- Scenarios are synthetic and realistic; no College Board wording is copied.
- Distractors are specific to the scenario and keep tag direction honest.
