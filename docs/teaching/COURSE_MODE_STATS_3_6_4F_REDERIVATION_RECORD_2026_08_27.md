# Course Mode Stats 3.6 x 4.F Re-Derivation Record

Date: 2026-08-27
Branch: content/course-mode-stats-3.6-4f
Cell: 3.6 x 4.F, p-Values — interpret p-value meaning in context
Track: B conceptual slot-frame, served as MCQ choice-match
Frame: FB-U3-6-4F-PVALUE-01
Template: slotframe_u3_6_pvalue_interpret

## Scope

This branch implements exactly one legal AP Statistics Course Mode cell: topic 3.6, skill 4.F. It replaces the invalid draft cell 3.6 x 2.A with the legal mapping in cells.py: 3.6 has skill 4.F only.

No loader application, DB write, release, serving switch, frontend/router/engine change, Dev mutation, Edge deploy, or Prod action was performed. The generated SQL is DRAFT file output only.

## Gate 1: Property Harness

Track B harness command:

```bash
python3 scripts/course_mode_stats_generator/slot_frames.py
```

Frame line for FB-U3-6-4F-PVALUE-01:

- instances: 120
- checks: 1560
- distinct_prompts: 40
- correct_answer_positions: [0, 1, 2, 3]
- correct_answer_position_varies: true
- failures: []
- ok: true

Full Track B sweep:

- instances: 1080
- checks: 11160
- meta_tests: all_frames_ok, correct_answer_position_varies, misconception_catalog_self_check, scenario_catalog_self_check, all_frame_expected_tags_used all true
- overall ok: true

Additional required commands:

- `python3 scripts/course_mode_stats_generator/generator.py`: PASS, 880 instances, 13040 checks, all reject rates 0/80, meta_failures []
- `python3 scripts/course_mode_stats_generator/scenarios.py`: PASS, `u3_6_pvalue` context bank count 6, self_check_problems []
- `python3 scripts/course_mode_stats_generator/misconceptions.py`: PASS, 68 entries, `slotframe_u3_6_pvalue_interpret` has four cell-namespaced tags, self_check_problems []
- `python3 scripts/course_mode_stats_generator/build_load_sql.py --check`: PASS, validated 220 packages, 0 problems
- `python3 scripts/course_mode_stats_generator/build_load_sql.py`: PASS, regenerated DRAFT SQL only

## Gate 2: Independent Re-Derivation

Primary emitted instance checked: `slotframe-u3_6-4f-036000`.

Stem summary: a random sample of customer emails tests H0: p = 0.35 against Ha: p > 0.35, where p is the proportion of all customer emails opened within 24 hours. The sample open rate was above 0.35 and the p-value was 0.027.

By definition, a p-value is the probability, assuming the null hypothesis is true, of observing a result as extreme as or more extreme than the sample result in the direction of the alternative hypothesis. Since Ha is greater than 0.35, the relevant tail is sample proportions at least as large as the observed sample proportion. Therefore the correct interpretation is: if the true open rate is 0.35, there is about a 2.7% chance of getting a sample result at least as large as the one observed by random sampling alone. This matches the emitted key.

Distractor checks for seed 36000:

- `u3_6__p_value_probability_alternative_true`: emitted text says there is about a 2.7% chance the alternative hypothesis is true. This is incorrect because a p-value is not a posterior probability for Ha; it is calculated under H0.
- `u3_6__p_value_reverses_extreme_direction`: emitted text correctly conditions on p = 0.35 but says the result would be this small or smaller. This reverses the right-tail direction required by Ha: p > 0.35.
- `u3_6__p_value_probability_null_true`: emitted text says there is about a 2.7% chance H0 is true. This is incorrect because the p-value assumes H0 for the calculation; it does not give P(H0 true).

Secondary emitted instance checked for the remaining tag: `slotframe-u3_6-4f-036001`.

Stem summary: a random sample of neighborhood residents tests H0: p = 0.50 against Ha: p > 0.50 for support of protected bike lanes, with p-value 0.027.

Distractor check:

- `u3_6__p_value_probability_sample_due_to_chance`: emitted text says there is about a 2.7% chance that the sample result happened by chance. This is a common incomplete interpretation because it omits the null condition and the as-extreme-or-more-extreme tail event. The correct statement must say that if p = 0.50, a sample result at least as large as observed would occur about 2.7% of the time by random sampling alone.

All checked keys and distractors match their intended conceptual taxonomy.

## Gate 3: CED Conformance And Rights

The cell is 3.6 x 4.F, matching cells.py and the Course Mode registry: p-Values with skill 4.F, Interpret inference-method results. The frame uses original synthetic contexts and CED/fact-pack structure only. It contains no verbatim College Board question, key, or scoring language.

Scenario provenance cites fact pack Sections 5, 6, and 7 for FRQ archetype, task verb, and digital modality. Misconception tags cite AP_STATISTICS_2027_CED_FACT_PACK.md S10 Unit 3 (3.5-3.8).

## Gate 4: Distractor Realism

Each distractor is plausible in context because p-value interpretation errors commonly preserve the numerical p-value while misidentifying what probability it represents. The wrong-tail distractor is only used in one-sided test contexts, where the stem gives a clear direction for Ha; it is therefore a real directional-tail mistake rather than a random wrong answer.

## Emitted Review Samples

Twenty deterministic review samples were emitted locally:

- `slotframe-u3_6-4f-036000.json` through `slotframe-u3_6-4f-036019.json`

These remain unreleased generated pending review.
