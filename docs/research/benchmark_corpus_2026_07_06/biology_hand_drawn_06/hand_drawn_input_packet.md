# Hand-Drawn Input Packet -- Photosynthetic Oxygen Release Across a Light Intensity Series

**Subject:** AP Biology
**Answer type:** Hand-drawn graph response
**Source item:** `HDG-2026-P2-SER-002`
**Archetype:** continuous_measured_series_supplied_uncertainty
**Version:** `v1.0-ai-provisional-2026-07-06`
**Label status:** `ai_provisional_unapproved`

## Prompt (reused from source item)

Researchers measured photosynthetic oxygen release at several values of light intensity. Use the data table to construct a graph with light intensity on the x-axis and mean oxygen release on the y-axis. Plot each mean at its measured x-value, connect adjacent measured values, and include symmetric error bars showing plus or minus one SEM.

## Data Table (reused from source item)

| light intensity (umol photons/m^2/s) | Mean oxygen release (umol O2/min) | SEM (umol O2/min) |
| --- | --- | --- |
| 0 | 1.0 | 0.6 |
| 50 | 2.0 | 0.3 |
| 350 | 15.0 | 0.5 |
| 500 | 21.0 | 0.3 |
| 900 | 27.0 | 1.0 |
| 1100 | 28.0 | 0.4 |
| 1400 | 33.0 | 0.5 |

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

Points plotted at all seven light-intensity values, connected in order, correctly showing a steep rise at low light intensity that levels off toward a plateau near 1400 umol photons/m^2/s. X-axis labeled 'Light intensity (umol photons/m^2/s)' with a 0-1400 numeric scale; y-axis labeled 'Mean oxygen release (umol O2/min)' with a 0-35 scale. Point heights match the table. Each point has a symmetric error bar matching its SEM.

#### R2

Points plotted at correct positions for all seven light intensities, connected in order. X-axis labeled 'Light' with no unit; y-axis correctly labeled 'Mean oxygen release (umol O2/min).' Error bars present and symmetric.

#### R3

Points plotted at correct x-y positions for all seven light intensities on correctly labeled and scaled axes, connected in order. Error bars are present on the first four points (0, 50, 350, 500) but are missing on the remaining three (900, 1100, 1400).

#### R4

Points plotted at all seven light-intensity values on correctly labeled and scaled axes, each with a symmetric error bar matching its SEM. Points are plotted correctly, but no connecting lines are drawn between them -- the graph shows an unconnected scatter of seven points.

#### R5

Points plotted at correct positions for all seven light intensities, connected in order, on correctly labeled and scaled axes. Error bars are drawn on all seven points, but for the 0 and 50 light-intensity points, the bars extend downward well below zero (the 0-intensity point's bar reaches roughly -1 to 3, when 0 +/- 0.6 SEM should only reach about 0.4 to 1.6).

## Draft Label Matrix

**Label status:** Claude-authored draft, `ai_provisional_unapproved`. NOT confirmed by Learning Quality.

| Response ID | `C1` | `C2` | `C3` | `C4` | Reviewer notes |
| --- | --- | --- | --- | --- | --- |
| `R1` | earned | earned | earned | earned | Full-credit response correctly reproducing the saturating (plateauing) light-response curve shape with correct axes, values, connections, and uncertainty marks. |
| `R2` | earned | not_earned | earned | earned | X-axis label drops both the specific variable name detail and the unit (umol photons/m^2/s), leaving just 'Light' -- insufficient on its own to recover the correct unit of measurement from the graph. Flags: axis label under-specified, over-credit risk if grader accepts a bare generic label for one of the two axes while the other is fully correct. |
| `R3` | earned | earned | earned | not_earned | Only some points have uncertainty marks -- a clear partial failure, not an ambiguous case, since three of seven points have no whisker at all. Flags: partial/inconsistent uncertainty marking. |
| `R4` | not_earned | earned | not_earned | earned | The prompt specifically instructs connecting adjacent measured values, which is part of the accepted representation for this archetype (a connected series, not an unconnected scatter) -- since the points are not connected, both C1 (representation type) and the connection half of C3 are not earned, even though every point and error bar is individually placed correctly. Flags: missing point-connection, illustrates that accurate plotting alone is not sufficient for this archetype's representation requirement. |
| `R5` | earned | earned | earned | unable_to_determine | Most of the graph is correct, but the error bars on the lowest two points appear to be drawn at roughly triple the reported SEM rather than a single SEM -- it's unclear from the description alone whether this is a genuine SEM-magnitude error or an artifact of the point being close to zero making a small absolute bar look visually larger; flagged unable_to_determine pending a reviewer re-measurement against the actual page rather than assumed as a clear miss. Flags: visual ambiguity in bar magnitude near a low baseline value, rubric-drift risk in judging bar width near zero. |

## Boundary Tags Index (visual failure modes)

- `R1`: (none)
- `R2`: `over_credit_risk`, `axis_label_underspecified`
- `R3`: `partial_uncertainty_marking`, `under_credit_risk`
- `R4`: `missing_evidence`, `under_credit_risk`
- `R5`: `visual_ambiguity`, `rubric_drift_bar_magnitude_near_zero`
