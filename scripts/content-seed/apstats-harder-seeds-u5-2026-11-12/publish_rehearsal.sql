begin;
select pg_advisory_xact_lock(hashtext('cramapple-apstats-u5-2026-11-12-publish-20261112'));
create temporary table lab (content_key text primary key, topic text, exp_hash text) on commit drop;
insert into lab values
('apstats-mcq-b8-h-5.1-a','5.1','8b9356cb730dfd8bb3198915e3b016e0'),
('apstats-mcq-b8-sv-h-5.1-a-v1','5.1','d33ea17e28edc80e3d3236a62943ac7b'),
('apstats-mcq-b8-sv-h-5.1-a-v2','5.1','10af3918507f4631aef29a2b81174062'),
('apstats-mcq-b8-sv-h-5.1-a-v3','5.1','e892031bdd666d6323ea994d4da9e02b'),
('apstats-mcq-b8-h-5.1-b','5.1','bac7ee0cc56cf259228a8bb1e90dae81'),
('apstats-mcq-b8-sv-h-5.1-b-v1','5.1','e70c4b1d0678c8a8f450f6b5d5581ff9'),
('apstats-mcq-b8-sv-h-5.1-b-v2','5.1','d23e838ce49672030ab667679d4ce2b1'),
('apstats-mcq-b8-sv-h-5.1-b-v3','5.1','9e7b5c787964549166cb1cfe8d4be8a3'),
('apstats-mcq-b8-h-5.2-a','5.2','ea3f186316b8fc351e2c7c49666a07a9'),
('apstats-mcq-b8-sv-h-5.2-a-v1','5.2','408e75de71d59725e73fbb8012799c65'),
('apstats-mcq-b8-sv-h-5.2-a-v2','5.2','01057ed26c5cddebe74d630f365b24b8'),
('apstats-mcq-b8-sv-h-5.2-a-v3','5.2','eafcd314b38bcf5a7bffb56a982f3743'),
('apstats-mcq-b8-h-5.2-b','5.2','f0958e8416efff031665eb68e496cae5'),
('apstats-mcq-b8-sv-h-5.2-b-v1','5.2','91c2cf63add667ea4370cb0d870f6f5e'),
('apstats-mcq-b8-sv-h-5.2-b-v2','5.2','db1ef6ec1f9b42064059714743f987f5'),
('apstats-mcq-b8-sv-h-5.2-b-v3','5.2','76a2d3db259743d1ee403ff88fcd8695'),
('apstats-mcq-b8-h-5.3-a','5.3','aab5fc2c9956770543a2fda68db636d0'),
('apstats-mcq-b8-sv-h-5.3-a-v1','5.3','974b32c72f9c6074c2b204d9dddd60ed'),
('apstats-mcq-b8-sv-h-5.3-a-v2','5.3','8d214bad31fc1bb23cb8cfeb2bf3b376'),
('apstats-mcq-b8-sv-h-5.3-a-v3','5.3','b30123dc2729f971af9b5bbbd0d1789b'),
('apstats-mcq-b8-h-5.3-b','5.3','e739e86b48e96fe7b865af0503d7e147'),
('apstats-mcq-b8-sv-h-5.3-b-v1','5.3','617b340531a0cea70d450f54f9f4dc18'),
('apstats-mcq-b8-sv-h-5.3-b-v2','5.3','43e1a3d77f39242fb711c3446cab7c4c'),
('apstats-mcq-b8-sv-h-5.3-b-v3','5.3','8d51aff1a12b29d603d827249b203a01'),
('apstats-mcq-b8-h-5.4-a','5.4','0efafa65b8ab59f0eb3ce54e31d23223'),
('apstats-mcq-b8-sv-h-5.4-a-v1','5.4','deccd5d83682372f9757a26518daa426'),
('apstats-mcq-b8-sv-h-5.4-a-v2','5.4','1a25a7f535e2cc74fddf0299289f5642'),
('apstats-mcq-b8-sv-h-5.4-a-v3','5.4','bc07df39068cfeab6b2f2a42497fbe1c'),
('apstats-mcq-b8-h-5.4-b','5.4','2e40d55c4ad15aba647ff42719543ffa'),
('apstats-mcq-b8-sv-h-5.4-b-v1','5.4','41332b014b5be56571207d557058fc9f'),
('apstats-mcq-b8-sv-h-5.4-b-v2','5.4','653bbb627c381f27239eac5a086edcd2'),
('apstats-mcq-b8-sv-h-5.4-b-v3','5.4','98cf97d96c0accd8bbe917c15902a2f2'),
('apstats-mcq-b8-h-5.5-a','5.5','5d737da09599acf367afcf128467b038'),
('apstats-mcq-b8-sv-h-5.5-a-v1','5.5','ea0b6341790b6c735d61cd8757c482cd'),
('apstats-mcq-b8-sv-h-5.5-a-v2','5.5','d5503fbfa25c8ff5f944fac0b1c72cdf'),
('apstats-mcq-b8-sv-h-5.5-a-v3','5.5','b6c007e4bc8f1d35521f5e968c4d804c'),
('apstats-mcq-b8-h-5.5-b','5.5','0aca2638e9473945a8d0ceec178b5ab8'),
('apstats-mcq-b8-sv-h-5.5-b-v1','5.5','ca3e09b87e8054abface9dcc0f2be3e6'),
('apstats-mcq-b8-sv-h-5.5-b-v2','5.5','a2f7a3b7c7634dec3decc95f324f57a5'),
('apstats-mcq-b8-sv-h-5.5-b-v3','5.5','f4554e11fb4215495c4dbe15960ba004'),
('apstats-mcq-b8-h-5.1-c','5.1','5e962127edb040a669a129e205bd31fd'),
('apstats-mcq-b8-sv-h-5.1-c-v1','5.1','9a345b1311093fa99d7f290956ab4824'),
('apstats-mcq-b8-sv-h-5.1-c-v2','5.1','0f516c72db8b6b26ce48106881d37026'),
('apstats-mcq-b8-sv-h-5.1-c-v3','5.1','1e662a353a0f7d014549401eb9f41af0'),
('apstats-mcq-b8-h-5.2-c','5.2','013c1d10eaf207d8685896ddaf6c44f0'),
('apstats-mcq-b8-sv-h-5.2-c-v1','5.2','1c0257a8900a4bee8507dc42ba819c44'),
('apstats-mcq-b8-sv-h-5.2-c-v2','5.2','5ae59573536411d66bc73f2ee3d1e537'),
('apstats-mcq-b8-sv-h-5.2-c-v3','5.2','3f4792b9fc904ea5c95814325c4341f2'),
('apstats-mcq-b8-h-5.3-c','5.3','7d2721eced8be23e2afe413a8ac127c3'),
('apstats-mcq-b8-sv-h-5.3-c-v1','5.3','8e6f2bbb540c28222963f1adbeaca897'),
('apstats-mcq-b8-sv-h-5.3-c-v2','5.3','619e0d1166f91e4a342ec135b30fb00c'),
('apstats-mcq-b8-sv-h-5.3-c-v3','5.3','845686fb6d583f8f60c6725243cf3670'),
('apstats-mcq-b8-h-5.4-c','5.4','9eef14703a9a7d3428dd4423709a576e'),
('apstats-mcq-b8-sv-h-5.4-c-v1','5.4','620aaf801a135abfe58ef66d35b5afe2'),
('apstats-mcq-b8-sv-h-5.4-c-v2','5.4','4533b2d51bb7b29ac291b3baf8fd20c1'),
('apstats-mcq-b8-sv-h-5.4-c-v3','5.4','fbf5f7a030b6a4ba3bfe1b3b9d50c0d6'),
('apstats-mcq-b8-h-5.5-c','5.5','3385b9872b0d405d1faf776b50b8b538'),
('apstats-mcq-b8-sv-h-5.5-c-v1','5.5','634dfa75c958489710eea44843f6a111'),
('apstats-mcq-b8-sv-h-5.5-c-v2','5.5','5e67d28aced09acc35f7113f71605c47'),
('apstats-mcq-b8-sv-h-5.5-c-v3','5.5','311a8ce164cc3c444dd1a8573c9d7ac9');
create temporary table tgt on commit drop as
select l.*, ci.id item_id, civ.id version_id, gen_random_uuid() assignment_id, gen_random_uuid() label_id, gen_random_uuid() vd_id,
 'dae3c72e-82ca-4960-9552-1b034bd347e5'::uuid tsv, (case topic when '5.1' then array[5] when '5.2' then array[5] when '5.3' then array[5] when '5.4' then array[5] when '5.5' then array[5] end)::int[] req, 5 pu
from lab l join app.content_items ci on ci.content_key=l.content_key and ci.exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438'
join app.content_item_versions civ on civ.content_item_id=ci.id and civ.version_num=1
where ci.status='draft' and civ.status='draft';
do $$ begin
 if (select count(*) from tgt)<>60 then raise exception 'expected 60 draft targets, got %', (select count(*) from tgt); end if;
 if exists (select 1 from tgt where split_part(topic,'.',1)::int<>pu) then raise exception 'topic/unit mismatch'; end if;
 if exists (select 1 from tgt t join app.content_item_cells c on c.content_item_version_id=t.version_id) or exists (select 1 from tgt t join app.content_taxonomy_labels l on l.content_item_id=t.item_id) then raise exception 'a target already has cells or labels'; end if;
 if (select count(*) from (select t.content_key from tgt t join app.content_item_versions civ on civ.id=t.version_id join app.mcq_choices c on c.content_item_version_id=civ.id group by t.content_key, civ.stem, t.exp_hash having md5(civ.stem||'|'||string_agg(c.choice_key||':'||c.choice_text||':'||c.is_correct::text||':'||c.rationale,'|' order by c.choice_key))=t.exp_hash) z)<>60 then raise exception 'loaded text does not match the build manifest'; end if;
 if exists (select 1 from tgt t where not exists (select 1 from app.taxonomy_topics tt where tt.taxonomy_source_version=t.tsv and tt.topic_code=t.topic)) then raise exception 'a topic code is not present in the taxonomy source version'; end if;
end $$;
insert into app.content_review_assignments (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, review_kind, status, assignment_purpose, created_by)
select assignment_id, version_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'tutor_question', 'mcq', 'pending', 'owner_remediation_approval', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
insert into app.content_review_decisions (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, tutor_score, difficulty_label, diagnostic_flag, concern_codes, note, tutor_decision, decision_payload, decision_hash, created_by)
select assignment_id, version_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'tutor_question', 1, null, false, array[]::text[],
 'AP Statistics Unit 5 harder seeds and variants (batch apstats_u5_2026_11_12); owner-authorized production content release after the batch checks recorded in the status document. No subject-expert review is claimed.',
 'approve',
 jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apstats_u5_2026_11_12_po_approval','qa_date','2026-11-12','content_key',content_key),
 md5(jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apstats_u5_2026_11_12_po_approval','qa_date','2026-11-12','content_key',content_key)::text),
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
 'apstats_u5_2026_11_12',
 jsonb_build_object('origin','owner_authored','units_source','AP Statistics Unit 5 (topics 5.x belong to unit 5; required_units set per topic from verified serving labels and taxonomy mapping)','topic',topic,'report','scripts/content-seed/apstats-harder-seeds-u5-2026-11-12'),
 'apstats-u5-2026-11-12-labeling', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
insert into app.content_taxonomy_validation_decisions (validation_decision_id, content_taxonomy_label_id, decided_by, decision, decision_source, reviewed_primary_unit, reviewed_required_units, notes)
select vd_id, label_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'confirmed', 'chat_review', pu, req,
 'Product Owner chat instruction 2026-11-12 (AP Statistics harder seeds and variants). Topic assigned by the author from the question design (topic recorded on the cell); topic-only tagging, skill left null.' from tgt;
insert into app.content_item_cells (content_item_version_id, content_item_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id, validated_by, validated_at, validation_decision_id)
select version_id, item_id, tsv, topic, null, true, 'validated', 'apstats_u5_2026_11_12_topic',
 'apstats-u5-2026-11-12-labeling (topic set by the author from the question design)', null, now(), gen_random_uuid() from tgt;
update app.content_taxonomy_labels l set label_status='validated', validated_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, validated_at=now(), validation_decision_id=t.vd_id, validated_against_version_id=t.version_id, validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id) from tgt t where l.content_taxonomy_label_id=t.label_id;
update app.content_item_versions civ set status='published', published_at=coalesce(civ.published_at,now()), updated_at=now() from tgt where civ.id=tgt.version_id;
update app.content_items ci set status='published', updated_at=now() from tgt where ci.id=tgt.item_id;
do $$ declare n int; begin
  select count(*) into n from (select content_item_id from app.content_item_versions where status='published' group by 1 having count(*)>1) d; if n<>0 then raise exception 'duplicate published versions: %', n; end if;
  if (select count(*) from app.content_items ci join tgt on tgt.item_id=ci.id where ci.status='published')<>60 then raise exception 'publish count mismatch'; end if;
  select count(*) into n from app.content_taxonomy_labels l join tgt t on t.item_id=l.content_item_id where l.label_scope='serving' and l.superseded_by is null and l.label_status='validated' and l.validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id); if n<>60 then raise exception 'label post-check %', n; end if;
  select count(*) into n from app.content_item_cells where source='apstats_u5_2026_11_12_topic' and is_primary and superseded_by is null; if n<>60 then raise exception 'topic cell count %', n; end if;
end $$;
do $$ begin raise exception 'REHEARSAL OK (rolled back): published=%, validated_labels=%, topic_cells=%', (select count(*) from tgt), (select count(*) from app.content_taxonomy_labels where source='apstats_u5_2026_11_12' and label_status='validated'), (select count(*) from app.content_item_cells where source='apstats_u5_2026_11_12_topic'); end $$;
rollback;
