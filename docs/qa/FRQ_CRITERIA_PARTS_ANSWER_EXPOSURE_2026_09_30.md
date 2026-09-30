# Day-1 FRQs Show Students the Answer as the Question

**Date:** 2026-09-30 · **Ran by:** Claude · **Status:** Ready for Review — needs a Product Owner decision
**Origin:** `DECISION-0092` "Still open": *"Criteria-sourced `parts` on other subjects' long FRQs are
rendered as the questions today; where `learner_facing_text` states answers, students see them. Not
measured or fixed here; needs its own task."* This is that measurement.
**Method:** Production read-only SQL + repo code read. No writes, no deploys.

## Headline

**50 of the 119 published AP Biology and AP Statistics FRQ items hand the student a value, hypothesis or
conclusion inside the text shown as the question.** Both are day-1 Oct 2 subjects on the flat practice path.

| Subject | Published FRQ items | Leaking today | Closed by the serving fix | Left needing content work |
|---|---|---|---|---|
| AP Statistics | 44 | **31 (70%)** | 23 | **8** |
| AP Biology | 75 | **19 (25%)** | 3 | **16** |
| **Total** | **119** | **50** | **26** | **24** |

Rubric-register text reaches students far more widely than that: Statistics 127 of 152 criteria (84%),
Biology 113 of 279 (41%). The 50 above are only the subset that discloses a concrete answer.

## What a student sees

`toLearnerFacingParts` (`_shared/student-item-delivery.ts`) maps every `frq_criteria.learner_facing_text`
row into `parts[].prompt_text` — the question text. These rows were written as **scoring lines**, so the
grammar gives them away: Statistics' single most common opening word across all criteria is "Correctly".

Real Production rows, shown verbatim as the question, beside the authored question that already exists:

| Item | Shown to the student today | Authored question sitting unused |
|---|---|---|
| `APSTATS-SFRQ-013` a | "States H0: mu = 70 and Ha: mu != 70." | "Write the null and alternative hypotheses." |
| `APSTATS-SFRQ-004` a | "States that each additional hour of screen time is associated with about 0.65 fewer hours of sleep on average." | "Interpret the slope in context." |
| `APSTATS-SFRQ-001` c | "Computes the mean as about 23.7 minutes and says the mean is greater than the median." | "Calculate the mean of the data set and state whether the mean is greater than or less than the median." |
| `APSTATS-HDG-2026-GRAPH-031` | "Identifies 11 days as a possible high outlier." | — (no authored part) |
| `APSTAT-MOD3-E002` | "Correctly identifies skewed left or negative skew as most scores cluster at higher values" | — (no authored part) |

## Root cause: two independent defects, both required

The Calc AB patch (`DECISION-0092`) built the mechanism to prefer authored part prompts. It does not reach
these subjects, for two separate reasons — fixing either alone changes nothing.

**1. The reader looks for the wrong key.** `extractQuestionParts` (`student-session-items/index.ts` ~line 131)
reads `p.prompt`. Every authored part in Production stores its text under **`prompt_text`**:

| Subject | Items with a parts array | Parts total | Have `prompt_text` | Have `prompt` |
|---|---|---|---|---|
| AP Statistics | 34 | 76 | **76** | **0** |
| AP Biology | 4 | 4 | **4** | **0** |

Because the function returns `[]` unless *every* part has a non-empty `prompt`, it returns `[]` for all 80
parts and the server falls back to criteria-sourced parts. The authored questions are correct, imperative,
and already published — they have simply never been read.

**2. The flag is hard-gated to Calc AB.** `questionParts: sessionExamCode === "ap_calculus_ab"` (~line 751).
Biology and Statistics never request authored parts at all.

## Proposed serving fix (not applied — needs approval)

1. In `extractQuestionParts`, read `prompt_text` first, falling back to `prompt`.
2. Widen the `questionParts` flag from Calc AB to the day-1 exam codes.
3. Keep the existing all-or-nothing rule: an item with any part missing its text keeps current behaviour.

This closes **26 of 50** items using content already in Production. No migration, no content write.

**Deploy hazard.** Production `student-session-items` is **v28** — v27 plus the Calc AB patch, deliberately
*excluding* `main`'s TASK-0051 `annotateOpenHandExclusions`, which is still Production-gated. Any deploy must
be v28 + this patch only, read back and byte-compared, exactly as `DECISION-0092` did. **Do not deploy this
function from `main`.**

## The residual 24 items

16 Biology and 8 Statistics leaking items have **no authored parts at all** — `prompt_json` is null or has no
parts array. The serving fix cannot help them; only rewriting `learner_facing_text`, or authoring parts, will.
That is content work with its own QA, not a pre-Oct-2 change. Options for David:

- **Suppress.** For an item with no authored parts, show the stem and a single response box instead of
  criteria-derived parts. Closest to a real AP FRQ; needs a check that each stem carries the question.
- **Descope.** Exclude the 24 from the day-1 pool. Leaves Biology FRQ practice thin.
- **Accept.** Launch as-is and fix after. The student is handed the answer on those items.

## Bearing on the runbook

§3 and §4 require a real submit-to-grade round trip on each subject. Neither says anything about whether the
question shown is the question. On the evidence above, a Statistics FRQ smoke test has a ~70% chance of
landing on an item that shows the answer — and would still pass §4 as written, because grading works. The
checklist should gain an explicit "the question shown is the authored question" line before go/no-go.
