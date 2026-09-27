# Course Mode Stats 2.4 x 3.C Re-Derivation Record

Date: 2026-08-26
Branch: `content/course-mode-stats-2.4-3c`
Template: `basic_probability`
Cell: AP Statistics `2.4 x 3.C` - Introduction to Probability; calculate basic probabilities.
Track/serving: Track A computational, served as MCQ choice-match with deterministic numeric substrate retained.

## Gate 1 - Property Harness

Required commands run:

- `python3 generator.py`: PASS. `basic_probability`: 80 instances, 1360 checks, reject rate `0/80`; total computational sweep 960 instances, 14400 checks, all meta-tests green.
- Explicit `generator.property_report(120)`: PASS. `basic_probability`: 120 instances, 2040 checks, reject rate `0/120`; total computational sweep 1440 instances, 21600 checks, all meta-tests green.
- `python3 slot_frames.py`: PASS. 960 Track B instances, 9600 checks, all meta-tests green.
- `python3 scenarios.py`: PASS. `basic_probability` framing present; `u2_4_probability` context bank has 5 contexts; no self-check problems.
- `python3 misconceptions.py`: PASS. 67 entries; `basic_probability` has 3 cell-namespaced tags; no self-check problems.
- `python3 build_load_sql.py --check`: PASS. 220 packages, 0 problems.
- `python3 build_load_sql.py`: PASS. Regenerated local DRAFT SQL only.

## Gate 2 - Independent Re-Derivation

Checked emitted instance: `basic_probability-024000`.

Prompt data: A packet contains mixed seeds that are equally likely to be drawn: basil 26, dill 18, mint 34, parsley 30. Event: selecting a basil or dill seed.

From first principles, the finite sample space total is:

`26 + 18 + 34 + 30 = 108` equally likely seed outcomes.

The favorable outcomes are basil or dill:

`26 + 18 = 44`.

Correct probability:

`P(E) = favorable / total = 44 / 108 = 0.407407...`, displayed as `P = 0.407` and deterministic numeric answer `0.4074` with tolerance `0.001`. This matches the emitted key.

Distractor re-derivations:

- `u2_4__used_complement_probability`: non-event outcomes are mint or parsley, `34 + 30 = 64`. Complement probability is `64 / 108 = 0.592592...`, displayed as `P = 0.593`. This matches the emitted distractor and represents swapping the requested event with its complement.
- `u2_4__used_odds_instead_of_probability`: odds in favor divide favorable outcomes by non-event outcomes, `44 / 64 = 0.6875`, displayed as `P = 0.688`. This matches the emitted distractor and represents using odds rather than probability.
- `u2_4__used_partial_sample_space_denominator`: the partial denominator used by the template keeps the favorable count but includes only the first non-event category in the denominator. Here that is `44 / (44 + 34) = 44 / 78 = 0.564102...`, displayed as `P = 0.564`. This matches the emitted distractor and represents omitting part of the sample space from the denominator.

All three distractors are probabilities in `[0, 1]`, distinct from the key, and plausible for the scenario.

## Gate 3 - CED Conformance And Rights

The item is limited to Topic 2.4 content from the in-repo fact pack: finite equally likely outcomes, `P(E) = outcomes in E / total outcomes in sample space`, `0 <= P(E) <= 1`, and the complement rule. It does not use conditional probability, independence, unions as a separate formula, random variables, binomial, or Normal content.

Contexts are original synthetic settings. No College Board question, key, scoring wording, or released prompt was copied or paraphrased.

## Gate 4 - Realistic Distractors

The misconception tags are cell-namespaced under `u2_4__` and cite `AP_STATISTICS_2027_CED_FACT_PACK.md S10 Unit 2 (2.4)`. Each emitted distractor is a documented structural probability error and remains inside the scenario's plausibility envelope.

## Release Boundary

No loader application, DB write, release, serving switch, frontend/router/engine change, Edge deploy, Dev mutation, or Production action was performed. The generated SQL is DRAFT-only for later review.
