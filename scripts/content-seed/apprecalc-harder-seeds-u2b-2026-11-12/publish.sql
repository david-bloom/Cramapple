begin;
select pg_advisory_xact_lock(hashtext('cramapple-apprecalc-u2b-2026-11-12-publish-20261112'));
create temporary table lab (content_key text primary key, topic text, exp_hash text) on commit drop;
insert into lab values
('apprecalc-mcq-b8-h-2.9-a','2.9','0be914f155d13404fdac39b59593b874'),
('apprecalc-mcq-b8-sv-h-2.9-a-v1','2.9','a707435812d7f8f0c2a20ee9edb150ab'),
('apprecalc-mcq-b8-sv-h-2.9-a-v2','2.9','f832b1f47c6c8c7b208e3c6ec7b3a510'),
('apprecalc-mcq-b8-sv-h-2.9-a-v3','2.9','0527f192c74252044f69a1d44e7f3a05'),
('apprecalc-mcq-b8-h-2.9-b','2.9','38adc4fd31d0aa676e873b0d4e191ab3'),
('apprecalc-mcq-b8-sv-h-2.9-b-v1','2.9','093849ec4b3bb99046fc1254ef089755'),
('apprecalc-mcq-b8-sv-h-2.9-b-v2','2.9','7b9ba8d5872b8cee6ece1d1096179a27'),
('apprecalc-mcq-b8-sv-h-2.9-b-v3','2.9','2436e72c9ae8de588d6453dbbe0727e5'),
('apprecalc-mcq-b8-h-2.10-a','2.10','7d2da914f7fc75347f14be7a5a5cc48d'),
('apprecalc-mcq-b8-sv-h-2.10-a-v1','2.10','7fe5789a0ac09439a972f072eea7a70e'),
('apprecalc-mcq-b8-sv-h-2.10-a-v2','2.10','f2fe9ec751c17307a0774dd622d748c8'),
('apprecalc-mcq-b8-sv-h-2.10-a-v3','2.10','a182c369604e19bc66fa3324fdf45f78'),
('apprecalc-mcq-b8-h-2.10-b','2.10','b633818529510f6a26be8ee6c7045dde'),
('apprecalc-mcq-b8-sv-h-2.10-b-v1','2.10','0fb1d9c989a2cb0e6a249ba7a65b961b'),
('apprecalc-mcq-b8-sv-h-2.10-b-v2','2.10','e14a9c28cf72bdf4cf2161cc11b24328'),
('apprecalc-mcq-b8-sv-h-2.10-b-v3','2.10','351788a8035a72c705b3bc821f430754'),
('apprecalc-mcq-b8-h-2.11-a','2.11','11e23e03b048269f47e58a94db7b34d7'),
('apprecalc-mcq-b8-sv-h-2.11-a-v1','2.11','ca014e26d7a5b37e81378f9969a0d8a3'),
('apprecalc-mcq-b8-sv-h-2.11-a-v2','2.11','6d4e2a45ee30c42aba60ddd0bbd1dbaa'),
('apprecalc-mcq-b8-sv-h-2.11-a-v3','2.11','494dbb0803862bf162830dd147f837a4'),
('apprecalc-mcq-b8-h-2.11-b','2.11','1f782b1af1b8be14b2a1cb5c0f3734ba'),
('apprecalc-mcq-b8-sv-h-2.11-b-v1','2.11','1a0b2e8f56c867a3f590b92b3e19475f'),
('apprecalc-mcq-b8-sv-h-2.11-b-v2','2.11','b5669d02d07016404feea4af5dfc29f9'),
('apprecalc-mcq-b8-sv-h-2.11-b-v3','2.11','6c44f9ba10a2356f60ee922d9de73dd9'),
('apprecalc-mcq-b8-h-2.12-a','2.12','19fd34fdb91d0471ded1518f31c33c47'),
('apprecalc-mcq-b8-sv-h-2.12-a-v1','2.12','c5ce046c8f7bd5346b3170ddb209c6a3'),
('apprecalc-mcq-b8-sv-h-2.12-a-v2','2.12','1ba4d00ebc76f2c38084e2d98bbc0b85'),
('apprecalc-mcq-b8-sv-h-2.12-a-v3','2.12','58b47523e8887f9a8d75b8ca40fc81b2'),
('apprecalc-mcq-b8-h-2.12-b','2.12','5f287f456bf1cb52aac939b037f76498'),
('apprecalc-mcq-b8-sv-h-2.12-b-v1','2.12','fb5be9675cf3a493f51385d7089aa9cb'),
('apprecalc-mcq-b8-sv-h-2.12-b-v2','2.12','cf043b619341251b7172baad90a4d4af'),
('apprecalc-mcq-b8-sv-h-2.12-b-v3','2.12','e64bf2ba24088e8fe9c05611b0f8501c'),
('apprecalc-mcq-b8-h-2.13-a','2.13','7235dc9618c352286cf5673609a80868'),
('apprecalc-mcq-b8-sv-h-2.13-a-v1','2.13','24ec31c4bb66a80fa8ec9b779c819580'),
('apprecalc-mcq-b8-sv-h-2.13-a-v2','2.13','e5442df25496c98ca025d1b9b6555cae'),
('apprecalc-mcq-b8-sv-h-2.13-a-v3','2.13','a3bce17d4568aa37bb0d428ab7d18240'),
('apprecalc-mcq-b8-h-2.13-b','2.13','3e858348a78cd1b4947f83853a934fd4'),
('apprecalc-mcq-b8-sv-h-2.13-b-v1','2.13','f5ddf05d208019dd611ab090674520a1'),
('apprecalc-mcq-b8-sv-h-2.13-b-v2','2.13','a1dc7d40ccc6010eee7aa1911b7f1b2b'),
('apprecalc-mcq-b8-sv-h-2.13-b-v3','2.13','adbc0947d35c2222bf394bc20dbe60c0'),
('apprecalc-mcq-b8-h-2.14-a','2.14','2d52361e0d8cad8c7df9d64bdc3c7e39'),
('apprecalc-mcq-b8-sv-h-2.14-a-v1','2.14','db9384a038b475238b5bb6a7426a97a0'),
('apprecalc-mcq-b8-sv-h-2.14-a-v2','2.14','b9a691ad892d15eaa3db11c4be6cbb7d'),
('apprecalc-mcq-b8-sv-h-2.14-a-v3','2.14','07d953ab80860549c0ee731bd83b5e72'),
('apprecalc-mcq-b8-h-2.14-b','2.14','a8eee165f284031e54a7bb208363cb44'),
('apprecalc-mcq-b8-sv-h-2.14-b-v1','2.14','40585af9ce801e17fa25a8dfc6c301f1'),
('apprecalc-mcq-b8-sv-h-2.14-b-v2','2.14','2d7d05c0beba8cbf013b01c85b42c6b6'),
('apprecalc-mcq-b8-sv-h-2.14-b-v3','2.14','02e9dc559ba5f51b2f3428bfe80e997f'),
('apprecalc-mcq-b8-h-2.15-a','2.15','3502f7080bf961cf6f520ea25961cd5b'),
('apprecalc-mcq-b8-sv-h-2.15-a-v1','2.15','b668411dc489d5cbc93ff7dbed8cf992'),
('apprecalc-mcq-b8-sv-h-2.15-a-v2','2.15','f4d67dbd97e92b687305f8ede2524585'),
('apprecalc-mcq-b8-sv-h-2.15-a-v3','2.15','55d32edc337c53a4dde436a39dcbf5bf'),
('apprecalc-mcq-b8-h-2.15-b','2.15','aaaf16ad0eb6a3c865b2643a5e10150d'),
('apprecalc-mcq-b8-sv-h-2.15-b-v1','2.15','648e952123103846b9329822b2d4e814'),
('apprecalc-mcq-b8-sv-h-2.15-b-v2','2.15','2cba932f2054140b110cc1ca6358b5d9'),
('apprecalc-mcq-b8-sv-h-2.15-b-v3','2.15','337fccb953fecad86802b484f95d3eaf');
create temporary table tgt on commit drop as
select l.*, ci.id item_id, civ.id version_id, gen_random_uuid() assignment_id, gen_random_uuid() label_id, gen_random_uuid() vd_id,
 '16383753-6775-430d-960a-544cd6ee0972'::uuid tsv, (case topic when '2.1' then array[2] when '2.10' then array[2] when '2.11' then array[1, 2] when '2.12' then array[2] when '2.13' then array[2] when '2.14' then array[2] when '2.15' then array[2] when '2.2' then array[2] when '2.3' then array[2] when '2.4' then array[2] when '2.5' then array[2] when '2.6' then array[2] when '2.7' then array[2] when '2.8' then array[2] when '2.9' then array[2] end)::int[] req, 2 pu
from lab l join app.content_items ci on ci.content_key=l.content_key and ci.exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db'
join app.content_item_versions civ on civ.content_item_id=ci.id and civ.version_num=1
where ci.status='draft' and civ.status='draft';
do $$ begin
 if (select count(*) from tgt)<>56 then raise exception 'expected 56 draft targets, got %', (select count(*) from tgt); end if;
 if exists (select 1 from tgt where split_part(topic,'.',1)::int<>pu) then raise exception 'topic/unit mismatch'; end if;
 if exists (select 1 from tgt t join app.content_item_cells c on c.content_item_version_id=t.version_id) or exists (select 1 from tgt t join app.content_taxonomy_labels l on l.content_item_id=t.item_id) then raise exception 'a target already has cells or labels'; end if;
 if (select count(*) from (select t.content_key from tgt t join app.content_item_versions civ on civ.id=t.version_id join app.mcq_choices c on c.content_item_version_id=civ.id group by t.content_key, civ.stem, t.exp_hash having md5(civ.stem||'|'||string_agg(c.choice_key||':'||c.choice_text||':'||c.is_correct::text||':'||c.rationale,'|' order by c.choice_key))=t.exp_hash) z)<>56 then raise exception 'loaded text does not match the build manifest'; end if;
 if exists (select 1 from tgt t where not exists (select 1 from app.taxonomy_topics tt where tt.taxonomy_source_version=t.tsv and tt.topic_code=t.topic)) then raise exception 'a topic code is not present in the taxonomy source version'; end if;
end $$;
insert into app.content_review_assignments (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, review_kind, status, assignment_purpose, created_by)
select assignment_id, version_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'tutor_question', 'mcq', 'pending', 'owner_remediation_approval', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
insert into app.content_review_decisions (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, tutor_score, difficulty_label, diagnostic_flag, concern_codes, note, tutor_decision, decision_payload, decision_hash, created_by)
select assignment_id, version_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'tutor_question', 1, null, false, array[]::text[],
 'AP Precalculus Unit 3 harder seeds and variants (batch apprecalc_u2b_2026_11_12): Product Owner review of owner-session-authored drafts, 2026-11-12. Arithmetic verified in Python; no model-checker pass, by Product Owner decision.',
 'approve',
 jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apprecalc_u2b_2026_11_12_po_approval','qa_date','2026-11-12','content_key',content_key),
 md5(jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apprecalc_u2b_2026_11_12_po_approval','qa_date','2026-11-12','content_key',content_key)::text),
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
select label_id, item_id, 1, 'serving', req, 2, pu, array[]::text[], tsv, 'provisional', 'provisional_model',
 'apprecalc_u2b_2026_11_12',
 jsonb_build_object('origin','owner_authored','units_source','AP Precalculus Unit 2 (topics 2.x belong to unit 3; required_units set per topic from existing Unit 3 labels)','topic',topic,'report','scripts/content-seed/apchem-harder-seeds-u3-2026-11-12'),
 'apprecalc-u2b-2026-11-12-labeling', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
insert into app.content_taxonomy_validation_decisions (validation_decision_id, content_taxonomy_label_id, decided_by, decision, decision_source, reviewed_primary_unit, reviewed_required_units, notes)
select vd_id, label_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'confirmed', 'chat_review', pu, req,
 'Product Owner chat instruction 2026-11-12 (AP Precalculus harder seeds and variants). Topic assigned by the author from the question design (topic recorded on the cell); topic-only tagging, skill left null.' from tgt;
insert into app.content_item_cells (content_item_version_id, content_item_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id, validated_by, validated_at, validation_decision_id)
select version_id, item_id, tsv, topic, null, true, 'validated', 'apprecalc_u2b_2026_11_12_topic',
 'apprecalc-u2b-2026-11-12-labeling (topic set by the author from the question design)', null, now(), gen_random_uuid() from tgt;
update app.content_taxonomy_labels l set label_status='validated', validated_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, validated_at=now(), validation_decision_id=t.vd_id, validated_against_version_id=t.version_id, validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id) from tgt t where l.content_taxonomy_label_id=t.label_id;
update app.content_item_versions civ set status='published', published_at=coalesce(civ.published_at,now()), updated_at=now() from tgt where civ.id=tgt.version_id;
update app.content_items ci set status='published', updated_at=now() from tgt where ci.id=tgt.item_id;
do $$ declare n int; begin
  select count(*) into n from (select content_item_id from app.content_item_versions where status='published' group by 1 having count(*)>1) d; if n<>0 then raise exception 'duplicate published versions: %', n; end if;
  if (select count(*) from app.content_items ci join tgt on tgt.item_id=ci.id where ci.status='published')<>56 then raise exception 'publish count mismatch'; end if;
  select count(*) into n from app.content_taxonomy_labels l join tgt t on t.item_id=l.content_item_id where l.label_scope='serving' and l.superseded_by is null and l.label_status='validated' and l.validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id); if n<>56 then raise exception 'label post-check %', n; end if;
  select count(*) into n from app.content_item_cells where source='apprecalc_u2b_2026_11_12_topic' and is_primary and superseded_by is null; if n<>56 then raise exception 'topic cell count %', n; end if;
end $$;
select (select count(*) from tgt) published, (select count(*) from app.content_taxonomy_labels where source='apprecalc_u2b_2026_11_12' and label_status='validated') validated_labels, (select count(*) from app.content_item_cells where source='apprecalc_u2b_2026_11_12_topic') topic_cells;
commit;
