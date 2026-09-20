# Course Mode 1.2 x 2.A Re-Derivation Record

STATUS: authoring QA record | DATE: 2026-08-24 | CELL: 1.2 x 2.A | TRACK: B

## Scope

- Template: `FB-U1-2-2A-VARIABLES-01`
- Generator: `scripts/course_mode_stats_generator/slot_frames.py`
- Cell: Topic 1.2 Variables x Skill 2.A
- Serving/grading: MCQ choice-match
- Difficulty: Easy-Medium
- Release status: unreleased/generated pending review

This is an authored conceptual slot-frame. Correctness is determined by what the recorded values mean: categories classify units; counts and measurements are quantitative; numeric identifiers/codes remain categorical.

## Gate 1 Property Harness

Command:

```bash
python3 scripts/course_mode_stats_generator/slot_frames.py
```

Result for this template:

```text
FB-U1-2-2A-VARIABLES-01 | cell 1.2 x 2.A | 120 instances | 1200 checks | 0 failures | 15 distinct prompts | correct positions [0, 1, 2, 3]
```

Meta-tests also passed: all frames OK, correct-answer position varies, misconception catalog self-check clean, scenario catalog self-check clean, and all three new `u1_2__` misconception tags are used.

## Gate 2 Independent Re-Derivation

I re-derived the key and every new distractor type from the variable meaning, not from the stored `correct` flags.

### Instance A

- Seed: `12000`
- Scenario: `u1_2__jersey_number`
- Stem summary: in a youth soccer roster, each player's recorded variable is jersey number.

Independent key derivation:

- A jersey number is an identifier/label for a player.
- Arithmetic on jersey numbers is not meaningful for the statistical question.
- Therefore the variable is categorical.
- Emitted key matched: `categorical, because the number is an identifier, not a measurement.`

Distractor checks:

- `u1_2__numeric_codes_called_quantitative`: `quantitative continuous, because larger jersey numbers are greater values` treats numeric labels as measurements. That matches the tag.
- `u1_2__numeric_codes_called_quantitative`: `quantitative discrete, because jersey numbers are whole numbers` treats whole-number codes as counts. That matches the same numeric-code misconception.
- `u1_2__counts_or_ordinal_miscategorized`: `ordinal categorical, because the numbers put players in ranked order` incorrectly imposes order on identifier codes. That matches the ordered-category/count confusion pattern.

### Instance B

- Seed: `12003`
- Scenario: `u1_2__household_size`
- Stem summary: in a city-services survey, each household's recorded variable is number of people living in the household.

Independent key derivation:

- Household size is a count of people.
- Counts are numerical values for which differences and averages are meaningful.
- Counts are discrete because they change in whole people, not arbitrary fractional values for an individual household.
- Therefore the variable is quantitative discrete.
- Emitted key matched: `quantitative discrete, because the value is a count of people.`

Distractor checks:

- `u1_2__quantitative_called_categorical`: `categorical, because households can be grouped as small or large` mistakes possible grouping for the original variable type. The recorded value is still quantitative.
- `u1_2__counts_or_ordinal_miscategorized`: `categorical ordinal, because larger households rank above smaller households` treats a count as an ordered label rather than a numerical count.
- `u1_2__counts_or_ordinal_miscategorized`: `quantitative continuous, because the average household size can be a decimal` confuses a mean of counts with the individual variable's discrete count type.

All emitted keys and distractors matched their claimed variable-type logic.

## Gate 3 CED Conformance & Rights

- CED alignment: Topic 1.2 Variables, Skill 2.A. The frame asks students to identify/describe variable type in context.
- Fact-pack anchor: `AP_STATISTICS_2027_CED_FACT_PACK.md` §10 Unit 1 (1.2), which distinguishes categorical variables from quantitative variables.
- Scenario/source rights: contexts are original synthetic school, civic, health, library, and manufacturing settings. No College Board question, released prompt, key, scoring language, or third-party wording was copied.

## Gate 4 Distractor Realism

Each distractor is a plausible student classification error for the specific variable shown:

- numeric codes called quantitative;
- counts or ordinal labels miscategorized;
- genuine measurements/counts called categorical because they can be grouped.

All distractors are catalog-cited in `misconceptions.py` and all variable slots are cell-namespaced in `scenarios.py`.

## Non-Execution Attestation

No loader was run, no SQL was generated or applied, no DB was touched, no release was attempted, no serving switch was flipped, and Production was untouched.
