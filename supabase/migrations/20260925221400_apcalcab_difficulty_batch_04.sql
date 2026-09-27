-- AP Calculus AB Tier 3 difficulty, batch 4/4.
-- Generated from APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv. Batch rows: 30.

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
  ('apcalcab-mcq-033', '46ed1137-6d05-41ee-ba4f-33c75138bbfe'::uuid, 'Medium', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"mcq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Standard single-concept Calculus operation in MCQ stem.'),
  ('apcalcab-mcq-034', 'a6963891-72c1-4665-912f-948599fcbfa4'::uuid, 'Medium', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"mcq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Standard single-concept Calculus operation in MCQ stem.'),
  ('apcalcab-mcq-035', '4cc3b370-f56b-47ca-a7cf-4e0b32a06595'::uuid, 'Medium', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"mcq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Standard single-concept Calculus operation in MCQ stem.'),
  ('apcalcab-mcq-036', 'cadbc0c7-61d6-4c34-87df-70fecd83e14c'::uuid, 'Medium', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"mcq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Standard single-concept Calculus operation in MCQ stem.'),
  ('apcalcab-mcq-037', '809ae281-c05f-4e7e-8582-15dabad909d0'::uuid, 'Medium', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"mcq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Standard single-concept Calculus operation in MCQ stem.'),
  ('apcalcab-mcq-038', 'a948f2bd-99d2-4b79-b1c1-ef6f1fe0e43a'::uuid, 'Medium', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"mcq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Standard single-concept Calculus operation in MCQ stem.'),
  ('apcalcab-mcq-039', '3d5aa0f8-6b75-4490-b338-4d83c9ba3f18'::uuid, 'Hard', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"mcq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Non-routine or multi-stage Calculus cue in MCQ stem.'),
  ('apcalcab-mcq-040', '172ee07f-0692-45f6-bcf0-413062e46d4d'::uuid, 'Medium', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"mcq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Standard single-concept Calculus operation in MCQ stem.'),
  ('apcalcab-mcq-041', '4785a80b-e6df-44f8-80b9-0a24c715da30'::uuid, 'Medium', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"mcq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Standard single-concept Calculus operation in MCQ stem.'),
  ('apcalcab-mcq-042', '8a70d356-3323-498f-bf1c-ed157a9c1d4a'::uuid, 'Easy', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"mcq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Direct theorem/definition/read-off cue in MCQ stem.'),
  ('apcalcab-mcq-043', '4513a5d9-2989-4839-9009-7cddd4eadfe1'::uuid, 'Medium', 'calibrated_judgement', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"judgement","item_type":"mcq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'No decisive cue; standard one-concept MCQ judged Medium.'),
  ('apcalcab-mcq-044', 'c8d4f7c2-7aec-4ffa-a03f-d301e5d36127'::uuid, 'Medium', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"mcq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Standard single-concept Calculus operation in MCQ stem.'),
  ('apcalcab-mcq-045', '94bf5ab0-4fc3-4b53-bac9-62ed9de33fe1'::uuid, 'Hard', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"mcq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Non-routine or multi-stage Calculus cue in MCQ stem.'),
  ('apcalcab-mcq-046', '6202f329-6245-4fef-ab40-0a7b8a14c525'::uuid, 'Hard', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"mcq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Non-routine or multi-stage Calculus cue in MCQ stem.'),
  ('apcalcab-mcq-047', 'f5374b3d-e3ff-44b7-91df-5a17e34fe98a'::uuid, 'Medium', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"mcq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Standard single-concept Calculus operation in MCQ stem.'),
  ('apcalcab-mcq-050', 'c431bc9c-5cfe-4059-96f8-98e8589d8410'::uuid, 'Hard', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"mcq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Non-routine or multi-stage Calculus cue in MCQ stem.'),
  ('apcalcab-mcq-060', 'f492bfbf-5434-434f-a4d8-50b058477139'::uuid, 'Easy', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"mcq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Direct theorem/definition/read-off cue in MCQ stem.'),
  ('apcalcab-mcq-070', '56b14ecb-0aef-40ad-8edf-8af6d1c966fc'::uuid, 'Easy', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"mcq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Direct theorem/definition/read-off cue in MCQ stem.'),
  ('apcalcab-mcq-080', '05cdd14c-f447-47d2-ad62-17c0eb25cc28'::uuid, 'Medium', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"mcq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Standard single-concept Calculus operation in MCQ stem.'),
  ('apcalcab-mcq-090', '8113b078-35ee-426c-8593-a37255f0367e'::uuid, 'Easy', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"mcq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Direct theorem/definition/read-off cue in MCQ stem.'),
  ('apcalcab-mcq-np2-001', '771dee16-a72e-4e4c-ae4b-853c1a9e4e37'::uuid, 'Medium', 'calibrated_judgement', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"judgement","item_type":"mcq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'No decisive cue; standard one-concept MCQ judged Medium.'),
  ('apcalcab-mcq-np2-002', '05bc02e0-3ca9-45f2-9643-e69eddd4161b'::uuid, 'Medium', 'calibrated_judgement', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"judgement","item_type":"mcq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'No decisive cue; standard one-concept MCQ judged Medium.'),
  ('apcalcab-mcq-np2-003', 'df73f375-1e54-4c0f-a847-137c1d14103c'::uuid, 'Hard', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"mcq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Non-routine or multi-stage Calculus cue in MCQ stem.'),
  ('apcalcab-mcq-np2-004', 'c56f7008-6b5f-4b7a-a5b1-1e885b68ad89'::uuid, 'Easy', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"mcq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Direct theorem/definition/read-off cue in MCQ stem.'),
  ('apcalcab-mcq-np2-005', '580c88e3-b631-48cf-8cd0-52a8a151a9ef'::uuid, 'Medium', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"mcq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Standard single-concept Calculus operation in MCQ stem.'),
  ('apcalcab-mcq-np2-006', 'a606fa68-dd58-44cc-8103-8928f6239452'::uuid, 'Medium', 'calibrated_judgement', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"judgement","item_type":"mcq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'No decisive cue; standard one-concept MCQ judged Medium.'),
  ('apcalcab-mcq-np2-007', '8d70b5e5-45f8-4a63-af0f-8f00b605e7dc'::uuid, 'Medium', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"mcq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Standard single-concept Calculus operation in MCQ stem.'),
  ('apcalcab-mcq-np2-008', 'b7da8007-1029-4fed-84f7-08354fb31397'::uuid, 'Medium', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"mcq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Standard single-concept Calculus operation in MCQ stem.'),
  ('apcalcab-mcq-np2-009', '9322a7ab-2a93-4b6f-8046-0ccaa6de3ba0'::uuid, 'Medium', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"mcq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Standard single-concept Calculus operation in MCQ stem.'),
  ('apcalcab-mcq-np2-010', '6a085ceb-28e4-4e9c-b330-1e64675c3e60'::uuid, 'Hard', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"mcq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Non-routine or multi-stage Calculus cue in MCQ stem.');

do $$
declare
  v_expected int := 30;
  v_rows int;
  v_prior int;
  v_bad_subject int;
begin
  select count(*) into v_rows from tmp_apcalcab_difficulty;
  if v_rows <> v_expected then
    raise exception 'AP Calculus AB difficulty batch 4: expected % rows, found %', v_expected, v_rows;
  end if;

  select count(*) into v_prior
  from tmp_apcalcab_difficulty tmp
  join app.content_item_difficulty cid on cid.content_item_version_id = tmp.content_item_version_id;
  if v_prior <> 0 then
    raise exception 'AP Calculus AB difficulty batch 4: % versions already have difficulty rows', v_prior;
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
    raise exception 'AP Calculus AB difficulty batch 4: % contaminated or non-current rows', v_bad_subject;
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
