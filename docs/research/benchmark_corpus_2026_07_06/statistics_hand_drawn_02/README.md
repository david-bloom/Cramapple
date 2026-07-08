# Segmented Bar Graph for Homework App Use by Class Group

**Package:** `statistics_hand_drawn_02`
**Subject:** AP Statistics
**Answer type:** Hand-drawn graph response
**Source item:** `APSTATS-HDG-2026-GRAPH-002` (reused from the existing in-repo
hand-drawn item pool; question stem, data table, and capture instruction are
not new authoring)
**Archetype:** segmented_bar_graph_construction
**Version:** `v1.0-ai-provisional-2026-07-06`
**Created date:** 2026-07-06
**Label status:** `ai_provisional_unapproved` (Claude-authored draft; not reviewed or approved by Learning Quality)

## Purpose

This package is a benchmark-grade grading corpus spike input packet for a
single hand-drawn graph-response item. The question stem, data table, and
capture instruction are reused directly from the existing in-repo hand-drawn
item pool (see Source item above) rather than newly authored, per the agreed
plan to extend rather than duplicate that pool. This package adds the
missing layer on top: a condensed 4-criterion grading contract and a labeled
response set.

**Important limitation:** no real photographed student responses exist for
this item. Every "response" in this package is a textual description of
what a hypothetical drawn page would show, standing in for an actual
photograph. This is explicitly not the same as real hand-drawn capture data
and must not be represented as such downstream. See `label_validation.md`
for the explicit readiness statement.

## Files

- `README.md` -- this file.
- `hand_drawn_input_packet.md` -- question stem, data table, capture
  instruction, visual grading contract (4-criterion rubric), full response
  set, and the draft label matrix.
- `corpus.jsonl` -- one record per response, machine-readable.
- `label_validation.md` -- validation summary (counts, ID range, duplicate
  check, score/criterion distributions) and the readiness statement.

## Next step

Route this packet to Learning Quality (Orly) for a real review pass before
any use in benchmark execution or grader calibration. Real photographed
responses would also be needed before this package could support actual
visual-grading benchmark execution.
