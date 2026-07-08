# Hand-Drawn Input Packet -- Enzyme Product Formed Across Four pH Treatments

**Subject:** AP Biology
**Answer type:** Hand-drawn graph response
**Source item:** `HDG-2026-P2-CAT-005`
**Archetype:** categorical_comparison_supplied_uncertainty
**Version:** `v1.0-ai-provisional-2026-07-06`
**Label status:** `ai_provisional_unapproved`

## Prompt (reused from source item)

Researchers measured enzyme product for four treatment groups. Use the data table to construct a graph that compares the group means. Include a categorical x-axis with the treatments in table order, a y-axis labeled with units, plotted means, and symmetric error bars showing plus or minus one SEM.

## Data Table (reused from source item)

| Treatment | Mean product formed in 5 min (umol) | SEM (umol) |
| --- | --- | --- |
| pH 5 | 14.0 | 0.3 |
| pH 6 | 31.0 | 0.9 |
| pH 7 | 23.0 | 0.5 |
| pH 8 | 35.0 | 0.7 |

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

Bar graph in table order (pH 5, pH 6, pH 7, pH 8), y-axis labeled 'Mean product formed in 5 min (umol)' with a 0-40 scale in steps of 5. Bar heights match 14, 31, 23, 35. Symmetric whiskers matching the reported SEMs.

#### R2

Bar graph with bars reordered from low to high value: pH 5, pH 7, pH 6, pH 8 (sorted by product amount rather than by table/pH order). Y-axis correctly labeled and scaled, bar heights and error bars all individually correct.

#### R3

Bar graph in table order, y-axis labeled 'Product (umol)' with a scale from 0 to 40. Bar heights match the table. Whiskers are drawn, but they extend asymmetrically -- notably longer above the bar top than below it on all four bars.

#### R4

Point-with-whisker graph in table order, y-axis correctly labeled and scaled. Points at approximately 14, 32, 22, 36 -- each within about 1-2 units of the table. Symmetric whiskers matching the reported SEMs.

#### R5

Bar graph in table order, y-axis labeled and scaled correctly. Bar heights approximately match the table, but the page is a low-resolution photo with significant glare across the pH 6 and pH 7 bars, making it difficult to tell whether whiskers are present on those two bars specifically; pH 5 and pH 8 clearly show symmetric whiskers.

## Draft Label Matrix

**Label status:** Claude-authored draft, `ai_provisional_unapproved`. NOT confirmed by Learning Quality.

| Response ID | `C1` | `C2` | `C3` | `C4` | Reviewer notes |
| --- | --- | --- | --- | --- | --- |
| `R1` | earned | earned | earned | earned | Full-credit response matching the source data on every criterion, including the non-monotonic pattern (pH 7 lower than both pH 6 and pH 8) reproduced correctly. |
| `R2` | not_earned | earned | earned | earned | Reordering by value rather than preserving table order changes the apparent pH sequence and obscures the pH-7-dip pattern that the original table order is designed to show -- category identity/order is not preserved, so C1 is not earned even though all four bars are individually accurate. Flags: category order violation via value-sorting. |
| `R3` | earned | earned | earned | not_earned | Everything else is correct, but the error bars are consistently asymmetric (longer above than below) rather than centered plus/minus one SEM -- this is a clear, not ambiguous, failure since the asymmetry is consistent across all four bars rather than a single measurement artifact. Flags: visual misread of symmetric-uncertainty convention. |
| `R4` | earned | earned | earned | earned | Second full-credit response within normal hand-drawn reading tolerance; confirms grader consistency for the point-with-whisker variant. |
| `R5` | earned | earned | earned | unable_to_determine | Image quality (glare) genuinely obscures whether two of the four required error bars are present -- this should be routed back for a rescan/reshoot rather than scored as either earned or not_earned from this capture. Flags: visual ambiguity from image capture quality, distinct from a genuine drawing omission. |

## Boundary Tags Index (visual failure modes)

- `R1`: (none)
- `R2`: `rubric_drift_category_order`
- `R3`: `visual_misread`
- `R4`: (none)
- `R5`: `visual_ambiguity`, `missing_evidence`
