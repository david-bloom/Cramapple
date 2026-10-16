-- Development ONLY. Creates (idempotently) single-item learning sessions for the synthetic
-- QA identity, so the QA runner can request More help on real published questions.
-- Substitute the three placeholders before running with:
--   supabase db query --linked --workdir <repo> -f <file>   (confirm the ref is Development)
--   __SUBJECT__  registry key, e.g. ap-statistics
--   __UNITS__    int array literal, e.g. {1,2,3}  (never include a unit the owner has not approved)
--   __USER__     synthetic QA user id (an @example.invalid identity)
-- Picks, per unit: up to 2 MCQs and 1 FRQ (latest published, no stimulus image, with reference).
-- Output: JSON array [{unit,type,topic,session,version}] to feed run.mjs --fixtures.
with picks as (
  select * from (
    select distinct on (ci.id) ci.id item_id, ci.item_type, v.id vid, cell.topic_code, tt.unit_number, ep_sess.epv_id,
      row_number() over (partition by tt.unit_number, ci.item_type order by ci.id) rn
    from app.content_items ci
    join app.content_item_versions v on v.content_item_id = ci.id and v.status = 'published' and v.stimulus_image_path is null
    join app.exam_pack_versions epv on epv.id = ci.exam_pack_version_id
    join app.exam_packs ep on ep.id = epv.exam_pack_id
    join app.subjects s on s.id = ep.subject_id
    cross join lateral (select epv.id epv_id) ep_sess
    join lateral (select cc.topic_code, cc.taxonomy_source_version from app.content_item_cells cc
      where cc.content_item_version_id = v.id and cc.superseded_by is null
      order by cc.is_primary desc nulls last, cc.created_at limit 1) cell on true
    join app.taxonomy_topics tt on tt.taxonomy_source_version = cell.taxonomy_source_version and tt.topic_code = cell.topic_code
    where ci.status = 'published' and s.subject_key = '__SUBJECT__' and tt.unit_number = any('__UNITS__'::int[])
      and exists (select 1 from app.unit_reference_entries r where r.status = 'published'
        and cell.topic_code = any(r.topic_codes) and nullif(r.body, '') is not null)
    order by ci.id, v.version_num desc
  ) x where (item_type = 'mcq' and rn <= 2) or (item_type = 'frq' and rn <= 1)
), have as (
  select lsi.content_item_version_id vid, min(ls.id::text)::uuid session_id
  from app.learning_sessions ls join app.learning_session_items lsi on lsi.learning_session_id = ls.id
  where ls.user_id = '__USER__' and ls.status = 'active' and (select count(*) from app.learning_session_items z where z.learning_session_id = ls.id) = 1
  group by 1
), need as (
  select p.*, gen_random_uuid() sid from picks p left join have h on h.vid = p.vid where h.vid is null
), new_s as (
  insert into app.learning_sessions(id, user_id, exam_pack_version_id, entry_path, session_mode, available_minutes, practice_format)
  select n.sid, '__USER__', n.epv_id, 'topic', 'focused', 10, case when n.item_type = 'mcq' then 'mcq' else 'short_frq' end
  from need n returning id
), new_i as (
  insert into app.learning_session_items(learning_session_id, ordinal, content_item_version_id)
  select n.sid, 1, n.vid from need n where n.sid in (select id from new_s) returning learning_session_id, content_item_version_id
)
select coalesce(jsonb_agg(jsonb_build_object('unit', p.unit_number, 'type', p.item_type, 'topic', p.topic_code,
  'session', coalesce(h.session_id, ni.learning_session_id), 'version', p.vid) order by p.unit_number, p.item_type, p.rn), '[]'::jsonb) as fixtures
from picks p left join have h on h.vid = p.vid left join new_i ni on ni.content_item_version_id = p.vid;
