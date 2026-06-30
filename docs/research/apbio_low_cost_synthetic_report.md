# AP Biology Low-Cost Provider Pilot

**Status:** Generated aggregate report

**Raw JSONL:** `/private/tmp/cramapple-bio-ref-next/apbio_low_cost_synthetic_results.jsonl`

This pilot compares low-cost gateway models on the AP Biology short-FRQ held-out set using the 2-canonical-answer prompt configuration.

| Arm | Calls | Criterion accuracy | Strict success rate | p50 latency ms | p95 latency ms | Avg cost | Avg input tokens | Avg output tokens | Avg reference tokens | Avg cached tokens |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| deepseek/deepseek-v4-flash | 15.0000 | 0.8333 | 0.6667 | 6409.2661 | 10287.2304 | 0.0002 | 592.8000 | 649.0667 | 36.0000 | 401.0667 |
| alibaba/qwen3.5-flash | 15.0000 | 0.8333 | 0.8000 | 22008.4921 | 36502.8602 | 0.0017 | 433.5333 | 4053.0000 | 36.0000 | 0.0000 |

## Criterion-Level Comparison

| Arm | Correct / Total | Over-credit | Under-credit | Quality flags / call |
| --- | ---: | ---: | ---: | ---: |
| deepseek/deepseek-v4-flash | 25.0000 / 30.0000 | 0.0000 | 5.0000 | 0.3333 |
| alibaba/qwen3.5-flash | 25.0000 / 30.0000 | 0.0000 | 5.0000 | 0.3333 |
