-- AP Physics C: Mechanics Tier 3 difficulty calibration.
-- Generated offline on 2026-09-26; not applied by the generator.
-- DECISION-0061/0065: three bands; source preserved; honest null ratios.
-- Expected rows: 77. Source: docs/research/content_pipeline_difficulty_2026_09_26/AP_PHYSICS_C_MECHANICS_DIFFICULTY_ASSIGNMENTS_2026_09_26.csv.

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
  ('apphycm-frq-001', '582c18e0-f56a-4813-8751-efb8e0b5a671'::uuid, 'Easy', 'normalised_casing', 'Easy', 'Preserved authored three-level source value ''Easy'' as operative band ''Easy''; raw value preserved.', 'high'),
  ('apphycm-frq-003', 'e7863b1a-5b2b-4d8b-8f66-7ad9e576d9c0'::uuid, 'Easy', 'normalised_casing', 'Easy', 'Preserved authored three-level source value ''Easy'' as operative band ''Easy''; raw value preserved.', 'high'),
  ('apphycm-frq-004', 'c0cf107a-725e-4242-87f4-943f74e9523b'::uuid, 'Easy', 'normalised_casing', 'Easy', 'Preserved authored three-level source value ''Easy'' as operative band ''Easy''; raw value preserved.', 'high'),
  ('apphycm-frq-005', '1563ed28-e535-42a5-8e70-951459b70d01'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apphycm-frq-007', 'bef2c1e6-b959-4106-94fe-4d7e803946c2'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apphycm-frq-008', '6700878c-423e-447e-be05-9e11b15b013b'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apphycm-frq-009', 'b5b41e26-e424-4e1d-9ce1-7c855a6ed663'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apphycm-frq-010', '167a3e58-bc4b-4857-bd38-d3eac681ec1a'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apphycm-frq-011', '2b0ed52f-72a3-40ee-a190-4d87099ddd2b'::uuid, 'Hard', 'normalised_casing', 'Hard', 'Preserved authored three-level source value ''Hard'' as operative band ''Hard''; raw value preserved.', 'high'),
  ('apphycm-frq-012', '877f60ba-7e2d-4e0d-9778-7b04264d58b9'::uuid, 'Hard', 'normalised_casing', 'Hard', 'Preserved authored three-level source value ''Hard'' as operative band ''Hard''; raw value preserved.', 'high'),
  ('apphycm-frq-013', 'd119c3f3-c224-45f6-8f2d-7370c87fddc1'::uuid, 'Hard', 'normalised_casing', 'Hard', 'Preserved authored three-level source value ''Hard'' as operative band ''Hard''; raw value preserved.', 'high'),
  ('apphycm-frq-015', '317345d1-4f50-4fdd-964b-85eff3195244'::uuid, 'Hard', 'translated', 'Very Hard', 'Translated authored source value ''Very Hard'' to the operative three-level band ''Hard''; raw value preserved.', 'high'),
  ('apphycm-frq-016', '09aa37fc-4cb2-4718-82f1-3a19ee1bd15f'::uuid, 'Hard', 'translated', 'Very Hard', 'Translated authored source value ''Very Hard'' to the operative three-level band ''Hard''; raw value preserved.', 'high'),
  ('apphycm-frq-017', '57c6fbdf-72dc-4205-9d04-8dc339144511'::uuid, 'Hard', 'calibrated_task_verb', null, 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=0, Medium=2, Hard=3; uncued=2/7.', 'medium'),
  ('apphycm-frq-018', '086cbead-f233-42d0-ada2-a1f48dfa51ec'::uuid, 'Medium', 'calibrated_task_verb', null, 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=1, Medium=2, Hard=1; uncued=2/6.', 'medium'),
  ('apphycm-frq-019', 'aa3f2f91-39ff-4d42-9af4-9648fdf495ce'::uuid, 'Medium', 'calibrated_task_verb', null, 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=0, Medium=1, Hard=0; uncued=3/4.', 'medium'),
  ('apphycm-frq-020', '3b89db83-f0dc-42d8-aaab-0bd815f2cbba'::uuid, 'Medium', 'calibrated_task_verb', null, 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=0, Medium=2, Hard=1; uncued=1/4.', 'medium'),
  ('apphycm-frq-022', '3c16edf3-d2bc-4ded-969c-1e3497818529'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apphycm-frq-024', '5fcb4563-b353-4692-98aa-af5b356af902'::uuid, 'Hard', 'calibrated_task_verb', null, 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=2, Medium=0, Hard=3; uncued=2/7.', 'medium'),
  ('apphycm-frq-025', 'acd401b0-564e-433e-9bdf-a19ff1977052'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apphycm-frq-026', '7f809bef-c1f9-46d9-a40b-34053ceb3ca5'::uuid, 'Hard', 'normalised_casing', 'Hard', 'Preserved authored three-level source value ''Hard'' as operative band ''Hard''; raw value preserved.', 'high'),
  ('apphycm-frq-027', '4ed7f1e0-371b-4985-b8b9-3f0a4e37c36c'::uuid, 'Hard', 'calibrated_task_verb', null, 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=0, Medium=1, Hard=3; uncued=0/4.', 'medium'),
  ('apphycm-frq-029', '0fea4545-a459-41d6-9262-7f1260588076'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apphycm-frq-030', 'f801426f-6426-4bc7-8182-3d41ac0d85d1'::uuid, 'Medium', 'calibrated_task_verb', null, 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=0, Medium=7, Hard=1; uncued=0/8.', 'medium'),
  ('apphycm-frq-031', '15739e64-449f-48f1-9daa-97fecf8f1122'::uuid, 'Medium', 'calibrated_task_verb', null, 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=1, Medium=2, Hard=1; uncued=0/4.', 'medium'),
  ('apphycm-frq-032', 'b0eebeb1-707b-4e43-b67a-36a30b2a05e2'::uuid, 'Hard', 'calibrated_task_verb', null, 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=1, Medium=1, Hard=1; uncued=1/4.', 'medium'),
  ('apphycm-frq-033', '33adf1cf-de11-4b37-aeee-ee323bf6e761'::uuid, 'Hard', 'calibrated_task_verb', null, 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=1, Medium=2, Hard=2; uncued=2/7.', 'medium'),
  ('apphycm-frq-034', '2ef5f8b1-d238-44e8-b81d-c25f21910ecf'::uuid, 'Hard', 'calibrated_task_verb', null, 'Per-criterion approved task-verb tiers, modal with upward tie-break: Easy=1, Medium=1, Hard=1; uncued=1/4.', 'medium'),
  ('apphycm-frq-035', '371c2cda-06e0-440e-bb60-2b544e7799ae'::uuid, 'Hard', 'normalised_casing', 'Hard', 'Preserved authored three-level source value ''Hard'' as operative band ''Hard''; raw value preserved.', 'high'),
  ('apphycm-frq-036', 'd46347bb-0063-4627-b1a5-0b099ca01a71'::uuid, 'Hard', 'normalised_casing', 'Hard', 'Preserved authored three-level source value ''Hard'' as operative band ''Hard''; raw value preserved.', 'high'),
  ('apphycm-frq-037', 'c46146ec-f28e-4db7-bce8-b8bbf44688d7'::uuid, 'Hard', 'normalised_casing', 'Hard', 'Preserved authored three-level source value ''Hard'' as operative band ''Hard''; raw value preserved.', 'high'),
  ('apphycm-frq-044', 'e94aab5e-bc64-4397-bbe4-6044cdfe66cc'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apphycm-frq-047', 'bc2f6a20-bd16-4ac0-a975-7619f80212b2'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apphycm-frq-049', 'abcb1df9-3dc3-4403-a7ab-ec6c88fd1e9f'::uuid, 'Hard', 'normalised_casing', 'Hard', 'Preserved authored three-level source value ''Hard'' as operative band ''Hard''; raw value preserved.', 'high'),
  ('apphycm-frq-050', '8e3d19be-4792-4fc0-a1d4-32d4a3c889d3'::uuid, 'Hard', 'normalised_casing', 'Hard', 'Preserved authored three-level source value ''Hard'' as operative band ''Hard''; raw value preserved.', 'high'),
  ('apphycm-frq-051', 'e5a1cbd8-3c5b-46a0-aefe-3996d561ebd9'::uuid, 'Hard', 'normalised_casing', 'Hard', 'Preserved authored three-level source value ''Hard'' as operative band ''Hard''; raw value preserved.', 'high'),
  ('apphycm-mcq-001', 'db2e6c78-ef6f-46a1-a4fb-1dbbb906f2e6'::uuid, 'Easy', 'normalised_casing', 'Easy', 'Preserved authored three-level source value ''Easy'' as operative band ''Easy''; raw value preserved.', 'high'),
  ('apphycm-mcq-002', '7cfdacff-5cb8-417c-9e45-0cd579e98c76'::uuid, 'Easy', 'normalised_casing', 'Easy', 'Preserved authored three-level source value ''Easy'' as operative band ''Easy''; raw value preserved.', 'high'),
  ('apphycm-mcq-003', 'afa57d5f-9865-4994-abe8-5417da1b27db'::uuid, 'Easy', 'normalised_casing', 'Easy', 'Preserved authored three-level source value ''Easy'' as operative band ''Easy''; raw value preserved.', 'high'),
  ('apphycm-mcq-005', 'ad958df1-1534-4cb0-970c-df8e9328985c'::uuid, 'Easy', 'normalised_casing', 'Easy', 'Preserved authored three-level source value ''Easy'' as operative band ''Easy''; raw value preserved.', 'high'),
  ('apphycm-mcq-006', '1bf78f57-14be-4400-8f4a-ef79e6f7b01d'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apphycm-mcq-007', 'ae4db131-c654-4d7a-a9c7-7b54e994341c'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apphycm-mcq-008', '856ead17-947c-4e0f-9592-a2da10b0ade6'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apphycm-mcq-009', '80dda346-3421-4f59-95fc-e7f973e1e15c'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apphycm-mcq-010', '06cab4fb-979c-4ec6-ae24-3e384ef8097a'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apphycm-mcq-011', '7bbc529a-7234-40c3-a573-179ab58d6a13'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apphycm-mcq-012', '6deeda4a-51fc-4932-a515-dc302ff2e27a'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apphycm-mcq-013', '928a5a7e-6957-4b74-9802-281e9ce3e96c'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apphycm-mcq-014', '2a806254-1a78-4af8-b4dd-689a497ef50e'::uuid, 'Hard', 'normalised_casing', 'Hard', 'Preserved authored three-level source value ''Hard'' as operative band ''Hard''; raw value preserved.', 'high'),
  ('apphycm-mcq-015', 'f19dc852-061a-4060-ab50-f526132c9b24'::uuid, 'Hard', 'normalised_casing', 'Hard', 'Preserved authored three-level source value ''Hard'' as operative band ''Hard''; raw value preserved.', 'high'),
  ('apphycm-mcq-016', 'f0d61bed-eb70-4a59-a66d-b5a2c8f0c654'::uuid, 'Hard', 'normalised_casing', 'Hard', 'Preserved authored three-level source value ''Hard'' as operative band ''Hard''; raw value preserved.', 'high'),
  ('apphycm-mcq-017', '69deeb0b-611a-45fd-8e64-defec3e092f4'::uuid, 'Hard', 'normalised_casing', 'Hard', 'Preserved authored three-level source value ''Hard'' as operative band ''Hard''; raw value preserved.', 'high'),
  ('apphycm-mcq-018', '9604811c-40a7-46b2-9340-80f09c38e5d0'::uuid, 'Hard', 'normalised_casing', 'Hard', 'Preserved authored three-level source value ''Hard'' as operative band ''Hard''; raw value preserved.', 'high'),
  ('apphycm-mcq-019', 'b7f33d69-7a41-42ba-9455-eb46472604f3'::uuid, 'Hard', 'translated', 'Very Hard', 'Translated authored source value ''Very Hard'' to the operative three-level band ''Hard''; raw value preserved.', 'high'),
  ('apphycm-mcq-020', 'f415f38a-4f86-4254-92a2-51b3687c44d5'::uuid, 'Hard', 'translated', 'Very Hard', 'Translated authored source value ''Very Hard'' to the operative three-level band ''Hard''; raw value preserved.', 'high'),
  ('apphycm-mcq-021', '2b6e1aa8-7f08-43b1-b7f0-fffa0bbe380d'::uuid, 'Easy', 'normalised_casing', 'Easy', 'Preserved authored three-level source value ''Easy'' as operative band ''Easy''; raw value preserved.', 'high'),
  ('apphycm-mcq-022', 'b7950289-62d4-4275-9b06-bcf1e5523221'::uuid, 'Easy', 'normalised_casing', 'Easy', 'Preserved authored three-level source value ''Easy'' as operative band ''Easy''; raw value preserved.', 'high'),
  ('apphycm-mcq-023', '18ada83c-3177-4506-b8b6-1200358df615'::uuid, 'Easy', 'normalised_casing', 'Easy', 'Preserved authored three-level source value ''Easy'' as operative band ''Easy''; raw value preserved.', 'high'),
  ('apphycm-mcq-024', '54867242-0e93-4bf4-81d1-a54d044bc394'::uuid, 'Easy', 'normalised_casing', 'Easy', 'Preserved authored three-level source value ''Easy'' as operative band ''Easy''; raw value preserved.', 'high'),
  ('apphycm-mcq-025', 'c6bc1dcb-e4be-4a4a-bdcf-cf908d8aff43'::uuid, 'Easy', 'normalised_casing', 'Easy', 'Preserved authored three-level source value ''Easy'' as operative band ''Easy''; raw value preserved.', 'high'),
  ('apphycm-mcq-026', '20aa73d9-a25a-4836-a602-ba540df33334'::uuid, 'Easy', 'normalised_casing', 'Easy', 'Preserved authored three-level source value ''Easy'' as operative band ''Easy''; raw value preserved.', 'high'),
  ('apphycm-mcq-027', 'a9e501c1-c9e1-4237-b40f-07cee0b30fb3'::uuid, 'Easy', 'normalised_casing', 'Easy', 'Preserved authored three-level source value ''Easy'' as operative band ''Easy''; raw value preserved.', 'high'),
  ('apphycm-mcq-028', '6876d1f1-f40b-4415-beb3-bae7898459ff'::uuid, 'Easy', 'normalised_casing', 'Easy', 'Preserved authored three-level source value ''Easy'' as operative band ''Easy''; raw value preserved.', 'high'),
  ('apphycm-mcq-029', '4276e4d3-afac-4f10-8232-1c1c05f563f8'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apphycm-mcq-030', 'dc3bec4a-550a-47d9-85f3-7eedc09c996f'::uuid, 'Easy', 'normalised_casing', 'Easy', 'Preserved authored three-level source value ''Easy'' as operative band ''Easy''; raw value preserved.', 'high'),
  ('apphycm-mcq-031', '53067725-5cab-4423-b089-fa4992dba508'::uuid, 'Easy', 'normalised_casing', 'Easy', 'Preserved authored three-level source value ''Easy'' as operative band ''Easy''; raw value preserved.', 'high'),
  ('apphycm-mcq-032', '5e75e2b8-cfe6-4f8d-bec9-324d66ccd696'::uuid, 'Easy', 'normalised_casing', 'Easy', 'Preserved authored three-level source value ''Easy'' as operative band ''Easy''; raw value preserved.', 'high'),
  ('apphycm-mcq-033', 'ba498b18-fcc5-4323-977c-89cd83878f89'::uuid, 'Easy', 'normalised_casing', 'Easy', 'Preserved authored three-level source value ''Easy'' as operative band ''Easy''; raw value preserved.', 'high'),
  ('apphycm-mcq-034', 'ba6e8551-c83d-4c81-8844-09674b2f42cc'::uuid, 'Easy', 'normalised_casing', 'Easy', 'Preserved authored three-level source value ''Easy'' as operative band ''Easy''; raw value preserved.', 'high'),
  ('apphycm-mcq-035', 'c352aa57-dd96-4b56-9dc1-7a95b80e8da2'::uuid, 'Easy', 'normalised_casing', 'Easy', 'Preserved authored three-level source value ''Easy'' as operative band ''Easy''; raw value preserved.', 'high'),
  ('apphycm-mcq-036', 'fe698e65-d37b-4194-81c2-75504cba2deb'::uuid, 'Easy', 'normalised_casing', 'Easy', 'Preserved authored three-level source value ''Easy'' as operative band ''Easy''; raw value preserved.', 'high'),
  ('apphycm-mcq-037', 'c1f19405-a9cd-45f3-b9d9-55a57b86b180'::uuid, 'Easy', 'normalised_casing', 'Easy', 'Preserved authored three-level source value ''Easy'' as operative band ''Easy''; raw value preserved.', 'high'),
  ('apphycm-mcq-038', '6de62c61-d226-478b-88f6-fed67a05f2a8'::uuid, 'Easy', 'normalised_casing', 'Easy', 'Preserved authored three-level source value ''Easy'' as operative band ''Easy''; raw value preserved.', 'high'),
  ('apphycm-mcq-039', '0284f245-d4ce-4c8d-95bf-3022d1cac73d'::uuid, 'Easy', 'normalised_casing', 'Easy', 'Preserved authored three-level source value ''Easy'' as operative band ''Easy''; raw value preserved.', 'high'),
  ('apphycm-mcq-040', 'a6ce6f27-2a89-4fdb-bd4f-e462b7c09f73'::uuid, 'Medium', 'normalised_casing', 'Medium', 'Preserved authored three-level source value ''Medium'' as operative band ''Medium''; raw value preserved.', 'high'),
  ('apphycm-mcq-041', 'b8e9a3af-7e78-4715-8dab-7b2342d3421f'::uuid, 'Easy', 'normalised_casing', 'Easy', 'Preserved authored three-level source value ''Easy'' as operative band ''Easy''; raw value preserved.', 'high'),
  ('apphycm-mcq-042', '73234415-efbc-48f4-9d1c-acad9e98b7e1'::uuid, 'Easy', 'normalised_casing', 'Easy', 'Preserved authored three-level source value ''Easy'' as operative band ''Easy''; raw value preserved.', 'high');

do $$
declare
  v_expected int := 77;
  v_rows int;
  v_bad_subject int;
  v_prior int;
begin
  select count(*) into v_rows from tmp_subject_difficulty;
  if v_rows <> v_expected then
    raise exception 'AP Physics C: Mechanics difficulty: expected % rows, found %', v_expected, v_rows;
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
      and ep.exam_code = 'ap_physics_c_mechanics'
      and epv.status = 'published'
      and epv.retired_at is null
      and ci.status = 'published'
      and latest.status = 'published'
  );
  if v_bad_subject <> 0 then
    raise exception 'AP Physics C: Mechanics difficulty: % rows are contaminated, retired, or non-current', v_bad_subject;
  end if;

  select count(*) into v_prior
  from tmp_subject_difficulty tmp
  join app.content_item_difficulty cid
    on cid.content_item_version_id = tmp.content_item_version_id;
  if v_prior <> 0 then
    raise exception 'AP Physics C: Mechanics difficulty: % versions already have difficulty rows', v_prior;
  end if;
end $$;

insert into app.content_item_difficulty (
  content_item_version_id, difficulty, basis, attainment_ratio, ratio_source,
  subject_cut_points, source_value, rationale, confidence, proposal_run
)
select
  content_item_version_id, difficulty, basis, null, null,
  null, source_value, rationale, confidence,
  'ap_physics_c_mechanics_tier3_difficulty_2026_09_26'
from tmp_subject_difficulty;

commit;
