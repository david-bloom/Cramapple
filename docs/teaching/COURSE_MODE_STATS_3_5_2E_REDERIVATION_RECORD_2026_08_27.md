# Course Mode Stats 3.5 x 2.E Re-Derivation Record

Date: 2026-08-27
Branch: `content/course-mode-stats-3.5-2e`
Cell: `3.5 x 2.E` — Setting Up a Test for a Population Proportion; identify null and alternative hypotheses.
Track: B — authored conceptual MCQ slot-frame.
Frame: `FB-U3-5-2E-PROP-HYP-01`
Template: `slotframe_u3_5_prop_hypotheses`

## Scope And Guardrails

Implemented exactly one AP Statistics Course Mode cell, replacing the invalid draft `3.5 x 2.A` with the legal `3.5 x 2.E` mapping from `cells.py`. The item asks for the appropriate null and alternative hypotheses for a one-population proportion test. It does not ask for a test statistic, p-value, conclusion, loader application, DB write, release, serving switch, frontend/router/engine change, Dev mutation, or Prod mutation.

All scenarios are original synthetic contexts. The frame follows CED structure only: `H0` uses equality to the hypothesized population proportion, and `Ha` follows the stated research direction.

## Gate 1 Property Harness

Track B harness command: `python3 scripts/course_mode_stats_generator/slot_frames.py`

New frame report:

```json
{
  "frame_id": "FB-U3-5-2E-PROP-HYP-01",
  "cell": "3.5 x 2.E",
  "instances": 120,
  "checks": 1800,
  "distinct_prompts": 6,
  "correct_answer_positions": [0, 1, 2, 3],
  "correct_answer_position_varies": true,
  "failures": [],
  "ok": true
}
```

Full Track B sweep: 1080 instances, 11400 checks, meta-tests green, `ok: true`.

Catalog checks:

- `python3 scripts/course_mode_stats_generator/scenarios.py`: `ok: true`; `u3_5_prop_hypotheses` context bank count 6.
- `python3 scripts/course_mode_stats_generator/misconceptions.py`: `ok: true`; `slotframe_u3_5_prop_hypotheses` tags present and cited.

## Gate 2 Independent Re-Derivation

Checked emitted instance: `scripts/course_mode_stats_generator/out/slotframe-u3_5-2e-030520.json`.

Prompt summary: The research question is whether more than 60% of seniors at the school have a part-time job. A random sample of 140 seniors finds 92 with a part-time job.

By hand:

1. The parameter must be `p`, the true population proportion of seniors at the school who have a part-time job. Hypotheses are about the population parameter, not the sample statistic.
2. The hypothesized value is `p0 = 0.60` because the claim is phrased against 60%.
3. The null hypothesis must include equality: `H0: p = 0.60`.
4. The research question says "more than 60%," so the alternative is right-tailed: `Ha: p > 0.60`.

Emitted key matched: `Let p be the true proportion of seniors at a high school who have a part-time job. H0: p = 0.6; Ha: p > 0.6.`

Distractor re-derivation:

- `u3_5__wrong_alternative_direction`: uses the population parameter and correct null value, but changes the right-tailed research question to `Ha: p < 0.60`. This is wrong-direction alternative confusion and matches the emitted distractor.
- `u3_5__sample_proportion_as_parameter`: uses `p-hat` in both hypotheses, `H0: p-hat = 0.60; Ha: p-hat > 0.60`, instead of using the population parameter `p`. This matches the sample-statistic-as-parameter misconception.
- `u3_5__alternative_uses_equality`: reverses the roles by putting the inequality in `H0` and equality in `Ha`: `H0: p > 0.60; Ha: p = 0.60`. This matches the equality-in-alternative/null-alternative role confusion.

All distractors are plausible for this exact stem: each preserves the same population context and hypothesized value, while making a common hypothesis-setup error.

## Gate 3 CED Conformance And Rights

- Legal cell verified from `cells.py`: topic `3.5` supports skill `2.E`.
- Skill demand: identify the null and alternative hypotheses.
- Difficulty: Medium, because students must coordinate parameter, null equality, and tail direction.
- No College Board wording, released questions, scoring guidelines, or third-party item text used. Contexts and option text are original synthetic authoring grounded only in CED/fact-pack structure.
- New misconception tags are cell-namespaced and cite `AP_STATISTICS_2027_CED_FACT_PACK.md S10 Unit 3 (3.5-3.8)`.

## Gate 4 Realistic Distractors

Each distractor is specific to the scenario and keeps the same claimed population proportion. The wrong options differ from the key by one meaningful conceptual error: equality placement, parameter/statistic confusion, or tail direction. No throwaway distractors were used.

## Remaining QA Commands

Required commands passed after emission and record creation:

- `python3 scripts/course_mode_stats_generator/generator.py`
- `python3 scripts/course_mode_stats_generator/build_load_sql.py --check`
- `python3 scripts/course_mode_stats_generator/build_load_sql.py` (DRAFT SQL only)
- `git diff --check`

No loader application, DB write, release, serving switch, frontend/router/engine change, Dev mutation, Edge deploy, or Prod action was performed.
