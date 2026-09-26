-- AP Calculus AB Tier 3 difficulty, batch 2/4.
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
  ('apcalcab-frq-036', 'cbee2cad-7e2c-4a80-a4a7-7328310a04f6'::uuid, 'Medium', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"frq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Modal criterion cue tier with upward tie-break: Easy=0, Medium=5, Hard=0; uncued=4.'),
  ('apcalcab-frq-np2-001', '8d5ec26d-648b-41a1-bfc3-e9bd7fb879f4'::uuid, 'Medium', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"frq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Modal criterion cue tier with upward tie-break: Easy=0, Medium=3, Hard=0; uncued=0.'),
  ('apcalcab-frq-np2-002', '2be7e655-9c90-42d4-ac84-59146fd84599'::uuid, 'Medium', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"frq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Modal criterion cue tier with upward tie-break: Easy=1, Medium=4, Hard=0; uncued=0.'),
  ('apcalcab-frq-np2-003', '095a5088-1d13-463a-a8d5-73726adc81e2'::uuid, 'Medium', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"frq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Modal criterion cue tier with upward tie-break: Easy=1, Medium=3, Hard=1; uncued=0.'),
  ('apcalcab-frq-np2-004', '2aa9f09d-7d8f-446a-a687-1ed543858db7'::uuid, 'Hard', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"frq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Modal criterion cue tier with upward tie-break: Easy=0, Medium=1, Hard=3; uncued=0.'),
  ('apcalcab-frq-np2-005', 'c9bbae66-e509-49d4-8ca1-e029c41d2668'::uuid, 'Medium', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"frq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Modal criterion cue tier with upward tie-break: Easy=0, Medium=5, Hard=1; uncued=0.'),
  ('apcalcab-frq-np2-006', 'dc1f2f7d-12ce-4735-be3d-c3fa85c802cd'::uuid, 'Medium', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"frq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Modal criterion cue tier with upward tie-break: Easy=0, Medium=3, Hard=0; uncued=0.'),
  ('apcalcab-frq-np2-007', 'e2434089-78b6-4091-8553-4664beef7549'::uuid, 'Medium', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"frq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Modal criterion cue tier with upward tie-break: Easy=0, Medium=3, Hard=0; uncued=0.'),
  ('apcalcab-frq-np2-008', '72973fb2-f772-4729-b9cb-e21d6ba8650d'::uuid, 'Medium', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"frq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Modal criterion cue tier with upward tie-break: Easy=1, Medium=3, Hard=0; uncued=0.'),
  ('apcalcab-frq-np2-009', '9803edbb-ed8a-439e-b71f-c29204dcf34c'::uuid, 'Medium', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"frq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Modal criterion cue tier with upward tie-break: Easy=0, Medium=4, Hard=0; uncued=0.'),
  ('apcalcab-frq-np2-010', 'ba1c6bef-a2ad-4f5b-97fc-a34a123d0e74'::uuid, 'Medium', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"frq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Modal criterion cue tier with upward tie-break: Easy=0, Medium=4, Hard=0; uncued=0.'),
  ('apcalcab-frq-u13-001', '829f41f5-2804-4231-a111-9edb31cda154'::uuid, 'Easy', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"frq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Modal criterion cue tier with upward tie-break: Easy=6, Medium=1, Hard=1; uncued=1.'),
  ('apcalcab-frq-u13-002', 'd0f2974c-bac9-498d-8173-8a1c88b3d8eb'::uuid, 'Hard', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"frq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Modal criterion cue tier with upward tie-break: Easy=2, Medium=1, Hard=2; uncued=4.'),
  ('apcalcab-frq-u13-003', '594f8bc1-35a0-4a04-ac7f-f3835f40f96d'::uuid, 'Medium', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"frq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Modal criterion cue tier with upward tie-break: Easy=1, Medium=7, Hard=0; uncued=1.'),
  ('apcalcab-frq-u13-004', 'f786dc8a-a3c4-497f-a271-24a2da334fcd'::uuid, 'Easy', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"frq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Modal criterion cue tier with upward tie-break: Easy=4, Medium=1, Hard=0; uncued=4.'),
  ('apcalcab-frq-u13-005', '66c7e7de-16e7-4d06-a7ac-25e80a6d8f22'::uuid, 'Medium', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"frq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Modal criterion cue tier with upward tie-break: Easy=3, Medium=3, Hard=2; uncued=1.'),
  ('apcalcab-frq-u13-006', '2f5e9638-893a-42bc-8b31-8b316a216968'::uuid, 'Medium', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"frq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Modal criterion cue tier with upward tie-break: Easy=1, Medium=8, Hard=0; uncued=0.'),
  ('apcalcab-frq-u13-007', '7a8363c6-f70b-43a7-ae03-3f9943157edc'::uuid, 'Medium', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"frq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Modal criterion cue tier with upward tie-break: Easy=1, Medium=7, Hard=0; uncued=1.'),
  ('apcalcab-frq-u13-008', 'fd460169-7f26-45b2-a7d7-e96a174f5d5d'::uuid, 'Medium', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"frq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Modal criterion cue tier with upward tie-break: Easy=1, Medium=6, Hard=0; uncued=2.'),
  ('apcalcab-frq-u13-009', '92b7fc1f-e3df-4f44-a251-540fee43da11'::uuid, 'Medium', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"frq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Modal criterion cue tier with upward tie-break: Easy=2, Medium=6, Hard=1; uncued=0.'),
  ('apcalcab-frq-u13-010', 'daf9d061-631a-4f52-a59d-92d39431e448'::uuid, 'Medium', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"frq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Modal criterion cue tier with upward tie-break: Easy=3, Medium=4, Hard=0; uncued=2.'),
  ('apcalcab-frq-u13-011', 'a10d5a79-0d50-4945-adb0-b4942902ac34'::uuid, 'Hard', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"frq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Modal criterion cue tier with upward tie-break: Easy=1, Medium=2, Hard=4; uncued=2.'),
  ('apcalcab-frq-u13-012', '87949000-95db-4cf3-a1eb-c14767be7728'::uuid, 'Medium', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"frq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Modal criterion cue tier with upward tie-break: Easy=2, Medium=4, Hard=2; uncued=1.'),
  ('apcalcab-frq-u13-013', '3befbb63-72fe-45f2-a2d9-8fa58c57300f'::uuid, 'Medium', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"frq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Modal criterion cue tier with upward tie-break: Easy=0, Medium=8, Hard=0; uncued=1.'),
  ('apcalcab-frq-u13-014', '3b86e94b-3723-498c-a653-2952a034223c'::uuid, 'Medium', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"frq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Modal criterion cue tier with upward tie-break: Easy=3, Medium=5, Hard=1; uncued=0.'),
  ('apcalcab-frq-u13-015', 'b00b9a52-ad49-4f07-a7a6-4911a180f91a'::uuid, 'Medium', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"frq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Modal criterion cue tier with upward tie-break: Easy=1, Medium=3, Hard=0; uncued=5.'),
  ('apcalcab-frq-u13-016', '798d58ab-6661-4293-a380-7ca6a7245909'::uuid, 'Medium', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"frq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Modal criterion cue tier with upward tie-break: Easy=3, Medium=6, Hard=0; uncued=0.'),
  ('apcalcab-frq-u13-017', 'bb06d698-561d-40bc-a57f-f4181365b134'::uuid, 'Medium', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"frq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Modal criterion cue tier with upward tie-break: Easy=2, Medium=3, Hard=1; uncued=3.'),
  ('apcalcab-frq-u13-018', 'c794879c-9f93-41bb-883c-d0688834fb30'::uuid, 'Medium', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"frq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Modal criterion cue tier with upward tie-break: Easy=2, Medium=5, Hard=0; uncued=2.'),
  ('apcalcab-frq-u13-019', '529f709a-1910-4ffd-a628-d864a9a53d43'::uuid, 'Medium', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"frq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Modal criterion cue tier with upward tie-break: Easy=2, Medium=4, Hard=0; uncued=3.'),
  ('apcalcab-frq-u13-020', 'bc2104db-65a3-4a64-a42d-1e7997a70d61'::uuid, 'Medium', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"frq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Modal criterion cue tier with upward tie-break: Easy=2, Medium=5, Hard=2; uncued=0.');

do $$
declare
  v_expected int := 31;
  v_rows int;
  v_prior int;
  v_bad_subject int;
begin
  select count(*) into v_rows from tmp_apcalcab_difficulty;
  if v_rows <> v_expected then
    raise exception 'AP Calculus AB difficulty batch 2: expected % rows, found %', v_expected, v_rows;
  end if;

  select count(*) into v_prior
  from tmp_apcalcab_difficulty tmp
  join app.content_item_difficulty cid on cid.content_item_version_id = tmp.content_item_version_id;
  if v_prior <> 0 then
    raise exception 'AP Calculus AB difficulty batch 2: % versions already have difficulty rows', v_prior;
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
    raise exception 'AP Calculus AB difficulty batch 2: % contaminated or non-current rows', v_bad_subject;
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
