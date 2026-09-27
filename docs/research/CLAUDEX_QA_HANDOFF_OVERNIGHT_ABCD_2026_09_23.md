# Claudex QA Handoff — Overnight Work Orders A–D

## Purpose

Independently validate the outputs of work orders A, B, C, and D. Treat every proposal, ledger, summary, flag, and claimed invariant as an untrusted assertion to be recomputed. Do not use this handoff as evidence that any work order passed.

This document intentionally contains no result totals, quality conclusions, or descriptions of Codex's findings. That separation is required so Claude's QA results can be compared cleanly with the producing model's results afterward.

## Repository and branch

- Repository checkout: `/Users/davidbloom/Documents/Cramapple.nosync`
- Output branch: `codex/overnight-2026-09-22`
- Remote branch: `origin/codex/overnight-2026-09-22`
- Production project named in the work orders: `pcntajvbdfqhbeewmdry`

Before reviewing, confirm the checked-out branch and record the commit SHA. Do not merge, rebase, or modify the proposal artifacts during QA.

## Read these instructions first

Read the protocol and each work order directly; they are the authoritative specifications:

1. `prompts/CODEX_OVERNIGHT_RUN_PROTOCOL_2026_09_22.md`
2. `prompts/CODEX_WORK_ORDER_A_APBIO_CANONICAL_RECOVERY_2026_09_22.md`
3. `prompts/CODEX_WORK_ORDER_B_APSTATS_CANONICAL_ANSWERS_2026_09_22.md`
4. `prompts/CODEX_WORK_ORDER_C_APSTATS_SEGMENTATION_2026_09_22.md`
5. `prompts/CODEX_WORK_ORDER_D_CALCAB_CHEM_TOPIC_LABELS_2026_09_22.md`

Also read any source documents explicitly named by a work order. Do not infer requirements from the producer's `SUMMARY.md` when the work order or protocol can be checked directly.

## Where to find Work Order A

Directory:

`docs/research/apbio_canonical_recovery_2026_09_22/`

Files to review:

- `packet.jsonl` — frozen model-neutral input packet.
- `recovery_proposal.jsonl` — proposed recoveries and credited spans.
- `recovery_ledger.csv` — item/criterion recovery ledger.
- `open_questions.csv` — producer-recorded uncertainties and judgment calls.
- `SUMMARY.md` — producer's assertions and invariant measurements; validate rather than trust them.

Validate A against its work order, the protected Biology segmentation source named there, and an independent read-only Production extraction. Verify provenance, byte offsets, criterion mappings, concatenation, scope, and the distinction between recovered and newly drafted text.

## Where to find Work Order B

Directory:

`docs/research/apstats_canonical_answers_2026_09_22/`

Files to review:

- `packet.jsonl` — frozen model-neutral input packet for all in-scope and out-of-scope AP Statistics FRQs.
- `canonical_proposal.jsonl` — proposed canonical answers, credited spans, coverage, derivations, and flags.
- `criterion_ledger.csv` — one row per item/criterion.
- `open_questions.csv` — producer-recorded uncertainties and judgment calls.
- `SUMMARY.md` — producer's assertions and invariant measurements; validate rather than trust them.

Validate B from the stored stem, stimulus, prompt structure, and rubric. Independently rederive every numeric claim, test criterion coverage semantically, inspect span boundaries and strike behavior, check for rubric-instruction prose masquerading as an answer, and confirm that no out-of-scope existing answer was altered.

## Where to find Work Order C

Directory:

`docs/research/apstats_segmentation_2026_09_22/`

Files to review:

- `packet.jsonl` — frozen model-neutral input packet.
- `segmentation_proposal.jsonl` — verbatim segmentation proposal with source fields and offsets.
- `criterion_ledger.csv` — covered and uncovered criterion ledger.
- `open_questions.csv` — producer-recorded uncertainties and judgment calls.
- `SUMMARY.md` — producer's assertions and invariant measurements; validate rather than trust them.

Validate C by independently reading both canonical-answer fields for every in-scope item. Check exact byte preservation, source-field attribution, offsets, criterion semantics, uncovered determinations, cross-criterion entanglement, and preservation of any nonblank second answer field. Compare the C packet independently with Production and with B's packet only after each packet has been validated on its own.

## Where to find Work Order D

Directory:

`docs/research/calcab_chem_topic_labels_2026_09_22/`

Files to review:

- `packet.jsonl` — frozen item content, rubric/choice evidence, author signals, and taxonomy source identifiers.
- `inventory.csv` — existing author-code and governed-label inventory.
- `topic_labels_proposal.csv` — proposed primary topic selection for each item.
- `open_questions.csv` — producer-recorded uncertainties and judgment calls.
- `SUMMARY.md` — producer's assertions and invariant measurements; validate rather than trust them.

Validate D against fresh read-only copies of the exact taxonomy source versions required by the work order. Confirm closed-list membership, topic titles, unit/topic consistency, recovery eligibility, author-code preservation, content agreement, derived-label rationale, alternatives, signal conflicts, confidence, and human-review flags. Judge Chemistry before Calculus if review time becomes constrained.

## QA isolation rules

- Requery Production read-only rather than accepting packet contents as authoritative.
- Recompute counts and invariants before opening each producer `SUMMARY.md` where practical.
- Do not edit proposal packets, ledgers, inventories, or summaries.
- Do not write to Production or to `app.content_taxonomy_labels`.
- Do not treat the producer's confidence, flags, or open questions as proof; they are sampling aids only.
- Do not reuse an answer proposal as the rubric ground truth. The stored rubric and item are the specification.
- Record disagreements even when the proposal is structurally valid.
- Keep QA findings attributable to A, B, C, or D and to an exact `content_key` or criterion whenever possible.

## QA output locations

Write QA-owned files only in the corresponding work-order directory:

- `qa_findings.csv`
- `qa_report.md`

Do not overwrite either file if it already exists. Follow the overnight protocol's handling rules for pre-existing QA artifacts and preserve provenance. If a work order specifies a more exact QA schema, follow that schema.

## Recommended review order

Run QA serially in the same order as production:

1. A — Biology canonical recovery
2. B — AP Statistics canonical authoring and segmentation
3. C — AP Statistics existing-answer segmentation
4. D — Calculus AB and Chemistry topic labels

Complete and save the QA artifacts for one work order before beginning the next. Report Claude's independently measured results without reconciling them to the producer's summaries; comparison and adjudication should happen only after the independent report is complete.
