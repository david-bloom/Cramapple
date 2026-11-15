begin;
select pg_advisory_xact_lock(hashtext('cramapple-apcalcbc-u1a-2026-11-12-publish-20261112'));
create temporary table lab (content_key text primary key, topic text, exp_hash text) on commit drop;
insert into lab values
('apcalcbc-mcq-b6-h-1.1-a','1.1','b461f6dbaa8741e759890943299e8151'),
('apcalcbc-mcq-b6-sv-h-1.1-a-v1','1.1','5758dd0d5ebd90070328822e4674881b'),
('apcalcbc-mcq-b6-sv-h-1.1-a-v2','1.1','6225bd0db563f0e1f19b033f104873c6'),
('apcalcbc-mcq-b6-sv-h-1.1-a-v3','1.1','269c207d689317e020a8dd4bac1bf93a'),
('apcalcbc-mcq-b6-h-1.1-b','1.1','567d23166d469182c8ccf023e14ad506'),
('apcalcbc-mcq-b6-sv-h-1.1-b-v1','1.1','201801c14500dff9a083dfbfc5457952'),
('apcalcbc-mcq-b6-sv-h-1.1-b-v2','1.1','6e2d38c554469181537ba16a8d29d66d'),
('apcalcbc-mcq-b6-sv-h-1.1-b-v3','1.1','302727f1bcf240401e4f900fd880f2d4'),
('apcalcbc-mcq-b6-h-1.2-a','1.2','78464c066b38f72f07407cc5fd3ecb55'),
('apcalcbc-mcq-b6-sv-h-1.2-a-v1','1.2','8a2ab0e95c023b5630cf8c465b81c097'),
('apcalcbc-mcq-b6-sv-h-1.2-a-v2','1.2','3b9c024a96534ec6543c1ac4f1f22fe2'),
('apcalcbc-mcq-b6-sv-h-1.2-a-v3','1.2','5a0dc35d30ae7c3e3a4d7f5810e9422a'),
('apcalcbc-mcq-b6-h-1.2-b','1.2','c335159320f2934bfe51e05f5ef59253'),
('apcalcbc-mcq-b6-sv-h-1.2-b-v1','1.2','364e2f9d1842cffa25fe789d7a34f0b7'),
('apcalcbc-mcq-b6-sv-h-1.2-b-v2','1.2','aceabb7d299c67d74197494b4cd88cd7'),
('apcalcbc-mcq-b6-sv-h-1.2-b-v3','1.2','219b036fe248dc9e05bfefb2fba17a0f'),
('apcalcbc-mcq-b6-h-1.3-a','1.3','2aa7ba45fbf817ec675bf4ecd0a62ebd'),
('apcalcbc-mcq-b6-sv-h-1.3-a-v1','1.3','e53c2e891e0455380a8bf71a11dd9673'),
('apcalcbc-mcq-b6-sv-h-1.3-a-v2','1.3','9596ce34ea8be78a5e6a068e61388f41'),
('apcalcbc-mcq-b6-sv-h-1.3-a-v3','1.3','ebf06ec08fe4dc929243e2ca0470c9e2'),
('apcalcbc-mcq-b6-h-1.3-b','1.3','3f5aebc556b8803573d8584e2cd98dd5'),
('apcalcbc-mcq-b6-sv-h-1.3-b-v1','1.3','1d91bdf387ff13d02bd46f96bb95be80'),
('apcalcbc-mcq-b6-sv-h-1.3-b-v2','1.3','f2e2f6b8fc36755b24ec147f9da90698'),
('apcalcbc-mcq-b6-sv-h-1.3-b-v3','1.3','03f52c8901d5e193167ddca0fee6e3c6'),
('apcalcbc-mcq-b6-h-1.4-a','1.4','7e31aa0ba04065b75f63127cd72504fb'),
('apcalcbc-mcq-b6-sv-h-1.4-a-v1','1.4','757b1cd9f72ba384ce560ad6c814c1c7'),
('apcalcbc-mcq-b6-sv-h-1.4-a-v2','1.4','3e607c4e4ec595ed89370409bc9753ed'),
('apcalcbc-mcq-b6-sv-h-1.4-a-v3','1.4','27bc5f407213c261b2ea00997283c260'),
('apcalcbc-mcq-b6-h-1.4-b','1.4','278194aa16dd3df23b499c2d78d2150a'),
('apcalcbc-mcq-b6-sv-h-1.4-b-v1','1.4','25358e21ca447ac6f9423d9f8ae63e22'),
('apcalcbc-mcq-b6-sv-h-1.4-b-v2','1.4','847c221e61901c1d24eefb67e54a7e1e'),
('apcalcbc-mcq-b6-sv-h-1.4-b-v3','1.4','73f78bd04f23d27160231b90578b1642'),
('apcalcbc-mcq-b6-h-1.5-a','1.5','6c6782effebaabacd45acee430533fc2'),
('apcalcbc-mcq-b6-sv-h-1.5-a-v1','1.5','fe5e98d09ee5c0cb81d5201e1d89479a'),
('apcalcbc-mcq-b6-sv-h-1.5-a-v2','1.5','0a0c071cb077c5484e62a57816b37e14'),
('apcalcbc-mcq-b6-sv-h-1.5-a-v3','1.5','37ac6341aecc53dff1dfa1e6a96586a0'),
('apcalcbc-mcq-b6-h-1.5-b','1.5','41a7475bcaba6775f98bf00f4d6203a2'),
('apcalcbc-mcq-b6-sv-h-1.5-b-v1','1.5','ad476fbf204620dd930084f9bf8f135b'),
('apcalcbc-mcq-b6-sv-h-1.5-b-v2','1.5','65e78633c9989218ba5d36dbef6c297c'),
('apcalcbc-mcq-b6-sv-h-1.5-b-v3','1.5','387a5fbb495717f4eca431e0246fa2c7'),
('apcalcbc-mcq-b6-h-1.6-a','1.6','9179b486ed7837b2b162daf196a631b1'),
('apcalcbc-mcq-b6-sv-h-1.6-a-v1','1.6','20e851ee0f438885ebed88418a52f1c7'),
('apcalcbc-mcq-b6-sv-h-1.6-a-v2','1.6','02d34074002419c84bd26278e3fbac2a'),
('apcalcbc-mcq-b6-sv-h-1.6-a-v3','1.6','b7c9867ba37da79c18574884037c2145'),
('apcalcbc-mcq-b6-h-1.6-b','1.6','03bda9ceb35c21c0c0789c0cb48bcbc1'),
('apcalcbc-mcq-b6-sv-h-1.6-b-v1','1.6','7941678b7c3ab3c808302b3e312e3932'),
('apcalcbc-mcq-b6-sv-h-1.6-b-v2','1.6','742d86b282d266bb8777df8ed0e886e9'),
('apcalcbc-mcq-b6-sv-h-1.6-b-v3','1.6','e714eeb1ba7ef40d16c89d22d6683f99'),
('apcalcbc-mcq-b6-h-1.7-a','1.7','888c53eb7af23c7ddf7b50e29618c0bb'),
('apcalcbc-mcq-b6-sv-h-1.7-a-v1','1.7','5dd0e3c1fafba32f219bd2f4793fd6d0'),
('apcalcbc-mcq-b6-sv-h-1.7-a-v2','1.7','1c7eef996352d011d610de125f6e9e30'),
('apcalcbc-mcq-b6-sv-h-1.7-a-v3','1.7','bfe365c6c7b6d83022e6977ce4d32ba6'),
('apcalcbc-mcq-b6-h-1.7-b','1.7','c5eec946cef4ff7cb7378b52e6fd415e'),
('apcalcbc-mcq-b6-sv-h-1.7-b-v1','1.7','7cefc52b1b265d028c341cd53b7871fe'),
('apcalcbc-mcq-b6-sv-h-1.7-b-v2','1.7','25070337e0ae9fe99de63876465f1567'),
('apcalcbc-mcq-b6-sv-h-1.7-b-v3','1.7','189f04e53c8b83d6f1234bbc774f232d'),
('apcalcbc-mcq-b6-h-1.8-a','1.8','e34df976013469bc7aeffbae688c6ae9'),
('apcalcbc-mcq-b6-sv-h-1.8-a-v1','1.8','fbc9a51660e299b982fa2d2292286e58'),
('apcalcbc-mcq-b6-sv-h-1.8-a-v2','1.8','1ce4f1c09af1583df0cd3a2793b4457e'),
('apcalcbc-mcq-b6-sv-h-1.8-a-v3','1.8','05701ef10368d8dca55bbd86f6e9e658'),
('apcalcbc-mcq-b6-h-1.8-b','1.8','eb6015614da310685bb23d68e0145234'),
('apcalcbc-mcq-b6-sv-h-1.8-b-v1','1.8','c7d97ad0bad1373a202a58958fc2f9fa'),
('apcalcbc-mcq-b6-sv-h-1.8-b-v2','1.8','4131cfd28634d944d09a6f2a99d7216a'),
('apcalcbc-mcq-b6-sv-h-1.8-b-v3','1.8','52c3bad1a86358511a7072b200383530');
create temporary table tgt on commit drop as
select l.*, ci.id item_id, civ.id version_id, gen_random_uuid() assignment_id, gen_random_uuid() label_id, gen_random_uuid() vd_id,
 'ab088009-dc9a-4f93-8824-803e1913505b'::uuid tsv, (case topic when '1.1' then array[1] when '1.10' then array[1] when '1.11' then array[1] when '1.12' then array[1] when '1.13' then array[1] when '1.14' then array[1] when '1.15' then array[1] when '1.16' then array[1] when '1.2' then array[1] when '1.3' then array[1] when '1.4' then array[1] when '1.5' then array[1] when '1.6' then array[1] when '1.7' then array[1] when '1.8' then array[1] when '1.9' then array[1] end)::int[] req, 1 pu
from lab l join app.content_items ci on ci.content_key=l.content_key and ci.exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27'
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
 'AP Calculus BC Unit 3 harder seeds and variants (batch apcalcbc_u1a_2026_11_12): Product Owner review of owner-session-authored drafts, 2026-11-12. Arithmetic verified in Python; no model-checker pass, by Product Owner decision.',
 'approve',
 jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apcalcbc_u1a_2026_11_12_po_approval','qa_date','2026-11-12','content_key',content_key),
 md5(jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apcalcbc_u1a_2026_11_12_po_approval','qa_date','2026-11-12','content_key',content_key)::text),
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
 'apcalcbc_u1a_2026_11_12',
 jsonb_build_object('origin','owner_authored','units_source','AP Calculus BC Unit 1 (topics 1.x belong to unit 3; required_units set per topic from existing Unit 3 labels)','topic',topic,'report','scripts/content-seed/apchem-harder-seeds-u3-2026-11-12'),
 'apcalcbc-u1a-2026-11-12-labeling', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
insert into app.content_taxonomy_validation_decisions (validation_decision_id, content_taxonomy_label_id, decided_by, decision, decision_source, reviewed_primary_unit, reviewed_required_units, notes)
select vd_id, label_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'confirmed', 'chat_review', pu, req,
 'Product Owner chat instruction 2026-11-12 (AP Calculus BC harder seeds and variants). Topic assigned by the author from the question design (topic recorded on the cell); topic-only tagging, skill left null.' from tgt;
insert into app.content_item_cells (content_item_version_id, content_item_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id, validated_by, validated_at, validation_decision_id)
select version_id, item_id, tsv, topic, null, true, 'validated', 'apcalcbc_u1a_2026_11_12_topic',
 'apcalcbc-u1a-2026-11-12-labeling (topic set by the author from the question design)', null, now(), gen_random_uuid() from tgt;
update app.content_taxonomy_labels l set label_status='validated', validated_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, validated_at=now(), validation_decision_id=t.vd_id, validated_against_version_id=t.version_id, validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id) from tgt t where l.content_taxonomy_label_id=t.label_id;
update app.content_item_versions civ set status='published', published_at=coalesce(civ.published_at,now()), updated_at=now() from tgt where civ.id=tgt.version_id;
update app.content_items ci set status='published', updated_at=now() from tgt where ci.id=tgt.item_id;
do $$ declare n int; begin
  select count(*) into n from (select content_item_id from app.content_item_versions where status='published' group by 1 having count(*)>1) d; if n<>0 then raise exception 'duplicate published versions: %', n; end if;
  if (select count(*) from app.content_items ci join tgt on tgt.item_id=ci.id where ci.status='published')<>64 then raise exception 'publish count mismatch'; end if;
  select count(*) into n from app.content_taxonomy_labels l join tgt t on t.item_id=l.content_item_id where l.label_scope='serving' and l.superseded_by is null and l.label_status='validated' and l.validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id); if n<>64 then raise exception 'label post-check %', n; end if;
  select count(*) into n from app.content_item_cells where source='apcalcbc_u1a_2026_11_12_topic' and is_primary and superseded_by is null; if n<>64 then raise exception 'topic cell count %', n; end if;
end $$;
do $$ begin raise exception 'REHEARSAL OK (rolled back): published=%, validated_labels=%, topic_cells=%', (select count(*) from tgt), (select count(*) from app.content_taxonomy_labels where source='apcalcbc_u1a_2026_11_12' and label_status='validated'), (select count(*) from app.content_item_cells where source='apcalcbc_u1a_2026_11_12_topic'); end $$;
rollback;
