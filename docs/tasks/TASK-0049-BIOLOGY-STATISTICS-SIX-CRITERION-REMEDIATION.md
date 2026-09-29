# TASK-0049 — Close Six-Criterion Gaps for AP Biology and AP Statistics

**Task ID:** TASK-0049  
**Title:** Biology + Statistics — Close Remaining Six-Criterion Servability Gaps  
**Owner:** Unassigned implementation agent  
**Product Owner:** David Bloom  
**Tier:** Hard-Gate  
**Status:** In Progress — Phase 1 promotion batches applied to Production 2026-09-28 (100 items across
two migrations, David-approved per-batch); Phase 2 scoped in
`prompts/CODEX_TASK0049_PHASE2_LABEL_REMEDIATION_2026_09_28.md`, not yet executed. See the "Current Live
Baseline" superseded-note above — not independently re-verified in this document.  
**Priority:** Medium — post-launch/unit-gated readiness follow-up  
**Created Date:** 2026-09-28  
**Approved Date:** Pending for remaining batches; first two batches approved in-session 2026-09-28  
**Branch:** See individual migration/prompt files for the branches that executed Phase 1  
**PR:** None recorded in this document yet

## Origin

Created at session close on 2026-09-28 after TASK-0046 live verification showed that AP Biology and AP Statistics are both currently servable on their active unit-gated paths, but substantial portions of their current-published banks still do not satisfy all six servability criteria item-by-item.

This task is remediation, not verification. TASK-0046 remains the verification/gate task.

**Naming note:** `docs/tasks/TASK-0049-CLAUDE-INDEPENDENT-AUDIT-2026-09-28.md` is a session log, not a
second task doc — an earlier same-day session initially misfiled its work under this task's own ID
before catching the mistake. It is kept under that name (not renamed) because later Production
migrations and an active Codex prompt already cite it by filename. This document remains the sole
source of truth for TASK-0049's scope and status.

Two further workstreams also carried this ID by mistake and were corrected by renumbering, since
neither had durable citations to preserve: the `app.attempt_criterion_results` writer, now
`docs/tasks/SESSION-NOTE-ATTEMPT-CRITERION-RESULTS-WRITER.md` (main, commit `734cf286`), and the Open
Hand answer-key serving contract, now `docs/tasks/TASK-0051-OPEN-HAND-UNIFIED-ANSWER-KEY.md`
(renumbered 0049 → 0050 → 0051; it briefly held TASK-0050, which now belongs to the skill-dimension
rollout — see `DECISION-0086`). Neither is part of this task's scope.

## Product Goal

Bring the intended current-published AP Biology and AP Statistics inventory to an explicit six-criterion-ready state for unit-gated practice, with every remaining gap either:

1. closed with durable Production evidence; or
2. explicitly excluded/retired with a documented rationale so it is not silently counted as six-criterion-ready.

Do not manufacture completeness by narrowing the eligible population without recording the exclusion.

## Current Live Baseline — 2026-09-28

> **Superseded same day, not yet re-verified in this doc:** the counts below predate two Production
> migrations applied later on 2026-09-28
> (`20260928130000_task0049_promote_claude_confirmed_single_unit.sql`,
> `20260928131500_task0049_promote_multi_unit_reconciled.sql`). Per
> `prompts/CODEX_TASK0049_PHASE2_LABEL_REMEDIATION_2026_09_28.md`, the post-migration counts are Biology
> 43/118 (was 23) and Statistics 143/170 (was 67) — re-confirm against live Production before treating
> either number as current; not independently re-verified here.

Production project: `pcntajvbdfqhbeewmdry`.

### AP Biology

Active exam-pack version: `2d88ba5e-a6a3-43b8-bfae-9e5505a178a7`

- 118 current-published items.
- 23/118 have a current-fresh validated serving label.
- Difficulty: 118/118 complete.
- FRQ rubric coverage: no current-published rubric defects found.
- MCQ correctness: no current-published choice defects found.
- 4 current-published FRQs have no `canonical_answer_1`.
- All 4 missing-canonical FRQs are hand-drawn graph items:
  - `APBIO-HDG-2026-GRAPH-002`
  - `APBIO-HDG-2026-GRAPH-003`
  - `APBIO-HDG-2026-GRAPH-008`
  - `APBIO-HDG-2026-GRAPH-010`
- Those 4 are structurally excluded from the ordinary/unit-gated selectors today.
- Current exact unit-gated eligible pool at released unit 8: 23 items.

### AP Statistics

Active exam-pack version: `548f06be-ccf4-426d-b82b-b424137a4438`

- 170 current-published items.
- 67/170 have a current-fresh validated serving label.
- Difficulty: 170/170 complete.
- FRQ canonicals: 69/69 complete.
- FRQ rubric coverage: no current-published rubric defects found.
- MCQ correctness: 101/101 have exactly one correct choice.
- Current exact unit-gated eligible pool at released unit 5: 48 items.

## Scope

### Workstream A — AP Biology

1. Re-audit the 95 current-published items without a current-fresh validated serving label.
2. Use the proven TASK-0042 taxonomy/label pipeline; do not invent a new labeling mechanism.
3. For every candidate promotion, preserve the current-version/current-hash freshness rule.
4. Multi-unit labels require the independent review path already established under `DECISION-0066`; do not auto-promote them from two-model agreement alone.
5. Resolve the four hand-drawn FRQs with missing canonicals:
   - if they are intended to become unit-gated/servable, author and independently verify canonical-answer evidence appropriate to their grading model; or
   - if they are intentionally outside automated/unit-gated serving, record an explicit exclusion/retirement policy and ensure readiness reporting does not treat them as silent failures.
6. Re-run the real Production serving RPCs and census/self-test after each approved batch.

### Workstream B — AP Statistics

1. Re-audit the 103 current-published items without a current-fresh validated serving label.
2. Use the existing TASK-0042 pipeline and freshness rules.
3. Apply independent review for multi-unit candidates as required by `DECISION-0066`.
4. Re-run the real Production serving RPCs and census/self-test after each approved batch.
5. Confirm that the existing combined Statistics MCQ serving path remains intact after any label changes.

## Out of Scope

- Changing the October 2 flat-path launch decision.
- Changing the six servability criteria themselves.
- Rebuilding the taxonomy pipeline.
- Turning on unit-gated UI behavior automatically.
- Any Production mutation without explicit, recorded approval for the specific batch.
- Treating hand-drawn exclusions as resolved unless the exclusion is explicitly documented and reflected in readiness reporting.

## Systems / Files Affected

- Production Supabase project `pcntajvbdfqhbeewmdry`.
- `app.content_taxonomy_labels`.
- `app.content_item_versions` if Biology hand-drawn canonical remediation is approved.
- Existing taxonomy promotion scripts/migrations from TASK-0042.
- `public.select_unit_gated_practice_items`.
- `app.servable_items_census()` / `app.servable_items_census_selftest()`.
- `docs/product/SUBJECT_SERVABILITY_CRITERIA.md`.
- `docs/product/APP_LAUNCH_READINESS_INDEX_2026_09_26.md`.

## Approval / Safety Boundary

This task is **Hard-Gate** because closing the gaps requires live Production writes.

Before any Production mutation:
- obtain explicit Product Owner approval for the specific subject/batch;
- create subject-scoped, independently reviewable branches;
- preserve exact before/after counts and migration provenance;
- require fresh independent QA separate from the implementer.

Read-only audit and planning may proceed under Standing Approval.

## Required Slicing

Do not execute as one combined implementation branch.

- TASK-0049-BIOLOGY
- TASK-0049-STATISTICS

Each subject slice must have its own branch, PR, Production-write approval, implementation evidence, and fresh independent QA.

## Acceptance Criteria

Per subject:

- [ ] Active pack singularity re-confirmed immediately before writes.
- [ ] Current-published population re-counted immediately before execution.
- [ ] Every intended in-scope item has a current-fresh validated serving label, or an explicit documented exclusion.
- [ ] Difficulty remains complete with populated band + basis.
- [ ] FRQs intended for serving have valid rubrics and canonical-answer coverage appropriate to their serving/grading mode.
- [ ] MCQs intended for serving have exactly one correct choice.
- [ ] Real `select_unit_gated_practice_items` calls run after remediation and counts are recorded.
- [ ] `app.servable_items_census_selftest()` reports zero mismatches.
- [ ] No stale-hash label is treated as valid.
- [ ] No multi-unit label is promoted without the independent review required by `DECISION-0066`.
- [ ] `SUBJECT_SERVABILITY_CRITERIA.md` updated with final dated evidence.
- [ ] Launch/readiness index updated with final status.
- [ ] Fresh independent QA returns Pass.
- [ ] Main Conductor records the Done decision.

## QA Plan

- Fresh-context independent review per subject.
- Verify exact migration row counts against pre-write snapshots.
- Spot-check promoted labels against content and unit scope.
- Call live selectors, not modeled SQL alone.
- Re-run census self-test and require zero mismatches.
- For Biology hand-drawn items, explicitly verify that the chosen resolution matches the approved grading/serving policy.

## Approval State

**Approval Required:** Yes  
**Approval Type:** Hard Gate — explicit Product Owner approval per Production-write batch.  
**Decision:** Pending.

## Done Decision

**Decision:** Pending  
**Date:** YYYY-MM-DD
