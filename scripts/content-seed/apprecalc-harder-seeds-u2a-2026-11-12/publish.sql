begin;
select pg_advisory_xact_lock(hashtext('cramapple-apprecalc-u2a-2026-11-12-publish-20261112'));
create temporary table lab (content_key text primary key, topic text, exp_hash text) on commit drop;
insert into lab values
('apprecalc-mcq-b7-h-2.1-a','2.1','dedbc94aa5c789e961021b564e42367f'),
('apprecalc-mcq-b7-sv-h-2.1-a-v1','2.1','02cd22fc5ed36bfd34d841b786f0cd6d'),
('apprecalc-mcq-b7-sv-h-2.1-a-v2','2.1','1ccce4026f2f00d94859333f6493e76d'),
('apprecalc-mcq-b7-sv-h-2.1-a-v3','2.1','75058042a87665cda71713d696bad001'),
('apprecalc-mcq-b7-h-2.1-b','2.1','9c4a0ed623558df26a3de58fe19a53fe'),
('apprecalc-mcq-b7-sv-h-2.1-b-v1','2.1','a090793d8ea28d0eabb587d2f779e114'),
('apprecalc-mcq-b7-sv-h-2.1-b-v2','2.1','62aa8db626aecbc64d8f4771679921b4'),
('apprecalc-mcq-b7-sv-h-2.1-b-v3','2.1','6641abfe257aea9089e040a3902ae04b'),
('apprecalc-mcq-b7-h-2.2-a','2.2','e4e7151660cbe3abb6e015a537f8243a'),
('apprecalc-mcq-b7-sv-h-2.2-a-v1','2.2','fcc3fd5020b3ef24741c4af6ba19baee'),
('apprecalc-mcq-b7-sv-h-2.2-a-v2','2.2','77667269508660857ed2f6a63db93f20'),
('apprecalc-mcq-b7-sv-h-2.2-a-v3','2.2','ae27b7493d58f692fee59be58fcdf28c'),
('apprecalc-mcq-b7-h-2.2-b','2.2','2a7d57caf755f11abf395649d4b1fabb'),
('apprecalc-mcq-b7-sv-h-2.2-b-v1','2.2','1942fb82809a6049428c950dfd8ce708'),
('apprecalc-mcq-b7-sv-h-2.2-b-v2','2.2','c185ecb68d69c891d42bf7359b75daff'),
('apprecalc-mcq-b7-sv-h-2.2-b-v3','2.2','b73c992038fbbbabef6b02caf964032e'),
('apprecalc-mcq-b7-h-2.3-a','2.3','5a8484baa2f07dfa769ef4ecf52cd1d9'),
('apprecalc-mcq-b7-sv-h-2.3-a-v1','2.3','3a829c42dafb6e35d9e8ce42cdbc8f78'),
('apprecalc-mcq-b7-sv-h-2.3-a-v2','2.3','0757e39f5b86ae08781d1e9af88aec79'),
('apprecalc-mcq-b7-sv-h-2.3-a-v3','2.3','3efe0f35f3ad4052ac531d0fbbfd3eb8'),
('apprecalc-mcq-b7-h-2.3-b','2.3','5b34a23f602dc9a69ee7b36a15ffa598'),
('apprecalc-mcq-b7-sv-h-2.3-b-v1','2.3','d86643aed3180b38bc768db868847f0e'),
('apprecalc-mcq-b7-sv-h-2.3-b-v2','2.3','ac0fd53978337c04c1c02e0e5f26485d'),
('apprecalc-mcq-b7-sv-h-2.3-b-v3','2.3','d04c8b2ca6b7f7f481c2d87f9633fcec'),
('apprecalc-mcq-b7-h-2.4-a','2.4','7a81d5cdcdfb26511cfb4dd6fd42ea35'),
('apprecalc-mcq-b7-sv-h-2.4-a-v1','2.4','6beff0e74cd71aaa61a18e4a6575e26c'),
('apprecalc-mcq-b7-sv-h-2.4-a-v2','2.4','00082c8729ed3f95002a2654184b4e47'),
('apprecalc-mcq-b7-sv-h-2.4-a-v3','2.4','df6d1dc59a0b7bb8f2dd675e3e2337c7'),
('apprecalc-mcq-b7-h-2.4-b','2.4','de192c77c954d29035809e62862b7379'),
('apprecalc-mcq-b7-sv-h-2.4-b-v1','2.4','76a8e8a2b8d5757c65ebb1956a12e378'),
('apprecalc-mcq-b7-sv-h-2.4-b-v2','2.4','2f353eb5fd23846dee8fc4a40ad954c5'),
('apprecalc-mcq-b7-sv-h-2.4-b-v3','2.4','5214cde41d0f9d24ebcd0959dc234810'),
('apprecalc-mcq-b7-h-2.5-a','2.5','e48c04735d85997d326461d1e85788c3'),
('apprecalc-mcq-b7-sv-h-2.5-a-v1','2.5','36e7264685e6c11c5ff7e95e2b4529ea'),
('apprecalc-mcq-b7-sv-h-2.5-a-v2','2.5','0e88e3e643b69a5b148cc1289374c874'),
('apprecalc-mcq-b7-sv-h-2.5-a-v3','2.5','bac6987882ba93a5073ce7d7f529d782'),
('apprecalc-mcq-b7-h-2.5-b','2.5','70220b2ca77dccd5c096bcbf9a7822ea'),
('apprecalc-mcq-b7-sv-h-2.5-b-v1','2.5','c64970d36def985d30691394ba03b987'),
('apprecalc-mcq-b7-sv-h-2.5-b-v2','2.5','36e597c7d5e12b3a346f96f792a35954'),
('apprecalc-mcq-b7-sv-h-2.5-b-v3','2.5','501a779ec2af09ee8e4be08da8b6ceb5'),
('apprecalc-mcq-b7-h-2.6-a','2.6','2f7a6e397a7e41cd367dfeb2df62027e'),
('apprecalc-mcq-b7-sv-h-2.6-a-v1','2.6','3c391cde01851b10ce1267ea9f4cd7eb'),
('apprecalc-mcq-b7-sv-h-2.6-a-v2','2.6','b1605230b20a17b9cc2f6e9dc7e3948f'),
('apprecalc-mcq-b7-sv-h-2.6-a-v3','2.6','5ad7254c7aabd41a3afa32014bda04a4'),
('apprecalc-mcq-b7-h-2.6-b','2.6','be18f2c39a3a0b1fb2234e1e8d34a080'),
('apprecalc-mcq-b7-sv-h-2.6-b-v1','2.6','df6705da626ae57cb9873ae704636b50'),
('apprecalc-mcq-b7-sv-h-2.6-b-v2','2.6','6899bff5301a31fd2ddcfebd7b360625'),
('apprecalc-mcq-b7-sv-h-2.6-b-v3','2.6','b61e1c8dd96919eb48fb79fe420e0376'),
('apprecalc-mcq-b7-h-2.7-a','2.7','33d96dab69dfab474d3bf222a4a2115e'),
('apprecalc-mcq-b7-sv-h-2.7-a-v1','2.7','75e07b9fc3405dae60174d55167c41b8'),
('apprecalc-mcq-b7-sv-h-2.7-a-v2','2.7','142bb828976f57ce9dfd09e3b6885ef6'),
('apprecalc-mcq-b7-sv-h-2.7-a-v3','2.7','d4c289d04d1b014a4c25be0a48b23fbd'),
('apprecalc-mcq-b7-h-2.7-b','2.7','9a1ba6cec4d21e23e59c4952059de05b'),
('apprecalc-mcq-b7-sv-h-2.7-b-v1','2.7','26ba902f9cfef158510d2e6a4222c449'),
('apprecalc-mcq-b7-sv-h-2.7-b-v2','2.7','71c177975c17b947900957235c927ad2'),
('apprecalc-mcq-b7-sv-h-2.7-b-v3','2.7','825c7ddbdfba9fe04a0dadc760038f19'),
('apprecalc-mcq-b7-h-2.8-a','2.8','0d19f2b1c48aebbd35e65fa748f92cdc'),
('apprecalc-mcq-b7-sv-h-2.8-a-v1','2.8','35e7b74ec023a0e224f3aa902ec19046'),
('apprecalc-mcq-b7-sv-h-2.8-a-v2','2.8','004ff1392545c555ed8e7030a9594cd1'),
('apprecalc-mcq-b7-sv-h-2.8-a-v3','2.8','a48c03187b72b1cedb805e9ae9cd594f'),
('apprecalc-mcq-b7-h-2.8-b','2.8','aec14eb718d093571d88ec7f35cdff25'),
('apprecalc-mcq-b7-sv-h-2.8-b-v1','2.8','16087b90aef7c34fb75e35d223fdce06'),
('apprecalc-mcq-b7-sv-h-2.8-b-v2','2.8','63090c2b4f47ae05d6fb10e5fcd10804'),
('apprecalc-mcq-b7-sv-h-2.8-b-v3','2.8','a61b1d6617eec9b36132d0919fbb8c60');
create temporary table tgt on commit drop as
select l.*, ci.id item_id, civ.id version_id, gen_random_uuid() assignment_id, gen_random_uuid() label_id, gen_random_uuid() vd_id,
 '16383753-6775-430d-960a-544cd6ee0972'::uuid tsv, (case topic when '2.1' then array[2] when '2.10' then array[2] when '2.11' then array[1, 2] when '2.12' then array[2] when '2.13' then array[2] when '2.14' then array[2] when '2.15' then array[2] when '2.2' then array[2] when '2.3' then array[2] when '2.4' then array[2] when '2.5' then array[2] when '2.6' then array[2] when '2.7' then array[2] when '2.8' then array[2] when '2.9' then array[2] end)::int[] req, 2 pu
from lab l join app.content_items ci on ci.content_key=l.content_key and ci.exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db'
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
 'AP Precalculus Unit 3 harder seeds and variants (batch apprecalc_u2a_2026_11_12): Product Owner review of owner-session-authored drafts, 2026-11-12. Arithmetic verified in Python; no model-checker pass, by Product Owner decision.',
 'approve',
 jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apprecalc_u2a_2026_11_12_po_approval','qa_date','2026-11-12','content_key',content_key),
 md5(jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apprecalc_u2a_2026_11_12_po_approval','qa_date','2026-11-12','content_key',content_key)::text),
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
 'apprecalc_u2a_2026_11_12',
 jsonb_build_object('origin','owner_authored','units_source','AP Precalculus Unit 2 (topics 2.x belong to unit 3; required_units set per topic from existing Unit 3 labels)','topic',topic,'report','scripts/content-seed/apchem-harder-seeds-u3-2026-11-12'),
 'apprecalc-u2a-2026-11-12-labeling', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
insert into app.content_taxonomy_validation_decisions (validation_decision_id, content_taxonomy_label_id, decided_by, decision, decision_source, reviewed_primary_unit, reviewed_required_units, notes)
select vd_id, label_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'confirmed', 'chat_review', pu, req,
 'Product Owner chat instruction 2026-11-12 (AP Precalculus harder seeds and variants). Topic assigned by the author from the question design (topic recorded on the cell); topic-only tagging, skill left null.' from tgt;
insert into app.content_item_cells (content_item_version_id, content_item_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id, validated_by, validated_at, validation_decision_id)
select version_id, item_id, tsv, topic, null, true, 'validated', 'apprecalc_u2a_2026_11_12_topic',
 'apprecalc-u2a-2026-11-12-labeling (topic set by the author from the question design)', null, now(), gen_random_uuid() from tgt;
update app.content_taxonomy_labels l set label_status='validated', validated_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, validated_at=now(), validation_decision_id=t.vd_id, validated_against_version_id=t.version_id, validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id) from tgt t where l.content_taxonomy_label_id=t.label_id;
update app.content_item_versions civ set status='published', published_at=coalesce(civ.published_at,now()), updated_at=now() from tgt where civ.id=tgt.version_id;
update app.content_items ci set status='published', updated_at=now() from tgt where ci.id=tgt.item_id;
do $$ declare n int; begin
  select count(*) into n from (select content_item_id from app.content_item_versions where status='published' group by 1 having count(*)>1) d; if n<>0 then raise exception 'duplicate published versions: %', n; end if;
  if (select count(*) from app.content_items ci join tgt on tgt.item_id=ci.id where ci.status='published')<>64 then raise exception 'publish count mismatch'; end if;
  select count(*) into n from app.content_taxonomy_labels l join tgt t on t.item_id=l.content_item_id where l.label_scope='serving' and l.superseded_by is null and l.label_status='validated' and l.validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id); if n<>64 then raise exception 'label post-check %', n; end if;
  select count(*) into n from app.content_item_cells where source='apprecalc_u2a_2026_11_12_topic' and is_primary and superseded_by is null; if n<>64 then raise exception 'topic cell count %', n; end if;
end $$;
select (select count(*) from tgt) published, (select count(*) from app.content_taxonomy_labels where source='apprecalc_u2a_2026_11_12' and label_status='validated') validated_labels, (select count(*) from app.content_item_cells where source='apprecalc_u2a_2026_11_12_topic') topic_cells;
commit;
