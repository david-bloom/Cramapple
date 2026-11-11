begin;
select pg_advisory_xact_lock(hashtext('cramapple-apcalcbc-u4-2026-11-12-publish-20261112'));
create temporary table lab (content_key text primary key, topic text, exp_hash text) on commit drop;
insert into lab values
('apcalcbc-mcq-b4-h-4.1-a','4.1','ac55c55f88d318bcbe2dd4d607dfa7cd'),
('apcalcbc-mcq-b4-sv-h-4.1-a-v1','4.1','1bc7515acdff1766917d1e3be59f02a7'),
('apcalcbc-mcq-b4-sv-h-4.1-a-v2','4.1','c41f7a9577861a7ec2cb8d8bccba3690'),
('apcalcbc-mcq-b4-sv-h-4.1-a-v3','4.1','5b0874935fd3e66960cfb2c165f2212a'),
('apcalcbc-mcq-b4-h-4.1-b','4.1','8d901cb2cb59fec7c0ef3eec0e306b6f'),
('apcalcbc-mcq-b4-sv-h-4.1-b-v1','4.1','64c677fea0fb35464600b593376bcee3'),
('apcalcbc-mcq-b4-sv-h-4.1-b-v2','4.1','b4c922b027eb96f7be0c35fa4a97b495'),
('apcalcbc-mcq-b4-sv-h-4.1-b-v3','4.1','700319c374c5c56c4e9c4351127d4e9a'),
('apcalcbc-mcq-b4-h-4.2-a','4.2','31190806eeabb3cbbf8933afa36d86e2'),
('apcalcbc-mcq-b4-sv-h-4.2-a-v1','4.2','bc721af13ae99ae38a270bcec5522fa0'),
('apcalcbc-mcq-b4-sv-h-4.2-a-v2','4.2','e3c51ea3d2da9a4e1aa6306e65a78a0b'),
('apcalcbc-mcq-b4-sv-h-4.2-a-v3','4.2','04f1a1d7136db4d08673ae9fcf0f218b'),
('apcalcbc-mcq-b4-h-4.2-b','4.2','ff0d645380a1a09498d16bbd149753a2'),
('apcalcbc-mcq-b4-sv-h-4.2-b-v1','4.2','5b3692826767d37ac7b3cd106f8aa8bb'),
('apcalcbc-mcq-b4-sv-h-4.2-b-v2','4.2','a04fc0d5eead7456c09092f18d3f178a'),
('apcalcbc-mcq-b4-sv-h-4.2-b-v3','4.2','9ab47f626b78ec99aa51d9a9246badfc'),
('apcalcbc-mcq-b4-h-4.3-a','4.3','922b5d2f9d1330787cfd8e56fdb77039'),
('apcalcbc-mcq-b4-sv-h-4.3-a-v1','4.3','493f0d50a1cb81046be4c5ce228f73f9'),
('apcalcbc-mcq-b4-sv-h-4.3-a-v2','4.3','76ea6fd7ad67e941879f6091dcbbdae5'),
('apcalcbc-mcq-b4-sv-h-4.3-a-v3','4.3','51f14ac27c85f31c226fb16d6bb12b2c'),
('apcalcbc-mcq-b4-h-4.3-b','4.3','4b56a0909ae54d86744e5deb1fa41611'),
('apcalcbc-mcq-b4-sv-h-4.3-b-v1','4.3','279f37cc49659c1ae7bd7c272fcb370d'),
('apcalcbc-mcq-b4-sv-h-4.3-b-v2','4.3','b64a6ca3fbb590dc8bdfa243226708d9'),
('apcalcbc-mcq-b4-sv-h-4.3-b-v3','4.3','0d69f26cdaab1d8d2b14c0c9449f7c09'),
('apcalcbc-mcq-b4-h-4.4-a','4.4','399cdd8f37e3b240e5e6332b5aa2d109'),
('apcalcbc-mcq-b4-sv-h-4.4-a-v1','4.4','c7cd7b81e4d3c60470b736856c6017b1'),
('apcalcbc-mcq-b4-sv-h-4.4-a-v2','4.4','09158403314c7a9ca336f67173a74a1e'),
('apcalcbc-mcq-b4-sv-h-4.4-a-v3','4.4','ba3930528f24d95ff8358d061f749707'),
('apcalcbc-mcq-b4-h-4.4-b','4.4','21cab8817b957dd96097a083802c5fbf'),
('apcalcbc-mcq-b4-sv-h-4.4-b-v1','4.4','394658ba1b196df72562dceb9427c4ce'),
('apcalcbc-mcq-b4-sv-h-4.4-b-v2','4.4','739ebf89063c2f2998a9add700fe0453'),
('apcalcbc-mcq-b4-sv-h-4.4-b-v3','4.4','f2f7c67bde90ca579408391ce964f128'),
('apcalcbc-mcq-b4-h-4.5-a','4.5','e77a1e7b352a5eba1e8fc0623d61dca7'),
('apcalcbc-mcq-b4-sv-h-4.5-a-v1','4.5','5aa867abaa04ad9d2c2b0b7dd0914822'),
('apcalcbc-mcq-b4-sv-h-4.5-a-v2','4.5','eccac0ca2fe333d518dd4b48ea423288'),
('apcalcbc-mcq-b4-sv-h-4.5-a-v3','4.5','3ad175de2ec8ce1c6bb98aebf17e6ab4'),
('apcalcbc-mcq-b4-h-4.5-b','4.5','77b79623ec86a8727cdecc9c190de2bd'),
('apcalcbc-mcq-b4-sv-h-4.5-b-v1','4.5','fc00f51c589625163659ea4c4ec61c73'),
('apcalcbc-mcq-b4-sv-h-4.5-b-v2','4.5','faf72cddf82c423e3f7b56f7a8448f6a'),
('apcalcbc-mcq-b4-sv-h-4.5-b-v3','4.5','79efe530be8c6efa6a2a8d99707e7c02'),
('apcalcbc-mcq-b4-h-4.6-a','4.6','976e24f40f4df64ac917cfde33fe3a85'),
('apcalcbc-mcq-b4-sv-h-4.6-a-v1','4.6','31ec650cfffded5d7cfd61bc1eadf643'),
('apcalcbc-mcq-b4-sv-h-4.6-a-v2','4.6','94ce545bd277141414cc8343e68840fc'),
('apcalcbc-mcq-b4-sv-h-4.6-a-v3','4.6','1aaf51ba1ded6162a9384a63b481f0f1'),
('apcalcbc-mcq-b4-h-4.6-b','4.6','8c32f6942896050bbfda358221bbc505'),
('apcalcbc-mcq-b4-sv-h-4.6-b-v1','4.6','96df1c078c95a4a35a82e83455149b50'),
('apcalcbc-mcq-b4-sv-h-4.6-b-v2','4.6','6c317cebe1873f2176bacf7f0bfd402f'),
('apcalcbc-mcq-b4-sv-h-4.6-b-v3','4.6','bac83c981cebd7eb66b99cb71f2b76e4'),
('apcalcbc-mcq-b4-h-4.7-a','4.7','ffb14e01e3475b15c9d80dd9c9a94cbe'),
('apcalcbc-mcq-b4-sv-h-4.7-a-v1','4.7','a637d45d5e0418427b4e44d18557a917'),
('apcalcbc-mcq-b4-sv-h-4.7-a-v2','4.7','b0330aa765ef46e7ef7f8792303b9ed2'),
('apcalcbc-mcq-b4-sv-h-4.7-a-v3','4.7','c1e5cd1d1eee77b9f98264f5af52eccb'),
('apcalcbc-mcq-b4-h-4.7-b','4.7','932020c0a50667557a6a6ac395f998bf'),
('apcalcbc-mcq-b4-sv-h-4.7-b-v1','4.7','4ebcc9572a0c1f4ae2bb4cb08414bbf9'),
('apcalcbc-mcq-b4-sv-h-4.7-b-v2','4.7','9bf429d2b3b9d0bd3c6a5760e465a1a6'),
('apcalcbc-mcq-b4-sv-h-4.7-b-v3','4.7','61b13bbfa9138490a3ac9e9367f1f868');
create temporary table tgt on commit drop as
select l.*, ci.id item_id, civ.id version_id, gen_random_uuid() assignment_id, gen_random_uuid() label_id, gen_random_uuid() vd_id,
 'ab088009-dc9a-4f93-8824-803e1913505b'::uuid tsv, (case topic when '4.1' then array[2, 4] when '4.2' then array[2, 4] when '4.3' then array[2, 4] when '4.4' then array[3, 4] when '4.5' then array[3, 4] when '4.6' then array[2, 4] when '4.7' then array[1, 4] end)::int[] req, 4 pu
from lab l join app.content_items ci on ci.content_key=l.content_key and ci.exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27'
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
 'AP Calculus BC Unit 3 harder seeds and variants (batch apcalcbc_u4_2026_11_12): Product Owner review of owner-session-authored drafts, 2026-11-12. Arithmetic verified in Python; no model-checker pass, by Product Owner decision.',
 'approve',
 jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apcalcbc_u4_2026_11_12_po_approval','qa_date','2026-11-12','content_key',content_key),
 md5(jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apcalcbc_u4_2026_11_12_po_approval','qa_date','2026-11-12','content_key',content_key)::text),
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
 'apcalcbc_u4_2026_11_12',
 jsonb_build_object('origin','owner_authored','units_source','AP Calculus BC Unit 4 (topics 4.x belong to unit 3; required_units set per topic from existing Unit 3 labels)','topic',topic,'report','scripts/content-seed/apchem-harder-seeds-u3-2026-11-12'),
 'apcalcbc-u4-2026-11-12-labeling', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
insert into app.content_taxonomy_validation_decisions (validation_decision_id, content_taxonomy_label_id, decided_by, decision, decision_source, reviewed_primary_unit, reviewed_required_units, notes)
select vd_id, label_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'confirmed', 'chat_review', pu, req,
 'Product Owner chat instruction 2026-11-12 (AP Calculus BC harder seeds and variants). Topic assigned by the author from the question design (topic recorded on the cell); topic-only tagging, skill left null.' from tgt;
insert into app.content_item_cells (content_item_version_id, content_item_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id, validated_by, validated_at, validation_decision_id)
select version_id, item_id, tsv, topic, null, true, 'validated', 'apcalcbc_u4_2026_11_12_topic',
 'apcalcbc-u4-2026-11-12-labeling (topic set by the author from the question design)', null, now(), gen_random_uuid() from tgt;
update app.content_taxonomy_labels l set label_status='validated', validated_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, validated_at=now(), validation_decision_id=t.vd_id, validated_against_version_id=t.version_id, validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id) from tgt t where l.content_taxonomy_label_id=t.label_id;
update app.content_item_versions civ set status='published', published_at=coalesce(civ.published_at,now()), updated_at=now() from tgt where civ.id=tgt.version_id;
update app.content_items ci set status='published', updated_at=now() from tgt where ci.id=tgt.item_id;
do $$ declare n int; begin
  select count(*) into n from (select content_item_id from app.content_item_versions where status='published' group by 1 having count(*)>1) d; if n<>0 then raise exception 'duplicate published versions: %', n; end if;
  if (select count(*) from app.content_items ci join tgt on tgt.item_id=ci.id where ci.status='published')<>56 then raise exception 'publish count mismatch'; end if;
  select count(*) into n from app.content_taxonomy_labels l join tgt t on t.item_id=l.content_item_id where l.label_scope='serving' and l.superseded_by is null and l.label_status='validated' and l.validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id); if n<>56 then raise exception 'label post-check %', n; end if;
  select count(*) into n from app.content_item_cells where source='apcalcbc_u4_2026_11_12_topic' and is_primary and superseded_by is null; if n<>56 then raise exception 'topic cell count %', n; end if;
end $$;
select (select count(*) from tgt) published, (select count(*) from app.content_taxonomy_labels where source='apcalcbc_u4_2026_11_12' and label_status='validated') validated_labels, (select count(*) from app.content_item_cells where source='apcalcbc_u4_2026_11_12_topic') topic_cells;
commit;
