-- AP Biology serving-label repair for the 70 live items a three-family blind consensus could label (APPROVAL-0073, David 2026-10-02: assess Bio, make the 118 publishable, replace stale hashes).
-- Models: gemini-3.8-flash, deepseek-v4-pro, gpt-6.1-sol, 2 samples each. Accepted only where >= 5 of 6 samples agree on the max required unit. New label version per item
-- (validated, hash-fresh against the published version); the old row is superseded, never edited. The 5 items without that agreement stay as they are.
-- Registered primary topic cells are NOT changed: 58 of these items disagree with the consensus topic (36 across units); that is reported separately.
begin;
select pg_advisory_xact_lock(hashtext('cramapple-apbio-serving-labels-20261002'));
create temporary table tgt0 (content_key text primary key, version_id uuid, primary_unit int, req int[], topic text, topic_support text, units_support text, registered_conflict boolean) on commit drop;
insert into tgt0 values
('APBIO-FRQ-L-012','1514c2ee-7cc6-4173-b547-b1f5535a4e95',3,'{3}'::int[],'3.1','3/6','6/6',true),
('APBIO-FRQ-L-014','0fbbb21d-7816-41e5-96ef-d5f2d904c3a9',3,'{2,3}'::int[],'3.5','6/6','6/6',true),
('APBIO-FRQ-L-015','f9ab1b6b-ec52-479b-9c31-fbad9dcc62e8',3,'{3}'::int[],'3.5','6/6','6/6',false),
('APBIO-FRQ-L-031','4bc0591a-b1a8-4709-9e8d-b749210972b7',3,'{3}'::int[],'3.1','3/6','6/6',true),
('APBIO-FRQ-S-003','c4da3229-8d7a-4cf9-8738-68b62af20372',3,'{3}'::int[],'3.4','6/6','6/6',true),
('APBIO-FRQ-S-006','6162803c-0888-41cb-8c04-9f2b196f0091',5,'{4,5}'::int[],'5.1','6/6','6/6',true),
('APBIO-FRQ-S-007','dac34d4b-b53d-4def-8fea-a4167b7a49de',5,'{5}'::int[],'5.3','6/6','6/6',true),
('APBIO-FRQ-S-010','9c5f933f-f9a7-4c39-bf21-048315268be5',7,'{7}'::int[],'7.2','6/6','6/6',true),
('APBIO-FRQ-S-011','5b8ee27e-2447-416d-9691-070bdf3b96da',7,'{7}'::int[],'7.5','6/6','6/6',false),
('APBIO-FRQ-S-016','9d8b0980-5c11-4f0a-b270-cd30e7619edb',7,'{7}'::int[],'7.10','6/6','6/6',true),
('APBIO-FRQ-S-017','47959e87-42b9-4634-8705-ecffcab4754e',8,'{8}'::int[],'8.2','6/6','6/6',true),
('APBIO-FRQ-S-019','51c855c0-9e64-4788-bfb5-a679129a281f',2,'{2}'::int[],'2.10','6/6','6/6',true),
('APBIO-FRQ-S-020','9ea33554-4ed7-4d97-8ccc-d253c1d71c1d',4,'{4}'::int[],'4.4','6/6','6/6',true),
('APBIO-FRQ-S-021','1c8662ac-d06b-47e4-bfd3-714dae885aac',1,'{1}'::int[],'1.3','6/6','6/6',true),
('APBIO-FRQ-S-023','89ba31c8-84ca-4f2c-be9c-01fb4ea8e76b',3,'{3}'::int[],'3.2','6/6','6/6',false),
('APBIO-FRQ-S-025','9384a865-b082-4048-a087-b4c26cc859ee',1,'{1}'::int[],'1.1','6/6','6/6',false),
('APBIO-FRQ-S-026','3d6ff5f6-4ea2-44a4-874b-f22120fdb97e',2,'{2}'::int[],'2.1','4/6','6/6',false),
('APBIO-FRQ-S-028','7a819a05-5d81-4359-9f51-006bc51212b3',2,'{2}'::int[],'2.10','6/6','6/6',true),
('APBIO-FRQ-S-029','205c0b5d-0937-47e4-8044-0df319848075',2,'{2}'::int[],'2.7','6/6','6/6',true),
('APBIO-FRQ-S-031','f4dc03a9-a479-4443-aa4f-5e6870cd6fae',2,'{1,2}'::int[],'2.3','6/6','6/6',true),
('APBIO-FRQ-S-032','a04bde76-f1f8-485d-af9b-f8e3e38390df',2,'{2}'::int[],'2.6','6/6','6/6',false),
('APBIO-FRQ-S-033','502aa255-e7de-4bcb-a18d-26af2d07fc01',2,'{2}'::int[],'2.8','6/6','6/6',true),
('APBIO-FRQ-S-036','09b27b58-3cc8-4423-a9c9-a6771fc44c42',3,'{3}'::int[],'3.5','6/6','6/6',true),
('APBIO-FRQ-S-038','968b0367-0a44-4f51-a59a-8d85f5039c44',3,'{3}'::int[],'3.5','6/6','6/6',true),
('APBIO-FRQ-S-040','933fa551-5500-46c9-b6b3-2a203759459f',4,'{4}'::int[],'4.2','4/6','6/6',true),
('APBIO-FRQ-S-045','923ce8b5-f4ce-439c-8d99-b28973ed0f3f',5,'{5}'::int[],'5.3','6/6','6/6',true),
('APBIO-FRQ-S-046','3b98ba34-103c-41f2-83cb-8e7c05de4f15',5,'{5}'::int[],'5.4','6/6','6/6',true),
('APBIO-FRQ-S-047','840d2217-ce35-43a7-a0f7-8a233590b628',5,'{5}'::int[],'5.4','6/6','6/6',true),
('APBIO-FRQ-S-048','5a3e01a6-0b07-4c8d-b3a3-79783c9861a9',5,'{5}'::int[],'5.4','6/6','6/6',true),
('APBIO-FRQ-S-051','aaa389e4-ab38-4be6-80d3-9c595be504c6',5,'{5}'::int[],'5.1','6/6','6/6',true),
('APBIO-FRQ-S-052','32a19d38-ab7b-40e9-bec7-02dc3993d943',6,'{6}'::int[],'6.3','6/6','6/6',true),
('APBIO-FRQ-S-058','de993d8e-09a0-49d8-bb2b-6a15008f6182',7,'{7}'::int[],'7.4','6/6','6/6',true),
('APBIO-FRQ-S-062','f859f5be-f80a-4b71-8525-7c238756def2',7,'{7}'::int[],'7.2','4/6','6/6',true),
('APBIO-FRQ-S-063','8a8be53a-d01c-4b01-9639-5d1e2e6ccdd0',8,'{8}'::int[],'8.2','6/6','6/6',true),
('APBIO-FRQ-S-064','d55c0321-3098-44d2-9823-f40926eaacf4',8,'{8}'::int[],'8.7','6/6','6/6',true),
('APBIO-FRQ-S-066','088e2b89-72e9-43b4-8a53-ff145f5271dd',8,'{8}'::int[],'8.5','6/6','6/6',true),
('APBIO-FRQ-S-068','3527c697-e98a-422e-aaab-3912523be39b',8,'{8}'::int[],'8.5','6/6','6/6',true),
('APBIO-FRQ-S-070','172c7a1f-1fe3-49b4-a9c4-0712b351eb65',8,'{8}'::int[],'8.5','6/6','6/6',true),
('APBIO-FRQ-S-071','cf0a90f8-1d7a-4135-b096-20daa8806e54',2,'{2}'::int[],'2.7','6/6','6/6',false),
('APBIO-FRQ-S-073','2390157a-8afe-4fc8-bb77-903f9f7d03a1',5,'{5}'::int[],'5.1','6/6','6/6',true),
('APBIO-FRQ-S-074','0ac026bd-7daa-421e-a4f3-d2f4ba5dd9f6',6,'{6}'::int[],'6.8','6/6','6/6',true),
('APBIO-FRQ-S-076','2792c2f8-dc64-4dac-8ae1-75bfb930c6b5',8,'{8}'::int[],'8.7','4/6','6/6',true),
('APBIO-FRQ-S-080','b7f6c54c-b1a8-445d-8ee5-bf2dd816f579',1,'{1}'::int[],'1.7','6/6','6/6',true),
('APBIO-FRQ-S-081','383b750d-2749-4c23-aea1-5cc4cc228d48',6,'{4,6}'::int[],'6.7','4/6','6/6',true),
('APBIO-FRQ-S-084','08a2b95a-4f3f-4a4f-bc4c-6b1e41105f6b',8,'{8}'::int[],'8.5','6/6','6/6',true),
('APBIO-FRQ-S-085','0248f6e3-3237-453a-8037-3a7ed19e507b',4,'{4}'::int[],'4.1','6/6','5/6',true),
('APBIO-FRQ-S-086','f5248787-f7d3-4838-901e-fb19df12242e',8,'{8}'::int[],'8.7','6/6','6/6',true),
('APBIO-FRQ-S-087','818b0a35-668d-4087-bd06-1d7265089367',7,'{7}'::int[],'7.2','6/6','6/6',true),
('APBIO-FRQ-S-090','b3a9caa2-b109-4d26-8227-edc2740461c4',8,'{8}'::int[],'8.2','6/6','6/6',true),
('APBIO-FRQ-S-094','db5db9c9-1899-4864-b13d-dadb9a6d5b6b',6,'{6}'::int[],'6.7','6/6','6/6',true),
('APBIO-FRQ-S-095','a965c3d0-259e-4f5e-9c5e-c999ec6e3ae5',6,'{6}'::int[],'6.7','6/6','6/6',true),
('APBIO-FRQ-S-097','018d63b6-8961-440b-a52f-f95e8d4d487b',6,'{4,6}'::int[],'6.8','4/6','6/6',true),
('APBIO-FRQ-S-099','f1a8fb93-bc97-4d53-b9c2-1974bc281fd7',7,'{7}'::int[],'7.10','6/6','6/6',true),
('APBIO-FRQ-S-101','406df04d-6c14-4ca2-9444-9f18cd2a5ed8',7,'{7}'::int[],'7.9','6/6','6/6',true),
('APBIO-FRQ-S-102','4a5c171e-86c2-4581-96a4-d491b510fb59',7,'{6,7}'::int[],'7.6','4/6','6/6',true),
('APBIO-FRQ-S-103','acef35fc-9531-45b7-95ae-3139b531baa7',7,'{7}'::int[],'7.9','4/6','6/6',true),
('APBIO-HDG-2026-GRAPH-002','1c29347d-0f41-4f09-96a7-6f863be82eaf',3,'{3}'::int[],'3.2','6/6','6/6',false),
('APBIO-HDG-2026-GRAPH-003','6ac7429d-1bb4-4be3-9cc4-6059fbdcfbc7',7,'{7}'::int[],'7.2','4/6','6/6',false),
('APBIO-HDG-2026-GRAPH-010','dc837bba-58ad-4734-8539-47813be6e2c3',8,'{8}'::int[],'8.4','4/6','6/6',false),
('APBIO-MCQ-011','533c21dd-cfa1-4d11-99ad-e6aab888b934',7,'{6,7}'::int[],'7.12','6/6','6/6',false),
('APBIO-MCQ-024','ecd0db9f-67cc-4dff-9297-14bffd1c3fa8',2,'{2,7}'::int[],'2.3','6/6','6/6',false),
('APBIO-MCQ-025','973c0fba-185e-4ee1-a24e-7a92a3f3d097',2,'{2}'::int[],'2.7','6/6','6/6',true),
('APBIO-MCQ-027','8dc89768-43d8-471b-8b7d-f671c798d561',4,'{4,6}'::int[],'4.3','4/6','5/6',true),
('APBIO-MCQ-030','64c9f99b-5569-43e0-a123-662c0bf33a64',4,'{4}'::int[],'4.6','4/6','6/6',true),
('APBIO-MCQ-033','bbe37ba6-2a58-45c0-a10b-d25b032ddf8f',4,'{4}'::int[],'4.3','6/6','6/6',true),
('APBIO-MCQ-043','a3317605-ae54-4092-a9d3-428c40c2c9e9',5,'{4,5}'::int[],'5.1','6/6','6/6',true),
('APBIO-MCQ-046','2613407b-e76f-4e3c-9cf2-97b588d2277e',4,'{4}'::int[],'4.4','6/6','6/6',true),
('APBIO-MCQ-055','f1a362bf-9847-4f87-98ed-08af07f8dd82',5,'{5}'::int[],'5.4','6/6','6/6',true),
('APBIO-MCQ-064','bdfe102c-6617-4190-9a1a-aa855cddf05b',6,'{2,6}'::int[],'6.3','4/6','6/6',true),
('APBIO-MCQ-094','430109f4-bf82-4e2a-8125-7b2063cc8a4f',8,'{8}'::int[],'8.6','6/6','6/6',true);
create temporary table tgt on commit drop as
select t.*, ci.id item_id, l.content_taxonomy_label_id old_label_id, coalesce(l.label_version,0) old_ver, l.label_status old_status, coalesce(l.taxonomy_source_version,'c676d1fc-3b58-4896-89e3-852d9bd1f81b'::uuid) tsv,
       gen_random_uuid() new_label_id, gen_random_uuid() vd_id
from tgt0 t join app.content_items ci on ci.content_key=t.content_key and ci.exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and ci.status='published'
left join app.content_taxonomy_labels l on l.content_item_id=ci.id and l.label_scope='serving' and l.superseded_by is null;
do $$ begin
  if (select count(*) from tgt)<>70 then raise exception 'expected 70 targets, got %', (select count(*) from tgt); end if;
  if exists (select 1 from tgt t where not exists (select 1 from app.content_item_versions v where v.id=t.version_id and v.content_item_id=t.item_id and v.status='published' and v.version_num=(select max(version_num) from app.content_item_versions x where x.content_item_id=t.item_id))) then raise exception 'a probed version is no longer the latest published version'; end if;
  if exists (select 1 from tgt where old_status='validated' and (select validated_against_taxo_hash from app.content_taxonomy_labels where content_taxonomy_label_id=old_label_id)=app.taxonomy_relevant_hash(version_id)) then raise exception 'a target already has a fresh validated label'; end if;
end $$;
insert into app.content_taxonomy_labels (content_taxonomy_label_id, content_item_id, label_version, label_scope, required_units, max_required_unit, primary_unit, assessed_topics, taxonomy_source_version, taxonomy_confidence, label_status, source, source_payload, model_run_id, created_by)
select new_label_id, item_id, old_ver+1, 'serving', req, (select max(u) from unnest(req) u), primary_unit, array[]::text[], tsv, 'provisional', 'provisional_model', 'apbio_serving_label_repair_2026_10_02',
 jsonb_build_object('origin','three_family_blind_probe','models','google/gemini-3.8-flash, deepseek/deepseek-v4-pro, openai/gpt-6.1-sol','samples','2 each (6 per item)','max_unit_support',units_support,'consensus_topic',topic,'topic_support',topic_support,
   'registered_topic_conflict',registered_conflict,'supersedes_status',old_status,'report','scripts/content-seed/apbio-skills-and-labels-2026-10-02/'),
 'apbio-serving-label-repair-2026-10-02','f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid from tgt;
update app.content_taxonomy_labels l set superseded_by=t.new_label_id from tgt t where l.content_taxonomy_label_id=t.old_label_id;
insert into app.content_taxonomy_validation_decisions (validation_decision_id, content_taxonomy_label_id, decided_by, decision, decision_source, reviewed_primary_unit, reviewed_required_units, notes)
select vd_id, new_label_id, 'f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, 'confirmed', 'automated_spot_check', primary_unit, req,
 'Product Owner chat instruction 2026-10-02 (APPROVAL-0073): make the live Biology items servable. Blind three-family consensus, max unit '||units_support||'; human review waived under the pattern of APPROVAL-0065 and 0069.' from tgt;
update app.content_taxonomy_labels l set label_status='validated', validated_by='f5a26c6b-3566-4d58-9e97-979fbb947564'::uuid, validated_at=now(), validation_decision_id=t.vd_id,
 validated_against_version_id=t.version_id, validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id) from tgt t where l.content_taxonomy_label_id=t.new_label_id;
do $$ declare n int; begin
  select count(*) into n from app.content_taxonomy_labels l join tgt t on t.item_id=l.content_item_id where l.label_scope='serving' and l.superseded_by is null and l.label_status='validated' and l.validated_against_taxo_hash=app.taxonomy_relevant_hash(t.version_id);
  if n<>70 then raise exception 'post-check: % of 70 validated and hash-fresh', n; end if;
  select count(*) into n from (select l.content_item_id from app.content_taxonomy_labels l join tgt t on t.item_id=l.content_item_id where l.label_scope='serving' and l.superseded_by is null group by 1 having count(*)>1) d;
  if n<>0 then raise exception 'multiple active serving labels'; end if;
end $$;
select count(*) validated_fresh from tgt;
