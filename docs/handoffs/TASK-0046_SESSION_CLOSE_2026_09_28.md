# Cramapple Session Close — TASK-0046 / TASK-0049 — 2026-09-28

## 1. Current task or issue

Primary session task: `TASK-0046` — full six-criterion subject onboarding verification.  
New follow-up created this session: `TASK-0049` — close remaining six-criterion gaps for AP Biology and AP Statistics.

## 2. What changed this session

- Confirmed canonical `TASK-0042` is Done (2026-09-27) and that its criteria-3/5 pipeline work is complete.
- David explicitly authorized TASK-0046 execution and set subject order.
- Ran live Production six-criterion verification for all 10 AP subjects.
- Created per-subject TASK-0046 verification branches/PRs for the eight non-Day-1 subjects plus AP Statistics and AP Biology.
- **Created `TASK-0049-BIOLOGY-STATISTICS-SIX-CRITERION-REMEDIATION.md` because no dedicated remediation task already existed.** TASK-0049 is Hard-Gate and owns closing Biology/Statistics gaps after TASK-0046 verification.
- No Production mutations were made by this session.

## 3. What was verified

Production project: `pcntajvbdfqhbeewmdry`.

All 10 subjects were checked against:
- active published/non-retired exam-pack singularity;
- current-published item/version state;
- FRQ rubric presence;
- MCQ exactly-one-correct-choice condition;
- canonical-answer coverage;
- difficulty rows with populated band+basis;
- real `select_unit_gated_practice_items` / `select_practice_frqs` calls;
- `app.servable_items_census()` and `app.servable_items_census_selftest()`.

Eight non-Day-1 subjects all support Pass recommendations pending independent QA.

AP Statistics:
- active pack `548f06be-ccf4-426d-b82b-b424137a4438`;
- 170 current-published items;
- 67/170 current-fresh validated serving labels;
- 170/170 difficulty complete;
- 69/69 FRQ canonical/rubric complete;
- 101/101 MCQ have exactly one correct choice;
- exact unit-gated pool at unit 5 = 48.

AP Biology:
- active pack `2d88ba5e-a6a3-43b8-bfae-9e5505a178a7`;
- 118 current-published items;
- 23/118 current-fresh validated serving labels;
- 118/118 difficulty complete;
- four current-published hand-drawn FRQs lack `canonical_answer_1`:
  `APBIO-HDG-2026-GRAPH-002`, `003`, `008`, `010`;
- those four are structurally excluded from the ordinary/unit-gated selectors today;
- exact unit-gated pool at unit 8 = 23.

## 4. What remains open

- Every TASK-0046 slice requires fresh independent QA before Done.
- Shared `SUBJECT_SERVABILITY_CRITERIA.md` and `APP_LAUNCH_READINESS_INDEX_2026_09_26.md` should be reconciled only after independent QA accepts the slices.
- TASK-0049 remains Not Started and unapproved for Production writes.
- TASK-0049 requires separate Biology and Statistics implementation slices.

## 5. Open blockers or risks

- TASK-0049 is Hard-Gate. Any Production label/canonical write requires explicit Product Owner approval per subject/batch.
- Biology has 95 current-published items without a current-fresh validated serving label; Statistics has 103.
- Biology's four hand-drawn canonical gaps need an explicit policy choice: remediate for future serving or formally exclude/retire and document the exclusion.
- Concurrent work exists: Claude opened PR #248 (`claude/cramapple-task-0046-gmbf9u`) covering TASK-0046 while this session's PRs are also open. Do not merge overlapping TASK-0046 documentation blindly; reconcile evidence/branch scope first.

## 6. Files changed or checked

Created on `chatgpt/task-0049-bio-stats-six-criterion-remediation`:
- `docs/tasks/TASK-0049-BIOLOGY-STATISTICS-SIX-CRITERION-REMEDIATION.md`
- this handoff file.

Checked:
- `docs/team_charter/CRAMAPPLE_SESSION_START.md`
- `prompts/CLOSE_SESSION_PROMPT.md`
- `docs/tasks/TASK-0042-LAUNCH-CONTENT-PIPELINE.md`
- `docs/tasks/TASK-0044-LAUNCH-SUBJECT-ONBOARDING-GATE.md`
- `docs/tasks/TASK-0046-SUBJECT-ONBOARDING-GATE-FULL-PROGRAM.md`
- `docs/product/SUBJECT_SERVABILITY_CRITERIA.md`
- `docs/product/APP_LAUNCH_READINESS_INDEX_2026_09_26.md`
- relevant governance/approval records.

## 7. Commands, queries, or tests run

Read-only Production SQL via Supabase MCP:
- active-pack singularity and current-published defect audit;
- exact fresh validated serving-label counts;
- difficulty completeness;
- Biology missing-canonical identification;
- `app.servable_items_census()`;
- `app.servable_items_census_selftest()`;
- direct `public.select_unit_gated_practice_items` and `public.select_practice_frqs` calls.

Results: no census/RPC mismatches on active subject packs; selector caps were recorded as caps rather than exact pool sizes.

## 8. Approval state

- TASK-0046 execution was explicitly authorized by David in-session; recording PR #237 remains open.
- TASK-0046 slice Done decisions are still pending fresh independent QA/Main Conductor integration.
- TASK-0049: task documentation only. Production implementation approval is **Pending**; Hard-Gate applies.

## 9. Exact next step

**Next owner:** fresh independent QA agent/Main Conductor.

**Next action:** reconcile PR #248 against TASK-0046 PRs #237–247, independently rerun the subject evidence, choose the non-duplicative integration path, then update shared readiness docs and close accepted TASK-0046 slices. After TASK-0046 integration, David can approve TASK-0049-BIOLOGY or TASK-0049-STATISTICS as the first remediation slice.

## 10. Do not touch next session

- Do not perform TASK-0049 Production writes without explicit recorded Product Owner approval for the specific subject/batch.
- Do not weaken `DECISION-0066` independent review for multi-unit labels.
- Do not treat the four Biology hand-drawn missing canonicals as ordinary serving defects without checking their approved hand-drawn grading/serving policy.
- Do not merge both PR #248 and overlapping TASK-0046 per-subject PRs without reconciliation.

## Restart note

Start with independent TASK-0046 QA/reconciliation, not new Production remediation.
