begin;
select pg_advisory_xact_lock(hashtext('cramapple-heldfour-variants-publish-20261004'));
create temporary table lab (content_key text primary key, pack uuid, seed text, exp_hash text) on commit drop;
insert into lab values
('apphycem-mcq-sv-003-v1','841a88cc-773c-44e5-97fa-6504f8667689'::uuid,'apphycem-mcq-003','3cf72749c7f8faaf5d01e6945656fa24'),
('apphycem-mcq-sv-003-v2','841a88cc-773c-44e5-97fa-6504f8667689'::uuid,'apphycem-mcq-003','08e7182ed7fc001f9bf2bf362b53fd00'),
('apphycem-mcq-sv-003-v3','841a88cc-773c-44e5-97fa-6504f8667689'::uuid,'apphycem-mcq-003','30b718fa7ba98b7417c4affb68d530e1'),
('apphycm-mcq-sv-031-v1','ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9'::uuid,'apphycm-mcq-031','a1ae939ac1fa888e862cbfd091c1937b'),
('apphycm-mcq-sv-031-v2','ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9'::uuid,'apphycm-mcq-031','0a9cc68eabfa0bedf4235609c3c2901b'),
('apphycm-mcq-sv-031-v3','ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9'::uuid,'apphycm-mcq-031','fe519d44d626d2b9453ca820a3e218ae'),
('apphy2-mcq-sv-001-v1','f584ab0d-114a-4520-9649-42e3e9a2fd22'::uuid,'apphy2-mcq-001','47c305a57d6e4b30c60f99b15fdf78be'),
('apphy2-mcq-sv-001-v2','f584ab0d-114a-4520-9649-42e3e9a2fd22'::uuid,'apphy2-mcq-001','710b2183187b42d32c3915486b7d823c'),
('apphy2-mcq-sv-001-v3','f584ab0d-114a-4520-9649-42e3e9a2fd22'::uuid,'apphy2-mcq-001','caa5f0b64be8cc26abacbaa3a760ae65');
create temporary table tgt on commit drop as
select l.*, ci.id item_id, civ.id version_id, gen_random_uuid() assignment_id, gen_random_uuid() label_id, gen_random_uuid() vd_id,
 sl.required_units req, sl.primary_unit pu, sl.taxonomy_source_version tsv, sc.topic_code topic
from lab l join app.content_items ci on ci.content_key=l.content_key and ci.exam_pack_version_id=l.pack
join app.content_item_versions civ on civ.content_item_id=ci.id and civ.version_num=1
join app.content_items si on si.content_key=l.seed and si.exam_pack_version_id=l.pack and si.status='published'
join app.content_item_versions sv on sv.content_item_id=si.id and sv.status='published'
join app.content_taxonomy_labels sl on sl.content_item_id=si.id and sl.label_scope='serving' and sl.superseded_by is null and sl.label_status='validated'
join app.content_item_cells sc on sc.content_item_version_id=sv.id and sc.is_primary and sc.superseded_by is null and sc.assignment_status='validated'
where ci.status='draft' and civ.status='draft';
do $$ begin
 if (select count(*) from tgt)<>9 then raise exception 'expected 9 draft targets with a validated seed label and topic cell, got %', (select count(*) from tgt); end if;
 if exists (select 1 from tgt where split_part(topic,'.',1)::int<>pu or pu<>(select max(u) from unnest(req) u)) then raise exception 'seed unit/topic/required-unit mismatch'; end if;
 if exists (select 1 from tgt t join app.content_item_cells c on c.content_item_version_id=t.version_id) or exists (select 1 from tgt t join app.content_taxonomy_labels l on l.content_item_id=t.item_id) then raise exception 'a target already has cells or labels'; end if;
 if exists (select 1 from app.content_taxonomy_labels where source='heldfour_variants_2026_10_04') or exists (select 1 from app.content_item_cells where source='heldfour_variants_topic_2026_10_04') then raise exception 'already published (label or cell source exists)'; end if;
 if (select count(*) from (select t.content_key from tgt t join app.content_item_versions civ on civ.id=t.version_id join app.mcq_choices c on c.content_item_version_id=civ.id group by t.content_key, civ.stem, t.exp_hash having md5(civ.stem||'|'||string_agg(c.choice_key||':'||c.choice_text||':'||c.is_correct::text||':'||c.rationale,'|' order by c.choice_key))=t.exp_hash) z)<>9 then raise exception 'loaded text does not match the build manifest'; end if;
end $$;
insert into app.content_review_assignments (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, review_kind, status, assignment_purpose, created_by)
select assignment_id, version_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'tutor_question', 'mcq', 'pending', 'owner_remediation_approval', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
insert into app.content_review_decisions (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, tutor_score, difficulty_label, diagnostic_flag, concern_codes, note, tutor_decision, decision_payload, decision_hash, created_by)
select assignment_id, version_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'tutor_question', 1, null, false, array[]::text[],
 'Held-four seed variants (AP Physics C E&M, AP Physics C Mechanics, AP Physics 2): publication on Product Owner chat instruction 2026-10-04. Python/sympy-verified authoring; two-model blind solve and rationale audit (Gemini 3.8 Flash + DeepSeek V4 Pro); CED scope and topic check against the seed.',
 'approve',
 jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','heldfour_variants_po_approval','qa_date','2026-10-04','content_key',content_key,'seed',seed),
 md5(jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','heldfour_variants_po_approval','qa_date','2026-10-04','content_key',content_key,'seed',seed)::text),
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
 'heldfour_variants_2026_10_04',
 jsonb_build_object('origin','inherited_from_seed','seed',seed,'units_source','seed current validated serving label; two blind checkers (Gemini 3.8 Flash, DeepSeek V4 Pro) placed the variant in the seed unit and none above it','topic',topic,'report','scripts/content-seed/release-held-four-2026-10-04'),
 'heldfour-variants-labeling-2026-10-04', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
insert into app.content_taxonomy_validation_decisions (validation_decision_id, content_taxonomy_label_id, decided_by, decision, decision_source, reviewed_primary_unit, reviewed_required_units, notes)
select vd_id, label_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'confirmed', 'automated_spot_check', pu, req,
 'Product Owner chat instruction 2026-10-04 (held-four seed variants). Variant inherits its seed unit, required units and topic after a two-checker blind check (unit and topic agreement with the seed).' from tgt;
insert into app.content_item_cells (content_item_version_id, content_item_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id, validated_by, validated_at, validation_decision_id)
select version_id, item_id, tsv, topic, null, true, 'validated', 'heldfour_variants_topic_2026_10_04',
 'heldfour-variants-labeling-2026-10-04 (two blind checkers; topic inherited from the validated seed cell)', null, now(), gen_random_uuid() from tgt;
update app.content_taxonomy_labels l set label_status='validated', validated_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, validated_at=now(), validation_decision_id=t.vd_id, validated_against_version_id=t.version_id, validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id) from tgt t where l.content_taxonomy_label_id=t.label_id;
update app.content_item_versions civ set status='published', published_at=coalesce(civ.published_at,now()), updated_at=now() from tgt where civ.id=tgt.version_id;
update app.content_items ci set status='published', updated_at=now() from tgt where ci.id=tgt.item_id;
do $$ declare n int; begin
  select count(*) into n from (select content_item_id from app.content_item_versions where status='published' group by 1 having count(*)>1) d; if n<>0 then raise exception 'duplicate published versions: %', n; end if;
  if (select count(*) from app.content_items ci join tgt on tgt.item_id=ci.id where ci.status='published')<>9 then raise exception 'publish count mismatch'; end if;
  select count(*) into n from app.content_taxonomy_labels l join tgt t on t.item_id=l.content_item_id where l.label_scope='serving' and l.superseded_by is null and l.label_status='validated' and l.validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id); if n<>9 then raise exception 'label post-check %', n; end if;
  select count(*) into n from app.content_item_cells where source='heldfour_variants_topic_2026_10_04' and is_primary and superseded_by is null; if n<>9 then raise exception 'topic cell count %', n; end if;
end $$;
do $$ begin raise exception 'REHEARSAL OK (rolled back): published=%, validated_labels=%, topic_cells=%', (select count(*) from tgt), (select count(*) from app.content_taxonomy_labels where source='heldfour_variants_2026_10_04' and label_status='validated'), (select count(*) from app.content_item_cells where source='heldfour_variants_topic_2026_10_04'); end $$;
rollback;
