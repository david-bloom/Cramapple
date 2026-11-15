# Label gap audit, registry Units 1-5, all ten AP subjects (Stage 1, read-only, 2026-11-13)

Read-only against Production (`pcntajvbdfqhbeewmdry`; only SELECTs; `scripts/content-seed/label-gap-audit-2026-11-13/export_prod.py` then `analyze.py`/`report.py`). Nothing was written to any database. Machine-readable per-item flags: `docs/qa/LABEL_GAP_AUDIT_UNITS_1_5_2026_11_13_ITEMS.json` (4,795 rows, one per item with `status='published'`).

## Scope and mapping
- Subjects joined through `app.exam_packs.exam_code` (`ap_*`), never by `subject_key` text. Registry keys use hyphens, taxonomy keys underscores, Biology is `biology` (registry) / `ap_biology` (taxonomy/exam code): joining on the replaced string would have matched zero Biology rows.
- "Units 1-5" = the **first five registry units** of each subject: Biology, Calc AB, Calc BC, Chemistry, Physics 1, Mechanics, Statistics 1-5; **Physics 2 = 9-13; Physics C: E&M = 8-12** (same rule the Units 1-3 runbook used); **Precalculus has only four units (1-4)**.
- Statistics has two published exam-pack versions under one pack (`548f06be` and `7c5a2975`); both included.
- In scope = `items.status='published'` AND latest version (max `version_num`, the selector's own rule) `status='published'` AND not a teaching item AND unit in the subject's Units 1-5. Unit comes from the primary topic cell, else the serving label's primary/max unit, else `prompt_json`.
- **4,795** published-item rows; **4,730** have a published latest version; **4,214 in scope**; 495 are in Units 6+; **86 have no resolvable unit** (no cell, no label, no unit in `prompt_json`; Calc BC 39, Mechanics 9, Physics 1 10, Chemistry 9, Physics 2 7, E&M 5, Precalc 3, Stats 3, Bio 1) and are listed as an open question, not counted; **65** have a published item whose latest version is *retired* (not served; lifecycle defect, not touched: Stats 23, Physics 2 11, Physics 1 7, Mechanics 7, E&M 6, Chem 4, Precalc 3, AB 2, BC 2).

## Definition of "missing" (from the live selector, the `content_item_topic_resolution` view and `taxonomy_relevant_hash`)
1. **Topic cell**: a primary cell (`skill_code is null`) on the latest version with `assignment_status='validated'`. The selector's `topic_match` also accepts `authored`; reported separately.
2. **Skill cell**: >=1 non-primary cell with a `skill_code`, status `validated` (`provisional_model` reported separately).
3. **Serving label**: latest non-superseded `label_scope='serving'` row with `label_status='validated'`, `max_required_unit` set and `validated_against_taxo_hash = taxonomy_relevant_hash(latest version)`. Anything else (none, held, provisional_model, legacy_unvalidated, stale) means the selector **does not serve the item**.
4. **Difficulty row**: any `content_item_difficulty` row on the latest version.

## Result (in-scope items missing each label; recounted from raw query output)
Totals: 4,214 items; missing topic **525**; missing serving **373**; missing difficulty **2,467**; missing skill **3,237**; items missing topic, serving or difficulty **2,853**.

```
subject                   u  mcq   frq | topic serv  diff skill | anyCore
ap_biology                1  119     8 |    0    0    59   78 | 59
ap_biology                2  139    15 |    0    1    87   92 | 88
ap_biology                3   50    11 |    0    0    44   45 | 44
ap_biology                4   50     8 |    0    1    48   52 | 49
ap_biology                5    5    10 |    0    0     0    8 | 0
ap_calculus_ab            1  236    39 |  130    2   128  235 | 258
ap_calculus_ab            2  140    11 |   19    3    80  104 | 99
ap_calculus_ab            3   96     9 |   12    6    48   59 | 60
ap_calculus_ab            4   57     5 |    6    6    56   62 | 62
ap_calculus_ab            5   36    11 |   23   16    24   47 | 47
ap_calculus_bc            1  226    22 |    2    6   128  208 | 134
ap_calculus_bc            2  132    11 |    0    4    80  102 | 84
ap_calculus_bc            3   77     9 |    0    8    48   58 | 56
ap_calculus_bc            4   58     0 |    2    2    56   58 | 58
ap_calculus_bc            5   29     4 |    5    5    24   33 | 29
ap_chemistry              1   96     8 |    0    0    64   73 | 64
ap_chemistry              2   75     7 |    0    0    56   66 | 56
ap_chemistry              3  110    16 |    0    1   104  111 | 105
ap_chemistry              4   76     6 |    8    7    72   82 | 80
ap_chemistry              5    5     1 |    2    2     0    6 | 2
ap_physics_1              1   64    14 |    0    5    40   58 | 45
ap_physics_1              2   88    19 |    1    6    72   92 | 78
ap_physics_1              3   48    14 |    0    4    40   54 | 44
ap_physics_1              4   37     4 |    9    1    32   41 | 41
ap_physics_1              5    6     1 |    7    1     0    7 | 7
ap_physics_2              9   22    10 |    0    3     0   10 | 3
ap_physics_2             10   21     7 |    0    2     0    7 | 2
ap_physics_2             11   25    11 |    0    3     0   11 | 3
ap_physics_2             12    5     1 |    6    0     0    6 | 6
ap_physics_2             13    5     5 |   10    1     0   10 | 10
ap_physics_c_em           8   37    19 |    0    2     0   23 | 2
ap_physics_c_em           9   24     8 |    0    3     0   12 | 3
ap_physics_c_em          10   22     8 |    2    5     0    8 | 5
ap_physics_c_em          11    8     8 |   16    1     0   16 | 16
ap_physics_c_em          12    6     3 |    9    1     0    9 | 9
ap_physics_c_mechanics    1   64     7 |    0    0    40   47 | 40
ap_physics_c_mechanics    2   77    14 |    0    5     0   23 | 5
ap_physics_c_mechanics    3   50     9 |    2    4     0    9 | 5
ap_physics_c_mechanics    4    5     5 |   10    2     0   10 | 10
ap_physics_c_mechanics    5    4     4 |    8    1     0    8 | 8
ap_precalculus            1  169    26 |    1    6   112  162 | 118
ap_precalculus            2  167    30 |    2   17   120  150 | 137
ap_precalculus            3  139    28 |    0   12   120  152 | 132
ap_precalculus            4   56     0 |    0    0    56   56 | 56
ap_statistics             1  341    32 |  200  182   304  310 | 306
ap_statistics             2  107    24 |    0    0    96  101 | 96
ap_statistics             3   98    16 |    0    1    88  100 | 89
ap_statistics             4   51    35 |   18   18    66   84 | 66
ap_statistics             5   65    18 |   15   17    75   82 | 77
{'difficulty': 2467, 'core': 2853, 'skill': 3237, 'items': 4214, 'serving': 373, 'topic': 525}
```

## What the gaps are (not all are defects)
- **Serving (373 items, these are NOT SERVED today).** 213 Statistics items have *no* serving label at all (Unit 1: 182, Unit 4: 18, Unit 5: 17 incl. the 30 `apstats-frq-u45r2-%` FRQs: 18 in Unit 4, 12 in Unit 5, each with no topic cell, no serving label, no difficulty row, as APPROVAL-0257 said). The rest hold only a non-validated label: provisional_model (Precalc 30, AB 19, BC 15, Physics 1 7, Mechanics 6, Chem 4, E&M 4, Physics 2 2, Stats 2), held (AB 14, BC 10, Physics 1 10, E&M 8, Physics 2 7, Mechanics 6, Precalc 5, Chem 4, Bio 2, Stats 2), legacy_unvalidated (Chem 2), stale (Stats 1). Split: MCQ seeds 206, FRQ seeds 147, FRQ variants 20, MCQ variants 0.
- **Topic (525).** Statistics 233 (203 carry an `authored` cell only, so the selector accepts them; 30 are the new FRQs with none), Calculus AB 190 (all `provisional_model` topic cells, of which 157 are served; the selector ignores a provisional cell for `topic_match`), and 102 with no cell at all (E&M 27, Mechanics 20, Physics 1 17, Physics 2 16, Chem 10, BC 9, Precalc 3). Of the 525, 298 are MCQ seeds, 107 FRQ seeds, 85 MCQ variants, 35 FRQ variants. 25 have a cell on an *older* version (a version bump left them behind).
- **Difficulty (2,467) and Skill (3,237) are mostly historical, not recent regressions.** Difficulty is absent for 1,665 MCQ variants and 758 MCQ seeds (Stats 599, Precalc 408, AB 336, BC 336, Chem 296, Bio 224, Physics 1 184, Mechanics 40) plus 44 FRQs (Stats 30, Bio 14). Physics 2 and E&M have zero gaps. Skills: MCQs in Precalc, AB, BC, Chem, Bio, Physics 1, Mechanics lack validated skill cells in large numbers (Stats is topic-only by design, 544 provisional); only 157 of the 591 in-scope FRQs have any skill cell (validated or provisional). Whether skills or difficulty are *required* for these subjects is an **owner question** (see Q1/Q2).

## Surprises raised as questions, not fixes
- **Q1 (scale).** The brief assumed a small tail. The core gap (topic/serving/difficulty) is 2,853 items and skills add 3,237. Is difficulty required for all published MCQs (variants carry basis `translated`; the repo has 1,665 variants without it), and are skill cells wanted for Precalc, AB, BC, Chemistry, Biology, Physics 1 and Mechanics, or only the three subjects whose runbook says so? Does anything in serving consume `content_item_difficulty`? (The selector does not.)
- **Q2.** Statistics Unit 1: 182 items are not served because they have no serving label (legacy `APSTAT-MOD*` and similar with an `authored` cell). Are they intended to be dark, or should they be labeled?
- **Q3.** Calculus AB: 190 `provisional_model` topic cells. Promoting them to validated is a change to an existing label, which the brief forbids without asking; adding a new validated cell beside them would create two primary cells on one version.
- **Q4.** 86 published items with no resolvable unit (Calc BC 39: mirrors without cells/labels?) and 65 items with a retired latest version. Left alone.
- **Q5.** Held/provisional_model serving labels (about 160 items) were held on purpose in earlier runs (failed calls, unit disagreement, exam-scoring content). They are not auto-released here; releasing needs its own probe and reason.
- Unit disagreements between sources (14 items): APBIO-FRQ-L-031, S-040, S-081, S-103, apcalcbc-frq-np1-008, apcalcbc-frq-u13-015, apchem-frq-l-010, apphycm-mcq-031, apprecalc-frq-np2-004, apprecalc-mcq-sv-037-v3, APSTAT-MOD3-H001-INV, APSTAT-MOD5-H001-INV, apstats-frq-u12-017, APSTATS-MCQ-009.
- The Units 4+ FRQ topic probes (158 from 2026-10-09) were never written; most of them correspond to the 107 FRQ seeds above.

## Not yet done
Selector spot-check before/after (Stage 5), Stage 2 method/cost plan, and anything in Dev. No approval number has been assigned yet (highest on origin: APPROVAL-0258; open PR #640 may claim more).
