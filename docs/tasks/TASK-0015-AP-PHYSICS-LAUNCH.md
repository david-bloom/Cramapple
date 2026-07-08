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

Launch AP Physics 1 as the initial Cramapple Physics subject by extending the existing
multi-subject architecture, governed content workflow, and subject-aware UX
that already support AP Biology and AP Statistics.

Launch Physics as four separately sold SKUs with one shared physics engine:
AP Physics 1, AP Physics 2, AP Physics C: Mechanics, and AP Physics C:
Electricity and Magnetism. Roll out each SKU when ready, individually or in
readiness waves when overlap is high enough to justify grouping.

Physics is likely to require reusable platform capabilities beyond Biology,
including symbolic math, vector reasoning, dimensional analysis, unit handling,
and possibly diagram/graph support. The launch should keep the platform generic
enough to support later physics variants while avoiding premature abstraction
that Biology has not proven necessary.

## Technical Scope

1. **Grading/prompt generalization.** Remove any AP Biology-only literals from
   Physics-facing prompt composition and verification paths so Physics is
   driven by subject metadata, not subject-specific strings.
2. **Schema/content instantiation.** Add an `AP Physics 1` row to
   `app.subjects`; create a versioned `exam_pack`; create the Physics
   taxonomy scaffold in `app.content_labels` plus the subject-side taxonomy
   brief used by the authoring flow.
3. **Subject-specific verification.** Define the Physics verification profile
   needed for the first pilot batch, likely including symbolic math, unit
   consistency, vector reasoning, and calculation checks.
4. **Content authoring.** Produce a governed pilot batch of Physics content
   under the existing rights, originality, and review rules.
5. **Frontend/UX.** Expose Physics in subject selection and routes only after
   the backend/content path exists.
6. **Calibration.** Run a Physics gold-set calibration and record agreement,
   boundary, and failure-mode evidence before launch readiness review.

7. **Launch sequencing.** Treat AP Physics 1 and AP Physics 2 as
   diagram-heavy algebra-based SKUs, and the two AP Physics C courses as the
   calculus-based pair whose derivations and notation share a single rubric
   path.

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
- [ ] `app.subjects` contains an `ap-physics-1` row with versioned exam-pack
      and taxonomy scaffold records.
- [ ] The initial Physics verification profile is implemented and tested
      against at least one pilot criterion type.
- [ ] A governed Physics pilot batch passes originality/rights/teaching
      validation.
- [ ] Physics calibration against a gold set is documented.
- [ ] Physics is selectable end-to-end in a non-production environment.
- [ ] The four-SKU launch plan is recorded and the SKU rollout order is
      approved.
- [ ] Lovable has a frontend assignment for the four-SKU experience.
- [ ] Claude has a planning/calibration assignment for the four-SKU launch.

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
from `APPROVAL-0024`/`DECISION-0031`). Phase 2 migration approved
(`APPROVAL-0031`, 2026-07-07). Production launch remains a separate Hard
Gate not yet granted.

## Implementation Notes — Delegation Plan

| Phase | Work | Delegate | Depends on | Status |
|---|---|---|---|---|
| 0 | Decision gate — confirm Physics launch scope, owner review path, and any subject-specific constraints | **David** | — | **Done** (`APPROVAL-0027`) |
| 1 | Generalize grading/prompt composition away from AP Biology literals | **Codex** (backend) | Phase 0 approval | **Ready to start** |
| 2 | Add `app.subjects`, exam-pack, and Physics taxonomy rows | **Codex** (backend) | Phase 1 | **Migration drafted and approved** (`APPROVAL-0031`; `supabase/migrations/202607070005_chemistry_physics_schema_instantiation.sql`, not yet applied) |
| 3 | Build Physics verification profile for the first criterion type | **Codex** (backend) | Phase 1 | **Pending** |
| 4 | Author and validate a governed Physics pilot batch (tutor-authored-base-package model, `APPROVAL-0029`) | **Orly** (curriculum) or delegated reviewer, with David approval | Phases 2–3 | **Pending** |
| 5 | Expose Physics in subject selection and learning routes | **Lovable** (frontend) | Phases 2–4 | **Pending** |
| 6 | Run Physics calibration against a gold set | **QA / Learning Quality** | Phases 3–4 | **Pending** |
| 7 | Launch readiness review | **David** | All above | **Pending** |
| 8 | Four-SKU launch plan, rollout sequencing, and assignments | **Main Conductor + Lovable + Claude** | Phase 0+ | **In progress** |
| 9 | Physics question/answer authoring packet for all four SKUs | **Claude** (content) | Plan + brief | **In progress** |
| 10 | Deferred backend/curriculum follow-ups from Lovable (component ship, signup prefill, waitlist capture) | **Main Conductor** | Any SKU live | **Deferred** |

## Done Decision

**Decision:** Pending
**Date:** Pending
