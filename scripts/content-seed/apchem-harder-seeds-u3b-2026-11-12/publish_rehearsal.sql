begin;
select pg_advisory_xact_lock(hashtext('cramapple-apchem-u3b-2026-11-12-publish-20261112'));
create temporary table lab (content_key text primary key, topic text, exp_hash text) on commit drop;
insert into lab values
('apchem-mcq-b2-h-3.4-a','3.4','2a532b7ec2314d41c1cb903968100fb3'),
('apchem-mcq-b2-sv-h-3.4-a-v1','3.4','1969753f891d9f3d0eff55a93f37a4be'),
('apchem-mcq-b2-sv-h-3.4-a-v2','3.4','9eb8ea6eecfdde5132e7d8d8fb61e215'),
('apchem-mcq-b2-sv-h-3.4-a-v3','3.4','eabadad14e47b7b9cc5ddf2620284c3c'),
('apchem-mcq-b2-h-3.4-b','3.4','9542b6157ffe29bb35005b0fc2501c52'),
('apchem-mcq-b2-sv-h-3.4-b-v1','3.4','4efae753830387a779435c284a35bdea'),
('apchem-mcq-b2-sv-h-3.4-b-v2','3.4','136eec67b59398f6bafe95d687cdb348'),
('apchem-mcq-b2-sv-h-3.4-b-v3','3.4','ef6d9446e7af54e4e393859c5af3c918'),
('apchem-mcq-b2-h-3.5-a','3.5','b64c0d1a3b3b6a5bdc35005d95dfd641'),
('apchem-mcq-b2-sv-h-3.5-a-v1','3.5','7bb5c770037dd068010e3a0bd8b18f41'),
('apchem-mcq-b2-sv-h-3.5-a-v2','3.5','46b804b87551a0aac842116d2574bad6'),
('apchem-mcq-b2-sv-h-3.5-a-v3','3.5','8a6a84725a28c056bb4ea6bf1a119db2'),
('apchem-mcq-b2-h-3.5-b','3.5','3664ee1cdd637a3175e87482f25157ae'),
('apchem-mcq-b2-sv-h-3.5-b-v1','3.5','0b1dc0e8512fef5120f30fb660ae62ec'),
('apchem-mcq-b2-sv-h-3.5-b-v2','3.5','2bc2e3200bb6bd40ca7960248e0fd5a6'),
('apchem-mcq-b2-sv-h-3.5-b-v3','3.5','0a8347b68b7b317006bfb90a25d3712c'),
('apchem-mcq-b2-h-3.6-a','3.6','0cd490353033376d0662925e2d7cfc39'),
('apchem-mcq-b2-sv-h-3.6-a-v1','3.6','29cb375da8dd70ff22396165ecbbdc97'),
('apchem-mcq-b2-sv-h-3.6-a-v2','3.6','f51a32da37549d64bc729650d57d9d25'),
('apchem-mcq-b2-sv-h-3.6-a-v3','3.6','a562fc897cade9717f279eb2ca393fce'),
('apchem-mcq-b2-h-3.6-b','3.6','c4bbcbb5df86daa57ea5f75307d374c6'),
('apchem-mcq-b2-sv-h-3.6-b-v1','3.6','d6bf90d1ae30e355d2ae2ae4dd915b90'),
('apchem-mcq-b2-sv-h-3.6-b-v2','3.6','8ed47b642916fd19248b53e79ae4ad19'),
('apchem-mcq-b2-sv-h-3.6-b-v3','3.6','bc4822dea210a2b8561ee3d554dfec93'),
('apchem-mcq-b2-h-3.7-a','3.7','2fe96b95ac4ba4cf3f0797442738897f'),
('apchem-mcq-b2-sv-h-3.7-a-v1','3.7','0d2b0ebb9e4e37eea0e8430e954ddac2'),
('apchem-mcq-b2-sv-h-3.7-a-v2','3.7','3383630d77f4b11d47b8c1362226b646'),
('apchem-mcq-b2-sv-h-3.7-a-v3','3.7','a069aa0ba24bb3241845edfb177d49fa'),
('apchem-mcq-b2-h-3.7-b','3.7','19361449ee30348f8e248285f2c20f54'),
('apchem-mcq-b2-sv-h-3.7-b-v1','3.7','f4ec273bd54291a88a3e9a617fb557bb'),
('apchem-mcq-b2-sv-h-3.7-b-v2','3.7','16799dc9e690b2ea85eb83a268029159'),
('apchem-mcq-b2-sv-h-3.7-b-v3','3.7','ad29fb0b2fbba3214fbed49beb5d5491'),
('apchem-mcq-b2-h-3.8-a','3.8','9a61a6ac9588eb0e8047757e9f4a9ac4'),
('apchem-mcq-b2-sv-h-3.8-a-v1','3.8','59fffb233b572889cd533c5d0da3d9a6'),
('apchem-mcq-b2-sv-h-3.8-a-v2','3.8','e22221fd8017dafe60b4b9bb66efb48b'),
('apchem-mcq-b2-sv-h-3.8-a-v3','3.8','5a4f5b07224717124ca50c9070773f3c'),
('apchem-mcq-b2-h-3.8-b','3.8','a2ecf551d3f35f478337c0e6ab61061a'),
('apchem-mcq-b2-sv-h-3.8-b-v1','3.8','b4a5c4e0f86ae708b864eb4e6a50dabb'),
('apchem-mcq-b2-sv-h-3.8-b-v2','3.8','f6798656f6c4446df0ff97776b678309'),
('apchem-mcq-b2-sv-h-3.8-b-v3','3.8','035c1d0e80050285ecb80d0eba187ed6'),
('apchem-mcq-b2-h-3.9-a','3.9','0bfee27337f800aad541fc2cc54d9d47'),
('apchem-mcq-b2-sv-h-3.9-a-v1','3.9','94513599baa5079aa842bf3c9c756b28'),
('apchem-mcq-b2-sv-h-3.9-a-v2','3.9','6bc57115ca557a3ec9b2fab7bd9a2e91'),
('apchem-mcq-b2-sv-h-3.9-a-v3','3.9','86c9a0c20226b925df1710600b541b43'),
('apchem-mcq-b2-h-3.9-b','3.9','e3bafe72bb768dd709fe36a89df013e3'),
('apchem-mcq-b2-sv-h-3.9-b-v1','3.9','7a41efd2bde8e4ed516ab9bbd5e541f4'),
('apchem-mcq-b2-sv-h-3.9-b-v2','3.9','a1959699dea144615a4f0ef9fd49039c'),
('apchem-mcq-b2-sv-h-3.9-b-v3','3.9','0e1f54c012940816c3d7585a78d1d5b3'),
('apchem-mcq-b2-h-3.10-a','3.10','9699032694c38be0059f4a0d47bcbc6d'),
('apchem-mcq-b2-sv-h-3.10-a-v1','3.10','84d264053a6b99c6fe05b72f7c0bb1d9'),
('apchem-mcq-b2-sv-h-3.10-a-v2','3.10','7430f8ec65b2f5797071452b875f1810'),
('apchem-mcq-b2-sv-h-3.10-a-v3','3.10','09316f4a6be58aa263ba089535b8d0e2'),
('apchem-mcq-b2-h-3.10-b','3.10','2ec1961f7458de336f2629fbfc115a56'),
('apchem-mcq-b2-sv-h-3.10-b-v1','3.10','8074a089e17ab7a7df2415d7cd059f07'),
('apchem-mcq-b2-sv-h-3.10-b-v2','3.10','6c00d802dcfff614fcff6cf25585f329'),
('apchem-mcq-b2-sv-h-3.10-b-v3','3.10','5a312b6c43983a0b4efbb0cfab616574'),
('apchem-mcq-b2-h-3.11-a','3.11','114d0483c58e574425f7643d363df4c0'),
('apchem-mcq-b2-sv-h-3.11-a-v1','3.11','31ac51903752dc28dfb83e193736122d'),
('apchem-mcq-b2-sv-h-3.11-a-v2','3.11','2d4ad1d8d260938ef7d1adb0472330a7'),
('apchem-mcq-b2-sv-h-3.11-a-v3','3.11','26a6bed2d7dc83c1dd518dc9de7ccdc0'),
('apchem-mcq-b2-h-3.11-b','3.11','bafec51e373f1a39b43d8a4d55b68b82'),
('apchem-mcq-b2-sv-h-3.11-b-v1','3.11','8010e89ac419d68e08c48e36b2ad600d'),
('apchem-mcq-b2-sv-h-3.11-b-v2','3.11','4b460d04e97c9152c1588a247b6ecc20'),
('apchem-mcq-b2-sv-h-3.11-b-v3','3.11','9e56f7eb7a978a2e50f1410fe3d33eea'),
('apchem-mcq-b2-h-3.12-a','3.12','d1afc44288700f189bb1b72f75ff7464'),
('apchem-mcq-b2-sv-h-3.12-a-v1','3.12','743627c5ff122dd1870324692c0845bf'),
('apchem-mcq-b2-sv-h-3.12-a-v2','3.12','407fc59af8a850399f2b70f0156a14b5'),
('apchem-mcq-b2-sv-h-3.12-a-v3','3.12','23e4b7d5c4185339acc96217a3e7ef20'),
('apchem-mcq-b2-h-3.12-b','3.12','72a62902da0a9f9b7ba126bba47306cc'),
('apchem-mcq-b2-sv-h-3.12-b-v1','3.12','24a9d51aa83229726827cebba6732468'),
('apchem-mcq-b2-sv-h-3.12-b-v2','3.12','b25f9163a0efe96b6fd51d1e22f118e4'),
('apchem-mcq-b2-sv-h-3.12-b-v3','3.12','371d677823b25966c4b3a64ebcfecf1d'),
('apchem-mcq-b2-h-3.13-a','3.13','ebe0f3c4c6152abd413a5d57cffb8fbb'),
('apchem-mcq-b2-sv-h-3.13-a-v1','3.13','56d3bf3af10db396621f0ce630632f02'),
('apchem-mcq-b2-sv-h-3.13-a-v2','3.13','cc706b9d62208cfcb4ea6d4380a8e93b'),
('apchem-mcq-b2-sv-h-3.13-a-v3','3.13','7b2c33a05b540e80755202b105d7ef96'),
('apchem-mcq-b2-h-3.13-b','3.13','a7bfe9226fcba19361a705acc962d46c'),
('apchem-mcq-b2-sv-h-3.13-b-v1','3.13','75e55a3d5dc83c079be89dcf032fa5a6'),
('apchem-mcq-b2-sv-h-3.13-b-v2','3.13','7be8471a29f362c61af5cadc960cb5f1'),
('apchem-mcq-b2-sv-h-3.13-b-v3','3.13','f80989a92d2e1fa03ae882068e70067e');
create temporary table tgt on commit drop as
select l.*, ci.id item_id, civ.id version_id, gen_random_uuid() assignment_id, gen_random_uuid() label_id, gen_random_uuid() vd_id,
 'cbe3116f-6ef5-410c-b535-e9fb711c4c2c'::uuid tsv, (case topic when '3.1' then array[3] when '3.2' then array[3] when '3.3' then array[3] when '3.4' then array[3] when '3.5' then array[1, 3] when '3.6' then array[3] when '3.7' then array[3] when '3.9' then array[3] when '3.10' then array[3] when '3.12' then array[3] when '3.13' then array[3] when '3.8' then array[3] when '3.11' then array[3] end)::int[] req, 3 pu
from lab l join app.content_items ci on ci.content_key=l.content_key and ci.exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b'
join app.content_item_versions civ on civ.content_item_id=ci.id and civ.version_num=1
where ci.status='draft' and civ.status='draft';
do $$ begin
 if (select count(*) from tgt)<>80 then raise exception 'expected 80 draft targets, got %', (select count(*) from tgt); end if;
 if exists (select 1 from tgt where split_part(topic,'.',1)::int<>pu) then raise exception 'topic/unit mismatch'; end if;
 if exists (select 1 from tgt t join app.content_item_cells c on c.content_item_version_id=t.version_id) or exists (select 1 from tgt t join app.content_taxonomy_labels l on l.content_item_id=t.item_id) then raise exception 'a target already has cells or labels'; end if;
 if (select count(*) from (select t.content_key from tgt t join app.content_item_versions civ on civ.id=t.version_id join app.mcq_choices c on c.content_item_version_id=civ.id group by t.content_key, civ.stem, t.exp_hash having md5(civ.stem||'|'||string_agg(c.choice_key||':'||c.choice_text||':'||c.is_correct::text||':'||c.rationale,'|' order by c.choice_key))=t.exp_hash) z)<>80 then raise exception 'loaded text does not match the build manifest'; end if;
 if exists (select 1 from tgt t where not exists (select 1 from app.content_item_cells c join app.content_items ci2 on ci2.id=c.content_item_id where ci2.exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b' and c.topic_code=t.topic and c.taxonomy_source_version=t.tsv and c.superseded_by is null)) then raise exception 'a topic code is not present in the AP Chemistry taxonomy source version'; end if;
end $$;
insert into app.content_review_assignments (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, review_kind, status, assignment_purpose, created_by)
select assignment_id, version_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'tutor_question', 'mcq', 'pending', 'owner_remediation_approval', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
insert into app.content_review_decisions (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, tutor_score, difficulty_label, diagnostic_flag, concern_codes, note, tutor_decision, decision_payload, decision_hash, created_by)
select assignment_id, version_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'tutor_question', 1, null, false, array[]::text[],
 'AP Chemistry Unit 3 harder seeds and variants (batch apchem_u3b_2026_11_12): Product Owner review of owner-session-authored drafts, 2026-11-12. Arithmetic verified in Python; no model-checker pass, by Product Owner decision.',
 'approve',
 jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apchem_u3b_2026_11_12_po_approval','qa_date','2026-11-12','content_key',content_key),
 md5(jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apchem_u3b_2026_11_12_po_approval','qa_date','2026-11-12','content_key',content_key)::text),
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
 'apchem_u3b_2026_11_12',
 jsonb_build_object('origin','owner_authored','units_source','AP Chemistry Unit 3 (topics 3.x belong to unit 3; required_units set per topic from existing Unit 3 labels)','topic',topic,'report','scripts/content-seed/apchem-harder-seeds-u3-2026-11-12'),
 'apchem-u3b-2026-11-12-labeling', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
insert into app.content_taxonomy_validation_decisions (validation_decision_id, content_taxonomy_label_id, decided_by, decision, decision_source, reviewed_primary_unit, reviewed_required_units, notes)
select vd_id, label_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'confirmed', 'chat_review', pu, req,
 'Product Owner chat instruction 2026-11-12 (AP Chemistry harder seeds and variants). Topic assigned by the author from the question design (topic recorded on the cell); topic-only tagging, skill left null.' from tgt;
insert into app.content_item_cells (content_item_version_id, content_item_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id, validated_by, validated_at, validation_decision_id)
select version_id, item_id, tsv, topic, null, true, 'validated', 'apchem_u3b_2026_11_12_topic',
 'apchem-u3b-2026-11-12-labeling (topic set by the author from the question design)', null, now(), gen_random_uuid() from tgt;
update app.content_taxonomy_labels l set label_status='validated', validated_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, validated_at=now(), validation_decision_id=t.vd_id, validated_against_version_id=t.version_id, validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id) from tgt t where l.content_taxonomy_label_id=t.label_id;
update app.content_item_versions civ set status='published', published_at=coalesce(civ.published_at,now()), updated_at=now() from tgt where civ.id=tgt.version_id;
update app.content_items ci set status='published', updated_at=now() from tgt where ci.id=tgt.item_id;
do $$ declare n int; begin
  select count(*) into n from (select content_item_id from app.content_item_versions where status='published' group by 1 having count(*)>1) d; if n<>0 then raise exception 'duplicate published versions: %', n; end if;
  if (select count(*) from app.content_items ci join tgt on tgt.item_id=ci.id where ci.status='published')<>80 then raise exception 'publish count mismatch'; end if;
  select count(*) into n from app.content_taxonomy_labels l join tgt t on t.item_id=l.content_item_id where l.label_scope='serving' and l.superseded_by is null and l.label_status='validated' and l.validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id); if n<>80 then raise exception 'label post-check %', n; end if;
  select count(*) into n from app.content_item_cells where source='apchem_u3b_2026_11_12_topic' and is_primary and superseded_by is null; if n<>80 then raise exception 'topic cell count %', n; end if;
end $$;
do $$ begin raise exception 'REHEARSAL OK (rolled back): published=%, validated_labels=%, topic_cells=%', (select count(*) from tgt), (select count(*) from app.content_taxonomy_labels where source='apchem_u3b_2026_11_12' and label_status='validated'), (select count(*) from app.content_item_cells where source='apchem_u3b_2026_11_12_topic'); end $$;
rollback;
