begin;
select pg_advisory_xact_lock(hashtext('cramapple-apbio-topic-correction-20261002'));
create temporary table tc0 (content_key text primary key, topic text, sup text) on commit drop;
insert into tc0 values ('APBIO-FRQ-L-006','7.2','6/6'),('APBIO-FRQ-L-008','2.7','6/6'),('APBIO-FRQ-L-014','3.5','6/6'),('APBIO-FRQ-L-026','7.4','5/6'),('APBIO-FRQ-L-030','8.7','5/6'),('APBIO-FRQ-S-003','3.4','6/6'),('APBIO-FRQ-S-006','5.1','6/6'),('APBIO-FRQ-S-007','5.3','6/6'),('APBIO-FRQ-S-009','6.3','6/6'),('APBIO-FRQ-S-010','7.2','6/6'),('APBIO-FRQ-S-016','7.10','6/6'),('APBIO-FRQ-S-017','8.2','6/6'),('APBIO-FRQ-S-019','2.10','6/6'),('APBIO-FRQ-S-020','4.4','6/6'),('APBIO-FRQ-S-021','1.3','6/6'),('APBIO-FRQ-S-028','2.10','6/6'),('APBIO-FRQ-S-029','2.7','6/6'),('APBIO-FRQ-S-031','2.3','6/6'),('APBIO-FRQ-S-033','2.8','6/6'),('APBIO-FRQ-S-036','3.5','6/6'),('APBIO-FRQ-S-038','3.5','6/6'),('APBIO-FRQ-S-045','5.3','6/6'),('APBIO-FRQ-S-046','5.4','6/6'),('APBIO-FRQ-S-047','5.4','6/6'),('APBIO-FRQ-S-048','5.4','6/6'),('APBIO-FRQ-S-051','5.1','6/6'),('APBIO-FRQ-S-052','6.3','6/6'),('APBIO-FRQ-S-058','7.4','6/6'),('APBIO-FRQ-S-061','7.10','6/6'),('APBIO-FRQ-S-063','8.2','6/6'),('APBIO-FRQ-S-064','8.7','6/6'),('APBIO-FRQ-S-066','8.5','6/6'),('APBIO-FRQ-S-068','8.5','6/6'),('APBIO-FRQ-S-070','8.5','6/6'),('APBIO-FRQ-S-071','2.7','6/6'),('APBIO-FRQ-S-073','5.1','6/6'),('APBIO-FRQ-S-074','6.8','6/6'),('APBIO-FRQ-S-080','1.7','6/6'),('APBIO-FRQ-S-084','8.5','6/6'),('APBIO-FRQ-S-085','4.1','6/6'),('APBIO-FRQ-S-086','8.7','6/6'),('APBIO-FRQ-S-087','7.2','6/6'),('APBIO-FRQ-S-089','7.10','6/6'),('APBIO-FRQ-S-090','8.2','6/6'),('APBIO-FRQ-S-094','6.7','6/6'),('APBIO-FRQ-S-095','6.7','6/6'),('APBIO-FRQ-S-099','7.10','6/6'),('APBIO-FRQ-S-101','7.9','6/6'),('APBIO-HDG-2026-GRAPH-002','3.2','6/6'),('APBIO-MCQ-005','2.6','6/6'),('APBIO-MCQ-008','1.7','6/6'),('APBIO-MCQ-017','2.8','5/6'),('APBIO-MCQ-018','2.8','5/6'),('APBIO-MCQ-020','2.7','6/6'),('APBIO-MCQ-022','2.10','6/6'),('APBIO-MCQ-025','2.7','6/6'),('APBIO-MCQ-028','4.3','6/6'),('APBIO-MCQ-032','4.3','6/6'),('APBIO-MCQ-033','4.3','6/6'),('APBIO-MCQ-043','5.1','6/6'),('APBIO-MCQ-046','4.4','6/6'),('APBIO-MCQ-047','4.3','6/6'),('APBIO-MCQ-054','5.4','6/6'),('APBIO-MCQ-055','5.4','6/6'),('APBIO-MCQ-056','5.4','6/6'),('APBIO-MCQ-058','5.4','6/6'),('APBIO-MCQ-063','6.3','6/6'),('APBIO-MCQ-069','6.3','6/6'),('APBIO-MCQ-079','7.2','6/6'),('APBIO-MCQ-084','7.10','6/6'),('APBIO-MCQ-086','7.9','6/6'),('APBIO-MCQ-094','8.6','6/6'),('APBIO-MCQ-099','8.6','6/6');
create temporary table tc on commit drop as
select t.*, ci.id item_id, civ.id version_id, oc.content_item_cell_id old_cell, oc.topic_code old_topic, oc.taxonomy_source_version tsv, gen_random_uuid() new_cell
from tc0 t join app.content_items ci on ci.content_key=t.content_key and ci.exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and ci.status='published'
join app.content_item_versions civ on civ.content_item_id=ci.id and civ.status='published'
left join app.content_item_cells oc on oc.content_item_version_id=civ.id and oc.is_primary and oc.superseded_by is null;
do $$ begin
 if (select count(*) from tc)<>73 then raise exception 'expected 73 targets, got %', (select count(*) from tc); end if;
 if exists (select 1 from tc where old_topic=topic) then raise exception 'a target already has the consensus topic'; end if;
end $$;
create temporary table sk on commit drop as
select c.content_item_cell_id, c.skill_code, c.topic_code old_topic, t.topic new_topic, t.content_key,
 exists (select 1 from app.taxonomy_cells x where x.taxonomy_source_version=c.taxonomy_source_version and x.topic_code=t.topic and x.skill_code=c.skill_code) valid_pair
from tc t join app.content_item_cells c on c.content_item_version_id=t.version_id and not c.is_primary and c.skill_code is not null and c.superseded_by is null and c.topic_code<>t.topic;
insert into app.content_item_cells (content_item_cell_id, content_item_version_id, content_item_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id, validated_by, validated_at, validation_decision_id)
select t.new_cell, t.version_id, t.item_id, coalesce(t.tsv,'c676d1fc-3b58-4896-89e3-852d9bd1f81b'::uuid), t.topic, null, false, 'validated', 'apbio_topic_correction_2026_10_02:'||t.sup,
 'apbio-topic-correction-2026-10-02 (google/gemini-3.8-flash + deepseek/deepseek-v4-pro + openai/gpt-6.1-sol, 2 samples each; topic agreement >= 5 of 6; replaces the registered topic '||coalesce(t.old_topic,'none')||')', null, now(), gen_random_uuid() from tc t;
update app.content_item_cells c set is_primary=false, superseded_by=t.new_cell from tc t where c.content_item_cell_id=t.old_cell;
update app.content_item_cells c set is_primary=true from tc t where c.content_item_cell_id=t.new_cell;
update app.content_item_cells c set topic_code=s.new_topic from sk s where c.content_item_cell_id=s.content_item_cell_id and s.valid_pair;
update app.content_item_cells c set assignment_status='held', validated_at=null, validation_decision_id=null, validated_by=null,
 source='apbio_topic_correction_2026_10_02:skill_revote_needed', model_run_id='skill '||c.skill_code||' is not a valid pairing for the corrected topic '||s.new_topic||'; held pending a revote' from sk s where c.content_item_cell_id=s.content_item_cell_id and not s.valid_pair;
do $$ declare n int; begin
 select count(*) into n from tc t join app.content_item_cells c on c.content_item_version_id=t.version_id and c.is_primary and c.superseded_by is null and c.topic_code=t.topic and c.assignment_status='validated'; if n<>73 then raise exception 'primary post-check %', n; end if;
 select count(*) into n from (select content_item_version_id from app.content_item_cells where is_primary and superseded_by is null group by 1 having count(*)>1) d; if n<>0 then raise exception 'multiple primaries'; end if;
end $$;
-- MCQ-005 serving label: Unit 2 (all three families, 6 of 6), required units 1 and 2
create temporary table lb on commit drop as
select ci.id item_id, civ.id version_id, l.label_version, l.content_taxonomy_label_id old_label, l.taxonomy_source_version tsv, gen_random_uuid() label_id, gen_random_uuid() vd_id
from app.content_items ci join app.content_item_versions civ on civ.content_item_id=ci.id and civ.status='published'
join app.content_taxonomy_labels l on l.content_item_id=ci.id and l.label_scope='serving' and l.superseded_by is null
where ci.exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and ci.content_key='APBIO-MCQ-005';
do $$ begin if (select count(*) from lb)<>1 then raise exception 'MCQ-005 label target'; end if; end $$;
insert into app.content_taxonomy_labels (content_taxonomy_label_id, content_item_id, label_version, label_scope, required_units, max_required_unit, primary_unit, assessed_topics, taxonomy_source_version, taxonomy_confidence, label_status, source, source_payload, model_run_id, created_by)
select label_id, item_id, label_version+1, 'serving', array[1,2], 2, 2, array[]::text[], tsv, 'provisional', 'provisional_model', 'apbio_topic_correction_2026_10_02',
 jsonb_build_object('origin','three_family_blind_probe','topic','2.6','topic_support','6/6','max_unit_support','6/6','note','previous label said Unit 1; the consensus puts the item in Unit 2'),'apbio-topic-correction-2026-10-02','f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from lb;
update app.content_taxonomy_labels l set superseded_by=lb.label_id from lb where l.content_taxonomy_label_id=lb.old_label;
insert into app.content_taxonomy_validation_decisions (validation_decision_id, content_taxonomy_label_id, decided_by, decision, decision_source, reviewed_primary_unit, reviewed_required_units, notes)
select vd_id, label_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'confirmed', 'automated_spot_check', 2, array[1,2], 'Product Owner chat instruction 2026-10-02 (APPROVAL-0079, Biology topic correction); three-family blind consensus 6 of 6.' from lb;
update app.content_taxonomy_labels l set label_status='validated', validated_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, validated_at=now(), validation_decision_id=lb.vd_id, validated_against_version_id=lb.version_id, validated_against_taxo_hash=app.taxonomy_relevant_hash(lb.version_id) from lb where l.content_taxonomy_label_id=lb.label_id;
select (select count(*) from tc) topics_changed, (select count(*) from tc where old_topic is null) had_no_primary, (select count(*) from sk where valid_pair) skill_cells_retopiced, (select count(*) from sk where not valid_pair) skill_cells_held, (select string_agg(content_key||':'||skill_code||'@'||new_topic, ', ') from sk where not valid_pair) held_list;
ROLLBACK_OR_COMMIT;
