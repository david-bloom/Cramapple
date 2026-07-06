# Hand-Drawn Input Packet -- Side-by-Side Boxplots for Commute Times by Transportation Type

**Subject:** AP Statistics
**Answer type:** Hand-drawn graph response
**Source item:** `APSTATS-HDG-2026-GRAPH-007`
**Archetype:** boxplot_construction_interpretation
**Version:** `v1.0-ai-provisional-2026-07-06`
**Label status:** `ai_provisional_unapproved`

## Prompt (reused from source item)

A city planner compared commute times for students who usually ride the bus and students who usually bike. Construct side-by-side boxplots from the five-number summaries using one common scale. Then compare the typical commute time and the spread in context.

## Data Table (reused from source item)

| Transportation | Min | Q1 | Median | Q3 | Max |
| --- | --- | --- | --- | --- | --- |
| Bus | 18 | 24 | 29 | 41 | 55 |
| Bike | 12 | 16 | 19 | 25 | 31 |

## Capture Instruction (reused from source item)

Draw one graph on one page. Write only the item ID at the top of the page, then photograph the full page with all graph evidence visible. Do not expose criterion definitions to the person drawing the graph.

## Visual Grading Contract (condensed to 4 criteria for this package)

| Criterion ID | Criterion | Notes for reviewer |
| --- | --- | --- |
| `C1` | Uses one interpretable common scale for both groups. | Reused directly from source BOXPLOT_SCALE. |
| `C2` | Both boxplots recover the listed five-number summaries. | Reused directly from source FIVE_NUMBER_VALUES. |
| `C3` | Correctly compares medians in context. | Reused directly from source CENTER_COMPARISON. |
| `C4` | Correctly compares IQR or range in context. | Reused directly from source VARIABILITY_COMPARISON. |

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

Two boxplots on one shared scale from 10 to 55. Bus box spans 18-24-29-41-55; Bike box spans 12-16-19-25-31, both matching the table. Written answer: 'The typical (median) commute time is longer for bus riders (29 minutes) than for bike riders (19 minutes).' 'Bus commute times also have much greater spread than bike commute times, both by IQR (17 vs. 9 minutes) and by range (37 vs. 19 minutes).'

#### R2

Two boxplots on one shared scale from 10 to 55, matching the table for both groups. Written answer: 'Bike commutes are typically shorter and less spread out than bus commutes.' No numeric values referenced.

#### R3

Two boxplots on one shared scale, matching the table for both groups. Written answer: 'Bus has a higher median commute time (29 vs. 19 minutes).' 'Bike has more spread, since its box looks wider on the page.'

#### R4

Two boxplots on one shared scale from 10 to 55, five-number summaries for both groups matching the table. Written answer: 'The median commute time for bus riders (29 minutes) is noticeably higher than for bike riders (19 minutes). Bus commute times are also much more variable than bike commute times: the bus IQR (41-24=17 minutes) is nearly double the bike IQR (25-16=9 minutes), and the bus range (55-18=37 minutes) is almost twice the bike range (31-12=19 minutes).'

#### R5

Two boxplots drawn on one shared scale. The Bus box's five-number summary matches the table exactly. The Bike box's Q1, Median, and Q3 match the table (16, 19, 25), but its whiskers are drawn extending to 10 and 35 instead of 12 and 31, apparently smoothing the range outward slightly. Written answer correctly compares medians and correctly identifies bus as having greater spread by both IQR and range.

## Draft Label Matrix

**Label status:** Claude-authored draft, `ai_provisional_unapproved`. NOT confirmed by Learning Quality.

| Response ID | `C1` | `C2` | `C3` | `C4` | Reviewer notes |
| --- | --- | --- | --- | --- | --- |
| `R1` | earned | earned | earned | earned | Full-credit response with correctly recovered five-number summaries on a shared scale and correct, numerically-referenced center and spread comparisons. |
| `R2` | earned | earned | not_earned | not_earned | The direction of both comparisons is correct, but neither sentence references any of the actual median, IQR, or range values from the graph -- this is a vague restatement of the correct conclusion rather than a comparison grounded in the specific five-number summaries, which the criteria (as demonstrated by the reference answer's use of specific numbers) expect. Flags: over-credit risk if grader accepts direction-only comparisons without values, vague generality. |
| `R3` | earned | earned | earned | not_earned | Center comparison is correct and grounded in the right numbers. But the spread comparison reverses the correct conclusion -- Bus actually has the larger IQR (17 vs. 9) and range (37 vs. 19) -- and the stated reasoning ('looks wider on the page') suggests a visual misread of box width, possibly confusing Bike's narrower box position on the shared scale with a wider one. Flags: variability comparison reversed, visual misread of box width. |
| `R4` | earned | earned | earned | earned | Second full-credit response with fully shown IQR/range arithmetic; confirms grader consistency for a more detailed answer. |
| `R5` | earned | not_earned | earned | earned | Bike's min and max are drawn slightly outside the reported values (10/35 instead of 12/31), so C2 (both boxplots recover the listed five-number summaries) is not earned even though the error is small and doesn't change the direction of either comparison conclusion. Flags: whisker endpoint transcription error, illustrates that correct conclusions can coexist with a failed values criterion. |

## Boundary Tags Index (visual failure modes)

- `R1`: (none)
- `R2`: `over_credit_risk`, `vague_generality`
- `R3`: `visual_misread`
- `R4`: (none)
- `R5`: `under_credit_risk`
