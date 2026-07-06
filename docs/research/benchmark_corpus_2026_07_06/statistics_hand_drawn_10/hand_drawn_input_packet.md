# Hand-Drawn Input Packet -- Scatterplot of Screen Brightness and Battery Remaining

**Subject:** AP Statistics
**Answer type:** Hand-drawn graph response
**Source item:** `APSTATS-HDG-2026-GRAPH-011`
**Archetype:** scatterplot_regression_context
**Version:** `v1.0-ai-provisional-2026-07-06`
**Label status:** `ai_provisional_unapproved`

## Prompt (reused from source item)

A technology club measured screen brightness and battery remaining after one hour for nine phones. Construct a scatterplot, sketch a reasonable least-squares trend line, and describe the direction, form, and strength of the association in context.

## Data Table (reused from source item)

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

## Capture Instruction (reused from source item)

Draw one graph on one page. Write only the item ID at the top of the page, then photograph the full page with all graph evidence visible. Do not expose criterion definitions to the person drawing the graph.

## Visual Grading Contract (condensed to 4 criteria for this package)

| Criterion ID | Criterion | Notes for reviewer |
| --- | --- | --- |
| `C1` | Plots all nine ordered pairs at recoverable locations. | Reused directly from source POINTS_PLOTTED. |
| `C2` | Labels screen brightness and battery remaining on the correct axes. | Reused directly from source AXIS_LABELS. |
| `C3` | Sketches a reasonable decreasing line through the point cloud. | Reused directly from source TREND_LINE. |
| `C4` | Describes strong negative roughly linear association in context. | Reused directly from source ASSOCIATION_DESCRIPTION. |

**Important:** no real photographed student responses exist for this item. Each response below is a textual description of a hypothetical drawn page, not an actual photograph.

## Response Set

| Response ID | Points (Claude-provisional) |
| --- | ---: |
| `R1` | 4 |
| `R2` | 2 |
| `R3` | 3 |
| `R4` | 4 |
| `R5` | 3 |

#### R1

Scatterplot with x-axis labeled 'Screen brightness (%)' and y-axis labeled 'Battery remaining (%),' all nine points plotted at positions matching the table, closely following a decreasing linear pattern. A single straight trend line sketched falling from about (12, 88) to about (25, 63). Written answer: 'There is a strong, negative, roughly linear association between screen brightness and battery remaining -- phones with higher screen brightness tended to have less battery remaining after one hour, and the points fall close to a straight decreasing line.'

#### R2

Scatterplot with correct axis labels and all nine points plotted accurately, closely following the decreasing pattern. Trend line sketched, but drawn increasing (rising) from lower-left to upper-right instead of falling, which does not match the visibly downward-sloping point cloud. Written answer: 'There is a strong positive linear association between screen brightness and battery remaining.'

#### R3

Scatterplot with correct axis labels, all nine points plotted accurately, and a reasonable decreasing trend line. Written answer: 'Screen brightness and battery remaining are related.'

#### R4

Scatterplot with correct axis labels, all nine points plotted accurately, and a reasonable decreasing trend line sketched from about (12, 87) to about (25, 64). Written answer: 'The scatterplot shows a strong, negative, roughly linear association: as screen brightness increases, battery remaining after one hour tends to decrease, and the points cluster tightly around the falling trend line.'

#### R5

Scatterplot with correct axis labels and all nine points plotted accurately. Trend line is sketched correctly decreasing, but it is drawn noticeably steeper than the actual data trend, running from about (12, 95) to about (25, 55) -- overshooting both ends of the point cloud's actual range. Written answer correctly describes a strong negative roughly linear association.

## Draft Label Matrix

**Label status:** Claude-authored draft, `ai_provisional_unapproved`. NOT confirmed by Learning Quality.

| Response ID | `C1` | `C2` | `C3` | `C4` | Reviewer notes |
| --- | --- | --- | --- | --- | --- |
| `R1` | earned | earned | earned | earned | Full-credit response with all points plotted accurately, correct axis labels, a reasonable decreasing trend line, and a correctly contextualized direction/form/strength description. |
| `R2` | earned | earned | not_earned | not_earned | Points and axis labels are correct, but both the sketched trend line and the written description invert the direction of the association -- the data clearly decreases (higher brightness, less battery remaining), and both the line and the words describe it as increasing/positive instead. Flags: direction reversed in both the sketched line and the written description. |
| `R3` | earned | earned | earned | not_earned | The graph and trend line are both correct, but the written description never states the direction (negative), form (linear), or strength (strong) of the association -- 'are related' is far too vague to demonstrate the specific description the criterion requires. Flags: vague generality, over-credit risk if grader accepts a bare association claim without direction/form/strength. |
| `R4` | earned | earned | earned | earned | Second full-credit response with a slightly different but still reasonable trend-line reading; confirms grader tolerance for hand-drawn line variation. |
| `R5` | earned | earned | unable_to_determine | earned | The trend line's direction is correct but its slope is visibly steeper than the point cloud actually supports, overshooting the data range at both ends rather than passing through it -- it's a judgment call whether this still counts as 'a reasonable decreasing line through the point cloud' given the correct direction but poor fit, or whether the overshoot is severe enough to fail the criterion; flagged unable_to_determine for a reviewer to judge against the actual drawn line rather than assumed from this description alone. Flags: rubric ambiguity on trend-line fit quality vs. mere direction correctness. |

## Boundary Tags Index (visual failure modes)

- `R1`: (none)
- `R2`: `direction_reversed`
- `R3`: `vague_generality`, `over_credit_risk`
- `R4`: (none)
- `R5`: `rubric_ambiguity`, `visual_ambiguity`
