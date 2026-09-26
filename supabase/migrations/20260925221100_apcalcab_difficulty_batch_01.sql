-- AP Calculus AB Tier 3 difficulty, batch 1/4.
-- Generated from APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv. Batch rows: 31.

begin;

create temporary table tmp_apcalcab_difficulty (
  content_key text not null,
  content_item_version_id uuid not null,
  difficulty text not null,
  basis text not null,
  subject_cut_points jsonb not null,
  rationale text not null
) on commit drop;

insert into tmp_apcalcab_difficulty (
  content_key, content_item_version_id, difficulty, basis, subject_cut_points, rationale
) values
  ('apcalcab-frq-001', 'ccbb330e-f818-4724-bf7b-60c6018bd234'::uuid, 'Medium', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"frq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Modal criterion cue tier with upward tie-break: Easy=0, Medium=3, Hard=0; uncued=0.'),
  ('apcalcab-frq-002', 'e2a84e4f-f23c-4ae9-b575-19cef29ad511'::uuid, 'Hard', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"frq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Modal criterion cue tier with upward tie-break: Easy=0, Medium=1, Hard=2; uncued=0.'),
  ('apcalcab-frq-003', '167fb62c-b87f-4dda-abd0-1403229b885e'::uuid, 'Medium', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"frq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Modal criterion cue tier with upward tie-break: Easy=1, Medium=2, Hard=0; uncued=0.'),
  ('apcalcab-frq-004', '0d313626-3bbe-4b2e-a49d-fb2951c9aa8a'::uuid, 'Medium', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"frq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Modal criterion cue tier with upward tie-break: Easy=1, Medium=6, Hard=0; uncued=2.'),
  ('apcalcab-frq-005', '4069df3a-e60c-4608-9e65-24a920e64b27'::uuid, 'Medium', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"frq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Modal criterion cue tier with upward tie-break: Easy=1, Medium=6, Hard=0; uncued=2.'),
  ('apcalcab-frq-006', 'ac8d8f22-0aa6-4964-84d6-122952d7b4a7'::uuid, 'Medium', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"frq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Modal criterion cue tier with upward tie-break: Easy=2, Medium=6, Hard=0; uncued=1.'),
  ('apcalcab-frq-007', '80904015-b7ea-4c45-b191-d241adbf1dd1'::uuid, 'Medium', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"frq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Modal criterion cue tier with upward tie-break: Easy=1, Medium=7, Hard=0; uncued=1.'),
  ('apcalcab-frq-008', 'e7e9660e-5b55-42d7-9e36-51543619ff35'::uuid, 'Medium', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"frq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Modal criterion cue tier with upward tie-break: Easy=0, Medium=3, Hard=0; uncued=0.'),
  ('apcalcab-frq-009', 'f55d4dec-ca07-43e6-9f1e-70e4071b91e4'::uuid, 'Hard', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"frq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Modal criterion cue tier with upward tie-break: Easy=2, Medium=3, Hard=4; uncued=0.'),
  ('apcalcab-frq-010', 'f11dedde-a8f8-4ba7-bfaf-3aa9f00f2033'::uuid, 'Medium', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"frq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Modal criterion cue tier with upward tie-break: Easy=3, Medium=5, Hard=0; uncued=1.'),
  ('apcalcab-frq-011', '7478fe56-2c66-4937-81c8-c2c805aff31a'::uuid, 'Medium', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"frq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Modal criterion cue tier with upward tie-break: Easy=0, Medium=3, Hard=0; uncued=0.'),
  ('apcalcab-frq-012', '6702312d-cc97-461a-8d7b-624648420740'::uuid, 'Medium', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"frq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Modal criterion cue tier with upward tie-break: Easy=1, Medium=7, Hard=1; uncued=0.'),
  ('apcalcab-frq-015', '69464ac8-38be-41b6-8cdb-903586c0cfce'::uuid, 'Medium', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"frq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Modal criterion cue tier with upward tie-break: Easy=0, Medium=8, Hard=1; uncued=0.'),
  ('apcalcab-frq-016', '2d6b576b-9d00-4e8b-965e-a07be0d7033e'::uuid, 'Medium', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"frq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Modal criterion cue tier with upward tie-break: Easy=0, Medium=3, Hard=0; uncued=0.'),
  ('apcalcab-frq-017', '73db0cfd-c121-4af5-b19d-03bd7d735bec'::uuid, 'Medium', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"frq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Modal criterion cue tier with upward tie-break: Easy=0, Medium=3, Hard=0; uncued=6.'),
  ('apcalcab-frq-018', '8ae0c760-8a62-408f-b6a5-1b7b0c654707'::uuid, 'Medium', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"frq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Modal criterion cue tier with upward tie-break: Easy=0, Medium=3, Hard=2; uncued=4.'),
  ('apcalcab-frq-019', 'b400a260-7a92-4b32-8844-3fdb491d8879'::uuid, 'Medium', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"frq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Modal criterion cue tier with upward tie-break: Easy=0, Medium=7, Hard=0; uncued=2.'),
  ('apcalcab-frq-020', 'f03b7434-56b4-41a8-b778-d65c95de86e5'::uuid, 'Medium', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"frq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Modal criterion cue tier with upward tie-break: Easy=0, Medium=7, Hard=0; uncued=2.'),
  ('apcalcab-frq-022', '92050fd6-0b28-4f58-915e-816939da9aa5'::uuid, 'Medium', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"frq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Modal criterion cue tier with upward tie-break: Easy=0, Medium=5, Hard=0; uncued=4.'),
  ('apcalcab-frq-023', '90a924a8-c427-4c8b-a53b-cc872045b83b'::uuid, 'Medium', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"frq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Modal criterion cue tier with upward tie-break: Easy=0, Medium=7, Hard=0; uncued=2.'),
  ('apcalcab-frq-024', 'c975c3ce-6e5b-4618-8ecc-776f750fbafc'::uuid, 'Medium', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"frq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Modal criterion cue tier with upward tie-break: Easy=0, Medium=4, Hard=1; uncued=4.'),
  ('apcalcab-frq-025', 'b21ebb17-3823-41ad-bf55-4c68e9e3d8f3'::uuid, 'Medium', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"frq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Modal criterion cue tier with upward tie-break: Easy=2, Medium=4, Hard=0; uncued=3.'),
  ('apcalcab-frq-026', '400885fa-5480-4b13-b26e-deb87d9fdfa0'::uuid, 'Medium', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"frq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Modal criterion cue tier with upward tie-break: Easy=1, Medium=6, Hard=0; uncued=3.'),
  ('apcalcab-frq-027', 'cc8eda3b-0e8c-4a81-b0e0-095027262a64'::uuid, 'Medium', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"frq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Modal criterion cue tier with upward tie-break: Easy=0, Medium=6, Hard=0; uncued=3.'),
  ('apcalcab-frq-028', '3af5ba83-b824-4d66-b2df-3292e77f272b'::uuid, 'Medium', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"frq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Modal criterion cue tier with upward tie-break: Easy=0, Medium=6, Hard=0; uncued=3.'),
  ('apcalcab-frq-030', 'f7aa944a-7b37-45df-8511-56034e77b483'::uuid, 'Easy', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"frq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Modal criterion cue tier with upward tie-break: Easy=4, Medium=2, Hard=1; uncued=2.'),
  ('apcalcab-frq-031', '7840c050-967d-4695-8391-b3aa82b98f76'::uuid, 'Medium', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"frq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Modal criterion cue tier with upward tie-break: Easy=3, Medium=5, Hard=1; uncued=0.'),
  ('apcalcab-frq-032', 'df787769-b4b9-4d3b-bb79-5a3557d0ebab'::uuid, 'Medium', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"frq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Modal criterion cue tier with upward tie-break: Easy=1, Medium=6, Hard=1; uncued=1.'),
  ('apcalcab-frq-033', 'b2aa5c0f-685d-4df3-8d4c-da1a46163e2a'::uuid, 'Easy', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"frq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Modal criterion cue tier with upward tie-break: Easy=3, Medium=2, Hard=0; uncued=4.'),
  ('apcalcab-frq-034', 'ca81613d-ab96-43a7-9cc1-fb3ba8b68981'::uuid, 'Medium', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"frq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Modal criterion cue tier with upward tie-break: Easy=0, Medium=6, Hard=0; uncued=3.'),
  ('apcalcab-frq-035', 'b318d8fe-1b10-4ab7-a2e5-1cddd9ee8bdd'::uuid, 'Medium', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"frq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Modal criterion cue tier with upward tie-break: Easy=0, Medium=7, Hard=0; uncued=2.');

do $$
declare
  v_expected int := 31;
  v_rows int;
  v_prior int;
  v_bad_subject int;
begin
  select count(*) into v_rows from tmp_apcalcab_difficulty;
  if v_rows <> v_expected then
    raise exception 'AP Calculus AB difficulty batch 1: expected % rows, found %', v_expected, v_rows;
  end if;

  select count(*) into v_prior
  from tmp_apcalcab_difficulty tmp
  join app.content_item_difficulty cid on cid.content_item_version_id = tmp.content_item_version_id;
  if v_prior <> 0 then
    raise exception 'AP Calculus AB difficulty batch 1: % versions already have difficulty rows', v_prior;
  end if;

  select count(*) into v_bad_subject
  from tmp_apcalcab_difficulty tmp
  where not exists (
    select 1
    from app.content_items ci
    join app.exam_pack_versions epv on epv.id = ci.exam_pack_version_id and epv.retired_at is null
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
      and ep.exam_code = 'ap_calculus_ab'
      and ci.status = 'published'
      and latest.status = 'published'
  );
  if v_bad_subject <> 0 then
    raise exception 'AP Calculus AB difficulty batch 1: % contaminated or non-current rows', v_bad_subject;
  end if;
end $$;

insert into app.content_item_difficulty (
  content_item_version_id, difficulty, basis, attainment_ratio,
  ratio_source, subject_cut_points, source_value, rationale, confidence, proposal_run
)
select
  content_item_version_id, difficulty, basis, null,
  null, subject_cut_points, null, rationale, 'medium', 'apcalcab_tier3_difficulty_2026_09_25'
from tmp_apcalcab_difficulty;

commit;
