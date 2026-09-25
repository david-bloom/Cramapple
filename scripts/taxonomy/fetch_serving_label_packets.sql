-- Extracted from scripts/taxonomy/extend_math_serving_labels.mjs's fetchPackets() (2026-09-25), for
-- running via the Supabase MCP execute_sql tool against Production instead of `supabase db query
-- --linked` (which points at Dev). Run this, save the single `packets` column's text value to a
-- packets.json file, then pass it to extend_serving_labels_mcp.mjs via --packets-file=.
--
-- To scope to one subject before running (recommended -- the full packet payload for all ten subjects
-- is large), add `and ep.exam_code = 'ap_chemistry'` (or the relevant exam_code) to the outer where
-- clause below.

with latest as (
  select distinct on (civ.content_item_id)
    civ.*
  from app.content_item_versions civ
  order by civ.content_item_id, civ.version_num desc
), target as (
  select
    ep.exam_code,
    epv.id as exam_pack_version_id,
    ci.id as content_item_id,
    ci.content_key,
    ci.title,
    ci.status as content_status,
    ci.item_type,
    ci.frq_form,
    ci.practice_format,
    latest.id as content_item_version_id,
    latest.version_num,
    latest.status as version_status,
    latest.published_at,
    latest.stem,
    latest.stimulus,
    latest.stimulus_image_path,
    coalesce(latest.prompt_json, '{}'::jsonb) - 'modules' - 'subtopics' as prompt_json_without_legacy_taxonomy,
    latest.canonical_answer_1,
    latest.canonical_answer_2,
    app.taxonomy_relevant_hash(latest.id) as taxonomy_relevant_hash,
    (
      select coalesce(jsonb_agg(jsonb_build_object(
        'choice_key', mc.choice_key,
        'choice_text', mc.choice_text,
        'is_correct', mc.is_correct,
        'rationale', mc.rationale
      ) order by mc.choice_key), '[]'::jsonb)
      from app.mcq_choices mc
      where mc.content_item_version_id = latest.id
    ) as mcq_choices,
    (
      select coalesce(jsonb_agg(jsonb_build_object(
        'criterion_key', fc.criterion_key,
        'learner_facing_text', fc.learner_facing_text,
        'points_possible', fc.points_possible,
        'evidence_requirements', fc.evidence_requirements,
        'minimum_fix', fc.minimum_fix
      ) order by fc.criterion_key), '[]'::jsonb)
      from app.frq_criteria fc
      where fc.content_item_version_id = latest.id
    ) as frq_criteria,
    tsv.taxonomy_source_version,
    legacy.label_status as legacy_label_status,
    legacy.required_units as legacy_required_units,
    legacy.max_required_unit as legacy_max_required_unit,
    legacy.primary_unit as legacy_primary_unit,
    legacy.source as legacy_source,
    legacy.source_payload as legacy_source_payload
  from app.exam_packs ep
  join app.exam_pack_versions epv on epv.exam_pack_id = ep.id
  join app.content_items ci on ci.exam_pack_version_id = epv.id
  join latest on latest.content_item_id = ci.id
  join app.taxonomy_source_versions tsv
    on tsv.subject_key = ep.exam_code
   and tsv.taxonomy_confidence = 'verified'
  left join lateral (
    select
      ctl.label_status,
      ctl.required_units,
      ctl.max_required_unit,
      ctl.primary_unit,
      ctl.source,
      ctl.source_payload
    from app.content_taxonomy_labels ctl
    where ctl.content_item_id = ci.id
      and ctl.label_scope = 'serving'
      and ctl.superseded_by is null
      and ctl.label_status = 'legacy_unvalidated'
    order by ctl.label_version desc, ctl.created_at desc
    limit 1
  ) legacy on true
  where ep.exam_code in ('ap_biology', 'ap_chemistry', 'ap_physics_1', 'ap_physics_2', 'ap_physics_c_mechanics', 'ap_physics_c_em', 'ap_statistics', 'ap_calculus_ab', 'ap_calculus_bc', 'ap_precalculus')
    and (
      (
        ep.exam_code in ('ap_biology', 'ap_chemistry', 'ap_physics_1', 'ap_physics_2', 'ap_physics_c_mechanics', 'ap_physics_c_em', 'ap_statistics')
        and ci.status = 'published'
        and latest.status = 'published'
      )
      or (
        ep.exam_code in ('ap_calculus_ab', 'ap_calculus_bc', 'ap_precalculus')
        and ci.status in ('published', 'reviewed_approved')
        and latest.status in ('published', 'reviewed_approved')
      )
    )
)
select coalesce(jsonb_agg(to_jsonb(target) order by exam_code, content_key), '[]'::jsonb)::text as packets
from target;
