-- FF-3 remainder, DECISION-0066: apply the 2 unambiguous tag-only corrections
-- from Codex's unit-tag-distractor-repair work order
-- (docs/research/unit_tag_distractor_repair_2026_09_24/proposal.jsonl).
--
-- Scope: apchem-mcq-048 and apchem-frq-l-004 only. Both are published, have
-- exactly one current (non-superseded) app.content_taxonomy_labels row, and
-- Codex's own reasoning holds up on inspection (the dropped units are
-- distractor-adjacent vocabulary, not load-bearing for selecting/rejecting
-- choices).
--
-- Deliberately NOT applied here: APBIO-MCQ-012 and APBIO-MCQ-041. Both are
-- `retired` (not currently servable, so this doesn't touch anything a student
-- can reach), and both currently carry TWO non-superseded
-- content_taxonomy_labels rows each (a label_version 1 'legacy_unvalidated'
-- row with empty required_units, and a label_version 2 'provisional_model'
-- row with the disputed units) -- a data-quality ambiguity the proposal
-- itself flagged ("QA/apply should first decide whether a retired item
-- should receive a label correction"). Not resolving that ambiguity here;
-- flagged separately rather than guessed at. APBIO-MCQ-041 also needs a
-- distractor content edit (mcq_choices), held for the same reason.
--
-- Pattern: insert a new label_version (this table is append-only history,
-- per its label_version/superseded_by columns), mark the prior version
-- superseded_by the new row's id. required_units_by_criterion is left
-- unchanged for apchem-frq-l-004 -- Codex's proposal only revises the
-- item-level required_units/max_required_unit ("load-bearing" set), not the
-- per-criterion breakdown, and revising that wasn't proposed or reviewed.
--
-- Rollback: set superseded_by back to null on the version-3 rows and delete
-- the version-4 rows inserted here.

begin;

-- apchem-mcq-048: [5,6,7] -> [5]. Distractors C/D reference equilibrium (7)
-- and delta-H (6) vocabulary, but rejecting them only requires knowing a
-- catalyst changes neither -- Unit 5 catalysis/kinetics content alone.
with new_label as (
  insert into app.content_taxonomy_labels (
    content_item_id, label_version, label_scope, validated_against_version_id,
    required_units, max_required_unit, assessed_topics, primary_unit,
    required_units_by_criterion, taxonomy_source_version, taxonomy_confidence,
    label_status, source, source_payload, model_run_id, input_packet_hash
  )
  select
    content_item_id, label_version + 1, label_scope, validated_against_version_id,
    array[5], 5, assessed_topics, primary_unit,
    required_units_by_criterion, taxonomy_source_version, taxonomy_confidence,
    label_status, 'claude_unit_tag_distractor_repair_2026_09_24',
    jsonb_build_object(
      'corrected_from', required_units,
      'reason', 'Distractors C (equilibrium, Unit 7) and D (delta-H, Unit 6) are refuted by the catalyst/activation-energy mechanism alone (Unit 5); their extra unit vocabulary is not load-bearing for selecting the keyed answer.',
      'prior_label_id', content_taxonomy_label_id,
      'work_order', 'CODEX_WORK_ORDER_UNIT_TAG_DISTRACTOR_REPAIR_2026_09_24'
    ),
    model_run_id, input_packet_hash
  from app.content_taxonomy_labels
  where content_item_id = '6fc7e1c5-8d24-4276-8c37-b3145d3a3d6d' and superseded_by is null
  returning content_taxonomy_label_id, content_item_id
)
update app.content_taxonomy_labels t
set superseded_by = n.content_taxonomy_label_id
from new_label n
where t.content_item_id = n.content_item_id
  and t.superseded_by is null
  and t.content_taxonomy_label_id <> n.content_taxonomy_label_id;

-- apchem-frq-l-004: [1,3,4] -> [1,4]. Unit 3 (solutions/mixtures) is touched
-- only incidentally (molarity-from-volume, filtration) inside criteria whose
-- credited content is really Unit 1 (mass/moles) or Unit 4 (stoichiometry,
-- net ionic precipitation); the item's construct doesn't require reasoning
-- about solution IMFs, mixture properties, or concentration in a load-bearing
-- way.
with new_label as (
  insert into app.content_taxonomy_labels (
    content_item_id, label_version, label_scope, validated_against_version_id,
    required_units, max_required_unit, assessed_topics, primary_unit,
    required_units_by_criterion, taxonomy_source_version, taxonomy_confidence,
    label_status, source, source_payload, model_run_id, input_packet_hash
  )
  select
    content_item_id, label_version + 1, label_scope, validated_against_version_id,
    array[1,4], 4, assessed_topics, primary_unit,
    required_units_by_criterion, taxonomy_source_version, taxonomy_confidence,
    label_status, 'claude_unit_tag_distractor_repair_2026_09_24',
    jsonb_build_object(
      'corrected_from', required_units,
      'reason', 'Unit 3 (solutions/mixtures) is incidental -- molarity-from-volume and filtration are touched but not load-bearing; the item''s construct is Unit 1 mass/mole foundations plus Unit 4 stoichiometry/net-ionic precipitation. Adding a Unit 3 criterion would change what the item tests, which is out of scope for a tag correction.',
      'prior_label_id', content_taxonomy_label_id,
      'work_order', 'CODEX_WORK_ORDER_UNIT_TAG_DISTRACTOR_REPAIR_2026_09_24'
    ),
    model_run_id, input_packet_hash
  from app.content_taxonomy_labels
  where content_item_id = 'f332abf4-7f85-4acb-b31e-260e774711d4' and superseded_by is null
  returning content_taxonomy_label_id, content_item_id
)
update app.content_taxonomy_labels t
set superseded_by = n.content_taxonomy_label_id
from new_label n
where t.content_item_id = n.content_item_id
  and t.superseded_by is null
  and t.content_taxonomy_label_id <> n.content_taxonomy_label_id;

-- Verification: exactly one current (non-superseded) row per item, with the
-- corrected units.
do $$
declare
  v_units int[];
  v_max int;
  v_current_count int;
begin
  select count(*) into v_current_count from app.content_taxonomy_labels
    where content_item_id = '6fc7e1c5-8d24-4276-8c37-b3145d3a3d6d' and superseded_by is null;
  if v_current_count <> 1 then
    raise exception 'apchem-mcq-048: expected exactly 1 current label row, got %', v_current_count;
  end if;
  select required_units, max_required_unit into v_units, v_max from app.content_taxonomy_labels
    where content_item_id = '6fc7e1c5-8d24-4276-8c37-b3145d3a3d6d' and superseded_by is null;
  if v_units <> array[5] or v_max <> 5 then
    raise exception 'apchem-mcq-048: expected required_units=[5] max=5, got % / %', v_units, v_max;
  end if;

  select count(*) into v_current_count from app.content_taxonomy_labels
    where content_item_id = 'f332abf4-7f85-4acb-b31e-260e774711d4' and superseded_by is null;
  if v_current_count <> 1 then
    raise exception 'apchem-frq-l-004: expected exactly 1 current label row, got %', v_current_count;
  end if;
  select required_units, max_required_unit into v_units, v_max from app.content_taxonomy_labels
    where content_item_id = 'f332abf4-7f85-4acb-b31e-260e774711d4' and superseded_by is null;
  if v_units <> array[1,4] or v_max <> 4 then
    raise exception 'apchem-frq-l-004: expected required_units=[1,4] max=4, got % / %', v_units, v_max;
  end if;
end $$;

commit;
