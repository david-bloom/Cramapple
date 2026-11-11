begin;
select pg_advisory_xact_lock(hashtext('cramapple-apstats-u3-harder-publish-20261111'));
create temporary table lab (content_key text primary key, topic text, exp_hash text) on commit drop;
insert into lab values
('APSTATS-MCQ-H-3.1-A','3.1','5844497e655b384f37480137be5ac21c'),
('APSTATS-MCQ-H-3.2-A','3.2','0de579e9ea7ece09c62d2037dfd8abbe'),
('APSTATS-MCQ-H-3.3-A','3.3','6dfbdf772736fd21ce95b857d5ba8728'),
('APSTATS-MCQ-H-3.3-B','3.3','5ee1cafcda1e1b9c6d5c5c9d3b2f9cde'),
('APSTATS-MCQ-H-3.4-B','3.4','f72ce847898cf0a67cf951e6d680e5c4'),
('APSTATS-MCQ-H-3.5-A','3.5','16cbdac025688702419f63ef1a4eb135'),
('APSTATS-MCQ-H-3.6-A','3.6','6ea4d4d8619d528dc4402232b67b8a26'),
('APSTATS-MCQ-H-3.6-B','3.6','3ff46eeb82a3fa7b96360c9276d4376c'),
('APSTATS-MCQ-H-3.7-A','3.7','9c7b43fbeb9bb717858395f72f62ac14'),
('APSTATS-MCQ-H-3.8-A','3.8','fe2cc075c1d0d58ff62e11bc0c604779'),
('APSTATS-MCQ-H-3.8-B','3.8','2b23b0e6312bea5284cc5a119e73e989'),
('APSTATS-MCQ-H-3.8-C','3.8','c26983bde191d69d342e4b034051f4ea'),
('APSTATS-MCQ-H-3.9-A','3.9','eb7dc970b58651de56b9a701f6edfedf'),
('APSTATS-MCQ-H-3.10-A','3.10','c3f35630f37eb8bc0b8d35eddb7ba228'),
('APSTATS-MCQ-H-3.11-A','3.11','bf347479b6671899624b4074d24895da'),
('APSTATS-MCQ-H-3.12-A','3.12','815df98aaf5e58414b65427e5c634237'),
('APSTATS-MCQ-H-3.13-A','3.13','f53d04ed47bd50e3c82c3efccd039e36'),
('APSTATS-MCQ-H-3.14-A','3.14','753a81f2c3beb3362412a0660a6880be'),
('APSTATS-MCQ-H-3.15-A','3.15','c4fbbd07a614d682f348afd0006ea053'),
('APSTATS-MCQ-SV-H-3.1-A-v1','3.1','3053a6a71e1f87a47fc4974c0bb6d5eb'),
('APSTATS-MCQ-SV-H-3.1-A-v2','3.1','8df79c7f1346e7d409bba18d60978e45'),
('APSTATS-MCQ-SV-H-3.1-A-v3','3.1','b5578804aa52932072f84de0f888ebc5'),
('APSTATS-MCQ-SV-H-3.2-A-v1','3.2','e319c1f76ce49cdea2e0fdfd5ec611d3'),
('APSTATS-MCQ-SV-H-3.2-A-v2','3.2','972bb92fab107e1579a316932a8cf754'),
('APSTATS-MCQ-SV-H-3.2-A-v3','3.2','010270c8be5dab013d5542f7efd1393a'),
('APSTATS-MCQ-SV-H-3.3-A-v1','3.3','b43373fc94854a29513a1a26450d5029'),
('APSTATS-MCQ-SV-H-3.3-A-v2','3.3','47e8e6025e9479b326e85aa28030d814'),
('APSTATS-MCQ-SV-H-3.3-A-v3','3.3','3fb3136de056cc7a6c4d7a58e9f6873b'),
('APSTATS-MCQ-SV-H-3.3-B-v1','3.3','9def98d91d11c6884cb1c3c009f22a0e'),
('APSTATS-MCQ-SV-H-3.3-B-v2','3.3','74d07fd1a4b83ee55d5830b9d7d44398'),
('APSTATS-MCQ-SV-H-3.3-B-v3','3.3','2cb2f1a45ffede08d6a1117fe884f9ef'),
('APSTATS-MCQ-SV-H-3.4-B-v1','3.4','3c599f99f3ff2934fef84604e719a5d0'),
('APSTATS-MCQ-SV-H-3.4-B-v2','3.4','2addf04ef0b9b1147e00ba7f339c72ee'),
('APSTATS-MCQ-SV-H-3.4-B-v3','3.4','74b7a734f7dda0c982b91d3dcfc8f5f4'),
('APSTATS-MCQ-SV-H-3.5-A-v1','3.5','62225af0cb750a8657df15892b0e13e5'),
('APSTATS-MCQ-SV-H-3.5-A-v2','3.5','73071e763bd3846d9d9e411b8c519da1'),
('APSTATS-MCQ-SV-H-3.5-A-v3','3.5','da59ae461dfb67704bda11d7bdaee1c9'),
('APSTATS-MCQ-SV-H-3.6-A-v1','3.6','f2f532bb56f3fbaf571ed88fd955e643'),
('APSTATS-MCQ-SV-H-3.6-A-v2','3.6','d9d350247e6e5c42870895546293f02b'),
('APSTATS-MCQ-SV-H-3.6-A-v3','3.6','19d184c464050102636c5d6bf6b553a3'),
('APSTATS-MCQ-SV-H-3.6-B-v1','3.6','d0c4a4fe568be8a80617a6b14e29d6e9'),
('APSTATS-MCQ-SV-H-3.6-B-v2','3.6','fa507ad021b8fe46deb89fab6cd95c45'),
('APSTATS-MCQ-SV-H-3.6-B-v3','3.6','8f2bd8cd07f2745e2c4e670564ad0382'),
('APSTATS-MCQ-SV-H-3.7-A-v1','3.7','2a3704543c8575fed0e01c98cbeb55b3'),
('APSTATS-MCQ-SV-H-3.7-A-v2','3.7','c9e3523d5be1c4dc47894ad20dc087f2'),
('APSTATS-MCQ-SV-H-3.7-A-v3','3.7','15de57b7bc43b083c89f859317068e84'),
('APSTATS-MCQ-SV-H-3.8-A-v1','3.8','54c2b47967aef5c4d62843161a247541'),
('APSTATS-MCQ-SV-H-3.8-A-v2','3.8','4b3113c6212f350c5a975566f9e37282'),
('APSTATS-MCQ-SV-H-3.8-A-v3','3.8','e27a8fe2133d034d2c7909d1c8151b0f'),
('APSTATS-MCQ-SV-H-3.8-B-v1','3.8','ed41430a069bdb6c13c60a9f4ccdccf9'),
('APSTATS-MCQ-SV-H-3.8-B-v2','3.8','50a12b7170a68018542040f60d035d1e'),
('APSTATS-MCQ-SV-H-3.8-B-v3','3.8','9ef89dee681b8a073a9684d7308460ed'),
('APSTATS-MCQ-SV-H-3.8-C-v1','3.8','2f31278744481c69dc4faa5d964b2fcf'),
('APSTATS-MCQ-SV-H-3.8-C-v2','3.8','f660eabb1228c43c40562b71e1dc604b'),
('APSTATS-MCQ-SV-H-3.8-C-v3','3.8','8c09932b8fdc09345ca9319d9370ca53'),
('APSTATS-MCQ-SV-H-3.9-A-v1','3.9','93ed690cf892b0cbc71389bee5436d7c'),
('APSTATS-MCQ-SV-H-3.9-A-v2','3.9','30aeba91f035f7afdfb426db1e9e0c8c'),
('APSTATS-MCQ-SV-H-3.9-A-v3','3.9','527953c1c0677aea8561531fe5cbd3ee'),
('APSTATS-MCQ-SV-H-3.10-A-v1','3.10','836184e5454e8a682f1645c8897cfbdc'),
('APSTATS-MCQ-SV-H-3.10-A-v2','3.10','0d0503cbaea4e685299b255df19a6c13'),
('APSTATS-MCQ-SV-H-3.10-A-v3','3.10','ccd9b9213cf3daff6af5280d06b5fb12'),
('APSTATS-MCQ-SV-H-3.11-A-v1','3.11','44f758e31e23eda05a3a0675807d8ce1'),
('APSTATS-MCQ-SV-H-3.11-A-v2','3.11','4df52fbee14da1a031cab476284045a4'),
('APSTATS-MCQ-SV-H-3.11-A-v3','3.11','edc6e04f766d86a4846d2af27c3376f3'),
('APSTATS-MCQ-SV-H-3.12-A-v1','3.12','3f424fc891e2fa4be032dbd56dc65b5a'),
('APSTATS-MCQ-SV-H-3.12-A-v2','3.12','dfed53161c2e04b516c806b5bb539753'),
('APSTATS-MCQ-SV-H-3.12-A-v3','3.12','d4373659693f397f745320dc85c24551'),
('APSTATS-MCQ-SV-H-3.13-A-v1','3.13','2323123c3e668f10dfd5fd5ace17e39e'),
('APSTATS-MCQ-SV-H-3.13-A-v2','3.13','83102ed62ef3efcf3fb5654e787b0ec9'),
('APSTATS-MCQ-SV-H-3.13-A-v3','3.13','01bd37b2d0dfa335274ac4c0f4103162'),
('APSTATS-MCQ-SV-H-3.14-A-v1','3.14','d4994c345cbfa4c99bb30a00886f5eee'),
('APSTATS-MCQ-SV-H-3.14-A-v2','3.14','664c6f13fb548904d950e5064c34d353'),
('APSTATS-MCQ-SV-H-3.14-A-v3','3.14','b2cfc3ea50e68b3cda4d150800a4aede'),
('APSTATS-MCQ-SV-H-3.15-A-v1','3.15','41b16a9c690981ff81aec5133548a194'),
('APSTATS-MCQ-SV-H-3.15-A-v2','3.15','d5a6b8441d31a0f894c14cdf0c4931b8'),
('APSTATS-MCQ-SV-H-3.15-A-v3','3.15','3b3ffde40643cb2714a392da5f774a9a');
create temporary table tgt on commit drop as
select l.*, ci.id item_id, civ.id version_id, gen_random_uuid() assignment_id, gen_random_uuid() label_id, gen_random_uuid() vd_id,
 'dae3c72e-82ca-4960-9552-1b034bd347e5'::uuid tsv, array[3]::int[] req, 3 pu
from lab l join app.content_items ci on ci.content_key=l.content_key and ci.exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438'
join app.content_item_versions civ on civ.content_item_id=ci.id and civ.version_num=1
where ci.status='draft' and civ.status='draft';
do $$ begin
 if (select count(*) from tgt)<>76 then raise exception 'expected 76 draft targets, got %', (select count(*) from tgt); end if;
 if exists (select 1 from tgt where split_part(topic,'.',1)::int<>pu) then raise exception 'topic/unit mismatch'; end if;
 if exists (select 1 from tgt t join app.content_item_cells c on c.content_item_version_id=t.version_id) or exists (select 1 from tgt t join app.content_taxonomy_labels l on l.content_item_id=t.item_id) then raise exception 'a target already has cells or labels'; end if;
 if (select count(*) from (select t.content_key from tgt t join app.content_item_versions civ on civ.id=t.version_id join app.mcq_choices c on c.content_item_version_id=civ.id group by t.content_key, civ.stem, t.exp_hash having md5(civ.stem||'|'||string_agg(c.choice_key||':'||c.choice_text||':'||c.is_correct::text||':'||c.rationale,'|' order by c.choice_key))=t.exp_hash) z)<>76 then raise exception 'loaded text does not match the build manifest'; end if;
 if exists (select 1 from tgt t where not exists (select 1 from app.content_item_cells c join app.content_items ci2 on ci2.id=c.content_item_id where ci2.exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and c.topic_code=t.topic and c.taxonomy_source_version=t.tsv and c.superseded_by is null)) then raise exception 'a topic code is not present in the Statistics taxonomy source version'; end if;
end $$;
insert into app.content_review_assignments (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, review_kind, status, assignment_purpose, created_by)
select assignment_id, version_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'tutor_question', 'mcq', 'pending', 'owner_remediation_approval', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
insert into app.content_review_decisions (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, tutor_score, difficulty_label, diagnostic_flag, concern_codes, note, tutor_decision, decision_payload, decision_hash, created_by)
select assignment_id, version_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'tutor_question', 1, null, false, array[]::text[],
 'AP Statistics Unit 3 harder seeds and variants (topics 3.1 to 3.15): Product Owner review of owner-session-authored drafts, 2026-11-11. Arithmetic verified in Python; no model-checker pass, by Product Owner decision.',
 'approve',
 jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apstats_u3_harder_po_approval','qa_date','2026-11-11','content_key',content_key),
 md5(jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apstats_u3_harder_po_approval','qa_date','2026-11-11','content_key',content_key)::text),
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
 'apstats_u3_harder_2026_11_11',
 jsonb_build_object('origin','owner_authored','units_source','Statistics Unit 3 (all topics 3.x belong to unit 3; existing Unit 3 serving labels use required_units [3], primary_unit 3)','topic',topic,'report','scripts/content-seed/ap-statistics-unit3-harder-seeds-2026-11-11'),
 'apstats-u3-harder-labeling-2026-11-11', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
insert into app.content_taxonomy_validation_decisions (validation_decision_id, content_taxonomy_label_id, decided_by, decision, decision_source, reviewed_primary_unit, reviewed_required_units, notes)
select vd_id, label_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'confirmed', 'chat_review', pu, req,
 'Product Owner chat instruction 2026-11-11 (AP Statistics Unit 3 harder seeds and variants). Topic assigned by the author from the question design (topic recorded on the cell); topic-only tagging, skill left null.' from tgt;
insert into app.content_item_cells (content_item_version_id, content_item_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id, validated_by, validated_at, validation_decision_id)
select version_id, item_id, tsv, topic, null, true, 'validated', 'apstats_u3_harder_topic_2026_11_11',
 'apstats-u3-harder-labeling-2026-11-11 (topic set by the author from the question design)', null, now(), gen_random_uuid() from tgt;
update app.content_taxonomy_labels l set label_status='validated', validated_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, validated_at=now(), validation_decision_id=t.vd_id, validated_against_version_id=t.version_id, validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id) from tgt t where l.content_taxonomy_label_id=t.label_id;
update app.content_item_versions civ set status='published', published_at=coalesce(civ.published_at,now()), updated_at=now() from tgt where civ.id=tgt.version_id;
update app.content_items ci set status='published', updated_at=now() from tgt where ci.id=tgt.item_id;
do $$ declare n int; begin
  select count(*) into n from (select content_item_id from app.content_item_versions where status='published' group by 1 having count(*)>1) d; if n<>0 then raise exception 'duplicate published versions: %', n; end if;
  if (select count(*) from app.content_items ci join tgt on tgt.item_id=ci.id where ci.status='published')<>76 then raise exception 'publish count mismatch'; end if;
  select count(*) into n from app.content_taxonomy_labels l join tgt t on t.item_id=l.content_item_id where l.label_scope='serving' and l.superseded_by is null and l.label_status='validated' and l.validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id); if n<>76 then raise exception 'label post-check %', n; end if;
  select count(*) into n from app.content_item_cells where source='apstats_u3_harder_topic_2026_11_11' and is_primary and superseded_by is null; if n<>76 then raise exception 'topic cell count %', n; end if;
end $$;
do $$ begin raise exception 'REHEARSAL OK (rolled back): published=%, validated_labels=%, topic_cells=%', (select count(*) from tgt), (select count(*) from app.content_taxonomy_labels where source='apstats_u3_harder_2026_11_11' and label_status='validated'), (select count(*) from app.content_item_cells where source='apstats_u3_harder_topic_2026_11_11'); end $$;
rollback;
