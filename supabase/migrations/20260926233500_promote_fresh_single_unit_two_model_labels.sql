-- DECISION-0066: promote only current-live, single-unit, two-model agreements
-- whose stored generation-time taxonomy hash matches the current published version.
--
-- Multi-unit agreements are deliberately excluded: they require a genuinely
-- independent third review. Timestamp ordering is not freshness evidence; the
-- exact generation hash and current version identity are both required.

begin;

create temporary table _fresh_single_unit_promotions on commit drop as
select
  ctl.content_taxonomy_label_id,
  civ.id as content_item_version_id,
  app.taxonomy_relevant_hash(civ.id) as taxonomy_relevant_hash,
  gen_random_uuid() as validation_decision_id,
  ctl.primary_unit,
  ctl.required_units
from app.subjects s
join app.exam_packs ep
  on ep.subject_id = s.id
join app.exam_pack_versions epv
  on epv.exam_pack_id = ep.id
 and epv.status = 'published'
 and epv.retired_at is null
join app.content_items ci
  on ci.exam_pack_version_id = epv.id
 and ci.status = 'published'
join lateral (
  select v.*
  from app.content_item_versions v
  where v.content_item_id = ci.id
  order by v.version_num desc
  limit 1
) civ
  on civ.status = 'published'
join app.content_taxonomy_labels ctl
  on ctl.content_item_id = ci.id
 and ctl.label_scope = 'serving'
 and ctl.superseded_by is null
where ctl.label_status = 'provisional_model'
  and ctl.source = 'vercel_ai_gateway_two_model_serving_lane'
  and ctl.source_payload->>'reason' like 'two_model_%'
  and cardinality(ctl.required_units) = 1
  and ctl.validated_against_version_id = civ.id
  and ctl.validated_against_taxo_hash = app.taxonomy_relevant_hash(civ.id);

do $$
declare
  v_count integer;
begin
  select count(*) into v_count from _fresh_single_unit_promotions;
  if v_count <> 216 then
    raise exception
      'DECISION-0066 promotion drift: expected 216 fresh single-unit candidates, found %',
      v_count;
  end if;
end $$;

insert into app.content_taxonomy_validation_decisions (
  validation_decision_id,
  content_taxonomy_label_id,
  decided_by,
  decided_at,
  decision,
  decision_source,
  reviewed_primary_unit,
  reviewed_required_units,
  notes
)
select
  p.validation_decision_id,
  p.content_taxonomy_label_id,
  'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,
  now(),
  'confirmed',
  'automated_spot_check',
  p.primary_unit,
  p.required_units,
  'DECISION-0066 batch: fresh single-unit agreement from the approved GPT-5.5 + Gemini-2.5-flash serving-label lane. Multi-unit and generation-hash-mismatched labels excluded.'
from _fresh_single_unit_promotions p;

update app.content_taxonomy_labels ctl
set
  label_status = 'validated',
  validation_decision_id = p.validation_decision_id,
  validated_by = 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,
  validated_at = now(),
  validated_against_version_id = p.content_item_version_id,
  validated_against_taxo_hash = p.taxonomy_relevant_hash
from _fresh_single_unit_promotions p
where ctl.content_taxonomy_label_id = p.content_taxonomy_label_id;

do $$
declare
  v_promoted integer;
begin
  select count(*) into v_promoted
  from app.content_taxonomy_labels ctl
  join _fresh_single_unit_promotions p
    on p.content_taxonomy_label_id = ctl.content_taxonomy_label_id
  where ctl.label_status = 'validated'
    and ctl.validation_decision_id = p.validation_decision_id
    and ctl.validated_against_version_id = p.content_item_version_id
    and ctl.validated_against_taxo_hash = p.taxonomy_relevant_hash;

  if v_promoted <> 216 then
    raise exception
      'DECISION-0066 promotion verification failed: expected 216, found %',
      v_promoted;
  end if;
end $$;

commit;
