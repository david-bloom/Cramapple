# AP Statistics HDR Trace-Ready Results — 2026-07-07

Synthetic trace-ready results for all **40 published** AP Statistics hand-drawn-response
(HDR) items in Supabase (`APSTATS-HDG-2026-GRAPH-001` through `-040`, `app.content_items`,
all `frq/short`, `hand_drawn: true`, `status: published`).

## Why this exists

A direct Supabase query on 2026-07-07 found these 40 production HDR items have **zero**
existing photographed/graded trace results. Prior research packets
(`ap_stats_hand_drawn_corpus_2026_07_06`, `ap_stats_hdr_experiment_2026_07_06/07`,
`hand_drawn_graph_corpus_2026_06_30/trace_sets`) all used disconnected item IDs
(`IMG-70XX`, `HDR-0XX`) from earlier prototyping and never mapped onto these 40
production rows.

Real photographed hand-drawn pages aren't producible in this environment (no
camera/image-capture tool), so — per an explicit scope decision — these are
**programmatically rendered, xkcd-style sketch images** standing in for real
hand-drawn responses: same role the text `synthetic_responses` play for text FRQs
(see `ap_statistics_frq_bootstrap_corpus_2026_07_07.json`), just for the
image-based HDR item type.

## Contents

- `images/` — 120 PNGs (40 items × 3 tiers)
- `gold_labels.jsonl` — 120 records, one per image, with per-criterion
  `earned`/`not_earned` labels, a synthetic written-response caption, and points
- Source spec: `../ap_statistics_hdg_full_export_2026_07_07.json` (full export of
  all 40 items' `prompt_json` — stem, `expected_graph_spec`, `stimulus_table`,
  `criteria` — pulled directly from `app.content_items`/`content_item_versions`)

## Archetypes covered (all 6 present in the 40-item corpus)

| Archetype | Count | Renderer flaw injected (partially_correct / subtly_wrong) |
|---|---|---|
| `boxplot_construction_interpretation` | 7 | swapped Q1/Q3 + missing comparison / inconsistent inter-group scale |
| `segmented_bar_graph_construction` | 7 | not normalized to relative frequency / reversed segment stacking order |
| `mosaic_plot_interpretation` | 7 | equal bar widths (ignores group totals) / uses overall instead of conditional proportions |
| `dotplot_distribution_shape` | 6 | dropped a value + no outlier note / shape read backwards (right vs. left skew) |
| `scatterplot_regression_context` | 6 | trend line omitted / trend line drawn flat despite a clear positive trend |
| `graph_annotation_marking_value` | 6 | mark placed at the wrong x-location / correct x-location but misread y-value |

## Tiers per item (3 each, 120 total images)

- **fully_correct** — all criteria earned
- **partially_correct** — ~half the criteria earned; a plausible incomplete/malformed graph
- **subtly_wrong** — 3 of 4 criteria earned; one deceptive, realistic error a student
  could make while everything else looks right

## Regenerating

```
python3 render_hdr_traces.py <full_export.json> <out_dir> <prefix>
```

Renderer script: kept in the session scratchpad during generation; copy into
`scripts/` if this becomes a recurring pipeline rather than a one-off calibration
pass.

## Status

`label_status: synthetic_generated_gold` on every record — these are **not**
tutor-verified gold labels, they're deterministic-by-construction labels (the
renderer knows exactly which criterion it broke). Treat as a bootstrap/calibration
aid, not ground truth for a real student response.

## Correctness fix (2026-07-07, same day)

The first render pass hardcoded the marked-point index for
`graph_annotation_marking_value` items to array position 3, rather than reading
the x-value each item's own `X_LOCATION` rubric actually asks for. This only
matched by coincidence for 2 of the 6 items in this archetype
(`APSTATS-HDG-2026-GRAPH-006`, `-040`); the other 4
(`-012`, `-037`, `-038`, `-039`) had their X marker placed at the wrong point
relative to their own criteria. Fixed by extracting the target x-value directly
from the `X_LOCATION` criterion text and matching it against the stimulus table
instead of assuming a fixed index. All 120 images (not just the 18 affected)
were regenerated after the fix to keep the batch internally consistent — verify
against `gold_labels.jsonl` if you pulled images before this note was added.
