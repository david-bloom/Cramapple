# AP Biology FRQ Canonical-Answer Segmentation — Codex Run

Date: 2026-09-22

Mode: proposal only. Production was read-only; no published content was
changed. This revision implements the corrected work order that requires both
`canonical_answer_1` and `canonical_answer_2` to be read and reused before
any new span is drafted.

## Outputs

- `apbio_frq_packets.jsonl`: the shared, model-neutral packet for all 75
  published Biology FRQs.
- `apbio_frq_segmentation.codex.jsonl`: the packet fields plus the Codex
  proposal for `canonical_answer`, `credited_response`, provenance-aware
  coverage, flags, and human-review status.

The packet was derived from Production project `pcntajvbdfqhbeewmdry`, using
the latest published `public.content_item_versions` row per Biology FRQ and
its stored `public.frq_criteria` rows.

## Live scope and outcomes

| Measure | Count |
| --- | ---: |
| Latest published Biology FRQs | 75 |
| Nonblank `canonical_answer_1` | 68 |
| Nonblank `canonical_answer_2` | 52 |
| Neither canonical field present | 7 |
| Combined existing corpus segmented without drafted content | 27 |
| Combined existing corpus completed with drafted gaps | 41 |
| Fully drafted answers | 7 |
| Records with every criterion mapped to at least one span | 75 |
| Records whose spans concatenate exactly to `canonical_answer.full_text` | 75 |
| Records with empty `frq_criteria` | 0 |
| Records marked `needs_human: true` | 64 |

The work order's scope assumptions—75 published FRQs, 68 primary answers, and
7 items without a primary answer—match Production exactly. A final drift check
also found no differences between Production and the packet in version IDs,
either canonical-answer field, criterion counts, or rubric point sums.

## Criterion provenance

There are 278 item/criterion pairs. The following provenance counts are
nonexclusive because a criterion can contain useful existing evidence and
still require a drafted completion, or can be supported by both canonical
fields:

| Provenance | Item/criterion pairs |
| --- | ---: |
| Reused evidence from `canonical_answer_1` | 122 |
| Reused evidence from `canonical_answer_2` | 51 |
| Distinct criteria with evidence from either existing field | 166 |
| Criteria requiring at least one drafted span | 118 |

Every segmentation record additionally carries:

- `coverage.criteria_from_canonical_answer_1`
- `coverage.criteria_from_canonical_answer_2`
- `coverage.criteria_drafted`

Existing spans carry a `source_field`; newly authored spans retain
`drafted: true` and use `source_field: "drafted"`.

## Why 64 records need human review

Reasons overlap within individual records.

| Reason | Count | Meaning |
| --- | ---: | --- |
| Drafted coverage completion | 41 | After checking both canonical fields, one or more rubric gaps remained. |
| Fully drafted written answer | 3 | `APBIO-FRQ-S-101`, `-102`, and `-103` had neither canonical field. |
| Drawn response not representable as text | 4 | Visible plotted/drawn marks require a spatial canonical. |
| Prompt/rubric point mismatch | 9 | `prompt_json.total_points` is 8 while the stored rubric sums to 9. |
| Cross-criterion entanglement | 23 | Existing sentence-level wording combines multiple criteria, so hiding one span can leave a connective or punctuation artifact. |
| Answer-2/rubric misalignment | 15 | The second canonical is preserved verbatim but does not directly satisfy a stored criterion. |
| Existing field-order conflict | 1 | `APBIO-FRQ-S-036` contains b evidence before an a2 clause inside `canonical_answer_2`; preserving that field verbatim prevents perfect question order. |

Eleven records are clean existing-answer segmentations without a review flag:
`APBIO-FRQ-L-003`, `-008`, `-014`, `-026`, `-030`, `-031`, `-036`,
`APBIO-FRQ-S-003`, `-006`, `-029`, and `-031`.

## Point-total findings

These nine items have `prompt_json.total_points = 8`, but their stored
`frq_criteria.points_possible` values sum to 9:

- `APBIO-FRQ-L-004`
- `APBIO-FRQ-L-006`
- `APBIO-FRQ-L-012`
- `APBIO-FRQ-L-013`
- `APBIO-FRQ-L-015`
- `APBIO-FRQ-L-016`
- `APBIO-FRQ-L-017`
- `APBIO-FRQ-L-019`
- `APBIO-FRQ-L-021`

The segmentation follows every stored criterion and does not attempt to
resolve the metadata conflict.

## `canonical_answer_2` findings

All 52 nonblank second canonicals are preserved verbatim in their assembled
answers. Fifteen are related Biology content but do not directly answer any
stored rubric criterion:

`APBIO-FRQ-S-021`, `-025`, `-026`, `-028`, `-032`, `-033`, `-040`,
`-051`, `-052`, `-058`, `-066`, `-071`, `-081`, `-086`, and
`-097`.

They remain as uncredited existing context rather than being discarded or
silently relabeled. The actual rubric gaps receive explicit drafted spans and
the records are flagged for human review.

## Drawn-response findings

The following items contain criteria that require an actual graph rather than
prose:

- `APBIO-HDG-2026-GRAPH-002`: common-scale boxplots and recoverable
  five-number summaries.
- `APBIO-HDG-2026-GRAPH-003`: two complete labeled segmented bars.
- `APBIO-HDG-2026-GRAPH-008`: a scaled dotplot with the correct dot counts.
- `APBIO-HDG-2026-GRAPH-010`: plotted ordered pairs, labeled axes, and a
  trend line.

Their proposed spans state exactly what must be drawn and include the written
comparisons, but `creditedResponse` text alone cannot be a full-credit spatial
canonical. A governed spatial representation remains necessary.

## Validation performed

- Recomputed every concatenation from the emitted spans.
- Confirmed every stored criterion key has at least one span.
- Confirmed no span invents a criterion outside the item's Production rubric.
- Confirmed each nonblank canonical field appears verbatim in the assembled
  answer for its item.
- Confirmed packet fields are unchanged between the shared packet and Codex
  segmentation files.
- Confirmed removing any one criterion's spans never empties the whole answer.
- Recorded known semantic/removal risks as flags instead of rewriting governed
  existing content.

This is an authoring proposal, not validated content. It requires the separate
AI comparison/adversarial QA described in the work order and human ratification
under the double-approval governance rule.
