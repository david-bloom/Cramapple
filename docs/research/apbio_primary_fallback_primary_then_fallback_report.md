# AP Biology Primary/Fallback Diagnostic

**Status:** Generated aggregate report

**Raw JSONL:** `/private/tmp/cramapple-bio-ref-nuanced/primary_then_fallback.jsonl`

Primary model: `openai/gpt-4o-mini`
Fallback model: `openai/gpt-5.5`
Escalation threshold: `0.9`

| Mode | Calls | Criterion accuracy | Fallback rate | p50 latency ms | p95 latency ms | Avg cost | Criterion correct / total |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| primary_then_fallback | 40 | 0.5375 | 0.6250 | 4665.9 | 6109.6 | 0.001506 | 43 / 80 |
