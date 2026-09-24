# Work Order F — AP Biology drafted-criterion completion

**Status:** F accepted by independent QA; F.1 presentation correction complete and awaiting independent re-grade. No Production writes occurred.

## F.1 addendum — APBIO-FRQ-S-101

The combined (iii) paragraph was split into explicit (iii) and (iv) labels without changing its vetted biological wording. Exact concatenation and full coverage remain 71/71; all 261 criteria still have at least one exclusive span. The added (iv) label makes that span drafted with no inherited source offset. See F1_CHANGES.md for the before/after text, provenance change, and the required 71-item label scan. The pre-F.1 QA files were not edited.

## Scope and result

F re-authored all **88** criterion spans A left drafted, across **41** Biology items. The other **13** formerly drafted criteria remain A's byte-preserved recovered-parent content. The proposal contains all **71** non-graph Biology FRQ; the four spatial graph items remain out of scope. APBIO-FRQ-S-073 criterion a is corrected from an explicit 2n=4 → n=2 derivation.

## Invariants

| Invariant | Expected | Measured | Result |
|---|---:|---:|---|
| Charter gate marker count | 1 | 1 | PASS |
| Biology packet rows | 75 | 75 | PASS |
| Non-graph proposals | 71 | 71 | PASS |
| Authored criterion pairs | 88 | 88 | PASS |
| A recoveries preserved as source-backed spans | 13 criteria | 13 criteria | PASS |
| Authored similarity ≥0.85 | 0 | 0 | PASS |
| Authored similarity 0.70–0.85 with justification | all | 0/0 | PASS |
| Span concatenation equals full_text | 71 | 71 | PASS |
| Declared removals traceable and logged | all | 4/4 | PASS |
| Numeric values carry derivation records | all | 346/346 | PASS |

## Similarity gate

Pair-level evidence is in `similarity_report.csv`. Across 88 authored span × criterion pairs, mean similarity is **0.219**; **0** are at or above 0.70 and **0** are at or above 0.85. The highest-scoring pair governs each span. Scores were treated as a gate, not a target; added material is criterion-relevant mechanism, calculation, consequence, or stem application.

## Cross-criterion entanglement

The proposal carries **24** `cross_criterion_entanglement` flags: A’s 23 inherited disclosures plus a new explicit flag on APBIO-FRQ-S-080, where criteria a2 and b2 share the same folding-to-function causal chain. S-047 b1 was narrowed to genotype-only content so it does not newly absorb b2’s phenotype point.

## DECISION-0056 removals

Removed **4** uncredited, source-backed spans from **3** items where the newly authored span clearly supersedes the same content. Every row is verbatim and provenance-complete in `removals.csv`. Other candidates were retained when overlap was ambiguous; the QA finding's 30 in-scope items were not treated as a quota. Out-of-scope redundant prose on APBIO-FRQ-S-061, APBIO-FRQ-S-063, and APBIO-FRQ-S-064 is unchanged.

## Confidence and review order

Confidence tracks scientific ambiguity: **84 high, 4 medium, 0 low**. Lowest-confidence-first review:

1. **APBIO-FRQ-S-073 a** — correction conflicts with the stored rubric evidence but follows the 2n=4 derivation.
2. **APBIO-FRQ-S-036 a1** — approximate aerobic ATP yield convention.
3. **APBIO-FRQ-S-038 b2** — residual substrate-level ATP range depends on continuing stages.
4. **APBIO-FRQ-S-051 b1** — uses the scientifically safer “comparatively few genes” formulation.
5. **Four logged removals** — verify semantic supersession as well as verbatim traceability.

## Preserved boundaries

A's directory and QA files were not modified. A-QA-003 and A-QA-005 remain outside F. No graph item, point-total mismatch, or Production record was changed. This run stops before work order G.

## Reproducibility

- UTC window: 2026-09-23T15:04:34.989Z to 2026-09-23T15:04:35.013Z
- Model: OpenAI Codex GPT-5
- Production project: pcntajvbdfqhbeewmdry (read-only; F used A's QA-confirmed snapshot)
- Snapshot: 2026-09-23T01:30:44Z
- Maximum version number per item: `run_metadata.json`
- Superseded-run backups: `SUMMARY.md.20260923T145719Z.bak`, `run_metadata.json.20260923T145719Z.bak`
