-- Export current, published serving-label candidates for one subject.
--
-- Replace __SUBJECT__ with one exact exam_code before execution. This query intentionally excludes
-- current validated, provisional_model, and held labels. It targets only missing, stale, or
-- legacy_unvalidated serving labels and emits the packet shape consumed by
-- extend_serving_labels_mcp.mjs.

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
    coalesce(latest.prompt_json, '{}'::jsonb) - 'modules' - 'subtopics'
      as prompt_json_without_legacy_taxonomy,
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
    current_label.label_status as legacy_label_status,
    current_label.required_units as legacy_required_units,
    current_label.max_required_unit as legacy_max_required_unit,
    current_label.primary_unit as legacy_primary_unit,
    current_label.source as legacy_source,
    current_label.source_payload as legacy_source_payload
  from app.exam_packs ep
  join app.exam_pack_versions epv on epv.exam_pack_id = ep.id
  join app.content_items ci on ci.exam_pack_version_id = epv.id
  join latest on latest.content_item_id = ci.id
  join app.taxonomy_source_versions tsv
    on tsv.subject_key = ep.exam_code
   and tsv.taxonomy_confidence = 'verified'
  left join lateral (
    select ctl.*
    from app.content_taxonomy_labels ctl
    where ctl.content_item_id = ci.id
      and ctl.label_scope = 'serving'
      and ctl.superseded_by is null
    order by ctl.label_version desc, ctl.created_at desc
    limit 1
  ) current_label on true
  where ep.exam_code = '__SUBJECT__'
    and epv.status = 'published'
    and epv.retired_at is null
    and ci.status = 'published'
    and latest.status = 'published'
    and (
      current_label.content_taxonomy_label_id is null
      or current_label.label_status in ('legacy_unvalidated', 'stale')
    )
)
select coalesce(jsonb_agg(to_jsonb(target) order by content_key), '[]'::jsonb) as packets
from target;
