# APPROVAL-0230 — AP Biology Unit 4 topics 4.1 to 4.6: 48 items published, 5 superseded items retired (granted and executed 2026-11-12)

- **Status:** Granted by David in chat ("Do Unit 4 for all subjects. Excluding Physics 2, C and C", then "Execute all seven", 2026-11-12) and executed.
- **Tier:** Production content write (student-facing questions).
- **Basis:** Unit 4 audit across subjects (`docs/product/UNIT4_BUILDOUT_STATUS_2026_11_12.md`): Unit 4 content was mostly unbuilt outside Statistics, so this batch is mainly new content to the owner's difficulty standard (`QUESTION_DIFFICULTY_IMPROVEMENT_PLAN_2026_11_11.md`).

## Scope
Production `pcntajvbdfqhbeewmdry`, AP Biology pack `2d88ba5e-a6a3-43b8-bfae-9e5505a178a7`.
- **Loaded and published 48 MCQs** keyed `apbio-mcq-b4-h-4.<n>-<letter>` (seeds) and `apbio-mcq-b4-sv-h-4.<n>-<letter>-v1..3` (variants), topics 4.1 to 4.6; serving labels validated (`chat_review`) with unit-4 required units set per topic; topic-only cells; correct answer position balanced across A to D.
- **Retired 5 superseded items** (`superseded_keys.json` in the package): R1 or near-duplicate families. Rows retired, not deleted; student history intact.
- Package: `scripts/content-seed/apbio-harder-seeds-u4-2026-11-12/`.

## Verification
- Before each write: retire keys published and none of the 48 new keys existing (the execution script stops on any mismatch).
- Authoring: written in session by a subagent against a strict format and validator; every number recomputed in Python. Blind solve by `deepseek/deepseek-v4-pro` and `moonshotai/kimi-k3.1-pro`; items either model or the difficulty tool disputed were re-solved by `openai/gpt-5.5`, which agreed with the key on all of them.
- A review comment found that the publish guard required an existing content cell for each topic, which would have blocked first-ever Unit 4 content; the guard now checks the taxonomy, and the packages were regenerated before running.
- Executed: load hash check 48/48, publish and retire rehearsals passed in rolled-back transactions, published 48, validated labels 48, topic cells 48, retired 5; after: hash check 48/48, item and version `published`.
- Published MCQs per topic (4.1 to 4.6) are now 8, 8, 11, 8, 8, 8 (counts include any teaching items). The real selector `select_student_practice_items` for a Unit 4 student returned the new items.

## Not done
No live student session; no subject-expert read of the new items; rationales not model-audited; attempt history on any retired items not inspected. Difficulty tiers (`scripts/difficulty-audit/`) are uncalibrated model judgements; some seeds are strong R2 rather than R3.
