# Hand-Drawn Graph Batch 50 Grading Test - 2026-06-29

**Input:** `/Users/davidbloom/Documents/Cramapple/Hand Drawn Samples/graph_001.png` through `graph_050.png`  
**Expected key:** `docs/research/hand_drawn_graph_corpus_2026_06_29/trace_sets/set_01/set_01_manifest.json`  
**Method:** Local visual criterion smoke test against the generated graph specs. No external model API was used.

## Result

| Metric | Result |
| --- | ---: |
| Images reviewed | 50 |
| Capture accepted | 50 / 50 |
| Full-credit graph decision | 50 / 50 |
| Abstentions | 0 / 50 |
| Non-obscuring scanner/edge artifact flags | 30 / 50 |
| Prominent edge artifact flags | 3 / 50 |

## Archetype Coverage

| Archetype | Count | Full-credit decisions |
| --- | ---: | ---: |
| categorical comparison with supplied uncertainty | 17 | 17 |
| continuous measured series with supplied uncertainty | 17 | 17 |
| continuous relationship / graph-derived estimate | 16 | 16 |

## Findings

1. All 50 images preserve the item ID, axes, labels, plotted values, and required visual feature for their archetype.
2. Categorical and continuous-series responses consistently include the required uncertainty marks.
3. Relationship/estimate responses consistently include the best-fit/trend line and a visible estimate annotation.
4. Scanner artifacts are common at page edges, but none obscure the graph evidence in this batch.
5. `graph_014`, `graph_019`, and `graph_031` have the most prominent non-graph edge artifacts and should be useful challenge cases for crop/quality handling.

## Limits

This is a smoke test on traced/redrawn graphs, not an independent student-response validation set. It supports capture and reviewer-pipeline testing, but not production promotion by itself. The next useful test is to have reviewers score these blind in the reviewer portal and compare criterion-level agreement against this expected key.

## Artifacts

- `batch_50_grading_results.csv`
- `batch_50_grading_results.jsonl`
- Source contact sheet: `/Users/davidbloom/Documents/Cramapple/Hand Drawn Samples/graphs_pdf_split_contact_sheet.jpg`
