# Hand-Drawn Input Packet -- Dialysis Bag Mass Change Across Sucrose Concentration

**Subject:** AP Biology
**Answer type:** Hand-drawn graph response
**Source item:** `HDG-2026-P2-EST-002`
**Archetype:** continuous_relationship_graph_derived_estimate
**Version:** `v1.0-ai-provisional-2026-07-06`
**Label status:** `ai_provisional_unapproved`

## Prompt (reused from source item)

Researchers measured dialysis bag mass change across a range of sucrose concentration. Construct a graph with sucrose concentration on the x-axis and percent mass change on the y-axis. Plot the paired observations, draw one best-fit relationship, mark where the relationship crosses zero change, and report the estimated sucrose concentration at zero change with units.

## Data Table (reused from source item)

| sucrose concentration (M) | percent mass change (%) |
| --- | --- |
| 0.0 | 24.0 |
| 0.1 | 19.0 |
| 0.2 | 11.0 |
| 0.35 | 4.0 |
| 0.5 | -4.0 |
| 0.7 | -14.0 |
| 0.9 | -25.0 |

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
| `R2` | 3 |
| `R3` | 3 |
| `R4` | 4 |
| `R5` | 2 |

#### R1

Scatterplot with x-axis labeled 'Sucrose concentration (M)' on a 0-0.9 scale, y-axis labeled 'Percent mass change (%)' on a -25 to +25 scale. All seven points plotted at positions matching the table. A single smooth best-fit line crosses the x-axis at approximately 0.40 M, marked with a small tick and labeled '~0.40 M.'

#### R2

Scatterplot with axes swapped: sucrose concentration plotted on the y-axis and percent mass change on the x-axis, both correctly labeled for their (swapped) positions and correctly scaled. Points plotted consistently with the swapped axes. A best-fit line is drawn and a zero-crossing estimate of 0.40 M is reported.

#### R3

Scatterplot with correctly labeled and scaled axes. Six of the seven points are plotted accurately; the point at 0.35 M is missing from the graph entirely. A best-fit line is drawn through the remaining six points and crosses zero at approximately 0.40 M.

#### R4

Scatterplot with correctly labeled and scaled axes and all seven points plotted accurately. A single smooth best-fit line crosses zero at approximately 0.39 M, marked and labeled with units.

#### R5

Scatterplot with correctly labeled and scaled axes and all seven points plotted accurately. A best-fit line is drawn, but it is a straight line forced through the origin (0,0) rather than through the actual data trend, giving a zero-crossing estimate of 0 M.

## Draft Label Matrix

**Label status:** Claude-authored draft, `ai_provisional_unapproved`. NOT confirmed by Learning Quality.

| Response ID | `C1` | `C2` | `C3` | `C4` | Reviewer notes |
| --- | --- | --- | --- | --- | --- |
| `R1` | earned | earned | earned | earned | Full-credit response with correct axes, accurate plotted points, a genuine single best-fit line, and a correctly marked and estimated zero-crossing with units. |
| `R2` | not_earned | earned | earned | earned | The prompt specifically instructs sucrose concentration on the x-axis and percent mass change on the y-axis -- swapping which variable goes on which axis, even when done consistently and correctly labeled, does not match the required graph orientation specified in the stem, so C1 (representation with the specified axis assignment) is not earned. Downstream values, fit line, and zero-crossing estimate are all internally consistent and happen to be numerically recoverable, so the later criteria are still earned despite the axis swap. Flags: axis assignment reversed relative to stem instructions. |
| `R3` | earned | not_earned | earned | earned | One of seven paired observations is missing entirely, so C2 (all paired observations plotted) is not earned, even though the omission happens not to shift the fit line's zero-crossing estimate much in this case. Flags: single point omitted, illustrates that a missing point can fail C2 even when downstream estimate criteria still happen to be reasonable. |
| `R4` | earned | earned | earned | earned | Second full-credit response with a slightly different but still reasonable zero-crossing estimate (0.39 vs. 0.40 M); confirms grader tolerance for small estimate variation from reading a hand-drawn fit line. |
| `R5` | earned | earned | not_earned | not_earned | The forced-through-origin line does not represent the actual trend of the plotted data (which clearly crosses zero mass-change around 0.4 M, not at 0 M sucrose concentration) -- this is an invented/unsupported best-fit relationship rather than one derived from the data, so C3 is not earned, and the resulting zero-crossing estimate inherits that error. Flags: best-fit relationship not derived from plotted data, unsupported inference propagated into the final estimate. |

## Boundary Tags Index (visual failure modes)

- `R1`: (none)
- `R2`: `axis_assignment_reversed`
- `R3`: `missing_evidence`, `under_credit_risk`
- `R4`: (none)
- `R5`: `unsupported_inference`, `best_fit_not_derived_from_data`
