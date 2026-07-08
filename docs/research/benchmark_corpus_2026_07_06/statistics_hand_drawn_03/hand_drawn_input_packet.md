# Hand-Drawn Input Packet -- Mosaic Plot for Study Device and Stress Level

**Subject:** AP Statistics
**Answer type:** Hand-drawn graph response
**Source item:** `APSTATS-HDG-2026-GRAPH-003`
**Archetype:** mosaic_plot_interpretation
**Version:** `v1.0-ai-provisional-2026-07-06`
**Label status:** `ai_provisional_unapproved`

## Prompt (reused from source item)

Students were classified by primary study device and reported stress level. Draw a mosaic plot from the table so that each device width is proportional to its total count and each vertical segment shows the conditional distribution of stress level within that device. Then state which device group has the largest number of high-stress students.

## Data Table (reused from source item)

| Device | Low | Medium | High |
| --- | --- | --- | --- |
| Phone | 24 | 36 | 40 |
| Laptop | 18 | 52 | 30 |
| Tablet | 30 | 30 | 20 |

## Capture Instruction (reused from source item)

Draw one graph on one page. Write only the item ID at the top of the page, then photograph the full page with all graph evidence visible. Do not expose criterion definitions to the person drawing the graph.

## Visual Grading Contract (condensed to 4 criteria for this package)

| Criterion ID | Criterion | Notes for reviewer |
| --- | --- | --- |
| `C1` | Device widths are proportional to device totals. | Reused directly from source WIDTHS_BY_TOTAL. |
| `C2` | Segment heights use within-device proportions. | Reused directly from source HEIGHTS_BY_CONDITIONAL_PROPORTION. |
| `C3` | Device and stress-level categories are identifiable. | Reused directly from source SEGMENT_LABELS. |
| `C4` | Correctly identifies Phone as largest high-stress count. | Reused directly from source AREA_OR_COUNT_REASONING. |

**Important:** no real photographed student responses exist for this item. Each response below is a textual description of a hypothetical drawn page, not an actual photograph.

## Response Set

| Response ID | Points (Claude-provisional) |
| --- | ---: |
| `R1` | 4 |
| `R2` | 3 |
| `R3` | 3 |
| `R4` | 4 |
| `R5` | 1 |

#### R1

Mosaic plot with three columns: Phone (width proportional to 100/280), Laptop (width proportional to 100/280), Tablet (width proportional to 80/280). Within each column, vertical segments for Low/Medium/High sized to that device's own within-device proportions (Phone: 24/100, 36/100, 40/100). All columns and segments labeled clearly. Written answer: 'Phone has the largest number of high-stress students (40), compared with 30 for Laptop and 20 for Tablet.'

#### R2

Mosaic plot with three columns of equal width (Phone, Laptop, Tablet each drawn at the same width, not scaled by their totals of 100, 100, and 80). Within each column, segment heights correctly reflect within-device proportions and are clearly labeled. Written answer: 'Phone has the largest number of high-stress students.'

#### R3

Mosaic plot with correctly proportioned column widths and correctly proportioned within-device segment heights, all clearly labeled. Written answer: 'Phone has the highest proportion of high-stress students, since its High segment looks the tallest.'

#### R4

Mosaic plot with column widths proportional to device totals (100, 100, 80 out of 280) and segment heights proportional to within-device stress-level distributions, all columns and segments labeled with device names and stress levels. Written answer: 'Phone has the largest number of high-stress students: 40 students, compared with 30 for Laptop and 20 for Tablet, even though Phone and Laptop have the same total number of students (100 each).'

#### R5

Mosaic plot with column widths proportional to device totals and correctly labeled device names. Within each column, segments are present and roughly sized, but none of the three stress-level segments (Low/Medium/High) are labeled anywhere on the page, and there is no legend or key indicating which segment corresponds to which stress level.

## Draft Label Matrix

**Label status:** Claude-authored draft, `ai_provisional_unapproved`. NOT confirmed by Learning Quality.

| Response ID | `C1` | `C2` | `C3` | `C4` | Reviewer notes |
| --- | --- | --- | --- | --- | --- |
| `R1` | earned | earned | earned | earned | Full-credit response with correctly proportioned widths and heights, clear labeling, and a correct count-based comparison distinguishing area/proportion from raw count. |
| `R2` | not_earned | earned | earned | earned | Column widths are drawn equal rather than proportional to each device's total count (100, 100, 80 out of 280) -- this is the specific feature that distinguishes a mosaic plot from a simple set of separate segmented bars, so C1 is not earned even though the within-device segment heights and the final comparison are both correct. Flags: mosaic-plot width-proportionality omitted, reduces the graph to a set of equal-width segmented bars. |
| `R3` | earned | earned | earned | not_earned | The graph itself is fully correct, but the final answer confuses proportion with count -- the question asks which device has the largest *number* (count) of high-stress students, not the largest proportion. Phone's High segment does happen to be tallest by proportion (40%) as well as largest by count (40 students), so the response reaches the numerically correct device but through proportion-based reasoning rather than the count-based reasoning the criterion specifically requires (since these two forms of reasoning give different answers in other datasets, this distinction matters for grading generalizably). Flags: proportion-vs-count reasoning conflation, correct device via unsound justification. |
| `R4` | earned | earned | earned | earned | Second full-credit response with an additional, correct observation distinguishing Phone from Laptop despite equal totals; useful for confirming the grader rewards this extra correct reasoning without penalizing length. |
| `R5` | earned | unable_to_determine | not_earned | unable_to_determine | Column widths are correctly proportioned and device names are labeled, but with no stress-level segment labels or legend anywhere, it is impossible to verify from the image alone whether segment heights actually correspond to Low/Medium/High in the correct order, or to confirm which segment the response intends as 'High' when identifying the largest count -- both flagged unable_to_determine pending clarification from the drawer rather than assumed correct or incorrect. Flags: missing evidence for segment identity, downstream count-comparison criterion unverifiable without that label. |

## Boundary Tags Index (visual failure modes)

- `R1`: (none)
- `R2`: `mosaic_width_proportionality_omitted`
- `R3`: `proportion_count_conflation`, `correct_conclusion_wrong_reasoning`
- `R4`: (none)
- `R5`: `missing_evidence`, `rubric_ambiguity`
