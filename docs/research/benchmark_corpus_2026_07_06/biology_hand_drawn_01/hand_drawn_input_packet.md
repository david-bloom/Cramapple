# Hand-Drawn Input Packet -- Chlorophyll Absorbance Across Four Light Treatments

**Subject:** AP Biology
**Answer type:** Hand-drawn graph response
**Source item:** `HDG-2026-P2-CAT-001`
**Archetype:** categorical_comparison_supplied_uncertainty
**Version:** `v1.0-ai-provisional-2026-07-06`
**Label status:** `ai_provisional_unapproved`

## Prompt (reused from source item)

Researchers measured chlorophyll absorbance for four treatment groups. Use the data table to construct a graph that compares the group means. Include a categorical x-axis with the treatments in table order, a y-axis labeled with units, plotted means, and symmetric error bars showing plus or minus one SEM.

## Data Table (reused from source item)

| Treatment | Mean absorbance at 540 nm (a.u.) | SEM (a.u.) |
| --- | --- | --- |
| low blue | 44.0 | 1.2 |
| moderate blue | 32.0 | 0.6 |
| high blue | 59.0 | 1.1 |
| mixed light | 52.0 | 0.7 |

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
| `R2` | 1 |
| `R3` | 3 |
| `R4` | 4 |
| `R5` | 1 |

#### R1

Bar graph with four bars in table order (low blue, moderate blue, high blue, mixed light), x-axis labeled 'Treatment.' Y-axis labeled 'Mean absorbance at 540 nm (a.u.)' with evenly spaced gridlines from 0 to 65 in steps of 5. Bar heights closely match 44, 32, 59, 52. Each bar has a centered whisker extending symmetrically above and below the bar top, with cap widths roughly matching the reported SEM values (1.2, 0.6, 1.1, 0.7).

#### R2

Bar graph with bars in the order high blue, low blue, mixed light, moderate blue (not table order). Y-axis has no unit label, just 'Absorbance.' Bar heights are close to the correct means. No error bars of any kind are drawn.

#### R3

Bar graph in correct table order, y-axis labeled 'Mean absorbance at 540 nm (a.u.)' with an interpretable scale. Bar heights match the table well. Error bars are drawn, but they appear only above each bar (not below), and the cap width looks closer to double the reported SEM than to a single SEM.

#### R4

Point-with-whisker graph (dots instead of bars) in correct table order, y-axis correctly labeled and scaled. Dots are placed at heights matching 44, 32, 59, 52, each with a symmetric whisker matching the reported SEM.

#### R5

Bar graph in correct table order with a y-axis labeled 'Absorbance (a.u.)' but with an unevenly spaced, hand-drawn scale that compresses the space between 40 and 60, making the high blue (59) and mixed light (52) bars look nearly the same height even though they should differ by 7 units. Error bars are present and roughly symmetric, but their exact width is hard to measure precisely against the compressed scale.

## Draft Label Matrix

**Label status:** Claude-authored draft, `ai_provisional_unapproved`. NOT confirmed by Learning Quality.

| Response ID | `C1` | `C2` | `C3` | `C4` | Reviewer notes |
| --- | --- | --- | --- | --- | --- |
| `R1` | earned | earned | earned | earned | Full-credit response. Graph type, category order, axis labeling/scale, plotted values, and error bars all match the source data. |
| `R2` | not_earned | not_earned | earned | not_earned | Category order does not follow the table, so C1 (which requires table-order category identity) is not earned even though the representation type itself is acceptable. Y-axis label is missing its unit, so C2 is not earned. Values are plotted reasonably accurately (C3 earned). No uncertainty marks appear at all -- clear miss, not an ambiguous case. Flags: category order not preserved, missing axis unit, missing evidence for uncertainty. |
| `R3` | earned | earned | earned | not_earned | Graph type, order, axis, and plotted values are all correct. Error bars are present but are one-sided rather than symmetric, and appear closer to +/-2 SEM in magnitude than +/-1 SEM as specified -- this does not meet the 'centered, symmetric, one-SEM' requirement. Flags: visual misread of uncertainty convention (one-sided bars), possible SEM-vs-2xSEM confusion. |
| `R4` | earned | earned | earned | earned | Second full-credit response using the point-with-whisker variant explicitly listed as acceptable in the source item's accepted_variants; confirms grader tolerance for both bar and point representations. |
| `R5` | earned | unable_to_determine | unable_to_determine | unable_to_determine | Graph type and category order are clearly correct. However, the compressed/uneven y-scale makes it genuinely hard to verify whether the plotted values and error-bar widths recover the reported numbers precisely -- this is a visual-ambiguity case rather than a clear pass or fail, and should not be scored as earned or not_earned without a second reviewer's measurement pass on the actual image. Flags: visual ambiguity from uneven scale, reviewer disagreement risk. |

## Boundary Tags Index (visual failure modes)

- `R1`: (none)
- `R2`: `missing_evidence`, `rubric_drift_category_order`
- `R3`: `visual_misread`, `over_credit_risk_if_bars_uncounted`
- `R4`: (none)
- `R5`: `visual_ambiguity`, `rubric_drift_scale_uniformity`
