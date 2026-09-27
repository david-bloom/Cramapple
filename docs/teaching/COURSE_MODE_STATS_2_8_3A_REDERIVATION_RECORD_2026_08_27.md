# Course Mode Stats 2.8 x 3.A Re-Derivation Record

Date: 2026-08-27
Branch: content/course-mode-stats-2.8-3a
Cell: 2.8 x 3.A, Introduction to Random Variables and Probability Distributions
Track: B -- conceptual slot-frame, served as MCQ choice-match
Frame: FB-U2-8-3A-RANDOM-VARIABLE-DIST-01
Template: slotframe_u2_8_random_variable_distributions

## Scope

This frame asks students to select a valid probability distribution representation for a discrete random variable. A valid table must list point probabilities P(X = x), each probability must be between 0 and 1 inclusive, and the probabilities must sum to 1.

No DB write, loader application, release, serving switch, frontend/router/engine change, Edge deploy, Dev mutation, or Prod mutation was performed.

## Gate 1 Property Harness

Track B harness line for this template:

- FB-U2-8-3A-RANDOM-VARIABLE-DIST-01, cell 2.8 x 3.A: 120 instances, 1560 checks, 5 distinct prompts/contexts, correct answer positions [0, 1, 2, 3], failures [], ok true.

Full Track B sweep:

- 1080 instances, 11160 checks, meta-tests green: all_frames_ok, correct_answer_position_varies, misconception_catalog_self_check, scenario_catalog_self_check, all_frame_expected_tags_used.

Catalog checks:

- scenarios.py: ok true; slotframe_u2_8_random_variable_distributions present; u2_8_random_variables context bank count = 5.
- misconceptions.py: ok true; three cell-namespaced tags present for slotframe_u2_8_random_variable_distributions.

Loader dry-run:

- build_load_sql.py --check: validated 220 packages, 0 problems.

## Gate 2 Independent Re-Derivation

Sample checked: scripts/course_mode_stats_generator/out/slotframe-u2_8-3a-022800.json

Stem summary: N is the number of returned items in a sample of four orders. Values are 0, 1, 2, 3, 4.

### Correct Key

Displayed key:

- Probability table: N=0: 0.52; N=1: 0.29; N=2: 0.13; N=3: 0.05; N=4: 0.01

Hand check from first principles:

- All listed probabilities are between 0 and 1.
- Sum = 0.52 + 0.29 + 0.13 + 0.05 + 0.01 = 1.00.
- The table is labeled as point probabilities for values of N, so it is a valid probability distribution.

Result: matches the emitted correct option.

### Distractor: probabilities do not sum to one

Tag: u2_8__probabilities_do_not_sum_to_one

Displayed distractor:

- Probability table: N=0: 0.52; N=1: 0.29; N=2: 0.13; N=3: 0.05; N=4: 0.09

Hand check:

- Sum = 0.52 + 0.29 + 0.13 + 0.05 + 0.09 = 1.08, not 1.00.
- Each individual value is nonnegative, so the tempting mistake is accepting the table format without checking total probability.

Result: the emitted distractor matches the named misconception.

### Distractor: negative probability allowed

Tag: u2_8__negative_probability_allowed

Displayed distractor:

- Probability table: N=0: 0.57; N=1: 0.29; N=2: 0.13; N=3: 0.05; N=4: -0.04

Hand check:

- N=4 has probability -0.04, which is impossible because probabilities cannot be negative.
- The listed probabilities sum to 1.00, making this a plausible distractor for students who check only the total and not the range condition.

Result: the emitted distractor matches the named misconception.

### Distractor: cumulative probability confused with point probability

Tag: u2_8__cumulative_probability_confused_with_point_probability

Displayed distractor:

- Cumulative probability table: N=0: 0.52; N=1: 0.81; N=2: 0.94; N=3: 0.99; N=4: 1.00

Hand check:

- These are cumulative sums: 0.52, 0.52+0.29=0.81, +0.13=0.94, +0.05=0.99, +0.01=1.00.
- They represent P(N <= n), not point probabilities P(N = n). If misread as point probabilities, their total is 4.26, not 1.00.

Result: the emitted distractor matches the named misconception.

## Gates 3 and 4

CED conformance: cell 2.8 x 3.A is a Practice 3.A representation-reading task for probability distributions. The frame uses original synthetic contexts and CED structure only, with no College Board wording.

Distractor realism: each distractor is a plausible AP Statistics error for probability distributions and is tied to a cited, cell-namespaced misconception tag. The distractors are not throwaway options: one checks total probability, one checks probability range, and one distinguishes point-probability distributions from cumulative-probability tables.
