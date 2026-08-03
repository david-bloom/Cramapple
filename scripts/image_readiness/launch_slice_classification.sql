-- TASK-0020 launch-slice semantic-classification support queries.
-- READ ONLY: every statement in this file is SELECT-only.
-- Production snapshot first executed 2026-08-03 against pcntajvbdfqhbeewmdry.

-- The locked slice is every published AP Biology FRQ plus every published
-- AP Statistics targeted-drill FRQ, using each item's latest version.
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
  s.display_name as course,
  ci.content_key,
  ci.practice_format,
  (l.stimulus_image_path is not null) as has_stored_image,
  (l.prompt_json ? 'stimulus_table') as has_structured_table,
  (l.prompt_json ? 'expected_graph_spec') as has_graph_spec,
  (lower(coalesce(l.prompt_json->>'hand_drawn', 'false')) = 'true') as hand_drawn,
  (
    concat_ws(' ', ci.title, l.stem, l.stimulus) ~*
    '\m(figure|image|diagram|graph|chart|plot|scatterplot|histogram|boxplot|dotplot|residual plot|tree diagram|display|table|map|shown above|shown below)\M'
  ) as has_visual_or_data_language
from app.content_items ci
join latest l on l.content_item_id = ci.id
join app.exam_pack_versions epv on epv.id = ci.exam_pack_version_id
join app.exam_packs ep on ep.id = epv.exam_pack_id
join app.subjects s on s.id = ep.subject_id
where ci.status = 'published'
  and l.version_status = 'published'
  and ci.item_type = 'frq'
  and (
    s.display_name = 'AP Biology'
    or (
      s.display_name = 'AP Statistics'
      and ci.practice_format = 'targeted_drill'
    )
  )
order by course, ci.content_key;

-- Archetype coverage for the structured hand-drawn subset.
with latest as (
  select distinct on (civ.content_item_id)
    civ.content_item_id,
    civ.status as version_status,
    coalesce(civ.prompt_json, '{}'::jsonb) as prompt_json
  from app.content_item_versions civ
  order by civ.content_item_id, civ.version_num desc, civ.created_at desc
)
select
  s.display_name as course,
  coalesce(l.prompt_json->>'archetype', ci.frq_archetype, '(none)') as archetype,
  count(*) as item_count,
  count(*) filter (where l.prompt_json ? 'stimulus_table') as with_table,
  count(*) filter (where l.prompt_json ? 'expected_graph_spec') as with_graph_spec,
  count(*) filter (
    where lower(coalesce(l.prompt_json->>'hand_drawn', 'false')) = 'true'
  ) as hand_drawn
from app.content_items ci
join latest l on l.content_item_id = ci.id
join app.exam_pack_versions epv on epv.id = ci.exam_pack_version_id
join app.exam_packs ep on ep.id = epv.exam_pack_id
join app.subjects s on s.id = ep.subject_id
where ci.status = 'published'
  and l.version_status = 'published'
  and ci.item_type = 'frq'
  and (
    s.display_name = 'AP Biology'
    or (
      s.display_name = 'AP Statistics'
      and ci.practice_format = 'targeted_drill'
    )
  )
group by course, archetype
order by course, archetype;
