begin;
select pg_advisory_xact_lock(hashtext('cramapple-apcalcab-u4-2026-11-12-publish-20261112'));
create temporary table lab (content_key text primary key, topic text, exp_hash text) on commit drop;
insert into lab values
('apcalcab-mcq-b4-h-4.1-a','4.1','c527725453911f77f3a77633754eddbb'),
('apcalcab-mcq-b4-sv-h-4.1-a-v1','4.1','755b86da9c7e459d801649c93f50cd3a'),
('apcalcab-mcq-b4-sv-h-4.1-a-v2','4.1','ed628c79fd682b980ae83e62652aa47e'),
('apcalcab-mcq-b4-sv-h-4.1-a-v3','4.1','82e8da7549cfde9c2ec40629cd670dbf'),
('apcalcab-mcq-b4-h-4.1-b','4.1','179163d43ce00a4ec3947e340b231047'),
('apcalcab-mcq-b4-sv-h-4.1-b-v1','4.1','97ca8218f4c69114b5eb98260e4f8ef4'),
('apcalcab-mcq-b4-sv-h-4.1-b-v2','4.1','97b8f9a9d5d295f5a1d3242b829e4ba1'),
('apcalcab-mcq-b4-sv-h-4.1-b-v3','4.1','fff6c553df50e51685816cf39e421c9b'),
('apcalcab-mcq-b4-h-4.2-a','4.2','cbaaa70b4e433cf14f14ab9f8bd0701d'),
('apcalcab-mcq-b4-sv-h-4.2-a-v1','4.2','1a3dba1d9710d7d3bd8384419cb43c13'),
('apcalcab-mcq-b4-sv-h-4.2-a-v2','4.2','0bdd6c3c824e72b537ce92ea350a1848'),
('apcalcab-mcq-b4-sv-h-4.2-a-v3','4.2','02d045b5109729352b461915f7ac01b1'),
('apcalcab-mcq-b4-h-4.2-b','4.2','0664a362b839bd6486f8fdc927256665'),
('apcalcab-mcq-b4-sv-h-4.2-b-v1','4.2','89575f0b4c306101b00e3347d9872170'),
('apcalcab-mcq-b4-sv-h-4.2-b-v2','4.2','ebfdfbd3c49452c1a7048893ef621faa'),
('apcalcab-mcq-b4-sv-h-4.2-b-v3','4.2','644438abdad20bc15521e4881f3de63f'),
('apcalcab-mcq-b4-h-4.3-a','4.3','b32d7729eb869fb93d268a5d8dc420e3'),
('apcalcab-mcq-b4-sv-h-4.3-a-v1','4.3','bddac2beb5aff321c36d482a9f62c375'),
('apcalcab-mcq-b4-sv-h-4.3-a-v2','4.3','024356a2b37ba445f38b67323aeb970f'),
('apcalcab-mcq-b4-sv-h-4.3-a-v3','4.3','14af8139354756b3750487f51e17e361'),
('apcalcab-mcq-b4-h-4.3-b','4.3','c17cf5c347238958e42ede3ee1b70a89'),
('apcalcab-mcq-b4-sv-h-4.3-b-v1','4.3','d41d58687d9be40eb0465a11af9dacfd'),
('apcalcab-mcq-b4-sv-h-4.3-b-v2','4.3','e7e2fc6c92d15a6ca3e816a031579014'),
('apcalcab-mcq-b4-sv-h-4.3-b-v3','4.3','a20e1421831582b387975e9c016075b4'),
('apcalcab-mcq-b4-h-4.4-a','4.4','70aeb541c933e5c64d8d55464a5862f1'),
('apcalcab-mcq-b4-sv-h-4.4-a-v1','4.4','aa54c164f7a505e36ff36c8175fb4997'),
('apcalcab-mcq-b4-sv-h-4.4-a-v2','4.4','5b960bc27e94d670378ef0d94f26eaf6'),
('apcalcab-mcq-b4-sv-h-4.4-a-v3','4.4','d61033d407d45a4bd10cf202ab0f4b6b'),
('apcalcab-mcq-b4-h-4.4-b','4.4','5632e8f49f56fb232e620548a48fa1b3'),
('apcalcab-mcq-b4-sv-h-4.4-b-v1','4.4','b37797eb120aac0fe722885b6e3ba949'),
('apcalcab-mcq-b4-sv-h-4.4-b-v2','4.4','e54bef2788666e0ea0931a63cb24efec'),
('apcalcab-mcq-b4-sv-h-4.4-b-v3','4.4','8499d9d0a8f7912010df47a4baed6736'),
('apcalcab-mcq-b4-h-4.5-a','4.5','5513a60ba3292a2193bd655aa8b7a236'),
('apcalcab-mcq-b4-sv-h-4.5-a-v1','4.5','a0ddfa0f0fdc716877b54a0c58373c80'),
('apcalcab-mcq-b4-sv-h-4.5-a-v2','4.5','004aebce89d8800df248e4b6d058fcfb'),
('apcalcab-mcq-b4-sv-h-4.5-a-v3','4.5','a9707f4722e77f0071784b6040e1de53'),
('apcalcab-mcq-b4-h-4.5-b','4.5','f726f4597c85fafc01254694ecac2559'),
('apcalcab-mcq-b4-sv-h-4.5-b-v1','4.5','e442bcd789cb24c7b46a255d8309e32d'),
('apcalcab-mcq-b4-sv-h-4.5-b-v2','4.5','66dd854c5dddf3c127df7ce154f06b5e'),
('apcalcab-mcq-b4-sv-h-4.5-b-v3','4.5','0844d92047caa8c98671d3e1e505811e'),
('apcalcab-mcq-b4-h-4.6-a','4.6','d092a3c48d06cb6a5397fe77a3cc18de'),
('apcalcab-mcq-b4-sv-h-4.6-a-v1','4.6','e6f5aa9f28d92eae72c38e1b563f3c7a'),
('apcalcab-mcq-b4-sv-h-4.6-a-v2','4.6','dacbee9abbc9f034bffad4e995669a6e'),
('apcalcab-mcq-b4-sv-h-4.6-a-v3','4.6','3fdb3f88bf37b6604795e059225002a8'),
('apcalcab-mcq-b4-h-4.6-b','4.6','319d546289cf2b7dfbe1fd9cbc2a2221'),
('apcalcab-mcq-b4-sv-h-4.6-b-v1','4.6','5df6d50c1c80a04cad05f539ccca98bf'),
('apcalcab-mcq-b4-sv-h-4.6-b-v2','4.6','ef346ba64b8e07ebcceba5d95eb29b3b'),
('apcalcab-mcq-b4-sv-h-4.6-b-v3','4.6','495e797d9f5748ade262132e839bc082'),
('apcalcab-mcq-b4-h-4.7-a','4.7','a2cfa6a61d30bb90dfa86b50b097e706'),
('apcalcab-mcq-b4-sv-h-4.7-a-v1','4.7','c5ed6311ee4a4e2b345da497d76d1d4f'),
('apcalcab-mcq-b4-sv-h-4.7-a-v2','4.7','faf33c057781d32b38e398c6c0a829b4'),
('apcalcab-mcq-b4-sv-h-4.7-a-v3','4.7','cb869f6c68aca6a97ef21adf71f2ca3c'),
('apcalcab-mcq-b4-h-4.7-b','4.7','421a185516fd2ca8a9a7c14993ae690e'),
('apcalcab-mcq-b4-sv-h-4.7-b-v1','4.7','f49ee47c99a374f3ad9268135bb580bb'),
('apcalcab-mcq-b4-sv-h-4.7-b-v2','4.7','11ab09cef356038b63796677d499efa9'),
('apcalcab-mcq-b4-sv-h-4.7-b-v3','4.7','d6c26c10c0d9c4cdaaca07efa6688fd2');
create temporary table tgt on commit drop as
select l.*, ci.id item_id, civ.id version_id, gen_random_uuid() assignment_id, gen_random_uuid() label_id, gen_random_uuid() vd_id,
 '33b4408b-0ecc-4c7a-b0b1-612db81164a1'::uuid tsv, (case topic when '4.1' then array[2, 4] when '4.2' then array[2, 4] when '4.3' then array[2, 4] when '4.4' then array[3, 4] when '4.5' then array[3, 4] when '4.6' then array[2, 4] when '4.7' then array[1, 4] end)::int[] req, 4 pu
from lab l join app.content_items ci on ci.content_key=l.content_key and ci.exam_pack_version_id='826c8cf1-bc1b-4f2a-bd33-61a758e1487d'
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
 'AP Calculus AB Unit 3 harder seeds and variants (batch apcalcab_u4_2026_11_12): Product Owner review of owner-session-authored drafts, 2026-11-12. Arithmetic verified in Python; no model-checker pass, by Product Owner decision.',
 'approve',
 jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apcalcab_u4_2026_11_12_po_approval','qa_date','2026-11-12','content_key',content_key),
 md5(jsonb_build_object('review_stage','tutor_question','tutor_score',1,'tutor_decision','approve','approval_basis','apcalcab_u4_2026_11_12_po_approval','qa_date','2026-11-12','content_key',content_key)::text),
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
 'apcalcab_u4_2026_11_12',
 jsonb_build_object('origin','owner_authored','units_source','AP Calculus AB Unit 4 (topics 4.x belong to unit 3; required_units set per topic from existing Unit 3 labels)','topic',topic,'report','scripts/content-seed/apchem-harder-seeds-u3-2026-11-12'),
 'apcalcab-u4-2026-11-12-labeling', 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
insert into app.content_taxonomy_validation_decisions (validation_decision_id, content_taxonomy_label_id, decided_by, decision, decision_source, reviewed_primary_unit, reviewed_required_units, notes)
select vd_id, label_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'confirmed', 'chat_review', pu, req,
 'Product Owner chat instruction 2026-11-12 (AP Calculus AB harder seeds and variants). Topic assigned by the author from the question design (topic recorded on the cell); topic-only tagging, skill left null.' from tgt;
insert into app.content_item_cells (content_item_version_id, content_item_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id, validated_by, validated_at, validation_decision_id)
select version_id, item_id, tsv, topic, null, true, 'validated', 'apcalcab_u4_2026_11_12_topic',
 'apcalcab-u4-2026-11-12-labeling (topic set by the author from the question design)', null, now(), gen_random_uuid() from tgt;
update app.content_taxonomy_labels l set label_status='validated', validated_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, validated_at=now(), validation_decision_id=t.vd_id, validated_against_version_id=t.version_id, validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id) from tgt t where l.content_taxonomy_label_id=t.label_id;
update app.content_item_versions civ set status='published', published_at=coalesce(civ.published_at,now()), updated_at=now() from tgt where civ.id=tgt.version_id;
update app.content_items ci set status='published', updated_at=now() from tgt where ci.id=tgt.item_id;
do $$ declare n int; begin
  select count(*) into n from (select content_item_id from app.content_item_versions where status='published' group by 1 having count(*)>1) d; if n<>0 then raise exception 'duplicate published versions: %', n; end if;
  if (select count(*) from app.content_items ci join tgt on tgt.item_id=ci.id where ci.status='published')<>56 then raise exception 'publish count mismatch'; end if;
  select count(*) into n from app.content_taxonomy_labels l join tgt t on t.item_id=l.content_item_id where l.label_scope='serving' and l.superseded_by is null and l.label_status='validated' and l.validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id); if n<>56 then raise exception 'label post-check %', n; end if;
  select count(*) into n from app.content_item_cells where source='apcalcab_u4_2026_11_12_topic' and is_primary and superseded_by is null; if n<>56 then raise exception 'topic cell count %', n; end if;
end $$;
do $$ begin raise exception 'REHEARSAL OK (rolled back): published=%, validated_labels=%, topic_cells=%', (select count(*) from tgt), (select count(*) from app.content_taxonomy_labels where source='apcalcab_u4_2026_11_12' and label_status='validated'), (select count(*) from app.content_item_cells where source='apcalcab_u4_2026_11_12_topic'); end $$;
rollback;
