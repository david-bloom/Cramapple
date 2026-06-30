# AP Biology Short-FRQ Canonical Answer Ablation

**Status:** Generated aggregate report

**Raw JSONL:** `/private/tmp/cramapple-bio-ref-spike/apbio_short_frq_canonical_ablation_results.jsonl`
**Model:** `gpt-5.5`
**Reasoning effort:** medium

## Summary

This run compares 0, 1, and 2 canonical-answer variants on the AP Biology short-FRQ held-out set from the spike packet.
Quality is the first decision axis; speed and cost are reported after that.

| Arm | Calls | Criterion accuracy | Strict success rate | p50 latency ms | p95 latency ms | Avg cost | Avg input tokens | Avg output tokens | Avg reference tokens | Avg cached tokens |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 0 canonical answers | 15 | 0.8167 | 0.5333 | 7077.4438 | 9974.3017 | 0.0212 | 524.2667 | 618.6000 | 7.0000 | 0.0000 |
| 1 canonical answer | 15 | 0.8167 | 0.5333 | 6254.3290 | 11802.0428 | 0.0206 | 560.6000 | 594.7333 | 30.6667 | 0.0000 |
| 2 canonical answers | 15 | 0.8667 | 0.5333 | 6610.7237 | 9992.5000 | 0.0214 | 596.6000 | 613.1333 | 55.3333 | 0.0000 |

## Criterion-Level Comparison

| Arm | Correct / Total | Over-credit | Under-credit | Quality flags / call |
| --- | ---: | ---: | ---: | ---: |
| 0 canonical answers | 49 / 60 | 2 | 8 | 0.6667 |
| 1 canonical answer | 49 / 60 | 2 | 8 | 0.6667 |
| 2 canonical answers | 52 / 60 | 2 | 6 | 0.5333 |

## Interpretation

- Baseline (`0 canonical answers`) criterion accuracy: 0.8167.
- 1 canonical answer vs baseline: criterion accuracy 0.8167, strict success 0.5333, avg cost 0.0206.
- 2 canonical answers vs baseline: criterion accuracy 0.8667, strict success 0.5333, avg cost 0.0214.

## Notes

- Canonical answers were treated as boundary memory, not extra rubric.
- The next promotion decision should prefer the smallest canonical count that improves criterion accuracy without increasing over-credit.
