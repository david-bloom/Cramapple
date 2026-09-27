# Course Mode Stats 3.2 x 3.D Re-Derivation Record - 2026-08-27

Branch: `content/course-mode-stats-3.2-3d`
Procedure: `sample_prop_distribution`
Cell: Topic 3.2, Skill 3.D
Track: A - computational procedure, served as MCQ
Release status: unreleased generated pending review

## Property Harness Evidence

Command: `python3 scripts/course_mode_stats_generator/generator.py`

Relevant procedure result:

- instances: 80
- checks: 1120
- reject rate: 0/80
- overall: PASS

Explicit bar command: `generator.property_report(120)`

Relevant procedure result:

- instances: 120
- checks: 1680
- reject rate: 0/120
- failures: []
- overall: PASS

## Catalog Evidence

Command: `python3 scripts/course_mode_stats_generator/scenarios.py`

- `sample_prop_distribution` appears in the procedure list.
- `u3_2_sample_prop` context bank count: 5.
- self_check_problems: []
- ok: true

Command: `python3 scripts/course_mode_stats_generator/misconceptions.py`

- `sample_prop_distribution` maps to:
  - `u3_2__used_observed_count_as_mean`
  - `u3_2__omitted_sqrt_in_sd`
  - `u3_2__used_count_sd_instead_of_proportion_sd`
- self_check_problems: []
- ok: true

## Independent Re-Derivation Sample

Sample package: `sample_prop_distribution-032000`
Content key: `apstat-u3-2-3d-sample_prop_distribution-032000`

Prompt basis: population proportion p = 0.70, sample size n = 80. Asked for the mean and standard deviation of the sampling distribution of p-hat.

Correct mean:

mean(p-hat) = p = 0.700.

Correct standard deviation:

SD(p-hat) = sqrt(p(1-p)/n) = sqrt(0.70 * 0.30 / 80) = sqrt(0.002625) = 0.051234... -> 0.0512.

Correct key: `mean = 0.700, SD = 0.0512`.

## Distractor Re-Derivation

Distractor tag: `u3_2__used_observed_count_as_mean`

Text: `mean = 56, SD = 0.0512`

Check: 80 * 0.70 = 56. This uses the expected count as the mean instead of p as the mean of p-hat.

Distractor tag: `u3_2__omitted_sqrt_in_sd`

Text: `mean = 0.700, SD = 0.0026`

Check: 0.70 * 0.30 / 80 = 0.002625 -> 0.0026. This omits the square root in the SD formula.

Distractor tag: `u3_2__used_count_sd_instead_of_proportion_sd`

Text: `mean = 0.700, SD = 4.0988`

Check: sqrt(n p (1-p)) = sqrt(80 * 0.70 * 0.30) = sqrt(16.8) = 4.09878... -> 4.0988. This is the SD of a count, not the SD of p-hat.

## CED / Rights Conformance

- Topic 3.2 / Skill 3.D alignment: the item asks for parameters of a sampling distribution for a sample proportion.
- Practice 3 alignment: the response requires calculating mean and SD.
- No official College Board wording, questions, or identifiable scenario structures were used.
- Contexts are original synthetic settings.

## Non-Actions

No loader application, database write, release, serving switch, Edge Function deployment, Dev mutation, or production change was performed.
