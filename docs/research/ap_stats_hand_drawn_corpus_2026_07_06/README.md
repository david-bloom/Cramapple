# AP Statistics Hand-Drawn Corpus - 2026-07-06

**Status:** draft / provisional only. These labels are not ground truth and have not been human-reviewed.

This package turns the 12 photographed AP Statistics hand-drawn pages in `/Users/davidbloom/Downloads/` into a single corpus slice with a consistent 4-slot contract per item and draft boundary tags for calibration work.

## Package intent

This is a mapping corpus, not a benchmark report. The goal is to preserve:

- the source image path
- the inferred AP Statistics graph archetype
- a consistent 4-criterion contract
- draft labels per criterion
- boundary tags that explain where the response sits near a rubric edge

The prompt text for each page is inferred from the visible drawing only. If you have the original prompt packets, replace `prompt_inference` with the true stem before using this as a benchmark input.

## Schema

`schema_id`: `ap_stats_hdg_4criterion_draft_v1`

Each row in `corpus.jsonl` uses the same four contract slots:

1. `REPRESENTATION` - correct graph form or display structure.
2. `LABELING` - readable axes, categories, title, or units.
3. `GEOMETRY` - the plotted values, segment widths, boxplot positions, or trend placement are close enough to be read.
4. `COMPLETENESS` - the response includes the needed second-order cue for the task, such as both groups, the marked point, or a complete display.

Draft labels use:

- `earned`
- `borderline`
- `not_earned`

Overall item labels are provisional and should be treated as calibration hints only.

## Item map

| Item | Image | Inferred archetype | Confidence | Main boundary tags |
| --- | --- | --- | --- | --- |
| APSTATS-HDG-2026-IMG-7007 | `IMG_7007.jpeg` | increasing curve with marked estimate | high | `curve_annotation_task`, `marked_point_required`, `estimate_from_curve` |
| APSTATS-HDG-2026-IMG-7008 | `IMG_7008.jpeg` | segmented bar / conditional proportion display | medium | `segmented_bar_vs_mosaic_boundary`, `relative_frequency_axis`, `approximate_partition_lines` |
| APSTATS-HDG-2026-IMG-7009 | `IMG_7009.jpeg` | segmented bar display by study time | medium | `conditional_proportion_display`, `stacked_bar_geometry`, `handwritten_category_labels` |
| APSTATS-HDG-2026-IMG-7010 | `IMG_7010.jpeg` | increasing probability curve with marked estimate | high | `probability_curve`, `point_estimate`, `saturation_curve` |
| APSTATS-HDG-2026-IMG-7011 | `IMG_7011.jpeg` | segmented bar display by class group | medium | `relative_frequency_axis`, `category_label_legibility`, `stacked_bar_geometry` |
| APSTATS-HDG-2026-IMG-7012 | `IMG_7012.jpeg` | side-by-side boxplots | high | `boxplot_scale`, `five_number_summary_boundary`, `common_axis` |
| APSTATS-HDG-2026-IMG-7013 | `IMG_7013.jpeg` | side-by-side boxplots | high | `boxplot_scale`, `five_number_summary_boundary`, `common_axis` |
| APSTATS-HDG-2026-IMG-7014 | `IMG_7014.jpeg` | dotplot | high | `dotplot_stack_counts`, `axis_tick_spacing`, `distribution_shape_implicit` |
| APSTATS-HDG-2026-IMG-7016 | `IMG_7016.jpeg` | scatterplot with decreasing trend | high | `scatterplot_negative_trend`, `fitted_line_estimate`, `axis_labels_readable` |
| APSTATS-HDG-2026-IMG-7017 | `IMG_7017.jpeg` | side-by-side boxplots | high | `boxplot_scale`, `five_number_summary_boundary`, `common_axis` |
| APSTATS-HDG-2026-IMG-7018 | `IMG_7018.jpeg` | segmented bar display by study time | medium | `conditional_proportion_display`, `stacked_bar_geometry`, `handwritten_category_labels` |
| APSTATS-HDG-2026-IMG-7019 | `IMG_7019.jpeg` | segmented bar display by class group | medium | `relative_frequency_axis`, `category_label_legibility`, `stacked_bar_geometry` |

## Use guidance

- Use this package to test how the grader handles hand-drawn AP Statistics graphs.
- Do not treat the draft labels as production truth.
- If a human reviewer later disagrees with an image, keep the image and replace only the label block for that row.
- If you need benchmark-grade data, add a reviewer pass and re-freeze the corpus under a new package ID.

