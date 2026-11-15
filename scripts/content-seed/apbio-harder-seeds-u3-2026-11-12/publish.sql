begin;
select pg_advisory_xact_lock(hashtext('cramapple-apbio-u3b-2026-11-12-publish-20261112'));
create temporary table lab (content_key text primary key, topic text, exp_hash text) on commit drop;
insert into lab values
('apbio-mcq-b2-h-3.1-a','3.1','7da812e51be7d6f9119b91fd19f55bc4'),
('apbio-mcq-b2-sv-h-3.1-a-v1','3.1','9fa9590f8e7796f9f736a7f2f93b1e8c'),
('apbio-mcq-b2-sv-h-3.1-a-v2','3.1','c8b1763078663582f45cb5990ca61971'),
('apbio-mcq-b2-sv-h-3.1-a-v3','3.1','14a6096f5e0a03cec6a32100d32a2644'),
('apbio-mcq-b2-h-3.1-b','3.1','14982954f6c447dbad8529ccc7cd7f4f'),
('apbio-mcq-b2-sv-h-3.1-b-v1','3.1','9c636584e781ba9394018da94b42b433'),
('apbio-mcq-b2-sv-h-3.1-b-v2','3.1','4f6099af7de0d62bbfa60cdbc3ec301b'),
('apbio-mcq-b2-sv-h-3.1-b-v3','3.1','89ba870562fc5045be0f1be9b32c3cea'),
('apbio-mcq-b2-h-3.1-c','3.1','002ba91ef5872570c531bea9aadb3801'),
('apbio-mcq-b2-sv-h-3.1-c-v1','3.1','7220b9bcef96f2f9fd6fcce3fbea0538'),
('apbio-mcq-b2-sv-h-3.1-c-v2','3.1','42909bac7a4d255c0937a8c3ec294be0'),
('apbio-mcq-b2-sv-h-3.1-c-v3','3.1','138224cc2e86496af3aadb9c5f206508'),
('apbio-mcq-b2-h-3.2-a','3.2','e5f524e9bd5bae37edcdcab93fe234fb'),
('apbio-mcq-b2-sv-h-3.2-a-v1','3.2','21f58b1ef3e19330cad4e6370991395f'),
('apbio-mcq-b2-sv-h-3.2-a-v2','3.2','efc39ffde7d3d26d94d787a79657f5e3'),
('apbio-mcq-b2-sv-h-3.2-a-v3','3.2','c2c8b1cf86ef53498e456b96604f1d93'),
('apbio-mcq-b2-h-3.2-b','3.2','8a7c41b48abf101ca07543ce3894b2df'),
('apbio-mcq-b2-sv-h-3.2-b-v1','3.2','63d8da9c544901a3af26d89a5c419a7e'),
('apbio-mcq-b2-sv-h-3.2-b-v2','3.2','0953ed3fc98b641e2ce717e9f3223aba'),
('apbio-mcq-b2-sv-h-3.2-b-v3','3.2','5eab8d4509e87ce3e155db67b6e45d3c'),
('apbio-mcq-b2-h-3.3-a','3.3','4557878d4f0cc47a01cb0992b9cad9c8'),
('apbio-mcq-b2-sv-h-3.3-a-v1','3.3','716c506780477d088c5799611fb99f6d'),
('apbio-mcq-b2-sv-h-3.3-a-v2','3.3','a36d710eca0ecf236a3b4b6f6f13ac9e'),
('apbio-mcq-b2-sv-h-3.3-a-v3','3.3','d1a667eb6709dd2c19d0302081abab66'),
('apbio-mcq-b2-h-3.3-b','3.3','20d68bef8b29d248979b44159a277f8c'),
('apbio-mcq-b2-sv-h-3.3-b-v1','3.3','aaef94b41244e64dad2d09e7b308b7d0'),
('apbio-mcq-b2-sv-h-3.3-b-v2','3.3','16f69e91b081b4e04806f3ba4a2bacdc'),
('apbio-mcq-b2-sv-h-3.3-b-v3','3.3','96d7894f3e846c62b5617f49bdec9afd'),
('apbio-mcq-b2-h-3.4-a','3.4','b624428c6900cc618be1ad0ded4afb7d'),
('apbio-mcq-b2-sv-h-3.4-a-v1','3.4','d6ec68722f4d56bb3e68642c5c25afb1'),
('apbio-mcq-b2-sv-h-3.4-a-v2','3.4','50528179fc710141362ece7a71118a56'),
('apbio-mcq-b2-sv-h-3.4-a-v3','3.4','1b40860ae1a00a2c81279cd2f548e95c'),
('apbio-mcq-b2-h-3.4-b','3.4','67d066a817e3b65d10b4368b8d1afcf3'),
('apbio-mcq-b2-sv-h-3.4-b-v1','3.4','577bb00109b3efd068bdb4e29c20f947'),
('apbio-mcq-b2-sv-h-3.4-b-v2','3.4','a0dfd92889c9fb9f9d5a12e873ddc5ca'),
('apbio-mcq-b2-sv-h-3.4-b-v3','3.4','62518b6984215cbe64fa1a0d150e123a'),
('apbio-mcq-b2-h-3.5-a','3.5','50140a365fc969ae8ef95c0fdd461905'),
('apbio-mcq-b2-sv-h-3.5-a-v1','3.5','7671948bcfd60a00c2d859366acc2520'),
('apbio-mcq-b2-sv-h-3.5-a-v2','3.5','19b8445d059a712c2800900890c63d60'),
('apbio-mcq-b2-sv-h-3.5-a-v3','3.5','ed765261117497692a89130ef6bc85c7');
create temporary table tgt on commit drop as
select l.*, ci.id item_id, civ.id version_id, gen_random_uuid() assignment_id, gen_random_uuid() label_id, gen_random_uuid() vd_id,
 'c676d1fc-3b58-4896-89e3-852d9bd1f81b'::uuid tsv, (case topic when '3.1' then array[3] when '3.2' then array[3] when '3.3' then array[3] when '3.4' then array[3] when '3.5' then array[3] when '3.8' then array[3] when '3.11' then array[3] end)::int[] req, 3 pu
from lab l join app.content_items ci on ci.content_key=l.content_key and ci.exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7'
join app.content_item_versions civ on civ.content_item_id=ci.id and civ.version_num=1
where ci.status='draft' and civ.status='draft';
do $$ begin
 if (select count(*) from tgt)<>40 then raise exception 'expected 40 draft targets, got %', (select count(*) from tgt); end if;
 if exists (select 1 from tgt where split_part(topic,'.',1)::int<>pu) then raise exception 'topic/unit mismatch'; end if;
 if exists (select 1 from tgt t join app.content_item_cells c on c.content_item_version_id=t.version_id) or exists (select 1 from tgt t join app.content_taxonomy_labels l on l.content_item_id=t.item_id) then raise exception 'a target already has cells or labels'; end if;
 if (select count(*) from (select t.content_key from tgt t join app.content_item_versions civ on civ.id=t.version_id join app.mcq_choices c on c.content_item_version_id=civ.id group by t.content_key, civ.stem, t.exp_hash having md5(civ.stem||'|'||string_agg(c.choice_key||':'||c.choice_text||':'||c.is_correct::text||':'||c.rationale,'|' order by c.choice_key))=t.exp_hash) z)<>40 then raise exception 'loaded text does not match the build manifest'; end if;
 if exists (select 1 from tgt t where not exists (select 1 from app.content_item_cells c join app.content_items ci2 on ci2.id=c.content_item_id where ci2.exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and c.topic_code=t.topic and c.taxonomy_source_version=t.tsv and c.superseded_by is null)) then raise exception 'a topic code is not present in the AP Biology taxonomy source version'; end if;
end $$;
insert into app.content_review_assignments (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, review_kind, status, assignment_purpose, created_by)
select assignment_id, version_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'tutor_question', 'mcq', 'pending', 'owner_remediation_approval', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
insert into app.content_review_decisions (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, tutor_score, difficulty_label, diagnostic_flag, concern_codes, note, tutor_decision, decision_payload, decision_hash, created_by)
select assignment_id, version_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'tutor_question', 1, null, false, array[]::text[],
 'AP Biology Unit 3 harder seeds and variants (batch apbio_u3b_2026_11_12): Product Owner review of owner-session-authored drafts, 2026-11-12. Arithmetic verified in Python; no model-checker pass, by Product Owner decision.',
 'approve',
 jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apbio_u3b_2026_11_12_po_approval','qa_date','2026-11-12','content_key',content_key),
 md5(jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apbio_u3b_2026_11_12_po_approval','qa_date','2026-11-12','content_key',content_key)::text),
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
 'apbio_u3b_2026_11_12',
 jsonb_build_object('origin','owner_authored','units_source','AP Biology Unit 3 (topics 3.x belong to unit 3; required_units set per topic from existing Unit 3 labels)','topic',topic,'report','scripts/content-seed/apchem-harder-seeds-u3-2026-11-12'),
 'apbio-u3b-2026-11-12-labeling', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
insert into app.content_taxonomy_validation_decisions (validation_decision_id, content_taxonomy_label_id, decided_by, decision, decision_source, reviewed_primary_unit, reviewed_required_units, notes)
select vd_id, label_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'confirmed', 'chat_review', pu, req,
 'Product Owner chat instruction 2026-11-12 (AP Biology harder seeds and variants). Topic assigned by the author from the question design (topic recorded on the cell); topic-only tagging, skill left null.' from tgt;
insert into app.content_item_cells (content_item_version_id, content_item_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id, validated_by, validated_at, validation_decision_id)
select version_id, item_id, tsv, topic, null, true, 'validated', 'apbio_u3b_2026_11_12_topic',
 'apbio-u3b-2026-11-12-labeling (topic set by the author from the question design)', null, now(), gen_random_uuid() from tgt;
update app.content_taxonomy_labels l set label_status='validated', validated_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, validated_at=now(), validation_decision_id=t.vd_id, validated_against_version_id=t.version_id, validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id) from tgt t where l.content_taxonomy_label_id=t.label_id;
update app.content_item_versions civ set status='published', published_at=coalesce(civ.published_at,now()), updated_at=now() from tgt where civ.id=tgt.version_id;
update app.content_items ci set status='published', updated_at=now() from tgt where ci.id=tgt.item_id;
do $$ declare n int; begin
  select count(*) into n from (select content_item_id from app.content_item_versions where status='published' group by 1 having count(*)>1) d; if n<>0 then raise exception 'duplicate published versions: %', n; end if;
  if (select count(*) from app.content_items ci join tgt on tgt.item_id=ci.id where ci.status='published')<>40 then raise exception 'publish count mismatch'; end if;
  select count(*) into n from app.content_taxonomy_labels l join tgt t on t.item_id=l.content_item_id where l.label_scope='serving' and l.superseded_by is null and l.label_status='validated' and l.validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id); if n<>40 then raise exception 'label post-check %', n; end if;
  select count(*) into n from app.content_item_cells where source='apbio_u3b_2026_11_12_topic' and is_primary and superseded_by is null; if n<>40 then raise exception 'topic cell count %', n; end if;
end $$;
select (select count(*) from tgt) published, (select count(*) from app.content_taxonomy_labels where source='apbio_u3b_2026_11_12' and label_status='validated') validated_labels, (select count(*) from app.content_item_cells where source='apbio_u3b_2026_11_12_topic') topic_cells;
commit;
