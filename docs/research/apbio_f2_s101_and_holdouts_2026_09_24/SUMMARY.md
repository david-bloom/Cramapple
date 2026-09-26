# AP Biology F.2 — S-101 Rubric Split and Canonical Holdouts

Date: 2026-09-24  
Mode: proposal only. Production was read-only throughout; no rubric, canonical answer, label, or
span row was written.

## Scope

Exactly four items were touched:

- `APBIO-FRQ-S-101` — rubric split proposal only; no grader run by Codex.
- `APBIO-FRQ-S-021`, `APBIO-FRQ-S-023`, `APBIO-FRQ-S-058` — replacement
  `canonical_answer_1` proposals and `canonical_answer_2` decisions.

Current Production was rechecked first. The four latest published version IDs match the prior
segmentation packet, so the 2026-09-22 drafts remain applicable to the current stems/rubrics:

| Item | Current version | Existing CA1 | Existing CA2 |
| --- | --- | --- | --- |
| APBIO-FRQ-S-101 | `406df04d-6c14-4ca2-9444-9f18cd2a5ed8` | null | null |
| APBIO-FRQ-S-021 | `1c8662ac-d06b-47e4-bfd3-714dae885aac` | present | present |
| APBIO-FRQ-S-023 | `89ba31c8-84ca-4f2c-be9c-01fb4ea8e76b` | present | present |
| APBIO-FRQ-S-058 | `de993d8e-09a0-49d8-bb2b-6a15008f6182` | present | present |

Note: the F.2 prompt names `QA2-*` rows in `apbio_canonical_recovery_2026_09_22/qa_findings.csv`,
but that file uses `A-QA-*` IDs. The substantive referenced findings are present in
DECISION-0064 and the recovery/segmentation records; this packet proceeds on the item-specific
evidence rather than the mismatched IDs.

## Part 1 — S-101 Rubric Split

`criteria_change.json` proposes splitting old `a-iv` into:

| New key | Points | Scope |
| --- | ---: | --- |
| `a-iv` | 1 | Stem (a)(iii): what “most parsimonious” means. |
| `a-v` | 1 | Stem (a)(iv): why parsimony is preferred. |

The combined scope equals the old `a-iv`; nothing else is added or removed. The existing F.1-style
answer text is not graded here and is not proposed for Production write by Codex.

S-101 invariants:

| Invariant | Result |
| --- | --- |
| Criteria after split | 5 |
| Spans concatenate to full text | PASS |
| Criteria covered | `a-i`, `a-ii`, `a-iii`, `a-iv`, `a-v` |
| Criteria without exclusive span | 0 |
| Mean over-strike fraction | 0 |
| Codex grader run | Not run, per work order |

Claude must run the DECISION-0052 grader gate against the corrected rubric before anything is
written.

## Part 2 — S-021, S-023, S-058

`canonical_proposal.jsonl` contains one complete `canonical_answer_1` proposal per item. Each uses
criterion-exclusive spans plus assembly-literal paragraph breaks so concatenation is exact.

| Item | Criteria | Covered | Missing exclusive spans | CA2 decision |
| --- | ---: | ---: | ---: | --- |
| APBIO-FRQ-S-021 | 4 | 4 | 0 | Remove. Both stored fields are off-rubric/supplementary; new CA1 covers all criteria. |
| APBIO-FRQ-S-023 | 4 | 4 | 0 | Remove as separate field. The recoverable b2 clause from CA2 is retained verbatim inside new CA1. |
| APBIO-FRQ-S-058 | 4 | 4 | 0 | Remove. Both stored fields are broad/off-rubric; new CA1 covers all criteria explicitly. |

Confidence is medium overall, not high: most spans are drafted from rubric requirements because the
stored answers do not directly answer the rubrics. `S-023` b2 is stronger because it is recovered
verbatim from current `canonical_answer_2`.

## Removal Log

`removal_log.csv` accounts for all current stored canonical text for the three holdouts:

| Decision | Rows | Characters |
| --- | ---: | ---: |
| remove | 6 | 641 |
| relocate_to_canonical_answer_1 | 1 | 69 |
| total accounted | 7 | 710 |

For `S-023`, the 69-character b2 clause is retained verbatim as an exclusive span in the new
`canonical_answer_1`; it is logged as relocation rather than disappearance.

## Files

- `packet.jsonl` — model-neutral current inputs for the four scoped items.
- `criteria_change.json` — S-101 before/after rubric split plus span invariants.
- `canonical_proposal.jsonl` — three complete canonical-answer proposals.
- `removal_log.csv` — before-text accounting for current canonical fields not kept in place.
- `build_f2_outputs.py` — deterministic artifact generator.

## Weak Points For QA

1. `S-101` still requires Claude’s independent grader gate; Codex intentionally did not run it.
2. `S-021` and `S-058` are mostly drafted from scratch because the stored canonicals are off-rubric.
3. `S-023` preserves only the exact b2 clause from current CA2; QA should verify the dropped CA2
   prefix is genuinely supplementary and not needed.
