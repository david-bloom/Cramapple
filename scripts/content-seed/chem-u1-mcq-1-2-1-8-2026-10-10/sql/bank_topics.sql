select ci.content_key, c.topic_code, v.stem,
  (select json_agg(json_build_object('choice_text', m.choice_text, 'is_correct', m.is_correct) order by m.choice_key) from app.mcq_choices m where m.content_item_version_id = v.id) choices
from app.content_items ci
join app.content_item_versions v on v.content_item_id = ci.id and v.status = 'published'
join app.content_item_cells c on c.content_item_version_id = v.id and c.is_primary and c.superseded_by is null
where ci.exam_pack_version_id = 'c9ca46b2-b529-4ed3-9741-dddea455ab9b' and ci.status = 'published' and ci.item_type = 'mcq'
  and c.topic_code in ('1.2', '1.8')
order by 1
