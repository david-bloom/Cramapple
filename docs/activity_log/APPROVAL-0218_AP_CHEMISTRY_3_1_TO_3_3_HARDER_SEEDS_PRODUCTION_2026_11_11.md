# APPROVAL-0218 — AP Chemistry topics 3.1 to 3.3 harder seeds: 24 items published, 12 superseded items retired (granted and executed 2026-11-11)

- **Status:** Granted by David in chat ("Execute both", 2026-11-11) and executed.
- **Tier:** Production content write (student-facing questions).
- **Basis:** Difficulty audit of topics 3.1 to 3.3 across subjects (`output/other_subjects_3_1_to_3_3_audit.xlsx`, AI-judged) and the plan `docs/product/QUESTION_DIFFICULTY_IMPROVEMENT_PLAN_2026_11_11.md`. Of the 14 published MCQs for these topics, 8 were the single idea that hydrogen bonding raises boiling point, 4 were solid-type recognition, one key (`apchem-mcq-030`) was ambiguous, and 3.3 had no practice MCQs. The two OHT items are teaching items and were kept.

## Scope
Production `pcntajvbdfqhbeewmdry`, AP Chemistry pack `c9ca46b2-b529-4ed3-9741-dddea455ab9b`.
- **Loaded and published 24 MCQs** (6 seeds + 18 variants), keys `apchem-mcq-h-3.<n>-<a|b> and apchem-mcq-sv-h-3.<n>-<a|b>-v1..3`, topics 3.1 to 3.3, eight each, serving labels validated (`chat_review`), topic-only cells, correct answer balanced 6 each of A to D.
- **Retired 12 superseded items:** `apchem-mcq-029`, `-030`, `-031` and their variants v1 to v3. Rows retired, not deleted; student history intact.
- Package: `scripts/content-seed/apchem-harder-seeds-u3-2026-11-11/`.

## Verification
- Before: all 12 retire keys published; none of the 24 new keys existed.
- Blind solve by `deepseek/deepseek-v4-pro` and `moonshotai/kimi-k3.1-pro`: 24 of 24 agree with the key each, on the final draft.
- Load hash check 24/24; publish and retire rehearsals passed in rolled-back transactions; executed: published 24, validated labels 24, topic cells 24, retired 12. After: hash check 24/24, item and version `published`.
- Published MCQ counts for topics 3.1, 3.2, 3.3 are now 8, 9, 9 (the 9s include one teaching OHT item each). The real selector `select_student_practice_items` for a Unit 3 student with a topic filter returns all 8 new items for each of 3.1, 3.2 and 3.3.

## Not done
No live student session; no subject-expert read of the new items; rationales not model-audited; attempt history on the retired items not inspected. The difficulty tool rates the final drafts mostly R2/R3 but not all R3 (`scripts/difficulty-audit/`); tiers are model judgements and uncalibrated. No two-checker audit, topic or skill vote.
