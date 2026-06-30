# AP Biology Low-Cost Provider Pilot

**Status:** Generated aggregate report

**Raw JSONL:** `/private/tmp/cramapple-bio-ref-nuanced/three_model_results.jsonl`

This pilot compares low-cost gateway models on the AP Biology short-FRQ held-out set using the 2-canonical-answer prompt configuration.

| Arm | Calls | Criterion accuracy | Strict success rate | p50 latency ms | p95 latency ms | Avg cost | Avg input tokens | Avg output tokens | Avg reference tokens | Avg cached tokens |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| deepseek/deepseek-v4-flash | 40.0000 | 0.7250 | 0.5250 | 5439.0645 | 9443.7282 | 0.0002 | 621.3000 | 612.7250 | 37.0000 | 454.4000 |
| alibaba/qwen3.5-flash | n/a | n/a | n/a | n/a | n/a | n/a | n/a | n/a | n/a | n/a |

## Criterion-Level Comparison

| Arm | Correct / Total | Over-credit | Under-credit | Quality flags / call |
| --- | ---: | ---: | ---: | ---: |
| deepseek/deepseek-v4-flash | 58.0000 / 80.0000 | 0.0000 | 22.0000 | 0.5500 |
| alibaba/qwen3.5-flash | n/a / n/a | n/a | n/a | n/a |
