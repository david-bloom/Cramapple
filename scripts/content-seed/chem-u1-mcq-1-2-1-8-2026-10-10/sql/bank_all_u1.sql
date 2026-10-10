select ci.content_key, app.content_item_is_teaching(ci.id) teaching,
  (select c.topic_code from app.content_item_cells c where c.content_item_version_id = v.id and c.is_primary and c.superseded_by is null limit 1) topic,
  v.stem,
  (select json_agg(json_build_object('choice_text', m.choice_text) order by m.choice_key) from app.mcq_choices m where m.content_item_version_id = v.id) choices
from app.content_items ci
join app.exam_pack_versions epv on epv.id = ci.exam_pack_version_id
join app.exam_packs ep on ep.id = epv.exam_pack_id
join app.subjects s on s.id = ep.subject_id
join app.content_item_versions v on v.content_item_id = ci.id and v.status = 'published'
where s.subject_key = 'ap-chemistry' and ci.status = 'published' and ci.item_type = 'mcq'
