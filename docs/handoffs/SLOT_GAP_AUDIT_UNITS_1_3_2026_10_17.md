# Slot-gap audit, units 1-3, all subjects (read from Production 2026-10-17)

**Scope:** the first three units of each subject's taxonomy (Physics 2 = units 9-11, Physics C-E&M = units 8-10, as in the reference sets). "Served" = published item with a primary topic cell and a validated serving label, i.e. what the student practice selector can return. Counts include the Biology 2.10 and Mechanics loads done today; Physics 1 topic 1.3 not yet (it shows 4, becomes 8 after the load).

## 1. MCQ gaps (true gaps: no practice MCQ is served)
The single unserved item on most of these topics is the topic's Open Hand teaching item (`*-oht-*`, no label by design), not a practice question.

| Subject | Zero served MCQs | Thin (1-3) |
|---|---|---|
| Calculus AB | 1.1, 1.9, 1.16 | 1.3 (1), 3.6 (3) |
| Calculus BC | 1.1, 1.9, 1.16 | 1.3 (1) |
| Chemistry | 3.3, 3.8, 3.11 | none |
| Physics 1 | none | none (1.3 gets +4 from slot A) |
| Physics 2 (9-11) | 9.1, 9.3, 10.1, 10.6, 11.1, 11.2 | 10.4 (2), 11.7 (3) |
| Physics C-E&M (8-10) | 8.2, 9.3, 10.2 | 8.4 (1) |
| Physics C-Mechanics | none | none (slots 1.3-B, 2.2-A, 2.7-B unfilled) |
| Precalculus | none | 2.4 (1), 2.10 (2), 2.12 (1), 3.1 (2), 3.2 (2) |
| Statistics | 1.1-1.5, 2.1, 2.3, 2.8, 2.11, 2.12, 3.7, 3.9-3.14 (18; see 3) | 2.2 (1), 3.3 (3) |
| Biology | none | 2.8 (2) |

Totals: 36 zero-MCQ topics (34 if Statistics 1.2 and 1.9 are relabeled instead, see 3), 14 thin topics.

## 2. FRQ gaps (no FRQ served)
Calc AB 2.3, 2.4, 3.4, 3.5, 3.6; Calc BC 1.6, 1.10, 2.2, 2.4, 2.5, 2.7, 3.2, 3.3, 3.4, 3.6; Chemistry 3.10; Physics 2 10.6, 10.7; C-E&M 10.1, 10.4; Mechanics 2.9, 3.3; Precalculus 2.2, 2.10, 2.11, 2.12, 2.15, 3.6, 3.10. 29 topics. The MCQ seed pipeline does not write FRQs; filling these needs its own plan (rubric criteria, parts) and approval.

## 3. Published but not served (relabel, don't regenerate)
- **Statistics 1.2: 20 MCQs** (`apstat-u1-2-2a-variables-*`) and **Statistics 1.9: 40 MCQs** (`apstat-4b-compare-*`) are published with a topic cell but **no serving label at all**, so none is served. Statistics 1.2 and 1.9 therefore show zero. Labeling these (with validation) would close both gaps without generating. Why they were never labeled is not established; needs a quick quality read before labeling.
- **Calculus AB 1.16:** `apcalcab-mcq-003` (label held) and `apcalcab-mcq-023` (provisional_model) exist but are not validated; a decision on those two could add 2 served MCQs.
- Elsewhere the published-not-served pool is small per topic; per-subject totals of published MCQs without a validated label: AB 50, BC 47, Chemistry 30, Precalculus 30, Statistics 37, Biology 22 (all units, not only 1-3).

## 4. Plan and rough cost (for the owner's decision; nothing started)
Method: seed pipeline, 2 slots per topic x (1 seed + 3 variants) = 8 items per topic (4 for thin topics already holding 2-3), `--bank` of the subject's published items so seeds cannot duplicate, duplicate check, load by the SQL route with a new approval record per subject.
- Zero MCQ topics: 34 x 8 = 272 items; thin topics: 14 x 4 = 56 items; Mechanics unfilled slots: up to 12. About 340 items. At the Mechanics rate ($19.28 for 108 items, about $0.18 each) that is roughly $60-70 plus escalations.
- Suggested order by impact: Statistics (largest hole; first decide relabel vs generate for 1.2 and 1.9), Physics 2, Calculus AB/BC, Chemistry, C-E&M, Precalculus, then thin topics.
- Decisions needed: (a) relabel the 60 Statistics MCQs after a quality read, or generate; (b) whether FRQ gaps are in scope now; (c) per-subject go for each load.
