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

- The hit counts are a loose upper bound. The rule-applying detector in Method step 1 gives the real number.
- No renderer exists yet for prose surfaces. `MathText` is reusable but stems, choices, rationales and criteria must
  each opt in. The Product Owner's visual QA needs this first, so it is the first build step.
- `ap-prep-blueprint` is not reachable as a GitHub repository from the session that opened this task; the app is
  edited through its Lovable project (`56cae479`). Confirm the edit path before building.
- Author-forward (`DECISION-0121` item 6) needs the prose rule stated in the authoring guidance, done in
  `docs/new_design/CONTENT_AND_PEDAGOGY.md`.
