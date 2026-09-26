begin;

insert into app.content_item_difficulty (
  content_item_version_id, difficulty, basis, attainment_ratio,
  ratio_source, subject_cut_points, source_value, rationale, confidence, proposal_run
) values
  ('e2616354-3bf6-4195-b23c-22a61b244837'::uuid, 'Medium', 'calibrated_task_verb', null, null, null, null, 'task-verb/regex-cue (modal of 6 criteria: {''Medium'': 6})', 'medium', 'apprecalc_tier3_2026_09_25'),
  ('184814fb-41f2-4820-ace4-368a4fe7e877'::uuid, 'Medium', 'calibrated_task_verb', null, null, null, null, 'task-verb/regex-cue (modal of 1 criteria: {''Medium'': 1})', 'medium', 'apprecalc_tier3_2026_09_25'),
  ('6da87c68-cdd3-4917-b6c1-cbc10a2a1446'::uuid, 'Medium', 'calibrated_task_verb', null, null, null, null, 'task-verb/regex-cue (modal of 6 criteria: {''Medium'': 6})', 'medium', 'apprecalc_tier3_2026_09_25'),
  ('a7ae9b95-dde0-4a8b-a060-969d5c730677'::uuid, 'Medium', 'calibrated_judgement', null, null, null, null, 'judgement (no cue matched at all -- default Medium, undiscriminated)', 'low', 'apprecalc_tier3_2026_09_25'),
  ('1f3da360-fae1-4863-b78e-cbc25096e1ac'::uuid, 'Medium', 'calibrated_task_verb', null, null, null, null, 'task-verb/regex-cue (stem/rationale)', 'medium', 'apprecalc_tier3_2026_09_25'),
  ('75878da0-4881-4cd6-b6e1-a46a177ff6fc'::uuid, 'Medium', 'calibrated_task_verb', null, null, null, null, 'task-verb/regex-cue (stem/rationale)', 'medium', 'apprecalc_tier3_2026_09_25'),
  ('58ea3472-e4ea-4fc4-a9c2-fd8848044534'::uuid, 'Medium', 'calibrated_task_verb', null, null, null, null, 'task-verb/regex-cue (stem/rationale)', 'medium', 'apprecalc_tier3_2026_09_25'),
  ('95daa0ae-0637-4383-b15a-1ffbe8dfb769'::uuid, 'Medium', 'calibrated_judgement', null, null, null, null, 'judgement (no cue matched in stem or rationale -- default Medium, undiscriminated)', 'low', 'apprecalc_tier3_2026_09_25'),
  ('8a117b2f-28e4-45d3-a066-c70df240825b'::uuid, 'Hard', 'calibrated_task_verb', null, null, null, null, 'task-verb/regex-cue (stem/rationale)', 'medium', 'apprecalc_tier3_2026_09_25'),
  ('4c36a1f6-078c-4913-8fb6-e53c05ac4391'::uuid, 'Medium', 'calibrated_judgement', null, null, null, null, 'judgement (no cue matched in stem or rationale -- default Medium, undiscriminated)', 'low', 'apprecalc_tier3_2026_09_25'),
  ('db4e7d67-9e5b-4806-8ddf-9ea933024ef5'::uuid, 'Medium', 'calibrated_judgement', null, null, null, null, 'judgement (no cue matched in stem or rationale -- default Medium, undiscriminated)', 'low', 'apprecalc_tier3_2026_09_25'),
  ('8cf47932-7788-485b-936b-6523b4839944'::uuid, 'Medium', 'calibrated_judgement', null, null, null, null, 'judgement (no cue matched in stem or rationale -- default Medium, undiscriminated)', 'low', 'apprecalc_tier3_2026_09_25'),
  ('f0a05545-2625-4b16-a8f5-736133c23c9a'::uuid, 'Medium', 'calibrated_task_verb', null, null, null, null, 'task-verb/regex-cue (stem/rationale)', 'medium', 'apprecalc_tier3_2026_09_25'),
  ('d564e7b5-c5eb-435b-861c-00e2ac610c7f'::uuid, 'Medium', 'calibrated_judgement', null, null, null, null, 'judgement (no cue matched in stem or rationale -- default Medium, undiscriminated)', 'low', 'apprecalc_tier3_2026_09_25'),
  ('1390a0bb-5287-4e8c-8278-d99f2da60f13'::uuid, 'Medium', 'calibrated_judgement', null, null, null, null, 'judgement (no cue matched in stem or rationale -- default Medium, undiscriminated)', 'low', 'apprecalc_tier3_2026_09_25'),
  ('2724b80e-8771-4ea0-a70a-30c4d44625ca'::uuid, 'Hard', 'calibrated_task_verb', null, null, null, null, 'task-verb/regex-cue (stem/rationale)', 'medium', 'apprecalc_tier3_2026_09_25'),
  ('ad7657b3-e4c2-42a7-8665-c6478054537d'::uuid, 'Medium', 'calibrated_judgement', null, null, null, null, 'judgement (no cue matched in stem or rationale -- default Medium, undiscriminated)', 'low', 'apprecalc_tier3_2026_09_25'),
  ('0107c7cf-3cdd-4dac-8c15-68afd51abc50'::uuid, 'Medium', 'calibrated_judgement', null, null, null, null, 'judgement (no cue matched in stem or rationale -- default Medium, undiscriminated)', 'low', 'apprecalc_tier3_2026_09_25'),
  ('395fa42e-514b-4f12-9e77-2f237cf2baf0'::uuid, 'Medium', 'calibrated_judgement', null, null, null, null, 'judgement (no cue matched in stem or rationale -- default Medium, undiscriminated)', 'low', 'apprecalc_tier3_2026_09_25'),
  ('e419db31-d8a1-45c2-bc73-56b8e10eb73f'::uuid, 'Medium', 'calibrated_judgement', null, null, null, null, 'judgement (no cue matched in stem or rationale -- default Medium, undiscriminated)', 'low', 'apprecalc_tier3_2026_09_25'),
  ('8f4d3521-2ffe-41d9-b984-0ad794740c85'::uuid, 'Medium', 'calibrated_judgement', null, null, null, null, 'judgement (no cue matched in stem or rationale -- default Medium, undiscriminated)', 'low', 'apprecalc_tier3_2026_09_25'),
  ('997ef4a5-dde2-4b96-a6f3-9b02e7162137'::uuid, 'Medium', 'calibrated_judgement', null, null, null, null, 'judgement (no cue matched in stem or rationale -- default Medium, undiscriminated)', 'low', 'apprecalc_tier3_2026_09_25'),
  ('ec7a351a-e7ae-4975-93e6-d96f56d17d41'::uuid, 'Medium', 'calibrated_judgement', null, null, null, null, 'judgement (no cue matched in stem or rationale -- default Medium, undiscriminated)', 'low', 'apprecalc_tier3_2026_09_25'),
  ('62f4499f-0651-422f-9678-548a88cfd8a0'::uuid, 'Medium', 'calibrated_judgement', null, null, null, null, 'judgement (no cue matched in stem or rationale -- default Medium, undiscriminated)', 'low', 'apprecalc_tier3_2026_09_25'),
  ('addb24dd-7548-4a4a-8aec-8b9538eaa5bc'::uuid, 'Medium', 'calibrated_judgement', null, null, null, null, 'judgement (no cue matched in stem or rationale -- default Medium, undiscriminated)', 'low', 'apprecalc_tier3_2026_09_25'),
  ('41678966-fcda-48f1-bd64-1582b798bc65'::uuid, 'Medium', 'calibrated_judgement', null, null, null, null, 'judgement (no cue matched in stem or rationale -- default Medium, undiscriminated)', 'low', 'apprecalc_tier3_2026_09_25'),
  ('bf8bb242-3617-491e-bad7-c3ec02c3908d'::uuid, 'Medium', 'calibrated_judgement', null, null, null, null, 'judgement (no cue matched in stem or rationale -- default Medium, undiscriminated)', 'low', 'apprecalc_tier3_2026_09_25'),
  ('1c7ebb28-c319-4b3e-b95d-c33bb8ca91ed'::uuid, 'Medium', 'calibrated_task_verb', null, null, null, null, 'task-verb/regex-cue (stem/rationale)', 'medium', 'apprecalc_tier3_2026_09_25'),
  ('6a7db798-e2be-4fa3-a4ee-3b79c5faebf6'::uuid, 'Medium', 'calibrated_task_verb', null, null, null, null, 'task-verb/regex-cue (stem/rationale)', 'medium', 'apprecalc_tier3_2026_09_25'),
  ('7d65daed-6f30-492b-89ad-65b14aab614f'::uuid, 'Medium', 'calibrated_judgement', null, null, null, null, 'judgement (no cue matched in stem or rationale -- default Medium, undiscriminated)', 'low', 'apprecalc_tier3_2026_09_25');

commit;
