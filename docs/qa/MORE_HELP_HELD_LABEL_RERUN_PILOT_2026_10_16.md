# More help — held serving-label rerun pilot (2026-10-16)

**No database write of any kind.** Production was read once (packet export, SELECT only); the labeler's `write_labels.sql` was generated and **not applied**. Private packets, model outputs and the SQL are in `/private/tmp/more-help-held-pilot-2026-10-16/` (contain authored questions; do not commit).

## Question
Would rerunning the serving-unit labeler, with a refreshed model pair, rescue the ~94 `held` serving labels among untagged questions in the five in-scope subjects, and so tell us which belong in units 1–3?

## Method
`scripts/taxonomy/extend_serving_labels_mcp.mjs` (unchanged, from `main`), models `openai/gpt-6.1-sol` + `google/gemini-3.8-flash` (the labeling runs of Aug–Sep used `gemini-2.5-flash`, which the script itself calls two generations old; the pair is chosen per run). Pilot set of 17: all 5 `model_call_failure` holds plus up to 3 `model_unit_disagreement` holds per subject whose question changed since labeling (BC 3, Chemistry 3, Physics 1 3, Physics C Mechanics 3; Precalculus has none: its three holds are rubric failures, excluded). 34 model calls, **$1.25** reported by the gateway.

## Result
| Original hold | Now agree | Still held |
| --- | --- | --- |
| model_unit_disagreement (12) | 7 | 5 |
| model_call_failure (5) | 3 | 2 (one is a repeat call failure: Gemini timed out) |

**Only 1 of the 10 that now agree is entirely within units 1–3** (`apphy1-mcq-022`, Physics 1 unit 2). The others land in units 4, 6, 7 and 8 (and one spans 3 and 6). The six genuine disagreements all share the **same primary unit** (all above unit 3); they differ only in the *supporting* units, where `gpt-6.1-sol` adds prerequisite units and Gemini returns just the main one. The labeler's rule (identical required-unit sets) holds them anyway.

## What this says
- The held pool is overwhelmingly **unit 4+ content**, not units 1–3 questions the labeler was unsure about. Rerunning the remaining ~77 would be expected to surface roughly one in 17 (about 4–6) units-1–3 questions, for roughly $5–6.
- A refreshed model pair does rescue many holds (10 of 17), mostly into later units, which are outside the current rollout scope.
- The set-equality rule converts a model that lists prerequisite units into a "disagreement". Whether to compare primary unit (or max required unit) instead is a labeler-protocol decision for the Product Owner, not made here.
- Any agreement produced is `provisional_model`, not `validated`; nothing here changes serving.
