# Codex Work Order — AP Precalculus Servability Measurement and Gap Proposals

**Context.** Same treatment as AP Biology, AP Statistics, and AP Calculus AB (2026-09-24/25). Read
`docs/product/SUBJECT_SERVABILITY_CRITERIA.md` first — it's the fixed six-criterion checklist this
order measures against, so nothing here needs to re-derive what "servable" means.
Proposal only — no Production writes, no PR, no merge to main.

Criterion 6 is already satisfied: exactly one `ap-precalculus` exam_pack_version
(`5522b532-5e50-41f2-99a2-10144bd4e8db`) is `status='published'` and `retired_at IS NULL`, verified
directly against Production 2026-09-25. The other criteria have real, already-measured gaps — this
order is about closing them, not discovering whether they exist.

Paste the block below into Codex.

```text
Work order — AP Precalculus servability gaps: canonicals, serving labels, difficulty.

Merge main first:

    git fetch origin
    git switch codex/apprecalc-launch-readiness-2026-09-25
    # If that branch does not exist instead run:
    # git switch -c codex/apprecalc-launch-readiness-2026-09-25 origin/main
    git merge origin/main

The checkout must be clean before starting. Commit and push to
codex/apprecalc-launch-readiness-2026-09-25 as you go. Production project ref: pcntajvbdfqhbeewmdry.
Read-only SQL against Production for measurement; everything you produce is a proposal artifact
(CSV/JSONL/SQL migration file), not an applied write.

READ FIRST:
- docs/product/SUBJECT_SERVABILITY_CRITERIA.md (the six criteria and how to measure them)
- docs/product/AP_BIOLOGY_COMPLETION_PLAN_2026_09_24.md and
  docs/product/AP_BIOLOGY_FAST_FOLLOW.md (the M0-M6 pattern this order mirrors: measure, propose,
  QA-verify, only then apply -- applying is Claude's job, not this order's)
- prompts/CODEX_WORK_ORDER_AP_CALCULUS_AB_LAUNCH_READINESS_2026_09_24.md (the immediately-prior sibling
  order for a closely related subject -- same method, same output shapes, follow it exactly)
- docs/research/difficulty_reconciliation_2026_09_23/SUMMARY.md and
  docs/activity_log/DECISIONS_LOG.md's DECISION-0065 (the approved attainment-ratio method --
  reuse it exactly, don't invent a new one)

ALREADY MEASURED (verified directly against Production just now -- confirm these numbers as your
first step, but they should not need rediscovering):

  120 published items, single exam_pack_version (5522b532-5e50-41f2-99a2-10144bd4e8db), 65 FRQ / 55 MCQ.
  Rubric/criteria: 65/65 FRQ have frq_criteria rows (0 missing). MCQ correct-choice count not yet
    spot-checked in this measurement pass -- confirm 55/55 MCQ have exactly one is_correct choice as
    your first step, the same way Calc AB's order did.
  Canonical answers: 32 of 65 FRQ are missing canonical_answer_1. Identify which content_keys these
    are and whether they cluster into batches (the way Calc AB's did into u13-*/np2-*/024-026) before
    authoring anything.
  canonical_answer_spans: not yet measured at all for this subject -- expect 0 coverage; that is a
    separate, later-arriving fact (do not conflate "has a canonical" with "has spans").
  Serving labels (label_scope='serving', current/non-superseded row per item): of 120 rows checked,
    30 validated, 90 not validated (mix of held/stale/legacy_unvalidated/provisional_model -- get the
    exact breakdown as your first step).
  Difficulty: 0 of 120 items have any app.content_item_difficulty row.

PART 1 -- INVESTIGATE THE MISSING-CANONICAL BATCH BEFORE AUTHORING ANYTHING

Find out what the 32 canonical-missing FRQ items actually are -- check content/item-packages/
ap-precalculus/ in this repo, any authoring/import script that created these content_keys, and their
prompt_json/stem content directly. Two real possibilities that need different handling:
  - They are genuine content that was authored/imported without ever going through canonical-answer
    authoring. If so, propose canonical answers the same way Calc AB's order did: full_text + spans,
    criterion-exclusive, verified concatenation.
  - They are draft/placeholder/test content that should not have been published at all. If the stems
    look incomplete, templated, or clearly non-production-quality, say so explicitly rather than
    authoring canonicals for content that may need to be unpublished instead.
State which you found before proposing anything for these items.

PART 2 -- CANONICAL ANSWERS (if Part 1 concludes they're genuine, keep-published content)

Same discipline as Calc AB's Part 2: for each FRQ, author a full_text answer plus criterion-exclusive
spans (concatenation verified to equal full_text exactly, every frq_criteria criterion covered by
exactly one exclusive span, no content deleted from anything currently published). Output as a
proposal JSONL/CSV matching the shape Calc AB's order used.

PART 3 -- SERVING LABEL REFRESH for the 90 non-validated items

Same two-model lane as Biology's FF-3 work, the Physics-C-Mech/Calc-BC relabel order, and Calc AB's
Part 3 (prompts/CODEX_WORK_ORDER_PHYSICS_C_MECH_AND_CALC_BC_RELABEL_2026_09_24.md has the exact method
-- follow it, adapted to Precalculus). Two independently-architected models, agreement -> provisional_
model proposal ready for promotion, disagreement -> reported as disagreement, no adjudication. Held
items specifically: read why each was held before re-running it blind.

PART 4 -- DIFFICULTY (reuse DECISION-0065's method exactly)

Compute the same categorical-band-plus-attainment-ratio proposal for all 120 Precalculus items. Use
the same CRR verb-verification approach and subject-mean normalization
(docs/research/apbio_difficulty_calibration_2026_09_22/README.md section 2 has the subject means
table -- if Precalculus is not already in it, say so explicitly and propose a normalization approach
rather than fabricating a mean). Report using the same output shape as
docs/research/difficulty_reconciliation_2026_09_23/attainment_ratio_proposal.csv.

PART 5 -- GRADER-GATE SANITY CHECK (small, not exhaustive)

Pick 3 of the 33 FRQ that already have a canonical_answer_1 today and run app.qa_grade_frq against
each 3 times (same multi-run discipline as Biology's M5 baseline). Report status/confidence/integrity
per run.

DELIVERABLE

`docs/product/AP_PRECALCULUS_LAUNCH_READINESS_2026_09_25.md`, structured against the six criteria in
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
- Fabricating a subject-mean normalization value for difficulty instead of flagging it as missing.
```
