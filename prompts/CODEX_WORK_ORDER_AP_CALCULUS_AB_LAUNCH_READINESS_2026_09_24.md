# Codex Work Order — AP Calculus AB Servability Measurement and Gap Proposals

**Context.** Same treatment as AP Biology (2026-09-24) and the AP Statistics work order sent the same
day. Read `docs/product/SUBJECT_SERVABILITY_CRITERIA.md` first — it's the fixed six-criterion
checklist this order measures against, so nothing here needs to re-derive what "servable" means.
Proposal only — no Production writes, no PR, no merge to main.

Unlike Statistics, Calculus AB has **no exam-pack-version routing hazard** (verified: exactly one
`ap_calculus_ab` exam_pack_version is `status='published'` and `retired_at IS NULL`). Criterion 6 is
already satisfied. The other five have real, already-measured gaps — this order is about closing
them, not discovering whether they exist.

Paste the block below into Codex.

```text
Work order — AP Calculus AB servability gaps: canonicals, serving labels, difficulty.

Merge main first:

    git fetch origin
    git switch codex/apcalcab-launch-readiness-2026-09-24
    # If that branch does not exist instead run:
    # git switch -c codex/apcalcab-launch-readiness-2026-09-24 origin/main
    git merge origin/main

The checkout must be clean before starting. Commit and push to
codex/apcalcab-launch-readiness-2026-09-24 as you go. Production project ref: pcntajvbdfqhbeewmdry.
Read-only SQL against Production for measurement; everything you produce is a proposal artifact
(CSV/JSONL/SQL migration file), not an applied write.

READ FIRST:
- docs/product/SUBJECT_SERVABILITY_CRITERIA.md (the six criteria and how to measure them)
- docs/product/AP_BIOLOGY_COMPLETION_PLAN_2026_09_24.md and
  docs/product/AP_BIOLOGY_FAST_FOLLOW.md (the M0-M6 pattern this order mirrors: measure, propose,
  QA-verify, only then apply -- applying is Claude's job, not this order's)
- docs/research/difficulty_reconciliation_2026_09_23/SUMMARY.md and
  docs/activity_log/DECISIONS_LOG.md's DECISION-0065 (the approved attainment-ratio method --
  reuse it exactly, don't invent a new one)

ALREADY MEASURED (verified directly against Production just now -- confirm these numbers as your
first step, but they should not need rediscovering):

  124 published items (62 FRQ, 62 MCQ), single exam_pack_version (826c8cf1-bc1b-4f2a-bd33-61a758e1487d).
  Rubric/criteria: 62/62 FRQ have frq_criteria; 62/62 MCQ have exactly one is_correct choice. Clean.
  Canonical answers: 29 of 62 FRQ have canonical_answer_1; 33 do not. The 33 cluster into three
    batches by content_key, not scattered: apcalcab-frq-u13-001..020 (20 items), apcalcab-frq-np2-001..010
    (10 items), and apcalcab-frq-024/025/026 (3 items, a gap in the otherwise-covered main
    apcalcab-frq-0XX bank). canonical_answer_spans is 0/62 across the board (expected -- that's
    Biology-only work so far, not a Calc AB-specific gap; note it but it is not this order's scope).
  Serving labels (label_scope='serving', current/non-superseded, all 91 rows across the 124 items --
    some items may lack a row at all, confirm): 9 validated, 14 provisional_model, 16 held, 9 stale,
    43 legacy_unvalidated.
  Difficulty: 0 of 124 items have any app.content_item_difficulty row.

PART 1 -- INVESTIGATE THE THREE MISSING-CANONICAL BATCHES BEFORE AUTHORING ANYTHING

Find out what `apcalcab-frq-u13-*` and `apcalcab-frq-np2-*` actually are -- check content/item-packages/
ap-calculus-ab/ in this repo, any authoring/import script that created these content_keys, and their
prompt_json/stem content directly. Two real possibilities that need different handling:
  - They are genuine additional Unit-13-labeled or "np2" (unclear what this abbreviates -- check
    prompt_json or any accompanying metadata) content that was authored/imported without ever going
    through canonical-answer authoring. If so, this is a normal missing-canonical gap: propose
    canonical answers the same way work order F did for Biology (full_text + spans, criterion-exclusive,
    verified concatenation).
  - They are draft/placeholder/test content that should not have been published at all. If the stems
    look incomplete, templated, or clearly non-production-quality, say so explicitly rather than
    authoring canonicals for content that may need to be unpublished instead -- that is a product
    question, not something to paper over with a canonical answer.
State which you found before proposing anything for these 33 items.

PART 2 -- CANONICAL ANSWERS for the 33 items (if Part 1 concludes they're genuine, keep-published
content)

Same discipline as Biology's work order F: for each FRQ, author a full_text answer plus
criterion-exclusive spans (concatenation verified to equal full_text exactly, every frq_criteria
criterion covered by exactly one exclusive span, no content deleted from anything currently published
-- these 33 currently have a blank canonical_answer_1 so there is nothing to preserve, this is a
pure addition). Output as a proposal JSONL/CSV, matching the shape of
docs/research/apbio_drafted_criteria_2026_09_23/canonical_proposal.jsonl (read that file for the
exact shape).

PART 3 -- SERVING LABEL REFRESH for the 82 non-validated items (43 legacy_unvalidated + 16 held + 14
provisional_model + 9 stale)

Same two-model lane as Biology's FF-3 work and the Physics-C-Mech/Calc-BC order sent the same day
(prompts/CODEX_WORK_ORDER_PHYSICS_C_MECH_AND_CALC_BC_RELABEL_2026_09_24.md has the exact method --
follow it, adapted to Calc AB). Two independently-architected models, agreement -> provisional_model
proposal ready for promotion, disagreement -> reported as disagreement, no adjudication. Multi-unit
agreements get no special promotion path (report them, don't imply promotable). Held items specifically:
read why each was held before re-running it blind -- a held status usually means QA found something,
and a fresh label doesn't fix an underlying content problem if that's what caused the hold.

PART 4 -- DIFFICULTY (reuse DECISION-0065's method exactly)

Compute the same categorical-band-plus-attainment-ratio proposal Biology's J.0 resume produced, for
all 124 Calc AB items. Use the same CRR verb-verification approach and subject-mean normalization
(docs/research/apbio_difficulty_calibration_2026_09_22/README.md section 2 has the subject means table
-- Calc AB's own mean should already be in there since it was one of the cross-subject sources J.0
normalized against). Report using the same output shape as
docs/research/difficulty_reconciliation_2026_09_23/attainment_ratio_proposal.csv.

PART 5 -- GRADER-GATE SANITY CHECK (small, not exhaustive)

Pick 3 of the 29 FRQ that already have a canonical_answer_1 today and run app.qa_grade_frq against
each 3 times (same multi-run discipline as Biology's M5 baseline -- a single run is not evidence).
Report status/confidence/integrity per run. This is a sanity check that existing Calc AB canonicals
actually clear the DECISION-0052 bar, not an assumption that "has a canonical" means "grades correctly."

DELIVERABLE

`docs/product/AP_CALCULUS_AB_LAUNCH_READINESS_2026_09_24.md`, structured against the six criteria in
SUBJECT_SERVABILITY_CRITERIA.md (not the Biology doc's original six-condition list, which predates
that shared doc and is phrased slightly differently) -- one section per criterion, current state,
what's proposed, what's still open.

WHAT WOULD MAKE THIS REJECTED AT QA

- Any Production write.
- Authoring canonical answers for the u13/np2 batches without first checking whether that content is
  genuine or should be unpublished instead.
- Treating canonical_answer_1 and canonical_answer_spans coverage as the same fact.
- Promoting anything to validated yourself, or implying a multi-unit agreement is promotable.
- A single grader-gate run reported as reliable evidence.
- Re-running a held item's label without reading why it was held first.
```
