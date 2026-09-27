# Course Mode Stats 1.4 x 3.A Re-Derivation Record - 2026-08-26

Branch: `content/course-mode-stats-1.4-3a`
Frame: `FB-U1-4-3A-CAT-GRAPH-01`
Template: `slotframe_u1_4_cat_graphs`
Cell: Topic 1.4, Skill 3.A
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

- `slotframe_u1_4_cat_graphs` appears in the procedure list.
- `u1_4_cat_graphs` context bank count: 5.
- self_check_problems: []
- ok: true

Command: `python3 scripts/course_mode_stats_generator/misconceptions.py`

- `slotframe_u1_4_cat_graphs` maps to:
  - `u1_4__categorical_graph_as_quantitative_axis`
  - `u1_4__count_percent_graph_confusion`
  - `u1_4__relative_frequency_graph_denominator_error`
- self_check_problems: []
- ok: true

## Independent Re-Derivation Sample

Sample package: `slotframe-u1_4-3a-014000`

Prompt basis: 108 households classified by primary pet type.

Counts:

- dog: 46
- cat: 33
- fish: 12
- none: 17

Total: 46 + 33 + 12 + 17 = 108.

Correct relative-frequency bar heights, rounded to the nearest percent:

- dog: 46 / 108 = 0.4259... -> 43%
- cat: 33 / 108 = 0.3056... -> 31%
- fish: 12 / 108 = 0.1111... -> 11%
- none: 17 / 108 = 0.1574... -> 16%

Correct key:

`Relative-frequency bar graph with separate category bars: dog: 43%; cat: 31%; fish: 11%; none: 16%`

The key preserves the categorical labels, uses separate bars rather than a connected quantitative display, and divides each category count by the total number of observations.

## Distractor Re-Derivation

Distractor tag: `u1_4__relative_frequency_graph_denominator_error`

Text: `Relative-frequency bar graph using the largest category as the denominator: dog: 100%; cat: 72%; fish: 26%; none: 37%`

Check: the largest category count is 46. The distractor computes 46/46 = 100%, 33/46 = 72%, 12/46 = 26%, and 17/46 = 37%. This is internally coherent as the stated misconception and incorrect because relative frequencies must use the total 108 as the denominator.

Distractor tag: `u1_4__categorical_graph_as_quantitative_axis`

Text: `Line graph on a number line after coding the categories as 1=dog, 2=cat, 3=fish, 4=none, with points connected in code order`

Check: the response turns nominal categories into ordered numeric positions and connects them, which represents the cataloged misconception. It is incorrect because the variable is categorical and the requested display is a relative-frequency bar graph.

Distractor tag: `u1_4__count_percent_graph_confusion`

Text: `Relative-frequency bar graph with bar heights copied from the counts: dog: 46%; cat: 33%; fish: 12%; none: 17%`

Check: the displayed percentages are the raw counts with percent signs attached. This is the cataloged count/percent confusion and is incorrect because the correct relative frequencies are 43%, 31%, 11%, and 16%.

## CED / Rights Conformance

- Topic 1.4 / Skill 3.A alignment: the item asks for a representation of one categorical variable from category counts.
- Practice 3 alignment: the response requires selecting the correct graphical representation.
- No official College Board wording, questions, or identifiable scenario structures were used.
- Contexts are original synthetic settings.

## Non-Actions

No loader application, database write, release, serving switch, Edge Function deployment, or production change was performed.
