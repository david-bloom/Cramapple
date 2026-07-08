# Hand-Drawn Input Packet -- Root Tip Mitotic Index Across Four Temperature Treatments

**Subject:** AP Biology
**Answer type:** Hand-drawn graph response
**Source item:** `HDG-2026-P2-CAT-004`
**Archetype:** categorical_comparison_supplied_uncertainty
**Version:** `v1.0-ai-provisional-2026-07-06`
**Label status:** `ai_provisional_unapproved`

## Prompt (reused from source item)

Researchers measured root tip mitosis for four treatment groups. Use the data table to construct a graph that compares the group means. Include a categorical x-axis with the treatments in table order, a y-axis labeled with units, plotted means, and symmetric error bars showing plus or minus one SEM.

## Data Table (reused from source item)

| Treatment | Mean mitotic cells (%) | SEM (%) |
| --- | --- | --- |
| cool | 11.0 | 0.3 |
| room temp | 31.0 | 1.0 |
| warm | 36.0 | 0.7 |
| heat stress | 40.0 | 1.6 |

## Capture Instruction (reused from source item)

Draw one graph on one page. Write only the item ID at the top of the page, then photograph the full page with all graph evidence visible. Do not expose criterion definitions to the person drawing the graph.

## Visual Grading Contract (condensed to 4 criteria for this package)

| Criterion ID | Criterion | Notes for reviewer |
| --- | --- | --- |
| `C1` | Uses an accepted categorical representation (bar-with-whisker or point-with-whisker graph) with all four treatments identifiable and in table order. | Condensed from source REPRESENTATION_TYPE + CATEGORY_IDENTITY. |
| `C2` | Y-axis is labeled with the correct variable and unit, and the scale is interpretable and can represent all four means and their SEM bars. | Condensed from source Y_UNIT + Y_SCALE. |
| `C3` | All four means are plotted at positions recoverable from the graph and consistent with the data table. | Same as source PLOT_VALUES. |
| `C4` | Each mean has centered, symmetric plus/minus one SEM error bars. | Same as source UNCERTAINTY_MARKS. |

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

Bar graph in table order (cool, room temp, warm, heat stress), y-axis labeled 'Mean mitotic cells (%)' with a 0-45 scale in steps of 5. Bar heights match 11, 31, 36, 40. Symmetric whiskers on each bar matching the reported SEMs (0.3, 1.0, 0.7, 1.6).

#### R2

Bar graph with bars for cool, room temp, warm, heat stress in table order, y-axis labeled '% mitotic cells.' Bar heights for cool, room temp, and warm match the table, but the heat stress bar is drawn noticeably shorter, at roughly 25 rather than 40.

#### R3

Bar graph in table order, y-axis correctly labeled and scaled, all four bar heights matching the table closely. All four bars have symmetric whiskers, but every whisker appears to be the same fixed width regardless of the differing reported SEM values (0.3 vs. 1.6).

#### R4

Point-with-whisker graph in table order, y-axis correctly labeled and scaled. Points at approximately 11, 30, 37, 41 -- each within about 1-2 units of the table. Whisker widths visibly scale with the reported SEMs, narrowest at cool and widest at heat stress.

#### R5

Bar graph with bars in the order cool, room temp, heat stress, warm (heat stress and warm swapped relative to the table). Y-axis correctly labeled and scaled. Bar heights for the swapped pair match their own data (heat stress at 40, warm at 36) but appear in the wrong x-axis position. Symmetric whiskers present matching each bar's own SEM.

## Draft Label Matrix

**Label status:** Claude-authored draft, `ai_provisional_unapproved`. NOT confirmed by Learning Quality.

| Response ID | `C1` | `C2` | `C3` | `C4` | Reviewer notes |
| --- | --- | --- | --- | --- | --- |
| `R1` | earned | earned | earned | earned | Full-credit response matching the source data on every criterion, including the largest SEM (heat stress, 1.6) drawn visibly wider than the smallest (cool, 0.3). |
| `R2` | earned | earned | not_earned | earned | Three of four bars are plotted accurately, but the fourth (heat stress) is off by roughly 15 percentage points -- well outside a reasonable hand-drawn reading tolerance, so C3 (all four means recoverable and consistent with the table) is not earned even though most of the graph is correct. Flags: partial plotting error, under-credit risk if grader treats 'mostly correct' as sufficient for a criterion requiring all four values. |
| `R3` | earned | earned | earned | not_earned | Error bars are present and visually symmetric, but they do not scale with the reported SEM magnitudes -- the cool treatment's much smaller SEM (0.3) should look visibly narrower than heat stress's (1.6), and here all four look identical. This does not meet the uncertainty-marks criterion, which requires the bars to represent the actual reported SEM per treatment, not a uniform decorative whisker. Flags: uncertainty marks present but not data-driven, over-credit risk if grader checks only for whisker presence. |
| `R4` | earned | earned | earned | earned | Second full-credit response; confirms the point-with-whisker variant is scored identically to the bar variant when all criteria are met. |
| `R5` | not_earned | earned | earned | earned | The magnitudes and uncertainty bars are all individually correct for whichever treatment they're attached to, but two categories are swapped out of table order, which fails the category-identity half of C1 even though every other criterion checks out. Flags: category order violation, illustrates that C1 can fail independently of C3/C4 being otherwise clean. |

## Boundary Tags Index (visual failure modes)

- `R1`: (none)
- `R2`: `under_credit_risk`, `partial_plotting_error`
- `R3`: `over_credit_risk`, `uncertainty_marks_not_data_driven`
- `R4`: (none)
- `R5`: `rubric_drift_category_order`
