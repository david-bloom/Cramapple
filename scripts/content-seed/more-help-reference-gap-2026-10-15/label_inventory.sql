-- Read-only inventory for the separate topic-linkage repair; no promotion or content writes.
-- Metadata, authored hints and full prompts are inputs to review, never validation decisions.
with latest_taxonomy as (
  select distinct on (subject_key) subject_key, taxonomy_source_version
  from app.taxonomy_source_versions
  where subject_key in ('ap_calculus_ab','ap_calculus_bc','ap_chemistry')
  order by subject_key, verified_at desc nulls last, created_at desc
), missing as (
  select s.subject_key, v.id as version_id, v.content_item_id, v.version_num,
    v.stem, v.stimulus, v.prompt_json, v.canonical_answer_1, v.canonical_answer_2,
    v.item_package_payload, v.stimulus_image_path,
    app.taxonomy_relevant_hash(v.id) as current_taxonomy_relevant_hash
  from app.content_items ci
  join app.content_item_versions v on v.content_item_id=ci.id
  join app.exam_pack_versions epv on epv.id=ci.exam_pack_version_id
  join app.exam_packs ep on ep.id=epv.exam_pack_id
  join app.subjects s on s.id=ep.subject_id
  where ci.status='published' and v.status='published'
    and s.subject_key in ('ap-calculus-ab','ap-calculus-bc','ap-chemistry')
    and not exists (
      select 1 from app.content_item_cells c
      where c.content_item_version_id=v.id and c.superseded_by is null
    )
)
select m.*, lt.taxonomy_source_version as current_target_taxonomy,
  labels.active_labels,
  (select count(*) from app.content_item_topic_resolution tr
    where tr.content_item_version_id=m.version_id) as existing_resolution_count,
  (select count(*) from app.content_item_cells c
    where c.content_item_id=m.content_item_id and c.assignment_status='validated'
      and c.superseded_by is null) as same_item_validated_cell_count,
  (select jsonb_agg(jsonb_build_object(
      'topic',c.topic_code,'source_taxonomy',c.taxonomy_source_version,
      'version',c.content_item_version_id,'source',c.source,'validated_at',c.validated_at))
    from app.content_item_cells c
    where c.content_item_id=m.content_item_id) as historical_cell_evidence
from missing m
join latest_taxonomy lt on lt.subject_key=replace(m.subject_key,'-','_')
left join lateral (
  select jsonb_agg(jsonb_build_object(
    'label_id',l.content_taxonomy_label_id,'scope',l.label_scope,'status',l.label_status,
    'required_units',l.required_units,'assessed_topics',l.assessed_topics,
    'validated_version',l.validated_against_version_id,
    'validated_hash',l.validated_against_taxo_hash,
    'hash_fresh',l.validated_against_taxo_hash=m.current_taxonomy_relevant_hash,
    'source',l.source,'source_payload',l.source_payload)) as active_labels
  from app.content_taxonomy_labels l
  where l.content_item_id=m.content_item_id and l.superseded_by is null
) labels on true
order by m.subject_key,m.content_item_id,m.version_num;
