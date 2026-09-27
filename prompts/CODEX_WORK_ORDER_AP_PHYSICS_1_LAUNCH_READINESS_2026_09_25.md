# Codex Work Order — AP Physics 1 Servability Measurement and Gap Proposals

**Context.** Same treatment as AP Biology, AP Statistics, AP Calculus AB, AP Chemistry, AP
Precalculus, and AP Calculus BC (2026-09-24/25). Read `docs/product/SUBJECT_SERVABILITY_CRITERIA.md`
first — it's the fixed six-criterion checklist this order measures against. Proposal only — no
Production writes, no PR, no merge to main.

Criterion 6 is already satisfied: exactly one `ap-physics-1` exam_pack_version
(`29c719dc-701b-470f-9e49-fab981722d3f`) is `status='published'` and `retired_at IS NULL`, verified
directly against Production 2026-09-25.

Paste the block below into Codex.

```text
Work order — AP Physics 1 servability gaps: canonicals, serving labels, difficulty.

Merge main first:

    git fetch origin
    git switch codex/apphysics1-launch-readiness-2026-09-25
    # If that branch does not exist instead run:
    # git switch -c codex/apphysics1-launch-readiness-2026-09-25 origin/main
    git merge origin/main

The checkout must be clean before starting. Commit and push to
codex/apphysics1-launch-readiness-2026-09-25 as you go. Production project ref: pcntajvbdfqhbeewmdry.
Read-only SQL against Production for measurement; everything you produce is a proposal artifact
(CSV/JSONL/SQL migration file), not an applied write.

READ FIRST:
- docs/product/SUBJECT_SERVABILITY_CRITERIA.md (the six criteria and how to measure them)
- docs/product/AP_BIOLOGY_COMPLETION_PLAN_2026_09_24.md and
  docs/product/AP_BIOLOGY_FAST_FOLLOW.md (the M0-M6 pattern this order mirrors: measure, propose,
  QA-verify, only then apply -- applying is Claude's job, not this order's)
- prompts/CODEX_WORK_ORDER_AP_CALCULUS_AB_LAUNCH_READINESS_2026_09_24.md (the closest-in-shape sibling
  order -- same method, same output shapes, follow it exactly; Physics 1's canonical gap is
  proportionally similar in size)
- docs/research/difficulty_reconciliation_2026_09_23/SUMMARY.md and
  docs/activity_log/DECISIONS_LOG.md's DECISION-0065 (the approved attainment-ratio method for
  difficulty -- reuse it exactly, don't invent a new one)

ALREADY MEASURED (verified directly against Production just now -- confirm these numbers as your
first step, but they should not need rediscovering):

  124 published items, single exam_pack_version (29c719dc-701b-470f-9e49-fab981722d3f), 61 FRQ / 63 MCQ.
  Rubric/criteria: 61/61 FRQ have frq_criteria rows (0 missing). 63/63 MCQ have exactly one is_correct
    choice. Clean.
  Canonical answers: 39 of 61 FRQ are missing canonical_answer_1 -- the largest canonical gap of any
    subject measured this week both in absolute count and as a fraction of FRQ (64%). Identify which
    content_keys these are and whether they cluster into batches (the way Calc AB's did) before
    authoring anything.
  canonical_answer_spans: not yet measured -- expect 0 coverage, a separate later-arriving fact.
  Serving labels (label_scope='serving', current/non-superseded row per item): of 124 rows, only 9
    validated, 115 not validated (96.8% non-validated -- get the exact status breakdown as your first
    step).
  Difficulty: 0 of 124 items have any app.content_item_difficulty row.

PART 1 -- INVESTIGATE THE MISSING-CANONICAL ITEMS BEFORE AUTHORING ANYTHING

Find out what the 39 canonical-missing FRQ items actually are -- check content/item-packages/
ap-physics-1/ in this repo, any authoring/import script that created these content_keys, and their
prompt_json/stem content directly. Two real possibilities that need different handling:
  - They are genuine content that was authored/imported without ever going through canonical-answer
    authoring. If so, propose canonical answers the same way Calc AB's order did: full_text + spans,
    criterion-exclusive, verified concatenation. Physics 1 FRQ frequently involve multi-part
    experimental-design and justification questions (not just numeric answers) -- make sure each span
    captures the actual reasoning/justification the rubric requires, not just a final number.
  - They are draft/placeholder/test content that should not have been published at all. If the stems
    look incomplete, templated, or clearly non-production-quality, say so explicitly rather than
    authoring canonicals for content that may need to be unpublished instead.
Given this is the largest gap measured so far (39 items), if you find the items split into clear
authoring batches (e.g. by unit or by content_key prefix), note that grouping explicitly -- it may be
worth splitting this into sub-batches for review rather than one large proposal file.
State which you found before proposing anything.

PART 2 -- CANONICAL ANSWERS (if Part 1 concludes they're genuine, keep-published content)

Same discipline as Calc AB's Part 2: for each FRQ, author a full_text answer plus criterion-exclusive
spans (concatenation verified to equal full_text exactly, every frq_criteria criterion covered by
exactly one exclusive span, no content deleted from anything currently published). For quantitative
items, independently re-derive the numeric answer from first principles (do not just restate the
rubric's stated value) -- this caught a live grading bug in Calc AB and a rubric error in Biology, so
treat it as a real check, not a formality. Output as a proposal JSONL/CSV matching the shape Calc AB's
order used.

PART 3 -- SERVING LABEL REFRESH for the 115 non-validated items

Same two-model lane as Biology's FF-3 work and Calc AB's Part 3 (prompts/CODEX_WORK_ORDER_PHYSICS_C_MECH_AND_CALC_BC_RELABEL_2026_09_24.md
has a closely related method for a sibling Physics subject -- read it for precedent even though it
covers different subjects). Two independently-architected models, agreement -> provisional_model
proposal ready for promotion, disagreement -> reported as disagreement, no adjudication. Held items
specifically: read why each was held before re-running it blind.

PART 4 -- DIFFICULTY (reuse DECISION-0065's method exactly)

Compute the same categorical-band-plus-attainment-ratio proposal for all 124 Physics 1 items. Use the
same CRR verb-verification approach and subject-mean normalization
(docs/research/apbio_difficulty_calibration_2026_09_22/README.md section 2 has the subject means
table -- if Physics 1 is not already in it, say so explicitly and propose a normalization approach
rather than fabricating a mean). Report using the same output shape as
docs/research/difficulty_reconciliation_2026_09_23/attainment_ratio_proposal.csv.

PART 5 -- GRADER-GATE SANITY CHECK (small, not exhaustive)

Pick 3 of the 22 FRQ that already have a canonical_answer_1 today and run app.qa_grade_frq against
each 3 times (same multi-run discipline as Biology's M5 baseline). Report status/confidence/integrity
per run.

DELIVERABLE

`docs/product/AP_PHYSICS_1_LAUNCH_READINESS_2026_09_25.md`, structured against the six criteria in
SUBJECT_SERVABILITY_CRITERIA.md -- one section per criterion, current state, what's proposed, what's
still open.

WHAT WOULD MAKE THIS REJECTED AT QA

- Any Production write.
- Authoring canonical answers for content without first checking whether it's genuine or should be
  unpublished instead.
- Treating canonical_answer_1 and canonical_answer_spans coverage as the same fact.
- Promoting anything to validated yourself, or implying a multi-unit agreement is promotable.
- A single grader-gate run reported as reliable evidence.
- Re-running a held item's label without reading why it was held first.
- Restating a rubric's stated numeric answer as a canonical answer without independently re-deriving
  it first.
- Fabricating a subject-mean normalization value for difficulty instead of flagging it as missing.
```
