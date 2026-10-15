# More help — parallel QA and tagging checkpoint, 2026-10-15

**Status: In progress; Production release pending.** Owner authorized backend/app QA and deployment work alongside a topic-tagging audit. Backend draft [#464](https://github.com/david-bloom/Cramapple/pull/464); app draft [#29](https://github.com/david-bloom/ap-prep-blueprint/pull/29).

## Backend/app evidence

Development grounding migration `20261015175446` and conditional canonical hash-helper restoration `20261015175807` are applied. Initial grounding apply failed on a missing statement terminator and rolled back; corrected execution and six real MCQ/FRQ payload assertions passed. Ledger filenames match. Production remains unchanged.

Development More help v13 is ACTIVE/JWT-verified, all ten retrieved files equal the upload graph; bundle SHA-256 `28c3c308812a4f92e9a9e0236f7e0133272ef754600b8b3df897f4b1de63b2db`. Backend33 tests pass; app source c9c8d8b has1190 passing local tests/typecheck/build and independent defect/retest evidence. App CI initially crashed in npm `edgesOut` before tests, also on retry. Ignoring the npm lockfile also reproduced the same installer crash. App commit c723183 switches CI installation to pinned Bun1.3.13 with the committed `bun.lock` in frozen mode; Node22 and all typecheck/test/build steps remain. Hosted CI [38784474658](https://github.com/david-bloom/ap-prep-blueprint/actions/runs/38784474658) passed installation, typecheck, tests and production build at18:19:56UTC. Dependency manifests/lockfiles unchanged.

The entire **12/12 request allowance is consumed**: seven final before-submit samples (three subjects × MCQ/FRQ, plus Chemistry2.5), three after-grade MCQ samples, and two failed before-submit outputs retained as evidence. All requests returned200; returning200 did not establish semantic correctness. Independent review caught two P1 headline disclosures: an AB statement question's limit/discontinuity conclusions, then a BC conceptual subpart's zero-width diagnosis. Targeted guards were challenged with sibling controls, repaired, independently retested and replayed successfully. Samples were produced across Developmentv12/v13; all ten saved final outputs were additionally revalidated through the finalv13 output validator without provider calls. Final ten samples passed independent agent reading; this is not human acceptance or a universal leakage guarantee.

Real browser evidence includes authored parts visible on FRQs (and the multipart BC MCQ), actual new Chemistry2.5 reference use, draft preservation, no additional generation on cached reopen, assistance status surviving reload and a second tab, and375px question-page width without horizontal overflow. AB's stored grade JSON is exactly unchanged before/after post-grade help. BC's earlier comparison had an unstable baseline and is not certified. Existing transactional runtime12-assertion results remain separately recorded.

The synthetic QA profile/three entitlements were restored to their exact original values; three temporary Development manifest rows were removed with guards, and the owned local server stopped. The canonical helper and grounding deployment remain. Intended synthetic fixtures, delivered-help receipts and three scored MCQ attempts remain. One additional synthetic Chemistry2.5 session `77a33622-dd86-4ea1-b9fe-66d38963a20b` serves existing version `8ab24dc8-eeda-481b-a0ee-d12acacdca85`; no bank content was changed.

## Parallel tagging result

[Read-only report and CED ruling packet](MORE_HELP_TOPIC_TAGGING_PRIORITY_2026_10_15.md): of166 untagged published versions,65 are potentially eligible under current selector content predicates (BC20, Chemistry45);101 lack active validated serving labels (AB1, BC64, Chemistry36). This is eligibility at an allowed unit before learner-specific exclusions, not student/traffic counts. No student records or topic writes were involved.

All four TASK-0076 expanded-octet MCQs are currently practice eligible. Recommended owner ruling: retire or rewrite, not retag to2.7. Adjacent scope candidates and a108-item provenance family warrant bounded semantic review; six-vote agreement did not establish CED admissibility. The literal no-primary-validated-cell count differs from no-selected-topic and is reported separately. The65-item exact-key queue and repeatable SELECT SQL are saved with the report.

## Remaining gates and next actions

1. Hosted app CI now passes; final independent source/report reconciliation must cover final commits.
2. Owner human reading of the actual outputs. Private local packet: `/private/tmp/MORE_HELP_HUMAN_REVIEW_2026_10_15.md`; never commit full questions/outputs to this public repo.
3. Real image/figure help output and wider keyboard/phone fidelity remain unverified. All returned sample figure arrays were empty. Local symlinked KaTeX font requests were blocked by Vite; current screenshots do not certify final glyph/font fidelity.
4. FRQ grading/photo provider availability and graded/revision flows were not exercised by these MCQ scoring checks. No new FRQ/photo provider allowance was inferred from the exhausted separate grading round. Prepare a bounded follow-on QA packet; no further help calls under the exhausted12-request allowance.
5. Production migration/function/app publication, exact source provenance, smoke and recovery checks remain pending. Do not overwrite separately deployed `student-session-items` teaching-image work.
6. Owner TASK-0076 content ruling; canonical classification process for65 priority versions, then101 serving-label gaps. No new topic decisions or paid vote run were performed.
7. Calculus reference-production slate/$60 proposal and6.14 handling remain pending; Chemistry2.5 is already published and was not duplicated.

H01–H15 remain under the parent work order. This checkpoint completes the initial parallel audit and bounded Development round, not the entire remediation/release task.

## Catalog disposition at this checkpoint

| ID | Current disposition |
| --- | --- |
| H01 | Fresh independent source/migration and final-sample reviews pass within recorded scope; full release verdict pending. |
| H02 | Three real MCQ scoring/after-help flows and all three FRQ before-help flows exercised; FRQ graded/revision matrix remains. |
| H03 | Two observed headline failures repaired/replayed with targeted sibling controls; final samples agent-reviewed, human redteam acceptance pending. |
| H04 | Bounded round executed,12/12 requests consumed; no automatic extension or reuse of separate grading allowance. |
| H05 | Transactional runtime assertions, cached reopen, draft/reload/second-tab assistance and AB durable-grade invariance pass; BC stable-baseline recheck remains. |
| H06 | Six exact reviewed visual transcripts allowlisted; actual image-help output not exercised. |
| H07 | Figure linkage/filtering/wire regressions pass; actual returned-figure help sample remains. |
| H08 | Authored parts restored; six real RPC assertions and signed-in FRQ/BC-MCQ display evidence pass. |
| H09 |375px question-page overflow check passes; full help glyph/keyboard/phone evidence remains, local font-path issue documented. |
| H10 | Deterministic MCQ evaluate endpoint works; FRQ grading/photo provider connection remains unverified. |
| H11 | New grounding only Development; exact Production migration/function/app release and smoke pending. |
| H12 | Chemistry2.5 reference now exercised successfully;83 later-Calculus mapped gaps and166 untagged remain,65 potentially servable. Four expanded-octet items need ruling. |
| H13 | Approved current-question/three-subject boundary retained; no new history or subject scope needed. |
| H14 | Current checkpoint/task/index/activity updated; older reports and historical checkpoints preserved. |
| H15 | Original BC response/cause remains unknowable; current BC before/after samples exercised and agent-reviewed. |
