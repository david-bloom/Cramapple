# Codex Work Order — AP Physics C: Electricity & Magnetism Servability Measurement and Gap Proposals

**Context.** Same treatment as AP Biology, AP Statistics, AP Calculus AB, AP Chemistry, AP
Precalculus, AP Calculus BC, AP Physics 1, and AP Physics 2 (2026-09-24/25). Read
`docs/product/SUBJECT_SERVABILITY_CRITERIA.md` first — it's the fixed six-criterion checklist this
order measures against. Proposal only — no Production writes, no PR, no merge to main.

Criterion 6 is already satisfied: exactly one `ap-physics-c-em` exam_pack_version
(`841a88cc-773c-44e5-97fa-6504f8667689`) is `status='published'` and `retired_at IS NULL`, verified
directly against Production 2026-09-25.

Unlike AP Physics C: Mechanics, this subject has **no existing serving-label work order** — the
FF-3/DECISION-0066 relabel order only covered Mechanics and Calc BC. This order covers all three
remaining criteria (3, 4, 5) for E&M.

Paste the block below into Codex.

```text
Work order — AP Physics C: E&M servability gaps: canonicals, serving labels, difficulty.

Merge main first:

    git fetch origin
    git switch codex/apphysicscem-launch-readiness-2026-09-25
    # If that branch does not exist instead run:
    # git switch -c codex/apphysicscem-launch-readiness-2026-09-25 origin/main
    git merge origin/main

The checkout must be clean before starting. Commit and push to
codex/apphysicscem-launch-readiness-2026-09-25 as you go. Production project ref:
pcntajvbdfqhbeewmdry. Read-only SQL against Production for measurement; everything you produce is a
proposal artifact (CSV/JSONL/SQL migration file), not an applied write.

READ FIRST:
- docs/product/SUBJECT_SERVABILITY_CRITERIA.md (the six criteria and how to measure them)
- docs/product/AP_BIOLOGY_COMPLETION_PLAN_2026_09_24.md and
  docs/product/AP_BIOLOGY_FAST_FOLLOW.md (the M0-M6 pattern this order mirrors)
- prompts/CODEX_WORK_ORDER_AP_PHYSICS_C_MECHANICS_LAUNCH_READINESS_2026_09_25.md (the sibling Physics C
  subject's order -- same method for canonicals/difficulty; note that subject's labels were already
  covered by a separate pre-existing order, but E&M has no such order, so Part 3 below is real,
  first-time-scoped work for this subject)
- docs/research/difficulty_reconciliation_2026_09_23/SUMMARY.md and
  docs/activity_log/DECISIONS_LOG.md's DECISION-0065 (the approved attainment-ratio method for
  difficulty -- reuse it exactly, don't invent a new one)

ALREADY MEASURED (verified directly against Production just now -- confirm as your first step):

  103 published items, single exam_pack_version (841a88cc-773c-44e5-97fa-6504f8667689), 55 FRQ / 48 MCQ.
  Rubric/criteria: 55/55 FRQ have frq_criteria rows (0 missing). 48/48 MCQ have exactly one is_correct
    choice. Clean.
  Canonical answers: 39 of 55 FRQ are missing canonical_answer_1 (71% -- tied with Physics C:
    Mechanics for the highest fraction of any subject measured this week, and the largest absolute
    count alongside Physics 1). Identify which content_keys these are and whether they cluster into
    batches before authoring anything.
  canonical_answer_spans: not yet measured -- expect 0 coverage.
  Serving labels (label_scope='serving', current/non-superseded row per item): of 103 rows, only 6
    validated, 97 not validated (94% non-validated). Get the exact status breakdown (legacy_unvalidated
    vs held vs stale vs provisional_model) as your first step -- do not assume it mirrors Mechanics'
    breakdown from the earlier FF-3 order, this subject has not been measured for that before.
  Difficulty: 0 of 103 items have any app.content_item_difficulty row.

PART 1 -- INVESTIGATE THE MISSING-CANONICAL ITEMS BEFORE AUTHORING ANYTHING

Find out what the 39 canonical-missing FRQ items actually are -- check content/item-packages/
ap-physics-c-em/ in this repo, any authoring/import script that created these content_keys, and their
prompt_json/stem content directly. Two real possibilities that need different handling:
  - They are genuine content that was authored/imported without ever going through canonical-answer
    authoring. If so, propose canonical answers the same way Calc AB's order did: full_text + spans,
    criterion-exclusive, verified concatenation. Physics C: E&M FRQ are calculus-based (Gauss's law
    integrals, circuit differential equations, magnetic flux/induction) -- independently re-derive
    every quantitative result from first principles before writing it, the same discipline that caught
    a live grading bug in Calc AB.
  - They are draft/placeholder/test content that should not have been published at all. If the stems
    look incomplete, templated, or clearly non-production-quality, say so explicitly rather than
    authoring canonicals for content that may need to be unpublished instead.
State which you found before proposing anything.

PART 2 -- CANONICAL ANSWERS (if Part 1 concludes they're genuine, keep-published content)

Same discipline as Calc AB's Part 2: for each FRQ, author a full_text answer plus criterion-exclusive
spans (concatenation verified to equal full_text exactly, every frq_criteria criterion covered by
exactly one exclusive span, no content deleted from anything currently published). Output as a
proposal JSONL/CSV matching the shape Calc AB's order used.

PART 3 -- SERVING LABEL REFRESH for the 97 non-validated items (first-time work for this subject)

Same two-model lane as Biology's FF-3 work and the FF-3/DECISION-0066 relabel order used for Physics
C: Mechanics (prompts/CODEX_WORK_ORDER_PHYSICS_C_MECH_AND_CALC_BC_RELABEL_2026_09_24.md is good
precedent for method, but this is a distinct subject with its own measurement -- do not reuse that
order's Mechanics-specific numbers). Two independently-architected models, agreement -> provisional_
model proposal ready for promotion, disagreement -> reported as disagreement, no adjudication. Held
items specifically: read why each was held before re-running it blind.

PART 4 -- DIFFICULTY (reuse DECISION-0065's method exactly)

Compute the same categorical-band-plus-attainment-ratio proposal for all 103 Physics C: E&M items. Use
the same CRR verb-verification approach and subject-mean normalization
(docs/research/apbio_difficulty_calibration_2026_09_22/README.md section 2 -- if this subject is not
already in the subject-means table, say so explicitly and propose a normalization approach rather than
fabricating a mean; check whether it's reasonable to share Physics C: Mechanics' mean given they're the
same overall AP exam, or whether E&M's item style is different enough to need its own). Report using
the same output shape as docs/research/difficulty_reconciliation_2026_09_23/attainment_ratio_proposal.csv.

PART 5 -- GRADER-GATE SANITY CHECK (small, not exhaustive)

Pick 3 of the 16 FRQ that already have a canonical_answer_1 today and run app.qa_grade_frq against
each 3 times (same multi-run discipline as Biology's M5 baseline). Report status/confidence/integrity
per run.

DELIVERABLE

`docs/product/AP_PHYSICS_C_EM_LAUNCH_READINESS_2026_09_25.md`, structured against the six criteria in
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
- Assuming this subject's label-status breakdown mirrors Physics C: Mechanics' without measuring it.
- Fabricating a subject-mean normalization value for difficulty instead of flagging it as missing.
```
