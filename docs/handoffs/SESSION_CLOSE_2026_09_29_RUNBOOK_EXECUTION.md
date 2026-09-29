# Session Close — 2026-09-29 (runbook execution session)

**Session:** executed `RESOLUTION_RUNBOOK_2026_09_29.md` Steps 1–3 (Claude Code, cloud).
**Next owner:** David Bloom.
**Single best next action:** merge PR #277 (QA report, TASK-0051 Blocked) and PR #278 (TASK-0056 +
DECISION-0089). Then approve TASK-0056 step 2.

## 1. Tasks in scope

- Runbook Step 1 (PR #272), Step 2 (smoke test), Step 3 (TASK-0051 Open Hand backend).
- One unplanned Production hotfix (APPROVAL-0062).
- Independent QA of TASK-0051 (child session). It found F1, now **TASK-0056**.

## 2. What changed

| Change | Where | Record |
|---|---|---|
| PR #272 merged (skill dimension + five recovered migrations) | `main` `13bb2ba` | runbook Step 1 |
| **Production grading hotfix:** `evaluate-attempt` v67 read `app.open_hand_scoring_exclusions`, which existed only in Dev, so every graded Production answer would have returned 500. Created the table only (no RPC) in Dev and Prod, with the same ledger version `20260929130754` on both. | PR #275 | APPROVAL-0062; TASK-0051 § Production hotfix |
| `scripts/open_hand_e2e_dev.mjs`, a Dev-only TASK-0051 end-to-end check | PR #275 | TASK-0051 § Live Development end-to-end |
| `scripts/student_grade_smoke.mjs` fixed: five calls didn't match the deployed code, plus a `check()` bug that printed a false pass | PR #270 | runbook Step 2 |
| Runbook Step 2 records the passing Dev run | PR #276 | runbook Step 2 |
| Cloud environment: network allow-list for the Dev Supabase host; API credential (Dev secret key, `apikey` header) | environment settings (David) | this file |

The only Production write was the APPROVAL-0062 table creation. No Production deploys.

## 3. Verified

- PR #272's five migrations are byte-identical to Production's ledger. The fifth is the recorded SQL plus a comment-only header.
- Hotfix parity, Dev vs Prod: columns, constraints, indexes, forced RLS and grants all match. Production has **no** `get_open_hand_item`.
- **TASK-0051 Dev end-to-end: 16/16.** A student read a key directly through PostgREST, which wrote one exclusion. Grading refused that item with 409; a never-viewed item graded normally (200). Dev function logs confirm both.
- **Smoke test on Dev: ALL CHECKS PASSED.** This is the first signup-to-graded-wrong-answer run on a deployed environment. The chosen distractor's authored rationale reached the student.
- Dev and Prod have zero `smoke+` test users at close.

## 4. Open

- **TASK-0056 (F1, launch-gating per DECISION-0089):** any signed-in student can read `content_item_versions.canonical_answer_1/2`, `explanation` and `item_package_payload` for every published item. That comes from the column grants plus RLS policy `content_item_versions_select_published`, re-verified on Production at 19:25 UTC. Sits in PR #278, unmerged.
- **TASK-0051 Blocked** by TASK-0056 (PR #277). QA also found:
  - **F2:** `.maybeSingle()` on exclusions returns 500 once a student has viewed two versions of one item; the fix is `.limit(1)`.
  - **F3:** Dev still runs the superseded `open-hand-item` v9.
  - Still to do: independent QA re-run, the Production gate.
- **Production smoke test:** not run (called off at 19:10; no student record created). It is still David's, immediately before test students.
- **The live app calls `get_graded_choice_feedback`, which exists nowhere** (Prod, Dev, repo), so it 404s after every graded MCQ. Seen in Production logs 2026-09-27. This is Lovable-side.
- **TASK-0055 ledger drift** now runs both ways: 72+ migrations are Prod-only, and Dev lacks PR #272's five. The header of `20260929034129` wrongly says a plain `db push` will apply it.

## 5. Risks

- F1 is live in Production today, independent of Open Hand. It matters as soon as real students sign in.
- `supabase db push` remains unsafe (TASK-0055).
- The QA child session (`session_01P1EvXnsyGqUNF79DVvXmBJ`) is idle on TASK-0056 step 2, waiting for David's approval of a reviewer function (Dev) and a Lovable edit. It is acting as TASK-0056's implementer. Treat any further QA of TASK-0051 as needing a *new*, fresh context.

## 6. Commands and queries (results)

- Prod/Dev ledger and MD5 comparisons: matched (see §3).
- Prod logs 2026-09-27 18:29–18:30: the app submits via `attempt-response` `submit_response`. Production has no `submit-response` function.
- `node scripts/open_hand_e2e_dev.mjs` (David, Mac): 16/16.
- `node scripts/student_grade_smoke.mjs` against Dev (David, Mac): all passed. Test user deleted by SQL afterwards.

## 7. Approval state

- APPROVAL-0062 (hotfix): used and complete.
- APPROVAL-0061 (TASK-0051, Dev scope): still in force. The Production gate is not approved.
- DECISION-0089 (in PR #278) records direction only. TASK-0056's Dev migration and Prod apply each need their own approval.

## 8. Next session: exact next step

1. David merges PR #277 and PR #278.
2. David approves TASK-0056 step 2, then the step 3 migration: Dev first, then a separate approval for Prod.
3. Fold F2 (`.limit(1)`) into TASK-0056 step 6, then run a **fresh** independent QA of TASK-0051 + TASK-0056.
4. Only then, the TASK-0051 Production gate (migration `20260929034129` by direct apply plus version rename; see runbook Trap 1).

## 9. Do not touch

- Do not apply `20260929034129` (the answer-key RPC) to Production before TASK-0056 lands and QA passes.
- Do not run `supabase db push` (TASK-0055).
- Do not run the smoke test against Production except at David's direction; it leaves a real student record.
- Do not `source .secrets.env`.
