begin;
select pg_advisory_xact_lock(hashtext('cramapple-apphysics1-u2-2026-11-12-publish-20261112'));
create temporary table lab (content_key text primary key, topic text, exp_hash text) on commit drop;
insert into lab values
('apphysics1-mcq-b5-h-2.1-a','2.1','933e3c43170c71975f16c896874e1006'),
('apphysics1-mcq-b5-sv-h-2.1-a-v1','2.1','7e55d2c92da3c71a391f6af16cdbb572'),
('apphysics1-mcq-b5-sv-h-2.1-a-v2','2.1','7cbdfd5f9fa0ada7c1545398dd77a0a3'),
('apphysics1-mcq-b5-sv-h-2.1-a-v3','2.1','15769f9e91cf3c9bb73ebd9c58168ac2'),
('apphysics1-mcq-b5-h-2.1-b','2.1','9fcd2d324f6ace77b40f99d717e89b1b'),
('apphysics1-mcq-b5-sv-h-2.1-b-v1','2.1','ccbd524d8b4af4173ea31532dc0605a4'),
('apphysics1-mcq-b5-sv-h-2.1-b-v2','2.1','bf6af650bbabeb37d57d75603118b180'),
('apphysics1-mcq-b5-sv-h-2.1-b-v3','2.1','b4f85a264b3e95d30178a0d019f28e4a'),
('apphysics1-mcq-b5-h-2.2-a','2.2','00022b35b3d032770e29b78ac076fd6a'),
('apphysics1-mcq-b5-sv-h-2.2-a-v1','2.2','9e5fb175f682182252a9e6102c66119c'),
('apphysics1-mcq-b5-sv-h-2.2-a-v2','2.2','a04e52b67371f25fc59ddf5dee191614'),
('apphysics1-mcq-b5-sv-h-2.2-a-v3','2.2','43737ced194886fcddd9f9cb919b3278'),
('apphysics1-mcq-b5-h-2.2-b','2.2','c841986eebcaa4f1989102a9531744df'),
('apphysics1-mcq-b5-sv-h-2.2-b-v1','2.2','c063286a3884824e31db2f5e238b335c'),
('apphysics1-mcq-b5-sv-h-2.2-b-v2','2.2','cced3ddd6dc56a465b0a3c2be4873011'),
('apphysics1-mcq-b5-sv-h-2.2-b-v3','2.2','9565fbda318d004489d451108e5b73a4'),
('apphysics1-mcq-b5-h-2.3-a','2.3','9291e5f4815b7f64e393166822261685'),
('apphysics1-mcq-b5-sv-h-2.3-a-v1','2.3','9dcdbf9a67ba2ecfcba9ab8966775d79'),
('apphysics1-mcq-b5-sv-h-2.3-a-v2','2.3','57fbd01f27fcca586a58d89ad60c99e0'),
('apphysics1-mcq-b5-sv-h-2.3-a-v3','2.3','1b06e0f008d0e94afcb84fc557eaade6'),
('apphysics1-mcq-b5-h-2.3-b','2.3','60aa01889f7809cc4475f772bc9d4375'),
('apphysics1-mcq-b5-sv-h-2.3-b-v1','2.3','33fc19de9742451471b83b478f1a2ff5'),
('apphysics1-mcq-b5-sv-h-2.3-b-v2','2.3','023b0d2e1afd5d69f6dabbecbf360d22'),
('apphysics1-mcq-b5-sv-h-2.3-b-v3','2.3','9ccb51e5d48e7e236f4066ee788a0e3f'),
('apphysics1-mcq-b5-h-2.4-a','2.4','f741801cea68c79acef74b70f84e4415'),
('apphysics1-mcq-b5-sv-h-2.4-a-v1','2.4','fc1873e9a53dc41a56976b2ea08b690a'),
('apphysics1-mcq-b5-sv-h-2.4-a-v2','2.4','7068838606576209c25e16387c35fa49'),
('apphysics1-mcq-b5-sv-h-2.4-a-v3','2.4','7a08f37e69a8d28d25c681e3cb01904f'),
('apphysics1-mcq-b5-h-2.4-b','2.4','e899a3ee17af41a75cb24b1088047830'),
('apphysics1-mcq-b5-sv-h-2.4-b-v1','2.4','7a31329a7afbfdd272cbb621840f0fd7'),
('apphysics1-mcq-b5-sv-h-2.4-b-v2','2.4','e493dd3d364da0ac42e44b4ea2800d9b'),
('apphysics1-mcq-b5-sv-h-2.4-b-v3','2.4','4304b4a97975d0f44cf3d07b032d414e'),
('apphysics1-mcq-b5-h-2.5-a','2.5','20f73f83243756ff79f45f05d23910ab'),
('apphysics1-mcq-b5-sv-h-2.5-a-v1','2.5','9db294089d2fe98f25ed8331ddb6c414'),
('apphysics1-mcq-b5-sv-h-2.5-a-v2','2.5','a1fc85ec651f5fd059261672c523cfdd'),
('apphysics1-mcq-b5-sv-h-2.5-a-v3','2.5','214fc48ce4e20d8be415e5763c775207'),
('apphysics1-mcq-b5-h-2.5-b','2.5','dc33c72d3dfd1a439509d389668c8457'),
('apphysics1-mcq-b5-sv-h-2.5-b-v1','2.5','21f3dd235245c66b2944e3f69e1a601b'),
('apphysics1-mcq-b5-sv-h-2.5-b-v2','2.5','7316e54db9a04fcfdb9074c2cf861f66'),
('apphysics1-mcq-b5-sv-h-2.5-b-v3','2.5','d97240c71e9cf80f3bdca079f9d39597'),
('apphysics1-mcq-b5-h-2.6-a','2.6','71888fb525521a17bbf19aeef2ee6a61'),
('apphysics1-mcq-b5-sv-h-2.6-a-v1','2.6','df4ca5d67ac634cbe325c5b737a37a36'),
('apphysics1-mcq-b5-sv-h-2.6-a-v2','2.6','6718a551fe733abe3d463a1fbbe0c2d0'),
('apphysics1-mcq-b5-sv-h-2.6-a-v3','2.6','8576debd9fd4493d449ed472bc142e4f'),
('apphysics1-mcq-b5-h-2.6-b','2.6','7793aec81f27f855b72ce4cbad8814da'),
('apphysics1-mcq-b5-sv-h-2.6-b-v1','2.6','26d2b74880dbbc322e166a2dc6cd290e'),
('apphysics1-mcq-b5-sv-h-2.6-b-v2','2.6','06cf4673b37e71844c983f6c569af4c3'),
('apphysics1-mcq-b5-sv-h-2.6-b-v3','2.6','ae6b3483da511730880a9f0e55cd1f7f'),
('apphysics1-mcq-b5-h-2.7-a','2.7','8bc809946b57777a0fca62f36e9c0b4d'),
('apphysics1-mcq-b5-sv-h-2.7-a-v1','2.7','392bfc09d57a4ffd3c20939b47264617'),
('apphysics1-mcq-b5-sv-h-2.7-a-v2','2.7','ced46a3b6ba4b2b8d1c1754facbd95a9'),
('apphysics1-mcq-b5-sv-h-2.7-a-v3','2.7','d7cafbb09fa49f67bf91a83343f04443'),
('apphysics1-mcq-b5-h-2.7-b','2.7','1fd930d7dbc4197127ca5605f12be44d'),
('apphysics1-mcq-b5-sv-h-2.7-b-v1','2.7','a0a382002c05ea758d397cad47a1edad'),
('apphysics1-mcq-b5-sv-h-2.7-b-v2','2.7','a50adb83fbf6cb6c7037e7a50bdb003b'),
('apphysics1-mcq-b5-sv-h-2.7-b-v3','2.7','cb119069a5a6987bff70cc8e98b27128'),
('apphysics1-mcq-b5-h-2.8-a','2.8','bbb8114c2a39bba7d49bd7018427aa45'),
('apphysics1-mcq-b5-sv-h-2.8-a-v1','2.8','bb7cc5d6590fb0e15f991662b2849655'),
('apphysics1-mcq-b5-sv-h-2.8-a-v2','2.8','d711d1c5c267cbe35d3a0d3b33d0f380'),
('apphysics1-mcq-b5-sv-h-2.8-a-v3','2.8','0750b0cdf7d277fbce5f7cd1264a1953'),
('apphysics1-mcq-b5-h-2.8-b','2.8','d8005468c17faa3733487c45b013437f'),
('apphysics1-mcq-b5-sv-h-2.8-b-v1','2.8','5ee40c973a916d0f7658de5e132a825c'),
('apphysics1-mcq-b5-sv-h-2.8-b-v2','2.8','6c44f0817a6a6e8f7ec8bcce432cfbd7'),
('apphysics1-mcq-b5-sv-h-2.8-b-v3','2.8','f175971a0058b112674363c1cc83975f'),
('apphysics1-mcq-b5-h-2.9-a','2.9','4204d0d05b57a628d443cf8828b9d030'),
('apphysics1-mcq-b5-sv-h-2.9-a-v1','2.9','064627c2dbdd9f4e92daf9f0470a253b'),
('apphysics1-mcq-b5-sv-h-2.9-a-v2','2.9','6e1c20b2de637358961019e8cd30ceb0'),
('apphysics1-mcq-b5-sv-h-2.9-a-v3','2.9','354d4365cdcf3322be25a891f9b49464'),
('apphysics1-mcq-b5-h-2.9-b','2.9','4dffeb7177e2a7de8ade6d7e7853a511'),
('apphysics1-mcq-b5-sv-h-2.9-b-v1','2.9','95fb89dbc43372890c8d5a5fa81ca0d1'),
('apphysics1-mcq-b5-sv-h-2.9-b-v2','2.9','1b2eeeec5c9a68efd623acda10dd0977'),
('apphysics1-mcq-b5-sv-h-2.9-b-v3','2.9','2f5e3d8cc26da4b3d5ed6e818ffed642');
create temporary table tgt on commit drop as
select l.*, ci.id item_id, civ.id version_id, gen_random_uuid() assignment_id, gen_random_uuid() label_id, gen_random_uuid() vd_id,
 '27111dec-ee07-48f1-86cf-1a5833dd2962'::uuid tsv, (case topic when '2.1' then array[2] when '2.2' then array[2] when '2.3' then array[2] when '2.4' then array[2] when '2.5' then array[2] when '2.6' then array[2] when '2.7' then array[2] when '2.8' then array[2] when '2.9' then array[2] end)::int[] req, 2 pu
from lab l join app.content_items ci on ci.content_key=l.content_key and ci.exam_pack_version_id='29c719dc-701b-470f-9e49-fab981722d3f'
join app.content_item_versions civ on civ.content_item_id=ci.id and civ.version_num=1
where ci.status='draft' and civ.status='draft';
do $$ begin
 if (select count(*) from tgt)<>72 then raise exception 'expected 72 draft targets, got %', (select count(*) from tgt); end if;
 if exists (select 1 from tgt where split_part(topic,'.',1)::int<>pu) then raise exception 'topic/unit mismatch'; end if;
 if exists (select 1 from tgt t join app.content_item_cells c on c.content_item_version_id=t.version_id) or exists (select 1 from tgt t join app.content_taxonomy_labels l on l.content_item_id=t.item_id) then raise exception 'a target already has cells or labels'; end if;
 if (select count(*) from (select t.content_key from tgt t join app.content_item_versions civ on civ.id=t.version_id join app.mcq_choices c on c.content_item_version_id=civ.id group by t.content_key, civ.stem, t.exp_hash having md5(civ.stem||'|'||string_agg(c.choice_key||':'||c.choice_text||':'||c.is_correct::text||':'||c.rationale,'|' order by c.choice_key))=t.exp_hash) z)<>72 then raise exception 'loaded text does not match the build manifest'; end if;
 if exists (select 1 from tgt t where not exists (select 1 from app.taxonomy_topics tt where tt.taxonomy_source_version=t.tsv and tt.topic_code=t.topic)) then raise exception 'a topic code is not present in the taxonomy source version'; end if;
end $$;
insert into app.content_review_assignments (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, review_kind, status, assignment_purpose, created_by)
select assignment_id, version_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'tutor_question', 'mcq', 'pending', 'owner_remediation_approval', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
insert into app.content_review_decisions (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, tutor_score, difficulty_label, diagnostic_flag, concern_codes, note, tutor_decision, decision_payload, decision_hash, created_by)
select assignment_id, version_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'tutor_question', 1, null, false, array[]::text[],
 'AP Physics 1 Unit 3 harder seeds and variants (batch apphysics1_u2_2026_11_12): Product Owner review of owner-session-authored drafts, 2026-11-12. Arithmetic verified in Python; no model-checker pass, by Product Owner decision.',
 'approve',
 jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apphysics1_u2_2026_11_12_po_approval','qa_date','2026-11-12','content_key',content_key),
 md5(jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apphysics1_u2_2026_11_12_po_approval','qa_date','2026-11-12','content_key',content_key)::text),
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
 'apphysics1_u2_2026_11_12',
 jsonb_build_object('origin','owner_authored','units_source','AP Physics 1 Unit 2 (topics 2.x belong to unit 3; required_units set per topic from existing Unit 3 labels)','topic',topic,'report','scripts/content-seed/apchem-harder-seeds-u3-2026-11-12'),
 'apphysics1-u2-2026-11-12-labeling', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
insert into app.content_taxonomy_validation_decisions (validation_decision_id, content_taxonomy_label_id, decided_by, decision, decision_source, reviewed_primary_unit, reviewed_required_units, notes)
select vd_id, label_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'confirmed', 'chat_review', pu, req,
 'Product Owner chat instruction 2026-11-12 (AP Physics 1 harder seeds and variants). Topic assigned by the author from the question design (topic recorded on the cell); topic-only tagging, skill left null.' from tgt;
insert into app.content_item_cells (content_item_version_id, content_item_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id, validated_by, validated_at, validation_decision_id)
select version_id, item_id, tsv, topic, null, true, 'validated', 'apphysics1_u2_2026_11_12_topic',
 'apphysics1-u2-2026-11-12-labeling (topic set by the author from the question design)', null, now(), gen_random_uuid() from tgt;
update app.content_taxonomy_labels l set label_status='validated', validated_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, validated_at=now(), validation_decision_id=t.vd_id, validated_against_version_id=t.version_id, validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id) from tgt t where l.content_taxonomy_label_id=t.label_id;
update app.content_item_versions civ set status='published', published_at=coalesce(civ.published_at,now()), updated_at=now() from tgt where civ.id=tgt.version_id;
update app.content_items ci set status='published', updated_at=now() from tgt where ci.id=tgt.item_id;
do $$ declare n int; begin
  select count(*) into n from (select content_item_id from app.content_item_versions where status='published' group by 1 having count(*)>1) d; if n<>0 then raise exception 'duplicate published versions: %', n; end if;
  if (select count(*) from app.content_items ci join tgt on tgt.item_id=ci.id where ci.status='published')<>72 then raise exception 'publish count mismatch'; end if;
  select count(*) into n from app.content_taxonomy_labels l join tgt t on t.item_id=l.content_item_id where l.label_scope='serving' and l.superseded_by is null and l.label_status='validated' and l.validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id); if n<>72 then raise exception 'label post-check %', n; end if;
  select count(*) into n from app.content_item_cells where source='apphysics1_u2_2026_11_12_topic' and is_primary and superseded_by is null; if n<>72 then raise exception 'topic cell count %', n; end if;
end $$;
do $$ begin raise exception 'REHEARSAL OK (rolled back): published=%, validated_labels=%, topic_cells=%', (select count(*) from tgt), (select count(*) from app.content_taxonomy_labels where source='apphysics1_u2_2026_11_12' and label_status='validated'), (select count(*) from app.content_item_cells where source='apphysics1_u2_2026_11_12_topic'); end $$;
rollback;
