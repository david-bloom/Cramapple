begin;
select pg_advisory_xact_lock(hashtext('cramapple-apphy2-variants-publish-20261003'));
create temporary table lab (content_key text primary key, seed text, exp_hash text) on commit drop;
insert into lab values
('apphy2-mcq-sv-002-v1','apphy2-mcq-002','372bfde6d7aa8813041144f3385cdd38'),
('apphy2-mcq-sv-002-v2','apphy2-mcq-002','42496c8a4e7371e2d8730070ef6b6c0e'),
('apphy2-mcq-sv-002-v3','apphy2-mcq-002','8ca309cbb1af0dc45828dc63a6306789'),
('apphy2-mcq-sv-003-v1','apphy2-mcq-003','f40920368f03f09422687f833d0f5db0'),
('apphy2-mcq-sv-003-v2','apphy2-mcq-003','f0b3e8c68c12e269ae339c152ac01350'),
('apphy2-mcq-sv-003-v3','apphy2-mcq-003','0925fb7ba255ae8361befbdb3792afad'),
('apphy2-mcq-sv-004-v1','apphy2-mcq-004','37622f65e6dcba544ba486aa4d01f883'),
('apphy2-mcq-sv-004-v2','apphy2-mcq-004','df9345c0dd35fe324f6aa41d589ef4eb'),
('apphy2-mcq-sv-004-v3','apphy2-mcq-004','dd1c8f6cc86facc3b8ae0c05c6b52807'),
('apphy2-mcq-sv-005-v3','apphy2-mcq-005','b17e09506e5a46a396ebf6858a40138d'),
('apphy2-mcq-sv-006-v1','apphy2-mcq-006','c151babd5c4266d7ceb5b76b4b52d25b'),
('apphy2-mcq-sv-006-v2','apphy2-mcq-006','d8e90df1190cbaff820ca464da677991'),
('apphy2-mcq-sv-006-v3','apphy2-mcq-006','927c5c318e5fe63c371f3fdb36a63021'),
('apphy2-mcq-sv-007-v1','apphy2-mcq-007','e175a3ed661d57e0cc101e5bf9cb5ab1'),
('apphy2-mcq-sv-007-v2','apphy2-mcq-007','6b2cc2799878c91d98754a797f1c594b'),
('apphy2-mcq-sv-007-v3','apphy2-mcq-007','e2d3e06b6dfa632b46235342ca0cf304'),
('apphy2-mcq-sv-008-v1','apphy2-mcq-008','d84df13aa3619ef0f1192977257ab340'),
('apphy2-mcq-sv-008-v2','apphy2-mcq-008','56c824a17070270a299b0a82d5c4b8e7'),
('apphy2-mcq-sv-008-v3','apphy2-mcq-008','f1e5bb8a60a875375fed56f64991472a'),
('apphy2-mcq-sv-009-v1','apphy2-mcq-009','76eff8fd36441ee572ed6a68b0944241'),
('apphy2-mcq-sv-009-v2','apphy2-mcq-009','de8ec7519fb3c9beef3f246984a90914'),
('apphy2-mcq-sv-009-v3','apphy2-mcq-009','62cce24720751a1f314a385fc7fa19f8'),
('apphy2-mcq-sv-021-v1','apphy2-mcq-021','d98e9179fab4d53e84995e4904962dba'),
('apphy2-mcq-sv-021-v2','apphy2-mcq-021','a57062109d658e71bd2cb237a664a174'),
('apphy2-mcq-sv-021-v3','apphy2-mcq-021','796c5ffc0e91541161f10fd4fc440652'),
('apphy2-mcq-sv-022-v1','apphy2-mcq-022','713f4426f8ac754484b7fce8aa23b0cb'),
('apphy2-mcq-sv-022-v2','apphy2-mcq-022','9b052a3f12e6331b90258d43704867e7'),
('apphy2-mcq-sv-022-v3','apphy2-mcq-022','12f8f4a801517cbbe2b3504951078063'),
('apphy2-mcq-sv-023-v1','apphy2-mcq-023','8d7e92a9f8b61ecee31d036a29cdccc8'),
('apphy2-mcq-sv-023-v2','apphy2-mcq-023','570dd14153f8b452ad8561047046feca'),
('apphy2-mcq-sv-023-v3','apphy2-mcq-023','f3c940c6cfbd22624822b9b68d93f286'),
('apphy2-mcq-sv-024-v1','apphy2-mcq-024','674404e8ceaacae3476e6dc9e33dea30'),
('apphy2-mcq-sv-024-v2','apphy2-mcq-024','a5772754680d3115e18063ab20556f6a'),
('apphy2-mcq-sv-024-v3','apphy2-mcq-024','550fb3ce59e05a911b4dd55b77e067a7'),
('apphy2-mcq-sv-025-v1','apphy2-mcq-025','fed456831fe750d6670576215af7c870'),
('apphy2-mcq-sv-025-v2','apphy2-mcq-025','d40b4c80347819366551fc2fada90adc'),
('apphy2-mcq-sv-025-v3','apphy2-mcq-025','7b4295be8cd11d935f29a7170512df7a'),
('apphy2-mcq-sv-026-v1','apphy2-mcq-026','c297ae9765b2fb813c538260d82b1d05'),
('apphy2-mcq-sv-026-v2','apphy2-mcq-026','019025c1024ec5c7c6f1842a47932448'),
('apphy2-mcq-sv-026-v3','apphy2-mcq-026','d4704bb7814967367ec1d623635f379d'),
('apphy2-mcq-sv-027-v1','apphy2-mcq-027','ddd4587580890eca715673775e730bd4'),
('apphy2-mcq-sv-027-v2','apphy2-mcq-027','0b880dde2a9a0edff8713a3426cf5e5c'),
('apphy2-mcq-sv-027-v3','apphy2-mcq-027','a31f7b27a9e44fa0da8c8176c3dfd44f'),
('apphy2-mcq-sv-028-v1','apphy2-mcq-028','604aa09d9ac44b191a64822e1f37d489'),
('apphy2-mcq-sv-028-v2','apphy2-mcq-028','99f0dc16c37b5fd961bc00103d8fca56'),
('apphy2-mcq-sv-028-v3','apphy2-mcq-028','a804fb05994baee3b4af2f628f77712c'),
('apphy2-mcq-sv-029-v1','apphy2-mcq-029','1f5a7e6bdb337fcc4f0312b8f2349df5'),
('apphy2-mcq-sv-029-v2','apphy2-mcq-029','a9f9e37e13d2b4b297a76ff90fee92d2'),
('apphy2-mcq-sv-030-v1','apphy2-mcq-030','a148d99219037705f33e350f7d7874bd'),
('apphy2-mcq-sv-030-v2','apphy2-mcq-030','4b2db59fc391f7cfd823ad2b7bd3e9dd');
create temporary table tgt on commit drop as
select l.*, ci.id item_id, civ.id version_id, gen_random_uuid() assignment_id, gen_random_uuid() label_id, gen_random_uuid() vd_id,
 sl.required_units req, sl.primary_unit pu, sl.taxonomy_source_version tsv, sc.topic_code topic
from lab l join app.content_items ci on ci.content_key=l.content_key and ci.exam_pack_version_id='f584ab0d-114a-4520-9649-42e3e9a2fd22'
join app.content_item_versions civ on civ.content_item_id=ci.id and civ.version_num=1
join app.content_items si on si.content_key=l.seed and si.exam_pack_version_id='f584ab0d-114a-4520-9649-42e3e9a2fd22' and si.status='published'
join app.content_item_versions sv on sv.content_item_id=si.id and sv.status='published'
join app.content_taxonomy_labels sl on sl.content_item_id=si.id and sl.label_scope='serving' and sl.superseded_by is null and sl.label_status='validated'
join app.content_item_cells sc on sc.content_item_version_id=sv.id and sc.is_primary and sc.superseded_by is null and sc.assignment_status='validated'
where ci.status='draft' and civ.status='draft';
do $$ begin
 if (select count(*) from tgt)<>50 then raise exception 'expected 50 draft targets with a validated seed label and topic cell, got %', (select count(*) from tgt); end if;
 if exists (select 1 from tgt where split_part(topic,'.',1)::int<>pu or pu<>(select max(u) from unnest(req) u)) then raise exception 'seed unit/topic/required-unit mismatch'; end if;
 if exists (select 1 from tgt t join app.content_item_cells c on c.content_item_version_id=t.version_id) or exists (select 1 from tgt t join app.content_taxonomy_labels l on l.content_item_id=t.item_id) then raise exception 'a target already has cells or labels'; end if;
 if (select count(*) from (select t.content_key from tgt t join app.content_item_versions civ on civ.id=t.version_id join app.mcq_choices c on c.content_item_version_id=civ.id group by t.content_key, civ.stem, t.exp_hash having md5(civ.stem||'|'||string_agg(c.choice_key||':'||c.choice_text||':'||c.is_correct::text||':'||c.rationale,'|' order by c.choice_key))=t.exp_hash) z)<>50 then raise exception 'loaded text does not match the build manifest'; end if;
end $$;
insert into app.content_review_assignments (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, review_kind, status, assignment_purpose, created_by)
select assignment_id, version_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'tutor_question', 'mcq', 'pending', 'owner_remediation_approval', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
insert into app.content_review_decisions (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, tutor_score, difficulty_label, diagnostic_flag, concern_codes, note, tutor_decision, decision_payload, decision_hash, created_by)
select assignment_id, version_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'tutor_question', 1, null, false, array[]::text[],
 'AP Physics 2 Units 9-11 variants: publication on Product Owner chat instruction 2026-10-03 (continue: Units 1-3 pipeline). Seed audit and repair; python-verified authoring; two-model blind solve and rationale audit (Gemini 3.8 Flash + DeepSeek V4 Pro) with patch rounds and re-audit; CED scope and topic check against the seed.',
 'approve',
 jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apphy2_variants_po_approval','qa_date','2026-10-03','content_key',content_key,'seed',seed),
 md5(jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apphy2_variants_po_approval','qa_date','2026-10-03','content_key',content_key,'seed',seed)::text),
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
select label_id, item_id, 1, 'serving', req, (select max(u) from unnest(req) u), pu, array[]::text[], tsv, 'provisional', 'provisional_model',
 'apphy2_variants_2026_10_03',
 jsonb_build_object('origin','inherited_from_seed','seed',seed,'units_source','seed current validated serving label; two blind checkers (Gemini 3.8 Flash, DeepSeek V4 Pro) placed the variant in the seed unit and none above it','topic',topic,'report','scripts/content-seed/pipeline-v2-phys2-u13-2026-10-03'),
 'apphy2-variants-labeling-2026-10-03', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
insert into app.content_taxonomy_validation_decisions (validation_decision_id, content_taxonomy_label_id, decided_by, decision, decision_source, reviewed_primary_unit, reviewed_required_units, notes)
select vd_id, label_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'confirmed', 'automated_spot_check', pu, req,
 'Product Owner chat instruction 2026-10-03 (continue: Units 1-3 pipeline, AP Physics 2). Variant inherits its seed unit, required units and topic after a two-checker blind check (unit and topic agreement with the seed).' from tgt;
insert into app.content_item_cells (content_item_version_id, content_item_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id, validated_by, validated_at, validation_decision_id)
select version_id, item_id, tsv, topic, null, true, 'validated', 'apphy2_variants_topic_2026_10_03',
 'apphy2-variants-labeling-2026-10-03 (two blind checkers; topic inherited from the validated seed cell)', null, now(), gen_random_uuid() from tgt;
update app.content_taxonomy_labels l set label_status='validated', validated_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, validated_at=now(), validation_decision_id=t.vd_id, validated_against_version_id=t.version_id, validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id) from tgt t where l.content_taxonomy_label_id=t.label_id;
update app.content_item_versions civ set status='published', published_at=coalesce(civ.published_at,now()), updated_at=now() from tgt where civ.id=tgt.version_id;
update app.content_items ci set status='published', updated_at=now() from tgt where ci.id=tgt.item_id;
do $$ declare n int; begin
  select count(*) into n from (select content_item_id from app.content_item_versions where status='published' group by 1 having count(*)>1) d; if n<>0 then raise exception 'duplicate published versions: %', n; end if;
  if (select count(*) from app.content_items ci join tgt on tgt.item_id=ci.id where ci.status='published')<>50 then raise exception 'publish count mismatch'; end if;
  select count(*) into n from app.content_taxonomy_labels l join tgt t on t.item_id=l.content_item_id where l.label_scope='serving' and l.superseded_by is null and l.label_status='validated' and l.validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id); if n<>50 then raise exception 'label post-check %', n; end if;
  select count(*) into n from app.content_item_cells where source='apphy2_variants_topic_2026_10_03' and is_primary and superseded_by is null; if n<>50 then raise exception 'topic cell count %', n; end if;
end $$;
select (select count(*) from tgt) published, (select count(*) from app.content_taxonomy_labels where source='apphy2_variants_2026_10_03' and label_status='validated') validated_labels, (select count(*) from app.content_item_cells where source='apphy2_variants_topic_2026_10_03') topic_cells;
commit;
