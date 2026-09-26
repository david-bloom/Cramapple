# TASK-0042 — Post-Launch: Content Pipeline (Question Templates)

**Task ID:** TASK-0042
**Title:** Content Pipeline — Run the Proven Labels/Difficulty Lane to Completion, Per Subject
**Owner:** AI agent (implementation) — unassigned; candidate: Codex or Claude
**Product Owner:** David Bloom
**Tier:** Hard-Gate
**Status:** Not Started
**Priority:** Medium — **removed from the October 2, 2026 launch-critical path**
**Created Date:** 2026-09-26
**Approved Date:** Pending
**Branch:** Not yet created — see "Required slicing" below before any branch is assigned
**PR:** None yet

## Codex QA note (2026-09-26, pre-execution review)

Codex reviewed this task record before any work started and returned **Fail — revision required**.
Findings folded into this revision: **removed from the October 2 critical path** — per
`docs/product/LAUNCH_RUNBOOK_2026_10_02.md`'s "Explicitly post-launch" list, "unit-gated practice and
the remaining labels/difficulty pipeline for Biology and Statistics" is post-launch, and neither Day-1
subject's flat-path launch depends on this task; tier raised from Standard to **Hard-Gate** because
this task performs live Production writes (label/difficulty promotion) and Standing Approval is
insufficient for that — every promotion batch needs explicit, recorded approval; **must be split into
independently reviewable per-subject slices before assignment** — see "Required slicing" below. This is
still a pre-execution draft — no implementation agent has been assigned.

## Product Goal

The system that turns raw exam content into servable, validated questions works end to end without
manual per-item authoring at scale. Its output eventually unblocks unit-gated practice for all
subjects — but that is post-launch work, not part of the October 2 free-launch critical path (both
Day-1 subjects launch on their flat/practice paths, which do not require this task's output).

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

## Required slicing (Codex finding — do not assign this task as one program-sized unit)

This task record is the **umbrella reference**, not an assignable unit of work. Before any agent
starts, split it into one slice per subject, each independently reviewable and separately approved
(branch-hygiene R1: "a branch is one independently reviewable task or slice"):

- TASK-0042-CALC-AB, TASK-0042-CALC-BC, TASK-0042-CHEMISTRY, TASK-0042-PHYSICS-1, TASK-0042-PHYSICS-2,
  TASK-0042-PHYSICS-C-MECH, TASK-0042-PHYSICS-C-EM, TASK-0042-PRECALCULUS, TASK-0042-STATISTICS
  (Biology already sits at 141 servable items product-wide per FF-3 — confirm live whether it needs a
  slice at all before creating one).
- Each slice gets its own branch, its own PR, and its own explicit approval for its Production
  label/difficulty writes — do not batch multiple subjects' promotions under one approval.
- Do not create these sub-task files speculatively; create each one only when an agent is actually
  about to start that subject's slice, naming the specific work order it continues.

## Out of Scope

UX-003 and UX-004 (see correction above) — track separately, not on this task's critical path unless
David says otherwise. The October 2 launch itself — this task is explicitly post-launch.

## Routes / Components / Systems Affected

- `scripts/taxonomy/extend_serving_labels_mcp.mjs`, `extend_math_serving_labels.mjs`
- `select_unit_gated_practice_items` (serving RPC — verify by calling it, not by reading the rule)
- `app.content_item_difficulty` — **live Production writes**, not a read-only audit
- `docs/product/SUBJECT_SERVABILITY_CRITERIA.md` — **this task owns criteria 3/5 updates to the
  "Applied so far" table; TASK-0046 (post-launch full six-criteria gate) owns criteria 1/2/4/6. Check
  the other task's latest edit before overwriting a row.**

## Data / Security / Integration Impact

Each per-subject slice writes label/difficulty data directly to Production via the existing
two-model-agreement pipeline. **This is a live Production data write and requires explicit, recorded
approval per batch — Standing Approval does not cover it**, even though the underlying mechanism is
already approved and repeatedly exercised.

## Acceptance Criteria

(Full detail and rationale in `LAUNCH_PLAN_CONTENT_PIPELINE_2026_09_26.md` — this list mirrors it; that
doc governs if they drift. Apply per subject slice.)

- [ ] For the subject in this slice, issue or continue a Codex work order following the established
      pattern, and independently re-verify its output.
- [ ] Every promoted label passes a spot-check against `select_unit_gated_practice_items`'s actual
      requirement (call it, don't assume) and honors `DECISION-0066`'s content-hash freshness rule.
- [ ] Difficulty rows produced per `DECISION-0061`/`DECISION-0065` (null `attainment_ratio` acceptable
      with an honest `basis`; a fabricated ratio is not).
- [ ] Grader-gate reachability checks run 3+ times before being trusted (this rule is about reachability,
      not the label-agreement step, which already has its own design).
- [ ] `CONTENT_QUANTITY_AND_DISTRIBUTION.md`'s targets checked against actual bank size — flag to David
      whether equivalent per-subject targets are needed beyond AP Biology before treating this as
      checkable product-wide.
- [ ] This subject's row in `SUBJECT_SERVABILITY_CRITERIA.md`'s "Applied so far" table is updated with
      real numbers, cited to the migration/run that produced them.
- [ ] Explicit, recorded approval obtained for this subject's Production label/difficulty write before
      it lands — cite the approval record, not an assumption that the mechanism's prior approval
      carries forward automatically.

## QA Plan

- Manual QA: call `select_unit_gated_practice_items` live for this subject after each promotion batch.
- Automated tests: none beyond the existing label-promotion scripts' own checks.
- Regression areas: content-hash freshness (stale labels on Physics C/Calc BC flagged previously).
- Failure cases: a promoted label that doesn't actually satisfy the serving RPC's requirement; a
  fabricated (non-null, non-honest) `attainment_ratio`; a batch that ships without its own explicit
  approval record.
- Security/data/integration checks: none beyond standard content-migration review.
- **QA independence:** QA on each slice must run in a fresh context, separate from the implementer.

## Approval State

**Approval Required:** Yes
**Approval Type:** Hard Gate — explicit, recorded approval per subject slice's Production write. Not
Standing Approval, despite the underlying mechanism being repeatedly exercised.
**Decision:** Pending — Codex reviewed this task record 2026-09-26 (Fail, revision required); this
revision folds in that feedback, including removal from the October 2 critical path and the slicing
requirement. Still awaiting Codex's re-review before being finalized; no slice has been assigned.

## Implementation Notes

**Implementation Summary:** _(Per-slice — to be filled by each slice's implementation agent.)_

**Test Results:** _(Per-slice — live RPC verification results.)_

**Risks / Issues:** _(Per-slice — e.g. stale content-hash findings, targets gap for non-Biology
subjects.)_

## QA Review

**QA Verdict:** Pending (Pass / Fail) — per slice, from a fresh, independent QA context.

**QA Result:** _(Per-slice — to be filled by the QA agent.)_

## Done Decision

**Decision:** Pending
**Date:** YYYY-MM-DD

This umbrella task is Done only once every subject slice it spawned is Done or explicitly descoped.
Only the Main Conductor may set a slice's status to `Done`.
