# AP Calculus AB Content Batch — 2026-07-27

## Outcome

This batch contains 30 original multiple-choice questions and 20 original free-response questions aligned to the verified AP Calculus AB Course and Exam Description fact pack.

The material is a draft candidate bank for independent human review. It has not been approved, published, inserted into Production, or assigned to reviewers.

## Controlling sources and protocols

- Primary-source fact pack: `docs/product/AP_CALCULUS_AB_BC_CED_FACT_PACK.md`
- Local CED: `docs/teaching/ap-calculus-ab-and-bc-course-and-exam-description.pdf`
- Verified CED SHA-256: `fd571cdc252c24d33a75ed556ee20d9261ef1ad3dbb718d0caf78acecc8253ca`
- Authoring architecture: `docs/architecture/CONTENT_AUTHORING_AND_PROMPT_ARCHITECTURE.md`
- Governance and validation: `docs/architecture/CONTENT_GOVERNANCE_AND_VALIDATION.md`
- Calculus FRQ structure audit: `docs/research/AP_CALCULUS_PRECALC_FRQ_STRUCTURE_VALIDATION_2026_07_26.md`
- Cross-subject MCQ cueing control: `docs/research/MCQ_ANSWER_LENGTH_PARITY_QA_2026_07_21.md`

The CED fact pack controls whenever older generic guidance conflicts with the active Calculus exam specification. In particular, every FRQ is a 9-point question with three or four lettered parts. The batch excludes Units 9 and 10 and BC-only Topics 6.12 and 6.13.

## Blueprint

### MCQ distribution

| Dimension | Count |
|---|---:|
| Unit 1 | 4 |
| Unit 2 | 4 |
| Unit 3 | 2 |
| Unit 4 | 4 |
| Unit 5 | 5 |
| Unit 6 | 5 |
| Unit 7 | 2 |
| Unit 8 | 4 |
| No calculator | 21 |
| Calculator required | 9 |
| Practice 1 primary | 18 |
| Practice 2 primary | 7 |
| Practice 3 primary | 5 |

The unit counts correspond to 13.3%, 13.3%, 6.7%, 13.3%, 16.7%, 16.7%, 6.7%, and 13.3%, respectively, keeping every unit within its published AB multiple-choice weighting range at this batch size.

Answer positions are balanced A/B/C/D as 8/8/7/7.

### FRQ distribution

| Dimension | Count |
|---|---:|
| Unit 1 | 2 |
| Unit 2 | 3 |
| Unit 3 | 1 |
| Unit 4 | 3 |
| Unit 5 | 5 |
| Unit 6 | 2 |
| Unit 7 | 2 |
| Unit 8 | 2 |
| No calculator | 13 |
| Calculator required | 7 |
| 9-point scoring topology | 20 of 20 |
| Three or four lettered parts | 20 of 20 |

The FRQ set mixes contextual rate and accumulation, particle motion, function and derivative analysis, continuity and theorem justification, implicit differentiation, related rates, optimization, differential equations, area, volume, and accumulation-function tasks. Calculator questions require numerical integration, equation solving, or graph-supported candidate analysis rather than carrying a cosmetic calculator label.

## Artifacts

- Student-facing packet with answer key and criterion-level scoring guidance: `docs/teaching/AP_CALCULUS_AB_PRACTICE_PACKET_2026_07_27.md`
- Versioned item packages: `content/item-packages/ap-calculus-ab/apcalcab-mcq-021.json` through `apcalcab-mcq-050.json`, and `apcalcab-frq-017.json` through `apcalcab-frq-036.json`
- Reproducible generator: `scripts/calculus-ab-content-2026-07-27/generate.mjs`
- Deterministic structural verifier: `scripts/calculus-ab-content-2026-07-27/verify.mjs`
- Independent calculation regression suite: `scripts/calculus-ab-content-2026-07-27/math-regression.mjs`
- Machine-readable validation result: `docs/research/AP_CALCULUS_AB_CONTENT_VALIDATION_2026_07_27.json`

## Validation result

The deterministic verifier passes with no errors and no warnings. It checks:

- exact package and identifier counts;
- immutable content hashes;
- CED source integrity;
- AB-only unit and topic scope;
- unit, practice, and calculator distributions;
- four unique MCQ choices with one keyed response;
- balanced MCQ answer positions and correct-answer-length cueing;
- complete choice rationales and misconception mechanisms;
- every FRQ's exact 9-point total and 3–4-part structure;
- criterion-level boundary fields, accepted variants, contradictions, and minimum fixes;
- scratch-work artifacts; and
- near-duplicate prompt similarity.

The independent regression suite passes 36 numerical and algebraic checks covering every calculator-dependent answer and the more consequential constructed-response calculations.

Human mathematical, editorial, accessibility, teaching, and grading review remains required before approval or publication. Author-generated scoring cases are development aids, not a human gold set.

## Production draft load

On 2026-07-28, the complete batch was loaded into the Production Calculus AB
exam pack as review-ready draft content:

| State check | Result |
|---|---:|
| Draft items | 50 |
| Draft item versions | 50 |
| MCQs | 30 |
| FRQs | 20 |
| Published versions | 0 |
| Reviewer assignments | 0 |
| MCQ choices / keyed choices | 120 / 30 |
| FRQ criteria / available points | 180 / 180 |
| Nine-point FRQs | 20 of 20 |

The database records retain the batch's `2026-27` source-school-year
provenance. They are intentionally unassigned and unpublished so they can enter
reviewer management when reviewer capacity becomes available.

The fail-closed draft loader is reproducible from
`scripts/calculus-ab-content-2026-07-27/generate-draft-sql.mjs`. It rejects
preexisting target keys and rolls back unless all expected child records,
draft-state checks, publication checks, and assignment checks reconcile.
