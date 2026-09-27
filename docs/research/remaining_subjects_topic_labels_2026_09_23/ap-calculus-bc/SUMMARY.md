# Work Order H — AP Calculus BC topic labels

Status: **subject complete; proposal pending independent cross-model QA and Product Owner approval**

## Scope and method

Read-only Production snapshot filter: latest version per content_item_id where status='published' and subject_key='ap-calculus-bc'. Observed 127 items, matching the charter. The pinned registry ab088009-dc9a-4f93-8824-803e1913505b contains 111 topics across 10 units, also matching the charter. A template pre-pass separated legacy, next-practice, and Unit 1–3 author-coded families before classification. Evidence came from stem, stimulus, rubric criteria for FRQ, answer choices for MCQ, and author metadata only as corroboration.

Recovered author codes: 17. Content-derived decisions: 110. One item is deliberately undetermined rather than forced into a misleading topic. Production writes: 0.

## Invariants

| Invariant | Measured result | Status |
|---|---:|---|
| Packet covers latest published scope | 127 / 127 | PASS |
| Exactly one proposal row per item | 127 / 127 | PASS |
| Proposed closed-list codes valid (excluding explicit undetermined sentinel) | 0 invalid | PASS |
| Proposed unit matches registry | 0 mismatches | PASS |
| Recovered code equals parsed author code | 0 failures | PASS |
| Recovered rows | 17 | PASS |
| Explicit content_check on recovered rows | 17 / 17 | PASS |
| Production writes | 0 | PASS |

## Distributions

Content checks: agrees 16; disagrees 0; unclear 1.

Confidence: high 96; medium 30; low 1. Undetermined: 1.

Topic concentration (diagnostic only; not engineered):

- 3.2: 6 (4.7%)
- 7.9: 5 (3.9%)
- 3.5: 4 (3.1%)
- 6.13: 4 (3.1%)
- 1.16: 4 (3.1%)
- 2.8: 4 (3.1%)
- 4.2: 3 (2.4%)
- 5.4: 3 (2.4%)
- 9.1: 3 (2.4%)
- 9.8: 3 (2.4%)
- 9.6: 3 (2.4%)
- 10.15: 3 (2.4%)
- 3.3: 3 (2.4%)
- 2.9: 3 (2.4%)
- 3.1: 3 (2.4%)
- 3.4: 3 (2.4%)
- 6.14: 2 (1.6%)
- 8.13: 2 (1.6%)
- 10.13: 2 (1.6%)
- 10.10: 2 (1.6%)
- 1.13: 2 (1.6%)
- 5.5: 2 (1.6%)
- 6.4: 2 (1.6%)
- 7.5: 2 (1.6%)
- 9.2: 2 (1.6%)
- 10.12: 2 (1.6%)
- 1.10: 2 (1.6%)
- 1.8: 2 (1.6%)
- 2.2: 2 (1.6%)
- 4.5: 2 (1.6%)
- 1.6: 2 (1.6%)
- 5.1: 2 (1.6%)
- 5.3: 2 (1.6%)
- 6.11: 2 (1.6%)
- 6.12: 2 (1.6%)
- 10.2: 2 (1.6%)
- 10.14: 2 (1.6%)
- 4.7: 2 (1.6%)
- 1.15: 2 (1.6%)
- 10.11: 1 (0.8%)
- 8.3: 1 (0.8%)
- 6.5: 1 (0.8%)
- 8.7: 1 (0.8%)
- 9.7: 1 (0.8%)
- 10.1: 1 (0.8%)
- 2.7: 1 (0.8%)
- 1.4: 1 (0.8%)
- 1.11: 1 (0.8%)
- 2.5: 1 (0.8%)
- 1.9: 1 (0.8%)
- 2.4: 1 (0.8%)
- 1.14: 1 (0.8%)
- 2.10: 1 (0.8%)
- 1.7: 1 (0.8%)
- 5.6: 1 (0.8%)
- undetermined: 1 (0.8%)
- 6.8: 1 (0.8%)
- 10.8: 1 (0.8%)
- 3.6: 1 (0.8%)
- 8.4: 1 (0.8%)
- 8.8: 1 (0.8%)
- 10.9: 1 (0.8%)
- 5.12: 1 (0.8%)

## Lowest-confidence-first QA sample

- apcalcbc-mcq-007: undetermined vs 5.11 — low
- apcalcbc-frq-002: 3.5 vs 5.2 — medium
- apcalcbc-frq-003: 3.2 vs 3.6 — medium
- apcalcbc-frq-005: 5.4 vs 5.6 — medium
- apcalcbc-frq-012: 9.1 vs 9.2 — medium
- apcalcbc-frq-013: 9.8 vs 9.7 — medium
- apcalcbc-frq-016: 10.11 vs 10.10 — medium
- apcalcbc-frq-017: 1.13 vs 1.16 — medium
- apcalcbc-frq-018: 1.16 vs 1.13 — medium
- apcalcbc-frq-019: 2.8 vs 3.6 — medium

## Judgment calls

- apcalcbc-mcq-007 asks for a Newton iteration, but the pinned closed list has no Newton-method topic. It is marked undetermined with 5.11 only as a weak alternative.
- Multi-part FRQs spanning adjacent topics are medium confidence with explicit runner-ups; clean metadata did not raise confidence.
- apcalcbc-frq-u13-012 is an author-coded item covering both vertical and horizontal asymptotes; the recovered 1.14 code is retained, but content_check is unclear and 1.15 is recorded as the alternative.
- Topic concentration is reported as observed and was not used to change any content-based decision.

The prior gate-skip SUMMARY.md and run_metadata.json were backed up at 20260923T195338Z. No QA-owned file was created or edited.
