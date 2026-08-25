# Course Mode 1.9 x 3.B Re-Derivation Record

STATUS: authoring QA record | DATE: 2026-08-24 | CELL: 1.9 x 3.B | TRACK: A

## Scope

- Template: `compare_stats`
- Generator: `scripts/course_mode_stats_generator/generator.py`
- Cell: Topic 1.9 Comparing Distributions x Skill 3.B
- Serving/grading: numeric-entry deterministic, with MCQ choices also emitted
- Difficulty: Medium
- Release status: unreleased/generated pending review

The template presents two one-variable quantitative data sets and asks for a single statistic comparison, always Group A minus Group B. The requested statistic is one of mean, median, or IQR.

## Gate 1 Property Harness

Commands:

```bash
python3 scripts/course_mode_stats_generator/generator.py
python3 -c 'import sys,json; sys.path.insert(0,"scripts/course_mode_stats_generator"); import generator as g; insts=g.generate("compare_stats",120); failures=[]; checks=0
for inst in insts:
    for name, ok in inst["_property_checks"]:
        checks += 1
        if not ok:
            failures.append(str(inst["provenance"]["seed"]) + "/" + name)
print(json.dumps({"procedure":"compare_stats","instances":len(insts),"checks":checks,"rejects":len(failures),"failures":failures[:10]}, indent=2))'
```

Result for this template:

```text
compare_stats | 120 instances | 1920 checks | 0 rejects
```

The full computational harness also passed with no meta-failures: `compare_stats` reported `80/80` rejects `0/80` inside the full sweep.

## Gate 2 Independent Re-Derivation

I re-derived the key and every new distractor type from the displayed data and named statistic, not from the stored `correct` flags.

### Instance A

- Seed: `1000`
- Scenario: `u1_9__store_receipts`
- Asked statistic: Group A IQR minus Group B IQR
- Group A: 49, 51, 52, 55, 56, 56, 58
- Group B: 51, 55, 57, 58, 62, 66, 66

Independent key derivation using the TI-style five-number convention in `statlib`:

- Group A median is 55; lower half 49, 51, 52 gives Q1 = 51; upper half 56, 56, 58 gives Q3 = 56; IQR = 56 - 51 = 5.
- Group B median is 58; lower half 51, 55, 57 gives Q1 = 55; upper half 62, 66, 66 gives Q3 = 66; IQR = 66 - 55 = 11.
- Requested A - B = 5 - 11 = -6.
- Emitted key matched: `-6.00` with deterministic check value `-6.0` and tolerance `0.01`.

Distractor checks:

- `u1_9__sign_reversed_difference`: `6.00` equals B - A = 11 - 5. This matches the reversed-order misconception.
- `u1_9__reported_single_group_stat`: `5.00` equals Group A's IQR alone, with no subtraction. This matches the single-group-stat misconception.
- `u1_9__used_mean_not_median`: Group A mean = 377/7 = 53.8571; Group B mean = 415/7 = 59.2857; mean difference = -5.4286, displayed `-5.43`. This is a wrong-statistic comparison when IQR was requested.

### Instance B

- Seed: `1002`
- Scenario: `u1_9__trail_counts`
- Asked statistic: Group A IQR minus Group B IQR
- Group A: 55, 56, 56, 57, 60, 61, 62, 62, 68
- Group B: 61, 63, 64, 67, 69, 74, 74, 76, 82

Independent key derivation:

- Group A median is 60; lower half 55, 56, 56, 57 gives Q1 = 56; upper half 61, 62, 62, 68 gives Q3 = 62; IQR = 6.
- Group B median is 69; lower half 61, 63, 64, 67 gives Q1 = 63.5; upper half 74, 74, 76, 82 gives Q3 = 75; IQR = 11.5.
- Requested A - B = 6 - 11.5 = -5.5.
- Emitted key matched: `-5.50`.

Distractor checks:

- `u1_9__used_range_not_iqr`: Group A range = 68 - 55 = 13; Group B range = 82 - 61 = 21; range difference = 13 - 21 = -8. Emitted distractor `-8.00` matched the range-instead-of-IQR transform.
- `u1_9__sign_reversed_difference`: emitted `5.50` equals B IQR - A IQR.
- `u1_9__used_mean_not_median`: Group A mean = 537/9 = 59.6667; Group B mean = 630/9 = 70; mean difference = -10.3333, displayed `-10.33`.

All emitted keys and distractors matched their claimed formulas and misconception tags.

## Gate 3 CED Conformance & Rights

- CED alignment: Topic 1.9 Comparing distributions, Skill 3.B calculate. The item asks for a quantitative comparison statistic, not an interpretation or open justification.
- Fact-pack anchor: `AP_STATISTICS_2027_CED_FACT_PACK.md` §10 Unit 1 (1.7/1.9) distinguishes summary statistics and comparison calculations.
- Scenario/source rights: contexts are original synthetic biology, operations, education, business, and civic settings. No College Board question, released prompt, key, scoring language, or third-party wording was copied.

## Gate 4 Distractor Realism

Each distractor is a plausible student calculation error for the specific numbers shown:

- wrong statistic (mean/median/center when a different statistic was asked);
- range instead of IQR for spread;
- B - A instead of A - B;
- one group's statistic without subtraction.

All new distractors are catalog-cited in `misconceptions.py`; all new scenarios are cell-namespaced in `scenarios.py`.

## Non-Execution Attestation

No loader was run, no SQL was generated or applied, no DB was touched, no release was attempted, no serving switch was flipped, and Production was untouched.
