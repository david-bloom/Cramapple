# More help topic tagging priority audit — 2026-10-15

STATUS: CURRENT read-only checkpoint
Scope: Production app content metadata and a bounded Development exact-key comparison. No learner records, writes, paid model calls, or tag promotions.

## Current impact

| Subject | Published versions without a selected active topic | Potential practice eligibility | No active validated serving label |
| --- | ---: | ---: | ---: |
| Calculus AB | 1 | 0 | 1 |
| Calculus BC | 84 | 20 | 64 |
| Chemistry | 81 | 45 | 36 |
| Total | 166 | 65 | 101 |

The 65 satisfy the deployed `public.select_student_practice_items` content predicates: latest version is published, active validated serving label is fresh against `app.taxonomy_relevant_hash`, required-unit maximum is reachable at some manifest-allowed unit, supported item/form, and exclusion from the teaching pool. All 166 lack any selected unsuperseded cell topic, not merely a validated cell. No teaching item is among the 166.

This is potential content eligibility for a fresh eligible learner at an appropriate unit. It does not count served requests or affected students. Entitlement, active subject, session format/unit, previous submissions and Open Hand exclusions can reduce an individual learner's pool. No learner tables were read. No claim is made that all 166 reach students.

The live selector intentionally includes hand-drawn/photo-required FRQs. The October 8 source migration's hand-drawn exclusion is stale for this comparison; the October 15 deployed definition was inspected. The other legacy unit selector differs and cannot substitute for the app practice queue.

## Ordered queue

First resolve the four already-tagged, currently eligible expanded-octet MCQs below. In parallel, queue the 65 currently eligible untagged versions for CED-based topic votes; then handle the 101 unserved untagged versions together with their serving-label deficiencies. Adding a topic does not itself establish serving eligibility, and mapping a Calculus question may expose the separate later-unit reference gap.

| Subject / earliest required unit | MCQ | FRQ |
| --- | ---: | ---: |
| BC 3 | 0 | 2 |
| BC 5 | 3 | 0 |
| BC 6 | 4 | 2 |
| BC 10 | 7 | 2 |
| Chemistry 4 | 6 | 1 |
| Chemistry 5 | 3 | 0 |
| Chemistry 6 | 6 | 3 |
| Chemistry 7 | 6 | 1 |
| Chemistry 8 | 7 | 3 |
| Chemistry 9 | 6 | 3 |

The companion SQL emits the exact keys for each row. Unit labels are prioritization hints, not validated topic decisions. Apply the canonical six-vote topic process from `docs/handoffs/UNITS_1_3_PIPELINE_RUNBOOK_AND_SESSION_CLOSE_2026_10_04.md` §2: accept 5/6; accept 4/6 only with matching pooled variant plurality; otherwise read the exact CED or leave unassigned. An untagged seed gives variants nothing to inherit. Preserve exact text/version hashes, vote artifacts, CED rationale and unresolved cases. This checkpoint authorizes no paid run or Production metadata change.

## TASK-0076 semantic ruling packet

Direct source inspected: `docs/teaching/ap-chemistry-course-and-exam-description.pdf`, PDF pages 55–62. Topic 2.5.A/2.5.A.1 requires representing a molecule by a Lewis diagram using established principles. The exclusion following 2.7.A.3 (printed framework page 52) restricts more-than-four-pair central atoms to resulting molecular shape. Current stems below ask for expanded-shell identification/counting, not shape.

| Content key | Current primary topic / provenance | Requirement in current stem | Proposal |
| --- | --- | --- | --- |
| apchem-mcq-026 | 2.5 validated; apchem_topic_probe_2026_10_02:6/6 | Identify species requiring greater-than-octet central shell | Owner retire or rewrite ruling |
| apchem-mcq-sv-026-v1 | 2.5 validated; apchem_variants_topic_2026_10_02 | Identify central atom with more than eight electrons | Owner retire or rewrite ruling |
| apchem-mcq-sv-026-v2 | 2.5 validated; apchem_variants_topic_2026_10_02 | Count electrons around iodine in IF5 | Owner retire or rewrite ruling |
| apchem-mcq-sv-026-v3 | 2.5 validated; apchem_variants_topic_2026_10_02 | Identify ion requiring central atom beyond octet | Owner retire or rewrite ruling |
| apchem-frq-u13g-2-5 | 2.5 validated; frq_u13_gap_fill_2026_10_09:6/6 | Electron count, complete Lewis structures and octet explanation | Retain 2.5, subject to normal independent content review |
| apchem-mcq-078 | 2.5 validated; task0065_chem_u2_2026_10_08:topic | Complete correct hydroxide Lewis diagram | Retain 2.5 |
| apchem-mcq-sv-078-v1 | 2.5 validated; same topic source | Complete correct amide-ion Lewis diagram | Retain 2.5 |
| apchem-oht-2.5 | 2.5 authored; task0065_oht_generated_2026_10_06 | Phosphate valence-electron total | Retain 2.5; teaching route, not practice queue |

All seven non-teaching versions in this table currently meet practice content eligibility. The Open Hand question has a live unreleased generated teaching designation, a published nonretired pack and published item/version; the live teaching RPC does not require validated serving labels or validated cells. Its authored cell is therefore not evidence of an accidental practice-selector bypass. Actual signed-in teaching delivery was not exercised here.

A mechanical retag to 2.7 would produce references named VSEPR theory, Molecular geometries named in the CED, Hybridization and ideal bond angles, Sigma and pi bonds, Bond order/bond length/bond energy, and the three bond-polarity entries. These do not change the excluded demand of the four stems. Retaining 2.5 currently supplies Principles for constructing a Lewis diagram, deliberately written without expanded-octet instruction. Reference-row availability alone does not establish useful or CED-valid help.

No proposed replacement topic exists for the four unchanged stems. Recommended ruling is retire them, or authorize new in-scope shape questions followed by normal independent content QA and new tagging. If owner chooses to keep them as enrichment, explicitly record scope/product policy rather than calling them covered AP objectives.

## Evidence and remaining boundaries

Reproducible SELECT-only SQL: `MORE_HELP_TOPIC_TAGGING_PRIORITY_2026_10_15.sql`. It reproduces the 166/65/101 split, exact 65-key queue, TASK-0076 current stem/provenance and practice predicates. Production project: pcntajvbdfqhbeewmdry.

The live provenance string records a 6/6 seed probe and a named variant tagging run. The historical executable SQL below records per-variant checked inheritance at >=5/6; raw individual votes were not reread. Secondary skill rows explicitly say inheritance. CED admissibility remains a separate check from topic agreement.

TASK-0076 is not fully closed: complete semantic source-family audit and independent review remain. These do not block acting on the explicit four-item scope mismatch through an owner ruling. No new reference entry is proposed; Chemistry 2.5 was already published under APPROVAL-0177.

## Follow-up evidence checkpoint

A targeted Production stem scan of untagged and 2.1/2.6/2.7 questions containing Lewis/oct(et)/valence-electron/lone-pair terms returned nine candidates. Eight are 2.6 resonance/formal-charge questions with no obvious 2.5 mismatch; `apchem-sfrq-014` is a new scope-review candidate: XeF4 with supplied lone pairs, requesting electron-domain geometry and count justification, molecular shape/lone-pair placement, and polarity justification. It is currently practice-eligible with a fresh Unit 2 label. Shape is allowed; the additional demands need a CED/owner ruling. This keyword scan is a triage aid, not a semantic certificate of all 81 untagged versions.

Targeted historical tracing found the executable seed and variant records:
- `scripts/content-seed/chem-units1-3-pipeline-2026-10-02/step3_topic_cells.sql`: seed 026 recorded as 6/6, three families × two samples.
- `.../step9_publish.sql`: topic cells explicitly use per-variant agreement with the seed at >=5/6; unit-label payload says inherited-from-seed after that check. Thus the variant tags were recorded as checked inheritance, not an unsupported blanket copy. Raw individual vote artifacts were not reread.
- `.../PIPELINE_REPORT.md` §Gaps records that CED scope checking was initially omitted on seeds; later flagged seed 028 for the same more-than-four-pair exclusion and left it unchanged. This is a concrete process gap: topic consensus did not establish CED admissibility.

The 36 surviving published primary seed cells in this source family comprise 35 at6/6 and1 at5/6; 72 published primary variant cells use its variant source. Recheck scope independently across these108 items before changing classifications; vote agreement does not erase an explicit exclusion.

The known `apchem-mcq-028` currently asks both SF4 electron-domain geometry and molecular shape. Its variants are not uniform: v1 asks XeF4 shape and v2 asks BrF3 shape (within the explicit shape allowance); v3 asks formula from a supplied six-domain/square-pyramidal description and needs separate scope review. Do not retire or retag a whole seed family mechanically.

The literal count of published versions with **no primary validated cell** is AB286, BC95, Chemistry102. These differ from the no-selected-topic counts AB1/BC84/Chem81 because many authored/provisional cells, especially teaching cells, still carry a topic and can ground help. The TASK-0076 background's phrasing equating Chemistry81 with no primary validated cell is imprecise.

Development contains only one of the eight named published items in this exact-key check: `apchem-frq-u13g-2-5` (validated2.5), with matching stem and source. The other seven are not published under those exact keys there; do not claim mirrored bank parity or mutate Development to make the counts match.

Remaining TASK-0076 work: semantic review of all untagged/held candidates, independent review of proposed dispositions, precise Production write/recovery batch after owner ruling, and signed-in help verification. Units1–3 no-other-zero-reference finding is inherited from today's canonical help-coverage closeout, not rerun here; later-unit Calculus reference gaps remain separate.
