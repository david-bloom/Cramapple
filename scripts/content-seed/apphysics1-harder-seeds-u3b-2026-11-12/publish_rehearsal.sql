begin;
select pg_advisory_xact_lock(hashtext('cramapple-apphysics1-u3b-2026-11-12-publish-20261112'));
create temporary table lab (content_key text primary key, topic text, exp_hash text) on commit drop;
insert into lab values
('apphysics1-mcq-b2-h-3.1-a','3.1','dfd04d7707d8beb4444a5b145b0f72c6'),
('apphysics1-mcq-b2-sv-h-3.1-a-v1','3.1','7fa42043066fe44e843fab494db65e52'),
('apphysics1-mcq-b2-sv-h-3.1-a-v2','3.1','011757a6b31ea1c1e59bbc1f0aaca909'),
('apphysics1-mcq-b2-sv-h-3.1-a-v3','3.1','12e33df6a5b4a7350ff088d05f32a188'),
('apphysics1-mcq-b2-h-3.1-b','3.1','7e81d25d584e4a1892ff00f31b6e673a'),
('apphysics1-mcq-b2-sv-h-3.1-b-v1','3.1','3e2481ab9a159d7d3ee7e5f313bda4b2'),
('apphysics1-mcq-b2-sv-h-3.1-b-v2','3.1','fe365bace214063d211fa7b5921ed6bd'),
('apphysics1-mcq-b2-sv-h-3.1-b-v3','3.1','c8e3d03a36d14446ef5fbcbc7f0e42e8'),
('apphysics1-mcq-b2-h-3.2-a','3.2','949d4d4738f69fac6677370d20deec7b'),
('apphysics1-mcq-b2-sv-h-3.2-a-v1','3.2','6c09aa16b4b03f2999f5db8bbf129ef2'),
('apphysics1-mcq-b2-sv-h-3.2-a-v2','3.2','46ac4d4d3b66a3dcbb4fb0b99f5ed1f5'),
('apphysics1-mcq-b2-sv-h-3.2-a-v3','3.2','4a643b1b3cc364a42ecacc3db4520bdc'),
('apphysics1-mcq-b2-h-3.2-b','3.2','c890967a3f919b83d5ea5027e47230d9'),
('apphysics1-mcq-b2-sv-h-3.2-b-v1','3.2','5fade06877912e89e1cc69874340fc06'),
('apphysics1-mcq-b2-sv-h-3.2-b-v2','3.2','7f37a2fbb48f73fa1502f84c00adbd6f'),
('apphysics1-mcq-b2-sv-h-3.2-b-v3','3.2','e80a1b9a829a56205d5106cc81df9e3a'),
('apphysics1-mcq-b2-h-3.3-a','3.3','e287d3dfd346a0dc6aba85488ee90e0f'),
('apphysics1-mcq-b2-sv-h-3.3-a-v1','3.3','9ad9cde71f454c1d2fc09a91d4e40333'),
('apphysics1-mcq-b2-sv-h-3.3-a-v2','3.3','1551de19d031f849ad3c6d39ffc8812e'),
('apphysics1-mcq-b2-sv-h-3.3-a-v3','3.3','913464c0855ec54514f93db41b6623f0'),
('apphysics1-mcq-b2-h-3.3-b','3.3','334871456037207e9dc4f7fe680daf74'),
('apphysics1-mcq-b2-sv-h-3.3-b-v1','3.3','b824a25adf26772634514891b2fd23ad'),
('apphysics1-mcq-b2-sv-h-3.3-b-v2','3.3','9e21062737ef407ff4b1ad57d919a829'),
('apphysics1-mcq-b2-sv-h-3.3-b-v3','3.3','fa409b80370e09473403c43921d5a1f5'),
('apphysics1-mcq-b2-h-3.4-a','3.4','e0e6661de385fb396fb2f51b2c930004'),
('apphysics1-mcq-b2-sv-h-3.4-a-v1','3.4','b40103900e34492c24b727a48f090022'),
('apphysics1-mcq-b2-sv-h-3.4-a-v2','3.4','6bb014d1ff9ca51e6d1405cbcc47f9c8'),
('apphysics1-mcq-b2-sv-h-3.4-a-v3','3.4','02d857aac918ae9e5d54ea373b2ab365'),
('apphysics1-mcq-b2-h-3.4-b','3.4','43394e8dcd773db025763c03c2b333b0'),
('apphysics1-mcq-b2-sv-h-3.4-b-v1','3.4','1840d542d821be68acd9b6c5d57dd923'),
('apphysics1-mcq-b2-sv-h-3.4-b-v2','3.4','b30595564443d0a3384cb4ef74480c84'),
('apphysics1-mcq-b2-sv-h-3.4-b-v3','3.4','1b64fa02d0995f111c212e8f1e62e921'),
('apphysics1-mcq-b2-h-3.5-a','3.5','d68173a38e533600b5aca1b20fdc2862'),
('apphysics1-mcq-b2-sv-h-3.5-a-v1','3.5','49b85b0859c7558d03778fcdf2f63e97'),
('apphysics1-mcq-b2-sv-h-3.5-a-v2','3.5','4d080efa1e8e0fc9efe8b9519bb46e22'),
('apphysics1-mcq-b2-sv-h-3.5-a-v3','3.5','5a3091e873eb4ba16ba9b7ba8c3cc9d1'),
('apphysics1-mcq-b2-h-3.5-b','3.5','0f9305e3b54a250f3b38e7784e7c781f'),
('apphysics1-mcq-b2-sv-h-3.5-b-v1','3.5','6f7f8d85dafdb99f6d990d24538acd00'),
('apphysics1-mcq-b2-sv-h-3.5-b-v2','3.5','bc7d96eed023715203a30f52eadd757c'),
('apphysics1-mcq-b2-sv-h-3.5-b-v3','3.5','8c1b49a3ecc959cbd9d6248f75c43046');
create temporary table tgt on commit drop as
select l.*, ci.id item_id, civ.id version_id, gen_random_uuid() assignment_id, gen_random_uuid() label_id, gen_random_uuid() vd_id,
 '27111dec-ee07-48f1-86cf-1a5833dd2962'::uuid tsv, (case topic when '3.1' then array[3] when '3.2' then array[3] when '3.3' then array[3] when '3.4' then array[3] when '3.5' then array[3] end)::int[] req, 3 pu
from lab l join app.content_items ci on ci.content_key=l.content_key and ci.exam_pack_version_id='29c719dc-701b-470f-9e49-fab981722d3f'
join app.content_item_versions civ on civ.content_item_id=ci.id and civ.version_num=1
where ci.status='draft' and civ.status='draft';
do $$ begin
 if (select count(*) from tgt)<>40 then raise exception 'expected 40 draft targets, got %', (select count(*) from tgt); end if;
 if exists (select 1 from tgt where split_part(topic,'.',1)::int<>pu) then raise exception 'topic/unit mismatch'; end if;
 if exists (select 1 from tgt t join app.content_item_cells c on c.content_item_version_id=t.version_id) or exists (select 1 from tgt t join app.content_taxonomy_labels l on l.content_item_id=t.item_id) then raise exception 'a target already has cells or labels'; end if;
 if (select count(*) from (select t.content_key from tgt t join app.content_item_versions civ on civ.id=t.version_id join app.mcq_choices c on c.content_item_version_id=civ.id group by t.content_key, civ.stem, t.exp_hash having md5(civ.stem||'|'||string_agg(c.choice_key||':'||c.choice_text||':'||c.is_correct::text||':'||c.rationale,'|' order by c.choice_key))=t.exp_hash) z)<>40 then raise exception 'loaded text does not match the build manifest'; end if;
 if exists (select 1 from tgt t where not exists (select 1 from app.content_item_cells c join app.content_items ci2 on ci2.id=c.content_item_id where ci2.exam_pack_version_id='29c719dc-701b-470f-9e49-fab981722d3f' and c.topic_code=t.topic and c.taxonomy_source_version=t.tsv and c.superseded_by is null)) then raise exception 'a topic code is not present in the AP Physics 1 taxonomy source version'; end if;
end $$;
insert into app.content_review_assignments (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, review_kind, status, assignment_purpose, created_by)
select assignment_id, version_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'tutor_question', 'mcq', 'pending', 'owner_remediation_approval', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
insert into app.content_review_decisions (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, tutor_score, difficulty_label, diagnostic_flag, concern_codes, note, tutor_decision, decision_payload, decision_hash, created_by)
select assignment_id, version_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'tutor_question', 1, null, false, array[]::text[],
 'AP Physics 1 Unit 3 harder seeds and variants (batch apphysics1_u3b_2026_11_12): Product Owner review of owner-session-authored drafts, 2026-11-12. Arithmetic verified in Python; no model-checker pass, by Product Owner decision.',
 'approve',
 jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apphysics1_u3b_2026_11_12_po_approval','qa_date','2026-11-12','content_key',content_key),
 md5(jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apphysics1_u3b_2026_11_12_po_approval','qa_date','2026-11-12','content_key',content_key)::text),
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
select label_id, item_id, 1, 'serving', req, 3, pu, array[]::text[], tsv, 'provisional', 'provisional_model',
 'apphysics1_u3b_2026_11_12',
 jsonb_build_object('origin','owner_authored','units_source','AP Physics 1 Unit 3 (topics 3.x belong to unit 3; required_units set per topic from existing Unit 3 labels)','topic',topic,'report','scripts/content-seed/apchem-harder-seeds-u3-2026-11-12'),
 'apphysics1-u3b-2026-11-12-labeling', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
insert into app.content_taxonomy_validation_decisions (validation_decision_id, content_taxonomy_label_id, decided_by, decision, decision_source, reviewed_primary_unit, reviewed_required_units, notes)
select vd_id, label_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'confirmed', 'chat_review', pu, req,
 'Product Owner chat instruction 2026-11-12 (AP Physics 1 harder seeds and variants). Topic assigned by the author from the question design (topic recorded on the cell); topic-only tagging, skill left null.' from tgt;
insert into app.content_item_cells (content_item_version_id, content_item_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id, validated_by, validated_at, validation_decision_id)
select version_id, item_id, tsv, topic, null, true, 'validated', 'apphysics1_u3b_2026_11_12_topic',
 'apphysics1-u3b-2026-11-12-labeling (topic set by the author from the question design)', null, now(), gen_random_uuid() from tgt;
update app.content_taxonomy_labels l set label_status='validated', validated_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, validated_at=now(), validation_decision_id=t.vd_id, validated_against_version_id=t.version_id, validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id) from tgt t where l.content_taxonomy_label_id=t.label_id;
update app.content_item_versions civ set status='published', published_at=coalesce(civ.published_at,now()), updated_at=now() from tgt where civ.id=tgt.version_id;
update app.content_items ci set status='published', updated_at=now() from tgt where ci.id=tgt.item_id;
do $$ declare n int; begin
  select count(*) into n from (select content_item_id from app.content_item_versions where status='published' group by 1 having count(*)>1) d; if n<>0 then raise exception 'duplicate published versions: %', n; end if;
  if (select count(*) from app.content_items ci join tgt on tgt.item_id=ci.id where ci.status='published')<>40 then raise exception 'publish count mismatch'; end if;
  select count(*) into n from app.content_taxonomy_labels l join tgt t on t.item_id=l.content_item_id where l.label_scope='serving' and l.superseded_by is null and l.label_status='validated' and l.validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id); if n<>40 then raise exception 'label post-check %', n; end if;
  select count(*) into n from app.content_item_cells where source='apphysics1_u3b_2026_11_12_topic' and is_primary and superseded_by is null; if n<>40 then raise exception 'topic cell count %', n; end if;
end $$;
do $$ begin raise exception 'REHEARSAL OK (rolled back): published=%, validated_labels=%, topic_cells=%', (select count(*) from tgt), (select count(*) from app.content_taxonomy_labels where source='apphysics1_u3b_2026_11_12' and label_status='validated'), (select count(*) from app.content_item_cells where source='apphysics1_u3b_2026_11_12_topic'); end $$;
rollback;
