-- CONTENT_TAXONOMY_RATIONALIZATION_PLAN_2026_09_26.md Phase 1 step 4.
-- Migrates every item with a real (non-empty) content_taxonomy_labels topic
-- assignment into app.content_item_cells as topic-only rows (skill_code
-- NULL), keyed to each item's current published version. Applied against
-- Production data 2026-09-26/27 (112 AP Biology rows at the time); the
-- source label rows are left in place, frozen -- system 3 stays the
-- unit-serving-label table it actually is in production, nothing here
-- deletes or mutates content_taxonomy_labels. Re-running is idempotent in
-- effect (the unique constraint from the prior migration rejects a repeat
-- insert for the same version+topic), though not wrapped in ON CONFLICT
-- since a real re-run was not expected.

begin;

insert into app.content_item_cells (
  content_item_id,
  content_item_version_id,
  taxonomy_source_version,
  topic_code,
  skill_code,
  is_primary,
  assignment_status,
  source,
  model_run_id
)
select
  ctl.content_item_id,
  civ.id,
  ctl.taxonomy_source_version,
  ctl.assessed_topics[1],
  null,
  true,
  'provisional_model',
  ctl.source,
  ctl.model_run_id
from app.content_taxonomy_labels ctl
join app.content_item_versions civ
  on civ.content_item_id = ctl.content_item_id and civ.status = 'published'
where ctl.assessed_topics is not null and cardinality(ctl.assessed_topics) > 0
on conflict do nothing;

commit;
