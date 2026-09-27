# Work Order G — Multisubject Canonical Answers

Status: **partial by design — subjects 1–2 complete; STOP-for-QA gate closed before subject 3**

AP Physics 1 received an explicit ACCEPTED disposition, opening subject 2. AP Physics C: Electricity and Magnetism is now complete and ready for independent QA. No later subject was started. Production remained read-only.

## Subject status

| Sequence | Subject | Status | Completed |
|---:|---|---|---:|
| 1 | `ap-physics-1` | QA ACCEPTED | 39/39 |
| 2 | `ap-physics-c-em` | Ready for independent QA | 39/39 |
| 3 | `ap-calculus-ab` | Not attempted — waiting on E&M QA | 0/33 |
| 4 | `ap-precalculus` | Not attempted | 0/32 |
| 5 | `ap-calculus-bc` | Not attempted | 0/29 |
| 6 | `ap-physics-c-mechanics` | Not attempted | 0/29 |
| 7 | `ap-physics-2` | Not attempted | 0/19 |
| 8 | `ap-chemistry` | Not attempted micro-batch | 0/1 |

## AP Physics 1 measured invariants

| Invariant | Measured result | Status |
|---|---:|---|
| Published FRQs in frozen packet | 54 | PASS |
| Blank in-scope FRQs | 39 | PASS |
| Proposal rows / unique IDs | 39 / 39 | PASS |
| Stored criteria / point sum covered | 176 / 182 | PASS |
| Span concatenation equals `full_text` | 39/39 | PASS |
| Uncovered criteria | 0 | PASS |
| Invented criterion references | 0 | PASS |
| Numeric occurrences / derivation entries | 449 / 449 | PASS |
| Recoverable prior-text items, preserved byte-exact | 5 / 5 | PASS |
| Prohibited second-person wording | 0 | PASS |
| Rubric-restatement markers | 0 | PASS |
| Out-of-scope proposals | 0 | PASS |
| Production writes | 0 | PASS |

## Recovery check

- In-scope items with a prior version: 31.
- In-scope items with recoverable prior canonical text: 5.
- Recoverable text is retained in `recovered` spans with byte offsets; authored text completes the current rubric.

## Confidence and QA focus

- High: 34.
- Medium: 5.
- Low: 0.

Lowest-confidence-first:
- `apphy1-frq-033` — medium: rubric expects a graph or free-body diagram; proposal provides an exact textual/mathematical representation, so QA must decide whether a visual asset is required.
- `apphy1-frq-049` — medium: rubric expects a graph or free-body diagram; proposal provides an exact textual/mathematical representation, so QA must decide whether a visual asset is required.
- `apphy1-frq-052` — medium: rubric expects a graph or free-body diagram; proposal provides an exact textual/mathematical representation, so QA must decide whether a visual asset is required.
- `apphy1-frq-058` — medium: rubric expects a graph or free-body diagram; proposal provides an exact textual/mathematical representation, so QA must decide whether a visual asset is required.
- `apphy1-frq-np1-002` — medium: rubric expects a graph or free-body diagram; proposal provides an exact textual/mathematical representation, so QA must decide whether a visual asset is required.

All other items are high confidence after source-grounded arithmetic and criterion review. Every multi-criterion answer is flagged `cross_criterion_entanglement` because its readable answer span can earn more than one stored criterion; QA should assess strike-through granularity before ingestion.

## Judgment calls

- Prior canonical text was preserved byte-exact as recovery evidence even when it was too short to satisfy the expanded current rubric; authored additions supply the missing work.
- Numeric results were re-derived from stem/stimulus inputs and checked against the approved Physics 1 fact pack.
- Text-only graph and FBD descriptions are not silently treated as equivalent to a drawn asset; all five are routed to QA.
- The subject stop gate is applied immediately after this commit. AP Physics C: E&M authoring must not begin until Physics 1 receives an explicit accepted/pass QA disposition or the Product Owner waives the gate in writing.

## G.1 correction — AP Physics 1

The 39-item AP Physics 1 proposal was re-cut to satisfy the shared span-exclusivity invariant. Criteria with no exclusive span fell from 176/176 to 0/176, and mean over-strike fell from 1.00 to 0.00. Twenty-three items retained byte-identical full_text; 16 required criterion-specific sentence re-authoring. Exact concatenation and full coverage pass for all 39 items. The corrected proposal remains pending independent QA, and the STOP-for-QA gate before subject 2 remains in force.

Before writing the G.1 correction, the pre-existing root summary and the AP Physics 1 canonical proposal, criterion ledger, manifest, run metadata, and validation report were moved to side-by-side 20260923T192650Z.bak files. No QA-owned file was created, edited, moved, or backed up.

## AP Physics C: Electricity and Magnetism

Subject 2 contains 39/39 in-scope blank-canonical FRQs and covers 198/198 stored criteria. Every criterion has a span tagged to it alone; exact concatenation passes for all 39 items. Eighteen earlier canonical answers were recovered byte-exact before criterion-specific completion.

The amended G contract is applied from this subject onward: similarity_report.csv contains every authored span/criterion pair and high-similarity cases carry typed restatement_justified flags. All 297 numeric occurrences have one derivation row, populated criterion keys, criterion-specific expressions, and non-placeholder inputs. Computed results carry a one-value formula with named operands; values taken from standard physical or mathematical relations use looked_up provenance.

Eight diagram/graph items are medium confidence and explicitly routed for spatial-path QA. The other 31 are high confidence. A second read-only Production snapshot matched the frozen packet on all 39 items with zero differences. The mandatory gate is now closed before AP Calculus AB until E&M receives an explicit accepted/pass QA disposition.
