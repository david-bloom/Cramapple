select ci.content_key, ci.item_type, ci.status, l.assessed_topics::text, app.content_item_is_teaching(ci.id) teaching,
  (select string_agg(c.topic_code || coalesce('/' || c.skill_code, '') || case when c.is_primary then '(p)' else '' end, ',')
     from app.content_item_cells c join app.content_item_versions v on v.id = c.content_item_version_id
     where v.content_item_id = ci.id and v.status = 'published' and c.superseded_by is null) cells,
  left((select v.stem from app.content_item_versions v where v.content_item_id = ci.id and v.status = 'published' limit 1), 300) stem
from app.content_items ci
join app.content_taxonomy_labels l on l.content_item_id = ci.id and l.label_scope = 'serving' and l.superseded_by is null
join app.exam_pack_versions epv on epv.id = ci.exam_pack_version_id
join app.exam_packs ep on ep.id = epv.exam_pack_id
join app.subjects s on s.id = ep.subject_id
where s.subject_key = 'ap-chemistry' and ci.status = 'published' and ci.item_type = 'mcq'
  and (l.assessed_topics::text ~ '"1\.(2|8)"' or exists (
    select 1 from app.content_item_cells c join app.content_item_versions v on v.id = c.content_item_version_id
    where v.content_item_id = ci.id and c.topic_code in ('1.2', '1.8') and c.superseded_by is null))
order by 1
