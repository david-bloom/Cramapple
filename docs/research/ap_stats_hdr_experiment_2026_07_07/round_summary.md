# AP Stats HDR Round Summary - 2026-07-07

This is the second pass on the 12 photographed AP Statistics hand-drawn responses, using the tightened 4-criterion contract and normalized criterion-key parsing.

## Outcome

| Arm | Schema Valid | Exact Match | Criterion Acc | P50 Latency ms | Avg Cost USD |
| --- | ---: | ---: | ---: | ---: | ---: |
| VISION_FAST | 1.0000 | 0.2500 | 0.4583 | 4979.4012 | 0.0040 |
| VISION_ACCURACY | 0.5833 | 0.1667 | 0.2292 | 10786.4295 | 0.0187 |
| VISION_FAST_ESC | 1.0000 | 0.2500 | 0.4375 | 12796.5180 | 0.0274 |

## Comparison to 2026-07-06

- `VISION_FAST` improved on criterion accuracy and latency, and the normalized parser now shows all rows schema-valid.
- `VISION_ACCURACY` improved after normalization, but remains slow and expensive.
- `VISION_FAST_ESC` improved in exact match and criterion accuracy, but the escalation path is still too expensive for the target.

## Interpretation

- The revised contract helped the grader make cleaner distinctions on some borderline items.
- The remaining failures are still dominated by image-analysis misses on graph-family confusion and a smaller set of parse failures in the accuracy arm.
- This round is better than the prior one for rubric clarity, but it is still not production-ready against the current targets.
