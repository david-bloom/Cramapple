# Day-1 FRQs Show Students the Answer as the Question

**Date:** 2026-09-30 · **Ran by:** Claude · **Status:** Ready for Review — needs a Product Owner decision
**Origin:** `DECISION-0092` "Still open": *"Criteria-sourced `parts` on other subjects' long FRQs are
rendered as the questions today; where `learner_facing_text` states answers, students see them. Not
measured or fixed here; needs its own task."* This is that measurement.
**Method:** Production read-only SQL + repo code read. No writes, no deploys.

## Headline

**112 of the 141 AP Biology and AP Statistics FRQ items a student can actually be served (79%) show
answer content inside the text rendered as the question.** Both are day-1 Oct 2 subjects.

| Subject | Servable FRQ items | Showing answer content | Closed by the serving fix | Residual |
|---|---|---|---|---|
| AP Statistics | 69 | **59 (86%)** | 45 | **14** |
| AP Biology | 72 | **53 (74%)** | 1 | **52** |
| **Total** | **141** | **112 (79%)** | **46** | **66** |

At the criterion level: **345 of 618 rows (56%)** disclose an answer.

> **Revision, same day.** A first pass using a keyword heuristic reported 50 items and treated Biology as
> the milder case. Both figures were wrong. Independent review (below) found the heuristic missed 256 of
> the 345 true positives — a roughly threefold undercount — and that **Biology is the harder problem, not
> the easier one**: the serving fix closes 45 of 59 Statistics items but only 1 of 53 in Biology. The
> numbers in this document are the reviewed ones. The superseded figures are kept here deliberately, so
> the record shows what changed and why.

## Validation

Two things were checked: whether the exposure is real end to end, and whether the classification holds.

### The path is live — run, not inferred

`app.select_ordinary_combined_practice_items` was called on the **live** AP Statistics pack
`548f06be` with `targeted_drill` and returned a real session: **7 FRQ + 13 MCQ**. (The pack with the most
session history, `7c5a2975`, was **retired on 2026-09-25** and returns nothing — an early read of this
suggested Statistics served no FRQs at all, and that was wrong.) Biology's
`select_biology_practice_items` returned 12 FRQ + 8 MCQ; `select_practice_frqs` returned 20.

The shipped `buildRenderItem` was then run over real Production criteria for items from that session.
Verbatim output, current Production behaviour against the patched behaviour:

```
================ APSTATS-SFRQ-011 ================
stem shown: "Answer all parts of the following question."

-- BEFORE (Production v28 today) -- parts_source=criteria
   [a] Identifies the parameter and computes the point estimate.
   [b] Checks conditions and computes the confidence interval.
   [c] Interprets the interval as a range of plausible values for the true
       population proportion of supportive students.

-- AFTER (with the patch) -- parts_source=prompt
   [a] State the parameter of interest and calculate p-hat.
   [b] Check the conditions for a one-proportion confidence interval.
   [c] Calculate a 95% confidence interval for the proportion of all students
       who support a later start time.
   [d] Interpret the interval in context.
```

Note the item's stem is "Answer all parts of the following question." — so the criteria text is the only
question the student gets. Today they also get **three** parts where the item has **four**.

An item with no authored parts is unchanged by the patch, as expected:

```
================ APSTAT-MOD5-H001-INV ================
-- BEFORE -- parts_source=criteria
   [causation_vs_correlation] Correctly concludes no causation from correlation; ...
-- AFTER  -- parts_source=criteria   (identical)
```

### The classification was judged independently

All 618 criteria rows for servable items were stripped to `{id, subject, text}` — no stems, no labels, no
statement of what was expected — and given to **two independent fresh-context reviewers** who did not see
each other's work or the heuristic.

| | Rows marked as disclosing an answer |
|---|---|
| Reviewer A | 351 |
| Reviewer B | 349 |
| **Both agree (the figure used above)** | **345** |
| Either | 355 |
| Original keyword heuristic | 109 |

**Inter-rater agreement 608/618 = 98.4%.** The heuristic missed 256 rows the reviewers both flagged and
raised 20 the reviewers both cleared. It keyed on digits and comparison words, so it caught
"Computes the mean as about 23.7 minutes" and missed qualitative disclosure such as
`APBIO-FRQ-S-011#a1` — "q^2 = 80/500 = 0.16, so q = 0.4 and p = 1 - 0.4 = 0.6." — and
`APBIO-FRQ-L-003#a` — "Determines autosomal-recessive inheritance ... and assigns I-1=aa, I-2=Aa,
II-3=aa, and II-4=Aa." Several Biology rows are a full worked solution.

Raw evidence: `docs/qa/frq_exposure_2026_09_30/criteria_blind.json` (the exact input both reviewers saw),
`review_A.json`, `review_B.json`.

**Caveat.** Both reviewers are model judgements, not a subject-matter expert's. Agreement is high and the
two were independent, but the 345 figure is a strong indication rather than a certified count. The ten
clearest cases quoted in this document are unambiguous on their face.

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

This closes **46 of 112** items using content already in Production — 45 of 59 in Statistics, 1 of 53 in Biology. No migration, no content write.

**Deploy hazard.** Production `student-session-items` is **v28** — v27 plus the Calc AB patch, deliberately
*excluding* `main`'s TASK-0051 `annotateOpenHandExclusions`, which is still Production-gated. Any deploy must
be v28 + this patch only, read back and byte-compared, exactly as `DECISION-0092` did. **Do not deploy this
function from `main`.**

## The residual 66 items

66 items show answer content and have no authored parts the fix can use — **52 Biology, 14 Statistics**.
Rewriting `learner_facing_text`, or authoring part prompts, is the only route. That is content work with
its own QA, not a pre-Oct-2 change. Options:

- **Suppress.** Where an item has no authored parts, render the stem and a single response box instead of
  criteria-derived parts. Closest to a real AP FRQ. Needs a check that each stem carries the question —
  and at least some do not: `APSTATS-SFRQ-011`'s stem is "Answer all parts of the following question."
- **Descope.** Exclude the 66 from the day-1 pool. That is 52 of Biology's 72 servable FRQ items, which
  leaves Biology FRQ practice at 20 items.
- **Author.** Fix all 66 before launch. Highest quality, largest job, two days.
- **Accept.** Launch as-is on those items.

The full list is in `residual_items.json` beside this file.

## Bearing on the runbook

§3 and §4 require a real submit-to-grade round trip on each subject. Neither says anything about whether the
question shown is the question. On the evidence above, a Statistics FRQ smoke test has an ~86% chance, and a
Biology one a ~74% chance, of landing on an item that shows the student answer content — and would still pass §4 as written, because grading works. The
checklist should gain an explicit "the question shown is the authored question" line before go/no-go.
