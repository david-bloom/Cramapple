# Course Mode Stats 2.6 x 3.C Re-Derivation Record - 2026-08-26

Branch: `content/course-mode-stats-2.6-3c`
Procedure: `u2_6_cond_prob`
Cell: Topic 2.6, Skill 3.C
Track: A - computational procedure, served as MCQ
Release status: unreleased generated pending review

## Property Harness Evidence

Command: `python3 scripts/course_mode_stats_generator/generator.py`

Relevant procedure result:

- instances: 80
- checks: 1280
- reject rate: 0/80
- overall: PASS

Explicit bar command: `python3 - <<'PY' ... generator.property_report(120) ... PY`

Relevant procedure result:

- instances: 120
- checks: 1920
- reject rate: 0/120
- failures: []
- overall: PASS

## Catalog Evidence

Command: `python3 scripts/course_mode_stats_generator/scenarios.py`

- `u2_6_cond_prob` appears in the procedure list.
- `u2_6_cond_prob` context bank count: 5.
- self_check_problems: []
- ok: true

Command: `python3 scripts/course_mode_stats_generator/misconceptions.py`

- `u2_6_cond_prob` maps to:
  - `u2_6__used_joint_probability_instead_of_conditional`
  - `u2_6__reversed_the_condition`
  - `u2_6__used_condition_complement_count`
- self_check_problems: []
- ok: true

## Independent Re-Derivation Sample

Sample package: `u2_6_cond_prob-026000`
Content key: `apstat-u2-6-3c-cond_prob-026000`

Prompt basis: among 200 customers, 70 used a coupon, 50 returned within a month, and 30 both used a coupon and returned within a month. Asked for the probability a randomly selected member used a coupon given that the member returned within a month.

Let A = used a coupon and B = returned within a month.

Correct conditional probability:

P(A | B) = count(A and B) / count(B) = 30 / 50 = 0.600.

Correct key: `0.600`.

## Distractor Re-Derivation

Distractor tag: `u2_6__reversed_the_condition`

Text: `0.429`

Check: this computes P(B | A) = count(A and B) / count(A) = 30 / 70 = 0.42857... -> 0.429. It reverses the condition.

Distractor tag: `u2_6__used_condition_complement_count`

Text: `0.400`

Check: this computes the complement within the condition, count(B but not A) / count(B) = (50 - 30) / 50 = 20 / 50 = 0.400. It uses the condition denominator but the wrong numerator.

Distractor tag: `u2_6__used_joint_probability_instead_of_conditional`

Text: `0.150`

Check: this computes the joint probability count(A and B) / total = 30 / 200 = 0.150. It fails to restrict the sample space to the condition B.

## CED / Rights Conformance

- Topic 2.6 / Skill 3.C alignment: the item asks for a probability calculation from event counts.
- Practice 3 alignment: the response requires calculating a conditional probability.
- No official College Board wording, questions, or identifiable scenario structures were used.
- Contexts are original synthetic settings.

## Non-Actions

No loader application, database write, release, serving switch, Edge Function deployment, Dev mutation, or production change was performed.
