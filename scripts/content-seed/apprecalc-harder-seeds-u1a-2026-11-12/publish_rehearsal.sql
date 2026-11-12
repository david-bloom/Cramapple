begin;
select pg_advisory_xact_lock(hashtext('cramapple-apprecalc-u1a-2026-11-12-publish-20261112'));
create temporary table lab (content_key text primary key, topic text, exp_hash text) on commit drop;
insert into lab values
('apprecalc-mcq-b10-h-1.1-a','1.1','ac8521d71e52d4eddaa9cd092c1822b3'),
('apprecalc-mcq-b10-sv-h-1.1-a-v1','1.1','f3fe64b092b607150656c941378e9f27'),
('apprecalc-mcq-b10-sv-h-1.1-a-v2','1.1','51e2a96920a13494bf81a41b35d8039e'),
('apprecalc-mcq-b10-sv-h-1.1-a-v3','1.1','fc70f85a31b29360d7dccd85a8922009'),
('apprecalc-mcq-b10-h-1.1-b','1.1','63916981e584fff37266b0a31551178f'),
('apprecalc-mcq-b10-sv-h-1.1-b-v1','1.1','be062e304356028362ff7e3c9d51bf32'),
('apprecalc-mcq-b10-sv-h-1.1-b-v2','1.1','63dafa8e2dbe94926690b3c6209590ff'),
('apprecalc-mcq-b10-sv-h-1.1-b-v3','1.1','8ced83ce0f68bd785dad5a6d104c648c'),
('apprecalc-mcq-b10-h-1.2-a','1.2','932d47b8a9f8b1020aba3b792a10b93b'),
('apprecalc-mcq-b10-sv-h-1.2-a-v1','1.2','1bfb586f6484aa7bc672cb439e2e8c31'),
('apprecalc-mcq-b10-sv-h-1.2-a-v2','1.2','63be1aa908ce0b3fd74c46fbcad68265'),
('apprecalc-mcq-b10-sv-h-1.2-a-v3','1.2','59f1312b6d343c8e05459609f8d3809c'),
('apprecalc-mcq-b10-h-1.2-b','1.2','ddf5fa310c5c2c0275b08a845134076c'),
('apprecalc-mcq-b10-sv-h-1.2-b-v1','1.2','392f5f8946ab9f8fc1b0e49eef489f8e'),
('apprecalc-mcq-b10-sv-h-1.2-b-v2','1.2','73025ef61e15a7f8a004685ee4f96ca2'),
('apprecalc-mcq-b10-sv-h-1.2-b-v3','1.2','a45a7f667f2faa8ebeb8854bd3285435'),
('apprecalc-mcq-b10-h-1.3-a','1.3','ac465fdd02540f2cbd0bdac993c66f10'),
('apprecalc-mcq-b10-sv-h-1.3-a-v1','1.3','04b198832d09c4ef835857066109ef24'),
('apprecalc-mcq-b10-sv-h-1.3-a-v2','1.3','369bfe7b8f50c13d73b3476a2db71ffe'),
('apprecalc-mcq-b10-sv-h-1.3-a-v3','1.3','a76abab35e9ed644cf3c3b97f3a9cfd4'),
('apprecalc-mcq-b10-h-1.3-b','1.3','267b63bd5e516be47bc3860295b7644d'),
('apprecalc-mcq-b10-sv-h-1.3-b-v1','1.3','7d009d808f5c0d99635a04a614976eff'),
('apprecalc-mcq-b10-sv-h-1.3-b-v2','1.3','dbd8d5494f61bee463517bb0ca4d7e39'),
('apprecalc-mcq-b10-sv-h-1.3-b-v3','1.3','58b2c53f1b19bb3ef1511baf46b4b5c1'),
('apprecalc-mcq-b10-h-1.4-a','1.4','57a4b17f49134459bb43709165f05d42'),
('apprecalc-mcq-b10-sv-h-1.4-a-v1','1.4','e172f8fe06f85acbe52cba4469f2c9dc'),
('apprecalc-mcq-b10-sv-h-1.4-a-v2','1.4','acda23336c336b24b092694dc4761475'),
('apprecalc-mcq-b10-sv-h-1.4-a-v3','1.4','d5a3737b49d6a5467e627d31b99b6201'),
('apprecalc-mcq-b10-h-1.4-b','1.4','2c066008063b9ac37d818a829f6d26c2'),
('apprecalc-mcq-b10-sv-h-1.4-b-v1','1.4','a88ca8997a4063a20fcfc8524c785e30'),
('apprecalc-mcq-b10-sv-h-1.4-b-v2','1.4','865cfecce3adf5cdb77c48839a841343'),
('apprecalc-mcq-b10-sv-h-1.4-b-v3','1.4','0eeffa816f53a0cb205e1d51eb421eb4'),
('apprecalc-mcq-b10-h-1.5-a','1.5','39698882f5be601e368687e225e45406'),
('apprecalc-mcq-b10-sv-h-1.5-a-v1','1.5','05e53109bc52c1e754c461f31591b25f'),
('apprecalc-mcq-b10-sv-h-1.5-a-v2','1.5','ca5abc5aadf847005e719e98e4b10bb5'),
('apprecalc-mcq-b10-sv-h-1.5-a-v3','1.5','42b1e9bd90d4823382c7ed26496f0071'),
('apprecalc-mcq-b10-h-1.5-b','1.5','11e6831bd04c39e136d6508f2284cad8'),
('apprecalc-mcq-b10-sv-h-1.5-b-v1','1.5','fea39ecf2ed1dab75c2e5df984be4a8d'),
('apprecalc-mcq-b10-sv-h-1.5-b-v2','1.5','b6283880f3abd3096ef98d0e446ba49d'),
('apprecalc-mcq-b10-sv-h-1.5-b-v3','1.5','03d85297070019bd01736730bfd98d1d'),
('apprecalc-mcq-b10-h-1.6-a','1.6','96c6552a481a2214aa23428888366cce'),
('apprecalc-mcq-b10-sv-h-1.6-a-v1','1.6','ded0666ddca0f832af73b6ef8d2d0d29'),
('apprecalc-mcq-b10-sv-h-1.6-a-v2','1.6','65a999726416de242c78bddef6044fc4'),
('apprecalc-mcq-b10-sv-h-1.6-a-v3','1.6','1655a9ee223af404a0c41be1dce59cea'),
('apprecalc-mcq-b10-h-1.6-b','1.6','bd9d113ee4c47dd8d5f71b90da0b3ab4'),
('apprecalc-mcq-b10-sv-h-1.6-b-v1','1.6','f0859e25fffabdde803d328cb5270e20'),
('apprecalc-mcq-b10-sv-h-1.6-b-v2','1.6','8b4540a61b6a0d0e0381ee86e52ec55c'),
('apprecalc-mcq-b10-sv-h-1.6-b-v3','1.6','8da1fac7116bf4098d123e6fef042afb'),
('apprecalc-mcq-b10-h-1.7-a','1.7','b98c4fef1ca9b49c03bb26814543c22c'),
('apprecalc-mcq-b10-sv-h-1.7-a-v1','1.7','047653525ffd520fbecaa3f5645d4782'),
('apprecalc-mcq-b10-sv-h-1.7-a-v2','1.7','86428d6057730da2e060659b6fd2a9e7'),
('apprecalc-mcq-b10-sv-h-1.7-a-v3','1.7','42958e17e8de79e594a853dc059d2e0f'),
('apprecalc-mcq-b10-h-1.7-b','1.7','23813946aa53dd0affc87ff7497157ed'),
('apprecalc-mcq-b10-sv-h-1.7-b-v1','1.7','0cdf63b4978115dfab5a2f51d5161caf'),
('apprecalc-mcq-b10-sv-h-1.7-b-v2','1.7','630917ce07c947029ba47998440820d1'),
('apprecalc-mcq-b10-sv-h-1.7-b-v3','1.7','be14117b39edddfa808db327fd15ab5c');
create temporary table tgt on commit drop as
select l.*, ci.id item_id, civ.id version_id, gen_random_uuid() assignment_id, gen_random_uuid() label_id, gen_random_uuid() vd_id,
 '16383753-6775-430d-960a-544cd6ee0972'::uuid tsv, (case topic when '1.1' then array[1] when '1.10' then array[1] when '1.11' then array[1] when '1.12' then array[1] when '1.13' then array[1] when '1.14' then array[1] when '1.2' then array[1] when '1.3' then array[1] when '1.4' then array[1] when '1.5' then array[1] when '1.6' then array[1] when '1.7' then array[1] when '1.8' then array[1] when '1.9' then array[1] end)::int[] req, 1 pu
from lab l join app.content_items ci on ci.content_key=l.content_key and ci.exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db'
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
 'AP Precalculus Unit 3 harder seeds and variants (batch apprecalc_u1a_2026_11_12): Product Owner review of owner-session-authored drafts, 2026-11-12. Arithmetic verified in Python; no model-checker pass, by Product Owner decision.',
 'approve',
 jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apprecalc_u1a_2026_11_12_po_approval','qa_date','2026-11-12','content_key',content_key),
 md5(jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apprecalc_u1a_2026_11_12_po_approval','qa_date','2026-11-12','content_key',content_key)::text),
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
 'apprecalc_u1a_2026_11_12',
 jsonb_build_object('origin','owner_authored','units_source','AP Precalculus Unit 1 (topics 1.x belong to unit 3; required_units set per topic from existing Unit 3 labels)','topic',topic,'report','scripts/content-seed/apchem-harder-seeds-u3-2026-11-12'),
 'apprecalc-u1a-2026-11-12-labeling', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
insert into app.content_taxonomy_validation_decisions (validation_decision_id, content_taxonomy_label_id, decided_by, decision, decision_source, reviewed_primary_unit, reviewed_required_units, notes)
select vd_id, label_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'confirmed', 'chat_review', pu, req,
 'Product Owner chat instruction 2026-11-12 (AP Precalculus harder seeds and variants). Topic assigned by the author from the question design (topic recorded on the cell); topic-only tagging, skill left null.' from tgt;
insert into app.content_item_cells (content_item_version_id, content_item_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id, validated_by, validated_at, validation_decision_id)
select version_id, item_id, tsv, topic, null, true, 'validated', 'apprecalc_u1a_2026_11_12_topic',
 'apprecalc-u1a-2026-11-12-labeling (topic set by the author from the question design)', null, now(), gen_random_uuid() from tgt;
update app.content_taxonomy_labels l set label_status='validated', validated_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, validated_at=now(), validation_decision_id=t.vd_id, validated_against_version_id=t.version_id, validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id) from tgt t where l.content_taxonomy_label_id=t.label_id;
update app.content_item_versions civ set status='published', published_at=coalesce(civ.published_at,now()), updated_at=now() from tgt where civ.id=tgt.version_id;
update app.content_items ci set status='published', updated_at=now() from tgt where ci.id=tgt.item_id;
do $$ declare n int; begin
  select count(*) into n from (select content_item_id from app.content_item_versions where status='published' group by 1 having count(*)>1) d; if n<>0 then raise exception 'duplicate published versions: %', n; end if;
  if (select count(*) from app.content_items ci join tgt on tgt.item_id=ci.id where ci.status='published')<>56 then raise exception 'publish count mismatch'; end if;
  select count(*) into n from app.content_taxonomy_labels l join tgt t on t.item_id=l.content_item_id where l.label_scope='serving' and l.superseded_by is null and l.label_status='validated' and l.validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id); if n<>56 then raise exception 'label post-check %', n; end if;
  select count(*) into n from app.content_item_cells where source='apprecalc_u1a_2026_11_12_topic' and is_primary and superseded_by is null; if n<>56 then raise exception 'topic cell count %', n; end if;
end $$;
do $$ begin raise exception 'REHEARSAL OK (rolled back): published=%, validated_labels=%, topic_cells=%', (select count(*) from tgt), (select count(*) from app.content_taxonomy_labels where source='apprecalc_u1a_2026_11_12' and label_status='validated'), (select count(*) from app.content_item_cells where source='apprecalc_u1a_2026_11_12_topic'); end $$;
rollback;
