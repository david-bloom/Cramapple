# AP Statistics Grading Experiment Report Template

**Run key:** `ap_statistics_grading_experiment_2026_07_07`
**Phase:** `boundary | full`
**Corpus version:** `ap_statistics_frq_v1_2026_07_07`

## Overview

- Corpus slice:
  - boundary: 10 long investigative-task FRQs
  - full: 100 FRQs, 220 synthetic responses
- Model arms:
  - `apstats_fast`
  - `apstats_balanced`
  - `apstats_strict`
- Routing note:
  - short FRQs -> fast path
  - `codex.frq_subtype = investigative_task` or borderline responses -> strict path

## Results Table

| Arm | Calls | Schema Valid | Boundary Valid | p50 Latency ms | p95 Latency ms | Avg Cost USD | Avg Score | Avg Max Score |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| apstats_fast | n/a | n/a | n/a | n/a | n/a | n/a | n/a | n/a |
| apstats_balanced | n/a | n/a | n/a | n/a | n/a | n/a | n/a | n/a |
| apstats_strict | n/a | n/a | n/a | n/a | n/a | n/a | n/a | n/a |

## Comparison

| Arm | Baseline Agreement | Shared Cases | Confidence Mix |
| --- | ---: | ---: | --- |
| apstats_fast | n/a | n/a | {} |
| apstats_balanced | n/a | n/a | {} |
| apstats_strict | n/a | n/a | {} |

## What To Summarize

- Which arm has the best schema validity.
- Whether the boundary slice is stable enough to expand.
- Where confidence is too high or too low relative to disagreement.
- Whether the strict arm actually improves criterion-vector agreement.
- Whether speed gains justify any loss in agreement.
- How many cases would route to fast, balanced, or strict.

## Interpretation Rule

Treat the baseline arm as the default grading behavior and only promote a changed arm if it improves agreement or clarity without creating new over-credit risk.
