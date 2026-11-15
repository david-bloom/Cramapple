begin;
select pg_advisory_xact_lock(hashtext('cramapple-apstats-u1b-2026-11-12-publish-20261112'));
create temporary table lab (content_key text primary key, topic text, exp_hash text) on commit drop;
insert into lab values
('apstats-mcq-b6-h-1.8-a','1.8','4716ae164643722662d94392e8edae79'),
('apstats-mcq-b6-sv-h-1.8-a-v1','1.8','db220defe28f895a0022215454fce2c1'),
('apstats-mcq-b6-sv-h-1.8-a-v2','1.8','80e6f902016a90b240a0599d556f6dc4'),
('apstats-mcq-b6-sv-h-1.8-a-v3','1.8','f74b25995e9319b6e0812402d6f5439e'),
('apstats-mcq-b6-h-1.8-b','1.8','13972e1deee7751528ce15b7c90c9cbe'),
('apstats-mcq-b6-sv-h-1.8-b-v1','1.8','7484c254afed843f690c830b70ae949f'),
('apstats-mcq-b6-sv-h-1.8-b-v2','1.8','2664fbf47c7945ce9e5a903b41e1273e'),
('apstats-mcq-b6-sv-h-1.8-b-v3','1.8','58f53167a529cb36572cc4d69e4cd5bd'),
('apstats-mcq-b6-h-1.9-a','1.9','929859d934f0f47d54db2ce962ee3ffa'),
('apstats-mcq-b6-sv-h-1.9-a-v1','1.9','676ff6396d84b0974dfdc615acdda2f4'),
('apstats-mcq-b6-sv-h-1.9-a-v2','1.9','f1744a6b2ee487badb2ddfa95236057f'),
('apstats-mcq-b6-sv-h-1.9-a-v3','1.9','046df7bd0fb56e1f2f465cb5039fba11'),
('apstats-mcq-b6-h-1.9-b','1.9','06fb8bd80b3fbffc7517dd3ffec8a60d'),
('apstats-mcq-b6-sv-h-1.9-b-v1','1.9','0c6437421353bffa905ece0624248f46'),
('apstats-mcq-b6-sv-h-1.9-b-v2','1.9','7b8e58eb14c7af01ee24b9f2c7c04745'),
('apstats-mcq-b6-sv-h-1.9-b-v3','1.9','344e57dc80480c68921e816853219430'),
('apstats-mcq-b6-h-1.10-a','1.10','481172bf69af0136b10c7d08dd3fabe5'),
('apstats-mcq-b6-sv-h-1.10-a-v1','1.10','77bc9153b44f06de55b8a4d406953578'),
('apstats-mcq-b6-sv-h-1.10-a-v2','1.10','830a51743333a669fa15fefde4325456'),
('apstats-mcq-b6-sv-h-1.10-a-v3','1.10','12b203869c4632100719a675be425e15'),
('apstats-mcq-b6-h-1.10-b','1.10','4144dfb55119404d0ccc1c1cefb8855b'),
('apstats-mcq-b6-sv-h-1.10-b-v1','1.10','2cd072633e61d658799914810af91f87'),
('apstats-mcq-b6-sv-h-1.10-b-v2','1.10','6f7ed386fdacad4d6295ba26ea8fb25e'),
('apstats-mcq-b6-sv-h-1.10-b-v3','1.10','e7ede3f63d023051f4f9fc5a89e52291'),
('apstats-mcq-b6-h-1.11-a','1.11','b82ba9b01a5ec33ab048fbfe6e5341d1'),
('apstats-mcq-b6-sv-h-1.11-a-v1','1.11','80c5c09561551977610c1ca851e982c4'),
('apstats-mcq-b6-sv-h-1.11-a-v2','1.11','8ffc30374dd79a9445f95119f86fbd3b'),
('apstats-mcq-b6-sv-h-1.11-a-v3','1.11','03fa7c8f5def240e1f0304b9286ca546'),
('apstats-mcq-b6-h-1.11-b','1.11','95ce9381f77148e93d4b43d176ea6e9e'),
('apstats-mcq-b6-sv-h-1.11-b-v1','1.11','885b4268b1a721d9c4f9fa58659c1e63'),
('apstats-mcq-b6-sv-h-1.11-b-v2','1.11','672ded2c037b06bb43e6914e4a4d8b27'),
('apstats-mcq-b6-sv-h-1.11-b-v3','1.11','e2adbd365a7fff784f17bd15be762cea'),
('apstats-mcq-b6-h-1.12-a','1.12','32caeebebd4c404c5f27d92793667113'),
('apstats-mcq-b6-sv-h-1.12-a-v1','1.12','ed246ca735d39a4a3459821965433623'),
('apstats-mcq-b6-sv-h-1.12-a-v2','1.12','1ad2041ff03e1f33bef3b6804c146ec4'),
('apstats-mcq-b6-sv-h-1.12-a-v3','1.12','d1e89276cdcd7fdd038ab11d577a76b9'),
('apstats-mcq-b6-h-1.12-b','1.12','74baab6a30431aac461477079dcdc9da'),
('apstats-mcq-b6-sv-h-1.12-b-v1','1.12','090c2e4682f0e3cc860dffc30cfe64d1'),
('apstats-mcq-b6-sv-h-1.12-b-v2','1.12','428b0468488d68d95cfb778718ad5890'),
('apstats-mcq-b6-sv-h-1.12-b-v3','1.12','439a7b0bb651584342583dc3b013ef72'),
('apstats-mcq-b6-h-1.13-a','1.13','9a9a78b4832ac40fe2944de3449f0fe3'),
('apstats-mcq-b6-sv-h-1.13-a-v1','1.13','9cbe240c6971b0c1ad866ea4f94d1325'),
('apstats-mcq-b6-sv-h-1.13-a-v2','1.13','c7a4f9dcf12ab0aae218a5fb55266cc3'),
('apstats-mcq-b6-sv-h-1.13-a-v3','1.13','b4119c200b32ecf0f864f48e4c2e3418'),
('apstats-mcq-b6-h-1.13-b','1.13','4cb421ab5f561b37f20bea6bf868cfef'),
('apstats-mcq-b6-sv-h-1.13-b-v1','1.13','9336d835c3d4bc77c6b62796a5be606c'),
('apstats-mcq-b6-sv-h-1.13-b-v2','1.13','dcc698cd061f7e323eb96748384c94d5'),
('apstats-mcq-b6-sv-h-1.13-b-v3','1.13','bf7a1f9dbfc31e6bd4ababe4c8c2db84');
create temporary table tgt on commit drop as
select l.*, ci.id item_id, civ.id version_id, gen_random_uuid() assignment_id, gen_random_uuid() label_id, gen_random_uuid() vd_id,
 'dae3c72e-82ca-4960-9552-1b034bd347e5'::uuid tsv, (case topic when '1.1' then array[1] when '1.10' then array[1] when '1.11' then array[1] when '1.12' then array[1] when '1.13' then array[1] when '1.2' then array[1] when '1.3' then array[1] when '1.4' then array[1] when '1.5' then array[1] when '1.6' then array[1] when '1.7' then array[1] when '1.8' then array[1] when '1.9' then array[1] end)::int[] req, 1 pu
from lab l join app.content_items ci on ci.content_key=l.content_key and ci.exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438'
join app.content_item_versions civ on civ.content_item_id=ci.id and civ.version_num=1
where ci.status='draft' and civ.status='draft';
do $$ begin
 if (select count(*) from tgt)<>48 then raise exception 'expected 48 draft targets, got %', (select count(*) from tgt); end if;
 if exists (select 1 from tgt where split_part(topic,'.',1)::int<>pu) then raise exception 'topic/unit mismatch'; end if;
 if exists (select 1 from tgt t join app.content_item_cells c on c.content_item_version_id=t.version_id) or exists (select 1 from tgt t join app.content_taxonomy_labels l on l.content_item_id=t.item_id) then raise exception 'a target already has cells or labels'; end if;
 if (select count(*) from (select t.content_key from tgt t join app.content_item_versions civ on civ.id=t.version_id join app.mcq_choices c on c.content_item_version_id=civ.id group by t.content_key, civ.stem, t.exp_hash having md5(civ.stem||'|'||string_agg(c.choice_key||':'||c.choice_text||':'||c.is_correct::text||':'||c.rationale,'|' order by c.choice_key))=t.exp_hash) z)<>48 then raise exception 'loaded text does not match the build manifest'; end if;
 if exists (select 1 from tgt t where not exists (select 1 from app.taxonomy_topics tt where tt.taxonomy_source_version=t.tsv and tt.topic_code=t.topic)) then raise exception 'a topic code is not present in the taxonomy source version'; end if;
end $$;
insert into app.content_review_assignments (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, review_kind, status, assignment_purpose, created_by)
select assignment_id, version_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'tutor_question', 'mcq', 'pending', 'owner_remediation_approval', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
insert into app.content_review_decisions (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, tutor_score, difficulty_label, diagnostic_flag, concern_codes, note, tutor_decision, decision_payload, decision_hash, created_by)
select assignment_id, version_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'tutor_question', 1, null, false, array[]::text[],
 'AP Statistics Unit 3 harder seeds and variants (batch apstats_u1b_2026_11_12): Product Owner review of owner-session-authored drafts, 2026-11-12. Arithmetic verified in Python; no model-checker pass, by Product Owner decision.',
 'approve',
 jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apstats_u1b_2026_11_12_po_approval','qa_date','2026-11-12','content_key',content_key),
 md5(jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apstats_u1b_2026_11_12_po_approval','qa_date','2026-11-12','content_key',content_key)::text),
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
select label_id, item_id, 1, 'serving', req, 1, pu, array[]::text[], tsv, 'provisional', 'provisional_model',
 'apstats_u1b_2026_11_12',
 jsonb_build_object('origin','owner_authored','units_source','AP Statistics Unit 1 (topics 1.x belong to unit 3; required_units set per topic from existing Unit 3 labels)','topic',topic,'report','scripts/content-seed/apchem-harder-seeds-u3-2026-11-12'),
 'apstats-u1b-2026-11-12-labeling', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
insert into app.content_taxonomy_validation_decisions (validation_decision_id, content_taxonomy_label_id, decided_by, decision, decision_source, reviewed_primary_unit, reviewed_required_units, notes)
select vd_id, label_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'confirmed', 'chat_review', pu, req,
 'Product Owner chat instruction 2026-11-12 (AP Statistics harder seeds and variants). Topic assigned by the author from the question design (topic recorded on the cell); topic-only tagging, skill left null.' from tgt;
insert into app.content_item_cells (content_item_version_id, content_item_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id, validated_by, validated_at, validation_decision_id)
select version_id, item_id, tsv, topic, null, true, 'validated', 'apstats_u1b_2026_11_12_topic',
 'apstats-u1b-2026-11-12-labeling (topic set by the author from the question design)', null, now(), gen_random_uuid() from tgt;
update app.content_taxonomy_labels l set label_status='validated', validated_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, validated_at=now(), validation_decision_id=t.vd_id, validated_against_version_id=t.version_id, validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id) from tgt t where l.content_taxonomy_label_id=t.label_id;
update app.content_item_versions civ set status='published', published_at=coalesce(civ.published_at,now()), updated_at=now() from tgt where civ.id=tgt.version_id;
update app.content_items ci set status='published', updated_at=now() from tgt where ci.id=tgt.item_id;
do $$ declare n int; begin
  select count(*) into n from (select content_item_id from app.content_item_versions where status='published' group by 1 having count(*)>1) d; if n<>0 then raise exception 'duplicate published versions: %', n; end if;
  if (select count(*) from app.content_items ci join tgt on tgt.item_id=ci.id where ci.status='published')<>48 then raise exception 'publish count mismatch'; end if;
  select count(*) into n from app.content_taxonomy_labels l join tgt t on t.item_id=l.content_item_id where l.label_scope='serving' and l.superseded_by is null and l.label_status='validated' and l.validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id); if n<>48 then raise exception 'label post-check %', n; end if;
  select count(*) into n from app.content_item_cells where source='apstats_u1b_2026_11_12_topic' and is_primary and superseded_by is null; if n<>48 then raise exception 'topic cell count %', n; end if;
end $$;
select (select count(*) from tgt) published, (select count(*) from app.content_taxonomy_labels where source='apstats_u1b_2026_11_12' and label_status='validated') validated_labels, (select count(*) from app.content_item_cells where source='apstats_u1b_2026_11_12_topic') topic_cells;
commit;
