# Course Mode Stats 3.4 x 4.F Re-Derivation Record

Date: 2026-08-27
Branch: `content/course-mode-stats-3.4-4f`
Cell: `3.4 x 4.F`
Track: B, authored conceptual MCQ slot-frame
Frame: `FB-U3-4-4F-PROP-CI-CLAIM-01`
Template: `slotframe_u3_4_prop_ci_claim`

## Scope

This frame replaces the invalid draft cell `3.4 x 4.B` with the legal `cells.py` mapping for topic 3.4: `2.D`, `4.F`, and `4.G`. The implemented cell is `3.4 x 4.F`, interpreting inference-method results from a one-population proportion confidence interval.

The student receives an already-computed confidence interval and a proposed population-proportion claim. The task is to choose whether the interval supports the claim, with non-definitive inference language. No interval construction or numeric-verifier path is introduced.

## Gate 1: Property Harness Evidence

Track B harness command: `python3 scripts/course_mode_stats_generator/slot_frames.py`

New-frame report:

```json
{
  "frame_id": "FB-U3-4-4F-PROP-CI-CLAIM-01",
  "cell": "3.4 x 4.F",
  "instances": 120,
  "checks": 1440,
  "distinct_prompts": 119,
  "correct_answer_positions": [0, 1, 2, 3],
  "correct_answer_position_varies": true,
  "failures": [],
  "ok": true
}
```

Full Track B sweep: 1080 instances, 11040 checks, all frame failures empty. Meta-tests all green: `all_frames_ok`, `correct_answer_position_varies`, `misconception_catalog_self_check`, `scenario_catalog_self_check`, and `all_frame_expected_tags_used`.

Additional required checks:

- `python3 scripts/course_mode_stats_generator/generator.py`: PASS, 880 instances, 13040 checks, all reject rates `0/80`, meta failures empty.
- `python3 scripts/course_mode_stats_generator/scenarios.py`: PASS, scenario catalog OK; `u3_4_prop_ci_claim` context bank count 6.
- `python3 scripts/course_mode_stats_generator/misconceptions.py`: PASS, catalog OK; 68 entries; all four `u3_4__` tags attached to `slotframe_u3_4_prop_ci_claim`.
- `python3 scripts/course_mode_stats_generator/build_load_sql.py --check`: PASS, validated 220 packages, 0 problems.
- `python3 scripts/course_mode_stats_generator/build_load_sql.py`: PASS, regenerated local DRAFT SQL only.

## Gate 2: Independent Re-Derivation

### Sample 1: `slotframe-u3_4-4f-030400`

Prompt facts:

- Parameter: true proportion of adult city residents who support the permit program.
- Confidence interval: `(44%, 56%)`.
- Claim: the population proportion is less than `50%`.

By-hand key derivation:

For a claim `p < 0.50` to be supported by a confidence interval, the whole interval should be below `0.50`. Here the interval is `0.44` to `0.56`, so it contains values above `0.50` and includes `0.50` itself. Therefore the interval does not support the claim that the population proportion is less than `50%`. The emitted correct option says exactly this and avoids proof language.

Distractor checks:

- `u3_4__sample_statistic_as_population_claim`: The interval midpoint is `(0.44 + 0.56) / 2 = 0.50`, but treating that sample estimate as the exact population proportion ignores uncertainty. The emitted distractor says the true proportion equals about `50%` and judges from that value alone, matching the tag.
- `u3_4__endpoint_inclusion_reversed`: Because `0.50` is inside the interval, it is plausible under the interval; that does not support the directional claim `p < 0.50`. The emitted distractor says inside-the-interval support is enough, reversing the rule, matching the tag.
- `u3_4__confidence_level_as_probability_claim`: For an already-computed interval, the correct AP interpretation does not say there is a `99%` probability this fixed interval contains the parameter. The emitted distractor uses exactly that single-interval probability phrasing and automatic-support conclusion, matching the tag.

### Sample 2: `slotframe-u3_4-4f-030401`

Prompt facts:

- Parameter: true proportion of students who would use a late-night shuttle.
- Confidence interval: `(65%, 75%)`.
- Claim: the population proportion is more than `70%`.

By-hand key derivation:

For a claim `p > 0.70` to be supported, the whole interval should be above `0.70`. Here the interval is `0.65` to `0.75`, so it contains values below `0.70` and includes `0.70`. Therefore the interval does not support the claim that the population proportion is more than `70%`.

Additional distractor check:

- `u3_4__overstated_certainty_from_interval`: The interval can fail to support a directional claim without proving the claim impossible. The emitted distractor says the interval proves the claim is impossible, matching the definitive overclaim misconception.

## Gate 3: CED Conformance And Rights

The item uses topic 3.4 and skill 4.F from the legal `cells.py` registry: interpreting inference-method results for a confidence interval for a population proportion. The frame uses original synthetic contexts only. No College Board wording, released questions, keys, or scoring language were copied.

## Gate 4: Distractor Realism

All distractors are plausible student interpretations of a confidence interval: reversing the inclusion rule, treating the confidence level as a single-interval probability, treating the sample estimate as the population value, or overstating certainty. Every distractor is cell-namespaced with prefix `u3_4__` and has an evidence tier plus cited source in `misconceptions.py`.

## Emission And Safety

Emitted 20 review JSON packages: `slotframe-u3_4-4f-030400.json` through `slotframe-u3_4-4f-030419.json`.

Regenerated `scripts/course_mode_stats_generator/out/f4_load_DRAFT.sql` locally for review only. No DB write, loader application, release, serving switch, frontend/router/engine change, Dev mutation, Edge deploy, or Prod action was performed.
