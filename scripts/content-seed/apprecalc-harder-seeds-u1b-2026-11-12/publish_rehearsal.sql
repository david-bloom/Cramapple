begin;
select pg_advisory_xact_lock(hashtext('cramapple-apprecalc-u1b-2026-11-12-publish-20261112'));
create temporary table lab (content_key text primary key, topic text, exp_hash text) on commit drop;
insert into lab values
('apprecalc-mcq-b9-h-1.8-a','1.8','3a3ee46f4e9879833d16e8e8621f8054'),
('apprecalc-mcq-b9-sv-h-1.8-a-v1','1.8','b0c945eb6d61991e8cae63d17dc6db53'),
('apprecalc-mcq-b9-sv-h-1.8-a-v2','1.8','f26a5a45c5d1276824734807c65bc097'),
('apprecalc-mcq-b9-sv-h-1.8-a-v3','1.8','6e839b1d9c1e332cd3c4657124bde444'),
('apprecalc-mcq-b9-h-1.8-b','1.8','af5216b0bd71e7c9c4f8dcf0e4960aaa'),
('apprecalc-mcq-b9-sv-h-1.8-b-v1','1.8','f49bf5e3ff9c9f27d81ff55901252143'),
('apprecalc-mcq-b9-sv-h-1.8-b-v2','1.8','ee4a4a1b98b9d050e762d101bf37162c'),
('apprecalc-mcq-b9-sv-h-1.8-b-v3','1.8','2ae8c82c61ca5786c2af47d0cb3d590d'),
('apprecalc-mcq-b9-h-1.9-a','1.9','66040c2f576ab687ce9296fe35250e2a'),
('apprecalc-mcq-b9-sv-h-1.9-a-v1','1.9','8a599334fadb047b82855b043cea2302'),
('apprecalc-mcq-b9-sv-h-1.9-a-v2','1.9','928c62d79a543a75e324871cc29dab22'),
('apprecalc-mcq-b9-sv-h-1.9-a-v3','1.9','a5d3bbcc945d48c50eb9688fb17f38d0'),
('apprecalc-mcq-b9-h-1.9-b','1.9','2528334fec321db15febd8ba8cb554ee'),
('apprecalc-mcq-b9-sv-h-1.9-b-v1','1.9','d8f2da92a7892c1ac78efd5bf3214093'),
('apprecalc-mcq-b9-sv-h-1.9-b-v2','1.9','7e858fc0083f4c5585f46908b72af5fb'),
('apprecalc-mcq-b9-sv-h-1.9-b-v3','1.9','0ceeb706fa82b42d9c8d54827f7df285'),
('apprecalc-mcq-b9-h-1.10-a','1.10','bfbc8bc08a8145c77f569098d5461402'),
('apprecalc-mcq-b9-sv-h-1.10-a-v1','1.10','7505bb68c78406babf03c8407bdfb345'),
('apprecalc-mcq-b9-sv-h-1.10-a-v2','1.10','ea9a981af3b94869960c948610f08b59'),
('apprecalc-mcq-b9-sv-h-1.10-a-v3','1.10','a3ba6a7eae8f703fc06284e8083bcb25'),
('apprecalc-mcq-b9-h-1.10-b','1.10','c8a65b11ea463882e90883251eaaba59'),
('apprecalc-mcq-b9-sv-h-1.10-b-v1','1.10','252284491d784c2beb41333e81da9bf3'),
('apprecalc-mcq-b9-sv-h-1.10-b-v2','1.10','b7fc5c83cc4f622722e19d599eabbc45'),
('apprecalc-mcq-b9-sv-h-1.10-b-v3','1.10','e8de7581c5df5b8e80c254968e786e57'),
('apprecalc-mcq-b9-h-1.11-a','1.11','7033498b8760e48f525636fdbb3811f4'),
('apprecalc-mcq-b9-sv-h-1.11-a-v1','1.11','4ff290d1f53749a26f2641d826fe0914'),
('apprecalc-mcq-b9-sv-h-1.11-a-v2','1.11','1f7f7528ba28e912007746b9dde871b9'),
('apprecalc-mcq-b9-sv-h-1.11-a-v3','1.11','51f6dcb8a18e17db23e0a7978a6fb942'),
('apprecalc-mcq-b9-h-1.11-b','1.11','7928342a5444cc6013f7f9db8d80c16a'),
('apprecalc-mcq-b9-sv-h-1.11-b-v1','1.11','5ae17124e671e2ad5f3f6fed376ae1de'),
('apprecalc-mcq-b9-sv-h-1.11-b-v2','1.11','3fc7ab52abfd5807129ac4683973f942'),
('apprecalc-mcq-b9-sv-h-1.11-b-v3','1.11','e625a6af61137ab5e509027e0fdc589d'),
('apprecalc-mcq-b9-h-1.12-a','1.12','2a8880c054b803fbfc30363d193645f8'),
('apprecalc-mcq-b9-sv-h-1.12-a-v1','1.12','4ce3568a25da0f813216687d5a48c96c'),
('apprecalc-mcq-b9-sv-h-1.12-a-v2','1.12','6cb7d85c367be2a883f59f91a2c8ac7b'),
('apprecalc-mcq-b9-sv-h-1.12-a-v3','1.12','f7b992a3d8107849147104c3d1694388'),
('apprecalc-mcq-b9-h-1.12-b','1.12','85c59c66e2517532e9247af223ed5f24'),
('apprecalc-mcq-b9-sv-h-1.12-b-v1','1.12','da467c72a8891275db82ff2282b75f46'),
('apprecalc-mcq-b9-sv-h-1.12-b-v2','1.12','1d47a48a12d81a55e9891dfd13b13a26'),
('apprecalc-mcq-b9-sv-h-1.12-b-v3','1.12','ea9d62c0ed7e32060129d903dc0feeba'),
('apprecalc-mcq-b9-h-1.13-a','1.13','d398265cac671c7246ba77074241037b'),
('apprecalc-mcq-b9-sv-h-1.13-a-v1','1.13','a984a206557552f6a82d822a25f0bc9f'),
('apprecalc-mcq-b9-sv-h-1.13-a-v2','1.13','c442aac18aab09d34b96a79d35d206e1'),
('apprecalc-mcq-b9-sv-h-1.13-a-v3','1.13','61c967a6709ef0ba4800e8275ee9d5c4'),
('apprecalc-mcq-b9-h-1.13-b','1.13','8b2361316cb577980cfad6210ed10a9a'),
('apprecalc-mcq-b9-sv-h-1.13-b-v1','1.13','0d5566952f1e3c76fb54044e8327e8f8'),
('apprecalc-mcq-b9-sv-h-1.13-b-v2','1.13','b28fae0a348397fdafa4744ec147bd5a'),
('apprecalc-mcq-b9-sv-h-1.13-b-v3','1.13','897144e4f22d32efd9a7fcca9f8e7df0'),
('apprecalc-mcq-b9-h-1.14-a','1.14','0837f3d2708814d0ed90dcadbb9e6732'),
('apprecalc-mcq-b9-sv-h-1.14-a-v1','1.14','eedec9abf302930ae0e62825a7c78a0c'),
('apprecalc-mcq-b9-sv-h-1.14-a-v2','1.14','84e7dbc40d17f088c351d96d68bba90a'),
('apprecalc-mcq-b9-sv-h-1.14-a-v3','1.14','44c4eb906c705fa7223bb9500cc43a34'),
('apprecalc-mcq-b9-h-1.14-b','1.14','2804f3b8371696d2ee2d7ecb0de4ccca'),
('apprecalc-mcq-b9-sv-h-1.14-b-v1','1.14','90f1af9a87d15c59c236dcd1ce7a737d'),
('apprecalc-mcq-b9-sv-h-1.14-b-v2','1.14','7a1a209efcbf5ca51b84475601ca05ab'),
('apprecalc-mcq-b9-sv-h-1.14-b-v3','1.14','37d6429fd71d5c6c869d6552c27cf0dd');
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
 'AP Precalculus Unit 3 harder seeds and variants (batch apprecalc_u1b_2026_11_12): Product Owner review of owner-session-authored drafts, 2026-11-12. Arithmetic verified in Python; no model-checker pass, by Product Owner decision.',
 'approve',
 jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apprecalc_u1b_2026_11_12_po_approval','qa_date','2026-11-12','content_key',content_key),
 md5(jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apprecalc_u1b_2026_11_12_po_approval','qa_date','2026-11-12','content_key',content_key)::text),
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
 'apprecalc_u1b_2026_11_12',
 jsonb_build_object('origin','owner_authored','units_source','AP Precalculus Unit 1 (topics 1.x belong to unit 3; required_units set per topic from existing Unit 3 labels)','topic',topic,'report','scripts/content-seed/apchem-harder-seeds-u3-2026-11-12'),
 'apprecalc-u1b-2026-11-12-labeling', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
insert into app.content_taxonomy_validation_decisions (validation_decision_id, content_taxonomy_label_id, decided_by, decision, decision_source, reviewed_primary_unit, reviewed_required_units, notes)
select vd_id, label_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'confirmed', 'chat_review', pu, req,
 'Product Owner chat instruction 2026-11-12 (AP Precalculus harder seeds and variants). Topic assigned by the author from the question design (topic recorded on the cell); topic-only tagging, skill left null.' from tgt;
insert into app.content_item_cells (content_item_version_id, content_item_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id, validated_by, validated_at, validation_decision_id)
select version_id, item_id, tsv, topic, null, true, 'validated', 'apprecalc_u1b_2026_11_12_topic',
 'apprecalc-u1b-2026-11-12-labeling (topic set by the author from the question design)', null, now(), gen_random_uuid() from tgt;
update app.content_taxonomy_labels l set label_status='validated', validated_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, validated_at=now(), validation_decision_id=t.vd_id, validated_against_version_id=t.version_id, validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id) from tgt t where l.content_taxonomy_label_id=t.label_id;
update app.content_item_versions civ set status='published', published_at=coalesce(civ.published_at,now()), updated_at=now() from tgt where civ.id=tgt.version_id;
update app.content_items ci set status='published', updated_at=now() from tgt where ci.id=tgt.item_id;
do $$ declare n int; begin
  select count(*) into n from (select content_item_id from app.content_item_versions where status='published' group by 1 having count(*)>1) d; if n<>0 then raise exception 'duplicate published versions: %', n; end if;
  if (select count(*) from app.content_items ci join tgt on tgt.item_id=ci.id where ci.status='published')<>56 then raise exception 'publish count mismatch'; end if;
  select count(*) into n from app.content_taxonomy_labels l join tgt t on t.item_id=l.content_item_id where l.label_scope='serving' and l.superseded_by is null and l.label_status='validated' and l.validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id); if n<>56 then raise exception 'label post-check %', n; end if;
  select count(*) into n from app.content_item_cells where source='apprecalc_u1b_2026_11_12_topic' and is_primary and superseded_by is null; if n<>56 then raise exception 'topic cell count %', n; end if;
end $$;
do $$ begin raise exception 'REHEARSAL OK (rolled back): published=%, validated_labels=%, topic_cells=%', (select count(*) from tgt), (select count(*) from app.content_taxonomy_labels where source='apprecalc_u1b_2026_11_12' and label_status='validated'), (select count(*) from app.content_item_cells where source='apprecalc_u1b_2026_11_12_topic'); end $$;
rollback;
