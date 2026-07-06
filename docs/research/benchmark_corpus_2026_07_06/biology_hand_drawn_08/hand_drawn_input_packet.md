# Hand-Drawn Input Packet -- Water Movement in Model Cells Across External Solute Concentration

**Subject:** AP Biology
**Answer type:** Hand-drawn graph response
**Source item:** `HDG-2026-P2-EST-001`
**Archetype:** continuous_relationship_graph_derived_estimate
**Version:** `v1.0-ai-provisional-2026-07-06`
**Label status:** `ai_provisional_unapproved`

## Prompt (reused from source item)

Researchers measured water movement in model cells across a range of external solute concentration. Construct a graph with external solute concentration on the x-axis and percent mass change on the y-axis. Plot the paired observations, draw one best-fit relationship, mark where the relationship crosses zero change, and report the estimated external solute concentration at zero change with units.

## Data Table (reused from source item)

| external solute concentration (M) | percent mass change (%) |
| --- | --- |
| 0.0 | 18.0 |
| 0.1 | 14.0 |
| 0.2 | 9.0 |
| 0.3 | 3.0 |
| 0.4 | -1.0 |
| 0.6 | -13.0 |
| 0.8 | -20.0 |

## Capture Instruction (reused from source item)

Draw one graph on one page. Write only the item ID at the top of the page, then photograph the full page with all graph evidence visible. Do not expose criterion definitions to the person drawing the graph.

## Visual Grading Contract (condensed to 4 criteria for this package)

| Criterion ID | Criterion | Notes for reviewer |
| --- | --- | --- |
| `C1` | Uses a scatterplot representation with both axes correctly labeled with variable and unit and scaled to fit the data range. | Condensed from source REPRESENTATION_TYPE + X_UNIT + Y_UNIT + X_SCALE + Y_SCALE. |
| `C2` | All paired observations are plotted at positions recoverable from the graph and consistent with the table. | Same as source PLOT_VALUES. |
| `C3` | Draws one smooth best-fit relationship (line or curve) representing the trend through the plotted points, not a point-to-point connection. | Same as source BEST_FIT_RELATIONSHIP. |
| `C4` | Marks where the best-fit relationship crosses zero change and reports a numeric estimate with correct units consistent with the graph. | Condensed from source ZERO_INTERCEPT_ANNOTATION + ESTIMATE_VALUE. |

**Important:** no real photographed student responses exist for this item. Each response below is a textual description of a hypothetical drawn page, not an actual photograph.

## Response Set

| Response ID | Points (Claude-provisional) |
| --- | ---: |
| `R1` | 4 |
| `R2` | 2 |
| `R3` | 3 |
| `R4` | 4 |
| `R5` | 2 |

#### R1

Scatterplot with x-axis labeled 'External solute concentration (M)' on a 0-0.8 scale, y-axis labeled 'Percent mass change (%)' on a -25 to +20 scale. All seven points plotted at positions matching the table. A single smooth curve is drawn through the points (not point-to-point segments), crossing the x-axis at approximately 0.35 M, which is marked with a small circle and labeled 'x-intercept ~0.35 M.'

#### R2

Scatterplot with correctly labeled and scaled axes and all seven points plotted accurately. Instead of a single smooth best-fit relationship, the points are connected with straight point-to-point segments (a jagged line through every point). No zero-crossing mark or estimate is given.

#### R3

Scatterplot with correctly labeled and scaled axes, all seven points plotted accurately, and a single smooth best-fit line drawn through the data. The line is marked where it crosses zero, but the reported estimate is written as '0.35' with no unit given.

#### R4

Scatterplot with correctly labeled and scaled axes and all seven points plotted accurately. A single smooth best-fit line is drawn through the data, marked where it crosses zero at approximately 0.34 M.

#### R5

Scatterplot with correctly labeled and scaled axes and all seven points plotted accurately. Two different best-fit lines are drawn on the same graph: one straight line and one slightly curved line, crossing zero at two different points (approximately 0.33 M and 0.38 M respectively), with no indication of which one is the intended final answer.

## Draft Label Matrix

**Label status:** Claude-authored draft, `ai_provisional_unapproved`. NOT confirmed by Learning Quality.

| Response ID | `C1` | `C2` | `C3` | `C4` | Reviewer notes |
| --- | --- | --- | --- | --- | --- |
| `R1` | earned | earned | earned | earned | Full-credit response with correct axes, plotted points, a genuine best-fit relationship (not a point-to-point connection), and a marked, correctly estimated zero-crossing with units. |
| `R2` | earned | earned | not_earned | not_earned | Point-to-point connection is a different representation than the required single best-fit relationship -- this archetype specifically calls for one smooth trend line/curve summarizing the relationship, not a line that passes through every individual point. Because there's no fit line, there's also nothing marked or estimated at the zero-crossing. Flags: point-to-point connection used instead of a best-fit relationship, missing evidence for the zero-crossing estimate. |
| `R3` | earned | earned | earned | not_earned | Everything up through marking the zero-crossing point on the graph is correct, and the numeric estimate itself (0.35) is accurate, but the criterion requires the estimate to be reported with the correct unit (M) -- a bare number without units is not sufficient given the explicit prompt instruction to 'report the estimated ... concentration at zero change with units.' Flags: units omitted from final reported estimate, over-credit risk if grader accepts the bare number as equivalent. |
| `R4` | earned | earned | earned | earned | Second full-credit response with a slightly different but still reasonable zero-crossing estimate (0.34 vs. 0.35 M), confirming the grader should accept a small range of estimates consistent with reading a hand-drawn best-fit line rather than requiring one exact number. |
| `R5` | earned | earned | unable_to_determine | unable_to_determine | The rubric calls for one best-fit relationship, and this page shows two conflicting fit lines without a clear indication of which is final -- this is a genuine rubric-drift/ambiguity case (is a corrected/revised second attempt acceptable, or does showing two undermine 'one' relationship entirely?) rather than a clean pass or fail, and should be routed to a reviewer for a policy decision rather than scored outright. Flags: rubric ambiguity on multiple candidate fit lines, downstream estimate also ambiguous as a result. |

## Boundary Tags Index (visual failure modes)

- `R1`: (none)
- `R2`: `wrong_representation_for_estimate_task`, `missing_evidence`
- `R3`: `over_credit_risk`, `units_omitted`
- `R4`: (none)
- `R5`: `rubric_ambiguity`, `visual_ambiguity`
