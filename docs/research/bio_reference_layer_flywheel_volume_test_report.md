# Bio Reference Layer Flywheel Volume Test Report

**Status:** Completed first 100-answer online flywheel run
**Run Date:** 2026-06-17
**Raw Results:** `/private/tmp/cramapple-bio-ref-spike/frq02_flywheel_results_2026-06-17.jsonl`
**Question:** `SPIKE-FRQ-02` Bottleneck Drift and Genetic Diversity
**Model:** `gpt-5.5`, medium reasoning, compact output, `store:false`
**Shuffle Seed:** `20260617`

## Executive Summary

The 100-answer run completed successfully, but the online criterion-precedent flywheel did not improve grading quality. BM-Control produced 100 valid JSON responses; BM-Flywheel produced 99 valid JSON responses and one malformed response, which was conservatively scored as missed earned criteria. BM-Flywheel trailed BM-Control on total criterion agreement and did not show the expected final-50 improvement as the precedent library grew.

BM-Flywheel did not meet the protocol success threshold. It added input tokens, cost, and latency without a reliable quality gain. The most important interpretation is that this run validates the harness and rejects this specific retrieval/prompt design, not the broader idea of a scored-answer intelligence layer.

## Overall Results

| Arm | Agreement | Misses | Schema valid | Avg cost | p50 latency | p95 latency | Avg input | Avg output | Avg reasoning | Avg precedent tokens |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| bm_control | 381/400 (95.2%) | 19 | 100/100 | $0.01260 | 5.55s | 12.40s | 491.7 | 338.2 | 132.7 | 0.0 |
| bm_flywheel | 376/400 (94.0%) | 24 | 99/100 | $0.01790 | 6.00s | 15.37s | 1405.1 | 362.4 | 143.9 | 454.2 |

## Protocol Thresholds

| Threshold | Result | Pass? |
| --- | --- | ---: |
| Final-50 agreement delta >= +5 pp | -2.5 pp | No |
| Final-50 FRQ02-C2 under-credit at least 50% lower | control 6, flywheel 11 | No |
| No worse new overall flag pattern | control 19 misses, flywheel 24 | No |
| Schema validity 100% | control 100/100, flywheel 99/100 | No |
| p50 latency increase <30% | +8.1% | Yes |
| average cost increase <50% | +42.0% | Yes |

## Learning Curve

| Precedent library size | BM-Control agreement | BM-Flywheel agreement | Delta | Control misses | Flywheel misses |
| --- | ---: | ---: | ---: | ---: | ---: |
| 0-9 | 100.0% | 100.0% | +0.0 pp | 0 | 0 |
| 10-24 | 100.0% | 100.0% | +0.0 pp | 0 | 0 |
| 25-49 | 94.0% | 94.0% | +0.0 pp | 6 | 6 |
| 50-99 | 93.5% | 91.0% | -2.5 pp | 13 | 18 |

## Moving Windows

| Answer window | BM-Control agreement | BM-Flywheel agreement | Delta |
| --- | ---: | ---: | ---: |
| 1-10 | 100.0% | 100.0% | +0.0 pp |
| 11-20 | 100.0% | 100.0% | +0.0 pp |
| 21-30 | 97.5% | 92.5% | -5.0 pp |
| 31-40 | 92.5% | 92.5% | +0.0 pp |
| 41-50 | 95.0% | 100.0% | +5.0 pp |
| 51-60 | 95.0% | 90.0% | -5.0 pp |
| 61-70 | 95.0% | 92.5% | -2.5 pp |
| 71-80 | 100.0% | 95.0% | -5.0 pp |
| 81-90 | 87.5% | 87.5% | +0.0 pp |
| 91-100 | 90.0% | 90.0% | +0.0 pp |

## Final 50 Answers

| Arm | Agreement | Misses | Avg cost | p50 latency | Avg reasoning |
| --- | ---: | ---: | ---: | ---: | ---: |
| bm_control | 187/200 (93.5%) | 13 | $0.01280 | 5.67s | 144.3 |
| bm_flywheel | 182/200 (91.0%) | 18 | $0.01768 | 6.38s | 138.0 |

## Error Pattern

| Criterion | Control under | Flywheel under | Control over | Flywheel over |
| --- | ---: | ---: | ---: | ---: |
| FRQ02-C1 | 1 | 2 | 0 | 0 |
| FRQ02-C2 | 7 | 13 | 3 | 3 |
| FRQ02-C3 | 0 | 0 | 7 | 5 |
| FRQ02-C4 | 0 | 0 | 1 | 1 |

## Paired Changes

- Flags fixed by flywheel: 2
- New flags introduced by flywheel: 7
- Responses improved: 2
- Responses worsened: 6
- Responses unchanged by flag count: 92

Fixed flags:

S063:over_credit:FRQ02-C3, S065:over_credit:FRQ02-C3

Introduced flags:

S008:under_credit:FRQ02-C1, S008:under_credit:FRQ02-C2, S017:under_credit:FRQ02-C2, S054:under_credit:FRQ02-C2, S057:under_credit:FRQ02-C2, S070:under_credit:FRQ02-C2, S098:under_credit:FRQ02-C2

## Interpretation

This run supports three narrow conclusions:

1. The flywheel harness is working: it processed 100 answers, used only prior approved labels as precedents, resumed safely, and produced complete measurements.
2. The current criterion-precedent retrieval design is not enough. It neither improved final-50 agreement nor reduced `FRQ02-C2` under-credit in the online setting.
3. The generated corpus is too easy and full-credit-heavy for a strong learning-curve decision. It is useful for validating mechanics, but the low miss rate leaves little headroom for a volume flywheel to demonstrate compounding improvement.

The next test should either use a deliberately harder/borderline corpus for `FRQ02-C2`, or add an oracle-retrieval diagnostic to separate retrieval failure from prompt-use failure.

Note: the single malformed flywheel response was `S008` at sequence 29. Its empty parsed status object was treated as under-credit on the earned criteria, which is the same conservative scoring rule used elsewhere in the reference-layer spike.
