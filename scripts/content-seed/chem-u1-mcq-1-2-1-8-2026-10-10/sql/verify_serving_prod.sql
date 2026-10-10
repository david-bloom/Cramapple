-- Post-publish serving check (read-only). Calls the REAL selector as service_role (auth.uid() is null), Unit 1, MCQs.
-- Expect: served_new = 9 (all of apchem-mcq-080..084 and their -sv- variants), teaching_served = 0,
-- and the per-topic primary-cell counts 1.2 = 5, 1.8 = 4 among non-teaching published MCQs.
with served as (
  select * from public.select_unit_gated_practice_items('c9ca46b2-b529-4ed3-9741-dddea455ab9b'::uuid, 1, null, 'mcq', 50)
)
select
  (select count(*) from served) served_total,
  (select count(*) from served where content_key ~ '^apchem-mcq-(sv-)?08[0-4]') served_new,
  (select string_agg(content_key, ',' order by content_key) from served where content_key ~ '^apchem-mcq-(sv-)?08[0-4]') served_new_keys,
  (select count(*) from served s where app.content_item_is_teaching(s.content_item_id)) teaching_served,
  (select json_object_agg(topic_code, n) from (
     select c.topic_code, count(*) n from app.content_item_cells c
     join app.content_item_versions v on v.id = c.content_item_version_id and v.status = 'published'
     join app.content_items ci on ci.id = v.content_item_id and ci.status = 'published' and ci.item_type = 'mcq'
     where ci.exam_pack_version_id = 'c9ca46b2-b529-4ed3-9741-dddea455ab9b' and c.is_primary and c.superseded_by is null
       and c.topic_code in ('1.2', '1.8') and not app.content_item_is_teaching(ci.id)
     group by 1) x) practice_by_topic
