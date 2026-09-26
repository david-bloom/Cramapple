-- AP Chemistry Tier 3 difficulty load, batch 1/4.
-- Source: docs/research/apbio_difficulty_calibration_2026_09_22/apchem_difficulty_assignments.csv.
-- Proposal run: apchem_tier3_difficulty_2026_09_25. Batch rows: 30.

begin;

create temporary table tmp_apchem_difficulty (
  content_key text not null,
  difficulty text not null,
  basis text not null,
  subject_cut_points jsonb,
  source_value text,
  rationale text,
  confidence text
) on commit drop;

insert into tmp_apchem_difficulty (
  content_key, difficulty, basis, subject_cut_points, source_value, rationale, confidence
) values
  ('apchem-frq-l-002', 'Hard', 'calibrated_task_verb', '{"framework":"ap_chemistry_task_verb_and_structural_characteristics","csv_basis":"predict AND justify a directional change","item_type":"frq","authored_difficulty":"Easy","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/apchem_difficulty_assignments.csv"}'::jsonb, 'Easy', 'AP Chemistry difficulty framework assignment (FRQ): predict AND justify a directional change. Authored difficulty: Easy. Loaded as provisional tier-3 readiness data; no continuous attainment ratio is available for this item-level assignment.', 'medium'),
  ('apchem-frq-l-003', 'Hard', 'calibrated_task_verb', '{"framework":"ap_chemistry_task_verb_and_structural_characteristics","csv_basis":"predict AND justify a directional change","item_type":"frq","authored_difficulty":"Easy","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/apchem_difficulty_assignments.csv"}'::jsonb, 'Easy', 'AP Chemistry difficulty framework assignment (FRQ): predict AND justify a directional change. Authored difficulty: Easy. Loaded as provisional tier-3 readiness data; no continuous attainment ratio is available for this item-level assignment.', 'medium'),
  ('apchem-frq-l-004', 'Hard', 'calibrated_task_verb', '{"framework":"ap_chemistry_task_verb_and_structural_characteristics","csv_basis":"predict AND justify a directional change","item_type":"frq","authored_difficulty":"Easy","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/apchem_difficulty_assignments.csv"}'::jsonb, 'Easy', 'AP Chemistry difficulty framework assignment (FRQ): predict AND justify a directional change. Authored difficulty: Easy. Loaded as provisional tier-3 readiness data; no continuous attainment ratio is available for this item-level assignment.', 'medium'),
  ('apchem-frq-l-005', 'Medium', 'calibrated_task_verb', '{"framework":"ap_chemistry_task_verb_and_structural_characteristics","csv_basis":"explain/justify, single link","item_type":"frq","authored_difficulty":"Medium","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/apchem_difficulty_assignments.csv"}'::jsonb, 'Medium', 'AP Chemistry difficulty framework assignment (FRQ): explain/justify, single link. Authored difficulty: Medium. Loaded as provisional tier-3 readiness data; no continuous attainment ratio is available for this item-level assignment.', 'medium'),
  ('apchem-frq-l-006', 'Medium', 'calibrated_task_verb', '{"framework":"ap_chemistry_task_verb_and_structural_characteristics","csv_basis":"explain/justify, single link","item_type":"frq","authored_difficulty":"Medium","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/apchem_difficulty_assignments.csv"}'::jsonb, 'Medium', 'AP Chemistry difficulty framework assignment (FRQ): explain/justify, single link. Authored difficulty: Medium. Loaded as provisional tier-3 readiness data; no continuous attainment ratio is available for this item-level assignment.', 'medium'),
  ('apchem-frq-l-010', 'Medium', 'calibrated_task_verb', '{"framework":"ap_chemistry_task_verb_and_structural_characteristics","csv_basis":"explain/justify, single link","item_type":"frq","authored_difficulty":"Medium","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/apchem_difficulty_assignments.csv"}'::jsonb, 'Medium', 'AP Chemistry difficulty framework assignment (FRQ): explain/justify, single link. Authored difficulty: Medium. Loaded as provisional tier-3 readiness data; no continuous attainment ratio is available for this item-level assignment.', 'medium'),
  ('apchem-frq-l-011', 'Easy', 'calibrated_task_verb', '{"framework":"ap_chemistry_task_verb_and_structural_characteristics","csv_basis":"single-step algorithmic calculation","item_type":"frq","authored_difficulty":"Medium","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/apchem_difficulty_assignments.csv"}'::jsonb, 'Medium', 'AP Chemistry difficulty framework assignment (FRQ): single-step algorithmic calculation. Authored difficulty: Medium. Loaded as provisional tier-3 readiness data; no continuous attainment ratio is available for this item-level assignment.', 'medium'),
  ('apchem-frq-l-012', 'Easy', 'calibrated_task_verb', '{"framework":"ap_chemistry_task_verb_and_structural_characteristics","csv_basis":"single-step algorithmic calculation","item_type":"frq","authored_difficulty":"Medium","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/apchem_difficulty_assignments.csv"}'::jsonb, 'Medium', 'AP Chemistry difficulty framework assignment (FRQ): single-step algorithmic calculation. Authored difficulty: Medium. Loaded as provisional tier-3 readiness data; no continuous attainment ratio is available for this item-level assignment.', 'medium'),
  ('apchem-frq-l-013', 'Medium', 'calibrated_task_verb', '{"framework":"ap_chemistry_task_verb_and_structural_characteristics","csv_basis":"explain/justify linked to a shift or representation","item_type":"frq","authored_difficulty":"Medium","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/apchem_difficulty_assignments.csv"}'::jsonb, 'Medium', 'AP Chemistry difficulty framework assignment (FRQ): explain/justify linked to a shift or representation. Authored difficulty: Medium. Loaded as provisional tier-3 readiness data; no continuous attainment ratio is available for this item-level assignment.', 'medium'),
  ('apchem-frq-l-014', 'Easy', 'calibrated_task_verb', '{"framework":"ap_chemistry_task_verb_and_structural_characteristics","csv_basis":"single-step algorithmic calculation","item_type":"frq","authored_difficulty":"Medium","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/apchem_difficulty_assignments.csv"}'::jsonb, 'Medium', 'AP Chemistry difficulty framework assignment (FRQ): single-step algorithmic calculation. Authored difficulty: Medium. Loaded as provisional tier-3 readiness data; no continuous attainment ratio is available for this item-level assignment.', 'medium'),
  ('apchem-frq-l-016', 'Easy', 'calibrated_task_verb', '{"framework":"ap_chemistry_task_verb_and_structural_characteristics","csv_basis":"single-step algorithmic calculation","item_type":"frq","authored_difficulty":"Medium","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/apchem_difficulty_assignments.csv"}'::jsonb, 'Medium', 'AP Chemistry difficulty framework assignment (FRQ): single-step algorithmic calculation. Authored difficulty: Medium. Loaded as provisional tier-3 readiness data; no continuous attainment ratio is available for this item-level assignment.', 'medium'),
  ('apchem-frq-l-017', 'Medium', 'calibrated_task_verb', '{"framework":"ap_chemistry_task_verb_and_structural_characteristics","csv_basis":"predicts a shift without required justification","item_type":"frq","authored_difficulty":"Medium","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/apchem_difficulty_assignments.csv"}'::jsonb, 'Medium', 'AP Chemistry difficulty framework assignment (FRQ): predicts a shift without required justification. Authored difficulty: Medium. Loaded as provisional tier-3 readiness data; no continuous attainment ratio is available for this item-level assignment.', 'medium'),
  ('apchem-frq-l-020', 'Easy', 'calibrated_task_verb', '{"framework":"ap_chemistry_task_verb_and_structural_characteristics","csv_basis":"single-step algorithmic calculation","item_type":"frq","authored_difficulty":"Medium","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/apchem_difficulty_assignments.csv"}'::jsonb, 'Medium', 'AP Chemistry difficulty framework assignment (FRQ): single-step algorithmic calculation. Authored difficulty: Medium. Loaded as provisional tier-3 readiness data; no continuous attainment ratio is available for this item-level assignment.', 'medium'),
  ('apchem-frq-l-021', 'Medium', 'calibrated_task_verb', '{"framework":"ap_chemistry_task_verb_and_structural_characteristics","csv_basis":"C2 multi-step Hess-law manipulation","item_type":"frq","authored_difficulty":"Medium","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/apchem_difficulty_assignments.csv"}'::jsonb, 'Medium', 'AP Chemistry difficulty framework assignment (FRQ): C2 multi-step Hess-law manipulation. Authored difficulty: Medium. Loaded as provisional tier-3 readiness data; no continuous attainment ratio is available for this item-level assignment.', 'medium'),
  ('apchem-frq-l-022', 'Medium', 'calibrated_task_verb', '{"framework":"ap_chemistry_task_verb_and_structural_characteristics","csv_basis":"predicts a shift without required justification","item_type":"frq","authored_difficulty":"Medium","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/apchem_difficulty_assignments.csv"}'::jsonb, 'Medium', 'AP Chemistry difficulty framework assignment (FRQ): predicts a shift without required justification. Authored difficulty: Medium. Loaded as provisional tier-3 readiness data; no continuous attainment ratio is available for this item-level assignment.', 'medium'),
  ('apchem-frq-l-023', 'Hard', 'calibrated_task_verb', '{"framework":"ap_chemistry_task_verb_and_structural_characteristics","csv_basis":"predict AND justify a directional change","item_type":"frq","authored_difficulty":"Medium","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/apchem_difficulty_assignments.csv"}'::jsonb, 'Medium', 'AP Chemistry difficulty framework assignment (FRQ): predict AND justify a directional change. Authored difficulty: Medium. Loaded as provisional tier-3 readiness data; no continuous attainment ratio is available for this item-level assignment.', 'medium'),
  ('apchem-frq-l-024', 'Easy', 'calibrated_task_verb', '{"framework":"ap_chemistry_task_verb_and_structural_characteristics","csv_basis":"single-step algorithmic calculation","item_type":"frq","authored_difficulty":"Medium","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/apchem_difficulty_assignments.csv"}'::jsonb, 'Medium', 'AP Chemistry difficulty framework assignment (FRQ): single-step algorithmic calculation. Authored difficulty: Medium. Loaded as provisional tier-3 readiness data; no continuous attainment ratio is available for this item-level assignment.', 'medium'),
  ('apchem-frq-l-025', 'Easy', 'calibrated_task_verb', '{"framework":"ap_chemistry_task_verb_and_structural_characteristics","csv_basis":"single-step algorithmic calculation","item_type":"frq","authored_difficulty":"Medium","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/apchem_difficulty_assignments.csv"}'::jsonb, 'Medium', 'AP Chemistry difficulty framework assignment (FRQ): single-step algorithmic calculation. Authored difficulty: Medium. Loaded as provisional tier-3 readiness data; no continuous attainment ratio is available for this item-level assignment.', 'medium'),
  ('apchem-frq-l-026', 'Easy', 'calibrated_task_verb', '{"framework":"ap_chemistry_task_verb_and_structural_characteristics","csv_basis":"single-step algorithmic calculation","item_type":"frq","authored_difficulty":"Medium","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/apchem_difficulty_assignments.csv"}'::jsonb, 'Medium', 'AP Chemistry difficulty framework assignment (FRQ): single-step algorithmic calculation. Authored difficulty: Medium. Loaded as provisional tier-3 readiness data; no continuous attainment ratio is available for this item-level assignment.', 'medium'),
  ('apchem-frq-l-027', 'Medium', 'calibrated_task_verb', '{"framework":"ap_chemistry_task_verb_and_structural_characteristics","csv_basis":"explain/justify, single link","item_type":"frq","authored_difficulty":"Medium","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/apchem_difficulty_assignments.csv"}'::jsonb, 'Medium', 'AP Chemistry difficulty framework assignment (FRQ): explain/justify, single link. Authored difficulty: Medium. Loaded as provisional tier-3 readiness data; no continuous attainment ratio is available for this item-level assignment.', 'medium'),
  ('apchem-frq-l-028', 'Easy', 'calibrated_task_verb', '{"framework":"ap_chemistry_task_verb_and_structural_characteristics","csv_basis":"direct recall / identification","item_type":"frq","authored_difficulty":"Medium","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/apchem_difficulty_assignments.csv"}'::jsonb, 'Medium', 'AP Chemistry difficulty framework assignment (FRQ): direct recall / identification. Authored difficulty: Medium. Loaded as provisional tier-3 readiness data; no continuous attainment ratio is available for this item-level assignment.', 'medium'),
  ('apchem-sfrq-002', 'Medium', 'calibrated_task_verb', '{"framework":"ap_chemistry_task_verb_and_structural_characteristics","csv_basis":"explain/justify, single link","item_type":"frq","authored_difficulty":"Medium","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/apchem_difficulty_assignments.csv"}'::jsonb, 'Medium', 'AP Chemistry difficulty framework assignment (FRQ): explain/justify, single link. Authored difficulty: Medium. Loaded as provisional tier-3 readiness data; no continuous attainment ratio is available for this item-level assignment.', 'medium'),
  ('apchem-sfrq-003', 'Medium', 'calibrated_task_verb', '{"framework":"ap_chemistry_task_verb_and_structural_characteristics","csv_basis":"explain/justify, single link","item_type":"frq","authored_difficulty":"Medium","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/apchem_difficulty_assignments.csv"}'::jsonb, 'Medium', 'AP Chemistry difficulty framework assignment (FRQ): explain/justify, single link. Authored difficulty: Medium. Loaded as provisional tier-3 readiness data; no continuous attainment ratio is available for this item-level assignment.', 'medium'),
  ('apchem-sfrq-004', 'Medium', 'calibrated_task_verb', '{"framework":"ap_chemistry_task_verb_and_structural_characteristics","csv_basis":"explain/justify, single link","item_type":"frq","authored_difficulty":"Medium","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/apchem_difficulty_assignments.csv"}'::jsonb, 'Medium', 'AP Chemistry difficulty framework assignment (FRQ): explain/justify, single link. Authored difficulty: Medium. Loaded as provisional tier-3 readiness data; no continuous attainment ratio is available for this item-level assignment.', 'medium'),
  ('apchem-sfrq-005', 'Hard', 'calibrated_task_verb', '{"framework":"ap_chemistry_task_verb_and_structural_characteristics","csv_basis":"predict AND justify a directional change","item_type":"frq","authored_difficulty":"Hard","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/apchem_difficulty_assignments.csv"}'::jsonb, 'Hard', 'AP Chemistry difficulty framework assignment (FRQ): predict AND justify a directional change. Authored difficulty: Hard. Loaded as provisional tier-3 readiness data; no continuous attainment ratio is available for this item-level assignment.', 'medium'),
  ('apchem-sfrq-007', 'Medium', 'calibrated_task_verb', '{"framework":"ap_chemistry_task_verb_and_structural_characteristics","csv_basis":"explain/justify, single link","item_type":"frq","authored_difficulty":"Hard","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/apchem_difficulty_assignments.csv"}'::jsonb, 'Hard', 'AP Chemistry difficulty framework assignment (FRQ): explain/justify, single link. Authored difficulty: Hard. Loaded as provisional tier-3 readiness data; no continuous attainment ratio is available for this item-level assignment.', 'medium'),
  ('apchem-sfrq-008', 'Hard', 'calibrated_task_verb', '{"framework":"ap_chemistry_task_verb_and_structural_characteristics","csv_basis":"deviation/experimental-error/design evaluation","item_type":"frq","authored_difficulty":"Hard","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/apchem_difficulty_assignments.csv"}'::jsonb, 'Hard', 'AP Chemistry difficulty framework assignment (FRQ): deviation/experimental-error/design evaluation. Authored difficulty: Hard. Loaded as provisional tier-3 readiness data; no continuous attainment ratio is available for this item-level assignment.', 'medium'),
  ('apchem-sfrq-009', 'Medium', 'calibrated_task_verb', '{"framework":"ap_chemistry_task_verb_and_structural_characteristics","csv_basis":"explain/justify, single link","item_type":"frq","authored_difficulty":"Very Hard","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/apchem_difficulty_assignments.csv"}'::jsonb, 'Very Hard', 'AP Chemistry difficulty framework assignment (FRQ): explain/justify, single link. Authored difficulty: Very Hard. Loaded as provisional tier-3 readiness data; no continuous attainment ratio is available for this item-level assignment.', 'medium'),
  ('apchem-sfrq-010', 'Medium', 'calibrated_task_verb', '{"framework":"ap_chemistry_task_verb_and_structural_characteristics","csv_basis":"explain/justify, single link","item_type":"frq","authored_difficulty":"Very Hard","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/apchem_difficulty_assignments.csv"}'::jsonb, 'Very Hard', 'AP Chemistry difficulty framework assignment (FRQ): explain/justify, single link. Authored difficulty: Very Hard. Loaded as provisional tier-3 readiness data; no continuous attainment ratio is available for this item-level assignment.', 'medium'),
  ('apchem-sfrq-014', 'Medium', 'calibrated_task_verb', '{"framework":"ap_chemistry_task_verb_and_structural_characteristics","csv_basis":"explain/justify, single link","item_type":"frq","authored_difficulty":"Medium","source_file":"docs/research/apbio_difficulty_calibration_2026_09_22/apchem_difficulty_assignments.csv"}'::jsonb, 'Medium', 'AP Chemistry difficulty framework assignment (FRQ): explain/justify, single link. Authored difficulty: Medium. Loaded as provisional tier-3 readiness data; no continuous attainment ratio is available for this item-level assignment.', 'medium');

do $$
declare
  v_expected int := 30;
  v_rows int;
  v_bad_live int;
  v_prior int;
begin
  select count(*) into v_rows from tmp_apchem_difficulty;
  if v_rows <> v_expected then
    raise exception 'AP Chemistry difficulty batch 1: expected % rows, found %', v_expected, v_rows;
  end if;

  select count(*) into v_bad_live
  from tmp_apchem_difficulty tmp
  where not exists (
    select 1
    from app.content_items ci
    join app.exam_pack_versions epv on epv.id = ci.exam_pack_version_id
    join app.exam_packs ep on ep.id = epv.exam_pack_id
    join lateral (
      select civ.id, civ.status
      from app.content_item_versions civ
      where civ.content_item_id = ci.id
      order by civ.created_at desc, civ.id desc
      limit 1
    ) latest on true
    where ci.content_key = tmp.content_key
      and ep.exam_code = 'ap_chemistry'
      and epv.retired_at is null
      and ci.status = 'published'
      and latest.status = 'published'
  );
  if v_bad_live <> 0 then
    raise exception 'AP Chemistry difficulty batch 1: % rows do not belong to published live AP Chemistry content', v_bad_live;
  end if;

  select count(*) into v_prior
  from tmp_apchem_difficulty tmp
  join app.content_items ci on ci.content_key = tmp.content_key
  join lateral (
    select civ.id
    from app.content_item_versions civ
    where civ.content_item_id = ci.id
    order by civ.created_at desc, civ.id desc
    limit 1
  ) latest on true
  join app.content_item_difficulty cid on cid.content_item_version_id = latest.id;
  if v_prior <> 0 then
    raise exception 'AP Chemistry difficulty batch 1: % latest versions already have difficulty rows', v_prior;
  end if;
end $$;

insert into app.content_item_difficulty (
  content_item_version_id, difficulty, basis, attainment_ratio,
  ratio_source, subject_cut_points, source_value, rationale, confidence, proposal_run
)
select
  latest.id, tmp.difficulty, tmp.basis, null,
  null, tmp.subject_cut_points, tmp.source_value, tmp.rationale, tmp.confidence,
  'apchem_tier3_difficulty_2026_09_25'
from tmp_apchem_difficulty tmp
join app.content_items ci on ci.content_key = tmp.content_key
join lateral (
  select civ.id
  from app.content_item_versions civ
  where civ.content_item_id = ci.id
  order by civ.created_at desc, civ.id desc
  limit 1
) latest on true;

commit;
