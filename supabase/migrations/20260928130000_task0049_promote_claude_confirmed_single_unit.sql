-- TASK-0049 / DECISION-0066 follow-on batch.
--
-- David asked for an independent Opus classification pass over every current
-- Biology/Statistics gap item, then compared it against the stored two-model
-- fresh single-unit promotion predicate (the same predicate
-- 20260926233500_promote_fresh_single_unit_two_model_labels.sql already
-- promoted 216 items under). Of the 98 items currently satisfying that
-- predicate, Opus's independent content read agreed with 96 and flagged 2 as
-- genuinely multi-unit (APSTATS-MCQ-010-CAL: the sample-proportion
-- success/failure condition explicitly depends on the Unit 2 binomial
-- background; APSTATS-MCQ-033: a lurking-variable item that invokes both
-- Unit 5 correlation and Unit 1 confounding). This migration promotes the 96
-- where independent human-adjacent review confirms the mechanical predicate,
-- and explicitly excludes the 2 disputed items pending a real multi-unit
-- review rather than promoting them on the strength of the predicate alone.
--
-- See docs/tasks/TASK-0049-CLAUDE-INDEPENDENT-AUDIT-2026-09-28.md and the
-- session's comparison report against the separate ChatGPT/Codex execution
-- for full evidence. Approved by David Bloom (Product Owner) in-session,
-- 2026-09-28, as the specific named batch (96 content keys, listed in the
-- comparison report) required by TASK-0049's Hard-Gate approval boundary.

begin;

create temporary table _task0049_batch_a on commit drop as
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
where s.subject_key in ('biology', 'ap-statistics')
  and ctl.label_status = 'provisional_model'
  and ctl.source = 'vercel_ai_gateway_two_model_serving_lane'
  and ctl.source_payload->>'reason' like 'two_model_%'
  and cardinality(ctl.required_units) = 1
  and ctl.validated_against_version_id = civ.id
  and ctl.validated_against_taxo_hash = app.taxonomy_relevant_hash(civ.id)
  and ci.content_key not in ('APSTATS-MCQ-010-CAL', 'APSTATS-MCQ-033');

do $$
declare
  v_count integer;
begin
  select count(*) into v_count from _task0049_batch_a;
  if v_count <> 96 then
    raise exception
      'TASK-0049 batch A drift: expected 96 confirmed single-unit candidates, found %',
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
  'chat_review',
  p.primary_unit,
  p.required_units,
  'TASK-0049 batch A: fresh single-unit two-model agreement, independently re-read and confirmed by Claude Opus against the raw item content (95 Biology + 103 Statistics gap population), 2 of the 98 predicate-satisfying candidates excluded as genuinely multi-unit pending separate review.'
from _task0049_batch_a p;

update app.content_taxonomy_labels ctl
set
  label_status = 'validated',
  validation_decision_id = p.validation_decision_id,
  validated_by = 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,
  validated_at = now(),
  validated_against_version_id = p.content_item_version_id,
  validated_against_taxo_hash = p.taxonomy_relevant_hash
from _task0049_batch_a p
where ctl.content_taxonomy_label_id = p.content_taxonomy_label_id;

do $$
declare
  v_promoted integer;
begin
  select count(*) into v_promoted
  from app.content_taxonomy_labels ctl
  join _task0049_batch_a p
    on p.content_taxonomy_label_id = ctl.content_taxonomy_label_id
  where ctl.label_status = 'validated'
    and ctl.validation_decision_id = p.validation_decision_id
    and ctl.validated_against_version_id = p.content_item_version_id
    and ctl.validated_against_taxo_hash = p.taxonomy_relevant_hash;

  if v_promoted <> 96 then
    raise exception
      'TASK-0049 batch A verification failed: expected 96, found %',
      v_promoted;
  end if;
end $$;

commit;
