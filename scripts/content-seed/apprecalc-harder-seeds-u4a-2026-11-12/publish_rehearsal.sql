begin;
select pg_advisory_xact_lock(hashtext('cramapple-apprecalc-u4a-2026-11-12-publish-20261112'));
create temporary table lab (content_key text primary key, topic text, exp_hash text) on commit drop;
insert into lab values
('apprecalc-mcq-b4a-h-4.1-a','4.1','8d861799bdbc4d1adddbd092ff2bf4bc'),
('apprecalc-mcq-b4a-sv-h-4.1-a-v1','4.1','2bb17d8967373eed98f3b78eca3efbd7'),
('apprecalc-mcq-b4a-sv-h-4.1-a-v2','4.1','a7816fd1e73c23039b5b629aebb58b80'),
('apprecalc-mcq-b4a-sv-h-4.1-a-v3','4.1','d17890d1cb2c575918a9b2da05a44c2d'),
('apprecalc-mcq-b4a-h-4.2-a','4.2','e9c8944f6013172aa88a14452e4002a3'),
('apprecalc-mcq-b4a-sv-h-4.2-a-v1','4.2','62f73ff65ac85b0bb177321b258f43e7'),
('apprecalc-mcq-b4a-sv-h-4.2-a-v2','4.2','8fb40607600613c8c499cb0edc0dfadb'),
('apprecalc-mcq-b4a-sv-h-4.2-a-v3','4.2','7b199bb028bdc536159cc9974074c156'),
('apprecalc-mcq-b4a-h-4.3-a','4.3','bf40ccddb43b54ac2160fef31e95b574'),
('apprecalc-mcq-b4a-sv-h-4.3-a-v1','4.3','752672ffd08df4a73115b099352e9c62'),
('apprecalc-mcq-b4a-sv-h-4.3-a-v2','4.3','283367d2c40bfe877da6aaa2cfe004ce'),
('apprecalc-mcq-b4a-sv-h-4.3-a-v3','4.3','ee1e92e196e5def7a325869afdfdbed5'),
('apprecalc-mcq-b4a-h-4.4-a','4.4','5a434426f5ac291b50bbb4f1962efef8'),
('apprecalc-mcq-b4a-sv-h-4.4-a-v1','4.4','ababa3053a2fff824d68b0a84e66e3db'),
('apprecalc-mcq-b4a-sv-h-4.4-a-v2','4.4','81edbec28ff6e8ea91d043051e4458b4'),
('apprecalc-mcq-b4a-sv-h-4.4-a-v3','4.4','8cb0347d877bd96339a1ce1e5a62b1d8'),
('apprecalc-mcq-b4a-h-4.5-a','4.5','22a05fbcd17b2b651a1d81cc68bdef31'),
('apprecalc-mcq-b4a-sv-h-4.5-a-v1','4.5','9eeca0b8d089ce9874e361d1379de5a3'),
('apprecalc-mcq-b4a-sv-h-4.5-a-v2','4.5','3d47dea29adc695fa412e2094e62a397'),
('apprecalc-mcq-b4a-sv-h-4.5-a-v3','4.5','5dbecd66dc07e5e882318861cadbff5b'),
('apprecalc-mcq-b4a-h-4.6-a','4.6','12b02cb2439c4e8229ed12aa268227bc'),
('apprecalc-mcq-b4a-sv-h-4.6-a-v1','4.6','2b6fdabacf5c9443efc85946d40b8aa5'),
('apprecalc-mcq-b4a-sv-h-4.6-a-v2','4.6','42b3c786b79650f0c253a3dd0895c57a'),
('apprecalc-mcq-b4a-sv-h-4.6-a-v3','4.6','e4c75e45e67a0ffa94fafe069c06d810'),
('apprecalc-mcq-b4a-h-4.7-a','4.7','3fbb6db1860cdad8310967b6709dfabb'),
('apprecalc-mcq-b4a-sv-h-4.7-a-v1','4.7','553cf48b68c4f21f62a4e456bf12e863'),
('apprecalc-mcq-b4a-sv-h-4.7-a-v2','4.7','226238932b5d7565b872c4749f4204cb'),
('apprecalc-mcq-b4a-sv-h-4.7-a-v3','4.7','4b552457d0e271714986601a22fcf3d2');
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
 'AP Precalculus Unit 3 harder seeds and variants (batch apprecalc_u4a_2026_11_12): Product Owner review of owner-session-authored drafts, 2026-11-12. Arithmetic verified in Python; no model-checker pass, by Product Owner decision.',
 'approve',
 jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apprecalc_u4a_2026_11_12_po_approval','qa_date','2026-11-12','content_key',content_key),
 md5(jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apprecalc_u4a_2026_11_12_po_approval','qa_date','2026-11-12','content_key',content_key)::text),
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
 'apprecalc_u4a_2026_11_12',
 jsonb_build_object('origin','owner_authored','units_source','AP Precalculus Unit 4 (topics 4.x belong to unit 3; required_units set per topic from existing Unit 3 labels)','topic',topic,'report','scripts/content-seed/apchem-harder-seeds-u3-2026-11-12'),
 'apprecalc-u4a-2026-11-12-labeling', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
insert into app.content_taxonomy_validation_decisions (validation_decision_id, content_taxonomy_label_id, decided_by, decision, decision_source, reviewed_primary_unit, reviewed_required_units, notes)
select vd_id, label_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'confirmed', 'chat_review', pu, req,
 'Product Owner chat instruction 2026-11-12 (AP Precalculus harder seeds and variants). Topic assigned by the author from the question design (topic recorded on the cell); topic-only tagging, skill left null.' from tgt;
insert into app.content_item_cells (content_item_version_id, content_item_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id, validated_by, validated_at, validation_decision_id)
select version_id, item_id, tsv, topic, null, true, 'validated', 'apprecalc_u4a_2026_11_12_topic',
 'apprecalc-u4a-2026-11-12-labeling (topic set by the author from the question design)', null, now(), gen_random_uuid() from tgt;
update app.content_taxonomy_labels l set label_status='validated', validated_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, validated_at=now(), validation_decision_id=t.vd_id, validated_against_version_id=t.version_id, validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id) from tgt t where l.content_taxonomy_label_id=t.label_id;
update app.content_item_versions civ set status='published', published_at=coalesce(civ.published_at,now()), updated_at=now() from tgt where civ.id=tgt.version_id;
update app.content_items ci set status='published', updated_at=now() from tgt where ci.id=tgt.item_id;
do $$ declare n int; begin
  select count(*) into n from (select content_item_id from app.content_item_versions where status='published' group by 1 having count(*)>1) d; if n<>0 then raise exception 'duplicate published versions: %', n; end if;
  if (select count(*) from app.content_items ci join tgt on tgt.item_id=ci.id where ci.status='published')<>28 then raise exception 'publish count mismatch'; end if;
  select count(*) into n from app.content_taxonomy_labels l join tgt t on t.item_id=l.content_item_id where l.label_scope='serving' and l.superseded_by is null and l.label_status='validated' and l.validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id); if n<>28 then raise exception 'label post-check %', n; end if;
  select count(*) into n from app.content_item_cells where source='apprecalc_u4a_2026_11_12_topic' and is_primary and superseded_by is null; if n<>28 then raise exception 'topic cell count %', n; end if;
end $$;
do $$ begin raise exception 'REHEARSAL OK (rolled back): published=%, validated_labels=%, topic_cells=%', (select count(*) from tgt), (select count(*) from app.content_taxonomy_labels where source='apprecalc_u4a_2026_11_12' and label_status='validated'), (select count(*) from app.content_item_cells where source='apprecalc_u4a_2026_11_12_topic'); end $$;
rollback;
