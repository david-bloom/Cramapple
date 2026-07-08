# AP Statistics HDR Grading Experiment -- FRQ Packets

Reused verbatim from `docs/research/ap_statistics_graph_response_seed_2026_07_02/ap_statistics_graph_response_seed_2026_07_02.jsonl` for all 12 items -- no re-authoring. One correction applied inline (GRAPH-010, flagged below); everything else is exactly as staged 2026-07-02.

## APSTATS-HDG-2026-GRAPH-001 {#apstats-hdg-2026-graph-001}

**Archetype:** boxplot_construction_interpretation

### Stem

A logistics teacher recorded delivery times for two route types. Construct side-by-side boxplots from the five-number summaries, using one common horizontal or vertical scale. Then write one sentence comparing the centers and one sentence comparing the variability.

| Route type | Min | Q1 | Median | Q3 | Max |
| --- | --- | --- | --- | --- | --- |
| Rural | 24 | 28 | 31 | 38 | 42 |
| Urban | 30 | 33 | 37 | 45 | 49 |

### Rubric criteria

| Criterion ID | Met rule |
| --- | --- |
| `BOXPLOT_SCALE` | Uses one interpretable common scale for both groups. |
| `FIVE_NUMBER_VALUES` | Both boxplots recover the listed five-number summaries. |
| `CENTER_COMPARISON` | Correctly compares medians in context. |
| `VARIABILITY_COMPARISON` | Correctly compares IQR or range in context. |

### Canonical answer

Side-by-side boxplots with rural min/Q1/median/Q3/max at 24/28/31/38/42 and urban at 30/33/37/45/49. Urban routes have the higher median delivery time; urban routes also have greater variability by IQR and range.

## APSTATS-HDG-2026-GRAPH-002 {#apstats-hdg-2026-graph-002}

**Archetype:** segmented_bar_graph_construction

### Stem

A school surveyed students about how often they use a homework planning app. Complete a segmented bar graph using relative frequencies for each class group. Then identify which group has the larger relative frequency of weekly app use.

| Class group | Never | Monthly | Weekly |
| --- | --- | --- | --- |
| Underclass | 20 | 45 | 35 |
| Upperclass | 12 | 38 | 50 |

### Rubric criteria

| Criterion ID | Met rule |
| --- | --- |
| `RELATIVE_FREQUENCIES` | Converts counts to correct within-group relative frequencies. |
| `SEGMENTED_BARS` | Draws two complete segmented bars with total length 1 or 100%. |
| `CATEGORY_LABELS` | Segments and class groups are identifiable. |
| `COMPARISON` | Correctly identifies the larger weekly relative frequency. |

### Canonical answer

Underclass segmented bar: 0.20 never, 0.45 monthly, 0.35 weekly. Upperclass segmented bar: 0.12 never, 0.38 monthly, 0.50 weekly. Upperclass students have the larger relative frequency of weekly app use.

## APSTATS-HDG-2026-GRAPH-003 {#apstats-hdg-2026-graph-003}

**Archetype:** mosaic_plot_interpretation

### Stem

Students were classified by primary study device and reported stress level. Draw a mosaic plot from the table so that each device width is proportional to its total count and each vertical segment shows the conditional distribution of stress level within that device. Then state which device group has the largest number of high-stress students.

| Device | Low | Medium | High |
| --- | --- | --- | --- |
| Phone | 24 | 36 | 40 |
| Laptop | 18 | 52 | 30 |
| Tablet | 30 | 30 | 20 |

### Rubric criteria

| Criterion ID | Met rule |
| --- | --- |
| `WIDTHS_BY_TOTAL` | Device widths are proportional to device totals. |
| `HEIGHTS_BY_CONDITIONAL_PROPORTION` | Segment heights use within-device proportions. |
| `SEGMENT_LABELS` | Device and stress-level categories are identifiable. |
| `AREA_OR_COUNT_REASONING` | Correctly identifies Phone as largest high-stress count. |

### Canonical answer

Device widths are proportional to totals: Phone 100, Laptop 100, Tablet 80 out of 280. Segment heights use within-device proportions. Phone has the largest number of high-stress students: 40, compared with 30 for Laptop and 20 for Tablet.

## APSTATS-HDG-2026-GRAPH-004 {#apstats-hdg-2026-graph-004}

**Archetype:** dotplot_distribution_shape

### Stem

A sample of 12 customer wait times is shown below. Construct a dotplot of the data, then describe the distribution's shape and identify any possible outlier.

| Wait time (min) |
| --- |
| 4 |
| 5 |
| 5 |
| 6 |
| 6 |
| 6 |
| 7 |
| 7 |
| 8 |
| 11 |
| 12 |
| 14 |

### Rubric criteria

| Criterion ID | Met rule |
| --- | --- |
| `DOT_COUNTS` | Plots the correct number of dots at each wait time. |
| `AXIS_SCALE` | Uses an interpretable numeric scale covering 4 through 14. |
| `SHAPE_DESCRIPTION` | Describes the distribution as right-skewed in context. |
| `OUTLIER_NOTE` | Identifies 14 minutes as a possible high outlier or unusual value. |

### Canonical answer

Dotplot places dots at 4, two at 5, three at 6, two at 7, one at 8, one at 11, one at 12, and one at 14. The distribution is right-skewed, with 14 minutes a possible high outlier.

## APSTATS-HDG-2026-GRAPH-005 {#apstats-hdg-2026-graph-005}

**Archetype:** scatterplot_regression_context

### Stem

A teacher recorded hours studied and quiz score for nine students. Construct a scatterplot, sketch a reasonable least-squares trend line, and describe the direction, form, and strength of the association in context.

| Hours studied | Quiz score |
| --- | --- |
| 2 | 41 |
| 3 | 45 |
| 4 | 48 |
| 5 | 53 |
| 6 | 55 |
| 7 | 59 |
| 8 | 65 |
| 9 | 68 |
| 10 | 72 |

### Rubric criteria

| Criterion ID | Met rule |
| --- | --- |
| `POINTS_PLOTTED` | Plots all nine ordered pairs at recoverable locations. |
| `AXIS_LABELS` | Labels hours studied and quiz score on the correct axes. |
| `TREND_LINE` | Sketches a reasonable increasing line through the point cloud. |
| `ASSOCIATION_DESCRIPTION` | Describes strong positive roughly linear association in context. |

### Canonical answer

Scatterplot shows a strong positive roughly linear association between hours studied and quiz score. A reasonable trend line rises from about (2, 41) toward about (10, 72).

## APSTATS-HDG-2026-GRAPH-006 {#apstats-hdg-2026-graph-006}

**Archetype:** graph_annotation_marking_value

### Stem

The table gives values from a curve showing the probability that a sample satisfies a condition as sample size increases. Draw the curve on a graph with sample size on the x-axis and probability on the y-axis. Mark the point for sample size 20 with an X, then estimate the corresponding probability.

| Sample size | Probability |
| --- | --- |
| 5 | 0.02 |
| 10 | 0.07 |
| 15 | 0.18 |
| 20 | 0.39 |
| 25 | 0.61 |
| 30 | 0.78 |
| 35 | 0.88 |
| 40 | 0.94 |
| 45 | 0.97 |
| 50 | 0.99 |

### Rubric criteria

| Criterion ID | Met rule |
| --- | --- |
| `CURVE_SHAPE` | Draws an increasing curve consistent with the table. |
| `AXIS_SCALE_LABELS` | Labels sample size and probability with interpretable scales. |
| `X_LOCATION` | Places X at sample size 20 and probability about 0.39. |
| `PROBABILITY_ESTIMATE` | Reports an estimate close to 0.39 or 0.4. |

### Canonical answer

Curve increases from near 0 toward 1. The marked X should be at sample size 20 and probability about 0.39. A reasonable estimate is approximately 0.4.

## APSTATS-HDG-2026-GRAPH-007 {#apstats-hdg-2026-graph-007}

**Archetype:** boxplot_construction_interpretation

### Stem

A city planner compared commute times for students who usually ride the bus and students who usually bike. Construct side-by-side boxplots from the five-number summaries using one common scale. Then compare the typical commute time and the spread in context.

| Transportation | Min | Q1 | Median | Q3 | Max |
| --- | --- | --- | --- | --- | --- |
| Bus | 18 | 24 | 29 | 41 | 55 |
| Bike | 12 | 16 | 19 | 25 | 31 |

### Rubric criteria

| Criterion ID | Met rule |
| --- | --- |
| `BOXPLOT_SCALE` | Uses one interpretable common scale for both groups. |
| `FIVE_NUMBER_VALUES` | Both boxplots recover the listed five-number summaries. |
| `CENTER_COMPARISON` | Correctly compares medians in context. |
| `VARIABILITY_COMPARISON` | Correctly compares IQR or range in context. |

### Canonical answer

Side-by-side boxplots with bus min/Q1/median/Q3/max at 18/24/29/41/55 and bike at 12/16/19/25/31. Bus commutes have the larger median and greater spread by both IQR and range.

## APSTATS-HDG-2026-GRAPH-008 {#apstats-hdg-2026-graph-008}

**Archetype:** segmented_bar_graph_construction

### Stem

A teacher scored short written explanations before and after a simulation lesson. Complete a segmented bar graph using relative frequencies for each lesson timing group. Then state whether the relative frequency of correct explanations increased after the lesson.

| Lesson timing | Incorrect | Partially correct | Correct |
| --- | --- | --- | --- |
| Before lesson | 30 | 42 | 28 |
| After lesson | 14 | 30 | 56 |

### Rubric criteria

| Criterion ID | Met rule |
| --- | --- |
| `RELATIVE_FREQUENCIES` | Converts counts to correct within-group relative frequencies. |
| `SEGMENTED_BARS` | Draws two complete segmented bars with total length 1 or 100%. |
| `CATEGORY_LABELS` | Segments and lesson timing groups are identifiable. |
| `COMPARISON` | Correctly states that correct explanations increased after the lesson. |

### Canonical answer

Before lesson segmented bar: 0.30 incorrect, 0.42 partially correct, 0.28 correct. After lesson segmented bar: 0.14 incorrect, 0.30 partially correct, 0.56 correct. The relative frequency of correct explanations increased after the lesson.

## APSTATS-HDG-2026-GRAPH-009 {#apstats-hdg-2026-graph-009}

**Archetype:** mosaic_plot_interpretation

### Stem

Students were grouped by usual study time and caffeine use level. Draw a mosaic plot so each study time width is proportional to its total count and each vertical segment shows the conditional distribution of caffeine use within that study time. Then identify which study-time group has the largest number of high-caffeine students.

| Study time | Low | Medium | High |
| --- | --- | --- | --- |
| Morning | 36 | 42 | 12 |
| Afternoon | 28 | 50 | 32 |
| Evening | 16 | 38 | 46 |

### Rubric criteria

| Criterion ID | Met rule |
| --- | --- |
| `WIDTHS_BY_TOTAL` | Study-time widths are proportional to group totals. |
| `HEIGHTS_BY_CONDITIONAL_PROPORTION` | Segment heights use within-group proportions. |
| `SEGMENT_LABELS` | Study-time and caffeine-use categories are identifiable. |
| `AREA_OR_COUNT_REASONING` | Correctly identifies Evening as largest high-caffeine count. |

### Canonical answer

Study-time widths are proportional to totals: Morning 90, Afternoon 110, Evening 100 out of 300. Segment heights use within-study-time proportions. Evening has the largest high-caffeine count: 46, compared with 32 for Afternoon and 12 for Morning.

## APSTATS-HDG-2026-GRAPH-010 {#apstats-hdg-2026-graph-010}

**Archetype:** dotplot_distribution_shape

### Stem

A biology class measured the heights of 12 plants after four weeks. Construct a dotplot of the data, then describe the distribution's shape and comment on whether there is a clear outlier.

| Height (cm) |
| --- |
| 68 |
| 70 |
| 71 |
| 72 |
| 72 |
| 73 |
| 74 |
| 74 |
| 75 |
| 76 |
| 78 |
| 82 |

### Rubric criteria

| Criterion ID | Met rule |
| --- | --- |
| `DOT_COUNTS` | Plots the correct number of dots at each plant height. |
| `AXIS_SCALE` | Uses an interpretable numeric scale covering 68 through 82. |
| `SHAPE_DESCRIPTION` | Describes the distribution as roughly unimodal with slight right tail or similar. |
| `OUTLIER_NOTE` | ~~Does not overstate 82 cm as a definite outlier; explains it is high or possibly unusual.~~ **CORRECTED (see note below):** Does not overstate 82 cm as a definite outlier without checking a rule, OR correctly applies the 1.5xIQR rule (Q1=71.5, Q3=75.5, IQR=4, upper fence=81.5) and identifies 82 cm as a mild outlier by that rule. |

### Canonical answer

~~Dotplot places dots at 68, 70, 71, two at 72, one at 73, two at 74, one at 75, one at 76, one at 78, and one at 82. The distribution is roughly unimodal with a slight right tail; 82 cm is high but not clearly isolated enough to require calling it an outlier.~~

**CORRECTED** (per `ap_statistics_graph_response_seed_2026_07_02/README.md`'s QA section -- the original claim that 82 cm is not an outlier does not survive independently recomputing the 1.5xIQR rule on this item's own data; fixed in the staged Supabase row 2026-07-02 but never fixed in this source JSONL file, kept there for provenance):

> Dotplot places dots at 68, 70, 71, two at 72, one at 73, two at 74, one at 75, one at 76, one at 78, and one at 82. The distribution is roughly unimodal with a slight right tail. By the 1.5xIQR rule (Q1=71.5, Q3=75.5, IQR=4, upper fence=81.5), 82 cm exceeds the fence and is a mild outlier.

## APSTATS-HDG-2026-GRAPH-011 {#apstats-hdg-2026-graph-011}

**Archetype:** scatterplot_regression_context

### Stem

A technology club measured screen brightness and battery remaining after one hour for nine phones. Construct a scatterplot, sketch a reasonable least-squares trend line, and describe the direction, form, and strength of the association in context.

| Screen brightness (%) | Battery remaining (%) |
| --- | --- |
| 12 | 88 |
| 14 | 84 |
| 15 | 82 |
| 17 | 79 |
| 18 | 77 |
| 20 | 73 |
| 21 | 70 |
| 23 | 66 |
| 25 | 63 |

### Rubric criteria

| Criterion ID | Met rule |
| --- | --- |
| `POINTS_PLOTTED` | Plots all nine ordered pairs at recoverable locations. |
| `AXIS_LABELS` | Labels screen brightness and battery remaining on the correct axes. |
| `TREND_LINE` | Sketches a reasonable decreasing line through the point cloud. |
| `ASSOCIATION_DESCRIPTION` | Describes strong negative roughly linear association in context. |

### Canonical answer

Scatterplot shows a strong negative roughly linear association between screen brightness and battery remaining. A reasonable trend line falls from about (12, 88) toward about (25, 63).

## APSTATS-HDG-2026-GRAPH-012 {#apstats-hdg-2026-graph-012}

**Archetype:** graph_annotation_marking_value

### Stem

A simulation estimated the detection rate for a rare issue as additional sample size increased. Draw the curve using the table, with added sample size on the x-axis and detection rate on the y-axis. Mark the point for added sample size 25 with an X, then estimate the corresponding detection rate.

| Added sample size | Detection rate |
| --- | --- |
| 0 | 0.12 |
| 5 | 0.2 |
| 10 | 0.34 |
| 15 | 0.52 |
| 20 | 0.69 |
| 25 | 0.81 |
| 30 | 0.89 |
| 35 | 0.94 |
| 40 | 0.97 |

### Rubric criteria

| Criterion ID | Met rule |
| --- | --- |
| `CURVE_SHAPE` | Draws an increasing curve consistent with the table. |
| `AXIS_SCALE_LABELS` | Labels added sample size and detection rate with interpretable scales. |
| `X_LOCATION` | Places X at added sample size 25 and detection rate about 0.81. |
| `RATE_ESTIMATE` | Reports an estimate close to 0.81. |

### Canonical answer

Curve increases from about 0.12 toward 0.97. The marked X should be at added sample size 25 and detection rate about 0.81.
