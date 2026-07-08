# Hand-Drawn Input Packet -- Segmented Bar Graph for Homework App Use by Class Group

**Subject:** AP Statistics
**Answer type:** Hand-drawn graph response
**Source item:** `APSTATS-HDG-2026-GRAPH-002`
**Archetype:** segmented_bar_graph_construction
**Version:** `v1.0-ai-provisional-2026-07-06`
**Label status:** `ai_provisional_unapproved`

## Prompt (reused from source item)

A school surveyed students about how often they use a homework planning app. Complete a segmented bar graph using relative frequencies for each class group. Then identify which group has the larger relative frequency of weekly app use.

## Data Table (reused from source item)

| Class group | Never | Monthly | Weekly |
| --- | --- | --- | --- |
| Underclass | 20 | 45 | 35 |
| Upperclass | 12 | 38 | 50 |

## Capture Instruction (reused from source item)

Draw one graph on one page. Write only the item ID at the top of the page, then photograph the full page with all graph evidence visible. Do not expose criterion definitions to the person drawing the graph.

## Visual Grading Contract (condensed to 4 criteria for this package)

| Criterion ID | Criterion | Notes for reviewer |
| --- | --- | --- |
| `C1` | Converts counts to correct within-group relative frequencies. | Reused directly from source RELATIVE_FREQUENCIES. |
| `C2` | Draws two complete segmented bars with total length 1 or 100%. | Reused directly from source SEGMENTED_BARS. |
| `C3` | Segments and class groups are identifiable. | Reused directly from source CATEGORY_LABELS. |
| `C4` | Correctly identifies the larger weekly relative frequency. | Reused directly from source COMPARISON. |

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

Two full-height segmented bars, each running 0 to 100%. Underclass bar divided into 20% Never, 45% Monthly, 35% Weekly (bottom to top), each segment labeled with its percentage. Upperclass bar divided into 12% Never, 38% Monthly, 50% Weekly, similarly labeled. Both bars labeled with class group names underneath, and a legend/key identifying the three segment colors. Written answer: 'Upperclass students have the larger relative frequency of weekly app use (50% vs. 35%).'

#### R2

Two segmented bars, but built directly from the raw counts (20, 45, 35 for Underclass; 12, 38, 50 for Upperclass) without converting to relative frequencies, so the Underclass bar totals 100 units tall and the Upperclass bar totals 100 units tall by coincidence of similar group sizes, but the segment labels show raw counts rather than percentages or proportions. Written answer: 'Upperclass has more weekly users (50 vs. 35).'

#### R3

Two segmented bars correctly showing relative frequencies (20/45/35 and 12/38/50 converted to 0.20/0.45/0.35 and 0.12/0.38/0.50), both bars totaling 1.0, with segment and class-group labels. No written comparison sentence is included anywhere on the page.

#### R4

Two segmented bars correctly showing relative frequencies (0.20/0.45/0.35 and 0.12/0.38/0.50), both bars totaling 100%, with clear segment and class-group labels and a small legend. Written answer: 'The relative frequency of weekly app use is 0.50 for Upperclass and 0.35 for Underclass, so Upperclass students have the larger relative frequency of weekly use.'

#### R5

Two segmented bars correctly showing relative frequencies and totaling 100% each. Segment order within each bar is Weekly (bottom), Monthly (middle), Never (top) for Underclass, but Never (bottom), Monthly (middle), Weekly (top) for Upperclass -- the two bars use inconsistent segment orderings, making the two bars hard to visually align and compare segment-by-segment even though each bar's own segments are individually labeled and correctly sized.

## Draft Label Matrix

**Label status:** Claude-authored draft, `ai_provisional_unapproved`. NOT confirmed by Learning Quality.

| Response ID | `C1` | `C2` | `C3` | `C4` | Reviewer notes |
| --- | --- | --- | --- | --- | --- |
| `R1` | earned | earned | earned | earned | Full-credit response with correctly computed relative frequencies, complete 100%-total bars, clear labeling, and a correct, numerically-referenced comparison. |
| `R2` | not_earned | earned | earned | not_earned | Segments are labeled with raw counts, not relative frequencies -- the criterion specifically requires converting to within-group proportions, and comparing raw counts (50 vs. 35) is misleading if the two class groups have different total sizes (here they coincidentally are both 100, but the response never computes or shows that, and the comparison itself is about relative frequency, not raw count). Flags: relative frequency conversion skipped, comparison made on raw counts rather than proportions. |
| `R3` | earned | earned | earned | not_earned | The graph itself is fully correct, but the response never states which group has the larger weekly relative frequency, which the stem explicitly asks for as a separate step. Flags: missing evidence for the required comparison statement, a clear omission. |
| `R4` | earned | earned | earned | earned | Second full-credit response with a more detailed comparison statement; confirms grader consistency. |
| `R5` | earned | earned | unable_to_determine | earned | Each segment is individually labeled and sized correctly, and the response still reaches the correct comparison conclusion, but the inconsistent stacking order between the two bars undermines the visual side-by-side readability that 'segments are identifiable [and comparable]' is meant to capture -- flagged unable_to_determine rather than a clean earned/not_earned, since the labels are technically all present but the graph's comparative clarity is compromised. Flags: rubric ambiguity on cross-bar segment order consistency, visual comparison undermined despite correct individual labels. |

## Boundary Tags Index (visual failure modes)

- `R1`: (none)
- `R2`: `relative_frequency_conversion_skipped`, `comparison_uses_raw_counts`
- `R3`: `missing_evidence`
- `R4`: (none)
- `R5`: `rubric_ambiguity`, `visual_ambiguity`
