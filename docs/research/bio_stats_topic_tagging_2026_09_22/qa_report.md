# QA — Biology & Statistics Topic Labels

Reviewer: Claude (independent QA, different model from the builder). Date: 2026-09-22.
Builder: Codex, this directory's `topic_labels_proposal.csv` (502 rows).
Method: every structural claim recomputed independently against Production
(`pcntajvbdfqhbeewmdry`, read-only); content sampled by hand. No builder file was modified.

## Decision

**ACCEPT AP Biology** (118 items) — structurally clean, content sampling holds up. Route the six
flagged items to a human and land the rest.

**REJECT AP Statistics** (384 items) — structurally clean but **content-invalid on identifiable
template blocks**. 56 items carry a demonstrably wrong topic, and the errors are systematic rather
than random, which means the underlying selection logic needs a fix rather than the rows needing
spot repair.

Neither subject may serve until Product Owner approval under DECISION-0055 regardless of this QA.

## What passed — structure

| Check | Result |
| --- | --- |
| Rows / distinct items | 502 / 502 — no duplicates |
| Coverage vs published set | 502 of 502, zero missing, zero extra |
| Exactly one primary topic per item | 502 / 502 |
| **Every proposed code exists in that subject's closed list** | **73 / 73 distinct (subject, code) pairs valid — 0 invalid** |
| **`primary_unit_number` matches the code's registry unit** | **73 / 73 — 0 mismatches** |
| Cross-subject code leakage | 0 |
| Pinned `taxonomy_source_version` | correct per subject |

The closed-list constraint did its job: **an invented topic was structurally impossible and none
appeared.** That is the single most valuable property of this design and it held.

### A correction to my own first read

I initially flagged as critical that AP Statistics had *zero* items in Units 6–9. That was my
error, not the builder's. The **current** AP Statistics CED has **five** units — Exploring
One-Variable Data and Collecting Data; Probability, Random Variables, and Probability
Distributions; Inference for Categorical Data: Proportions; Inference for Quantitative Data: Means;
Regression Analysis. I was working from the older 9-unit framework. Verified against
`subject packs/Statistics/ap-statistics-course-and-exam-description.pdf`. The registry is correct
and so was the builder.

**This has a consequence worth recording.** The content's own author-time `subtopics` strings use
the **legacy 9-unit** numbering (`Unit 6:`, `Unit 7:`, `Unit 9:` all appear). The registry uses the
**current 5-unit** structure. So `agreement_with_author_prose='no'` on 85 items is at least partly
an artifact of comparing two different CED editions, not evidence of a labelling error. That
column should not be read as an accuracy signal.

## What failed — content

62 findings across 62 distinct items, in `qa_findings.csv`. Four systematic classes:

| Class | Items | Severity |
| --- | ---: | --- |
| Compare-two-groups items labelled `1.7` (one variable) instead of `1.9` (comparisons) | 20 | high |
| Sampling-**method** items labelled as something else, incl. `4.1 Sampling Distributions for Sample Means` | 11 | high |
| Graph-construction items labelled from a boilerplate stem that carries no content | 24 | medium |
| Regression / slope / correlation items labelled in Unit 1 instead of Unit 5 | 5 | high |
| Biology: osmosis / water-potential investigation labelled `1.1 Structure of Water` | 2 | high |

**The failures are template-shaped, not random.** Each class is one repeated item template where
the same wrong choice was made every time. Examples:

- `apstat-compare_stats-*` — "records X for two groups… Group A / Group B… compare" is the
  definition of **1.9 Comparisons of the Distributions for One Quantitative Variable**. All 20 got
  `1.7`.
- `apstat-u1-11-2a-sampling-*` — "Sampling plan: … Which choice best describes the sampling
  method?" is **1.11 Random Sampling** or **1.12 Potential Problems with Sampling**. One was given
  `4.1 Sampling Distributions for Sample Means`, which is the classic sampling-method versus
  sampling-distribution confusion — a different concept entirely.
- `APSTAT-MOD8-M004` — "The regression line is y = 3x + 5. Interpret the slope…" was given
  `1.3 Tabular Representation and Summary Statistics for One Categorical Variable`. The item is not
  categorical, not tabular, and not Unit 1.
- `APSTATS-HDG-2026-GRAPH-*` (24 items) — stem is only "Submit one photograph showing your
  constructed graph and your written response together." No topic can be derived from that. The
  assigned `1.3` is a default, not a judgement, and the same pattern exists in Biology's HDG items.

## Why this happened, and what to fix

Two topic codes absorb **45% of the Statistics corpus** — `1.3` (92 items) and `1.7` (81). That
concentration is the symptom. Three causes, in order of impact:

1. **The stem was treated as sufficient.** For templated MCQ and for graph-construction items the
   stem carries little or no topic signal; the discriminating content is in the **stimulus** and,
   for FRQ, the **rubric**. The same lesson came out of the difficulty work earlier today: short
   Statistics stems keep their content in `stimulus`, not `stem`.
2. **Near-miss topics were not separated.** `1.7` vs `1.9`, and sampling *method* vs sampling
   *distribution*, are exactly the adjacent-pair distinctions the work order warned about. The
   builder resolved them consistently in the wrong direction.
3. **A default was used where a flag was correct.** For the 24 HDG items the honest output is
   "cannot determine from available fields — route to human", not a plausible-looking code.

**Recommended fix for the Statistics rerun:** build the classification blob from
`stem + stimulus + rubric criteria + subtopics`, not the stem alone; add an explicit pre-pass that
detects the known templates (`compare_stats`, `sampling plan`, `HDG-GRAPH`, regression-slope) and
routes each to its correct topic family; and allow an explicit `undetermined` output rather than
forcing a code.

## Calibration signals the builder reported

- **Confidence: 358 `low`, 144 `medium`, 0 `high`.** The builder had low confidence on 71% of its
  own output and said so. That is honest reporting and it is consistent with what I found.
- **`needs_human`: 372 of 502 (74%).** Also honest — but a proposal where three-quarters of rows
  need human review is not a labour saving at this quality level.
- **`agreement_with_explainer_retrieval`: `na` on all 502.** The second in-house corroborating
  signal never ran. That matters: the design assumed two independent signals and only one was
  available, which is consistent with the low confidence and is a gap to close before a rerun.

## Bottom line

The **mechanism** is sound — closed-list selection made invalid topics impossible, and that held
perfectly across 502 items. The **Biology output is usable** after six human checks. The
**Statistics output is not**, and the reason is diagnosable and fixable rather than fundamental:
it read the wrong fields for templated items and resolved adjacent-topic ties the wrong way.

Biology closes GAP-1 for 118 items pending Product Owner approval. Statistics needs one more
build pass before it is worth a human's time.
