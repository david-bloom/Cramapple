begin;
select pg_advisory_xact_lock(hashtext('cramapple-apcalcbc-u5-t5-1-2026-11-12-publish-20261112'));
create temporary table lab (content_key text primary key, topic text, exp_hash text) on commit drop;
insert into lab values
('apcalcbc-mcq-b8-h-5.1-a','5.1','5945163ba9edb184082f6e66d422095c'),
('apcalcbc-mcq-b8-sv-h-5.1-a-v1','5.1','e93f3ced9fb62e282508c051e2170e0a'),
('apcalcbc-mcq-b8-sv-h-5.1-a-v2','5.1','a16fbf5b5f60da8f997003cce6008ad9'),
('apcalcbc-mcq-b8-sv-h-5.1-a-v3','5.1','1c1795c3b56ac2100bfab95330d76f8f'),
('apcalcbc-mcq-b8-h-5.1-b','5.1','c70bd42eb792f09cd61cae79167cd8d6'),
('apcalcbc-mcq-b8-sv-h-5.1-b-v1','5.1','80779042e430583e5fa13a5f2b0a7586'),
('apcalcbc-mcq-b8-sv-h-5.1-b-v2','5.1','de3eb21d6fe5676de206cae27483b482'),
('apcalcbc-mcq-b8-sv-h-5.1-b-v3','5.1','3f3579971936c72908473fd9dd39fd8f'),
('apcalcbc-mcq-b8-h-5.1-c','5.1','8ec5b06dcc52cfc24613d319bc5643d0'),
('apcalcbc-mcq-b8-sv-h-5.1-c-v1','5.1','ff5606d3f332f7c6082254e02e9698f4'),
('apcalcbc-mcq-b8-sv-h-5.1-c-v2','5.1','5ddc2b0b281d946bf5771cbe0b032cf6'),
('apcalcbc-mcq-b8-sv-h-5.1-c-v3','5.1','3b17a7e5f9d3401c7739323a48d9ba9a');
create temporary table tgt on commit drop as
select l.*, ci.id item_id, civ.id version_id, gen_random_uuid() assignment_id, gen_random_uuid() label_id, gen_random_uuid() vd_id,
 'ab088009-dc9a-4f93-8824-803e1913505b'::uuid tsv, (case topic when '5.1' then array[5] when '5.2' then array[5] when '5.3' then array[5] when '5.4' then array[5] when '5.5' then array[5] when '5.6' then array[5] when '5.7' then array[5] when '5.8' then array[5] when '5.9' then array[5] when '5.10' then array[5] when '5.11' then array[5] when '5.12' then array[5] end)::int[] req, 5 pu
from lab l join app.content_items ci on ci.content_key=l.content_key and ci.exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27'
join app.content_item_versions civ on civ.content_item_id=ci.id and civ.version_num=1
where ci.status='draft' and civ.status='draft';
do $$ begin
 if (select count(*) from tgt)<>12 then raise exception 'expected 12 draft targets, got %', (select count(*) from tgt); end if;
 if exists (select 1 from tgt where split_part(topic,'.',1)::int<>pu) then raise exception 'topic/unit mismatch'; end if;
 if exists (select 1 from tgt t join app.content_item_cells c on c.content_item_version_id=t.version_id) or exists (select 1 from tgt t join app.content_taxonomy_labels l on l.content_item_id=t.item_id) then raise exception 'a target already has cells or labels'; end if;
 if (select count(*) from (select t.content_key from tgt t join app.content_item_versions civ on civ.id=t.version_id join app.mcq_choices c on c.content_item_version_id=civ.id group by t.content_key, civ.stem, t.exp_hash having md5(civ.stem||'|'||string_agg(c.choice_key||':'||c.choice_text||':'||c.is_correct::text||':'||c.rationale,'|' order by c.choice_key))=t.exp_hash) z)<>12 then raise exception 'loaded text does not match the build manifest'; end if;
 if exists (select 1 from tgt t where not exists (select 1 from app.taxonomy_topics tt where tt.taxonomy_source_version=t.tsv and tt.topic_code=t.topic)) then raise exception 'a topic code is not present in the taxonomy source version'; end if;
end $$;
insert into app.content_review_assignments (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, review_kind, status, assignment_purpose, created_by)
select assignment_id, version_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'tutor_question', 'mcq', 'pending', 'owner_remediation_approval', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
insert into app.content_review_decisions (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, tutor_score, difficulty_label, diagnostic_flag, concern_codes, note, tutor_decision, decision_payload, decision_hash, created_by)
select assignment_id, version_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'tutor_question', 1, null, false, array[]::text[],
 'AP Calculus BC Unit 5 harder seeds and variants (batch apcalcbc_u5_t5_1_2026_11_12); owner-authorized production content release after the batch checks recorded in the status document. No subject-expert review is claimed.',
 'approve',
 jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apcalcbc_u5_t5_1_2026_11_12_po_approval','qa_date','2026-11-12','content_key',content_key),
 md5(jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apcalcbc_u5_t5_1_2026_11_12_po_approval','qa_date','2026-11-12','content_key',content_key)::text),
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
select label_id, item_id, 1, 'serving', req, 5, pu, array[]::text[], tsv, 'provisional', 'provisional_model',
 'apcalcbc_u5_t5_1_2026_11_12',
 jsonb_build_object('origin','owner_authored','units_source','AP Calculus BC Unit 5 (topics 5.x belong to unit 5; required_units set per topic from verified serving labels and taxonomy mapping)','topic',topic,'report','scripts/content-seed/apcalcbc-harder-seeds-u5-t5_1-2026-11-12'),
 'apcalcbc-u5-t5-1-2026-11-12-labeling', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
insert into app.content_taxonomy_validation_decisions (validation_decision_id, content_taxonomy_label_id, decided_by, decision, decision_source, reviewed_primary_unit, reviewed_required_units, notes)
select vd_id, label_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'confirmed', 'chat_review', pu, req,
 'Product Owner chat instruction 2026-11-12 (AP Calculus BC harder seeds and variants). Topic assigned by the author from the question design (topic recorded on the cell); topic-only tagging, skill left null.' from tgt;
insert into app.content_item_cells (content_item_version_id, content_item_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id, validated_by, validated_at, validation_decision_id)
select version_id, item_id, tsv, topic, null, true, 'validated', 'apcalcbc_u5_t5_1_2026_11_12_topic',
 'apcalcbc-u5-t5-1-2026-11-12-labeling (topic set by the author from the question design)', null, now(), gen_random_uuid() from tgt;
update app.content_taxonomy_labels l set label_status='validated', validated_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, validated_at=now(), validation_decision_id=t.vd_id, validated_against_version_id=t.version_id, validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id) from tgt t where l.content_taxonomy_label_id=t.label_id;
update app.content_item_versions civ set status='published', published_at=coalesce(civ.published_at,now()), updated_at=now() from tgt where civ.id=tgt.version_id;
update app.content_items ci set status='published', updated_at=now() from tgt where ci.id=tgt.item_id;
do $$ declare n int; begin
  select count(*) into n from (select content_item_id from app.content_item_versions where status='published' group by 1 having count(*)>1) d; if n<>0 then raise exception 'duplicate published versions: %', n; end if;
  if (select count(*) from app.content_items ci join tgt on tgt.item_id=ci.id where ci.status='published')<>12 then raise exception 'publish count mismatch'; end if;
  select count(*) into n from app.content_taxonomy_labels l join tgt t on t.item_id=l.content_item_id where l.label_scope='serving' and l.superseded_by is null and l.label_status='validated' and l.validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id); if n<>12 then raise exception 'label post-check %', n; end if;
  select count(*) into n from app.content_item_cells where source='apcalcbc_u5_t5_1_2026_11_12_topic' and is_primary and superseded_by is null; if n<>12 then raise exception 'topic cell count %', n; end if;
end $$;
do $$ begin raise exception 'REHEARSAL OK (rolled back): published=%, validated_labels=%, topic_cells=%', (select count(*) from tgt), (select count(*) from app.content_taxonomy_labels where source='apcalcbc_u5_t5_1_2026_11_12' and label_status='validated'), (select count(*) from app.content_item_cells where source='apcalcbc_u5_t5_1_2026_11_12_topic'); end $$;
rollback;
