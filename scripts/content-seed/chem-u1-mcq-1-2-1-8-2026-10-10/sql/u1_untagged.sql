select ci.content_key, l.primary_unit, l.max_required_unit,
  (select string_agg(c.topic_code || case when c.is_primary then '(p)' else '' end, ',') from app.content_item_cells c
     where c.content_item_version_id = v.id and c.superseded_by is null) cells,
  left(v.stem, 260) stem
from app.content_items ci
join app.content_item_versions v on v.content_item_id = ci.id and v.status = 'published'
join app.content_taxonomy_labels l on l.content_item_id = ci.id and l.label_scope = 'serving' and l.superseded_by is null and l.label_status = 'validated'
where ci.content_key like 'apchem-%' and ci.status = 'published' and ci.item_type = 'mcq' and l.primary_unit = 1
  and not app.content_item_is_teaching(ci.id)
  and not exists (select 1 from app.content_item_cells c where c.content_item_version_id = v.id and c.is_primary and c.superseded_by is null and c.topic_code in ('1.1','1.3','1.4','1.5','1.6','1.7'))
order by 1
