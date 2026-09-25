# Codex Work Order — AP Physics 2 Servability Measurement and Gap Proposals

**Context.** Same treatment as AP Biology, AP Statistics, AP Calculus AB, AP Chemistry, AP
Precalculus, AP Calculus BC, and AP Physics 1 (2026-09-24/25). Read
`docs/product/SUBJECT_SERVABILITY_CRITERIA.md` first — it's the fixed six-criterion checklist this
order measures against. Proposal only — no Production writes, no PR, no merge to main.

Criterion 6 is already satisfied: exactly one `ap-physics-2` exam_pack_version
(`f584ab0d-114a-4520-9649-42e3e9a2fd22`) is `status='published'` and `retired_at IS NULL`, verified
directly against Production 2026-09-25.

Paste the block below into Codex.

```text
Work order — AP Physics 2 servability gaps: canonicals, serving labels, difficulty.

Merge main first:

    git fetch origin
    git switch codex/apphysics2-launch-readiness-2026-09-25
    # If that branch does not exist instead run:
    # git switch -c codex/apphysics2-launch-readiness-2026-09-25 origin/main
    git merge origin/main

The checkout must be clean before starting. Commit and push to
codex/apphysics2-launch-readiness-2026-09-25 as you go. Production project ref: pcntajvbdfqhbeewmdry.
Read-only SQL against Production for measurement; everything you produce is a proposal artifact
(CSV/JSONL/SQL migration file), not an applied write.

READ FIRST:
- docs/product/SUBJECT_SERVABILITY_CRITERIA.md (the six criteria and how to measure them)
- docs/product/AP_BIOLOGY_COMPLETION_PLAN_2026_09_24.md and
  docs/product/AP_BIOLOGY_FAST_FOLLOW.md (the M0-M6 pattern this order mirrors)
- prompts/CODEX_WORK_ORDER_AP_PHYSICS_1_LAUNCH_READINESS_2026_09_25.md (the immediately-prior sibling
  order -- same subject family, same method, same output shapes, follow it exactly)
- docs/research/difficulty_reconciliation_2026_09_23/SUMMARY.md and
  docs/activity_log/DECISIONS_LOG.md's DECISION-0065 (the approved attainment-ratio method for
  difficulty -- reuse it exactly, don't invent a new one)

ALREADY MEASURED (verified directly against Production just now -- confirm these numbers as your
first step, but they should not need rediscovering):

  79 published items, single exam_pack_version (f584ab0d-114a-4520-9649-42e3e9a2fd22), 37 FRQ / 42 MCQ.
  Rubric/criteria: 37/37 FRQ have frq_criteria rows (0 missing). 42/42 MCQ have exactly one is_correct
    choice. Clean.
  Canonical answers: 19 of 37 FRQ are missing canonical_answer_1 (51%). Identify which content_keys
    these are and whether they cluster into batches before authoring anything.
  canonical_answer_spans: not yet measured -- expect 0 coverage, a separate later-arriving fact.
  Serving labels (label_scope='serving', current/non-superseded row per item): of 79 rows, 10
    validated, 69 not validated (get the exact status breakdown as your first step).
  Difficulty: 0 of 79 items have any app.content_item_difficulty row.

PART 1 -- INVESTIGATE THE MISSING-CANONICAL ITEMS BEFORE AUTHORING ANYTHING

Find out what the 19 canonical-missing FRQ items actually are -- check content/item-packages/
ap-physics-2/ in this repo, any authoring/import script that created these content_keys, and their
prompt_json/stem content directly. Two real possibilities that need different handling:
  - They are genuine content that was authored/imported without ever going through canonical-answer
    authoring. If so, propose canonical answers the same way Physics 1's order did: full_text + spans,
    criterion-exclusive, verified concatenation. Physics 2 FRQ often involve conceptual/qualitative
    reasoning (fluids, thermodynamics, E&M, optics, modern physics) as much as numeric calculation --
    make sure each span captures the actual reasoning the rubric requires, not just a final number.
  - They are draft/placeholder/test content that should not have been published at all. If the stems
    look incomplete, templated, or clearly non-production-quality, say so explicitly rather than
    authoring canonicals for content that may need to be unpublished instead.
State which you found before proposing anything.

PART 2 -- CANONICAL ANSWERS (if Part 1 concludes they're genuine, keep-published content)

Same discipline as the prior physics order's Part 2: for each FRQ, author a full_text answer plus
criterion-exclusive spans (concatenation verified to equal full_text exactly, every frq_criteria
criterion covered by exactly one exclusive span, no content deleted from anything currently
published). For quantitative items, independently re-derive the numeric answer from first principles
before writing it. Output as a proposal JSONL/CSV matching the shape the prior orders used.

PART 3 -- SERVING LABEL REFRESH for the 69 non-validated items

Same two-model lane as Biology's FF-3 work and the prior orders' Part 3. Two independently-architected
models, agreement -> provisional_model proposal ready for promotion, disagreement -> reported as
disagreement, no adjudication. Held items specifically: read why each was held before re-running it
blind.

PART 4 -- DIFFICULTY (reuse DECISION-0065's method exactly)

Compute the same categorical-band-plus-attainment-ratio proposal for all 79 Physics 2 items. Use the
same CRR verb-verification approach and subject-mean normalization
(docs/research/apbio_difficulty_calibration_2026_09_22/README.md section 2 -- if Physics 2 is not
already in the subject-means table, say so explicitly and propose a normalization approach rather than
fabricating a mean). Report using the same output shape as
docs/research/difficulty_reconciliation_2026_09_23/attainment_ratio_proposal.csv.

PART 5 -- GRADER-GATE SANITY CHECK (small, not exhaustive)

Pick 3 of the 18 FRQ that already have a canonical_answer_1 today and run app.qa_grade_frq against
each 3 times (same multi-run discipline as Biology's M5 baseline). Report status/confidence/integrity
per run.

DELIVERABLE

`docs/product/AP_PHYSICS_2_LAUNCH_READINESS_2026_09_25.md`, structured against the six criteria in
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
