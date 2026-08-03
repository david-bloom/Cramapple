# Hand-Drawn Graph Benchmark Report

Total rows: 150

## By Arm

| Arm | Count | Schema Valid | Exact Match | Criterion Acc | False Accept | False Reject | Abstention | P50 Latency ms | P95 Latency ms | Avg Cost USD |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| VISION_FAST_ESC | 150 | 1 | 0.9733 | 0.9948 | 0 | 0.0052 | 0 | 3392.3236 | 7844.0605 | 0.0039 |

## Notes

- Exact match is strict dictionary equality on the criterion-status map.
- False accept and false reject are computed only where a gold criterion status exists.
- Per-criterion F1 is included in the JSON output only and can be extended into a separate detail table later.
