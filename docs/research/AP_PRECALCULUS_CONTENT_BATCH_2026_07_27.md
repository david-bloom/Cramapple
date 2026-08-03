# AP Precalculus Content Batch — 2026-07-27

## Outcome

This batch contains 30 original multiple-choice questions and 20 original free-response questions aligned to the AP Precalculus Course and Exam Description effective Fall 2026.

The content is draft practice material for human review. On 2026-07-28 it was
upgraded to the current complete-package and difficulty-distribution contract.

## Authoritative source and authoring controls

- Local CED: `docs/teaching/ap-precalculus-course-and-exam-description.pdf`
- Local fact pack: `docs/product/AP_PRECALCULUS_CED_FACT_PACK.md`
- Drive fact pack: `AP Precalculus 2026-27 — CED Fact Pack`
  (`18inDRWcdoP7Qq2yw2--3HQ0hZDASahhyvDhwXVyFpz0`)
- Verified source SHA-256: `5ef13ad6e4b39455330257e94d1b4750a833ef6e05ccf2f4a24141912345f04f`
- Drive source file ID: `1ANP9L45EfpyqQXppNl0i1aLMifpbCv8y`
- Architecture: `docs/architecture/CONTENT_AUTHORING_AND_PROMPT_ARCHITECTURE.md`
- Expansion handoff: `prompts/CODEX_CALCULUS_PRECALC_CONTENT_EXPANSION_2026_07_24.md`
- MCQ leakage check: `docs/research/MCQ_ANSWER_LENGTH_PARITY_QA_2026_07_21.md`
- FRQ structure validation: `docs/research/AP_CALCULUS_PRECALC_FRQ_STRUCTURE_VALIDATION_2026_07_26.md`

The CED controls when older generic guidance conflicts with the current exam description. In particular, every Precalculus FRQ in this batch has three 2-point parts and six one-point scoring criteria, for 6 points total.

## Blueprint

### MCQ

| Dimension | Count |
|---|---:|
| Unit 1 | 11 |
| Unit 2 | 9 |
| Unit 3 | 10 |
| Unit 4 | 0 |
| No calculator | 21 |
| Calculator | 9 |
| Practice 1 | 13 |
| Practice 2 | 7 |
| Practice 3 | 10 |

Answer positions are balanced A/B/C/D as 8/8/7/7.

Difficulty is distributed as 6 Easy, 9 Medium, 9 Hard, and 6 Very Hard. Each
of the three assessed units contains all four difficulty bands.

### FRQ

| Official task model | Count | Units | Calculator |
|---|---:|---|---|
| Function Concepts | 5 | 1–2 | Yes |
| Modeling a Non-Periodic Context | 5 | 1–2 | Yes |
| Modeling a Periodic Context | 5 | 3 | No |
| Symbolic Manipulations | 5 | 2–3 | No |

FRQ difficulty is distributed as 4 Easy, 6 Medium, 6 Hard, and 4 Very Hard.
All three assessed units contain every difficulty band across the combined
MCQ/FRQ portfolio.

## Artifacts

- Student-facing packet and answer/scoring section: `docs/teaching/AP_PRECALCULUS_PRACTICE_PACKET_2026_07_27.md`
- Versioned item packages: `content/item-packages/ap-precalculus/apprecalc-mcq-021.json` through `apprecalc-mcq-050.json`, and `apprecalc-frq-017.json` through `apprecalc-frq-036.json`
- Reproducible generator: `scripts/precalculus-content-2026-07-27/generate.mjs`
- Deterministic verifier: `scripts/precalculus-content-2026-07-27/verify.mjs`
- Independent calculation checks: `scripts/precalculus-content-2026-07-27/math-regression.mjs`
- Machine-readable validation result: `docs/research/AP_PRECALCULUS_CONTENT_VALIDATION_2026_07_27.json`

## Validation status

The deterministic verifier passes with no errors and no warnings. It checks:

- package counts, identifiers, hashes, and source-PDF integrity;
- assessed Unit 1–3 and topic scope, with zero Unit 4 exam content;
- exact difficulty distributions and all four bands within each assessed unit;
- calculator modes, mathematical-practice distribution, answer balance, and
  MCQ choice integrity;
- all four FRQ task models and their calculator policies;
- exact three-part, two-points-per-part, six-point FRQ scoring topology;
- criterion-level accepted variants, insufficient responses, contradictions,
  minimum fixes, and scoring contracts;
- required teaching, transfer, delayed-retrieval, accessibility, and
  originality fields;
- absence of calculus notation or derivative language; and
- near-duplicate prompt similarity.

The expanded regression suite passes 28 numerical and algebraic checks.

The repair loop corrected two mathematical defects that the earlier suite had
not detected: a mixed-exponential table that failed to match its derived model
beyond the first two points, and an incorrectly rounded exponential-function
value. The generator and both QA suites were rerun after correction.

Human mathematical/editorial review remains required before approval or publication.

## Production draft load

On 2026-07-28, the corrected batch was loaded into the Production AP
Precalculus exam pack as review-ready draft content.

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
| FRQ criteria / available points | 120 / 120 |
| Six-point, three-part FRQs | 20 of 20 |
| Distinct official FRQ archetypes | 4 |

The records retain `2026-27` source-school-year provenance. They are
intentionally unpublished and unassigned so reviewer management can allocate
them when qualified Precalculus reviewers are available.

The fail-closed loader is generated by
`scripts/precalculus-content-2026-07-27/generate-draft-sql.mjs`. It rejects
preexisting target keys and rolls back unless all expected child records,
draft-state checks, publication checks, and assignment checks reconcile.
