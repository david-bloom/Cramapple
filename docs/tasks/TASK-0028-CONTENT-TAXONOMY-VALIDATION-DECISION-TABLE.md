# TASK-0028 — Content Taxonomy Validation Decision Table

**Task ID:** TASK-0028
**Title:** Content Taxonomy Validation Decision Table
**Owner:** Claude, with David
**Product Owner:** David Bloom
**Tier:** Standard
**Status:** Done
**Priority:** Medium
**Created Date:** 2026-08-24
**Approved Date:** 2026-08-24
**Source:** Discovered while human-validating taxonomy labels for the 8 items
authored under `docs/research/ORLY_EXTERNAL_ASSIGNMENT_MINING_PROTOCOL_2026_08_24.md`
(see `docs/research/orly_source_log/SOURCE_LOG.md`, "Validation note").

## Product Goal

`app.content_taxonomy_labels.validation_decision_id` has existed since
`20260804170000_taxonomy_label_layer.sql` as a bare `uuid` column with no
foreign key and no backing table. `docs/architecture/TAXONOMY_LABELING_PLAN_V3_2026_08_04.md`
§T6 requires every `label_status='validated'` row to represent an actual
human validation decision, but there was nothing in the schema to record
*what* that decision was, *who* made it, or *how* — only that a UUID exists.
The first real validation (2026-08-24, 8 items) had to use a generated
placeholder UUID and document the gap in `source_payload` rather than
reference a real decision record.

This task builds that missing table and wires the existing column to it as a
real foreign key, so every future validation has an auditable decision
record instead of an opaque placeholder.

## Technical Scope

- New table `app.content_taxonomy_validation_decisions`: one row per
  validation decision, capturing who decided, when, how (`decision_source`),
  what was decided (`decision`: `confirmed` / `corrected` / `rejected`), and
  the reviewer's final `reviewed_primary_unit` / `reviewed_required_units`
  (which may differ from the model's suggestion when `decision='corrected'`).
- `app.content_taxonomy_labels.validation_decision_id` gets a real foreign
  key to the new table (`ON DELETE RESTRICT` — a decision record must not be
  deleted out from under a label that cites it).
- Backfill: insert 8 decision rows for the existing validated labels, reusing
  their already-stored `validation_decision_id` values so no relabeling or
  re-validation is needed — this closes the gap for those 8 rows rather than
  orphaning them.
- RLS: enabled, `service_role` full access (matches
  `app.content_review_decisions`'s `crd_service_all` pattern), `SELECT`
  granted to the `content_reviewer` role (matches
  `app.content_taxonomy_labels`'s existing grant).

## Out of Scope

- A UI or RPC for reviewers to *make* new validation decisions through the
  app — this task only builds the storage layer and backfills existing data.
  T6's actual human-review workflow (spot-check triage, gold-set calibration)
  is still unimplemented per the plan doc and is separate future work.
- Retroactively touching any other subject's or item's taxonomy labels —
  scope is exactly the 8 rows already validated this session.

## Routes / Components / Systems Affected

- `app.content_taxonomy_labels` (new FK constraint only, no column changes).
- New table `app.content_taxonomy_validation_decisions`.
- No edge functions, frontend routes, or RPCs touched.

## Data / Security / Integration Impact

- Applied to Production only (`pcntajvbdfqhbeewmdry`) — mirrors the scope of
  the validation work it backs. Not applied to Dev in this pass; Dev does not
  have these 8 content_items at all, so there is nothing to backfill there,
  though the table/FK could be mirrored later as pure schema (no data) if
  Dev needs it for its own taxonomy-labeling work.
- RLS enabled from creation; no `authenticated`-role access, matching the
  existing `content_taxonomy_labels` access pattern (internal/reviewer
  tooling only, not student-facing).

## Acceptance Criteria

- [x] `app.content_taxonomy_validation_decisions` exists with the columns
      described above and RLS enabled.
- [x] All 8 existing `content_taxonomy_labels.validation_decision_id` values
      resolve to a real row in the new table.
- [x] `content_taxonomy_labels_validation_decision_id_fkey` foreign key
      constraint exists and validates cleanly against current data.
- [x] `select_unit_gated_practice_items` still returns all 8 items correctly
      after the migration (no regression from adding the FK).

## QA Plan

- Manual QA: re-ran the same selector query used to verify the original
  validation pass; independently queried the new table's row count and
  spot-checked one row's `reviewed_primary_unit` against the corresponding
  `content_taxonomy_labels.primary_unit`.
- Automated tests: none added — this is a small, one-off schema addition
  with no application code path yet exercising it beyond the FK itself.
- Regression areas: any future write to `content_taxonomy_labels` with a
  non-null `validation_decision_id` must now reference an existing decision
  row or the write will fail — this is the intended behavior change.
- Failure cases: n/a (backfill data was verified to be exactly the 8 target
  rows, with no pre-existing non-null `validation_decision_id` values
  elsewhere, before the FK was added).
- Security/data/integration checks: RLS policy mirrors an existing,
  already-reviewed table's pattern rather than inventing a new one.

## Approval State

**Approval Required:** Yes
**Approval Type:** Standing (David asked to spawn and execute this task
directly in chat, 2026-08-24)
**Decision:** Approved and executed 2026-08-24.

## Implementation Notes

Migration: `supabase/migrations/20260824160000_content_taxonomy_validation_decisions.sql`.

## QA Review

**QA Verdict:** Pass — acceptance criteria verified against Production
directly after apply (see Implementation Notes migration for the exact
statements; verification queries run separately, not part of the migration
file itself).

## Done Decision

**Decision:** Done
**Date:** 2026-08-24
