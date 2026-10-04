begin;
select pg_advisory_xact_lock(hashtext('cramapple-apphycem-variants-publish-20261003'));
create temporary table lab (content_key text primary key, seed text, exp_hash text) on commit drop;
insert into lab values
('apphycem-mcq-sv-001-v1','apphycem-mcq-001','fd18a376e2749a3358e9796eec5f3176'),
('apphycem-mcq-sv-001-v2','apphycem-mcq-001','c7244c28876600c82905aa67fadf880f'),
('apphycem-mcq-sv-001-v3','apphycem-mcq-001','3106328290e0b2fada0992aa0c99750f'),
('apphycem-mcq-sv-005-v1','apphycem-mcq-005','7690fe3bd3d2d5693b3a45a6c3eac0ae'),
('apphycem-mcq-sv-005-v2','apphycem-mcq-005','f0d87de71037cbc2bbcf15682388c4d0'),
('apphycem-mcq-sv-005-v3','apphycem-mcq-005','a881f602b00ac0e150b7c84b14451c32'),
('apphycem-mcq-sv-006-v1','apphycem-mcq-006','bc45a263f95c9989e0b84501d307de89'),
('apphycem-mcq-sv-006-v2','apphycem-mcq-006','2a9ee18b38ecd99ce9def2e56764e2f9'),
('apphycem-mcq-sv-006-v3','apphycem-mcq-006','71613d25afbb790a8a89b66c8283a00b'),
('apphycem-mcq-sv-007-v1','apphycem-mcq-007','4738fdb69af2727f4e18ffc2d68561a0'),
('apphycem-mcq-sv-007-v2','apphycem-mcq-007','4fcc608ff2f2dc68d568b4a6ef6165d8'),
('apphycem-mcq-sv-007-v3','apphycem-mcq-007','706358679fb6ecc7e5039823ae679896'),
('apphycem-mcq-sv-008-v1','apphycem-mcq-008','767bc031a42e98eb60bc0d100d5d197f'),
('apphycem-mcq-sv-008-v2','apphycem-mcq-008','ffcd6f98b7f4f0f69eb56564a96d47fe'),
('apphycem-mcq-sv-008-v3','apphycem-mcq-008','7fa9002d2c19871507c3bffa402019f5'),
('apphycem-mcq-sv-009-v1','apphycem-mcq-009','8bbd7db523819afb4193f950517d8231'),
('apphycem-mcq-sv-009-v2','apphycem-mcq-009','0d8a55fe06b82be14cbc187bd02939fd'),
('apphycem-mcq-sv-009-v3','apphycem-mcq-009','f8ebf98f210f92ca91b71489b2f5ee8b'),
('apphycem-mcq-sv-021-v1','apphycem-mcq-021','ab90fe96d6858980445b7638c0306b0e'),
('apphycem-mcq-sv-021-v2','apphycem-mcq-021','69bc1b5cc924abd30f790036acb0b831'),
('apphycem-mcq-sv-021-v3','apphycem-mcq-021','be64964947c66c41e3549d52f8b8ada4'),
('apphycem-mcq-sv-022-v1','apphycem-mcq-022','09c9272ad81460de70673e45e80e3f2d'),
('apphycem-mcq-sv-022-v2','apphycem-mcq-022','cf9615bedde1dcbc1d155edabeb51825'),
('apphycem-mcq-sv-022-v3','apphycem-mcq-022','0c24f2aacace2b2041b0775830d08dde'),
('apphycem-mcq-sv-024-v1','apphycem-mcq-024','8d76d986ed0450c65c1b08c7d35ebdcd'),
('apphycem-mcq-sv-024-v2','apphycem-mcq-024','0ea0588a886e31131360993e040fd171'),
('apphycem-mcq-sv-024-v3','apphycem-mcq-024','7f7c5a66272d68c9251fc78bc4c2f8be'),
('apphycem-mcq-sv-025-v1','apphycem-mcq-025','fa454854fff02d568767d7eefe69c7e5'),
('apphycem-mcq-sv-025-v2','apphycem-mcq-025','dcf1de084f0d67755d99c9e29ab9e642'),
('apphycem-mcq-sv-025-v3','apphycem-mcq-025','903303ecd2ebe2180ef3a37903249236'),
('apphycem-mcq-sv-026-v1','apphycem-mcq-026','ef98d642b182ace97168510ebd652b52'),
('apphycem-mcq-sv-026-v2','apphycem-mcq-026','6243d6c6bba937a14690d9a255bb14a5'),
('apphycem-mcq-sv-026-v3','apphycem-mcq-026','bac048fc7dac7c88d644ac2f3e687d20'),
('apphycem-mcq-sv-027-v1','apphycem-mcq-027','1f6cae91631b77a5db741261f8b37a58'),
('apphycem-mcq-sv-027-v2','apphycem-mcq-027','37433ed3f2dbfac5131ef8beb8dc190b'),
('apphycem-mcq-sv-027-v3','apphycem-mcq-027','cbf2ff7d6c7c1630d90cdb18cf1d9f11'),
('apphycem-mcq-sv-029-v1','apphycem-mcq-029','0b67db17338ef529dc8f6d1bfc346678'),
('apphycem-mcq-sv-029-v2','apphycem-mcq-029','af8171a3c7900fc5e4bb8fb23603130f'),
('apphycem-mcq-sv-029-v3','apphycem-mcq-029','663d0c117634378e5429f947f4fd3d72'),
('apphycem-mcq-sv-030-v1','apphycem-mcq-030','5451f244de9cc1063f6ec8992ecabd1e'),
('apphycem-mcq-sv-030-v2','apphycem-mcq-030','1aa8d6b60019c5858f5dda73640e9c33'),
('apphycem-mcq-sv-030-v3','apphycem-mcq-030','bd78940618606da47d046336be3fb9f5'),
('apphycem-mcq-sv-np1-001-v1','apphycem-mcq-np1-001','f56153f327bf417715dbae88e58d7f88'),
('apphycem-mcq-sv-np1-001-v2','apphycem-mcq-np1-001','c04fc07de90eeb295deca4a3b721bb29'),
('apphycem-mcq-sv-np1-001-v3','apphycem-mcq-np1-001','1f630da3d2d396fa8f10eefda91e4619'),
('apphycem-mcq-sv-np1-002-v1','apphycem-mcq-np1-002','47cf102edb7546bfa3a01976a90c35fc'),
('apphycem-mcq-sv-np1-002-v2','apphycem-mcq-np1-002','564cb5847eb4efb27e7fa6e8fe4dd563'),
('apphycem-mcq-sv-np1-002-v3','apphycem-mcq-np1-002','96c019a3e7ced424a7109e0764d4600a'),
('apphycem-mcq-sv-np1-003-v1','apphycem-mcq-np1-003','277c347725199d7c0ffa98ed0435b1a4'),
('apphycem-mcq-sv-np1-003-v2','apphycem-mcq-np1-003','2bedf520c9711ae3e798ece50df441b2'),
('apphycem-mcq-sv-np1-003-v3','apphycem-mcq-np1-003','6aaaf2a8824408e7456df50880684f2c'),
('apphycem-mcq-sv-np1-004-v1','apphycem-mcq-np1-004','6a2c3d3e7f3638a0e4e1236ff1fdd91d'),
('apphycem-mcq-sv-np1-004-v2','apphycem-mcq-np1-004','8738a6adde8e42cb28853a39c9dbe7ef'),
('apphycem-mcq-sv-np1-004-v3','apphycem-mcq-np1-004','da1876fc99ddfe600ee26f2f5d3bd817'),
('apphycem-mcq-sv-np1-006-v1','apphycem-mcq-np1-006','f1baaa389cbed32e03c4d6230c980a72'),
('apphycem-mcq-sv-np1-006-v2','apphycem-mcq-np1-006','774ba7b55cffb2939e78e870cc99db9b'),
('apphycem-mcq-sv-np1-006-v3','apphycem-mcq-np1-006','d1b96d06a8cf31c4c5a67b0554be0843'),
('apphycem-mcq-sv-np1-009-v1','apphycem-mcq-np1-009','7aab49216d8cc828e937af0bc32d0e86'),
('apphycem-mcq-sv-np1-009-v2','apphycem-mcq-np1-009','ba71aa9bceaa420a39107a02b761835c'),
('apphycem-mcq-sv-np1-009-v3','apphycem-mcq-np1-009','5ab08d7f2cb6d8b06bbdd1cff218b19d'),
('apphycem-mcq-sv-np1-010-v2','apphycem-mcq-np1-010','0e2fcb78007f5f7341c95d27d3b44e0f');
create temporary table tgt on commit drop as
select l.*, ci.id item_id, civ.id version_id, gen_random_uuid() assignment_id, gen_random_uuid() label_id, gen_random_uuid() vd_id,
 sl.required_units req, sl.primary_unit pu, sl.taxonomy_source_version tsv, sc.topic_code topic
from lab l join app.content_items ci on ci.content_key=l.content_key and ci.exam_pack_version_id='841a88cc-773c-44e5-97fa-6504f8667689'
join app.content_item_versions civ on civ.content_item_id=ci.id and civ.version_num=1
join app.content_items si on si.content_key=l.seed and si.exam_pack_version_id='841a88cc-773c-44e5-97fa-6504f8667689' and si.status='published'
join app.content_item_versions sv on sv.content_item_id=si.id and sv.status='published'
join app.content_taxonomy_labels sl on sl.content_item_id=si.id and sl.label_scope='serving' and sl.superseded_by is null and sl.label_status='validated'
join app.content_item_cells sc on sc.content_item_version_id=sv.id and sc.is_primary and sc.superseded_by is null and sc.assignment_status='validated'
where ci.status='draft' and civ.status='draft';
do $$ begin
 if (select count(*) from tgt)<>61 then raise exception 'expected 61 draft targets with a validated seed label and topic cell, got %', (select count(*) from tgt); end if;
 if exists (select 1 from tgt where split_part(topic,'.',1)::int<>pu or pu<>(select max(u) from unnest(req) u)) then raise exception 'seed unit/topic/required-unit mismatch'; end if;
 if exists (select 1 from tgt t join app.content_item_cells c on c.content_item_version_id=t.version_id) or exists (select 1 from tgt t join app.content_taxonomy_labels l on l.content_item_id=t.item_id) then raise exception 'a target already has cells or labels'; end if;
 if (select count(*) from (select t.content_key from tgt t join app.content_item_versions civ on civ.id=t.version_id join app.mcq_choices c on c.content_item_version_id=civ.id group by t.content_key, civ.stem, t.exp_hash having md5(civ.stem||'|'||string_agg(c.choice_key||':'||c.choice_text||':'||c.is_correct::text||':'||c.rationale,'|' order by c.choice_key))=t.exp_hash) z)<>61 then raise exception 'loaded text does not match the build manifest'; end if;
end $$;
insert into app.content_review_assignments (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, review_kind, status, assignment_purpose, created_by)
select assignment_id, version_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'tutor_question', 'mcq', 'pending', 'owner_remediation_approval', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
insert into app.content_review_decisions (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, tutor_score, difficulty_label, diagnostic_flag, concern_codes, note, tutor_decision, decision_payload, decision_hash, created_by)
select assignment_id, version_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'tutor_question', 1, null, false, array[]::text[],
 'AP Physics C: Electricity and Magnetism Units 8-10 variants: publication on Product Owner chat instruction 2026-10-03 (continue: Units 1-3 pipeline). Seed audit and repair; python-verified authoring; two-model blind solve and rationale audit (Gemini 3.8 Flash + DeepSeek V4 Pro) with patch rounds and re-audit; CED scope and topic check against the seed.',
 'approve',
 jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apphycem_variants_po_approval','qa_date','2026-10-03','content_key',content_key,'seed',seed),
 md5(jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apphycem_variants_po_approval','qa_date','2026-10-03','content_key',content_key,'seed',seed)::text),
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
 'apphycem_variants_2026_10_03',
 jsonb_build_object('origin','inherited_from_seed','seed',seed,'units_source','seed current validated serving label; two blind checkers (Gemini 3.8 Flash, DeepSeek V4 Pro) placed the variant in the seed unit and none above it','topic',topic,'report','scripts/content-seed/pipeline-v2-physcem-u13-2026-10-03'),
 'apphycem-variants-labeling-2026-10-03', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
insert into app.content_taxonomy_validation_decisions (validation_decision_id, content_taxonomy_label_id, decided_by, decision, decision_source, reviewed_primary_unit, reviewed_required_units, notes)
select vd_id, label_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'confirmed', 'automated_spot_check', pu, req,
 'Product Owner chat instruction 2026-10-03 (continue: Units 1-3 pipeline, AP Physics C: Electricity and Magnetism). Variant inherits its seed unit, required units and topic after a two-checker blind check (unit and topic agreement with the seed).' from tgt;
insert into app.content_item_cells (content_item_version_id, content_item_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id, validated_by, validated_at, validation_decision_id)
select version_id, item_id, tsv, topic, null, true, 'validated', 'apphycem_variants_topic_2026_10_03',
 'apphycem-variants-labeling-2026-10-03 (two blind checkers; topic inherited from the validated seed cell)', null, now(), gen_random_uuid() from tgt;
update app.content_taxonomy_labels l set label_status='validated', validated_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, validated_at=now(), validation_decision_id=t.vd_id, validated_against_version_id=t.version_id, validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id) from tgt t where l.content_taxonomy_label_id=t.label_id;
update app.content_item_versions civ set status='published', published_at=coalesce(civ.published_at,now()), updated_at=now() from tgt where civ.id=tgt.version_id;
update app.content_items ci set status='published', updated_at=now() from tgt where ci.id=tgt.item_id;
do $$ declare n int; begin
  select count(*) into n from (select content_item_id from app.content_item_versions where status='published' group by 1 having count(*)>1) d; if n<>0 then raise exception 'duplicate published versions: %', n; end if;
  if (select count(*) from app.content_items ci join tgt on tgt.item_id=ci.id where ci.status='published')<>61 then raise exception 'publish count mismatch'; end if;
  select count(*) into n from app.content_taxonomy_labels l join tgt t on t.item_id=l.content_item_id where l.label_scope='serving' and l.superseded_by is null and l.label_status='validated' and l.validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id); if n<>61 then raise exception 'label post-check %', n; end if;
  select count(*) into n from app.content_item_cells where source='apphycem_variants_topic_2026_10_03' and is_primary and superseded_by is null; if n<>61 then raise exception 'topic cell count %', n; end if;
end $$;
select (select count(*) from tgt) published, (select count(*) from app.content_taxonomy_labels where source='apphycem_variants_2026_10_03' and label_status='validated') validated_labels, (select count(*) from app.content_item_cells where source='apphycem_variants_topic_2026_10_03') topic_cells;
commit;
