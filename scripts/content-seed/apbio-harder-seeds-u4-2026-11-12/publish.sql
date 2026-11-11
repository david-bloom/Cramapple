begin;
select pg_advisory_xact_lock(hashtext('cramapple-apbio-u4-2026-11-12-publish-20261112'));
create temporary table lab (content_key text primary key, topic text, exp_hash text) on commit drop;
insert into lab values
('apbio-mcq-b4-h-4.1-a','4.1','9371d91fb99588e75f9e8a7aed218e30'),
('apbio-mcq-b4-sv-h-4.1-a-v1','4.1','634282a18bd08342c2316b85b8c6dcb8'),
('apbio-mcq-b4-sv-h-4.1-a-v2','4.1','ee884fcc1f846a60e5f90762f7f2fab0'),
('apbio-mcq-b4-sv-h-4.1-a-v3','4.1','79ae7a7fc6058c46b8129150f2724427'),
('apbio-mcq-b4-h-4.1-b','4.1','f19e81991b9e2d1f5eafcfc8b0647804'),
('apbio-mcq-b4-sv-h-4.1-b-v1','4.1','0af096d616f1992b748f4d5a8a3ccb99'),
('apbio-mcq-b4-sv-h-4.1-b-v2','4.1','6f226ccd3f2d920a50b7e0563f2fd7e0'),
('apbio-mcq-b4-sv-h-4.1-b-v3','4.1','65f9887bf71037fe94e102470dc6bff8'),
('apbio-mcq-b4-h-4.2-a','4.2','e4437a82c3661af9fecb94c0e1c319e3'),
('apbio-mcq-b4-sv-h-4.2-a-v1','4.2','21fa1f99f42d1cfb405c54fbbcab8b6c'),
('apbio-mcq-b4-sv-h-4.2-a-v2','4.2','87511410e68ab30c8432b53f73729aaa'),
('apbio-mcq-b4-sv-h-4.2-a-v3','4.2','6f7ff900828116f4d53ee9f6ea9a5a93'),
('apbio-mcq-b4-h-4.2-b','4.2','11f68fbc32cb87ea35824bd23da2e897'),
('apbio-mcq-b4-sv-h-4.2-b-v1','4.2','b4ffbcada5bb0c9db96a4795a6a59cf4'),
('apbio-mcq-b4-sv-h-4.2-b-v2','4.2','5d7a514995ef2a3f57290d322f77bea2'),
('apbio-mcq-b4-sv-h-4.2-b-v3','4.2','7f53549406ed67c2bfd9ea94a329b421'),
('apbio-mcq-b4-h-4.3-a','4.3','9db87e0e73d0b69a3a709d395b43213a'),
('apbio-mcq-b4-sv-h-4.3-a-v1','4.3','6b08c2f2304cb63f20c02308e4a7d7f3'),
('apbio-mcq-b4-sv-h-4.3-a-v2','4.3','2c4af51372977359745a604c8af39fa0'),
('apbio-mcq-b4-sv-h-4.3-a-v3','4.3','1bb011ad095015e0ddcf91df476077b8'),
('apbio-mcq-b4-h-4.3-b','4.3','03879391cbcb127749f5488909824ad1'),
('apbio-mcq-b4-sv-h-4.3-b-v1','4.3','6fc492f317464fe063549275da3b454a'),
('apbio-mcq-b4-sv-h-4.3-b-v2','4.3','26ea23585935ef2d692de94ff7b8ebf1'),
('apbio-mcq-b4-sv-h-4.3-b-v3','4.3','75f782afd4a304780eb11de19e11f3b7'),
('apbio-mcq-b4-h-4.4-a','4.4','975ba19fc7ed290160b6c2aebbdc5d2c'),
('apbio-mcq-b4-sv-h-4.4-a-v1','4.4','2a57f07732b2ff31ee716c81b62859d4'),
('apbio-mcq-b4-sv-h-4.4-a-v2','4.4','fac294e6cfc0a1cb5bf6083004e5effe'),
('apbio-mcq-b4-sv-h-4.4-a-v3','4.4','5203dc55197e621531829c102863eeeb'),
('apbio-mcq-b4-h-4.4-b','4.4','e1a45cece1c5f03d5d28433b03aebfa1'),
('apbio-mcq-b4-sv-h-4.4-b-v1','4.4','b51ef9fc1c94e460c484291c9c896964'),
('apbio-mcq-b4-sv-h-4.4-b-v2','4.4','ee50379af6b325f4e2da77f515e3ec4c'),
('apbio-mcq-b4-sv-h-4.4-b-v3','4.4','5c239c90a8ab7887da67ae159943e249'),
('apbio-mcq-b4-h-4.5-a','4.5','50befdbcc4ac3a28e04316bc5bc0d717'),
('apbio-mcq-b4-sv-h-4.5-a-v1','4.5','56e7d002e04cceb1edab3294fb1b7d14'),
('apbio-mcq-b4-sv-h-4.5-a-v2','4.5','6b61a9f3a5982ffa7554b0c8db58382b'),
('apbio-mcq-b4-sv-h-4.5-a-v3','4.5','917fd60de5b8aaee927e24254e614b56'),
('apbio-mcq-b4-h-4.5-b','4.5','364b85e168a9a1d222b2569dc33769fb'),
('apbio-mcq-b4-sv-h-4.5-b-v1','4.5','dde64fefc2f0cc6cf7bfc901627fcb6b'),
('apbio-mcq-b4-sv-h-4.5-b-v2','4.5','9bf786710b49a81ac858c1c0b2972e9e'),
('apbio-mcq-b4-sv-h-4.5-b-v3','4.5','f33869cfbd4a9851840607b10593882b'),
('apbio-mcq-b4-h-4.6-a','4.6','3b87960e7cf7538d0dae363d75039657'),
('apbio-mcq-b4-sv-h-4.6-a-v1','4.6','1ca4e6a8058950d6e30b698349e3300c'),
('apbio-mcq-b4-sv-h-4.6-a-v2','4.6','927ff1d05eea50402973b241c195d07c'),
('apbio-mcq-b4-sv-h-4.6-a-v3','4.6','c1eb5f2aeae6228d3b4fba195d246760'),
('apbio-mcq-b4-h-4.6-b','4.6','995ff466fee772dad7b301b9f1f45929'),
('apbio-mcq-b4-sv-h-4.6-b-v1','4.6','c1b0b591fc872e37f88ee33dd8699419'),
('apbio-mcq-b4-sv-h-4.6-b-v2','4.6','4f066a2a12ef5349c9c14e58439323a5'),
('apbio-mcq-b4-sv-h-4.6-b-v3','4.6','2991d5391a6a502397bb8099d9b37ef7');
create temporary table tgt on commit drop as
select l.*, ci.id item_id, civ.id version_id, gen_random_uuid() assignment_id, gen_random_uuid() label_id, gen_random_uuid() vd_id,
 'c676d1fc-3b58-4896-89e3-852d9bd1f81b'::uuid tsv, (case topic when '4.1' then array[4] when '4.2' then array[4] when '4.3' then array[4] when '4.4' then array[4] when '4.5' then array[4] when '4.6' then array[4] end)::int[] req, 4 pu
from lab l join app.content_items ci on ci.content_key=l.content_key and ci.exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7'
join app.content_item_versions civ on civ.content_item_id=ci.id and civ.version_num=1
where ci.status='draft' and civ.status='draft';
do $$ begin
 if (select count(*) from tgt)<>48 then raise exception 'expected 48 draft targets, got %', (select count(*) from tgt); end if;
 if exists (select 1 from tgt where split_part(topic,'.',1)::int<>pu) then raise exception 'topic/unit mismatch'; end if;
 if exists (select 1 from tgt t join app.content_item_cells c on c.content_item_version_id=t.version_id) or exists (select 1 from tgt t join app.content_taxonomy_labels l on l.content_item_id=t.item_id) then raise exception 'a target already has cells or labels'; end if;
 if (select count(*) from (select t.content_key from tgt t join app.content_item_versions civ on civ.id=t.version_id join app.mcq_choices c on c.content_item_version_id=civ.id group by t.content_key, civ.stem, t.exp_hash having md5(civ.stem||'|'||string_agg(c.choice_key||':'||c.choice_text||':'||c.is_correct::text||':'||c.rationale,'|' order by c.choice_key))=t.exp_hash) z)<>48 then raise exception 'loaded text does not match the build manifest'; end if;
 if exists (select 1 from tgt t where not exists (select 1 from app.content_item_cells c join app.content_items ci2 on ci2.id=c.content_item_id where ci2.exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and c.topic_code=t.topic and c.taxonomy_source_version=t.tsv and c.superseded_by is null)) then raise exception 'a topic code is not present in the AP Biology taxonomy source version'; end if;
end $$;
insert into app.content_review_assignments (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, review_kind, status, assignment_purpose, created_by)
select assignment_id, version_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'tutor_question', 'mcq', 'pending', 'owner_remediation_approval', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
insert into app.content_review_decisions (content_review_assignment_id, content_item_version_id, reviewer_id, review_stage, tutor_score, difficulty_label, diagnostic_flag, concern_codes, note, tutor_decision, decision_payload, decision_hash, created_by)
select assignment_id, version_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'tutor_question', 1, null, false, array[]::text[],
 'AP Biology Unit 3 harder seeds and variants (batch apbio_u4_2026_11_12): Product Owner review of owner-session-authored drafts, 2026-11-12. Arithmetic verified in Python; no model-checker pass, by Product Owner decision.',
 'approve',
 jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apbio_u4_2026_11_12_po_approval','qa_date','2026-11-12','content_key',content_key),
 md5(jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apbio_u4_2026_11_12_po_approval','qa_date','2026-11-12','content_key',content_key)::text),
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
select label_id, item_id, 1, 'serving', req, 4, pu, array[]::text[], tsv, 'provisional', 'provisional_model',
 'apbio_u4_2026_11_12',
 jsonb_build_object('origin','owner_authored','units_source','AP Biology Unit 4 (topics 4.x belong to unit 3; required_units set per topic from existing Unit 3 labels)','topic',topic,'report','scripts/content-seed/apchem-harder-seeds-u3-2026-11-12'),
 'apbio-u4-2026-11-12-labeling', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
insert into app.content_taxonomy_validation_decisions (validation_decision_id, content_taxonomy_label_id, decided_by, decision, decision_source, reviewed_primary_unit, reviewed_required_units, notes)
select vd_id, label_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'confirmed', 'chat_review', pu, req,
 'Product Owner chat instruction 2026-11-12 (AP Biology harder seeds and variants). Topic assigned by the author from the question design (topic recorded on the cell); topic-only tagging, skill left null.' from tgt;
insert into app.content_item_cells (content_item_version_id, content_item_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id, validated_by, validated_at, validation_decision_id)
select version_id, item_id, tsv, topic, null, true, 'validated', 'apbio_u4_2026_11_12_topic',
 'apbio-u4-2026-11-12-labeling (topic set by the author from the question design)', null, now(), gen_random_uuid() from tgt;
update app.content_taxonomy_labels l set label_status='validated', validated_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, validated_at=now(), validation_decision_id=t.vd_id, validated_against_version_id=t.version_id, validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id) from tgt t where l.content_taxonomy_label_id=t.label_id;
update app.content_item_versions civ set status='published', published_at=coalesce(civ.published_at,now()), updated_at=now() from tgt where civ.id=tgt.version_id;
update app.content_items ci set status='published', updated_at=now() from tgt where ci.id=tgt.item_id;
do $$ declare n int; begin
  select count(*) into n from (select content_item_id from app.content_item_versions where status='published' group by 1 having count(*)>1) d; if n<>0 then raise exception 'duplicate published versions: %', n; end if;
  if (select count(*) from app.content_items ci join tgt on tgt.item_id=ci.id where ci.status='published')<>48 then raise exception 'publish count mismatch'; end if;
  select count(*) into n from app.content_taxonomy_labels l join tgt t on t.item_id=l.content_item_id where l.label_scope='serving' and l.superseded_by is null and l.label_status='validated' and l.validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id); if n<>48 then raise exception 'label post-check %', n; end if;
  select count(*) into n from app.content_item_cells where source='apbio_u4_2026_11_12_topic' and is_primary and superseded_by is null; if n<>48 then raise exception 'topic cell count %', n; end if;
end $$;
select (select count(*) from tgt) published, (select count(*) from app.content_taxonomy_labels where source='apbio_u4_2026_11_12' and label_status='validated') validated_labels, (select count(*) from app.content_item_cells where source='apbio_u4_2026_11_12_topic') topic_cells;
commit;
