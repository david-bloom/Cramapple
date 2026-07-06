# Hand-Drawn Input Packet -- Dotplot of Plant Heights After Four Weeks

**Subject:** AP Statistics
**Answer type:** Hand-drawn graph response
**Source item:** `APSTATS-HDG-2026-GRAPH-010`
**Archetype:** dotplot_distribution_shape
**Version:** `v1.0-ai-provisional-2026-07-06`
**Label status:** `ai_provisional_unapproved`

## Prompt (reused from source item)

A biology class measured the heights of 12 plants after four weeks. Construct a dotplot of the data, then describe the distribution's shape and comment on whether there is a clear outlier.

## Data Table (reused from source item)

| Height (cm) |
| --- |
| 68 |
| 70 |
| 71 |
| 72 |
| 72 |
| 73 |
| 74 |
| 74 |
| 75 |
| 76 |
| 78 |
| 82 |

## Capture Instruction (reused from source item)

Draw one graph on one page. Write only the item ID at the top of the page, then photograph the full page with all graph evidence visible. Do not expose criterion definitions to the person drawing the graph.

## Visual Grading Contract (condensed to 4 criteria for this package)

| Criterion ID | Criterion | Notes for reviewer |
| --- | --- | --- |
| `C1` | Plots the correct number of dots at each plant height. | Reused directly from source DOT_COUNTS. |
| `C2` | Uses an interpretable numeric scale covering 68 through 82. | Reused directly from source AXIS_SCALE. |
| `C3` | Describes the distribution as roughly unimodal with slight right tail or similar. | Reused directly from source SHAPE_DESCRIPTION. |
| `C4` | Does not overstate 82 cm as a definite outlier; explains it is high or possibly unusual. | Reused directly from source OUTLIER_NOTE. |

**Important:** no real photographed student responses exist for this item. Each response below is a textual description of a hypothetical drawn page, not an actual photograph.

## Response Set

| Response ID | Points (Claude-provisional) |
| --- | ---: |
| `R1` | 4 |
| `R2` | 2 |
| `R3` | 4 |
| `R4` | 4 |
| `R5` | 3 |

#### R1

Dotplot on a numeric axis from 68 to 82 cm, dots correctly stacked at 68, 70, 71, two at 72, one at 73, two at 74, one at 75, one at 76, one at 78, one at 82. Written answer: 'The distribution of plant heights is roughly unimodal with a slight right tail, with most heights clustered between 70 and 78 cm. The height of 82 cm is on the high end and somewhat separated from the rest of the data, but it is not clearly isolated enough to call it a definite outlier.'

#### R2

Dotplot with dots correctly stacked matching the table, on an axis from 68 to 82. Written answer: 'The distribution is roughly symmetric and bell-shaped. 82 cm is definitely an outlier and should be removed from the data before further analysis.'

#### R3

Dotplot with correct dot counts on a correct axis. Written answer: 'Roughly unimodal, slight right tail. 82 might be unusual.'

#### R4

Dotplot with correct dot counts (68, 70, 71, two at 72, one at 73, two at 74, one at 75, one at 76, one at 78, one at 82) on a numeric axis from 68 to 82. Written answer: 'The plant heights form a roughly unimodal distribution with a slight tail toward higher values. The 82 cm plant is noticeably taller than the rest but not isolated enough from the cluster (which extends up to 78 cm) to be confidently labeled an outlier -- it may simply be a naturally taller plant.'

#### R5

Dotplot with dots correctly stacked at all values except only one dot shown at 72 instead of two (missing one of the two plants at 72 cm). Axis and all other placements correct. Written answer correctly describes the shape and appropriately hedges on the 82 cm value.

## Draft Label Matrix

**Label status:** Claude-authored draft, `ai_provisional_unapproved`. NOT confirmed by Learning Quality.

| Response ID | `C1` | `C2` | `C3` | `C4` | Reviewer notes |
| --- | --- | --- | --- | --- | --- |
| `R1` | earned | earned | earned | earned | Full-credit response with correct dot counts, an interpretable axis, and a shape/outlier description that avoids overstating 82 cm as a definite outlier while still noting it is high, matching the source item's specific intent of testing appropriately hedged outlier language. |
| `R2` | earned | earned | not_earned | not_earned | Dot counts and axis are correct. But the shape description misses the slight right-skew (the distribution has a bit more spread on the high side, from 76 to 82, than on the low side) by calling it simply 'symmetric and bell-shaped.' The outlier statement also overreaches -- 82 cm is only 4 cm above the next-highest value (78) and 14 cm above the minimum (68), which is high but not dramatically separated enough to be called 'definitely' an outlier, and recommending removal goes beyond what this single description task calls for. Flags: shape description overlooks slight skew, outlier claim overstated exactly as this item's OUTLIER_NOTE criterion is designed to catch. |
| `R3` | earned | earned | earned | earned | Brief but complete and correctly hedged -- 'might be unusual' appropriately avoids overstating 82 as a definite outlier while still flagging it as noteworthy, matching the criterion's intent. Full-credit response demonstrating that terse phrasing can still meet the bar if the substance is correct. |
| `R4` | earned | earned | earned | earned | Second full-credit response with more detailed reasoning about why 82 cm shouldn't be called a definite outlier; confirms grader consistency for a more elaborated answer. |
| `R5` | not_earned | earned | earned | earned | One dot is missing at 72 cm, failing the dot-count criterion even though the shape and outlier descriptions (which depend mainly on the overall spread and the top value, not on this specific interior duplicate) remain correct and appropriately hedged. Flags: single dot omitted at an interior value, illustrates the dot-count criterion can fail independently of the shape/outlier criteria. |

## Boundary Tags Index (visual failure modes)

- `R1`: (none)
- `R2`: `overstated_certainty`, `shape_description_overlooks_skew`
- `R3`: (none)
- `R4`: (none)
- `R5`: `under_credit_risk`, `single_dot_omitted`
