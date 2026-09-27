-- AP Chemistry Tier 3 difficulty load, batch 3/4.
-- Source: docs/research/apbio_difficulty_calibration_2026_09_22/apchem_difficulty_assignments.csv.
-- Proposal run: apchem_tier3_difficulty_2026_09_25. Batch rows: 30.

begin;

create temporary table tmp_apchem_difficulty (
  content_key text not null,
  item_type text not null,
  difficulty text not null,
  csv_basis text not null,
  authored_difficulty text
) on commit drop;

insert into tmp_apchem_difficulty (content_key, item_type, difficulty, csv_basis, authored_difficulty) values
  ('apchem-mcq-011', 'mcq', 'Medium', 'C2 connects two distinct ideas, a shift, or a multi-step chain', 'Medium'),
  ('apchem-mcq-012', 'mcq', 'Medium', 'C2 connects two distinct ideas, a shift, or a multi-step chain', 'Medium'),
  ('apchem-mcq-013', 'mcq', 'Easy', 'C1 single-step algorithmic calculation', 'Medium'),
  ('apchem-mcq-014', 'mcq', 'Easy', 'C1 direct recall of a fundamental concept or trend', 'Hard'),
  ('apchem-mcq-015', 'mcq', 'Medium', 'C2 connects two distinct ideas, a shift, or a multi-step chain', 'Hard'),
  ('apchem-mcq-016', 'mcq', 'Hard', 'C3 synthesis / deviation / design evaluation', 'Hard'),
  ('apchem-mcq-017', 'mcq', 'Easy', 'C1 single-step log calculation', 'Hard'),
  ('apchem-mcq-018', 'mcq', 'Medium', 'C2 connects two distinct ideas, a shift, or a multi-step chain', 'Hard'),
  ('apchem-mcq-019', 'mcq', 'Easy', 'C1 direct recall of a fundamental concept or trend', 'Very Hard'),
  ('apchem-mcq-020', 'mcq', 'Medium', 'C2 connects two distinct ideas, a shift, or a multi-step chain', 'Very Hard'),
  ('apchem-mcq-021', 'mcq', 'Easy', 'C1 single-step algorithmic calculation', null),
  ('apchem-mcq-022', 'mcq', 'Easy', 'C1 direct recall of a fundamental concept or trend', null),
  ('apchem-mcq-023', 'mcq', 'Medium', 'C2 connects two distinct ideas, a shift, or a multi-step chain', null),
  ('apchem-mcq-024', 'mcq', 'Hard', 'C3 synthesis / deviation / design evaluation', null),
  ('apchem-mcq-025', 'mcq', 'Easy', 'C1 direct recall of a fundamental concept or trend', null),
  ('apchem-mcq-026', 'mcq', 'Easy', 'C1 direct recall of a fundamental concept or trend', null),
  ('apchem-mcq-027', 'mcq', 'Easy', 'C1 direct recall of a fundamental concept or trend', null),
  ('apchem-mcq-028', 'mcq', 'Easy', 'C1 direct recall of a fundamental concept or trend', null),
  ('apchem-mcq-029', 'mcq', 'Easy', 'C1 direct recall of a fundamental concept or trend', null),
  ('apchem-mcq-030', 'mcq', 'Easy', 'C1 direct recall of a fundamental concept or trend', null),
  ('apchem-mcq-031', 'mcq', 'Easy', 'C1 direct recall of a fundamental concept or trend', null),
  ('apchem-mcq-032', 'mcq', 'Easy', 'C1 single-step algorithmic calculation', null),
  ('apchem-mcq-033', 'mcq', 'Medium', 'C2 connects two distinct ideas, a shift, or a multi-step chain', null),
  ('apchem-mcq-034', 'mcq', 'Hard', 'C3 synthesis / deviation / design evaluation', null),
  ('apchem-mcq-035', 'mcq', 'Medium', 'C2 connects two distinct ideas, a shift, or a multi-step chain', null),
  ('apchem-mcq-036', 'mcq', 'Easy', 'C1 single-step algorithmic calculation', null),
  ('apchem-mcq-037', 'mcq', 'Easy', 'C1 direct recall of a photon energy trend', null),
  ('apchem-mcq-038', 'mcq', 'Hard', 'C3 synthesis / deviation / design evaluation', null),
  ('apchem-mcq-039', 'mcq', 'Easy', 'C1 single-step algorithmic calculation', null),
  ('apchem-mcq-040', 'mcq', 'Easy', 'C1 single-step algorithmic calculation', null);

do $$
declare
  v_expected int := 30;
  v_rows int;
  v_bad_live int;
  v_prior int;
begin
  select count(*) into v_rows from tmp_apchem_difficulty;
  if v_rows <> v_expected then raise exception 'AP Chemistry difficulty batch 3: expected % rows, found %', v_expected, v_rows; end if;

  select count(*) into v_bad_live
  from tmp_apchem_difficulty tmp
  where not exists (
    select 1 from app.content_items ci
    join app.exam_pack_versions epv on epv.id = ci.exam_pack_version_id
    join app.exam_packs ep on ep.id = epv.exam_pack_id
    join lateral (select civ.id, civ.status from app.content_item_versions civ where civ.content_item_id = ci.id order by civ.created_at desc, civ.id desc limit 1) latest on true
    where ci.content_key = tmp.content_key and ep.exam_code = 'ap_chemistry' and epv.retired_at is null and ci.status = 'published' and latest.status = 'published'
  );
  if v_bad_live <> 0 then raise exception 'AP Chemistry difficulty batch 3: % rows do not belong to published live AP Chemistry content', v_bad_live; end if;

  select count(*) into v_prior
  from tmp_apchem_difficulty tmp
  join app.content_items ci on ci.content_key = tmp.content_key
  join lateral (select civ.id from app.content_item_versions civ where civ.content_item_id = ci.id order by civ.created_at desc, civ.id desc limit 1) latest on true
  join app.content_item_difficulty cid on cid.content_item_version_id = latest.id;
  if v_prior <> 0 then raise exception 'AP Chemistry difficulty batch 3: % latest versions already have difficulty rows', v_prior; end if;
end $$;

insert into app.content_item_difficulty (
  content_item_version_id, difficulty, basis, attainment_ratio, ratio_source,
  subject_cut_points, source_value, rationale, confidence, proposal_run
)
select
  latest.id, tmp.difficulty,
  case when tmp.item_type = 'frq' then 'calibrated_task_verb' else 'calibrated_judgement' end,
  null, null,
  jsonb_build_object(
    'framework', 'ap_chemistry_task_verb_and_structural_characteristics',
    'csv_basis', tmp.csv_basis,
    'item_type', tmp.item_type,
    'authored_difficulty', tmp.authored_difficulty,
    'source_file', 'docs/research/apbio_difficulty_calibration_2026_09_22/apchem_difficulty_assignments.csv'
  ),
  tmp.authored_difficulty,
  'AP Chemistry difficulty framework assignment (' || upper(tmp.item_type) || '): ' || tmp.csv_basis || '. Authored difficulty: ' || coalesce(tmp.authored_difficulty, 'none') || '. Loaded as provisional tier-3 readiness data; no continuous attainment ratio is available for this item-level assignment.',
  'medium',
  'apchem_tier3_difficulty_2026_09_25'
from tmp_apchem_difficulty tmp
join app.content_items ci on ci.content_key = tmp.content_key
join lateral (select civ.id from app.content_item_versions civ where civ.content_item_id = ci.id order by civ.created_at desc, civ.id desc limit 1) latest on true;

commit;
