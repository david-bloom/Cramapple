# TASK-0046-PHYSICS-2 — AP Physics 2 Six-Criteria Unit-Gated Verification

**Parent:** TASK-0046
**Product Owner:** David Bloom
**Tier:** Standard
**Status:** Ready for Review
**Execution Date:** 2026-09-28
**Approval:** APPROVAL-0057 (recorded in PR #237)
**Branch:** `chatgpt/task-0046-physics-2`
**Production Project:** `pcntajvbdfqhbeewmdry`
**Exam Pack Version:** `f584ab0d-114a-4520-9649-42e3e9a2fd22`

## Scope

Read-only Production verification of the six fixed criteria in `SUBJECT_SERVABILITY_CRITERIA.md`. No Production mutation was performed.

## Live Result

**Recommended verdict: Pass, pending fresh independent QA.**

1. **Reviewed / approved:** 68 current-published items on the active pack (28 FRQ, 40 MCQ/quantitative). 11 item-level-published records whose latest version is not published are excluded from the current serving population rather than counted as ready.
2. **Rubric / choices:** 0 current FRQ missing a valid rubric; 0 current MCQ/quantitative items with anything other than exactly one correct choice.
3. **Serving label:** 50 current-fresh validated items in the exact unit-gated census. Live unit-gated probes across units 9–15 matched the mirrored selector predicates wherever uncapped; no mismatches were observed.
4. **Canonical answer:** 0 current FRQ missing `canonical_answer_1`; MCQ correctness is unambiguous via criterion 2.
5. **Difficulty:** 68/68 current-published items have a populated difficulty band and non-empty basis.
6. **Exam pack version:** exactly 1 `published`, non-retired version for this subject: `f584ab0d-114a-4520-9649-42e3e9a2fd22`.

## Real RPC Evidence

- `select_unit_gated_practice_items` at the highest released unit returned 50 (cap boundary; census exact pool 50). The standing census reports an exact eligible pool of **50**.
- `select_practice_frqs`: targeted 25; full-exam 3.
- `app.servable_items_census_selftest()`: no mismatch for this subject. Rows at or above 50 are explicitly reported as capped/skipped rather than falsely treated as exact selector equality.

No model-call-based verification was used in this slice, so the 3-run model-repeat rule is not applicable.

## Acceptance / Handoff

- [x] Criterion 6 checked first/live and singular.
- [x] Criteria 1, 2, and 4 checked against the active Production pack/version.
- [x] Criteria 3 and 5 checked live after TASK-0042 was confirmed Done.
- [x] Actual serving RPCs called directly against Production; cap behavior diagnosed where relevant.
- [ ] Shared `SUBJECT_SERVABILITY_CRITERIA.md` row updated after independent QA accepts this slice.
- [ ] `APP_LAUNCH_READINESS_INDEX_2026_09_26.md` updated after independent QA accepts this slice.
- [ ] Fresh independent QA context returns Pass.
- [ ] Main Conductor closes slice.

## QA Instruction

In a fresh context, independently rerun criterion 6, the defect-count audit for criteria 1/2/4/5, and the unit-gated selector/self-test for this subject. If the evidence matches, recommend Pass and allow the conductor to update the two shared status documents and close the slice.
