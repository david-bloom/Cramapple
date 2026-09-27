# Codex QA Prompt — AP Calculus AB Canonical-Answer Work (Claude, 2026-09-25)

**Context.** Claude directly authored and applied canonical answers for the 33 AP Calculus AB FRQ
items that had a blank `canonical_answer_1` (`apcalcab-frq-024/025/026`, `apcalcab-frq-np2-001..010`,
`apcalcab-frq-u13-001..020`), plus fixed an unrelated live grading bug found en route. Full account in
`docs/product/AP_CALCULUS_AB_LAUNCH_READINESS_2026_09_25.md`. This is a QA pass on that work, not new
authoring — do not extend scope into criteria 3 (labels) or 5 (difficulty), those are separate,
not-yet-run work orders.

Paste the block below into Codex.

```text
QA pass — AP Calculus AB canonical-answer authoring (Claude, 2026-09-25).

Merge main first:

    git fetch origin
    git switch codex/qa-apcalcab-canonicals-2026-09-25
    # If that branch does not exist instead run:
    # git switch -c codex/qa-apcalcab-canonicals-2026-09-25 origin/main
    git merge origin/main

The checkout must be clean before starting. This is a QA pass against Production
(pcntajvbdfqhbeewmdry) -- read-only SQL, report findings as a doc, no writes.

READ FIRST:
- docs/product/AP_CALCULUS_AB_LAUNCH_READINESS_2026_09_25.md (what was done and the claimed
  verification)
- supabase/migrations/20260925000000_apcalcab_dedupe_frq_criteria.sql (the grading-bug fix)
- supabase/migrations/20260925010000_apcalcab_canonical_answers_33_items.sql (11 of the 33 items --
  the other 22 were applied via 5 follow-on batches from the same generation run, not committed as
  separate files; query Production directly for the full set rather than looking for more migration
  files)

WHAT TO VERIFY

1. **Mathematical correctness, independently re-derived.** For all 33 items, read the stem/stimulus
   and frq_criteria directly from Production, then independently work each problem from first
   principles -- do not just check that canonical_answer_1 is "plausible" or matches the rubric's
   learner_facing_text (that would just confirm self-consistency, not correctness; the rubric text
   itself could in principle be wrong, the way one Biology rubric was found to be wrong earlier this
   week). Flag any canonical answer whose final value or reasoning does not match your own
   independent derivation.

2. **Span integrity**, for all 33 items:
   - Span concatenation equals canonical_answer_1 exactly (byte-for-byte, not approximately).
   - Every frq_criteria criterion_key for the item is covered by exactly one span's criterion_keys
     array -- no criterion missing, none appearing in two different spans, none extra.
   - assembly_literal spans have an empty criterion_keys array.
   This should already be guaranteed by an in-transaction check the migrations ran, but re-verify
   independently against current Production state rather than trusting that the migration's own
   check is still true (schema or data could have changed since).

3. **The grading-bug fix** (apcalcab-frq-np2-008, apcalcab-frq-u13-002, apcalcab-frq-u13-006,
   apcalcab-frq-u13-018): confirm each of these 4 items now has exactly one frq_criteria row per
   criterion_key (not two), and that no other Calc AB FRQ item has the same duplication pattern that
   was missed.

4. **No collateral damage.** Confirm no other Calc AB item's canonical_answer_1,
   canonical_answer_spans, or frq_criteria rows were modified by these migrations beyond the intended
   33 (canonicals) and 4 (dedupe) items.

5. **Grader-gate spot check.** Pick 5 of the 33 newly-canonicaled items (spread across easy
   mechanical-derivative items and harder multi-part FRQ) and run app.qa_grade_frq against each
   3 times minimum (same discipline as Biology's M5 baseline -- a single run is not evidence). Report
   status/confidence/integrity per run, and flag any item where the 3 runs disagree.

DELIVERABLE

`docs/product/AP_CALCULUS_AB_CANONICAL_QA_2026_09_25.md`: one row per item (33 rows) with your
independent re-derivation verdict (confirmed / disputed, with your own worked answer if disputed), the
span-integrity check result, and the grading-bug re-verification. Plus the grader-gate spot-check
results as their own section.

WHAT WOULD MAKE THIS REJECTED

- Confirming correctness by comparing against the rubric's learner_facing_text instead of an
  independent derivation.
- Reporting span-integrity as "already verified by the migration" without re-running the check
  yourself against current Production state.
- Scope creep into criteria 3 or 5 -- this QA pass is criterion-4 only.
- A single grader-gate run per item reported as sufficient.
```
