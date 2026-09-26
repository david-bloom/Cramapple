# Launch Plan — Content Pipeline (Question Templates) — 2026-09-26

**Status:** Draft | **Owner:** David Bloom | **Tier:** Standard
**Part of:** `APP_LAUNCH_READINESS_INDEX_2026_09_26.md`

## Product Goal

The system that turns raw exam content into servable, validated questions works end to end without
manual per-item authoring at scale. This plan covers two related but distinct systems plus the
quantity target they feed, and its output directly unblocks
`LAUNCH_PLAN_SUBJECT_ONBOARDING_GATE_2026_09_26.md`.

## CORRECTION, 2026-09-26 (same day, after a second AI review)

**This plan originally described the labels/difficulty pipeline as something to build.** It already
exists and has been run manually, per subject, via `scripts/taxonomy/extend_serving_labels_mcp.mjs` /
`extend_math_serving_labels.mjs`, DECISION-0066's two-model-agreement promotion rule, and per-subject
Codex work orders (e.g. `prompts/CODEX_WORK_ORDER_AP_CHEMISTRY_LABELS_AND_DIFFICULTY_2026_09_25.md`).
It has already produced a real result: FF-3 (`AP_BIOLOGY_FAST_FOLLOW.md`, closed 2026-09-24 under
DECISION-0066) promoted 229 two-model-agreed labels across 9 subjects, moving unit-gated servable
items from 8 to 141 product-wide. **This plan's actual remaining work is running the same
already-proven lane for the subjects/items not yet covered — not building new infrastructure.**
Difficulty has a related but separate method (DECISION-0061/0065).

**UX-003 (Content Authoring Workbench) and UX-004 (BYOQ intake) are demoted out of this plan's
critical path.** Both are gated on human domain reviews (Learning Quality, accessibility, security,
privacy, rights, academic-integrity, Product Owner) that no AI agent can close, and neither is what's
actually blocking subjects from passing the servability gate. They remain listed below for reference,
but treat them as a separate content-ops-tooling track, not launch-critical, unless David says
otherwise.

## The three pieces (UX-003/UX-004 below are reference only — see correction above)

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

## The actual remaining work: run the proven pipeline for the rest

`SUBJECT_SERVABILITY_CRITERIA.md` criteria 3 (validated serving labels) and 5 (difficulty values) are
still open for most subjects — not because the pipeline doesn't exist (it does, and has already
promoted 229 labels for a 9-subject set per FF-3), but because it hasn't been run to completion for
every subject/item yet. Consult `docs/content/CODEX_QA_REPORT_READINESS_AUDIT_WORK_ORDERS_AND_SELECTORS_2026_09_25.md`
for the current per-subject validated-label counts (e.g. Calc AB 9, Calc BC 4, Chemistry 45, Physics 1
9, Physics 2 10, Physics C Mechanics 4, Physics C E&M 6, Precalculus 30, Statistics 64) before assuming
zero progress — this is more current than `SUBJECT_SERVABILITY_CRITERIA.md`'s own "Applied so far"
table. Hand-authoring the remainder isn't viable at the current pace; the path is running the same
Codex-work-order pattern per subject, not inventing a new mechanism.

## Acceptance Criteria

- [ ] For each subject not yet fully covered, issue or continue a Codex work order following the
      pattern in the examples above, and independently re-verify its output (per this repo's own
      practice of an independent re-check after every Codex-proposed batch).
- [ ] Every promoted label passes a spot-check against `select_unit_gated_practice_items`'s actual
      requirement (verify by calling it — do not assume from reading the promotion rule) and honors
      DECISION-0066's content-hash freshness rule (a label promoted against stale content is not
      valid — this is why some Physics C/Calc BC candidates were flagged stale).
- [ ] Difficulty rows are produced per DECISION-0061/0065 (null `attainment_ratio` acceptable with an
      honest `basis`; a fabricated ratio is not).
- [ ] Any model-call-based *grader-gate reachability* check specifically is run 3+ times before being
      trusted (this 3+ rule is about grader reachability, not the label-agreement step itself, which
      already has its own two-model-agreement design per DECISION-0066 — don't triple the label-run
      cost by conflating the two).
- [ ] `CONTENT_QUANTITY_AND_DISTRIBUTION.md`'s approved planning targets are checked against actual
      current bank size — note this doc's targets are currently AP-Biology-specific; flag to David
      whether equivalent targets are needed for the other 9 subjects before treating this criterion as
      checkable for them.
- [ ] Once a subject's labels/difficulty are updated, its entry in `SUBJECT_SERVABILITY_CRITERIA.md`'s
      "Applied so far" table is updated with real numbers, cited to the migration or run that produced
      them. **This table is shared with `LAUNCH_PLAN_SUBJECT_ONBOARDING_GATE_2026_09_26.md` — this plan
      owns writing criteria 3/5 updates to it; plan 5 owns criteria 1/2/4/6. Do not both edit the same
      row concurrently without checking the other plan's latest edit first.**

## Out of Scope

UX-003 and UX-004 (see correction above) — track separately, not on this plan's critical path unless
David says otherwise.

## Method Note

Don't conflate "reviewed/approved" (criterion 1, a human content-review gate) with "servable"
(criteria 3, 5, 6 combined) — this exact conflation is what produced AP Biology's same-day correction
in its own launch-readiness doc. Verify pipeline output against live serving RPCs, not against the
reviewer tool's published-item count.
