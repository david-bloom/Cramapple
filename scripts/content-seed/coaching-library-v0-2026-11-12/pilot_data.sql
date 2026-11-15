-- Coaching library v0, Layer 3 pilot selection (read-only). Deterministic: md5 seed 'pilot1'.
-- Fix over the exploratory query: ONE distractor per item FAMILY (content_key minus trailing -vN),
-- and the held-out split is by family, so near-duplicate variants never straddle the split.
with d as (
  select s.subject_key, ci.content_key,
         regexp_replace(lower(ci.content_key),'-v[0-9]+$','') family,
         v.version_num, m.choice_key,
         (v.stimulus is not null or v.stimulus_image_path is not null) has_stim,
         case when length(m.rationale)<60 then 'thin' when length(m.rationale)<120 then 'short'
              when length(m.rationale)<240 then 'mid' else 'long' end bucket,
         md5(m.id::text||'pilot1') h
  from app.content_items ci
  join app.exam_pack_versions epv on epv.id=ci.exam_pack_version_id and epv.retired_at is null
  join app.exam_packs ep on ep.id=epv.exam_pack_id
  join app.subjects s on s.id=ep.subject_id and s.subject_key in ('biology','ap-statistics')
  join app.content_item_versions v on v.content_item_id=ci.id and v.status='published'
  join app.mcq_choices m on m.content_item_version_id=v.id and not m.is_correct
  where ci.item_type='mcq' and ci.status='published'
), one as (select *, row_number() over (partition by family order by h) r from d),
r as (select *, row_number() over (partition by subject_key, bucket order by h) rb from one where r=1),
q as (select * from r where
  (subject_key='ap-statistics' and ((bucket='thin' and rb<=25) or (bucket='short' and rb<=40) or (bucket='mid' and rb<=28) or (bucket='long' and rb<=7)))
  or (subject_key='biology' and ((bucket='thin' and rb<=1) or (bucket='short' and rb<=49) or (bucket='mid' and rb<=30) or (bucket='long' and rb<=20))))
select json_agg(json_build_object(
  'subject', q.subject_key, 'item', q.content_key, 'family', q.family, 'version', q.version_num,
  'target', q.choice_key, 'bucket', q.bucket, 'has_stim', q.has_stim,
  'held_out', (('x'||substr(md5(q.family||'split1'),1,8))::bit(32)::int % 3 = 0),
  'stem', v.stem, 'stimulus', v.stimulus, 'image_stim', (v.stimulus_image_path is not null),
  'choices', (select json_agg(json_build_object('k',m.choice_key,'t',m.choice_text,'ok',m.is_correct,'r',m.rationale) order by m.choice_key) from app.mcq_choices m where m.content_item_version_id=v.id)
) order by q.subject_key, q.h) as items
from q
join app.content_items ci on ci.content_key=q.content_key
join app.content_item_versions v on v.content_item_id=ci.id and v.status='published' and v.version_num=q.version_num;
