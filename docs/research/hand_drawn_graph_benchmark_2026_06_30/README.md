# Hand-Drawn Graph Benchmark - 2026-06-30

This package is the execution scaffold for the hand-drawn graph grading benchmark.
It combines the frozen 2026-06-30 synthetic corpus with the v0.1 trace-set challenge pages.

## Purpose

Validate hand-drawn response grading for:

1. Accuracy first
2. Speed second
3. Cost third

## Benchmark Shape

- Synthetic corpus: 150 items
- Synthetic split: 60 dev / 30 calibration / 30 holdout / 30 internal challenge
- Trace-set challenge: 150 items across the frozen trace packets
- Total benchmark records: 300

## Pass Thresholds

- Exact criterion-vector agreement >= 95%
- Minimum per-criterion F1 >= 90%
- False accept rate <= 2%
- False reject rate <= 5%
- p95 latency within product target
- Cost per accepted grade within budget target

## Output Files

- `benchmark_manifest.json`
- `benchmark_manifest.csv`

## Source Inputs

- `docs/research/hand_drawn_graph_corpus_2026_06_30/hand_drawn_graph_questions_2026_06_30.jsonl`
- `docs/research/hand_drawn_graph_corpus_2026_06_29/trace_sets/set_*/set_*_manifest.json`

## Notes

- The synthetic corpus is stratified by archetype before splitting.
- The trace-set pages are held out as a separate external challenge set.
- This package does not run model calls or score any results by itself.
