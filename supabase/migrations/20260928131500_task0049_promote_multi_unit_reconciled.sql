-- TASK-0049 batch B: multi-unit items where Claude Opus's independent content
-- read, the prior Claude Haiku 4.5 third review
-- (docs/research/content_pipeline_third_review_2026_09_27/reviews.jsonl),
-- AND the item's own stored required_units_by_criterion evidence all agree.
--
-- Of the 7 multi_unit_nonconfirmed rows this session compared, Opus's fresh
-- read matched the third review's correction (not the original candidate) on
-- 5. Before promoting those 5, this migration cross-checked each FRQ's
-- stored required_units_by_criterion against the proposed item-level
-- required_units -- a check neither the original candidate generation, the
-- third review, nor Opus's first pass had done. Two failed that check and
-- are deliberately excluded, pending real re-examination, not promoted here:
--   - APSTAT-MOD7-H002-INV: review says required_units=[2,3], but its own
--     stored criterion "contextual_interpretation" cites units=[1,3] --
--     the per-criterion evidence itself references Unit 1, contradicting the
--     item-level correction that drops it.
--   - APSTAT-MOD5-H001-INV: review and Opus both propose required_units
--     including Unit 5, but the item's stored required_units_by_criterion
--     covers only {1,4} -- no stored criterion evidence supports Unit 5 at
--     all, and Opus and the third review disagree on primary_unit (1 vs 5).
--
-- The 4 promoted here have no such conflict:
--   - APSTAT-MOD3-H001-INV: candidate already equals review ([1,4]/primary
--     4); per-criterion union {1,4} matches exactly. No field change.
--   - apstats-frq-u12-017: candidate already equals review ([1,2]/primary
--     2); per-criterion union {1,2} matches exactly. No field change.
--   - APSTATS-MCQ-091, APSTATS-MCQ-099: MCQs, no per-criterion structure to
--     conflict with; both review and Opus independently drop the original
--     candidate's Unit 3 and agree on required_units=[4].
--
-- Approved by David Bloom (Product Owner) in-session, 2026-09-28.

begin;

create temporary table _task0049_batch_b (
  content_key text primary key,
  required_units integer[],
  primary_unit integer,
  max_required_unit integer,
  decision text
) on commit drop;

insert into _task0049_batch_b (content_key, required_units, primary_unit, max_required_unit, decision) values
  ('APSTAT-MOD3-H001-INV', array[1,4], 4, 4, 'confirmed'),
  ('apstats-frq-u12-017',  array[1,2], 2, 2, 'confirmed'),
  ('APSTATS-MCQ-091',      array[4],   4, 4, 'corrected'),
  ('APSTATS-MCQ-099',      array[4],   4, 4, 'corrected');

create temporary table _task0049_batch_b_resolved on commit drop as
select
  ctl.content_taxonomy_label_id,
  civ.id as content_item_version_id,
  app.taxonomy_relevant_hash(civ.id) as taxonomy_relevant_hash,
  gen_random_uuid() as validation_decision_id,
  b.required_units,
  b.primary_unit,
  b.max_required_unit,
  b.decision
from _task0049_batch_b b
join app.content_items ci on ci.content_key = b.content_key and ci.status = 'published'
join lateral (
  select v.* from app.content_item_versions v
  where v.content_item_id = ci.id order by v.version_num desc limit 1
) civ on civ.status = 'published'
join app.content_taxonomy_labels ctl
  on ctl.content_item_id = ci.id
 and ctl.label_scope = 'serving'
 and ctl.superseded_by is null;

do $$
declare
  v_count integer;
begin
  select count(*) into v_count from _task0049_batch_b_resolved;
  if v_count <> 4 then
    raise exception
      'TASK-0049 batch B drift: expected 4 reconciled multi-unit items, found %',
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
  p.decision,
  'chat_review',
  p.primary_unit,
  p.required_units,
  'TASK-0049 batch B: multi-unit item where the Claude Haiku 4.5 third review (2026-09-27), Claude Opus''s independent fresh read (2026-09-28), and the item''s own required_units_by_criterion evidence all agree. Held-out siblings APSTAT-MOD7-H002-INV and APSTAT-MOD5-H001-INV failed this per-criterion cross-check and are intentionally not promoted here.'
from _task0049_batch_b_resolved p;

update app.content_taxonomy_labels ctl
set
  required_units = p.required_units,
  primary_unit = p.primary_unit,
  max_required_unit = p.max_required_unit,
  label_status = 'validated',
  validation_decision_id = p.validation_decision_id,
  validated_by = 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid,
  validated_at = now(),
  validated_against_version_id = p.content_item_version_id,
  validated_against_taxo_hash = p.taxonomy_relevant_hash
from _task0049_batch_b_resolved p
where ctl.content_taxonomy_label_id = p.content_taxonomy_label_id;

do $$
declare
  v_promoted integer;
begin
  select count(*) into v_promoted
  from app.content_taxonomy_labels ctl
  join _task0049_batch_b_resolved p
    on p.content_taxonomy_label_id = ctl.content_taxonomy_label_id
  where ctl.label_status = 'validated'
    and ctl.validation_decision_id = p.validation_decision_id
    and ctl.required_units = p.required_units
    and ctl.primary_unit = p.primary_unit;

  if v_promoted <> 4 then
    raise exception
      'TASK-0049 batch B verification failed: expected 4, found %',
      v_promoted;
  end if;
end $$;

commit;
