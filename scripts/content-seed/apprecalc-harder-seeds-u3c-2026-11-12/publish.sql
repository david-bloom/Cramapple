begin;
select pg_advisory_xact_lock(hashtext('cramapple-apprecalc-u3c-2026-11-12-publish-20261112'));
create temporary table lab (content_key text primary key, topic text, exp_hash text) on commit drop;
insert into lab values
('apprecalc-mcq-b3-h-3.10-a','3.10','1ec9ac0149775585c49317b75d0a1ac9'),
('apprecalc-mcq-b3-sv-h-3.10-a-v1','3.10','19b9aa7c24d251f625c5800d9089ac56'),
('apprecalc-mcq-b3-sv-h-3.10-a-v2','3.10','b3c182f9545d8ee31c7c9dcefac278d9'),
('apprecalc-mcq-b3-sv-h-3.10-a-v3','3.10','0405e16cb9b2e072e1f4d1681392ed08'),
('apprecalc-mcq-b3-h-3.10-b','3.10','5482f5ffcd736fa799edf099ce3a7583'),
('apprecalc-mcq-b3-sv-h-3.10-b-v1','3.10','1fac6aa83abe3a1d4d96976b5a8d09ee'),
('apprecalc-mcq-b3-sv-h-3.10-b-v2','3.10','ad2b500c78d0eafcc9c88078f1ab7ffb'),
('apprecalc-mcq-b3-sv-h-3.10-b-v3','3.10','8a265c19db2c1b2317a39c9f62118175'),
('apprecalc-mcq-b3-h-3.11-a','3.11','9bf422d3b5be81e40a0fca0c4f989553'),
('apprecalc-mcq-b3-sv-h-3.11-a-v1','3.11','ab79c2067d87741708cef7a431c5c451'),
('apprecalc-mcq-b3-sv-h-3.11-a-v2','3.11','0fdbdf3b662090986f7060f19c3640c6'),
('apprecalc-mcq-b3-sv-h-3.11-a-v3','3.11','f1318b50de37ad0842a885574441a8af'),
('apprecalc-mcq-b3-h-3.11-b','3.11','d12f3cef4a4a9834b3d4423b2077ed90'),
('apprecalc-mcq-b3-sv-h-3.11-b-v1','3.11','22ee9b3f009cea0136cff7282ba63d42'),
('apprecalc-mcq-b3-sv-h-3.11-b-v2','3.11','8af37186cb6e8ae665e16fe668e7e054'),
('apprecalc-mcq-b3-sv-h-3.11-b-v3','3.11','c9c2949457f931960cd9cc9256751907'),
('apprecalc-mcq-b3-h-3.12-a','3.12','06cddb6eb0e943ef1fa9e10e83239fc5'),
('apprecalc-mcq-b3-sv-h-3.12-a-v1','3.12','d2458643ca900e130c27a965e3238692'),
('apprecalc-mcq-b3-sv-h-3.12-a-v2','3.12','30ed645d48c6ce4bf65736608283453f'),
('apprecalc-mcq-b3-sv-h-3.12-a-v3','3.12','a4589c4de7f6b15b08e50edbd9dda416'),
('apprecalc-mcq-b3-h-3.12-b','3.12','e005528d0643ec7bda4b679f9db4f23b'),
('apprecalc-mcq-b3-sv-h-3.12-b-v1','3.12','58cf78669d91ead3268d18f4c105777f'),
('apprecalc-mcq-b3-sv-h-3.12-b-v2','3.12','1609a1a1d282a4bbe3a5497d9ba7c746'),
('apprecalc-mcq-b3-sv-h-3.12-b-v3','3.12','c6bc1706436d3976cba133c33a3b626d'),
('apprecalc-mcq-b3-h-3.13-a','3.13','8d427a608d637c02d75855549481e57a'),
('apprecalc-mcq-b3-sv-h-3.13-a-v1','3.13','a7061dad0b316a6db3f630168fe0d34c'),
('apprecalc-mcq-b3-sv-h-3.13-a-v2','3.13','a8bd8d81e82b1dc366c419a81a900eac'),
('apprecalc-mcq-b3-sv-h-3.13-a-v3','3.13','9ff906b010d86d4b91eab3c4a5552cf7'),
('apprecalc-mcq-b3-h-3.13-b','3.13','8512453f0226a743550efad41f9a17c6'),
('apprecalc-mcq-b3-sv-h-3.13-b-v1','3.13','98a1b034e0d249704750e9a2e2ea6a10'),
('apprecalc-mcq-b3-sv-h-3.13-b-v2','3.13','885bf06d463046dd36c0dd3365e81980'),
('apprecalc-mcq-b3-sv-h-3.13-b-v3','3.13','bc264b3dc29e61d45a803a3570796f4d'),
('apprecalc-mcq-b3-h-3.14-a','3.14','69418ef35ffb59fb6318452eaba822e7'),
('apprecalc-mcq-b3-sv-h-3.14-a-v1','3.14','c25e26d6ef90fe00bbb91a9a38e7d6bc'),
('apprecalc-mcq-b3-sv-h-3.14-a-v2','3.14','5aee1f8a87d26212e811a65e1a7c309d'),
('apprecalc-mcq-b3-sv-h-3.14-a-v3','3.14','b08c2282643de58babdf029d60f10a55'),
('apprecalc-mcq-b3-h-3.14-b','3.14','078aab15461c1a3f846d9e116b058c26'),
('apprecalc-mcq-b3-sv-h-3.14-b-v1','3.14','65e00aff6895e71e04e50f742835f0d0'),
('apprecalc-mcq-b3-sv-h-3.14-b-v2','3.14','6cc28aeb3a4aa11ed669c86aa0e492cd'),
('apprecalc-mcq-b3-sv-h-3.14-b-v3','3.14','c94460f31ce6b9e7ba0ea96eefdc9f96'),
('apprecalc-mcq-b3-h-3.15-a','3.15','1649cc518d4860df77efc0320c1f5555'),
('apprecalc-mcq-b3-sv-h-3.15-a-v1','3.15','b9c5617e3ac912cfd66da0808e00a0fc'),
('apprecalc-mcq-b3-sv-h-3.15-a-v2','3.15','a135f20a3cf9391944dac0c352d6a71e'),
('apprecalc-mcq-b3-sv-h-3.15-a-v3','3.15','523b05fc0f8157ddb444409d9290f9fb'),
('apprecalc-mcq-b3-h-3.15-b','3.15','c4b09dfcabe358250aee356350b38bae'),
('apprecalc-mcq-b3-sv-h-3.15-b-v1','3.15','058add9916cb7591a3e463b863ebae22'),
('apprecalc-mcq-b3-sv-h-3.15-b-v2','3.15','e147cd080288c6ccf9c7cb497232201d'),
('apprecalc-mcq-b3-sv-h-3.15-b-v3','3.15','795be6c328b6ce77567ab0dfead6c9a3');
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
 'AP Precalculus Unit 3 harder seeds and variants (batch apprecalc_u3c_2026_11_12): Product Owner review of owner-session-authored drafts, 2026-11-12. Arithmetic verified in Python; no model-checker pass, by Product Owner decision.',
 'approve',
 jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apprecalc_u3c_2026_11_12_po_approval','qa_date','2026-11-12','content_key',content_key),
 md5(jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apprecalc_u3c_2026_11_12_po_approval','qa_date','2026-11-12','content_key',content_key)::text),
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
 'apprecalc_u3c_2026_11_12',
 jsonb_build_object('origin','owner_authored','units_source','AP Precalculus Unit 3 (topics 3.x belong to unit 3; required_units set per topic from existing Unit 3 labels)','topic',topic,'report','scripts/content-seed/apchem-harder-seeds-u3-2026-11-12'),
 'apprecalc-u3c-2026-11-12-labeling', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
insert into app.content_taxonomy_validation_decisions (validation_decision_id, content_taxonomy_label_id, decided_by, decision, decision_source, reviewed_primary_unit, reviewed_required_units, notes)
select vd_id, label_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'confirmed', 'chat_review', pu, req,
 'Product Owner chat instruction 2026-11-12 (AP Precalculus harder seeds and variants). Topic assigned by the author from the question design (topic recorded on the cell); topic-only tagging, skill left null.' from tgt;
insert into app.content_item_cells (content_item_version_id, content_item_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id, validated_by, validated_at, validation_decision_id)
select version_id, item_id, tsv, topic, null, true, 'validated', 'apprecalc_u3c_2026_11_12_topic',
 'apprecalc-u3c-2026-11-12-labeling (topic set by the author from the question design)', null, now(), gen_random_uuid() from tgt;
update app.content_taxonomy_labels l set label_status='validated', validated_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, validated_at=now(), validation_decision_id=t.vd_id, validated_against_version_id=t.version_id, validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id) from tgt t where l.content_taxonomy_label_id=t.label_id;
update app.content_item_versions civ set status='published', published_at=coalesce(civ.published_at,now()), updated_at=now() from tgt where civ.id=tgt.version_id;
update app.content_items ci set status='published', updated_at=now() from tgt where ci.id=tgt.item_id;
do $$ declare n int; begin
  select count(*) into n from (select content_item_id from app.content_item_versions where status='published' group by 1 having count(*)>1) d; if n<>0 then raise exception 'duplicate published versions: %', n; end if;
  if (select count(*) from app.content_items ci join tgt on tgt.item_id=ci.id where ci.status='published')<>48 then raise exception 'publish count mismatch'; end if;
  select count(*) into n from app.content_taxonomy_labels l join tgt t on t.item_id=l.content_item_id where l.label_scope='serving' and l.superseded_by is null and l.label_status='validated' and l.validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id); if n<>48 then raise exception 'label post-check %', n; end if;
  select count(*) into n from app.content_item_cells where source='apprecalc_u3c_2026_11_12_topic' and is_primary and superseded_by is null; if n<>48 then raise exception 'topic cell count %', n; end if;
end $$;
select (select count(*) from tgt) published, (select count(*) from app.content_taxonomy_labels where source='apprecalc_u3c_2026_11_12' and label_status='validated') validated_labels, (select count(*) from app.content_item_cells where source='apprecalc_u3c_2026_11_12_topic') topic_cells;
commit;
