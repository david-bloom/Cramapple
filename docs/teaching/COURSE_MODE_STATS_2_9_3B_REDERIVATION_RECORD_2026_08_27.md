# Course Mode Stats 2.9 x 3.B Re-Derivation Record

Date: 2026-08-27  
Branch: `content/course-mode-stats-2.9-3b`  
Template/procedure: `random_variable_params`  
Track: A computational, served as MCQ  
Cell: AP Statistics Unit 2 Topic 2.9, Skill 3.B  
Difficulty: Medium

## Scope

This template asks for the standard deviation of a discrete random variable from a complete probability distribution. The expected value is computed first in the worked solution, then the variance and standard deviation are computed from the probability-weighted squared deviations.

CED/fact-pack conformance: `AP_STATISTICS_2027_CED_FACT_PACK.md S10 Unit 2 (2.9)` states `mu_X = E(X) = sum x_i P(x_i)` and `sigma_X = sqrt(sum (x_i - mu_X)^2 P(x_i))`. The scenarios are original synthetic contexts and do not use College Board wording.

## Gate 1 Property Harness

Explicit `generator.property_report(120)`:

- `random_variable_params`: 120 instances, 2280 checks, reject rate `0/120`.
- Full computational sweep: 1440 instances, 21840 checks, all procedures `0/120`, `meta_failures: []`, `ok: true`.

Required command QA also passed:

- `python3 generator.py`: PASS; `random_variable_params` 80 instances / 1520 checks / `0/80` rejects; full sweep 960 instances / 14560 checks.
- `python3 slot_frames.py`: PASS; 960 instances / 9600 checks; meta-tests green.
- `python3 scenarios.py`: PASS; scenario catalog ok; `random_variable` context bank count 6.
- `python3 misconceptions.py`: PASS; catalog ok; 68 entries; four `random_variable_params` tags.
- `python3 build_load_sql.py --check`: PASS; 220 packages / 0 problems.
- `python3 build_load_sql.py`: PASS; regenerated DRAFT SQL only.
- `git diff --check`: clean.

## Gate 2 Independent Re-Derivation

Primary sample: `random_variable_params-029000.json`.

Prompt distribution: values 0, 1, 2, 3 retries with probabilities 0.22, 0.36, 0.27, 0.15.

Correct key, derived from first principles:

- `mu_X = 0(0.22) + 1(0.36) + 2(0.27) + 3(0.15) = 1.35`.
- Squared-deviation variance:
  - `(0 - 1.35)^2(0.22) = 0.40095`
  - `(1 - 1.35)^2(0.36) = 0.04410`
  - `(2 - 1.35)^2(0.27) = 0.114075`
  - `(3 - 1.35)^2(0.15) = 0.408375`
  - total variance `0.9675`.
- `sigma_X = sqrt(0.9675) = 0.9836157786`, displayed as `0.98`. This matches the emitted correct option.

Displayed distractors in sample 029000:

- `u2_9__unweighted_mean_values`: `(0 + 1 + 2 + 3) / 4 = 1.50`, displayed as `1.50`. Matches.
- `u2_9__unweighted_sd_values`: equal-weight SD about the four outcomes uses mean `1.50`; `sqrt(((0-1.5)^2 + (1-1.5)^2 + (2-1.5)^2 + (3-1.5)^2)/4) = sqrt(1.25) = 1.1180`, displayed as `1.12`. Matches.
- `u2_9__off_by_one_discrete_value`: shifted outcomes 1, 2, 3, 4 with the original probabilities gives `1(0.22)+2(0.36)+3(0.27)+4(0.15)=2.35`, displayed as `2.35`. Matches.

Secondary sample for the variance-not-SD distractor: generated seed 29001.

Distribution: values 0, 1, 2, 3 defective sensors with probabilities 0.60, 0.24, 0.11, 0.05.

- `mu_X = 0(0.60)+1(0.24)+2(0.11)+3(0.05)=0.61`.
- `V(X)=0.7579`.
- `sigma_X=sqrt(0.7579)=0.8705745229`, displayed as `0.87`.
- `u2_9__reported_variance_not_sd`: reports `0.7579` directly as the standard deviation, displayed as `0.76`. Matches.

All displayed distractors are on-scale, distinct from the key beyond the deterministic tolerance, and map to cited cell-namespaced misconception tags.

## Gates 3 and 4

- Skill/difficulty: 2.9 x 3.B, Medium computational calculation from a discrete probability distribution.
- Rights: synthetic contexts only; no verbatim College Board content.
- Distractor realism: each wrong option represents a documented or formula-structural mistake for expected value / variance / standard deviation of a discrete random variable, and each emitted numeric option is plausible in the scenario's nonnegative count context.

## Non-Actions

No loader application, DB write, release, serving switch, frontend/router/engine change, Dev mutation, or Prod mutation was performed.
