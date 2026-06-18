# Bio Reference Layer Exemplar Follow-up Report

**Status:** Generated aggregate report
**Run date:** 2026-06-17
**BM raw JSONL:** `/private/tmp/cramapple-bio-ref-spike/gate_results_2026-06-17.jsonl`
**BM-E raw JSONL:** `/private/tmp/cramapple-bio-ref-spike/exemplar_results_2026-06-17.jsonl`

## Summary

| Arm | Calls | Agreement | Avg cost | p50 latency sec | Avg input tokens | Avg output tokens | Avg reasoning tokens | Schema valid rate |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| BM medium/compact/no exemplars | 15 | 52/60 = 86.7% | $0.0197 | 9.01 | 554.3 | 565.7 | 285.8 | 100.0% |
| BM-E medium/compact/exemplars | 15 | 53/60 = 88.3% | $0.0246 | 10.65 | 1269.7 | 607.3 | 339.0 | 100.0% |

## Decision Notes

BM-E did not meet the success threshold for investing in a scored-FRQ retrieval
layer. It improved agreement by only one criterion call, from 52/60 to 53/60,
while increasing average input tokens by 715 and average reasoning tokens by
53.

The scored exemplars did move the targeted FRQ02-C2 issue in the expected
direction, reducing under-credit from 3 to 1. However, the same criterion also
picked up one new over-credit, so the net gain was modest. BM-E did not fix
the other targeted misses: FRQ01-C2 remained at 1 under-credit and FRQ03-C3
remained at 2 under-credits.

Interpretation: same-FRQ scored exemplars contain some calibration signal, but
the full four-sibling exemplar block is too blunt and too expensive as tested.
If this line continues, the next diagnostic should not be a larger exemplar
corpus. It should test a narrower targeted-precedent prompt or direct rubric
threshold rewrites for the recurring criteria.

## Deltas

- Agreement delta: +1 criterion calls.
- Average cost delta: +24.5%.
- p50 latency delta: +18.2%.
- Average reasoning-token delta: +53.2.
- Average input-token delta: +715.4.

## Quality Flags

### BM

- over_credit:FRQ01-C3: 1
- over_credit:FRQ03-C4: 1
- under_credit:FRQ01-C2: 1
- under_credit:FRQ02-C2: 3
- under_credit:FRQ03-C3: 2

### BM-E

- over_credit:FRQ01-C3: 1
- over_credit:FRQ02-C2: 1
- over_credit:FRQ03-C4: 1
- under_credit:FRQ01-C2: 1
- under_credit:FRQ02-C2: 1
- under_credit:FRQ03-C3: 2

## Paired Changes Versus BM

- Fixed BM errors: 2
- Introduced new errors: 1
- Unchanged response-level flag states: 12

| Question | Response | Fixed BM flags | Introduced BM-E flags |
| --- | --- | --- | --- |
| SPIKE-FRQ-02 | FRQ02-R1 | under_credit:FRQ02-C2 | - |
| SPIKE-FRQ-02 | FRQ02-R3 | - | over_credit:FRQ02-C2 |
| SPIKE-FRQ-02 | FRQ02-R4 | under_credit:FRQ02-C2 | - |

## Threshold Assessment

- Agreement at least 56/60: no.
- FRQ02-C2 under-credit at most 1: yes (1).
- FRQ01-C2 under-credit equal to 0: no (1).
- FRQ03-C3 under-credit at most 1: no (2).
- Schema validity 100%: yes.
- Input-token cost increase under 2x BM: no.
- p50 latency increase under 30%: yes.
