# Phase 1 Curated Interface Notes

**Scope:** backend consolidation Phase 1, curated `public` interface over `app`
for Supabase Production `pcntajvbdfqhbeewmdry`.
**Status:** prepared from the local source-of-truth docs and repo migrations.
Use the companion verification SQL against Dev or a branch first, then rerun
the same read-only checks against Production with elevated access.

## Source Of Truth

- `docs/architecture/BACKEND_CONSOLIDATION_MIGRATION_PLAN_2026_07_08.md`
- `docs/architecture/APP_SCHEMA_RECONCILIATION_2026_07_08.md`
- `docs/activity_log/DECISIONS_LOG.md#DECISION-0035`
- `supabase/migrations/202607090001_curated_public_interface.sql`

## Built Curated Contract

### Read views

The curated `public` surface is built around these read-only views:

- `public.profiles`
- `public.subjects`
- `public.exam_packs`
- `public.exam_pack_versions`
- `public.content_labels`
- `public.content_items`
- `public.content_item_versions`
- `public.mcq_choices`
- `public.frq_criteria`
- `public.content_item_labels`
- `public.learning_sessions`
- `public.attempts`
- `public.response_versions`
- `public.attempt_criterion_results`
- `public.grading_results`
- `public.content_review_assignments`
- `public.content_review_decisions`
- `public.config`

### Dashboard views

The six pinned dashboard views are:

- `public.dashboard_overview_v1`
- `public.dashboard_subjects_v1`
- `public.dashboard_pipeline_v1`
- `public.dashboard_engagement_v1`
- `public.dashboard_quality_v1`
- `public.dashboard_attention_v1`

### Write paths

Frontend writes are intentionally kept out of base-table CRUD. The supported
backend write entrypoints remain the existing service-backed functions:

- `submit_response(uuid, uuid, uuid, text, text, text)`
- `compose_learning_runtime_context(uuid)`
- `reserve_model_usage(text, text, text, numeric, numeric)`
- `complete_model_usage(text, text, text, numeric, integer, integer)`

`apply_student_memory_event()` is a trigger helper, not a client-facing RPC.

## Exact Column Mapping

### `public.profiles`

- `user_id`
- `full_name`
- `role`
- `review_queue_scope`
- `timezone`
- `locale`
- `onboarding_completed_at`
- `created_at`
- `updated_at`

### `public.content_item_versions`

Columns exposed:

- `id`
- `content_item_id`
- `exam_pack_version_id`
- `exam_pack_id`
- `exam_code`
- `exam_name`
- `subject_id`
- `subject_key`
- `subject_name`
- `content_key`
- `item_type`
- `frq_form`
- `title`
- `version_num`
- `stem`
- `stimulus`
- `prompt_json`
- `explanation`
- `help_text`
- `content_hash`
- `canonical_answer_1`
- `canonical_answer_2`
- `review_status`
- `status`
- `approved_at`
- `approved_by`
- `published_at`
- `created_by`
- `created_at`
- `updated_at`

### `public.grading_results`

Learner-safe fields only:

- `id`
- `request_id`
- `attempt_id`
- `user_id`
- `learning_session_id`
- `exam_pack_version_id`
- `exam_pack_id`
- `exam_code`
- `exam_name`
- `subject_id`
- `subject_key`
- `subject_name`
- `content_item_version_id`
- `content_key`
- `item_type`
- `frq_form`
- `title`
- `response_version_id`
- `operation`
- `status`
- `points_earned`
- `points_available`
- `criterion_results`
- `highest_value_gap`
- `predicted_label`
- `predicted_point_gain`
- `actual_point_gain`
- `prediction_outcome`
- `confidence`
- `uncertainty_reason`
- `created_at`
- `updated_at`

Sensitive model-budget internals are intentionally excluded from the public
view.

The learner-facing preview fields stay out of this view until the Phase A
schema columns actually exist in the target database.

## Delta Report

This section captures the planning-to-implementation deltas that matter for the
frontend repoint.

1. The reconciliation plan originally assumed a single
   `app.content_item_versions.canonical_answer` column. Live Production uses
   `canonical_answer_1` and `canonical_answer_2`, so the curated public view
   exposes both fields instead.
2. `public.profiles` is required for frontend role resolution because role lives
  on `app.profiles.role`; there is no `user_roles` table.
3. The `content_review_*` workflow is the canonical review path. The legacy
   `review_*` workflow stays private unless a future task explicitly restores it.
4. `content_review_assignments` and `content_review_decisions` use
   `content_review_assignment_id` / `content_review_decision_id` as their live
   primary keys, so the curated views alias those names directly.
5. `review_blind_groups` is not created. `blind_group_id` on the review tables
   is the correlation key.
6. `app.config` is implemented as a small key/value table with a public filtered
   read view. The public view only returns rows flagged `is_public`.
7. The six dashboard view names are pinned here for the frontend contract. If a
   live Production inspection shows different names already in use, treat that
   as the override and adjust the frontend accordingly.
8. The verification SQL should be run against Dev or a branch first, then
   repeated as an authenticated role so security-invoker views are tested in the
   same access mode the frontend will use.

## Live Verification Notes

The live Production schema was separately validated through QA, and that check
is what surfaced the blocking column mismatches. This notes file now reflects
the corrected curated contract for Dev/branch testing and the follow-up
verification loop.
