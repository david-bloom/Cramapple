-- Read-only: authored-parts shape per subject/unit for each subject's first three units.
-- Mirrors the question RPC precedence (prompt_json.parts, else item_package_payload.parts).
-- Incomplete parts make the More help function fail closed (question_parts_unavailable).
with latest as (
  select distinct on (ci.id) ci.id as item_id, ci.item_type, ci.content_key, v.id as vid, v.stimulus_image_path, v.prompt_json, v.item_package_payload,
    s.subject_key,
    -- Reference/taxonomy keys differ from registry keys: Biology is ap_biology.
    case when s.subject_key = 'biology' then 'ap_biology' else replace(s.subject_key, '-', '_') end as reference_subject
  from app.content_items ci
  join app.content_item_versions v on v.content_item_id = ci.id and v.status = 'published'
  join app.exam_pack_versions epv on epv.id = ci.exam_pack_version_id
  join app.exam_packs ep on ep.id = epv.exam_pack_id
  join app.subjects s on s.id = ep.subject_id
  where ci.status = 'published'
  order by ci.id, v.version_num desc
), q as (
  select l.*, cell.topic_code, cell.unit_number
  from latest l
  left join lateral (
    select cc.topic_code, tt.unit_number
    from app.content_item_cells cc
    left join app.taxonomy_topics tt
      on tt.taxonomy_source_version = cc.taxonomy_source_version and tt.topic_code = cc.topic_code
    where cc.content_item_version_id = l.vid and cc.superseded_by is null
    order by cc.is_primary desc nulls last, cc.created_at
    limit 1
  ) cell on true
), first_units as (
  select subject_key, unit_number,
    dense_rank() over (partition by subject_key order by unit_number) as unit_rank
  from (select distinct subject_key, unit_number from q where unit_number is not null) u
), scoped as (
  select q.*, fu.unit_rank,
    case when q.prompt_json ? 'parts' and q.prompt_json->'parts' <> 'null'::jsonb then q.prompt_json->'parts'
         when q.item_package_payload ? 'parts' then q.item_package_payload->'parts' else '[]'::jsonb end as parts
  from q join first_units fu on fu.subject_key = q.subject_key and fu.unit_number = q.unit_number
  where fu.unit_rank <= 3
), checks as (
  select s.*, case when jsonb_typeof(parts)='array' then jsonb_array_length(parts) end part_count,
    jsonb_typeof(parts) is distinct from 'array' as wrong_shape, a.bad_part_count, a.duplicate_key_count, a.blank_key_count
  from scoped s cross join lateral (
    select count(*) filter(where jsonb_typeof(p) is distinct from 'object'
        or nullif(btrim(case when jsonb_typeof(p->'prompt')='string' and nullif(btrim(p->>'prompt'),'') is not null then p->>'prompt'
           when jsonb_typeof(p->'prompt_text')='string' then p->>'prompt_text' end),'') is null) bad_part_count,
      count(*)-count(distinct coalesce(nullif(p->>'part_key',''),nullif(p->>'part_id',''),'part-'||ord::text)) duplicate_key_count,
      count(*) filter(where btrim(coalesce(nullif(p->>'part_key',''),nullif(p->>'part_id',''),'part-'||ord::text))='') blank_key_count
    from jsonb_array_elements(case when jsonb_typeof(parts)='array' then parts else '[]'::jsonb end) with ordinality x(p,ord)
  ) a
)
select subject_key, unit_number, count(*) as questions,
  count(*) filter (where item_type='frq') as frqs,
  count(*) filter (where part_count > 0) as multipart,
  count(*) filter (where wrong_shape or bad_part_count>0 or duplicate_key_count>0 or blank_key_count>0) as incomplete_parts,
  count(*) filter (where coalesce(part_count,0) > 26) as over_26_parts,
  count(*) filter (where item_type='frq' and coalesce(part_count,0) = 0) as frq_without_parts_array
from checks group by subject_key, unit_number order by subject_key, unit_number;
