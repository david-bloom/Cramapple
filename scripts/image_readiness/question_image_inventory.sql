-- WORK-QUESTION-IMAGE-COMPLETENESS: READ ONLY, one row per published version.
-- Deliberately inventories every published version, not just latest-version rows.
-- No answer keys, rationales, expected graphs, learner records or signed URLs.
-- Markers are triage signals, NEVER an image-required classification.
with versions as (
  select ci.id as content_item_id, ci.content_key, ci.item_type,
    ci.practice_format, ci.title, v.id as content_item_version_id,
    v.version_num, v.stem, v.stimulus, v.prompt_json,
    v.item_package_payload, v.stimulus_image_path,
    s.subject_key, s.display_name as subject_name,
    epv.id as exam_pack_version_id, epv.status as pack_status,
    epv.retired_at as pack_retired_at,
    not exists (select 1 from app.content_item_versions newer
      where newer.content_item_id = ci.id
        and (newer.version_num, newer.created_at, newer.id) >
            (v.version_num, v.created_at, v.id)) as is_latest_version,
    exists (select 1 from app.open_hand_teaching_items t
      where t.content_item_id = ci.id and t.released_at is null) as teaching_designated
  from app.content_items ci
  join app.content_item_versions v on v.content_item_id = ci.id
  join app.exam_pack_versions epv on epv.id = ci.exam_pack_version_id
  join app.exam_packs ep on ep.id = epv.exam_pack_id
  join app.subjects s on s.id = ep.subject_id
  where ci.status = 'published' and v.status = 'published'
), bodies as (
  select v.*, vr.image_needed, vr.image_approval,
    coalesce((select jsonb_agg(jsonb_build_object(
      'key', c.choice_key, 'text', c.choice_text) order by c.choice_key)
      from app.mcq_choices c where c.content_item_version_id = v.content_item_version_id),
      '[]'::jsonb) as choices,
    coalesce((select jsonb_agg(jsonb_build_object(
      'key', f.criterion_key, 'text', f.learner_facing_text) order by f.criterion_key)
      from app.frq_criteria f where f.content_item_version_id = v.content_item_version_id
        and nullif(btrim(f.learner_facing_text), '') is not null), '[]'::jsonb) as part_prompts,
    coalesce((select jsonb_agg(jsonb_build_object(
      'bucket', a.storage_bucket, 'path', a.storage_path,
      'alt', a.alt_text, 'long_description', a.long_description,
      'approved', a.approved_at is not null,
      'object_present', exists (select 1 from storage.objects o
        where o.bucket_id = a.storage_bucket and o.name = a.storage_path))
      order by a.storage_bucket,a.storage_path)
      from app.content_asset_metadata a
      where a.content_item_version_id = v.content_item_version_id), '[]'::jsonb) as assets,
    coalesce((select jsonb_agg(jsonb_build_object(
      'figure_id', u.figure_id, 'role', u.role, 'status', f.status, 'family', f.family)
      order by u.figure_id,u.role)
      from app.figure_uses u join app.figures f on f.figure_id = u.figure_id
      where u.question_version_id = v.content_item_version_id), '[]'::jsonb) as question_figures
  from versions v left join app.content_visual_requirements vr
    on vr.content_item_version_id = v.content_item_version_id
), marked as (
  select b.*, concat_ws(' ',stem,stimulus,choices::text,part_prompts::text) as visible_text
  from bodies b
)
select subject_key,subject_name,content_key,content_item_id,content_item_version_id,
  version_num,item_type,practice_format,exam_pack_version_id,pack_status,
  pack_retired_at,is_latest_version,teaching_designated,
  stem,stimulus,choices,part_prompts,
  -- Only presentation subtrees: prompt/package objects can contain answer keys.
  prompt_json->'stimuli' as legacy_stimuli,
  prompt_json->'stimulus_table' as legacy_stimulus_table,
  item_package_payload->'stimuli' as package_stimuli,
  stimulus_image_path,image_needed,image_approval,assets,question_figures,
  case when nullif(btrim(stimulus_image_path),'') is null then null else
    exists (select 1 from storage.objects o where o.bucket_id='content-assets'
      and o.name=marked.stimulus_image_path) end as path_object_present,
  visible_text ~* '\m(figure|image|diagram|graph|chart|plot|scatterplot|histogram|boxplot|dotplot|pedigree|phylogenetic|circuit|spectrum|micrograph|table|map)\M'
    as visual_language_signal,
  visible_text ~* '(shown|pictured|illustrated|depicted) (above|below)|following (graph|diagram|figure)|the (figure|diagram|graph) (shows|depicts)'
    as explicit_reference_signal,
  visible_text ~* '\m(draw|sketch|construct|create|plot)\M.{0,60}\m(graph|diagram|curve|histogram|scatterplot|boxplot|dotplot)\M'
    as construction_signal,
  md5(jsonb_build_object('stem',stem,'stimulus',stimulus,'choices',choices,
    'parts',part_prompts,'prompt',prompt_json,'package',item_package_payload,
    'image_path',stimulus_image_path)::text) as audit_content_digest
from marked order by subject_name,content_key,version_num;
