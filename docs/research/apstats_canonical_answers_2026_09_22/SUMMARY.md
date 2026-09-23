# AP Statistics canonical-answer proposal — overnight run B

## Outcome

Authored and segmented 46 full-credit AP Statistics FRQ canonical-answer proposals from the exact 46-item blank-answer set in the Production snapshot. The packet contains all 80 published AP Statistics FRQs: 46 in scope and 34 deliberately untouched. This is a proposal only; Production was read-only.

## Reproducibility and counts

- Run start: 2026-09-23T01:46:31.108Z (UTC)
- Run end: 2026-09-23T02:08:26.503Z (UTC)
- Model identifier: Codex GPT-5-class local/in-session
- Production project ref: pcntajvbdfqhbeewmdry
- Production snapshot: 2026-09-23T01:46:31.108Z (UTC)
- Filter behind published count: latest version_num per content_item_id where status='published', item_type='frq', subject_key='ap-statistics'
- Published FRQs: 80; canonical present: 34; both canonical fields blank: 46
- In-scope items with any prior version: 10; prior versions with a canonical answer: 0
- Stored rubric rows covered: 240; stored rubric point sum: 246
- Count drift from work order: 0
- Maximum version_num by item: `{"APSTAT-MOD3-E002":1,"APSTAT-MOD3-E005":1,"APSTAT-MOD3-H001-INV":2,"APSTAT-MOD4-H001-INV":2,"APSTAT-MOD4-M001":2,"APSTAT-MOD4-M003":1,"APSTAT-MOD4-M004":2,"APSTAT-MOD5-H001-INV":1,"APSTAT-MOD5-M001":1,"APSTAT-MOD6-H001":1,"APSTAT-MOD6-H002-INV":1,"APSTAT-MOD6-M002":1,"APSTAT-MOD7-H002-INV":1,"APSTAT-MOD8-M004":2,"apstats-frq-u12-001":1,"apstats-frq-u12-002":1,"apstats-frq-u12-003":1,"apstats-frq-u12-004":1,"apstats-frq-u12-005":3,"apstats-frq-u12-006":1,"apstats-frq-u12-007":1,"apstats-frq-u12-008":1,"apstats-frq-u12-009":1,"apstats-frq-u12-010":1,"apstats-frq-u12-011":1,"apstats-frq-u12-012":1,"apstats-frq-u12-013":1,"apstats-frq-u12-014":1,"apstats-frq-u12-015":1,"apstats-frq-u12-016":1,"apstats-frq-u12-017":1,"apstats-frq-u12-018":1,"apstats-frq-u12-019":1,"apstats-frq-u12-020":2,"APSTATS-HDG-2026-GRAPH-003":1,"APSTATS-HDG-2026-GRAPH-005":1,"APSTATS-HDG-2026-GRAPH-007":1,"APSTATS-HDG-2026-GRAPH-008":1,"APSTATS-HDG-2026-GRAPH-010":1,"APSTATS-HDG-2026-GRAPH-013":1,"APSTATS-HDG-2026-GRAPH-014":1,"APSTATS-HDG-2026-GRAPH-015":1,"APSTATS-HDG-2026-GRAPH-016":1,"APSTATS-HDG-2026-GRAPH-017":1,"APSTATS-HDG-2026-GRAPH-018":1,"APSTATS-HDG-2026-GRAPH-019":1,"APSTATS-HDG-2026-GRAPH-020":1,"APSTATS-HDG-2026-GRAPH-023":1,"APSTATS-HDG-2026-GRAPH-025":1,"APSTATS-HDG-2026-GRAPH-027":1,"APSTATS-HDG-2026-GRAPH-028":1,"APSTATS-HDG-2026-GRAPH-030":1,"APSTATS-HDG-2026-GRAPH-031":1,"APSTATS-HDG-2026-GRAPH-033":2,"APSTATS-SFRQ-001":1,"APSTATS-SFRQ-002":2,"APSTATS-SFRQ-003":2,"APSTATS-SFRQ-004":2,"APSTATS-SFRQ-005":1,"APSTATS-SFRQ-007":2,"APSTATS-SFRQ-008":3,"APSTATS-SFRQ-009":2,"APSTATS-SFRQ-010":2,"APSTATS-SFRQ-011":2,"APSTATS-SFRQ-012":2,"APSTATS-SFRQ-013":2,"APSTATS-SFRQ-014":2,"APSTATS-SFRQ-016":2,"STATS-MOD1-E001":1,"STATS-MOD1-E002":2,"STATS-MOD1-E003":2,"STATS-MOD1-E005":1,"STATS-MOD1-M001":1,"STATS-MOD3-H006":1,"STATS-MOD3-M006":1,"STATS-MOD3-M007":2,"STATS-MOD4-E005":1,"STATS-MOD4-H012":1,"STATS-MOD4-M009":1,"STATS-MOD9-H018":1}`

## Measured invariants

| Invariant | Measured result |
| --- | ---: |
| Spans concatenate exactly to full_text | 46 / 46 |
| Every stored criterion covered by at least one span | 46 / 46; 0 uncovered |
| No span invents a criterion outside the stored rubric | 0 violations |
| Every numeric value in full_text appears in derivations | 0 orphans |
| Every derivation input traces to the stimulus or stem | 0 unsourced |
| Removing any one criterion's spans never empties the answer | 0 failures |
| No prohibited second-person rubric-instruction phrasing | 0 occurrences |
| Out-of-scope items unmodified | 34 / 34 |
| Packet differences from the frozen Production read | 0 differences at extraction time |

The removal invariant is mechanically satisfied by the uncredited `Response:
` span. Because some response-part spans are shared by multiple criteria, this does **not** imply criterion-level fine-grained strike behavior; that limitation is explicitly recorded as B-005.

## Confidence ranking (lowest first)

1. APSTAT-MOD4-H001-INV — medium: The prompt reportedly mentions p ≈ 0.014; that is approximately the two-sided p-value, while the directional alternative requested gives about 0.007.
1. APSTAT-MOD5-H001-INV — medium: The supplied t statistic lacks a stated subtraction order, so the answer concludes a difference but does not infer its direction.
1. apstats-frq-u12-005 — medium: The stored rubric is anomalously coarse: 4 criteria total 10 points rather than 10 one-point criteria.
1. apstats-frq-u12-013 — medium: The direction of time-of-day bias for an unspecified response cannot be determined without knowing how excluded groups differ.
1. apstats-frq-u12-020 — medium: The corrected South median and maximum cannot be calculated exactly from the supplied five-number summary alone; the answer states only supported direction and rank consequences.
1. APSTAT-MOD3-E002 — high
1. APSTAT-MOD3-E005 — high
1. APSTAT-MOD3-H001-INV — high
1. APSTAT-MOD4-M001 — high
1. APSTAT-MOD4-M003 — high
1. APSTAT-MOD4-M004 — high
1. APSTAT-MOD5-M001 — high
1. APSTAT-MOD6-H001 — high
1. APSTAT-MOD6-H002-INV — high
1. APSTAT-MOD6-M002 — high
1. APSTAT-MOD7-H002-INV — high
1. APSTAT-MOD8-M004 — high
1. apstats-frq-u12-001 — high
1. apstats-frq-u12-002 — high
1. apstats-frq-u12-003 — high
1. apstats-frq-u12-004 — high
1. apstats-frq-u12-006 — high
1. apstats-frq-u12-007 — high
1. apstats-frq-u12-008 — high
1. apstats-frq-u12-009 — high
1. apstats-frq-u12-010 — high
1. apstats-frq-u12-011 — high
1. apstats-frq-u12-012 — high
1. apstats-frq-u12-014 — high
1. apstats-frq-u12-015 — high
1. apstats-frq-u12-016 — high
1. apstats-frq-u12-017 — high
1. apstats-frq-u12-018 — high
1. apstats-frq-u12-019 — high
1. STATS-MOD1-E001 — high
1. STATS-MOD1-E002 — high
1. STATS-MOD1-E003 — high
1. STATS-MOD1-E005 — high
1. STATS-MOD1-M001 — high
1. STATS-MOD3-H006 — high
1. STATS-MOD3-M006 — high
1. STATS-MOD3-M007 — high
1. STATS-MOD4-E005 — high
1. STATS-MOD4-H012 — high
1. STATS-MOD4-M009 — high
1. STATS-MOD9-H018 — high

The lowest-confidence items are APSTAT-MOD4-H001-INV (directional versus two-sided p-value), APSTAT-MOD5-H001-INV (unstated sign convention), apstats-frq-u12-005 (coarse anomalous rubric), apstats-frq-u12-020 (summary-only correction limits), and apstats-frq-u12-013 (time-of-day bias direction depends on the unsampled population). The remaining items are ranked high after rubric-by-rubric and arithmetic review.

## Judgment calls and open questions

- **B-001 — apstats-frq-u12-005:** The stored rubric has 4 criteria totaling 10 points, unlike its 19 siblings with 10 one-point criteria. Authored against the stored 4-criterion rubric without changing it. Disposition: Product Owner and QA should confirm the intentionally coarser rubric before publication.
- **B-002 — APSTAT-MOD4-H001-INV:** The requested directional test gives p about 0.007, while the prompt reportedly cites about 0.014, which is approximately two-sided. Disposition: Used the one-sided p-value because the claim is that the program reduces heart rate; QA should confirm intended alternative.
- **B-003 — APSTAT-MOD5-H001-INV:** The supplied t = 2.1 does not state the subtraction order, so it cannot establish which condition has the higher sample mean. Disposition: Concluded only that the means differ and did not invent a direction.
- **B-004 — all_in_scope:** The authoring protocol prefers a non-OpenAI author when OpenAI will grade later. The sanctioned external route could not be used in this environment because transmitting the proprietary packet was not authorized. Disposition: Completed local Codex authorship as the explicitly assigned work order and require independent cross-model QA before approval.
- **B-005 — all_in_scope:** Answers are segmented at least by response part, and each part-level span may be tagged to multiple criteria. This preserves readable text but striking one criterion can strike other evidence in the same part. Disposition: QA should assess whether finer clause-level segmentation is required before UI ingestion.

## QA handoff

This proposal requires independent AI cross-model QA and Product Owner approval under DECISION-0055 before any answer serves students. No `qa_findings.csv` or `qa_report.md` was created; those belong to the QA model. No Production content, rubric, stem, stimulus, or existing canonical answer was modified.
