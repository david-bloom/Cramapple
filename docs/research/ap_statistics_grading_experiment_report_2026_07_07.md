# AP Statistics Grading Experiment Report

**Run key:** `ap_statistics_grading_experiment_2026_07_07`
**Phase:** `boundary`
**Corpus version:** `ap_statistics_frq_v1_2026_07_07`
**Cases:** 40
**Model calls:** 120

## Corpus Slice

- `boundary` = long investigative-task items only.
- `full` = all 100 FRQs and 220 synthetic responses.

## Arm Summary

| Arm | Calls | Schema Valid | Boundary Valid | p50 Latency ms | p95 Latency ms | Avg Cost USD | Avg Score | Avg Max Score |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| apstats_fast | 40 | 0 | 0 | 5701.7091 | 8739.8092 | 0.0004 | n/a | 3.5 |
| apstats_balanced | 40 | 0.925 | 0.925 | 9994.5168 | 16532.349 | 0.0251 | 1.8919 | 3.5 |
| apstats_strict | 40 | 0.65 | 0.65 | 12796.4015 | 16359.9828 | 0.0306 | 1.6154 | 3.5 |

## Comparison

| Arm | Baseline Agreement | Shared Cases | Confidence Mix |
| --- | ---: | ---: | --- |
| apstats_fast | n/a | 40 | {"unknown": 40} |
| apstats_balanced | 0.075 | 40 | {"high": 14, "low": 1, "medium": 22, "unknown": 3} |
| apstats_strict | 0.35 | 40 | {"high": 12, "medium": 14, "unknown": 14} |

## Interpretation

- The boundary phase is the first calibration gate and should be reviewed before the full-corpus scale run.
- Treat `codex.frq_subtype = investigative_task` as the canonical AP Statistics long-form filter.
- Use the baseline arm to detect criterion-vector drift before promoting any prompt or model change.

## Notes

- This report compares model arms only; it does not require a human gold set.
- Exact agreement here is between model arms on the same synthetic response, not against external correctness labels.
