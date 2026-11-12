begin;
select pg_advisory_xact_lock(hashtext('cramapple-apbio-u1-2026-11-12-publish-20261112'));
create temporary table lab (content_key text primary key, topic text, exp_hash text) on commit drop;
insert into lab values
('apbio-mcq-b6-h-1.1-a','1.1','88c0bdf319414ba9c7a6ab0ea2049e48'),
('apbio-mcq-b6-sv-h-1.1-a-v1','1.1','c5fea27d5cfe29f06ae575b0adfcf71b'),
('apbio-mcq-b6-sv-h-1.1-a-v2','1.1','8be8fc80f424c6fe564c1e664cce1a96'),
('apbio-mcq-b6-sv-h-1.1-a-v3','1.1','86ada573bca459691b74cc04e9dd8025'),
('apbio-mcq-b6-h-1.1-b','1.1','eb58cd98ce577b0fb2490cbe31ea3e75'),
('apbio-mcq-b6-sv-h-1.1-b-v1','1.1','8fe869fc15f128d40ef253bf8795c330'),
('apbio-mcq-b6-sv-h-1.1-b-v2','1.1','da300224dcb02f95fe0f73c06f91906e'),
('apbio-mcq-b6-sv-h-1.1-b-v3','1.1','754e080eff4184a84b0f87bffe538cea'),
('apbio-mcq-b6-h-1.2-a','1.2','e65c36441a24ae3b1effb43956b2c53c'),
('apbio-mcq-b6-sv-h-1.2-a-v1','1.2','a501b835fe1327633236e8cd733fe4a8'),
('apbio-mcq-b6-sv-h-1.2-a-v2','1.2','82deddc77b06c082d35ee4b600a23c6f'),
('apbio-mcq-b6-sv-h-1.2-a-v3','1.2','830d4da024571b903973ed44cf085cab'),
('apbio-mcq-b6-h-1.2-b','1.2','661f56248f2e7e23b00f0cbd7d8db063'),
('apbio-mcq-b6-sv-h-1.2-b-v1','1.2','0bffa06d7ef29e74dd4b820593eb6271'),
('apbio-mcq-b6-sv-h-1.2-b-v2','1.2','5982cce3cc2b55f4564e7b819b8a2120'),
('apbio-mcq-b6-sv-h-1.2-b-v3','1.2','ef56124ca160d95894fa4517da0a33c9'),
('apbio-mcq-b6-h-1.3-a','1.3','083c9a806dda730be0ec3210556d89d1'),
('apbio-mcq-b6-sv-h-1.3-a-v1','1.3','6e5f79ea10b984e26d6e5cd21926fba5'),
('apbio-mcq-b6-sv-h-1.3-a-v2','1.3','b52b34b35c7a794cadf0ab999a5ce2f5'),
('apbio-mcq-b6-sv-h-1.3-a-v3','1.3','76f6a0c68fc04f23b29cbccd3a8125cd'),
('apbio-mcq-b6-h-1.3-b','1.3','a410f802c803943e5f98a8df75a121cd'),
('apbio-mcq-b6-sv-h-1.3-b-v1','1.3','15e18a6976959f9fed010c5d85558106'),
('apbio-mcq-b6-sv-h-1.3-b-v2','1.3','be780590da4325b3e23794c6dfb4d577'),
('apbio-mcq-b6-sv-h-1.3-b-v3','1.3','a0e9d0b9c4ba2bc38a327476bc203bdc'),
('apbio-mcq-b6-h-1.4-a','1.4','4972cc3dcaacf590a388bac615d12044'),
('apbio-mcq-b6-sv-h-1.4-a-v1','1.4','79028decc75beba6777020addb0fa9b4'),
('apbio-mcq-b6-sv-h-1.4-a-v2','1.4','696634d26cbf0707c1533c53f1b8552c'),
('apbio-mcq-b6-sv-h-1.4-a-v3','1.4','2cec2fccc6a8dd766888868c6aa42844'),
('apbio-mcq-b6-h-1.4-b','1.4','e338f18e3c180dec3168b2034841d713'),
('apbio-mcq-b6-sv-h-1.4-b-v1','1.4','70afd08f3cc7039417789c6822a108b1'),
('apbio-mcq-b6-sv-h-1.4-b-v2','1.4','279e72179ed548bafc23af37fe6da2d9'),
('apbio-mcq-b6-sv-h-1.4-b-v3','1.4','04710596a49009f6998c41c3535ba815'),
('apbio-mcq-b6-h-1.5-a','1.5','3fbe35c314024e36261e9e9d1c8bb498'),
('apbio-mcq-b6-sv-h-1.5-a-v1','1.5','8982815aff167017bf7c5741f842161b'),
('apbio-mcq-b6-sv-h-1.5-a-v2','1.5','f3224f0783b1b09bf6ac578c8f802fc0'),
('apbio-mcq-b6-sv-h-1.5-a-v3','1.5','4fb038b300719f315b0e98cb7087a3ad'),
('apbio-mcq-b6-h-1.5-b','1.5','c06ad12d596e1cd5d447550b6a8f58bc'),
('apbio-mcq-b6-sv-h-1.5-b-v1','1.5','c0febd1ea4f9dfb1c58f3893c69c97f6'),
('apbio-mcq-b6-sv-h-1.5-b-v2','1.5','908ad59c3204558690018fb06fb7408e'),
('apbio-mcq-b6-sv-h-1.5-b-v3','1.5','e15ac6a9b2973f33f6357c084ba8ebd6'),
('apbio-mcq-b6-h-1.6-a','1.6','fecd6b362d0b61cc054f03c1f6ee9be9'),
('apbio-mcq-b6-sv-h-1.6-a-v1','1.6','3326e25bc3bb94517c04084b9f3895ab'),
('apbio-mcq-b6-sv-h-1.6-a-v2','1.6','183696152a137f8f8b255f6873f6afbd'),
('apbio-mcq-b6-sv-h-1.6-a-v3','1.6','3ea14ef404128acdb628e0c7c7ece24c'),
('apbio-mcq-b6-h-1.6-b','1.6','c383a888174560865ff621d0e919c8db'),
('apbio-mcq-b6-sv-h-1.6-b-v1','1.6','ba62b4d7b3fc3b5a26690bc006323ef1'),
('apbio-mcq-b6-sv-h-1.6-b-v2','1.6','b4bf77fb52d70b98ab6822ef81cb3099'),
('apbio-mcq-b6-sv-h-1.6-b-v3','1.6','71cc21e9ac427955c1b55eed23721f3c'),
('apbio-mcq-b6-h-1.7-a','1.7','34ab57d0821a48afb7cabce3adaed081'),
('apbio-mcq-b6-sv-h-1.7-a-v1','1.7','e4621e0d6c179c64b856772b146ffa29'),
('apbio-mcq-b6-sv-h-1.7-a-v2','1.7','9c56f8eb7107aa1001f099b6ab61d399'),
('apbio-mcq-b6-sv-h-1.7-a-v3','1.7','1d80cf905242433cb7666cccf864329f'),
('apbio-mcq-b6-h-1.7-b','1.7','dbc2727a1fb4ddd498677a2aa0998ea6'),
('apbio-mcq-b6-sv-h-1.7-b-v1','1.7','85278e54562610228a881964d625e8d4'),
('apbio-mcq-b6-sv-h-1.7-b-v2','1.7','18d50cf24c2336ca4258811d1cec6b51'),
('apbio-mcq-b6-sv-h-1.7-b-v3','1.7','f3fe22c7752feac9f90299f134bef7ee');
create temporary table tgt on commit drop as
select l.*, ci.id item_id, civ.id version_id, gen_random_uuid() assignment_id, gen_random_uuid() label_id, gen_random_uuid() vd_id,
 'c676d1fc-3b58-4896-89e3-852d9bd1f81b'::uuid tsv, (case topic when '1.1' then array[1] when '1.2' then array[1] when '1.3' then array[1] when '1.4' then array[1] when '1.5' then array[1] when '1.6' then array[1] when '1.7' then array[1] end)::int[] req, 1 pu
from lab l join app.content_items ci on ci.content_key=l.content_key and ci.exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7'
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
 'AP Biology Unit 3 harder seeds and variants (batch apbio_u1_2026_11_12): Product Owner review of owner-session-authored drafts, 2026-11-12. Arithmetic verified in Python; no model-checker pass, by Product Owner decision.',
 'approve',
 jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apbio_u1_2026_11_12_po_approval','qa_date','2026-11-12','content_key',content_key),
 md5(jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apbio_u1_2026_11_12_po_approval','qa_date','2026-11-12','content_key',content_key)::text),
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
select label_id, item_id, 1, 'serving', req, 1, pu, array[]::text[], tsv, 'provisional', 'provisional_model',
 'apbio_u1_2026_11_12',
 jsonb_build_object('origin','owner_authored','units_source','AP Biology Unit 1 (topics 1.x belong to unit 3; required_units set per topic from existing Unit 3 labels)','topic',topic,'report','scripts/content-seed/apchem-harder-seeds-u3-2026-11-12'),
 'apbio-u1-2026-11-12-labeling', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
insert into app.content_taxonomy_validation_decisions (validation_decision_id, content_taxonomy_label_id, decided_by, decision, decision_source, reviewed_primary_unit, reviewed_required_units, notes)
select vd_id, label_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'confirmed', 'chat_review', pu, req,
 'Product Owner chat instruction 2026-11-12 (AP Biology harder seeds and variants). Topic assigned by the author from the question design (topic recorded on the cell); topic-only tagging, skill left null.' from tgt;
insert into app.content_item_cells (content_item_version_id, content_item_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id, validated_by, validated_at, validation_decision_id)
select version_id, item_id, tsv, topic, null, true, 'validated', 'apbio_u1_2026_11_12_topic',
 'apbio-u1-2026-11-12-labeling (topic set by the author from the question design)', null, now(), gen_random_uuid() from tgt;
update app.content_taxonomy_labels l set label_status='validated', validated_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, validated_at=now(), validation_decision_id=t.vd_id, validated_against_version_id=t.version_id, validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id) from tgt t where l.content_taxonomy_label_id=t.label_id;
update app.content_item_versions civ set status='published', published_at=coalesce(civ.published_at,now()), updated_at=now() from tgt where civ.id=tgt.version_id;
update app.content_items ci set status='published', updated_at=now() from tgt where ci.id=tgt.item_id;
do $$ declare n int; begin
  select count(*) into n from (select content_item_id from app.content_item_versions where status='published' group by 1 having count(*)>1) d; if n<>0 then raise exception 'duplicate published versions: %', n; end if;
  if (select count(*) from app.content_items ci join tgt on tgt.item_id=ci.id where ci.status='published')<>56 then raise exception 'publish count mismatch'; end if;
  select count(*) into n from app.content_taxonomy_labels l join tgt t on t.item_id=l.content_item_id where l.label_scope='serving' and l.superseded_by is null and l.label_status='validated' and l.validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id); if n<>56 then raise exception 'label post-check %', n; end if;
  select count(*) into n from app.content_item_cells where source='apbio_u1_2026_11_12_topic' and is_primary and superseded_by is null; if n<>56 then raise exception 'topic cell count %', n; end if;
end $$;
select (select count(*) from tgt) published, (select count(*) from app.content_taxonomy_labels where source='apbio_u1_2026_11_12' and label_status='validated') validated_labels, (select count(*) from app.content_item_cells where source='apbio_u1_2026_11_12_topic') topic_cells;
commit;
