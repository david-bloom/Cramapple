# Hand-Drawn Input Packet -- Stomatal Density Across Four Light Exposure Treatments

**Subject:** AP Biology
**Answer type:** Hand-drawn graph response
**Source item:** `HDG-2026-P2-CAT-002`
**Archetype:** categorical_comparison_supplied_uncertainty
**Version:** `v1.0-ai-provisional-2026-07-06`
**Label status:** `ai_provisional_unapproved`

## Prompt (reused from source item)

Researchers measured leaf pore density for four treatment groups. Use the data table to construct a graph that compares the group means. Include a categorical x-axis with the treatments in table order, a y-axis labeled with units, plotted means, and symmetric error bars showing plus or minus one SEM.

## Data Table (reused from source item)

| Treatment | Mean stomatal density (stomata/mm^2) | SEM (stomata/mm^2) |
| --- | --- | --- |
| deep shade | 32.0 | 0.8 |
| partial shade | 70.0 | 0.8 |
| open sun | 20.0 | 0.3 |
| reflected sun | 47.0 | 0.8 |

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

Bar graph in table order (deep shade, partial shade, open sun, reflected sun), y-axis labeled 'Mean stomatal density (stomata/mm^2)' with a clean 0-80 scale in steps of 10. Bar heights closely match 32, 70, 20, 47. Each bar has a small, centered, symmetric whisker consistent with the reported SEMs.

#### R2

A line graph connecting the four treatment means with straight segments, x-axis in table order but treated as if it were a continuous numeric variable. Y-axis correctly labeled and scaled. Error bars present and symmetric.

#### R3

Bar graph in table order, y-axis labeled only 'Density' (no unit, no full variable name). Bar heights match the table. Error bars present and symmetric, matching reported SEMs.

#### R4

Point-with-whisker graph in table order, y-axis correctly labeled and scaled. Points plotted at approximately 34, 68, 22, 46 -- each within about 2 units of the reported means. Symmetric whiskers present and roughly matching reported SEMs.

#### R5

Bar graph in table order, y-axis correctly labeled and scaled, bar heights matching the table. Error bars are drawn on only two of the four bars (deep shade and open sun); the other two bars (partial shade and reflected sun) have no visible whiskers at all.

## Draft Label Matrix

**Label status:** Claude-authored draft, `ai_provisional_unapproved`. NOT confirmed by Learning Quality.

| Response ID | `C1` | `C2` | `C3` | `C4` | Reviewer notes |
| --- | --- | --- | --- | --- | --- |
| `R1` | earned | earned | earned | earned | Full-credit response matching the source data on every criterion. |
| `R2` | not_earned | earned | earned | earned | Treatment is a categorical variable (four unordered light-exposure conditions), not a continuous quantity, so connecting the means with line segments as though it were a continuous series is not an accepted categorical representation -- this is the specific error the categorical-vs-series distinction is meant to catch, even though axis labeling, values, and uncertainty marks are otherwise correct. Flags: wrong representation type for a categorical variable, boundary case between CAT and SER archetypes. |
| `R3` | earned | not_earned | earned | earned | Everything is correct except the y-axis label drops both the specific variable name (stomatal density) and the unit (stomata/mm^2), leaving only the generic word 'Density' -- insufficient to identify what is actually being measured from the graph alone. Flags: axis label under-specified, over-credit risk if grader treats a generic label as sufficient. |
| `R4` | earned | earned | earned | earned | Values are plotted slightly off the exact table numbers (within about 2 units), which is within the tolerance expected from hand-drawn graph reading against a ruled scale -- still earns PLOT_VALUES. Second full-credit response confirming the tolerance band for 'recoverable from the graph.' |
| `R5` | earned | earned | earned | not_earned | Uncertainty marks are required on every mean, not just some -- two of four bars are entirely missing whiskers, which is a clear (not ambiguous) partial failure of C4. Flags: partial/inconsistent uncertainty marking, under-credit risk if grader awards C4 for 'some bars have error bars.' |

## Boundary Tags Index (visual failure modes)

- `R1`: (none)
- `R2`: `wrong_representation_for_variable_type`, `rubric_drift_categorical_vs_series`
- `R3`: `over_credit_risk`, `axis_label_underspecified`
- `R4`: (none)
- `R5`: `under_credit_risk`, `partial_uncertainty_marking`
