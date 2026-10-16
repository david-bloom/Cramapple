-- UNEXECUTED recovery only: original state had zero cells.
-- Requires current owner/conductor recovery decision; never changes question or learner rows.
begin;
set local lock_timeout='5s';
set local statement_timeout='30s';
-- Readable content remains available; block content edits only during this short batch.
lock table app.content_items,app.content_item_versions,app.mcq_choices,app.frq_criteria,
 app.content_taxonomy_labels,app.taxonomy_source_versions,app.taxonomy_topics,
 app.exam_pack_versions,app.exam_packs,app.subjects in share mode;
lock table app.content_item_cells in share row exclusive mode;
create temporary table gap4_plan on commit drop as
select * from jsonb_to_recordset($plan$[{"cell_id":"0351551d-d735-50cf-822c-8c5a93b6c139","version_id":"91ea2d10-2353-4956-a83a-6f0be6d6f6fd","item_id":"58aac6ec-e5bd-4577-93ec-c9718bd8b4a8","exam_pack_version_id":"29c719dc-701b-470f-9e49-fab981722d3f","subject_key":"ap-physics-1","taxonomy_source_version":"27111dec-ee07-48f1-86cf-1a5833dd2962","topic_code":"2.5","source":"more_help_topic_gap9_2026_10_16:5of6","model_run_id":"more-help-topic-gap9-2026-10-16:three-families-two-samples+CED-read","decision_id":"18c6c823-3353-5d63-8180-d3a8736f08c4","version_md5":"b4bcbdd7d47d0a380ee93ecadc0c16e7","taxo_hash":"1cb9e54c36ca95f4a2d125f3a7e2aae9d68f62cc62d246457bdd9612e4b0b45f","label_id":"ea818cea-6471-4eab-9663-b0a6ef2f683f","label_version":1,"label_status":"validated","expected_md5":"b07d57505037630bf47b344ac6301fce"},{"cell_id":"c6218219-9a7a-525d-9a94-03a5f462d837","version_id":"3e7d5167-fa67-4748-848a-80e2cfea0eb3","item_id":"dd0399b5-ae58-4d3f-ae82-9afceb837214","exam_pack_version_id":"5522b532-5e50-41f2-99a2-10144bd4e8db","subject_key":"ap-precalculus","taxonomy_source_version":"16383753-6775-430d-960a-544cd6ee0972","topic_code":"3.13","source":"more_help_topic_gap9_2026_10_16:5of6","model_run_id":"more-help-topic-gap9-2026-10-16:three-families-two-samples+CED-read","decision_id":"18c6c823-3353-5d63-8180-d3a8736f08c4","version_md5":"e7daa20ec6dc581d3deb0a87cdca675d","taxo_hash":"c11bcea7a1d85dfd3182fc5b5795330ce5fa46470d1af7d63b7880e6d8f86a86","label_id":"7162c9cf-5e6f-444e-9fe6-e9d7f1165b4f","label_version":2,"label_status":"validated","expected_md5":"fb908639d9cd518b3bfeb51232717ac8"},{"cell_id":"1002964a-81d6-531a-88cc-9556217b5617","version_id":"100c521c-b604-4837-a3f9-cc36bc61cb78","item_id":"6c650d50-32ad-4df4-a6a6-8beb64a6a922","exam_pack_version_id":"5522b532-5e50-41f2-99a2-10144bd4e8db","subject_key":"ap-precalculus","taxonomy_source_version":"16383753-6775-430d-960a-544cd6ee0972","topic_code":"2.12","source":"more_help_topic_gap9_2026_10_16:6of6","model_run_id":"more-help-topic-gap9-2026-10-16:three-families-two-samples+CED-read","decision_id":"18c6c823-3353-5d63-8180-d3a8736f08c4","version_md5":"9a46f185e5833efe65281a446022b92c","taxo_hash":"32130673e590646c701b3875184800c4d7f6761fbdfeef3f2026054f2bc36664","label_id":"7e2d89a9-d0f5-4e28-a48b-05c26c8f532f","label_version":3,"label_status":"provisional_model","expected_md5":"1894a8be5ab7063ac60ca611f34337bb"},{"cell_id":"c31f247d-1bfb-572f-b44f-315799b853ca","version_id":"e560aa88-68dc-433c-a87c-0cee9bb6eb2d","item_id":"a2bab222-0ab3-420b-aeb5-bf94ece5bc36","exam_pack_version_id":"5522b532-5e50-41f2-99a2-10144bd4e8db","subject_key":"ap-precalculus","taxonomy_source_version":"16383753-6775-430d-960a-544cd6ee0972","topic_code":"1.13","source":"more_help_topic_gap9_2026_10_16:4of6_ced_confirmed","model_run_id":"more-help-topic-gap9-2026-10-16:three-families-two-samples+CED-read","decision_id":"18c6c823-3353-5d63-8180-d3a8736f08c4","version_md5":"39f97eb315236545d343c0add8d2cba4","taxo_hash":"c107d808d6efe492fcf1c141911a7c624cb19c4510692d2e08482f45c54733d4","label_id":"478a6221-bac0-43d2-b711-4f97a52764cf","label_version":1,"label_status":"validated","expected_md5":"da7c2346783b3dcfd895771c1ecda12e"}]$plan$::jsonb) as x(
 cell_id uuid,version_id uuid,item_id uuid,exam_pack_version_id uuid,subject_key text,
 taxonomy_source_version uuid,topic_code text,
 source text,model_run_id text,decision_id uuid,version_md5 text,taxo_hash text,
 label_id uuid,label_version integer,expected_md5 text,label_status text);
do $recover_guard$
begin
 if (select count(*) from app.content_item_cells c join gap4_plan p
   on c.content_item_cell_id=p.cell_id where md5(concat_ws('|',c.content_item_cell_id::text,c.content_item_version_id::text,c.content_item_id::text,c.taxonomy_source_version::text,c.topic_code,c.source,c.model_run_id,c.validation_decision_id::text))=p.expected_md5
   and c.is_primary and c.skill_code is null and c.assignment_status='validated'
   and c.validated_by is null
   and c.superseded_by is null)<>4
 then raise exception 'Recovery mapping drift; review before touching live rows'; end if;
 if exists(select 1 from gap4_plan p join app.content_item_versions v on v.id=p.version_id
   where md5(to_jsonb(v)::text)<>p.version_md5 or app.taxonomy_relevant_hash(v.id)<>p.taxo_hash)
 then raise exception 'Recovery source drift'; end if;
 if exists(select 1 from app.content_item_cells c join gap4_plan p
   on c.content_item_version_id=p.version_id where c.content_item_cell_id<>p.cell_id)
 then raise exception 'Recovery found additional cells'; end if;
end $recover_guard$;
delete from app.content_item_cells c using gap4_plan p
where c.content_item_cell_id=p.cell_id;
do $recovered$
begin
 if exists(select 1 from app.content_item_cells c join gap4_plan p
   on c.content_item_version_id=p.version_id)
 then raise exception 'Recovery failed to restore original cell absence'; end if;
end $recovered$;
select '4 new mappings removed; original absence restored' as result;
commit;
