-- AP Calculus AB Tier 3 difficulty, batch 3/4.
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
  ('apcalcab-mcq-001', '3201bedb-99aa-4e0d-b70c-d11470058cb6'::uuid, 'Medium', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"mcq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Standard single-concept Calculus operation in MCQ stem.'),
  ('apcalcab-mcq-003', 'e9090ec6-1e53-4668-b291-caaccc634d68'::uuid, 'Easy', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"mcq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Direct theorem/definition/read-off cue in MCQ stem.'),
  ('apcalcab-mcq-005', '4dc6dab4-5c31-4f2f-a15b-8f4ad27d5390'::uuid, 'Medium', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"mcq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Standard single-concept Calculus operation in MCQ stem.'),
  ('apcalcab-mcq-006', '4ea8c5e4-ef15-4b62-b8d0-a84e8477703e'::uuid, 'Medium', 'calibrated_judgement', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"judgement","item_type":"mcq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'No decisive cue; standard one-concept MCQ judged Medium.'),
  ('apcalcab-mcq-007', 'e1049e19-3c23-4498-b3dd-18346a7f19d3'::uuid, 'Medium', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"mcq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Standard single-concept Calculus operation in MCQ stem.'),
  ('apcalcab-mcq-008', '70669a81-a50b-4ea6-b4a8-d36b91a7550f'::uuid, 'Medium', 'calibrated_judgement', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"judgement","item_type":"mcq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'No decisive cue; standard one-concept MCQ judged Medium.'),
  ('apcalcab-mcq-009', 'c4ad7dd6-4c70-4962-a033-50bacebfaa23'::uuid, 'Medium', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"mcq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Standard single-concept Calculus operation in MCQ stem.'),
  ('apcalcab-mcq-010', '3c21b13a-6d99-4ce1-8110-67fdd5541ff3'::uuid, 'Medium', 'calibrated_judgement', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"judgement","item_type":"mcq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'No decisive cue; standard one-concept MCQ judged Medium.'),
  ('apcalcab-mcq-011', '597c4a89-98a5-494e-aa20-5ae679deceb9'::uuid, 'Medium', 'calibrated_judgement', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"judgement","item_type":"mcq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'No decisive cue; standard one-concept MCQ judged Medium.'),
  ('apcalcab-mcq-012', '4a7184b9-65a5-4b75-945c-834f9031d048'::uuid, 'Medium', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"mcq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Standard single-concept Calculus operation in MCQ stem.'),
  ('apcalcab-mcq-013', '10a43e2e-a36e-4aa0-abeb-edd19ebd23c5'::uuid, 'Medium', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"mcq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Standard single-concept Calculus operation in MCQ stem.'),
  ('apcalcab-mcq-014', '6468e218-bfc5-4855-805c-41f8c944db77'::uuid, 'Medium', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"mcq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Standard single-concept Calculus operation in MCQ stem.'),
  ('apcalcab-mcq-015', 'a205589c-3f8a-4bbd-b74a-c8844a517d28'::uuid, 'Medium', 'calibrated_judgement', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"judgement","item_type":"mcq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'No decisive cue; standard one-concept MCQ judged Medium.'),
  ('apcalcab-mcq-016', '577d9167-8648-4c6e-b1b9-ca327dd98c76'::uuid, 'Medium', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"mcq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Standard single-concept Calculus operation in MCQ stem.'),
  ('apcalcab-mcq-017', '63dcdc45-6ca7-4a95-a8a9-dfcab413c804'::uuid, 'Medium', 'calibrated_judgement', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"judgement","item_type":"mcq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'No decisive cue; standard one-concept MCQ judged Medium.'),
  ('apcalcab-mcq-018', '07870933-7bd9-44c3-81ab-86203c233021'::uuid, 'Medium', 'calibrated_judgement', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"judgement","item_type":"mcq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'No decisive cue; standard one-concept MCQ judged Medium.'),
  ('apcalcab-mcq-019', '715de584-b80d-419a-bb50-bbb52f7b47db'::uuid, 'Medium', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"mcq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Standard single-concept Calculus operation in MCQ stem.'),
  ('apcalcab-mcq-020', 'f38d76b2-9b8c-4c6f-9935-8059eb33124a'::uuid, 'Medium', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"mcq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Standard single-concept Calculus operation in MCQ stem.'),
  ('apcalcab-mcq-021', 'd5ce86ce-69e0-4e02-80d6-12b2e47cfb19'::uuid, 'Medium', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"mcq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Standard single-concept Calculus operation in MCQ stem.'),
  ('apcalcab-mcq-022', 'f187cb9b-ad82-4c0a-bf31-1fe9bc88b111'::uuid, 'Medium', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"mcq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Standard single-concept Calculus operation in MCQ stem.'),
  ('apcalcab-mcq-023', '84b735fd-c0c5-43e9-a061-3c1d49d6faa6'::uuid, 'Easy', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"mcq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Direct theorem/definition/read-off cue in MCQ stem.'),
  ('apcalcab-mcq-024', '83a5e4bd-4243-45ae-99f3-4dc2b20277d6'::uuid, 'Medium', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"mcq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Standard single-concept Calculus operation in MCQ stem.'),
  ('apcalcab-mcq-025', '282b516f-24df-4efd-a6b4-4bd707b27ade'::uuid, 'Medium', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"mcq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Standard single-concept Calculus operation in MCQ stem.'),
  ('apcalcab-mcq-026', '669ae7ce-d0bb-4605-8672-3d5edcc82ae0'::uuid, 'Medium', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"mcq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Standard single-concept Calculus operation in MCQ stem.'),
  ('apcalcab-mcq-027', '46c685fa-6f73-4fec-8e6a-65f76f20688b'::uuid, 'Medium', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"mcq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Standard single-concept Calculus operation in MCQ stem.'),
  ('apcalcab-mcq-028', '4f821f8a-e0d2-4335-a0f9-d7f0f45eab31'::uuid, 'Easy', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"mcq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Direct theorem/definition/read-off cue in MCQ stem.'),
  ('apcalcab-mcq-029', 'd78139a9-7f07-47dd-a1d7-2b74588b00f4'::uuid, 'Medium', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"mcq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Standard single-concept Calculus operation in MCQ stem.'),
  ('apcalcab-mcq-030', '562a99ea-e222-44cf-be4e-3d4092773ad7'::uuid, 'Medium', 'calibrated_judgement', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"judgement","item_type":"mcq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'No decisive cue; standard one-concept MCQ judged Medium.'),
  ('apcalcab-mcq-031', '070f547b-efbe-4984-9319-43489d9ec9ed'::uuid, 'Medium', 'calibrated_judgement', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"judgement","item_type":"mcq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'No decisive cue; standard one-concept MCQ judged Medium.'),
  ('apcalcab-mcq-032', '1a14dfca-2526-4774-86f5-95384856fa6b'::uuid, 'Medium', 'calibrated_task_verb', '{"framework":"ap_calculus_ab_calculus_specific_task_cues","csv_basis":"calculus_regex_cue","item_type":"mcq","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/APCALCAB_DIFFICULTY_ASSIGNMENTS_2026_09_25.csv"}'::jsonb, 'Standard single-concept Calculus operation in MCQ stem.');

do $$
declare
  v_expected int := 30;
  v_rows int;
  v_prior int;
  v_bad_subject int;
begin
  select count(*) into v_rows from tmp_apcalcab_difficulty;
  if v_rows <> v_expected then
    raise exception 'AP Calculus AB difficulty batch 3: expected % rows, found %', v_expected, v_rows;
  end if;

  select count(*) into v_prior
  from tmp_apcalcab_difficulty tmp
  join app.content_item_difficulty cid on cid.content_item_version_id = tmp.content_item_version_id;
  if v_prior <> 0 then
    raise exception 'AP Calculus AB difficulty batch 3: % versions already have difficulty rows', v_prior;
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
    raise exception 'AP Calculus AB difficulty batch 3: % contaminated or non-current rows', v_bad_subject;
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
