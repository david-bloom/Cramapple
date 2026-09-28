# TASK-0046-BIOLOGY — AP Biology Six-Criteria Unit-Gated Verification

**Parent:** TASK-0046
**Product Owner:** David Bloom
**Tier:** Standard
**Status:** Ready for Review
**Execution Date:** 2026-09-28
**Approval:** APPROVAL-0057 (recorded in PR #237)
**Branch:** `chatgpt/task-0046-biology`
**Production Project:** `pcntajvbdfqhbeewmdry`
**Exam Pack Version:** `2d88ba5e-a6a3-43b8-bfae-9e5505a178a7`

## Live Result

**Recommended verdict: Pass, pending fresh independent QA.**

1. **Reviewed / approved:** 118 current-published items on the active pack (75 FRQ, 43 MCQ/quantitative). 42 item-level-published records whose latest version is not published are excluded from the current serving population.
2. **Rubric / choices:** Four current-published FRQ lack canonical text, but all four are hand-drawn graph items and are structurally excluded from the ordinary/unit-gated serving selectors; among the actual servable population there is no canonical/rubric defect.
3. **Serving label:** 23 current-fresh validated items relevant to the TASK-0042 reconciliation; the exact unit-gated eligible pool at the highest released unit is **23**.
4. **Canonical answer:** See criterion 2 note above; MCQ correctness is unambiguous via exactly one correct choice.
5. **Difficulty:** 118/118 current-published items have a populated difficulty band and non-empty basis.
6. **Exam pack version:** exactly 1 `published`, non-retired version for this subject: `2d88ba5e-a6a3-43b8-bfae-9e5505a178a7`.

## Real RPC Evidence

- `select_unit_gated_practice_items` at unit 8: **23** rows, exactly matching the standing census.
- `select_practice_frqs`: targeted drill **50** rows (selector cap; census is higher where noted in the standing self-test); full-exam FRQ **0**.
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
