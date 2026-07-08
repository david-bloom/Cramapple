# Hand-Drawn Input Packet -- Side-by-Side Boxplots for Delivery Times by Route Type

**Subject:** AP Statistics
**Answer type:** Hand-drawn graph response
**Source item:** `APSTATS-HDG-2026-GRAPH-001`
**Archetype:** boxplot_construction_interpretation
**Version:** `v1.0-ai-provisional-2026-07-06`
**Label status:** `ai_provisional_unapproved`

## Prompt (reused from source item)

A logistics teacher recorded delivery times for two route types. Construct side-by-side boxplots from the five-number summaries, using one common horizontal or vertical scale. Then write one sentence comparing the centers and one sentence comparing the variability.

## Data Table (reused from source item)

| Route type | Min | Q1 | Median | Q3 | Max |
| --- | --- | --- | --- | --- | --- |
| Rural | 24 | 28 | 31 | 38 | 42 |
| Urban | 30 | 33 | 37 | 45 | 49 |

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
| `R2` | 1 |
| `R3` | 3 |
| `R4` | 4 |
| `R5` | 2 |

#### R1

Two boxplots drawn on one shared horizontal scale from 20 to 50. Rural box spans 24-28-31-38-42 with whiskers to the min/max; Urban box spans 30-33-37-45-49, positioned clearly higher along the scale. Written sentences: 'Urban routes have a higher median delivery time (37 min) than rural routes (31 min).' and 'Urban routes also have more variability, with a larger IQR (12 vs. 10 minutes) and a larger range (19 vs. 18 minutes).'

#### R2

Two boxplots drawn on separate scales: Rural on a 20-45 scale and Urban on a 25-50 scale, positioned side by side but not aligned to the same axis. Five-number summaries for each box otherwise match the table. Sentences: 'The two routes have different times.' and 'They also have different spreads.'

#### R3

Two boxplots on one common scale from 20 to 50, five-number summaries matching the table for both groups. Sentences: 'Urban has a higher median (37) than rural (31).' 'Urban and rural have about the same spread.'

#### R4

Two boxplots on one common vertical scale from 20 to 50, five-number summaries matching the table for both groups, drawn as vertical boxplots side by side rather than horizontal. Sentences: 'The median delivery time for urban routes (37 minutes) is higher than for rural routes (31 minutes).' 'Urban routes also show greater variability, with both a larger IQR (45-33=12 vs. 38-28=10) and a larger range (49-30=19 vs. 42-24=18).'

#### R5

Two boxplots on one common scale. Rural box matches the table exactly. Urban box has Min/Q1/Median/Q3 matching the table (30/33/37/45) but the max whisker is drawn extending to 55 instead of 49, apparently transcribing a value from a different row. Sentences correctly compare medians and correctly note urban has greater variability, referencing the (incorrect) whisker-implied range.

## Draft Label Matrix

**Label status:** Claude-authored draft, `ai_provisional_unapproved`. NOT confirmed by Learning Quality.

| Response ID | `C1` | `C2` | `C3` | `C4` | Reviewer notes |
| --- | --- | --- | --- | --- | --- |
| `R1` | earned | earned | earned | earned | Full-credit response. Both boxplots correctly recover the five-number summaries on one shared scale, and both comparison sentences are correct and reference specific numeric values in context. |
| `R2` | not_earned | earned | not_earned | not_earned | Using two different scales for the two boxplots defeats the purpose of a side-by-side comparison -- visually, box positions can no longer be compared directly, so C1 is not earned even though each box individually recovers its own five-number summary. Both comparison sentences are also too vague to earn credit -- neither references the median values or IQR/range numbers, just 'different,' which doesn't demonstrate the required comparison. Flags: non-common scale defeats comparison purpose, vague generality in both comparison sentences. |
| `R3` | earned | earned | earned | not_earned | Scale, five-number values, and the center comparison are all correct. But the variability comparison is wrong -- Urban's IQR (12) and range (19) are both larger than Rural's (10 and 18), so 'about the same spread' misreads the visually larger Urban box and whisker span. Flags: visual misread of relative box/whisker widths. |
| `R4` | earned | earned | earned | earned | Second full-credit response using the vertical-orientation variant explicitly allowed by the stem ('horizontal or vertical scale'); confirms grader tolerance for either orientation. |
| `R5` | earned | not_earned | earned | unable_to_determine | One of the ten required five-number-summary values (Urban max) does not match the table, so C2 is not earned. The center comparison is unaffected and correct. The variability comparison's conclusion (urban has greater spread) is still directionally correct, but since it's partly based on the mis-transcribed max, it's unclear whether to credit the reasoning or treat it as tainted by the upstream data error -- flagged unable_to_determine for reviewer judgment on how to handle a correct conclusion built on an incorrect plotted value. Flags: single five-number-summary value error, reviewer judgment call on downstream criteria. |

## Boundary Tags Index (visual failure modes)

- `R1`: (none)
- `R2`: `rubric_drift_non_common_scale`, `vague_generality`
- `R3`: `visual_misread`
- `R4`: (none)
- `R5`: `rubric_ambiguity`, `correct_conclusion_tainted_by_data_error`
