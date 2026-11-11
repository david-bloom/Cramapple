# APPROVAL-0228 — AP Statistics Unit 3 second seeds for topics 3.7, 3.12 and 3.14: 12 items published (granted and executed 2026-11-12)

- **Status:** Granted by David in chat ("Yes, do those", then "Yes, execute", 2026-11-12) and executed. The first attempt to execute was blocked by the permission classifier and was not worked around; it ran after the second, explicit approval.
- **Tier:** Production content write (student-facing questions).
- **Basis:** The Unit 3 re-leveling audit left Statistics topics 3.7, 3.12 and 3.14 with one R2 family (with an R1-leaning variant) plus a teaching item each. Status doc `docs/product/UNIT3_RELEVELING_STATUS_2026_11_12.md`.

## Scope
Production `pcntajvbdfqhbeewmdry`, AP Statistics pack `548f06be-ccf4-426d-b82b-b424137a4438`.
- **Loaded and published 12 MCQs** (3 seeds, 9 variants): `apstats-mcq-b2-h-3.7-b`, `-3.12-b`, `-3.14-b` and their `-sv-h-...-v1..3` variants. Serving labels validated (`chat_review`, `required_units [3]`), topic-only cells, correct answer position balanced.
  - 3.7-B: one-proportion z-test statistic, p-value, conclusion and p-value meaning. 3.12-B: two-proportion conditions and pooling. 3.14-B: chi-square hypotheses and expected-count condition.
- **Nothing retired:** the existing families are R2 and stay.
- Package: `scripts/content-seed/apstats-harder-seeds-u3-2026-11-12/`.

## Verification
- Blind solve by `deepseek/deepseek-v4-pro` and `moonshotai/kimi-k3.1-pro`: 12 of 12 agree with the key each. The difficulty tool rates the set R2 to R3, with two R1-leaning items (3.12-B-v2, 3.14-B-v3, models disagree).
- Preflight: none of the 12 new keys existed. Load hash check 12/12; publish rehearsal passed in a rolled-back transaction; executed: published 12, validated labels 12, topic cells 12; after: hash check 12/12, item and version `published`.
- Published MCQs for topics 3.7, 3.12, 3.14 are now 9, 9, 9 (each includes one teaching item). The real selector `select_student_practice_items` for a Unit 3 student returned all 4 new items for each topic.

## Not done
No live student session; no subject-expert read; rationales not model-audited. Statistics Unit 3 is now re-leveled for all topics 3.1 to 3.15 (with the earlier APPROVAL-0215).
