# AP Biology Low-Cost Synthetic Scale-Up Comparison

**Status:** Generated aggregate report

This report compares DeepSeek and `gpt-4o-mini` on the same 10-packet synthetic AP Biology set.

## Model Summary

| Model | Calls | Criterion accuracy | Exact match rate | p50 latency ms | p95 latency ms | Avg cost | Criterion correct / total |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| deepseek/deepseek-v4-flash | 40 | 1.0000 | 1.0000 | 4675.0 | 6311.1 | 0.000195 | 80 / 80 |
| openai/gpt-4o-mini | 40 | 1.0000 | 1.0000 | 2603.5 | 3710.8 | 0.000117 | 80 / 80 |

## Overlap

- Both correct: 80
- DeepSeek only correct: 0
- gpt-4o-mini only correct: 0
- Neither correct: 0

## Key Takeaway

- Over all 80 criteria, DeepSeek was correct on 80 and gpt-4o-mini was correct on 80.
- If the disagreement count stays healthy at this scale, the two-model side-by-side path remains plausible.
