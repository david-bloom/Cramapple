begin;
select pg_advisory_xact_lock(hashtext('cramapple-apbio-u2-2026-11-12-publish-20261112'));
create temporary table lab (content_key text primary key, topic text, exp_hash text) on commit drop;
insert into lab values
('apbio-mcq-b5-h-2.1-a','2.1','493465223b77ca575060d813a02a86e9'),
('apbio-mcq-b5-sv-h-2.1-a-v1','2.1','b06b41f62dc1b3f3c67c6b8ca14f18dd'),
('apbio-mcq-b5-sv-h-2.1-a-v2','2.1','2e3c6c7564e90d601e971d1008fc4aaf'),
('apbio-mcq-b5-sv-h-2.1-a-v3','2.1','4704b2e8266a8a230463e7bb37f610bb'),
('apbio-mcq-b5-h-2.1-b','2.1','622987a69b7a18ae5be824b0b6e879a3'),
('apbio-mcq-b5-sv-h-2.1-b-v1','2.1','c4c63bc79afedd054687afa886bd8399'),
('apbio-mcq-b5-sv-h-2.1-b-v2','2.1','f1df02829bb9c3d27e867e7a050584a0'),
('apbio-mcq-b5-sv-h-2.1-b-v3','2.1','61cf41d49ac6b2a78b921386f416776b'),
('apbio-mcq-b5-h-2.2-a','2.2','381f6238d4b5b0afbcb640650621e413'),
('apbio-mcq-b5-sv-h-2.2-a-v1','2.2','c9b3fd21f57c5f0b61bc4757aed09e24'),
('apbio-mcq-b5-sv-h-2.2-a-v2','2.2','919f9e3bdf1b2c64a1580f6d52d55adc'),
('apbio-mcq-b5-sv-h-2.2-a-v3','2.2','1d62bdf0d2e982a68dfe37d18bbdc6ba'),
('apbio-mcq-b5-h-2.2-b','2.2','f0f6673fde1fed51a6ff35af2cf9a641'),
('apbio-mcq-b5-sv-h-2.2-b-v1','2.2','e61b48f47958e494c4e225333e28578a'),
('apbio-mcq-b5-sv-h-2.2-b-v2','2.2','03cd5d937b5971a37a99ef46b3abd04c'),
('apbio-mcq-b5-sv-h-2.2-b-v3','2.2','95c0ea51e0c2f03ff757ec8d2816c65c'),
('apbio-mcq-b5-h-2.3-a','2.3','7679addc732e36640099158385536e8c'),
('apbio-mcq-b5-sv-h-2.3-a-v1','2.3','c97180a0849c2278e840b985d3eb3f62'),
('apbio-mcq-b5-sv-h-2.3-a-v2','2.3','ed84e8c600c64c4b51639dccebd53bd0'),
('apbio-mcq-b5-sv-h-2.3-a-v3','2.3','0297576f2c355bffe9768dea0d75ac0c'),
('apbio-mcq-b5-h-2.3-b','2.3','28988f4e8cc59a4eb18df662b568667f'),
('apbio-mcq-b5-sv-h-2.3-b-v1','2.3','44551d595a0fed40e13cb37f77c45bf8'),
('apbio-mcq-b5-sv-h-2.3-b-v2','2.3','d310f42a0ea9693cb580d138ac71623b'),
('apbio-mcq-b5-sv-h-2.3-b-v3','2.3','551088bdafd08e9a0ccf736c782cb531'),
('apbio-mcq-b5-h-2.4-a','2.4','20aa8a74a4a86afa2172fdabaca95c8e'),
('apbio-mcq-b5-sv-h-2.4-a-v1','2.4','9178e86dab2511a123a4dce4066b926c'),
('apbio-mcq-b5-sv-h-2.4-a-v2','2.4','cf1f55455ed4d0b57c429e1329ded445'),
('apbio-mcq-b5-sv-h-2.4-a-v3','2.4','2b23a70a76afcdf0c8611d82cb666e49'),
('apbio-mcq-b5-h-2.4-b','2.4','041c5b538d914d162c1b1be830ca9840'),
('apbio-mcq-b5-sv-h-2.4-b-v1','2.4','49b8d93e1c6a8d58bed3a45a19b16df3'),
('apbio-mcq-b5-sv-h-2.4-b-v2','2.4','37195884c38a7a1e86d91eb97e4d2c54'),
('apbio-mcq-b5-sv-h-2.4-b-v3','2.4','fdcee209c17dcdc1a0b84e3cd5e736b4'),
('apbio-mcq-b5-h-2.5-a','2.5','b2f9eb6525ccd0295c450c2427793539'),
('apbio-mcq-b5-sv-h-2.5-a-v1','2.5','9947f5b83ed231f2833b2095ab773d02'),
('apbio-mcq-b5-sv-h-2.5-a-v2','2.5','4c3d8d8561778802183cf1a6eafd2fa2'),
('apbio-mcq-b5-sv-h-2.5-a-v3','2.5','d68d17ee92ae3ff8e159eaf242000fa5'),
('apbio-mcq-b5-h-2.5-b','2.5','4b0681b00f41f4b7421ffb8732cb5b7c'),
('apbio-mcq-b5-sv-h-2.5-b-v1','2.5','f8cc23c2d283bcfeec1f8c9be702576a'),
('apbio-mcq-b5-sv-h-2.5-b-v2','2.5','7fd118b416a3f3a4b683a0cb9211952f'),
('apbio-mcq-b5-sv-h-2.5-b-v3','2.5','3e6a1d8faf925415aa97bc3b528d932c'),
('apbio-mcq-b5-h-2.6-a','2.6','c30d03a7f6a4af649e79076c5216ed0d'),
('apbio-mcq-b5-sv-h-2.6-a-v1','2.6','b37e17a9594639e12bcc7fb38151e935'),
('apbio-mcq-b5-sv-h-2.6-a-v2','2.6','a501e6883d0d318a5ae942a8bdcbfb3a'),
('apbio-mcq-b5-sv-h-2.6-a-v3','2.6','5d8c8d1913353a67e4ec50a1a6aafd56'),
('apbio-mcq-b5-h-2.6-b','2.6','b850a44d32ba551836489ee24c1bbece'),
('apbio-mcq-b5-sv-h-2.6-b-v1','2.6','c70301d1915873a816d0a9ebb6599639'),
('apbio-mcq-b5-sv-h-2.6-b-v2','2.6','969d6588cd865ecb33841227eab8880d'),
('apbio-mcq-b5-sv-h-2.6-b-v3','2.6','20e5423bd1678bdbc8a14368458f28f5'),
('apbio-mcq-b5-h-2.7-a','2.7','fb090c171f5b28907cdcac4d8bf27e83'),
('apbio-mcq-b5-sv-h-2.7-a-v1','2.7','3679aebc58e8cff8449e0b08c0c034f5'),
('apbio-mcq-b5-sv-h-2.7-a-v2','2.7','9319553dc344b60c22fb8be86a0f5e99'),
('apbio-mcq-b5-sv-h-2.7-a-v3','2.7','ea8e288da6bcc5b9e79197c1efdffacc'),
('apbio-mcq-b5-h-2.7-b','2.7','6585cf36c96252ac193d092a06bec0b2'),
('apbio-mcq-b5-sv-h-2.7-b-v1','2.7','79fb04f9fdfea54ab629739413e7d2ea'),
('apbio-mcq-b5-sv-h-2.7-b-v2','2.7','5ccf84dae11b9f6b749b74e47ba0806d'),
('apbio-mcq-b5-sv-h-2.7-b-v3','2.7','070ad84b7fb641674fc78d75a5f91225'),
('apbio-mcq-b5-h-2.8-a','2.8','8503a5be9874442fb23310219e0c7a81'),
('apbio-mcq-b5-sv-h-2.8-a-v1','2.8','704dc4eb67f928c9c1b5948a96506fce'),
('apbio-mcq-b5-sv-h-2.8-a-v2','2.8','7f9e0648a4c3ef44c6f97b2fd33c0c67'),
('apbio-mcq-b5-sv-h-2.8-a-v3','2.8','0c14d7561481058e3aa59d7fe4ca6cb1'),
('apbio-mcq-b5-h-2.8-b','2.8','ae3a528dd943f82ed4828605a176ec7e'),
('apbio-mcq-b5-sv-h-2.8-b-v1','2.8','3d7477ced34d04e1530ee008dea4ab9b'),
('apbio-mcq-b5-sv-h-2.8-b-v2','2.8','23db55ff50b9bf3f7e45c2d9cce1c000'),
('apbio-mcq-b5-sv-h-2.8-b-v3','2.8','60a5bd2a6a5178fdd199b60215f08fa3'),
('apbio-mcq-b5-h-2.9-a','2.9','45b57dafa65a7f8e9df8464731d86ad1'),
('apbio-mcq-b5-sv-h-2.9-a-v1','2.9','c9144587b62a79909629a698f5f7aa81'),
('apbio-mcq-b5-sv-h-2.9-a-v2','2.9','3bce9fd9aa373b7f8388568b76804373'),
('apbio-mcq-b5-sv-h-2.9-a-v3','2.9','3db49656fe9d4d1fec64a46c2489a8ed'),
('apbio-mcq-b5-h-2.9-b','2.9','84126cdf547d03a7bfab43f2e8993b4d'),
('apbio-mcq-b5-sv-h-2.9-b-v1','2.9','2da1875ed96c38ffb36288bb6e93cfac'),
('apbio-mcq-b5-sv-h-2.9-b-v2','2.9','aa494e96ababf554e670114c5eb01bb8'),
('apbio-mcq-b5-sv-h-2.9-b-v3','2.9','924fbcfb506f8b7f4ac9d01e5e356b3e'),
('apbio-mcq-b5-h-2.10-a','2.10','1a0f266c8bec553388ce0b6d7918c45d'),
('apbio-mcq-b5-sv-h-2.10-a-v1','2.10','5c9aa0998595ed67ef0c8dd73bc7e70d'),
('apbio-mcq-b5-sv-h-2.10-a-v2','2.10','6f2d13b238e4816e182aa3dfdd37cc00'),
('apbio-mcq-b5-sv-h-2.10-a-v3','2.10','51bba287f951504f3fac9d1bda46ea64'),
('apbio-mcq-b5-h-2.10-b','2.10','9981b39d59b40cb059c44b5419c19843'),
('apbio-mcq-b5-sv-h-2.10-b-v1','2.10','46619882df16b8847968e6d4a1bdccf0'),
('apbio-mcq-b5-sv-h-2.10-b-v2','2.10','46b0731fe4aae8b266a40f9ff5815ce4'),
('apbio-mcq-b5-sv-h-2.10-b-v3','2.10','9ba45aaf4557169eb8a1799a67cc2a65');
create temporary table tgt on commit drop as
select l.*, ci.id item_id, civ.id version_id, gen_random_uuid() assignment_id, gen_random_uuid() label_id, gen_random_uuid() vd_id,
 'c676d1fc-3b58-4896-89e3-852d9bd1f81b'::uuid tsv, (case topic when '2.1' then array[2] when '2.10' then array[2] when '2.2' then array[2] when '2.3' then array[2] when '2.4' then array[2] when '2.5' then array[2] when '2.6' then array[2] when '2.7' then array[2] when '2.8' then array[2] when '2.9' then array[2] end)::int[] req, 2 pu
from lab l join app.content_items ci on ci.content_key=l.content_key and ci.exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7'
join app.content_item_versions civ on civ.content_item_id=ci.id and civ.version_num=1
where ci.status='draft' and civ.status='draft';
do $$ begin
 if (select count(*) from tgt)<>80 then raise exception 'expected 80 draft targets, got %', (select count(*) from tgt); end if;
 if exists (select 1 from tgt where split_part(topic,'.',1)::int<>pu) then raise exception 'topic/unit mismatch'; end if;
 if exists (select 1 from tgt t join app.content_item_cells c on c.content_item_version_id=t.version_id) or exists (select 1 from tgt t join app.content_taxonomy_labels l on l.content_item_id=t.item_id) then raise exception 'a target already has cells or labels'; end if;
 if (select count(*) from (select t.content_key from tgt t join app.content_item_versions civ on civ.id=t.version_id join app.mcq_choices c on c.content_item_version_id=civ.id group by t.content_key, civ.stem, t.exp_hash having md5(civ.stem||'|'||string_agg(c.choice_key||':'||c.choice_text||':'||c.is_correct::text||':'||c.rationale,'|' order by c.choice_key))=t.exp_hash) z)<>80 then raise exception 'loaded text does not match the build manifest'; end if;
 if exists (select 1 from tgt t where not exists (select 1 from app.taxonomy_topics tt where tt.taxonomy_source_version=t.tsv and tt.topic_code=t.topic)) then raise exception 'a topic code is not present in the taxonomy source version'; end if;
end $$;
insert into app.content_review_assignments (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, review_kind, status, assignment_purpose, created_by)
select assignment_id, version_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'tutor_question', 'mcq', 'pending', 'owner_remediation_approval', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
insert into app.content_review_decisions (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, tutor_score, difficulty_label, diagnostic_flag, concern_codes, note, tutor_decision, decision_payload, decision_hash, created_by)
select assignment_id, version_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'tutor_question', 1, null, false, array[]::text[],
 'AP Biology Unit 3 harder seeds and variants (batch apbio_u2_2026_11_12): Product Owner review of owner-session-authored drafts, 2026-11-12. Arithmetic verified in Python; no model-checker pass, by Product Owner decision.',
 'approve',
 jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apbio_u2_2026_11_12_po_approval','qa_date','2026-11-12','content_key',content_key),
 md5(jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apbio_u2_2026_11_12_po_approval','qa_date','2026-11-12','content_key',content_key)::text),
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
 'apbio_u2_2026_11_12',
 jsonb_build_object('origin','owner_authored','units_source','AP Biology Unit 2 (topics 2.x belong to unit 3; required_units set per topic from existing Unit 3 labels)','topic',topic,'report','scripts/content-seed/apchem-harder-seeds-u3-2026-11-12'),
 'apbio-u2-2026-11-12-labeling', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
insert into app.content_taxonomy_validation_decisions (validation_decision_id, content_taxonomy_label_id, decided_by, decision, decision_source, reviewed_primary_unit, reviewed_required_units, notes)
select vd_id, label_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'confirmed', 'chat_review', pu, req,
 'Product Owner chat instruction 2026-11-12 (AP Biology harder seeds and variants). Topic assigned by the author from the question design (topic recorded on the cell); topic-only tagging, skill left null.' from tgt;
insert into app.content_item_cells (content_item_version_id, content_item_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id, validated_by, validated_at, validation_decision_id)
select version_id, item_id, tsv, topic, null, true, 'validated', 'apbio_u2_2026_11_12_topic',
 'apbio-u2-2026-11-12-labeling (topic set by the author from the question design)', null, now(), gen_random_uuid() from tgt;
update app.content_taxonomy_labels l set label_status='validated', validated_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, validated_at=now(), validation_decision_id=t.vd_id, validated_against_version_id=t.version_id, validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id) from tgt t where l.content_taxonomy_label_id=t.label_id;
update app.content_item_versions civ set status='published', published_at=coalesce(civ.published_at,now()), updated_at=now() from tgt where civ.id=tgt.version_id;
update app.content_items ci set status='published', updated_at=now() from tgt where ci.id=tgt.item_id;
do $$ declare n int; begin
  select count(*) into n from (select content_item_id from app.content_item_versions where status='published' group by 1 having count(*)>1) d; if n<>0 then raise exception 'duplicate published versions: %', n; end if;
  if (select count(*) from app.content_items ci join tgt on tgt.item_id=ci.id where ci.status='published')<>80 then raise exception 'publish count mismatch'; end if;
  select count(*) into n from app.content_taxonomy_labels l join tgt t on t.item_id=l.content_item_id where l.label_scope='serving' and l.superseded_by is null and l.label_status='validated' and l.validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id); if n<>80 then raise exception 'label post-check %', n; end if;
  select count(*) into n from app.content_item_cells where source='apbio_u2_2026_11_12_topic' and is_primary and superseded_by is null; if n<>80 then raise exception 'topic cell count %', n; end if;
end $$;
select (select count(*) from tgt) published, (select count(*) from app.content_taxonomy_labels where source='apbio_u2_2026_11_12' and label_status='validated') validated_labels, (select count(*) from app.content_item_cells where source='apbio_u2_2026_11_12_topic') topic_cells;
commit;
