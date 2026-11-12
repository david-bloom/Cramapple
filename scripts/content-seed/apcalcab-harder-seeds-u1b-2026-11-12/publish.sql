begin;
select pg_advisory_xact_lock(hashtext('cramapple-apcalcab-u1b-2026-11-12-publish-20261112'));
create temporary table lab (content_key text primary key, topic text, exp_hash text) on commit drop;
insert into lab values
('apcalcab-mcq-b7-h-1.9-a','1.9','37453bbacd02bdde7a77a13038c8c519'),
('apcalcab-mcq-b7-sv-h-1.9-a-v1','1.9','a983f74b5eeebcf2993df1d796ae41c9'),
('apcalcab-mcq-b7-sv-h-1.9-a-v2','1.9','67ab1314ad193beb8b69dab7d8e53faf'),
('apcalcab-mcq-b7-sv-h-1.9-a-v3','1.9','d67649572a98bc9f458ce74b5292b7a3'),
('apcalcab-mcq-b7-h-1.9-b','1.9','290dd976d6be39c02a73f6e9ee47298d'),
('apcalcab-mcq-b7-sv-h-1.9-b-v1','1.9','093953e087641f0484c0311934431048'),
('apcalcab-mcq-b7-sv-h-1.9-b-v2','1.9','01a3b38f8c07936a163c8d8f0da08636'),
('apcalcab-mcq-b7-sv-h-1.9-b-v3','1.9','a82b860f4d80f729c84c9a86e1535abe'),
('apcalcab-mcq-b7-h-1.10-a','1.10','8b9cfa0e668341bed439aa22e23d87ef'),
('apcalcab-mcq-b7-sv-h-1.10-a-v1','1.10','020b7ee6f16190abf89d4a1828f7117b'),
('apcalcab-mcq-b7-sv-h-1.10-a-v2','1.10','1b0c77453c0e17a95ffd08b4fa03c6c1'),
('apcalcab-mcq-b7-sv-h-1.10-a-v3','1.10','0cab67a24e99fded926a8944ec4d2446'),
('apcalcab-mcq-b7-h-1.10-b','1.10','67728d9ccdfcd51f58fa392c67f6394c'),
('apcalcab-mcq-b7-sv-h-1.10-b-v1','1.10','1fb5bc496d292aae8585b9ad7b606f31'),
('apcalcab-mcq-b7-sv-h-1.10-b-v2','1.10','306f545783087d9877635de13809d1f8'),
('apcalcab-mcq-b7-sv-h-1.10-b-v3','1.10','fcf6d993df4d1beb974d4ab4777b1159'),
('apcalcab-mcq-b7-h-1.11-a','1.11','2c97ebe10957dae28c713c48b5ed890a'),
('apcalcab-mcq-b7-sv-h-1.11-a-v1','1.11','54772851704e200c5a7a1ef29b9e4ac6'),
('apcalcab-mcq-b7-sv-h-1.11-a-v2','1.11','4866cafccfe7160bd32eac9e16d94144'),
('apcalcab-mcq-b7-sv-h-1.11-a-v3','1.11','ec2c0d1ef7b75467b0150d14de82f4fa'),
('apcalcab-mcq-b7-h-1.11-b','1.11','c8de5ea3ebdb4fbdede8846a7d0987a7'),
('apcalcab-mcq-b7-sv-h-1.11-b-v1','1.11','a14517793832f66855351c9a265a60b7'),
('apcalcab-mcq-b7-sv-h-1.11-b-v2','1.11','0c9bdcfde012f932a08c0779dfeb55dc'),
('apcalcab-mcq-b7-sv-h-1.11-b-v3','1.11','c9edc3fbea08f54eb6ce49f0bb5965f1'),
('apcalcab-mcq-b7-h-1.12-a','1.12','7ed60201f901682dffddb468a4c51ce2'),
('apcalcab-mcq-b7-sv-h-1.12-a-v1','1.12','b97c1028d3f08008671a32726b52de20'),
('apcalcab-mcq-b7-sv-h-1.12-a-v2','1.12','05271f6053e5a443028758bf4efa3958'),
('apcalcab-mcq-b7-sv-h-1.12-a-v3','1.12','838a91cdcab58189add8a411bb3c53ed'),
('apcalcab-mcq-b7-h-1.12-b','1.12','e21603bb7b15ae9af5334df43e33c90c'),
('apcalcab-mcq-b7-sv-h-1.12-b-v1','1.12','c53219276eb1a3f4086af3625c029a96'),
('apcalcab-mcq-b7-sv-h-1.12-b-v2','1.12','e52d934c49af5f8c8bb37c145da07d67'),
('apcalcab-mcq-b7-sv-h-1.12-b-v3','1.12','51d9f8dc05fc7895af5493e8f1ff17c5'),
('apcalcab-mcq-b7-h-1.13-a','1.13','bd201bd3e8508c08208ea88facd3344c'),
('apcalcab-mcq-b7-sv-h-1.13-a-v1','1.13','1834715435102668b06059bce1a0c6f2'),
('apcalcab-mcq-b7-sv-h-1.13-a-v2','1.13','ae7509ec5411b8c0cd6dcceefea63f3e'),
('apcalcab-mcq-b7-sv-h-1.13-a-v3','1.13','56ed6cfb1ef0cabd72593d72fc9a2332'),
('apcalcab-mcq-b7-h-1.13-b','1.13','a6e922733ca267ad2a7187c62cb907c1'),
('apcalcab-mcq-b7-sv-h-1.13-b-v1','1.13','4cda116246fd60207da9a4b0cda6b812'),
('apcalcab-mcq-b7-sv-h-1.13-b-v2','1.13','f71750ee04a22642a9eed446e1a9ea3f'),
('apcalcab-mcq-b7-sv-h-1.13-b-v3','1.13','0cf235f0dc68c294d029dfe113a377d6'),
('apcalcab-mcq-b7-h-1.14-a','1.14','5a0c8c3106c5770729bff534d0c445d0'),
('apcalcab-mcq-b7-sv-h-1.14-a-v1','1.14','312213c51a3000e991b071a2ef9e82a7'),
('apcalcab-mcq-b7-sv-h-1.14-a-v2','1.14','c1c92562fc46ffbe7306cb01a8c79a42'),
('apcalcab-mcq-b7-sv-h-1.14-a-v3','1.14','eadfd47c587ed96d0c5d1ed881b8220f'),
('apcalcab-mcq-b7-h-1.14-b','1.14','bcde4e4028a548e96337c8787205137a'),
('apcalcab-mcq-b7-sv-h-1.14-b-v1','1.14','9aade9930b54864d36d0634b17606916'),
('apcalcab-mcq-b7-sv-h-1.14-b-v2','1.14','fe8715eb318a608e40f0857428b7243b'),
('apcalcab-mcq-b7-sv-h-1.14-b-v3','1.14','2dd5853b6de5c6656dc6b1c7423c9a41'),
('apcalcab-mcq-b7-h-1.15-a','1.15','fe7786633f375cc27101ac3e34f4dbf8'),
('apcalcab-mcq-b7-sv-h-1.15-a-v1','1.15','7c63ee9cc74cea96cb53b9adf838aca7'),
('apcalcab-mcq-b7-sv-h-1.15-a-v2','1.15','cb6d58be8630eeb8c6f9341050bdff7e'),
('apcalcab-mcq-b7-sv-h-1.15-a-v3','1.15','47ff74296c3059440d7c96f323f495d9'),
('apcalcab-mcq-b7-h-1.15-b','1.15','f86378eee7836c277f0bf1fb581623cc'),
('apcalcab-mcq-b7-sv-h-1.15-b-v1','1.15','6ee1edeb3e47b21e963365174f64005e'),
('apcalcab-mcq-b7-sv-h-1.15-b-v2','1.15','f24da165fe16a8810a79b7849bf147c8'),
('apcalcab-mcq-b7-sv-h-1.15-b-v3','1.15','6a465c54aaf01e4fffbbedb9dfb91ca9'),
('apcalcab-mcq-b7-h-1.16-a','1.16','d73a103dfbb6f76d18e5679a1c7a5e7c'),
('apcalcab-mcq-b7-sv-h-1.16-a-v1','1.16','b1fbaa32bf8d52107eaf7d8f15a6e0ae'),
('apcalcab-mcq-b7-sv-h-1.16-a-v2','1.16','49acb258ab0ed1a24f516eee2dc4cbf5'),
('apcalcab-mcq-b7-sv-h-1.16-a-v3','1.16','d4c9055900d157ce6c9ad10679e206e0'),
('apcalcab-mcq-b7-h-1.16-b','1.16','3492d5f73ff331b8bdbfb93f05c9d0d1'),
('apcalcab-mcq-b7-sv-h-1.16-b-v1','1.16','005995c99b9bfd66ae2e709ac742f5e0'),
('apcalcab-mcq-b7-sv-h-1.16-b-v2','1.16','b517205599998198ce4f47b0089c9e49'),
('apcalcab-mcq-b7-sv-h-1.16-b-v3','1.16','8a14b73a448440d3d81c0a38320f7561');
create temporary table tgt on commit drop as
select l.*, ci.id item_id, civ.id version_id, gen_random_uuid() assignment_id, gen_random_uuid() label_id, gen_random_uuid() vd_id,
 '33b4408b-0ecc-4c7a-b0b1-612db81164a1'::uuid tsv, (case topic when '1.1' then array[1] when '1.10' then array[1] when '1.11' then array[1] when '1.12' then array[1] when '1.13' then array[1] when '1.14' then array[1] when '1.15' then array[1] when '1.16' then array[1] when '1.2' then array[1] when '1.3' then array[1] when '1.4' then array[1] when '1.5' then array[1] when '1.6' then array[1] when '1.7' then array[1] when '1.8' then array[1] when '1.9' then array[1] end)::int[] req, 1 pu
from lab l join app.content_items ci on ci.content_key=l.content_key and ci.exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d'
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
 'AP Calculus AB Unit 3 harder seeds and variants (batch apcalcab_u1b_2026_11_12): Product Owner review of owner-session-authored drafts, 2026-11-12. Arithmetic verified in Python; no model-checker pass, by Product Owner decision.',
 'approve',
 jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apcalcab_u1b_2026_11_12_po_approval','qa_date','2026-11-12','content_key',content_key),
 md5(jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apcalcab_u1b_2026_11_12_po_approval','qa_date','2026-11-12','content_key',content_key)::text),
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
 'apcalcab_u1b_2026_11_12',
 jsonb_build_object('origin','owner_authored','units_source','AP Calculus AB Unit 1 (topics 1.x belong to unit 3; required_units set per topic from existing Unit 3 labels)','topic',topic,'report','scripts/content-seed/apchem-harder-seeds-u3-2026-11-12'),
 'apcalcab-u1b-2026-11-12-labeling', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
insert into app.content_taxonomy_validation_decisions (validation_decision_id, content_taxonomy_label_id, decided_by, decision, decision_source, reviewed_primary_unit, reviewed_required_units, notes)
select vd_id, label_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'confirmed', 'chat_review', pu, req,
 'Product Owner chat instruction 2026-11-12 (AP Calculus AB harder seeds and variants). Topic assigned by the author from the question design (topic recorded on the cell); topic-only tagging, skill left null.' from tgt;
insert into app.content_item_cells (content_item_version_id, content_item_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id, validated_by, validated_at, validation_decision_id)
select version_id, item_id, tsv, topic, null, true, 'validated', 'apcalcab_u1b_2026_11_12_topic',
 'apcalcab-u1b-2026-11-12-labeling (topic set by the author from the question design)', null, now(), gen_random_uuid() from tgt;
update app.content_taxonomy_labels l set label_status='validated', validated_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, validated_at=now(), validation_decision_id=t.vd_id, validated_against_version_id=t.version_id, validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id) from tgt t where l.content_taxonomy_label_id=t.label_id;
update app.content_item_versions civ set status='published', published_at=coalesce(civ.published_at,now()), updated_at=now() from tgt where civ.id=tgt.version_id;
update app.content_items ci set status='published', updated_at=now() from tgt where ci.id=tgt.item_id;
do $$ declare n int; begin
  select count(*) into n from (select content_item_id from app.content_item_versions where status='published' group by 1 having count(*)>1) d; if n<>0 then raise exception 'duplicate published versions: %', n; end if;
  if (select count(*) from app.content_items ci join tgt on tgt.item_id=ci.id where ci.status='published')<>64 then raise exception 'publish count mismatch'; end if;
  select count(*) into n from app.content_taxonomy_labels l join tgt t on t.item_id=l.content_item_id where l.label_scope='serving' and l.superseded_by is null and l.label_status='validated' and l.validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id); if n<>64 then raise exception 'label post-check %', n; end if;
  select count(*) into n from app.content_item_cells where source='apcalcab_u1b_2026_11_12_topic' and is_primary and superseded_by is null; if n<>64 then raise exception 'topic cell count %', n; end if;
end $$;
select (select count(*) from tgt) published, (select count(*) from app.content_taxonomy_labels where source='apcalcab_u1b_2026_11_12' and label_status='validated') validated_labels, (select count(*) from app.content_item_cells where source='apcalcab_u1b_2026_11_12_topic') topic_cells;
commit;
