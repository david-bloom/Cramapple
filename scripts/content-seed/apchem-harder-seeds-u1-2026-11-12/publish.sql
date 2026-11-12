begin;
select pg_advisory_xact_lock(hashtext('cramapple-apchem-u1-2026-11-12-publish-20261112'));
create temporary table lab (content_key text primary key, topic text, exp_hash text) on commit drop;
insert into lab values
('apchem-mcq-b6-h-1.1-a','1.1','c6857c54dcc63dcbb31cf321136030fe'),
('apchem-mcq-b6-sv-h-1.1-a-v1','1.1','9943bc7aa7dc71da8f213ba6c4f5302d'),
('apchem-mcq-b6-sv-h-1.1-a-v2','1.1','19ec8e7ce9a8d8d87c8338606238f3f4'),
('apchem-mcq-b6-sv-h-1.1-a-v3','1.1','554f786caf38a9485974fa1d8a117a7e'),
('apchem-mcq-b6-h-1.1-b','1.1','69bde13ab2b48a4205966cc21e887ecd'),
('apchem-mcq-b6-sv-h-1.1-b-v1','1.1','dc2ad65782e1f168c19bac9f0271e593'),
('apchem-mcq-b6-sv-h-1.1-b-v2','1.1','05b359e0f39ae0f028d1b9438648797d'),
('apchem-mcq-b6-sv-h-1.1-b-v3','1.1','ec33699f93247d66afd93ce48f44e972'),
('apchem-mcq-b6-h-1.2-a','1.2','5fe63bf796efa4670e06d0bacc87b6cd'),
('apchem-mcq-b6-sv-h-1.2-a-v1','1.2','ee81ee33b98717cc763531bfc0a1952d'),
('apchem-mcq-b6-sv-h-1.2-a-v2','1.2','6d4d2eec170b81b99f8b0506d249cc66'),
('apchem-mcq-b6-sv-h-1.2-a-v3','1.2','96050674e8eda27d258e97b665073fe1'),
('apchem-mcq-b6-h-1.2-b','1.2','2176fe7cd5ab4437a3a2ed521bb50c83'),
('apchem-mcq-b6-sv-h-1.2-b-v1','1.2','85069d426f770a58c540bbe08722e03b'),
('apchem-mcq-b6-sv-h-1.2-b-v2','1.2','520cadfc5fa7928863fd0384bb7676c2'),
('apchem-mcq-b6-sv-h-1.2-b-v3','1.2','6a7a0b403cdafd1efb9a836df9173d2e'),
('apchem-mcq-b6-h-1.3-a','1.3','de7769e64e11a7021799fac1cf3c76d4'),
('apchem-mcq-b6-sv-h-1.3-a-v1','1.3','23c3908786310cf16767e7f02c2a9026'),
('apchem-mcq-b6-sv-h-1.3-a-v2','1.3','026e6c9a1bffb1d5f62e85be4426039c'),
('apchem-mcq-b6-sv-h-1.3-a-v3','1.3','0af013233e581c837237352f9a31c64d'),
('apchem-mcq-b6-h-1.3-b','1.3','07d9b5c567fcd7a713c2b61fd143bc05'),
('apchem-mcq-b6-sv-h-1.3-b-v1','1.3','51839a39d62f7d7b41b61e0530568e7d'),
('apchem-mcq-b6-sv-h-1.3-b-v2','1.3','c8b02b16bbe3c458880f38e02c5a8335'),
('apchem-mcq-b6-sv-h-1.3-b-v3','1.3','47d9b75414438fc14879cfda2a9e7ed0'),
('apchem-mcq-b6-h-1.4-a','1.4','00476817a74347da394eef7e899e6c4d'),
('apchem-mcq-b6-sv-h-1.4-a-v1','1.4','a853534966e3af3a91654d5aae22c355'),
('apchem-mcq-b6-sv-h-1.4-a-v2','1.4','515354eead4e76bea23a1bf293c89d5f'),
('apchem-mcq-b6-sv-h-1.4-a-v3','1.4','bdf7708045e530276334d564902db64c'),
('apchem-mcq-b6-h-1.4-b','1.4','c04bc73ef017629855baab89b6424c5a'),
('apchem-mcq-b6-sv-h-1.4-b-v1','1.4','8ba573a7df2666617cdb432b0c04a032'),
('apchem-mcq-b6-sv-h-1.4-b-v2','1.4','55649065c8c7af21a86276306311d325'),
('apchem-mcq-b6-sv-h-1.4-b-v3','1.4','8c685dcbf39d5a402bedff96124a572b'),
('apchem-mcq-b6-h-1.5-a','1.5','09062944efe96946137b3ac1f20661b9'),
('apchem-mcq-b6-sv-h-1.5-a-v1','1.5','f45e2cc0f170bd786b886639515232eb'),
('apchem-mcq-b6-sv-h-1.5-a-v2','1.5','713b2101da757159416115a62001f9c7'),
('apchem-mcq-b6-sv-h-1.5-a-v3','1.5','576428731188e5cf86b44d0ef9ca0fd1'),
('apchem-mcq-b6-h-1.5-b','1.5','cb4f389f2eba9dfa2d6337505b73f528'),
('apchem-mcq-b6-sv-h-1.5-b-v1','1.5','883532cf53f2fe790d5fa519102922e5'),
('apchem-mcq-b6-sv-h-1.5-b-v2','1.5','a9d3d7b1c17278e363b42ef6d456554d'),
('apchem-mcq-b6-sv-h-1.5-b-v3','1.5','e5d25f199f61033576ae608b7590a503'),
('apchem-mcq-b6-h-1.6-a','1.6','80bb9abe879f446cd02df4ea853b7034'),
('apchem-mcq-b6-sv-h-1.6-a-v1','1.6','4748a6f1e814d162edebcbb2d21c8c22'),
('apchem-mcq-b6-sv-h-1.6-a-v2','1.6','5c94be6656156e7225e71e9e26570f51'),
('apchem-mcq-b6-sv-h-1.6-a-v3','1.6','5d39e4bc0461e4b48adad101dfc663bf'),
('apchem-mcq-b6-h-1.6-b','1.6','b68d825d3be444c1be0bc65b57aabd7e'),
('apchem-mcq-b6-sv-h-1.6-b-v1','1.6','8bec57d54f5ba6637e748513409b9b54'),
('apchem-mcq-b6-sv-h-1.6-b-v2','1.6','23d2e4e7f5af5ce2792d3543c0b17ae5'),
('apchem-mcq-b6-sv-h-1.6-b-v3','1.6','be08608fe13248a88d8ad550011ad5d8'),
('apchem-mcq-b6-h-1.7-a','1.7','15778ab1ed71f90a076fc0712ade27cc'),
('apchem-mcq-b6-sv-h-1.7-a-v1','1.7','f64c4a0e28520cfd803d1b4e47f29d81'),
('apchem-mcq-b6-sv-h-1.7-a-v2','1.7','3c89a3202dd72afe8ab00d9abb601b2e'),
('apchem-mcq-b6-sv-h-1.7-a-v3','1.7','931e515c7f90b1822cf43889fcfeda84'),
('apchem-mcq-b6-h-1.7-b','1.7','3f24ac323c42539620e4228e0cc6c96e'),
('apchem-mcq-b6-sv-h-1.7-b-v1','1.7','aea142fbc742ca2a9a99725974916b67'),
('apchem-mcq-b6-sv-h-1.7-b-v2','1.7','649d70944616eb6c1783701b0d44079d'),
('apchem-mcq-b6-sv-h-1.7-b-v3','1.7','02a3190d8e125219f2ce3cea4f1b7383'),
('apchem-mcq-b6-h-1.8-a','1.8','c111179e51864bfd64ce8e6f3a8d9299'),
('apchem-mcq-b6-sv-h-1.8-a-v1','1.8','21a106fc960a020887b1a0086c5d144b'),
('apchem-mcq-b6-sv-h-1.8-a-v2','1.8','4e15ef339f1b6ed288bf4ec6121b95a3'),
('apchem-mcq-b6-sv-h-1.8-a-v3','1.8','e506cf370481ecdf90e1de4b5bb78ce0'),
('apchem-mcq-b6-h-1.8-b','1.8','0452c64a36a95b3f921b7dffb35251cf'),
('apchem-mcq-b6-sv-h-1.8-b-v1','1.8','dec61b6ef7557ff642fcedb7f0703ab3'),
('apchem-mcq-b6-sv-h-1.8-b-v2','1.8','66ab478d703e07681aaf35f0d8857944'),
('apchem-mcq-b6-sv-h-1.8-b-v3','1.8','35bcc62f8a8fe6783cf28a7f499d6a7b');
create temporary table tgt on commit drop as
select l.*, ci.id item_id, civ.id version_id, gen_random_uuid() assignment_id, gen_random_uuid() label_id, gen_random_uuid() vd_id,
 'cbe3116f-6ef5-410c-b535-e9fb711c4c2c'::uuid tsv, (case topic when '1.1' then array[1] when '1.2' then array[1] when '1.3' then array[1] when '1.4' then array[1] when '1.5' then array[1] when '1.6' then array[1] when '1.7' then array[1] when '1.8' then array[1] end)::int[] req, 1 pu
from lab l join app.content_items ci on ci.content_key=l.content_key and ci.exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b'
join app.content_item_versions civ on civ.content_item_id=ci.id and civ.version_num=1
where ci.status='draft' and civ.status='draft';
do $$ begin
 if (select count(*) from tgt)<>64 then raise exception 'expected 64 draft targets, got %', (select count(*) from tgt); end if;
 if exists (select 1 from tgt where split_part(topic,'.',1)::int<>pu) then raise exception 'topic/unit mismatch'; end if;
 if exists (select 1 from tgt t join app.content_item_cells c on c.content_item_version_id=t.version_id) or exists (select 1 from tgt t join app.content_taxonomy_labels l on l.content_item_id=t.item_id) then raise exception 'a target already has cells or labels'; end if;
 if (select count(*) from (select t.content_key from tgt t join app.content_item_versions civ on civ.id=t.version_id join app.mcq_choices c on c.content_item_version_id=civ.id group by t.content_key, civ.stem, t.exp_hash having md5(civ.stem||'|'||string_agg(c.choice_key||':'||c.choice_text||':'||c.is_correct::text||':'||c.rationale,'|' order by c.choice_key))=t.exp_hash) z)<>64 then raise exception 'loaded text does not match the build manifest'; end if;
 if exists (select 1 from tgt t where not exists (select 1 from app.taxonomy_topics tt where tt.taxonomy_source_version=t.tsv and tt.topic_code=t.topic)) then raise exception 'a topic code is not present in the taxonomy source version'; end if;
end $$;
insert into app.content_review_assignments (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, review_kind, status, assignment_purpose, created_by)
select assignment_id, version_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'tutor_question', 'mcq', 'pending', 'owner_remediation_approval', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
insert into app.content_review_decisions (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, tutor_score, difficulty_label, diagnostic_flag, concern_codes, note, tutor_decision, decision_payload, decision_hash, created_by)
select assignment_id, version_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'tutor_question', 1, null, false, array[]::text[],
 'AP Chemistry Unit 3 harder seeds and variants (batch apchem_u1_2026_11_12): Product Owner review of owner-session-authored drafts, 2026-11-12. Arithmetic verified in Python; no model-checker pass, by Product Owner decision.',
 'approve',
 jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apchem_u1_2026_11_12_po_approval','qa_date','2026-11-12','content_key',content_key),
 md5(jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apchem_u1_2026_11_12_po_approval','qa_date','2026-11-12','content_key',content_key)::text),
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
 'apchem_u1_2026_11_12',
 jsonb_build_object('origin','owner_authored','units_source','AP Chemistry Unit 1 (topics 1.x belong to unit 3; required_units set per topic from existing Unit 3 labels)','topic',topic,'report','scripts/content-seed/apchem-harder-seeds-u3-2026-11-12'),
 'apchem-u1-2026-11-12-labeling', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
insert into app.content_taxonomy_validation_decisions (validation_decision_id, content_taxonomy_label_id, decided_by, decision, decision_source, reviewed_primary_unit, reviewed_required_units, notes)
select vd_id, label_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'confirmed', 'chat_review', pu, req,
 'Product Owner chat instruction 2026-11-12 (AP Chemistry harder seeds and variants). Topic assigned by the author from the question design (topic recorded on the cell); topic-only tagging, skill left null.' from tgt;
insert into app.content_item_cells (content_item_version_id, content_item_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id, validated_by, validated_at, validation_decision_id)
select version_id, item_id, tsv, topic, null, true, 'validated', 'apchem_u1_2026_11_12_topic',
 'apchem-u1-2026-11-12-labeling (topic set by the author from the question design)', null, now(), gen_random_uuid() from tgt;
update app.content_taxonomy_labels l set label_status='validated', validated_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, validated_at=now(), validation_decision_id=t.vd_id, validated_against_version_id=t.version_id, validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id) from tgt t where l.content_taxonomy_label_id=t.label_id;
update app.content_item_versions civ set status='published', published_at=coalesce(civ.published_at,now()), updated_at=now() from tgt where civ.id=tgt.version_id;
update app.content_items ci set status='published', updated_at=now() from tgt where ci.id=tgt.item_id;
do $$ declare n int; begin
  select count(*) into n from (select content_item_id from app.content_item_versions where status='published' group by 1 having count(*)>1) d; if n<>0 then raise exception 'duplicate published versions: %', n; end if;
  if (select count(*) from app.content_items ci join tgt on tgt.item_id=ci.id where ci.status='published')<>64 then raise exception 'publish count mismatch'; end if;
  select count(*) into n from app.content_taxonomy_labels l join tgt t on t.item_id=l.content_item_id where l.label_scope='serving' and l.superseded_by is null and l.label_status='validated' and l.validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id); if n<>64 then raise exception 'label post-check %', n; end if;
  select count(*) into n from app.content_item_cells where source='apchem_u1_2026_11_12_topic' and is_primary and superseded_by is null; if n<>64 then raise exception 'topic cell count %', n; end if;
end $$;
select (select count(*) from tgt) published, (select count(*) from app.content_taxonomy_labels where source='apchem_u1_2026_11_12' and label_status='validated') validated_labels, (select count(*) from app.content_item_cells where source='apchem_u1_2026_11_12_topic') topic_cells;
commit;
