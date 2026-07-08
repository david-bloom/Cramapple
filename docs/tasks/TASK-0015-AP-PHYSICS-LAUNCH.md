# TASK-0015 — AP Physics Launch (Subject 4)

**Task ID:** TASK-0015
**Title:** Expand Cramapple to AP Physics as the fourth subject
**Owner:** Main Conductor
**Product Owner:** David Bloom
**Tier:** Hard-Gate
**Status:** In Progress
**Priority:** High
**Created Date:** 2026-07-07
**Approved Date:** 2026-07-07 (Phase 0 only — see `APPROVAL-0027`)

## Product Goal

Launch AP Physics as a new Cramapple subject by extending the existing
multi-subject architecture, governed content workflow, and subject-aware UX
that already support AP Biology and AP Statistics.

Physics is likely to require reusable platform capabilities beyond Biology,
including symbolic math, vector reasoning, dimensional analysis, unit handling,
and possibly diagram/graph support. The launch should keep the platform generic
enough to support later physics variants while avoiding premature abstraction
that Biology has not proven necessary.

## Technical Scope

1. **Grading/prompt generalization.** Remove any AP Biology-only literals from
   Physics-facing prompt composition and verification paths so Physics is
   driven by subject metadata, not subject-specific strings.
2. **Schema/content instantiation.** Add an `AP Physics` row to
   `app.subjects`; create a versioned `exam_pack`; create a Physics-specific
   `taxonomy_scheme` for units, practices, representations, and task types.
3. **Subject-specific verification.** Define the Physics verification profile
   needed for the first pilot batch, likely including symbolic math, unit
   consistency, vector reasoning, and calculation checks.
4. **Content authoring.** Produce a governed pilot batch of Physics content
   under the existing rights, originality, and review rules.
5. **Frontend/UX.** Expose Physics in subject selection and routes only after
   the backend/content path exists.
6. **Calibration.** Run a Physics gold-set calibration and record agreement,
   boundary, and failure-mode evidence before launch readiness review.

## Out of Scope

- World History, AP Chemistry, AP Calculus, or any non-Physics subject.
- Production deployment or public launch.
- Pricing, bundling, or marketing sequencing decisions.
- Rights-policy changes or use of official College Board materials.
- Reworking AP Biology content rules beyond what is needed to generalize them.

## Routes / Components / Systems Affected

- `supabase/functions/grade-frq/index.ts`
- `supabase/functions/evaluate-attempt/index.ts`
- `app.subjects`, `app.exam_packs`, `app.exam_pack_versions`, taxonomy tables
- Physics verification helpers or service modules
- Subject selector and Physics practice routes
- Reviewer/tutor workflow for Physics-credentialed review

## Data / Security / Integration Impact

- Additive subject rows, exam-pack rows, and taxonomy rows are required.
- Physics may require new reusable parsing or verification rules for symbols,
  units, vectors, and other math-heavy notation.
- No change to student auth, secret handling, or privacy boundaries.

## Acceptance Criteria

- [ ] Physics prompt composition is subject-driven and AP Biology output is
      unchanged.
- [ ] `app.subjects` contains an `ap-physics` row with versioned exam-pack and
      taxonomy records.
- [ ] The initial Physics verification profile is implemented and tested
      against at least one pilot criterion type.
- [ ] A governed Physics pilot batch passes originality/rights/teaching
      validation.
- [ ] Physics calibration against a gold set is documented.
- [ ] Physics is selectable end-to-end in a non-production environment.

## QA Plan

- Manual QA: confirm AP Biology regression safety after prompt/generalization
  changes.
- Automated tests: verify Physics calculation/profile logic against known
  correct and incorrect examples.
- Regression areas: AP Biology, AP Statistics, prompt-build manifest
  resolution, and subject-selection gating.
- Failure cases: unit mismatches, algebra mistakes, vector sign errors,
  missing dimensions, and partial work.

## Approval State

**Approval Required:** Yes
**Approval Type:** Hard Gate
**Decision:** Phase 0 Approved (`APPROVAL-0027`, 2026-07-07). Content-sourcing
model approved (`APPROVAL-0029`, 2026-07-07 — reuses the AP Statistics model
from `APPROVAL-0024`/`DECISION-0031`). Phase 2 (schema/migration) and
production launch remain separate Hard Gates not yet granted.

## Implementation Notes — Delegation Plan

| Phase | Work | Delegate | Depends on | Status |
|---|---|---|---|---|
| 0 | Decision gate — confirm Physics launch scope, owner review path, and any subject-specific constraints | **David** | — | **Done** (`APPROVAL-0027`) |
| 1 | Generalize grading/prompt composition away from AP Biology literals | **Codex** (backend) | Phase 0 approval | **Ready to start** |
| 2 | Add `app.subjects`, exam-pack, and Physics taxonomy rows | **Codex** (backend) | Phase 1 | **Pending** |
| 3 | Build Physics verification profile for the first criterion type | **Codex** (backend) | Phase 1 | **Pending** |
| 4 | Author and validate a governed Physics pilot batch (tutor-authored-base-package model, `APPROVAL-0029`) | **Orly** (curriculum) or delegated reviewer, with David approval | Phases 2–3 | **Pending** |
| 5 | Expose Physics in subject selection and learning routes | **Lovable** (frontend) | Phases 2–4 | **Pending** |
| 6 | Run Physics calibration against a gold set | **QA / Learning Quality** | Phases 3–4 | **Pending** |
| 7 | Launch readiness review | **David** | All above | **Pending** |

## Done Decision

**Decision:** Pending
**Date:** Pending
