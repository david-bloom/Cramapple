# AP Calculus AB/BC — CED captures used for TASK-0050 Phase 0

Supplied by David Bloom, 2026-09-29, as direct captures of the College Board
*AP Calculus AB and BC Course and Exam Description* PDF (the same document already recorded in
`AP_CALCULUS_AB_BC_CED_FACT_PACK.md`'s Source control section, SHA-256
`fd571cdc252c24d33a75ed556ee20d9261ef1ad3dbb718d0caf78acecc8253ca`).

Kept because `TASK-0050`'s sourcing rule requires fact-pack additions to be confirmed against the
actual CED, and because a transcription should be re-checkable against what it was transcribed from.

| File | CED page | What was taken from it |
| --- | --- | --- |
| `calc_mathematical_practices_skills.png` | Course Framework p. 12 | The four Mathematical Practices and all 23 sub-skills, including the three the CED marks *not assessed* (1.A, 1.B, 3.A) |
| `calc_course_at_a_glance_units_1_2.png` | Course Framework p. 9 | Topic → practice alignment, Units 1-2; also the practice/big-idea legend and the footnote confirming Topic 2.2 covers Practices 1 and 4 |
| `calc_course_at_a_glance_units_3_5.png` | Course Framework p. 9 | Topic → practice alignment, Units 3-5 |
| `calc_course_at_a_glance_units_6_8.png` | Course Framework p. 10 | Topic → practice alignment, Units 6-8 |
| `calc_course_at_a_glance_units_9_10.png` | Course Framework p. 10 | Topic → practice alignment, Units 9-10 (BC only) |

Transcribed into `docs/product/AP_CALCULUS_AB_BC_CED_FACT_PACK.md` under "Practice skills
(sub-skills)" and "Topic-to-practice alignment".

**Transcription check that passed:** the captures yield 87 topics across Units 1-8, six of them
BC-only, predicting AB = 81 and BC = 111. Production holds exactly 81 and 111. A miscount would
almost certainly have broken that equality.

## AP Chemistry

Supplied by David Bloom, 2026-09-29. Captures of the *AP Chemistry Course and Exam Description*,
Course Framework V.1, © 2024 College Board — the same Fall 2024 edition recorded in
`AP_CHEMISTRY_CED_FACT_PACK.md`'s Source control section.

| File | CED page | What was taken from it |
| --- | --- | --- |
| `chem_science_practices_1_3.png` | Course Framework V.1 p. 12 | Practices 1-3 and their sub-skills (1.A-1.B, 2.A-2.F, 3.A-3.C) |
| `chem_science_practices_4_6.png` | Course Framework V.1 p. 13 | Practices 4-6 and their sub-skills (4.A-4.D, 5.A-5.F, 6.A-6.G) |

28 sub-skills total, **none marked not assessed** — unlike AP Calculus, where the CED excludes 1.A,
1.B and 3.A. Practice 3 being absent from the MCQ weighting is a section-level restriction, not a
per-skill exclusion.

**Not yet supplied for Chemistry:** the "Course at a Glance" pages carrying each topic's practice
tag. Those are what made the Calculus grid a transcription rather than a curation; without them a
Chemistry grid would offer all 28 skills against each of 91 topics.

### AP Chemistry — Course at a Glance (partial)

Supplied 2026-09-29, second batch.

| File | CED page | What was taken from it |
| --- | --- | --- |
| `chem_course_at_a_glance_units_6_8.png` | Course Framework V.1 pp. 18-19 | Topic → practice alignment, Units 6, 7, 8, plus exam weightings |
| `chem_course_at_a_glance_unit_9.png` | Course Framework V.1 p. 20 | Topic → practice alignment, Unit 9 |

**Covers Units 6-9 only — 43 of Chemistry's 91 topics.** Units 1-5 (48 topics) are still needed
before a Chemistry grid can be built. Transcription check that passed: the captures give 9, 12, 11
and 11 topics for Units 6-9, and `app.taxonomy_topics` holds exactly those counts.

The same batch re-supplied the two Science Practices pages already archived as
`chem_science_practices_1_3.png` / `chem_science_practices_4_6.png`; they are identical in content
and were not duplicated here.
