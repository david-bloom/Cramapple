-- CONTENT_TAXONOMY_RATIONALIZATION_PLAN_2026_09_26.md §3.2 / §5 Phase 1.
-- Generalizes app.content_item_cells so a topic-only assignment (skill_code
-- NULL) is legal, and adds the governance apparatus decisions #5/#6 need
-- (assignment_status, source, model_run_id, validated_*). Additive only;
-- no existing row's meaning changes. Applied to Dev then Production
-- 2026-09-26/27, verified via get_advisors on both.

begin;

-- 1. skill_code becomes optional (topic-only row = topic asserted, skill not).
alter table app.content_item_cells
  alter column skill_code drop not null;

-- 2. New FK so a topic-only row still can't name a nonexistent topic. The
--    existing (source_version, topic_code, skill_code) -> taxonomy_cells FK
--    is trivially satisfied by Postgres when skill_code is NULL (MATCH
--    SIMPLE), so it no longer guards topic-only rows on its own -- this one
--    does.
alter table app.content_item_cells
  add constraint content_item_cells_topic_fkey
  foreign key (taxonomy_source_version, topic_code)
  references app.taxonomy_topics (taxonomy_source_version, topic_code)
  on delete restrict;

-- 3. Replace the unique constraint so two topic-only rows for the same
--    topic on the same version collide (NULLS NOT DISTINCT, PG17).
alter table app.content_item_cells
  drop constraint content_item_cells_content_item_version_id_topic_code_skill_key;

alter table app.content_item_cells
  add constraint content_item_cells_version_topic_skill_key
  unique nulls not distinct (content_item_version_id, topic_code, skill_code);

-- 4. Exactly one primary topic per version (plan §3.2, §6.2 of the migration
--    plan: "the new design needs exactly one topic per item"). Secondary
--    rows stay legal for coverage reporting.
alter table app.content_item_cells
  add column is_primary boolean not null default true;

create unique index content_item_cells_one_primary_per_version
  on app.content_item_cells (content_item_version_id)
  where is_primary;

-- 5. Governance apparatus, same vocabulary as content_taxonomy_labels plus
--    'authored' for generator/human-authored emissions that were never
--    machine-guessed (decision #5).
alter table app.content_item_cells
  add column assignment_status text not null default 'provisional_model',
  add column source text,
  add column model_run_id text,
  add column validated_by uuid references app.profiles (user_id),
  add column validated_at timestamptz,
  add column validation_decision_id uuid,
  add column superseded_by uuid references app.content_item_cells (content_item_cell_id);

alter table app.content_item_cells
  add constraint content_item_cells_status_check
  check (assignment_status = any (array['legacy_unvalidated','provisional_model','validated','stale','held','authored']));

-- Mirrors content_taxonomy_labels_validation_check: 'validated' status
-- requires the validation fields to actually be filled in, not just claimed.
alter table app.content_item_cells
  add constraint content_item_cells_validation_check
  check ((assignment_status = 'validated') = (validated_by is not null and validated_at is not null and validation_decision_id is not null));

-- 6. Backfill the pre-existing rows (203 in Production, 212 in Dev):
--    decision #5 -- 'authored', not 'provisional_model' (they were emitted
--    by a template whose cell was chosen by a human under the D2 SME gate,
--    not guessed by a classifier).
update app.content_item_cells
set assignment_status = 'authored',
    source = 'course_mode_generator_f4'
where assignment_status = 'provisional_model'; -- i.e. every existing row (the default above)

commit;
