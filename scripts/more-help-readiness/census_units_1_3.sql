-- Read-only census for the More help rollout: published questions in each subject's
-- FIRST THREE units (the three lowest unit numbers in that subject's taxonomy, so
-- Physics 2 resolves to 9-11 and Physics C E&M to 8-10). Run against Production.
-- Counts latest published version per content item, using the question RPC's active
-- cell rule (primary first, then created_at). Content counts, not learner counts, and
-- NOT proof of serving eligibility (authored-parts completeness and visual grounding
-- are checked at request time). Nothing here enables a subject or unit.
-- Shortfall rule (owner request 2026-10-16): a subject/unit is short when it has
-- fewer than 3 usable MCQs OR fewer than 1 usable FRQ. 'usable' = published, topic
-- tagged, has published reference grounding. Images are counted separately.
with latest as (
  select distinct on (ci.id) ci.id as item_id, ci.item_type, v.id as vid, v.stimulus_image_path,
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
), checked as (
  select q.*, fu.unit_rank,
    exists (
      select 1 from app.unit_reference_entries r
      where r.status = 'published' and q.topic_code = any(r.topic_codes)
        and nullif(r.body, '') is not null
        and (r.subject_key = q.reference_subject
          or exists (
            select 1 from app.subject_reference_aliases a
            where a.subject_key = q.reference_subject and a.source_subject_key = r.subject_key
              and r.unit_number between a.unit_from and a.unit_to))
    ) as has_reference
  from q join first_units fu on fu.subject_key = q.subject_key and fu.unit_number = q.unit_number
  where fu.unit_rank <= 3
), cells as (
  select subject_key, unit_number,
    count(*) filter (where item_type = 'mcq') as mcq_published,
    count(*) filter (where item_type = 'frq') as frq_published,
    count(*) filter (where item_type = 'mcq' and has_reference) as mcq_usable,
    count(*) filter (where item_type = 'frq' and has_reference) as frq_usable,
    count(*) filter (where stimulus_image_path is not null) as image_bearing,
    count(*) filter (where not has_reference) as missing_reference
  from checked group by subject_key, unit_number
)
select subject_key, unit_number, mcq_published, mcq_usable, frq_published, frq_usable,
  image_bearing, missing_reference,
  case when mcq_usable < 3 and frq_usable < 1 then 'SHORT: MCQ and FRQ'
       when mcq_usable < 3 then 'SHORT: MCQ'
       when frq_usable < 1 then 'SHORT: FRQ' else 'ok' end as status
from cells order by subject_key, unit_number;
-- Companion (run separately): questions with no resolvable unit, i.e. excluded above.
-- select subject_key, count(*) from q where unit_number is null group by 1 order by 1;
