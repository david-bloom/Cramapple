# Hand-Drawn Input Packet -- Seedling Growth Across Days After Planting

**Subject:** AP Biology
**Answer type:** Hand-drawn graph response
**Source item:** `HDG-2026-P2-SER-004`
**Archetype:** continuous_measured_series_supplied_uncertainty
**Version:** `v1.0-ai-provisional-2026-07-06`
**Label status:** `ai_provisional_unapproved`

## Prompt (reused from source item)

Researchers measured seedling growth at several values of days after planting. Use the data table to construct a graph with days after planting on the x-axis and mean height on the y-axis. Plot each mean at its measured x-value, connect adjacent measured values, and include symmetric error bars showing plus or minus one SEM.

## Data Table (reused from source item)

| days after planting (days) | Mean height (cm) | SEM (cm) |
| --- | --- | --- |
| 0 | 19.0 | 0.4 |
| 1 | 18.0 | 0.3 |
| 3 | 24.0 | 0.6 |
| 5 | 29.0 | 0.9 |
| 7 | 36.0 | 0.9 |
| 11 | 45.0 | 0.8 |
| 12 | 53.0 | 1.0 |

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
| `R4` | 4 |
| `R5` | 3 |

#### R1

Points plotted at all seven day values (0, 1, 3, 5, 7, 11, 12), connected in order, correctly showing the slight early dip (day 0 to day 1) followed by a steady climb. X-axis labeled 'Days after planting (days)' with a 0-12 numeric scale; y-axis labeled 'Mean height (cm)' with a 0-55 scale. Point heights match the table. Each point has a symmetric error bar matching its SEM.

#### R2

Points plotted at all seven day values, but the day-0-to-day-1 dip is drawn as a flat or slightly rising segment instead of the small decrease shown in the table (19 to 18 cm), effectively smoothing over that one data point. All other points, axes, and error bars are correct.

#### R3

Points plotted at correct x-y positions for all seven days, connected in order, on correctly labeled and scaled axes. No error bars are drawn on any point.

#### R4

Points plotted at all seven day values on correctly labeled and scaled axes, connected in order, each with a symmetric error bar. However, the y-axis scale only runs from 15 to 55 rather than starting at 0, without any axis-break indication.

#### R5

Points plotted at all seven day values, connected in order, on correctly labeled and scaled axes, each with a symmetric error bar. The days-11-and-12 points are extremely close together on the compressed x-axis used for this hand-drawn page, and the error bars on those two points visually overlap enough that it is hard to tell where one point's bar ends and the next begins.

## Draft Label Matrix

**Label status:** Claude-authored draft, `ai_provisional_unapproved`. NOT confirmed by Learning Quality.

| Response ID | `C1` | `C2` | `C3` | `C4` | Reviewer notes |
| --- | --- | --- | --- | --- | --- |
| `R1` | earned | earned | earned | earned | Full-credit response, notably including the small day-0-to-day-1 dip (19 to 18 cm) rather than smoothing it into a monotonic line, which some responses incorrectly do. |
| `R2` | earned | earned | not_earned | earned | One of the seven measured values (day 1, height 18) is not accurately recoverable from the graph -- the connecting segment implies a value at or above 19 rather than the measured dip to 18. Even though this is a small, easy-to-overlook discrepancy, the criterion requires all measured points to be recoverable, and smoothing over a real (if small) non-monotonic dip changes the scientific reading of the graph (e.g., possible transplant shock in the first day). Flags: single point smoothed away, under-credit risk if grader treats a 1-unit-scale dip as negligible. |
| `R3` | earned | earned | earned | not_earned | Clean, accurate graph in every respect except uncertainty marks are completely absent -- a clear miss. Flags: missing evidence for uncertainty representation. |
| `R4` | earned | earned | earned | earned | The y-axis criterion as scoped ('scale can represent the full range of the data') is satisfied even though the axis does not start at zero -- all seven values (18-53) fit within the 15-55 range shown, and the criteria as written do not require a zero-based axis for this archetype. Full-credit response; useful for confirming graders do not penalize a non-zero-based y-axis when it is not explicitly required by the rubric. |
| `R5` | earned | earned | earned | unable_to_determine | The two closely spaced final points (11 and 12 days apart by only 1 day, unlike the earlier gaps) create a genuine visual-crowding issue for verifying individual error bar widths, distinct from a clear omission -- flagged unable_to_determine rather than scored, pending a closer re-measurement against the actual page or a redraw with more x-axis separation. Flags: visual ambiguity from point crowding, not a clear pass/fail case. |

## Boundary Tags Index (visual failure modes)

- `R1`: (none)
- `R2`: `under_credit_risk`, `small_dip_smoothed_over`
- `R3`: `missing_evidence`
- `R4`: (none)
- `R5`: `visual_ambiguity`
