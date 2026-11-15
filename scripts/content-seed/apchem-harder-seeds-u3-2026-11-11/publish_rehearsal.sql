begin;
select pg_advisory_xact_lock(hashtext('cramapple-apchem-u3-harder-publish-20261111'));
create temporary table lab (content_key text primary key, topic text, exp_hash text) on commit drop;
insert into lab values
('apchem-mcq-h-3.1-a','3.1','cc2c7779f3e8f03e8bac796294c12b77'),
('apchem-mcq-sv-h-3.1-a-v1','3.1','26c431c63d4d824d1b9d4c124821a679'),
('apchem-mcq-sv-h-3.1-a-v2','3.1','8c22486c4b3321b7d40010e5a3d033f2'),
('apchem-mcq-sv-h-3.1-a-v3','3.1','0a73c2bf772cf0c299429770feb8e66c'),
('apchem-mcq-h-3.1-b','3.1','44031bf0a1eecbb9d04f529a8b90ef45'),
('apchem-mcq-sv-h-3.1-b-v1','3.1','115839fbcdf7bec4d879fa244e09c0cb'),
('apchem-mcq-sv-h-3.1-b-v2','3.1','89c7c453b1fc549e8c8f274a4966a889'),
('apchem-mcq-sv-h-3.1-b-v3','3.1','49e98bce2f139c215e682d895fa7c842'),
('apchem-mcq-h-3.2-a','3.2','af1b07be82c33b1d96e51ebd13c37dd1'),
('apchem-mcq-sv-h-3.2-a-v1','3.2','3d941d46fc4d9acf2b04c055165a34d2'),
('apchem-mcq-sv-h-3.2-a-v2','3.2','5f4db63c0ae8b15539f0d9d77baa2ad1'),
('apchem-mcq-sv-h-3.2-a-v3','3.2','d9a2f106dd7ed82d1d3fd7da93744143'),
('apchem-mcq-h-3.2-b','3.2','fa895e8c78f6f2364567a4d8a7f3e6f3'),
('apchem-mcq-sv-h-3.2-b-v1','3.2','119ec2e9172b5bc8a1b4ec59c68fbb3e'),
('apchem-mcq-sv-h-3.2-b-v2','3.2','0d98ceebe2e08ca91d5a43ce2c292fdd'),
('apchem-mcq-sv-h-3.2-b-v3','3.2','67d1c463681c94ccb9214f07f19f9b20'),
('apchem-mcq-h-3.3-a','3.3','3e40a0dab5367944624af82cbc669dd0'),
('apchem-mcq-sv-h-3.3-a-v1','3.3','5788e5bf1ce0dd72faed1d76351a3566'),
('apchem-mcq-sv-h-3.3-a-v2','3.3','210b91338547a76f9af32e49d830bc73'),
('apchem-mcq-sv-h-3.3-a-v3','3.3','cf80e09d070bb6093ebb3f8891c56925'),
('apchem-mcq-h-3.3-b','3.3','af6692b734cc2b8637154130cfd70b36'),
('apchem-mcq-sv-h-3.3-b-v1','3.3','20f056bf4b9f3974c1102b35ddc89ae3'),
('apchem-mcq-sv-h-3.3-b-v2','3.3','67f0f670a448364e3502996a29199c91'),
('apchem-mcq-sv-h-3.3-b-v3','3.3','4f225b9901b15d28193e9a089a5b62a6');
create temporary table tgt on commit drop as
select l.*, ci.id item_id, civ.id version_id, gen_random_uuid() assignment_id, gen_random_uuid() label_id, gen_random_uuid() vd_id,
 'cbe3116f-6ef5-410c-b535-e9fb711c4c2c'::uuid tsv, array[3]::int[] req, 3 pu
from lab l join app.content_items ci on ci.content_key=l.content_key and ci.exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b'
join app.content_item_versions civ on civ.content_item_id=ci.id and civ.version_num=1
where ci.status='draft' and civ.status='draft';
do $$ begin
 if (select count(*) from tgt)<>24 then raise exception 'expected 24 draft targets, got %', (select count(*) from tgt); end if;
 if exists (select 1 from tgt where split_part(topic,'.',1)::int<>pu) then raise exception 'topic/unit mismatch'; end if;
 if exists (select 1 from tgt t join app.content_item_cells c on c.content_item_version_id=t.version_id) or exists (select 1 from tgt t join app.content_taxonomy_labels l on l.content_item_id=t.item_id) then raise exception 'a target already has cells or labels'; end if;
 if (select count(*) from (select t.content_key from tgt t join app.content_item_versions civ on civ.id=t.version_id join app.mcq_choices c on c.content_item_version_id=civ.id group by t.content_key, civ.stem, t.exp_hash having md5(civ.stem||'|'||string_agg(c.choice_key||':'||c.choice_text||':'||c.is_correct::text||':'||c.rationale,'|' order by c.choice_key))=t.exp_hash) z)<>24 then raise exception 'loaded text does not match the build manifest'; end if;
 if exists (select 1 from tgt t where not exists (select 1 from app.content_item_cells c join app.content_items ci2 on ci2.id=c.content_item_id where ci2.exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and c.topic_code=t.topic and c.taxonomy_source_version=t.tsv and c.superseded_by is null)) then raise exception 'a topic code is not present in the Chemistry taxonomy source version'; end if;
end $$;
insert into app.content_review_assignments (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, review_kind, status, assignment_purpose, created_by)
select assignment_id, version_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'tutor_question', 'mcq', 'pending', 'owner_remediation_approval', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
insert into app.content_review_decisions (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, tutor_score, difficulty_label, diagnostic_flag, concern_codes, note, tutor_decision, decision_payload, decision_hash, created_by)
select assignment_id, version_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'tutor_question', 1, null, false, array[]::text[],
 'AP Chemistry harder seeds and variants (topics 3.1 to 3.3): Product Owner review of owner-session-authored drafts, 2026-11-11. Arithmetic verified in Python; no model-checker pass, by Product Owner decision.',
 'approve',
 jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apchem_u3_harder_po_approval','qa_date','2026-11-11','content_key',content_key),
 md5(jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apchem_u3_harder_po_approval','qa_date','2026-11-11','content_key',content_key)::text),
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
 'apchem_u3_harder_2026_11_11',
 jsonb_build_object('origin','owner_authored','units_source','Chemistry Unit 3 (topics 3.x belong to unit 3; existing Unit 3 serving labels use required_units [3], primary_unit 3)','topic',topic,'report','scripts/content-seed/apchem-harder-seeds-u3-2026-11-11'),
 'apchem-u3-harder-labeling-2026-11-11', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
insert into app.content_taxonomy_validation_decisions (validation_decision_id, content_taxonomy_label_id, decided_by, decision, decision_source, reviewed_primary_unit, reviewed_required_units, notes)
select vd_id, label_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'confirmed', 'chat_review', pu, req,
 'Product Owner chat instruction 2026-11-11 (AP Chemistry harder seeds and variants). Topic assigned by the author from the question design (topic recorded on the cell); topic-only tagging, skill left null.' from tgt;
insert into app.content_item_cells (content_item_version_id, content_item_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id, validated_by, validated_at, validation_decision_id)
select version_id, item_id, tsv, topic, null, true, 'validated', 'apchem_u3_harder_topic_2026_11_11',
 'apchem-u3-harder-labeling-2026-11-11 (topic set by the author from the question design)', null, now(), gen_random_uuid() from tgt;
update app.content_taxonomy_labels l set label_status='validated', validated_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, validated_at=now(), validation_decision_id=t.vd_id, validated_against_version_id=t.version_id, validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id) from tgt t where l.content_taxonomy_label_id=t.label_id;
update app.content_item_versions civ set status='published', published_at=coalesce(civ.published_at,now()), updated_at=now() from tgt where civ.id=tgt.version_id;
update app.content_items ci set status='published', updated_at=now() from tgt where ci.id=tgt.item_id;
do $$ declare n int; begin
  select count(*) into n from (select content_item_id from app.content_item_versions where status='published' group by 1 having count(*)>1) d; if n<>0 then raise exception 'duplicate published versions: %', n; end if;
  if (select count(*) from app.content_items ci join tgt on tgt.item_id=ci.id where ci.status='published')<>24 then raise exception 'publish count mismatch'; end if;
  select count(*) into n from app.content_taxonomy_labels l join tgt t on t.item_id=l.content_item_id where l.label_scope='serving' and l.superseded_by is null and l.label_status='validated' and l.validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id); if n<>24 then raise exception 'label post-check %', n; end if;
  select count(*) into n from app.content_item_cells where source='apchem_u3_harder_topic_2026_11_11' and is_primary and superseded_by is null; if n<>24 then raise exception 'topic cell count %', n; end if;
end $$;
do $$ begin raise exception 'REHEARSAL OK (rolled back): published=%, validated_labels=%, topic_cells=%', (select count(*) from tgt), (select count(*) from app.content_taxonomy_labels where source='apchem_u3_harder_2026_11_11' and label_status='validated'), (select count(*) from app.content_item_cells where source='apchem_u3_harder_topic_2026_11_11'); end $$;
rollback;
