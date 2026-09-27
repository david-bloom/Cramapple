# Work Order A — AP Biology canonical-answer recovery

Status: **proposal only; independent cross-model QA and Product Owner approval required under DECISION-0055.** No Production data was changed.

## Reproducibility

- Production project: `pcntajvbdfqhbeewmdry` (Cramapple – Production)
- Snapshot UTC: `2026-09-23T01:30:44.132Z`
- Run end UTC: `2026-09-23T01:41:24.814Z`
- Builder: Codex (GPT-5-class runtime; a more specific host model identifier was not exposed)
- Count WHERE: latest `version_num` per `content_item_id` among `public.content_item_versions` rows where `status='published' AND subject_key='biology' AND item_type='frq'`; criteria joined from `public.frq_criteria` on `content_item_version_id`.

## Headline result

- Packet: **75/75** published Biology FRQs; **278/278** stored criteria.
- Rubric-split, byte-identical set: **41/41**, exact match.
- Blank canonical fields: **7/7**, exact match.
- Proposal: **71/71** text-answer items.
- Of **118/118** criteria marked drafted by the prior run, **13 recovered** and **105 not recovered**. Of those 105, **88 remain drafted** in the 71 text-answer proposals and **17 belong to the four out-of-scope graph items**. All newly recovered criteria are on `S-101/102/103` and come verbatim from retired parent `APBIO-FRQ-L-025` version 4.
- The 41 rubric-split items' prior canonical fields are byte-identical to the published fields. They validate the migration history but supply no additional answer bytes beyond the accepted prior segmentation.
- Reused prior segmentation on **28** unchanged items; existing-source spans are tagged `unchanged_from_prior_run`.

## Invariants

| Invariant | Measured result | Status |
| --- | ---: | --- |
| Spans concatenate exactly to `full_text` | 71/71 | PASS |
| Every rubric criterion has at least one span | 71/71 | PASS |
| No span invents a criterion | 0 violations | PASS |
| Every `recovered_*` span is verbatim at its source offset | 0 failures | PASS |
| Every source version exists and is authorized | 0 unauthorized failures | PASS |
| Literal same-`content_item_id` source invariant | 14 recovered-parent spans cross item IDs by instruction | FAIL (A-001) |
| Removing any one criterion's spans never empties the answer | 0 failures | PASS |
| Packet captured from Production snapshot | 0 extraction errors | PASS |

The strict same-item invariant conflicts with the explicit parent-recovery instruction. Both IDs and the stored `prompt_json.split_from` relationship are preserved for QA.

## Span provenance counts

- `assembly_literal`: 140 spans
- `drafted`: 88 spans
- `recovered_ca1`: 107 spans
- `recovered_ca2`: 82 spans
- `recovered_parent`: 14 spans
- `unchanged_from_prior_run`: 153 spans

## Known findings and judgment calls

- Four graph items are packet-only and ledgered `out_of_scope`.
- Nine point-total mismatches were recorded but not changed.
- Weak points and cross-criterion entanglements from the accepted prior run were carried forward.
- The parent's two molecular-clock limitations split at a semicolon; the second recovered span retains that leading connective and is flagged rather than rewritten.
- No protected prior-run or QA-owned file was modified.
- Backups created: none.

## Maximum published version observed per item

- `APBIO-FRQ-L-003`: 4
- `APBIO-FRQ-L-004`: 2
- `APBIO-FRQ-L-006`: 2
- `APBIO-FRQ-L-008`: 2
- `APBIO-FRQ-L-012`: 2
- `APBIO-FRQ-L-013`: 2
- `APBIO-FRQ-L-014`: 2
- `APBIO-FRQ-L-015`: 2
- `APBIO-FRQ-L-016`: 3
- `APBIO-FRQ-L-017`: 2
- `APBIO-FRQ-L-019`: 2
- `APBIO-FRQ-L-021`: 1
- `APBIO-FRQ-L-026`: 3
- `APBIO-FRQ-L-030`: 4
- `APBIO-FRQ-L-031`: 5
- `APBIO-FRQ-L-036`: 3
- `APBIO-FRQ-S-003`: 1
- `APBIO-FRQ-S-006`: 1
- `APBIO-FRQ-S-007`: 1
- `APBIO-FRQ-S-009`: 3
- `APBIO-FRQ-S-010`: 2
- `APBIO-FRQ-S-011`: 2
- `APBIO-FRQ-S-016`: 2
- `APBIO-FRQ-S-017`: 2
- `APBIO-FRQ-S-019`: 2
- `APBIO-FRQ-S-020`: 2
- `APBIO-FRQ-S-021`: 2
- `APBIO-FRQ-S-023`: 2
- `APBIO-FRQ-S-025`: 2
- `APBIO-FRQ-S-026`: 2
- `APBIO-FRQ-S-028`: 2
- `APBIO-FRQ-S-029`: 1
- `APBIO-FRQ-S-031`: 1
- `APBIO-FRQ-S-032`: 2
- `APBIO-FRQ-S-033`: 2
- `APBIO-FRQ-S-036`: 2
- `APBIO-FRQ-S-038`: 2
- `APBIO-FRQ-S-040`: 2
- `APBIO-FRQ-S-045`: 1
- `APBIO-FRQ-S-046`: 2
- `APBIO-FRQ-S-047`: 2
- `APBIO-FRQ-S-048`: 2
- `APBIO-FRQ-S-051`: 2
- `APBIO-FRQ-S-052`: 2
- `APBIO-FRQ-S-058`: 2
- `APBIO-FRQ-S-061`: 3
- `APBIO-FRQ-S-062`: 1
- `APBIO-FRQ-S-063`: 2
- `APBIO-FRQ-S-064`: 2
- `APBIO-FRQ-S-066`: 2
- `APBIO-FRQ-S-068`: 3
- `APBIO-FRQ-S-070`: 2
- `APBIO-FRQ-S-071`: 2
- `APBIO-FRQ-S-073`: 1
- `APBIO-FRQ-S-074`: 1
- `APBIO-FRQ-S-076`: 1
- `APBIO-FRQ-S-080`: 2
- `APBIO-FRQ-S-081`: 2
- `APBIO-FRQ-S-084`: 2
- `APBIO-FRQ-S-085`: 1
- `APBIO-FRQ-S-086`: 2
- `APBIO-FRQ-S-087`: 2
- `APBIO-FRQ-S-089`: 3
- `APBIO-FRQ-S-090`: 2
- `APBIO-FRQ-S-094`: 1
- `APBIO-FRQ-S-095`: 2
- `APBIO-FRQ-S-097`: 2
- `APBIO-FRQ-S-099`: 1
- `APBIO-FRQ-S-101`: 1
- `APBIO-FRQ-S-102`: 1
- `APBIO-FRQ-S-103`: 1
- `APBIO-HDG-2026-GRAPH-002`: 1
- `APBIO-HDG-2026-GRAPH-003`: 1
- `APBIO-HDG-2026-GRAPH-008`: 2
- `APBIO-HDG-2026-GRAPH-010`: 2

## QA gate

This proposal requires independent AI cross-model QA and Product Owner approval under DECISION-0055 before any answer serves students.
