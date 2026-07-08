# Label Validation Notes

This file documents the provisional mapping from each photographed image to the package schema. These are draft labels only.

## Validation summary

- All 12 images are mapped.
- Each item has the same 4-slot contract: `REPRESENTATION`, `LABELING`, `GEOMETRY`, `COMPLETENESS`.
- The most important ambiguity tags are the graph-type boundary on the segmented-bar pages and the approximate-value boundary on the boxplot pages.
- None of the items should be treated as final gold labels without human review.

## Item notes

| Image | Draft overall | Notes |
| --- | --- | --- |
| `IMG_7007.jpeg` | `provisional_pass` | Clean increasing curve with a marked value; the `n=25` point is the important boundary cue. |
| `IMG_7008.jpeg` | `provisional_pass_with_boundary` | Segmented-bar / mosaic boundary is the main ambiguity; handwritten partitions are readable but not exact. |
| `IMG_7009.jpeg` | `provisional_pass_with_boundary` | Clear categorical display, but the segment widths are hand-drawn and should be treated as approximate. |
| `IMG_7010.jpeg` | `provisional_pass` | Strong curve-annotation example; marked point and probability estimate are present. |
| `IMG_7011.jpeg` | `provisional_pass_with_boundary` | The class-group bars are clear, but the handwritten category text and partitions are slightly rough. |
| `IMG_7012.jpeg` | `provisional_pass` | Boxplot structure is clean; use as a strong calibration item for common-scale boxplots. |
| `IMG_7013.jpeg` | `provisional_pass` | Boxplot structure is clean; useful for center/variability and five-number placement checks. |
| `IMG_7014.jpeg` | `provisional_pass` | Dot counts and stacking are the main signal; the plot is straightforward and likely high-confidence. |
| `IMG_7016.jpeg` | `provisional_pass` | Scatterplot and negative trend line are both visible; this is a strong geometry example. |
| `IMG_7017.jpeg` | `provisional_pass` | Another strong boxplot calibration page with a common scale and side-by-side comparison. |
| `IMG_7018.jpeg` | `provisional_pass_with_boundary` | Segmented-bar proportions are clear, but the handwritten labeling and partitioning are approximate. |
| `IMG_7019.jpeg` | `provisional_pass_with_boundary` | Good class-group comparison page; treat the relative-frequency cuts as approximate hand-drawn geometry. |

## Boundary tags used

- `curve_annotation_task`
- `marked_point_required`
- `estimate_from_curve`
- `segmented_bar_vs_mosaic_boundary`
- `relative_frequency_axis`
- `approximate_partition_lines`
- `conditional_proportion_display`
- `stacked_bar_geometry`
- `handwritten_category_labels`
- `boxplot_scale`
- `five_number_summary_boundary`
- `common_axis`
- `dotplot_stack_counts`
- `axis_tick_spacing`
- `distribution_shape_implicit`
- `scatterplot_negative_trend`
- `fitted_line_estimate`
- `axis_labels_readable`

