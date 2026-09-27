# Codex Work Order — AP Physics C: Mechanics Canonicals and Difficulty

**Context.** Criteria 1, 2, and 6 (per `docs/product/SUBJECT_SERVABILITY_CRITERIA.md`) are already
clean for AP Physics C: Mechanics. Criterion 3 (serving labels) already has an existing, not-yet-run
work order (`prompts/CODEX_WORK_ORDER_PHYSICS_C_MECH_AND_CALC_BC_RELABEL_2026_09_24.md`, FF-3/
DECISION-0066) — run that one for labels, don't duplicate it here. This order covers only criteria 4
(canonical answers) and 5 (difficulty), which that earlier order does not touch. Proposal only — no
Production writes, no PR, no merge to main.

Criterion 6 confirmed: exactly one `ap-physics-c-mechanics` exam_pack_version
(`ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9`) is `status='published'` and `retired_at IS NULL`, verified
directly against Production 2026-09-25.

Paste the block below into Codex.

```text
Work order — AP Physics C: Mechanics canonical answers and difficulty (labels covered separately).

Merge main first:

    git fetch origin
    git switch codex/apphysicscmech-canonicals-difficulty-2026-09-25
    # If that branch does not exist instead run:
    # git switch -c codex/apphysicscmech-canonicals-difficulty-2026-09-25 origin/main
    git merge origin/main

The checkout must be clean before starting. Commit and push to
codex/apphysicscmech-canonicals-difficulty-2026-09-25 as you go. Production project ref:
pcntajvbdfqhbeewmdry. Read-only SQL against Production for measurement; everything you produce is a
proposal artifact (CSV/JSONL/SQL migration file), not an applied write.

READ FIRST:
- docs/product/SUBJECT_SERVABILITY_CRITERIA.md (the six criteria and how to measure them)
- prompts/CODEX_WORK_ORDER_PHYSICS_C_MECH_AND_CALC_BC_RELABEL_2026_09_24.md (the EXISTING work order
  for this subject's criterion-3 gap -- if it has not been run yet, flag that in your deliverable as a
  separate, still-open item; do not re-derive or duplicate its content)
- prompts/CODEX_WORK_ORDER_AP_CALCULUS_AB_LAUNCH_READINESS_2026_09_24.md's Part 1, 2, and 4 (the exact
  canonical-authoring and difficulty method -- follow it, adapted to Physics C: Mechanics)
- docs/research/difficulty_reconciliation_2026_09_23/SUMMARY.md and
  docs/activity_log/DECISIONS_LOG.md's DECISION-0065 (the approved attainment-ratio method for
  difficulty -- reuse it exactly, don't invent a new one)

ALREADY MEASURED (verified directly against Production just now -- confirm as your first step):

  84 published items, single exam_pack_version (ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9), 42 FRQ / 42 MCQ.
  Rubric/criteria: 42/42 FRQ have frq_criteria rows (0 missing). 42/42 MCQ have exactly one is_correct
    choice. Clean.
  Canonical answers: 29 of 42 FRQ are missing canonical_answer_1 (69% -- the highest fraction of any
    subject measured this week). Identify which content_keys these are and whether they cluster into
    batches before authoring anything.
  canonical_answer_spans: not yet measured -- expect 0 coverage.
  Serving labels: NOT this order's scope -- see prompts/CODEX_WORK_ORDER_PHYSICS_C_MECH_AND_CALC_BC_RELABEL_2026_09_24.md.
  Difficulty: 0 of 84 items have any app.content_item_difficulty row.

PART 1 -- INVESTIGATE THE MISSING-CANONICAL ITEMS BEFORE AUTHORING ANYTHING

Find out what the 29 canonical-missing FRQ items actually are -- check content/item-packages/
ap-physics-c-mechanics/ in this repo, any authoring/import script that created these content_keys, and
their prompt_json/stem content directly. Two real possibilities that need different handling:
  - They are genuine content that was authored/imported without ever going through canonical-answer
    authoring. If so, propose canonical answers the same way Calc AB's order did: full_text + spans,
    criterion-exclusive, verified concatenation. Physics C: Mechanics FRQ are calculus-based
    (derivatives/integrals of motion, energy, rotation, oscillation) -- independently re-derive every
    quantitative result from first principles before writing it, the same discipline that caught a
    live grading bug in Calc AB.
  - They are draft/placeholder/test content that should not have been published at all. If the stems
    look incomplete, templated, or clearly non-production-quality, say so explicitly rather than
    authoring canonicals for content that may need to be unpublished instead.
State which you found before proposing anything.

PART 2 -- CANONICAL ANSWERS (if Part 1 concludes they're genuine, keep-published content)

Same discipline as Calc AB's Part 2: for each FRQ, author a full_text answer plus criterion-exclusive
spans (concatenation verified to equal full_text exactly, every frq_criteria criterion covered by
exactly one exclusive span, no content deleted from anything currently published). Output as a
proposal JSONL/CSV matching the shape Calc AB's order used.

PART 3 -- DIFFICULTY (reuse DECISION-0065's method exactly)

Compute the same categorical-band-plus-attainment-ratio proposal for all 84 Physics C: Mechanics
items. Use the same CRR verb-verification approach and subject-mean normalization
(docs/research/apbio_difficulty_calibration_2026_09_22/README.md section 2 -- if this subject is not
already in the subject-means table, say so explicitly and propose a normalization approach rather than
fabricating a mean). Report using the same output shape as
docs/research/difficulty_reconciliation_2026_09_23/attainment_ratio_proposal.csv.

PART 4 -- GRADER-GATE SANITY CHECK (small, not exhaustive)

Pick 3 of the 13 FRQ that already have a canonical_answer_1 today and run app.qa_grade_frq against
each 3 times (same multi-run discipline as Biology's M5 baseline). Report status/confidence/integrity
per run.

DELIVERABLE

`docs/product/AP_PHYSICS_C_MECHANICS_LAUNCH_READINESS_2026_09_25.md`, structured against the six
criteria in SUBJECT_SERVABILITY_CRITERIA.md -- one section per criterion. For criterion 3, state
explicitly that the gap is covered by the separate FF-3/DECISION-0066 order and whether that order has
been run yet, rather than leaving the section blank.

WHAT WOULD MAKE THIS REJECTED AT QA

- Any Production write.
- Authoring canonical answers for content without first checking whether it's genuine or should be
  unpublished instead.
- Treating canonical_answer_1 and canonical_answer_spans coverage as the same fact.
- Duplicating or re-deriving the existing FF-3/DECISION-0066 relabel order's content.
- A single grader-gate run reported as reliable evidence.
- Fabricating a subject-mean normalization value for difficulty instead of flagging it as missing.
```
