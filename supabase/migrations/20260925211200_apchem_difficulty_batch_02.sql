-- AP Chemistry Tier 3 difficulty load, batch 2/4.
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
  ('apchem-sfrq-015', 'frq', 'Easy', 'single-step algorithmic calculation', 'Medium'),
  ('apchem-sfrq-016', 'frq', 'Medium', 'explain/justify, single link', 'Medium'),
  ('apchem-sfrq-018', 'frq', 'Medium', 'explain/justify, single link', 'Medium'),
  ('apchem-sfrq-019', 'frq', 'Medium', 'explain/justify linked to a shift or representation', 'Medium'),
  ('apchem-sfrq-021', 'frq', 'Easy', 'direct recall / identification', 'Medium'),
  ('apchem-sfrq-022', 'frq', 'Medium', 'explain/justify, single link', 'Medium'),
  ('apchem-sfrq-023', 'frq', 'Easy', 'direct recall / identification', 'Medium'),
  ('apchem-sfrq-024', 'frq', 'Medium', 'explain/justify, single link', 'Medium'),
  ('apchem-sfrq-026', 'frq', 'Medium', 'explain/justify, single link', 'Medium'),
  ('apchem-sfrq-027', 'frq', 'Medium', 'explain/justify, single link', 'Medium'),
  ('apchem-sfrq-028', 'frq', 'Easy', 'single-step algorithmic calculation', 'Medium'),
  ('apchem-sfrq-029', 'frq', 'Medium', 'explain/justify linked to a shift or representation', 'Medium'),
  ('apchem-sfrq-030', 'frq', 'Hard', 'predict AND justify a directional change', 'Medium'),
  ('apchem-sfrq-031', 'frq', 'Medium', 'explain/justify, single link', 'Medium'),
  ('apchem-sfrq-032', 'frq', 'Easy', 'single-step algorithmic calculation', 'Medium'),
  ('apchem-sfrq-033', 'frq', 'Easy', 'direct recall / identification', 'Medium'),
  ('apchem-sfrq-034', 'frq', 'Medium', 'explain/justify, single link', 'Medium'),
  ('apchem-sfrq-035', 'frq', 'Medium', 'explain/justify, single link', 'Medium'),
  ('apchem-sfrq-036', 'frq', 'Hard', 'predict AND justify a directional change', 'Medium'),
  ('apchem-sfrq-037', 'frq', 'Easy', 'single-step algorithmic calculation', 'Medium'),
  ('apchem-sfrq-038', 'frq', 'Easy', 'single-step algorithmic calculation', 'Medium'),
  ('apchem-mcq-001', 'mcq', 'Easy', 'C1 single-step algorithmic calculation', 'Easy'),
  ('apchem-mcq-003', 'mcq', 'Easy', 'C1 direct recall of a fundamental concept or trend', 'Easy'),
  ('apchem-mcq-004', 'mcq', 'Easy', 'C1 direct recall of a fundamental concept or trend', 'Easy'),
  ('apchem-mcq-005', 'mcq', 'Easy', 'C1 direct recall of a fundamental concept or trend', 'Easy'),
  ('apchem-mcq-006', 'mcq', 'Easy', 'C1 single-step Beer-Lambert proportional reasoning', 'Medium'),
  ('apchem-mcq-007', 'mcq', 'Easy', 'C1 direct recall of a solubility trend', 'Medium'),
  ('apchem-mcq-008', 'mcq', 'Easy', 'C1 single-step algorithmic calculation', 'Medium'),
  ('apchem-mcq-009', 'mcq', 'Easy', 'C1 single-step stoichiometry', 'Medium'),
  ('apchem-mcq-010', 'mcq', 'Easy', 'C1 direct identification', 'Medium');

do $$
declare
  v_expected int := 30;
  v_rows int;
  v_bad_live int;
  v_prior int;
begin
  select count(*) into v_rows from tmp_apchem_difficulty;
  if v_rows <> v_expected then raise exception 'AP Chemistry difficulty batch 2: expected % rows, found %', v_expected, v_rows; end if;

  select count(*) into v_bad_live
  from tmp_apchem_difficulty tmp
  where not exists (
    select 1 from app.content_items ci
    join app.exam_pack_versions epv on epv.id = ci.exam_pack_version_id
    join app.exam_packs ep on ep.id = epv.exam_pack_id
    join lateral (select civ.id, civ.status from app.content_item_versions civ where civ.content_item_id = ci.id order by civ.created_at desc, civ.id desc limit 1) latest on true
    where ci.content_key = tmp.content_key and ep.exam_code = 'ap_chemistry' and epv.retired_at is null and ci.status = 'published' and latest.status = 'published'
  );
  if v_bad_live <> 0 then raise exception 'AP Chemistry difficulty batch 2: % rows do not belong to published live AP Chemistry content', v_bad_live; end if;

  select count(*) into v_prior
  from tmp_apchem_difficulty tmp
  join app.content_items ci on ci.content_key = tmp.content_key
  join lateral (select civ.id from app.content_item_versions civ where civ.content_item_id = ci.id order by civ.created_at desc, civ.id desc limit 1) latest on true
  join app.content_item_difficulty cid on cid.content_item_version_id = latest.id;
  if v_prior <> 0 then raise exception 'AP Chemistry difficulty batch 2: % latest versions already have difficulty rows', v_prior; end if;
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
