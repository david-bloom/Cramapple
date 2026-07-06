# Hand-Drawn Input Packet -- Scatterplot of Hours Studied and Quiz Score

**Subject:** AP Statistics
**Answer type:** Hand-drawn graph response
**Source item:** `APSTATS-HDG-2026-GRAPH-005`
**Archetype:** scatterplot_regression_context
**Version:** `v1.0-ai-provisional-2026-07-06`
**Label status:** `ai_provisional_unapproved`

## Prompt (reused from source item)

A teacher recorded hours studied and quiz score for nine students. Construct a scatterplot, sketch a reasonable least-squares trend line, and describe the direction, form, and strength of the association in context.

## Data Table (reused from source item)

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

## Capture Instruction (reused from source item)

Draw one graph on one page. Write only the item ID at the top of the page, then photograph the full page with all graph evidence visible. Do not expose criterion definitions to the person drawing the graph.

## Visual Grading Contract (condensed to 4 criteria for this package)

| Criterion ID | Criterion | Notes for reviewer |
| --- | --- | --- |
| `C1` | Plots all nine ordered pairs at recoverable locations. | Reused directly from source POINTS_PLOTTED. |
| `C2` | Labels hours studied and quiz score on the correct axes. | Reused directly from source AXIS_LABELS. |
| `C3` | Sketches a reasonable increasing line through the point cloud. | Reused directly from source TREND_LINE. |
| `C4` | Describes strong positive roughly linear association in context. | Reused directly from source ASSOCIATION_DESCRIPTION. |

**Important:** no real photographed student responses exist for this item. Each response below is a textual description of a hypothetical drawn page, not an actual photograph.

## Response Set

| Response ID | Points (Claude-provisional) |
| --- | ---: |
| `R1` | 4 |
| `R2` | 3 |
| `R3` | 3 |
| `R4` | 4 |
| `R5` | 3 |

#### R1

Scatterplot with x-axis labeled 'Hours studied' and y-axis labeled 'Quiz score,' all nine points plotted at positions matching the table, closely following an increasing linear pattern. A single straight trend line sketched rising from about (2, 41) to about (10, 72). Written answer: 'There is a strong, positive, roughly linear association between hours studied and quiz score -- students who studied more hours tended to earn higher quiz scores, and the points fall close to a straight increasing line.'

#### R2

Scatterplot with axes swapped: quiz score on the x-axis, hours studied on the y-axis, but labeled correctly for their (swapped) positions and all nine points plotted consistently with that swap. A trend line rises through the point cloud. Written answer correctly describes a strong positive roughly linear association in context.

#### R3

Scatterplot with correct axis labels and all nine points plotted accurately, closely following an increasing linear pattern. No trend line is sketched anywhere on the graph. Written answer: 'There is a strong positive linear association between hours studied and quiz score.'

#### R4

Scatterplot with correct axis labels, all nine points plotted accurately, and a reasonable increasing trend line sketched through the point cloud from about (2, 40) to about (10, 71). Written answer: 'The scatterplot shows a strong, positive, roughly linear relationship between the number of hours a student studied and their quiz score: as hours studied increases, quiz score tends to increase as well, and the points cluster tightly around the increasing trend line.'

#### R5

Scatterplot with correct axis labels and all nine points plotted accurately, closely following the increasing pattern. A trend line is sketched, but it is drawn as a slightly curved line bowing upward, rather than straight, following the point cloud a bit more closely than a straight line would. Written answer: 'There is a strong positive, roughly linear association, though the relationship might curve slightly upward at higher study-hour values.'

## Draft Label Matrix

**Label status:** Claude-authored draft, `ai_provisional_unapproved`. NOT confirmed by Learning Quality.

| Response ID | `C1` | `C2` | `C3` | `C4` | Reviewer notes |
| --- | --- | --- | --- | --- | --- |
| `R1` | earned | earned | earned | earned | Full-credit response with all points plotted accurately, correct axis labels, a reasonable trend line, and a correctly contextualized direction/form/strength description. |
| `R2` | earned | not_earned | earned | earned | The stem does not specify a strict axis assignment the way some regression items do, but by convention (and by matching how the variables are introduced in the stem, hours studied first as the explanatory variable), hours studied is expected on the x-axis and quiz score on the y-axis; swapping them is inconsistent with that expected convention even though internally consistent and correctly labeled for the swap. Flags: axis assignment reversed relative to expected explanatory/response convention, boundary case for how strictly axis assignment should be enforced. |
| `R3` | earned | earned | not_earned | earned | Points and labels are correct, and the written description is also correct, but the stem specifically asks the drawer to sketch a trend line on the graph itself, which is missing. Flags: missing evidence for the trend-line sketch specifically, despite a correct verbal description of the same relationship. |
| `R4` | earned | earned | earned | earned | Second full-credit response with a slightly different but still reasonable trend-line endpoint reading; confirms grader tolerance for hand-drawn line variation. |
| `R5` | earned | earned | unable_to_determine | earned | The written description correctly matches the requested 'roughly linear' framing, but the drawn line itself is curved rather than straight, and it's genuinely ambiguous whether a slightly curved 'reasonable' line sketched to hug a mostly-linear cloud should count as satisfying 'a reasonable increasing line' (which could be read as requiring a straight line specifically) -- flagged unable_to_determine pending a rubric-drift decision on how strictly 'line' should be interpreted for a roughly-linear-but-not-perfectly-linear cloud. Flags: rubric ambiguity on straight-vs-curved trend line, visual judgment call. |

## Boundary Tags Index (visual failure modes)

- `R1`: (none)
- `R2`: `axis_assignment_reversed`, `rubric_ambiguity`
- `R3`: `missing_evidence`
- `R4`: (none)
- `R5`: `rubric_ambiguity`
