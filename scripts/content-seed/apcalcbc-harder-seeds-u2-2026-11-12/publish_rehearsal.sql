begin;
select pg_advisory_xact_lock(hashtext('cramapple-apcalcbc-u2-2026-11-12-publish-20261112'));
create temporary table lab (content_key text primary key, topic text, exp_hash text) on commit drop;
insert into lab values
('apcalcbc-mcq-b5-h-2.1-a','2.1','3bd2a4b14e92f96ec0b0cf91915142d0'),
('apcalcbc-mcq-b5-sv-h-2.1-a-v1','2.1','2712fda795d3d1d61a5d59bec4cd3375'),
('apcalcbc-mcq-b5-sv-h-2.1-a-v2','2.1','b6ed5273ed09ca6b1ebd2ec75f2453a2'),
('apcalcbc-mcq-b5-sv-h-2.1-a-v3','2.1','e712e82dee3e8502964014e71623f4a1'),
('apcalcbc-mcq-b5-h-2.1-b','2.1','fa0583091ae3f7eefa0733ca6ce812ea'),
('apcalcbc-mcq-b5-sv-h-2.1-b-v1','2.1','8d1a70d5e39141f7d657b7782c83d080'),
('apcalcbc-mcq-b5-sv-h-2.1-b-v2','2.1','4d18b2c845d2ae4a3f9d68f2b407884b'),
('apcalcbc-mcq-b5-sv-h-2.1-b-v3','2.1','8ae75e146cab2554763b1ed95c5a25b9'),
('apcalcbc-mcq-b5-h-2.2-a','2.2','0467f94b82e8af28208364127130cd2a'),
('apcalcbc-mcq-b5-sv-h-2.2-a-v1','2.2','5e48e92f0d5a46ff6ebe91afe34ee4b2'),
('apcalcbc-mcq-b5-sv-h-2.2-a-v2','2.2','25a797eb14b5cb89195f6eff9034e33d'),
('apcalcbc-mcq-b5-sv-h-2.2-a-v3','2.2','522595282313ae05953aaed998b0e915'),
('apcalcbc-mcq-b5-h-2.2-b','2.2','d8d488429a1425e65b902191d99e96c6'),
('apcalcbc-mcq-b5-sv-h-2.2-b-v1','2.2','f7c5f5ec351b0ec31e711b39ffd52afe'),
('apcalcbc-mcq-b5-sv-h-2.2-b-v2','2.2','376142b3e768002def4beaee585771ae'),
('apcalcbc-mcq-b5-sv-h-2.2-b-v3','2.2','ca57955cbe915475fc898dcb7808e7ac'),
('apcalcbc-mcq-b5-h-2.3-a','2.3','ac19d52139df7d42ef49b898d84fcd35'),
('apcalcbc-mcq-b5-sv-h-2.3-a-v1','2.3','9a54d14a6d42a69e6046332f65470b2d'),
('apcalcbc-mcq-b5-sv-h-2.3-a-v2','2.3','fae44cacaf95ed50f92b53ecbac33056'),
('apcalcbc-mcq-b5-sv-h-2.3-a-v3','2.3','9ce73db766f7ebce8438e5cb80b0074a'),
('apcalcbc-mcq-b5-h-2.3-b','2.3','c2864e148a406a9f085596103767d6cc'),
('apcalcbc-mcq-b5-sv-h-2.3-b-v1','2.3','2faba7098e0b7cebef60dff6f77e8129'),
('apcalcbc-mcq-b5-sv-h-2.3-b-v2','2.3','873f4e105ba938fb3dc9d0aed72687ee'),
('apcalcbc-mcq-b5-sv-h-2.3-b-v3','2.3','1d3e9df62c6bc45bc4f117a792b52030'),
('apcalcbc-mcq-b5-h-2.4-a','2.4','6cfc824f96c4277ffb098a420ea0167a'),
('apcalcbc-mcq-b5-sv-h-2.4-a-v1','2.4','7b63d1800d5b078959585207f01ec545'),
('apcalcbc-mcq-b5-sv-h-2.4-a-v2','2.4','457710322925d0356ae44916b1f95050'),
('apcalcbc-mcq-b5-sv-h-2.4-a-v3','2.4','39356d2098c66a452e144dc071928f9d'),
('apcalcbc-mcq-b5-h-2.4-b','2.4','5ed1d8c00675cdd655748c2d3c910ab5'),
('apcalcbc-mcq-b5-sv-h-2.4-b-v1','2.4','1bc4bd2c1797a932cf6a5ff4640ed877'),
('apcalcbc-mcq-b5-sv-h-2.4-b-v2','2.4','7fd9e166cc65ee917f1c91a0eb51adc2'),
('apcalcbc-mcq-b5-sv-h-2.4-b-v3','2.4','1a96ffdd19001a0a2bb2fefafe7bc6b4'),
('apcalcbc-mcq-b5-h-2.5-a','2.5','85dfb8423ea905479ab421fa6763ee6a'),
('apcalcbc-mcq-b5-sv-h-2.5-a-v1','2.5','8299fbef416bac89b11c162af516143a'),
('apcalcbc-mcq-b5-sv-h-2.5-a-v2','2.5','509d74201c1ab11d323b793f7f75c1d9'),
('apcalcbc-mcq-b5-sv-h-2.5-a-v3','2.5','817a1e0e6301399f4076a5874d198e6f'),
('apcalcbc-mcq-b5-h-2.5-b','2.5','deca9b1f454b70972855fb82b8b5d55e'),
('apcalcbc-mcq-b5-sv-h-2.5-b-v1','2.5','b131439b57226ec29a47c7e466a7ecc1'),
('apcalcbc-mcq-b5-sv-h-2.5-b-v2','2.5','c443b7627e03a4084d07c3279e88915c'),
('apcalcbc-mcq-b5-sv-h-2.5-b-v3','2.5','7f25179b4cef9bd4414c59a4a53747e2'),
('apcalcbc-mcq-b5-h-2.6-a','2.6','2c21d8973e85eedeed8908af704220a8'),
('apcalcbc-mcq-b5-sv-h-2.6-a-v1','2.6','d5d6c16921261a2fc76417c9da02682e'),
('apcalcbc-mcq-b5-sv-h-2.6-a-v2','2.6','42a679b26c2bbd2e1b3f8e1ee1817fac'),
('apcalcbc-mcq-b5-sv-h-2.6-a-v3','2.6','8bb271f226abcb9aab91b17a61c28ba3'),
('apcalcbc-mcq-b5-h-2.6-b','2.6','3b9fe91f556aed66a1bf99d338b0ca43'),
('apcalcbc-mcq-b5-sv-h-2.6-b-v1','2.6','95ac81249cf0b03da3b12df4b2128d4f'),
('apcalcbc-mcq-b5-sv-h-2.6-b-v2','2.6','9616bf4c6cee78e866ba57f798e395aa'),
('apcalcbc-mcq-b5-sv-h-2.6-b-v3','2.6','adabf03a686fdca82161272755631713'),
('apcalcbc-mcq-b5-h-2.7-a','2.7','d481e6b57372f135491f6da79d8b19f7'),
('apcalcbc-mcq-b5-sv-h-2.7-a-v1','2.7','17789d287a352f858a860d25e2434a33'),
('apcalcbc-mcq-b5-sv-h-2.7-a-v2','2.7','3e20b1f9a5dcda0aa7ab1ea2b3c6bec7'),
('apcalcbc-mcq-b5-sv-h-2.7-a-v3','2.7','6ccc3f37ca90db0bf34f3910dcaaf4ba'),
('apcalcbc-mcq-b5-h-2.7-b','2.7','06c7d77415b2173fd453ae97e046dbca'),
('apcalcbc-mcq-b5-sv-h-2.7-b-v1','2.7','1df14b16b1778d1280d95e2cafcab7b8'),
('apcalcbc-mcq-b5-sv-h-2.7-b-v2','2.7','77f2ae20da03a6379515a42d8f86a3ab'),
('apcalcbc-mcq-b5-sv-h-2.7-b-v3','2.7','a47e32ac822769057d4e644ef4f526e1'),
('apcalcbc-mcq-b5-h-2.8-a','2.8','aca23db3703a6649bfbd537f200706ad'),
('apcalcbc-mcq-b5-sv-h-2.8-a-v1','2.8','6a47e3a56df0ea7e4823399b1b65a487'),
('apcalcbc-mcq-b5-sv-h-2.8-a-v2','2.8','065f6d39d3a00d0c98d202030dd4bb62'),
('apcalcbc-mcq-b5-sv-h-2.8-a-v3','2.8','5f48808e1c005b7e9b1892ae9f147046'),
('apcalcbc-mcq-b5-h-2.8-b','2.8','6c62e329ca4979f3cc6ed746f470acec'),
('apcalcbc-mcq-b5-sv-h-2.8-b-v1','2.8','ad5c92c340d331a70969feb8bbe0ff41'),
('apcalcbc-mcq-b5-sv-h-2.8-b-v2','2.8','cea8bbddf495f0e15d9a256dc778458b'),
('apcalcbc-mcq-b5-sv-h-2.8-b-v3','2.8','5eb710cd760bce787357f866b913c9d3'),
('apcalcbc-mcq-b5-h-2.9-a','2.9','b222a61581e1a8014fc7d1a374b6ee19'),
('apcalcbc-mcq-b5-sv-h-2.9-a-v1','2.9','8f78239692a048b49bb85b035226786b'),
('apcalcbc-mcq-b5-sv-h-2.9-a-v2','2.9','87bfcf207816b992934995681cb59325'),
('apcalcbc-mcq-b5-sv-h-2.9-a-v3','2.9','56c41e2bd822ff05bb8b96dc5a0b35dd'),
('apcalcbc-mcq-b5-h-2.9-b','2.9','5572225f2ae8579c77d0799d2692e75d'),
('apcalcbc-mcq-b5-sv-h-2.9-b-v1','2.9','7608f8d51d89245f1ff11f679b945702'),
('apcalcbc-mcq-b5-sv-h-2.9-b-v2','2.9','fee12f508ec04f91cc1f2d08afb61233'),
('apcalcbc-mcq-b5-sv-h-2.9-b-v3','2.9','a86e412f0f73cc09b432500436be1fb0'),
('apcalcbc-mcq-b5-h-2.10-a','2.10','316b9ee39d5ee6ce7798dd500aafd09a'),
('apcalcbc-mcq-b5-sv-h-2.10-a-v1','2.10','7f6fa00dd4475a69171bbba07239648c'),
('apcalcbc-mcq-b5-sv-h-2.10-a-v2','2.10','45a44e4bf2ac8cb1f45a6c1e6b20eba3'),
('apcalcbc-mcq-b5-sv-h-2.10-a-v3','2.10','4a3a3786086c55d0d26b3569e2f6e8c4'),
('apcalcbc-mcq-b5-h-2.10-b','2.10','9cb433f10bd3406ba91055c3f29c82af'),
('apcalcbc-mcq-b5-sv-h-2.10-b-v1','2.10','ad4e14e5adbba085ba51dd3d52fd383b'),
('apcalcbc-mcq-b5-sv-h-2.10-b-v2','2.10','57f75d2b0f9432968dff5b152d11e12c'),
('apcalcbc-mcq-b5-sv-h-2.10-b-v3','2.10','5e6695df39517ffc6b613619e14a756a');
create temporary table tgt on commit drop as
select l.*, ci.id item_id, civ.id version_id, gen_random_uuid() assignment_id, gen_random_uuid() label_id, gen_random_uuid() vd_id,
 'ab088009-dc9a-4f93-8824-803e1913505b'::uuid tsv, (case topic when '2.1' then array[2] when '2.10' then array[2] when '2.2' then array[2] when '2.3' then array[2] when '2.4' then array[1, 2] when '2.5' then array[2] when '2.6' then array[2] when '2.7' then array[2] when '2.8' then array[2] when '2.9' then array[2] end)::int[] req, 2 pu
from lab l join app.content_items ci on ci.content_key=l.content_key and ci.exam_pack_version_id='3778d753-273a-403d-8f02-55dc64ec6a27'
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
 'AP Calculus BC Unit 3 harder seeds and variants (batch apcalcbc_u2_2026_11_12): Product Owner review of owner-session-authored drafts, 2026-11-12. Arithmetic verified in Python; no model-checker pass, by Product Owner decision.',
 'approve',
 jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apcalcbc_u2_2026_11_12_po_approval','qa_date','2026-11-12','content_key',content_key),
 md5(jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apcalcbc_u2_2026_11_12_po_approval','qa_date','2026-11-12','content_key',content_key)::text),
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
 'apcalcbc_u2_2026_11_12',
 jsonb_build_object('origin','owner_authored','units_source','AP Calculus BC Unit 2 (topics 2.x belong to unit 3; required_units set per topic from existing Unit 3 labels)','topic',topic,'report','scripts/content-seed/apchem-harder-seeds-u3-2026-11-12'),
 'apcalcbc-u2-2026-11-12-labeling', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
insert into app.content_taxonomy_validation_decisions (validation_decision_id, content_taxonomy_label_id, decided_by, decision, decision_source, reviewed_primary_unit, reviewed_required_units, notes)
select vd_id, label_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'confirmed', 'chat_review', pu, req,
 'Product Owner chat instruction 2026-11-12 (AP Calculus BC harder seeds and variants). Topic assigned by the author from the question design (topic recorded on the cell); topic-only tagging, skill left null.' from tgt;
insert into app.content_item_cells (content_item_version_id, content_item_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id, validated_by, validated_at, validation_decision_id)
select version_id, item_id, tsv, topic, null, true, 'validated', 'apcalcbc_u2_2026_11_12_topic',
 'apcalcbc-u2-2026-11-12-labeling (topic set by the author from the question design)', null, now(), gen_random_uuid() from tgt;
update app.content_taxonomy_labels l set label_status='validated', validated_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, validated_at=now(), validation_decision_id=t.vd_id, validated_against_version_id=t.version_id, validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id) from tgt t where l.content_taxonomy_label_id=t.label_id;
update app.content_item_versions civ set status='published', published_at=coalesce(civ.published_at,now()), updated_at=now() from tgt where civ.id=tgt.version_id;
update app.content_items ci set status='published', updated_at=now() from tgt where ci.id=tgt.item_id;
do $$ declare n int; begin
  select count(*) into n from (select content_item_id from app.content_item_versions where status='published' group by 1 having count(*)>1) d; if n<>0 then raise exception 'duplicate published versions: %', n; end if;
  if (select count(*) from app.content_items ci join tgt on tgt.item_id=ci.id where ci.status='published')<>80 then raise exception 'publish count mismatch'; end if;
  select count(*) into n from app.content_taxonomy_labels l join tgt t on t.item_id=l.content_item_id where l.label_scope='serving' and l.superseded_by is null and l.label_status='validated' and l.validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id); if n<>80 then raise exception 'label post-check %', n; end if;
  select count(*) into n from app.content_item_cells where source='apcalcbc_u2_2026_11_12_topic' and is_primary and superseded_by is null; if n<>80 then raise exception 'topic cell count %', n; end if;
end $$;
do $$ begin raise exception 'REHEARSAL OK (rolled back): published=%, validated_labels=%, topic_cells=%', (select count(*) from tgt), (select count(*) from app.content_taxonomy_labels where source='apcalcbc_u2_2026_11_12' and label_status='validated'), (select count(*) from app.content_item_cells where source='apcalcbc_u2_2026_11_12_topic'); end $$;
rollback;
