-- TASK-0050 Statistics Phase B, APPROVAL-0236. Read-only Production check.
with inserted as (
  select c.*, ci.item_type, ci.exam_pack_version_id, ci.status item_status,
         v.status version_status,
         tc.taxonomy_cell_id
  from app.content_item_cells c
  join app.content_items ci on ci.id = c.content_item_id
  join app.content_item_versions v on v.id = c.content_item_version_id
  left join app.taxonomy_cells tc
    on tc.taxonomy_source_version = c.taxonomy_source_version
   and tc.topic_code = c.topic_code
   and tc.skill_code = c.skill_code
  where c.model_run_id like 'skill-codes-ap_statistics-20261112032357:%'
), missing as (
  select v.id
  from app.content_items ci
  join app.content_item_versions v on v.content_item_id = ci.id and v.status = 'published'
  where ci.exam_pack_version_id = '548f06be-ccf4-426d-b82b-b424137a4438'::uuid
    and ci.status = 'published'
    and not exists (
      select 1 from app.content_item_cells c
      where c.content_item_version_id = v.id and c.skill_code is not null
    )
), cell_inventory as (
  select c.topic_code, c.skill_code,
         count(distinct ci.id) filter (where ci.item_type = 'mcq') mcq_n,
         count(distinct ci.id) filter (where ci.item_type = 'frq') frq_n
  from app.content_item_cells c
  join app.content_item_versions v on v.id = c.content_item_version_id and v.status = 'published'
  join app.content_items ci on ci.id = v.content_item_id and ci.status = 'published'
  where ci.exam_pack_version_id = '548f06be-ccf4-426d-b82b-b424137a4438'::uuid
    and c.skill_code is not null
  group by c.topic_code, c.skill_code
)
select
  (select count(*) from inserted) inserted_rows,
  (select count(distinct content_item_version_id) from inserted) inserted_versions,
  (select count(*) from inserted where item_type = 'mcq') inserted_mcq,
  (select count(*) from inserted where item_type = 'frq') inserted_frq,
  (select count(*) from inserted where assignment_status <> 'provisional_model'
     or is_primary or taxonomy_cell_id is null or item_status <> 'published'
     or version_status <> 'published'
     or exam_pack_version_id <> '548f06be-ccf4-426d-b82b-b424137a4438'::uuid) invalid_inserted,
  (select md5(string_agg(content_item_version_id::text || '|' || topic_code || '|' || skill_code,
                         ',' order by content_item_version_id::text || '|' || topic_code || '|' || skill_code))
   from inserted) labels_md5,
  (select count(*) from missing) missing_published_versions,
  (select count(*) from cell_inventory) labeled_cells,
  (select count(*) from cell_inventory where mcq_n >= 2 and frq_n >= 1) inventory_threshold_cells;
