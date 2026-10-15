-- Read-only Production inventory. Published versions, not serving eligibility
-- certification or failed student-request counts. No student/session data read.
-- Mirror the question RPC's selected active cell (primary first, then created_at).
with questions as (
  select v.id, s.subject_key, replace(s.subject_key, '-', '_') as reference_subject,
    v.stimulus_image_path, cell.topic_code, cell.unit_number
  from app.content_items ci
  join app.content_item_versions v on v.content_item_id = ci.id
  join app.exam_pack_versions epv on epv.id = ci.exam_pack_version_id
  join app.exam_packs ep on ep.id = epv.exam_pack_id
  join app.subjects s on s.id = ep.subject_id
  left join lateral (
    select cc.topic_code, tt.unit_number
    from app.content_item_cells cc
    left join app.taxonomy_topics tt
      on tt.taxonomy_source_version = cc.taxonomy_source_version
     and tt.topic_code = cc.topic_code
    where cc.content_item_version_id = v.id and cc.superseded_by is null
    order by cc.is_primary desc nulls last, cc.created_at
    limit 1
  ) cell on true
  where ci.status = 'published' and v.status = 'published'
    and s.subject_key in ('ap-calculus-ab', 'ap-calculus-bc', 'ap-chemistry')
), checked as (
  select q.*, exists (
    select 1 from app.unit_reference_entries r
    where r.status = 'published' and q.topic_code = any(r.topic_codes)
      and nullif(r.body, '') is not null
      and (
        r.subject_key = q.reference_subject
        or exists (
          select 1 from app.subject_reference_aliases a
          where a.subject_key = q.reference_subject
            and a.source_subject_key = r.subject_key
            and r.unit_number between a.unit_from and a.unit_to
            and exists (
              select 1 from app.taxonomy_topics owner_topic
              where owner_topic.topic_code = r.owner_topic_code
                and owner_topic.taxonomy_source_version = (
                  select tsv.taxonomy_source_version
                  from app.taxonomy_source_versions tsv
                  where tsv.subject_key = q.reference_subject
                  order by tsv.verified_at desc nulls last, tsv.created_at desc
                  limit 1
                )
            )
        )
      )
  ) as has_reference
  from questions q
)
select subject_key, unit_number, count(*) as published_versions,
  count(*) filter (where not has_reference) as missing_reference,
  count(*) filter (where not has_reference and stimulus_image_path is null)
    as missing_reference_without_image,
  count(*) filter (where topic_code is null) as no_topic
from checked
group by subject_key, unit_number
order by subject_key, unit_number;
