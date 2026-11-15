begin;
select pg_advisory_xact_lock(hashtext('cramapple-apprecalc-u3-harder-publish-20261111'));
create temporary table lab (content_key text primary key, topic text, exp_hash text) on commit drop;
insert into lab values
('apprecalc-mcq-h-3.1-a','3.1','84dea26c22ca7cef147f912a0f90089c'),
('apprecalc-mcq-sv-h-3.1-a-v1','3.1','54002765a12d1e6b0e9fb99f991bfda8'),
('apprecalc-mcq-sv-h-3.1-a-v2','3.1','a7204a002dbb0e382267c718eb427a32'),
('apprecalc-mcq-sv-h-3.1-a-v3','3.1','1c2c31ff73c97a0637afc08ed11615b5'),
('apprecalc-mcq-h-3.1-b','3.1','3d1f06e7ae8f61df0fd29921bea0904b'),
('apprecalc-mcq-sv-h-3.1-b-v1','3.1','01edfece28e1cc3b069ea98186a4fd12'),
('apprecalc-mcq-sv-h-3.1-b-v2','3.1','dae2cab76d4ef0143e4b85d67b8bb3f6'),
('apprecalc-mcq-sv-h-3.1-b-v3','3.1','0a2c803d3540eb5c2a424c946f89f075'),
('apprecalc-mcq-h-3.2-a','3.2','e531c32aabb934f5a7a25013ef52a24d'),
('apprecalc-mcq-sv-h-3.2-a-v1','3.2','0050feda3fa001b3d57bdf323335ac7f'),
('apprecalc-mcq-sv-h-3.2-a-v2','3.2','c5ab6ab7e67d2cdbf086709ad349e645'),
('apprecalc-mcq-sv-h-3.2-a-v3','3.2','898c8f3e69e56088cf767943d961cb8e'),
('apprecalc-mcq-h-3.2-b','3.2','d711cc0893b16b12fd5fba181c4fceef'),
('apprecalc-mcq-sv-h-3.2-b-v1','3.2','db7e8f9a5fd2bd08ab39195ebd4f49db'),
('apprecalc-mcq-sv-h-3.2-b-v2','3.2','73e9fc7873b1a1106913c123cf2cfbeb'),
('apprecalc-mcq-sv-h-3.2-b-v3','3.2','cb66ba3eb9209215cf89457475ad1ba1'),
('apprecalc-mcq-h-3.3-a','3.3','1d60023d24188c86cc398856533cc601'),
('apprecalc-mcq-sv-h-3.3-a-v1','3.3','397c3d51b20b0978fb4688858ba09670'),
('apprecalc-mcq-sv-h-3.3-a-v2','3.3','65557dd1950331e6c0c2b1b565ed7a57'),
('apprecalc-mcq-sv-h-3.3-a-v3','3.3','45fc07383fdfec9c95411b46bb1c7917'),
('apprecalc-mcq-h-3.3-b','3.3','a5d77f5fe53ae2310d017e69dfb8608d'),
('apprecalc-mcq-sv-h-3.3-b-v1','3.3','dc993c1b70eb3e7202b266bfb928caa5'),
('apprecalc-mcq-sv-h-3.3-b-v2','3.3','45c5c05135130e0e50f30d56b8dd067e'),
('apprecalc-mcq-sv-h-3.3-b-v3','3.3','0c756fc9ddfa3d4dc068923b0bfd5fc4');
create temporary table tgt on commit drop as
select l.*, ci.id item_id, civ.id version_id, gen_random_uuid() assignment_id, gen_random_uuid() label_id, gen_random_uuid() vd_id,
 '16383753-6775-430d-960a-544cd6ee0972'::uuid tsv, array[3]::int[] req, 3 pu
from lab l join app.content_items ci on ci.content_key=l.content_key and ci.exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db'
join app.content_item_versions civ on civ.content_item_id=ci.id and civ.version_num=1
where ci.status='draft' and civ.status='draft';
do $$ begin
 if (select count(*) from tgt)<>24 then raise exception 'expected 24 draft targets, got %', (select count(*) from tgt); end if;
 if exists (select 1 from tgt where split_part(topic,'.',1)::int<>pu) then raise exception 'topic/unit mismatch'; end if;
 if exists (select 1 from tgt t join app.content_item_cells c on c.content_item_version_id=t.version_id) or exists (select 1 from tgt t join app.content_taxonomy_labels l on l.content_item_id=t.item_id) then raise exception 'a target already has cells or labels'; end if;
 if (select count(*) from (select t.content_key from tgt t join app.content_item_versions civ on civ.id=t.version_id join app.mcq_choices c on c.content_item_version_id=civ.id group by t.content_key, civ.stem, t.exp_hash having md5(civ.stem||'|'||string_agg(c.choice_key||':'||c.choice_text||':'||c.is_correct::text||':'||c.rationale,'|' order by c.choice_key))=t.exp_hash) z)<>24 then raise exception 'loaded text does not match the build manifest'; end if;
 if exists (select 1 from tgt t where not exists (select 1 from app.content_item_cells c join app.content_items ci2 on ci2.id=c.content_item_id where ci2.exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and c.topic_code=t.topic and c.taxonomy_source_version=t.tsv and c.superseded_by is null)) then raise exception 'a topic code is not present in the Precalculus taxonomy source version'; end if;
end $$;
insert into app.content_review_assignments (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, review_kind, status, assignment_purpose, created_by)
select assignment_id, version_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'tutor_question', 'mcq', 'pending', 'owner_remediation_approval', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
insert into app.content_review_decisions (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, tutor_score, difficulty_label, diagnostic_flag, concern_codes, note, tutor_decision, decision_payload, decision_hash, created_by)
select assignment_id, version_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'tutor_question', 1, null, false, array[]::text[],
 'AP Precalculus harder seeds and variants (topics 3.1 to 3.3): Product Owner review of owner-session-authored drafts, 2026-11-11. Arithmetic verified in Python; no model-checker pass, by Product Owner decision.',
 'approve',
 jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apprecalc_u3_harder_po_approval','qa_date','2026-11-11','content_key',content_key),
 md5(jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apprecalc_u3_harder_po_approval','qa_date','2026-11-11','content_key',content_key)::text),
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
 'apprecalc_u3_harder_2026_11_11',
 jsonb_build_object('origin','owner_authored','units_source','Precalculus Unit 3 (topics 3.x belong to unit 3; existing Unit 3 serving labels use required_units [3], primary_unit 3)','topic',topic,'report','scripts/content-seed/apprecalc-harder-seeds-u3-2026-11-11'),
 'apprecalc-u3-harder-labeling-2026-11-11', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
insert into app.content_taxonomy_validation_decisions (validation_decision_id, content_taxonomy_label_id, decided_by, decision, decision_source, reviewed_primary_unit, reviewed_required_units, notes)
select vd_id, label_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'confirmed', 'chat_review', pu, req,
 'Product Owner chat instruction 2026-11-11 (AP Precalculus harder seeds and variants). Topic assigned by the author from the question design (topic recorded on the cell); topic-only tagging, skill left null.' from tgt;
insert into app.content_item_cells (content_item_version_id, content_item_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id, validated_by, validated_at, validation_decision_id)
select version_id, item_id, tsv, topic, null, true, 'validated', 'apprecalc_u3_harder_topic_2026_11_11',
 'apprecalc-u3-harder-labeling-2026-11-11 (topic set by the author from the question design)', null, now(), gen_random_uuid() from tgt;
update app.content_taxonomy_labels l set label_status='validated', validated_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, validated_at=now(), validation_decision_id=t.vd_id, validated_against_version_id=t.version_id, validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id) from tgt t where l.content_taxonomy_label_id=t.label_id;
update app.content_item_versions civ set status='published', published_at=coalesce(civ.published_at,now()), updated_at=now() from tgt where civ.id=tgt.version_id;
update app.content_items ci set status='published', updated_at=now() from tgt where ci.id=tgt.item_id;
do $$ declare n int; begin
  select count(*) into n from (select content_item_id from app.content_item_versions where status='published' group by 1 having count(*)>1) d; if n<>0 then raise exception 'duplicate published versions: %', n; end if;
  if (select count(*) from app.content_items ci join tgt on tgt.item_id=ci.id where ci.status='published')<>24 then raise exception 'publish count mismatch'; end if;
  select count(*) into n from app.content_taxonomy_labels l join tgt t on t.item_id=l.content_item_id where l.label_scope='serving' and l.superseded_by is null and l.label_status='validated' and l.validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id); if n<>24 then raise exception 'label post-check %', n; end if;
  select count(*) into n from app.content_item_cells where source='apprecalc_u3_harder_topic_2026_11_11' and is_primary and superseded_by is null; if n<>24 then raise exception 'topic cell count %', n; end if;
end $$;
select (select count(*) from tgt) published, (select count(*) from app.content_taxonomy_labels where source='apprecalc_u3_harder_2026_11_11' and label_status='validated') validated_labels, (select count(*) from app.content_item_cells where source='apprecalc_u3_harder_topic_2026_11_11') topic_cells;
commit;
