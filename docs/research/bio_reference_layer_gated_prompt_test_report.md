# Bio Reference Layer Gated Prompt Test Report

**Status:** Completed prompt optimization run
**Run Date:** 2026-06-17
**Raw Results:** `/private/tmp/cramapple-bio-ref-spike/frq02_gated_prompt_results_2026-06-17_network.jsonl`
**Question:** `SPIKE-FRQ-02` Bottleneck Drift and Genetic Diversity
**Criterion:** `FRQ02-C2` random/non-selective construction event
**Model:** `gpt-5.5`, medium reasoning, `store:false`

## Executive Summary

The gated prompt reduced strict C2 agreement by -5.0 percentage points versus BM-Control.

## Overall Results

| Arm | Strict agreement | Quality-only agreement | Strict misses | Quality flags | Under-credit | Over-credit | Schema valid | Timeouts | Avg cost | p50 latency | p95 latency | Avg input | Avg output | Avg reasoning |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| bm_control | 37/40 (92.5%) | 37/40 (92.5%) | 3 | 3 | 0 | 3 | 40/40 | 0 | $0.00662 | 2.84s | 11.45s | 343.8 | 163.2 | 91.3 |
| bm_gated | 35/40 (87.5%) | 35/40 (87.5%) | 5 | 5 | 0 | 5 | 40/40 | 0 | $0.01005 | 4.46s | 9.74s | 602.8 | 234.6 | 140.4 |

## By Human Label

| Human label | Arm | Strict agreement | Under-credit | Over-credit |
| --- | --- | ---: | ---: | ---: |
| earned | bm_control | 20/20 (100.0%) | 0 | 0 |
| earned | bm_gated | 20/20 (100.0%) | 0 | 0 |
| not_earned | bm_control | 17/20 (85.0%) | 0 | 3 |
| not_earned | bm_gated | 15/20 (75.0%) | 0 | 5 |

## Paired Changes vs BM-Control

- Control errors fixed: 0
- New errors introduced: 2
- Fixed response IDs: None
- Introduced response IDs: S010, S066

## Gate Audit

- `decision_gate=pass` and `status=earned`: 25
- `decision_gate=fail` and `status=not_earned`: 15
- Invariant violations: 0

## Interpretation

This test isolates prompt-agent optimization from reference retrieval. A useful gated prompt should reduce C2 over-credit without increasing under-credit, schema failures, cost, or latency.

The failure pattern is informative. The gated prompt did not violate its own
invariants; it found evidence quotes and then consistently awarded C2. The
introduced errors (`S010`, `S066`) came from treating "allele frequencies change
randomly" as sufficient for the construction-event randomness criterion.

The recurring control-and-gated errors (`S020`, `S028`, `S068`) reveal a
possible label/rubric-boundary mismatch. Those responses include phrases such
as "random survivors," "not because of natural selection," or "due to chance,
not because any plants were more fit." If Learning Quality still wants these
not-earned for C2, the criterion needs a sharper rule: random downstream allele
change is insufficient unless the response explicitly ties randomness to the
construction destruction/survival event.
