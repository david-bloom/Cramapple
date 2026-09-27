# Work Order G — Multisubject Canonical Answers

Status: **partial by design — AP Physics 1 complete; STOP-for-QA gate closed for the next subject**

The first subject batch is complete and ready for independent QA. No later subject was started. Production remained read-only.

## Subject status

| Sequence | Subject | Status | Completed |
|---:|---|---|---:|
| 1 | `ap-physics-1` | Ready for independent QA | 39/39 |
| 2 | `ap-physics-c-em` | Not attempted — waiting on Physics 1 QA | 0/39 |
| 3 | `ap-calculus-ab` | Not attempted | 0/33 |
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
