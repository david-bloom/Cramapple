# Course Mode Stats 2.1 x 4.A Re-Derivation Record - 2026-08-26

Branch: `content/course-mode-stats-2.1-4a`
Frame: `FB-U2-1-4A-TWOWAY-01`
Template: `slotframe_u2_1_twoway_interpret`
Cell: Topic 2.1, Skill 4.A
Track: B - authored conceptual slot-frame
Serving/grading: MCQ choice-match
Release status: unreleased generated pending review

## Property Harness Evidence

Command: `python3 scripts/course_mode_stats_generator/slot_frames.py`

Relevant frame result:

- instances: 120
- checks: 1200
- distinct prompts: 20
- correct answer positions: [0, 1, 2, 3]
- correct_answer_position_varies: true
- failures: []
- ok: true

Meta-tests were green, including catalog self-checks and expected-tag coverage.

## Catalog Evidence

Command: `python3 scripts/course_mode_stats_generator/scenarios.py`

- `slotframe_u2_1_twoway_interpret` appears in the procedure list.
- `u2_1_twoway` context bank count: 5.
- self_check_problems: []
- ok: true

Command: `python3 scripts/course_mode_stats_generator/misconceptions.py`

- `slotframe_u2_1_twoway_interpret` maps to:
  - `u2_1__raw_counts_as_conditional_comparison`
  - `u2_1__used_column_denominator_for_row_condition`
  - `u2_1__marginal_percent_treated_as_conditional`
- self_check_problems: []
- ok: true

## Independent Re-Derivation Sample

Sample package: `slotframe-u2_1-4a-021000`

Prompt basis: two-way table for grade level and bus status.

Counts:

| Grade level | bus | not bus | row total |
|---|---:|---:|---:|
| 9th grade | 44 | 60 | 104 |
| 12th grade | 32 | 22 | 54 |

Column total for bus: 44 + 32 = 76.
Grand total: 104 + 54 = 158.

Correct row-conditional percentages for bus:

- 9th grade: 44 / 104 = 0.423... -> 42%
- 12th grade: 32 / 54 = 0.592... -> 59%

Correct key:

`About 59% of 12th grade are in the 'bus' category, compared with about 42% of 9th grade, so 12th grade have the larger conditional percentage.`

The key uses the row totals as denominators because the comparison is within grade-level groups.

## Distractor Re-Derivation

Distractor tag: `u2_1__used_column_denominator_for_row_condition`

Text: `Among cases in the 'bus' category, about 58% are 9th grade and 42% are 12th grade, so those are the conditional percentages within the two grade level groups.`

Check: 44 / 76 = 0.579... -> 58%; 32 / 76 = 0.421... -> 42%. These are column-conditional percentages among bus riders, not row-conditional percentages within each grade level. The value matches the named denominator error.

Distractor tag: `u2_1__marginal_percent_treated_as_conditional`

Text: `Overall, about 48% of all cases are in the 'bus' category, so each grade level group has about 48% in that category.`

Check: 76 / 158 = 0.481... -> 48%. This is the marginal bus percentage across all cases. It is incorrect because the two row-conditional percentages are 42% and 59%, not both 48%.

Distractor tag: `u2_1__raw_counts_as_conditional_comparison`

Text: `Because the count 44 is larger than 32, 9th grade have the larger conditional percentage than 12th grade.`

Check: the raw bus count is larger for 9th grade, but row totals differ. The conditional percentages reverse the raw count comparison: 44/104 -> 42%, while 32/54 -> 59%. The distractor represents comparing counts instead of conditional proportions.

## CED / Rights Conformance

- Topic 2.1 / Skill 4.A alignment: the item asks for an interpretation of a two-way table for two categorical variables.
- Practice 4 alignment: the response requires interpreting conditional distributions rather than computing a standalone result.
- No official College Board wording, questions, or identifiable scenario structures were used.
- Contexts are original synthetic settings.

## Non-Actions

No loader application, database write, release, serving switch, Edge Function deployment, or production change was performed.
