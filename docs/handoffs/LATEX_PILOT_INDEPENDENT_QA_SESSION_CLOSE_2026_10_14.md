# LaTeX pilot independent QA — session close, 2026-10-14

STATUS: CURRENT closeout; the two QA verdicts below are HISTORICAL checkpoints
TASK: TASK-0073
OWNER OF THIS QA: Codex
CANONICAL TASK: ../tasks/TASK-0073-LATEX-PROSE-PILOT.md
DOCUMENTATION BRANCH: codex/task-0073-latex-qa-close

## 1. Current task and scope

This session performed two independent, read-only QA sweeps for TASK-0073. The initial review covered 33 drafted notation edits; the recheck covered a narrower 21-row MCQ slice. The full reports contain published exam text and Production evidence and must not be placed in this public repository.

**Current state at close, from main's TASK-0073:** Phase 1's 21 MCQ rows have subsequently been applied and verified by the author; the statement-timeout and choice/version safeguards identified by the second sweep were fixed first. App PR #23 is confirmed merged (merge commit 8567bf48508f9bfd4776eb93927a3e31acedf8c2). The task record reports it published and the student view confirmed from Product Owner screenshots. Phase 2's ten rubric edits were dropped under DECISION-0122 after TASK-0074; three explanation edits were dropped. The next independent work item is TASK-0075, waiting on Product Owner scope/notation rulings.

Do not reuse the earlier “do not write” verdict as a claim that the later corrected release is still blocked. Do not infer that this QA session itself executed or independently recertified that later release.

## 2. What changed in this session

- Reviewed the full pilot, then the revised MCQ transaction, against the named QA prompts.
- Identified a missing active provisional taxonomy label in the first capture logic, raw-maths exposure on staff/grading surfaces, an omitted whole-field quotient, and explanation edits without a student consumer.
- In the recheck, verified the corrected label restoration and narrower scope; identified statement-timeout placement and the missing choice-to-version predicate.
- Recorded the results and preserved a sanitized durable handoff, task pointer, and index correction. No implementation or policy change was made by this session.

## 3. What was verified

### First sweep — historical recommendation: do not write the reviewed transaction

All 33 transformations preserved the mathematics on independent inspection. All 33 before-texts matched Production by direct equality and md5. The review table and SQL assignments matched. The sample covered 120 published field records, 40 per pilot subject, across stems, explanations, choices, rationales and criteria.

The batch affected 19 versions of 19 items. There were 17 validated and two provisional active labels; 18 stored hashes matched and one was NULL. SELECT-only reconstruction of the proposed final taxonomy hashes predicted 17 label flips, including one omitted from the original snapshot. The SQL's stale-count guard would abort rather than silently commit that lost label.

The named dependent check/span/comparison/synthetic stores were empty for affected versions, and item-package payloads were NULL. Equivalent older strings remained in prompt_json for four affected versions. The grader consumed rubric text; staff pages printed it bare. The preview harness routes returned 404 because they are development-only. Browser policy blocked opening the local static HTML, so no visual certification was claimed.

### Second sweep — historical recommendation: do not write those reviewed files yet

The 21 before-texts still matched Production. Twenty transformations were identical to the first passed set; the added whole-field quotient was mathematically equivalent. The transaction capture predicate now covered every active validated/provisional label the child trigger could flip, regardless of the original stored hash. Status/provenance restoration and conditional hash re-attestation were correct.

SELECT-only reconstruction matched the author's reported expectations: 21 edits, 11 versions of 11 items, 11 captured/restored active validated labels, all 11 in sync, zero hashes kept as mismatches, zero stale labels and zero snapshot-status changes expected. All ten deferred criterion rows were on different items.

Dry and real SQL were identical before their final diagnostic statements. All guard exceptions propagated; neither file had a partial-commit path. Concurrency concerns remained around child ownership and timeout placement. MCQ grading made no model call and the ordinary question UI submitted keys, but the grader retained a legacy choice-text exact-match fallback.

The current published bootstrap and question module were inspected directly. ProseMath's parser, display class and choice/rationale wiring existed in the deployed build, not merely source. At that review checkpoint PR #23 was still a draft. It is now merged; publication is recorded in the canonical task.

## 4. What remains open

The canonical task still lacks received reviewer/admin screenshots. Its student screenshots are owner-provided evidence. There was no third QA sweep of the author's later corrected SQL or Production write in this session.

TASK-0075 remains an inventory/drafting follow-up pending the owner's scope and notation rulings. The dropped rubric phase must not be reopened without verified grading mitigation and appropriate approval.

## 5. Blockers and risks

Historical QA blockers were real findings at their reviewed artifact revisions; the later task record says the MCQ write safeguards and staff release were completed. The first two reports must be labeled historical if archived.

The full-report GitHub upload was rejected by automatic approval review because it contains private exam text/Production evidence and the closeout request did not explicitly authorize that export. The sanitized record here preserves the findings without that payload. Full reports remain local and have already been linked in the chat; explicit authorization is needed before uploading them to a private archive branch.

## 6. Files checked and documented

Reviewed in the private ap-prep-blueprint repository, then on branch qa/latex-prose-pilot:
- QA_PROMPT_latex_pilot.md; REVIEW_latex_prose_pilot.md; apply_dry.sql; latex_prose_preview.html.
- RECHECK_PROMPT_phase1.md; REVIEW_phase1_mcq_slice.md; apply_phase1_dry.sql; apply_phase1_real.sql.

Inspected relevant prose renderer, question normalization/worked-example mapping, reviewer/manual-grading paths, BYOQ and legacy routing, plus live evaluate-attempt source and database functions/triggers.

Reviewed artifact fingerprints (identify historical revisions; they are not a claim about the later corrected versions):
- First prompt aee6ecd92af8bfdbe18a2aa308d8ad191460ce37; review 36b3123d78e08e7cac8162441ff7346971dd42fd; SQL 4e143d216b1406e0011f176ef9f97e5d8d0e1b9a.
- Recheck prompt 573e2eca2244dc262875af2e10349255f0997c58; review f754473d7e6045e078d81a03a1f231a789c60c2a; dry SQL debdef26c8158fca79b772c52ec91307ca2164b0; real SQL 291e87bddba03edd9b5cc0a611f9454935f7d6e8.

## 7. Commands, queries and tests

All Production queries were SELECT-only on the project named by the review prompt. Checks included exact before-text/md5 comparisons, pg_get_functiondef/pg_get_triggerdef, schema/constraint/index inspection, affected-version/label joins, hypothetical final-hash reconstruction, deferred-row overlap, dependent-copy counts and targeted prompt_json inspection.

The published question module contained the prose-math parser/wiring; its inspected SHA-256 was aec28bbd0df7e2e1a8832c07fa7286a5aed1dd861fbb972b57660ec37219eff8. No grading request was issued. Neither dry-run nor real apply SQL was executed. No code was changed or test suite rerun; author-reported test results were not claimed as independent tests.

## 8. Approval and state

Read-only QA was authorized by the user's two review requests. Documentation/checkpoint creation was authorized by “Document your work and end the session.” No new approval/decision ID was minted and no task was closed as Done by this QA session. Later author-executed Production changes and the rubric disposition are recorded separately in TASK-0073/DECISION-0122.

The local checkout was already on claude/task-0067-production-records, with five tracked modifications and 122 untracked entries at close. They predate this QA and were not edited, staged, stashed or committed here. Remote documentation synchronization must not be described as a clean/synchronized local checkout.

## 9. Next owner and exact next step

**David Bloom:** make the scope and notation rulings listed in [TASK-0075](../tasks/TASK-0075-ASCII-MATH-CLEANUP.md) before a drafter proceeds. If completing TASK-0073's visual evidence, provide/commission signed-in reviewer/admin screenshots showing the published staff rendering. Do not repeat the already applied Phase 1 transaction.

Restart prompt: “Read TASK-0073's current phase outcome, this session close, and TASK-0075. Treat both independent QA reports as historical artifact checkpoints. Resolve TASK-0075's owner scope/notation rulings before drafting; do not reopen dropped rubric edits or reapply Phase 1.”

## 10. Do-not-touch scope

- No repeat application of the 21-row Phase 1 transaction.
- No rubric notation writes: Phase 2 was dropped under DECISION-0122.
- No explanation edits or rollout widening under the old pilot approval.
- No private exam text, full before/after tables, or raw Production evidence in this public repository.
- No changes to the unrelated dirty local checkout or other sessions' work.
