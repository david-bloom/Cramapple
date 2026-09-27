# Mechanical Cleanup — Builder Summary

Status: **ready for independent QA and Product Owner decision**

This read-only Production snapshot covered **1346** latest published items. The cleanup proposal contains 10 point-total mismatches and 206 published versions with a null `rubric_type` column. Production writes: **0**.

## Deliverables

- `packet.jsonl` — the 216-item union of both cleanup populations.
- `point_total_proposal.csv` — the 10 point-total decisions.
- `rubric_type_proposal.csv` — the 206 null-column routing proposals.
- `open_questions.csv` — two explicit Product Owner/future-routing questions.
- `run_metadata.json` and `validation_report.txt` — reproducibility and builder checks.

## Measured invariants

| Invariant | Measured result | Status |
|---|---:|---|
| Latest published items scanned | 1,346 | PASS |
| Point-total mismatches | 10 | PASS |
| Biology 8-vs-9 template mismatches | 9 | PASS |
| Chemistry mismatch | 1 (`10` vs rubric `9`) | PASS |
| Missing `rubric_type` | 206 | PASS |
| Missing-type MCQ / FRQ | 173 / 33 | PASS |
| Proposal rows / unique IDs | 216 / 216 | PASS |
| Items in both proposal files | 0 | PASS |
| Blank proposed routes | 0 | PASS |
| Proposed runtime behavior changes | 0 | PASS |
| Production writes | 0 | PASS |

## Re-verified GAP-3 scope

The running-list estimate was 107 items (92 Statistics MCQ, 14 Statistics FRQ, 1 Biology FRQ). The current latest-published count is **206**, so the proposal uses the measured snapshot rather than the stale estimate.

| Subject | Missing `rubric_type` |
|---|---:|
| `ap-calculus-ab` | 10 |
| `ap-calculus-bc` | 10 |
| `ap-physics-1` | 26 |
| `ap-physics-2` | 5 |
| `ap-physics-c-em` | 18 |
| `ap-physics-c-mechanics` | 5 |
| `ap-precalculus` | 13 |
| `ap-statistics` | 118 |
| `biology` | 1 |

- Prompt routes mirrored into columns: 118.
- Existing item-type fallbacks made explicit: 88.

## Point-total decision

Recommended: remove `prompt_json.total_points` from the 10 affected versions and make the rubric sum the single source of truth. The field is sparse and no runtime code reads it; `evaluate-attempt` already sums `frq_criteria.points_possible`.

Alternative: set each field to the rubric sum of 9. Both options are present row-by-row in `point_total_proposal.csv`; no choice was applied.

## Confidence and QA focus

- All 216 proposal rows: high confidence for mechanical identification and behavior-preserving routing.
- Lowest-confidence policy question: whether quantitative FRQs should later move to `structured_formula`. That is explicitly deferred because the historical backfill kept quantitative items on shadow/default routing until the verifier is wired.

## Judgment calls

- A null routing column with valid prompt-level routing is still included: the goal is complete column coverage, and mirroring preserves behavior.
- Null routing without prompt metadata is proposed from the same item-type fallback the live router already uses (`mcq` or `discrete_text`).
- Structured-formula migration is not bundled into this cleanup because it would be a grading-behavior change, not a mechanical backfill.
- Point-total field removal is recommended over value repair, but both alternatives remain reviewable for Product Owner choice.
