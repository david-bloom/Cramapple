# FRQ02 Generated Answer Corpus Validation

**Status:** Generated answer corpus labeled and approved for flywheel test use
**Created Date:** 2026-06-17
**Source File:** `AP_BIO_STUDENT_ANSWERS.txt`
**Cleaned Raw JSONL:** `/private/tmp/cramapple-bio-ref-spike/frq02_generated_answers_raw.jsonl`
**Provisional Labels:** `docs/research/frq02_generated_answer_labels_codex_provisional.jsonl`
**Related Protocol:** `docs/research/BIO_REFERENCE_LAYER_FLYWHEEL_VOLUME_TEST_PROTOCOL.md`

## Summary

The generated answer file is structurally usable as a source of fresh synthetic
FRQ02 answers, but it is not ready to drive the flywheel test until
criterion-level labels are created.

Validation results:

| Check | Result |
| --- | --- |
| Parsed response records | `100` |
| Response ID range | `S001` through `S100` |
| Missing IDs | none |
| Exact duplicate answer texts | none |
| Average answer length | about `56` words |
| File format | reparsable by `S###` record markers; not safe as simple one-line TSV because some answers contain paragraph breaks |

Generation target distribution:

| Generation target | Count |
| --- | ---: |
| `0` | `12` |
| `1` | `22` |
| `2` | `35` |
| `3` | `20` |
| `4` | `11` |

This is usable as a rough bell-shaped generation distribution, though it is not
the originally suggested exact bucket distribution.

## Important Label Warning

The `target_score` field is a generation hint only. It must not be used as a
ground-truth score or criterion label.

Several low-target rows appear substantively higher-scoring under the FRQ02
rubric. Examples flagged by heuristic review include:

- `S010`
- `S012`
- `S013`
- `S014`
- `S015`

These answers mention genetic drift or bottleneck, random/non-selective
sampling, reduced diversity, and allele loss/chance logic. They may earn far
more than their generated target score suggests.

## Approved Label Summary

Codex created criterion-level labels, reviewer notes, and boundary tags for
all 100 responses. Orly / Learning Quality approved the labels on 2026-06-17.

Labeled point distribution:

| Labeled points | Count |
| --- | ---: |
| `0` | `10` |
| `1` | `14` |
| `2` | `4` |
| `3` | `10` |
| `4` | `62` |

Criterion-level distribution:

| Criterion | Earned | Not earned |
| --- | ---: | ---: |
| `FRQ02-C1` | `89` | `11` |
| `FRQ02-C2` | `69` | `31` |
| `FRQ02-C3` | `69` | `31` |
| `FRQ02-C4` | `73` | `27` |

Important implication: the generated corpus is heavily skewed toward
full-credit answers after actual rubric labeling. It is usable for early
flywheel mechanics, but not ideal for a clean learning-curve test unless more
borderline and low-credit responses are added. The most depleted bucket is
2-point answers.

## Readiness

Ready:

- use as a Learning Quality-approved synthetic ground-truth corpus;
- run duplicate and boundary-tag review;
- run the FRQ02 flywheel volume test.

Not ready:

- use for learner-facing production grading;
- use with real student-response retrieval before privacy/consent policy work;
- run the flywheel measurement using `target_score` as label.

## Required Next Step

Use the approved criterion-level labels:

```text
FRQ02-C1: earned | not_earned | unable_to_determine
FRQ02-C2: earned | not_earned | unable_to_determine
FRQ02-C3: earned | not_earned | unable_to_determine
FRQ02-C4: earned | not_earned | unable_to_determine
reviewer_note
boundary_tags
```

The `target_score` field remains a generation hint only and must not be used as
the measurement label.
