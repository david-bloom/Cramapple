# Course Mode Stats 2.7 x 3.C Re-Derivation Record - 2026-08-27

Branch: `content/course-mode-stats-2.7-3c`
Procedure: `u2_7_independent_union`
Cell: Topic 2.7, Skill 3.C
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

- `u2_7_independent_union` appears in the procedure list.
- `u2_7_independent_union` context bank count: 5.
- self_check_problems: []
- ok: true

Command: `python3 scripts/course_mode_stats_generator/misconceptions.py`

- `u2_7_independent_union` maps to:
  - `u2_7__added_without_subtracting_overlap`
  - `u2_7__reported_intersection_instead_of_union`
  - `u2_7__reported_not_both_instead_of_at_least_one`
- self_check_problems: []
- ok: true

## Independent Re-Derivation Sample

Sample package: `u2_7_independent_union-027000`
Content key: `apstat-u2-7-3c-independent_union-027000`

Prompt basis: event A = uses the search feature, P(A) = 0.45; event B = turns on notifications, P(B) = 0.32. The events are independent. Asked for P(A or B), the probability of at least one event.

Independent-event intersection:

P(A and B) = P(A)P(B) = 0.45 * 0.32 = 0.144.

Correct union probability:

P(A or B) = P(A) + P(B) - P(A and B) = 0.45 + 0.32 - 0.144 = 0.626.

Correct key: `0.626`.

## Distractor Re-Derivation

Distractor tag: `u2_7__added_without_subtracting_overlap`

Text: `0.770`

Check: this computes P(A)+P(B)=0.45+0.32=0.770 and fails to subtract the overlap P(A and B)=0.144.

Distractor tag: `u2_7__reported_intersection_instead_of_union`

Text: `0.144`

Check: this computes P(A and B)=0.45*0.32=0.144. It is the independent-events intersection, not the requested union.

Distractor tag: `u2_7__reported_not_both_instead_of_at_least_one`

Text: `0.856`

Check: this computes 1-P(A and B)=1-0.144=0.856. That is the probability the two events do not both occur, which incorrectly includes cases where neither event occurs.

## CED / Rights Conformance

- Topic 2.7 / Skill 3.C alignment: the item asks for a probability calculation involving independent events and a union.
- Practice 3 alignment: the response requires calculating a probability.
- No official College Board wording, questions, or identifiable scenario structures were used.
- Contexts are original synthetic settings.

## Non-Actions

No loader application, database write, release, serving switch, Edge Function deployment, Dev mutation, or production change was performed.
