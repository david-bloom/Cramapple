# AP Calculus BC Content Batch — 2026-07-28

Status: Automated authoring preflight and mathematical regression passed.
Human mathematical, editorial, accessibility, teaching, and grading review is
still required before approval or publication.

## Scope and controls

This batch contains 30 original multiple-choice questions and 20 original
nine-point free-response questions for AP Calculus BC.

Controlling sources and procedures:

- `docs/product/AP_CALCULUS_AB_BC_CED_FACT_PACK.md`
- `docs/teaching/ap-calculus-ab-and-bc-course-and-exam-description.pdf`
- verified CED SHA-256:
  `fd571cdc252c24d33a75ed556ee20d9261ef1ad3dbb718d0caf78acecc8253ca`
- `docs/architecture/CONTENT_AUTHORING_AND_PROMPT_ARCHITECTURE.md`
- `docs/architecture/CONTENT_GOVERNANCE_AND_VALIDATION.md`

All questions were independently authored from blank scope briefs. No official
question text, released scoring language, secure material, or third-party
question was used as a generation seed.

## Blueprint

College Board publishes unit-weighting ranges for the multiple-choice section,
not fixed item counts or topic-level percentages. The ranges were therefore
used as portfolio guidance rather than quotas. Units 6 and 10 receive the
largest allocations; Units 5 and 9 receive the next-largest allocations; all
ten units remain represented.

| Unit | MCQ | FRQ | Total |
|---|---:|---:|---:|
| 1 | 2 | 2 | 4 |
| 2 | 2 | 1 | 3 |
| 3 | 2 | 1 | 3 |
| 4 | 2 | 1 | 3 |
| 5 | 4 | 2 | 6 |
| 6 | 5 | 3 | 8 |
| 7 | 2 | 1 | 3 |
| 8 | 2 | 1 | 3 |
| 9 | 4 | 3 | 7 |
| 10 | 5 | 5 | 10 |

Topic coverage includes shared AB/BC content, BC-only partial fractions and
improper integrals, parametric and vector-valued motion, polar area and
derivatives, convergence tests, Taylor and Maclaurin series, error bounds, and
power-series operations.

### Difficulty distribution

The requested 20% / 30% / 30% / 20% distribution is enforced separately for
both sections. Each unit contains at least two difficulty bands.

| Difficulty | MCQ | FRQ | Total |
|---|---:|---:|---:|
| Easy | 6 | 4 | 10 |
| Medium | 9 | 6 | 15 |
| Hard | 9 | 6 | 15 |
| Very Hard | 6 | 4 | 10 |

### Exam-form distribution

- MCQ calculator split: 9 calculator required and 21 no calculator.
- FRQ calculator split: 7 calculator required and 13 no calculator.
- MCQ mathematical practices: Practice 1 = 18, Practice 2 = 7,
  Practice 3 = 5, Practice 4 = 0.
- MCQ answer positions: A/B/C/D = 8/8/7/7.
- Every FRQ contains four lettered parts and exactly nine independently
  represented one-point criteria.

## Automated QA

The deterministic verifier checks:

- exact package, identifier, type, and school-year counts;
- immutable content hashes;
- CED source integrity;
- valid BC unit and topic scope, including Units 9 and 10;
- unit, difficulty, calculator, practice, and answer-position distributions;
- at least two difficulty bands in every unit;
- four unique MCQ choices, one keyed response, and complete rationales;
- prose answer-length cueing;
- complete teaching, transfer, delayed-retrieval, accessibility, and
  originality fields;
- every FRQ's four-part, nine-point scoring topology;
- criterion-level accepted variants, insufficient responses, contradictions,
  minimum fixes, and deterministic point checks;
- scratch-work artifacts; and
- near-duplicate prompts.

Result: PASS with zero errors and zero warnings.

The independent regression suite passes 49 numerical and algebraic checks.
These cover every calculator-dependent result and the higher-risk symbolic
claims, including derivative sign analysis, improper integrals, parametric
second derivatives, vector motion, polar area, series coefficients, and Taylor
error bounds.

## Repair history

The pre-publication QA loop corrected:

- the sign and numerical value of a particle-acceleration MCQ;
- a chain-rule numerical value for an accumulation-function MCQ;
- a parametric second-derivative value;
- the maximizing time and maximum amount in a tank-rate FRQ;
- the absolute-extrema values in a derivative-defined-function FRQ;
- the value and extrema of an oscillatory accumulation function;
- a washer-method volume; and
- several scoring-topology and calculator/practice-distribution mismatches
  detected before database loading.

The generator was rerun after correction, and both QA suites passed on the
regenerated packages.

## Artifacts

- Student packet:
  `docs/teaching/AP_CALCULUS_BC_PRACTICE_PACKET_2026_07_28.md`
- Item packages:
  `content/item-packages/ap-calculus-bc/apcalcbc-mcq-021.json` through
  `apcalcbc-mcq-050.json`, and `apcalcbc-frq-017.json` through
  `apcalcbc-frq-036.json`
- Generator: `scripts/calculus-bc-content-2026-07-28/generate.mjs`
- Structural verifier: `scripts/calculus-bc-content-2026-07-28/verify.mjs`
- Mathematical regression:
  `scripts/calculus-bc-content-2026-07-28/math-regression.mjs`
- Machine-readable validation:
  `docs/research/AP_CALCULUS_BC_CONTENT_VALIDATION_2026_07_28.json`

Author-generated scoring cases are development aids, not a human gold set.

## Production draft load

On 2026-07-28, the corrected batch was loaded into the Production Calculus BC
exam pack as review-ready draft content.

| State check | Result |
|---|---:|
| Draft items | 50 |
| Draft item versions | 50 |
| MCQs | 30 |
| FRQs | 20 |
| Easy / Medium / Hard / Very Hard | 10 / 15 / 15 / 10 |
| Published versions | 0 |
| Reviewer assignments | 0 |
| MCQ choices / keyed choices | 120 / 30 |
| FRQ criteria / available points | 180 / 180 |
| Nine-point FRQs | 20 of 20 |

The records retain `2026-27` source-school-year provenance. They are
intentionally unpublished and unassigned so reviewer management can allocate
them when qualified Calculus BC reviewers are available.

The fail-closed loader is generated by
`scripts/calculus-bc-content-2026-07-28/generate-draft-sql.mjs`. It rejects
preexisting target keys and rolls back unless all expected child records,
draft-state checks, publication checks, and assignment checks reconcile.
