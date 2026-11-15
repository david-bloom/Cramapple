# APPROVAL-0223 — AP Precalculus topics 3.4 to 3.9 re-leveled: 48 items published, 24 superseded items retired (granted and executed 2026-11-12)

- **Status:** Granted by David in chat ("Execute all seven", 2026-11-12) and executed.
- **Tier:** Production content write (student-facing questions).
- **Basis:** Owner direction 2026-11-11 to audit and re-level all Unit 3 topics for every subject except Physics 2 and Physics C (on hold). Difficulty audit (`scripts/difficulty-audit/`, AI-judged, uncalibrated) and plan `docs/product/QUESTION_DIFFICULTY_IMPROVEMENT_PLAN_2026_11_11.md`; status doc `docs/product/UNIT3_RELEVELING_STATUS_2026_11_12.md`.

## Scope
Production `pcntajvbdfqhbeewmdry`, AP Precalculus pack `5522b532-5e50-41f2-99a2-10144bd4e8db`.
- **Loaded and published 48 MCQs** keyed `apprecalc-mcq-b2-h-3.<n>-<letter>` (seeds) and `apprecalc-mcq-b2-sv-h-3.<n>-<letter>-v1..3` (variants), topics 3.4 to 3.9; serving labels validated (`chat_review`) with the required units taken from each topic's existing Unit 3 labels; topic-only cells; correct answer position balanced across A to D.
- **Retired 24 superseded items** (`superseded_keys.json` in the package): R1-dominated or duplicated families. Teaching items were never retired, so some families are retired only partly. Rows retired, not deleted; student history intact.
- Package: `scripts/content-seed/apprecalc-harder-seeds-u3b-2026-11-12/`.

## Verification
- Before each write: all 24 retire keys published and none of the 48 new keys existing (checked by the execution script, which stops on any mismatch).
- Authoring: written in session by a subagent against a strict format and a validator; every number recomputed in Python. Blind solve by `deepseek/deepseek-v4-pro` and `moonshotai/kimi-k3.1-pro` before loading; any model miss was re-checked by hand.
- Executed: load hash check 48/48, publish and retire rehearsals passed in rolled-back transactions, published 48, validated labels 48, topic cells 48, retired 24; after: hash check 48/48, item and version `published`.
- Published MCQs per topic (3.4 to 3.9) are now 9, 12, 13, 9, 13, 9 (counts include teaching items). The real selector `select_student_practice_items` for a Unit 3 student returned the new items.

## Not done
No live student session; no subject-expert read of the new items; rationales not model-audited; attempt history on the retired items not inspected. The difficulty tool rates the batch mostly R2/R3 but tiers are uncalibrated model judgements. No two-checker audit, topic or skill vote.
