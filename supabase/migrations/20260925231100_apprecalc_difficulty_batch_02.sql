begin;

insert into app.content_item_difficulty (
  content_item_version_id, difficulty, basis, attainment_ratio,
  ratio_source, subject_cut_points, source_value, rationale, confidence, proposal_run
) values
  ('ba17ab7a-808a-4c24-8244-996ba74d7497'::uuid, 'Medium', 'calibrated_task_verb', null, null, null, null, 'task-verb/regex-cue (modal of 3 criteria: {''Medium'': 3})', 'medium', 'apprecalc_tier3_2026_09_25'),
  ('3d3d769e-3fb7-4a28-bd08-4727853f3ea0'::uuid, 'Medium', 'calibrated_task_verb', null, null, null, null, 'task-verb/regex-cue (modal of 6 criteria: {''Medium'': 6})', 'medium', 'apprecalc_tier3_2026_09_25'),
  ('060dff8c-4168-43b1-85ec-b508ee0bc946'::uuid, 'Medium', 'calibrated_task_verb', null, null, null, null, 'task-verb/regex-cue (modal of 3 criteria: {''Medium'': 3})', 'medium', 'apprecalc_tier3_2026_09_25'),
  ('a8e7f956-3b9b-45d2-a83e-9d19c9d7c085'::uuid, 'Medium', 'calibrated_task_verb', null, null, null, null, 'task-verb/regex-cue (modal of 6 criteria: {''Medium'': 6})', 'medium', 'apprecalc_tier3_2026_09_25'),
  ('b68d2cb7-edc1-4f33-b602-5de990c457e6'::uuid, 'Medium', 'calibrated_task_verb', null, null, null, null, 'task-verb/regex-cue (modal of 6 criteria: {''Medium'': 6})', 'medium', 'apprecalc_tier3_2026_09_25'),
  ('2bbab2ae-7ca1-42b4-915d-b67de9417969'::uuid, 'Hard', 'calibrated_task_verb', null, null, null, null, 'task-verb/regex-cue (modal of 6 criteria: {''Hard'': 5, ''Easy'': 1})', 'medium', 'apprecalc_tier3_2026_09_25'),
  ('b7a5d9ba-b504-42a6-b66e-07903533e2d8'::uuid, 'Hard', 'calibrated_task_verb', null, null, null, null, 'task-verb/regex-cue (modal of 6 criteria: {''Hard'': 5, ''Medium'': 1})', 'medium', 'apprecalc_tier3_2026_09_25'),
  ('470074a2-c95e-4d76-a866-c2fcde2fb16b'::uuid, 'Medium', 'calibrated_task_verb', null, null, null, null, 'task-verb/regex-cue (modal of 6 criteria: {''Medium'': 6})', 'medium', 'apprecalc_tier3_2026_09_25'),
  ('f6dc813c-50d0-45fc-99cd-25a47b811559'::uuid, 'Medium', 'calibrated_task_verb', null, null, null, null, 'task-verb/regex-cue (modal of 6 criteria: {''Medium'': 6})', 'medium', 'apprecalc_tier3_2026_09_25'),
  ('e385e927-883f-483d-9299-daeac95b266f'::uuid, 'Medium', 'calibrated_task_verb', null, null, null, null, 'task-verb/regex-cue (modal of 6 criteria: {''Medium'': 6})', 'medium', 'apprecalc_tier3_2026_09_25'),
  ('fa9e0ce7-fead-4d9c-85fd-620dedd7615f'::uuid, 'Medium', 'calibrated_task_verb', null, null, null, null, 'task-verb/regex-cue (modal of 6 criteria: {''Medium'': 6})', 'medium', 'apprecalc_tier3_2026_09_25'),
  ('a4100b8c-f820-4dfa-9e76-e7c4b271152c'::uuid, 'Medium', 'calibrated_task_verb', null, null, null, null, 'task-verb/regex-cue (modal of 6 criteria: {''Medium'': 6})', 'medium', 'apprecalc_tier3_2026_09_25'),
  ('0c6f5ac1-a8a6-4ab4-bd2c-fd380150114f'::uuid, 'Hard', 'calibrated_task_verb', null, null, null, null, 'task-verb/regex-cue (modal of 6 criteria: {''Hard'': 4, ''Medium'': 2})', 'medium', 'apprecalc_tier3_2026_09_25'),
  ('b7e1dcbe-4a15-45eb-9f7b-ebbaab8da6fd'::uuid, 'Medium', 'calibrated_task_verb', null, null, null, null, 'task-verb/regex-cue (modal of 6 criteria: {''Medium'': 6})', 'medium', 'apprecalc_tier3_2026_09_25'),
  ('9d3fff98-0960-4c91-8813-fe619de46276'::uuid, 'Medium', 'calibrated_task_verb', null, null, null, null, 'task-verb/regex-cue (modal of 6 criteria: {''Medium'': 6})', 'medium', 'apprecalc_tier3_2026_09_25'),
  ('100c521c-b604-4837-a3f9-cc36bc61cb78'::uuid, 'Medium', 'calibrated_judgement', null, null, null, null, 'judgement (no cue matched at all -- default Medium, undiscriminated)', 'low', 'apprecalc_tier3_2026_09_25'),
  ('b4c69acb-e5df-43b8-ac72-d96b8058d78f'::uuid, 'Medium', 'calibrated_judgement', null, null, null, null, 'judgement (no cue matched at all -- default Medium, undiscriminated)', 'low', 'apprecalc_tier3_2026_09_25'),
  ('d7d77cb5-9b34-49ed-97ea-2da4709b3379'::uuid, 'Medium', 'calibrated_task_verb', null, null, null, null, 'task-verb/regex-cue (modal of 1 criteria: {''Medium'': 1})', 'medium', 'apprecalc_tier3_2026_09_25'),
  ('f869e744-2c92-4c3a-b23a-1e0e94b553d5'::uuid, 'Medium', 'calibrated_task_verb', null, null, null, null, 'task-verb/regex-cue (modal of 6 criteria: {''Medium'': 6})', 'medium', 'apprecalc_tier3_2026_09_25'),
  ('3f6a5741-e344-4891-afcf-3c877869b1c4'::uuid, 'Medium', 'calibrated_task_verb', null, null, null, null, 'task-verb/regex-cue (modal of 1 criteria: {''Medium'': 1})', 'medium', 'apprecalc_tier3_2026_09_25'),
  ('123f761a-0b4a-4b6a-979c-f45ecfba3081'::uuid, 'Medium', 'calibrated_task_verb', null, null, null, null, 'task-verb/regex-cue (modal of 6 criteria: {''Medium'': 6})', 'medium', 'apprecalc_tier3_2026_09_25'),
  ('89cb2ceb-9985-48bd-a878-ff6489c4c541'::uuid, 'Medium', 'calibrated_task_verb', null, null, null, null, 'task-verb/regex-cue (modal of 2 criteria: {''Medium'': 2})', 'medium', 'apprecalc_tier3_2026_09_25'),
  ('1bba8d29-eda4-43aa-8872-54448810dcef'::uuid, 'Medium', 'calibrated_task_verb', null, null, null, null, 'task-verb/regex-cue (modal of 6 criteria: {''Medium'': 6})', 'medium', 'apprecalc_tier3_2026_09_25'),
  ('595bd40d-7726-4d7d-af6a-a8adab5d0472'::uuid, 'Medium', 'calibrated_task_verb', null, null, null, null, 'task-verb/regex-cue (modal of 2 criteria: {''Medium'': 2})', 'medium', 'apprecalc_tier3_2026_09_25'),
  ('df08dc19-9be8-4d1a-820c-29bd3e3f0547'::uuid, 'Medium', 'calibrated_task_verb', null, null, null, null, 'task-verb/regex-cue (modal of 6 criteria: {''Medium'': 6})', 'medium', 'apprecalc_tier3_2026_09_25'),
  ('0d390467-9d69-4a5a-acff-123bbfa73620'::uuid, 'Medium', 'calibrated_judgement', null, null, null, null, 'judgement (no cue matched at all -- default Medium, undiscriminated)', 'low', 'apprecalc_tier3_2026_09_25'),
  ('761bf688-8b78-4a2c-a985-3134cdc16e0b'::uuid, 'Medium', 'calibrated_task_verb', null, null, null, null, 'task-verb/regex-cue (modal of 6 criteria: {''Medium'': 6})', 'medium', 'apprecalc_tier3_2026_09_25'),
  ('68e75aee-1621-4fb8-a98b-287be2da2277'::uuid, 'Medium', 'calibrated_judgement', null, null, null, null, 'judgement (no cue matched at all -- default Medium, undiscriminated)', 'low', 'apprecalc_tier3_2026_09_25'),
  ('dd62283a-ac50-404f-8168-59ce2b27a2c3'::uuid, 'Medium', 'calibrated_task_verb', null, null, null, null, 'task-verb/regex-cue (modal of 6 criteria: {''Medium'': 6})', 'medium', 'apprecalc_tier3_2026_09_25'),
  ('d8c9d860-8dba-4c91-a96a-f0be701f5199'::uuid, 'Hard', 'calibrated_task_verb', null, null, null, null, 'task-verb/regex-cue (modal of 1 criteria: {''Hard'': 1})', 'medium', 'apprecalc_tier3_2026_09_25');

commit;
