# TASK-0051 — Skill Dimension Rollout (All 10 Subjects)

**Task ID:** TASK-0051
**Title:** Bring all 10 AP subjects to schema parity on the skill dimension (`app.taxonomy_cells` +
skill-labeled `app.content_item_cells`)
**Owner:** AI implementation agent — unassigned (run one subject per fresh context window, per the
plan's §8)
**Product Owner:** David Bloom
**Tier:** Hard-Gate (Production writes only — Dev work and documentation are not gated)
**Status:** Planned. Plan and feasibility measurement merged to `main`; no subject's Phase A/B has
started.
**Priority:** Post-launch. Not on the October 2, 2026 free-launch critical path — mastery derivation
(`DECISION-0074`) is not live (Hard Gate, see `PLATE_LOOP_BUILD_PLAN_2026_09_27.md`), so this task
cannot block or unblock anything shipping on launch day.
**Created Date:** 2026-09-29
**Approved Date:** 2026-09-29 — David: "create a plan for adding the skill dimension to each
subject. I authorize the vercel gateway cost. Use the CEDs." (Gateway spend authorized; each
subject's actual grid/label content, and every Production write, still needs a separate go-ahead
per §8.6 of the plan.)
**Branch:** `claude/skill-dimension-rollout-2026-09-29` (plan + feasibility doc, merged)
**PR:** [#258](https://github.com/david-bloom/Cramapple/pull/258) — merged 2026-09-29 (`148b05b`).
(Supersedes [#257](https://github.com/david-bloom/Cramapple/pull/257), closed without merging — same
content, corrected against live schema before merge.)

## Product goal

David, reframing GAP-10 from a 2-subject to a 10-subject problem: "I appreciate that we are talking
about a 2 subject launch, but we have ten subjects. we need them to have the same data schema."

Every subject should end this task with the same skill-dimension shape Statistics and Biology
partially have today: a `taxonomy_cells` topic×skill registry sourced from that subject's own CED,
and `skill_code`-labeled (not just `topic_code`-labeled) published MCQ and FRQ content.

## Governing documents

- `docs/product/SKILL_DIMENSION_ROLLOUT_PLAN_2026_09_29.md` — the plan: the FK ordering constraint
  (§3), which subjects need a CED sourcing pass before a grid can be built (§4), the automation
  ceiling on AI-Gateway labeling (§5), Phase A (grid) and Phase B (item labeling) methods (§6–7),
  the per-subject execution checklist (§8), and definition of done (§10).
- `docs/product/SKILL_DIMENSION_FEASIBILITY_2026_09_29.md` — the read-only, no-spend feasibility
  measurement run against Production for all 10 subjects before this task does any Phase A/B work.
  **Key finding: MCQ inventory, not the skill dimension, is the binding constraint on
  `DECISION-0074` mastery in all 10 subjects** (`floor(MCQ/2)` caps range 20–50 per subject,
  independent of grid size). This task delivers schema parity, not a mastery unlock — raising the
  mastery ceiling is a separate content-authoring decision, out of this task's scope.
- `docs/product/CONTENT_GAPS_RUNNING_LIST.md` — GAP-10, the originating diagnosis (0 masterable
  cells, every FRQ topic-only, Biology's grid empty as of 2026-09-27).
- `docs/architecture/TAXONOMY_LABELING_PLAN_V3_2026_08_04.md` — the labeling protocol and the
  measured two-model agreement ceiling (89% units / 44% topics) this task's Phase B design is bound
  by.

## What's already true (don't re-derive)

Per the plan PR's own corrections against live schema (see PR #258 description for the full list):

- `app.content_item_cells` already has `assignment_status`, `source`, `model_run_id`,
  `validated_by/at`, `validation_decision_id`, `superseded_by`, and a `content_item_cells_validation_check`
  constraint — the provisional-write/promote design in plan §5 needs no new schema work.
- `skill_code` is nullable and the composite FK is `MATCH SIMPLE` — a NULL skill satisfies it
  trivially. Verifying a labeling pass means counting non-null `skill_code`, not just absence of FK
  violations.
- `is_primary` defaults `true` under `content_item_cells_one_primary_per_version` — a naive
  skill-row insert on an item that already has a topic-only primary row will violate that unique
  index. Both legal shapes are documented in plan §7.
- AP Biology already has ~112 topic-only `content_item_cells` rows in Production (validated) — it is
  not at zero the way the first plan draft assumed.
- Statistics' 203 skill-coded rows sit entirely on a retired pilot pack (0 FRQ, 0 servable items);
  the pack it actually serves has 101 MCQ + 80 FRQ and zero skill labels. Statistics' Phase B is a
  full MCQ+FRQ pass, not "FRQ only" — see feasibility doc for detail.
- Zero `content_item_cells` rows are `provisional_model` in Production today (Biology/Statistics'
  validated rows are `authored`/`validated`, not sitting in a provisional queue).

## Scope of this task

Execute the plan's §8 per-subject checklist (Phase 0 if flagged, Phase A grid, Phase B labeling,
verify, update GAP-10) for each of the 10 subjects, in any order (no cross-subject dependency).
Suggested order is plan §9, adjusted for the corrected Statistics finding above.

**Out of scope:** authoring additional MCQs/FRQs to raise the `floor(MCQ/2)` mastery ceiling the
feasibility doc identified — that's a content-production decision for David, not an engineering or
labeling fix.

## Acceptance criteria (per subject, repeat 10x — see plan §10 for full detail)

- [ ] `taxonomy_cells` has a non-empty, CED-cited grid for the subject in Dev.
- [ ] Published MCQs and FRQs carry non-null `skill_code` in `content_item_cells`, with a recorded
      confirm/promote trail (who/what validated it, against what CED citation).
- [ ] At least one topic×skill cell verified (by row ID, not by trusting a script's success message)
      to satisfy `DECISION-0074`'s bar within that subject's measured ceiling.
- [ ] GAP-10 entry updated with the subject's result.
- [ ] Production writes (grid migration, promoted labels) only after David's explicit per-subject
      go-ahead — Hard Gate, not executed autonomously.

## Status

Not started. This doc exists to give the plan and feasibility work (PR #258) a task ID for tracking,
per David's request. The first subject session should pick this file plus the plan doc and begin
with feasibility-informed sequencing (plan §9, as corrected by the feasibility doc's Statistics
finding).
