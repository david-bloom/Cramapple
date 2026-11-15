-- TASK-0050 Statistics Phase B: deterministic single-candidate cells only.
-- REVIEW ONLY. Production write requires a fresh subject-specific Hard-Gate approval.
-- Exactly 99 currently published versions had one registered skill at export time.
-- Source: the 20 packets_*.json files in this directory (Production read, 2026-11-11 ET).
-- Rollback after an authorized apply: delete from app.content_item_cells
--   where model_run_id = 'task0050-stats-phase-b-2026-11-11:deterministic_single_candidate';
begin;
do $task0050$
declare inserted_count integer;
begin
  insert into app.content_item_cells (
    content_item_id, content_item_version_id, taxonomy_source_version,
    topic_code, skill_code, is_primary, assignment_status, source, model_run_id
  )
  select ci.id, v.id, p.taxonomy_source_version, p.topic_code, proposed.skill_code,
         false, 'provisional_model', 'skill_dimension_phase_b_deterministic', 'task0050-stats-phase-b-2026-11-11:deterministic_single_candidate'
  from (values
  ('apstats-frq-u13g-2-7', '12f65f47-a3ac-423a-8531-88a60fb665e1', '2.7', '3.C'),
  ('apstats-frq-u13g-3-6', '09bb497a-69c5-4606-8a04-8a594b970845', '3.6', '4.F'),
  ('apstats-mcq-b6-h-1.12-b', 'd873c331-0b34-4a4f-99c6-600fde1251d4', '1.12', '2.A'),
  ('apstats-mcq-b6-h-1.12-a', '4fac524f-f5a1-4d0e-8f76-c1f5fc47a92d', '1.12', '2.A'),
  ('apstats-mcq-b6-sv-h-1.12-a-v1', '2642c5bd-d956-49e9-9b8b-6af73a82bd00', '1.12', '2.A'),
  ('apstats-mcq-b6-sv-h-1.12-a-v2', 'c978bb56-f1e8-4576-9679-5778a5d65e96', '1.12', '2.A'),
  ('apstats-mcq-b6-sv-h-1.12-a-v3', 'e9490855-ca56-49c1-99f1-1468e921eae7', '1.12', '2.A'),
  ('apstats-mcq-b6-sv-h-1.12-b-v1', 'c9268908-7cb8-43a9-87a8-dc4fa52dc946', '1.12', '2.A'),
  ('apstats-mcq-b6-sv-h-1.12-b-v2', '366230c7-36c6-4152-8e7c-cb059c925fa9', '1.12', '2.A'),
  ('apstats-mcq-b6-sv-h-1.12-b-v3', '4a42565d-e89a-47d5-894c-bea328874b7e', '1.12', '2.A'),
  ('apstats-mcq-b7-h-1.2-b', '09ef9d39-7c2c-4681-bdc5-99e584a74c65', '1.2', '2.A'),
  ('apstats-mcq-b7-h-1.2-a', '497568a7-8cfe-48e7-a2b2-f6b5f8a53ee0', '1.2', '2.A'),
  ('apstats-mcq-b7-h-1.5-a', '298ba1cb-8ec4-47bd-ae0d-4edf38792a7e', '1.5', '3.A'),
  ('apstats-mcq-b7-h-1.5-b', 'c0033d75-4ddf-4727-92e5-0b8d93ca929f', '1.5', '3.A'),
  ('apstats-mcq-b7-sv-h-1.2-a-v1', 'ff3a88ff-3b22-4926-ac84-adc90a5b7006', '1.2', '2.A'),
  ('apstats-mcq-b7-sv-h-1.2-a-v2', '86c201d3-27d1-4bec-8d34-d34c5fdfc49b', '1.2', '2.A'),
  ('apstats-mcq-b7-sv-h-1.2-a-v3', '038c1bfb-e002-4d92-a168-925b2d0e4727', '1.2', '2.A'),
  ('apstats-mcq-b7-sv-h-1.2-b-v1', '3a090762-ee34-4dbd-a547-ed96f8d1da00', '1.2', '2.A'),
  ('apstats-mcq-b7-sv-h-1.2-b-v2', 'f561e9d4-cc7a-45d2-895b-f7128b0dff81', '1.2', '2.A'),
  ('apstats-mcq-b7-sv-h-1.2-b-v3', '626adc2a-1360-4005-9c1b-46f7e9e65974', '1.2', '2.A'),
  ('apstats-mcq-b7-sv-h-1.5-a-v1', '96b5e2cd-cf72-4a9b-a461-749ef966ead1', '1.5', '3.A'),
  ('apstats-mcq-b7-sv-h-1.5-a-v2', '5bd542e2-9c14-4dbe-b94d-1e0e7861dd3f', '1.5', '3.A'),
  ('apstats-mcq-b7-sv-h-1.5-a-v3', 'ef344af7-1de2-48ce-aef4-a91eb678e31b', '1.5', '3.A'),
  ('apstats-mcq-b7-sv-h-1.5-b-v1', '0384cdc1-b713-4a15-b234-2cbda0d77f5d', '1.5', '3.A'),
  ('apstats-mcq-b7-sv-h-1.5-b-v2', 'c8630929-1fe9-4e1d-b538-16718550a1d8', '1.5', '3.A'),
  ('apstats-mcq-b7-sv-h-1.5-b-v3', '85a2946a-7573-4321-ba5d-85a51f68a1ed', '1.5', '3.A'),
  ('APSTATS-MCQ-H-2.12-A', 'e713fc2f-5506-424d-9197-e04721e7c340', '2.12', '4.C'),
  ('APSTATS-MCQ-H-2.12-B', 'e1555590-6158-4715-a07c-34af7ede376b', '2.12', '4.C'),
  ('APSTATS-MCQ-H-2.3-A', '78c2bb1c-cc07-4c0d-aaaa-39d9a9b8d66b', '2.3', '3.C'),
  ('APSTATS-MCQ-H-2.3-B', '22ecba14-c412-4c6b-9bdc-bc0a8ce7fa3f', '2.3', '3.C'),
  ('APSTATS-MCQ-H-2.4-A', 'af0d93f8-ad72-4fb2-9b70-200ea0a4d6eb', '2.4', '3.C'),
  ('APSTATS-MCQ-H-2.4-B', '2e12a2a7-c8c5-47a8-9f1a-437394d714d0', '2.4', '3.C'),
  ('APSTATS-MCQ-H-2.5-A', '21415426-4e62-4172-a619-a387fcabc49a', '2.5', '4.B'),
  ('APSTATS-MCQ-H-2.5-B', 'fef11a07-92f0-47b8-9354-c18d3c0ee4f3', '2.5', '4.B'),
  ('APSTATS-MCQ-H-2.6-A', '9de55d97-7d67-465d-8c10-cbdbc1cfa14e', '2.6', '3.C'),
  ('APSTATS-MCQ-H-2.6-B', 'd20afc9e-9cdd-48c8-a06b-2ef4e118d443', '2.6', '3.C'),
  ('APSTATS-MCQ-H-2.7-A', '175249f1-e997-452f-bde8-61c68f78229a', '2.7', '3.C'),
  ('APSTATS-MCQ-H-2.7-B', 'aa730665-158a-4bc9-bea7-5df6f4257e38', '2.7', '3.C'),
  ('APSTATS-MCQ-H-2.8-A', 'f0b7d763-5cbb-4909-8026-621388858a63', '2.8', '3.A'),
  ('APSTATS-MCQ-H-2.8-B', '40230f6c-7512-4e87-9c20-f83886bb7171', '2.8', '3.A'),
  ('APSTATS-MCQ-H-3.6-A', 'd83473bb-ad9b-4bf6-803e-568f26f1b870', '3.6', '4.F'),
  ('APSTATS-MCQ-H-3.6-B', '91c062f5-f69e-4c3f-bfe4-d62a4c4dd9f3', '3.6', '4.F'),
  ('APSTATS-MCQ-SV-H-2.12-A-v1', '55d67131-12c7-41e7-b6d8-990065275ed2', '2.12', '4.C'),
  ('APSTATS-MCQ-SV-H-2.12-A-v2', '186761ee-0d13-4c82-b189-c404e47cd6bf', '2.12', '4.C'),
  ('APSTATS-MCQ-SV-H-2.12-A-v3', '0b875c0b-b774-4e26-91c4-6a20474815ce', '2.12', '4.C'),
  ('APSTATS-MCQ-SV-H-2.12-B-v1', 'd77bc2c1-d3e9-4732-ae26-e4fd1051bbcb', '2.12', '4.C'),
  ('APSTATS-MCQ-SV-H-2.12-B-v2', '2b87b6e5-34f4-4e42-bb7e-1db14c056edd', '2.12', '4.C'),
  ('APSTATS-MCQ-SV-H-2.12-B-v3', 'b4fd41f7-1216-4e59-85bf-22485a18b1be', '2.12', '4.C'),
  ('APSTATS-MCQ-SV-H-2.3-A-v1', '19a23423-805d-46d3-aa70-6e22019c2d14', '2.3', '3.C'),
  ('APSTATS-MCQ-SV-H-2.3-A-v2', '2b38ea00-8e88-40eb-8904-c9715120ae2f', '2.3', '3.C'),
  ('APSTATS-MCQ-SV-H-2.3-A-v3', 'ff0e7c1a-95b3-4784-bab0-7ff0b72fd2d6', '2.3', '3.C'),
  ('APSTATS-MCQ-SV-H-2.3-B-v1', '5190a648-4ca4-4d0f-810f-aacb61ed803f', '2.3', '3.C'),
  ('APSTATS-MCQ-SV-H-2.3-B-v2', '77f83793-cb8b-46a2-aa54-b339f9ea8471', '2.3', '3.C'),
  ('APSTATS-MCQ-SV-H-2.3-B-v3', '8adc1b9f-81c3-4cbc-8d87-1517fbec3545', '2.3', '3.C'),
  ('APSTATS-MCQ-SV-H-2.4-A-v1', '476c6435-39e7-4f3c-8d85-764327c5d5d8', '2.4', '3.C'),
  ('APSTATS-MCQ-SV-H-2.4-A-v2', '56177d1a-4939-431b-8887-5aec6ab685ee', '2.4', '3.C'),
  ('APSTATS-MCQ-SV-H-2.4-A-v3', 'f2f6a006-b42d-47e5-a993-26fe742804c7', '2.4', '3.C'),
  ('APSTATS-MCQ-SV-H-2.4-B-v1', '5a1f14f2-9c38-4776-a4f4-e816501d06bb', '2.4', '3.C'),
  ('APSTATS-MCQ-SV-H-2.4-B-v2', '8b438283-1bb5-40a9-acd3-08c7b5ce282a', '2.4', '3.C'),
  ('APSTATS-MCQ-SV-H-2.4-B-v3', '7cdd5f64-4b93-44c8-a0a1-6eeaf0c99812', '2.4', '3.C'),
  ('APSTATS-MCQ-SV-H-2.5-A-v1', 'f28ea38b-b529-4d04-9cee-c70acaa962e9', '2.5', '4.B'),
  ('APSTATS-MCQ-SV-H-2.5-A-v2', 'f78a9409-2127-4812-bd69-96b1a2932b51', '2.5', '4.B'),
  ('APSTATS-MCQ-SV-H-2.5-A-v3', 'a8b1cb16-60ba-4d52-a709-9b71db82f313', '2.5', '4.B'),
  ('APSTATS-MCQ-SV-H-2.5-B-v1', 'de93d5d4-2919-44d3-97d3-cc1f75d90bcd', '2.5', '4.B'),
  ('APSTATS-MCQ-SV-H-2.5-B-v2', '2b96e063-0213-49b2-8990-ed184eb94751', '2.5', '4.B'),
  ('APSTATS-MCQ-SV-H-2.5-B-v3', '089f5060-bc47-445b-98f4-514f310ac8c2', '2.5', '4.B'),
  ('APSTATS-MCQ-SV-H-2.6-A-v1', 'c8fc17ab-f210-4cd2-8ebe-7d406e10fa20', '2.6', '3.C'),
  ('APSTATS-MCQ-SV-H-2.6-A-v2', '92bb0fe1-ca22-42c0-b70f-7519ac40d74d', '2.6', '3.C'),
  ('APSTATS-MCQ-SV-H-2.6-A-v3', '07f251ea-7131-4dd7-b295-c9ec7d4fc1c5', '2.6', '3.C'),
  ('APSTATS-MCQ-SV-H-2.6-B-v1', 'eb5d1947-a060-444d-a128-c29082297e57', '2.6', '3.C'),
  ('APSTATS-MCQ-SV-H-2.6-B-v2', '5d4e43ec-087f-47ea-9381-f9783b15c8db', '2.6', '3.C'),
  ('APSTATS-MCQ-SV-H-2.6-B-v3', '21a65262-f9ba-4693-bd2e-ef5e16b4bbb6', '2.6', '3.C'),
  ('APSTATS-MCQ-SV-H-2.7-A-v1', '1e50e5e2-aacd-4244-8988-d8e5dd7ef840', '2.7', '3.C'),
  ('APSTATS-MCQ-SV-H-2.7-A-v2', '87b6de2d-1773-486a-aa21-ea728c2b9d46', '2.7', '3.C'),
  ('APSTATS-MCQ-SV-H-2.7-A-v3', 'e24ed56b-7dfb-426e-a4bf-c7db265b87d5', '2.7', '3.C'),
  ('APSTATS-MCQ-SV-H-2.7-B-v1', '55157beb-997c-4cf9-8f25-47911ba9ef95', '2.7', '3.C'),
  ('APSTATS-MCQ-SV-H-2.7-B-v2', 'c5c42bde-a5f7-4189-85e3-9444a0dae2af', '2.7', '3.C'),
  ('APSTATS-MCQ-SV-H-2.7-B-v3', '60be97f5-961a-4a14-b133-aa8539c462e5', '2.7', '3.C'),
  ('APSTATS-MCQ-SV-H-2.8-A-v1', 'e92c5f1a-8c16-4c0e-a672-c0c50701344a', '2.8', '3.A'),
  ('APSTATS-MCQ-SV-H-2.8-A-v2', 'cded8b78-ef07-44e0-b4bf-1080d0f49c29', '2.8', '3.A'),
  ('APSTATS-MCQ-SV-H-2.8-A-v3', 'c4e0380b-4a70-4c5f-a6a2-15acc3c5edc3', '2.8', '3.A'),
  ('APSTATS-MCQ-SV-H-2.8-B-v1', '99defbd3-9ed8-4f7f-90f3-d023420b1e7d', '2.8', '3.A'),
  ('APSTATS-MCQ-SV-H-2.8-B-v2', '548f2115-b5c4-46bd-afe5-0566baf05c74', '2.8', '3.A'),
  ('APSTATS-MCQ-SV-H-2.8-B-v3', '70d2abd7-7ea4-4934-bace-eb91c9c01298', '2.8', '3.A'),
  ('APSTATS-MCQ-SV-H-3.6-A-v1', '9434d0f0-08e0-49b3-9b81-c2e5f695083f', '3.6', '4.F'),
  ('APSTATS-MCQ-SV-H-3.6-A-v2', '3bbf9d38-8668-4541-92da-88852a38772e', '3.6', '4.F'),
  ('APSTATS-MCQ-SV-H-3.6-A-v3', 'd3211b28-0610-476a-88ff-caa9c5037f6c', '3.6', '4.F'),
  ('APSTATS-MCQ-SV-H-3.6-B-v1', 'c0db2af6-6c29-4e81-8a04-4b5a4eb5f9dc', '3.6', '4.F'),
  ('APSTATS-MCQ-SV-H-3.6-B-v2', '710685d5-33f5-4af0-8b4c-03afc86ffe3c', '3.6', '4.F'),
  ('APSTATS-MCQ-SV-H-3.6-B-v3', '9558b743-90bc-4b63-8289-b0dc328e2a13', '3.6', '4.F'),
  ('APSTATS-OHT-1.12', 'eab13b37-0e11-4272-bc5c-0df8aa9b0c7f', '1.12', '2.A'),
  ('APSTATS-OHT-1.2', 'dc1b463f-6f08-424b-8ece-8bb1e9444d44', '1.2', '2.A'),
  ('APSTATS-OHT-1.5', 'abfbe038-21b9-4860-808b-a5db0f3a331b', '1.5', '3.A'),
  ('APSTATS-OHT-2.12-r2', '4dfedcfa-c913-4d77-a8ce-5be1b4b34b42', '2.12', '4.C'),
  ('APSTATS-OHT-2.3', '6791ed61-a561-4c89-955d-a96e2ecb24b7', '2.3', '3.C'),
  ('APSTATS-OHT-2.4', '4ea4c8e8-f809-4403-9ac9-45feb3af70d8', '2.4', '3.C'),
  ('APSTATS-OHT-2.5', '57429e5f-b60d-41bf-aab3-452830bccaea', '2.5', '4.B'),
  ('APSTATS-OHT-2.8', '650b36f5-185d-4449-a46c-4be44423f074', '2.8', '3.A'),
  ('APSTATS-OHT-3.6', 'c45d300e-d9b9-4013-9c81-04a682f12b31', '3.6', '4.F')
  ) as proposed(content_key, version_id, topic_code, skill_code)
  join app.content_items ci
    on ci.content_key = proposed.content_key
   and ci.exam_pack_version_id = '548f06be-ccf4-426d-b82b-b424137a4438'::uuid
   and ci.status = 'published'
  join app.content_item_versions v
    on v.id = proposed.version_id::uuid
   and v.content_item_id = ci.id
   and v.status = 'published'
  join app.content_item_cells p
    on p.content_item_version_id = v.id
   and p.is_primary
   and p.topic_code = proposed.topic_code
  join app.taxonomy_cells tc
    on tc.taxonomy_source_version = p.taxonomy_source_version
   and tc.topic_code = p.topic_code
   and tc.skill_code = proposed.skill_code
  where not exists (
    select 1 from app.content_item_cells existing
    where existing.content_item_version_id = v.id and existing.skill_code is not null
  );
  get diagnostics inserted_count = row_count;
  if inserted_count <> 99 then
    raise exception 'TASK-0050 deterministic count changed: expected 99, inserted %', inserted_count;
  end if;
end
$task0050$;
commit;
