select ci.content_key, ci.status, civ.status vstatus, c.topic_code, c.skill_code, ci.item_type::text, ci.practice_format::text,
  left(civ.stem, 400) stem,
  (select string_agg(m.choice_key || (case when m.is_correct then '*' else '' end) || ': ' || m.choice_text, ' | ' order by m.choice_key)
     from app.mcq_choices m where m.content_item_version_id = civ.id) choices
from app.content_items ci
join app.exam_pack_versions epv on epv.id = ci.exam_pack_version_id
join app.exam_packs ep on ep.id = epv.exam_pack_id
join app.subjects s on s.id = ep.subject_id
join app.content_item_versions civ on civ.content_item_id = ci.id and civ.status = 'published'
join app.content_item_cells c on c.content_item_version_id = civ.id and c.is_primary and c.superseded_by is null
where s.subject_key = 'ap-chemistry' and ci.status = 'published' and c.topic_code in ('1.2', '1.8')
order by c.topic_code, ci.content_key
