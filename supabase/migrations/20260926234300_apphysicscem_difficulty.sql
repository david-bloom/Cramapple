-- AP Physics C: Electricity and Magnetism Tier 3 difficulty calibration.
-- Generated offline on 2026-09-26; not applied by the generator.
-- DECISION-0061/0065: three bands; source preserved; honest null ratios.
-- Expected rows: 97. Source: docs/research/content_pipeline_difficulty_2026_09_26/AP_PHYSICS_C_EM_DIFFICULTY_ASSIGNMENTS_2026_09_26.csv.

begin;

create temporary table tmp_subject_difficulty (
  content_key text not null,
  content_item_version_id uuid not null,
  difficulty text not null,
  basis text not null,
  source_value text,
  rationale text not null,
  confidence text not null
) on commit drop;

insert into tmp_subject_difficulty (
  content_key, content_item_version_id, difficulty, basis, source_value,
  rationale, confidence
) values
  ('apphycem-frq-001', '0dec206d-26dd-46a7-ab6c-fe5d47d8bf54'::uuid, 'Easy', 'normalised_casing', 'Easy', 'Preserved authored three-level source value ''Easy'' as operative band ''Easy''; raw value preserved.', 'high'),
  ('apphycem-frq-004', '666efb13-1448-4d6a-97e5-46cd3e0becae'::uuid, 'Easy', 'normalised_casing', 'Easy', 'Preserved authored three-level source value ''Easy'' as operative band ''Easy''; raw value preserved.', 'high'),
  ('apphycem-frq-005', 'c8a5ba00-4c78-41bc-9269-9ca68ee9d45b'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apphycem-frq-006', 'e3181785-fb5c-437a-a7c6-cda913c3909c'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apphycem-frq-008', '833ead87-9b27-471e-a8d1-2dbe10b40182'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apphycem-frq-009', 'e7679a1d-cf6b-4ce8-a42a-c07fb6cb9549'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apphycem-frq-010', '32ffca56-e4e1-401b-87c1-401c5ba00289'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apphycem-frq-011', '0318f7bf-d715-4e0f-94b8-7f467017484f'::uuid, 'Hard', 'normalised_casing', 'Hard', 'Preserved authored three-level source value ''Hard'' as operative band ''Hard''; raw value preserved.', 'high'),
  ('apphycem-frq-012', '5ac9b983-6266-4b04-914f-d91cc3edaa6b'::uuid, 'Hard', 'normalised_casing', 'Hard', 'Preserved authored three-level source value ''Hard'' as operative band ''Hard''; raw value preserved.', 'high'),
  ('apphycem-frq-013', '196e0c30-27f7-4b67-a1f0-2a4ee31e832c'::uuid, 'Hard', 'normalised_casing', 'Hard', 'Preserved authored three-level source value ''Hard'' as operative band ''Hard''; raw value preserved.', 'high'),
  ('apphycem-frq-014', 'c938f787-82ce-4a31-b0a9-add243227a98'::uuid, 'Hard', 'normalised_casing', 'Hard', 'Preserved authored three-level source value ''Hard'' as operative band ''Hard''; raw value preserved.', 'high'),
  ('apphycem-frq-015', '185f1287-4084-479c-bfbd-d96ccfa457a2'::uuid, 'Hard', 'translated', 'Very Hard', 'Translated authored source value ''Very Hard'' to the operative three-level band ''Hard''; raw value preserved.', 'high'),
  ('apphycem-frq-016', '4881dd2e-607b-49d8-9ede-e3d13c4da94e'::uuid, 'Hard', 'translated', 'Very Hard', 'Translated authored source value ''Very Hard'' to the operative three-level band ''Hard''; raw value preserved.', 'high'),
  ('apphycem-frq-017', '3b55e898-70be-47ec-9ebb-a3d0dd5808c0'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apphycem-frq-018', 'e4ae8556-5d1e-47f7-87c7-299c89725d57'::uuid, 'Medium', 'calibrated_task_verb', null, 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=0, Medium=1, Hard=0; uncued=2/3.', 'medium'),
  ('apphycem-frq-020', '827cc508-251e-4288-8be6-700541d5ee09'::uuid, 'Hard', 'calibrated_task_verb', null, 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=1, Medium=1, Hard=3; uncued=1/6.', 'medium'),
  ('apphycem-frq-021', '80649e35-7e85-49bb-a863-7a53c80699d3'::uuid, 'Medium', 'calibrated_task_verb', null, 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=0, Medium=3, Hard=2; uncued=3/8.', 'medium'),
  ('apphycem-frq-022', '59d49fc7-f4b6-40de-8d5a-99db9d47331b'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apphycem-frq-023', '449f79ed-3174-4fad-b2eb-a301c410b263'::uuid, 'Hard', 'normalised_casing', 'Hard', 'Preserved authored three-level source value ''Hard'' as operative band ''Hard''; raw value preserved.', 'high'),
  ('apphycem-frq-025', '43a19e11-5d0b-437f-9d9b-7098ee87e22e'::uuid, 'Hard', 'calibrated_task_verb', null, 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=1, Medium=1, Hard=3; uncued=3/8.', 'medium'),
  ('apphycem-frq-026', '6f7da085-92be-43a7-a613-12dc9c383458'::uuid, 'Hard', 'normalised_casing', 'Hard', 'Preserved authored three-level source value ''Hard'' as operative band ''Hard''; raw value preserved.', 'high'),
  ('apphycem-frq-027', '890799b0-985d-42f6-99c3-9dde59e81e68'::uuid, 'Medium', 'calibrated_task_verb', null, 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=3, Medium=4, Hard=0; uncued=0/7.', 'medium'),
  ('apphycem-frq-028', 'c356edae-f9f9-4d65-9f17-22c18498012d'::uuid, 'Medium', 'calibrated_task_verb', null, 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=1, Medium=3, Hard=0; uncued=1/5.', 'medium'),
  ('apphycem-frq-029', 'bbfe3c42-2c89-422a-aec8-4133d21a4b03'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apphycem-frq-031', '66830a63-4db7-420b-80e4-388e1d7460d9'::uuid, 'Easy', 'calibrated_task_verb', null, 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=2, Medium=1, Hard=0; uncued=2/5.', 'medium'),
  ('apphycem-frq-032', 'fd92843b-d129-47da-b324-7873eb78a58d'::uuid, 'Medium', 'calibrated_task_verb', null, 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=1, Medium=2, Hard=0; uncued=2/5.', 'medium'),
  ('apphycem-frq-033', '6f6d81dc-1c4e-4db9-8590-843e13d1e954'::uuid, 'Medium', 'calibrated_task_verb', null, 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=1, Medium=2, Hard=1; uncued=2/6.', 'medium'),
  ('apphycem-frq-034', '03d8df61-1888-4554-9c09-bc3b7e7de672'::uuid, 'Hard', 'calibrated_task_verb', null, 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=1, Medium=1, Hard=1; uncued=1/4.', 'medium'),
  ('apphycem-frq-035', '8caa38af-5656-4ae4-8840-b3018b308e6b'::uuid, 'Hard', 'normalised_casing', 'Hard', 'Preserved authored three-level source value ''Hard'' as operative band ''Hard''; raw value preserved.', 'high'),
  ('apphycem-frq-036', '3d699ff6-68b1-4987-9a7e-c1bab1b8694a'::uuid, 'Hard', 'normalised_casing', 'Hard', 'Preserved authored three-level source value ''Hard'' as operative band ''Hard''; raw value preserved.', 'high'),
  ('apphycem-frq-037', '67df7e3e-05de-4e71-82a4-e787c40ea10b'::uuid, 'Hard', 'normalised_casing', 'Hard', 'Preserved authored three-level source value ''Hard'' as operative band ''Hard''; raw value preserved.', 'high'),
  ('apphycem-frq-038', 'b71c78c4-a9e7-442c-a174-8a591ef6bd66'::uuid, 'Hard', 'normalised_casing', 'Hard', 'Preserved authored three-level source value ''Hard'' as operative band ''Hard''; raw value preserved.', 'high'),
  ('apphycem-frq-040', 'af57088b-e96a-4965-af61-dfefe99d1f29'::uuid, 'Easy', 'normalised_casing', 'Easy', 'Preserved authored three-level source value ''Easy'' as operative band ''Easy''; raw value preserved.', 'high'),
  ('apphycem-frq-042', '4a7130db-bc4a-4227-abab-e385fe24e9cf'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apphycem-frq-048', '6e70379e-3033-4164-a855-b6d286c10630'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apphycem-frq-049', '36bd0295-f15c-408f-a821-f503a43ff382'::uuid, 'Hard', 'normalised_casing', 'Hard', 'Preserved authored three-level source value ''Hard'' as operative band ''Hard''; raw value preserved.', 'high'),
  ('apphycem-frq-050', '46109859-090c-49ad-8426-8e1daf060d19'::uuid, 'Hard', 'normalised_casing', 'Hard', 'Preserved authored three-level source value ''Hard'' as operative band ''Hard''; raw value preserved.', 'high'),
  ('apphycem-frq-051', '47ee5fb8-949f-4ae8-aba1-ab5999ab7945'::uuid, 'Hard', 'normalised_casing', 'Hard', 'Preserved authored three-level source value ''Hard'' as operative band ''Hard''; raw value preserved.', 'high'),
  ('apphycem-frq-053', 'a7c8366f-efe2-4043-acd9-78b00913beb7'::uuid, 'Hard', 'normalised_casing', 'Hard', 'Preserved authored three-level source value ''Hard'' as operative band ''Hard''; raw value preserved.', 'high'),
  ('apphycem-frq-056', '4d1c80b6-f54f-4613-a860-5d956e6dfb96'::uuid, 'Hard', 'translated', 'Very Hard', 'Translated authored source value ''Very Hard'' to the operative three-level band ''Hard''; raw value preserved.', 'high'),
  ('apphycem-frq-np1-001', '44478991-915a-4e3e-b521-b2ae3b310558'::uuid, 'Medium', 'calibrated_task_verb', null, 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=0, Medium=4, Hard=2; uncued=0/6.', 'medium'),
  ('apphycem-frq-np1-002', 'e1f73980-bc95-4cea-a735-17044be6c987'::uuid, 'Hard', 'calibrated_task_verb', null, 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=0, Medium=2, Hard=4; uncued=0/6.', 'medium'),
  ('apphycem-frq-np1-003', '599dcf66-fca5-4c7d-b46b-eebdaab9316a'::uuid, 'Medium', 'calibrated_task_verb', null, 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=0, Medium=3, Hard=2; uncued=0/5.', 'medium'),
  ('apphycem-frq-np1-004', '57aeed25-7535-4055-b1a6-45bb9d51b505'::uuid, 'Medium', 'calibrated_task_verb', null, 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=1, Medium=4, Hard=1; uncued=0/6.', 'medium'),
  ('apphycem-frq-np1-005', 'f9c6c41f-3f9d-4a87-a3ea-9c59c0591c51'::uuid, 'Medium', 'calibrated_task_verb', null, 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=2, Medium=3, Hard=0; uncued=0/5.', 'medium'),
  ('apphycem-frq-np1-006', 'adc049a4-2cdc-4c8b-8304-899b54cca5c8'::uuid, 'Hard', 'calibrated_task_verb', null, 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=0, Medium=2, Hard=2; uncued=1/5.', 'medium'),
  ('apphycem-frq-np1-007', '045ec2b1-e801-4b01-994f-8c4f49d6e65a'::uuid, 'Hard', 'calibrated_task_verb', null, 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=2, Medium=1, Hard=2; uncued=0/5.', 'medium'),
  ('apphycem-frq-np1-009', 'b61b7a99-36e0-451d-93ce-f99503c2504d'::uuid, 'Hard', 'calibrated_task_verb', null, 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=0, Medium=1, Hard=3; uncued=2/6.', 'medium'),
  ('apphycem-frq-np1-010', '609a4d5a-ca55-4385-b3e1-7fe938d4b10d'::uuid, 'Easy', 'calibrated_task_verb', null, 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=3, Medium=1, Hard=1; uncued=1/6.', 'medium'),
  ('apphycem-mcq-001', '40d8dda2-58c4-4c30-a2af-6f48693fc0da'::uuid, 'Easy', 'normalised_casing', 'Easy', 'Preserved authored three-level source value ''Easy'' as operative band ''Easy''; raw value preserved.', 'high'),
  ('apphycem-mcq-002', '79fb2d5e-03de-4ae9-8f37-ccb344a96e08'::uuid, 'Easy', 'normalised_casing', 'Easy', 'Preserved authored three-level source value ''Easy'' as operative band ''Easy''; raw value preserved.', 'high'),
  ('apphycem-mcq-003', '310c3aab-790a-43c6-a2d8-75a617d6f2d5'::uuid, 'Easy', 'normalised_casing', 'Easy', 'Preserved authored three-level source value ''Easy'' as operative band ''Easy''; raw value preserved.', 'high'),
  ('apphycem-mcq-005', 'f776acc1-c315-4d81-84d0-053e20ada34e'::uuid, 'Easy', 'normalised_casing', 'Easy', 'Preserved authored three-level source value ''Easy'' as operative band ''Easy''; raw value preserved.', 'high'),
  ('apphycem-mcq-006', 'b27d1b43-4dd0-49bd-a0d8-8a4768cfdef0'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apphycem-mcq-007', '683d2a99-cc8b-455a-8c57-6a0414f3341c'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apphycem-mcq-008', 'd08e0b09-0ff5-4195-9516-c99e5ba9c0fd'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apphycem-mcq-009', 'c2521186-1279-4703-9b51-6a583a3fd95f'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apphycem-mcq-010', '3d8748d0-fdb6-47fa-bf9a-378ac440435c'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apphycem-mcq-011', 'ca322b9b-4d53-4c08-bda8-81028cb9bb4f'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apphycem-mcq-012', '4dbb7d4d-c572-46f3-9947-afcc9b107162'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apphycem-mcq-013', 'afe405bd-b6f6-4591-84e9-39b28c97962e'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apphycem-mcq-014', 'af65207c-0029-4d96-811a-492016f25afb'::uuid, 'Hard', 'normalised_casing', 'Hard', 'Preserved authored three-level source value ''Hard'' as operative band ''Hard''; raw value preserved.', 'high'),
  ('apphycem-mcq-015', 'cb00852c-7a3d-409a-9ef3-4d8716c7edbf'::uuid, 'Hard', 'normalised_casing', 'Hard', 'Preserved authored three-level source value ''Hard'' as operative band ''Hard''; raw value preserved.', 'high'),
  ('apphycem-mcq-016', 'a27c0b98-41a7-45a4-906c-785a810d239f'::uuid, 'Hard', 'normalised_casing', 'Hard', 'Preserved authored three-level source value ''Hard'' as operative band ''Hard''; raw value preserved.', 'high'),
  ('apphycem-mcq-017', 'ce80e748-3c79-42d0-aead-c1aec5bdd52a'::uuid, 'Hard', 'normalised_casing', 'Hard', 'Preserved authored three-level source value ''Hard'' as operative band ''Hard''; raw value preserved.', 'high'),
  ('apphycem-mcq-018', '89d7186e-8276-41e4-9d2a-40b7daeffc36'::uuid, 'Hard', 'normalised_casing', 'Hard', 'Preserved authored three-level source value ''Hard'' as operative band ''Hard''; raw value preserved.', 'high'),
  ('apphycem-mcq-019', 'f89306e6-08bc-4e0a-a074-7128d3f356e2'::uuid, 'Hard', 'translated', 'Very Hard', 'Translated authored source value ''Very Hard'' to the operative three-level band ''Hard''; raw value preserved.', 'high'),
  ('apphycem-mcq-020', '9f841d49-4f7e-434f-8497-2f7e17361062'::uuid, 'Hard', 'translated', 'Very Hard', 'Translated authored source value ''Very Hard'' to the operative three-level band ''Hard''; raw value preserved.', 'high'),
  ('apphycem-mcq-021', '323e62f1-a874-4a4b-8ac5-0a961436e554'::uuid, 'Easy', 'normalised_casing', 'Easy', 'Preserved authored three-level source value ''Easy'' as operative band ''Easy''; raw value preserved.', 'high'),
  ('apphycem-mcq-022', 'fd38da62-4043-41ce-9a6a-3587b37d3f47'::uuid, 'Easy', 'normalised_casing', 'Easy', 'Preserved authored three-level source value ''Easy'' as operative band ''Easy''; raw value preserved.', 'high'),
  ('apphycem-mcq-023', 'e0817ceb-7257-4284-8976-72615341b827'::uuid, 'Easy', 'normalised_casing', 'Easy', 'Preserved authored three-level source value ''Easy'' as operative band ''Easy''; raw value preserved.', 'high'),
  ('apphycem-mcq-024', '12c4d0cc-aaa6-48be-a9e4-3e619b10804a'::uuid, 'Easy', 'normalised_casing', 'Easy', 'Preserved authored three-level source value ''Easy'' as operative band ''Easy''; raw value preserved.', 'high'),
  ('apphycem-mcq-025', 'edc2da0d-97ad-464f-85be-cc218b51a578'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apphycem-mcq-026', '9973664a-5a58-4def-9e92-05517ac0af8f'::uuid, 'Easy', 'normalised_casing', 'Easy', 'Preserved authored three-level source value ''Easy'' as operative band ''Easy''; raw value preserved.', 'high'),
  ('apphycem-mcq-027', 'e430dc7b-f183-4750-81b1-f76017511120'::uuid, 'Easy', 'normalised_casing', 'Easy', 'Preserved authored three-level source value ''Easy'' as operative band ''Easy''; raw value preserved.', 'high'),
  ('apphycem-mcq-028', '41f074ee-841c-47fc-a263-a8ccc023aa2b'::uuid, 'Easy', 'normalised_casing', 'Easy', 'Preserved authored three-level source value ''Easy'' as operative band ''Easy''; raw value preserved.', 'high'),
  ('apphycem-mcq-029', 'b4febe3d-44f9-4a5c-96e4-02c8075526e0'::uuid, 'Easy', 'normalised_casing', 'Easy', 'Preserved authored three-level source value ''Easy'' as operative band ''Easy''; raw value preserved.', 'high'),
  ('apphycem-mcq-030', '2c73534a-508b-4c62-b215-af4faa83467f'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apphycem-mcq-031', '4e0dadc5-b0d6-45ec-a829-f565a271884e'::uuid, 'Easy', 'normalised_casing', 'Easy', 'Preserved authored three-level source value ''Easy'' as operative band ''Easy''; raw value preserved.', 'high'),
  ('apphycem-mcq-032', 'ce5636a2-ac51-4d6a-bd7a-9525d7c25408'::uuid, 'Easy', 'normalised_casing', 'Easy', 'Preserved authored three-level source value ''Easy'' as operative band ''Easy''; raw value preserved.', 'high'),
  ('apphycem-mcq-033', '4ccd67cf-6aed-4fb7-851d-edbb005d51d7'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apphycem-mcq-035', '6fe06345-fde5-40eb-b532-04effab6cc25'::uuid, 'Easy', 'normalised_casing', 'Easy', 'Preserved authored three-level source value ''Easy'' as operative band ''Easy''; raw value preserved.', 'high'),
  ('apphycem-mcq-036', 'cd96dd11-e6ad-428b-a95a-f20886b9b911'::uuid, 'Easy', 'normalised_casing', 'Easy', 'Preserved authored three-level source value ''Easy'' as operative band ''Easy''; raw value preserved.', 'high'),
  ('apphycem-mcq-037', 'e612ebec-2e6a-4b04-9c5c-5d7e7b711977'::uuid, 'Easy', 'normalised_casing', 'Easy', 'Preserved authored three-level source value ''Easy'' as operative band ''Easy''; raw value preserved.', 'high'),
  ('apphycem-mcq-038', '330a4588-b35a-4460-a7cb-65ee2ece4661'::uuid, 'Easy', 'normalised_casing', 'Easy', 'Preserved authored three-level source value ''Easy'' as operative band ''Easy''; raw value preserved.', 'high'),
  ('apphycem-mcq-039', 'f643b085-a308-44ca-9625-94eabea78655'::uuid, 'Easy', 'normalised_casing', 'Easy', 'Preserved authored three-level source value ''Easy'' as operative band ''Easy''; raw value preserved.', 'high'),
  ('apphycem-mcq-040', 'f0231b54-ad44-4cae-82d7-ff1cfe0b95e7'::uuid, 'Easy', 'normalised_casing', 'Easy', 'Preserved authored three-level source value ''Easy'' as operative band ''Easy''; raw value preserved.', 'high'),
  ('apphycem-mcq-041', '24bfd312-4fa1-47cf-aa88-77cacab03038'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apphycem-mcq-042', 'a3e5e87b-0940-4284-98bc-5b4b0e8f3691'::uuid, 'Easy', 'normalised_casing', 'Easy', 'Preserved authored three-level source value ''Easy'' as operative band ''Easy''; raw value preserved.', 'high'),
  ('apphycem-mcq-np1-001', '1d1dda5d-5f15-42fa-a61d-e1f26cccbf6f'::uuid, 'Medium', 'calibrated_judgement', null, 'No decisive MCQ task-verb cue; standard one-concept item judged Medium.', 'low'),
  ('apphycem-mcq-np1-002', '33cd1b57-477a-4ed5-988f-c6b4101c14f9'::uuid, 'Medium', 'calibrated_judgement', null, 'No decisive MCQ task-verb cue; standard one-concept item judged Medium.', 'low'),
  ('apphycem-mcq-np1-003', 'bf72f8ae-d7ba-4fa1-9396-e1d2516172fa'::uuid, 'Medium', 'calibrated_judgement', null, 'No decisive MCQ task-verb cue; standard one-concept item judged Medium.', 'low'),
  ('apphycem-mcq-np1-004', 'd9aa6cdf-6e08-4c3b-a8d7-76094bc2f2fa'::uuid, 'Medium', 'calibrated_judgement', null, 'No decisive MCQ task-verb cue; standard one-concept item judged Medium.', 'low'),
  ('apphycem-mcq-np1-005', 'eb1f57bc-e5e9-4916-b7b0-65273df863cd'::uuid, 'Medium', 'calibrated_judgement', null, 'No decisive MCQ task-verb cue; standard one-concept item judged Medium.', 'low'),
  ('apphycem-mcq-np1-006', 'b8f1500b-8378-4e9f-9eef-bd5228e719cb'::uuid, 'Medium', 'calibrated_judgement', null, 'No decisive MCQ task-verb cue; standard one-concept item judged Medium.', 'low'),
  ('apphycem-mcq-np1-009', 'ae39bac6-a30c-43bb-b774-b97712687b21'::uuid, 'Medium', 'calibrated_task_verb', null, 'MCQ stem classified by the approved task-verb framework: medium task-verb cue.', 'medium'),
  ('apphycem-mcq-np1-010', '6d3b2e63-94b2-4e3f-8e3e-4b26f36a9574'::uuid, 'Medium', 'calibrated_judgement', null, 'No decisive MCQ task-verb cue; standard one-concept item judged Medium.', 'low');

do $$
declare
  v_expected int := 97;
  v_rows int;
  v_bad_subject int;
  v_prior int;
begin
  select count(*) into v_rows from tmp_subject_difficulty;
  if v_rows <> v_expected then
    raise exception 'AP Physics C: Electricity and Magnetism difficulty: expected % rows, found %', v_expected, v_rows;
  end if;

  select count(*) into v_bad_subject
  from tmp_subject_difficulty tmp
  where not exists (
    select 1
    from app.content_items ci
    join app.exam_pack_versions epv on epv.id = ci.exam_pack_version_id
    join app.exam_packs ep on ep.id = epv.exam_pack_id
    join lateral (
      select civ.id, civ.status
      from app.content_item_versions civ
      where civ.content_item_id = ci.id
      order by civ.version_num desc
      limit 1
    ) latest on true
    where ci.content_key = tmp.content_key
      and latest.id = tmp.content_item_version_id
      and ep.exam_code = 'ap_physics_c_em'
      and epv.status = 'published'
      and epv.retired_at is null
      and ci.status = 'published'
      and latest.status = 'published'
  );
  if v_bad_subject <> 0 then
    raise exception 'AP Physics C: Electricity and Magnetism difficulty: % rows are contaminated, retired, or non-current', v_bad_subject;
  end if;

  select count(*) into v_prior
  from tmp_subject_difficulty tmp
  join app.content_item_difficulty cid
    on cid.content_item_version_id = tmp.content_item_version_id;
  if v_prior <> 0 then
    raise exception 'AP Physics C: Electricity and Magnetism difficulty: % versions already have difficulty rows', v_prior;
  end if;
end $$;

insert into app.content_item_difficulty (
  content_item_version_id, difficulty, basis, attainment_ratio, ratio_source,
  subject_cut_points, source_value, rationale, confidence, proposal_run
)
select
  content_item_version_id, difficulty, basis, null, null,
  null, source_value, rationale, confidence,
  'ap_physics_c_em_tier3_difficulty_2026_09_26'
from tmp_subject_difficulty;

commit;
