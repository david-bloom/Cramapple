begin;
select pg_advisory_xact_lock(hashtext('cramapple-apcalcbc-u3-2026-11-12-publish-20261112'));
create temporary table lab (content_key text primary key, topic text, exp_hash text) on commit drop;
insert into lab values
('apcalcbc-mcq-b2-h-3.1-a','3.1','cd0dd631cc9fc179de7a39fd4aefb5a7'),
('apcalcbc-mcq-b2-sv-h-3.1-a-v1','3.1','663a9b30c7503a3096d6300f7dd3d368'),
('apcalcbc-mcq-b2-sv-h-3.1-a-v2','3.1','ff5ee0ec15cebdcf912f2381641de78b'),
('apcalcbc-mcq-b2-sv-h-3.1-a-v3','3.1','3a0b8211ba4b5b6fae1231eb6b553853'),
('apcalcbc-mcq-b2-h-3.1-b','3.1','bbcb6c437e9a44a9732e4432ab67997b'),
('apcalcbc-mcq-b2-sv-h-3.1-b-v1','3.1','95f6659e68b9a9ed97406ed7f032a88e'),
('apcalcbc-mcq-b2-sv-h-3.1-b-v2','3.1','016ccce53d92abe44ef33ffc6a52b463'),
('apcalcbc-mcq-b2-sv-h-3.1-b-v3','3.1','389be224efd5cec4b91e7e5ac10f8986'),
('apcalcbc-mcq-b2-h-3.2-a','3.2','700327dd322dbb544f174d25a948337c'),
('apcalcbc-mcq-b2-sv-h-3.2-a-v1','3.2','9f212d4b68bdeefe29dd4ae200e77971'),
('apcalcbc-mcq-b2-sv-h-3.2-a-v2','3.2','65af95df1a2d6f5841d05f3cd5035f80'),
('apcalcbc-mcq-b2-sv-h-3.2-a-v3','3.2','c81edd8a5f4d8b32a29d7208ff43bd1b'),
('apcalcbc-mcq-b2-h-3.2-b','3.2','eea5e01d49a2f6e57adbf99633d90651'),
('apcalcbc-mcq-b2-sv-h-3.2-b-v1','3.2','bec42c01bb3ee975b6bd4d238a63c8c2'),
('apcalcbc-mcq-b2-sv-h-3.2-b-v2','3.2','c7c7e9b5446decd37a3750d83de86a7e'),
('apcalcbc-mcq-b2-sv-h-3.2-b-v3','3.2','9d9567654d7ed3a4fd148041fedcfd82'),
('apcalcbc-mcq-b2-h-3.3-a','3.3','81ee06f27de3e92b4bf37cebf8c0dd9c'),
('apcalcbc-mcq-b2-sv-h-3.3-a-v1','3.3','398cca93235b225f7b309e7f9369a694'),
('apcalcbc-mcq-b2-sv-h-3.3-a-v2','3.3','4ab4569c8cb42ba6e0390e824a1f7e83'),
('apcalcbc-mcq-b2-sv-h-3.3-a-v3','3.3','b8b273b79d5fdc7fef156c4b658b923f'),
('apcalcbc-mcq-b2-h-3.3-b','3.3','d5acfd58e58b740c00f12ba590bdb4e9'),
('apcalcbc-mcq-b2-sv-h-3.3-b-v1','3.3','f2a3d9851b6c3f2faa1ad04e0428009e'),
('apcalcbc-mcq-b2-sv-h-3.3-b-v2','3.3','fb828d217f3a14a081c986f2c9d453f1'),
('apcalcbc-mcq-b2-sv-h-3.3-b-v3','3.3','fe284f71a22f6ec7ce7bc5960f67c2c3'),
('apcalcbc-mcq-b2-h-3.4-a','3.4','2cc5973532b0ac26111520d44b29f449'),
('apcalcbc-mcq-b2-sv-h-3.4-a-v1','3.4','810e7a89056ddc0846425db4112916e4'),
('apcalcbc-mcq-b2-sv-h-3.4-a-v2','3.4','cdcd8b04c50109afc411d6a8cdda5cca'),
('apcalcbc-mcq-b2-sv-h-3.4-a-v3','3.4','eab0fef9a2d60485e5bd7570caa56e4f'),
('apcalcbc-mcq-b2-h-3.4-b','3.4','b0e397b8a48b546a463b500393c1f973'),
('apcalcbc-mcq-b2-sv-h-3.4-b-v1','3.4','fd4a1a4954c6d5704d102e60d7b5da62'),
('apcalcbc-mcq-b2-sv-h-3.4-b-v2','3.4','e83d6e4c7c79a4214bfaa17a9929fbc0'),
('apcalcbc-mcq-b2-sv-h-3.4-b-v3','3.4','fbf16dca27f83fe469395f381822afc7'),
('apcalcbc-mcq-b2-h-3.5-a','3.5','373e5c83db52a1a9e066a83ebe38cc28'),
('apcalcbc-mcq-b2-sv-h-3.5-a-v1','3.5','88200332fce22904f7aad1d4c8dd2437'),
('apcalcbc-mcq-b2-sv-h-3.5-a-v2','3.5','5930f34e178fc694c7768e3dac5aaa2b'),
('apcalcbc-mcq-b2-sv-h-3.5-a-v3','3.5','25bef5b41236425408a95baddaccaeea'),
('apcalcbc-mcq-b2-h-3.5-b','3.5','02d9b9243dd91d40ad59799890faa2dd'),
('apcalcbc-mcq-b2-sv-h-3.5-b-v1','3.5','f41e8b95c0e6bd48fa19f00f10d849b4'),
('apcalcbc-mcq-b2-sv-h-3.5-b-v2','3.5','fef72239f7bd280329b0ed4195a81654'),
('apcalcbc-mcq-b2-sv-h-3.5-b-v3','3.5','d331447857db65abcd6c98be3acba89e'),
('apcalcbc-mcq-b2-h-3.6-a','3.6','3e78619735a362654d7e5200a4f1a3b4'),
('apcalcbc-mcq-b2-sv-h-3.6-a-v1','3.6','baa62388e951704e9d11cec2c25dfde4'),
('apcalcbc-mcq-b2-sv-h-3.6-a-v2','3.6','237cd52cb612e401f96695414640e968'),
('apcalcbc-mcq-b2-sv-h-3.6-a-v3','3.6','974270a27a969b2a3ea7f543b8c0b1be'),
('apcalcbc-mcq-b2-h-3.6-b','3.6','641db049b6c8016a074c6e2aebfa4a98'),
('apcalcbc-mcq-b2-sv-h-3.6-b-v1','3.6','2236a112ad919ed01fb88746500ef925'),
('apcalcbc-mcq-b2-sv-h-3.6-b-v2','3.6','522cc6af58e56c7fdff96c540b120ca5'),
('apcalcbc-mcq-b2-sv-h-3.6-b-v3','3.6','7cca1259854eeaa29bcb2dda52e37a3a');
create temporary table tgt on commit drop as
select l.*, ci.id item_id, civ.id version_id, gen_random_uuid() assignment_id, gen_random_uuid() label_id, gen_random_uuid() vd_id,
 'ab088009-dc9a-4f93-8824-803e1913505b'::uuid tsv, (case topic when '3.1' then array[2, 3] when '3.2' then array[2, 3] when '3.3' then array[3] when '3.4' then array[3] when '3.5' then array[2, 3] when '3.6' then array[2, 3] when '3.8' then array[3] when '3.11' then array[3] end)::int[] req, 3 pu
from lab l join app.content_items ci on ci.content_key=l.content_key and ci.exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27'
join app.content_item_versions civ on civ.content_item_id=ci.id and civ.version_num=1
where ci.status='draft' and civ.status='draft';
do $$ begin
 if (select count(*) from tgt)<>48 then raise exception 'expected 48 draft targets, got %', (select count(*) from tgt); end if;
 if exists (select 1 from tgt where split_part(topic,'.',1)::int<>pu) then raise exception 'topic/unit mismatch'; end if;
 if exists (select 1 from tgt t join app.content_item_cells c on c.content_item_version_id=t.version_id) or exists (select 1 from tgt t join app.content_taxonomy_labels l on l.content_item_id=t.item_id) then raise exception 'a target already has cells or labels'; end if;
 if (select count(*) from (select t.content_key from tgt t join app.content_item_versions civ on civ.id=t.version_id join app.mcq_choices c on c.content_item_version_id=civ.id group by t.content_key, civ.stem, t.exp_hash having md5(civ.stem||'|'||string_agg(c.choice_key||':'||c.choice_text||':'||c.is_correct::text||':'||c.rationale,'|' order by c.choice_key))=t.exp_hash) z)<>48 then raise exception 'loaded text does not match the build manifest'; end if;
 if exists (select 1 from tgt t where not exists (select 1 from app.content_item_cells c join app.content_items ci2 on ci2.id=c.content_item_id where ci2.exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27' and c.topic_code=t.topic and c.taxonomy_source_version=t.tsv and c.superseded_by is null)) then raise exception 'a topic code is not present in the AP Calculus BC taxonomy source version'; end if;
end $$;
insert into app.content_review_assignments (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, review_kind, status, assignment_purpose, created_by)
select assignment_id, version_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'tutor_question', 'mcq', 'pending', 'owner_remediation_approval', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
insert into app.content_review_decisions (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, tutor_score, difficulty_label, diagnostic_flag, concern_codes, note, tutor_decision, decision_payload, decision_hash, created_by)
select assignment_id, version_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'tutor_question', 1, null, false, array[]::text[],
 'AP Calculus BC Unit 3 harder seeds and variants (batch apcalcbc_u3_2026_11_12): Product Owner review of owner-session-authored drafts, 2026-11-12. Arithmetic verified in Python; no model-checker pass, by Product Owner decision.',
 'approve',
 jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apcalcbc_u3_2026_11_12_po_approval','qa_date','2026-11-12','content_key',content_key),
 md5(jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apcalcbc_u3_2026_11_12_po_approval','qa_date','2026-11-12','content_key',content_key)::text),
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
select label_id, item_id, 1, 'serving', req, 3, pu, array[]::text[], tsv, 'provisional', 'provisional_model',
 'apcalcbc_u3_2026_11_12',
 jsonb_build_object('origin','owner_authored','units_source','AP Calculus BC Unit 3 (topics 3.x belong to unit 3; required_units set per topic from existing Unit 3 labels)','topic',topic,'report','scripts/content-seed/apchem-harder-seeds-u3-2026-11-12'),
 'apcalcbc-u3-2026-11-12-labeling', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
insert into app.content_taxonomy_validation_decisions (validation_decision_id, content_taxonomy_label_id, decided_by, decision, decision_source, reviewed_primary_unit, reviewed_required_units, notes)
select vd_id, label_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'confirmed', 'chat_review', pu, req,
 'Product Owner chat instruction 2026-11-12 (AP Calculus BC harder seeds and variants). Topic assigned by the author from the question design (topic recorded on the cell); topic-only tagging, skill left null.' from tgt;
insert into app.content_item_cells (content_item_version_id, content_item_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id, validated_by, validated_at, validation_decision_id)
select version_id, item_id, tsv, topic, null, true, 'validated', 'apcalcbc_u3_2026_11_12_topic',
 'apcalcbc-u3-2026-11-12-labeling (topic set by the author from the question design)', null, now(), gen_random_uuid() from tgt;
update app.content_taxonomy_labels l set label_status='validated', validated_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, validated_at=now(), validation_decision_id=t.vd_id, validated_against_version_id=t.version_id, validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id) from tgt t where l.content_taxonomy_label_id=t.label_id;
update app.content_item_versions civ set status='published', published_at=coalesce(civ.published_at,now()), updated_at=now() from tgt where civ.id=tgt.version_id;
update app.content_items ci set status='published', updated_at=now() from tgt where ci.id=tgt.item_id;
do $$ declare n int; begin
  select count(*) into n from (select content_item_id from app.content_item_versions where status='published' group by 1 having count(*)>1) d; if n<>0 then raise exception 'duplicate published versions: %', n; end if;
  if (select count(*) from app.content_items ci join tgt on tgt.item_id=ci.id where ci.status='published')<>48 then raise exception 'publish count mismatch'; end if;
  select count(*) into n from app.content_taxonomy_labels l join tgt t on t.item_id=l.content_item_id where l.label_scope='serving' and l.superseded_by is null and l.label_status='validated' and l.validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id); if n<>48 then raise exception 'label post-check %', n; end if;
  select count(*) into n from app.content_item_cells where source='apcalcbc_u3_2026_11_12_topic' and is_primary and superseded_by is null; if n<>48 then raise exception 'topic cell count %', n; end if;
end $$;
select (select count(*) from tgt) published, (select count(*) from app.content_taxonomy_labels where source='apcalcbc_u3_2026_11_12' and label_status='validated') validated_labels, (select count(*) from app.content_item_cells where source='apcalcbc_u3_2026_11_12_topic') topic_cells;
commit;
