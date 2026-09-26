# TASK-0042 — Launch: Content Pipeline (Question Templates)

**Task ID:** TASK-0042
**Title:** Content Pipeline — Run the Proven Labels/Difficulty Lane to Completion Per Subject
**Owner:** AI agent (implementation) — unassigned; candidate: Codex or Claude
**Product Owner:** David Bloom
**Tier:** Standard
**Status:** Not Started
**Priority:** High — blocks TASK-0044 (Subject Onboarding Gate) criteria 3 and 5
**Created Date:** 2026-09-26
**Approved Date:** Pending
**Branch:** Not yet created — assign per R1 (`<agent>/task-0042-<slug>`) when an agent starts execution
**PR:** None yet

## Product Goal

The system that turns raw exam content into servable, validated questions works end to end without
manual per-item authoring at scale, directly unblocking TASK-0044.

## Technical Scope

Primary source: `docs/product/LAUNCH_PLAN_CONTENT_PIPELINE_2026_09_26.md` — read in full, including the
CORRECTION block, before starting.

**The pipeline already exists and has already produced a real result** — do not build new
infrastructure. FF-3 promoted 229 two-model-agreed labels across 9 subjects (closed 2026-09-24 under
`DECISION-0066`), moving unit-gated servable items from 8 to 141 product-wide. The remaining work is
running the same Codex-work-order pattern (see
`prompts/CODEX_WORK_ORDER_AP_CHEMISTRY_LABELS_AND_DIFFICULTY_2026_09_25.md` for the pattern) for
subjects/items not yet covered, via `scripts/taxonomy/extend_serving_labels_mcp.mjs` /
`extend_math_serving_labels.mjs`.

Per-subject current validated-label counts (per
`docs/content/CODEX_QA_REPORT_READINESS_AUDIT_WORK_ORDERS_AND_SELECTORS_2026_09_25.md`, more current
than `SUBJECT_SERVABILITY_CRITERIA.md`'s own table): Calc AB 9, Calc BC 4, Chemistry 45, Physics 1 9,
Physics 2 10, Physics C Mechanics 4, Physics C E&M 6, Precalculus 30, Statistics 64.

UX-003 (Content Authoring Workbench) is out of this task's critical path — gated on human domain
reviews. UX-004 (BYOQ intake) is owned by TASK-0040 (Marketing Home Page), not this task — listed in
the plan for reference only.

## Out of Scope

UX-003 and UX-004 (see correction in the source plan) — track separately, not on this task's critical
path unless David says otherwise.

## Routes / Components / Systems Affected

- `scripts/taxonomy/extend_serving_labels_mcp.mjs`, `extend_math_serving_labels.mjs`
- `select_unit_gated_practice_items` (serving RPC — verify by calling it, not by reading the rule)
- `app.content_item_difficulty`
- `docs/product/SUBJECT_SERVABILITY_CRITERIA.md` — **this task owns criteria 3/5 updates to the
  "Applied so far" table; TASK-0044 owns criteria 1/2/4/6. Check the other task's latest edit before
  overwriting a row.**

## Data / Security / Integration Impact

None beyond standard content/schema promotion via the existing two-model-agreement pipeline. No live
migrations beyond what the existing label-promotion pattern already does.

## Acceptance Criteria

(Full detail and rationale in `LAUNCH_PLAN_CONTENT_PIPELINE_2026_09_26.md` — this list mirrors it; that
doc governs if they drift.)

- [ ] For each subject not yet fully covered, issue or continue a Codex work order following the
      established pattern, and independently re-verify its output.
- [ ] Every promoted label passes a spot-check against `select_unit_gated_practice_items`'s actual
      requirement (call it, don't assume) and honors `DECISION-0066`'s content-hash freshness rule.
- [ ] Difficulty rows produced per `DECISION-0061`/`DECISION-0065` (null `attainment_ratio` acceptable
      with an honest `basis`; a fabricated ratio is not).
- [ ] Grader-gate reachability checks run 3+ times before being trusted (this rule is about reachability,
      not the label-agreement step, which already has its own design).
- [ ] `CONTENT_QUANTITY_AND_DISTRIBUTION.md`'s targets checked against actual bank size — flag to David
      whether equivalent per-subject targets are needed beyond AP Biology before treating this as
      checkable product-wide.
- [ ] Once a subject's labels/difficulty are updated, its row in `SUBJECT_SERVABILITY_CRITERIA.md`'s
      "Applied so far" table is updated with real numbers, cited to the migration/run that produced
      them.

## QA Plan

- Manual QA: call `select_unit_gated_practice_items` live per subject after each promotion batch.
- Automated tests: none beyond the existing label-promotion scripts' own checks.
- Regression areas: content-hash freshness (stale labels on Physics C/Calc BC flagged previously).
- Failure cases: a promoted label that doesn't actually satisfy the serving RPC's requirement; a
  fabricated (non-null, non-honest) `attainment_ratio`.
- Security/data/integration checks: none beyond standard content-migration review.

## Approval State

**Approval Required:** Yes
**Approval Type:** Standing Approval for running the proven pipeline per subject (already-approved
mechanism); Hard Gate only if a subject's approach deviates from the established pattern.
**Decision:** Pending — this task record itself is a draft awaiting Codex's review before being
finalized; execution has not started.

## Implementation Notes

_(To be filled by the implementation agent.)_

## QA Review

**QA Verdict:** Pending (Pass / Fail)

## Done Decision

**Decision:** Pending
**Date:** YYYY-MM-DD
