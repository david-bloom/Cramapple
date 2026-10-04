begin;
select pg_advisory_xact_lock(hashtext('cramapple-apphycm-variants-publish-20261003'));
create temporary table lab (content_key text primary key, seed text, exp_hash text) on commit drop;
insert into lab values
('apphycm-mcq-sv-001-v1','apphycm-mcq-001','443d65f7436b928708c9b24cf76822b9'),
('apphycm-mcq-sv-001-v2','apphycm-mcq-001','b3da39eccab3d6fdc50a6bb780f5b6a4'),
('apphycm-mcq-sv-001-v3','apphycm-mcq-001','107b7f91ccfc386a2f6758d3f300f01f'),
('apphycm-mcq-sv-002-v3','apphycm-mcq-002','70bf43c266d29b25a58b2a34d826e914'),
('apphycm-mcq-sv-003-v1','apphycm-mcq-003','843d7ee5798a730f412ab6163ca629b1'),
('apphycm-mcq-sv-003-v2','apphycm-mcq-003','8d9ba86046ff71c3d56750ef532f25e3'),
('apphycm-mcq-sv-003-v3','apphycm-mcq-003','7cc8e26986e94acc805163b46457d4e1'),
('apphycm-mcq-sv-006-v1','apphycm-mcq-006','7744df4010c9677af63af6ef0c133a77'),
('apphycm-mcq-sv-006-v2','apphycm-mcq-006','1a1938c8b728e6780f9058f6515ece2f'),
('apphycm-mcq-sv-006-v3','apphycm-mcq-006','fc03ad40b70ad224ab06c1ee9312ed37'),
('apphycm-mcq-sv-007-v1','apphycm-mcq-007','3f29f8a2254e97925d12f866b894836c'),
('apphycm-mcq-sv-007-v2','apphycm-mcq-007','4151df955141cd256dec238307c4830f'),
('apphycm-mcq-sv-007-v3','apphycm-mcq-007','c639882e0d7dfb72ef90e14b3a9a4601'),
('apphycm-mcq-sv-008-v1','apphycm-mcq-008','3cbe645fec864f6bd3b1ccc1769cbad7'),
('apphycm-mcq-sv-008-v2','apphycm-mcq-008','c9b302f888b871622b6dd5aaafd82e6c'),
('apphycm-mcq-sv-008-v3','apphycm-mcq-008','7bd2861c922de1934b61689e1228c42f'),
('apphycm-mcq-sv-017-v1','apphycm-mcq-017','618def789fe87605a3139caf26aa5b6b'),
('apphycm-mcq-sv-017-v2','apphycm-mcq-017','d0f6d2469fd5f1e092b8efbc281bea0d'),
('apphycm-mcq-sv-017-v3','apphycm-mcq-017','2c527d41db6e0d6fc912ead1bf5599f4'),
('apphycm-mcq-sv-021-v1','apphycm-mcq-021','61342bd91365865631fdac85efb4b2a5'),
('apphycm-mcq-sv-021-v2','apphycm-mcq-021','720110da61312e51596171ff274debc3'),
('apphycm-mcq-sv-021-v3','apphycm-mcq-021','9236a115822a7c476a279a5d6f516e4a'),
('apphycm-mcq-sv-018-v1','apphycm-mcq-018','d3daf5b1bbab3667e35fc2990b831b38'),
('apphycm-mcq-sv-018-v2','apphycm-mcq-018','49979bc87005f2893e4f7f77c174594a'),
('apphycm-mcq-sv-018-v3','apphycm-mcq-018','674cebc8fe8fd0edb7fcf99342a01b82'),
('apphycm-mcq-sv-024-v1','apphycm-mcq-024','ba17befc0020b3f36492be4dc08e17ca'),
('apphycm-mcq-sv-024-v2','apphycm-mcq-024','c3985b82705ff89d6cb7d1f35d7d14ff'),
('apphycm-mcq-sv-024-v3','apphycm-mcq-024','c7cb91e2e39e7bc993ffdfd0db294037'),
('apphycm-mcq-sv-025-v1','apphycm-mcq-025','ead49020947469f470d83ddefa374a28'),
('apphycm-mcq-sv-025-v2','apphycm-mcq-025','bae716e9d516293f46c11ee22954a320'),
('apphycm-mcq-sv-025-v3','apphycm-mcq-025','c52198edee005a6246f9b1e5d551a3c8'),
('apphycm-mcq-sv-026-v1','apphycm-mcq-026','49accec4ad54d0269a194d0fc324ff66'),
('apphycm-mcq-sv-026-v2','apphycm-mcq-026','3211db158ae94fec4f9b89d80139ae8e'),
('apphycm-mcq-sv-026-v3','apphycm-mcq-026','a7f9568addcbd588da9d11bf4d39a913'),
('apphycm-mcq-sv-027-v1','apphycm-mcq-027','dd1c3af597900d7ff1b5fc7a8986eb34'),
('apphycm-mcq-sv-027-v2','apphycm-mcq-027','8eedb707734881bb0e3c7314fa49c938'),
('apphycm-mcq-sv-027-v3','apphycm-mcq-027','02df09a6ba9055417b0376f7b7859786'),
('apphycm-mcq-sv-028-v1','apphycm-mcq-028','dae317ea1ff072084c270aef00fe9f62'),
('apphycm-mcq-sv-028-v2','apphycm-mcq-028','12d9396fcf14a51d47a98a8c9aec5e57'),
('apphycm-mcq-sv-028-v3','apphycm-mcq-028','23b1bbf65ddfd64d4959acd804c52514'),
('apphycm-mcq-sv-030-v1','apphycm-mcq-030','6642b181fa59e83d390f00979a2ce4c2'),
('apphycm-mcq-sv-030-v2','apphycm-mcq-030','f417454caf42bc47d946b57479b3d209'),
('apphycm-mcq-sv-030-v3','apphycm-mcq-030','771e9456e0314ed2d2192d775c5c0069');
create temporary table tgt on commit drop as
select l.*, ci.id item_id, civ.id version_id, gen_random_uuid() assignment_id, gen_random_uuid() label_id, gen_random_uuid() vd_id,
 sl.required_units req, sl.primary_unit pu, sl.taxonomy_source_version tsv, sc.topic_code topic
from lab l join app.content_items ci on ci.content_key=l.content_key and ci.exam_pack_version_id='ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9'
join app.content_item_versions civ on civ.content_item_id=ci.id and civ.version_num=1
join app.content_items si on si.content_key=l.seed and si.exam_pack_version_id='ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9' and si.status='published'
join app.content_item_versions sv on sv.content_item_id=si.id and sv.status='published'
join app.content_taxonomy_labels sl on sl.content_item_id=si.id and sl.label_scope='serving' and sl.superseded_by is null and sl.label_status='validated'
join app.content_item_cells sc on sc.content_item_version_id=sv.id and sc.is_primary and sc.superseded_by is null and sc.assignment_status='validated'
where ci.status='draft' and civ.status='draft';
do $$ begin
 if (select count(*) from tgt)<>43 then raise exception 'expected 43 draft targets with a validated seed label and topic cell, got %', (select count(*) from tgt); end if;
 if exists (select 1 from tgt where split_part(topic,'.',1)::int<>pu or pu<>(select max(u) from unnest(req) u)) then raise exception 'seed unit/topic/required-unit mismatch'; end if;
 if exists (select 1 from tgt t join app.content_item_cells c on c.content_item_version_id=t.version_id) or exists (select 1 from tgt t join app.content_taxonomy_labels l on l.content_item_id=t.item_id) then raise exception 'a target already has cells or labels'; end if;
 if (select count(*) from (select t.content_key from tgt t join app.content_item_versions civ on civ.id=t.version_id join app.mcq_choices c on c.content_item_version_id=civ.id group by t.content_key, civ.stem, t.exp_hash having md5(civ.stem||'|'||string_agg(c.choice_key||':'||c.choice_text||':'||c.is_correct::text||':'||c.rationale,'|' order by c.choice_key))=t.exp_hash) z)<>43 then raise exception 'loaded text does not match the build manifest'; end if;
end $$;
insert into app.content_review_assignments (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, review_kind, status, assignment_purpose, created_by)
select assignment_id, version_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'tutor_question', 'mcq', 'pending', 'owner_remediation_approval', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
insert into app.content_review_decisions (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, tutor_score, difficulty_label, diagnostic_flag, concern_codes, note, tutor_decision, decision_payload, decision_hash, created_by)
select assignment_id, version_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'tutor_question', 1, null, false, array[]::text[],
 'AP Physics C: Mechanics Units 1-3 variants: publication on Product Owner chat instruction 2026-10-03 (continue: Units 1-3 pipeline). Seed audit and repair; python-verified authoring; two-model blind solve and rationale audit (Gemini 3.8 Flash + DeepSeek V4 Pro) with patch rounds and re-audit; CED scope and topic check against the seed.',
 'approve',
 jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apphycm_variants_po_approval','qa_date','2026-10-03','content_key',content_key,'seed',seed),
 md5(jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apphycm_variants_po_approval','qa_date','2026-10-03','content_key',content_key,'seed',seed)::text),
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
 'apphycm_variants_2026_10_03',
 jsonb_build_object('origin','inherited_from_seed','seed',seed,'units_source','seed current validated serving label; two blind checkers (Gemini 3.8 Flash, DeepSeek V4 Pro) placed the variant in the seed unit and none above it','topic',topic,'report','scripts/content-seed/pipeline-v2-physcm-u13-2026-10-03'),
 'apphycm-variants-labeling-2026-10-03', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
insert into app.content_taxonomy_validation_decisions (validation_decision_id, content_taxonomy_label_id, decided_by, decision, decision_source, reviewed_primary_unit, reviewed_required_units, notes)
select vd_id, label_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'confirmed', 'automated_spot_check', pu, req,
 'Product Owner chat instruction 2026-10-03 (continue: Units 1-3 pipeline, AP Physics C: Mechanics). Variant inherits its seed unit, required units and topic after a two-checker blind check (unit and topic agreement with the seed).' from tgt;
insert into app.content_item_cells (content_item_version_id, content_item_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id, validated_by, validated_at, validation_decision_id)
select version_id, item_id, tsv, topic, null, true, 'validated', 'apphycm_variants_topic_2026_10_03',
 'apphycm-variants-labeling-2026-10-03 (two blind checkers; topic inherited from the validated seed cell)', null, now(), gen_random_uuid() from tgt;
update app.content_taxonomy_labels l set label_status='validated', validated_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, validated_at=now(), validation_decision_id=t.vd_id, validated_against_version_id=t.version_id, validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id) from tgt t where l.content_taxonomy_label_id=t.label_id;
update app.content_item_versions civ set status='published', published_at=coalesce(civ.published_at,now()), updated_at=now() from tgt where civ.id=tgt.version_id;
update app.content_items ci set status='published', updated_at=now() from tgt where ci.id=tgt.item_id;
do $$ declare n int; begin
  select count(*) into n from (select content_item_id from app.content_item_versions where status='published' group by 1 having count(*)>1) d; if n<>0 then raise exception 'duplicate published versions: %', n; end if;
  if (select count(*) from app.content_items ci join tgt on tgt.item_id=ci.id where ci.status='published')<>43 then raise exception 'publish count mismatch'; end if;
  select count(*) into n from app.content_taxonomy_labels l join tgt t on t.item_id=l.content_item_id where l.label_scope='serving' and l.superseded_by is null and l.label_status='validated' and l.validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id); if n<>43 then raise exception 'label post-check %', n; end if;
  select count(*) into n from app.content_item_cells where source='apphycm_variants_topic_2026_10_03' and is_primary and superseded_by is null; if n<>43 then raise exception 'topic cell count %', n; end if;
end $$;
select (select count(*) from tgt) published, (select count(*) from app.content_taxonomy_labels where source='apphycm_variants_2026_10_03' and label_status='validated') validated_labels, (select count(*) from app.content_item_cells where source='apphycm_variants_topic_2026_10_03') topic_cells;
commit;
