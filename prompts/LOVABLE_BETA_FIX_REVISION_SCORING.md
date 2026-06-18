# Lovable Patch - Fix Revised-Answer Scoring and Comparison Surface

Apply a focused fix to the existing Cramapple beta at
`https://cramapple-beta.lovable.app/beta`. Do not redesign anything. Do not
touch the broader UX-006 student practice preview work. Change only what is
needed to correct the bug described below and the comparison panel that
reports it.

## Bug

On an FRQ, after a partial cold submission, the grader returns a per-criterion
result with `Fix this part` buttons against each missed criterion. When the
student clicks `Fix this part`, writes a clearly correct revision targeting
that one criterion, and submits, the comparison view reports
`Predicted: +0   Actual: +0` and leaves the revised total unchanged, even
when the revision plainly satisfies the targeted criterion.

Reproduction (Photosynthesis light reactions FRQ, 4 criteria):

1. Submit a deliberately partial cold answer. Grader returns `2/4` with two
   missed criteria, each with a `Fix this part` button.
2. Click `Fix this part` on "Describes electron path PSII → ETC → DCPIP".
3. In the coached-revision workspace, write: "Electrons from water enter
   PSII, travel through the electron transport chain (plastoquinone,
   cytochrome b6f, plastocyanin), and reduce DCPIP."
4. Submit revision.

Observed: `ORIGINAL VS REVISED` shows `REVISED (2/4)` with
`Predicted: +0   Actual: +0` and no per-criterion breakdown for the revision.

Root cause hypothesis: the revision is being graded in isolation against the
full 4-criterion rubric, so the revised paragraph loses credit on criteria the
original earned (for example it no longer restates water as the electron
source). The comparison then sums to the same total and the learner sees
"you fixed exactly what was asked, gained nothing."

## Required Fix - Targeted Criterion Grading

Adopt option (b) targeted grading. The original submission is immutable.
A revision is scoped to exactly one criterion, the one the student clicked
`Fix this part` on.

Semantics:

- The revised text is graded ONLY against the targeted criterion.
- For every other criterion, carry the original submission's per-criterion
  decision forward unchanged.
- The revised total is the sum of the carried-forward criterion decisions
  plus the new decision for the targeted criterion.
- The targeted criterion can move from Missed to Earned, stay Missed, or be
  reported as Unclear if the grader cannot decide on the revised text alone.
  No other criterion can change as a result of a revision.

This matches the per-criterion repair mental model the UI already presents
and removes the silent regression on untouched criteria.

## Required Fix - Comparison Surface

Update the `ORIGINAL VS REVISED` panel to show, at minimum:

- Original total and revised total, in the form `ORIGINAL (2/4)` and
  `REVISED (3/4)`.
- The targeted criterion, flagged so the learner sees which one was
  in scope for this revision.
- Per-criterion delta against the original: Gained, Lost, or Unchanged.
  Given the targeted grading rule, only the targeted criterion can show
  Gained or Lost, and all others must show Unchanged. Render the rule
  visibly so the learner understands why.
- The learner's predicted gain (as already collected) and the observed gain,
  for example `Predicted: +1   Actual: +1`.
- A short evidence line on the targeted criterion explaining why the
  revised text was judged Earned, Missed, or Unclear.

Keep the original submission text visible and read-only. Keep the revised
text visible. Do not regrade or rerender the original.

## Out of Scope

- No backend changes. Mock fixtures only.
- No changes to cold-grading behavior.
- No changes to UX-006 preview scope.
- No second revision round in this patch. One round only, as today.
- No marketing or hero copy changes.

## Acceptance Check

Run the exact walkthrough above. After step 5 the comparison panel must
show:

- `ORIGINAL (2/4)` and `REVISED (3/4)`.
- Targeted criterion "Describes electron path PSII → ETC → DCPIP" marked
  Earned with a Gained delta.
- The other three criteria marked Unchanged with their original decisions.
- `Predicted: +1   Actual: +1` (or whatever the learner predicted, with
  Actual matching the recomputed gain).
- A short evidence line citing the PSII → ETC → DCPIP path in the revised
  sentence.

A second check: if the learner writes a revision that does not address the
targeted criterion, the panel must show `REVISED (2/4)`, the targeted
criterion still Missed, all others Unchanged, and `Actual: +0`. The total
must never drop below the original.

## Related Internal Spec

`docs/product/STUDENT_PRACTICE_AND_GRADING_DESIGN.md` §6.2 criterion cards,
§9 repair preserves the immutable original and recommends one minimum fix,
and §11 regrading and correction for the comparison surface.
