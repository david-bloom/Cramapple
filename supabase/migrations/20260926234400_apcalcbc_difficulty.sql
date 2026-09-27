-- AP Calculus BC Tier 3 difficulty calibration.
-- Generated offline on 2026-09-26; not applied by the generator.
-- DECISION-0061/0065: three bands; source preserved; honest null ratios.
-- Expected rows: 127. Source: docs/research/content_pipeline_difficulty_2026_09_26/AP_CALCULUS_BC_DIFFICULTY_ASSIGNMENTS_2026_09_26.csv.

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
  ('apcalcbc-frq-002', '8ab6d2be-7e8a-406f-8c2f-967b078b766d'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apcalcbc-frq-003', '1849d5e6-c0cb-40ca-ad98-06e0a7137397'::uuid, 'Hard', 'normalised_casing', 'Hard', 'Preserved authored three-level source value ''Hard'' as operative band ''Hard''; raw value preserved.', 'high'),
  ('apcalcbc-frq-004', '0eb637b4-026d-436d-bb3f-5ccdb83fa12e'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apcalcbc-frq-005', 'd1b5b927-8aa5-4e64-ad22-622eed947540'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apcalcbc-frq-007', 'b5bac82a-0a80-4016-a997-d86a3b179c3d'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apcalcbc-frq-008', '06daba8e-9d95-46b9-9aba-a88ceb16879b'::uuid, 'Hard', 'normalised_casing', 'Hard', 'Preserved authored three-level source value ''Hard'' as operative band ''Hard''; raw value preserved.', 'high'),
  ('apcalcbc-frq-010', '8efd7c6c-3357-4778-a4df-9c28bfe81194'::uuid, 'Hard', 'normalised_casing', 'Hard', 'Preserved authored three-level source value ''Hard'' as operative band ''Hard''; raw value preserved.', 'high'),
  ('apcalcbc-frq-011', '11ea69e6-d7c0-4010-afe5-364270515b8c'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apcalcbc-frq-012', 'abae736b-5b0d-4cfc-81b2-655cfe05003b'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apcalcbc-frq-013', '7d6a0911-59fa-40b2-a59d-fd2753aa057f'::uuid, 'Hard', 'translated', 'Very Hard', 'Translated authored source value ''Very Hard'' to the operative three-level band ''Hard''; raw value preserved.', 'high'),
  ('apcalcbc-frq-014', '9672d143-a779-4fff-adb9-d68e9ef2f427'::uuid, 'Easy', 'normalised_casing', 'Easy', 'Preserved authored three-level source value ''Easy'' as operative band ''Easy''; raw value preserved.', 'high'),
  ('apcalcbc-frq-015', 'f433b336-248d-43e7-9815-0d88ed0d5368'::uuid, 'Hard', 'normalised_casing', 'Hard', 'Preserved authored three-level source value ''Hard'' as operative band ''Hard''; raw value preserved.', 'high'),
  ('apcalcbc-frq-016', 'c77ef499-cd6f-4763-9170-149421a452fa'::uuid, 'Hard', 'translated', 'Very Hard', 'Translated authored source value ''Very Hard'' to the operative three-level band ''Hard''; raw value preserved.', 'high'),
  ('apcalcbc-frq-017', '5a7508e2-0170-47d9-bbd0-39adef8bdd24'::uuid, 'Easy', 'normalised_casing', 'Easy', 'Preserved authored three-level source value ''Easy'' as operative band ''Easy''; raw value preserved.', 'high'),
  ('apcalcbc-frq-018', '73d30fe7-445e-40d7-af65-e9fee81b2db4'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apcalcbc-frq-019', '69dfd9c3-ed84-4936-bb87-5a3d6da1fdfe'::uuid, 'Easy', 'normalised_casing', 'Easy', 'Preserved authored three-level source value ''Easy'' as operative band ''Easy''; raw value preserved.', 'high'),
  ('apcalcbc-frq-020', '939c0aae-22aa-4340-a4dd-fff06c200cb6'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apcalcbc-frq-021', '694b276e-7a72-4bce-9f74-609bde6272a4'::uuid, 'Hard', 'normalised_casing', 'Hard', 'Preserved authored three-level source value ''Hard'' as operative band ''Hard''; raw value preserved.', 'high'),
  ('apcalcbc-frq-022', '3a306af9-cb30-4f35-9b4e-ed3eb77f39c4'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apcalcbc-frq-023', 'dcfa0dc4-b0a2-4395-b9bf-86598a03bf9b'::uuid, 'Hard', 'normalised_casing', 'Hard', 'Preserved authored three-level source value ''Hard'' as operative band ''Hard''; raw value preserved.', 'high'),
  ('apcalcbc-frq-024', '22c5b47b-b079-4a8c-8212-ca481dd8e5ec'::uuid, 'Easy', 'normalised_casing', 'Easy', 'Preserved authored three-level source value ''Easy'' as operative band ''Easy''; raw value preserved.', 'high'),
  ('apcalcbc-frq-025', '0555d985-8660-4b2e-a932-8540ed63886e'::uuid, 'Hard', 'normalised_casing', 'Hard', 'Preserved authored three-level source value ''Hard'' as operative band ''Hard''; raw value preserved.', 'high'),
  ('apcalcbc-frq-026', '073a4b93-ae5e-43bb-a6ef-63a1e00b733e'::uuid, 'Hard', 'translated', 'Very Hard', 'Translated authored source value ''Very Hard'' to the operative three-level band ''Hard''; raw value preserved.', 'high'),
  ('apcalcbc-frq-027', '3178e102-e9ea-4026-86b2-aa63532f70d2'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apcalcbc-frq-028', '95af7b8a-7406-483b-baed-fb8cea7bbc8d'::uuid, 'Hard', 'normalised_casing', 'Hard', 'Preserved authored three-level source value ''Hard'' as operative band ''Hard''; raw value preserved.', 'high'),
  ('apcalcbc-frq-029', '5608650c-aa63-4dc1-b39f-4b95a63846bd'::uuid, 'Easy', 'normalised_casing', 'Easy', 'Preserved authored three-level source value ''Easy'' as operative band ''Easy''; raw value preserved.', 'high'),
  ('apcalcbc-frq-030', 'bd17238a-84e4-4ed0-9a85-fd53b7d2b90e'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apcalcbc-frq-031', '5acbaf4b-4203-4ee7-a287-020fffb675c0'::uuid, 'Hard', 'normalised_casing', 'Hard', 'Preserved authored three-level source value ''Hard'' as operative band ''Hard''; raw value preserved.', 'high'),
  ('apcalcbc-frq-032', '01722da0-e2aa-4b21-a1b0-0f50bba49c19'::uuid, 'Hard', 'translated', 'Very Hard', 'Translated authored source value ''Very Hard'' to the operative three-level band ''Hard''; raw value preserved.', 'high'),
  ('apcalcbc-frq-033', '7f67db08-4dbb-4aaf-88d4-272fc4743d31'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apcalcbc-frq-034', '199e3acb-8905-42cd-aa36-378ab05ef415'::uuid, 'Hard', 'normalised_casing', 'Hard', 'Preserved authored three-level source value ''Hard'' as operative band ''Hard''; raw value preserved.', 'high'),
  ('apcalcbc-frq-035', 'e49c0541-39d2-425d-9347-6265db818a58'::uuid, 'Hard', 'translated', 'Very Hard', 'Translated authored source value ''Very Hard'' to the operative three-level band ''Hard''; raw value preserved.', 'high'),
  ('apcalcbc-frq-036', '86053d02-1e28-4d59-ad73-85ea81bf4b2b'::uuid, 'Hard', 'translated', 'Very Hard', 'Translated authored source value ''Very Hard'' to the operative three-level band ''Hard''; raw value preserved.', 'high'),
  ('apcalcbc-frq-037', '9f486862-e6c1-49bb-ae3f-ab14ce0a8734'::uuid, 'Hard', 'normalised_casing', 'Hard', 'Preserved authored three-level source value ''Hard'' as operative band ''Hard''; raw value preserved.', 'high'),
  ('apcalcbc-frq-038', '2fd1a064-d2a9-49c3-922c-31a5e3229678'::uuid, 'Hard', 'normalised_casing', 'Hard', 'Preserved authored three-level source value ''Hard'' as operative band ''Hard''; raw value preserved.', 'high'),
  ('apcalcbc-frq-np1-001', '31fbbeda-8089-45ea-81c4-6856a96b2eee'::uuid, 'Hard', 'calibrated_task_verb', null, 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=1, Medium=0, Hard=3; uncued=0/4.', 'medium'),
  ('apcalcbc-frq-np1-002', '5aaefdfb-aa6e-4ab6-91f9-6e62bfa0f181'::uuid, 'Medium', 'calibrated_task_verb', null, 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=1, Medium=2, Hard=1; uncued=0/4.', 'medium'),
  ('apcalcbc-frq-np1-003', '91140341-c188-4cb5-8475-6669012a70ab'::uuid, 'Hard', 'calibrated_task_verb', null, 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=2, Medium=0, Hard=3; uncued=0/5.', 'medium'),
  ('apcalcbc-frq-np1-004', 'd52cc987-35c1-492a-a456-b14e799dcb20'::uuid, 'Medium', 'calibrated_task_verb', null, 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=1, Medium=2, Hard=1; uncued=0/4.', 'medium'),
  ('apcalcbc-frq-np1-005', 'c3e93308-4c00-418f-9b7a-d0f1fe44589d'::uuid, 'Medium', 'calibrated_task_verb', null, 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=0, Medium=4, Hard=0; uncued=0/4.', 'medium'),
  ('apcalcbc-frq-np1-006', '5a71d645-8c9a-4b00-a91b-e45bdc91c184'::uuid, 'Medium', 'calibrated_task_verb', null, 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=1, Medium=2, Hard=1; uncued=0/4.', 'medium'),
  ('apcalcbc-frq-np1-007', 'af91cd64-2f6d-48cb-80a6-88b8eed92aab'::uuid, 'Hard', 'calibrated_task_verb', null, 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=1, Medium=1, Hard=2; uncued=0/4.', 'medium'),
  ('apcalcbc-frq-np1-008', '6029f4d7-0322-4c42-81e9-1ea063cb12d3'::uuid, 'Medium', 'calibrated_task_verb', null, 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=0, Medium=5, Hard=0; uncued=0/5.', 'medium'),
  ('apcalcbc-frq-np1-009', 'a2d645b5-9c86-48be-98e0-748431138a74'::uuid, 'Hard', 'calibrated_task_verb', null, 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=0, Medium=2, Hard=2; uncued=0/4.', 'medium'),
  ('apcalcbc-frq-np1-010', '5a2e9dae-4f57-45f6-802e-81ff4d8494b8'::uuid, 'Medium', 'calibrated_task_verb', null, 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=0, Medium=3, Hard=0; uncued=0/3.', 'medium'),
  ('apcalcbc-frq-u13-001', 'fb19d503-086d-416b-ad02-e9d8ab925de1'::uuid, 'Easy', 'normalised_casing', 'Easy', 'Preserved authored three-level source value ''Easy'' as operative band ''Easy''; raw value preserved.', 'high'),
  ('apcalcbc-frq-u13-002', 'ea3ebbf4-f766-477e-a798-aa218cc49bfd'::uuid, 'Easy', 'normalised_casing', 'Easy', 'Preserved authored three-level source value ''Easy'' as operative band ''Easy''; raw value preserved.', 'high'),
  ('apcalcbc-frq-u13-003', '6f0ed25f-14b8-4281-a959-43341518a46a'::uuid, 'Easy', 'normalised_casing', 'Easy', 'Preserved authored three-level source value ''Easy'' as operative band ''Easy''; raw value preserved.', 'high'),
  ('apcalcbc-frq-u13-004', 'b362ad58-b2bc-4ce8-ac79-79e7c7804ff7'::uuid, 'Medium', 'calibrated_task_verb', null, 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=0, Medium=4, Hard=3; uncued=2/9.', 'medium'),
  ('apcalcbc-frq-u13-005', '1e42d45b-9bfe-46f3-a06f-83000a161b73'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apcalcbc-frq-u13-006', '74d43a2f-e27f-4085-a1a0-4a481621cc02'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apcalcbc-frq-u13-007', '60dc8c06-eb91-4f46-ab7d-8c08a6e94846'::uuid, 'Hard', 'calibrated_task_verb', null, 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=2, Medium=3, Hard=4; uncued=0/9.', 'medium'),
  ('apcalcbc-frq-u13-008', 'cfff0403-4ee0-4f10-aa27-6b0cb8788a89'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apcalcbc-frq-u13-009', '38628fd4-ec04-4bfd-aac5-c4d4ba0729f9'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apcalcbc-frq-u13-010', 'd7ea5ab1-4073-4810-beca-6f3bcc409b21'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apcalcbc-frq-u13-011', 'bcd57ebc-fc7e-4084-a150-310b908d17db'::uuid, 'Hard', 'normalised_casing', 'Hard', 'Preserved authored three-level source value ''Hard'' as operative band ''Hard''; raw value preserved.', 'high'),
  ('apcalcbc-frq-u13-012', '408812cb-338b-4715-a6f2-0dfe87ba8076'::uuid, 'Hard', 'normalised_casing', 'Hard', 'Preserved authored three-level source value ''Hard'' as operative band ''Hard''; raw value preserved.', 'high'),
  ('apcalcbc-frq-u13-013', 'ac9389c3-a19a-4bde-a23c-3dcc57ccd61c'::uuid, 'Hard', 'normalised_casing', 'Hard', 'Preserved authored three-level source value ''Hard'' as operative band ''Hard''; raw value preserved.', 'high'),
  ('apcalcbc-frq-u13-014', '07dcdd87-340d-420d-bef5-43d72bb8b14a'::uuid, 'Hard', 'calibrated_task_verb', null, 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=0, Medium=0, Hard=9; uncued=0/9.', 'medium'),
  ('apcalcbc-frq-u13-015', '819047e6-f716-414b-a8b1-6c7cf64c137a'::uuid, 'Hard', 'normalised_casing', 'Hard', 'Preserved authored three-level source value ''Hard'' as operative band ''Hard''; raw value preserved.', 'high'),
  ('apcalcbc-frq-u13-016', '41511afb-a0d6-43fa-8adc-a790f7194b8e'::uuid, 'Medium', 'calibrated_task_verb', null, 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=1, Medium=2, Hard=0; uncued=3/6.', 'medium'),
  ('apcalcbc-frq-u13-018', '271965d6-66bc-4b1d-9eb5-d4a324cdcdcc'::uuid, 'Hard', 'translated', 'Very Hard', 'Translated authored source value ''Very Hard'' to the operative three-level band ''Hard''; raw value preserved.', 'high'),
  ('apcalcbc-frq-u13-019', 'cabe6695-6cac-402f-a145-751c2c84575a'::uuid, 'Hard', 'translated', 'Very Hard', 'Translated authored source value ''Very Hard'' to the operative three-level band ''Hard''; raw value preserved.', 'high'),
  ('apcalcbc-frq-u13-020', '78b9c5b5-28a7-48b9-80ae-9260e376298f'::uuid, 'Medium', 'calibrated_task_verb', null, 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=1, Medium=4, Hard=2; uncued=0/7.', 'medium'),
  ('apcalcbc-mcq-002', 'e9900869-00ec-4a88-986f-fe803d9985bf'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apcalcbc-mcq-003', 'c085bb17-278b-4c35-88f7-d63dbc94d859'::uuid, 'Medium', 'calibrated_task_verb', null, 'MCQ stem classified by the approved task-verb framework: medium task-verb cue.', 'medium'),
  ('apcalcbc-mcq-004', '6ff01d69-0735-41b8-ab2d-d46083ac63c1'::uuid, 'Hard', 'normalised_casing', 'Hard', 'Preserved authored three-level source value ''Hard'' as operative band ''Hard''; raw value preserved.', 'high'),
  ('apcalcbc-mcq-005', '5d9bb6ed-4a2e-4c79-bd7c-b0cdc38d1f93'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apcalcbc-mcq-006', 'fccecc3d-dc12-48af-b6a8-49a1972dfb91'::uuid, 'Medium', 'calibrated_task_verb', null, 'MCQ stem classified by the approved task-verb framework: medium task-verb cue.', 'medium'),
  ('apcalcbc-mcq-007', '7c72d0ed-1135-428a-a668-836759f2913d'::uuid, 'Hard', 'translated', 'Very Hard', 'Translated authored source value ''Very Hard'' to the operative three-level band ''Hard''; raw value preserved.', 'high'),
  ('apcalcbc-mcq-008', 'c6de5337-3373-4fd8-a94b-96c3d3660351'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apcalcbc-mcq-009', '724f53a9-e9a6-4d1b-9811-46555e3f2cbd'::uuid, 'Hard', 'normalised_casing', 'Hard', 'Preserved authored three-level source value ''Hard'' as operative band ''Hard''; raw value preserved.', 'high'),
  ('apcalcbc-mcq-010', 'eed2b377-8152-476c-8d9a-a94847b25ad8'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apcalcbc-mcq-011', '91800e9e-5d26-4bad-8a5c-62dee9935633'::uuid, 'Easy', 'normalised_casing', 'Easy', 'Preserved authored three-level source value ''Easy'' as operative band ''Easy''; raw value preserved.', 'high'),
  ('apcalcbc-mcq-012', '2d4fecc2-c4b8-4e29-81ad-923abb93aeb7'::uuid, 'Hard', 'normalised_casing', 'Hard', 'Preserved authored three-level source value ''Hard'' as operative band ''Hard''; raw value preserved.', 'high'),
  ('apcalcbc-mcq-013', '807302e4-5252-4860-b60d-9acfedbec067'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apcalcbc-mcq-014', 'eba2524d-a174-419e-b133-6b5c547714da'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apcalcbc-mcq-015', 'd2449b37-658f-448f-9019-931b8f10fe6f'::uuid, 'Hard', 'normalised_casing', 'Hard', 'Preserved authored three-level source value ''Hard'' as operative band ''Hard''; raw value preserved.', 'high'),
  ('apcalcbc-mcq-016', '6e872fba-3ec2-42e6-8db8-01f35528c1ff'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apcalcbc-mcq-017', 'd57ef38c-a9f1-431b-9563-e5f0b29d18c8'::uuid, 'Medium', 'calibrated_judgement', null, 'No decisive MCQ task-verb cue; standard one-concept item judged Medium.', 'low'),
  ('apcalcbc-mcq-018', '2c9f90cb-1219-4105-bf62-2395348a2a94'::uuid, 'Hard', 'normalised_casing', 'Hard', 'Preserved authored three-level source value ''Hard'' as operative band ''Hard''; raw value preserved.', 'high'),
  ('apcalcbc-mcq-019', '5e78180d-72f2-4a02-a904-1b95436e87ec'::uuid, 'Hard', 'translated', 'Very Hard', 'Translated authored source value ''Very Hard'' to the operative three-level band ''Hard''; raw value preserved.', 'high'),
  ('apcalcbc-mcq-020', '35e90d6f-0765-4116-a41e-6bcc7f7ad112'::uuid, 'Hard', 'normalised_casing', 'Hard', 'Preserved authored three-level source value ''Hard'' as operative band ''Hard''; raw value preserved.', 'high'),
  ('apcalcbc-mcq-021', '8801905c-357a-43b7-81b5-0f388c6685bf'::uuid, 'Easy', 'normalised_casing', 'Easy', 'Preserved authored three-level source value ''Easy'' as operative band ''Easy''; raw value preserved.', 'high'),
  ('apcalcbc-mcq-022', 'c8e50471-1357-4455-9e5b-b3365a2eed42'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apcalcbc-mcq-023', 'a548a41e-aa7b-462f-8969-fac4def77fd7'::uuid, 'Easy', 'normalised_casing', 'Easy', 'Preserved authored three-level source value ''Easy'' as operative band ''Easy''; raw value preserved.', 'high'),
  ('apcalcbc-mcq-024', '22757b29-3af8-40f1-8f88-4d07e2ab1b0c'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apcalcbc-mcq-025', 'fe829169-4d22-44ab-aafa-213cf63cee84'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apcalcbc-mcq-026', '435c0bbd-475e-41dd-bc25-ee04f09f4754'::uuid, 'Hard', 'normalised_casing', 'Hard', 'Preserved authored three-level source value ''Hard'' as operative band ''Hard''; raw value preserved.', 'high'),
  ('apcalcbc-mcq-027', 'fa8b34e0-f9a9-4ebd-a3d2-7a1a077f2034'::uuid, 'Easy', 'normalised_casing', 'Easy', 'Preserved authored three-level source value ''Easy'' as operative band ''Easy''; raw value preserved.', 'high'),
  ('apcalcbc-mcq-028', 'b79f95c1-f44e-4bb9-b280-7d3c4ae2a28b'::uuid, 'Hard', 'normalised_casing', 'Hard', 'Preserved authored three-level source value ''Hard'' as operative band ''Hard''; raw value preserved.', 'high'),
  ('apcalcbc-mcq-029', 'bed2766f-8714-419d-9aaf-d32bb3f69c2e'::uuid, 'Easy', 'normalised_casing', 'Easy', 'Preserved authored three-level source value ''Easy'' as operative band ''Easy''; raw value preserved.', 'high'),
  ('apcalcbc-mcq-030', 'b601f7db-92e4-4dd6-9b0d-e2864d426b0f'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apcalcbc-mcq-031', '4a47d6f6-0bd0-4ec2-add9-40d40d51b568'::uuid, 'Hard', 'normalised_casing', 'Hard', 'Preserved authored three-level source value ''Hard'' as operative band ''Hard''; raw value preserved.', 'high'),
  ('apcalcbc-mcq-032', 'c7d521ad-bc8a-404c-abd9-0e68350e7afd'::uuid, 'Hard', 'translated', 'Very Hard', 'Translated authored source value ''Very Hard'' to the operative three-level band ''Hard''; raw value preserved.', 'high'),
  ('apcalcbc-mcq-033', '1c459529-8016-44ad-be36-dbccc2e0e7fd'::uuid, 'Easy', 'normalised_casing', 'Easy', 'Preserved authored three-level source value ''Easy'' as operative band ''Easy''; raw value preserved.', 'high'),
  ('apcalcbc-mcq-034', '058cb9f7-37f0-4e0d-af06-97ffa239af39'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apcalcbc-mcq-035', 'de0da11c-94be-4ca2-a3e5-edf6836db953'::uuid, 'Hard', 'normalised_casing', 'Hard', 'Preserved authored three-level source value ''Hard'' as operative band ''Hard''; raw value preserved.', 'high'),
  ('apcalcbc-mcq-036', '54c79401-bf15-4533-97d2-1a634ed5ce69'::uuid, 'Hard', 'normalised_casing', 'Hard', 'Preserved authored three-level source value ''Hard'' as operative band ''Hard''; raw value preserved.', 'high'),
  ('apcalcbc-mcq-037', 'f54f258c-060d-4419-b6fc-8382a1b4634b'::uuid, 'Hard', 'translated', 'Very Hard', 'Translated authored source value ''Very Hard'' to the operative three-level band ''Hard''; raw value preserved.', 'high'),
  ('apcalcbc-mcq-038', '4b886041-044f-4c7a-9907-69d97a19b67f'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apcalcbc-mcq-039', '7ffa3a3c-5e6e-4c35-bdc7-bd6ca6d8e1ff'::uuid, 'Hard', 'normalised_casing', 'Hard', 'Preserved authored three-level source value ''Hard'' as operative band ''Hard''; raw value preserved.', 'high'),
  ('apcalcbc-mcq-040', '7e90cc29-6b7b-442f-9742-7b099d3745da'::uuid, 'Easy', 'normalised_casing', 'Easy', 'Preserved authored three-level source value ''Easy'' as operative band ''Easy''; raw value preserved.', 'high'),
  ('apcalcbc-mcq-041', '2bcaf641-2acb-418e-93a5-c1fa9ee02d83'::uuid, 'Hard', 'translated', 'Very Hard', 'Translated authored source value ''Very Hard'' to the operative three-level band ''Hard''; raw value preserved.', 'high'),
  ('apcalcbc-mcq-042', '7fd6e86b-00c8-4167-9cf3-2e9d94c5a0ae'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apcalcbc-mcq-043', '7945bd22-d0a1-4bba-8420-f193751a8118'::uuid, 'Hard', 'normalised_casing', 'Hard', 'Preserved authored three-level source value ''Hard'' as operative band ''Hard''; raw value preserved.', 'high'),
  ('apcalcbc-mcq-044', '519b75bf-b623-404e-9ad7-da11290053dd'::uuid, 'Hard', 'normalised_casing', 'Hard', 'Preserved authored three-level source value ''Hard'' as operative band ''Hard''; raw value preserved.', 'high'),
  ('apcalcbc-mcq-045', 'f4ea3f50-3a6d-460e-b40a-1be96890e04b'::uuid, 'Hard', 'translated', 'Very Hard', 'Translated authored source value ''Very Hard'' to the operative three-level band ''Hard''; raw value preserved.', 'high'),
  ('apcalcbc-mcq-046', '194278ff-5e81-4785-a965-ce99467e3adc'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apcalcbc-mcq-047', '29374f52-56b5-4d44-8d07-182d10f36644'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apcalcbc-mcq-048', '65eb803d-fa43-4292-81fe-dc81a672befc'::uuid, 'Hard', 'normalised_casing', 'Hard', 'Preserved authored three-level source value ''Hard'' as operative band ''Hard''; raw value preserved.', 'high'),
  ('apcalcbc-mcq-049', '4db8a57a-2691-4428-9e8c-2e806f26df40'::uuid, 'Hard', 'translated', 'Very Hard', 'Translated authored source value ''Very Hard'' to the operative three-level band ''Hard''; raw value preserved.', 'high'),
  ('apcalcbc-mcq-050', '6fb0f714-1f8b-47fd-9c84-2caf309ee9f1'::uuid, 'Hard', 'translated', 'Very Hard', 'Translated authored source value ''Very Hard'' to the operative three-level band ''Hard''; raw value preserved.', 'high'),
  ('apcalcbc-mcq-060', '50921ffc-23eb-4c4d-ba0b-060753fa1ce9'::uuid, 'Medium', 'calibrated_judgement', null, 'No decisive MCQ task-verb cue; standard one-concept item judged Medium.', 'low'),
  ('apcalcbc-mcq-070', '19a9cead-bab2-4d15-86b3-839e77c1e6a4'::uuid, 'Medium', 'calibrated_judgement', null, 'No decisive MCQ task-verb cue; standard one-concept item judged Medium.', 'low'),
  ('apcalcbc-mcq-080', '444702a4-517c-437f-b9f8-b6087bec7c64'::uuid, 'Hard', 'calibrated_task_verb', null, 'MCQ stem classified by the approved task-verb framework: hard task-verb cue.', 'medium'),
  ('apcalcbc-mcq-090', 'ea701776-b3cf-4717-9356-ecafad473d18'::uuid, 'Medium', 'calibrated_judgement', null, 'No decisive MCQ task-verb cue; standard one-concept item judged Medium.', 'low'),
  ('apcalcbc-mcq-np1-001', '16930cd8-ce83-4f27-88d1-eeb527396eda'::uuid, 'Medium', 'calibrated_judgement', null, 'No decisive MCQ task-verb cue; standard one-concept item judged Medium.', 'low'),
  ('apcalcbc-mcq-np1-002', '3381c823-3c09-4761-a92a-ab366f68fc57'::uuid, 'Medium', 'calibrated_task_verb', null, 'MCQ stem classified by the approved task-verb framework: medium task-verb cue.', 'medium'),
  ('apcalcbc-mcq-np1-003', '5c574d4a-8667-4923-bcd3-b78d93c1153b'::uuid, 'Medium', 'calibrated_judgement', null, 'No decisive MCQ task-verb cue; standard one-concept item judged Medium.', 'low'),
  ('apcalcbc-mcq-np1-004', 'bc0a0aa8-25f5-4aa9-89a4-71b8e8ff82bc'::uuid, 'Medium', 'calibrated_judgement', null, 'No decisive MCQ task-verb cue; standard one-concept item judged Medium.', 'low'),
  ('apcalcbc-mcq-np1-005', 'fcb0ad00-a203-4e3b-b009-9038634655e1'::uuid, 'Medium', 'calibrated_judgement', null, 'No decisive MCQ task-verb cue; standard one-concept item judged Medium.', 'low'),
  ('apcalcbc-mcq-np1-006', '98dc1c7e-aaf3-451c-80bc-75d10b956334'::uuid, 'Medium', 'calibrated_judgement', null, 'No decisive MCQ task-verb cue; standard one-concept item judged Medium.', 'low'),
  ('apcalcbc-mcq-np1-007', 'ade897f4-da4e-44dd-80f7-e6d8b8cad417'::uuid, 'Medium', 'calibrated_judgement', null, 'No decisive MCQ task-verb cue; standard one-concept item judged Medium.', 'low'),
  ('apcalcbc-mcq-np1-008', '603d310d-6209-4ac2-a704-9b9c9c10b950'::uuid, 'Medium', 'calibrated_judgement', null, 'No decisive MCQ task-verb cue; standard one-concept item judged Medium.', 'low'),
  ('apcalcbc-mcq-np1-009', '3af5af1d-38b3-440d-a2a6-d1e6adfbe422'::uuid, 'Medium', 'calibrated_judgement', null, 'No decisive MCQ task-verb cue; standard one-concept item judged Medium.', 'low'),
  ('apcalcbc-mcq-np1-010', '702a0a6b-e5e1-4ec8-9d16-ae9097ef7660'::uuid, 'Medium', 'calibrated_task_verb', null, 'MCQ stem classified by the approved task-verb framework: medium task-verb cue.', 'medium');

do $$
declare
  v_expected int := 127;
  v_rows int;
  v_bad_subject int;
  v_prior int;
begin
  select count(*) into v_rows from tmp_subject_difficulty;
  if v_rows <> v_expected then
    raise exception 'AP Calculus BC difficulty: expected % rows, found %', v_expected, v_rows;
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
      and ep.exam_code = 'ap_calculus_bc'
      and epv.status = 'published'
      and epv.retired_at is null
      and ci.status = 'published'
      and latest.status = 'published'
  );
  if v_bad_subject <> 0 then
    raise exception 'AP Calculus BC difficulty: % rows are contaminated, retired, or non-current', v_bad_subject;
  end if;

  select count(*) into v_prior
  from tmp_subject_difficulty tmp
  join app.content_item_difficulty cid
    on cid.content_item_version_id = tmp.content_item_version_id;
  if v_prior <> 0 then
    raise exception 'AP Calculus BC difficulty: % versions already have difficulty rows', v_prior;
  end if;
end $$;

insert into app.content_item_difficulty (
  content_item_version_id, difficulty, basis, attainment_ratio, ratio_source,
  subject_cut_points, source_value, rationale, confidence, proposal_run
)
select
  content_item_version_id, difficulty, basis, null, null,
  null, source_value, rationale, confidence,
  'ap_calculus_bc_tier3_difficulty_2026_09_26'
from tmp_subject_difficulty;

commit;
