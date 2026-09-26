# Launch Plan — Content Pipeline (Question Templates) — 2026-09-26

**Status:** Draft | **Owner:** David Bloom | **Tier:** Standard
**Part of:** `APP_LAUNCH_READINESS_INDEX_2026_09_26.md`

## Product Goal

The system that turns raw exam content into servable, validated questions works end to end without
manual per-item authoring at scale. This plan covers two related but distinct systems plus the
quantity target they feed, and its output directly unblocks
`LAUNCH_PLAN_SUBJECT_ONBOARDING_GATE_2026_09_26.md`.

## The three pieces

1. **Content Authoring and Revision Workbench** (internal tool for authors/reviewers) —
   `docs/product/CONTENT_AUTHORING_AND_REVISION_WORKBENCH_DESIGN.md` (17-section UX spec), task
   `docs/tasks/UX-003-CONTENT-AUTHORING-REVISION-WORKBENCH.md` (In Progress, needs multiple domain
   reviews before Done).
2. **Student-Provided Question Intake (BYOQ)** — `docs/product/STUDENT_PROVIDED_QUESTION_INTAKE_DESIGN.md`
   (14-section UX spec), task UX-004 (In Progress, needs Learning Quality/accessibility/security/
   privacy/rights/academic-integrity/Product Owner review). Note: the design doc has a duplicate "6.4"
   section numbering — flag to whoever owns the doc rather than silently resolving it.
3. **Content quantity and coverage targets** —
   `docs/product/CONTENT_QUANTITY_AND_DISTRIBUTION.md` (inventory unit, approved planning targets,
   unit distribution, official topic coverage matrix, launch/reporting rule).

## The actual blocker: the two-model-agreement pipeline

`SUBJECT_SERVABILITY_CRITERIA.md` criteria 3 (validated serving labels) and 5 (difficulty values) are
open for every subject except AP Biology — not because of a per-subject content gap, but because the
pipeline meant to produce them (two independent model passes + agreement/CRR, per
`docs/product/SUBJECT_READINESS_COMPLETION_PLAN_2026_09_25.md` Tier 3) doesn't run end to end yet.
Hand-authoring at the current pace isn't viable: roughly 900 non-validated labels and 900 missing
difficulty rows across the 9 non-Biology subjects. **This plan's core deliverable is getting that
pipeline running, not authoring individual labels/difficulty values by hand.**

## Acceptance Criteria

- [ ] The two-model-agreement pipeline for serving labels runs against at least one full subject
      end-to-end and produces `label_status='validated'` rows that pass a spot-check against
      `select_unit_gated_practice_items`'s actual requirement (not an assumption about what the
      function needs — verify by calling it, per `SUBJECT_SERVABILITY_CRITERIA.md`'s own method note).
- [ ] The same pipeline (or a parallel one) produces `app.content_item_difficulty` rows with a
      populated `difficulty` band and `basis` for that subject, honoring DECISION-0061 (null
      `attainment_ratio` acceptable with an honest basis; a fabricated ratio is not).
- [ ] Any model-call-based step in the pipeline is run 3+ times per item before a result is trusted —
      the repo's own findings show identical inputs producing different grader/label verdicts across
      runs on the same deployment.
- [ ] The Content Authoring Workbench (UX-003) and BYOQ intake (UX-004) task specs have their listed
      pending domain reviews resolved or explicitly still-open-and-tracked — do not let this plan
      silently assume they're farther along than MASTER_TODO records.
- [ ] `CONTENT_QUANTITY_AND_DISTRIBUTION.md`'s approved planning targets are checked against actual
      current bank size per subject, and any subject short of target is flagged (not silently launched
      under-target).
- [ ] Once the pipeline runs for a subject, that subject's entry in
      `SUBJECT_SERVABILITY_CRITERIA.md`'s "Applied so far" table is updated with real numbers, cited
      to the migration or run that produced them — this is what unblocks
      `LAUNCH_PLAN_SUBJECT_ONBOARDING_GATE_2026_09_26.md` for that subject.

## Out of Scope

Per-item hand-authoring of labels/difficulty at scale (not viable per the completion plan's own Tier 3
assessment) — if the pipeline genuinely can't be built in time, that's a finding to bring back to
David, not a mandate to hand-author 1,800 rows.

## Method Note

Don't conflate "reviewed/approved" (criterion 1, a human content-review gate) with "servable"
(criteria 3, 5, 6 combined) — this exact conflation is what produced AP Biology's same-day correction
in its own launch-readiness doc. Verify pipeline output against live serving RPCs, not against the
reviewer tool's published-item count.
