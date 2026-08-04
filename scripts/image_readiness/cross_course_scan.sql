-- TASK-0020 cheap cross-course image-readiness scan.
-- READ ONLY: every statement in this file is SELECT-only.
-- Production snapshot first executed 2026-08-03 against pcntajvbdfqhbeewmdry.

-- Query 1: aggregate candidate exposure by course.
with latest as (
  select distinct on (civ.content_item_id)
    civ.id as content_item_version_id,
    civ.content_item_id,
    civ.version_num,
    civ.status as version_status,
    civ.stem,
    civ.stimulus,
    coalesce(civ.prompt_json, '{}'::jsonb) as prompt_json,
    nullif(btrim(civ.stimulus_image_path), '') as stimulus_image_path
  from app.content_item_versions civ
  order by civ.content_item_id, civ.version_num desc, civ.created_at desc
),
base as (
  select
    s.subject_key,
    s.display_name as subject_name,
    ep.exam_code,
    ep.exam_name,
    ci.id as content_item_id,
    ci.content_key,
    ci.item_type,
    ci.status as item_status,
    ci.practice_format,
    l.version_status,
    (l.stimulus_image_path is not null) as has_image_path,
    (
      l.prompt_json ?| array[
        'stimulus_table', 'stimuli', 'expected_graph_spec'
      ]
    ) as has_structured_visual_marker,
    (
      concat_ws(' ', ci.title, l.stem, l.stimulus) ~*
      '\m(figure|image|diagram|graph|chart|plot|scatterplot|histogram|boxplot|dotplot|residual plot|tree diagram|display|table|map|shown above|shown below)\M'
    ) as has_visual_language,
    (
      lower(coalesce(l.prompt_json->>'hand_drawn', 'false')) = 'true'
      or l.prompt_json ? 'capture_instruction'
      or l.prompt_json ? 'expected_graph_spec'
      or ci.content_key ~* '(^|[-_])HDG([-_]|$)'
      or coalesce(ci.frq_archetype, '') ~* '(hand.?drawn|graph)'
      or concat_ws(' ', ci.title, l.stem, l.stimulus) ~*
        '\m(draw|sketch|construct|create|plot)\M.{0,60}\m(graph|diagram|curve|histogram|scatterplot|boxplot|dotplot)\M'
    ) as has_drawn_response_marker
  from app.content_items ci
  join latest l on l.content_item_id = ci.id
  join app.exam_pack_versions epv on epv.id = ci.exam_pack_version_id
  join app.exam_packs ep on ep.id = epv.exam_pack_id
  join app.subjects s on s.id = ep.subject_id
)
select
  subject_key,
  subject_name,
  exam_code,
  exam_name,
  count(*) as latest_items,
  count(*) filter (
    where item_status = 'published' and version_status = 'published'
  ) as published_latest,
  count(*) filter (where has_image_path) as image_path_any_status,
  count(*) filter (
    where item_status = 'published' and version_status = 'published'
      and has_image_path
  ) as image_path_published,
  count(*) filter (
    where item_status = 'published' and version_status = 'published'
      and has_structured_visual_marker
  ) as structured_visual_marker_published,
  count(*) filter (
    where item_status = 'published' and version_status = 'published'
      and has_visual_language
  ) as visual_language_published,
  count(*) filter (
    where item_status = 'published' and version_status = 'published'
      and has_drawn_response_marker
  ) as drawn_response_marker_published,
  count(*) filter (
    where item_status = 'published' and version_status = 'published'
      and (has_image_path or has_structured_visual_marker or has_visual_language)
      and has_drawn_response_marker
  ) as prompt_visual_and_drawn_overlap_published,
  count(*) filter (
    where item_status = 'published' and version_status = 'published'
      and has_visual_language
      and not has_image_path
      and not has_structured_visual_marker
  ) as possible_missing_visual_or_context_published
from base
group by subject_key, subject_name, exam_code, exam_name
order by subject_name, exam_code;

-- Query 2: storage metadata completeness for latest image-path references.
with latest as (
  select distinct on (civ.content_item_id)
    civ.content_item_id,
    civ.status as version_status,
    nullif(btrim(civ.stimulus_image_path), '') as stimulus_image_path
  from app.content_item_versions civ
  order by civ.content_item_id, civ.version_num desc, civ.created_at desc
),
refs as (
  select distinct
    ci.status as item_status,
    l.version_status,
    l.stimulus_image_path
  from app.content_items ci
  join latest l on l.content_item_id = ci.id
  where l.stimulus_image_path is not null
)
select
  count(*) as distinct_latest_reference_rows,
  count(*) filter (where o.id is not null) as found_in_content_assets,
  count(*) filter (where o.id is null) as missing_from_content_assets,
  count(*) filter (
    where r.item_status = 'published' and r.version_status = 'published'
  ) as published_reference_rows,
  count(*) filter (
    where r.item_status = 'published' and r.version_status = 'published'
      and o.id is not null
  ) as published_found
from refs r
left join storage.objects o
  on o.bucket_id = 'content-assets'
  and o.name = r.stimulus_image_path;

-- Query 3: published counts by course, item type, and FRQ serving format.
with latest as (
  select distinct on (civ.content_item_id)
    civ.content_item_id,
    civ.status as version_status,
    civ.stem,
    civ.stimulus,
    coalesce(civ.prompt_json, '{}'::jsonb) as prompt_json,
    nullif(btrim(civ.stimulus_image_path), '') as stimulus_image_path
  from app.content_item_versions civ
  order by civ.content_item_id, civ.version_num desc, civ.created_at desc
)
select
  s.display_name as subject_name,
  epv.status as exam_pack_version_status,
  ci.practice_format,
  ci.item_type,
  count(*) as published_latest_count,
  count(*) filter (
    where l.stimulus_image_path is not null
      or l.prompt_json ?| array[
        'stimulus_table', 'stimuli', 'expected_graph_spec'
      ]
      or concat_ws(' ', ci.title, l.stem, l.stimulus) ~*
        '\m(figure|image|diagram|graph|chart|plot|scatterplot|histogram|boxplot|dotplot|residual plot|tree diagram|display|table|map|shown above|shown below)\M'
  ) as prompt_visual_candidate_count,
  count(*) filter (
    where lower(coalesce(l.prompt_json->>'hand_drawn', 'false')) = 'true'
      or l.prompt_json ? 'capture_instruction'
      or l.prompt_json ? 'expected_graph_spec'
      or ci.content_key ~* '(^|[-_])HDG([-_]|$)'
  ) as explicit_drawn_candidate_count
from app.content_items ci
join latest l on l.content_item_id = ci.id
join app.exam_pack_versions epv on epv.id = ci.exam_pack_version_id
join app.exam_packs ep on ep.id = epv.exam_pack_id
join app.subjects s on s.id = ep.subject_id
where ci.status = 'published' and l.version_status = 'published'
group by s.display_name, epv.status, ci.practice_format, ci.item_type
order by s.display_name, ci.item_type, ci.practice_format nulls first;
