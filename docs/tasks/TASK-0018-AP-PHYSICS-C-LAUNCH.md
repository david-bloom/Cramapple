# TASK-0018 — AP Physics C: Mechanics & E&M Launch (Calculus-Based)

**Task ID:** TASK-0018
**Title:** Expand Cramapple to AP Physics C: Mechanics and AP Physics C:
Electricity and Magnetism (calculus-based)
**Owner:** Main Conductor
**Product Owner:** David Bloom
**Tier:** Hard-Gate
**Status:** In Progress (sequenced after Chemistry and Calculus)
**Priority:** High
**Created Date:** 2026-07-14
**Approved Date:** 2026-07-14 (`APPROVAL-0026`)

## Product Goal

Launch AP Physics C: Mechanics and AP Physics C: Electricity and Magnetism (both
calculus-based) as Cramapple subjects, reusing the multi-subject logical model and
the subject-driven grading path (`TASK-0013` Phase 1). Because Physics C is
**calculus-based** — derivatives and integrals appear directly in the physics
(e.g. `v = dx/dt`, `W = ∫F·dx`, Gauss's law) — it reuses the **symbolic-equivalence
verifier** scoped in `TASK-0015` (Calculus), not just numeric checks. This is the
efficiency reason `DECISION-0037` sequences Physics after Calculus.

**Sequencing:** this task follows Chemistry and Calculus (`TASK-0014`,
`TASK-0015`) and pairs with `TASK-0017` (algebra-based Physics 1 & 2).

## Technical Scope

1. **Grading/prompt reuse (verify, don't rebuild).** Confirm `evaluate-attempt`
   grades Physics C: Mechanics and Physics C: E&M by data once exam_pack rows and
   `subject_id`s exist. Regression check the other subjects.
2. **Verification technique — reuse the calculus symbolic verifier.** Physics C
   criteria need symbolic equivalence (derivatives/integrals of position, work
   integrals, field integrals) plus numeric checks with units and vectors. Reuse
   the sandboxed symbolic-equivalence verifier from `TASK-0015`; extend it for
   units/vectors as needed. Do not build a second symbolic engine.
3. **Schema/content instantiation.** Insert `AP Physics C: Mechanics` and `AP
   Physics C: E&M` rows into `app.subjects`; create versioned exam_packs and
   taxonomy_schemes. Confirm official unit/topic identifiers against the current
   CEDs.
4. **Content authoring.** Pilot batches under the same governance rules (no
   official material). Seed fact packs and short question sets are drafted
   (`docs/content/ap-physics-c-mechanics/`, `docs/content/ap-physics-c-em/`) as
   illustrative format examples, not the pilot batch.
5. **Frontend/UX.** Physics C: Mechanics and E&M in the subject selector and
   routes. Needs vector and calculus notation plus free-body/field diagrams;
   reuse the calculus math-notation surface from `TASK-0015` where possible.
6. **Calibration.** Scaled calibration runs against Physics C gold sets with a
   **calculus-based-physics-credentialed** reviewer pool (may overlap the
   Physics 1/2 pool but requires calculus-physics qualification).

## Out of Scope

- AP Physics 1 and 2 (algebra-based) — that is `TASK-0017`.
- Chemistry and Calculus (`TASK-0014`/`TASK-0015`) and any other subject.
- Full Biology-scale content volume for the pilot batches.
- Production deployment or public launch — separate Hard Gate under
  `STANDING_APPROVAL_LANES.md` Lane 3.
- Pricing, bundling, or marketing sequencing.

## Routes / Components / Systems Affected

- `supabase/functions/evaluate-attempt/index.ts` (verify subject-driven grading)
- Symbolic-equivalence verifier reused from `TASK-0015`, extended for units/vectors
- `app.subjects`, `app.exam_packs`, taxonomy_scheme rows for both Physics C exams
- Frontend: subject selector, Physics C routes, calculus + vector notation, diagrams
- Reviewer/tutor workflow: calculus-physics-credentialed reviewer accounts

## Data / Security / Integration Impact

- Additive subject/exam_pack/taxonomy rows — Database Migrations hard gate; not
  destructive.
- The reused symbolic-equivalence checker must remain sandboxed with bounded
  execution (security item carried over from `TASK-0015`).
- Reviewer credentialing is a new owner decision.

## Acceptance Criteria

- [ ] `app.subjects` contains `ap-physics-c-mechanics` and `ap-physics-c-em` rows
      with versioned exam_packs and taxonomy_schemes; unit/topic ids confirmed
      against the current CEDs.
- [ ] `evaluate-attempt` grades at least one FRQ task type for each Physics C exam
      subject-driven, other subjects unchanged (regression-safe).
- [ ] The `TASK-0015` symbolic-equivalence verifier is demonstrated on at least
      one Physics C criterion type (e.g. a derived expression for velocity from
      `x(t)`, or a work/field integral), running sandboxed, with units/vectors
      handled.
- [ ] Pilot content batches (sizes TBD) pass the same governance gates under
      calculus-physics-qualified review.
- [ ] Calibration runs against Physics C gold sets produce documented grader
      agreement/confidence numbers.
- [ ] Frontend exposes both Physics C exams end-to-end in a non-production
      environment, including calculus and vector notation and required diagrams.

## QA Plan

- Manual QA: regression spot-check of other subjects' grading output.
- Automated tests: unit tests on the reused symbolic verifier for Physics C cases
  — equivalent derived expressions accepted, wrong ones rejected, units/vectors,
  sandbox limits.
- Regression areas: existing subjects' grading (especially Calculus, which shares
  the verifier); taxonomy resolution from the immutable question-version.
- Failure cases: unsimplified-but-correct expressions, vector direction/sign,
  unit errors, criterion boundary cases.
- Security: confirm the reused equivalence checker remains bounded and cannot
  execute arbitrary student input.

## Approval State

**Approval Required:** Yes
**Approval Type:** Hard Gate
**Decision:** Approved — `APPROVAL-0026` (Product Owner, 2026-07-14). Selection and
sequencing recorded in `DECISION-0037`. Sequenced after Chemistry and Calculus;
depends on the `TASK-0015` symbolic verifier.

**Owner decisions (resolved 2026-07-14):**

1. **Curriculum owner:** David Bloom (holding the role in Orly's stead).
2. **Reviewer/author pool:** David will hire new calculus-physics-credentialed
   tutors and independent reviewers — new recruitment; a calculus-qualified
   reviewer may double for Physics C.
3. **Task grouping:** Mechanics & E&M remain one task track (this task), confirmed.
4. **Pilot batch size — RECOMMENDED, pending Product Owner confirmation of exact
   numbers.** Per-unit density **8 MCQ + 3 FRQ**. Two-stage, gated on calibration:
   - **Stage A (validation slice, each exam):** 3 highest-weight units ≈ **24 MCQ
     + 9 FRQ** per exam (for E&M, which has ~5 units, Stage A may be 2–3 units).
   - **Stage B (unit-complete):** Physics C: Mechanics ~7 units ≈ **56 MCQ + 21
     FRQ**; Physics C: E&M ~5 units ≈ **40 MCQ + 15 FRQ**.
   Unit counts approximate pending CED confirmation.

Execution is approved. Production deployment, public launch, and any lowering of
the originality/rights/teaching/grading/accessibility gates remain separate Hard
Gates and are **not** granted here; domain-qualified Learning Quality review and
calibration still gate production.

## Implementation Notes — Delegation Plan (proposed, pending approval)

| Phase | Work | Delegate | Depends on | Status |
|---|---|---|---|---|
| 0 | Decision gate — the 4 pending owner decisions above | **David** | `DECISION-0037`; TASK-0015 (verifier) | Not started |
| 1 | Verify subject-driven grading covers both Physics C exams by data; regression-test | Backend | Phase 0 | Not started |
| 2 | `app.subjects`/exam_packs/taxonomy for Mechanics & E&M (additive migration) | Backend, reviewed for label correctness | Phase 1 | Not started |
| 3 | Reuse + extend the TASK-0015 symbolic verifier for Physics C (units/vectors) | Backend + security review | Phase 1; TASK-0015 Phase 3 | Not started |
| 4 | Pilot content batches (governed authoring, no official material) | Curriculum owner, calculus-physics review | Phase 2 | Seed format examples drafted; pilot not started |
| 5 | Subject selector + Physics C routes + notation/diagram UI | Frontend | Phase 2 + 4 | Not started |
| 6 | Calibration runs + reviewer credentialing | QA protocol + David | Phases 3–4 | Not started |
| 7 | Launch readiness review (separate Hard Gate) | **David** | All above | Not started |

## Done Decision

**Decision:** Pending
**Date:** Pending

---

*Task-number note: TASK-0017/0018 claimed as the next free numbers on branch
`claude/cramapple-content-creation-igjvfb` (TASK-0016 is in use on the grading
branch). If numbering collides on merge, renumber whichever merges second and
update `MASTER_TODO.md`.*
