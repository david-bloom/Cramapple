# APPROVAL-0241 — AP Precalculus Unit 2 topics 2.1 to 2.8: 64 items published, 31 retired (granted and executed 2026-11-12)

- **Status:** Granted by David in chat ("Do Unit 2 for all subjects", then "Execute all seven", 2026-11-12) and executed.
- **Tier:** Production content write (student-facing questions).
- **Basis:** Unit 2 audit across subjects (`docs/product/UNIT2_RELEVELING_STATUS_2026_11_12.md`): almost no R3 items and several R1-heavy topics; this batch re-levels to the owner's difficulty standard (`QUESTION_DIFFICULTY_IMPROVEMENT_PLAN_2026_11_11.md`).

## Scope
Production `pcntajvbdfqhbeewmdry`, AP Precalculus pack `5522b532-5e50-41f2-99a2-10144bd4e8db`.
- **Loaded and published 64 MCQs** keyed `apprecalc-mcq-b7-h-2.<n>-<letter>` (seeds) and `apprecalc-mcq-b7-sv-h-2.<n>-<letter>-v1..3` (variants), topics 2.1 to 2.8; serving labels validated (`chat_review`) with required units set per topic; topic-only cells; correct answer position balanced across A to D.
- **Retired 31 superseded practice MCQs** (whole families whose seed the difficulty tool rated R1; teaching items excluded).
- Package: `scripts/content-seed/apprecalc-harder-seeds-u2a-2026-11-12/`.

## Verification
- Before each write: the retire keys were published and none of the new keys existed (the execution script stops on any mismatch).
- Authoring in session by a subagent against a strict format and validator; every number recomputed in Python. Blind solve by `deepseek/deepseek-v4-pro` and `moonshotai/kimi-k3.1-pro`; every disputed key was re-derived by hand and confirmed.
- Executed: load hash check 64/64, publish and retire rehearsals passed in rolled-back transactions, published 64, validated labels 64; after: hash check 64/64. The real selector `select_student_practice_items` returned the new items for every topic in scope.

## Not done
No live student session; no subject-expert read of the new items; rationales not model-audited; attempt history on retired items not inspected. Difficulty tiers (`scripts/difficulty-audit/`) are uncalibrated model judgements; a few seeds are R2 (see the status doc caveats).
