# TASK-0014 — AP Chemistry Launch (Subject 3)

**Task ID:** TASK-0014
**Title:** Expand Cramapple to AP Chemistry as the third subject
**Owner:** Main Conductor
**Product Owner:** David Bloom
**Tier:** Hard-Gate
**Status:** In Progress
**Priority:** High
**Created Date:** 2026-07-07
**Approved Date:** 2026-07-07 (Phase 0 only — see `APPROVAL-0026`)

## Product Goal

Launch AP Chemistry as a new Cramapple subject by reusing the multi-subject
logical model, subject-driven prompt composition, and governed content pipeline
already established for AP Biology and AP Statistics.

AP Chemistry is a natural-science subject, so the launch should primarily
instantiate Chemistry-specific data, content, review, and UX surfaces while
only adding platform code where Chemistry proves the need for reusable subject
capabilities such as chemical notation, stoichiometric calculation checks,
equilibrium reasoning, or other chemistry-specific verification profiles.

## Technical Scope

1. **Grading/prompt generalization.** Ensure any remaining AP Biology literals
   in chemistry-facing prompt composition, content selection, or verification
   paths are data-driven by `subject_id` and versioned exam-pack metadata, not
   hardcoded subject strings.
2. **Schema/content instantiation.** Add an `AP Chemistry` row to
   `app.subjects`; create a versioned `exam_pack`; create the Chemistry
   taxonomy scaffold in `app.content_labels` plus the subject-side taxonomy
   brief used by the authoring flow.
3. **Subject-specific verification.** Define and implement the Chemistry
   verification profile needed for the first pilot batch, likely including
   stoichiometry, equation balancing, unit-aware calculation checks, and
   chemistry-notation handling where required.
4. **Content authoring.** Produce a governed pilot batch of Chemistry MCQ/FRQ
   content under the existing rights, originality, and review rules.
5. **Frontend/UX.** Expose Chemistry in subject selection and route learners
   into Chemistry practice/assessment flows only after the backend/content path
   exists.
6. **Calibration.** Run a Chemistry gold-set calibration and record agreement,
   boundary, and failure-mode evidence before launch readiness review.

## Out of Scope

- World History, Physics, AP Calculus, or any non-Chemistry subject.
- Production deployment or public launch.
- Pricing, bundling, or marketing sequencing decisions.
- Rights-policy changes or use of official College Board materials.
- Reworking AP Biology content rules beyond what is needed to generalize them.

## Routes / Components / Systems Affected

- `supabase/functions/grade-frq/index.ts`
- `supabase/functions/evaluate-attempt/index.ts`
- `app.subjects`, `app.exam_packs`, `app.exam_pack_versions`, taxonomy tables
- Chemistry verification helpers or service modules
- Subject selector and Chemistry practice routes
- Reviewer/tutor workflow for Chemistry-credentialed review

## Data / Security / Integration Impact

- Additive subject rows, exam-pack rows, and taxonomy rows are required.
- Chemistry may require new reusable parsing or verification rules for chemical
  notation and calculations.
- No change to student auth, secret handling, or privacy boundaries.

## Acceptance Criteria

- [ ] Chemistry prompt composition is subject-driven and AP Biology output is
      unchanged.
- [ ] `app.subjects` contains an `ap-chemistry` row with versioned exam-pack
      and taxonomy scaffold records.
- [ ] The initial Chemistry verification profile is implemented and tested
      against at least one pilot criterion type.
- [ ] A governed Chemistry pilot batch passes originality/rights/teaching
      validation.
- [ ] Chemistry calibration against a gold set is documented.
- [ ] Chemistry is selectable end-to-end in a non-production environment.

## QA Plan

- Manual QA: confirm AP Biology regression safety after prompt/generalization
  changes.
- Automated tests: verify Chemistry calculation/profile logic against known
  correct and incorrect examples.
- Regression areas: AP Biology, AP Statistics, prompt-build manifest
  resolution, and subject-selection gating.
- Failure cases: malformed equations, missing units, ambiguous notation,
  stoichiometric boundary cases, and partial work.

## Approval State

**Approval Required:** Yes
**Approval Type:** Hard Gate
**Decision:** Phase 0 Approved (`APPROVAL-0026`, 2026-07-07). Content-sourcing
model approved (`APPROVAL-0028`, 2026-07-07 — reuses the AP Statistics model
from `APPROVAL-0024`/`DECISION-0031`). Phase 2 (schema/migration) and
production launch remain separate Hard Gates not yet granted.

## Implementation Notes — Delegation Plan

| Phase | Work | Delegate | Depends on | Status |
|---|---|---|---|---|
| 0 | Decision gate — confirm Chemistry launch scope, owner review path, and any subject-specific constraints | **David** | — | **Done** (`APPROVAL-0026`) |
| 1 | Generalize grading/prompt composition away from AP Biology literals | **Codex** (backend) | Phase 0 approval | **Ready to start** |
| 2 | Add `app.subjects`, exam-pack, and Chemistry taxonomy rows | **Codex** (backend) | Phase 1 | **Pending** |
| 3 | Build Chemistry verification profile for the first criterion type | **Codex** (backend) | Phase 1 | **Pending** |
| 4 | Author and validate a governed Chemistry pilot batch (tutor-authored-base-package model, `APPROVAL-0028`) | **Orly** (curriculum), with David approval | Phases 2–3 | **Pending** |
| 5 | Expose Chemistry in subject selection and learning routes | **Lovable** (frontend) | Phases 2–4 | **Pending** |
| 6 | Run Chemistry calibration against a gold set | **QA / Learning Quality** | Phases 3–4 | **Pending** |
| 7 | Launch readiness review | **David** | All above | **Pending** |

## Done Decision

**Decision:** Pending
**Date:** Pending
