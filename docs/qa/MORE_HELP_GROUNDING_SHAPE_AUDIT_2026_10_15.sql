-- SELECT only. Published source content across the three supported subjects;
-- no student/session/attempt data. Mirrors migration authored-parts precedence.
with q as (
 select v.id, s.subject_key, ci.content_key, ci.item_type,
   v.prompt_json->'parts' primary_parts, v.item_package_payload->'parts' fallback_parts,
   case when v.prompt_json ? 'parts' and v.prompt_json->'parts' <> 'null'::jsonb
     then v.prompt_json->'parts' when v.item_package_payload ? 'parts'
     then v.item_package_payload->'parts' else '[]'::jsonb end parts
 from app.content_items ci
 join app.content_item_versions v on v.content_item_id=ci.id
 join app.exam_pack_versions epv on epv.id=ci.exam_pack_version_id
 join app.exam_packs ep on ep.id=epv.exam_pack_id
 join app.subjects s on s.id=ep.subject_id
 where ci.status='published' and v.status='published'
 and s.subject_key in ('ap-calculus-ab','ap-calculus-bc','ap-chemistry')
), checks as (
 select q.*, case when jsonb_typeof(parts)='array' then jsonb_array_length(parts) end part_count,
   jsonb_typeof(parts) is distinct from 'array' as wrong_shape,
   primary_parts='[]'::jsonb and jsonb_typeof(fallback_parts)='array'
     and fallback_parts<>'[]'::jsonb as empty_primary_nonempty_fallback,
   a.bad_part_count,a.duplicate_key_count,a.long_key_count,a.blank_key_count
 from q
 cross join lateral (
   select count(*) filter(where jsonb_typeof(p) is distinct from 'object'
       or nullif(btrim(case when jsonb_typeof(p->'prompt')='string'
          and nullif(btrim(p->>'prompt'),'') is not null then p->>'prompt'
          when jsonb_typeof(p->'prompt_text')='string' then p->>'prompt_text' end),'') is null) bad_part_count,
     count(*)-count(distinct coalesce(nullif(p->>'part_key',''),nullif(p->>'part_id',''),'part-'||ord::text)) duplicate_key_count,
     count(*) filter(where length(coalesce(nullif(p->>'part_key',''),nullif(p->>'part_id',''),'part-'||ord::text))>80) long_key_count,
     count(*) filter(where btrim(coalesce(nullif(p->>'part_key',''),nullif(p->>'part_id',''),'part-'||ord::text))='') blank_key_count
   from jsonb_array_elements(case when jsonb_typeof(parts)='array' then parts else '[]'::jsonb end)
     with ordinality x(p,ord)
 ) a
), flags as (
 select *, wrong_shape or bad_part_count>0 or duplicate_key_count>0 or blank_key_count>0 as incomplete,
   coalesce(part_count>26,false) as too_many_parts
 from checks
)
select subject_key,count(*) published_versions,
 count(*) filter(where part_count>0) multipart_versions,
 count(*) filter(where incomplete) incomplete_versions,
 count(*) filter(where too_many_parts) over_26_parts,
 count(*) filter(where long_key_count>0) over_80char_key_versions,
 count(*) filter(where empty_primary_nonempty_fallback) empty_primary_nonempty_fallback,
 coalesce(jsonb_agg(jsonb_build_object('version_id',id,'content_key',content_key,
   'item_type',item_type,'part_count',part_count,'wrong_shape',wrong_shape,
   'bad_parts',bad_part_count,'duplicate_keys',duplicate_key_count,
   'long_keys',long_key_count,'empty_primary_nonempty_fallback',empty_primary_nonempty_fallback))
   filter(where incomplete or too_many_parts or long_key_count>0 or empty_primary_nonempty_fallback),'[]'::jsonb) affected
from flags group by subject_key order by subject_key;
