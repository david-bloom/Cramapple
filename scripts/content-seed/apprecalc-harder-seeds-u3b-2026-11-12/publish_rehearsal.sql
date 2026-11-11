begin;
select pg_advisory_xact_lock(hashtext('cramapple-apprecalc-u3b-2026-11-12-publish-20261112'));
create temporary table lab (content_key text primary key, topic text, exp_hash text) on commit drop;
insert into lab values
('apprecalc-mcq-b2-h-3.4-a','3.4','da17f1b33d16c40e2328a37740d1eba1'),
('apprecalc-mcq-b2-sv-h-3.4-a-v1','3.4','d70d76dcf9a7e6b31047b16cde364cc5'),
('apprecalc-mcq-b2-sv-h-3.4-a-v2','3.4','ab0e77ab2ad07931169b19688d48ca40'),
('apprecalc-mcq-b2-sv-h-3.4-a-v3','3.4','c952e72d2f8194fac8414f2dae120eb3'),
('apprecalc-mcq-b2-h-3.4-b','3.4','d297dc566512bd5be75dc3645d317a04'),
('apprecalc-mcq-b2-sv-h-3.4-b-v1','3.4','637a2e4b2848e252966c6e169724035e'),
('apprecalc-mcq-b2-sv-h-3.4-b-v2','3.4','8195fac5433e8524e3deac1eaee6aa8d'),
('apprecalc-mcq-b2-sv-h-3.4-b-v3','3.4','da5dd63a57a39732d47cccdf1fe8abdd'),
('apprecalc-mcq-b2-h-3.5-a','3.5','91ad655fafdd12947539b28b66217f88'),
('apprecalc-mcq-b2-sv-h-3.5-a-v1','3.5','9b3ebd8c6bf558258f522f980953249e'),
('apprecalc-mcq-b2-sv-h-3.5-a-v2','3.5','4bf6b1135f905ec64f70ca61252ca0db'),
('apprecalc-mcq-b2-sv-h-3.5-a-v3','3.5','5fa858a6e28d53eb33e1559cf22443cc'),
('apprecalc-mcq-b2-h-3.5-b','3.5','6fa87cd52d747b7d045e12324b36b0ae'),
('apprecalc-mcq-b2-sv-h-3.5-b-v1','3.5','0c5ff77cc4db5962c36b949922fa6aec'),
('apprecalc-mcq-b2-sv-h-3.5-b-v2','3.5','ae06ad01a2d5999b25a54350bb78f1f7'),
('apprecalc-mcq-b2-sv-h-3.5-b-v3','3.5','b9b8285ab18fa2d693678a0bdbcdaf3c'),
('apprecalc-mcq-b2-h-3.6-a','3.6','4ad79cb1505ceb3f665a4432c6714669'),
('apprecalc-mcq-b2-sv-h-3.6-a-v1','3.6','118256f38cfcecf5da0b4900c93ca662'),
('apprecalc-mcq-b2-sv-h-3.6-a-v2','3.6','fd3109f2a2bbe06efcacfad794f76f99'),
('apprecalc-mcq-b2-sv-h-3.6-a-v3','3.6','c304d263901c3d0ca33ad7359df683db'),
('apprecalc-mcq-b2-h-3.6-b','3.6','8ac02f08537dc3596fdadd322aec9057'),
('apprecalc-mcq-b2-sv-h-3.6-b-v1','3.6','2fe62980dedcea0e6cd28b9f69220ab7'),
('apprecalc-mcq-b2-sv-h-3.6-b-v2','3.6','26cc0023b470ddeaf81520b75fd01e75'),
('apprecalc-mcq-b2-sv-h-3.6-b-v3','3.6','e1f4b7415add2156d6d60a8169bd3a8a'),
('apprecalc-mcq-b2-h-3.7-a','3.7','8194b517828dc982fe916dba176ace3d'),
('apprecalc-mcq-b2-sv-h-3.7-a-v1','3.7','e8f9ec6584a2d90dca01e29cc1e00655'),
('apprecalc-mcq-b2-sv-h-3.7-a-v2','3.7','c329e779e778929422abdd0a2bae2830'),
('apprecalc-mcq-b2-sv-h-3.7-a-v3','3.7','e0206f28231b5c43de996c27084daab5'),
('apprecalc-mcq-b2-h-3.7-b','3.7','b2e80ddc2c26a7e2c38a9e5624bfcbad'),
('apprecalc-mcq-b2-sv-h-3.7-b-v1','3.7','d152f3fc32f9d41c764803229426bbf4'),
('apprecalc-mcq-b2-sv-h-3.7-b-v2','3.7','5549175bc6f52cd33fe217b364384421'),
('apprecalc-mcq-b2-sv-h-3.7-b-v3','3.7','6e59a35a260c008334b6ea1860bc51e8'),
('apprecalc-mcq-b2-h-3.8-a','3.8','b2133f343b0c25046a170e1a9872fa88'),
('apprecalc-mcq-b2-sv-h-3.8-a-v1','3.8','9f9e44425d2365e8534fb930b402589a'),
('apprecalc-mcq-b2-sv-h-3.8-a-v2','3.8','d83c6f465da4935fc3f3056b052902d0'),
('apprecalc-mcq-b2-sv-h-3.8-a-v3','3.8','8a9a458166b403faacba95d0d867f272'),
('apprecalc-mcq-b2-h-3.8-b','3.8','ea9b919d9374ce13b84f1998b9aeee5e'),
('apprecalc-mcq-b2-sv-h-3.8-b-v1','3.8','5ce44938086ac4aa4527dd7bf2a5b488'),
('apprecalc-mcq-b2-sv-h-3.8-b-v2','3.8','a320a930bb0053f05d57b70268708664'),
('apprecalc-mcq-b2-sv-h-3.8-b-v3','3.8','758ba698a0d7223838eefc4353a2691f'),
('apprecalc-mcq-b2-h-3.9-a','3.9','b790123f323bedbb685a1cd95e45a96b'),
('apprecalc-mcq-b2-sv-h-3.9-a-v1','3.9','63b7bc687e1b4f9d9fe099c7c294fb69'),
('apprecalc-mcq-b2-sv-h-3.9-a-v2','3.9','41b20ffa3814132c8199fa5f6de34d10'),
('apprecalc-mcq-b2-sv-h-3.9-a-v3','3.9','e016a00b4e709b6e99261173e6275ab7'),
('apprecalc-mcq-b2-h-3.9-b','3.9','7449093b5872a5832645257d58b92113'),
('apprecalc-mcq-b2-sv-h-3.9-b-v1','3.9','24aed2146658f6daae99262f74a0c93e'),
('apprecalc-mcq-b2-sv-h-3.9-b-v2','3.9','001f6b7d17113247c5f75536b82d2fbe'),
('apprecalc-mcq-b2-sv-h-3.9-b-v3','3.9','d2854cb2792fe74cc47a5d6233b4c7ed');
create temporary table tgt on commit drop as
select l.*, ci.id item_id, civ.id version_id, gen_random_uuid() assignment_id, gen_random_uuid() label_id, gen_random_uuid() vd_id,
 '16383753-6775-430d-960a-544cd6ee0972'::uuid tsv, (case topic when '3.1' then array[3] when '3.2' then array[3] when '3.3' then array[3] when '3.4' then array[3] when '3.5' then array[3] when '3.6' then array[3] when '3.7' then array[3] when '3.8' then array[3] when '3.9' then array[3] when '3.10' then array[3] when '3.11' then array[3] when '3.12' then array[3] when '3.13' then array[3] when '3.14' then array[3] when '3.15' then array[3] end)::int[] req, 3 pu
from lab l join app.content_items ci on ci.content_key=l.content_key and ci.exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db'
join app.content_item_versions civ on civ.content_item_id=ci.id and civ.version_num=1
where ci.status='draft' and civ.status='draft';
do $$ begin
 if (select count(*) from tgt)<>48 then raise exception 'expected 48 draft targets, got %', (select count(*) from tgt); end if;
 if exists (select 1 from tgt where split_part(topic,'.',1)::int<>pu) then raise exception 'topic/unit mismatch'; end if;
 if exists (select 1 from tgt t join app.content_item_cells c on c.content_item_version_id=t.version_id) or exists (select 1 from tgt t join app.content_taxonomy_labels l on l.content_item_id=t.item_id) then raise exception 'a target already has cells or labels'; end if;
 if (select count(*) from (select t.content_key from tgt t join app.content_item_versions civ on civ.id=t.version_id join app.mcq_choices c on c.content_item_version_id=civ.id group by t.content_key, civ.stem, t.exp_hash having md5(civ.stem||'|'||string_agg(c.choice_key||':'||c.choice_text||':'||c.is_correct::text||':'||c.rationale,'|' order by c.choice_key))=t.exp_hash) z)<>48 then raise exception 'loaded text does not match the build manifest'; end if;
 if exists (select 1 from tgt t where not exists (select 1 from app.content_item_cells c join app.content_items ci2 on ci2.id=c.content_item_id where ci2.exam_pack_version_id='5522b532-5e50-41f2-99a2-10144bd4e8db' and c.topic_code=t.topic and c.taxonomy_source_version=t.tsv and c.superseded_by is null)) then raise exception 'a topic code is not present in the AP Precalculus taxonomy source version'; end if;
end $$;
insert into app.content_review_assignments (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, review_kind, status, assignment_purpose, created_by)
select assignment_id, version_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'tutor_question', 'mcq', 'pending', 'owner_remediation_approval', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
insert into app.content_review_decisions (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, tutor_score, difficulty_label, diagnostic_flag, concern_codes, note, tutor_decision, decision_payload, decision_hash, created_by)
select assignment_id, version_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'tutor_question', 1, null, false, array[]::text[],
 'AP Precalculus Unit 3 harder seeds and variants (batch apprecalc_u3b_2026_11_12): Product Owner review of owner-session-authored drafts, 2026-11-12. Arithmetic verified in Python; no model-checker pass, by Product Owner decision.',
 'approve',
 jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apprecalc_u3b_2026_11_12_po_approval','qa_date','2026-11-12','content_key',content_key),
 md5(jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apprecalc_u3b_2026_11_12_po_approval','qa_date','2026-11-12','content_key',content_key)::text),
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
 'apprecalc_u3b_2026_11_12',
 jsonb_build_object('origin','owner_authored','units_source','AP Precalculus Unit 3 (topics 3.x belong to unit 3; required_units set per topic from existing Unit 3 labels)','topic',topic,'report','scripts/content-seed/apchem-harder-seeds-u3-2026-11-12'),
 'apprecalc-u3b-2026-11-12-labeling', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
insert into app.content_taxonomy_validation_decisions (validation_decision_id, content_taxonomy_label_id, decided_by, decision, decision_source, reviewed_primary_unit, reviewed_required_units, notes)
select vd_id, label_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'confirmed', 'chat_review', pu, req,
 'Product Owner chat instruction 2026-11-12 (AP Precalculus harder seeds and variants). Topic assigned by the author from the question design (topic recorded on the cell); topic-only tagging, skill left null.' from tgt;
insert into app.content_item_cells (content_item_version_id, content_item_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id, validated_by, validated_at, validation_decision_id)
select version_id, item_id, tsv, topic, null, true, 'validated', 'apprecalc_u3b_2026_11_12_topic',
 'apprecalc-u3b-2026-11-12-labeling (topic set by the author from the question design)', null, now(), gen_random_uuid() from tgt;
update app.content_taxonomy_labels l set label_status='validated', validated_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, validated_at=now(), validation_decision_id=t.vd_id, validated_against_version_id=t.version_id, validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id) from tgt t where l.content_taxonomy_label_id=t.label_id;
update app.content_item_versions civ set status='published', published_at=coalesce(civ.published_at,now()), updated_at=now() from tgt where civ.id=tgt.version_id;
update app.content_items ci set status='published', updated_at=now() from tgt where ci.id=tgt.item_id;
do $$ declare n int; begin
  select count(*) into n from (select content_item_id from app.content_item_versions where status='published' group by 1 having count(*)>1) d; if n<>0 then raise exception 'duplicate published versions: %', n; end if;
  if (select count(*) from app.content_items ci join tgt on tgt.item_id=ci.id where ci.status='published')<>48 then raise exception 'publish count mismatch'; end if;
  select count(*) into n from app.content_taxonomy_labels l join tgt t on t.item_id=l.content_item_id where l.label_scope='serving' and l.superseded_by is null and l.label_status='validated' and l.validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id); if n<>48 then raise exception 'label post-check %', n; end if;
  select count(*) into n from app.content_item_cells where source='apprecalc_u3b_2026_11_12_topic' and is_primary and superseded_by is null; if n<>48 then raise exception 'topic cell count %', n; end if;
end $$;
do $$ begin raise exception 'REHEARSAL OK (rolled back): published=%, validated_labels=%, topic_cells=%', (select count(*) from tgt), (select count(*) from app.content_taxonomy_labels where source='apprecalc_u3b_2026_11_12' and label_status='validated'), (select count(*) from app.content_item_cells where source='apprecalc_u3b_2026_11_12_topic'); end $$;
rollback;
