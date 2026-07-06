# Hand-Drawn Input Packet -- Dotplot of Customer Wait Times

**Subject:** AP Statistics
**Answer type:** Hand-drawn graph response
**Source item:** `APSTATS-HDG-2026-GRAPH-004`
**Archetype:** dotplot_distribution_shape
**Version:** `v1.0-ai-provisional-2026-07-06`
**Label status:** `ai_provisional_unapproved`

## Prompt (reused from source item)

A sample of 12 customer wait times is shown below. Construct a dotplot of the data, then describe the distribution's shape and identify any possible outlier.

## Data Table (reused from source item)

| Wait time (min) |
| --- |
| 4 |
| 5 |
| 5 |
| 6 |
| 6 |
| 6 |
| 7 |
| 7 |
| 8 |
| 11 |
| 12 |
| 14 |

## Capture Instruction (reused from source item)

Draw one graph on one page. Write only the item ID at the top of the page, then photograph the full page with all graph evidence visible. Do not expose criterion definitions to the person drawing the graph.

## Visual Grading Contract (condensed to 4 criteria for this package)

| Criterion ID | Criterion | Notes for reviewer |
| --- | --- | --- |
| `C1` | Plots the correct number of dots at each wait time. | Reused directly from source DOT_COUNTS. |
| `C2` | Uses an interpretable numeric scale covering 4 through 14. | Reused directly from source AXIS_SCALE. |
| `C3` | Describes the distribution as right-skewed in context. | Reused directly from source SHAPE_DESCRIPTION. |
| `C4` | Identifies 14 minutes as a possible high outlier or unusual value. | Reused directly from source OUTLIER_NOTE. |

**Important:** no real photographed student responses exist for this item. Each response below is a textual description of a hypothetical drawn page, not an actual photograph.

## Response Set

| Response ID | Points (Claude-provisional) |
| --- | ---: |
| `R1` | 4 |
| `R2` | 2 |
| `R3` | 3 |
| `R4` | 4 |
| `R5` | 3 |

#### R1

Dotplot on a numeric axis from 4 to 14 minutes, with dots stacked correctly: one at 4, two at 5, three at 6, two at 7, one at 8, one at 11, one at 12, one at 14. Written answer: 'The distribution of wait times is right-skewed, with most wait times clustered between 4 and 8 minutes and a longer tail toward higher values. The wait time of 14 minutes is a possible high outlier compared to the rest of the data.'

#### R2

Dotplot with dots stacked at 4, 5, 5, 6, 6, 6, 7, 7, 8, 11, 12, 14 on a numeric axis from 4 to 14, matching the table exactly. Written answer: 'The distribution is left-skewed since most of the data is bunched up on the right side near 14.' No mention of an outlier.

#### R3

Dotplot with correct dot counts on a correct numeric axis. Written answer: 'The distribution is right-skewed. There's a possible outlier.'

#### R4

Dotplot with correct dot counts (one at 4, two at 5, three at 6, two at 7, one at 8, one at 11, one at 12, one at 14) on an interpretable numeric axis from 4 to 14. Written answer: 'This distribution is right-skewed, since most wait times are low (4-8 minutes) with a few unusually long waits stretching the distribution toward higher values. The 14-minute wait time stands out as a possible high outlier, well beyond the rest of the cluster.'

#### R5

Dotplot with 11 dots total instead of 12 -- appears to be missing one of the three dots at wait time 6 (only two dots shown at 6 instead of three). Axis and remaining dot placements otherwise correct. Written answer correctly describes right-skew and correctly identifies 14 minutes as the possible outlier.

## Draft Label Matrix

**Label status:** Claude-authored draft, `ai_provisional_unapproved`. NOT confirmed by Learning Quality.

| Response ID | `C1` | `C2` | `C3` | `C4` | Reviewer notes |
| --- | --- | --- | --- | --- | --- |
| `R1` | earned | earned | earned | earned | Full-credit response with correct dot counts, an interpretable axis covering the full range, a correctly directed and contextualized shape description, and correct outlier identification. |
| `R2` | earned | earned | not_earned | not_earned | Dot counts and axis are both correct, but the shape description reverses the skew direction -- the data is actually clustered at the low end (4-8) with a long tail toward the higher values (11-14), which is right-skewed, not left-skewed as described. No outlier is mentioned at all. Flags: skew direction reversed, missing evidence for outlier identification. |
| `R3` | earned | earned | earned | not_earned | Shape description correctly identifies right-skew. However, the outlier note never identifies which value (14 minutes) is the possible outlier -- 'there's a possible outlier' without naming it does not demonstrate the specific identification the criterion requires. Flags: over-credit risk if grader accepts a vague outlier mention without the specific value. |
| `R4` | earned | earned | earned | earned | Second full-credit response with more detailed shape/outlier reasoning; confirms grader consistency. |
| `R5` | not_earned | earned | earned | earned | One dot is missing from the required 12, which fails the dot-count criterion even though the overall shape and outlier conclusions (which are somewhat robust to losing a single interior data point) remain correct. Flags: single dot omitted, illustrates that a shape/outlier conclusion can still be correct even when the underlying plot has a minor count error. |

## Boundary Tags Index (visual failure modes)

- `R1`: (none)
- `R2`: `skew_direction_reversed`, `missing_evidence`
- `R3`: `over_credit_risk`, `vague_generality`
- `R4`: (none)
- `R5`: `under_credit_risk`, `single_dot_omitted`
