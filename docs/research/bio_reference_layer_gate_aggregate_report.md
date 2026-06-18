# Bio Reference Layer Spike Aggregate Report

**Status:** Generated aggregate report

**Run date:** 2026-06-17
**Raw JSONL:** `/private/tmp/cramapple-bio-ref-spike/gate_results_2026-06-17.jsonl`
**Pricing assumption:** uncached `gpt-5.5` direct standard endpoint pricing.
No cached input tokens were reported in this run.

## Validation

No validation errors detected.

## Decision Notes

The gate sample supports stepping down from `gpt-5.5` high/current output to
`gpt-5.5` medium/compact output for cost and latency, but it does not yet
support investing in reference-card infrastructure as the causal lever.

Compared with Arm A (`gpt-5.5` high, current output, no cards):

- Arm BM (`gpt-5.5` medium, compact output, no cards) was 29.6% cheaper and
  25.4% faster at p50 latency.
- Arm C (`gpt-5.5` medium, compact output, verbose biology context) was 29.0%
  cheaper and 29.3% faster at p50 latency.
- Arm D (`gpt-5.5` medium, compact output, compact cards) was 26.0% cheaper
  and 28.8% faster at p50 latency.

Arm D clears the broad cost and latency thresholds versus Arm A, but it does
not beat the cheaper alternatives:

- Arm D was more expensive than Arm BM and Arm C.
- Arm D was slightly faster than Arm BM, but slightly slower than Arm C.
- Arm D, Arm C, and Arm BM had the same automated quality-flag profile:
  6 under-credit flags and 2 over-credit flags.
- On mechanism-heavy FRQs, Arm D-prime had the same quality-flag count as Arm D
  and slightly lower p50 latency, so mechanism-chain cards did not show a clear
  safety or quality advantage in this run.

Recommended interpretation: run a follow-up prompt/schema refinement against
the recurring criterion misses before authoring production reference cards.
The strongest near-term lever appears to be medium reasoning plus compact
output, not card structure.

## Automated Criterion Agreement

Agreement is computed against the confirmed Learning Quality labels by counting
criterion-level over-credit and under-credit flags. It is an automated
screening metric, not a substitute for manual review.

| Arm | Agreement |
| --- | ---: |
| arm_a_high_current_no_cards | 48 / 60 = 80.0% |
| arm_b_high_compact_no_cards | 50 / 60 = 83.3% |
| arm_bm_medium_compact_no_cards | 52 / 60 = 86.7% |
| arm_c_medium_verbose_context | 52 / 60 = 86.7% |
| arm_d_medium_compact_cards | 52 / 60 = 86.7% |
| arm_dprime_medium_cards_no_mechanism | 35 / 40 = 87.5% |

## Aggregate By Arm

| Arm | Calls | p50 latency ms | p95 latency ms | Avg initial cost | Avg full-attempt cost | Avg input tokens | Avg output tokens | Avg cached tokens | Schema valid rate | Retries |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| arm_a_high_current_no_cards | 15 | 12083.4930 | 26156.7188 | 0.0280 | 0.0280 | 554.2667 | 842.0000 | 0.0000 | 0.9333 | 0 |
| arm_b_high_compact_no_cards | 15 | 16734.9517 | 29611.8850 | 0.0237 | 0.0237 | 578.5333 | 694.4000 | 0.0000 | 0.9333 | 0 |
| arm_bm_medium_compact_no_cards | 15 | 9009.8993 | 12777.1431 | 0.0197 | 0.0197 | 554.2667 | 565.6667 | 0.0000 | 1.0000 | 0 |
| arm_c_medium_verbose_context | 15 | 8539.8249 | 16402.7254 | 0.0199 | 0.0199 | 664.2667 | 552.8000 | 0.0000 | 1.0000 | 0 |
| arm_d_medium_compact_cards | 15 | 8601.5947 | 16220.8221 | 0.0207 | 0.0207 | 738.2667 | 568.1333 | 0.0000 | 1.0000 | 0 |
| arm_dprime_medium_cards_no_mechanism | 10 | 9280.8680 | 11913.6418 | 0.0201 | 0.0201 | 681.3000 | 554.8000 | 0.0000 | 1.0000 | 0 |

## Quality Flags

### arm_a_high_current_no_cards

- over_credit:FRQ01-C3: 1
- over_credit:FRQ02-C4: 1
- over_credit:FRQ03-C2: 1
- over_credit:FRQ03-C4: 1
- under_credit:FRQ01-C1: 1
- under_credit:FRQ01-C2: 1
- under_credit:FRQ01-C3: 1
- under_credit:FRQ02-C2: 3
- under_credit:FRQ03-C3: 2

### arm_b_high_compact_no_cards

- over_credit:FRQ01-C3: 1
- over_credit:FRQ01-C4: 1
- over_credit:FRQ03-C4: 1
- under_credit:FRQ01-C2: 1
- under_credit:FRQ02-C2: 3
- under_credit:FRQ03-C1: 1
- under_credit:FRQ03-C3: 2

### arm_bm_medium_compact_no_cards

- over_credit:FRQ01-C3: 1
- over_credit:FRQ03-C4: 1
- under_credit:FRQ01-C2: 1
- under_credit:FRQ02-C2: 3
- under_credit:FRQ03-C3: 2

### arm_c_medium_verbose_context

- over_credit:FRQ01-C3: 1
- over_credit:FRQ03-C4: 1
- under_credit:FRQ01-C2: 1
- under_credit:FRQ02-C2: 3
- under_credit:FRQ03-C3: 2

### arm_d_medium_compact_cards

- over_credit:FRQ01-C3: 1
- over_credit:FRQ03-C4: 1
- under_credit:FRQ01-C2: 1
- under_credit:FRQ02-C2: 3
- under_credit:FRQ03-C3: 2

### arm_dprime_medium_cards_no_mechanism

- over_credit:FRQ01-C3: 1
- over_credit:FRQ03-C4: 1
- under_credit:FRQ01-C2: 1
- under_credit:FRQ03-C3: 2
