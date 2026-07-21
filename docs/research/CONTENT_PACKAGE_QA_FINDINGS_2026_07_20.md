# Content Package QA Findings — 2026-07-20

## Scope and disposition

The reusable content-QA prompt was applied to the repository package inventory
and the production completeness inventory. Repository scope was 288 authored
packages across eight AP subjects: 160 MCQs and 128 FRQs containing 364 scoring
criteria.

The repository batch now passes the authoritative preflight in strict mode:

- blocking findings: 0
- warnings: 0
- MCQ packages checked: 160
- FRQ packages checked: 128
- FRQ criteria checked: 364

The subject-specific verification suites also pass for all eight subjects. The
five-subject suite verifies 180 content keys; the calculus/precalculus suite
verifies 108 content keys.

## Findings remediated

1. `FRQ_POINTS_INVALID` accepted fractional values. The shared preflight now
   requires a finite integer greater than or equal to one, with regression
   coverage for fractional, zero, negative, `NaN`, and infinite values.
2. The CLI claimed subject-harness support but did not adapt nested FRQ
   `parts[].criteria`. It now maps nested criteria, canonical answers, teaching
   explanations, evidence requirements, and authored minimum fixes into the
   authoritative contract.
3. The subject-harness compiler previously validated JSON shape without running
   the authoritative completeness gate. Compilation now fails before producing
   an ingestion plan when any package has a blocking finding.
4. The direct calculus seed path bypassed the shared authoring flow and
   synthesized generic repair coaching. It now validates MCQ/FRQ completeness
   before writes and persists each criterion's authored `minimum_fix`.
5. The database subject-package projection used the same generic `minimum_fix`
   for every criterion. A migration adds a pre-insert database backstop,
   preserves authored coaching, and backfills earlier subject-package rows from
   their stored package payloads.
6. All 364 repository FRQ criteria now include an opportunity-framed,
   evidence-specific `minimum_fix`; package provenance hashes were recomputed.
7. The earlier item-quality sweep remediated duplicated distractor rationales,
   generic FRQ criteria, physics archetype leakage and prompt/grading
   mismatches, and the incorrect constant in `apcalcab-frq-005`.

## Production inventory finding

A read-only audit of the current production database found 818 items: 378 MCQs
and 440 FRQs. MCQ required fields and keys were complete. FRQ points were valid
integers and every FRQ had criteria, but 172 criteria across 80 subject-harness
FRQs lacked both `evidence_requirements` and `minimum_fix` in their projected
rows. Seventy-four affected items were assigned and six were published:

- `apchem-frq-l-001`
- `apchem-sfrq-001`
- `apphy1-frq-001`
- `apphy2-frq-001`
- `apphycem-frq-001`
- `apphycm-frq-001`

The migration in this change deterministically repairs those projected fields
from the stored source-package criteria and refuses to complete if any
subject-package FRQ remains mechanically incomplete.

The production inventory also contained 577 empty `accepted_variants` values,
510 empty teaching explanations, and 112 FRQs without a canonical answer.
Those fields are warnings rather than the required-field blocking contract and
span content outside this repository batch. They remain a separate editorial
backlog and must not be represented as completed correctness review.

## Verification evidence

- Shared preflight, adapter, schema, and compiler tests: 30 passed, 0 failed.
- Strict CLI over all 288 repository packages: 0 blocking, 0 warnings.
- Five-subject content verification: valid, 180 content keys.
- Calculus/precalculus content verification: valid, 108 content keys.
- Production inventory query: read-only; no production rows were changed during
  this QA session.
