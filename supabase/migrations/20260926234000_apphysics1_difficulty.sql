-- AP Physics 1 Tier 3 difficulty calibration.
-- Generated offline on 2026-09-26; not applied by the generator.
-- DECISION-0061/0065: three bands; source preserved; honest null ratios.
-- Expected rows: 117. Source: docs/research/content_pipeline_difficulty_2026_09_26/AP_PHYSICS_1_DIFFICULTY_ASSIGNMENTS_2026_09_26.csv.

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
  ('apphy1-frq-001', '86e72fa9-ccf0-4496-aba2-ef42f8ec8fe1'::uuid, 'Easy', 'normalised_casing', 'Easy', 'Preserved authored three-level source value ''Easy'' as operative band ''Easy''; raw value preserved.', 'high'),
  ('apphy1-frq-012', 'd5148959-28b2-4e2d-a111-f64926d3d2f4'::uuid, 'Hard', 'normalised_casing', 'Hard', 'Preserved authored three-level source value ''Hard'' as operative band ''Hard''; raw value preserved.', 'high'),
  ('apphy1-frq-014', 'ca68fb39-58be-4691-bfe7-c47ecd46f282'::uuid, 'Hard', 'normalised_casing', 'Hard', 'Preserved authored three-level source value ''Hard'' as operative band ''Hard''; raw value preserved.', 'high'),
  ('apphy1-frq-015', 'd1bbeb16-03b4-42c8-ae1b-37a9eb84e8d7'::uuid, 'Hard', 'translated', 'Very Hard', 'Translated authored source value ''Very Hard'' to the operative three-level band ''Hard''; raw value preserved.', 'high'),
  ('apphy1-frq-017', 'bdd84c46-b4ce-4b4a-8059-188e288125c9'::uuid, 'Hard', 'calibrated_task_verb', null, 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=0, Medium=1, Hard=1; uncued=0/2.', 'medium'),
  ('apphy1-frq-018', '6bc66fdd-2dfe-43ca-8f24-f5c33694d9ac'::uuid, 'Medium', 'calibrated_task_verb', null, 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=1, Medium=1, Hard=0; uncued=0/2.', 'medium'),
  ('apphy1-frq-019', 'ec7eca13-207c-4839-9343-9542578e71f8'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apphy1-frq-020', 'dc9a044e-e24c-4f9d-a2b8-232106cce238'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apphy1-frq-021', '6e68bac0-367b-4bda-b971-7f0bab89fa18'::uuid, 'Easy', 'normalised_casing', 'Easy', 'Preserved authored three-level source value ''Easy'' as operative band ''Easy''; raw value preserved.', 'high'),
  ('apphy1-frq-022', '21bff47c-03ba-4d59-8fab-873dcd127469'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apphy1-frq-023', 'def15be4-b068-47e2-b9e6-7dc93b2481af'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apphy1-frq-024', '5bb16d64-6210-499b-aeb7-fa59823ac11a'::uuid, 'Hard', 'calibrated_task_verb', null, 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=1, Medium=1, Hard=1; uncued=0/3.', 'medium'),
  ('apphy1-frq-025', '357a5ca6-c0ff-4ad2-a5ed-1a2dfce4cf8d'::uuid, 'Hard', 'calibrated_task_verb', null, 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=0, Medium=2, Hard=4; uncued=0/6.', 'medium'),
  ('apphy1-frq-026', '3860d78d-4c4c-4505-bfc1-8db4ba0bbf45'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apphy1-frq-027', '85f95e28-10f2-455b-bd41-ab4a0b97cb5d'::uuid, 'Easy', 'normalised_casing', 'Easy', 'Preserved authored three-level source value ''Easy'' as operative band ''Easy''; raw value preserved.', 'high'),
  ('apphy1-frq-029', 'c973ec2c-826d-4dcf-bc00-aed52d250ee9'::uuid, 'Hard', 'normalised_casing', 'Hard', 'Preserved authored three-level source value ''Hard'' as operative band ''Hard''; raw value preserved.', 'high'),
  ('apphy1-frq-030', 'eb3cd946-0364-4170-83da-690d6597b2d7'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apphy1-frq-031', 'e77f13b0-bb68-4e34-8dd5-b4cbe18219fc'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apphy1-frq-032', 'b95a39b7-e1be-49ae-aa09-a5f9dbd5cd01'::uuid, 'Easy', 'calibrated_task_verb', null, 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=2, Medium=1, Hard=0; uncued=3/6.', 'medium'),
  ('apphy1-frq-033', 'beacb3d2-fd4c-404d-95b9-e734637d17d8'::uuid, 'Easy', 'calibrated_task_verb', null, 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=2, Medium=0, Hard=0; uncued=1/3.', 'medium'),
  ('apphy1-frq-035', '9f159e00-a8d9-4690-945b-c255632a5429'::uuid, 'Hard', 'normalised_casing', 'Hard', 'Preserved authored three-level source value ''Hard'' as operative band ''Hard''; raw value preserved.', 'high'),
  ('apphy1-frq-037', '96f0cca0-0b23-4d3d-91f1-d5c0bf65832c'::uuid, 'Hard', 'normalised_casing', 'Hard', 'Preserved authored three-level source value ''Hard'' as operative band ''Hard''; raw value preserved.', 'high'),
  ('apphy1-frq-038', 'db659ebf-4ffa-4a30-aa77-f0fd3e2b1a3a'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apphy1-frq-039', 'bf116285-ed24-4204-abb5-0991b3584a22'::uuid, 'Hard', 'calibrated_task_verb', null, 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=0, Medium=1, Hard=2; uncued=0/3.', 'medium'),
  ('apphy1-frq-040', 'c7a640a0-0475-4276-bc66-1de484a058a6'::uuid, 'Hard', 'calibrated_task_verb', null, 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=0, Medium=1, Hard=4; uncued=0/5.', 'medium'),
  ('apphy1-frq-041', 'f43cd467-46ad-4758-b6c9-21e3851a261e'::uuid, 'Hard', 'calibrated_task_verb', null, 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=1, Medium=1, Hard=1; uncued=0/3.', 'medium'),
  ('apphy1-frq-042', '2a7ee51f-c0d2-490c-bc20-2e749616868b'::uuid, 'Hard', 'calibrated_task_verb', null, 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=0, Medium=2, Hard=2; uncued=0/4.', 'medium'),
  ('apphy1-frq-043', '0927826d-129f-490a-911c-ad68c38eb929'::uuid, 'Hard', 'calibrated_task_verb', null, 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=0, Medium=1, Hard=2; uncued=0/3.', 'medium'),
  ('apphy1-frq-044', '8a24e2ec-5604-4100-a3f9-565a0ed16d5b'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apphy1-frq-045', '408b1a87-6b9a-438d-93e8-9881ea534971'::uuid, 'Easy', 'calibrated_task_verb', null, 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=3, Medium=1, Hard=0; uncued=0/4.', 'medium'),
  ('apphy1-frq-046', 'f0613586-dd55-4891-b441-ce9abccc3b28'::uuid, 'Hard', 'calibrated_task_verb', null, 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=0, Medium=0, Hard=2; uncued=0/2.', 'medium'),
  ('apphy1-frq-047', '050bf660-8498-452f-bfad-e521280c3e46'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apphy1-frq-048', '2a52b9bb-636d-43f7-8ffe-d67a746e0bfb'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apphy1-frq-049', '76d2506f-9aeb-4d39-b20d-804df229efd5'::uuid, 'Easy', 'calibrated_task_verb', null, 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=4, Medium=2, Hard=0; uncued=0/6.', 'medium'),
  ('apphy1-frq-050', '78097e73-05c4-4498-8407-f9fbc9060755'::uuid, 'Hard', 'calibrated_task_verb', null, 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=0, Medium=1, Hard=3; uncued=0/4.', 'medium'),
  ('apphy1-frq-051', '8aeccb20-2703-408e-a8ea-0a6eaec41310'::uuid, 'Hard', 'normalised_casing', 'Hard', 'Preserved authored three-level source value ''Hard'' as operative band ''Hard''; raw value preserved.', 'high'),
  ('apphy1-frq-052', 'a15042a9-45bb-4ea3-95f9-02f3c208a373'::uuid, 'Hard', 'normalised_casing', 'Hard', 'Preserved authored three-level source value ''Hard'' as operative band ''Hard''; raw value preserved.', 'high'),
  ('apphy1-frq-053', 'dc25829e-0b21-4dae-9e99-dbd3f5201651'::uuid, 'Easy', 'calibrated_task_verb', null, 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=3, Medium=1, Hard=1; uncued=0/5.', 'medium'),
  ('apphy1-frq-054', '4c283652-3ddd-4d93-99f7-186acbed682d'::uuid, 'Hard', 'normalised_casing', 'Hard', 'Preserved authored three-level source value ''Hard'' as operative band ''Hard''; raw value preserved.', 'high'),
  ('apphy1-frq-055', 'c565c13b-b3b4-41f0-ab4c-206673372e1b'::uuid, 'Hard', 'normalised_casing', 'Hard', 'Preserved authored three-level source value ''Hard'' as operative band ''Hard''; raw value preserved.', 'high'),
  ('apphy1-frq-056', '9cac395c-05da-4b9e-bb3c-f6d3905238bf'::uuid, 'Hard', 'calibrated_task_verb', null, 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=0, Medium=1, Hard=5; uncued=0/6.', 'medium'),
  ('apphy1-frq-057', '105deb51-6c66-415d-8537-28d22a54d095'::uuid, 'Hard', 'calibrated_task_verb', null, 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=3, Medium=2, Hard=3; uncued=0/8.', 'medium'),
  ('apphy1-frq-058', '26b34dfd-f85b-4520-97e5-de69f04c4940'::uuid, 'Hard', 'translated', 'Very Hard', 'Translated authored source value ''Very Hard'' to the operative three-level band ''Hard''; raw value preserved.', 'high'),
  ('apphy1-frq-np1-001', '40c3850d-f7e1-4ad7-bde8-0ff27230d22c'::uuid, 'Medium', 'calibrated_task_verb', null, 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=0, Medium=3, Hard=0; uncued=1/4.', 'medium'),
  ('apphy1-frq-np1-002', '4c413573-a128-4274-a44c-2bacd6289897'::uuid, 'Medium', 'calibrated_task_verb', null, 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=0, Medium=3, Hard=1; uncued=0/4.', 'medium'),
  ('apphy1-frq-np1-003', '64f59454-5f26-4483-8407-7202ed6f8142'::uuid, 'Medium', 'calibrated_task_verb', null, 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=0, Medium=4, Hard=0; uncued=0/4.', 'medium'),
  ('apphy1-frq-np1-004', '91ea2d10-2353-4956-a83a-6f0be6d6f6fd'::uuid, 'Medium', 'calibrated_task_verb', null, 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=0, Medium=4, Hard=0; uncued=0/4.', 'medium'),
  ('apphy1-frq-np1-005', '591e865e-e2ab-410d-9c6b-1ec7e79e2379'::uuid, 'Medium', 'calibrated_task_verb', null, 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=0, Medium=3, Hard=1; uncued=0/4.', 'medium'),
  ('apphy1-frq-np1-006', '1200ff17-ed8a-433f-ae65-efd3c136bcd0'::uuid, 'Hard', 'calibrated_task_verb', null, 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=0, Medium=2, Hard=2; uncued=0/4.', 'medium'),
  ('apphy1-frq-np1-007', '664f7767-66a4-49c6-9959-452e6c5e8666'::uuid, 'Medium', 'calibrated_task_verb', null, 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=0, Medium=3, Hard=1; uncued=0/4.', 'medium'),
  ('apphy1-frq-np1-008', '67b35097-72a4-4af6-b621-61cf15188e9f'::uuid, 'Medium', 'calibrated_task_verb', null, 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=0, Medium=5, Hard=0; uncued=0/5.', 'medium'),
  ('apphy1-frq-np1-009', '85ab476a-ed8d-4e51-a35a-f935260094c3'::uuid, 'Medium', 'calibrated_task_verb', null, 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=0, Medium=4, Hard=0; uncued=0/4.', 'medium'),
  ('apphy1-frq-np1-010', '126217af-dd27-484a-8221-c760e3b21f58'::uuid, 'Medium', 'calibrated_task_verb', null, 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=0, Medium=3, Hard=0; uncued=0/3.', 'medium'),
  ('apphy1-frq-np2-007', '01e51098-a810-4cdf-9be9-e6e98c7be0ea'::uuid, 'Hard', 'normalised_casing', 'Hard', 'Preserved authored three-level source value ''Hard'' as operative band ''Hard''; raw value preserved.', 'high'),
  ('apphy1-mcq-001', '2c820084-2551-4764-853d-a0dc9f11e0c9'::uuid, 'Easy', 'normalised_casing', 'Easy', 'Preserved authored three-level source value ''Easy'' as operative band ''Easy''; raw value preserved.', 'high'),
  ('apphy1-mcq-003', '24e1b672-8130-4e68-9ecf-0fa9875bfffb'::uuid, 'Easy', 'normalised_casing', 'Easy', 'Preserved authored three-level source value ''Easy'' as operative band ''Easy''; raw value preserved.', 'high'),
  ('apphy1-mcq-004', '926d74a3-728c-4d70-988c-2badf0b4884f'::uuid, 'Easy', 'normalised_casing', 'Easy', 'Preserved authored three-level source value ''Easy'' as operative band ''Easy''; raw value preserved.', 'high'),
  ('apphy1-mcq-005', 'bb9afd55-b2d5-4af0-94c9-59886dc5926c'::uuid, 'Easy', 'normalised_casing', 'Easy', 'Preserved authored three-level source value ''Easy'' as operative band ''Easy''; raw value preserved.', 'high'),
  ('apphy1-mcq-006', 'c7e38946-d45b-42e6-8c58-919e9bfce4a5'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apphy1-mcq-007', '220a3baa-2b1d-481a-9670-db5038c7c291'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apphy1-mcq-008', 'f6925ed6-4935-4a38-aaef-c100c8c22240'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apphy1-mcq-009', '1f58497a-221b-4265-928f-8e70331ee3b4'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apphy1-mcq-010', '0c9fdac3-6787-4bd4-b302-abed1a982ab1'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apphy1-mcq-011', '099337a6-966a-4ef1-b931-a0a5a8df67bf'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apphy1-mcq-012', 'c525b652-0731-4fa7-9300-4d8c835a76a4'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apphy1-mcq-014', 'c71dcbce-3da7-4c8e-9c62-9cc87ea01355'::uuid, 'Hard', 'normalised_casing', 'Hard', 'Preserved authored three-level source value ''Hard'' as operative band ''Hard''; raw value preserved.', 'high'),
  ('apphy1-mcq-015', '0d08ffbf-c83b-45a4-98a8-f97f3246660c'::uuid, 'Hard', 'normalised_casing', 'Hard', 'Preserved authored three-level source value ''Hard'' as operative band ''Hard''; raw value preserved.', 'high'),
  ('apphy1-mcq-016', '190d1f49-0544-42fa-ba0d-0b9da1def765'::uuid, 'Hard', 'normalised_casing', 'Hard', 'Preserved authored three-level source value ''Hard'' as operative band ''Hard''; raw value preserved.', 'high'),
  ('apphy1-mcq-017', 'b240be8d-c4c0-4d82-8278-09592bbd3d90'::uuid, 'Hard', 'normalised_casing', 'Hard', 'Preserved authored three-level source value ''Hard'' as operative band ''Hard''; raw value preserved.', 'high'),
  ('apphy1-mcq-018', '89a4d869-97ad-4bcb-8e8b-8b2cd5d10be4'::uuid, 'Hard', 'normalised_casing', 'Hard', 'Preserved authored three-level source value ''Hard'' as operative band ''Hard''; raw value preserved.', 'high'),
  ('apphy1-mcq-019', 'e6481db2-df0b-4424-8b54-56889c85609d'::uuid, 'Hard', 'translated', 'Very Hard', 'Translated authored source value ''Very Hard'' to the operative three-level band ''Hard''; raw value preserved.', 'high'),
  ('apphy1-mcq-020', 'c4a6ebb3-d175-4a60-8b4e-97fd7747f9df'::uuid, 'Hard', 'translated', 'Very Hard', 'Translated authored source value ''Very Hard'' to the operative three-level band ''Hard''; raw value preserved.', 'high'),
  ('apphy1-mcq-021', 'ecaad82f-c923-4a65-8c54-cd6e99da73b2'::uuid, 'Medium', 'calibrated_judgement', null, 'No decisive MCQ task-verb cue; standard one-concept item judged Medium.', 'low'),
  ('apphy1-mcq-022', 'bdb3517e-2fad-4517-90d1-6763df42f6e8'::uuid, 'Medium', 'calibrated_judgement', null, 'No decisive MCQ task-verb cue; standard one-concept item judged Medium.', 'low'),
  ('apphy1-mcq-023', 'eff69e7c-46eb-46dd-8b58-5a8714e43c94'::uuid, 'Medium', 'calibrated_task_verb', null, 'MCQ stem classified by the approved task-verb framework: medium task-verb cue.', 'medium'),
  ('apphy1-mcq-024', '6c427f6c-b401-4043-a470-458dcc416a86'::uuid, 'Medium', 'calibrated_judgement', null, 'No decisive MCQ task-verb cue; standard one-concept item judged Medium.', 'low'),
  ('apphy1-mcq-025', '45181081-39da-484b-b13b-863eb5f997ff'::uuid, 'Medium', 'calibrated_judgement', null, 'No decisive MCQ task-verb cue; standard one-concept item judged Medium.', 'low'),
  ('apphy1-mcq-026', '8d17d888-657c-4454-b31d-8e206af7c9cc'::uuid, 'Medium', 'calibrated_task_verb', null, 'MCQ stem classified by the approved task-verb framework: medium task-verb cue.', 'medium'),
  ('apphy1-mcq-027', '06673d08-b128-4c03-ae90-a800fd981340'::uuid, 'Easy', 'normalised_casing', 'Easy', 'Preserved authored three-level source value ''Easy'' as operative band ''Easy''; raw value preserved.', 'high'),
  ('apphy1-mcq-028', 'fb38cec8-6e6c-4626-bd70-83c831809672'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apphy1-mcq-029', '2603976c-9939-4f74-99e2-d01c3a03eea5'::uuid, 'Easy', 'normalised_casing', 'Easy', 'Preserved authored three-level source value ''Easy'' as operative band ''Easy''; raw value preserved.', 'high'),
  ('apphy1-mcq-030', 'de3eaba6-9673-4bcc-b719-169f6eee2c1f'::uuid, 'Easy', 'normalised_casing', 'Easy', 'Preserved authored three-level source value ''Easy'' as operative band ''Easy''; raw value preserved.', 'high'),
  ('apphy1-mcq-031', '075dcd6e-8e6f-4458-b1c1-4235efde6475'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apphy1-mcq-032', '597e294e-e4e0-4756-9892-502e71fba634'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apphy1-mcq-033', '996fa997-44be-474f-9a2e-56bc793a48d8'::uuid, 'Easy', 'normalised_casing', 'Easy', 'Preserved authored three-level source value ''Easy'' as operative band ''Easy''; raw value preserved.', 'high'),
  ('apphy1-mcq-034', '0c7d5004-5595-44b6-8d9b-97c5c865edf9'::uuid, 'Hard', 'normalised_casing', 'Hard', 'Preserved authored three-level source value ''Hard'' as operative band ''Hard''; raw value preserved.', 'high'),
  ('apphy1-mcq-035', 'e985d1eb-8dc5-43cc-8d5b-d63e360463ad'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apphy1-mcq-036', 'a1dfe74d-67dd-4fec-ab51-5130926bf8df'::uuid, 'Easy', 'normalised_casing', 'Easy', 'Preserved authored three-level source value ''Easy'' as operative band ''Easy''; raw value preserved.', 'high'),
  ('apphy1-mcq-037', '109a8378-0f5f-4dd8-814d-3822a59398da'::uuid, 'Easy', 'normalised_casing', 'Easy', 'Preserved authored three-level source value ''Easy'' as operative band ''Easy''; raw value preserved.', 'high'),
  ('apphy1-mcq-038', '61a0acd1-d7b1-4b73-8293-29a24583c7b0'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apphy1-mcq-039', '0efe6803-940a-42b0-8d68-742b4072fad8'::uuid, 'Easy', 'normalised_casing', 'Easy', 'Preserved authored three-level source value ''Easy'' as operative band ''Easy''; raw value preserved.', 'high'),
  ('apphy1-mcq-040', '5b2e914d-dea5-4f5d-9a27-56bbd0b96b13'::uuid, 'Easy', 'normalised_casing', 'Easy', 'Preserved authored three-level source value ''Easy'' as operative band ''Easy''; raw value preserved.', 'high'),
  ('apphy1-mcq-041', '634ff15f-d50c-4b06-86de-2a0d36b6f113'::uuid, 'Easy', 'normalised_casing', 'Easy', 'Preserved authored three-level source value ''Easy'' as operative band ''Easy''; raw value preserved.', 'high'),
  ('apphy1-mcq-042', '9bb41125-91f3-4ff8-9966-1752ed3e1263'::uuid, 'Medium', 'calibrated_judgement', null, 'No decisive MCQ task-verb cue; standard one-concept item judged Medium.', 'low'),
  ('apphy1-mcq-043', 'edc13957-c6a1-4ed0-89d6-03d45d535731'::uuid, 'Easy', 'normalised_casing', 'Easy', 'Preserved authored three-level source value ''Easy'' as operative band ''Easy''; raw value preserved.', 'high'),
  ('apphy1-mcq-044', '967a26f8-30c2-466c-973b-5422389cf9ef'::uuid, 'Easy', 'normalised_casing', 'Easy', 'Preserved authored three-level source value ''Easy'' as operative band ''Easy''; raw value preserved.', 'high'),
  ('apphy1-mcq-045', '2cb3c6fd-4c2d-41af-a3dc-e2e3b5db4e8d'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apphy1-mcq-046', 'a6e95d9b-91cb-4004-bbf9-d393fa9a3c81'::uuid, 'Easy', 'normalised_casing', 'Easy', 'Preserved authored three-level source value ''Easy'' as operative band ''Easy''; raw value preserved.', 'high'),
  ('apphy1-mcq-047', 'e06d79d9-0a0e-4794-8d76-86a0bf3d60e3'::uuid, 'Easy', 'normalised_casing', 'Easy', 'Preserved authored three-level source value ''Easy'' as operative band ''Easy''; raw value preserved.', 'high'),
  ('apphy1-mcq-048', 'a7bfb31f-ad79-4b7d-8cb2-a3afddd128ab'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apphy1-mcq-049', 'b2d2b392-90c8-4da5-a163-b093df91c911'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apphy1-mcq-050', 'd6ce72be-9e61-4c93-a3db-49e39f0f2a77'::uuid, 'Medium', 'calibrated_judgement', null, 'No decisive MCQ task-verb cue; standard one-concept item judged Medium.', 'low'),
  ('apphy1-mcq-np1-001', '62a90a11-984f-4725-8e80-5a0339369492'::uuid, 'Medium', 'calibrated_task_verb', null, 'MCQ stem classified by the approved task-verb framework: medium task-verb cue.', 'medium'),
  ('apphy1-mcq-np1-002', 'fa5569b5-9295-42d1-9bdb-04da5e5d2443'::uuid, 'Hard', 'calibrated_task_verb', null, 'MCQ stem classified by the approved task-verb framework: hard task-verb cue.', 'medium'),
  ('apphy1-mcq-np1-003', '9378703b-8170-47ba-a4a4-e5c913d142b4'::uuid, 'Medium', 'calibrated_task_verb', null, 'MCQ stem classified by the approved task-verb framework: medium task-verb cue.', 'medium'),
  ('apphy1-mcq-np1-004', '9bff5406-439b-4103-893a-bd902f813a11'::uuid, 'Medium', 'calibrated_judgement', null, 'No decisive MCQ task-verb cue; standard one-concept item judged Medium.', 'low'),
  ('apphy1-mcq-np1-005', 'a42325f5-1cd3-41ca-ab6c-5182fc45c13d'::uuid, 'Medium', 'calibrated_judgement', null, 'No decisive MCQ task-verb cue; standard one-concept item judged Medium.', 'low'),
  ('apphy1-mcq-np1-006', 'ba6460cb-0609-49ae-9587-60e6575eb2ef'::uuid, 'Medium', 'calibrated_judgement', null, 'No decisive MCQ task-verb cue; standard one-concept item judged Medium.', 'low'),
  ('apphy1-mcq-np1-007', 'e49f394b-fd51-4b50-83a3-867d99c23ce8'::uuid, 'Medium', 'calibrated_judgement', null, 'No decisive MCQ task-verb cue; standard one-concept item judged Medium.', 'low'),
  ('apphy1-mcq-np1-008', 'fa8abc48-89e5-4d75-bf15-d0357b5ffd6c'::uuid, 'Medium', 'calibrated_task_verb', null, 'MCQ stem classified by the approved task-verb framework: medium task-verb cue.', 'medium'),
  ('apphy1-mcq-np1-009', '429d4ece-1723-4dad-8db4-c548d1f8abb1'::uuid, 'Medium', 'calibrated_judgement', null, 'No decisive MCQ task-verb cue; standard one-concept item judged Medium.', 'low'),
  ('apphy1-mcq-np1-010', '538f8e41-d20e-422a-b7a8-13495665c5d9'::uuid, 'Medium', 'calibrated_judgement', null, 'No decisive MCQ task-verb cue; standard one-concept item judged Medium.', 'low'),
  ('apphy1-mcq-np2-001', '6d2349fc-2359-4a96-87e5-0dc91c0a4e24'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apphy1-mcq-np2-003', '338affec-7980-49d3-aceb-d126147ef8cb'::uuid, 'Hard', 'normalised_casing', 'Hard', 'Preserved authored three-level source value ''Hard'' as operative band ''Hard''; raw value preserved.', 'high'),
  ('apphy1-mcq-np2-004', 'a4e40fd5-7483-4ea6-8ca6-0c454f4e2b26'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apphy1-mcq-np2-008', '44fc574f-2372-4822-a6f4-2b79ac2aee42'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apphy1-mcq-np2-009', '432c7f01-499e-4399-a313-34c5dbe730f8'::uuid, 'Hard', 'normalised_casing', 'Hard', 'Preserved authored three-level source value ''Hard'' as operative band ''Hard''; raw value preserved.', 'high');

do $$
declare
  v_expected int := 117;
  v_rows int;
  v_bad_subject int;
  v_prior int;
begin
  select count(*) into v_rows from tmp_subject_difficulty;
  if v_rows <> v_expected then
    raise exception 'AP Physics 1 difficulty: expected % rows, found %', v_expected, v_rows;
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
      and ep.exam_code = 'ap_physics_1'
      and epv.status = 'published'
      and epv.retired_at is null
      and ci.status = 'published'
      and latest.status = 'published'
  );
  if v_bad_subject <> 0 then
    raise exception 'AP Physics 1 difficulty: % rows are contaminated, retired, or non-current', v_bad_subject;
  end if;

  select count(*) into v_prior
  from tmp_subject_difficulty tmp
  join app.content_item_difficulty cid
    on cid.content_item_version_id = tmp.content_item_version_id;
  if v_prior <> 0 then
    raise exception 'AP Physics 1 difficulty: % versions already have difficulty rows', v_prior;
  end if;
end $$;

insert into app.content_item_difficulty (
  content_item_version_id, difficulty, basis, attainment_ratio, ratio_source,
  subject_cut_points, source_value, rationale, confidence, proposal_run
)
select
  content_item_version_id, difficulty, basis, null, null,
  null, source_value, rationale, confidence,
  'ap_physics_1_tier3_difficulty_2026_09_26'
from tmp_subject_difficulty;

commit;
