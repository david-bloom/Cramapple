-- AP Biology skill labels, option 2 (David 2026-10-02): four voters (claude-opus-5, gpt-5.5, gemini-2.5-pro, gemini-3.8-flash); `validated` only at >= 3 of 4; a unique 2-of-4 plurality is `provisional_model`;
-- 2-2 ties and 1-1-1-1 splits are parked as `held` (DECISION-0085 item 4). No label changes: every update is a status or provenance change on a cell written earlier today (APPROVAL-0073).
begin;
select pg_advisory_xact_lock(hashtext('cramapple-apbio-skill-cells-4voter-20261002'));
create temporary table tgt (content_key text primary key, version_id uuid, topic text, skill text, status text, tier text, had_cell boolean) on commit drop;
insert into tgt values
('APBIO-FRQ-L-003','0c9b6720-639f-4dc4-8fab-c66e65271b1d','5.3','5.C','provisional_model','2of4',false),
('APBIO-FRQ-L-013','3f39e127-2862-4a16-9805-c8ad8251a224','2.1','6.E','validated','4of4',true),
('APBIO-FRQ-L-014','0fbbb21d-7816-41e5-96ef-d5f2d904c3a9','3.5','6.E','validated','4of4',true),
('APBIO-FRQ-L-016','2fea6947-66ba-4080-9bcb-863c35adeb1b','3.5','6.E','validated','3of4',true),
('APBIO-FRQ-L-017','1840ca34-d29d-45f2-b0c1-831759df1d46','4.3','6.E','validated','4of4',true),
('APBIO-FRQ-L-019','0d8bb422-95ef-4e50-884e-38f83cb4cf6a','5.4','1.C','provisional_model','2of4',false),
('APBIO-FRQ-L-021','072da3bc-ba23-4a52-8ef5-f1bb9a8ae49a','6.5','1.B','validated','3of4',true),
('APBIO-FRQ-L-026','13f4a0e3-a018-4ddf-ba71-c4a0ca0d7e67','5.2','6.E','validated','3of4',true),
('APBIO-FRQ-L-030','e5703022-8587-4962-ad27-d63b8bb56227','3.2','6.E','validated','3of4',true),
('APBIO-FRQ-L-031','4bc0591a-b1a8-4709-9e8d-b749210972b7','2.1','6.E','validated','4of4',true),
('APBIO-FRQ-L-036','69b78d2f-d887-4d95-8fa4-0dd416185da6','6.5','6.E','validated','4of4',true),
('APBIO-FRQ-S-006','6162803c-0888-41cb-8c04-9f2b196f0091','5.1','1.B','provisional_model','2of4',false),
('APBIO-FRQ-S-007','dac34d4b-b53d-4def-8fea-a4167b7a49de','5.3','2.D','validated','3of4',true),
('APBIO-FRQ-S-009','1517aedb-e279-44e8-9696-42b235bffd00','2.1','1.A','provisional_model','2of4',true),
('APBIO-FRQ-S-010','9c5f933f-f9a7-4c39-bf21-048315268be5','7.2','1.C','validated','3of4',true),
('APBIO-FRQ-S-011','5b8ee27e-2447-416d-9691-070bdf3b96da','7.5','5.A','validated','4of4',true),
('APBIO-FRQ-S-016','9d8b0980-5c11-4f0a-b270-cd30e7619edb','7.10','1.C','validated','3of4',true),
('APBIO-FRQ-S-017','47959e87-42b9-4634-8705-ecffcab4754e','8.2','6.E','validated','4of4',true),
('APBIO-FRQ-S-021','1c8662ac-d06b-47e4-bfd3-714dae885aac','1.3','1.B','validated','4of4',true),
('APBIO-FRQ-S-023','89ba31c8-84ca-4f2c-be9c-01fb4ea8e76b','3.2','1.C','validated','4of4',true),
('APBIO-FRQ-S-025','9384a865-b082-4048-a087-b4c26cc859ee','1.1','1.B','validated','4of4',true),
('APBIO-FRQ-S-026','3d6ff5f6-4ea2-44a4-874b-f22120fdb97e','2.1','1.B','validated','3of4',true),
('APBIO-FRQ-S-028','7a819a05-5d81-4359-9f51-006bc51212b3','2.10','6.B','validated','4of4',true),
('APBIO-FRQ-S-029','205c0b5d-0937-47e4-8044-0df319848075','2.7','1.C','validated','3of4',true),
('APBIO-FRQ-S-031','f4dc03a9-a479-4443-aa4f-5e6870cd6fae','2.3','1.C','validated','3of4',true),
('APBIO-FRQ-S-032','a04bde76-f1f8-485d-af9b-f8e3e38390df','2.6','1.B','validated','3of4',true),
('APBIO-FRQ-S-033','502aa255-e7de-4bcb-a18d-26af2d07fc01','2.8','1.C','validated','3of4',true),
('APBIO-FRQ-S-036','09b27b58-3cc8-4423-a9c9-a6771fc44c42','3.5','1.B','validated','3of4',true),
('APBIO-FRQ-S-038','968b0367-0a44-4f51-a59a-8d85f5039c44','3.5','6.E','validated','4of4',true),
('APBIO-FRQ-S-040','933fa551-5500-46c9-b6b3-2a203759459f','1.7','6.E','validated','4of4',true),
('APBIO-FRQ-S-045','923ce8b5-f4ce-439c-8d99-b28973ed0f3f','5.3','5.A','validated','3of4',true),
('APBIO-FRQ-S-046','3b98ba34-103c-41f2-83cb-8e7c05de4f15','5.4','6.E','provisional_model','2of4',true),
('APBIO-FRQ-S-048','5a3e01a6-0b07-4c8d-b3a3-79783c9861a9','5.4','1.C','provisional_model','2of4',false),
('APBIO-FRQ-S-051','aaa389e4-ab38-4be6-80d3-9c595be504c6','5.1','6.E','validated','4of4',true),
('APBIO-FRQ-S-058','de993d8e-09a0-49d8-bb2b-6a15008f6182','7.4','6.E','validated','4of4',true),
('APBIO-FRQ-S-061','0907dce7-5af1-4e5f-bea1-b78b2dae0d05','2.2','1.C','validated','4of4',true),
('APBIO-FRQ-S-062','f859f5be-f80a-4b71-8525-7c238756def2','7.1','1.C','validated','4of4',true),
('APBIO-FRQ-S-063','8a8be53a-d01c-4b01-9639-5d1e2e6ccdd0','8.2','5.A','validated','4of4',true),
('APBIO-FRQ-S-066','088e2b89-72e9-43b4-8a53-ff145f5271dd','8.5','6.E','validated','4of4',true),
('APBIO-FRQ-S-068','3527c697-e98a-422e-aaab-3912523be39b','8.5','1.C','validated','3of4',true),
('APBIO-FRQ-S-070','172c7a1f-1fe3-49b4-a9c4-0712b351eb65','8.5','6.E','validated','4of4',true),
('APBIO-FRQ-S-071','cf0a90f8-1d7a-4135-b096-20daa8806e54','2.7','6.E','validated','3of4',true),
('APBIO-FRQ-S-073','2390157a-8afe-4fc8-bb77-903f9f7d03a1','5.1','1.B','validated','4of4',true),
('APBIO-FRQ-S-074','0ac026bd-7daa-421e-a4f3-d2f4ba5dd9f6','6.8','1.C','validated','4of4',true),
('APBIO-FRQ-S-076','2792c2f8-dc64-4dac-8ae1-75bfb930c6b5','8.5','1.C','validated','4of4',true),
('APBIO-FRQ-S-081','383b750d-2749-4c23-aea1-5cc4cc228d48','4.5','1.C','validated','4of4',true),
('APBIO-FRQ-S-084','08a2b95a-4f3f-4a4f-bc4c-6b1e41105f6b','8.5','1.C','validated','3of4',true),
('APBIO-FRQ-S-085','0248f6e3-3237-453a-8037-3a7ed19e507b','4.1','6.E','validated','4of4',true),
('APBIO-FRQ-S-086','f5248787-f7d3-4838-901e-fb19df12242e','8.7','6.E','validated','4of4',true),
('APBIO-FRQ-S-087','818b0a35-668d-4087-bd06-1d7265089367','7.2','1.C','validated','4of4',true),
('APBIO-FRQ-S-089','b044a041-5c3b-44c6-8f35-c76ac24a3744','5.2','1.C','validated','3of4',true),
('APBIO-FRQ-S-090','b3a9caa2-b109-4d26-8227-edc2740461c4','8.2','6.E','validated','4of4',true),
('APBIO-FRQ-S-094','db5db9c9-1899-4864-b13d-dadb9a6d5b6b','6.7','6.E','validated','3of4',true),
('APBIO-FRQ-S-095','a965c3d0-259e-4f5e-9c5e-c999ec6e3ae5','6.7','1.C','validated','3of4',true),
('APBIO-FRQ-S-097','018d63b6-8961-440b-a52f-f95e8d4d487b','6.1','1.C','validated','3of4',true),
('APBIO-FRQ-S-099','f1a8fb93-bc97-4d53-b9c2-1974bc281fd7','7.10','1.C','validated','4of4',true),
('APBIO-FRQ-S-101','406df04d-6c14-4ca2-9444-9f18cd2a5ed8','7.9','2.D','validated','4of4',true),
('APBIO-FRQ-S-102','4a5c171e-86c2-4581-96a4-d491b510fb59','7.1','5.A','provisional_model','2of4',false),
('APBIO-FRQ-S-103','acef35fc-9531-45b7-95ae-3139b531baa7','6.1','1.C','validated','3of4',true),
('APBIO-HDG-2026-GRAPH-002','1c29347d-0f41-4f09-96a7-6f863be82eaf','3.2','4.A','validated','4of4',true),
('APBIO-HDG-2026-GRAPH-003','6ac7429d-1bb4-4be3-9cc4-6059fbdcfbc7','7.2','4.A','validated','4of4',true),
('APBIO-HDG-2026-GRAPH-008','5725097a-a077-4f98-98da-12a527455879','7.11','4.A','validated','4of4',true),
('APBIO-HDG-2026-GRAPH-010','dc837bba-58ad-4734-8539-47813be6e2c3','8.4','4.A','validated','3of4',true),
('APBIO-MCQ-005','b6033e88-6dc7-49cb-9f45-78583669a3fb','1.3','1.C','validated','3of4',true),
('APBIO-MCQ-008','8fbe9af9-b42f-4225-a880-0901d7c7a8f9','1.1','1.C','validated','4of4',true),
('APBIO-MCQ-011','533c21dd-cfa1-4d11-99ad-e6aab888b934','7.12','6.B','validated','3of4',true),
('APBIO-MCQ-014','ad7a9f91-3861-4f2e-a8ff-eff3558d3a52','2.1','6.B','validated','3of4',true),
('APBIO-MCQ-016','1be8f5a0-929c-479c-b70f-83a6e56cf75f','2.7','1.C','validated','3of4',true),
('APBIO-MCQ-017','bb05df6f-07b4-4d70-aacc-018327c5e23d','2.8','1.C','validated','3of4',true),
('APBIO-MCQ-018','2de784ce-f783-43a1-bdcd-a08f5890a5ab','2.5','6.E','validated','4of4',true),
('APBIO-MCQ-021','5799ccb6-c47d-47d2-b656-462609d19b36','2.1','6.E','validated','4of4',true),
('APBIO-MCQ-022','3a69b406-ed1c-4ea2-861f-a03ee7b6ac61','2.1','6.B','validated','4of4',true),
('APBIO-MCQ-023','cd0343a2-f93d-46ec-a6cd-7191fee07f7a','2.3','6.B','validated','3of4',true),
('APBIO-MCQ-024','ecd0db9f-67cc-4dff-9297-14bffd1c3fa8','2.3','6.B','provisional_model','2of4',true),
('APBIO-MCQ-025','973c0fba-185e-4ee1-a24e-7a92a3f3d097','2.7','6.C','provisional_model','2of4',false),
('APBIO-MCQ-026','4521b833-b4c3-4376-860f-9262095b2a2c','4.1','1.A','validated','3of4',true),
('APBIO-MCQ-027','8dc89768-43d8-471b-8b7d-f671c798d561','4.2','1.C','validated','3of4',true),
('APBIO-MCQ-028','ebf7c9ea-3d0c-41c1-8604-f0aa0ebdcb0a','4.2','6.E','validated','4of4',true),
('APBIO-MCQ-030','64c9f99b-5569-43e0-a123-662c0bf33a64','3.3','1.C','validated','4of4',true),
('APBIO-MCQ-032','b99cefa5-2e80-4743-a9b9-631533d224a9','4.2','6.D','provisional_model','2of4',false),
('APBIO-MCQ-033','bbe37ba6-2a58-45c0-a10b-d25b032ddf8f','4.3','6.E','validated','4of4',true),
('APBIO-MCQ-034','c92dabc7-2a63-4835-8cd3-d25dffc7a674','4.3','6.B','validated','3of4',true),
('APBIO-MCQ-043','a3317605-ae54-4092-a9d3-428c40c2c9e9','5.1','1.C','provisional_model','2of4',false),
('APBIO-MCQ-046','2613407b-e76f-4e3c-9cf2-97b588d2277e','4.4','6.E','provisional_model','2of4',true),
('APBIO-MCQ-047','c5a8e814-20b5-4020-b66b-cd4806f918ff','4.2','1.C','validated','3of4',true),
('APBIO-MCQ-055','f1a362bf-9847-4f87-98ed-08af07f8dd82','5.4','6.B','validated','4of4',true),
('APBIO-MCQ-058','17ca7505-86ed-47e9-aa2f-1a8809671e07','5.3','5.A','validated','4of4',true),
('APBIO-MCQ-061','87ab7c3a-8afb-4085-a33d-ae49be5900f4','1.6','1.A','validated','4of4',true),
('APBIO-MCQ-063','b14827d3-ad59-4683-ae00-7ea8223306ef','6.5','6.E','validated','4of4',true),
('APBIO-MCQ-064','bdfe102c-6617-4190-9a1a-aa855cddf05b','6.5','1.A','validated','3of4',true),
('APBIO-MCQ-065','b8274747-ff97-4026-90d9-ba100388cf11','6.5','1.C','validated','3of4',true),
('APBIO-MCQ-067','97c2d55b-0295-4d15-bd54-87642ff59c29','6.5','6.B','validated','3of4',true),
('APBIO-MCQ-074','82edfa5f-e94f-4b85-8b72-23220bde6547','6.8','6.E','validated','4of4',true),
('APBIO-MCQ-079','76e28f76-8a84-49a7-89c8-6528e01b57da','7.1','1.C','validated','3of4',true),
('APBIO-MCQ-084','e522fa68-d4ad-41f0-9e93-2c7b1ac2f0d1','6.6','1.B','validated','3of4',true),
('APBIO-MCQ-086','346b2592-67fd-469d-ad31-2645bd1adbcc','7.7','1.C','provisional_model','2of4',false),
('APBIO-MCQ-088','c066276d-8b38-4bf1-bebd-83fb5b0c2c45','7.1','1.B','provisional_model','2of4',false),
('APBIO-MCQ-093','004bcd77-6f2a-4c57-957a-918c11720f2a','8.5','6.E','validated','3of4',true),
('APBIO-MCQ-094','430109f4-bf82-4e2a-8125-7b2063cc8a4f','8.6','6.C','provisional_model','2of4',true),
('APBIO-MCQ-095','4dc6cd64-db54-403e-81bd-1b5620bb0cb5','8.2','5.A','validated','4of4',true),
('APBIO-MCQ-099','76ed843d-af2c-481e-a7b2-a661dc2443dc','2.1','1.C','validated','3of4',true);
create temporary table hold (content_key text primary key, version_id uuid) on commit drop;
insert into hold values
('APBIO-FRQ-L-004','c721f9eb-1f78-4fa0-b035-15701b663bde'),
('APBIO-FRQ-L-006','9aaacb20-9b11-4867-aaff-57ec9dbb07cf'),
('APBIO-FRQ-L-012','1514c2ee-7cc6-4173-b547-b1f5535a4e95'),
('APBIO-FRQ-S-003','c4da3229-8d7a-4cf9-8738-68b62af20372'),
('APBIO-FRQ-S-019','51c855c0-9e64-4788-bfb5-a679129a281f'),
('APBIO-FRQ-S-020','9ea33554-4ed7-4d97-8ccc-d253c1d71c1d'),
('APBIO-FRQ-S-047','840d2217-ce35-43a7-a0f7-8a233590b628'),
('APBIO-FRQ-S-052','32a19d38-ab7b-40e9-bec7-02dc3993d943'),
('APBIO-FRQ-S-064','d55c0321-3098-44d2-9823-f40926eaacf4'),
('APBIO-FRQ-S-080','b7f6c54c-b1a8-445d-8ee5-bf2dd816f579'),
('APBIO-MCQ-056','13c9c246-6f1c-46ee-9983-3e0cdfd7671d'),
('APBIO-MCQ-069','008f7245-0504-47d9-9a4f-e6860f0a9286'),
('APBIO-MCQ-097','044c1796-d319-497f-b532-69168da5ce30');
do $$ declare n int; begin
  if (select count(*) from tgt where had_cell and status='validated')<>86 or (select count(*) from tgt where had_cell and status<>'validated')<>5 or (select count(*) from tgt where not had_cell)<>10 or (select count(*) from hold)<>13 then raise exception 'unexpected plan sizes'; end if;
  select count(*) into n from tgt t where t.had_cell and not exists (select 1 from app.content_item_cells c where c.content_item_version_id=t.version_id and not c.is_primary and c.superseded_by is null and c.topic_code=t.topic and c.skill_code=t.skill and c.source like 'apbio_skill_phase_b_2026_10_02%');
  if n<>0 then raise exception '% planned cells do not match the existing batch cell', n; end if;
  select count(*) into n from hold h where not exists (select 1 from app.content_item_cells c where c.content_item_version_id=h.version_id and not c.is_primary and c.superseded_by is null and c.skill_code is not null and c.source like 'apbio_skill_phase_b_2026_10_02%');
  if n<>0 then raise exception '% held targets have no batch cell', n; end if;
  select count(*) into n from tgt t where not t.had_cell and exists (select 1 from app.content_item_cells c where c.content_item_version_id=t.version_id and c.skill_code is not null and c.superseded_by is null); if n<>0 then raise exception 'new-cell target already has a skill cell'; end if;
end $$;
update app.content_item_cells c set source='apbio_skill_phase_b_2026_10_02:'||t.tier, model_run_id='apbio-skill-phase-b-2026-10-02 (4 voters: claude-opus-5, gpt-5.5, gemini-2.5-pro, gemini-3.8-flash; validated at >=3 of 4)'
from tgt t where t.had_cell and t.status='validated' and c.content_item_version_id=t.version_id and not c.is_primary and c.superseded_by is null and c.skill_code=t.skill and c.topic_code=t.topic;
update app.content_item_cells c set assignment_status='provisional_model', validated_at=null, validation_decision_id=null, validated_by=null, source='apbio_skill_phase_b_2026_10_02:'||t.tier,
 model_run_id='apbio-skill-phase-b-2026-10-02 (4 voters; unique 2-of-4 plurality, below the 3-of-4 validation bar)'
from tgt t where t.had_cell and t.status<>'validated' and c.content_item_version_id=t.version_id and not c.is_primary and c.superseded_by is null and c.skill_code=t.skill and c.topic_code=t.topic;
update app.content_item_cells c set assignment_status='held', validated_at=null, validation_decision_id=null, validated_by=null, source='apbio_skill_phase_b_2026_10_02:held_no_plurality',
 model_run_id='apbio-skill-phase-b-2026-10-02 (4 voters; 2-2 tie or no agreement; held, excluded)'
from hold h where c.content_item_version_id=h.version_id and not c.is_primary and c.superseded_by is null and c.skill_code is not null and c.source like 'apbio_skill_phase_b_2026_10_02%';
insert into app.content_item_cells (content_item_version_id, content_item_id, taxonomy_source_version, topic_code, skill_code, is_primary, assignment_status, source, model_run_id, validated_by, validated_at, validation_decision_id)
select t.version_id, v.content_item_id, 'c676d1fc-3b58-4896-89e3-852d9bd1f81b', t.topic, t.skill, false, t.status, 'apbio_skill_phase_b_2026_10_02:'||t.tier,
 'apbio-skill-phase-b-2026-10-02 (4 voters; unique 2-of-4 plurality, below the 3-of-4 validation bar)', null, null, null
from tgt t join app.content_item_versions v on v.id=t.version_id where not t.had_cell;
do $$ declare n int; begin
  select count(*) into n from app.content_item_cells c join app.content_items i on i.id=c.content_item_id where i.exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and c.skill_code is not null and c.superseded_by is null and not c.is_primary and c.assignment_status='validated';
  if n<>86 then raise exception 'validated skill cells after: %', n; end if;
  select count(*) into n from app.content_item_cells c join app.content_items i on i.id=c.content_item_id where i.exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and c.skill_code is not null and c.superseded_by is null and not c.is_primary and c.assignment_status='provisional_model';
  if n<>15 then raise exception 'provisional skill cells after: %', n; end if;
  select count(*) into n from app.content_item_cells c join app.content_items i on i.id=c.content_item_id where i.exam_pack_version_id='2d88ba5e-a6a3-43b8-bfae-9e5505a178a7' and c.skill_code is not null and c.superseded_by is null and not c.is_primary and c.assignment_status='held';
  if n<>13 then raise exception 'held skill cells after: %', n; end if;
end $$;
select (select count(*) from tgt) planned, (select count(*) from hold) parked;
commit;
