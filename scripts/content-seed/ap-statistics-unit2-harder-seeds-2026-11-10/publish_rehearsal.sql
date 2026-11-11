begin;
select pg_advisory_xact_lock(hashtext('cramapple-apstats-u2-harder-publish-20261110'));
create temporary table lab (content_key text primary key, topic text, exp_hash text) on commit drop;
insert into lab values
('APSTATS-MCQ-H-2.4-A','2.4','299fb5b4845a92ae71162a4baa236604'),
('APSTATS-MCQ-H-2.4-B','2.4','35e195a332dc04e03d18b1973444fc49'),
('APSTATS-MCQ-H-2.5-A','2.5','df075e3ffb1e06869091f3707122ef84'),
('APSTATS-MCQ-H-2.5-B','2.5','41dc4fd2c7a960c15284f0c518e84645'),
('APSTATS-MCQ-H-2.6-A','2.6','852630759c87a198e22e23a85dad59ee'),
('APSTATS-MCQ-H-2.6-B','2.6','f7125f09e1e636dc6548993121de1ec8'),
('APSTATS-MCQ-SV-H-2.4-A-v1','2.4','cc9f915dc67cf25a931d0e15f9e3b4ee'),
('APSTATS-MCQ-SV-H-2.4-A-v2','2.4','19b461b991ce9c6593dc7ba9ce800e04'),
('APSTATS-MCQ-SV-H-2.4-A-v3','2.4','6af7150839df7c9a5372c9a1ee9d768d'),
('APSTATS-MCQ-SV-H-2.4-B-v1','2.4','4073b254f6007856837335e414b11a16'),
('APSTATS-MCQ-SV-H-2.4-B-v2','2.4','06fb81a63251793367dcb3827f1216b8'),
('APSTATS-MCQ-SV-H-2.4-B-v3','2.4','e6b5a403df39635b57ddab8efa438c89'),
('APSTATS-MCQ-SV-H-2.5-A-v1','2.5','29d5150159af1e0684cf976c8cc0705a'),
('APSTATS-MCQ-SV-H-2.5-A-v2','2.5','d1b93be1a65cc4ee2d5bf66c6050a821'),
('APSTATS-MCQ-SV-H-2.5-A-v3','2.5','574cc97b4709c508d805cd3e4b3af75a'),
('APSTATS-MCQ-SV-H-2.5-B-v1','2.5','57baf08b0212ce7faea3ee4caebc4f8b'),
('APSTATS-MCQ-SV-H-2.5-B-v2','2.5','8b4dfaee8955bd9c45df05bf82683f09'),
('APSTATS-MCQ-SV-H-2.5-B-v3','2.5','48ff0e8ec10e2423fab88ac6f4167231'),
('APSTATS-MCQ-SV-H-2.6-A-v1','2.6','358071eabcd34ead4a1b672247812ad4'),
('APSTATS-MCQ-SV-H-2.6-A-v2','2.6','c92def6ddf4d94ae568f15615678ea51'),
('APSTATS-MCQ-SV-H-2.6-A-v3','2.6','2ef02e8cbd56b402e339671ccf3fa2cb'),
('APSTATS-MCQ-SV-H-2.6-B-v1','2.6','d745a8c21036fad96e7499360d635325'),
('APSTATS-MCQ-SV-H-2.6-B-v2','2.6','6fa139f486d525188ad0bd193cee5131'),
('APSTATS-MCQ-SV-H-2.6-B-v3','2.6','7086575748d6173f22fb26b6112b083a'),
('APSTATS-MCQ-H-2.7-A','2.7','fd07ee60fddc8bbcc55fa73f9626e493'),
('APSTATS-MCQ-SV-H-2.7-A-v1','2.7','da8834cd2b67cc573fdda26a35059779'),
('APSTATS-MCQ-SV-H-2.7-A-v2','2.7','4adf307c3a5a2e3ba4b7066f18735382'),
('APSTATS-MCQ-SV-H-2.7-A-v3','2.7','d491e58c50779e9cf2771605ad201409'),
('APSTATS-MCQ-H-2.7-B','2.7','318ebb088d5461db9ba07d7e4809cf85'),
('APSTATS-MCQ-SV-H-2.7-B-v1','2.7','e12382d7d8bb79edb77497a06d869ca7'),
('APSTATS-MCQ-SV-H-2.7-B-v2','2.7','a8d74342148d0e8cbf35eb8a009c64e9'),
('APSTATS-MCQ-SV-H-2.7-B-v3','2.7','19770d8a6dd62de18717ed98e06646e1'),
('APSTATS-MCQ-H-2.9-A','2.9','35a93801ad12dc1ee7deb79730620387'),
('APSTATS-MCQ-SV-H-2.9-A-v1','2.9','412e0ae2fd5840a053be77644bc851f4'),
('APSTATS-MCQ-SV-H-2.9-A-v2','2.9','98ce3720e4fc3cfd097a85512b4e8e9c'),
('APSTATS-MCQ-SV-H-2.9-A-v3','2.9','f95b8023de9a9ade826f388f80fede8e'),
('APSTATS-MCQ-H-2.9-B','2.9','c35abcc830d9a27a4759835163f13856'),
('APSTATS-MCQ-SV-H-2.9-B-v1','2.9','e405ff9801a23270a8ef8595078357d6'),
('APSTATS-MCQ-SV-H-2.9-B-v2','2.9','1e1ca8f00d61bf302f96012137536dc5'),
('APSTATS-MCQ-SV-H-2.9-B-v3','2.9','dd257d339521b50d3874e9177302831e'),
('APSTATS-MCQ-H-2.10-A','2.10','5ed9dcaeb7d938a006b1136cb92f890f'),
('APSTATS-MCQ-SV-H-2.10-A-v1','2.10','c1ed2261c7b483ffc1f4e12ac0a4c2b0'),
('APSTATS-MCQ-SV-H-2.10-A-v2','2.10','4e35b2bb1fa1725ddcf62e782ae60519'),
('APSTATS-MCQ-SV-H-2.10-A-v3','2.10','d9ab8584a87f611ddd4d2bc04e067b5b'),
('APSTATS-MCQ-H-2.10-B','2.10','d007367f5231eb069ccfeda0b68594c7'),
('APSTATS-MCQ-SV-H-2.10-B-v1','2.10','0231335ee1f15a6cc086fb69e9af8a76'),
('APSTATS-MCQ-SV-H-2.10-B-v2','2.10','000c8a7f5b4efb28c3810d0285be29c4'),
('APSTATS-MCQ-SV-H-2.10-B-v3','2.10','1b9c7c61f56f99927ea74d9a7e01ba40'),
('APSTATS-MCQ-H-2.1-A','2.1','c5031020a67bb9b51c698c607f03b3f8'),
('APSTATS-MCQ-SV-H-2.1-A-v1','2.1','43a4b800f9ba7910f7dc3d3e47d06447'),
('APSTATS-MCQ-SV-H-2.1-A-v2','2.1','4010109407630f353654a93bfd07fa12'),
('APSTATS-MCQ-SV-H-2.1-A-v3','2.1','e9a8bbb169e064bb5898328e55a9cf2f'),
('APSTATS-MCQ-H-2.1-B','2.1','0a67ebba1828136265e3f9d80bab9a99'),
('APSTATS-MCQ-SV-H-2.1-B-v1','2.1','a8c1a24d35a3e0c8cb5835479a6d5a20'),
('APSTATS-MCQ-SV-H-2.1-B-v2','2.1','51df6309365464adab8662237a66db3d'),
('APSTATS-MCQ-SV-H-2.1-B-v3','2.1','68b2c66ec9144cd41a07f23f6ee5e0cd'),
('APSTATS-MCQ-H-2.2-A','2.2','3bc3dbe107cb5c654f193a357ed6f833'),
('APSTATS-MCQ-SV-H-2.2-A-v1','2.2','dcd9532aaf3342208d002ec88cf8d590'),
('APSTATS-MCQ-SV-H-2.2-A-v2','2.2','38c7ce458d999465dfe9909b42bcd25f'),
('APSTATS-MCQ-SV-H-2.2-A-v3','2.2','7062e8e31894499e1d32186b47ab31c9'),
('APSTATS-MCQ-H-2.2-B','2.2','825355195e0c39b3a5b897ffb53d655e'),
('APSTATS-MCQ-SV-H-2.2-B-v1','2.2','a859c1f01dda3bc425c2c09c2bac4d39'),
('APSTATS-MCQ-SV-H-2.2-B-v2','2.2','63059f02435a771580cd9e29494863c7'),
('APSTATS-MCQ-SV-H-2.2-B-v3','2.2','d6784762e2449e8c036240cf67907318'),
('APSTATS-MCQ-H-2.3-A','2.3','374e2c00fd976e62705c13ad33baca0c'),
('APSTATS-MCQ-SV-H-2.3-A-v1','2.3','99101b88ab7b9052e47005e12b3bf08d'),
('APSTATS-MCQ-SV-H-2.3-A-v2','2.3','bdb0f3a8b55b8a82e49a4ea86a35149e'),
('APSTATS-MCQ-SV-H-2.3-A-v3','2.3','8f7cb506fa0cfd481be97eace74d0894'),
('APSTATS-MCQ-H-2.3-B','2.3','69c43d2a71546be359d27a305d6a7bd4'),
('APSTATS-MCQ-SV-H-2.3-B-v1','2.3','453d713208ac3be5cbb2d673f2ca7efa'),
('APSTATS-MCQ-SV-H-2.3-B-v2','2.3','f1fc030a88b07120e6a280c2eb7d93c8'),
('APSTATS-MCQ-SV-H-2.3-B-v3','2.3','41de75db9ebf37720f3979c6c1c36d85'),
('APSTATS-MCQ-H-2.8-A','2.8','eb60cba860c59abfb8068630e7ea82d4'),
('APSTATS-MCQ-SV-H-2.8-A-v1','2.8','ef5d7f8ac75b744dbd9d77e31d2cec0a'),
('APSTATS-MCQ-SV-H-2.8-A-v2','2.8','475401920d50c0e2b8b9b632ff71f091'),
('APSTATS-MCQ-SV-H-2.8-A-v3','2.8','9cbc3a5999c3257ff5f2d268e7868fe9'),
('APSTATS-MCQ-H-2.8-B','2.8','dd2eadd4b1f649b369b00d5221acb1f1'),
('APSTATS-MCQ-SV-H-2.8-B-v1','2.8','d77abbc7072994cad6437a4faf741b53'),
('APSTATS-MCQ-SV-H-2.8-B-v2','2.8','c69e44ce692b32e4da6c7d8432947f84'),
('APSTATS-MCQ-SV-H-2.8-B-v3','2.8','e73c4835327c7725ac379284af0df68f'),
('APSTATS-MCQ-H-2.11-A','2.11','b1615457f763d2310fc928a48c92e0d1'),
('APSTATS-MCQ-SV-H-2.11-A-v1','2.11','65eac882bc289bd841485df10dcbc771'),
('APSTATS-MCQ-SV-H-2.11-A-v2','2.11','7da84ebbe4a1e83e4a48530864ef4c8f'),
('APSTATS-MCQ-SV-H-2.11-A-v3','2.11','052d2d6d5dfd45e4f6ba0ce7c1aa029f'),
('APSTATS-MCQ-H-2.11-B','2.11','4ed4e7795a79c4007440b2c628dd27a0'),
('APSTATS-MCQ-SV-H-2.11-B-v1','2.11','12088ca87aff444cdd3df56288a91fae'),
('APSTATS-MCQ-SV-H-2.11-B-v2','2.11','338028a7e6eb74bff0e9d8b487ec08cc'),
('APSTATS-MCQ-SV-H-2.11-B-v3','2.11','065a9a745d8b9f1b1cd75d653b84469d'),
('APSTATS-MCQ-H-2.12-A','2.12','312dfdbe55383b452918675beff79140'),
('APSTATS-MCQ-SV-H-2.12-A-v1','2.12','f3b520f8f99e19ab2a1af08937a3efbe'),
('APSTATS-MCQ-SV-H-2.12-A-v2','2.12','c414c893e620965fa07d5a62dea1839e'),
('APSTATS-MCQ-SV-H-2.12-A-v3','2.12','4dabec32aeab5aa6d3349934faa6c772'),
('APSTATS-MCQ-H-2.12-B','2.12','af5b92a5166d2baccd13001b9a6ec5aa'),
('APSTATS-MCQ-SV-H-2.12-B-v1','2.12','69df39f70bf8f0c105403d3609f29c74'),
('APSTATS-MCQ-SV-H-2.12-B-v2','2.12','21785309abfb77df8589aeea6610dbd5'),
('APSTATS-MCQ-SV-H-2.12-B-v3','2.12','c47092749361895ebaddf0926b2cfe32');
create temporary table tgt on commit drop as
select l.*, ci.id item_id, civ.id version_id, gen_random_uuid() assignment_id, gen_random_uuid() label_id, gen_random_uuid() vd_id,
 'dae3c72e-82ca-4960-9552-1b034bd347e5'::uuid tsv, array[2]::int[] req, 2 pu
from lab l join app.content_items ci on ci.content_key=l.content_key and ci.exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438'
join app.content_item_versions civ on civ.content_item_id=ci.id and civ.version_num=1
where ci.status='draft' and civ.status='draft';
do $$ begin
 if (select count(*) from tgt)<>96 then raise exception 'expected 96 draft targets, got %', (select count(*) from tgt); end if;
 if exists (select 1 from tgt where split_part(topic,'.',1)::int<>pu) then raise exception 'topic/unit mismatch'; end if;
 if exists (select 1 from tgt t join app.content_item_cells c on c.content_item_version_id=t.version_id) or exists (select 1 from tgt t join app.content_taxonomy_labels l on l.content_item_id=t.item_id) then raise exception 'a target already has cells or labels'; end if;
 if (select count(*) from (select t.content_key from tgt t join app.content_item_versions civ on civ.id=t.version_id join app.mcq_choices c on c.content_item_version_id=civ.id group by t.content_key, civ.stem, t.exp_hash having md5(civ.stem||'|'||string_agg(c.choice_key||':'||c.choice_text||':'||c.is_correct::text||':'||c.rationale,'|' order by c.choice_key))=t.exp_hash) z)<>96 then raise exception 'loaded text does not match the build manifest'; end if;
 if exists (select 1 from tgt t where not exists (select 1 from app.content_item_cells c join app.content_items ci2 on ci2.id=c.content_item_id where ci2.exam_pack_version_id='548f06be-ccf4-426d-b82b-b424137a4438' and c.topic_code=t.topic and c.taxonomy_source_version=t.tsv and c.superseded_by is null)) then raise exception 'a topic code is not present in the Statistics taxonomy source version'; end if;
end $$;
insert into app.content_review_assignments (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, review_kind, status, assignment_purpose, created_by)
select assignment_id, version_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'tutor_question', 'mcq', 'pending', 'owner_remediation_approval', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
insert into app.content_review_decisions (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, tutor_score, difficulty_label, diagnostic_flag, concern_codes, note, tutor_decision, decision_payload, decision_hash, created_by)
select assignment_id, version_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'tutor_question', 1, null, false, array[]::text[],
 'AP Statistics Unit 2 harder seeds and variants (topics 2.1 to 2.12): Product Owner review of owner-session-authored drafts, 2026-11-10. Arithmetic verified in Python; no model-checker pass, by Product Owner decision.',
 'approve',
 jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apstats_u2_harder_po_approval','qa_date','2026-11-10','content_key',content_key),
 md5(jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apstats_u2_harder_po_approval','qa_date','2026-11-10','content_key',content_key)::text),
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
 'apstats_u2_harder_2026_11_10',
 jsonb_build_object('origin','owner_authored','units_source','Statistics Unit 2 (all topics 2.x belong to unit 2; existing Unit 2 serving labels use required_units [2], primary_unit 2)','topic',topic,'report','scripts/content-seed/ap-statistics-unit2-harder-seeds-2026-11-10'),
 'apstats-u2-harder-labeling-2026-11-10', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
insert into app.content_taxonomy_validation_decisions (validation_decision_id, content_taxonomy_label_id, decided_by, decision, decision_source, reviewed_primary_unit, reviewed_required_units, notes)
select vd_id, label_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'confirmed', 'chat_review', pu, req,
 'Product Owner chat instruction 2026-11-10 (AP Statistics Unit 2 harder seeds and variants). Topic assigned by the author from the question design (topic recorded on the cell); topic-only tagging, skill left null.' from tgt;
insert into app.content_item_cells (content_item_version_id, content_item_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id, validated_by, validated_at, validation_decision_id)
select version_id, item_id, tsv, topic, null, true, 'validated', 'apstats_u2_harder_topic_2026_11_10',
 'apstats-u2-harder-labeling-2026-11-10 (topic set by the author from the question design)', null, now(), gen_random_uuid() from tgt;
update app.content_taxonomy_labels l set label_status='validated', validated_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, validated_at=now(), validation_decision_id=t.vd_id, validated_against_version_id=t.version_id, validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id) from tgt t where l.content_taxonomy_label_id=t.label_id;
update app.content_item_versions civ set status='published', published_at=coalesce(civ.published_at,now()), updated_at=now() from tgt where civ.id=tgt.version_id;
update app.content_items ci set status='published', updated_at=now() from tgt where ci.id=tgt.item_id;
do $$ declare n int; begin
  select count(*) into n from (select content_item_id from app.content_item_versions where status='published' group by 1 having count(*)>1) d; if n<>0 then raise exception 'duplicate published versions: %', n; end if;
  if (select count(*) from app.content_items ci join tgt on tgt.item_id=ci.id where ci.status='published')<>96 then raise exception 'publish count mismatch'; end if;
  select count(*) into n from app.content_taxonomy_labels l join tgt t on t.item_id=l.content_item_id where l.label_scope='serving' and l.superseded_by is null and l.label_status='validated' and l.validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id); if n<>96 then raise exception 'label post-check %', n; end if;
  select count(*) into n from app.content_item_cells where source='apstats_u2_harder_topic_2026_11_10' and is_primary and superseded_by is null; if n<>96 then raise exception 'topic cell count %', n; end if;
end $$;
do $$ begin raise exception 'REHEARSAL OK (rolled back): published=%, validated_labels=%, topic_cells=%', (select count(*) from tgt), (select count(*) from app.content_taxonomy_labels where source='apstats_u2_harder_2026_11_10' and label_status='validated'), (select count(*) from app.content_item_cells where source='apstats_u2_harder_topic_2026_11_10'); end $$;
rollback;
