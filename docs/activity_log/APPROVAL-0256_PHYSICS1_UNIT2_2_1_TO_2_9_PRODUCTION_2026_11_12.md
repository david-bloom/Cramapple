# APPROVAL-0256 — AP Physics 1 Unit 2 topics 2.1 to 2.9: 72 items published, 40 retired (granted and executed 2026-11-12)

**Numbering correction (2026-11-12):** This Production execution was originally recorded as
`APPROVAL-0236` on the unmerged PR #630 branch. PR #631 merged first with `APPROVAL-0236` assigned
to TASK-0050 Statistics Phase B. Per the later-merging-branch convention, this Physics 1 record is
now `APPROVAL-0256`. Its authorized scope and execution evidence are unchanged.

- **Status:** Granted by David in chat ("Do Unit 2 for all subjects", then "Execute all seven", 2026-11-12) and executed.
- **Tier:** Production content write (student-facing questions).
- **Basis:** Unit 2 audit across subjects (`docs/product/UNIT2_RELEVELING_STATUS_2026_11_12.md`): almost no R3 items and several R1-heavy topics; this batch re-levels to the owner's difficulty standard (`QUESTION_DIFFICULTY_IMPROVEMENT_PLAN_2026_11_11.md`).

## Scope
Production `pcntajvbdfqhbeewmdry`, AP Physics 1 pack `29c719dc-701b-470f-9e49-fab981722d3f`.
- **Loaded and published 72 MCQs** keyed `apphysics1-mcq-b5-h-2.<n>-<letter>` (seeds) and `apphysics1-mcq-b5-sv-h-2.<n>-<letter>-v1..3` (variants), topics 2.1 to 2.9; serving labels validated (`chat_review`) with required units set per topic; topic-only cells; correct answer position balanced across A to D.
- **Retired 40 superseded practice MCQs** (whole families whose seed the difficulty tool rated R1; teaching items excluded).
- Package: `scripts/content-seed/apphysics1-harder-seeds-u2-2026-11-12/`.

## Verification
- Before each write: the retire keys were published and none of the new keys existed (the execution script stops on any mismatch).
- Authoring in session by a subagent against a strict format and validator; every number recomputed in Python. Blind solve by `deepseek/deepseek-v4-pro` and `moonshotai/kimi-k3.1-pro`; every disputed key was re-derived by hand and confirmed.
- Executed: load hash check 72/72, publish and retire rehearsals passed in rolled-back transactions, published 72, validated labels 72; after: hash check 72/72. The real selector `select_student_practice_items` returned the new items for every topic in scope.

## Not done
No live student session; no subject-expert read of the new items; rationales not model-audited; attempt history on retired items not inspected. Difficulty tiers (`scripts/difficulty-audit/`) are uncalibrated model judgements; a few seeds are R2 (see the status doc caveats).
