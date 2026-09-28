# TASK-0046-PHYSICS-C-MECHANICS — AP Physics C: Mechanics Six-Criteria Unit-Gated Verification

**Parent:** TASK-0046
**Product Owner:** David Bloom
**Tier:** Standard
**Status:** Ready for Review
**Execution Date:** 2026-09-28
**Approval:** APPROVAL-0057 (recorded in PR #237)
**Branch:** `chatgpt/task-0046-physics-c-mechanics`
**Production Project:** `pcntajvbdfqhbeewmdry`
**Exam Pack Version:** `ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9`

## Live Result

**Recommended verdict: Pass, pending fresh independent QA.**

1. Reviewed/approved: 77 current-published items (36 FRQ, 41 MCQ/quantitative); 7 item-level-published records with non-published latest versions are excluded from the serving population.
2. Rubric/choices: 0 current FRQ missing a valid rubric; 0 current MCQ/quantitative items with anything other than exactly one correct choice.
3. Serving label: 50 current-fresh validated items. Unit-gated probes across units 1–7 had no mismatches; the top-unit call hits the selector's 50-row cap and the census exact pool is 50.
4. Canonical answer: 0 current FRQ missing `canonical_answer_1`; MCQ correctness is unambiguous via criterion 2.
5. Difficulty: 77/77 current-published items have a populated difficulty band and non-empty basis.
6. Exam pack version: exactly one published, non-retired version, `ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9`.

## Real RPC Evidence

- `select_unit_gated_practice_items` at unit 7 returned 50; census exact eligible pool = 50.
- `select_practice_frqs`: targeted drill 33; full-exam FRQ 3.
- `app.servable_items_census_selftest()`: no mismatch for this subject; cap-bound rows are explicitly skipped rather than falsely certified.

No model-call-based verification was used, so the 3-run model-repeat rule is not applicable.

## Handoff

- [x] Criteria 1–6 verified live on Production.
- [x] Real serving RPCs called; cap behavior diagnosed.
- [ ] Shared servability/readiness docs updated after independent QA accepts this slice.
- [ ] Fresh independent QA context returns Pass.
- [ ] Main Conductor closes slice.
