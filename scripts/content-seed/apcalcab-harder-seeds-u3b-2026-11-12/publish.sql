begin;
select pg_advisory_xact_lock(hashtext('cramapple-apcalcab-u3b-2026-11-12-publish-20261112'));
create temporary table lab (content_key text primary key, topic text, exp_hash text) on commit drop;
insert into lab values
('apcalcab-mcq-b2-h-3.4-a','3.4','355b10551f00c5cfa502ce1b764f8c53'),
('apcalcab-mcq-b2-sv-h-3.4-a-v1','3.4','5f382e88ec7029ba480c00eaf7aa9b78'),
('apcalcab-mcq-b2-sv-h-3.4-a-v2','3.4','44ace3b80648982c040f8cd796dc8617'),
('apcalcab-mcq-b2-sv-h-3.4-a-v3','3.4','bbf5eca0f32536553cddcf245a35f78c'),
('apcalcab-mcq-b2-h-3.4-b','3.4','d4329837098e31efdcd0058ce91ca715'),
('apcalcab-mcq-b2-sv-h-3.4-b-v1','3.4','8059137e38e2ce0679bfdc960dad77d0'),
('apcalcab-mcq-b2-sv-h-3.4-b-v2','3.4','44a7f723bb4489ac308fc4828a6393bb'),
('apcalcab-mcq-b2-sv-h-3.4-b-v3','3.4','341a91a2914e2a5ef993a2bdc1f9ed32'),
('apcalcab-mcq-b2-h-3.5-a','3.5','71b03df35f0ab871b171ed93481bd2bf'),
('apcalcab-mcq-b2-sv-h-3.5-a-v1','3.5','371561226e4148af96522c8c6874fbde'),
('apcalcab-mcq-b2-sv-h-3.5-a-v2','3.5','8578388de63bdb0f95acb1c556dc2aa6'),
('apcalcab-mcq-b2-sv-h-3.5-a-v3','3.5','31d4fec200d62bdaec36b8a0054abf65'),
('apcalcab-mcq-b2-h-3.5-b','3.5','9496e3fadfafcfb334885482e33a1e41'),
('apcalcab-mcq-b2-sv-h-3.5-b-v1','3.5','30069d5a6176e73010dd52b66f2c1e1e'),
('apcalcab-mcq-b2-sv-h-3.5-b-v2','3.5','2515f9baca3e38514e3678c002c987a4'),
('apcalcab-mcq-b2-sv-h-3.5-b-v3','3.5','29c734006706b03df4eb136cfcf68222'),
('apcalcab-mcq-b2-h-3.6-a','3.6','626c77e73c1f95963eeb171072ca5466'),
('apcalcab-mcq-b2-sv-h-3.6-a-v1','3.6','c2bd896d8e979e2cbe502a8ecba30e8e'),
('apcalcab-mcq-b2-sv-h-3.6-a-v2','3.6','30ff668e48277e5fe09fad62e4c29a50'),
('apcalcab-mcq-b2-sv-h-3.6-a-v3','3.6','fb7c5b53b8735eec7ebd89a80038e478'),
('apcalcab-mcq-b2-h-3.6-b','3.6','b66508b405c8e4b27fdad85dbcdc9d5b'),
('apcalcab-mcq-b2-sv-h-3.6-b-v1','3.6','8cd787b4ce3a6a741b8b1caf9b1def75'),
('apcalcab-mcq-b2-sv-h-3.6-b-v2','3.6','fbc6b2a270e3693a0c90c1c22352bc18'),
('apcalcab-mcq-b2-sv-h-3.6-b-v3','3.6','5410aa2a4ea693e99dc828e236c8de69');
create temporary table tgt on commit drop as
select l.*, ci.id item_id, civ.id version_id, gen_random_uuid() assignment_id, gen_random_uuid() label_id, gen_random_uuid() vd_id,
 '33b4408b-0ecc-4c7a-b0b1-612db81164a1'::uuid tsv, (case topic when '3.1' then array[2, 3] when '3.2' then array[2, 3] when '3.3' then array[3] when '3.4' then array[3] when '3.5' then array[2, 3] when '3.6' then array[2, 3] when '3.8' then array[3] when '3.11' then array[3] end)::int[] req, 3 pu
from lab l join app.content_items ci on ci.content_key=l.content_key and ci.exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d'
join app.content_item_versions civ on civ.content_item_id=ci.id and civ.version_num=1
where ci.status='draft' and civ.status='draft';
do $$ begin
 if (select count(*) from tgt)<>24 then raise exception 'expected 24 draft targets, got %', (select count(*) from tgt); end if;
 if exists (select 1 from tgt where split_part(topic,'.',1)::int<>pu) then raise exception 'topic/unit mismatch'; end if;
 if exists (select 1 from tgt t join app.content_item_cells c on c.content_item_version_id=t.version_id) or exists (select 1 from tgt t join app.content_taxonomy_labels l on l.content_item_id=t.item_id) then raise exception 'a target already has cells or labels'; end if;
 if (select count(*) from (select t.content_key from tgt t join app.content_item_versions civ on civ.id=t.version_id join app.mcq_choices c on c.content_item_version_id=civ.id group by t.content_key, civ.stem, t.exp_hash having md5(civ.stem||'|'||string_agg(c.choice_key||':'||c.choice_text||':'||c.is_correct::text||':'||c.rationale,'|' order by c.choice_key))=t.exp_hash) z)<>24 then raise exception 'loaded text does not match the build manifest'; end if;
 if exists (select 1 from tgt t where not exists (select 1 from app.content_item_cells c join app.content_items ci2 on ci2.id=c.content_item_id where ci2.exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d' and c.topic_code=t.topic and c.taxonomy_source_version=t.tsv and c.superseded_by is null)) then raise exception 'a topic code is not present in the AP Calculus AB taxonomy source version'; end if;
end $$;
insert into app.content_review_assignments (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, review_kind, status, assignment_purpose, created_by)
select assignment_id, version_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'tutor_question', 'mcq', 'pending', 'owner_remediation_approval', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
insert into app.content_review_decisions (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, tutor_score, difficulty_label, diagnostic_flag, concern_codes, note, tutor_decision, decision_payload, decision_hash, created_by)
select assignment_id, version_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'tutor_question', 1, null, false, array[]::text[],
 'AP Calculus AB Unit 3 harder seeds and variants (batch apcalcab_u3b_2026_11_12): Product Owner review of owner-session-authored drafts, 2026-11-12. Arithmetic verified in Python; no model-checker pass, by Product Owner decision.',
 'approve',
 jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apcalcab_u3b_2026_11_12_po_approval','qa_date','2026-11-12','content_key',content_key),
 md5(jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apcalcab_u3b_2026_11_12_po_approval','qa_date','2026-11-12','content_key',content_key)::text),
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
 'apcalcab_u3b_2026_11_12',
 jsonb_build_object('origin','owner_authored','units_source','AP Calculus AB Unit 3 (topics 3.x belong to unit 3; required_units set per topic from existing Unit 3 labels)','topic',topic,'report','scripts/content-seed/apchem-harder-seeds-u3-2026-11-12'),
 'apcalcab-u3b-2026-11-12-labeling', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
insert into app.content_taxonomy_validation_decisions (validation_decision_id, content_taxonomy_label_id, decided_by, decision, decision_source, reviewed_primary_unit, reviewed_required_units, notes)
select vd_id, label_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'confirmed', 'chat_review', pu, req,
 'Product Owner chat instruction 2026-11-12 (AP Calculus AB harder seeds and variants). Topic assigned by the author from the question design (topic recorded on the cell); topic-only tagging, skill left null.' from tgt;
insert into app.content_item_cells (content_item_version_id, content_item_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id, validated_by, validated_at, validation_decision_id)
select version_id, item_id, tsv, topic, null, true, 'validated', 'apcalcab_u3b_2026_11_12_topic',
 'apcalcab-u3b-2026-11-12-labeling (topic set by the author from the question design)', null, now(), gen_random_uuid() from tgt;
update app.content_taxonomy_labels l set label_status='validated', validated_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, validated_at=now(), validation_decision_id=t.vd_id, validated_against_version_id=t.version_id, validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id) from tgt t where l.content_taxonomy_label_id=t.label_id;
update app.content_item_versions civ set status='published', published_at=coalesce(civ.published_at,now()), updated_at=now() from tgt where civ.id=tgt.version_id;
update app.content_items ci set status='published', updated_at=now() from tgt where ci.id=tgt.item_id;
do $$ declare n int; begin
  select count(*) into n from (select content_item_id from app.content_item_versions where status='published' group by 1 having count(*)>1) d; if n<>0 then raise exception 'duplicate published versions: %', n; end if;
  if (select count(*) from app.content_items ci join tgt on tgt.item_id=ci.id where ci.status='published')<>24 then raise exception 'publish count mismatch'; end if;
  select count(*) into n from app.content_taxonomy_labels l join tgt t on t.item_id=l.content_item_id where l.label_scope='serving' and l.superseded_by is null and l.label_status='validated' and l.validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id); if n<>24 then raise exception 'label post-check %', n; end if;
  select count(*) into n from app.content_item_cells where source='apcalcab_u3b_2026_11_12_topic' and is_primary and superseded_by is null; if n<>24 then raise exception 'topic cell count %', n; end if;
end $$;
select (select count(*) from tgt) published, (select count(*) from app.content_taxonomy_labels where source='apcalcab_u3b_2026_11_12' and label_status='validated') validated_labels, (select count(*) from app.content_item_cells where source='apcalcab_u3b_2026_11_12_topic') topic_cells;
commit;
