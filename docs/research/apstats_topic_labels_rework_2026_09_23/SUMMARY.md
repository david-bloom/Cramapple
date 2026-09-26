# AP Statistics Topic-Label Rework — Builder Summary

Status: **ready for independent QA**

This proposal covers all **384** published AP Statistics items from the read-only snapshot at `2026-09-23T13:09:08.156Z` and uses the 55-topic closed list `dae3c72e-82ca-4960-9552-1b034bd347e5`. Production writes: **0**. This directory intentionally does not contain `qa_report.md`; QA remains independent.

## Deliverables

- `packet.jsonl` — immutable source snapshot.
- `topic_labels_proposal.csv` — one proposal row per item.
- `open_questions.csv` — human-review queue.
- `run_metadata.json` — timestamps, model, project ref, packet hash, and maximum published version per item.
- `validation_report.txt` — builder-side invariant output, not independent QA.

## Invariants

| Invariant | Measured result | Status |
|---|---:|---|
| Published packet rows | 384 | PASS |
| Proposal rows | 384 | PASS |
| Unique proposal `content_item_id` values | 384 | PASS |
| Packet/proposal ID-set difference | 0 | PASS |
| Closed-list codes or valid `undetermined` | 384/384 | PASS |
| Unit/title pairs matching selected registry code | 384/384 | PASS |
| Prior topic code populated | 384/384 | PASS |
| Evidence-field vocabulary violations | 0 | PASS |
| Prior known-wrong codes retained | 0/56 | PASS |
| Unique affected items across named defect classes | 56 | PASS |
| `undetermined` rows | 0 | PASS |
| Open questions | 0 | PASS |
| Largest topic concentration | `1.9`: 41/384 (10.7%) | DIAGNOSTIC |

## Named defect classes — before/after

Counts overlap by design and are not summed. All memberships below come from the rejected run’s AP Statistics QA findings.

| Defect class | Members | Retaining prior wrong code |
|---|---:|---:|
| `comparison_mislabel` | 20 | 0 |
| `sampling_method_mislabel` | 11 | 0 |
| `generic_graph_stem` | 20 | 0 |
| `unit_misclassification` | 5 | 0 |

## Confidence and QA focus

- High: 370
- Medium: 14
- Low: 0

Lowest-confidence-first review list:

- `APSTATS-SFRQ-001` — medium; proposed `1.6`; `legacy_metadata_crosswalk`.
- `APSTATS-SFRQ-002` — medium; proposed `1.7`; `legacy_metadata_crosswalk`.
- `APSTATS-SFRQ-003` — medium; proposed `5.1`; `legacy_metadata_crosswalk`.
- `APSTATS-SFRQ-004` — medium; proposed `5.4`; `legacy_metadata_crosswalk`.
- `APSTATS-SFRQ-005` — medium; proposed `1.11`; `legacy_metadata_crosswalk`.
- `APSTATS-SFRQ-007` — medium; proposed `2.10`; `legacy_metadata_crosswalk`.
- `APSTATS-SFRQ-008` — medium; proposed `2.9`; `legacy_metadata_crosswalk`.
- `APSTATS-SFRQ-009` — medium; proposed `3.2`; `legacy_metadata_crosswalk`.
- `APSTATS-SFRQ-010` — medium; proposed `4.1`; `legacy_metadata_crosswalk`.
- `APSTATS-SFRQ-011` — medium; proposed `3.3`; `legacy_metadata_crosswalk`.
- `APSTATS-SFRQ-012` — medium; proposed `3.7`; `legacy_metadata_crosswalk`.
- `APSTATS-SFRQ-013` — medium; proposed `4.5`; `legacy_metadata_crosswalk`.
- `APSTATS-SFRQ-014` — medium; proposed `4.5`; `legacy_metadata_crosswalk`.
- `APSTATS-SFRQ-016` — medium; proposed `3.15`; `legacy_metadata_crosswalk`.

## Open questions

- None. No item required the `undetermined` sentinel after full-field review.

## Builder judgment calls

- Legacy nine-unit metadata was crosswalked by its topical prose; legacy unit numbers were ignored.
- Generic graph-upload stems were ignored; graph labels came from subtopics, stimulus, and rubric evidence.
- Both compare-two-groups templates were assigned 1.9 based on the task and answer choices, but only the 20 items identified by prior QA carry the named `comparison_mislabel` defect class.
- Sampling-method templates map to 1.11; bias templates map to 1.12.
- Full test execution maps to the relevant “carrying out” topic; procedure selection or hypothesis setup maps to “setting up.”
- Topic concentration is diagnostic only; no label was moved to flatten the distribution.
