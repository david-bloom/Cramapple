begin;
select pg_advisory_xact_lock(hashtext('cramapple-apphysics1-u1-2026-11-12-publish-20261112'));
create temporary table lab (content_key text primary key, topic text, exp_hash text) on commit drop;
insert into lab values
('apphysics1-mcq-b6-h-1.1-a','1.1','7d32aa8e121e2ebe87aa54cd6588b4c8'),
('apphysics1-mcq-b6-sv-h-1.1-a-v1','1.1','f1ca6aa8daedd53662ea0e80c1cfc6fd'),
('apphysics1-mcq-b6-sv-h-1.1-a-v2','1.1','f9b49a37c5a9920822c5b86dd225943a'),
('apphysics1-mcq-b6-sv-h-1.1-a-v3','1.1','0133aa4f11e02fb2984efd044a8a2a2c'),
('apphysics1-mcq-b6-h-1.1-b','1.1','0063096456a851c38bee9c912c30e81d'),
('apphysics1-mcq-b6-sv-h-1.1-b-v1','1.1','e4cbf3ee6fdc41b183ec69f49466f976'),
('apphysics1-mcq-b6-sv-h-1.1-b-v2','1.1','89129ba3233432b15a317a2b906008ca'),
('apphysics1-mcq-b6-sv-h-1.1-b-v3','1.1','1eebff4dd0761a91db3046f1248d2524'),
('apphysics1-mcq-b6-h-1.2-a','1.2','23640fc7c32f898de0d1d7e2f209c85b'),
('apphysics1-mcq-b6-sv-h-1.2-a-v1','1.2','d8f59c10e27c2329cf40e6d5fbeb9c93'),
('apphysics1-mcq-b6-sv-h-1.2-a-v2','1.2','05f660081234e683522bcfdb5eaa085a'),
('apphysics1-mcq-b6-sv-h-1.2-a-v3','1.2','6a5a6edb4a58511fa3042094da791b7d'),
('apphysics1-mcq-b6-h-1.2-b','1.2','f011525dec6a33a5f87d83641e6013b6'),
('apphysics1-mcq-b6-sv-h-1.2-b-v1','1.2','fcf891bec3c13ea053246900bc92be3d'),
('apphysics1-mcq-b6-sv-h-1.2-b-v2','1.2','5f844e2face3795d586fccfbdb1dfee1'),
('apphysics1-mcq-b6-sv-h-1.2-b-v3','1.2','9456e7d7a183cc1b8b17a5a91a8ff42c'),
('apphysics1-mcq-b6-h-1.3-a','1.3','2920eb86c0228462d17444d7dca2f5be'),
('apphysics1-mcq-b6-sv-h-1.3-a-v1','1.3','30fab60e87ff8316fb72548b6be91bf4'),
('apphysics1-mcq-b6-sv-h-1.3-a-v2','1.3','3f2a7cad04776ba3569b4dda9f85ab5d'),
('apphysics1-mcq-b6-sv-h-1.3-a-v3','1.3','be161a7b7c77bb57e30806546b64319c'),
('apphysics1-mcq-b6-h-1.3-b','1.3','3ac1888df12d204f52bea75491b003e5'),
('apphysics1-mcq-b6-sv-h-1.3-b-v1','1.3','6e21d7669b0aa4a81df7602d22b7bcc0'),
('apphysics1-mcq-b6-sv-h-1.3-b-v2','1.3','d969881b32b93ec5c52b916865c4be87'),
('apphysics1-mcq-b6-sv-h-1.3-b-v3','1.3','740633e7f0fcafd79f291880428adeef'),
('apphysics1-mcq-b6-h-1.4-a','1.4','4d5454bf628a20e2caf5225ed255e244'),
('apphysics1-mcq-b6-sv-h-1.4-a-v1','1.4','5ac027e5be5cd148ad1499dbdefb52d4'),
('apphysics1-mcq-b6-sv-h-1.4-a-v2','1.4','ef5f6dc9d0e38a2f7113a0746cfeb2f2'),
('apphysics1-mcq-b6-sv-h-1.4-a-v3','1.4','228adf8b0a98ab07e1f44b61c6c5414e'),
('apphysics1-mcq-b6-h-1.4-b','1.4','e5c0ab612ea3f4c60e8de12c4fec7a31'),
('apphysics1-mcq-b6-sv-h-1.4-b-v1','1.4','e4f355496f9fecbe012d33dcebe9eb2e'),
('apphysics1-mcq-b6-sv-h-1.4-b-v2','1.4','c80ae8bb4edfe77836d4a42e1e91f2fc'),
('apphysics1-mcq-b6-sv-h-1.4-b-v3','1.4','76f1654428817a267f7aba5aa0e1a3f2'),
('apphysics1-mcq-b6-h-1.5-a','1.5','7b0698af5fcaffe18162362570f5703f'),
('apphysics1-mcq-b6-sv-h-1.5-a-v1','1.5','d77dbab70dea66ffa58821ec0def3db4'),
('apphysics1-mcq-b6-sv-h-1.5-a-v2','1.5','34d0ec28dfd6c3aad17c72807fa18f4b'),
('apphysics1-mcq-b6-sv-h-1.5-a-v3','1.5','eb35e4eb18b6f355fb685f926cbd5d70'),
('apphysics1-mcq-b6-h-1.5-b','1.5','aaafa65525fc51254bf57351f0f84474'),
('apphysics1-mcq-b6-sv-h-1.5-b-v1','1.5','fc2e632841eb99c2ea8e8b17045b6c37'),
('apphysics1-mcq-b6-sv-h-1.5-b-v2','1.5','a18958677ee95c4dcc0b60b1e600b827'),
('apphysics1-mcq-b6-sv-h-1.5-b-v3','1.5','318d97b3a5bcb84dae4c181730ae93f1');
create temporary table tgt on commit drop as
select l.*, ci.id item_id, civ.id version_id, gen_random_uuid() assignment_id, gen_random_uuid() label_id, gen_random_uuid() vd_id,
 '27111dec-ee07-48f1-86cf-1a5833dd2962'::uuid tsv, (case topic when '1.1' then array[1] when '1.2' then array[1] when '1.3' then array[1] when '1.4' then array[1] when '1.5' then array[1] end)::int[] req, 1 pu
from lab l join app.content_items ci on ci.content_key=l.content_key and ci.exam_pack_version_id='29c719dc-701b-470f-9e49-fab981722d3f'
join app.content_item_versions civ on civ.content_item_id=ci.id and civ.version_num=1
where ci.status='draft' and civ.status='draft';
do $$ begin
 if (select count(*) from tgt)<>40 then raise exception 'expected 40 draft targets, got %', (select count(*) from tgt); end if;
 if exists (select 1 from tgt where split_part(topic,'.',1)::int<>pu) then raise exception 'topic/unit mismatch'; end if;
 if exists (select 1 from tgt t join app.content_item_cells c on c.content_item_version_id=t.version_id) or exists (select 1 from tgt t join app.content_taxonomy_labels l on l.content_item_id=t.item_id) then raise exception 'a target already has cells or labels'; end if;
 if (select count(*) from (select t.content_key from tgt t join app.content_item_versions civ on civ.id=t.version_id join app.mcq_choices c on c.content_item_version_id=civ.id group by t.content_key, civ.stem, t.exp_hash having md5(civ.stem||'|'||string_agg(c.choice_key||':'||c.choice_text||':'||c.is_correct::text||':'||c.rationale,'|' order by c.choice_key))=t.exp_hash) z)<>40 then raise exception 'loaded text does not match the build manifest'; end if;
 if exists (select 1 from tgt t where not exists (select 1 from app.taxonomy_topics tt where tt.taxonomy_source_version=t.tsv and tt.topic_code=t.topic)) then raise exception 'a topic code is not present in the taxonomy source version'; end if;
end $$;
insert into app.content_review_assignments (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, review_kind, status, assignment_purpose, created_by)
select assignment_id, version_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'tutor_question', 'mcq', 'pending', 'owner_remediation_approval', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
insert into app.content_review_decisions (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, tutor_score, difficulty_label, diagnostic_flag, concern_codes, note, tutor_decision, decision_payload, decision_hash, created_by)
select assignment_id, version_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'tutor_question', 1, null, false, array[]::text[],
 'AP Physics 1 Unit 3 harder seeds and variants (batch apphysics1_u1_2026_11_12): Product Owner review of owner-session-authored drafts, 2026-11-12. Arithmetic verified in Python; no model-checker pass, by Product Owner decision.',
 'approve',
 jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apphysics1_u1_2026_11_12_po_approval','qa_date','2026-11-12','content_key',content_key),
 md5(jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apphysics1_u1_2026_11_12_po_approval','qa_date','2026-11-12','content_key',content_key)::text),
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
 'apphysics1_u1_2026_11_12',
 jsonb_build_object('origin','owner_authored','units_source','AP Physics 1 Unit 1 (topics 1.x belong to unit 3; required_units set per topic from existing Unit 3 labels)','topic',topic,'report','scripts/content-seed/apchem-harder-seeds-u3-2026-11-12'),
 'apphysics1-u1-2026-11-12-labeling', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
insert into app.content_taxonomy_validation_decisions (validation_decision_id, content_taxonomy_label_id, decided_by, decision, decision_source, reviewed_primary_unit, reviewed_required_units, notes)
select vd_id, label_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'confirmed', 'chat_review', pu, req,
 'Product Owner chat instruction 2026-11-12 (AP Physics 1 harder seeds and variants). Topic assigned by the author from the question design (topic recorded on the cell); topic-only tagging, skill left null.' from tgt;
insert into app.content_item_cells (content_item_version_id, content_item_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id, validated_by, validated_at, validation_decision_id)
select version_id, item_id, tsv, topic, null, true, 'validated', 'apphysics1_u1_2026_11_12_topic',
 'apphysics1-u1-2026-11-12-labeling (topic set by the author from the question design)', null, now(), gen_random_uuid() from tgt;
update app.content_taxonomy_labels l set label_status='validated', validated_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, validated_at=now(), validation_decision_id=t.vd_id, validated_against_version_id=t.version_id, validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id) from tgt t where l.content_taxonomy_label_id=t.label_id;
update app.content_item_versions civ set status='published', published_at=coalesce(civ.published_at,now()), updated_at=now() from tgt where civ.id=tgt.version_id;
update app.content_items ci set status='published', updated_at=now() from tgt where ci.id=tgt.item_id;
do $$ declare n int; begin
  select count(*) into n from (select content_item_id from app.content_item_versions where status='published' group by 1 having count(*)>1) d; if n<>0 then raise exception 'duplicate published versions: %', n; end if;
  if (select count(*) from app.content_items ci join tgt on tgt.item_id=ci.id where ci.status='published')<>40 then raise exception 'publish count mismatch'; end if;
  select count(*) into n from app.content_taxonomy_labels l join tgt t on t.item_id=l.content_item_id where l.label_scope='serving' and l.superseded_by is null and l.label_status='validated' and l.validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id); if n<>40 then raise exception 'label post-check %', n; end if;
  select count(*) into n from app.content_item_cells where source='apphysics1_u1_2026_11_12_topic' and is_primary and superseded_by is null; if n<>40 then raise exception 'topic cell count %', n; end if;
end $$;
do $$ begin raise exception 'REHEARSAL OK (rolled back): published=%, validated_labels=%, topic_cells=%', (select count(*) from tgt), (select count(*) from app.content_taxonomy_labels where source='apphysics1_u1_2026_11_12' and label_status='validated'), (select count(*) from app.content_item_cells where source='apphysics1_u1_2026_11_12_topic'); end $$;
rollback;
