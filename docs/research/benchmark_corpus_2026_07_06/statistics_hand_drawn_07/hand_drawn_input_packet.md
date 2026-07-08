# Hand-Drawn Input Packet -- Segmented Bar Graph for Explanation Quality Before/After a Simulation Lesson

**Subject:** AP Statistics
**Answer type:** Hand-drawn graph response
**Source item:** `APSTATS-HDG-2026-GRAPH-008`
**Archetype:** segmented_bar_graph_construction
**Version:** `v1.0-ai-provisional-2026-07-06`
**Label status:** `ai_provisional_unapproved`

## Prompt (reused from source item)

A teacher scored short written explanations before and after a simulation lesson. Complete a segmented bar graph using relative frequencies for each lesson timing group. Then state whether the relative frequency of correct explanations increased after the lesson.

## Data Table (reused from source item)

| Lesson timing | Incorrect | Partially correct | Correct |
| --- | --- | --- | --- |
| Before lesson | 30 | 42 | 28 |
| After lesson | 14 | 30 | 56 |

## Capture Instruction (reused from source item)

Draw one graph on one page. Write only the item ID at the top of the page, then photograph the full page with all graph evidence visible. Do not expose criterion definitions to the person drawing the graph.

## Visual Grading Contract (condensed to 4 criteria for this package)

| Criterion ID | Criterion | Notes for reviewer |
| --- | --- | --- |
| `C1` | Converts counts to correct within-group relative frequencies. | Reused directly from source RELATIVE_FREQUENCIES. |
| `C2` | Draws two complete segmented bars with total length 1 or 100%. | Reused directly from source SEGMENTED_BARS. |
| `C3` | Segments and lesson timing groups are identifiable. | Reused directly from source CATEGORY_LABELS. |
| `C4` | Correctly states that correct explanations increased after the lesson. | Reused directly from source COMPARISON. |

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

Two full-height segmented bars. Before-lesson bar divided into 30% Incorrect, 42% Partially correct, 28% Correct, each labeled. After-lesson bar divided into 14% Incorrect, 30% Partially correct, 56% Correct, each labeled. Both bars labeled with lesson timing beneath them and a legend. Written answer: 'Yes, the relative frequency of correct explanations increased after the lesson, from 28% before to 56% after.'

#### R2

Two segmented bars with correctly computed relative frequencies (0.30/0.42/0.28 and 0.14/0.30/0.56), each totaling 100%, but with no labels identifying which bar is 'Before lesson' and which is 'After lesson,' and no legend distinguishing the three segment colors from each other. Written answer correctly states that correct explanations increased.

#### R3

Two segmented bars correctly showing relative frequencies, correctly totaling 100%, clearly labeled with lesson-timing groups and a legend. Written answer: 'The relative frequency of correct explanations changed after the lesson.'

#### R4

Two segmented bars correctly showing relative frequencies (0.30/0.42/0.28 and 0.14/0.30/0.56), each totaling 100%, clearly labeled with lesson timing and a legend identifying Incorrect/Partially correct/Correct. Written answer: 'Yes -- the relative frequency of correct explanations rose from 0.28 (28%) before the lesson to 0.56 (56%) after the lesson, a clear increase.'

#### R5

Two segmented bars with segment sizes computed from the raw counts directly (30, 42, 28 stacked to a total of 100 for Before; 14, 30, 56 stacked to a total of 100 for After) without ever explicitly labeling the segments as relative frequencies or percentages -- the bars happen to total 100 because the raw group sizes are both 100, but the segment labels just show the raw counts (e.g., '28' rather than '28%' or '0.28'). Written answer correctly states that correct explanations increased.

## Draft Label Matrix

**Label status:** Claude-authored draft, `ai_provisional_unapproved`. NOT confirmed by Learning Quality.

| Response ID | `C1` | `C2` | `C3` | `C4` | Reviewer notes |
| --- | --- | --- | --- | --- | --- |
| `R1` | earned | earned | earned | earned | Full-credit response with correctly computed relative frequencies, complete 100%-total bars, clear labeling, and a correct, numerically-referenced comparison. |
| `R2` | earned | earned | not_earned | earned | Relative frequencies and bar totals are correct, and the final comparison happens to be stated correctly (perhaps from the drawer's own memory of which bar was which), but without any labels on the graph itself, a reviewer working only from the image could not verify which bar represents which group or which color represents which category -- this is exactly what the category-labels criterion is meant to require. Flags: missing evidence for category/group labels, correct conclusion despite unlabeled graph. |
| `R3` | earned | earned | earned | not_earned | The graph is fully correct, but the written answer only says the relative frequency 'changed' rather than specifically stating it increased, which is what the stem asks the response to determine and state. 'Changed' is technically true but doesn't answer the specific yes/no direction the question requires. Flags: vague generality, direction not stated despite being directly askable from the correct graph. |
| `R4` | earned | earned | earned | earned | Second full-credit response with slightly more detail in the comparison statement; confirms grader consistency. |
| `R5` | unable_to_determine | earned | earned | earned | Because both groups happen to have exactly 100 total responses, the raw counts and the relative frequencies (as percentages) are numerically identical in this specific dataset, making it genuinely ambiguous from the image alone whether the drawer understood the relative-frequency conversion conceptually or simply plotted raw counts that happened to coincide with percentages -- flagged unable_to_determine rather than earned, since the criterion is meant to test the conversion step specifically and this dataset doesn't distinguish the two approaches. Flags: rubric ambiguity from coincidental equal group totals, cannot distinguish conceptual understanding from coincidence. |

## Boundary Tags Index (visual failure modes)

- `R1`: (none)
- `R2`: `missing_evidence`
- `R3`: `vague_generality`
- `R4`: (none)
- `R5`: `rubric_ambiguity`
