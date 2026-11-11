begin;
select pg_advisory_xact_lock(hashtext('cramapple-apphysics1-u4-2026-11-12-publish-20261112'));
create temporary table lab (content_key text primary key, topic text, exp_hash text) on commit drop;
insert into lab values
('apphysics1-mcq-b4-h-4.1-a','4.1','a09afd379bc4cee1b6959c0e976bb77d'),
('apphysics1-mcq-b4-sv-h-4.1-a-v1','4.1','1ee7634ec22c4a6620246ef4332744a2'),
('apphysics1-mcq-b4-sv-h-4.1-a-v2','4.1','eb825de363f6f0cbe5f5323b347da93c'),
('apphysics1-mcq-b4-sv-h-4.1-a-v3','4.1','dfdd2aad3af0965f6baadef9b9e4d059'),
('apphysics1-mcq-b4-h-4.1-b','4.1','6973e57a43493dddffff3c6c75eb1e26'),
('apphysics1-mcq-b4-sv-h-4.1-b-v1','4.1','8603c62742110f1b24db2c0850a28713'),
('apphysics1-mcq-b4-sv-h-4.1-b-v2','4.1','7438279770f0a17e163e3076c4e54b48'),
('apphysics1-mcq-b4-sv-h-4.1-b-v3','4.1','e54b891c13793b940f603be6afd8e915'),
('apphysics1-mcq-b4-h-4.2-a','4.2','821f2310ed87c44b7dcd7310134f8df2'),
('apphysics1-mcq-b4-sv-h-4.2-a-v1','4.2','b4037c7c4d90cde0eeaaa225abf4e9d7'),
('apphysics1-mcq-b4-sv-h-4.2-a-v2','4.2','22780dd907dc187e5b82107a95a53d04'),
('apphysics1-mcq-b4-sv-h-4.2-a-v3','4.2','c57ee688ba6109b48862bf4ddbdeee69'),
('apphysics1-mcq-b4-h-4.2-b','4.2','f23334909335df4b78462ccf8c158529'),
('apphysics1-mcq-b4-sv-h-4.2-b-v1','4.2','f69be8ddd245b6ea0917f613f451aa83'),
('apphysics1-mcq-b4-sv-h-4.2-b-v2','4.2','c60e292ed5c8ff7022349293bf7c223e'),
('apphysics1-mcq-b4-sv-h-4.2-b-v3','4.2','060f204411effb98f7146ad514205eb3'),
('apphysics1-mcq-b4-h-4.3-a','4.3','9d278678127b17bf369d54d92c138727'),
('apphysics1-mcq-b4-sv-h-4.3-a-v1','4.3','74d321f62bc4c7bbb1a0adcff044535a'),
('apphysics1-mcq-b4-sv-h-4.3-a-v2','4.3','55b9f0eda50b3f0d1e946e268689e03b'),
('apphysics1-mcq-b4-sv-h-4.3-a-v3','4.3','e3541910ff4ab0c643f66a963929b084'),
('apphysics1-mcq-b4-h-4.3-b','4.3','721552ab7b3611f6155b5e48656ce69e'),
('apphysics1-mcq-b4-sv-h-4.3-b-v1','4.3','2490f577ed6a55d881818d5619797bb6'),
('apphysics1-mcq-b4-sv-h-4.3-b-v2','4.3','cb4844e77a34cf11dc90527efc8a5671'),
('apphysics1-mcq-b4-sv-h-4.3-b-v3','4.3','4b6f44b16eebb95fdebaa43eab03a579'),
('apphysics1-mcq-b4-h-4.4-a','4.4','d4bd4da7e9f78022729c421d4f216364'),
('apphysics1-mcq-b4-sv-h-4.4-a-v1','4.4','5c7fc983d4c49a96c4ef239f17e232ca'),
('apphysics1-mcq-b4-sv-h-4.4-a-v2','4.4','a728011f4e3e6b64d9cd03664683d680'),
('apphysics1-mcq-b4-sv-h-4.4-a-v3','4.4','4fe4edfcf3510b899e78ed208bcb1823'),
('apphysics1-mcq-b4-h-4.4-b','4.4','df3371ac9614034f30b949f77daf0740'),
('apphysics1-mcq-b4-sv-h-4.4-b-v1','4.4','d586638b88305887c9df93042d96a25e'),
('apphysics1-mcq-b4-sv-h-4.4-b-v2','4.4','05cce68def6f4fed2d6d06f7ab39d8a4'),
('apphysics1-mcq-b4-sv-h-4.4-b-v3','4.4','47dc2f9ce260c57f7c46b3bbadb9f1d8');
create temporary table tgt on commit drop as
select l.*, ci.id item_id, civ.id version_id, gen_random_uuid() assignment_id, gen_random_uuid() label_id, gen_random_uuid() vd_id,
 '27111dec-ee07-48f1-86cf-1a5833dd2962'::uuid tsv, (case topic when '4.1' then array[4] when '4.2' then array[4] when '4.3' then array[4] when '4.4' then array[4] end)::int[] req, 4 pu
from lab l join app.content_items ci on ci.content_key=l.content_key and ci.exam_pack_version_id='29c719dc-701b-470f-9e49-fab981722d3f'
join app.content_item_versions civ on civ.content_item_id=ci.id and civ.version_num=1
where ci.status='draft' and civ.status='draft';
do $$ begin
 if (select count(*) from tgt)<>32 then raise exception 'expected 32 draft targets, got %', (select count(*) from tgt); end if;
 if exists (select 1 from tgt where split_part(topic,'.',1)::int<>pu) then raise exception 'topic/unit mismatch'; end if;
 if exists (select 1 from tgt t join app.content_item_cells c on c.content_item_version_id=t.version_id) or exists (select 1 from tgt t join app.content_taxonomy_labels l on l.content_item_id=t.item_id) then raise exception 'a target already has cells or labels'; end if;
 if (select count(*) from (select t.content_key from tgt t join app.content_item_versions civ on civ.id=t.version_id join app.mcq_choices c on c.content_item_version_id=civ.id group by t.content_key, civ.stem, t.exp_hash having md5(civ.stem||'|'||string_agg(c.choice_key||':'||c.choice_text||':'||c.is_correct::text||':'||c.rationale,'|' order by c.choice_key))=t.exp_hash) z)<>32 then raise exception 'loaded text does not match the build manifest'; end if;
 if exists (select 1 from tgt t where not exists (select 1 from app.content_item_cells c join app.content_items ci2 on ci2.id=c.content_item_id where ci2.exam_pack_version_id='29c719dc-701b-470f-9e49-fab981722d3f' and c.topic_code=t.topic and c.taxonomy_source_version=t.tsv and c.superseded_by is null)) then raise exception 'a topic code is not present in the AP Physics 1 taxonomy source version'; end if;
end $$;
insert into app.content_review_assignments (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, review_kind, status, assignment_purpose, created_by)
select assignment_id, version_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'tutor_question', 'mcq', 'pending', 'owner_remediation_approval', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
insert into app.content_review_decisions (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, tutor_score, difficulty_label, diagnostic_flag, concern_codes, note, tutor_decision, decision_payload, decision_hash, created_by)
select assignment_id, version_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'tutor_question', 1, null, false, array[]::text[],
 'AP Physics 1 Unit 3 harder seeds and variants (batch apphysics1_u4_2026_11_12): Product Owner review of owner-session-authored drafts, 2026-11-12. Arithmetic verified in Python; no model-checker pass, by Product Owner decision.',
 'approve',
 jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apphysics1_u4_2026_11_12_po_approval','qa_date','2026-11-12','content_key',content_key),
 md5(jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apphysics1_u4_2026_11_12_po_approval','qa_date','2026-11-12','content_key',content_key)::text),
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
 'apphysics1_u4_2026_11_12',
 jsonb_build_object('origin','owner_authored','units_source','AP Physics 1 Unit 4 (topics 4.x belong to unit 3; required_units set per topic from existing Unit 3 labels)','topic',topic,'report','scripts/content-seed/apchem-harder-seeds-u3-2026-11-12'),
 'apphysics1-u4-2026-11-12-labeling', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
insert into app.content_taxonomy_validation_decisions (validation_decision_id, content_taxonomy_label_id, decided_by, decision, decision_source, reviewed_primary_unit, reviewed_required_units, notes)
select vd_id, label_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'confirmed', 'chat_review', pu, req,
 'Product Owner chat instruction 2026-11-12 (AP Physics 1 harder seeds and variants). Topic assigned by the author from the question design (topic recorded on the cell); topic-only tagging, skill left null.' from tgt;
insert into app.content_item_cells (content_item_version_id, content_item_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id, validated_by, validated_at, validation_decision_id)
select version_id, item_id, tsv, topic, null, true, 'validated', 'apphysics1_u4_2026_11_12_topic',
 'apphysics1-u4-2026-11-12-labeling (topic set by the author from the question design)', null, now(), gen_random_uuid() from tgt;
update app.content_taxonomy_labels l set label_status='validated', validated_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, validated_at=now(), validation_decision_id=t.vd_id, validated_against_version_id=t.version_id, validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id) from tgt t where l.content_taxonomy_label_id=t.label_id;
update app.content_item_versions civ set status='published', published_at=coalesce(civ.published_at,now()), updated_at=now() from tgt where civ.id=tgt.version_id;
update app.content_items ci set status='published', updated_at=now() from tgt where ci.id=tgt.item_id;
do $$ declare n int; begin
  select count(*) into n from (select content_item_id from app.content_item_versions where status='published' group by 1 having count(*)>1) d; if n<>0 then raise exception 'duplicate published versions: %', n; end if;
  if (select count(*) from app.content_items ci join tgt on tgt.item_id=ci.id where ci.status='published')<>32 then raise exception 'publish count mismatch'; end if;
  select count(*) into n from app.content_taxonomy_labels l join tgt t on t.item_id=l.content_item_id where l.label_scope='serving' and l.superseded_by is null and l.label_status='validated' and l.validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id); if n<>32 then raise exception 'label post-check %', n; end if;
  select count(*) into n from app.content_item_cells where source='apphysics1_u4_2026_11_12_topic' and is_primary and superseded_by is null; if n<>32 then raise exception 'topic cell count %', n; end if;
end $$;
do $$ begin raise exception 'REHEARSAL OK (rolled back): published=%, validated_labels=%, topic_cells=%', (select count(*) from tgt), (select count(*) from app.content_taxonomy_labels where source='apphysics1_u4_2026_11_12' and label_status='validated'), (select count(*) from app.content_item_cells where source='apphysics1_u4_2026_11_12_topic'); end $$;
rollback;
