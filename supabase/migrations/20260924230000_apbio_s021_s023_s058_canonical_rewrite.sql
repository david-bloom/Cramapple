-- FF-5, DECISION-0064: replace canonical_answer_1 for APBIO-FRQ-S-021,
-- S-023, S-058 and add segmentation, per Codex work order F.2
-- (docs/research/apbio_f2_s101_and_holdouts_2026_09_24/canonical_proposal.jsonl,
-- removal_log.csv). Held out of M1 (20260924170000) because M1's additive
-- guarantee requires the existing canonical_answer_1 to survive inside the
-- new text, and for these three items it does not: the stored answers do not
-- answer their own rubrics (recorded as A-QA-002 / the segmentation findings).
-- DECISION-0064 authorized replacement rather than assembly for these three.
--
-- Verified before writing (not just trusted from the proposal):
--   - each proposed full_text's spans concatenate to it exactly (Python check)
--   - each item's 4-criterion rubric is unchanged from what the proposal assumed
--   - stored canonical_answer_1/2 lengths match removal_log.csv exactly
--     (S-021 104/134, S-023 100/118, S-058 138/116)
--   - each proposed answer cleared app.qa_grade_frq 3 of 3 runs at 4/4, high
--     confidence, 0 integrity issues (all three items, all rubric-unchanged)
--
-- canonical_answer_2 is cleared (set null) for all three per the proposal's
-- canonical_answer_2_decision ('remove' for all three) -- each field's content
-- is either off-rubric/supplementary or (S-023's b2 clause specifically)
-- relocated verbatim into the new canonical_answer_1 as its own exclusive
-- span, not lost. See removal_log.csv for the full before-text accounting.
--
-- The update predicates include the current stored text so this becomes a
-- no-op (verification block raises) rather than a silent overwrite if
-- Production has drifted since the proposal was captured.
--
-- Rollback: restore each item's canonical_answer_1/2 to the removal_log.csv
-- values above, and delete from app.canonical_answer_spans where
-- proposal_run = 'work_order_F2_2026_09_24_holdouts'.

begin;

-- APBIO-FRQ-S-021 (1c8662ac-d06b-47e4-bfd3-714dae885aac)
update app.content_item_versions
set canonical_answer_1 = 'A peptide bond forms between the carboxyl group of one amino acid and the amino group of the adjacent amino acid.

Formation of this bond releases a water molecule in a dehydration-synthesis reaction.

A fatty acid contains a long, nonpolar hydrocarbon tail.

Because this nonpolar tail cannot form hydrogen bonds with water, the fatty acid is hydrophobic.',
    canonical_answer_2 = null
where id = '1c8662ac-d06b-47e4-bfd3-714dae885aac'
  and canonical_answer_1 = 'Amino acids link via peptide bonds to form proteins; the R-group determines the amino acid''s properties.'
  and canonical_answer_2 = 'Monosaccharides link via glycosidic bonds to form polysaccharides; fatty acids link to glycerol via ester bonds to form triglycerides.';

insert into app.canonical_answer_spans (
  content_item_version_id, answer_field, span_ordinal, span_text,
  criterion_keys, provenance, source_field, proposal_run
) values
  ('1c8662ac-d06b-47e4-bfd3-714dae885aac', 'canonical_answer_1', 0,
   'A peptide bond forms between the carboxyl group of one amino acid and the amino group of the adjacent amino acid.',
   array['a1'], 'drafted', null, 'work_order_F2_2026_09_24_holdouts'),
  ('1c8662ac-d06b-47e4-bfd3-714dae885aac', 'canonical_answer_1', 1,
   E'\n\n', array[]::text[], 'assembly_literal', null, 'work_order_F2_2026_09_24_holdouts'),
  ('1c8662ac-d06b-47e4-bfd3-714dae885aac', 'canonical_answer_1', 2,
   'Formation of this bond releases a water molecule in a dehydration-synthesis reaction.',
   array['a2'], 'drafted', null, 'work_order_F2_2026_09_24_holdouts'),
  ('1c8662ac-d06b-47e4-bfd3-714dae885aac', 'canonical_answer_1', 3,
   E'\n\n', array[]::text[], 'assembly_literal', null, 'work_order_F2_2026_09_24_holdouts'),
  ('1c8662ac-d06b-47e4-bfd3-714dae885aac', 'canonical_answer_1', 4,
   'A fatty acid contains a long, nonpolar hydrocarbon tail.',
   array['b1'], 'drafted', null, 'work_order_F2_2026_09_24_holdouts'),
  ('1c8662ac-d06b-47e4-bfd3-714dae885aac', 'canonical_answer_1', 5,
   E'\n\n', array[]::text[], 'assembly_literal', null, 'work_order_F2_2026_09_24_holdouts'),
  ('1c8662ac-d06b-47e4-bfd3-714dae885aac', 'canonical_answer_1', 6,
   'Because this nonpolar tail cannot form hydrogen bonds with water, the fatty acid is hydrophobic.',
   array['b2'], 'drafted', null, 'work_order_F2_2026_09_24_holdouts');

-- APBIO-FRQ-S-023 (89ba31c8-84ca-4f2c-be9c-01fb4ea8e76b)
-- b2's span is recovered verbatim from the old canonical_answer_2 (source_field set
-- accordingly), per removal_log.csv's relocate_to_canonical_answer_1 decision.
update app.content_item_versions
set canonical_answer_1 = 'At about pH 2, the acidic environment maintains the ionic and hydrogen bonds that give pepsin''s active site its functional shape.

That conformation allows the substrate to bind effectively, so pepsin functions optimally at pH 2.

Trypsin activity decreases greatly or stops at pH 2.

acidic conditions denature it by disrupting ionic and hydrogen bonds.',
    canonical_answer_2 = null
where id = '89ba31c8-84ca-4f2c-be9c-01fb4ea8e76b'
  and canonical_answer_1 = 'Pepsin is most active at low pH because its active site is shaped by acid conditions of the stomach.'
  and canonical_answer_2 = 'Trypsin is most active near neutral-to-basic pH; acidic conditions denature it by disrupting ionic and hydrogen bonds.';

insert into app.canonical_answer_spans (
  content_item_version_id, answer_field, span_ordinal, span_text,
  criterion_keys, provenance, source_field, source_offset, proposal_run
) values
  ('89ba31c8-84ca-4f2c-be9c-01fb4ea8e76b', 'canonical_answer_1', 0,
   'At about pH 2, the acidic environment maintains the ionic and hydrogen bonds that give pepsin''s active site its functional shape.',
   array['a1'], 'drafted', null, null, 'work_order_F2_2026_09_24_holdouts'),
  ('89ba31c8-84ca-4f2c-be9c-01fb4ea8e76b', 'canonical_answer_1', 1,
   E'\n\n', array[]::text[], 'assembly_literal', null, null, 'work_order_F2_2026_09_24_holdouts'),
  ('89ba31c8-84ca-4f2c-be9c-01fb4ea8e76b', 'canonical_answer_1', 2,
   'That conformation allows the substrate to bind effectively, so pepsin functions optimally at pH 2.',
   array['a2'], 'drafted', null, null, 'work_order_F2_2026_09_24_holdouts'),
  ('89ba31c8-84ca-4f2c-be9c-01fb4ea8e76b', 'canonical_answer_1', 3,
   E'\n\n', array[]::text[], 'assembly_literal', null, null, 'work_order_F2_2026_09_24_holdouts'),
  ('89ba31c8-84ca-4f2c-be9c-01fb4ea8e76b', 'canonical_answer_1', 4,
   'Trypsin activity decreases greatly or stops at pH 2.',
   array['b1'], 'drafted', null, null, 'work_order_F2_2026_09_24_holdouts'),
  ('89ba31c8-84ca-4f2c-be9c-01fb4ea8e76b', 'canonical_answer_1', 5,
   E'\n\n', array[]::text[], 'assembly_literal', null, null, 'work_order_F2_2026_09_24_holdouts'),
  ('89ba31c8-84ca-4f2c-be9c-01fb4ea8e76b', 'canonical_answer_1', 6,
   'acidic conditions denature it by disrupting ionic and hydrogen bonds.',
   array['b2'], 'recovered_ca2', 'canonical_answer_2', 49, 'work_order_F2_2026_09_24_holdouts');

-- APBIO-FRQ-S-058 (de993d8e-09a0-49d8-bb2b-6a15008f6182)
update app.content_item_versions
set canonical_answer_1 = 'A population bottleneck is a drastic reduction in population size that changes allele frequencies by chance.

Rare alleles may be lost entirely, while alleles common among the few survivors can become overrepresented.

With less genetic variation, individuals in the surviving population are more genetically similar to one another.

If a new disease or environmental change occurs, many individuals may share the same susceptibility, threatening the population''s survival.',
    canonical_answer_2 = null
where id = 'de993d8e-09a0-49d8-bb2b-6a15008f6182'
  and canonical_answer_1 = 'The bottleneck effect reduces genetic diversity: alleles present in the survivors become fixed or lost regardless of their adaptive value.'
  and canonical_answer_2 = 'Low genetic diversity after a bottleneck can reduce a population''s ability to adapt to new environmental challenges.';

insert into app.canonical_answer_spans (
  content_item_version_id, answer_field, span_ordinal, span_text,
  criterion_keys, provenance, source_field, proposal_run
) values
  ('de993d8e-09a0-49d8-bb2b-6a15008f6182', 'canonical_answer_1', 0,
   'A population bottleneck is a drastic reduction in population size that changes allele frequencies by chance.',
   array['a1'], 'drafted', null, 'work_order_F2_2026_09_24_holdouts'),
  ('de993d8e-09a0-49d8-bb2b-6a15008f6182', 'canonical_answer_1', 1,
   E'\n\n', array[]::text[], 'assembly_literal', null, 'work_order_F2_2026_09_24_holdouts'),
  ('de993d8e-09a0-49d8-bb2b-6a15008f6182', 'canonical_answer_1', 2,
   'Rare alleles may be lost entirely, while alleles common among the few survivors can become overrepresented.',
   array['a2'], 'drafted', null, 'work_order_F2_2026_09_24_holdouts'),
  ('de993d8e-09a0-49d8-bb2b-6a15008f6182', 'canonical_answer_1', 3,
   E'\n\n', array[]::text[], 'assembly_literal', null, 'work_order_F2_2026_09_24_holdouts'),
  ('de993d8e-09a0-49d8-bb2b-6a15008f6182', 'canonical_answer_1', 4,
   'With less genetic variation, individuals in the surviving population are more genetically similar to one another.',
   array['b1'], 'drafted', null, 'work_order_F2_2026_09_24_holdouts'),
  ('de993d8e-09a0-49d8-bb2b-6a15008f6182', 'canonical_answer_1', 5,
   E'\n\n', array[]::text[], 'assembly_literal', null, 'work_order_F2_2026_09_24_holdouts'),
  ('de993d8e-09a0-49d8-bb2b-6a15008f6182', 'canonical_answer_1', 6,
   'If a new disease or environmental change occurs, many individuals may share the same susceptibility, threatening the population''s survival.',
   array['b2'], 'drafted', null, 'work_order_F2_2026_09_24_holdouts');

-- Verification: for each of the three items, canonical_answer_1 is set, spans
-- reconstruct it exactly, canonical_answer_2 is null, and every criterion has
-- exactly one exclusive span.
do $$
declare
  v_id uuid;
  v_ids uuid[] := array[
    '1c8662ac-d06b-47e4-bfd3-714dae885aac',
    '89ba31c8-84ca-4f2c-be9c-01fb4ea8e76b',
    'de993d8e-09a0-49d8-bb2b-6a15008f6182'
  ];
  v_canonical text;
  v_canonical2 text;
  v_reconstructed text;
  v_missing_exclusive int;
begin
  foreach v_id in array v_ids loop
    select canonical_answer_1, canonical_answer_2 into v_canonical, v_canonical2
    from app.content_item_versions where id = v_id;

    if v_canonical is null then
      raise exception 'holdout %: canonical_answer_1 is still null -- update predicate did not match (Production may have drifted from removal_log.csv)', v_id;
    end if;
    if v_canonical2 is not null then
      raise exception 'holdout %: canonical_answer_2 was not cleared', v_id;
    end if;

    select string_agg(span_text, '' order by span_ordinal) into v_reconstructed
    from app.canonical_answer_spans
    where content_item_version_id = v_id and answer_field = 'canonical_answer_1';

    if v_reconstructed is distinct from v_canonical then
      raise exception 'holdout %: spans do not reconstruct canonical_answer_1', v_id;
    end if;

    select count(*) into v_missing_exclusive
    from app.frq_criteria fc
    where fc.content_item_version_id = v_id
      and not exists (
        select 1 from app.canonical_answer_spans sp
        where sp.content_item_version_id = fc.content_item_version_id
          and sp.criterion_keys = array[fc.criterion_key]);
    if v_missing_exclusive <> 0 then
      raise exception 'holdout %: % criteria have no exclusive span', v_id, v_missing_exclusive;
    end if;
  end loop;
end $$;

commit;
