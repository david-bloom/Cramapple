-- AP Calc AB serving-label repair, 11 of 12 problem items (APPROVAL-0069, Product Owner chat authorization 2026-10-02).
-- Each target has a NEW label version: validated, 3-model (Gemini 3.8 Flash, DeepSeek V4 Pro, GPT-6.1 Sol) x 2 samples blind probe,
-- units/topic accepted only where at least 4 of 6 samples agree on the max required unit and topic. apcalcab-frq-u13-003 is NOT
-- included (max unit split 3/3 between Unit 2 and Unit 4): it stays held for a Product Owner decision.
-- The old label row is superseded, never edited. Text of items is not changed.
begin;
select pg_advisory_xact_lock(hashtext('cramapple-apcalcab-label-repair-20261002'));
create temporary table tgt0 (content_key text primary key, primary_unit int, req int[], topic text, units_support text, topic_support text) on commit drop;
insert into tgt0 values
('apcalcab-frq-005',3,array[2,3],'3.2','6/6','6/6'),
('apcalcab-frq-006',3,array[2,3],'3.3','6/6 (set 5/6)','6/6'),
('apcalcab-frq-033',5,array[5],'5.1','6/6 (set 5/6)','6/6'),
('apcalcab-frq-u13-007',2,array[2],'2.6','6/6','6/6'),
('apcalcab-frq-u13-009',3,array[2,3],'3.1','6/6','6/6'),
('apcalcab-frq-u13-013',2,array[2],'2.9','6/6','6/6'),
('apcalcab-frq-u13-014',2,array[2],'2.10','6/6','6/6'),
('apcalcab-frq-u13-016',3,array[2,3],'3.3','6/6','6/6'),
('apcalcab-mcq-014',6,array[3,6],'6.4','6/6 (set 5/6)','6/6'),
('apcalcab-mcq-015',6,array[6],'6.9','6/6 (set 3/6 vs [2,6] 3/6)','6/6'),
('apcalcab-mcq-030',3,array[2,3],'3.2','6/6','6/6');
create temporary table tgt on commit drop as
select t.*, ci.id item_id, civ.id version_id, l.content_taxonomy_label_id old_label_id, l.label_version old_ver, l.label_status old_status,
       gen_random_uuid() new_label_id, gen_random_uuid() vd_id
from tgt0 t
join app.content_items ci on ci.content_key=t.content_key and ci.exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and ci.status='published'
join app.content_item_versions civ on civ.content_item_id=ci.id and civ.status='published'
join app.content_taxonomy_labels l on l.content_item_id=ci.id and l.label_scope='serving' and l.superseded_by is null;
do $$ begin
  if (select count(*) from tgt)<>11 then raise exception 'expected 11 targets, got %', (select count(*) from tgt); end if;
  if exists (select 1 from tgt where old_status not in ('held','provisional_model')) then raise exception 'unexpected prior status'; end if;
  -- the consensus topic must equal the item''s existing primary cell topic
  if exists (select 1 from tgt t where not exists (select 1 from app.content_item_cells c where c.content_item_version_id=t.version_id and c.is_primary and c.topic_code=t.topic))
    then raise exception 'consensus topic differs from the primary cell'; end if;
end $$;
-- supersede by inserting the new row first (superseded_by is a FK to the new row)
insert into app.content_taxonomy_labels (content_taxonomy_label_id, content_item_id, label_version, label_scope, required_units, max_required_unit, primary_unit, assessed_topics, taxonomy_source_version, taxonomy_confidence, label_status, source, source_payload, model_run_id, created_by)
select new_label_id, item_id, old_ver+1, 'serving', req, (select max(u) from unnest(req) u), primary_unit, array[]::text[], '33b4408b-0ecc-4c7a-b0b1-612db81164a1'::uuid, 'provisional', 'provisional_model',
 'apcalcab_label_repair_2026_10_02',
 jsonb_build_object('origin','three_model_blind_probe','models','google/gemini-3.8-flash, deepseek/deepseek-v4-pro, openai/gpt-6.1-sol','samples','2 each (6 per item)','units_support',units_support,'topic',topic,'topic_support',topic_support,'supersedes_status',old_status,'report','scripts/content-seed/calc-ab-label-repair-2026-10-02/'),
 'apcalcab-label-repair-2026-10-02', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from tgt;
update app.content_taxonomy_labels l set superseded_by=t.new_label_id from tgt t where l.content_taxonomy_label_id=t.old_label_id;
insert into app.content_taxonomy_validation_decisions (validation_decision_id, content_taxonomy_label_id, decided_by, decision, decision_source, reviewed_primary_unit, reviewed_required_units, notes)
select vd_id, new_label_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'confirmed', 'automated_spot_check', primary_unit, req,
 'Product Owner chat authorization 2026-10-02 (APPROVAL-0069): relabel the held/stale AP Calc AB items. Blind 3-model x 2-sample probe; units '||units_support||', topic '||topic_support||' agree. Human review waived under the same pattern as APPROVAL-0065.'
from tgt;
update app.content_taxonomy_labels l set label_status='validated', validated_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, validated_at=now(), validation_decision_id=t.vd_id,
  validated_against_version_id=t.version_id, validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id)
from tgt t where l.content_taxonomy_label_id=t.new_label_id;
do $$ declare n int; begin
  select count(*) into n from app.content_taxonomy_labels l join tgt t on t.item_id=l.content_item_id
   where l.label_scope='serving' and l.superseded_by is null and l.label_status='validated' and l.validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id);
  if n<>11 then raise exception 'post-check: % of 11 labels validated and hash-fresh', n; end if;
  select count(*) into n from (select l.content_item_id from app.content_taxonomy_labels l join tgt t on t.item_id=l.content_item_id where l.label_scope='serving' and l.superseded_by is null group by 1 having count(*)>1) d;
  if n<>0 then raise exception 'multiple active serving labels'; end if;
end $$;
select count(*) validated_fresh, (select count(*) from tgt) targets from tgt;
rollback;
