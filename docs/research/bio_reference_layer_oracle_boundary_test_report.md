# Bio Reference Layer Oracle Boundary-Memory Test Report

**Status:** Completed diagnostic run
**Run Date:** 2026-06-17
**Raw Results:** `/private/tmp/cramapple-bio-ref-spike/frq02_oracle_boundary_results_2026-06-17_network.jsonl`
**Question:** `SPIKE-FRQ-02` Bottleneck Drift and Genetic Diversity
**Criterion:** `FRQ02-C2` random/non-selective construction event
**Model:** `gpt-5.5`; medium reasoning except `boundary_table_low` uses low reasoning; `store:false`

## Executive Summary

On a strict production-style metric where malformed or timed-out calls count as misses, the diagnostic did not find a memory intervention that beats the no-memory control. The oracle-precedent arm improved quality-only C2 decisions when it returned valid JSON, but it was slower, less schema-reliable, and did not beat BM-Control operationally.
Quality-only diagnostic signal: `oracle_precedents` improved valid-decision C2 agreement by +5.0 percentage points versus BM-Control before penalizing schema/timeouts.

## Decision

Do not proceed with the current exemplar-in-prompt memory design as a production
path. It is not faster, cheaper, or more reliable than BM-Control.

The useful signal is narrower: oracle-selected scored precedents fixed three
control over-credit errors (`S028`, `S068`, `S082`), which means scored examples
can contain real calibration information. However, the same arm introduced one
quality error (`S050`) and three operational failures (`S007`, `S067`, `S088`).

The next test should move the calibration signal out of bulky retrieved
examples and into the grader agent itself: explicit criterion decision gates,
short required evidence extraction, and a strict valid-JSON retry path.

## Overall Results

| Arm | Strict agreement | Quality-only agreement | Strict misses | Quality flags | Under-credit | Over-credit | Schema valid | Avg cost | p50 latency | p95 latency | Avg input | Avg output | Avg reasoning | Avg precedents |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| bm_control | 36/40 (90.0%) | 36/40 (90.0%) | 4 | 4 | 0 | 4 | 40/40 | $0.00722 | 2.83s | 11.72s | 344.8 | 183.3 | 109.0 | 0.0 |
| oracle_precedents | 35/40 (87.5%) | 38/40 (95.0%) | 5 | 2 | 1 | 1 | 37/40 | $0.01083 | 5.89s | 120.04s | 1230.4 | 156.1 | 82.8 | 6.0 |
| boundary_table | 34/40 (85.0%) | 34/40 (85.0%) | 6 | 6 | 0 | 6 | 40/40 | $0.00682 | 2.65s | 7.37s | 500.8 | 143.9 | 71.3 | 0.0 |
| boundary_table_low | 35/40 (87.5%) | 35/40 (87.5%) | 5 | 5 | 0 | 5 | 40/40 | $0.00530 | 2.02s | 5.12s | 500.8 | 93.3 | 18.6 | 0.0 |

## By Human Label

| Human label | Arm | Agreement | Under-credit | Over-credit |
| --- | --- | ---: | ---: | ---: |
| earned | bm_control | 20/20 (100.0%) | 0 | 0 |
| earned | oracle_precedents | 19/20 (95.0%) | 1 | 0 |
| earned | boundary_table | 20/20 (100.0%) | 0 | 0 |
| earned | boundary_table_low | 20/20 (100.0%) | 0 | 0 |
| not_earned | bm_control | 16/20 (80.0%) | 0 | 4 |
| not_earned | oracle_precedents | 16/20 (80.0%) | 0 | 1 |
| not_earned | boundary_table | 14/20 (70.0%) | 0 | 6 |
| not_earned | boundary_table_low | 15/20 (75.0%) | 0 | 5 |

## Paired Changes vs BM-Control

### oracle_precedents

- Control errors fixed: 3
- New errors introduced: 4
- Fixed response IDs: S028, S068, S082
- Introduced response IDs: S007, S050, S067, S088

### boundary_table

- Control errors fixed: 0
- New errors introduced: 2
- Fixed response IDs: None
- Introduced response IDs: S010, S067

### boundary_table_low

- Control errors fixed: 0
- New errors introduced: 1
- Fixed response IDs: None
- Introduced response IDs: S010

## Interpretation Guide

- If `oracle_precedents` wins, scored examples contain useful signal and the prior flywheel failure was mainly retrieval/prompt design.
- If `boundary_table` wins, compact distilled rubric-boundary memory is better than exemplar retrieval for this criterion.
- If `boundary_table_low` matches or beats BM-Control while cheaper/faster, memory may support a lower-reasoning production path.
- If no arm beats BM-Control, the next lever is likely grader-agent/prompt optimization rather than a reference layer for this criterion.
