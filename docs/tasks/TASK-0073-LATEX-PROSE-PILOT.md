# TASK-0073 — LaTeX in question and teaching prose: pilot (Precalculus and Physics C)

**Status:** Open — scope revised and approved by the Product Owner 2026-10-14 ("I approve 1 and 3. Do precalculus and physics c first."); no content drafted yet. The Product Owner will do visual QA.
**Tier:** Standard for drafting and validation in Development; **Hard-Gate** for any Production content write.
**Owner:** Claude session. **Product Owner:** David Bloom.
**Branch / PR:** `claude/latex-prose-pilot`.
**Source:** David, 2026-10-14: *"I approve option 2 for Units 1–3 in chemistry and calculus AB only. This will give us enough material to determine if it is a good approach."*
**Related:** `DECISION-0121` (this scope and the display-only rule), `DECISION-0119` (equation presentation),
`docs/handoffs/LATEX_ROLLOUT_AND_VISUAL_SIZE_SESSION_CLOSE_2026_10_13.md` (targets, traps).

## Goal

Find out whether display-only stacking of compound quotients is a good approach in question and teaching prose,
on a slice small enough to review row by row. The pilot is a test of the approach. It is not the rollout.

## Scope

Subjects `ap_precalculus`, `ap_physics_c_em` and `ap_physics_c_mechanics`, all published units. Read-only Production
counts, 2026-10-14 (published items; fields with a slash next to a bracket, an **upper bound** that includes
rule-exempt units): Precalculus U1 108/85, U2 97/45, U3 98/47; Physics C E&M U8 57/66, U9 33/18, U10 30/14;
Physics C Mechanics U1 22/5, U2 27/15, U3 44/18. Out of scope: Calculus AB/BC, Chemistry and every other subject. Surfaces: `content_item_versions.stem` and `.explanation`,
`mcq_choices.choice_text` and `.rationale`, `frq_criteria.learner_facing_text`, `topic_explainers` (five columns),
`topic_point_briefs.what_it_is`.

## Out of scope

Every other subject and unit. Any Production write. Any regex or render-time transform of content. Widening the
slice before QA signs off.

## Method (author, do not transform)

1. **Detect.** A deterministic query lists candidate rows per surface. Exceptions are excluded by rule, not by model:
   compound units, Leibniz notation, single-symbol quotients, fractions inside an argument/subscript/exponent, scores.
2. **Draft.** One model call per row (Sonnet 5.5, medium effort). The model classifies each candidate as display
   (stands alone on a line, stacked) or inline (inside a sentence, slash kept) and writes the edit in `\(…\)` (inline)
   or `\[…\]` (display), with `\frac{}{}`. Any row it is unsure of is **flagged and left unedited**.
3. **Validate.** Every edit must (a) parse in KaTeX with no error, (b) differ from the original only inside
   the math delimiters, and (c) convert back, with `stripProseMath` and the fraction rewritten as a slash, to the original text exactly.
4. **Review.** The Product Owner reviews the diff. An independent QA pass (Opus or Codex) reviews the pilot before
   anything widens.
5. **Apply to Development only.** Production is a separate Hard Gate and a separate approval.

## Acceptance

- Every changed row passes all three validator checks; failures are listed, not hidden.
- Every flagged row has a stated reason.
- A before/after table of every changed row exists for QA.
- The pilot report answers: how many rows were display vs inline vs flagged, and did stacking read well in the app.

## Renderer (2026-10-14): PR open, not merged or published

`david-bloom/ap-prep-blueprint` PR #22 (draft), branch `claude/prose-math-renderer`. The patch file in
`docs/tasks/patches/` is the same change, kept for the record. It adds `src/lib/prose-math.ts` and
`src/components/content/ProseMath.tsx`, wires `ProseMath` into the authored-prose sites of `QuestionExperience.jsx`
(stem, stimulus, rubric label and minimum fix, answer-key choice text and rationale, both choice lists), adds
`.ca-prose-display` so display maths takes its own line, and adds two dev-harness states, `?state=prose-math` and
`?state=prose-math-frq`, on `/dev-qx-harness`. The harness samples are **synthetic**, not published items.

- **Why a harness and not Development:** the app's `.env` (preview and published alike) points at the **Production**
  database, so seeding Development would show nothing in any app page. The harness renders the real components from
  sample data with no database.
- **Verified on the branch, with the CI recipe:** `tsc --noEmit` clean; `vitest run` 115 files / 1,109 tests pass;
  `npm run build` succeeds. Both harness states were run in `vite dev` and screenshotted in headless Chromium.
- **A defect only the real app showed:** `.ca-formula` is `inline-block`, so a `\[…\]` equation sat beside the words
  before it. Fixed by `.ca-prose-display`, scoped to prose so reference-pane formulas are unchanged.
- **Zero change for current content:** a string with no `\(` or `\[` is returned untouched.
- **Not wired:** FRQ comparison answers, the grader's per-criterion `reason`, student text (deliberately never parsed),
  `PromptText`, `RadioOptionRow`, `RubricCriterionRow`, `FeedbackCard`, lesson notes and topic explainers. The pilot's
  `content_item_versions.explanation` column was not located in the render path and is unconfirmed.
- **Still to do:** merge and publish through Lovable (a Product Owner action); then the content edits, which remain
  a Production write behind a Hard Gate.

## Drafted edits (2026-10-14)

Read-only Production read, drafted into a private review file (published exam text, kept out of this public repo).
Product Owner rulings applied: whole-field equations are stacked; Precalculus choices keep the wording "the square
root of 3"; `1/(…)` reciprocals are stacked. Result: **33 edits** (Precalculus 17, Physics C E&M 10, Physics C
Mechanics 6), 0 hard validator failures, every original hash-checked against Production. Of 324 candidate rows,
279 are quotients inside a sentence and stay as slashes by design, and 12 are exempt. A static KaTeX preview
confirmed the rendering and caught three draft defects, all fixed: a trailing period stranded outside display maths,
a nested fraction that rendered too small, and italic text subscripts. Nothing is applied to any database.

## Phase plan and QA outcome (2026-10-14)

An independent QA (Codex) reviewed the 33 drafted edits and recommended **do not write** the first transaction. All 33
were mathematically equivalent and their before-text matched Production, but it found real problems, most of which
were confirmed independently:

- **A label the transaction missed.** Editing text changes a hash that flips an item's taxonomy labels to `stale`, and
  every practice-serving function requires `validated`. The transaction now captures every label the trigger can
  flip and restores it exactly (status, `validated_by`, `validated_at`, `validation_decision_id`), advancing only the
  hash of labels that were in sync.
- **Rubric text is read by the grader** (see `TASK-0074`).
- **Raw LaTeX on staff pages:** reviewer and admin grading pages print these fields. Fixed in `ap-prep-blueprint` PR #23.
- **The explanation column reaches no student surface**, so those three edits are dropped.
- **One missed row** (a whole-field quotient with no adjacent bracket) was found and is added.

The Product Owner split the work:

| Phase | Rows | State |
|---|---|---|
| 1 — MCQ choices and one rationale | 21 | transaction rewritten and dry-run (rolled back); second QA pending; **no Production write yet** |
| 2 — rubric lines | 10 | Hold: Gateway pilot fails safe-as-is gate (decision variation and markup in minimum_fix); retain current plain-text rows pending a verified mitigation |
| dropped — explanation edits | 3 | no student surface reads that column |

The drafts and the transaction contain published exam text and are kept in a private repository branch, not here.
Phase 1 still needs the second QA, the Product Owner's visual review, and an explicit go-ahead before any write.

## Known gaps at open

- The hit counts are a loose upper bound. The rule-applying detector in Method step 1 gives the real number.
- The prose renderer is in `ap-prep-blueprint` PR #22 and is not merged or published; visual QA of real content needs both, plus the content edits.
- Author-forward (`DECISION-0121` item 6) needs the prose rule stated in the authoring guidance, done in
  `docs/new_design/CONTENT_AND_PEDAGOGY.md`.
