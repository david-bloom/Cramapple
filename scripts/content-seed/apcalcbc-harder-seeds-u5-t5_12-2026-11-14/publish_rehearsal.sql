begin;
select pg_advisory_xact_lock(hashtext('cramapple-apcalcbc-u5-t5-12-2026-11-14-publish-20261114'));
create temporary table lab (content_key text primary key, topic text, exp_hash text) on commit drop;
insert into lab values
('apcalcbc-mcq-b19-h-5.12-a','5.12','dc11c6de3482514e9df8d97deff9c9c2'),
('apcalcbc-mcq-b19-sv-h-5.12-a-v1','5.12','7ce3b5e17c57d2547b8334ed4e59e612'),
('apcalcbc-mcq-b19-sv-h-5.12-a-v2','5.12','1af35d9b88924285c3a18bd9f595b083'),
('apcalcbc-mcq-b19-sv-h-5.12-a-v3','5.12','c8297efd1e9314b12b797ed0498da06d'),
('apcalcbc-mcq-b19-h-5.12-b','5.12','5f51e812644e98df9b3cb7dfbd7136c3'),
('apcalcbc-mcq-b19-sv-h-5.12-b-v1','5.12','025174d7e9998be173ec9defc0a93719'),
('apcalcbc-mcq-b19-sv-h-5.12-b-v2','5.12','fffb5f127a505a4c304cfa1a641a2ab9'),
('apcalcbc-mcq-b19-sv-h-5.12-b-v3','5.12','7f89ca68c8eeb633ae6e25d9751e09b4'),
('apcalcbc-mcq-b19-h-5.12-c','5.12','edc65b6bfbb510e1def413c9ae6bd2da'),
('apcalcbc-mcq-b19-sv-h-5.12-c-v1','5.12','888e1985b775d59ce976bf5fb41bbba8'),
('apcalcbc-mcq-b19-sv-h-5.12-c-v2','5.12','488db42fd52314ffb6ae8ec636f68a7e'),
('apcalcbc-mcq-b19-sv-h-5.12-c-v3','5.12','ffb499b9f04d1f8833532263c3305c22');
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
 'AP Calculus BC Unit 5 harder seeds and variants (batch apcalcbc_u5_t5_12_2026_11_14); owner-authorized production content release after the batch checks recorded in the status document. No subject-expert review is claimed.',
 'approve',
 jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apcalcbc_u5_t5_12_2026_11_14_po_approval','qa_date','2026-11-14','content_key',content_key),
 md5(jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apcalcbc_u5_t5_12_2026_11_14_po_approval','qa_date','2026-11-14','content_key',content_key)::text),
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
 'apcalcbc_u5_t5_12_2026_11_14',
 jsonb_build_object('origin','owner_authored','units_source','AP Calculus BC Unit 5 (topics 5.x belong to unit 5; required_units set per topic from verified serving labels and taxonomy mapping)','topic',topic,'report','scripts/content-seed/apcalcbc-harder-seeds-u5-t5_12-2026-11-14'),
 'apcalcbc-u5-t5-12-2026-11-14-labeling', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
insert into app.content_taxonomy_validation_decisions (validation_decision_id, content_taxonomy_label_id, decided_by, decision, decision_source, reviewed_primary_unit, reviewed_required_units, notes)
select vd_id, label_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'confirmed', 'chat_review', pu, req,
 'Product Owner chat instruction 2026-11-14 (AP Calculus BC harder seeds and variants). Topic assigned by the author from the question design (topic recorded on the cell); topic-only tagging, skill left null.' from tgt;
insert into app.content_item_cells (content_item_version_id, content_item_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id, validated_by, validated_at, validation_decision_id)
select version_id, item_id, tsv, topic, null, true, 'validated', 'apcalcbc_u5_t5_12_2026_11_14_topic',
 'apcalcbc-u5-t5-12-2026-11-14-labeling (topic set by the author from the question design)', null, now(), gen_random_uuid() from tgt;
update app.content_taxonomy_labels l set label_status='validated', validated_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, validated_at=now(), validation_decision_id=t.vd_id, validated_against_version_id=t.version_id, validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id) from tgt t where l.content_taxonomy_label_id=t.label_id;
update app.content_item_versions civ set status='published', published_at=coalesce(civ.published_at,now()), updated_at=now() from tgt where civ.id=tgt.version_id;
update app.content_items ci set status='published', updated_at=now() from tgt where ci.id=tgt.item_id;
do $$ declare n int; begin
  select count(*) into n from (select content_item_id from app.content_item_versions where status='published' group by 1 having count(*)>1) d; if n<>0 then raise exception 'duplicate published versions: %', n; end if;
  if (select count(*) from app.content_items ci join tgt on tgt.item_id=ci.id where ci.status='published')<>12 then raise exception 'publish count mismatch'; end if;
  select count(*) into n from app.content_taxonomy_labels l join tgt t on t.item_id=l.content_item_id where l.label_scope='serving' and l.superseded_by is null and l.label_status='validated' and l.validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id); if n<>12 then raise exception 'label post-check %', n; end if;
  select count(*) into n from app.content_item_cells where source='apcalcbc_u5_t5_12_2026_11_14_topic' and is_primary and superseded_by is null; if n<>12 then raise exception 'topic cell count %', n; end if;
end $$;
do $$ begin raise exception 'REHEARSAL OK (rolled back): published=%, validated_labels=%, topic_cells=%', (select count(*) from tgt), (select count(*) from app.content_taxonomy_labels where source='apcalcbc_u5_t5_12_2026_11_14' and label_status='validated'), (select count(*) from app.content_item_cells where source='apcalcbc_u5_t5_12_2026_11_14_topic'); end $$;
rollback;
