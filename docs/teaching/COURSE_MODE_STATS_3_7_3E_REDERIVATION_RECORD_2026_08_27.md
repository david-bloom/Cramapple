# Course Mode Stats 3.7 x 3.E Re-Derivation Record - 2026-08-27

Branch: `content/course-mode-stats-3.7-3e`
Procedure: `one_prop_ztest`
Cell: Topic 3.7, Skill 3.E
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

- `one_prop_ztest` appears in the procedure list.
- `u3_7_one_prop_test` context bank count: 5.
- self_check_problems: []
- ok: true

Command: `python3 scripts/course_mode_stats_generator/misconceptions.py`

- `one_prop_ztest` maps to:
  - `u3_7__used_phat_in_null_se`
  - `u3_7__reversed_z_numerator`
  - `u3_7__reported_one_sided_p_value_for_two_sided_test`
- self_check_problems: []
- ok: true

## Independent Re-Derivation Sample

Sample package: `one_prop_ztest-037000`
Content key: `apstat-u3-7-3e-one_prop_ztest-037000`

Prompt basis: H0: p = 0.45 versus Ha: p != 0.45. Random sample n = 220, x = 86.

p-hat = 86 / 220 = 0.390909...

Null standard error:

SE0 = sqrt(0.45 * 0.55 / 220) = sqrt(0.001125...) = 0.03354...

Test statistic:

z = (0.390909... - 0.45) / 0.03354... = -1.76175... -> -1.762.

Two-sided p-value:

2 * P(Z <= -1.76175...) = 0.07811... -> 0.078.

Correct key: `z = -1.762, p-value = 0.078`.

## Distractor Re-Derivation

Distractor tag: `u3_7__reversed_z_numerator`

Text: `z = 1.762, p-value = 0.078`

Check: this computes p0 - p-hat instead of p-hat - p0, reversing the sign of z. The two-sided p-value remains the same by symmetry.

Distractor tag: `u3_7__reported_one_sided_p_value_for_two_sided_test`

Text: `z = -1.762, p-value = 0.039`

Check: one tail is P(Z <= -1.76175...) = 0.03906..., but the stated alternative is two-sided, so the correct p-value doubles that tail area.

Distractor tag: `u3_7__used_phat_in_null_se`

Text: `z = -1.796, p-value = 0.072`

Check: this uses SE = sqrt(p-hat(1-p-hat)/n) = sqrt(0.3909*0.6091/220) = 0.03290..., giving z = -1.796 and a two-sided p-value about 0.072. A one-proportion z test uses p0 in the null standard error.

## CED / Rights Conformance

- Topic 3.7 / Skill 3.E alignment: the item asks for one-proportion test results.
- Practice 3 alignment: the response requires calculating a test statistic and p-value.
- No official College Board wording, questions, or identifiable scenario structures were used.
- Contexts are original synthetic settings.

## Non-Actions

No loader application, database write, release, serving switch, Edge Function deployment, Dev mutation, or production change was performed.
