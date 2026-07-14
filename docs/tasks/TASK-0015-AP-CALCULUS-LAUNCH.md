# TASK-0015 — AP Calculus AB & BC Launch (Subject 4)

**Task ID:** TASK-0015
**Title:** Expand Cramapple to AP Calculus AB and BC
**Owner:** Main Conductor
**Product Owner:** David Bloom
**Tier:** Hard-Gate
**Status:** In Progress
**Priority:** High
**Created Date:** 2026-07-14
**Approved Date:** 2026-07-14 (`APPROVAL-0026`)

## Product Goal

Launch AP Calculus AB and AP Calculus BC, reusing the multi-subject logical model
and the subject-driven grading path (`TASK-0013` Phase 1). AP Calculus is heavily
symbolic and quantitative; its FRQs require computed and symbolic answers, which
fits the deterministic verification direction named in
`CONTENT_AUTHORING_AND_PROMPT_ARCHITECTURE.md` §7 but pushes it further than
numeric-tolerance checking — calculus grading needs **symbolic equivalence**
(e.g. accepting `x²eˣ(3 + x)` and `3x²eˣ + x³eˣ` as the same derivative).

**AB ⊂ BC.** AP Calculus AB is a strict subset of BC. This task treats them as
two exam packs over one shared body of content: AB content is tagged
`applies_to: [CALCAB, CALCBC]` and reused by BC; BC-only material (parametric/
polar/vector, Unit 9; infinite sequences and series, Unit 10) is tagged
`[CALCBC]`. Authoring AB content once and reusing it for BC is the core efficiency
of launching them together.

## Technical Scope

1. **Grading/prompt reuse (verify, don't rebuild).** Confirm `evaluate-attempt`
   grades AP Calculus by data once exam_pack rows for `'AP Calculus AB'` and
   `'AP Calculus BC'` and their `subject_id`s exist. Regression check the other
   subjects.
2. **Net-new verification technique — symbolic equivalence.** Calculus criteria
   need a symbolic checker (derivative/integral equivalence, algebraic
   simplification, interval/limit answers), not just numeric tolerance. The AP
   Statistics numeric checker does not cover this. Scope a CAS-style equivalence
   check (e.g. compare canonical forms / difference-simplifies-to-zero) with
   bounded, sandboxed evaluation, per the sandboxed-execution note in §7.
3. **Schema/content instantiation.** Insert `AP Calculus AB` and `AP Calculus BC`
   rows into `app.subjects` (or one subject family with two exam packs — see
   pending decision); create versioned exam_packs and taxonomy_schemes. Confirm
   unit/topic identifiers against the current AP Calculus CED (publicly: AB Units
   1–8; BC = AB plus Unit 9 parametric/polar/vector and Unit 10 series). Encode
   the AB⊂BC reuse relationship in the taxonomy so BC inherits AB nodes.
4. **Content authoring.** A pilot batch under the same governance rules (no
   official material; same originality/rights gates). Seed fact packs and short
   question sets are drafted (`docs/content/ap-calculus-ab/`,
   `docs/content/ap-calculus-bc/`) as illustrative format examples, not the pilot
   batch. Pilot size/distribution is a pending owner decision.
5. **Frontend/UX.** AP Calculus AB and BC in the subject selector and routes.
   Calculus needs math notation (integrals, limits, exponents, fractions,
   summation) input and rendering — a larger notation surface than chemistry;
   scope once Phase 1 confirms the grader's response needs.
6. **Calibration.** A scaled calibration run against a calculus gold set with a
   new **calculus-credentialed** reviewer pool.

## Out of Scope

- AP Chemistry (that is `TASK-0014`) and any other subject.
- Full Biology-scale content volume for the pilot batch.
- Production deployment or public launch — separate Hard Gate under
  `STANDING_APPROVAL_LANES.md` Lane 3.
- Pricing, bundling, or marketing sequencing.

## Routes / Components / Systems Affected

- `supabase/functions/evaluate-attempt/index.ts` (verify subject-driven grading)
- New symbolic-equivalence verifier (sandboxed) — the largest net-new build
- `app.subjects`, `app.exam_packs`, taxonomy_scheme with AB⊂BC inheritance
- Frontend: subject selector, AP Calculus AB/BC routes, math notation input/render
- Reviewer/tutor workflow: new calculus-credentialed reviewer accounts

## Data / Security / Integration Impact

- Additive subject/exam_pack/taxonomy rows — Database Migrations hard gate; not
  destructive.
- The symbolic-equivalence checker must run sandboxed with bounded execution
  (no arbitrary code execution from student input) — a security review item.
- Calculus reviewer credentialing is a new owner decision.

## Acceptance Criteria

- [ ] `app.subjects`/exam_packs contain AP Calculus AB and BC entries with
      taxonomy schemes; unit/topic ids confirmed against the CED; the AB⊂BC reuse
      relationship is encoded (BC reuses AB nodes, no duplicate authoring).
- [ ] `evaluate-attempt` grades at least one AP Calculus FRQ task type
      subject-driven, other subjects' output unchanged (regression-safe).
- [ ] A symbolic-equivalence verifier accepts equivalent correct forms and
      rejects incorrect ones for at least one criterion type (e.g. a derivative
      or a definite integral), running sandboxed with bounded execution.
- [ ] A pilot content batch (size TBD) passes the same governance gates under
      calculus-qualified review, with AB content demonstrably reused by BC.
- [ ] A calibration run against a calculus gold set produces documented grader
      agreement/confidence numbers.
- [ ] Frontend exposes AP Calculus AB and BC end-to-end in a non-production
      environment, including math notation.

## QA Plan

- Manual QA: regression spot-check of other subjects' grading output after any
  grading-path change.
- Automated tests: unit tests on the symbolic-equivalence verifier — equivalent
  forms accepted, wrong answers rejected, adversarial inputs (unsimplified,
  reordered, sign-error) handled; sandbox resource limits enforced.
- Regression areas: existing subjects' grading; taxonomy resolution and AB⊂BC
  inheritance from the immutable question-version the student saw.
- Failure cases: unsimplified-but-correct answers, notation ambiguity, interval
  endpoints, non-terminating decimals, criterion boundary cases.
- Security: confirm the equivalence checker cannot execute arbitrary student
  input and is bounded in time/memory.

## Approval State

**Approval Required:** Yes
**Approval Type:** Hard Gate
**Decision:** Approved — `APPROVAL-0026` (Product Owner, 2026-07-14). Selection
recorded in `DECISION-0036`.

**Owner decisions (resolved 2026-07-14):**

1. **Curriculum owner:** David Bloom (holding the role in Orly's stead).
2. **Reviewer/author pool:** David will hire new calculus-credentialed tutors and
   independent reviewers — new recruitment, not cross-credentialing.
3. **AB/BC modeling:** open sub-decision retained for Phase 2 (two `app.subjects`
   rows vs. one family with two exam packs); recommended one family sharing a
   taxonomy so AB⊂BC reuse is natural. Does not block approval.
4. **Pilot batch size — RECOMMENDED, pending Product Owner confirmation of exact
   numbers.** Per-unit density **8 MCQ + 3 FRQ**. Two-stage, gated on calibration:
   - **Stage A (validation slice):** 3 highest-weight AB units ≈ **24 MCQ + 9 FRQ**.
   - **Stage B (unit-complete):** AB's ~8 units ≈ **64 MCQ + 24 FRQ**, authored
     once and reused by BC; plus the ~2 BC-only units (Unit 9 parametric/polar,
     Unit 10 series) ≈ **+16 MCQ + 6 FRQ**. BC's usable bank by reuse ≈ 80 MCQ +
     30 FRQ.
   Unit counts approximate pending CED confirmation.

Execution is approved. Production deployment, public launch, and any lowering of
the originality/rights/teaching/grading/accessibility gates remain separate Hard
Gates and are **not** granted here; domain-qualified Learning Quality review and
calibration still gate production.

## Implementation Notes — Delegation Plan (proposed, pending approval)

| Phase | Work | Delegate | Depends on | Status |
|---|---|---|---|---|
| 0 | Decision gate — the 5 pending owner decisions above | **David** | `DECISION-0036` | Not started |
| 1 | Verify subject-driven grading covers AP Calculus by data; regression-test | Backend | Phase 0 | Not started |
| 2 | `app.subjects`/exam_packs/taxonomy for AB & BC with AB⊂BC inheritance (additive migration) | Backend, reviewed for label correctness | Phase 1 | Not started |
| 3 | Symbolic-equivalence verifier (sandboxed) — the main net-new build | Backend + security review | Phase 1 | Not started |
| 4 | Pilot content batch (AB authored once, reused by BC; governed, no official material) | Curriculum owner, calculus-qualified review | Phase 2 | Seed format examples drafted; pilot not started |
| 5 | Subject selector + AP Calculus AB/BC routes + math notation UI | Frontend | Phase 2 + 4 | Not started |
| 6 | Calibration run + calculus reviewer credentialing | QA protocol + David | Phases 3–4 | Not started |
| 7 | Launch readiness review (separate Hard Gate) | **David** | All above | Not started |

## Done Decision

**Decision:** Pending
**Date:** Pending

---

*Task-number note: TASK-0014/0015 claimed as the next free numbers on branch
`claude/cramapple-content-creation-igjvfb`. TASK-0016 is already in use (grading,
other branch). If numbering collides on merge, renumber whichever merges second
and update `MASTER_TODO.md`.*
