# TASK-0046-STATISTICS — AP Statistics Six-Criteria Unit-Gated Verification

**Parent:** TASK-0046
**Product Owner:** David Bloom
**Tier:** Standard
**Status:** Ready for Review
**Execution Date:** 2026-09-28
**Approval:** APPROVAL-0057 (recorded in PR #237)
**Branch:** `chatgpt/task-0046-statistics`
**Production Project:** `pcntajvbdfqhbeewmdry`
**Exam Pack Version:** `548f06be-ccf4-426d-b82b-b424137a4438`

## Live Result

**Recommended verdict: Pass, pending fresh independent QA.**

1. **Reviewed / approved:** 170 current-published items on the active pack (69 FRQ, 101 MCQ/quantitative). 23 item-level-published records whose latest version is not published are excluded from the current serving population.
2. **Rubric / choices:** 0 current FRQ missing canonical; 0 rubric defects; 0 MCQ choice defects.
3. **Serving label:** 67 current-fresh validated items relevant to the TASK-0042 reconciliation; the exact unit-gated eligible pool at the highest released unit is **48**.
4. **Canonical answer:** See criterion 2 note above; MCQ correctness is unambiguous via exactly one correct choice.
5. **Difficulty:** 170/170 current-published items have a populated difficulty band and non-empty basis.
6. **Exam pack version:** exactly 1 `published`, non-retired version for this subject: `548f06be-ccf4-426d-b82b-b424137a4438`.

## Real RPC Evidence

- `select_unit_gated_practice_items` at unit 5: **48** rows, exactly matching the standing census.
- `select_practice_frqs`: targeted drill **49** rows; full-exam FRQ **0**.
- `app.servable_items_census_selftest()`: no mismatch on the active pack/unit probes. Historical/retired Statistics pack rows may also appear in the global self-test but are not the active routed pack and are not used for this verdict.

No model-call-based verification was used in this slice, so the 3-run model-repeat rule is not applicable.

## Acceptance / Handoff

- [x] Criterion 6 checked first/live and singular.
- [x] Criteria 1, 2, and 4 checked against the active Production pack/version.
- [x] Criteria 3 and 5 checked live after TASK-0042 was confirmed Done.
- [x] Actual serving RPCs called directly against Production.
- [ ] Shared `SUBJECT_SERVABILITY_CRITERIA.md` row updated after independent QA accepts this slice.
- [ ] `APP_LAUNCH_READINESS_INDEX_2026_09_26.md` updated after independent QA accepts this slice.
- [ ] Fresh independent QA context returns Pass.
- [ ] Main Conductor closes slice.
