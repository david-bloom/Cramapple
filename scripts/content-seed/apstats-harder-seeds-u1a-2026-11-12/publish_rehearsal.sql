begin;
select pg_advisory_xact_lock(hashtext('cramapple-apstats-u1a-2026-11-12-publish-20261112'));
create temporary table lab (content_key text primary key, topic text, exp_hash text) on commit drop;
insert into lab values
('apstats-mcq-b7-h-1.1-a','1.1','d0978dcee69b7a796d28f5709b0f2ed0'),
('apstats-mcq-b7-sv-h-1.1-a-v1','1.1','8a6486614cd895f6f349838bcbc0ddb8'),
('apstats-mcq-b7-sv-h-1.1-a-v2','1.1','638677b16b85c715dfa79428f3d7cae9'),
('apstats-mcq-b7-sv-h-1.1-a-v3','1.1','470d521d12f76c0539f5eb7b7911f414'),
('apstats-mcq-b7-h-1.1-b','1.1','a1ecff5f5ec6366c8b9efb8509e71ecb'),
('apstats-mcq-b7-sv-h-1.1-b-v1','1.1','95eb4510a35497b421c084f4636f3af2'),
('apstats-mcq-b7-sv-h-1.1-b-v2','1.1','fac8ba97022235fde4a36afc7ec94620'),
('apstats-mcq-b7-sv-h-1.1-b-v3','1.1','284ab45ce9629a9fa3632660a0db7a7b'),
('apstats-mcq-b7-h-1.2-a','1.2','ba70982c978e7c3cea1b0d24d62b0359'),
('apstats-mcq-b7-sv-h-1.2-a-v1','1.2','e6c159e7a205ca56312f84a15a98e9a5'),
('apstats-mcq-b7-sv-h-1.2-a-v2','1.2','4a9bcd35a99c72da7caefb17dc1566ca'),
('apstats-mcq-b7-sv-h-1.2-a-v3','1.2','17d17d29b586c495f758356c616d4755'),
('apstats-mcq-b7-h-1.2-b','1.2','73e4b9e78569e85983290deaad8f2f94'),
('apstats-mcq-b7-sv-h-1.2-b-v1','1.2','d16390260b603daaf86b6049f9cb93a4'),
('apstats-mcq-b7-sv-h-1.2-b-v2','1.2','c35935335774145f9f5f44dac14f2831'),
('apstats-mcq-b7-sv-h-1.2-b-v3','1.2','a87e9cbae6602e391ddedd84cb5af152'),
('apstats-mcq-b7-h-1.3-a','1.3','de2bca0f63a218cbccd4b37ba04e8550'),
('apstats-mcq-b7-sv-h-1.3-a-v1','1.3','2c8aa940acc6b5e18666c39cbf39c7bc'),
('apstats-mcq-b7-sv-h-1.3-a-v2','1.3','d481b822d07b067c91c651bcd37745b5'),
('apstats-mcq-b7-sv-h-1.3-a-v3','1.3','f3ec6fd03352d21cd3716b2d0d2cb604'),
('apstats-mcq-b7-h-1.3-b','1.3','07c7a36e685f27608b8996b139a28c24'),
('apstats-mcq-b7-sv-h-1.3-b-v1','1.3','e1a64933a9b575130040e379870cdc88'),
('apstats-mcq-b7-sv-h-1.3-b-v2','1.3','0beaa0d4a29ee16bb7a58379a00c5a24'),
('apstats-mcq-b7-sv-h-1.3-b-v3','1.3','41d89c8daa00db34bec5ae89168b29cd'),
('apstats-mcq-b7-h-1.4-a','1.4','f00c30d891f743db6abcf672f911e83c'),
('apstats-mcq-b7-sv-h-1.4-a-v1','1.4','b8e60c490294a8f84010f9165e1f8460'),
('apstats-mcq-b7-sv-h-1.4-a-v2','1.4','37acb5688d0aa09c1531f349c52f9c6a'),
('apstats-mcq-b7-sv-h-1.4-a-v3','1.4','d335c6a78cd47a8f0d6e86f4a4052787'),
('apstats-mcq-b7-h-1.4-b','1.4','f6f1561b945a27f1e5e225333d182997'),
('apstats-mcq-b7-sv-h-1.4-b-v1','1.4','b804ef89f7abab5cef5530024f7aa908'),
('apstats-mcq-b7-sv-h-1.4-b-v2','1.4','54a0f9374cf64ce0e61265f1ef57c878'),
('apstats-mcq-b7-sv-h-1.4-b-v3','1.4','88992aa54dd53b6f015876d4412dc792'),
('apstats-mcq-b7-h-1.5-a','1.5','3c00dfe7a3acb3f0335880945240bbae'),
('apstats-mcq-b7-sv-h-1.5-a-v1','1.5','2edc13c3725f6874c0e7c424ed26f2b5'),
('apstats-mcq-b7-sv-h-1.5-a-v2','1.5','b5fe2ce12fa68e2877fda5a6478a8bda'),
('apstats-mcq-b7-sv-h-1.5-a-v3','1.5','7a28cb8e192bb0548e4275bc004223a3'),
('apstats-mcq-b7-h-1.5-b','1.5','deed56e0b8169d6a12a6895e535caf1a'),
('apstats-mcq-b7-sv-h-1.5-b-v1','1.5','f6d111e642f36810372c57acd6762098'),
('apstats-mcq-b7-sv-h-1.5-b-v2','1.5','bf558b353f8bbccbdc67d59b591a6a27'),
('apstats-mcq-b7-sv-h-1.5-b-v3','1.5','d7f5de1115b45badef496274a609b0a7'),
('apstats-mcq-b7-h-1.6-a','1.6','b2578e8f6203229a44cfa2bac89b5d00'),
('apstats-mcq-b7-sv-h-1.6-a-v1','1.6','ebbc63cae02e439fd0c45966f82406ed'),
('apstats-mcq-b7-sv-h-1.6-a-v2','1.6','be93688b8631891256315298aeb22dd0'),
('apstats-mcq-b7-sv-h-1.6-a-v3','1.6','18ea7f386237189ab214941aab7efd62'),
('apstats-mcq-b7-h-1.6-b','1.6','4ad23da8e991fc23ad84c01232fee505'),
('apstats-mcq-b7-sv-h-1.6-b-v1','1.6','207f7d0d79a2da6c940eccf0c4793135'),
('apstats-mcq-b7-sv-h-1.6-b-v2','1.6','9eae43ab6a51141fa14bceade7833440'),
('apstats-mcq-b7-sv-h-1.6-b-v3','1.6','86a116f4bb14ef3d8b77f17950afb73d'),
('apstats-mcq-b7-h-1.7-a','1.7','d3874af1c8e8af4461141532b45fde8d'),
('apstats-mcq-b7-sv-h-1.7-a-v1','1.7','b363c1c76b78e1343ad52ccf16a140c6'),
('apstats-mcq-b7-sv-h-1.7-a-v2','1.7','01a010374e7f41f52df8027d153db5fc'),
('apstats-mcq-b7-sv-h-1.7-a-v3','1.7','4bf3c0d1ce2f3ca96225668aa63d7ca5'),
('apstats-mcq-b7-h-1.7-b','1.7','a2283a8d2f4eb42339d651413ed46ea4'),
('apstats-mcq-b7-sv-h-1.7-b-v1','1.7','52c038391b2db698adbe99a453efdfcb'),
('apstats-mcq-b7-sv-h-1.7-b-v2','1.7','b27128117df963e13f2b0f69c7ad4a27'),
('apstats-mcq-b7-sv-h-1.7-b-v3','1.7','3c2ebbca1ca95deb40851206c965de0f');
create temporary table tgt on commit drop as
select l.*, ci.id item_id, civ.id version_id, gen_random_uuid() assignment_id, gen_random_uuid() label_id, gen_random_uuid() vd_id,
 'dae3c72e-82ca-4960-9552-1b034bd347e5'::uuid tsv, (case topic when '1.1' then array[1] when '1.10' then array[1] when '1.11' then array[1] when '1.12' then array[1] when '1.13' then array[1] when '1.2' then array[1] when '1.3' then array[1] when '1.4' then array[1] when '1.5' then array[1] when '1.6' then array[1] when '1.7' then array[1] when '1.8' then array[1] when '1.9' then array[1] end)::int[] req, 1 pu
from lab l join app.content_items ci on ci.content_key=l.content_key and ci.exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438'
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
 'AP Statistics Unit 3 harder seeds and variants (batch apstats_u1a_2026_11_12): Product Owner review of owner-session-authored drafts, 2026-11-12. Arithmetic verified in Python; no model-checker pass, by Product Owner decision.',
 'approve',
 jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apstats_u1a_2026_11_12_po_approval','qa_date','2026-11-12','content_key',content_key),
 md5(jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apstats_u1a_2026_11_12_po_approval','qa_date','2026-11-12','content_key',content_key)::text),
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
 'apstats_u1a_2026_11_12',
 jsonb_build_object('origin','owner_authored','units_source','AP Statistics Unit 1 (topics 1.x belong to unit 3; required_units set per topic from existing Unit 3 labels)','topic',topic,'report','scripts/content-seed/apchem-harder-seeds-u3-2026-11-12'),
 'apstats-u1a-2026-11-12-labeling', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
insert into app.content_taxonomy_validation_decisions (validation_decision_id, content_taxonomy_label_id, decided_by, decision, decision_source, reviewed_primary_unit, reviewed_required_units, notes)
select vd_id, label_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'confirmed', 'chat_review', pu, req,
 'Product Owner chat instruction 2026-11-12 (AP Statistics harder seeds and variants). Topic assigned by the author from the question design (topic recorded on the cell); topic-only tagging, skill left null.' from tgt;
insert into app.content_item_cells (content_item_version_id, content_item_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id, validated_by, validated_at, validation_decision_id)
select version_id, item_id, tsv, topic, null, true, 'validated', 'apstats_u1a_2026_11_12_topic',
 'apstats-u1a-2026-11-12-labeling (topic set by the author from the question design)', null, now(), gen_random_uuid() from tgt;
update app.content_taxonomy_labels l set label_status='validated', validated_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, validated_at=now(), validation_decision_id=t.vd_id, validated_against_version_id=t.version_id, validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id) from tgt t where l.content_taxonomy_label_id=t.label_id;
update app.content_item_versions civ set status='published', published_at=coalesce(civ.published_at,now()), updated_at=now() from tgt where civ.id=tgt.version_id;
update app.content_items ci set status='published', updated_at=now() from tgt where ci.id=tgt.item_id;
do $$ declare n int; begin
  select count(*) into n from (select content_item_id from app.content_item_versions where status='published' group by 1 having count(*)>1) d; if n<>0 then raise exception 'duplicate published versions: %', n; end if;
  if (select count(*) from app.content_items ci join tgt on tgt.item_id=ci.id where ci.status='published')<>56 then raise exception 'publish count mismatch'; end if;
  select count(*) into n from app.content_taxonomy_labels l join tgt t on t.item_id=l.content_item_id where l.label_scope='serving' and l.superseded_by is null and l.label_status='validated' and l.validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id); if n<>56 then raise exception 'label post-check %', n; end if;
  select count(*) into n from app.content_item_cells where source='apstats_u1a_2026_11_12_topic' and is_primary and superseded_by is null; if n<>56 then raise exception 'topic cell count %', n; end if;
end $$;
do $$ begin raise exception 'REHEARSAL OK (rolled back): published=%, validated_labels=%, topic_cells=%', (select count(*) from tgt), (select count(*) from app.content_taxonomy_labels where source='apstats_u1a_2026_11_12' and label_status='validated'), (select count(*) from app.content_item_cells where source='apstats_u1a_2026_11_12_topic'); end $$;
rollback;
