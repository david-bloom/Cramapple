# Hand-Drawn Input Packet -- Enzyme Inhibitor Response Across Inhibitor Concentration

**Subject:** AP Biology
**Answer type:** Hand-drawn graph response
**Source item:** `HDG-2026-P2-EST-004`
**Archetype:** continuous_relationship_graph_derived_estimate
**Version:** `v1.0-ai-provisional-2026-07-06`
**Label status:** `ai_provisional_unapproved`

## Prompt (reused from source item)

Researchers measured enzyme inhibitor response across a range of inhibitor concentration. Construct a graph with inhibitor concentration on the x-axis and change from control on the y-axis. Plot the paired observations, draw one best-fit relationship, mark where the relationship crosses zero change, and report the estimated inhibitor concentration at zero change with units.

## Data Table (reused from source item)

| inhibitor concentration (mM) | change from control (%) |
| --- | --- |
| 0 | 37.0 |
| 2 | 31.0 |
| 5 | 23.0 |
| 8 | 14.0 |
| 12 | 2.0 |
| 18 | -16.0 |
| 25 | -41.0 |

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
| `R2` | 4 |
| `R3` | 3 |
| `R4` | 3 |
| `R5` | 3 |

#### R1

Scatterplot with x-axis labeled 'Inhibitor concentration (mM)' on a 0-25 scale, y-axis labeled 'Change from control (%)' on a -45 to +40 scale. All seven points plotted at positions matching the table. A single smooth best-fit line crosses the x-axis at approximately 12.5 mM, marked with a tick and labeled '~12.5 mM.'

#### R2

Scatterplot with correctly labeled and scaled axes and all seven points plotted accurately, with a single smooth best-fit line drawn through the data. The line is marked at its zero-crossing, and the estimate is reported as 'about 12 or so mM' without a more precise reading.

#### R3

Scatterplot with correctly labeled and scaled axes and all seven points plotted accurately. Instead of a single best-fit line, two separate straight-line segments are drawn: one connecting the first four points and a second, differently-sloped segment connecting the last three, meeting at a sharp angle at the 8 mM point. The zero-crossing is marked at approximately 12 mM.

#### R4

Scatterplot with correctly labeled and scaled axes and all seven points plotted accurately. A single smooth best-fit line is drawn, but no mark or annotation is made at the zero-crossing, and no numeric estimate is reported anywhere on the page.

#### R5

Scatterplot with correctly labeled and scaled axes and all seven points plotted accurately. A single smooth best-fit line is drawn and marked at its zero-crossing, reported as '12.5' with the unit written as '%' instead of 'mM.'

## Draft Label Matrix

**Label status:** Claude-authored draft, `ai_provisional_unapproved`. NOT confirmed by Learning Quality.

| Response ID | `C1` | `C2` | `C3` | `C4` | Reviewer notes |
| --- | --- | --- | --- | --- | --- |
| `R1` | earned | earned | earned | earned | Full-credit response with correct axes, accurate plotted points, a genuine single best-fit line, and a correctly marked and estimated zero-crossing with units. |
| `R2` | earned | earned | earned | earned | The estimate is reported with appropriate hedging language for a hand-drawn reading ('about 12 or so') rather than false precision, and is consistent with the data (the 12 mM point itself is close to zero at +2%) -- this level of estimate precision is acceptable for a graph-derived value and should not be penalized relative to a more precisely stated '12.5 mM.' Full-credit response, useful for calibrating acceptable estimate precision. |
| `R3` | earned | earned | not_earned | earned | The two-segment piecewise line is not a single smooth best-fit relationship as required -- even though the resulting zero-crossing estimate happens to be reasonable, the relationship itself does not match the required representation (one smooth trend line/curve). Flags: piecewise line used instead of single best-fit relationship, illustrates that a reasonable final estimate doesn't retroactively validate an incorrect fit representation. |
| `R4` | earned | earned | earned | not_earned | Graph, points, and fit line are all correct, but the response never completes the final step the stem explicitly asks for -- marking where the relationship crosses zero and reporting a numeric estimate with units. Flags: missing evidence for the final reported estimate, a clear omission rather than an ambiguous one. |
| `R5` | earned | earned | earned | not_earned | The numeric estimate itself is correct and the crossing is correctly marked, but the reported unit is wrong -- '%' is the unit of the y-axis variable (change from control), not the x-axis variable actually being estimated (inhibitor concentration in mM). This is a unit-mismatch error rather than an omission, distinct from R4's missing estimate. Flags: wrong unit attached to correct numeric estimate, over-credit risk if grader checks only the number and not the unit. |

## Boundary Tags Index (visual failure modes)

- `R1`: (none)
- `R2`: (none)
- `R3`: `wrong_representation_for_estimate_task`
- `R4`: `missing_evidence`
- `R5`: `over_credit_risk`, `unit_mismatch`
