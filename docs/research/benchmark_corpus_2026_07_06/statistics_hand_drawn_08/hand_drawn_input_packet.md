# Hand-Drawn Input Packet -- Mosaic Plot for Study Time and Caffeine Use

**Subject:** AP Statistics
**Answer type:** Hand-drawn graph response
**Source item:** `APSTATS-HDG-2026-GRAPH-009`
**Archetype:** mosaic_plot_interpretation
**Version:** `v1.0-ai-provisional-2026-07-06`
**Label status:** `ai_provisional_unapproved`

## Prompt (reused from source item)

Students were grouped by usual study time and caffeine use level. Draw a mosaic plot so each study time width is proportional to its total count and each vertical segment shows the conditional distribution of caffeine use within that study time. Then identify which study-time group has the largest number of high-caffeine students.

## Data Table (reused from source item)

| Study time | Low | Medium | High |
| --- | --- | --- | --- |
| Morning | 36 | 42 | 12 |
| Afternoon | 28 | 50 | 32 |
| Evening | 16 | 38 | 46 |

## Capture Instruction (reused from source item)

Draw one graph on one page. Write only the item ID at the top of the page, then photograph the full page with all graph evidence visible. Do not expose criterion definitions to the person drawing the graph.

## Visual Grading Contract (condensed to 4 criteria for this package)

| Criterion ID | Criterion | Notes for reviewer |
| --- | --- | --- |
| `C1` | Study-time widths are proportional to group totals. | Reused directly from source WIDTHS_BY_TOTAL. |
| `C2` | Segment heights use within-group proportions. | Reused directly from source HEIGHTS_BY_CONDITIONAL_PROPORTION. |
| `C3` | Study-time and caffeine-use categories are identifiable. | Reused directly from source SEGMENT_LABELS. |
| `C4` | Correctly identifies Evening as largest high-caffeine count. | Reused directly from source AREA_OR_COUNT_REASONING. |

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

Mosaic plot with three columns: Morning (width proportional to 90/300), Afternoon (width proportional to 110/300), Evening (width proportional to 100/300). Within each column, segments sized to that group's own within-group proportions. All columns and segments labeled clearly with a legend. Written answer: 'Evening has the largest number of high-caffeine students (46), compared with 32 for Afternoon and 12 for Morning.'

#### R2

Mosaic plot with column widths that only roughly follow group totals -- Morning and Evening columns are drawn nearly the same width even though Evening's total (100) is noticeably larger than Morning's (90), and Afternoon (110, the largest) is drawn only slightly wider than the other two rather than clearly the widest. Segment heights within each column are correctly proportioned and labeled. Written answer correctly identifies Evening as having the largest high-caffeine count.

#### R3

Mosaic plot with correctly proportioned column widths and within-group segment heights, all clearly labeled. Written answer: 'Evening has the largest proportion of high-caffeine students.'

#### R4

Mosaic plot with column widths proportional to group totals (90, 110, 100 out of 300) and segment heights proportional to within-group caffeine-use distributions, all columns and segments labeled with study-time and caffeine-level names. Written answer: 'Evening has the largest number of high-caffeine students: 46, compared with 32 for Afternoon and 12 for Morning, even though Afternoon has the largest total group size (110 students).'

#### R5

Mosaic plot with correctly proportioned column widths and correctly labeled study-time groups. Within each column, segment heights are drawn but two of the nine total segments (Afternoon-Medium and Evening-Low) look visually similar in height to their neighbors due to close underlying proportions, making it hard to be fully certain from the drawing alone whether those two specific segments are proportioned correctly or just eyeballed close. The final high-caffeine count comparison is stated correctly.

## Draft Label Matrix

**Label status:** Claude-authored draft, `ai_provisional_unapproved`. NOT confirmed by Learning Quality.

| Response ID | `C1` | `C2` | `C3` | `C4` | Reviewer notes |
| --- | --- | --- | --- | --- | --- |
| `R1` | earned | earned | earned | earned | Full-credit response with correctly proportioned widths and heights, clear labeling, and a correct count-based comparison. |
| `R2` | unable_to_determine | earned | earned | earned | The three group totals (90, 110, 100) are close enough to each other that visually distinguishing 'roughly proportional' from 'not proportional' column widths from a hand-drawn page is genuinely difficult without a ruler measurement against the actual image -- flagged unable_to_determine rather than a clean fail, since the differences between the totals are small (a maximum 20-unit spread out of 300) and reasonable hand-drawing imprecision could produce this same appearance even from a correctly-intended proportional drawing. Flags: visual ambiguity in width proportionality with closely-spaced group totals. |
| `R3` | earned | earned | earned | not_earned | The graph is fully correct, and Evening does happen to have both the largest proportion and the largest count of high-caffeine students, but the response answers a different question than the one asked (proportion rather than count) -- the criterion specifically requires count-based reasoning ('largest number'), which is a distinct comparison from proportion and would give a different answer with a different dataset. Flags: proportion-vs-count conflation, same failure pattern as statistics_hand_drawn_03's R3. |
| `R4` | earned | earned | earned | earned | Second full-credit response with an additional correct observation distinguishing the largest-count group from the largest-total-group; useful for confirming the grader rewards the extra correct distinction. |
| `R5` | earned | unable_to_determine | earned | earned | Most of the mosaic plot is clearly correct and the final answer is right, but two specific segments are close enough in apparent size that a confident earned/not_earned call on the height-proportionality criterion isn't possible without measuring the actual page -- flagged unable_to_determine rather than assumed correct just because the final answer is right. Flags: visual ambiguity in a subset of segments, correct final answer does not resolve an upstream ambiguous criterion. |

## Boundary Tags Index (visual failure modes)

- `R1`: (none)
- `R2`: `visual_ambiguity`
- `R3`: `proportion_count_conflation`
- `R4`: (none)
- `R5`: `visual_ambiguity`
