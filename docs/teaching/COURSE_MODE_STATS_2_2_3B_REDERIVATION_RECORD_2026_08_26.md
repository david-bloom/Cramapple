# Course Mode Stats 2.2 x 3.B Re-Derivation Record

Date: 2026-08-26
Branch: content/course-mode-stats-2.2-3b
Template: two_way_proportions
Cell: 2.2 x 3.B, Summary Statistics for Two Categorical Variables
Track: A computational, served as MCQ with deterministic numeric check
Difficulty: Medium

## Scope

This template asks students to calculate marginal and conditional proportions from an original synthetic two-way table of counts. It assesses the 2.2 x 3.B calculation skill only. The package is MCQ-facing, but the item retains `numeric_form.deterministic_checks` so the value is independently verifier-backed.

No College Board prompt, scoring language, or released item wording was used. Contexts are synthetic and the misconception tags cite AP_STATISTICS_2027_CED_FACT_PACK.md S10 Unit 2 (2.2) for the marginal/conditional denominator structure.

## Gate 1 Property Harness

`python3 scripts/course_mode_stats_generator/generator.py` on the repo default reported:

- two_way_proportions: 80 instances, 1360 checks, reject_rate 0/80
- all computational procedures: 960 instances, 14400 checks
- meta_failures: []
- OVERALL: PASS

An explicit >=100 run using `property_report(120)` reported:

- two_way_proportions: 120 instances, 2040 checks, reject_rate 0/120
- all computational procedures: 1440 instances, 21600 checks
- meta_failures: []
- ok: true

Catalog and companion harness checks:

- `python3 scripts/course_mode_stats_generator/misconceptions.py`: ok true, 71 entries, two_way_proportions tags present.
- `python3 scripts/course_mode_stats_generator/scenarios.py`: ok true, two_way_proportion context bank count 6.
- `python3 scripts/course_mode_stats_generator/slot_frames.py`: ok true, 960 instances, 9600 checks.
- `python3 scripts/course_mode_stats_generator/build_load_sql.py --check`: validated 200 packages, 0 problems before DRAFT regeneration.
- `python3 scripts/course_mode_stats_generator/build_load_sql.py`: validated 220 packages, 0 problems and regenerated `out/f4_load_DRAFT.sql` locally.

## Gate 2 Independent Re-Derivation

Checked emitted sample `scripts/course_mode_stats_generator/out/two_way_proportions-022000.json`.

Prompt table:

- Line A: Pass 72, Rework 28, Fail 24
- Line B: Pass 80, Rework 26, Fail 18

Question: Calculate the proportion of Line A who are in the Rework category.

Totals by hand:

- Line A row total = 72 + 28 + 24 = 124
- Line B row total = 80 + 26 + 18 = 124
- Rework column total = 28 + 26 = 54
- Grand total = 124 + 124 = 248

Correct key:

- Conditional on Line A, the denominator is the Line A row total.
- Rework within Line A = 28 / 124 = 0.225806..., displayed as 0.226.
- Emitted correct option: 0.226. Matches.

Distractors checked:

- `u2_2__used_complement_category`: uses the correct Line A denominator but counts not-Rework in Line A: (124 - 28) / 124 = 96 / 124 = 0.774193..., displayed as 0.774. Matches.
- `u2_2__used_grand_total_for_conditional`: uses the requested cell count over the whole table total: 28 / 248 = 0.112903..., displayed as 0.113. Matches.
- `u2_2__swapped_conditioning_denominator`: uses the Rework column total instead of the Line A row total: 28 / 54 = 0.518518..., displayed as 0.519. Matches.

All distractors are plausible two-way-table denominator or event-selection mistakes, inside [0, 1], distinct from the key, and tied to cited misconception tags.

## Gate 3 CED Conformance And Rights

Cell `2.2 x 3.B` is valid in `cells.py`: Summary Statistics for Two Categorical Variables x Calculate summary statistics. The template calculates marginal and conditional proportions from two categorical variables, aligning with the stated skill. All scenarios are synthetic and framed through the in-repo fact-pack structure, not copied from official or third-party items.

## Gate 4 Realistic Distractors

Distractors are computed from the same table as the key. They preserve realistic proportion scale and encode common denominator/category confusions: grand-total denominator for conditional questions, row/column conditioning swap, complement category, conditional-vs-marginal substitution, joint-cell-as-margin, and mixed row/column margins.

## Release Safety

No DB write, loader application, release function, serving switch, frontend/router/engine change, Edge deploy, Dev change, or Prod change was performed. `build_load_sql.py` was run only to validate packages and regenerate the local DRAFT SQL artifact.
