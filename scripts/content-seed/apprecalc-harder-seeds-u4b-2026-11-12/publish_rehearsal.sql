begin;
select pg_advisory_xact_lock(hashtext('cramapple-apprecalc-u4b-2026-11-12-publish-20261112'));
create temporary table lab (content_key text primary key, topic text, exp_hash text) on commit drop;
insert into lab values
('apprecalc-mcq-b4b-h-4.8-a','4.8','27409fda06d9fdad62a848b01455f622'),
('apprecalc-mcq-b4b-sv-h-4.8-a-v1','4.8','ed91386e395f865ecb0b21d7b6dc824c'),
('apprecalc-mcq-b4b-sv-h-4.8-a-v2','4.8','7356d300d4079baa1cd4ff7b28775818'),
('apprecalc-mcq-b4b-sv-h-4.8-a-v3','4.8','7dd12dc742364fad4faeb8236283d918'),
('apprecalc-mcq-b4b-h-4.9-a','4.9','19698c8ee02e8991217651f1d99872cf'),
('apprecalc-mcq-b4b-sv-h-4.9-a-v1','4.9','d4c6050ea6cf6093195cdff88a5ab797'),
('apprecalc-mcq-b4b-sv-h-4.9-a-v2','4.9','37beee7439a3d0df2ade56c67ad83317'),
('apprecalc-mcq-b4b-sv-h-4.9-a-v3','4.9','05ef105bb2053bf0b4271ada98aa92b4'),
('apprecalc-mcq-b4b-h-4.10-a','4.10','71ccf92d68dd07c84082ec19da105702'),
('apprecalc-mcq-b4b-sv-h-4.10-a-v1','4.10','4dcd3bc6277687c0d54fdb4ce667187f'),
('apprecalc-mcq-b4b-sv-h-4.10-a-v2','4.10','b158b653584b748d35d5a33555a09851'),
('apprecalc-mcq-b4b-sv-h-4.10-a-v3','4.10','1f73ba9d1c7694180a7d01eb1917ea78'),
('apprecalc-mcq-b4b-h-4.11-a','4.11','94b5bb991ab0fb9eab042f70ccf4bfcf'),
('apprecalc-mcq-b4b-sv-h-4.11-a-v1','4.11','3d4a92e4395d758bf9f98eb008b40588'),
('apprecalc-mcq-b4b-sv-h-4.11-a-v2','4.11','bd718bf358b01d079845c00f64f1c8c0'),
('apprecalc-mcq-b4b-sv-h-4.11-a-v3','4.11','85ed26cc76d25e7929157444e007b549'),
('apprecalc-mcq-b4b-h-4.12-a','4.12','a45e33114b271734d371545c54a4ddaf'),
('apprecalc-mcq-b4b-sv-h-4.12-a-v1','4.12','7cc9cf2ac4c0e39179598383f778c35b'),
('apprecalc-mcq-b4b-sv-h-4.12-a-v2','4.12','3e5800c8aeb4956af27403a3ab122684'),
('apprecalc-mcq-b4b-sv-h-4.12-a-v3','4.12','1a32254534dbd6f893f3a0e8a2eebc3f'),
('apprecalc-mcq-b4b-h-4.13-a','4.13','686965ccfe0a6bd32aad07a3f1b14477'),
('apprecalc-mcq-b4b-sv-h-4.13-a-v1','4.13','b506ee55b134aaf9d4136115290f4f6f'),
('apprecalc-mcq-b4b-sv-h-4.13-a-v2','4.13','f36b316ddfa43309ae1127cab784162b'),
('apprecalc-mcq-b4b-sv-h-4.13-a-v3','4.13','6b97973a5f61a975fb26a54d5025ecb7'),
('apprecalc-mcq-b4b-h-4.14-a','4.14','4267f397b28112a0a90e08201e11302a'),
('apprecalc-mcq-b4b-sv-h-4.14-a-v1','4.14','dedcc0f688cdc810c946fc6ccd3d2a65'),
('apprecalc-mcq-b4b-sv-h-4.14-a-v2','4.14','bbaf0bdd5a9b4e359f961ee101341d4f'),
('apprecalc-mcq-b4b-sv-h-4.14-a-v3','4.14','1d18d13bef720332d28ea487f4694a5f');
create temporary table tgt on commit drop as
select l.*, ci.id item_id, civ.id version_id, gen_random_uuid() assignment_id, gen_random_uuid() label_id, gen_random_uuid() vd_id,
 '16383753-6775-430d-960a-544cd6ee0972'::uuid tsv, (case topic when '4.1' then array[4] when '4.2' then array[4] when '4.3' then array[4] when '4.4' then array[4] when '4.5' then array[4] when '4.6' then array[4] when '4.7' then array[4] when '4.8' then array[4] when '4.9' then array[4] when '4.10' then array[4] when '4.11' then array[4] when '4.12' then array[4] when '4.13' then array[4] when '4.14' then array[4] end)::int[] req, 4 pu
from lab l join app.content_items ci on ci.content_key=l.content_key and ci.exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db'
join app.content_item_versions civ on civ.content_item_id=ci.id and civ.version_num=1
where ci.status='draft' and civ.status='draft';
do $$ begin
 if (select count(*) from tgt)<>28 then raise exception 'expected 28 draft targets, got %', (select count(*) from tgt); end if;
 if exists (select 1 from tgt where split_part(topic,'.',1)::int<>pu) then raise exception 'topic/unit mismatch'; end if;
 if exists (select 1 from tgt t join app.content_item_cells c on c.content_item_version_id=t.version_id) or exists (select 1 from tgt t join app.content_taxonomy_labels l on l.content_item_id=t.item_id) then raise exception 'a target already has cells or labels'; end if;
 if (select count(*) from (select t.content_key from tgt t join app.content_item_versions civ on civ.id=t.version_id join app.mcq_choices c on c.content_item_version_id=civ.id group by t.content_key, civ.stem, t.exp_hash having md5(civ.stem||'|'||string_agg(c.choice_key||':'||c.choice_text||':'||c.is_correct::text||':'||c.rationale,'|' order by c.choice_key))=t.exp_hash) z)<>28 then raise exception 'loaded text does not match the build manifest'; end if;
 if exists (select 1 from tgt t where not exists (select 1 from app.taxonomy_topics tt where tt.taxonomy_source_version=t.tsv and tt.topic_code=t.topic)) then raise exception 'a topic code is not present in the taxonomy source version'; end if;
end $$;
insert into app.content_review_assignments (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, review_kind, status, assignment_purpose, created_by)
select assignment_id, version_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'tutor_question', 'mcq', 'pending', 'owner_remediation_approval', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
insert into app.content_review_decisions (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, tutor_score, difficulty_label, diagnostic_flag, concern_codes, note, tutor_decision, decision_payload, decision_hash, created_by)
select assignment_id, version_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'tutor_question', 1, null, false, array[]::text[],
 'AP Precalculus Unit 3 harder seeds and variants (batch apprecalc_u4b_2026_11_12): Product Owner review of owner-session-authored drafts, 2026-11-12. Arithmetic verified in Python; no model-checker pass, by Product Owner decision.',
 'approve',
 jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apprecalc_u4b_2026_11_12_po_approval','qa_date','2026-11-12','content_key',content_key),
 md5(jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apprecalc_u4b_2026_11_12_po_approval','qa_date','2026-11-12','content_key',content_key)::text),
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
 'apprecalc_u4b_2026_11_12',
 jsonb_build_object('origin','owner_authored','units_source','AP Precalculus Unit 4 (topics 4.x belong to unit 3; required_units set per topic from existing Unit 3 labels)','topic',topic,'report','scripts/content-seed/apchem-harder-seeds-u3-2026-11-12'),
 'apprecalc-u4b-2026-11-12-labeling', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
insert into app.content_taxonomy_validation_decisions (validation_decision_id, content_taxonomy_label_id, decided_by, decision, decision_source, reviewed_primary_unit, reviewed_required_units, notes)
select vd_id, label_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'confirmed', 'chat_review', pu, req,
 'Product Owner chat instruction 2026-11-12 (AP Precalculus harder seeds and variants). Topic assigned by the author from the question design (topic recorded on the cell); topic-only tagging, skill left null.' from tgt;
insert into app.content_item_cells (content_item_version_id, content_item_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id, validated_by, validated_at, validation_decision_id)
select version_id, item_id, tsv, topic, null, true, 'validated', 'apprecalc_u4b_2026_11_12_topic',
 'apprecalc-u4b-2026-11-12-labeling (topic set by the author from the question design)', null, now(), gen_random_uuid() from tgt;
update app.content_taxonomy_labels l set label_status='validated', validated_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, validated_at=now(), validation_decision_id=t.vd_id, validated_against_version_id=t.version_id, validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id) from tgt t where l.content_taxonomy_label_id=t.label_id;
update app.content_item_versions civ set status='published', published_at=coalesce(civ.published_at,now()), updated_at=now() from tgt where civ.id=tgt.version_id;
update app.content_items ci set status='published', updated_at=now() from tgt where ci.id=tgt.item_id;
do $$ declare n int; begin
  select count(*) into n from (select content_item_id from app.content_item_versions where status='published' group by 1 having count(*)>1) d; if n<>0 then raise exception 'duplicate published versions: %', n; end if;
  if (select count(*) from app.content_items ci join tgt on tgt.item_id=ci.id where ci.status='published')<>28 then raise exception 'publish count mismatch'; end if;
  select count(*) into n from app.content_taxonomy_labels l join tgt t on t.item_id=l.content_item_id where l.label_scope='serving' and l.superseded_by is null and l.label_status='validated' and l.validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id); if n<>28 then raise exception 'label post-check %', n; end if;
  select count(*) into n from app.content_item_cells where source='apprecalc_u4b_2026_11_12_topic' and is_primary and superseded_by is null; if n<>28 then raise exception 'topic cell count %', n; end if;
end $$;
do $$ begin raise exception 'REHEARSAL OK (rolled back): published=%, validated_labels=%, topic_cells=%', (select count(*) from tgt), (select count(*) from app.content_taxonomy_labels where source='apprecalc_u4b_2026_11_12' and label_status='validated'), (select count(*) from app.content_item_cells where source='apprecalc_u4b_2026_11_12_topic'); end $$;
rollback;
