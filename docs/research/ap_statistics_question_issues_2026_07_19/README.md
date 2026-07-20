# AP Statistics Question Issues — Pre-Launch Log (2026-07-19)

**Task:** Requested as the AP Statistics equivalent of the AP Biology
stimulus-image sweep (`docs/research/ap_biology_stimulus_images_2026_07_12/`):
review every AP Statistics question for ones that reference a graph/diagram
they don't actually have, and fix the gap. Relates to `TASK-0013`
(AP Statistics Launch).

**Result:** No stimulus images needed to be generated — every genuine
graph/diagram reference in the current AP Statistics bank already has its
underlying data given as text (a table, bin counts, or a full qualitative
description), or is a hand-drawn-graph (`HDG`) item where the student
constructs the graph themself. Instead, this sweep found **2 unfinished
content stubs** that block launch, and confirmed **the entire list of 8
items previously flagged as unanswerable (2026-07-11 QA) is now fixed**.

## Method

Queried all `ap-statistics` `content_item_versions` (276 items) for
stem/stimulus text matching graph/plot/diagram/table-reference language (two
keyword passes, ~63 matches), then read each match's full stem and stimulus
by hand — same method as the Biology sweep. For the deterministic-numeric
stub check, additionally queried every FRQ whose
`prompt_json.deterministic_criteria` declares a `numeric` or `numeric+ecf`
kind and confirmed whether a concrete number exists anywhere in its stem,
stimulus, or explanation.

## Launch blockers found: 2 content stubs, not missing images

Both items narrate a data source ("a contingency table," "this tree
diagram") that was never actually populated, and both are wired for
deterministic numeric grading against a value that doesn't exist anywhere —
not in a missing image, in a missing dataset. Generating an illustrative
image for either would mean inventing the underlying numbers myself and
asserting them as the graded answer key, which is a content-authoring
decision, not an image-generation one. Flagging for real authoring instead.

1. **`APSTAT-MOD7-M004`** (module 7, probability) — stem: "This tree diagram
   shows the outcomes of a two-stage experiment. Calculate the probability of
   reaching a specific endpoint." `stimulus` is empty. `explanation` only
   restates the rubric criterion generically ("Correctly multiplies
   probabilities along the path and shows work") with no numbers.
   `deterministic_criteria.tree_diagram_calculation` is `kind: "numeric"`,
   `parts: ["path_prob"]` — the grader expects a specific numeric answer that
   is defined nowhere. `status: draft`, `review_status: tutor_review_pending`.

2. **`APSTAT-MOD7-M001`** (module 7, probability) — stem: "A contingency
   table shows the relationship between gender and preference for a new
   product. Calculate the marginal probability that a person prefers the
   product." Same pattern: empty stimulus, no table anywhere,
   `deterministic_criteria.marginal_probability` is `kind: "numeric"`,
   `parts: ["prefer_rate"]` with no value to key against. `status: draft`,
   `review_status: null`.

**Next required action:** a content author needs to write the actual
two-stage tree (branch probabilities) for `APSTAT-MOD7-M004` and the actual
contingency table for `APSTAT-MOD7-M001`, and set a canonical numeric
answer for each before either goes to tutor review. Neither should be
imported/published as-is.

## Confirmed fixed since the 2026-07-11 staging QA

`docs/research/ap_statistics_phase_c_publish_staging_2026_07_11/qa_review.md`
found this same class of problem in an earlier staging pass and blocked the
import (`Fail — do not run the Production bulk_import`). Re-checked all of
its findings directly against current Production content today:

- **`APSTAT-MOD5-M001`** (sample SD keyed as the population value, 7.07
  instead of ≈7.91) — **fixed.** Current `explanation` reads "Correctly
  calculates mean as 20 and sample standard deviation as approximately
  7.91."
- **The 8 FRQs flagged as "requires absent visual/data stimuli"** — **all 8
  now have sufficient text-embedded data or description to answer without
  an image**, re-checked one by one against current Production content:
  - `APSTAT-MOD4-M004` — scatterplot direction/form/strength/outliers fully
    described in the stem.
  - `APSTAT-MOD5-M003` — histogram bin counts given in the stimulus.
  - `APSTAT-MOD6-M004` — pure CLT theory question (shape/center/SD of a
    sampling distribution given population shape, μ, σ, n); doesn't need a
    plotted graph to answer.
  - `APSTAT-MOD6-H004` — residual pattern fully described in the stimulus.
  - `APSTAT-MOD6-H002-INV` — full numeric summary given (means, SDs, r,
    regression equation, R², residual description, SAT range); answerable
    from the numbers alone.
  - `APSTAT-MOD8-M003` — regression equation given explicitly; pure
    substitution, no plot needed.
  - `STATS-MOD3-H009` — histogram bin counts given in the stimulus.
  - `STATS-MOD4-H014` — all four treatment combinations named explicitly in
    the stimulus; factors/levels identifiable from the text alone.

  None of these 8 need a generated image. (`APSTAT-MOD5-M003` and
  `STATS-MOD3-H009` were also independently found by today's keyword sweep,
  for the same reason — they still mention "histogram" in the stem even
  though the shape is now fully specified as text.)

## Lower-confidence item worth a second look

`APSTAT-MOD6-M001` — "estimate the proportion... with a margin of error of
±5%" asks for `n_required` (`kind: "numeric"`), but the stem doesn't state a
confidence level. `n_required` depends on the confidence level (via `z*`)
and a planning value of `p`, neither given. Possibly resolved by a documented
grading convention (e.g., assume 95%, `p = 0.5`) elsewhere that this sweep
didn't check for — flagging rather than asserting it's broken.

## Everything else checked and fine

The remaining ~53 keyword matches split into two categories, same as
Biology's false positives:

- **~40 `APSTATS-HDG-2026-GRAPH-*` items** — student constructs their own
  graph from data given in the stimulus table and submits a photo. No
  stimulus image needed by design (mirrors Biology's 12 `HDG` items).
- **~13 items fully embed their data/description as text** — histogram bin
  counts, five-number summaries, and plain-language descriptions of a
  scatterplot/boxplot/residual-plot shape sufficient to answer the question
  (`APSTAT-MOD3-E002`, `-MOD4-M004`, `-MOD5-M002`, `-MOD5-M003`,
  `-MOD6-H004`, `-MOD8-H002`, `-MOD8-H003`, `-MOD8-M001`,
  `APSTATS-MCQ-004`/`-004-CAL`/`-013`/`-013-CAL`/`-022`/`-034`/`-036`/`-087`/
  `-089`/`-090`, `STATS-MOD3-H009`).

## Note on review status

Separately observed while pulling this data (not a question-content issue,
flagging for visibility): every `published` AP Statistics item — FRQ and
MCQ alike — currently sits at `review_status` of either
`tutor_review_pending` or `null`; none show a terminal
approved/confirmed review status. The same pattern holds for Biology. This
may just reflect that the human review workflow (tracked via
`content_review_assignments`/`content_review_decisions`) runs independently
of the `content_item_versions.review_status` field rather than writing back
to it — not confirmed either way here. Worth a specific check before
launch: does "published" actually mean "cleared tutor/reader review," or
only "available to the grading/session runtime"?
