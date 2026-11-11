begin;
select pg_advisory_xact_lock(hashtext('cramapple-apstats-u4-harder-publish-20261111'));
create temporary table lab (content_key text primary key, topic text, exp_hash text) on commit drop;
insert into lab values
('APSTATS-MCQ-H-4.1-A','4.1','ce72b72f2a14ed47f35f8cb7e9c4f7a8'),
('APSTATS-MCQ-SV-H-4.1-A-v1','4.1','e376ec0329abc32a980d65e97689fad5'),
('APSTATS-MCQ-SV-H-4.1-A-v2','4.1','fed9255679be5f00bb71464a1ddfae39'),
('APSTATS-MCQ-SV-H-4.1-A-v3','4.1','06980a38872759852252deb4f07860f2'),
('APSTATS-MCQ-H-4.1-B','4.1','d0299c2751243a07e68a4295bd3271ad'),
('APSTATS-MCQ-SV-H-4.1-B-v1','4.1','193dd779cc87aa748f695f8c974082e4'),
('APSTATS-MCQ-SV-H-4.1-B-v2','4.1','fffdf6523df351b528802215de008628'),
('APSTATS-MCQ-SV-H-4.1-B-v3','4.1','4d609c9d05ebeb65e7250bbee2a36f48'),
('APSTATS-MCQ-H-4.2-A','4.2','9e98c9609a210476fec19d0eabf96073'),
('APSTATS-MCQ-SV-H-4.2-A-v1','4.2','47c3646bc56a06456bf4433f97a8f7d5'),
('APSTATS-MCQ-SV-H-4.2-A-v2','4.2','e4fa08f319ec271aef634cd1ff18219b'),
('APSTATS-MCQ-SV-H-4.2-A-v3','4.2','47987f1c1ecb42f8cba64a30f2827009'),
('APSTATS-MCQ-H-4.2-B','4.2','b9f1a93503bf0b5ebf21d89a19e7cac5'),
('APSTATS-MCQ-SV-H-4.2-B-v1','4.2','1e8bd870a46e101f69c18909a387f420'),
('APSTATS-MCQ-SV-H-4.2-B-v2','4.2','1656133795666a5db53d8b55390ec9f7'),
('APSTATS-MCQ-SV-H-4.2-B-v3','4.2','17b1559c8510536b1a69b16e4d55cd08'),
('APSTATS-MCQ-H-4.3-A','4.3','9bf56d3583c6a9a584c7f26265db7aa1'),
('APSTATS-MCQ-SV-H-4.3-A-v1','4.3','255173b0eeda0411c3d439e180e1fbe8'),
('APSTATS-MCQ-SV-H-4.3-A-v2','4.3','e3ac9c348bdc20367f068c4384b6c836'),
('APSTATS-MCQ-SV-H-4.3-A-v3','4.3','e00a6fd5ee2aec8beee1ea600ef20715'),
('APSTATS-MCQ-H-4.4-A','4.4','298943da57084a5360b1dc8afb65a751'),
('APSTATS-MCQ-SV-H-4.4-A-v1','4.4','108777f67bb2649bfb91e0f61532408e'),
('APSTATS-MCQ-SV-H-4.4-A-v2','4.4','44e84574c130122154fa6f7bd3732445'),
('APSTATS-MCQ-SV-H-4.4-A-v3','4.4','aabfec242ae2f3b9eb4c1f2bd95a7a90'),
('APSTATS-MCQ-H-4.5-A','4.5','e761cc28680d6499dc7936afba919cf1'),
('APSTATS-MCQ-SV-H-4.5-A-v1','4.5','9894f9804f9bf8dfffb3d48ad0cdb283'),
('APSTATS-MCQ-SV-H-4.5-A-v2','4.5','1b758cdb7c4a8f52b2b6b1f648df8471'),
('APSTATS-MCQ-SV-H-4.5-A-v3','4.5','1223fdde0df58c9a4db3171e19888d6c'),
('APSTATS-MCQ-H-4.6-A','4.6','dfac32a2e20a75358f3bf79ad0806c07'),
('APSTATS-MCQ-SV-H-4.6-A-v1','4.6','1ee0057e9b9b741f7795a22a7247c530'),
('APSTATS-MCQ-SV-H-4.6-A-v2','4.6','5554a50e48f271d3674a338765fa11ea'),
('APSTATS-MCQ-SV-H-4.6-A-v3','4.6','601c5f5763e48b21e1b4d6a5831e9dcc'),
('APSTATS-MCQ-H-4.7-A','4.7','c40d033cd4937610c306d7d1bd371b5e'),
('APSTATS-MCQ-SV-H-4.7-A-v1','4.7','e6b6a4b2e0fa62f7f67688161aecf885'),
('APSTATS-MCQ-SV-H-4.7-A-v2','4.7','19d6feafb6ab74e24d3e1fbb244bfbeb'),
('APSTATS-MCQ-SV-H-4.7-A-v3','4.7','e5b359a8c3d02b98730e088b241f3e58'),
('APSTATS-MCQ-H-4.8-A','4.8','9bf9161a5a1d754a45fb6a2ff199e0d9'),
('APSTATS-MCQ-SV-H-4.8-A-v1','4.8','7894343ea660bb4cda7435bae7657a2c'),
('APSTATS-MCQ-SV-H-4.8-A-v2','4.8','1177e8fe827c3917ae44428663d2a03b'),
('APSTATS-MCQ-SV-H-4.8-A-v3','4.8','31441960d9951d678ca4ff7e58e57b6f'),
('APSTATS-MCQ-H-4.9-A','4.9','d89027ad30e0c59dc6076578d0675370'),
('APSTATS-MCQ-SV-H-4.9-A-v1','4.9','b823c3a9af1e5cfedae2a48b2ecc76e5'),
('APSTATS-MCQ-SV-H-4.9-A-v2','4.9','b5dd43a17fa3ecedae181467ca339b2f'),
('APSTATS-MCQ-SV-H-4.9-A-v3','4.9','4d80afe5f0954bf4d47ca49a08663ba4'),
('APSTATS-MCQ-H-4.10-A','4.10','c50a65c52dfc66d7b46502d554a91c32'),
('APSTATS-MCQ-SV-H-4.10-A-v1','4.10','0e38d84b6aa11235dc73b6171f934522'),
('APSTATS-MCQ-SV-H-4.10-A-v2','4.10','9b4ab27af9ec4a6165ac6842fbb7621b'),
('APSTATS-MCQ-SV-H-4.10-A-v3','4.10','93dc8bd0577da0f4b3036f782da629b8');
create temporary table tgt on commit drop as
select l.*, ci.id item_id, civ.id version_id, gen_random_uuid() assignment_id, gen_random_uuid() label_id, gen_random_uuid() vd_id,
 'dae3c72e-82ca-4960-9552-1b034bd347e5'::uuid tsv, array[4]::int[] req, 4 pu
from lab l join app.content_items ci on ci.content_key=l.content_key and ci.exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438'
join app.content_item_versions civ on civ.content_item_id=ci.id and civ.version_num=1
where ci.status='draft' and civ.status='draft';
do $$ begin
 if (select count(*) from tgt)<>48 then raise exception 'expected 48 draft targets, got %', (select count(*) from tgt); end if;
 if exists (select 1 from tgt where split_part(topic,'.',1)::int<>pu) then raise exception 'topic/unit mismatch'; end if;
 if exists (select 1 from tgt t join app.content_item_cells c on c.content_item_version_id=t.version_id) or exists (select 1 from tgt t join app.content_taxonomy_labels l on l.content_item_id=t.item_id) then raise exception 'a target already has cells or labels'; end if;
 if (select count(*) from (select t.content_key from tgt t join app.content_item_versions civ on civ.id=t.version_id join app.mcq_choices c on c.content_item_version_id=civ.id group by t.content_key, civ.stem, t.exp_hash having md5(civ.stem||'|'||string_agg(c.choice_key||':'||c.choice_text||':'||c.is_correct::text||':'||c.rationale,'|' order by c.choice_key))=t.exp_hash) z)<>48 then raise exception 'loaded text does not match the build manifest'; end if;
 if exists (select 1 from tgt t where not exists (select 1 from app.content_item_cells c join app.content_items ci2 on ci2.id=c.content_item_id where ci2.exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and c.topic_code=t.topic and c.taxonomy_source_version=t.tsv and c.superseded_by is null)) then raise exception 'a topic code is not present in the Statistics taxonomy source version'; end if;
end $$;
insert into app.content_review_assignments (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, review_kind, status, assignment_purpose, created_by)
select assignment_id, version_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'tutor_question', 'mcq', 'pending', 'owner_remediation_approval', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
insert into app.content_review_decisions (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, tutor_score, difficulty_label, diagnostic_flag, concern_codes, note, tutor_decision, decision_payload, decision_hash, created_by)
select assignment_id, version_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'tutor_question', 1, null, false, array[]::text[],
 'AP Statistics Unit 4 harder seeds and variants (topics 4.1 to 4.10): Product Owner review of owner-session-authored drafts, 2026-11-11. Arithmetic verified in Python; no model-checker pass, by Product Owner decision.',
 'approve',
 jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apstats_u4_harder_po_approval','qa_date','2026-11-11','content_key',content_key),
 md5(jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apstats_u4_harder_po_approval','qa_date','2026-11-11','content_key',content_key)::text),
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
select label_id, item_id, 1, 'serving', req, 4, pu, array[]::text[], tsv, 'provisional', 'provisional_model',
 'apstats_u4_harder_2026_11_11',
 jsonb_build_object('origin','owner_authored','units_source','Statistics Unit 4 (all topics 4.x belong to unit 4; existing Unit 4 serving labels use required_units [4], primary_unit 4)','topic',topic,'report','scripts/content-seed/ap-statistics-unit4-harder-seeds-2026-11-11'),
 'apstats-u4-harder-labeling-2026-11-11', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
insert into app.content_taxonomy_validation_decisions (validation_decision_id, content_taxonomy_label_id, decided_by, decision, decision_source, reviewed_primary_unit, reviewed_required_units, notes)
select vd_id, label_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'confirmed', 'chat_review', pu, req,
 'Product Owner chat instruction 2026-11-11 (AP Statistics Unit 4 harder seeds and variants). Topic assigned by the author from the question design (topic recorded on the cell); topic-only tagging, skill left null.' from tgt;
insert into app.content_item_cells (content_item_version_id, content_item_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id, validated_by, validated_at, validation_decision_id)
select version_id, item_id, tsv, topic, null, true, 'validated', 'apstats_u4_harder_topic_2026_11_11',
 'apstats-u4-harder-labeling-2026-11-11 (topic set by the author from the question design)', null, now(), gen_random_uuid() from tgt;
update app.content_taxonomy_labels l set label_status='validated', validated_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, validated_at=now(), validation_decision_id=t.vd_id, validated_against_version_id=t.version_id, validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id) from tgt t where l.content_taxonomy_label_id=t.label_id;
update app.content_item_versions civ set status='published', published_at=coalesce(civ.published_at,now()), updated_at=now() from tgt where civ.id=tgt.version_id;
update app.content_items ci set status='published', updated_at=now() from tgt where ci.id=tgt.item_id;
do $$ declare n int; begin
  select count(*) into n from (select content_item_id from app.content_item_versions where status='published' group by 1 having count(*)>1) d; if n<>0 then raise exception 'duplicate published versions: %', n; end if;
  if (select count(*) from app.content_items ci join tgt on tgt.item_id=ci.id where ci.status='published')<>48 then raise exception 'publish count mismatch'; end if;
  select count(*) into n from app.content_taxonomy_labels l join tgt t on t.item_id=l.content_item_id where l.label_scope='serving' and l.superseded_by is null and l.label_status='validated' and l.validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id); if n<>48 then raise exception 'label post-check %', n; end if;
  select count(*) into n from app.content_item_cells where source='apstats_u4_harder_topic_2026_11_11' and is_primary and superseded_by is null; if n<>48 then raise exception 'topic cell count %', n; end if;
end $$;
select (select count(*) from tgt) published, (select count(*) from app.content_taxonomy_labels where source='apstats_u4_harder_2026_11_11' and label_status='validated') validated_labels, (select count(*) from app.content_item_cells where source='apstats_u4_harder_topic_2026_11_11') topic_cells;
commit;
