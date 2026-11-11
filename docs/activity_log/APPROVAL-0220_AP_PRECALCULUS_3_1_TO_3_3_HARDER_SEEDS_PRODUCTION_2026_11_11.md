# APPROVAL-0220 — AP Precalculus topics 3.1 to 3.3 harder seeds: 24 items published, 11 superseded items retired (granted and executed 2026-11-11)

- **Status:** Granted by David in chat ("Execute it", 2026-11-11) and executed.
- **Tier:** Production content write (student-facing questions).
- **Basis:** Difficulty audit of topics 3.1 to 3.3 (`output/other_subjects_3_1_to_3_3_audit.xlsx`, AI-judged): of 14 published MCQs, 11 were R1 (79%), none R3; radian conversion was filed under 3.1; `apprecalc-mcq-041` and `-np2-007` both asked cos(5π/6). Plan: `docs/product/QUESTION_DIFFICULTY_IMPROVEMENT_PLAN_2026_11_11.md`. The three OHT items and the teaching item `apprecalc-mcq-sv-np2-007-v3` were kept.

## Scope
Production `pcntajvbdfqhbeewmdry`, AP Precalculus pack `5522b532-5e50-41f2-99a2-10144bd4e8db`.
- **Loaded and published 24 MCQs** (6 seeds + 18 variants), keys `apprecalc-mcq-h-3.<n>-<a|b>` and `apprecalc-mcq-sv-h-3.<n>-<a|b>-v1..3`, topics 3.1 to 3.3, eight each, serving labels validated (`chat_review`, `required_units [3]`), topic-only cells, correct answer balanced 6 each of A to D.
- **Retired 11 superseded items:** `apprecalc-mcq-015`, `-041`, `-np2-007`, and their variants (015 v1 to v3, 041 v1 to v3, np2-007 v1 and v2). Rows retired, not deleted; student history intact.
- Package: `scripts/content-seed/apprecalc-harder-seeds-u3-2026-11-11/`.

## Verification
- Before: all 11 retire keys published; none of the 24 new keys existed.
- Blind solve by `deepseek/deepseek-v4-pro` and `moonshotai/kimi-k3.1-pro`: 24 of 24 agree with the key each, on the final draft (an earlier draft had an item with three correct answers, caught while drafting and rewritten).
- Load hash check 24/24; publish and retire rehearsals passed in rolled-back transactions; executed: published 24, validated labels 24, topic cells 24, retired 11. After: hash check 24/24, item and version `published`.
- Published MCQs for topics 3.1, 3.2, 3.3 are now 9, 9, 9 (the 9s include one teaching item each). The real selector `select_student_practice_items` for a Unit 3 student with a topic filter returns all 8 new items for each of 3.1, 3.2 and 3.3.

## Not done
No live student session; no subject-expert read; rationales not model-audited; attempt history on the retired items not inspected. The difficulty tool rates the final draft mostly R2 with no R3, and the 3.1 periodic-shift family partly R1 (`scripts/difficulty-audit/`); tiers are model judgements and uncalibrated. No two-checker audit, topic or skill vote.
