-- Exported from Production migration history (supabase_migrations.schema_migrations)
-- version: 20260627124423
-- recorded name: deprecate_compatibility_content_tables
-- statements: 1
-- This file is a faithful transcript of what Production actually ran.
-- Do not edit to "improve" it; corrections belong in a new forward migration.

-- Mark the legacy content tables as compatibility projections only.
-- New content workflows should use the governance tables in 202606200006.

begin;

comment on table app.content_labels is
  'Deprecated compatibility projection. Use app.source_records, app.rights_records, app.artifact_versions, app.artifact_state_events, and related governance tables for new content workflows.';

comment on table app.content_items is
  'Deprecated compatibility projection. Use app.artifact_versions and app.artifact_state_events for authoritative content lifecycle.';

comment on table app.content_item_versions is
  'Deprecated compatibility projection. New versions should be authored as app.artifact_versions rows and projected here only for compatibility during the migration period.';

comment on table app.mcq_choices is
  'Deprecated compatibility projection. The authoritative MCQ content lives in app.artifact_versions and related governance records.';

comment on table app.frq_criteria is
  'Deprecated compatibility projection. The authoritative rubric and criterion model lives in the governance tables.';

comment on table app.content_item_labels is
  'Deprecated compatibility projection. New tagging and release workflows should be expressed through governance records and projections.';

commit;
