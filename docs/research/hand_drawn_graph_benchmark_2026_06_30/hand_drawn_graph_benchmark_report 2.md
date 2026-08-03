# Hand-Drawn Graph Benchmark Report

Total rows: 90

## By Arm

| Arm | Count | Schema Valid | Exact Match | Criterion Acc | False Accept | False Reject | Abstention | P50 Latency ms | P95 Latency ms | Avg Cost USD |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| VISION_ACCURACY | 30 | 0 | 0 | 0 | 0 | 0 | 0 | 6418.1189 | 8729.7981 | 0 |
| VISION_FAST | 30 | 1 | 0.9667 | 0.9957 | 0 | 0.0043 | 0 | 3925.81 | 6726.1897 | 0.0039 |
| VISION_FAST_ESC | 30 | 1 | 1 | 1 | 0 | 0 | 0 | 3257.1102 | 6325.9946 | 0.0039 |

## Notes

- Exact match is strict dictionary equality on the criterion-status map.
- False accept and false reject are computed only where a gold criterion status exists.
- Per-criterion F1 is included in the JSON output only and can be extended into a separate detail table later.
