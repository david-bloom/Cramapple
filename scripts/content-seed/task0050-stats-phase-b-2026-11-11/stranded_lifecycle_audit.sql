-- TASK-0050: read-only audit of published parent items without a published version.
-- Run against Production pcntajvbdfqhbeewmdry. No writes.
with stranded as (
  select ci.id, ci.content_key, ci.item_type
  from app.content_items ci
  where ci.exam_pack_version_id = '548f06be-ccf4-426d-b82b-b424137a4438'::uuid
    and ci.status = 'published'
    and not exists (
      select 1 from app.content_item_versions v
      where v.content_item_id = ci.id and v.status = 'published'
    )
), latest as (
  select distinct on (v.content_item_id)
    v.content_item_id, v.id version_id, v.version_num, v.status version_status,
    v.review_status
  from app.content_item_versions v
  join stranded s on s.id = v.content_item_id
  order by v.content_item_id, v.version_num desc
), serving as (
  select distinct on (l.content_item_id)
    l.content_item_id, l.label_status, l.primary_unit
  from app.content_taxonomy_labels l
  join stranded s on s.id = l.content_item_id
  where l.label_scope = 'serving' and l.superseded_by is null
  order by l.content_item_id, l.label_version desc
)
select s.content_key, s.item_type, l.version_id, l.version_num,
       l.version_status, l.review_status,
       (select count(*) from app.content_item_versions v
        where v.content_item_id = s.id) version_count,
       (select count(*) from app.content_item_cells c
        where c.content_item_version_id = l.version_id) cell_count,
       (select count(*) from app.content_item_topic_resolution r
        where r.content_item_version_id = l.version_id) topic_resolution_count,
       serving.label_status serving_label_status,
       serving.primary_unit serving_primary_unit
from stranded s
join latest l on l.content_item_id = s.id
left join serving on serving.content_item_id = s.id
order by s.item_type, s.content_key;
