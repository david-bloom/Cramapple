-- APPROVAL-0051 / DECISION-0066: promote fresh single-unit agreements for ap_physics_c_em.
-- Multi-unit agreements remain provisional pending independent third review.

begin;

create temporary table tmp_subject_single_unit_promotions on commit drop as
select
  ctl.content_taxonomy_label_id,
  civ.id as content_item_version_id,
  ctl.validated_against_taxo_hash as generation_taxonomy_hash,
  gen_random_uuid() as validation_decision_id,
  ctl.primary_unit,
  ctl.required_units
from app.content_taxonomy_labels ctl
join app.content_items ci on ci.id = ctl.content_item_id
join app.exam_pack_versions epv on epv.id = ci.exam_pack_version_id
join app.exam_packs ep on ep.id = epv.exam_pack_id
join lateral (
  select v.id, v.status
  from app.content_item_versions v
  where v.content_item_id = ci.id
  order by v.version_num desc
  limit 1
) civ on true
where ep.exam_code = 'ap_physics_c_em'
  and ctl.model_run_id = 'serving-units-mcp-2026-09-25-20260927113404'
  and ctl.superseded_by is null
  and ctl.label_status = 'provisional_model'
  and ctl.source = 'vercel_ai_gateway_two_model_serving_lane'
  and ctl.source_payload->>'reason' like 'two_model_%'
  and cardinality(ctl.required_units) = 1
  and ci.status = 'published'
  and epv.status = 'published'
  and epv.retired_at is null
  and civ.status = 'published'
  and ctl.validated_against_version_id = civ.id
  and ctl.validated_against_taxo_hash = app.taxonomy_relevant_hash(civ.id);

do $$
declare v_count integer;
begin
  select count(*) into v_count from tmp_subject_single_unit_promotions;
  if v_count <> 71 then
    raise exception 'ap_physics_c_em single-unit promotion drift: expected 71, found %', v_count;
  end if;
end $$;

insert into app.content_taxonomy_validation_decisions (
  validation_decision_id, content_taxonomy_label_id, decided_by, decided_at,
  decision, decision_source, reviewed_primary_unit, reviewed_required_units, notes
)
select
  validation_decision_id,
  content_taxonomy_label_id,
  'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,
  now(),
  'confirmed',
  'automated_spot_check',
  primary_unit,
  required_units,
  'APPROVAL-0051 / DECISION-0066: exact current-version and generation-hash match; fresh single-unit two-model agreement. Multi-unit labels excluded pending independent third review.'
from tmp_subject_single_unit_promotions;

update app.content_taxonomy_labels ctl
set
  label_status = 'validated',
  validation_decision_id = p.validation_decision_id,
  validated_by = 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,
  validated_at = now()
from tmp_subject_single_unit_promotions p
where ctl.content_taxonomy_label_id = p.content_taxonomy_label_id;

do $$
declare v_count integer;
begin
  select count(*) into v_count
  from app.content_taxonomy_labels ctl
  join tmp_subject_single_unit_promotions p
    on p.content_taxonomy_label_id = ctl.content_taxonomy_label_id
  where ctl.label_status = 'validated'
    and ctl.validation_decision_id = p.validation_decision_id
    and ctl.validated_against_version_id = p.content_item_version_id
    and ctl.validated_against_taxo_hash = p.generation_taxonomy_hash;
  if v_count <> 71 then
    raise exception 'ap_physics_c_em single-unit promotion verification failed: expected 71, found %', v_count;
  end if;
end $$;

commit;
