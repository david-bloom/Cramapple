begin;
select pg_advisory_xact_lock(hashtext('cramapple-apchem-u2-2026-11-12-publish-20261112'));
create temporary table lab (content_key text primary key, topic text, exp_hash text) on commit drop;
insert into lab values
('apchem-mcq-b5-h-2.1-a','2.1','831b470a91a30c2131bd315e7a78a1da'),
('apchem-mcq-b5-sv-h-2.1-a-v1','2.1','3423f2293aa47949b4ae188e6a926da6'),
('apchem-mcq-b5-sv-h-2.1-a-v2','2.1','0d913fa07d463438e8f976dcc45e7501'),
('apchem-mcq-b5-sv-h-2.1-a-v3','2.1','11d58b9a1ef6167eaf1f8827dcf51f94'),
('apchem-mcq-b5-h-2.1-b','2.1','be80a2994e4e5950d7b15196c9fa6101'),
('apchem-mcq-b5-sv-h-2.1-b-v1','2.1','285cb635f1928f513b642d9217c8ff7e'),
('apchem-mcq-b5-sv-h-2.1-b-v2','2.1','742e2eb696d9f5b0efdb3f4f8011a7dc'),
('apchem-mcq-b5-sv-h-2.1-b-v3','2.1','867a564eb1def23eea8d571fcfff5f1e'),
('apchem-mcq-b5-h-2.2-a','2.2','e2d2b7d0fba4589ea5cb77f2e9ae85d6'),
('apchem-mcq-b5-sv-h-2.2-a-v1','2.2','8d5940e6a2127c7c20a6e0b72caa9709'),
('apchem-mcq-b5-sv-h-2.2-a-v2','2.2','f2c11433b45fd9a942a642fbf21171d6'),
('apchem-mcq-b5-sv-h-2.2-a-v3','2.2','11c1e34862d70d930f01136cd07db3c2'),
('apchem-mcq-b5-h-2.2-b','2.2','a5975981abe88500c62e175efa5a83dd'),
('apchem-mcq-b5-sv-h-2.2-b-v1','2.2','a6b0652204f46ff088d23656ff1c77ce'),
('apchem-mcq-b5-sv-h-2.2-b-v2','2.2','6c4fedc9e76119d2d0fccc0483081722'),
('apchem-mcq-b5-sv-h-2.2-b-v3','2.2','bdc86e691477f4d521956bda83ee02f8'),
('apchem-mcq-b5-h-2.3-a','2.3','17b36159482fc3d09c4cda478e042973'),
('apchem-mcq-b5-sv-h-2.3-a-v1','2.3','422a3626f3aead1bf574fcf2de6fd448'),
('apchem-mcq-b5-sv-h-2.3-a-v2','2.3','4c7706ce794927b6018381c1084f9ca0'),
('apchem-mcq-b5-sv-h-2.3-a-v3','2.3','f46651171361e415956f9560c2920346'),
('apchem-mcq-b5-h-2.3-b','2.3','0953660360427a8dd712732a178491fc'),
('apchem-mcq-b5-sv-h-2.3-b-v1','2.3','54f6295914e1fcfed78861c50c6504b1'),
('apchem-mcq-b5-sv-h-2.3-b-v2','2.3','efed22af5e046a2c4e59357355d92a8d'),
('apchem-mcq-b5-sv-h-2.3-b-v3','2.3','a1e73a6349a19c645d4c4cb5e957d239'),
('apchem-mcq-b5-h-2.4-a','2.4','1b708c1289444d6bcf940c6bdb06074d'),
('apchem-mcq-b5-sv-h-2.4-a-v1','2.4','61668a75645300f80fb09eddd9668c33'),
('apchem-mcq-b5-sv-h-2.4-a-v2','2.4','1214c8a8d1fe2d9dd1b047760e02a6f3'),
('apchem-mcq-b5-sv-h-2.4-a-v3','2.4','ed3467b1c16614bd2fd4f059f93cd0db'),
('apchem-mcq-b5-h-2.4-b','2.4','e08bb0c1e8c9ae437f31d6acc094a823'),
('apchem-mcq-b5-sv-h-2.4-b-v1','2.4','0faa1a7e76d043403fb6fd9ad3c8fcf6'),
('apchem-mcq-b5-sv-h-2.4-b-v2','2.4','b4ac01958bc6b2ec88866125b25a03a5'),
('apchem-mcq-b5-sv-h-2.4-b-v3','2.4','b919a83708a330c49c15c2a634edeb74'),
('apchem-mcq-b5-h-2.5-a','2.5','5f469940fc572a6898def0ba67a61d19'),
('apchem-mcq-b5-sv-h-2.5-a-v1','2.5','1d8409a7dca755227067448655f517c2'),
('apchem-mcq-b5-sv-h-2.5-a-v2','2.5','9af42ddda289e9427852f7717263e5dc'),
('apchem-mcq-b5-sv-h-2.5-a-v3','2.5','968af1894e489ab20b93b92452f00880'),
('apchem-mcq-b5-h-2.5-b','2.5','494ee70b80fa0143425dfd682302206f'),
('apchem-mcq-b5-sv-h-2.5-b-v1','2.5','7898cd935776d75e33f68ca370577a0d'),
('apchem-mcq-b5-sv-h-2.5-b-v2','2.5','c9afb8f700fa5aba195034d78a9d4b12'),
('apchem-mcq-b5-sv-h-2.5-b-v3','2.5','ae2c166c2f531be9ec245af1f6047f19'),
('apchem-mcq-b5-h-2.6-a','2.6','ad9b984b52e7e4e4539d346ed8d89193'),
('apchem-mcq-b5-sv-h-2.6-a-v1','2.6','0899498c3074b2e9992423aa2fc3f177'),
('apchem-mcq-b5-sv-h-2.6-a-v2','2.6','c420a0462ce7716f22414ed68e394d28'),
('apchem-mcq-b5-sv-h-2.6-a-v3','2.6','cf1c327bcd09f40d3d5095149b93596f'),
('apchem-mcq-b5-h-2.6-b','2.6','84457afc0ead4ac4b1a8a481f1798344'),
('apchem-mcq-b5-sv-h-2.6-b-v1','2.6','d428540cc7c064d209e5245dcf4f7e65'),
('apchem-mcq-b5-sv-h-2.6-b-v2','2.6','e9c00f7520332af7929751c76eec25eb'),
('apchem-mcq-b5-sv-h-2.6-b-v3','2.6','9d247983ccd4ac3d5cfb94cf937e51f9'),
('apchem-mcq-b5-h-2.7-a','2.7','f56deef9b5a623fb9a2b427c18b960b0'),
('apchem-mcq-b5-sv-h-2.7-a-v1','2.7','82e6e934e87cff71be13531dac7e083b'),
('apchem-mcq-b5-sv-h-2.7-a-v2','2.7','45e53cdc3825e0970c96ff651b5a6e58'),
('apchem-mcq-b5-sv-h-2.7-a-v3','2.7','7dbd6c417683b775189b93b5e25e88eb'),
('apchem-mcq-b5-h-2.7-b','2.7','af3d0559b8af9d3683d6b894eae3f4f9'),
('apchem-mcq-b5-sv-h-2.7-b-v1','2.7','f4f0ccb43d0235a29d3046445d7de0a0'),
('apchem-mcq-b5-sv-h-2.7-b-v2','2.7','177c198f7ecd90ddd2a9247d84f92cc5'),
('apchem-mcq-b5-sv-h-2.7-b-v3','2.7','f374296e74140a3fce6cd7b2180e1066');
create temporary table tgt on commit drop as
select l.*, ci.id item_id, civ.id version_id, gen_random_uuid() assignment_id, gen_random_uuid() label_id, gen_random_uuid() vd_id,
 'cbe3116f-6ef5-410c-b535-e9fb711c4c2c'::uuid tsv, (case topic when '2.1' then array[2] when '2.2' then array[2] when '2.3' then array[2] when '2.4' then array[2] when '2.5' then array[2] when '2.6' then array[2] when '2.7' then array[2] end)::int[] req, 2 pu
from lab l join app.content_items ci on ci.content_key=l.content_key and ci.exam_pack_version_id='c9ca46b2-b529-4ed3-9741-dddea455ab9b'
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
 'AP Chemistry Unit 3 harder seeds and variants (batch apchem_u2_2026_11_12): Product Owner review of owner-session-authored drafts, 2026-11-12. Arithmetic verified in Python; no model-checker pass, by Product Owner decision.',
 'approve',
 jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apchem_u2_2026_11_12_po_approval','qa_date','2026-11-12','content_key',content_key),
 md5(jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apchem_u2_2026_11_12_po_approval','qa_date','2026-11-12','content_key',content_key)::text),
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
 'apchem_u2_2026_11_12',
 jsonb_build_object('origin','owner_authored','units_source','AP Chemistry Unit 2 (topics 2.x belong to unit 3; required_units set per topic from existing Unit 3 labels)','topic',topic,'report','scripts/content-seed/apchem-harder-seeds-u3-2026-11-12'),
 'apchem-u2-2026-11-12-labeling', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
insert into app.content_taxonomy_validation_decisions (validation_decision_id, content_taxonomy_label_id, decided_by, decision, decision_source, reviewed_primary_unit, reviewed_required_units, notes)
select vd_id, label_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'confirmed', 'chat_review', pu, req,
 'Product Owner chat instruction 2026-11-12 (AP Chemistry harder seeds and variants). Topic assigned by the author from the question design (topic recorded on the cell); topic-only tagging, skill left null.' from tgt;
insert into app.content_item_cells (content_item_version_id, content_item_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id, validated_by, validated_at, validation_decision_id)
select version_id, item_id, tsv, topic, null, true, 'validated', 'apchem_u2_2026_11_12_topic',
 'apchem-u2-2026-11-12-labeling (topic set by the author from the question design)', null, now(), gen_random_uuid() from tgt;
update app.content_taxonomy_labels l set label_status='validated', validated_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, validated_at=now(), validation_decision_id=t.vd_id, validated_against_version_id=t.version_id, validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id) from tgt t where l.content_taxonomy_label_id=t.label_id;
update app.content_item_versions civ set status='published', published_at=coalesce(civ.published_at,now()), updated_at=now() from tgt where civ.id=tgt.version_id;
update app.content_items ci set status='published', updated_at=now() from tgt where ci.id=tgt.item_id;
do $$ declare n int; begin
  select count(*) into n from (select content_item_id from app.content_item_versions where status='published' group by 1 having count(*)>1) d; if n<>0 then raise exception 'duplicate published versions: %', n; end if;
  if (select count(*) from app.content_items ci join tgt on tgt.item_id=ci.id where ci.status='published')<>56 then raise exception 'publish count mismatch'; end if;
  select count(*) into n from app.content_taxonomy_labels l join tgt t on t.item_id=l.content_item_id where l.label_scope='serving' and l.superseded_by is null and l.label_status='validated' and l.validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id); if n<>56 then raise exception 'label post-check %', n; end if;
  select count(*) into n from app.content_item_cells where source='apchem_u2_2026_11_12_topic' and is_primary and superseded_by is null; if n<>56 then raise exception 'topic cell count %', n; end if;
end $$;
do $$ begin raise exception 'REHEARSAL OK (rolled back): published=%, validated_labels=%, topic_cells=%', (select count(*) from tgt), (select count(*) from app.content_taxonomy_labels where source='apchem_u2_2026_11_12' and label_status='validated'), (select count(*) from app.content_item_cells where source='apchem_u2_2026_11_12_topic'); end $$;
rollback;
