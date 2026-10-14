# TASK-0073 — LaTeX in question and teaching prose: pilot (Chemistry and Calculus AB, units 1–3)

**Status:** Open — scoped and approved by the Product Owner 2026-10-14; no content drafted yet.
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

Subjects `ap_chemistry` and `ap_calculus_ab`, units 1–3 only. Not `ap_calculus_bc`, which inherits AB reference
entries by alias but has its own prose rows. Surfaces: `content_item_versions.stem` and `.explanation`,
`mcq_choices.choice_text` and `.rationale`, `frq_criteria.learner_facing_text`, `topic_explainers` (five columns),
`topic_point_briefs.what_it_is`.

## Out of scope

Every other subject and unit. Any Production write. Any regex or render-time transform of content. Widening the
slice before QA signs off.

## Method (author, do not transform)

1. **Detect.** A deterministic query lists candidate rows per surface. Exceptions are excluded by rule, not by model:
   compound units, Leibniz notation, single-symbol quotients, fractions inside an argument/subscript/exponent, scores.
2. **Draft.** One model call per row (Sonnet 5.5, medium effort). The model classifies each candidate as display
   (stands alone on a line, stacked) or inline (inside a sentence, slash kept) and writes the edit in `$…$`
   delimiters, `\frac{}{}`. Any row it is unsure of is **flagged and left unedited**.
3. **Validate.** Every edit must (a) parse in KaTeX with no error, (b) differ from the original only inside
   `$…$`, and (c) convert back, with `stripMath` and the fraction rewritten as a slash, to the original text exactly.
4. **Review.** The Product Owner reviews the diff. An independent QA pass (Opus or Codex) reviews the pilot before
   anything widens.
5. **Apply to Development only.** Production is a separate Hard Gate and a separate approval.

## Acceptance

- Every changed row passes all three validator checks; failures are listed, not hidden.
- Every flagged row has a stated reason.
- A before/after table of every changed row exists for QA.
- The pilot report answers: how many rows were display vs inline vs flagged, and did stacking read well in the app.

## Known gaps at open

- **Production counts are not yet measured for this slice.** The handoff's 415 / 1,044 figures are Production. The
  Development database available to this session holds 389 content items against Production's 4,368 stem rows, and a
  loose Development count (a slash adjacent to a bracket) finds **zero** Chemistry hits and a handful of Calculus AB
  hits. The pilot may be much smaller in Development than in Production, and Chemistry may contribute nothing.
- No renderer exists yet for prose surfaces. `MathText` is reusable but stems, choices, rationales and criteria must
  each opt in (`ap-prep-blueprint`). Drafted content cannot be seen typeset until that lands.
