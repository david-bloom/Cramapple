begin;
select pg_advisory_xact_lock(hashtext('cramapple-apphycm-u1-2026-11-12-publish-20261112'));
create temporary table lab (content_key text primary key, topic text, exp_hash text) on commit drop;
insert into lab values
('apphycm-mcq-b6-h-1.1-a','1.1','89fec8ffea0a8ffe6a7a2cd03fb8d329'),
('apphycm-mcq-b6-sv-h-1.1-a-v1','1.1','e58768d035a5fbc0980add59bc52f658'),
('apphycm-mcq-b6-sv-h-1.1-a-v2','1.1','40a421326a993d14ced15fa1d8bbc28b'),
('apphycm-mcq-b6-sv-h-1.1-a-v3','1.1','a02b6cab7ac126cc217f53898e6ddac8'),
('apphycm-mcq-b6-h-1.1-b','1.1','6230aff62f684cc4ec025e6d9b51c9cc'),
('apphycm-mcq-b6-sv-h-1.1-b-v1','1.1','104f4b253c64d2d5879659b3dbc2b8da'),
('apphycm-mcq-b6-sv-h-1.1-b-v2','1.1','8944e57193c64d007c238030c60f97ff'),
('apphycm-mcq-b6-sv-h-1.1-b-v3','1.1','867cda433ae1d1697f8cbe4d1f20b50e'),
('apphycm-mcq-b6-h-1.2-a','1.2','375df281f1fc01fe22353c96de8cda13'),
('apphycm-mcq-b6-sv-h-1.2-a-v1','1.2','ca82e9da31893f115ca20b6005439e88'),
('apphycm-mcq-b6-sv-h-1.2-a-v2','1.2','d075f77d87dea2be8c19f82913309e0b'),
('apphycm-mcq-b6-sv-h-1.2-a-v3','1.2','733cc56f33ab493a6232aee5765021d5'),
('apphycm-mcq-b6-h-1.2-b','1.2','d6a7fce7a8c82803aba6503a98fc13b8'),
('apphycm-mcq-b6-sv-h-1.2-b-v1','1.2','85eff25191deeeb012a098cea399a7e1'),
('apphycm-mcq-b6-sv-h-1.2-b-v2','1.2','e21cf645b546f8ef9b8c014d4017ea7b'),
('apphycm-mcq-b6-sv-h-1.2-b-v3','1.2','94a3fb83189cdb98ceae84cf4cfd7d63'),
('apphycm-mcq-b6-h-1.3-a','1.3','a2e89c65c470a1e57dc66d5c85984d24'),
('apphycm-mcq-b6-sv-h-1.3-a-v1','1.3','e7530bdfe87a16c91d824f9e1797b755'),
('apphycm-mcq-b6-sv-h-1.3-a-v2','1.3','eb80edc36c650f59a6d7d1b188aea8b4'),
('apphycm-mcq-b6-sv-h-1.3-a-v3','1.3','5e5f9a20f7538bc35d54c7bb1dbfbac8'),
('apphycm-mcq-b6-h-1.3-b','1.3','259104dc53b2f379e790e0c95aea0ecc'),
('apphycm-mcq-b6-sv-h-1.3-b-v1','1.3','e0f3b54e013e818bfe6980e968c35e15'),
('apphycm-mcq-b6-sv-h-1.3-b-v2','1.3','b95ca15b28926517493d9ddeadb62f84'),
('apphycm-mcq-b6-sv-h-1.3-b-v3','1.3','9775794c64e155f8b1b7b05d731e5cf3'),
('apphycm-mcq-b6-h-1.4-a','1.4','ebe3f09339d00b1f1d591392d679dfb4'),
('apphycm-mcq-b6-sv-h-1.4-a-v1','1.4','b365d4996d45d9e240d58e96e7700b4d'),
('apphycm-mcq-b6-sv-h-1.4-a-v2','1.4','9bf42e22078b5ec7d2e1d91813401bbb'),
('apphycm-mcq-b6-sv-h-1.4-a-v3','1.4','297a9439288fed922c90dd7b74eabcc6'),
('apphycm-mcq-b6-h-1.4-b','1.4','b804a2aa51560f6fb4f0c70e5ff0a8fd'),
('apphycm-mcq-b6-sv-h-1.4-b-v1','1.4','2602bc6b866a2ba7cdcfd8c2886702df'),
('apphycm-mcq-b6-sv-h-1.4-b-v2','1.4','67c8cad442a71ed881b1e3656b92e701'),
('apphycm-mcq-b6-sv-h-1.4-b-v3','1.4','21004f3917005b59fe4edb669288a942'),
('apphycm-mcq-b6-h-1.5-a','1.5','060cd297f48534257610d7097a1e9bac'),
('apphycm-mcq-b6-sv-h-1.5-a-v1','1.5','e7a86f88a93e3c312e7007dd3811a4f1'),
('apphycm-mcq-b6-sv-h-1.5-a-v2','1.5','ef3a01417f4f2456c4a667cd8fb2137e'),
('apphycm-mcq-b6-sv-h-1.5-a-v3','1.5','b52d9578b55379ee45f9474de837d9c6'),
('apphycm-mcq-b6-h-1.5-b','1.5','93cb0723e8e71261d2b7b7e7cf62bd00'),
('apphycm-mcq-b6-sv-h-1.5-b-v1','1.5','88151f25ae18a79a30cc6e249915d05d'),
('apphycm-mcq-b6-sv-h-1.5-b-v2','1.5','f3b3c9387f81640ae8e9b5fd3ba402bf'),
('apphycm-mcq-b6-sv-h-1.5-b-v3','1.5','b12dbb7ced5119e8829b49dcc2bb8c63');
create temporary table tgt on commit drop as
select l.*, ci.id item_id, civ.id version_id, gen_random_uuid() assignment_id, gen_random_uuid() label_id, gen_random_uuid() vd_id,
 'd77d7801-441d-49bb-a2cf-a02f6bff407d'::uuid tsv, (case topic when '1.1' then array[1] when '1.2' then array[1] when '1.3' then array[1] when '1.4' then array[1] when '1.5' then array[1] end)::int[] req, 1 pu
from lab l join app.content_items ci on ci.content_key=l.content_key and ci.exam_pack_version_id='ab92fc0f-7bab-4ea2-a1bc-7f03130ab7a9'
join app.content_item_versions civ on civ.content_item_id=ci.id and civ.version_num=1
where ci.status='draft' and civ.status='draft';
do $$ begin
 if (select count(*) from tgt)<>40 then raise exception 'expected 40 draft targets, got %', (select count(*) from tgt); end if;
 if exists (select 1 from tgt where split_part(topic,'.',1)::int<>pu) then raise exception 'topic/unit mismatch'; end if;
 if exists (select 1 from tgt t join app.content_item_cells c on c.content_item_version_id=t.version_id) or exists (select 1 from tgt t join app.content_taxonomy_labels l on l.content_item_id=t.item_id) then raise exception 'a target already has cells or labels'; end if;
 if (select count(*) from (select t.content_key from tgt t join app.content_item_versions civ on civ.id=t.version_id join app.mcq_choices c on c.content_item_version_id=civ.id group by t.content_key, civ.stem, t.exp_hash having md5(civ.stem||'|'||string_agg(c.choice_key||':'||c.choice_text||':'||c.is_correct::text||':'||c.rationale,'|' order by c.choice_key))=t.exp_hash) z)<>40 then raise exception 'loaded text does not match the build manifest'; end if;
 if exists (select 1 from tgt t where not exists (select 1 from app.taxonomy_topics tt where tt.taxonomy_source_version=t.tsv and tt.topic_code=t.topic)) then raise exception 'a topic code is not present in the taxonomy source version'; end if;
end $$;
insert into app.content_review_assignments (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, review_kind, status, assignment_purpose, created_by)
select assignment_id, version_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'tutor_question', 'mcq', 'pending', 'owner_remediation_approval', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
insert into app.content_review_decisions (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, tutor_score, difficulty_label, diagnostic_flag, concern_codes, note, tutor_decision, decision_payload, decision_hash, created_by)
select assignment_id, version_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'tutor_question', 1, null, false, array[]::text[],
 'AP Physics C: Mechanics Unit 3 harder seeds and variants (batch apphycm_u1_2026_11_12): Product Owner review of owner-session-authored drafts, 2026-11-12. Arithmetic verified in Python; no model-checker pass, by Product Owner decision.',
 'approve',
 jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apphycm_u1_2026_11_12_po_approval','qa_date','2026-11-12','content_key',content_key),
 md5(jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apphycm_u1_2026_11_12_po_approval','qa_date','2026-11-12','content_key',content_key)::text),
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
 'apphycm_u1_2026_11_12',
 jsonb_build_object('origin','owner_authored','units_source','AP Physics C: Mechanics Unit 1 (topics 1.x belong to unit 3; required_units set per topic from existing Unit 3 labels)','topic',topic,'report','scripts/content-seed/apchem-harder-seeds-u3-2026-11-12'),
 'apphycm-u1-2026-11-12-labeling', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
insert into app.content_taxonomy_validation_decisions (validation_decision_id, content_taxonomy_label_id, decided_by, decision, decision_source, reviewed_primary_unit, reviewed_required_units, notes)
select vd_id, label_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'confirmed', 'chat_review', pu, req,
 'Product Owner chat instruction 2026-11-12 (AP Physics C: Mechanics harder seeds and variants). Topic assigned by the author from the question design (topic recorded on the cell); topic-only tagging, skill left null.' from tgt;
insert into app.content_item_cells (content_item_version_id, content_item_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id, validated_by, validated_at, validation_decision_id)
select version_id, item_id, tsv, topic, null, true, 'validated', 'apphycm_u1_2026_11_12_topic',
 'apphycm-u1-2026-11-12-labeling (topic set by the author from the question design)', null, now(), gen_random_uuid() from tgt;
update app.content_taxonomy_labels l set label_status='validated', validated_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, validated_at=now(), validation_decision_id=t.vd_id, validated_against_version_id=t.version_id, validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id) from tgt t where l.content_taxonomy_label_id=t.label_id;
update app.content_item_versions civ set status='published', published_at=coalesce(civ.published_at,now()), updated_at=now() from tgt where civ.id=tgt.version_id;
update app.content_items ci set status='published', updated_at=now() from tgt where ci.id=tgt.item_id;
do $$ declare n int; begin
  select count(*) into n from (select content_item_id from app.content_item_versions where status='published' group by 1 having count(*)>1) d; if n<>0 then raise exception 'duplicate published versions: %', n; end if;
  if (select count(*) from app.content_items ci join tgt on tgt.item_id=ci.id where ci.status='published')<>40 then raise exception 'publish count mismatch'; end if;
  select count(*) into n from app.content_taxonomy_labels l join tgt t on t.item_id=l.content_item_id where l.label_scope='serving' and l.superseded_by is null and l.label_status='validated' and l.validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id); if n<>40 then raise exception 'label post-check %', n; end if;
  select count(*) into n from app.content_item_cells where source='apphycm_u1_2026_11_12_topic' and is_primary and superseded_by is null; if n<>40 then raise exception 'topic cell count %', n; end if;
end $$;
do $$ begin raise exception 'REHEARSAL OK (rolled back): published=%, validated_labels=%, topic_cells=%', (select count(*) from tgt), (select count(*) from app.content_taxonomy_labels where source='apphycm_u1_2026_11_12' and label_status='validated'), (select count(*) from app.content_item_cells where source='apphycm_u1_2026_11_12_topic'); end $$;
rollback;
