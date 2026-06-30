# AP Biology Low-Cost Provider Pilot

**Status:** Generated aggregate report

**Raw JSONL:** `/private/tmp/cramapple-bio-ref-scale10/deepseek_results.jsonl`

This pilot compares low-cost gateway models on the AP Biology short-FRQ held-out set using the 2-canonical-answer prompt configuration.

| Arm | Calls | Criterion accuracy | Strict success rate | p50 latency ms | p95 latency ms | Avg cost | Avg input tokens | Avg output tokens | Avg reference tokens | Avg cached tokens |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| deepseek/deepseek-v4-flash | 40.0000 | 1.0000 | 1.0000 | 4675.0013 | 6311.1117 | 0.0002 | 641.1250 | 499.5000 | 37.6000 | 252.8000 |
| alibaba/qwen3.5-flash | n/a | n/a | n/a | n/a | n/a | n/a | n/a | n/a | n/a | n/a |

## Criterion-Level Comparison

| Arm | Correct / Total | Over-credit | Under-credit | Quality flags / call |
| --- | ---: | ---: | ---: | ---: |
| deepseek/deepseek-v4-flash | 80.0000 / 80.0000 | 0.0000 | 0.0000 | 0.0000 |
| alibaba/qwen3.5-flash | n/a / n/a | n/a | n/a | n/a |
