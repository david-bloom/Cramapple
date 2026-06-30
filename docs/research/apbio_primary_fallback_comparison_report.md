# AP Biology Primary/Fallback Diagnostic Comparison

**Status:** Generated aggregate report

This report compares the primary-only baseline, the fallback-only ceiling, and the primary-plus-fallback routing policy on the same nuanced synthetic AP Biology packet.

| Mode | Calls | Criterion accuracy | Strict rate | Fallback rate | p50 latency ms | p95 latency ms | Avg cost | Criterion correct / total |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| primary_only | 40 | 0.7250 | 0.6000 | 0.0000 | 1931.4 | 3236.3 | 0.000129 | 58 / 80 |
| fallback_only | 40 | 0.4000 | 0.4000 | 0.0000 | 3035.0 | 4122.7 | 0.002712 | 32 / 80 |
| primary_then_fallback | 40 | 0.5375 | 0.5250 | 0.6250 | 4665.9 | 6109.6 | 0.001506 | 43 / 80 |

## Routing Effect

- Primary-plus-fallback fixed 1 rows relative to primary-only.
- Primary-plus-fallback worsened 13 rows relative to primary-only.
- Primary-plus-fallback was unchanged on 26 rows relative to primary-only.
- Ambiguous rows escalated: 17 / 24.
- Clear rows escalated: 8 / 16.

## Difficulty Split

- clear: primary 32/32, hybrid 30/32
- borderline: primary 26/48, hybrid 13/48
