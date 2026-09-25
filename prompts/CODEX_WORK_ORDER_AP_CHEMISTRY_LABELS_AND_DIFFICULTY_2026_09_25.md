# Codex Work Order — AP Chemistry Serving Labels and Difficulty

**Context.** AP Chemistry's criteria 1, 2, 4, and 6 (per `docs/product/SUBJECT_SERVABILITY_CRITERIA.md`)
are already clean — see `docs/product/AP_CHEMISTRY_LAUNCH_READINESS_2026_09_25.md` for the full
measurement. This order covers only the two remaining criteria: 3 (serving labels) and 5 (difficulty).
Proposal only — no Production writes, no PR, no merge to main.

Paste the block below into Codex.

```text
Work order — AP Chemistry servability gaps: serving labels and difficulty.

Merge main first:

    git fetch origin
    git switch codex/apchem-labels-difficulty-2026-09-25
    # If that branch does not exist instead run:
    # git switch -c codex/apchem-labels-difficulty-2026-09-25 origin/main
    git merge origin/main

The checkout must be clean before starting. Commit and push to
codex/apchem-labels-difficulty-2026-09-25 as you go. Production project ref: pcntajvbdfqhbeewmdry.
Read-only SQL against Production for measurement; everything you produce is a proposal artifact
(CSV/JSONL/SQL migration file), not an applied write.

READ FIRST:
- docs/product/SUBJECT_SERVABILITY_CRITERIA.md (the six criteria and how to measure them)
- docs/product/AP_CHEMISTRY_LAUNCH_READINESS_2026_09_25.md (current measured state -- criteria 1, 2,
  4, 6 are already closed, this order is criteria 3 and 5 only)
- prompts/CODEX_WORK_ORDER_AP_CALCULUS_AB_LAUNCH_READINESS_2026_09_24.md's Part 3 and Part 4 (the
  exact method for both -- follow it, adapted to Chemistry)
- docs/research/difficulty_reconciliation_2026_09_23/SUMMARY.md and
  docs/activity_log/DECISIONS_LOG.md's DECISION-0065 (the approved attainment-ratio method for
  difficulty -- reuse it exactly, don't invent a new one)

ALREADY MEASURED (verified directly against Production -- confirm as your first step, should not
need rediscovering):

  123 published items, single exam_pack_version (c9ca46b2-b529-4ed3-9741-dddea455ab9b), 53 FRQ / 70 MCQ.
  Serving labels (label_scope='serving', current/non-superseded row per item): 45 validated, 32 held,
    31 stale, 24 legacy_unvalidated, 2 provisional_model. 78 non-validated.
  Difficulty: 0 of 123 items have any app.content_item_difficulty row.

PART 1 -- SERVING LABEL REFRESH for the 78 non-validated items

Same two-model lane as Biology's FF-3 work and Calc AB's Part 3: two independently-architected models,
agreement -> provisional_model proposal ready for promotion, disagreement -> reported as disagreement,
no adjudication. Held items specifically (32 of them): read why each was held before re-running it
blind -- a held status usually means QA found something, and a fresh label doesn't fix an underlying
content problem if that's what caused the hold.

PART 2 -- DIFFICULTY (reuse DECISION-0065's method exactly)

Compute the same categorical-band-plus-attainment-ratio proposal for all 123 Chemistry items. Use the
same CRR verb-verification approach and subject-mean normalization
(docs/research/apbio_difficulty_calibration_2026_09_22/README.md section 2 has the subject means
table -- check whether Chemistry is already in it; if not, say so explicitly and propose a
normalization approach rather than fabricating a mean). Report using the same output shape as
docs/research/difficulty_reconciliation_2026_09_23/attainment_ratio_proposal.csv.

PART 3 -- GRADER-GATE SANITY CHECK (small, not exhaustive)

Pick 3 of the 53 FRQ that already have a canonical_answer_1 and run app.qa_grade_frq against each 3
times (same multi-run discipline as Biology's M5 baseline). Report status/confidence/integrity per
run.

DELIVERABLE

Update `docs/product/AP_CHEMISTRY_LAUNCH_READINESS_2026_09_25.md` in place: fill in the "Criterion 3"
and "Criterion 5" sections with what's proposed and what's still open, keep the rest of the doc as-is.

WHAT WOULD MAKE THIS REJECTED AT QA

- Any Production write.
- Promoting anything to validated yourself, or implying a multi-unit agreement is promotable.
- A single grader-gate run reported as reliable evidence.
- Re-running a held item's label without reading why it was held first.
- Fabricating a subject-mean normalization value for difficulty instead of flagging it as missing.
```
