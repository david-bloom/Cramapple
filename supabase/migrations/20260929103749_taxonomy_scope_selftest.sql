-- app.taxonomy_scope_selftest() — standing check that content stays inside the
-- scope its subject's taxonomy defines.
--
-- Why this exists (2026-09-29): three published apcalcab-* items assessed topics
-- the CED marks BC-only (Euler's method 7.5, logistic models 7.9, arc length
-- 8.13). Two independent AI labelling passes both failed on exactly those three
-- items -- the unit pass held them, then the topic pass held or force-fitted
-- them -- and a prior human audit had concluded no such item existed. The signal
-- was present twice and had nowhere to land. This gives it somewhere to land.
--
-- Mirrors app.servable_items_census_selftest(): returns one row per violation,
-- zero rows means healthy, so it reads the same way in a QA pass.

create or replace function app.taxonomy_scope_selftest()
returns table (
  check_name text,
  exam_code text,
  content_key text,
  detail text
)
language sql
stable
set search_path = pg_catalog
as $$
  -- 1. A cell tag must use the taxonomy source version of the item's OWN
  --    subject. The composite FK to taxonomy_cells does not enforce this: it
  --    only requires the (source_version, topic, skill) triple to exist
  --    somewhere, so an AB item tagged with a BC source version would pass it.
  select 'cell_uses_foreign_subject_taxonomy'::text,
         ep.exam_code::text,
         ci.content_key::text,
         format('cell row uses taxonomy_source_version %s but the item''s subject resolves to %s',
                cic.taxonomy_source_version, own.taxonomy_source_version)::text
  from app.content_item_cells cic
  join app.content_items ci on ci.id = cic.content_item_id
  join app.exam_pack_versions epv on epv.id = ci.exam_pack_version_id
  join app.exam_packs ep on ep.id = epv.exam_pack_id
  left join app.taxonomy_source_versions own on own.subject_key = ep.exam_code
  where own.taxonomy_source_version is null
     or cic.taxonomy_source_version <> own.taxonomy_source_version

  union all

  -- 2. The assigned topic must be registered for the item's own subject. This
  --    is the direct statement of the rule the Calculus defect broke: an AB
  --    item can only carry an AB topic.
  select 'topic_not_in_subject_taxonomy'::text,
         ep.exam_code::text,
         ci.content_key::text,
         format('topic %s is not registered for subject %s', cic.topic_code, ep.exam_code)::text
  from app.content_item_cells cic
  join app.content_items ci on ci.id = cic.content_item_id
  join app.exam_pack_versions epv on epv.id = ci.exam_pack_version_id
  join app.exam_packs ep on ep.id = epv.exam_pack_id
  join app.taxonomy_source_versions own on own.subject_key = ep.exam_code
  where cic.topic_code is not null
    and not exists (
      select 1 from app.taxonomy_topics t
      where t.taxonomy_source_version = own.taxonomy_source_version
        and t.topic_code = cic.topic_code
    )

  union all

  -- 3. Same rule for the unit-level serving labels, which are where the
  --    Calculus items first showed trouble. A required unit that no topic in
  --    the subject belongs to means the label points outside the course.
  select 'serving_label_unit_not_in_subject'::text,
         ep.exam_code::text,
         ci.content_key::text,
         format('serving label claims unit %s, which has no registered topic in %s', u, ep.exam_code)::text
  from app.content_taxonomy_labels ctl
  cross join lateral unnest(coalesce(ctl.required_units, '{}')) as u
  join app.content_items ci on ci.id = ctl.content_item_id
  join app.exam_pack_versions epv on epv.id = ci.exam_pack_version_id
  join app.exam_packs ep on ep.id = epv.exam_pack_id
  join app.taxonomy_source_versions own on own.subject_key = ep.exam_code
  where ctl.superseded_by is null
    and ctl.label_scope = 'serving'
    and not exists (
      select 1 from app.taxonomy_topics t
      where t.taxonomy_source_version = own.taxonomy_source_version
        and t.unit_number = u
    );
$$;

comment on function app.taxonomy_scope_selftest() is
  'TASK-0050. Returns one row per taxonomy-scope violation; zero rows is healthy. '
  'Checks that every content_item_cells tag uses its own subject''s taxonomy source '
  'version, that every assigned topic is registered for that subject, and that no '
  'serving label claims a unit the subject has no topics in. Added after three '
  'published apcalcab-* items were found assessing BC-only topics, a defect two '
  'labelling passes detected and had no way to report.';

revoke all on function app.taxonomy_scope_selftest() from public, anon, authenticated;
grant execute on function app.taxonomy_scope_selftest() to service_role;
