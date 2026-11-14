begin;
select pg_advisory_xact_lock(hashtext('cramapple-apcalcbc-u5-t5-7-2026-11-13-publish-20261113'));
create temporary table lab (content_key text primary key, topic text, exp_hash text) on commit drop;
insert into lab values
('apcalcbc-mcq-b14-h-5.7-a','5.7','652fcb5e771dc8676da09348eec9b507'),
('apcalcbc-mcq-b14-sv-h-5.7-a-v1','5.7','503f84b74a3d312cd207106cc639c7a4'),
('apcalcbc-mcq-b14-sv-h-5.7-a-v2','5.7','92bb77e593db5db9ac07ab1e29ed960f'),
('apcalcbc-mcq-b14-sv-h-5.7-a-v3','5.7','0dab376bb28f5e3a1333a5bc82d2d88e'),
('apcalcbc-mcq-b14-h-5.7-b','5.7','94d88524c0e887a59fa62a8ff174e2d1'),
('apcalcbc-mcq-b14-sv-h-5.7-b-v1','5.7','7bfeb424a464052377118b216170f423'),
('apcalcbc-mcq-b14-sv-h-5.7-b-v2','5.7','535a510e12c6102ae7cd3b3aa060ce79'),
('apcalcbc-mcq-b14-sv-h-5.7-b-v3','5.7','ff87ad6b07ea4d2e6e0eef7ee2d6d8db'),
('apcalcbc-mcq-b14-h-5.7-c','5.7','79f22d2bca6f8dcae3cad01d94123081'),
('apcalcbc-mcq-b14-sv-h-5.7-c-v1','5.7','18988bd7d006819a35eaa533ddca4e01'),
('apcalcbc-mcq-b14-sv-h-5.7-c-v2','5.7','f7d87b1f4dabc6fce0bc90b799dd8d50'),
('apcalcbc-mcq-b14-sv-h-5.7-c-v3','5.7','5230ca6a3d076d7b7ec06a3f1ca54cde');
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
 'AP Calculus BC Unit 5 harder seeds and variants (batch apcalcbc_u5_t5_7_2026_11_13); owner-authorized production content release after the batch checks recorded in the status document. No subject-expert review is claimed.',
 'approve',
 jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apcalcbc_u5_t5_7_2026_11_13_po_approval','qa_date','2026-11-13','content_key',content_key),
 md5(jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apcalcbc_u5_t5_7_2026_11_13_po_approval','qa_date','2026-11-13','content_key',content_key)::text),
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
 'apcalcbc_u5_t5_7_2026_11_13',
 jsonb_build_object('origin','owner_authored','units_source','AP Calculus BC Unit 5 (topics 5.x belong to unit 5; required_units set per topic from verified serving labels and taxonomy mapping)','topic',topic,'report','scripts/content-seed/apcalcbc-harder-seeds-u5-t5_7-2026-11-13'),
 'apcalcbc-u5-t5-7-2026-11-13-labeling', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
insert into app.content_taxonomy_validation_decisions (validation_decision_id, content_taxonomy_label_id, decided_by, decision, decision_source, reviewed_primary_unit, reviewed_required_units, notes)
select vd_id, label_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'confirmed', 'chat_review', pu, req,
 'Product Owner chat instruction 2026-11-13 (AP Calculus BC harder seeds and variants). Topic assigned by the author from the question design (topic recorded on the cell); topic-only tagging, skill left null.' from tgt;
insert into app.content_item_cells (content_item_version_id, content_item_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id, validated_by, validated_at, validation_decision_id)
select version_id, item_id, tsv, topic, null, true, 'validated', 'apcalcbc_u5_t5_7_2026_11_13_topic',
 'apcalcbc-u5-t5-7-2026-11-13-labeling (topic set by the author from the question design)', null, now(), gen_random_uuid() from tgt;
update app.content_taxonomy_labels l set label_status='validated', validated_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, validated_at=now(), validation_decision_id=t.vd_id, validated_against_version_id=t.version_id, validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id) from tgt t where l.content_taxonomy_label_id=t.label_id;
update app.content_item_versions civ set status='published', published_at=coalesce(civ.published_at,now()), updated_at=now() from tgt where civ.id=tgt.version_id;
update app.content_items ci set status='published', updated_at=now() from tgt where ci.id=tgt.item_id;
do $$ declare n int; begin
  select count(*) into n from (select content_item_id from app.content_item_versions where status='published' group by 1 having count(*)>1) d; if n<>0 then raise exception 'duplicate published versions: %', n; end if;
  if (select count(*) from app.content_items ci join tgt on tgt.item_id=ci.id where ci.status='published')<>12 then raise exception 'publish count mismatch'; end if;
  select count(*) into n from app.content_taxonomy_labels l join tgt t on t.item_id=l.content_item_id where l.label_scope='serving' and l.superseded_by is null and l.label_status='validated' and l.validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id); if n<>12 then raise exception 'label post-check %', n; end if;
  select count(*) into n from app.content_item_cells where source='apcalcbc_u5_t5_7_2026_11_13_topic' and is_primary and superseded_by is null; if n<>12 then raise exception 'topic cell count %', n; end if;
end $$;
do $$ begin raise exception 'REHEARSAL OK (rolled back): published=%, validated_labels=%, topic_cells=%', (select count(*) from tgt), (select count(*) from app.content_taxonomy_labels where source='apcalcbc_u5_t5_7_2026_11_13' and label_status='validated'), (select count(*) from app.content_item_cells where source='apcalcbc_u5_t5_7_2026_11_13_topic'); end $$;
rollback;
