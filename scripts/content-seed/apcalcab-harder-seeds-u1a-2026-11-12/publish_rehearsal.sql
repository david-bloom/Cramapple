begin;
select pg_advisory_xact_lock(hashtext('cramapple-apcalcab-u1a-2026-11-12-publish-20261112'));
create temporary table lab (content_key text primary key, topic text, exp_hash text) on commit drop;
insert into lab values
('apcalcab-mcq-b6-h-1.1-a','1.1','04b6b17cf6525eb97829ccf8ad08de48'),
('apcalcab-mcq-b6-sv-h-1.1-a-v1','1.1','c4e1592965c2a32acc8ec9bab0189737'),
('apcalcab-mcq-b6-sv-h-1.1-a-v2','1.1','2c16adf2b8b741dd9bad52d8baeb5312'),
('apcalcab-mcq-b6-sv-h-1.1-a-v3','1.1','7eb8d932a03675bfd18dc47075e606f1'),
('apcalcab-mcq-b6-h-1.1-b','1.1','3beaef9ac47c2627ad3c4ac55dd07072'),
('apcalcab-mcq-b6-sv-h-1.1-b-v1','1.1','6d60e65cca9dc426ec3b22b3dd5ccad3'),
('apcalcab-mcq-b6-sv-h-1.1-b-v2','1.1','c63ad298651d27c8fecd8242bac01845'),
('apcalcab-mcq-b6-sv-h-1.1-b-v3','1.1','3d40132a2d29e209f4c22fc7c0aade93'),
('apcalcab-mcq-b6-h-1.2-a','1.2','8dbb56f5dd90442ea622eb513bc1f34b'),
('apcalcab-mcq-b6-sv-h-1.2-a-v1','1.2','276525d4116951b4e4d949d8b2762d18'),
('apcalcab-mcq-b6-sv-h-1.2-a-v2','1.2','25ee2adbca3724408ca5d02028ca4b73'),
('apcalcab-mcq-b6-sv-h-1.2-a-v3','1.2','8002fc1c9cbe786f45e180b5c7a54e56'),
('apcalcab-mcq-b6-h-1.2-b','1.2','6f6b515872b669c330caa5c540ec5ec4'),
('apcalcab-mcq-b6-sv-h-1.2-b-v1','1.2','80f3329d326740581124a89abfbd689b'),
('apcalcab-mcq-b6-sv-h-1.2-b-v2','1.2','5ba0884310095820ee2a4eefb6d302f5'),
('apcalcab-mcq-b6-sv-h-1.2-b-v3','1.2','14bec5c7bce676377ea3981f13398b10'),
('apcalcab-mcq-b6-h-1.3-a','1.3','17e75d38d55dffb2b1bbcd692f3b0408'),
('apcalcab-mcq-b6-sv-h-1.3-a-v1','1.3','86d6634e76459c896542fb3c17500b7c'),
('apcalcab-mcq-b6-sv-h-1.3-a-v2','1.3','245a79794d46318e7f2ca4253c417d46'),
('apcalcab-mcq-b6-sv-h-1.3-a-v3','1.3','c290438a463d41209320aaa10723ee93'),
('apcalcab-mcq-b6-h-1.3-b','1.3','f31ee1ab7cfed2720613a7e77a340773'),
('apcalcab-mcq-b6-sv-h-1.3-b-v1','1.3','f6e09b5506c007a410be5e2990eda56c'),
('apcalcab-mcq-b6-sv-h-1.3-b-v2','1.3','77923212c542331f9a19ceb16ed2a033'),
('apcalcab-mcq-b6-sv-h-1.3-b-v3','1.3','3d043f8f5a1b2d20d61f22cb4b115447'),
('apcalcab-mcq-b6-h-1.4-a','1.4','767d78d7224cac3ae7549ef060828051'),
('apcalcab-mcq-b6-sv-h-1.4-a-v1','1.4','7d4a4f487141b68c68703f4321273816'),
('apcalcab-mcq-b6-sv-h-1.4-a-v2','1.4','fe5f67bafcf9aa748d4830e9a6180f62'),
('apcalcab-mcq-b6-sv-h-1.4-a-v3','1.4','6bcc07d5b539aff19e6a487755178d04'),
('apcalcab-mcq-b6-h-1.4-b','1.4','c18ff3315402b597e32e4852bf3b4229'),
('apcalcab-mcq-b6-sv-h-1.4-b-v1','1.4','4bcaa7049b4b807bb2126af4610256b9'),
('apcalcab-mcq-b6-sv-h-1.4-b-v2','1.4','9a684a4c8184f9f463196d87263c96ca'),
('apcalcab-mcq-b6-sv-h-1.4-b-v3','1.4','559d80ae6e5cc682876c3c10160d27cf'),
('apcalcab-mcq-b6-h-1.5-a','1.5','6573fc643492010dd09ebf5d90bf5ae6'),
('apcalcab-mcq-b6-sv-h-1.5-a-v1','1.5','df2dd1899c47bffd32f157225c7b757d'),
('apcalcab-mcq-b6-sv-h-1.5-a-v2','1.5','5940e3464f7112e63b7914577b5233a6'),
('apcalcab-mcq-b6-sv-h-1.5-a-v3','1.5','a93f4e7ec27e816ac004636b0a033996'),
('apcalcab-mcq-b6-h-1.5-b','1.5','e39c1f7648c69bdc043501970d5e7048'),
('apcalcab-mcq-b6-sv-h-1.5-b-v1','1.5','9949341e19cae7aceec170287a4c40bd'),
('apcalcab-mcq-b6-sv-h-1.5-b-v2','1.5','6200fc83e79f4a16f84e68686f2ecca6'),
('apcalcab-mcq-b6-sv-h-1.5-b-v3','1.5','dea9a6c22056b869eb7308552111e7bc'),
('apcalcab-mcq-b6-h-1.6-a','1.6','abbca44ea95380c841075fde5bb17f2a'),
('apcalcab-mcq-b6-sv-h-1.6-a-v1','1.6','77692a8caafcd70e263007a961954b62'),
('apcalcab-mcq-b6-sv-h-1.6-a-v2','1.6','3d70e7d695208aa226959172ad901dc3'),
('apcalcab-mcq-b6-sv-h-1.6-a-v3','1.6','56c4a5122f6b1b4ee65edcd35df3e1e8'),
('apcalcab-mcq-b6-h-1.6-b','1.6','a3a3633ac464d25f427352a04857779b'),
('apcalcab-mcq-b6-sv-h-1.6-b-v1','1.6','0df7aa2b60f3465dc933b71da4fdbf02'),
('apcalcab-mcq-b6-sv-h-1.6-b-v2','1.6','b9d9a1159266c45b13912915b97b94d1'),
('apcalcab-mcq-b6-sv-h-1.6-b-v3','1.6','05cf58c9017a681abf6ab78d6e3a1f5a'),
('apcalcab-mcq-b6-h-1.7-a','1.7','d7f0e32986110b368cfab431f489525d'),
('apcalcab-mcq-b6-sv-h-1.7-a-v1','1.7','9981748b5414d9dcd1e090b2a0bb46f0'),
('apcalcab-mcq-b6-sv-h-1.7-a-v2','1.7','56ae5426a332644c9b17ee0cbe622a5d'),
('apcalcab-mcq-b6-sv-h-1.7-a-v3','1.7','75f2daff59df4b5d5ef11d5230065ee6'),
('apcalcab-mcq-b6-h-1.7-b','1.7','1ab359e2b7ebab002764a53dfdaa18ee'),
('apcalcab-mcq-b6-sv-h-1.7-b-v1','1.7','bfd66ef542b4f93724b779c08da6001d'),
('apcalcab-mcq-b6-sv-h-1.7-b-v2','1.7','072ae8f3ffb2abb27941b77fc441cd41'),
('apcalcab-mcq-b6-sv-h-1.7-b-v3','1.7','3b8076bed58ed24d3aeb5e6be5ac1150'),
('apcalcab-mcq-b6-h-1.8-a','1.8','02cff5dcca1fd91514e0207f612c7b18'),
('apcalcab-mcq-b6-sv-h-1.8-a-v1','1.8','d517d302d56e2e8eb46f5156867e15b5'),
('apcalcab-mcq-b6-sv-h-1.8-a-v2','1.8','5cbe6a105af17835f305dd0f445656f0'),
('apcalcab-mcq-b6-sv-h-1.8-a-v3','1.8','195bcdc3aa1ffea1aa20cc31f0f4f522'),
('apcalcab-mcq-b6-h-1.8-b','1.8','cd4661ef21a98051c940e7c1a054fb14'),
('apcalcab-mcq-b6-sv-h-1.8-b-v1','1.8','7b42008c4bffe17d399f1f59a433048b'),
('apcalcab-mcq-b6-sv-h-1.8-b-v2','1.8','8c213414a2ab0deb8b17ea0afee607c8'),
('apcalcab-mcq-b6-sv-h-1.8-b-v3','1.8','e218024078f03f4d5fcc32a003555bfd');
create temporary table tgt on commit drop as
select l.*, ci.id item_id, civ.id version_id, gen_random_uuid() assignment_id, gen_random_uuid() label_id, gen_random_uuid() vd_id,
 '33b4408b-0ecc-4c7a-b0b1-612db81164a1'::uuid tsv, (case topic when '1.1' then array[1] when '1.10' then array[1] when '1.11' then array[1] when '1.12' then array[1] when '1.13' then array[1] when '1.14' then array[1] when '1.15' then array[1] when '1.16' then array[1] when '1.2' then array[1] when '1.3' then array[1] when '1.4' then array[1] when '1.5' then array[1] when '1.6' then array[1] when '1.7' then array[1] when '1.8' then array[1] when '1.9' then array[1] end)::int[] req, 1 pu
from lab l join app.content_items ci on ci.content_key=l.content_key and ci.exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d'
join app.content_item_versions civ on civ.content_item_id=ci.id and civ.version_num=1
where ci.status='draft' and civ.status='draft';
do $$ begin
 if (select count(*) from tgt)<>64 then raise exception 'expected 64 draft targets, got %', (select count(*) from tgt); end if;
 if exists (select 1 from tgt where split_part(topic,'.',1)::int<>pu) then raise exception 'topic/unit mismatch'; end if;
 if exists (select 1 from tgt t join app.content_item_cells c on c.content_item_version_id=t.version_id) or exists (select 1 from tgt t join app.content_taxonomy_labels l on l.content_item_id=t.item_id) then raise exception 'a target already has cells or labels'; end if;
 if (select count(*) from (select t.content_key from tgt t join app.content_item_versions civ on civ.id=t.version_id join app.mcq_choices c on c.content_item_version_id=civ.id group by t.content_key, civ.stem, t.exp_hash having md5(civ.stem||'|'||string_agg(c.choice_key||':'||c.choice_text||':'||c.is_correct::text||':'||c.rationale,'|' order by c.choice_key))=t.exp_hash) z)<>64 then raise exception 'loaded text does not match the build manifest'; end if;
 if exists (select 1 from tgt t where not exists (select 1 from app.taxonomy_topics tt where tt.taxonomy_source_version=t.tsv and tt.topic_code=t.topic)) then raise exception 'a topic code is not present in the taxonomy source version'; end if;
end $$;
insert into app.content_review_assignments (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, review_kind, status, assignment_purpose, created_by)
select assignment_id, version_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'tutor_question', 'mcq', 'pending', 'owner_remediation_approval', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
insert into app.content_review_decisions (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, tutor_score, difficulty_label, diagnostic_flag, concern_codes, note, tutor_decision, decision_payload, decision_hash, created_by)
select assignment_id, version_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'tutor_question', 1, null, false, array[]::text[],
 'AP Calculus AB Unit 3 harder seeds and variants (batch apcalcab_u1a_2026_11_12): Product Owner review of owner-session-authored drafts, 2026-11-12. Arithmetic verified in Python; no model-checker pass, by Product Owner decision.',
 'approve',
 jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apcalcab_u1a_2026_11_12_po_approval','qa_date','2026-11-12','content_key',content_key),
 md5(jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apcalcab_u1a_2026_11_12_po_approval','qa_date','2026-11-12','content_key',content_key)::text),
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
 'apcalcab_u1a_2026_11_12',
 jsonb_build_object('origin','owner_authored','units_source','AP Calculus AB Unit 1 (topics 1.x belong to unit 3; required_units set per topic from existing Unit 3 labels)','topic',topic,'report','scripts/content-seed/apchem-harder-seeds-u3-2026-11-12'),
 'apcalcab-u1a-2026-11-12-labeling', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
insert into app.content_taxonomy_validation_decisions (validation_decision_id, content_taxonomy_label_id, decided_by, decision, decision_source, reviewed_primary_unit, reviewed_required_units, notes)
select vd_id, label_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'confirmed', 'chat_review', pu, req,
 'Product Owner chat instruction 2026-11-12 (AP Calculus AB harder seeds and variants). Topic assigned by the author from the question design (topic recorded on the cell); topic-only tagging, skill left null.' from tgt;
insert into app.content_item_cells (content_item_version_id, content_item_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id, validated_by, validated_at, validation_decision_id)
select version_id, item_id, tsv, topic, null, true, 'validated', 'apcalcab_u1a_2026_11_12_topic',
 'apcalcab-u1a-2026-11-12-labeling (topic set by the author from the question design)', null, now(), gen_random_uuid() from tgt;
update app.content_taxonomy_labels l set label_status='validated', validated_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, validated_at=now(), validation_decision_id=t.vd_id, validated_against_version_id=t.version_id, validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id) from tgt t where l.content_taxonomy_label_id=t.label_id;
update app.content_item_versions civ set status='published', published_at=coalesce(civ.published_at,now()), updated_at=now() from tgt where civ.id=tgt.version_id;
update app.content_items ci set status='published', updated_at=now() from tgt where ci.id=tgt.item_id;
do $$ declare n int; begin
  select count(*) into n from (select content_item_id from app.content_item_versions where status='published' group by 1 having count(*)>1) d; if n<>0 then raise exception 'duplicate published versions: %', n; end if;
  if (select count(*) from app.content_items ci join tgt on tgt.item_id=ci.id where ci.status='published')<>64 then raise exception 'publish count mismatch'; end if;
  select count(*) into n from app.content_taxonomy_labels l join tgt t on t.item_id=l.content_item_id where l.label_scope='serving' and l.superseded_by is null and l.label_status='validated' and l.validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id); if n<>64 then raise exception 'label post-check %', n; end if;
  select count(*) into n from app.content_item_cells where source='apcalcab_u1a_2026_11_12_topic' and is_primary and superseded_by is null; if n<>64 then raise exception 'topic cell count %', n; end if;
end $$;
do $$ begin raise exception 'REHEARSAL OK (rolled back): published=%, validated_labels=%, topic_cells=%', (select count(*) from tgt), (select count(*) from app.content_taxonomy_labels where source='apcalcab_u1a_2026_11_12' and label_status='validated'), (select count(*) from app.content_item_cells where source='apcalcab_u1a_2026_11_12_topic'); end $$;
rollback;
