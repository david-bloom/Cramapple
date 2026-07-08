# Hand-Drawn Input Packet -- Enzyme Reaction Rate Across a Temperature Series

**Subject:** AP Biology
**Answer type:** Hand-drawn graph response
**Source item:** `HDG-2026-P2-SER-001`
**Archetype:** continuous_measured_series_supplied_uncertainty
**Version:** `v1.0-ai-provisional-2026-07-06`
**Label status:** `ai_provisional_unapproved`

## Prompt (reused from source item)

Researchers measured enzyme reaction rate at several values of temperature. Use the data table to construct a graph with temperature on the x-axis and mean reaction rate on the y-axis. Plot each mean at its measured x-value, connect adjacent measured values, and include symmetric error bars showing plus or minus one SEM.

## Data Table (reused from source item)

| temperature (deg C) | Mean reaction rate (umol/min) | SEM (umol/min) |
| --- | --- | --- |
| 10 | 46.0 | 1.3 |
| 15 | 63.0 | 1.9 |
| 20 | 60.0 | 1.2 |
| 28 | 48.0 | 1.0 |
| 42 | 23.0 | 0.3 |
| 55 | 12.0 | 0.3 |
| 60 | 10.0 | 0.3 |

## Capture Instruction (reused from source item)

Draw one graph on one page. Write only the item ID at the top of the page, then photograph the full page with all graph evidence visible. Do not expose criterion definitions to the person drawing the graph.

## Visual Grading Contract (condensed to 4 criteria for this package)

| Criterion ID | Criterion | Notes for reviewer |
| --- | --- | --- |
| `C1` | Uses an accepted representation for a continuous measured series (points connected in x-order by line segments). | Condensed from source REPRESENTATION_TYPE. |
| `C2` | Both axes are labeled with the correct variable and unit, and both scales can represent the full range of the data. | Condensed from source X_UNIT + Y_UNIT + X_SCALE + Y_SCALE. |
| `C3` | All measured points are plotted at positions recoverable from the graph and consistent with the table, and adjacent points are connected in measured order. | Condensed from source PLOT_VALUES + POINT_CONNECTION. |
| `C4` | Each point has centered, symmetric plus/minus one SEM error bars. | Same as source UNCERTAINTY_MARKS. |

**Important:** no real photographed student responses exist for this item. Each response below is a textual description of a hypothetical drawn page, not an actual photograph.

## Response Set

| Response ID | Points (Claude-provisional) |
| --- | ---: |
| `R1` | 4 |
| `R2` | 3 |
| `R3` | 3 |
| `R4` | 2 |
| `R5` | 3 |

#### R1

Points plotted at each of the seven temperature values, connected by straight line segments in order of increasing temperature, correctly showing the rise from 10 to 15 deg C and the fall from 15 deg C onward. X-axis labeled 'Temperature (deg C)' with an evenly spaced numeric scale from 0 to 60; y-axis labeled 'Mean reaction rate (umol/min)' with a 0-70 scale. Point heights match the table (46, 63, 60, 48, 23, 12, 10). Each point has a small, symmetric error bar matching its reported SEM.

#### R2

Points plotted at even, artificial x-spacing (treating the seven temperatures as though they were equally spaced categories rather than their true numeric values: 10, 15, 20, 28, 42, 55, 60 compressed into uniform gaps). Y-axis correctly labeled and scaled. Point heights match the table and points are connected in order. Error bars present and symmetric.

#### R3

Points plotted at correct x-y positions for all seven temperatures, connected in order. X and y axes both correctly labeled and scaled. No error bars appear anywhere on the graph.

#### R4

Points plotted at correct positions for all seven temperatures on correctly labeled and scaled axes, each with a symmetric error bar matching its SEM. However, the points are connected out of x-order -- the line jumps from 20 deg C directly to 42 deg C, then back to 28 deg C, before continuing to 55 and 60.

#### R5

Points plotted at correct positions for six of seven temperatures, connected in order, correctly labeled/scaled axes, symmetric error bars on all visible points. The 15 deg C point (the peak of the curve, reaction rate 63) is missing entirely from the graph -- the line goes directly from 10 to 20.

## Draft Label Matrix

**Label status:** Claude-authored draft, `ai_provisional_unapproved`. NOT confirmed by Learning Quality.

| Response ID | `C1` | `C2` | `C3` | `C4` | Reviewer notes |
| --- | --- | --- | --- | --- | --- |
| `R1` | earned | earned | earned | earned | Full-credit response correctly reproducing the rise-then-fall (optimum-temperature) shape, with correct axes, values, connections, and uncertainty marks. |
| `R2` | earned | not_earned | earned | earned | The x-axis fails to represent temperature on a true numeric scale -- treating unevenly spaced measured values as evenly spaced categories distorts the shape of the curve (e.g., the gap between 42 and 55 should be much larger than the gap between 10 and 15, but here they look the same), so the x-scale half of C2 is not earned even though the y-axis and everything else is correct. Flags: x-scale not proportional to true numeric spacing, rubric-drift risk between categorical and continuous x-axis treatment. |
| `R3` | earned | earned | earned | not_earned | Clean, accurate graph in every respect except that uncertainty marks are entirely absent -- a clear miss rather than an ambiguous one. Flags: missing evidence for uncertainty representation. |
| `R4` | not_earned | earned | not_earned | earned | Every individual point and its error bar is placed correctly, but the connecting lines are drawn out of measured order, which both breaks the point-connection requirement (part of C3) and makes the graph no longer read as a standard measured-series representation (affecting C1, since the resulting zig-zag isn't the accepted 'connect adjacent measured values' representation). Flags: connection-order error, illustrates that correct point placement alone doesn't satisfy C1/C3 if the connecting logic is wrong. |
| `R5` | earned | earned | not_earned | earned | Missing exactly the peak data point, which is the most informative value in the series (it establishes the optimum temperature). Six of seven points being correct is not sufficient for C3, which requires all measured points to be recoverable. Flags: single critical point omitted, under-credit risk if grader scores 'mostly complete' as sufficient given how much information the missing point carries. |

## Boundary Tags Index (visual failure modes)

- `R1`: (none)
- `R2`: `rubric_drift_x_scale_proportionality`, `over_credit_risk`
- `R3`: `missing_evidence`
- `R4`: `rubric_drift_connection_order`, `under_credit_risk`
- `R5`: `under_credit_risk`, `missing_evidence`, `critical_point_omitted`
