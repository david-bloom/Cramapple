begin;
select pg_advisory_xact_lock(hashtext('cramapple-apchem-variants-publish-20261002'));
create temporary table lab (content_key text primary key, primary_unit int, req int[], topic text, seed text) on commit drop;
insert into lab values
('apchem-mcq-sv-001-v1',1,'{1}'::int[],'1.1','apchem-mcq-001'),
('apchem-mcq-sv-001-v2',1,'{1}'::int[],'1.1','apchem-mcq-001'),
('apchem-mcq-sv-001-v3',1,'{1}'::int[],'1.1','apchem-mcq-001'),
('apchem-mcq-sv-021-v1',1,'{1}'::int[],'1.1','apchem-mcq-021'),
('apchem-mcq-sv-021-v2',1,'{1}'::int[],'1.1','apchem-mcq-021'),
('apchem-mcq-sv-021-v3',1,'{1}'::int[],'1.1','apchem-mcq-021'),
('apchem-mcq-sv-022-v1',1,'{1}'::int[],'1.5','apchem-mcq-022'),
('apchem-mcq-sv-022-v2',1,'{1}'::int[],'1.5','apchem-mcq-022'),
('apchem-mcq-sv-022-v3',1,'{1}'::int[],'1.5','apchem-mcq-022'),
('apchem-mcq-sv-023-v1',1,'{1}'::int[],'1.6','apchem-mcq-023'),
('apchem-mcq-sv-023-v2',1,'{1}'::int[],'1.6','apchem-mcq-023'),
('apchem-mcq-sv-023-v3',1,'{1}'::int[],'1.6','apchem-mcq-023'),
('apchem-mcq-sv-024-v1',1,'{1}'::int[],'1.7','apchem-mcq-024'),
('apchem-mcq-sv-024-v2',1,'{1}'::int[],'1.7','apchem-mcq-024'),
('apchem-mcq-sv-024-v3',1,'{1}'::int[],'1.7','apchem-mcq-024'),
('apchem-mcq-sv-003-v1',2,'{2}'::int[],'2.7','apchem-mcq-003'),
('apchem-mcq-sv-003-v2',2,'{2}'::int[],'2.7','apchem-mcq-003'),
('apchem-mcq-sv-003-v3',2,'{2}'::int[],'2.7','apchem-mcq-003'),
('apchem-mcq-sv-025-v1',2,'{2}'::int[],'2.1','apchem-mcq-025'),
('apchem-mcq-sv-025-v2',2,'{2}'::int[],'2.1','apchem-mcq-025'),
('apchem-mcq-sv-025-v3',2,'{2}'::int[],'2.1','apchem-mcq-025'),
('apchem-mcq-sv-026-v1',2,'{2}'::int[],'2.5','apchem-mcq-026'),
('apchem-mcq-sv-026-v2',2,'{2}'::int[],'2.5','apchem-mcq-026'),
('apchem-mcq-sv-026-v3',2,'{2}'::int[],'2.5','apchem-mcq-026'),
('apchem-mcq-sv-027-v1',2,'{2}'::int[],'2.6','apchem-mcq-027'),
('apchem-mcq-sv-027-v2',2,'{2}'::int[],'2.6','apchem-mcq-027'),
('apchem-mcq-sv-027-v3',2,'{2}'::int[],'2.6','apchem-mcq-027'),
('apchem-mcq-sv-028-v1',2,'{2}'::int[],'2.7','apchem-mcq-028'),
('apchem-mcq-sv-028-v2',2,'{2}'::int[],'2.7','apchem-mcq-028'),
('apchem-mcq-sv-028-v3',2,'{2}'::int[],'2.7','apchem-mcq-028'),
('apchem-mcq-sv-005-v1',3,'{1,3}'::int[],'3.5','apchem-mcq-005'),
('apchem-mcq-sv-005-v2',3,'{1,3}'::int[],'3.5','apchem-mcq-005'),
('apchem-mcq-sv-005-v3',3,'{1,3}'::int[],'3.5','apchem-mcq-005'),
('apchem-mcq-sv-006-v1',3,'{3}'::int[],'3.13','apchem-mcq-006'),
('apchem-mcq-sv-006-v2',3,'{3}'::int[],'3.13','apchem-mcq-006'),
('apchem-mcq-sv-006-v3',3,'{3}'::int[],'3.13','apchem-mcq-006'),
('apchem-mcq-sv-008-v1',3,'{3}'::int[],'3.4','apchem-mcq-008'),
('apchem-mcq-sv-008-v2',3,'{3}'::int[],'3.4','apchem-mcq-008'),
('apchem-mcq-sv-008-v3',3,'{3}'::int[],'3.4','apchem-mcq-008'),
('apchem-mcq-sv-029-v1',3,'{2,3}'::int[],'3.1','apchem-mcq-029'),
('apchem-mcq-sv-029-v2',3,'{2,3}'::int[],'3.1','apchem-mcq-029'),
('apchem-mcq-sv-029-v3',3,'{2,3}'::int[],'3.1','apchem-mcq-029'),
('apchem-mcq-sv-030-v1',3,'{3}'::int[],'3.1','apchem-mcq-030'),
('apchem-mcq-sv-030-v2',3,'{3}'::int[],'3.1','apchem-mcq-030'),
('apchem-mcq-sv-030-v3',3,'{3}'::int[],'3.1','apchem-mcq-030'),
('apchem-mcq-sv-031-v1',3,'{3}'::int[],'3.2','apchem-mcq-031'),
('apchem-mcq-sv-031-v2',3,'{3}'::int[],'3.2','apchem-mcq-031'),
('apchem-mcq-sv-031-v3',3,'{3}'::int[],'3.2','apchem-mcq-031'),
('apchem-mcq-sv-032-v1',3,'{3}'::int[],'3.4','apchem-mcq-032'),
('apchem-mcq-sv-032-v2',3,'{3}'::int[],'3.4','apchem-mcq-032'),
('apchem-mcq-sv-032-v3',3,'{3}'::int[],'3.4','apchem-mcq-032'),
('apchem-mcq-sv-033-v1',3,'{3}'::int[],'3.5','apchem-mcq-033'),
('apchem-mcq-sv-033-v2',3,'{3}'::int[],'3.5','apchem-mcq-033'),
('apchem-mcq-sv-033-v3',3,'{3}'::int[],'3.5','apchem-mcq-033'),
('apchem-mcq-sv-034-v1',3,'{3}'::int[],'3.6','apchem-mcq-034'),
('apchem-mcq-sv-034-v2',3,'{3}'::int[],'3.6','apchem-mcq-034'),
('apchem-mcq-sv-034-v3',3,'{3}'::int[],'3.6','apchem-mcq-034'),
('apchem-mcq-sv-035-v1',3,'{3}'::int[],'3.10','apchem-mcq-035'),
('apchem-mcq-sv-035-v2',3,'{3}'::int[],'3.10','apchem-mcq-035'),
('apchem-mcq-sv-035-v3',3,'{3}'::int[],'3.10','apchem-mcq-035'),
('apchem-mcq-sv-036-v1',3,'{3}'::int[],'3.13','apchem-mcq-036'),
('apchem-mcq-sv-036-v2',3,'{3}'::int[],'3.13','apchem-mcq-036'),
('apchem-mcq-sv-036-v3',3,'{3}'::int[],'3.13','apchem-mcq-036'),
('apchem-mcq-sv-037-v1',3,'{3}'::int[],'3.12','apchem-mcq-037'),
('apchem-mcq-sv-037-v2',3,'{3}'::int[],'3.12','apchem-mcq-037'),
('apchem-mcq-sv-037-v3',3,'{3}'::int[],'3.12','apchem-mcq-037'),
('apchem-mcq-sv-038-v1',3,'{3}'::int[],'3.9','apchem-mcq-038'),
('apchem-mcq-sv-038-v2',3,'{3}'::int[],'3.9','apchem-mcq-038'),
('apchem-mcq-sv-038-v3',3,'{3}'::int[],'3.9','apchem-mcq-038'),
('apchem-mcq-sv-039-v1',3,'{3}'::int[],'3.7','apchem-mcq-039'),
('apchem-mcq-sv-039-v2',3,'{3}'::int[],'3.7','apchem-mcq-039'),
('apchem-mcq-sv-039-v3',3,'{3}'::int[],'3.7','apchem-mcq-039');
create temporary table tgt as
select l.*, ci.id item_id, civ.id version_id, gen_random_uuid() assignment_id, gen_random_uuid() label_id, gen_random_uuid() vd_id
from lab l join app.content_items ci on ci.content_key=l.content_key and ci.exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b'
join app.content_item_versions civ on civ.content_item_id=ci.id and civ.version_num=1
where ci.status='draft' and civ.status='draft';
do $$ begin if (select count(*) from tgt)<>72 then raise exception 'expected 72 draft targets, got %', (select count(*) from tgt); end if; end $$;
insert into app.content_review_assignments (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, review_kind, status, assignment_purpose, created_by)
select assignment_id, version_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'tutor_question', 'mcq', 'pending', 'owner_remediation_approval', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
insert into app.content_review_decisions (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, tutor_score, difficulty_label, diagnostic_flag, concern_codes, note, tutor_decision, decision_payload, decision_hash, created_by)
select assignment_id, version_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'tutor_question', 1, null, false, array[]::text[],
 'AP Chemistry Units 1-3 variants: publication approved by the Product Owner (David Bloom, 2026-10-02, "publish"). Seed audit and repair; sympy-verified authoring; two-model blind solve and rationale audit (Gemini 3.8 Flash + DeepSeek V4 Pro) with patch rounds and full re-checks; CED scope check; three-family label inheritance 75 of 75.',
 'approve',
 jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apchem_variants_po_approval','qa_date','2026-10-02','content_key',content_key,'seed',seed),
 md5(jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apchem_variants_po_approval','qa_date','2026-10-02','content_key',content_key,'seed',seed)::text),
 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
create temporary table qa_blocked on commit drop as
select g.content_key, case
 when nullif(trim(civ.stem),'') is null then 'blank stem'
 when (select count(*) from app.mcq_choices m where m.content_item_version_id=civ.id)<>4 then 'choice count'
 when (select count(distinct lower(trim(m.choice_text))) from app.mcq_choices m where m.content_item_version_id=civ.id)<>4 then 'duplicate choice text'
 when (select count(*) from app.mcq_choices m where m.content_item_version_id=civ.id and m.is_correct)<>1 then 'correct key count'
 when exists (select 1 from app.mcq_choices m where m.content_item_version_id=civ.id and nullif(trim(coalesce(m.rationale,'')),'') is null) then 'blank rationale'
 when civ.canonical_answer_1 is distinct from (select m.choice_key from app.mcq_choices m where m.content_item_version_id=civ.id and m.is_correct) then 'canonical letter mismatch'
 end reason
from tgt g join app.content_item_versions civ on civ.id=g.version_id;
delete from qa_blocked where reason is null;
do $$ begin if exists (select 1 from qa_blocked) then raise exception 'structural QA blocked: %', (select string_agg(content_key||':'||reason, ', ') from qa_blocked); end if; end $$;
update app.content_item_versions civ set status='reviewed_approved', review_status='question_review_approved', approved_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, approved_at=coalesce(civ.approved_at,now()), updated_at=now() from tgt where civ.id=tgt.version_id;
update app.content_items ci set status='reviewed_approved', updated_at=now() from tgt where ci.id=tgt.item_id;
insert into app.content_taxonomy_labels (content_taxonomy_label_id, content_item_id, label_version, label_scope, required_units, max_required_unit, primary_unit, assessed_topics, taxonomy_source_version, taxonomy_confidence, label_status, source, source_payload, model_run_id, created_by)
select label_id, item_id, 1, 'serving', req, (select max(u) from unnest(req) u), primary_unit, array[]::text[], 'cbe3116f-6ef5-410c-b535-e9fb711c4c2c'::uuid, 'provisional', 'provisional_model',
 'apchem_variants_2026_10_02',
 jsonb_build_object('origin','inherited_from_seed','seed',seed,'units_source','seed consensus; 3 families (Gemini 3.8 Flash, DeepSeek V4 Pro, GPT-6.1 Sol) x 2 samples agree with the seed on unit and topic (variant at >= 5 of 6)','topic',topic,'report','scripts/content-seed/chem-units1-3-pipeline-2026-10-02/PIPELINE_REPORT.md'),
 'apchem-variants-labeling-2026-10-02', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
insert into app.content_taxonomy_validation_decisions (validation_decision_id, content_taxonomy_label_id, decided_by, decision, decision_source, reviewed_primary_unit, reviewed_required_units, notes)
select vd_id, label_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'confirmed', 'automated_spot_check', primary_unit, req,
 'Product Owner chat instruction 2026-10-02 (publish the Chemistry variants; APPROVAL-0075). Variant inherits its seed unit and topic after a per-variant 3-family x 2-sample agreement check (>= 5 of 6 on both).' from tgt;
update app.content_taxonomy_labels l set label_status='validated', validated_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, validated_at=now(), validation_decision_id=t.vd_id, validated_against_version_id=t.version_id, validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id) from tgt t where l.content_taxonomy_label_id=t.label_id;
insert into app.content_item_cells (content_item_version_id, content_item_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id, validated_by, validated_at, validation_decision_id)
select version_id, item_id, 'cbe3116f-6ef5-410c-b535-e9fb711c4c2c'::uuid, topic, null, true, 'validated', 'apchem_variants_topic_2026_10_02',
 'apchem-variants-labeling-2026-10-02 (3 families x 2 samples; topic agreement with the seed at >= 5 of 6)', null, now(), gen_random_uuid() from tgt;
update app.content_item_versions civ set status='published', published_at=coalesce(civ.published_at,now()), updated_at=now() from tgt where civ.id=tgt.version_id;
update app.content_items ci set status='published', updated_at=now() from tgt where ci.id=tgt.item_id;
do $$ declare n int; begin
  select count(*) into n from (select content_item_id from app.content_item_versions where status='published' group by 1 having count(*)>1) d; if n<>0 then raise exception 'duplicate published versions: %', n; end if;
  if (select count(*) from app.content_items ci join tgt on tgt.item_id=ci.id where ci.status='published')<>72 then raise exception 'publish count mismatch'; end if;
  select count(*) into n from app.content_taxonomy_labels l join tgt t on t.item_id=l.content_item_id where l.label_scope='serving' and l.superseded_by is null and l.label_status='validated' and l.validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id); if n<>72 then raise exception 'label post-check %', n; end if;
end $$;
select (select count(*) from tgt) published, (select count(*) from app.content_taxonomy_labels where source='apchem_variants_2026_10_02' and label_status='validated') validated_labels;
