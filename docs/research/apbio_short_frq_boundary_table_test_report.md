# AP Biology Short-FRQ Boundary Specificity Test

**Status:** Generated aggregate report

**Raw JSONL:** `/private/tmp/cramapple-bio-ref-spike/apbio_short_frq_boundary_table_test_results.jsonl`
**Model:** `gpt-5.5`
**Reasoning effort:** medium

## Summary

This run compares the winning 2-canonical-answer configuration against a compact boundary-table rewrite on the same AP Biology short-FRQ corpus.

| Arm | Calls | Criterion accuracy | Strict success rate | p50 latency ms | p95 latency ms | Avg cost | Avg input tokens | Avg output tokens | Avg reference tokens | Avg cached tokens |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 2 canonical answers | 15 | 0.8167 | 0.5333 | 6771.5637 | 12216.1333 | 0.0213 | 577.6000 | 613.3333 | 55.3333 | 0.0000 |
| Boundary table | 15 | 0.7500 | 0.4667 | 7329.1781 | 12009.0626 | 0.0238 | 732.6000 | 670.8000 | 144.3333 | 0.0000 |

## Criterion-Level Comparison

| Arm | Correct / Total | Over-credit | Under-credit | Quality flags / call |
| --- | ---: | ---: | ---: | ---: |
| 2 canonical answers | 49 / 60 | 2 | 8 | 0.6667 |
| Boundary table | 45 / 60 | 3 | 10 | 0.8667 |

## Interpretation

- Baseline (`2 canonical answers`) criterion accuracy: 0.8167.
- Boundary table criterion accuracy: 0.7500.
- Boundary table strict success: 0.4667.
- Boundary table avg cost: 0.0238.

## Notes

- If the boundary table matches canonical answers on accuracy, it is the cheaper specificity mechanism to prefer next.
- If it loses quality, the canonical answers are carrying information the boundary table did not preserve.
