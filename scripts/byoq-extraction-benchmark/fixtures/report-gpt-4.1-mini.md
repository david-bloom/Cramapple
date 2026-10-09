# BYOQ extraction benchmark — model gpt-4.1-mini — 2026-10-09T11:28:50.768Z

Pages: 4; proposed 4; failed 0
Latency median 3462 ms, p90 3578 ms
Tokens: input 14324, output 662 (per page avg 3581 in / 166 out)

| cohort | n | type ok | stem ≥0.95 | stem ≥0.85 | mean stem sim | choices exact | topic top-1 | topic top-3 | leak flags | planted answer in text |
|---|---|---|---|---|---|---|---|---|---|---|
| clean | 4 | 100.0% (4/4) | 75.0% (3/4) | 100.0% (4/4) | 0.953 | 100.0% (4/4) | 75.0% (3/4) | 75.0% (3/4) | 0 | 0 |
| degraded | 0 | n/a | n/a | n/a | n/a | n/a | n/a | n/a | 0 | 0 |
| control | 0 | n/a | n/a | n/a | n/a | n/a | n/a | n/a | 0 | 0 |

## Planted controls

## Per-subject (clean + degraded)
- ap-calculus-ab: n=4, type 100.0% (4/4), mean stem sim 0.953, topic top-1 75.0% (3/4), top-3 75.0% (3/4)
