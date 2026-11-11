begin;
select pg_advisory_xact_lock(hashtext('cramapple-apchem-u4-2026-11-12-publish-20261112'));
create temporary table lab (content_key text primary key, topic text, exp_hash text) on commit drop;
insert into lab values
('apchem-mcq-b4-h-4.1-a','4.1','12882a641a99d30b137f3377a3199162'),
('apchem-mcq-b4-sv-h-4.1-a-v1','4.1','1a40195272adeb07426a15fab46a8cec'),
('apchem-mcq-b4-sv-h-4.1-a-v2','4.1','dd35621412dfb4d190e4b29d8a2a2d76'),
('apchem-mcq-b4-sv-h-4.1-a-v3','4.1','31bc2acf722cfe286486d2e412bf39fa'),
('apchem-mcq-b4-h-4.1-b','4.1','564a68790ff8d0eacb6a44948c824a2f'),
('apchem-mcq-b4-sv-h-4.1-b-v1','4.1','30b83f62e8f48435e2e90ccdc91e19a2'),
('apchem-mcq-b4-sv-h-4.1-b-v2','4.1','a3b533396288a257b058e32c713e5816'),
('apchem-mcq-b4-sv-h-4.1-b-v3','4.1','c66f65c3cb6e8025210b61bbb9ff7da3'),
('apchem-mcq-b4-h-4.2-a','4.2','66aaa52233b5db51cceed467329175dd'),
('apchem-mcq-b4-sv-h-4.2-a-v1','4.2','ca5e8eed993837249a439d4957cfa2db'),
('apchem-mcq-b4-sv-h-4.2-a-v2','4.2','66ac147ab67692eed0dbd1910d61fb08'),
('apchem-mcq-b4-sv-h-4.2-a-v3','4.2','e2fa2baa749b6d4b3deecf16c19156ee'),
('apchem-mcq-b4-h-4.2-b','4.2','a4196c39c4f3c12b6e64d78abd6977d6'),
('apchem-mcq-b4-sv-h-4.2-b-v1','4.2','3b2e9620f194eff378eda27562900216'),
('apchem-mcq-b4-sv-h-4.2-b-v2','4.2','84589b3bcd8c3942fb730cfc46eab72b'),
('apchem-mcq-b4-sv-h-4.2-b-v3','4.2','6d77d7b6f91aff8f73c9f7ac1848047e'),
('apchem-mcq-b4-h-4.3-a','4.3','937e0677a2ce29d69a4ac6a034a3147f'),
('apchem-mcq-b4-sv-h-4.3-a-v1','4.3','e7797747716b956bab8485850ee6c1d9'),
('apchem-mcq-b4-sv-h-4.3-a-v2','4.3','ff5ae39a6c630636ff93c31bd3dbe577'),
('apchem-mcq-b4-sv-h-4.3-a-v3','4.3','d562b676bdb45ee9e196112f472a8607'),
('apchem-mcq-b4-h-4.3-b','4.3','1c615b753169d86a15aabc4c71c968f0'),
('apchem-mcq-b4-sv-h-4.3-b-v1','4.3','61db1e5acf9b19d924d2e9972ce4a76e'),
('apchem-mcq-b4-sv-h-4.3-b-v2','4.3','926ce89ccfd63fc18f3eea7385ec7733'),
('apchem-mcq-b4-sv-h-4.3-b-v3','4.3','c106d71259b05bce9ff9d87615167378'),
('apchem-mcq-b4-h-4.4-a','4.4','6439cac956a047bf17ec166c758ebc39'),
('apchem-mcq-b4-sv-h-4.4-a-v1','4.4','22b7325155a7e9b47c2d89483780ea7d'),
('apchem-mcq-b4-sv-h-4.4-a-v2','4.4','4edec20f147f00e06c379f99e370d55f'),
('apchem-mcq-b4-sv-h-4.4-a-v3','4.4','897a999aee2f4c2e55f3e56ed23c4a10'),
('apchem-mcq-b4-h-4.4-b','4.4','4b8f9369859b664a6c234dcb76c4086d'),
('apchem-mcq-b4-sv-h-4.4-b-v1','4.4','88a579dd321bc62224f8ad4c996a5c76'),
('apchem-mcq-b4-sv-h-4.4-b-v2','4.4','21cb59e790b6eb753f29dafc3ad20319'),
('apchem-mcq-b4-sv-h-4.4-b-v3','4.4','56b86393640a17730abebcb61c8437c0'),
('apchem-mcq-b4-h-4.5-a','4.5','1612bba06683f80700b094102989e555'),
('apchem-mcq-b4-sv-h-4.5-a-v1','4.5','3204949723f5bca2b1b60a39e0c4ddf1'),
('apchem-mcq-b4-sv-h-4.5-a-v2','4.5','13ee0914653a57c962865084b3a8fe73'),
('apchem-mcq-b4-sv-h-4.5-a-v3','4.5','88fbbc98adf0b0e27024564a34b5f0e6'),
('apchem-mcq-b4-h-4.5-b','4.5','7a0da591c971d968cab95bc01e61f3e2'),
('apchem-mcq-b4-sv-h-4.5-b-v1','4.5','9b244162b9581335317f2ad8d896e162'),
('apchem-mcq-b4-sv-h-4.5-b-v2','4.5','1041fe2fa3987c669ddd2664126670da'),
('apchem-mcq-b4-sv-h-4.5-b-v3','4.5','b85f2cbc07d2ba231288422a133c3551'),
('apchem-mcq-b4-h-4.6-a','4.6','8c06143a534aad7b30a27e69f0b4a8ce'),
('apchem-mcq-b4-sv-h-4.6-a-v1','4.6','75437f753676fbb17d34c6b2c27001e6'),
('apchem-mcq-b4-sv-h-4.6-a-v2','4.6','78505b89c72ad3b91d04245e05434659'),
('apchem-mcq-b4-sv-h-4.6-a-v3','4.6','523e7f9a0bc23f278332af2381b41780'),
('apchem-mcq-b4-h-4.6-b','4.6','6eb694c096b7bcaa9d3008ea844aa7cd'),
('apchem-mcq-b4-sv-h-4.6-b-v1','4.6','3f658f7a3b7866a3c2f43fea82adc966'),
('apchem-mcq-b4-sv-h-4.6-b-v2','4.6','d153161c3fe7aa422ca816f47b681fe5'),
('apchem-mcq-b4-sv-h-4.6-b-v3','4.6','3bd0aad2f297ebf7a2de838acf0b3951'),
('apchem-mcq-b4-h-4.7-a','4.7','b6a799ae904894c2361179da81093f4b'),
('apchem-mcq-b4-sv-h-4.7-a-v1','4.7','0491b2fedbf02fe5953eecc2561638e0'),
('apchem-mcq-b4-sv-h-4.7-a-v2','4.7','80d1a7215f28b768786b5d3cc4672eca'),
('apchem-mcq-b4-sv-h-4.7-a-v3','4.7','883883d67e3851941bb7f3773cb2f535'),
('apchem-mcq-b4-h-4.7-b','4.7','a6f72a52d2e8ac62f1eb64780153b145'),
('apchem-mcq-b4-sv-h-4.7-b-v1','4.7','df8bdd44ca805d619219609a8c710711'),
('apchem-mcq-b4-sv-h-4.7-b-v2','4.7','8c93e1c8d4a7e51311db445b9e9b6386'),
('apchem-mcq-b4-sv-h-4.7-b-v3','4.7','fc7444e52fa9605b66beb7df64d3b3f4'),
('apchem-mcq-b4-h-4.8-a','4.8','f27eb63e3ccc79c61f5458d43dca3216'),
('apchem-mcq-b4-sv-h-4.8-a-v1','4.8','bbf2fe3c7eabb516ece76064016b75f8'),
('apchem-mcq-b4-sv-h-4.8-a-v2','4.8','b08ba85d8bce54dbf11d5a1a0c41f8a9'),
('apchem-mcq-b4-sv-h-4.8-a-v3','4.8','c4cf127f37e1aafce1897cbc3ca5bea8'),
('apchem-mcq-b4-h-4.8-b','4.8','ecf2cd0fa5b8bcad40e03ce3ac9f1fe9'),
('apchem-mcq-b4-sv-h-4.8-b-v1','4.8','ed201b410d428a1a24102e767a1c7026'),
('apchem-mcq-b4-sv-h-4.8-b-v2','4.8','effc04b2e3cd2f6d7f8d190abd16c604'),
('apchem-mcq-b4-sv-h-4.8-b-v3','4.8','48fa32571108ef7db2c2df78f30ec180'),
('apchem-mcq-b4-h-4.9-a','4.9','2ef16af788e376560977c1c788c26e3c'),
('apchem-mcq-b4-sv-h-4.9-a-v1','4.9','4b5cdf526030801b63a98f537f2b9c0a'),
('apchem-mcq-b4-sv-h-4.9-a-v2','4.9','b431239d792aeb407d63d42f69f9fb8b'),
('apchem-mcq-b4-sv-h-4.9-a-v3','4.9','a35955bb073f8eb9ce5d16b35e59b389'),
('apchem-mcq-b4-h-4.9-b','4.9','714a91f97eb267c5acd5dfcf4a56e2d0'),
('apchem-mcq-b4-sv-h-4.9-b-v1','4.9','f22462dea4cbb8b0574c18d1dc4d0929'),
('apchem-mcq-b4-sv-h-4.9-b-v2','4.9','1504f8a2bad51600f62457c61e5f12e2'),
('apchem-mcq-b4-sv-h-4.9-b-v3','4.9','2fd4346761a66a824799884a443ed9a6');
create temporary table tgt on commit drop as
select l.*, ci.id item_id, civ.id version_id, gen_random_uuid() assignment_id, gen_random_uuid() label_id, gen_random_uuid() vd_id,
 'cbe3116f-6ef5-410c-b535-e9fb711c4c2c'::uuid tsv, (case topic when '4.1' then array[4] when '4.2' then array[4] when '4.3' then array[4] when '4.4' then array[4] when '4.5' then array[1, 4] when '4.6' then array[3, 4] when '4.7' then array[4] when '4.8' then array[4] when '4.9' then array[4] end)::int[] req, 4 pu
from lab l join app.content_items ci on ci.content_key=l.content_key and ci.exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b'
join app.content_item_versions civ on civ.content_item_id=ci.id and civ.version_num=1
where ci.status='draft' and civ.status='draft';
do $$ begin
 if (select count(*) from tgt)<>72 then raise exception 'expected 72 draft targets, got %', (select count(*) from tgt); end if;
 if exists (select 1 from tgt where split_part(topic,'.',1)::int<>pu) then raise exception 'topic/unit mismatch'; end if;
 if exists (select 1 from tgt t join app.content_item_cells c on c.content_item_version_id=t.version_id) or exists (select 1 from tgt t join app.content_taxonomy_labels l on l.content_item_id=t.item_id) then raise exception 'a target already has cells or labels'; end if;
 if (select count(*) from (select t.content_key from tgt t join app.content_item_versions civ on civ.id=t.version_id join app.mcq_choices c on c.content_item_version_id=civ.id group by t.content_key, civ.stem, t.exp_hash having md5(civ.stem||'|'||string_agg(c.choice_key||':'||c.choice_text||':'||c.is_correct::text||':'||c.rationale,'|' order by c.choice_key))=t.exp_hash) z)<>72 then raise exception 'loaded text does not match the build manifest'; end if;
 if exists (select 1 from tgt t where not exists (select 1 from app.content_item_cells c join app.content_items ci2 on ci2.id=c.content_item_id where ci2.exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and c.topic_code=t.topic and c.taxonomy_source_version=t.tsv and c.superseded_by is null)) then raise exception 'a topic code is not present in the AP Chemistry taxonomy source version'; end if;
end $$;
insert into app.content_review_assignments (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, review_kind, status, assignment_purpose, created_by)
select assignment_id, version_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'tutor_question', 'mcq', 'pending', 'owner_remediation_approval', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
insert into app.content_review_decisions (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, tutor_score, difficulty_label, diagnostic_flag, concern_codes, note, tutor_decision, decision_payload, decision_hash, created_by)
select assignment_id, version_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'tutor_question', 1, null, false, array[]::text[],
 'AP Chemistry Unit 3 harder seeds and variants (batch apchem_u4_2026_11_12): Product Owner review of owner-session-authored drafts, 2026-11-12. Arithmetic verified in Python; no model-checker pass, by Product Owner decision.',
 'approve',
 jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apchem_u4_2026_11_12_po_approval','qa_date','2026-11-12','content_key',content_key),
 md5(jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apchem_u4_2026_11_12_po_approval','qa_date','2026-11-12','content_key',content_key)::text),
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
 'apchem_u4_2026_11_12',
 jsonb_build_object('origin','owner_authored','units_source','AP Chemistry Unit 4 (topics 4.x belong to unit 3; required_units set per topic from existing Unit 3 labels)','topic',topic,'report','scripts/content-seed/apchem-harder-seeds-u3-2026-11-12'),
 'apchem-u4-2026-11-12-labeling', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
insert into app.content_taxonomy_validation_decisions (validation_decision_id, content_taxonomy_label_id, decided_by, decision, decision_source, reviewed_primary_unit, reviewed_required_units, notes)
select vd_id, label_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'confirmed', 'chat_review', pu, req,
 'Product Owner chat instruction 2026-11-12 (AP Chemistry harder seeds and variants). Topic assigned by the author from the question design (topic recorded on the cell); topic-only tagging, skill left null.' from tgt;
insert into app.content_item_cells (content_item_version_id, content_item_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id, validated_by, validated_at, validation_decision_id)
select version_id, item_id, tsv, topic, null, true, 'validated', 'apchem_u4_2026_11_12_topic',
 'apchem-u4-2026-11-12-labeling (topic set by the author from the question design)', null, now(), gen_random_uuid() from tgt;
update app.content_taxonomy_labels l set label_status='validated', validated_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, validated_at=now(), validation_decision_id=t.vd_id, validated_against_version_id=t.version_id, validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id) from tgt t where l.content_taxonomy_label_id=t.label_id;
update app.content_item_versions civ set status='published', published_at=coalesce(civ.published_at,now()), updated_at=now() from tgt where civ.id=tgt.version_id;
update app.content_items ci set status='published', updated_at=now() from tgt where ci.id=tgt.item_id;
do $$ declare n int; begin
  select count(*) into n from (select content_item_id from app.content_item_versions where status='published' group by 1 having count(*)>1) d; if n<>0 then raise exception 'duplicate published versions: %', n; end if;
  if (select count(*) from app.content_items ci join tgt on tgt.item_id=ci.id where ci.status='published')<>72 then raise exception 'publish count mismatch'; end if;
  select count(*) into n from app.content_taxonomy_labels l join tgt t on t.item_id=l.content_item_id where l.label_scope='serving' and l.superseded_by is null and l.label_status='validated' and l.validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id); if n<>72 then raise exception 'label post-check %', n; end if;
  select count(*) into n from app.content_item_cells where source='apchem_u4_2026_11_12_topic' and is_primary and superseded_by is null; if n<>72 then raise exception 'topic cell count %', n; end if;
end $$;
do $$ begin raise exception 'REHEARSAL OK (rolled back): published=%, validated_labels=%, topic_cells=%', (select count(*) from tgt), (select count(*) from app.content_taxonomy_labels where source='apchem_u4_2026_11_12' and label_status='validated'), (select count(*) from app.content_item_cells where source='apchem_u4_2026_11_12_topic'); end $$;
rollback;
