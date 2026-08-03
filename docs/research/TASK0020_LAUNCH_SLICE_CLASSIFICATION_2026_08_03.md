# TASK-0020 Launch-Slice Classification

Date: 2026-08-03  
Status: provisional semantic classification; Learning Quality validation pending  
Environment: Production metadata, read only  
Locked slice: 48 AP Statistics targeted-drill FRQs plus 41 AP Biology FRQs

## Outcome

The 89-item launch slice contains **one item with a stored prompt image**, **62 items whose prompt depends on text- or JSON-encoded data/visual structure**, **37 items requiring student construction and a photographed response**, and **26 items with no prompt-visual candidate**. Categories overlap: all 37 construction items also contain prompt data needed to construct the response.

This resolves a previously ambiguous count. If “question image” means a raster asset displayed with the prompt, the locked slice has **1**. If it means any prompt content whose successful presentation is required to interpret visual or structured data, the operationally relevant count is **63** (the stored image plus 62 data/structure items). Treating all 63 as image files would add complexity without improving delivery; their different representations should remain explicit.

| Classification | AP Biology | AP Statistics | Total |
|---|---:|---:|---:|
| Stored prompt image | 1 | 0 | 1 |
| Text- or JSON-encoded prompt data/visual structure | 30 | 32 | 62 |
| Student construction required (overlapping subset) | 5 | 32 | 37 |
| No prompt-visual candidate | 10 | 16 | 26 |
| Missing prior figure/table/context found in manual review | 0 | 0 | 0 |

## What the classification means

- **Stored prompt image** means the item has a non-empty `stimulus_image_path`. The sole item is `APBIO-FRQ-S-009`.
- **Text- or JSON-encoded prompt data/visual structure** means the student needs supplied table values, relationships, or visual structure, but the source is in the stimulus text or structured prompt JSON rather than a raster asset.
- **Student construction required** means the answer construct explicitly requires a graph or plot and the prompt instructs the learner to submit a photograph. This is Program B scope even when no prompt image exists.
- **Missing prior context** means the prompt refers to a required figure, table, earlier part, or external source that is absent. Manual review found no such case in the locked slice; named tables and figures were present as data or descriptions.
- These are multiple-applicable labels. They are not a single permanent artifact taxonomy.

## AP Biology detail

Stored prompt image:

- `APBIO-FRQ-S-009`

Structured student-construction items:

- `APBIO-HDG-2026-GRAPH-004`
- `APBIO-HDG-2026-GRAPH-006`
- `APBIO-HDG-2026-GRAPH-008`
- `APBIO-HDG-2026-GRAPH-011`
- `APBIO-HDG-2026-GRAPH-012`

Text-encoded table, diagram, graph, or figure information:

- `APBIO-FRQ-L-001`, `APBIO-FRQ-L-004`, `APBIO-FRQ-L-005`, `APBIO-FRQ-L-006`, `APBIO-FRQ-L-007`
- `APBIO-FRQ-L-008`, `APBIO-FRQ-L-009`, `APBIO-FRQ-L-011`, `APBIO-FRQ-L-012`, `APBIO-FRQ-L-015`
- `APBIO-FRQ-L-016`, `APBIO-FRQ-L-019`, `APBIO-FRQ-L-020`, `APBIO-FRQ-L-021`, `APBIO-FRQ-L-022`
- `APBIO-FRQ-L-023`, `APBIO-FRQ-L-025`, `APBIO-FRQ-L-026`, `APBIO-FRQ-L-027`, `APBIO-FRQ-L-028`
- `APBIO-FRQ-L-029`, `APBIO-FRQ-L-030`, `APBIO-FRQ-L-031`, `APBIO-FRQ-L-038`, `APBIO-FRQ-L-041`

No prompt-visual candidate:

- `APBIO-FRQ-L-002`, `APBIO-FRQ-L-003`, `APBIO-FRQ-L-010`, `APBIO-FRQ-L-013`, `APBIO-FRQ-L-014`
- `APBIO-FRQ-L-017`, `APBIO-FRQ-L-024`, `APBIO-FRQ-L-034`, `APBIO-FRQ-S-061`, `APBIO-FRQ-S-089`

Seven Biology items serialize an intended figure, graph, diagram, or photo into words or values: `APBIO-FRQ-L-009`, `APBIO-FRQ-L-011`, `APBIO-FRQ-L-019`, `APBIO-FRQ-L-020`, `APBIO-FRQ-L-021`, `APBIO-FRQ-L-027`, and `APBIO-FRQ-L-028`. These are not missing-context defects, but Learning Quality must decide whether the representation preserves the assessed construct. A textual alternate must not be assumed equivalent merely because it contains the answer-relevant facts.

## AP Statistics detail

The 48-item slice divides cleanly:

- 32 explicit hand-drawn items, each with `stimulus_table`, `expected_graph_spec`, and `hand_drawn=true`.
- 16 conventional targeted-drill FRQs with no prompt-visual candidate.

The 32 construction items cover five archetypes:

| Archetype | Count |
|---|---:|
| Boxplot construction and interpretation | 7 |
| Dotplot distribution shape | 6 |
| Mosaic plot interpretation | 6 |
| Scatterplot regression context | 6 |
| Segmented bar graph construction | 7 |

## Immediate implications for later assessment steps

1. Program A must prove signed delivery, rendering, failure behavior, and accessibility for the single stored image.
2. Program A must separately prove readable, semantically appropriate rendering for the 62 data/structure prompts. A successful image pipeline does not establish this.
3. Program B is launch-gating for all 37 construction items. Their instruction to submit a photograph is not supported merely by having an expected graph specification.
4. Program C qualification must be stratified by the five Statistics archetypes and the Biology construction archetypes; an aggregate response count alone cannot establish quality.
5. “No missing prior context” is provisional until Learning Quality validates the seven construct-sensitive textual representations and student-facing render checks confirm that encoded tables remain legible.

## Evidence and limitations

- Evidence came from SELECT-only Production queries against project `pcntajvbdfqhbeewmdry` on 2026-08-03.
- Manual review inspected every Biology candidate's referenced stimulus and grouped all Statistics construction items by archetype and structural fields.
- No learner object, signed URL, or private asset content was retrieved.
- This is a content classification, not a delivery verdict. It does not establish that the one image or the structured/text stimuli render correctly in the student UI.
- Learning Quality approval is still required for construct-sensitive classifications and accessible-equivalence judgments.

Reproducible query: `scripts/image_readiness/launch_slice_classification.sql`.
