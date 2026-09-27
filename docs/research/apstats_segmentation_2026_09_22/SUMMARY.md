# AP Statistics existing-answer segmentation — overnight run C

## Outcome

Segmented all 34 published AP Statistics FRQs that had a canonical answer in the independent Production snapshot. Every character is preserved verbatim from canonical_answer_1; all canonical_answer_2 fields in scope were blank. No answer text was authored. The other 46 items remained out of scope.

## Reproducibility and counts

- Run start / Production snapshot: 2026-09-23T02:10:13.633Z (UTC)
- Run end: 2026-09-23T02:13:50.884Z (UTC)
- Model identifier: Codex GPT-5-class local/in-session
- Production project ref: pcntajvbdfqhbeewmdry
- Filter: latest version_num per content_item_id where status=published, item_type=frq, subject_key=ap-statistics
- Published FRQs: 80; canonical present/in scope: 34; blank/out of scope: 46; count drift: 0
- B-to-C snapshot comparison: 0 field differences across all 80 packet rows
- Stored criteria: 122; covered: 108; uncovered: 14
- Maximum version_num by item: {"APSTAT-MOD3-E002":1,"APSTAT-MOD3-E005":1,"APSTAT-MOD3-H001-INV":2,"APSTAT-MOD4-H001-INV":2,"APSTAT-MOD4-M001":2,"APSTAT-MOD4-M003":1,"APSTAT-MOD4-M004":2,"APSTAT-MOD5-H001-INV":1,"APSTAT-MOD5-M001":1,"APSTAT-MOD6-H001":1,"APSTAT-MOD6-H002-INV":1,"APSTAT-MOD6-M002":1,"APSTAT-MOD7-H002-INV":1,"APSTAT-MOD8-M004":2,"apstats-frq-u12-001":1,"apstats-frq-u12-002":1,"apstats-frq-u12-003":1,"apstats-frq-u12-004":1,"apstats-frq-u12-005":3,"apstats-frq-u12-006":1,"apstats-frq-u12-007":1,"apstats-frq-u12-008":1,"apstats-frq-u12-009":1,"apstats-frq-u12-010":1,"apstats-frq-u12-011":1,"apstats-frq-u12-012":1,"apstats-frq-u12-013":1,"apstats-frq-u12-014":1,"apstats-frq-u12-015":1,"apstats-frq-u12-016":1,"apstats-frq-u12-017":1,"apstats-frq-u12-018":1,"apstats-frq-u12-019":1,"apstats-frq-u12-020":2,"APSTATS-HDG-2026-GRAPH-003":1,"APSTATS-HDG-2026-GRAPH-005":1,"APSTATS-HDG-2026-GRAPH-007":1,"APSTATS-HDG-2026-GRAPH-008":1,"APSTATS-HDG-2026-GRAPH-010":1,"APSTATS-HDG-2026-GRAPH-013":1,"APSTATS-HDG-2026-GRAPH-014":1,"APSTATS-HDG-2026-GRAPH-015":1,"APSTATS-HDG-2026-GRAPH-016":1,"APSTATS-HDG-2026-GRAPH-017":1,"APSTATS-HDG-2026-GRAPH-018":1,"APSTATS-HDG-2026-GRAPH-019":1,"APSTATS-HDG-2026-GRAPH-020":1,"APSTATS-HDG-2026-GRAPH-023":1,"APSTATS-HDG-2026-GRAPH-025":1,"APSTATS-HDG-2026-GRAPH-027":1,"APSTATS-HDG-2026-GRAPH-028":1,"APSTATS-HDG-2026-GRAPH-030":1,"APSTATS-HDG-2026-GRAPH-031":1,"APSTATS-HDG-2026-GRAPH-033":2,"APSTATS-SFRQ-001":1,"APSTATS-SFRQ-002":2,"APSTATS-SFRQ-003":2,"APSTATS-SFRQ-004":2,"APSTATS-SFRQ-005":1,"APSTATS-SFRQ-007":2,"APSTATS-SFRQ-008":3,"APSTATS-SFRQ-009":2,"APSTATS-SFRQ-010":2,"APSTATS-SFRQ-011":2,"APSTATS-SFRQ-012":2,"APSTATS-SFRQ-013":2,"APSTATS-SFRQ-014":2,"APSTATS-SFRQ-016":2,"STATS-MOD1-E001":1,"STATS-MOD1-E002":2,"STATS-MOD1-E003":2,"STATS-MOD1-E005":1,"STATS-MOD1-M001":1,"STATS-MOD3-H006":1,"STATS-MOD3-M006":1,"STATS-MOD3-M007":2,"STATS-MOD4-E005":1,"STATS-MOD4-H012":1,"STATS-MOD4-M009":1,"STATS-MOD9-H018":1}

## Measured invariants

| Invariant | Measured result |
| --- | ---: |
| Spans concatenate exactly to full_text | 34 / 34 |
| Every span appears verbatim in its named source field at stated offset | 0 failures |
| No span invents a criterion outside stored rubric | 0 violations |
| No text was drafted | 0 drafted spans |
| Each nonblank canonical_answer_2 appears verbatim | 0 failures (0 nonblank fields) |
| Removing any one criterion spans never empties answer | 0 failures |
| Out-of-scope items untouched | 46 / 46 |
| Packet differences from Production at extraction | 0 |

## Findings and judgment calls

- 14 graph-construction criteria are uncovered because the published textual answer does not explicitly provide the requested axis labels, common scale, plotted points, or full segment labels. No replacement prose was drafted.
- 14 items contain at least one verbatim span credited to multiple criteria. These are flagged in each proposal row because hiding one criterion can remove shared evidence.
- The packet snapshot at 2026-09-23T02:10:13.633Z exactly matched Work Order B snapshot fields despite being taken later.
- Textual descriptions of graphs were treated literally: a property was credited only when stated in the canonical field, not inferred from the prompt.

## Open questions

- **C-001 — APSTATS-HDG-2026-GRAPH-003:** SEGMENT_LABELS Disposition: No text drafted; retain as a QA/Product Owner finding.
- **C-002 — APSTATS-HDG-2026-GRAPH-005:** AXIS_LABELS | POINTS_PLOTTED Disposition: No text drafted; retain as a QA/Product Owner finding.
- **C-003 — APSTATS-HDG-2026-GRAPH-007:** BOXPLOT_SCALE Disposition: No text drafted; retain as a QA/Product Owner finding.
- **C-004 — APSTATS-HDG-2026-GRAPH-013:** BOXPLOT_SCALE Disposition: No text drafted; retain as a QA/Product Owner finding.
- **C-005 — APSTATS-HDG-2026-GRAPH-014:** BOXPLOT_SCALE Disposition: No text drafted; retain as a QA/Product Owner finding.
- **C-006 — APSTATS-HDG-2026-GRAPH-015:** BOXPLOT_SCALE Disposition: No text drafted; retain as a QA/Product Owner finding.
- **C-007 — APSTATS-HDG-2026-GRAPH-016:** BOXPLOT_SCALE Disposition: No text drafted; retain as a QA/Product Owner finding.
- **C-008 — APSTATS-HDG-2026-GRAPH-017:** BOXPLOT_SCALE Disposition: No text drafted; retain as a QA/Product Owner finding.
- **C-009 — APSTATS-HDG-2026-GRAPH-023:** SEGMENT_LABELS Disposition: No text drafted; retain as a QA/Product Owner finding.
- **C-010 — APSTATS-HDG-2026-GRAPH-025:** SEGMENT_LABELS Disposition: No text drafted; retain as a QA/Product Owner finding.
- **C-011 — APSTATS-HDG-2026-GRAPH-027:** SEGMENT_LABELS Disposition: No text drafted; retain as a QA/Product Owner finding.
- **C-012 — APSTATS-HDG-2026-GRAPH-033:** AXIS_LABELS | POINTS_PLOTTED Disposition: No text drafted; retain as a QA/Product Owner finding.
- **C-J01 — all_graph_items:** Textual canonical answers describe intended graphs but are not literal rendered graphs. Crediting is limited to properties explicit in the published text. Disposition: Axis/scale/label criteria are uncovered where the prose does not explicitly state them.

## QA handoff

This is a proposal requiring independent AI cross-model QA and Product Owner approval under DECISION-0055 before it serves students. No qa_findings.csv or qa_report.md was created. Production was read-only.
