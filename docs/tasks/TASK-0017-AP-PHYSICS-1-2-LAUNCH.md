# TASK-0017 — AP Physics 1 & 2 Launch (Algebra-Based)

**Task ID:** TASK-0017
**Title:** Expand Cramapple to AP Physics 1 and AP Physics 2 (algebra-based)
**Owner:** Main Conductor
**Product Owner:** David Bloom
**Tier:** Hard-Gate
**Status:** In Progress (sequenced after Chemistry and Calculus)
**Priority:** High
**Created Date:** 2026-07-14
**Approved Date:** 2026-07-14 (`APPROVAL-0026`)

## Product Goal

Launch AP Physics 1 and AP Physics 2 (both algebra-based) as Cramapple subjects,
reusing the multi-subject logical model and the subject-driven grading path
(`TASK-0013` Phase 1). Both are unit-organized with MCQ + criterion-scored FRQs
and are quantitative but **algebra-based**, so they fit the numeric
calculation-check verifier direction (`TASK-0014` Chemistry, and the AP Statistics
checker) rather than the symbolic-equivalence verifier needed for calculus-based
Physics C (`TASK-0018`).

**Sequencing:** this task follows Chemistry and Calculus (`TASK-0014`,
`TASK-0015`) per `DECISION-0037`.

## Technical Scope

1. **Grading/prompt reuse (verify, don't rebuild).** Confirm `evaluate-attempt`
   grades AP Physics 1 and 2 by data once exam_pack rows and `subject_id`s exist.
   Regression check the other subjects.
2. **Verification technique.** Numeric calculation checks for physics FRQ/
   quantitative criteria (kinematics, dynamics, energy/momentum for Physics 1;
   circuits, fluids, thermodynamics, optics for Physics 2), with **units and
   vector components** handled — an extension of the Chemistry/Statistics numeric
   checker, not the calculus symbolic verifier.
3. **Schema/content instantiation.** Insert `AP Physics 1` and `AP Physics 2`
   rows into `app.subjects`; create versioned exam_packs and taxonomy_schemes.
   Confirm official unit/topic identifiers against the current CEDs (the AP
   Physics frameworks were revised for recent school years — do not assume prior
   unit numbering).
4. **Content authoring.** Pilot batches under the same governance rules (no
   official material; same originality/rights gates). Seed fact packs and short
   question sets are drafted (`docs/content/ap-physics-1/`,
   `docs/content/ap-physics-2/`) as illustrative format examples, not the pilot
   batch.
5. **Frontend/UX.** Physics 1 and 2 in the subject selector and routes. Physics
   needs vector notation and free-body / circuit / ray diagrams — scope the
   input/render surface once Phase 1 confirms the grader's response needs.
6. **Calibration.** Scaled calibration runs against physics gold sets with a new
   **physics-credentialed** reviewer pool (shared across Physics 1 & 2, both
   algebra-based).

## Out of Scope

- AP Physics C: Mechanics and E&M (calculus-based) — that is `TASK-0018`.
- Chemistry and Calculus (`TASK-0014`/`TASK-0015`) and any other subject.
- Full Biology-scale content volume for the pilot batches.
- Production deployment or public launch — separate Hard Gate under
  `STANDING_APPROVAL_LANES.md` Lane 3.
- Pricing, bundling, or marketing sequencing.

## Routes / Components / Systems Affected

- `supabase/functions/evaluate-attempt/index.ts` (verify subject-driven grading)
- Numeric physics calculation verifier with unit/vector handling
- `app.subjects`, `app.exam_packs`, taxonomy_scheme rows for Physics 1 and 2
- Frontend: subject selector, Physics 1/2 routes, vector notation + diagram render
- Reviewer/tutor workflow: physics-credentialed reviewer accounts

## Data / Security / Integration Impact

- Additive subject/exam_pack/taxonomy rows — Database Migrations hard gate; not
  destructive.
- No change to student-data handling, auth, or secrets boundaries.
- Physics reviewer credentialing is a new owner decision.

## Acceptance Criteria

- [ ] `app.subjects` contains `ap-physics-1` and `ap-physics-2` rows with
      versioned exam_packs and taxonomy_schemes; unit/topic ids confirmed against
      the current CEDs.
- [ ] `evaluate-attempt` grades at least one FRQ task type for each of Physics 1
      and 2 subject-driven, other subjects unchanged (regression-safe).
- [ ] A numeric calculation verifier handles at least one physics criterion type
      per exam, including units and (where relevant) vector components, demonstrated
      against correct/incorrect cases.
- [ ] Pilot content batches (sizes TBD by owner) pass the same
      originality/rights/scientific-consistency gates as Biology, under
      physics-qualified review.
- [ ] Calibration runs against physics gold sets produce documented grader
      agreement/confidence numbers.
- [ ] Frontend exposes Physics 1 and 2 end-to-end in a non-production environment,
      including vector notation and required diagrams.

## QA Plan

- Manual QA: regression spot-check of other subjects' grading output.
- Automated tests: unit tests on the numeric physics verifier — correct/incorrect
  work, unit mismatches, vector-component and sig-fig cases.
- Regression areas: existing subjects' grading; taxonomy resolution from the
  immutable question-version the student saw.
- Failure cases: missing units, wrong vector direction, sign conventions,
  criterion boundary cases.

## Approval State

**Approval Required:** Yes
**Approval Type:** Hard Gate
**Decision:** Approved — `APPROVAL-0026` (Product Owner, 2026-07-14). Selection and
sequencing recorded in `DECISION-0037`. Sequenced after Chemistry and Calculus.

**Owner decisions (resolved 2026-07-14):**

1. **Curriculum owner:** David Bloom (holding the role in Orly's stead).
2. **Reviewer/author pool:** David will hire new physics-credentialed tutors and
   independent reviewers for Physics 1 & 2 — new recruitment.
3. **Task grouping:** Physics 1 & 2 remain one task track (this task), confirmed.
4. **Pilot batch size — RECOMMENDED, pending Product Owner confirmation of exact
   numbers.** Per-unit density **8 MCQ + 3 FRQ**. Two-stage, gated on calibration:
   - **Stage A (validation slice, each exam):** 3 highest-weight units ≈ **24 MCQ
     + 9 FRQ** per exam.
   - **Stage B (unit-complete):** Physics 1 ~8 units ≈ **64 MCQ + 24 FRQ**;
     Physics 2 ~7 units ≈ **56 MCQ + 21 FRQ**.
   Unit counts approximate pending CED confirmation.

Execution is approved. Production deployment, public launch, and any lowering of
the originality/rights/teaching/grading/accessibility gates remain separate Hard
Gates and are **not** granted here; domain-qualified Learning Quality review and
calibration still gate production.

## Implementation Notes — Delegation Plan (proposed, pending approval)

| Phase | Work | Delegate | Depends on | Status |
|---|---|---|---|---|
| 0 | Decision gate — the 4 pending owner decisions above | **David** | `DECISION-0037`; TASK-0014/0015 sequencing | Not started |
| 1 | Verify subject-driven grading covers Physics 1 & 2 by data; regression-test | Backend | Phase 0 | Not started |
| 2 | `app.subjects`/exam_packs/taxonomy for Physics 1 & 2 (additive migration) | Backend, reviewed for label correctness | Phase 1 | Not started |
| 3 | Numeric physics calculation verifier (units + vectors) | Backend | Phase 1 | Not started |
| 4 | Pilot content batches (governed authoring, no official material) | Curriculum owner, physics-qualified review | Phase 2 | Seed format examples drafted; pilot not started |
| 5 | Subject selector + Physics 1/2 routes + vector/diagram UI | Frontend | Phase 2 + 4 | Not started |
| 6 | Calibration runs + physics reviewer credentialing | QA protocol + David | Phases 3–4 | Not started |
| 7 | Launch readiness review (separate Hard Gate) | **David** | All above | Not started |

## Done Decision

**Decision:** Pending
**Date:** Pending
