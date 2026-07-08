# AP Biology HDR Trace-Ready Results — 2026-07-07

New pilot set of **12 AP Biology** hand-drawn-response (HDR) items — none existed
in Supabase before this pass (a direct query on 2026-07-07 found zero
`hand_drawn:true` content_items for `subject_key = biology`).

## Why this exists

Requested as a companion to the AP Statistics HDR trace-ready gap-closure pass
(`../ap_statistics_hdr_trace_ready_2026_07_07/`). Since AP Biology had no HDR
item type at all, this is new content authoring, not a backfill.

## Item design

Mirrors the AP Statistics HDG structure exactly: same `prompt_json` schema
(`archetype`, `expected_graph_spec`, `stimulus_table`, `criteria`, `parts`),
same 6 archetypes (2 items per archetype), same `criterion_key` naming per
archetype so the existing renderer works unmodified. Biology-native contexts:

| Archetype | Items | Context |
|---|---|---|
| `boxplot_construction_interpretation` | 001, 002 | stomata density (sun/shade leaves); catalase reaction rate (20C/37C) |
| `segmented_bar_graph_construction` | 003, 004 | beetle genotype frequency before/after pesticide; snail shell-color by habitat |
| `mosaic_plot_interpretation` | 005, 006 | wildflower species × pollinator type; fish depth zone × diet type |
| `dotplot_distribution_shape` | 007, 008 | Darwin's finch beak depth; bean seed germination time |
| `scatterplot_regression_context` | 009, 010 | enzyme reaction rate vs. substrate concentration; rabbit population vs. forage biomass |
| `graph_annotation_marking_value` | 011, 012 | logistic population growth curve (mark week 5); enzyme activity vs. temperature bell curve (mark 37C optimum) |

Source item authoring: `../ap_biology_hdg_items_2026_07_07.json` (content_key,
full `prompt_json` per item — same shape as would live in
`content_item_versions.prompt_json` in Supabase).

## Contents

- `images/` — 36 PNGs (12 items × 3 tiers: fully_correct, partially_correct, subtly_wrong)
- `gold_labels.jsonl` — 36 records, per-criterion earned/not_earned labels + synthetic caption

## Known-fixed rendering bug

Item 011/012 (`graph_annotation_marking_value`) exercised a real bug in the
shared renderer: it hardcoded "mark point at array index 3" instead of reading
the actual x-value each item's `X_LOCATION` criterion asks for. Fixed in
`render_hdr_traces.py` (extracts the target x-value from the rubric text and
matches it against the stimulus table) — see the AP Statistics package's README
for the full writeup; that fix also corrected 4 of the 6 AP Statistics
curve-annotation items that were silently wrong before this pass.

## Status

- **Not yet in Supabase.** These are draft-authored items living only in this
  research package and `ap_biology_hdg_items_2026_07_07.json`. Insert into
  `app.content_items`/`content_item_versions`/`frq_criteria` as `status='draft'`
  (matching the rest of AP Biology's content — see
  `project_ap_biology_publish_gap` memory) before they're usable anywhere real.
- `label_status: synthetic_generated_gold` on every record — deterministic,
  renderer-authored labels, not tutor-verified. Same caveat as the Statistics
  package: bootstrap/calibration aid, not ground truth.
- `rights_status: independently_authored_synthetic_research_seed_unverified` on
  every item, matching the AP Statistics HDG convention.
