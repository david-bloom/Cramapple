# Codex Work Order — Author New Distractors/Criteria to Resolve 4 Ambiguous Unit Tags

**Context: DECISION-0066's multi-unit tiebreak correction** (`docs/activity_log/DECISIONS_LOG.md`).
Read it in full first. Short version: 26 two-model-agreed multi-unit serving labels got an
independent third read (Claude, against the subject's unit closed list and full item content). 22
confirmed; 2 are genuine over-tags; 2 are genuinely unresolved even on careful reading. This order is
about those 4 — not a safety fix (over-tagging only delays availability, it can't show a student
content before they're ready), just a content-quality cleanup so the ambiguity doesn't have to be
argued about again.

Paste the block below into Codex.

```text
Work order — author new distractors/criteria for 4 items with disputed multi-unit serving tags.

Merge main first:

    git fetch origin
    git switch codex/unit-tag-distractor-repair-2026-09-24
    # If that branch does not exist instead run:
    # git switch -c codex/unit-tag-distractor-repair-2026-09-24 origin/main
    git merge origin/main

The checkout must be clean before starting. Commit and push to
codex/unit-tag-distractor-repair-2026-09-24 as you go. Do not open a PR and do not merge to main.
Proposal only -- no Production writes.

READ FIRST: docs/activity_log/DECISIONS_LOG.md, DECISION-0066's "Correction, same day" section, for
the full reasoning on all 26 items, not just the 4 below.

FOUR ITEMS, TWO DIFFERENT PROBLEMS

=== A. Genuine over-tags (2 items) -- confirm and simplify ===

APBIO-MCQ-012 (glycosidic linkages / polysaccharide structure) is tagged required_units=[1,3].
Independent review found unit 3 (Cellular Energetics) is not actually needed -- the correct answer
and all its reasoning is pure unit 1 (macromolecule structure, enzyme specificity). Verify this
yourself against the current published item and its choices, then, if you agree:
  - Confirm required_units should be [1] only.
  - Report this as a proposed serving-label correction (NOT a content edit -- do not touch the
    stem or choices for this one, the item itself is fine, only its tag is wrong).

apchem-mcq-048 (catalyst mechanism) is tagged required_units=[5,6,7]. Independent review found units
6 and 7 (thermochemistry, equilibrium) appear only in wrong-answer distractors ("shifts equilibrium,"
"increases deltaH") -- rejecting those wrong answers isn't what makes B correct; a student who only
knows unit 5 (kinetics/activation energy) can select B on its own definitional merits. Verify, then
if you agree, same treatment: propose required_units=[5] only, no content edit.

For both: if your own read disagrees with either of these findings, say so and why -- do not just
defer to the summary above.

=== B. Genuinely unresolved (2 items) -- author content that removes the ambiguity ===

APBIO-MCQ-041 (proto-oncogene/tumor-suppressor, gain-of-function vs loss-of-function) is tagged
required_units=[4,6]. Two independent reads could not agree whether "gain-of-function"/
"loss-of-function" vocabulary genuinely requires unit 6 (Gene Expression and Regulation) content, or
whether it's general-enough genetics vocabulary that unit 4 alone covers. Rather than a third
argument, AUTHOR new distractors that make the intended answer unambiguous:
  - If you determine the item SHOULD require unit 6: rewrite one or more distractors so that
    correctly rejecting them requires the specific unit-6 concept (e.g. a distractor whose error is
    a genuinely plausible gene-regulation misconception, not a cell-cycle one) -- so a student who
    hasn't covered unit 6 would have a real chance of picking that wrong answer, not just an
    implausible option.
  - If you determine the item should be unit 4 ONLY: rewrite the current distractors so none of them
    depend on unit-6-specific vocabulary or concepts to reject -- purely unit-4 (cell cycle/oncogene)
    reasoning should be sufficient to identify the correct answer and eliminate every wrong one.
  - State which direction you chose and why. This is a real curriculum-design call; make it
    deliberately, don't default silently.

apchem-frq-l-004 (AgCl gravimetric stoichiometry) is tagged required_units=[1,3,4]. Independent
review found unit 1 (mole concept, used in part a's calculation) is defensible, but unit 3
(properties of substances/mixtures -- solutions, IMFs) does not appear to be needed anywhere in the
item as currently written. Two options:
  - If unit 3 was never actually intended: propose required_units=[1,4], no content edit needed.
  - If you believe unit 3 SHOULD be tested here (e.g. a genuine solution-concentration step is
    missing from the item): author the missing criterion/evidence_requirements text that would make
    unit 3 genuinely necessary, and say what changed and why.
State which you chose.

WHAT WOULD MAKE THIS REJECTED AT QA

  - Content edits to APBIO-MCQ-012 or apchem-mcq-048 (part A) -- those are tag-only corrections, not
    content problems.
  - A rewritten distractor for MCQ-041 that's implausible (an answer nobody would pick regardless of
    what they've covered) -- it must be a genuine, temptable misconception for a student who hasn't
    covered the target unit.
  - Silently picking a direction for MCQ-041 or apchem-frq-l-004 without stating which and why.
  - Any change to the correct answer, the correct answer's own text, or FRQ criteria that already
    earn points correctly -- only the ambiguous surrounding material changes.

Report per item: what you found, what you changed (or confirmed as tag-only), and your reasoning.
Proposal only. Claude QAs and applies both the content edits (if any) and the resulting serving-label
corrections together, atomically -- a label change should never land without the content it now
correctly describes, or vice versa.
```

## What stays with Claude

- QA of both the content edits (does the new distractor actually work as intended) and the
  resulting serving-label tag, applied together.
- Promoting the corrected labels to `validated` once QA passes (same mechanism as the rest of
  DECISION-0066, single-unit lane where the result ends up single-unit).
