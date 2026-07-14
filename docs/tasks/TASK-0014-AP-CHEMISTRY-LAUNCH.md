# TASK-0014 — AP Chemistry Launch (Subject 3)

**Task ID:** TASK-0014
**Title:** Expand Cramapple to AP Chemistry as the third subject
**Owner:** Main Conductor
**Product Owner:** David Bloom
**Tier:** Hard-Gate
**Status:** In Progress
**Priority:** High
**Created Date:** 2026-07-14
**Approved Date:** 2026-07-14 (`APPROVAL-0026`)

## Product Goal

Launch AP Chemistry as a Cramapple subject, reusing the multi-subject logical
model (`CONTENT_AUTHORING_AND_PROMPT_ARCHITECTURE.md` §6), the `app.subjects`
normalization, and the subject-driven grading path already generalized for AP
Statistics (`TASK-0013` Phase 1: `evaluate-attempt` resolves the exam from
`app.exam_packs.exam_name`, so a new subject grades by data, not new branching).

AP Chemistry is the closest structural cousin to AP Biology: unit-organized,
MCQ + criterion/rubric-scored FRQs, and heavy on quantitative and data-analysis
tasks. Most of the grading investment transfers; the net-new work is a
deterministic verifier for chemistry calculations and a chemistry-credentialed
review pool.

## Technical Scope

1. **Grading/prompt reuse (verify, don't rebuild).** Confirm `evaluate-attempt`
   grades AP Chemistry unchanged once an `app.exam_packs` row with
   `exam_name = 'AP Chemistry'` and a `subject_id` exists (the Phase-1
   generalization from `TASK-0013` should already cover this by data). Regression
   check AP Biology and AP Statistics output.
2. **Net-new verification technique.** A deterministic calculation-check verifier
   for chemistry FRQ/quantitative criteria — stoichiometry (mole ratios,
   limiting reactant), gas laws (`PV = nRT`), and equilibrium/pH (`Ka`, `Kb`,
   `pH = −log[H⁺]`). Evaluate reuse of the AP Statistics checker
   (`scripts/ap_statistics_calculation_check/`) — its
   `{calculation_type, target, tolerance, comparison}` spec likely generalizes
   to numeric chemistry answers, but unit handling and significant figures need
   a scoping pass.
3. **Schema/content instantiation.** Insert an `AP Chemistry` row into
   `app.subjects`; create a versioned `exam_pack` and a new `taxonomy_scheme`
   (units, science practices, task verbs) distinct from Biology's — confirm the
   official unit/topic identifiers against the current AP Chemistry CED (publicly
   the 9 units: Atomic Structure; Compounds/Bonding; Intermolecular Forces &
   Properties; Chemical Reactions; Kinetics; Thermodynamics; Equilibrium; Acids
   & Bases; Applications of Thermodynamics).
4. **Content authoring.** A pilot content batch under the same governance rules
   as Biology/Statistics (no official College Board material as input; same
   originality/rights gates). Seed fact packs and short question sets already
   drafted (`docs/content/ap-chemistry/`, `docs/product/FACT_PACKS_AND_QUESTION_SETS.md`)
   are illustrative format examples, not the pilot batch. Pilot size/distribution
   is a pending owner decision (see Approval State).
5. **Frontend/UX.** AP Chemistry appears in the subject selector and
   practice/assessment routes. Chemistry needs notation support (formulas,
   subscripts, charge states, reaction arrows) — scope the input/render UI once
   Phase 1 confirms the grader's response needs.
6. **Calibration.** A scaled AP Statistics-style calibration run against a
   chemistry gold set using the subject-agnostic reviewer tables, with a new
   **chemistry-credentialed** reviewer pool (Biology/Statistics reviewers are not
   assumed chemistry-qualified).

## Out of Scope

- AP Calculus (that is `TASK-0015`) and any other subject.
- Full Biology-scale content volume for the pilot batch.
- Production deployment or public launch — separate Hard Gate under
  `STANDING_APPROVAL_LANES.md` Lane 3, not pre-authorized by this task.
- Pricing, bundling, or marketing sequencing.

## Routes / Components / Systems Affected

- `supabase/functions/evaluate-attempt/index.ts` (verify subject-driven grading;
  likely no change needed)
- New deterministic chemistry calculation verifier (module or `scripts/`)
- `app.subjects`, `app.exam_packs`, new taxonomy_scheme/content_labels rows
- Frontend: subject selector, AP Chemistry routes, chemistry notation input/render
- Reviewer/tutor workflow: new chemistry-credentialed reviewer accounts

## Data / Security / Integration Impact

- Additive `app.subjects`/exam_pack/taxonomy rows — routed through the Database
  Migrations hard gate; not destructive.
- No change to student-data handling, auth, or secrets boundaries.
- Chemistry reviewer credentialing is a new owner decision, not a config change.

## Acceptance Criteria

- [ ] `app.subjects` contains an `ap-chemistry` row; a versioned exam_pack and
      taxonomy_scheme exist, with unit/topic ids confirmed against the CED.
- [ ] `evaluate-attempt` grades at least one AP Chemistry FRQ task type
      subject-driven, with AP Biology and AP Statistics output unchanged
      (regression-safe).
- [ ] A deterministic calculation-check verifier handles at least one chemistry
      criterion type (e.g. limiting reactant or pH) and is demonstrated against
      correct/incorrect test cases, including unit and significant-figure handling.
- [ ] A pilot content batch (size TBD by Orly/David) passes the same
      originality/rights/scientific-consistency gates as Biology content, under
      chemistry-qualified review.
- [ ] A calibration run against a chemistry gold set produces documented grader
      agreement/confidence numbers.
- [ ] Frontend exposes AP Chemistry end-to-end in a non-production environment,
      including chemistry notation.

## QA Plan

- Manual QA: before/after regression spot-check of AP Biology and AP Statistics
  grading output after any grading-path change.
- Automated tests: unit tests on the chemistry calculation verifier against known
  correct/incorrect work (stoichiometry, gas law, pH), including unit-mismatch
  and sig-fig boundary cases.
- Regression areas: existing subjects' grading paths; taxonomy resolution from
  the immutable question-version the student saw.
- Failure cases: unbalanced equations, missing units, ambiguous notation,
  criterion boundary cases (reuse the boundary-contract pattern).

## Approval State

**Approval Required:** Yes
**Approval Type:** Hard Gate
**Decision:** Approved — `APPROVAL-0026` (Product Owner, 2026-07-14). Selection
recorded in `DECISION-0036`.

**Owner decisions (resolved 2026-07-14):**

1. **Curriculum owner:** David Bloom (holding the role in Orly's stead).
2. **Reviewer/author pool:** David will hire new chemistry-credentialed tutors and
   independent reviewers for this subject — new recruitment, not cross-credentialing
   from the AP Biology pool.
3. **Task scope/grouping:** as drafted.
4. **Pilot batch size — RECOMMENDED, pending Product Owner confirmation of exact
   numbers.** Per-unit density **8 MCQ + 3 FRQ** (anchored to the AP Statistics
   pilot). Two-stage, gated on calibration:
   - **Stage A (validation slice):** the 3 highest-exam-weight units ≈ **24 MCQ +
     9 FRQ**; run the full author → review → grading → calibration loop before
     scaling.
   - **Stage B (unit-complete pilot):** all ~9 units ≈ **72 MCQ + 27 FRQ**.
   Unit counts approximate pending CED confirmation. Roughly one in three FRQs
   should be multi-part to exercise harder grading.

Execution is approved. Production deployment, public launch, and any lowering of
the originality/rights/teaching/grading/accessibility gates remain separate Hard
Gates and are **not** granted here; domain-qualified Learning Quality review and
calibration still gate production.

## Implementation Notes — Delegation Plan (proposed, pending approval)

| Phase | Work | Delegate | Depends on | Status |
|---|---|---|---|---|
| 0 | Decision gate — the 4 pending owner decisions above | **David** | `DECISION-0036` | Not started |
| 1 | Verify subject-driven grading covers AP Chemistry by data; regression-test existing subjects | Backend | Phase 0 | Not started |
| 2 | `app.subjects` + exam_pack + taxonomy_scheme/content_labels for AP Chemistry (additive migration) | Backend, reviewed for label correctness | Phase 1 | Not started |
| 3 | Deterministic chemistry calculation verifier (evaluate reuse of the Stats checker) | Backend | Phase 1 | Not started |
| 4 | Pilot content batch (governed authoring, no official material) | Curriculum owner, chemistry-qualified review | Phase 2 | Seed format examples drafted; pilot not started |
| 5 | Subject selector + AP Chemistry routes + notation UI | Frontend | Phase 2 + 4 | Not started |
| 6 | Calibration run + chemistry reviewer credentialing | QA protocol + David | Phases 3–4 | Not started |
| 7 | Launch readiness review (separate Hard Gate) | **David** | All above | Not started |

## Done Decision

**Decision:** Pending
**Date:** Pending
