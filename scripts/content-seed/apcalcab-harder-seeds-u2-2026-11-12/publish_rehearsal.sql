begin;
select pg_advisory_xact_lock(hashtext('cramapple-apcalcab-u2-2026-11-12-publish-20261112'));
create temporary table lab (content_key text primary key, topic text, exp_hash text) on commit drop;
insert into lab values
('apcalcab-mcq-b5-h-2.1-a','2.1','901fd078db6a1a6129f5e41c0f193fce'),
('apcalcab-mcq-b5-sv-h-2.1-a-v1','2.1','8bd5a3dedb4598862d88165a2465cc74'),
('apcalcab-mcq-b5-sv-h-2.1-a-v2','2.1','aefe2e79f4eb7b25036150c38b8128bb'),
('apcalcab-mcq-b5-sv-h-2.1-a-v3','2.1','450a4496c74e285931f6aacec57d0b49'),
('apcalcab-mcq-b5-h-2.1-b','2.1','9ef91e52cf2b6e0ceed6009870df8ee4'),
('apcalcab-mcq-b5-sv-h-2.1-b-v1','2.1','028b31d7ffd235eb64602a675932e803'),
('apcalcab-mcq-b5-sv-h-2.1-b-v2','2.1','3c913f9edca70e70bd8ef6b0e3f281d0'),
('apcalcab-mcq-b5-sv-h-2.1-b-v3','2.1','69250d0e26c3dcb4f57c60c37a627180'),
('apcalcab-mcq-b5-h-2.2-a','2.2','869c6c61227531aff5190985f3a308aa'),
('apcalcab-mcq-b5-sv-h-2.2-a-v1','2.2','cef3148a58bb5467747eb89d85fb5fc6'),
('apcalcab-mcq-b5-sv-h-2.2-a-v2','2.2','6e4a8cb59951f794d27c97b01544ae9f'),
('apcalcab-mcq-b5-sv-h-2.2-a-v3','2.2','4ae407ca1a087acd7c2a60464c7cea54'),
('apcalcab-mcq-b5-h-2.2-b','2.2','e44edfe8aa05c34b3cc49861f09f5c64'),
('apcalcab-mcq-b5-sv-h-2.2-b-v1','2.2','e7157d1c4b752e9b2d86458ed35c426f'),
('apcalcab-mcq-b5-sv-h-2.2-b-v2','2.2','c5300034f2d1c046773fa31a3c37757d'),
('apcalcab-mcq-b5-sv-h-2.2-b-v3','2.2','a131777d1b2b3d2433faa8d7b1570ccf'),
('apcalcab-mcq-b5-h-2.3-a','2.3','62830f5924bac6a7517bf667a8ba4b8b'),
('apcalcab-mcq-b5-sv-h-2.3-a-v1','2.3','7e9a2df6734bd74d251123550afb2211'),
('apcalcab-mcq-b5-sv-h-2.3-a-v2','2.3','a7e0bc6c0216adaefb2381f587422faa'),
('apcalcab-mcq-b5-sv-h-2.3-a-v3','2.3','8da61efaa1b4f2fdc01a3eb73203c471'),
('apcalcab-mcq-b5-h-2.3-b','2.3','65eecc7e1767c8457ca20c4243d1dbef'),
('apcalcab-mcq-b5-sv-h-2.3-b-v1','2.3','d32d4da940a4352e22e102bab3c11454'),
('apcalcab-mcq-b5-sv-h-2.3-b-v2','2.3','fde74a9b2a2016c1ccfb4b1b003bb657'),
('apcalcab-mcq-b5-sv-h-2.3-b-v3','2.3','0fcdef74e11149ee89d416ef0768fdfd'),
('apcalcab-mcq-b5-h-2.4-a','2.4','78b179f0f9fb73d72ddce5429c5360f0'),
('apcalcab-mcq-b5-sv-h-2.4-a-v1','2.4','6d65a0e869d703d51ea50e523c91f5e8'),
('apcalcab-mcq-b5-sv-h-2.4-a-v2','2.4','fee36a56547910fd8073d08d347f38db'),
('apcalcab-mcq-b5-sv-h-2.4-a-v3','2.4','f41b4b7b75447cc5d56da59a4ecb12b7'),
('apcalcab-mcq-b5-h-2.4-b','2.4','ad0008e8054f4065c7c1385ad6efd2a7'),
('apcalcab-mcq-b5-sv-h-2.4-b-v1','2.4','41bc9f991913e56f09a7450a022aae45'),
('apcalcab-mcq-b5-sv-h-2.4-b-v2','2.4','d89a878846474f7a4aa8cb3ea531ccaf'),
('apcalcab-mcq-b5-sv-h-2.4-b-v3','2.4','c128a325a4fa6df239974a0b5c28ff53'),
('apcalcab-mcq-b5-h-2.5-a','2.5','3efc61abd9790b80002ce2982909a990'),
('apcalcab-mcq-b5-sv-h-2.5-a-v1','2.5','ea67e08f0d460846f0548975f3f1a5bc'),
('apcalcab-mcq-b5-sv-h-2.5-a-v2','2.5','8286b10681983e2217d87da1d521b9e7'),
('apcalcab-mcq-b5-sv-h-2.5-a-v3','2.5','d6b0eeae81043ff2179b0e61d07188cb'),
('apcalcab-mcq-b5-h-2.5-b','2.5','6fdc1dcc1869443eea6e5178234dc9ad'),
('apcalcab-mcq-b5-sv-h-2.5-b-v1','2.5','379e7e13e07f251da2d5eda80f993231'),
('apcalcab-mcq-b5-sv-h-2.5-b-v2','2.5','dcdc1dd456befb1db45c943c6c632fc5'),
('apcalcab-mcq-b5-sv-h-2.5-b-v3','2.5','7c49338149beb9dbb99a592186d7b62d'),
('apcalcab-mcq-b5-h-2.6-a','2.6','f37e79385d2b0ba0417028febf7c1ecf'),
('apcalcab-mcq-b5-sv-h-2.6-a-v1','2.6','ed1062dbf3252af50e3c5542961a23f6'),
('apcalcab-mcq-b5-sv-h-2.6-a-v2','2.6','64f64a4a8bb6469616c061197c736f87'),
('apcalcab-mcq-b5-sv-h-2.6-a-v3','2.6','9c3741a473b1983dc60bd8cf00b68211'),
('apcalcab-mcq-b5-h-2.6-b','2.6','03145f69c48b429b57f252d38f727c2a'),
('apcalcab-mcq-b5-sv-h-2.6-b-v1','2.6','e4e643c0e96f481005dfc6fdaeed823e'),
('apcalcab-mcq-b5-sv-h-2.6-b-v2','2.6','aead0e3fd6177b122d493a59766bd80b'),
('apcalcab-mcq-b5-sv-h-2.6-b-v3','2.6','02a8fcbdb2ee86d58ad0e3eaf84aa1af'),
('apcalcab-mcq-b5-h-2.7-a','2.7','eff63123ee664182455e1a33f8f31954'),
('apcalcab-mcq-b5-sv-h-2.7-a-v1','2.7','992a966da224bbfac2c6081f7c19791c'),
('apcalcab-mcq-b5-sv-h-2.7-a-v2','2.7','67f925b5e3278a07da875b5b0191df41'),
('apcalcab-mcq-b5-sv-h-2.7-a-v3','2.7','634fda828db4b7361033b40efcb31fda'),
('apcalcab-mcq-b5-h-2.7-b','2.7','7a48686a2f76ec203b5575d8d31de929'),
('apcalcab-mcq-b5-sv-h-2.7-b-v1','2.7','8e26804feb1948db8e8f0b93f816cc20'),
('apcalcab-mcq-b5-sv-h-2.7-b-v2','2.7','4d79702bbb7f5e7085e62d14483532b2'),
('apcalcab-mcq-b5-sv-h-2.7-b-v3','2.7','b27ed4deaa87f08a080b3181bbbe84f6'),
('apcalcab-mcq-b5-h-2.8-a','2.8','a2e0c22fc62439f91775e4d6f8f6f5c3'),
('apcalcab-mcq-b5-sv-h-2.8-a-v1','2.8','f3ab1022612b11f0f4a4412e9689fb59'),
('apcalcab-mcq-b5-sv-h-2.8-a-v2','2.8','9b8f9b81b6aa50d059190f9e4cc97e09'),
('apcalcab-mcq-b5-sv-h-2.8-a-v3','2.8','bc5754f5d09c0e5920fd1fc703d1bf33'),
('apcalcab-mcq-b5-h-2.8-b','2.8','c790b0464d8e2f2f5df228447d842c4a'),
('apcalcab-mcq-b5-sv-h-2.8-b-v1','2.8','1b3739058d10fe3621f755ad1ba76cc7'),
('apcalcab-mcq-b5-sv-h-2.8-b-v2','2.8','0e71076f60c849139c29c37720afb353'),
('apcalcab-mcq-b5-sv-h-2.8-b-v3','2.8','03a5d388c4e5f43ddaa91d7582c71efd'),
('apcalcab-mcq-b5-h-2.9-a','2.9','5882aeead6e85cc305897459142a0406'),
('apcalcab-mcq-b5-sv-h-2.9-a-v1','2.9','32ecda6015c88a03e24a770a7f5672e5'),
('apcalcab-mcq-b5-sv-h-2.9-a-v2','2.9','5ff2d9f3b7955d829850f2a1ca64e52a'),
('apcalcab-mcq-b5-sv-h-2.9-a-v3','2.9','f407807920f003edada6c885f5cfffe8'),
('apcalcab-mcq-b5-h-2.9-b','2.9','2c358119d84f8ef2395e377f079b0f50'),
('apcalcab-mcq-b5-sv-h-2.9-b-v1','2.9','618661cebe512c0c2357d3f95d5cda3e'),
('apcalcab-mcq-b5-sv-h-2.9-b-v2','2.9','72ca152b04b3f0e017f44284250fd732'),
('apcalcab-mcq-b5-sv-h-2.9-b-v3','2.9','21011f6f6f2fbb6e6dffacb8d2d3f0fb'),
('apcalcab-mcq-b5-h-2.10-a','2.10','d0445d369d62b89775eca98066c2635f'),
('apcalcab-mcq-b5-sv-h-2.10-a-v1','2.10','2ba7c2fa0c29835e20e0bd922701bed5'),
('apcalcab-mcq-b5-sv-h-2.10-a-v2','2.10','b42e5f489d52a59768120f6ae5d9e145'),
('apcalcab-mcq-b5-sv-h-2.10-a-v3','2.10','6d5537ab8bf5d723129ac7914520e5cd'),
('apcalcab-mcq-b5-h-2.10-b','2.10','2b63aa6c1e56e830753cba114d7b9b97'),
('apcalcab-mcq-b5-sv-h-2.10-b-v1','2.10','a6a30e12756ee42a1e0b7bcaf8b1bfa6'),
('apcalcab-mcq-b5-sv-h-2.10-b-v2','2.10','1d560b182c49670e3d06e23bb633d935'),
('apcalcab-mcq-b5-sv-h-2.10-b-v3','2.10','baee05101bbf3ee7cc0cfe9f17df7171');
create temporary table tgt on commit drop as
select l.*, ci.id item_id, civ.id version_id, gen_random_uuid() assignment_id, gen_random_uuid() label_id, gen_random_uuid() vd_id,
 '33b4408b-0ecc-4c7a-b0b1-612db81164a1'::uuid tsv, (case topic when '2.1' then array[2] when '2.10' then array[2] when '2.2' then array[2] when '2.3' then array[2] when '2.4' then array[1, 2] when '2.5' then array[2] when '2.6' then array[2] when '2.7' then array[2] when '2.8' then array[2] when '2.9' then array[2] end)::int[] req, 2 pu
from lab l join app.content_items ci on ci.content_key=l.content_key and ci.exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d'
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
 'AP Calculus AB Unit 3 harder seeds and variants (batch apcalcab_u2_2026_11_12): Product Owner review of owner-session-authored drafts, 2026-11-12. Arithmetic verified in Python; no model-checker pass, by Product Owner decision.',
 'approve',
 jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apcalcab_u2_2026_11_12_po_approval','qa_date','2026-11-12','content_key',content_key),
 md5(jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apcalcab_u2_2026_11_12_po_approval','qa_date','2026-11-12','content_key',content_key)::text),
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
 'apcalcab_u2_2026_11_12',
 jsonb_build_object('origin','owner_authored','units_source','AP Calculus AB Unit 2 (topics 2.x belong to unit 3; required_units set per topic from existing Unit 3 labels)','topic',topic,'report','scripts/content-seed/apchem-harder-seeds-u3-2026-11-12'),
 'apcalcab-u2-2026-11-12-labeling', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
insert into app.content_taxonomy_validation_decisions (validation_decision_id, content_taxonomy_label_id, decided_by, decision, decision_source, reviewed_primary_unit, reviewed_required_units, notes)
select vd_id, label_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'confirmed', 'chat_review', pu, req,
 'Product Owner chat instruction 2026-11-12 (AP Calculus AB harder seeds and variants). Topic assigned by the author from the question design (topic recorded on the cell); topic-only tagging, skill left null.' from tgt;
insert into app.content_item_cells (content_item_version_id, content_item_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id, validated_by, validated_at, validation_decision_id)
select version_id, item_id, tsv, topic, null, true, 'validated', 'apcalcab_u2_2026_11_12_topic',
 'apcalcab-u2-2026-11-12-labeling (topic set by the author from the question design)', null, now(), gen_random_uuid() from tgt;
update app.content_taxonomy_labels l set label_status='validated', validated_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, validated_at=now(), validation_decision_id=t.vd_id, validated_against_version_id=t.version_id, validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id) from tgt t where l.content_taxonomy_label_id=t.label_id;
update app.content_item_versions civ set status='published', published_at=coalesce(civ.published_at,now()), updated_at=now() from tgt where civ.id=tgt.version_id;
update app.content_items ci set status='published', updated_at=now() from tgt where ci.id=tgt.item_id;
do $$ declare n int; begin
  select count(*) into n from (select content_item_id from app.content_item_versions where status='published' group by 1 having count(*)>1) d; if n<>0 then raise exception 'duplicate published versions: %', n; end if;
  if (select count(*) from app.content_items ci join tgt on tgt.item_id=ci.id where ci.status='published')<>80 then raise exception 'publish count mismatch'; end if;
  select count(*) into n from app.content_taxonomy_labels l join tgt t on t.item_id=l.content_item_id where l.label_scope='serving' and l.superseded_by is null and l.label_status='validated' and l.validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id); if n<>80 then raise exception 'label post-check %', n; end if;
  select count(*) into n from app.content_item_cells where source='apcalcab_u2_2026_11_12_topic' and is_primary and superseded_by is null; if n<>80 then raise exception 'topic cell count %', n; end if;
end $$;
do $$ begin raise exception 'REHEARSAL OK (rolled back): published=%, validated_labels=%, topic_cells=%', (select count(*) from tgt), (select count(*) from app.content_taxonomy_labels where source='apcalcab_u2_2026_11_12' and label_status='validated'), (select count(*) from app.content_item_cells where source='apcalcab_u2_2026_11_12_topic'); end $$;
rollback;
