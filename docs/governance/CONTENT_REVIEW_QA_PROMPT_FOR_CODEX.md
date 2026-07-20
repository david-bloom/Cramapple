# Content Review & QA Prompt for Codex

**Status:** Draft
**Owner:** Main Conductor
**Product Owner:** David Bloom
**Purpose:** A reusable prompt to hand Codex for content-quality review passes
across any subject's question bank (MCQ + FRQ), including a dedicated
image/stimulus-visual pass. Grounded in this repo's actual content-governance
policy and in concrete defect patterns found in AP Biology and AP Statistics
content during 2026-07 review passes.

Codex acts as **QA Agent** under `docs/team_charter/AI_COLLABORATION_RULES.md`:
propose findings, cite evidence, recommend a verdict. Codex must not mark a
task `Done`, publish, deploy, migrate, or alter live content as part of this
review — findings go back to the Main Conductor / content author for
disposition.

---

## The prompt (copy from here down into Codex)

You are doing a content-quality QA pass on Cramapple's `<SUBJECT>` question
bank (MCQ + FRQ) in `app.content_item_versions`, joined through
`app.content_items` / `app.exam_pack_versions` / `app.exam_packs` /
`app.subjects`. Read via Supabase MCP tools or the curated
`public.content_item_versions` view. Do not write to the database, upload
assets, or change `status`/`review_status` — this is a findings-only pass.

### Governing standards

Read these before starting, they define what "correct" means here:

- `docs/architecture/CONTENT_GOVERNANCE_AND_VALIDATION.md` — teaching/grading
  independence, rubric-boundary rules, reviewer separation.
- `docs/architecture/VISUAL_STIMULUS_AND_RENDERING_SYSTEM.md` §4 (Core
  Learning Rules) and §7 (Validation Gates) — the four-lane visual model,
  construct preservation, answer-leakage rules, and the human-review
  checklist for any visual. Treat §4.2 (Prevent Answer Leakage) and §7.2's
  "absence of misleading scale, emphasis, decoration, or omitted context" as
  hard requirements even though the full pipeline described there (automated
  schema validation, per-lane reviewer counts) isn't built yet — the
  *principles* apply to today's simpler matplotlib-PNG-in-a-Storage-bucket
  reality.
- `docs/tasks/TASK-0005-CONTENT-GOVERNANCE-AND-VALIDATION.md` — reviewer
  roles and what a "Codex pre-review" is supposed to catch (question
  relevance, answer-key correctness, distractor plausibility, rubric-boundary
  issues) before tutor review.
- The current concern-code vocabulary is fixed and small:
  `Accuracy | Ambiguity | Rubric gap | Other` (see
  `supabase/migrations/202606280001_tutor_reader_phase0.sql`). Tag every
  finding with one of these; if none fit, say so explicitly rather than
  forcing a mismatch, and flag the vocabulary itself as a gap.

### What to check, per item

**1. Answer-key / canonical-answer correctness.** Don't eyeball it —
recompute. For any FRQ with a numeric canonical answer, independently derive
the number from the stated inputs and compare (2% relative-error band, same
as prior QA in this repo). For MCQ, verify the keyed choice against the
stem/stimulus, not just internal consistency of the choices.
  - Precedent: `APSTAT-MOD5-M001` was keyed with the *population* SD (7.07)
    when the stem said "sample" (correct sample SD ≈ 7.91) — a 10.6% error
    that would have shipped a wrong answer key. Confirmed since fixed; the
    class of error is what to watch for.

**2. Rubric-boundary and metadata consistency.** Check that
`prompt_json.total_points` (or equivalent) matches the sum of `frq_criteria`
points. Check `evidence_requirements`/`explanation` text for leftover
self-correction artifacts ("Wait, actually...", contradicting itself
mid-paragraph) — these ship confusing rubric text to tutors even when the
final answer is right.
  - Precedent: `APBIO-FRQ-L-001/002/003` had `total_points=8` vs. a
    rubric summing to 10; `APBIO-FRQ-S-013` had a criterion that said "will
    lose water" then self-corrected to "will gain water" in the same
    explanation.

**3. Distractor plausibility (MCQ only).** Each wrong choice should represent
a real, specific misconception — not an obviously-absurd filler and not a
near-duplicate of another choice.

**4. Content stubs — the most severe class, check this explicitly.** For
every FRQ, check `prompt_json.deterministic_criteria`. For any criterion with
`kind: "numeric"` or `"numeric+ecf"`, confirm a concrete number the grader
can check against actually exists somewhere in the stem, stimulus, or
explanation. If the item narrates a data source ("this tree diagram shows…",
"a contingency table shows…") but stem+stimulus+explanation contain *no
digits at all*, it is an unfinished stub, not a "needs an image" item — do
not propose an illustrative image for these. Flag for real content authoring
(someone has to invent the actual dataset/diagram and set a canonical
answer); inventing plausible-looking numbers yourself would mean authoring a
graded answer key, which is out of scope for a QA pass.
  - Precedent: `APSTAT-MOD7-M004` (tree diagram) and `APSTAT-MOD7-M001`
    (contingency table) were both exactly this — empty stimulus, no numbers
    anywhere, wired for numeric grading with nothing to grade against.

**5. Image/stimulus-visual need — assess every item, not just ones that
"look visual."** For each item, decide which bucket it falls in:

  - **Genuine gap:** the stem/stimulus describes or references a
    graph/diagram/table qualitatively (shape, layout, relationships) but
    gives *no underlying data* — a student or reviewer literally cannot
    answer or verify the item from text alone. This is the only bucket that
    needs a new stimulus image.
  - **Embedded data:** the graph/table is referenced narratively but the
    stimulus/stem fully supplies the underlying data as text (bin counts, a
    five-number summary, an explicit equation, a plain-language description
    of shape/trend/outliers sufficient to answer). Answerable without an
    image; do not flag as needing one, even though it says "this histogram
    shows…" or similar.
  - **Student-constructed (HDG-style):** the item gives data and asks the
    *student* to construct and photograph their own graph/diagram. No
    stimulus image needed by design.
  - **False positive:** matched a visual keyword but doesn't actually need
    or reference any visual (e.g., a hypothetical "what shape would you
    expect if…" reasoning question).

  Search stem *and* stimulus for graph/plot/scatterplot/histogram/
  boxplot/dotplot/diagram/figure/chart/table/tree/mosaic-plot/normal-curve/
  Venn/density-curve/shown-below/pictured language, then read each match's
  full text by hand — keyword matching alone over- and under-counts. Cross-
  check against `stimulus_image_path` on the row: if it's already set,
  confirm the path actually resolves to an object in the `content-assets`
  Storage bucket (don't assume a set path means the file exists).

**6. Image quality — for every item that already has a
`stimulus_image_path`, review the actual rendered image, not just its
existence.** Fetch and view it. Check, in order of how often these actually
break:

  a. **Directional/causal/sequential correctness.** This is where real
     errors hide, and the ones found so far were all in details a quick
     glance misses:
     - `APBIO-FRQ-S-008` (DNA replication fork): the "fork movement" arrow
       pointed *away* from the still-paired parental strands and into the
       already-replicated region — physically backwards, since a fork can
       only advance into unreplicated DNA.
     - `APBIO-FRQ-S-014` (electron transport chain): a direct
       Complex I → Complex II arrow implied one sequential pathway; they're
       independent parallel entry points that both feed Complex III, not
       each other.
     - `APBIO-FRQ-S-015` (lac operon): an arrow from `lacI` into the
       operon's `Promoter` box implied a functional link between two
       unrelated promoters.
     Trace every arrow in the image against what it's supposed to represent
     and ask "does this arrow's direction/target actually match the
     underlying mechanism, or just look plausible at a glance?"
  b. **Answer leakage** (Visual Stimulus policy §4.2) — the image must not
     state the trend/conclusion/comparison the question asks the student to
     identify, and must not print rubric or point-earning language.
  c. **Misleading presentation** — no misleading scale, truncated/reversed
     axes without explicit review, decoration that implies something not in
     the data, or omitted context that changes the apparent conclusion.
  d. **Legibility** — labels, units, legend, and axis text actually
     readable; color is not the sole encoding where a distinction matters.
  e. **Fidelity to the stimulus text** — the image should show exactly what
     the stem/stimulus says it shows (same labels, same entities, same
     relationships), not a plausible-looking approximation.

  If an image fails (a)-(e), flag as a defect requiring
  regeneration/correction — same severity as a wrong canonical answer, since
  a wrong image actively teaches the wrong mechanism.

**7. Review-workflow status.** Note (don't fix) each item's `status` and
`review_status`. Flag if you find `published` items whose `review_status`
suggests they never cleared tutor/reader review (`tutor_review_pending`,
`null`) — this may just be a known gap between the runtime "published" flag
and the human review-decision workflow, but it's worth surfacing per item
rather than assuming.

### Output format

Match the style already used in this repo's audits
(`docs/research/apbio_frq_corpus_quality_audit.md`,
`docs/research/ap_statistics_phase_c_publish_staging_2026_07_11/qa_review.md`):
group findings by severity (blocking vs. non-blocking), cite the exact
`content_key`, quote or precisely paraphrase the offending text/image detail,
recompute anything numeric independently and show the recomputation, and give
a concrete recommended fix — not just "this seems off." End with a short
"what's ready as-is" section and a proposed verdict (Pass / Fail /
Conditional), understanding that only the Main Conductor or Product Owner can
act on that verdict.

---

## Notes for whoever fills in `<SUBJECT>`

- This prompt assumes Supabase MCP access to `pcntajvbdfqhbeewmdry`
  (Production) or the equivalent dev project. If Codex doesn't have that,
  it needs read access before this pass can run at all.
- The image-quality check (item 6) requires actually viewing each image, not
  just checking the database row — budget for that; it's the step every
  defect found so far actually lived in.
- This is a template, not a one-time audit — reuse it per subject
  (AP Biology, AP Statistics, AP Calculus AB/BC, AP Precalculus) and update
  the "precedent" examples in items 4 and 6 as new defect patterns are
  found, so the next pass benefits from what this one caught.
