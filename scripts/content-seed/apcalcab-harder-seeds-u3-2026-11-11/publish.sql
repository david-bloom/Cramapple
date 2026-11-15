begin;
select pg_advisory_xact_lock(hashtext('cramapple-apcalcab-u3-harder-publish-20261111'));
create temporary table lab (content_key text primary key, topic text, exp_hash text) on commit drop;
insert into lab values
('apcalcab-mcq-h-3.1-a','3.1','1571ac29c18ffbee7923d35764731df5'),
('apcalcab-mcq-sv-h-3.1-a-v1','3.1','019cce388c6b4eeb139f758b9622ed06'),
('apcalcab-mcq-sv-h-3.1-a-v2','3.1','7ab3247f4419b31f09fa84bd5ba506c7'),
('apcalcab-mcq-sv-h-3.1-a-v3','3.1','8f6ff8eca1c8defb9e9c2bdaf956d282'),
('apcalcab-mcq-h-3.1-b','3.1','27f8c977ebd945d1d9b2512bdde2166a'),
('apcalcab-mcq-sv-h-3.1-b-v1','3.1','3688856983eedb779e38e5b9edcd4716'),
('apcalcab-mcq-sv-h-3.1-b-v2','3.1','e8a54b41da8328bdbcc0e4604ce22878'),
('apcalcab-mcq-sv-h-3.1-b-v3','3.1','c5a348d097418f81194bda876ef9c165'),
('apcalcab-mcq-h-3.2-a','3.2','6727fb4481310d201bd3c706c161ff0d'),
('apcalcab-mcq-sv-h-3.2-a-v1','3.2','56db56390908be8a8cd31b9457209e53'),
('apcalcab-mcq-sv-h-3.2-a-v2','3.2','2e14a4c7a164bce49febf21575eb394a'),
('apcalcab-mcq-sv-h-3.2-a-v3','3.2','6fe280eed62166c4bf5b8c3c31f880e5'),
('apcalcab-mcq-h-3.2-b','3.2','4afcd57eaa4ebbfe8cc60caf41ba78bc'),
('apcalcab-mcq-sv-h-3.2-b-v1','3.2','60e3e9a538c41761ec44ee187ad5c39f'),
('apcalcab-mcq-sv-h-3.2-b-v2','3.2','8b4b4482e190018e0e36754e2feca37c'),
('apcalcab-mcq-sv-h-3.2-b-v3','3.2','41ef9938a505007cef71753828c7763e'),
('apcalcab-mcq-h-3.3-a','3.3','e4b0dc3347b9f9aab024d80b86819084'),
('apcalcab-mcq-sv-h-3.3-a-v1','3.3','c88450d3980afe912b91d1bf675d1aca'),
('apcalcab-mcq-sv-h-3.3-a-v2','3.3','1deb70d46b3483d329f0199036e1deb4'),
('apcalcab-mcq-sv-h-3.3-a-v3','3.3','632d9f0205d2f0b9a2f66467627a8d4a'),
('apcalcab-mcq-h-3.3-b','3.3','1dc38e1ecb5b6b2a3ca2514b65d59ce8'),
('apcalcab-mcq-sv-h-3.3-b-v1','3.3','597e8743e506ce057ecd3809fb95cf55'),
('apcalcab-mcq-sv-h-3.3-b-v2','3.3','af6a4253ea7df56faf82a412792aabfd'),
('apcalcab-mcq-sv-h-3.3-b-v3','3.3','467c55f34d5dc6a131e6b43ade908a01');
create temporary table tgt on commit drop as
select l.*, ci.id item_id, civ.id version_id, gen_random_uuid() assignment_id, gen_random_uuid() label_id, gen_random_uuid() vd_id,
 '33b4408b-0ecc-4c7a-b0b1-612db81164a1'::uuid tsv, (case when topic='3.3' then array[3] else array[2,3] end)::int[] req, 3 pu
from lab l join app.content_items ci on ci.content_key=l.content_key and ci.exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d'
join app.content_item_versions civ on civ.content_item_id=ci.id and civ.version_num=1
where ci.status='draft' and civ.status='draft';
do $$ begin
 if (select count(*) from tgt)<>24 then raise exception 'expected 24 draft targets, got %', (select count(*) from tgt); end if;
 if exists (select 1 from tgt where split_part(topic,'.',1)::int<>pu) then raise exception 'topic/unit mismatch'; end if;
 if exists (select 1 from tgt t join app.content_item_cells c on c.content_item_version_id=t.version_id) or exists (select 1 from tgt t join app.content_taxonomy_labels l on l.content_item_id=t.item_id) then raise exception 'a target already has cells or labels'; end if;
 if (select count(*) from (select t.content_key from tgt t join app.content_item_versions civ on civ.id=t.version_id join app.mcq_choices c on c.content_item_version_id=civ.id group by t.content_key, civ.stem, t.exp_hash having md5(civ.stem||'|'||string_agg(c.choice_key||':'||c.choice_text||':'||c.is_correct::text||':'||c.rationale,'|' order by c.choice_key))=t.exp_hash) z)<>24 then raise exception 'loaded text does not match the build manifest'; end if;
 if exists (select 1 from tgt t where not exists (select 1 from app.content_item_cells c join app.content_items ci2 on ci2.id=c.content_item_id where ci2.exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and c.topic_code=t.topic and c.taxonomy_source_version=t.tsv and c.superseded_by is null)) then raise exception 'a topic code is not present in the Calculus AB taxonomy source version'; end if;
end $$;
insert into app.content_review_assignments (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, review_kind, status, assignment_purpose, created_by)
select assignment_id, version_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'tutor_question', 'mcq', 'pending', 'owner_remediation_approval', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
insert into app.content_review_decisions (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, tutor_score, difficulty_label, diagnostic_flag, concern_codes, note, tutor_decision, decision_payload, decision_hash, created_by)
select assignment_id, version_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'tutor_question', 1, null, false, array[]::text[],
 'AP Calculus AB harder seeds and variants (topics 3.1 to 3.3): Product Owner review of owner-session-authored drafts, 2026-11-11. Arithmetic verified in Python; no model-checker pass, by Product Owner decision.',
 'approve',
 jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apcalcab_u3_harder_po_approval','qa_date','2026-11-11','content_key',content_key),
 md5(jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apcalcab_u3_harder_po_approval','qa_date','2026-11-11','content_key',content_key)::text),
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
 'apcalcab_u3_harder_2026_11_11',
 jsonb_build_object('origin','owner_authored','units_source','Calculus AB Unit 3 (topics 3.x belong to unit 3; existing Unit 3 serving labels use required_units [2,3] or [3], primary_unit 3)','topic',topic,'report','scripts/content-seed/apcalcab-harder-seeds-u3-2026-11-11'),
 'apcalcab-u3-harder-labeling-2026-11-11', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
insert into app.content_taxonomy_validation_decisions (validation_decision_id, content_taxonomy_label_id, decided_by, decision, decision_source, reviewed_primary_unit, reviewed_required_units, notes)
select vd_id, label_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'confirmed', 'chat_review', pu, req,
 'Product Owner chat instruction 2026-11-11 (AP Chemistry harder seeds and variants). Topic assigned by the author from the question design (topic recorded on the cell); topic-only tagging, skill left null.' from tgt;
insert into app.content_item_cells (content_item_version_id, content_item_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id, validated_by, validated_at, validation_decision_id)
select version_id, item_id, tsv, topic, null, true, 'validated', 'apcalcab_u3_harder_topic_2026_11_11',
 'apcalcab-u3-harder-labeling-2026-11-11 (topic set by the author from the question design)', null, now(), gen_random_uuid() from tgt;
update app.content_taxonomy_labels l set label_status='validated', validated_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, validated_at=now(), validation_decision_id=t.vd_id, validated_against_version_id=t.version_id, validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id) from tgt t where l.content_taxonomy_label_id=t.label_id;
update app.content_item_versions civ set status='published', published_at=coalesce(civ.published_at,now()), updated_at=now() from tgt where civ.id=tgt.version_id;
update app.content_items ci set status='published', updated_at=now() from tgt where ci.id=tgt.item_id;
do $$ declare n int; begin
  select count(*) into n from (select content_item_id from app.content_item_versions where status='published' group by 1 having count(*)>1) d; if n<>0 then raise exception 'duplicate published versions: %', n; end if;
  if (select count(*) from app.content_items ci join tgt on tgt.item_id=ci.id where ci.status='published')<>24 then raise exception 'publish count mismatch'; end if;
  select count(*) into n from app.content_taxonomy_labels l join tgt t on t.item_id=l.content_item_id where l.label_scope='serving' and l.superseded_by is null and l.label_status='validated' and l.validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id); if n<>24 then raise exception 'label post-check %', n; end if;
  select count(*) into n from app.content_item_cells where source='apcalcab_u3_harder_topic_2026_11_11' and is_primary and superseded_by is null; if n<>24 then raise exception 'topic cell count %', n; end if;
end $$;
select (select count(*) from tgt) published, (select count(*) from app.content_taxonomy_labels where source='apcalcab_u3_harder_2026_11_11' and label_status='validated') validated_labels, (select count(*) from app.content_item_cells where source='apcalcab_u3_harder_topic_2026_11_11') topic_cells;
commit;
