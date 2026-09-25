-- FF-3 remainder: correct APBIO-MCQ-012's tag and APBIO-MCQ-041's tag +
-- distractor content, per Codex's unit-tag-distractor-repair proposal
-- (docs/research/unit_tag_distractor_repair_2026_09_24/proposal.jsonl).
--
-- Both items are `retired` (not currently servable) -- this has zero live
-- effect, done for record accuracy in case either is republished. The
-- "duplicate label row" concern from the prior pass was a misread: each item
-- has one coverage-scope legacy placeholder row (unrelated, empty) and one
-- serving-scope row (the actual tag) -- both correctly non-superseded since
-- superseded_by only chains within a scope's own lineage. Only the
-- serving-scope row is touched here.
--
-- APBIO-MCQ-012: tag-only, [1,3] -> [1]. Unit 3 (Cellular Energetics) is not
-- load-bearing; the keyed answer and its reasoning are pure Unit 1
-- (macromolecule structure / enzyme specificity).
--
-- APBIO-MCQ-041: tag [4,6] -> [4], plus a distractor rewrite. Preserves
-- correct choice B unchanged. Replaces A/C/D with cell-cycle-control
-- misconceptions that don't require Unit 6 gene-expression vocabulary to
-- reject, per Codex's "Unit 4 only" direction. Also updates A/C/D's
-- `rationale` to match the new choice_text -- Codex's proposal only specified
-- new choice_text, but the existing rationale explicitly discussed the OLD
-- wording (Rb, two-hit specifics) and would go stale otherwise.
--
-- Rollback: restore APBIO-MCQ-012 to required_units=[1,3] max=3 (new label
-- version; delete the version this migration inserts instead). Restore
-- APBIO-MCQ-041's label the same way, and restore mcq_choices A/C/D to the
-- text/rationale recorded below.
--
--   A (old): "Gene A is a tumor suppressor amplified to a gain-of-function oncogene; Gene B is a proto-oncogene with loss-of-function mutations in both alleles"
--     rationale: "Tumor suppressors lose function in cancer; amplification of a growth factor receptor gene is a gain-of-function change characteristic of a proto-oncogene converted to an oncogene. Gene B (Rb) is a classic tumor suppressor, not a proto-oncogene. Both classifications are reversed."
--   C (old): "Both are tumor suppressor genes; Gene A amplification indirectly reduces tumor suppressor activity by diluting suppressor protein, while Gene B mutations directly eliminate suppressor function"
--     rationale: "Gene A amplification produces excess growth factor receptor — a gain-of-function change in a proto-oncogene. It does not dilute tumor suppressors. Gene A is not a tumor suppressor. This choice misclassifies Gene A."
--   D (old): "Gene B requires only one allele to be mutated to cause cancer because Rb is haploinsufficient — one normal copy cannot maintain sufficient growth suppression"
--     rationale: "Rb is the prototypical example of a tumor suppressor following the two-hit hypothesis. One wild-type Rb allele is sufficient to suppress tumor development; both alleles must be inactivated. Haploinsufficiency is a property of some tumor suppressors but not Rb."

begin;

-- APBIO-MCQ-012 label correction
with new_label as (
  insert into app.content_taxonomy_labels (
    content_item_id, label_version, label_scope, validated_against_version_id,
    required_units, max_required_unit, assessed_topics, primary_unit,
    required_units_by_criterion, taxonomy_source_version, taxonomy_confidence,
    label_status, source, source_payload, model_run_id, input_packet_hash
  )
  select
    content_item_id, label_version + 1, label_scope, validated_against_version_id,
    array[1], 1, assessed_topics, primary_unit,
    required_units_by_criterion, taxonomy_source_version, taxonomy_confidence,
    label_status, 'claude_unit_tag_distractor_repair_2026_09_24',
    jsonb_build_object(
      'corrected_from', required_units,
      'reason', 'Unit 3 (Cellular Energetics) is not load-bearing; the keyed glycosidic-linkage answer and its reasoning are pure Unit 1 macromolecule structure / enzyme specificity.',
      'prior_label_id', content_taxonomy_label_id,
      'work_order', 'CODEX_WORK_ORDER_UNIT_TAG_DISTRACTOR_REPAIR_2026_09_24',
      'note', 'Item is retired; corrected for record accuracy, zero live effect.'
    ),
    model_run_id, input_packet_hash
  from app.content_taxonomy_labels
  where content_item_id = '0b389cb3-b3ec-4b98-b987-44f6edccf4d6'
    and label_scope = 'serving' and superseded_by is null
  returning content_taxonomy_label_id, content_item_id
)
update app.content_taxonomy_labels t
set superseded_by = n.content_taxonomy_label_id
from new_label n
where t.content_item_id = n.content_item_id
  and t.label_scope = 'serving'
  and t.superseded_by is null
  and t.content_taxonomy_label_id <> n.content_taxonomy_label_id;

-- APBIO-MCQ-041 label correction
with new_label as (
  insert into app.content_taxonomy_labels (
    content_item_id, label_version, label_scope, validated_against_version_id,
    required_units, max_required_unit, assessed_topics, primary_unit,
    required_units_by_criterion, taxonomy_source_version, taxonomy_confidence,
    label_status, source, source_payload, model_run_id, input_packet_hash
  )
  select
    content_item_id, label_version + 1, label_scope, validated_against_version_id,
    array[4], 4, assessed_topics, primary_unit,
    required_units_by_criterion, taxonomy_source_version, taxonomy_confidence,
    label_status, 'claude_unit_tag_distractor_repair_2026_09_24',
    jsonb_build_object(
      'corrected_from', required_units,
      'reason', 'Resolved by rewriting distractors A/C/D to plausible cell-cycle-control misconceptions that do not require Unit 6 gene-expression vocabulary to reject; the item now tests Unit 4 cell-cycle-control reasoning only. See mcq_choices for the paired content edit.',
      'prior_label_id', content_taxonomy_label_id,
      'work_order', 'CODEX_WORK_ORDER_UNIT_TAG_DISTRACTOR_REPAIR_2026_09_24',
      'note', 'Item is retired; corrected for record accuracy, zero live effect.'
    ),
    model_run_id, input_packet_hash
  from app.content_taxonomy_labels
  where content_item_id = '7e65ff98-fec9-4dc0-9c40-ca54bb24b97d'
    and label_scope = 'serving' and superseded_by is null
  returning content_taxonomy_label_id, content_item_id
)
update app.content_taxonomy_labels t
set superseded_by = n.content_taxonomy_label_id
from new_label n
where t.content_item_id = n.content_item_id
  and t.label_scope = 'serving'
  and t.superseded_by is null
  and t.content_taxonomy_label_id <> n.content_taxonomy_label_id;

-- APBIO-MCQ-041 distractor rewrite. B (correct) is untouched.
update app.mcq_choices
set choice_text = 'Gene A is a tumor suppressor whose increased copy number removes a cell-cycle brake; Gene B is a proto-oncogene that stops cell division when both alleles are disrupted.',
    rationale = 'This reverses both genes'' roles. Gene A''s amplification is a gain-of-function change in a proto-oncogene (an accelerator), not the loss of a tumor-suppressor brake. Gene B''s biallelic disruption is a tumor suppressor''s loss-of-function (removing a brake), not something that itself "stops division" -- a disrupted brake does the opposite of stopping the cycle.'
where content_item_version_id = '9935ee06-b328-4cb9-84cc-246389f7a22b' and choice_key = 'A'
  and choice_text = 'Gene A is a tumor suppressor amplified to a gain-of-function oncogene; Gene B is a proto-oncogene with loss-of-function mutations in both alleles';

update app.mcq_choices
set choice_text = 'Both genes are tumor suppressors: Gene A drives cancer because extra copies dilute checkpoint proteins, and Gene B drives cancer because one normal copy is always enough to stop division.',
    rationale = 'Gene A is a proto-oncogene, not a tumor suppressor, and "copy-number dilution" of checkpoint proteins is not a real mechanism this item tests. The claim about Gene B is also internally inconsistent: if one normal copy were "always enough to stop division," Gene B could not drive cancer at all, which contradicts the two-hit requirement that both alleles must be lost.'
where content_item_version_id = '9935ee06-b328-4cb9-84cc-246389f7a22b' and choice_key = 'C'
  and choice_text = 'Both are tumor suppressor genes; Gene A amplification indirectly reduces tumor suppressor activity by diluting suppressor protein, while Gene B mutations directly eliminate suppressor function';

update app.mcq_choices
set choice_text = 'Gene B requires only one altered allele to cause cancer because tumor suppressor genes normally act as accelerators of the cell cycle rather than brakes.',
    rationale = 'This reverses the brake/accelerator model: tumor suppressors normally act as brakes on the cell cycle, not accelerators. It also contradicts the two-hit requirement -- a tumor suppressor''s single wild-type allele normally still functions as a brake, so one altered allele alone is not sufficient.'
where content_item_version_id = '9935ee06-b328-4cb9-84cc-246389f7a22b' and choice_key = 'D'
  and choice_text = 'Gene B requires only one allele to be mutated to cause cancer because Rb is haploinsufficient — one normal copy cannot maintain sufficient growth suppression';

-- Verification
do $$
declare
  v_units int[];
  v_max int;
  v_a text; v_c text; v_d text; v_b_unchanged text;
begin
  select required_units, max_required_unit into v_units, v_max from app.content_taxonomy_labels
    where content_item_id = '0b389cb3-b3ec-4b98-b987-44f6edccf4d6' and label_scope='serving' and superseded_by is null;
  if v_units <> array[1] or v_max <> 1 then
    raise exception 'APBIO-MCQ-012: expected required_units=[1] max=1, got % / %', v_units, v_max;
  end if;

  select required_units, max_required_unit into v_units, v_max from app.content_taxonomy_labels
    where content_item_id = '7e65ff98-fec9-4dc0-9c40-ca54bb24b97d' and label_scope='serving' and superseded_by is null;
  if v_units <> array[4] or v_max <> 4 then
    raise exception 'APBIO-MCQ-041: expected required_units=[4] max=4, got % / %', v_units, v_max;
  end if;

  select choice_text into v_a from app.mcq_choices where content_item_version_id = '9935ee06-b328-4cb9-84cc-246389f7a22b' and choice_key='A';
  select choice_text into v_c from app.mcq_choices where content_item_version_id = '9935ee06-b328-4cb9-84cc-246389f7a22b' and choice_key='C';
  select choice_text into v_d from app.mcq_choices where content_item_version_id = '9935ee06-b328-4cb9-84cc-246389f7a22b' and choice_key='D';
  select choice_text into v_b_unchanged from app.mcq_choices where content_item_version_id = '9935ee06-b328-4cb9-84cc-246389f7a22b' and choice_key='B';

  if v_a not like 'Gene A is a tumor suppressor whose increased copy number%' then
    raise exception 'APBIO-MCQ-041 choice A did not update as expected';
  end if;
  if v_c not like 'Both genes are tumor suppressors%' then
    raise exception 'APBIO-MCQ-041 choice C did not update as expected';
  end if;
  if v_d not like 'Gene B requires only one altered allele%' then
    raise exception 'APBIO-MCQ-041 choice D did not update as expected';
  end if;
  if v_b_unchanged <> 'Gene A is a proto-oncogene converted to an oncogene by amplification (gain-of-function; a single overactive allele drives proliferation); Gene B is a tumor suppressor inactivated by biallelic loss-of-function (consistent with the two-hit hypothesis requiring both alleles to be lost)' then
    raise exception 'APBIO-MCQ-041 choice B (correct answer) was unexpectedly modified';
  end if;
end $$;

commit;
