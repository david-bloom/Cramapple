begin;
select pg_advisory_xact_lock(hashtext('cramapple-apcalcab-seeded-variants-publish-20260930'));
create temporary table lab (content_key text primary key, primary_unit int, req_units int[], topic text, skill text, difficulty text, diff_conf text, seed text) on commit drop;
insert into lab values
('apcalcab-mcq-sv-001-v1',1,array[1],'1.6','1.E','Medium','high','apcalcab-mcq-001'),
('apcalcab-mcq-sv-001-v2',1,array[1],'1.6','1.E','Medium','high','apcalcab-mcq-001'),
('apcalcab-mcq-sv-026-v1',2,array[2],'2.8','1.E','Medium','high','apcalcab-mcq-026'),
('apcalcab-mcq-sv-026-v2',2,array[2],'2.8','1.E','Medium','high','apcalcab-mcq-026'),
('apcalcab-mcq-sv-029-v1',3,array[2,3],'3.1','1.E','','medium','apcalcab-mcq-029'),
('apcalcab-mcq-sv-029-v2',3,array[2,3],'3.1','1.E','','medium','apcalcab-mcq-029'),
('apcalcab-mcq-sv-031-v1',4,array[2,4],'4.2','1.E','Medium','medium','apcalcab-mcq-031'),
('apcalcab-mcq-sv-031-v2',4,array[2,4],'4.2','1.E','Medium','medium','apcalcab-mcq-031'),
('apcalcab-mcq-sv-038-v1',5,array[5],'5.6','','','medium','apcalcab-mcq-038'),
('apcalcab-mcq-sv-038-v2',5,array[5],'5.6','','','medium','apcalcab-mcq-038'),
('apcalcab-mcq-sv-017-v1',6,array[5,6],'6.5','','Medium','high','apcalcab-mcq-017'),
('apcalcab-mcq-sv-017-v2',6,array[5,6],'6.5','','Medium','high','apcalcab-mcq-017'),
('apcalcab-mcq-sv-np2-006-v1',7,array[6,7],'7.7','1.E','Medium','high','apcalcab-mcq-np2-006'),
('apcalcab-mcq-sv-np2-006-v2',7,array[6,7],'7.7','1.E','Medium','high','apcalcab-mcq-np2-006'),
('apcalcab-mcq-sv-016-v1',8,array[6,8],'8.1','1.E','Medium','high','apcalcab-mcq-016'),
('apcalcab-mcq-sv-016-v2',8,array[6,8],'8.1','1.E','Medium','high','apcalcab-mcq-016'),
('apcalcab-mcq-sv-005-v1',3,array[2,3],'','1.E','Medium','high','apcalcab-mcq-005'),
('apcalcab-mcq-sv-005-v2',3,array[2,3],'','1.E','Medium','high','apcalcab-mcq-005'),
('apcalcab-mcq-sv-007-v1',3,array[2,3],'3.1','1.E','Medium','high','apcalcab-mcq-007'),
('apcalcab-mcq-sv-007-v2',3,array[2,3],'3.1','1.E','Medium','high','apcalcab-mcq-007'),
('apcalcab-mcq-sv-030-v1',3,array[2,3],'3.2','1.E','Medium','high','apcalcab-mcq-030'),
('apcalcab-mcq-sv-030-v2',3,array[2,3],'3.2','1.E','Medium','high','apcalcab-mcq-030'),
('apcalcab-mcq-sv-008-v1',3,array[2,3],'3.2','1.E','Medium','high','apcalcab-mcq-008'),
('apcalcab-mcq-sv-008-v2',3,array[2,3],'3.2','1.E','Medium','high','apcalcab-mcq-008');
create temporary table tgt on commit drop as
select l.*, ci.id item_id, civ.id version_id, gen_random_uuid() assignment_id, gen_random_uuid() label_id, gen_random_uuid() vd_id
from lab l join app.content_items ci on ci.content_key=l.content_key and ci.exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d'
join app.content_item_versions civ on civ.content_item_id=ci.id and civ.version_num=1
where ci.status='draft' and civ.status='draft';
do $$ begin if (select count(*) from tgt)<>24 then raise exception 'expected 24 draft targets, got %', (select count(*) from tgt); end if; end $$;
insert into app.content_review_assignments (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, review_kind, status, assignment_purpose, created_by)
select assignment_id, version_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'tutor_question', 'mcq', 'pending', 'owner_remediation_approval', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
insert into app.content_review_decisions (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, tutor_score, difficulty_label, diagnostic_flag, concern_codes, note, tutor_decision, decision_payload, decision_hash, created_by)
select assignment_id, version_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'tutor_question', 1, nullif(difficulty,''), false, array[]::text[],
 'AP Calc AB seeded variants: publication approved by the Product Owner (David Bloom, 2026-09-30). Independent sympy recompute; two-model blind solve and rationale audit (Gemini 3.8 Flash + DeepSeek V4 Pro); CED scope check; blind Fable 5.1 calibration run.',
 'approve',
 jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apcalcab_seeded_variants_po_approval','qa_date','2026-09-30','content_key',content_key,'seed',seed),
 encode(extensions.digest(jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apcalcab_seeded_variants_po_approval','qa_date','2026-09-30','content_key',content_key,'seed',seed)::text,'sha256'),'hex'),
 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from tgt;
create temporary table qa_blocked on commit drop as
select g.content_key, case
 when nullif(trim(civ.stem),'') is null then 'blank stem'
 when (select count(*) from app.mcq_choices m where m.content_item_version_id=civ.id)<>4 then 'choice count'
 when (select count(distinct lower(trim(m.choice_text))) from app.mcq_choices m where m.content_item_version_id=civ.id)<>4 then 'duplicate choice text'
 when (select count(*) from app.mcq_choices m where m.content_item_version_id=civ.id and m.is_correct)<>1 then 'correct key count'
 when exists (select 1 from app.mcq_choices m where m.content_item_version_id=civ.id and nullif(trim(coalesce(m.rationale,'')),'') is null) then 'blank rationale'
 end reason
from tgt g join app.content_item_versions civ on civ.id=g.version_id;
delete from qa_blocked where reason is null;
do $$ begin if exists (select 1 from qa_blocked) then raise exception 'structural QA blocked: %', (select string_agg(content_key||':'||reason, ', ') from qa_blocked); end if; end $$;
update app.content_item_versions civ set status='reviewed_approved', review_status='question_review_approved', approved_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, approved_at=coalesce(civ.approved_at,now()), updated_at=now() from tgt where civ.id=tgt.version_id;
update app.content_items ci set status='reviewed_approved', updated_at=now() from tgt where ci.id=tgt.item_id;
insert into app.content_taxonomy_labels (content_taxonomy_label_id, content_item_id, label_version, label_scope, required_units, max_required_unit, primary_unit, assessed_topics, taxonomy_source_version, taxonomy_confidence, label_status, source, source_payload, model_run_id, created_by)
select label_id, item_id, 1, 'serving', req_units, primary_unit, primary_unit, array[]::text[], '33b4408b-0ecc-4c7a-b0b1-612db81164a1'::uuid, 'provisional', 'provisional_model',
  'apcalcab_seeded_variants_2026_09_30',
  jsonb_build_object('origin','inherited_from_seed','seed',seed,'units_source','seed database label; 3-model (Gemini 3.8 Flash, DeepSeek V4 Pro, GPT-6.1 Sol) x 2 samples agree with the seed on required units','topic',nullif(topic,''),'skill',nullif(skill,''),'report','scripts/content-seed/calc-ab-seeded-batch-2026-09-30/label_inheritance.json'),
  'apcalcab-seeded-variants-labeling-2026-09-30', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from tgt;
insert into app.content_taxonomy_validation_decisions (validation_decision_id, content_taxonomy_label_id, decided_by, decision, decision_source, reviewed_primary_unit, reviewed_required_units, notes)
select vd_id, label_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'confirmed', 'automated_spot_check', primary_unit, req_units,
 'Product Owner approval 2026-09-30 (chat): publish the seeded variants. Variant inherits its seed''s required units after a per-variant 3-model agreement check (6 samples each; variant and seed pluralities equal, at least 4 of 6 support).'
from tgt;
update app.content_taxonomy_labels l set label_status='validated', validated_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, validated_at=now(), validation_decision_id=t.vd_id, validated_against_version_id=t.version_id, validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id)
from tgt t where l.content_taxonomy_label_id=t.label_id;
insert into app.content_item_difficulty (content_item_version_id, difficulty, basis, rationale, confidence, proposal_run, created_by)
select version_id, difficulty, 'calibrated_judgement', 'Three-model blind difficulty rubric (Easy/Medium/Hard), inherited from seed '||seed||' after a per-variant agreement check (6 samples). AP Calc AB seeded variants 2026-09-30.', diff_conf, 'apcalcab-seeded-variants-2026-09-30', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid
from tgt where nullif(difficulty,'') is not null;
insert into app.content_item_cells (content_item_version_id, content_item_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select version_id, item_id, '33b4408b-0ecc-4c7a-b0b1-612db81164a1'::uuid, topic, null, true, 'provisional_model', 'apcalcab_seeded_topic_2026_09_30', 'apcalcab-seeded-variants-labeling-2026-09-30'
from tgt where nullif(topic,'') is not null;
insert into app.content_item_cells (content_item_version_id, content_item_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id)
select t.version_id, t.item_id, '33b4408b-0ecc-4c7a-b0b1-612db81164a1'::uuid, t.topic, t.skill, false, 'provisional_model', 'apcalcab_seeded_skill_2026_09_30', 'apcalcab-seeded-variants-labeling-2026-09-30'
from tgt t where nullif(t.topic,'')<>'' and nullif(t.skill,'')<>''
  and exists (select 1 from app.taxonomy_cells c where c.taxonomy_source_version='33b4408b-0ecc-4c7a-b0b1-612db81164a1' and c.topic_code=t.topic and c.skill_code=t.skill);
update app.content_item_versions civ set status='published', published_at=coalesce(civ.published_at,now()), updated_at=now() from tgt where civ.id=tgt.version_id;
update app.content_items ci set status='published', updated_at=now() from tgt where ci.id=tgt.item_id;
do $$ declare n int; begin
 select count(*) into n from (select content_item_id from app.content_item_versions where status='published' group by 1 having count(*)>1) d;
 if n<>0 then raise exception 'duplicate published versions: %', n; end if;
 if (select count(*) from app.content_items ci join tgt on tgt.item_id=ci.id where ci.status='published')<>24 then raise exception 'publish count mismatch'; end if;
end $$;
select (select count(*) from app.content_taxonomy_labels where source='apcalcab_seeded_variants_2026_09_30' and label_status='validated') validated_labels,
 (select count(*) from app.content_item_difficulty where proposal_run='apcalcab-seeded-variants-2026-09-30') difficulty_rows,
 (select count(*) from app.content_item_cells where source='apcalcab_seeded_topic_2026_09_30') topic_cells,
 (select count(*) from app.content_item_cells where source='apcalcab_seeded_skill_2026_09_30') skill_cells;
commit;