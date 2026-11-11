# APPROVAL-0217 — AP Statistics Unit 4 harder seeds and variants: 48 items published, 18 superseded items retired (granted and executed 2026-11-11)

- **Status:** Granted by David in chat ("Let's publish all the new unpublished questions so students can use them", 2026-11-11) and executed.
- **Tier:** Production content write (student-facing questions).
- **Basis:** Audit of the 23 published Unit 4 MCQs (output/stats_unit4_mcqs.xlsx): 13 one-step recall (R1), 10 R2, none R3; no variants; topics 4.5 to 4.8 had no MCQs; three byte-identical or near-identical duplicate seeds; a proportion item filed under a means topic (058); a mean-CI key built with z* (065); an unclear t-sign item (068). David asked for the same rewrite as Units 2 and 3.
- **Scope of "all new unpublished questions":** only these 48 new Unit 4 items. Other unpublished items in Production (about 200, across other packs and this pack) are in `assigned`, `changes_requested` or `reviewed_disapproved` states from reviewers; they were not touched.

## Scope
Production `pcntajvbdfqhbeewmdry`, AP Statistics pack `548f06be-ccf4-426d-b82b-b424137a4438`.
- **Loaded and published 48 MCQs** (12 seeds + 36 variants), keys `APSTATS-MCQ-H-4.<n>-<A|B>` and `APSTATS-MCQ-SV-H-4.<n>-<A|B>-v1..3`, topics 4.1 to 4.10, serving label `required_units [4]`, topic-only cell, correct answer balanced 12 each of A to D.
- **Retired 18 superseded items:** 009-CAL, 013-CAL, 014-CAL (exact duplicates); 055, 056, 057, 059, 070, 096, 093, 091, 099 (R1); 062, 069 (near-twins of 013 and 014); 058 (proportion item, wrong topic); 065 (z* for a mean); 068 (unclear); 072 (thin). Rows retired, not deleted; student history intact. Kept on purpose: 009, 013, 014, 064, 079.
- Package: `scripts/content-seed/ap-statistics-unit4-harder-seeds-2026-11-11/`.

## Verification
- Before: all 18 retire keys published; none of the 48 new keys existed.
- Load hash check 48/48 matched the build manifest.
- **Blind solve:** `deepseek/deepseek-v4-pro` and `moonshotai/kimi-k3.1-pro`, each 48 of 48 agree with the keyed answer.
- Publish and retire rehearsals passed in rolled-back transactions; then executed: published 48, validated labels 48, topic cells 48, retired 18.
- After: hash check 48/48 with item and version `published`; Unit 4 now has 53 published MCQs (per topic 4.1 to 4.10: 10, 9, 5, 5, 4, 4, 4, 4, 4, 4). The real selector `select_student_practice_items` for a Unit 4 student returned 51 MCQs in one page, 48 of them new.

## Not done
No live student session; no content-reviewer read of the student-facing text; rationales not model-audited (Product Owner decision, as for Units 2 and 3); attempt history on the 18 retired items not inspected. Topics 4.5 to 4.8 have one seed family each. Topic and skill voting skipped as for Units 2 and 3.
