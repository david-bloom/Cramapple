-- FF-4, DECISION-0064/DECISION-0052: write APBIO-FRQ-S-101's canonical answer
-- and segmentation, completing M1 for the one item M1 (20260924170000) held.
--
-- Held reason (M1-B-001): before today, S-101 scored 100% on only 1 of 3
-- grader runs, and writing a canonical would have foreclosed that measurement
-- forever (the QA gate refuses any item that already has a canonical_answer_1).
-- Both blockers are now gone:
--   - 20260924210000 split criterion a-iv into a-iv/a-v (Codex work order F.2),
--     matching the stem's separate (a)(iii)/(a)(iv) sub-parts.
--   - FF-11 widened the qa_no_persist grader gate to run regardless of
--     canonical presence.
-- Re-tested against the corrected rubric with this exact text (unchanged from
-- Codex's F.2 proposal): 3 of 3 runs, 5/5, high confidence, 0 integrity
-- issues -- a clean pass, not a borderline one.
--
-- Text and spans are Codex's F.2 proposal
-- (docs/research/apbio_f2_s101_and_holdouts_2026_09_24/criteria_change.json),
-- verified here rather than trusted: the 9 span texts concatenate to the
-- canonical exactly (byte-for-byte, confirmed in Python before writing this
-- migration), and each of the 5 criteria has exactly one exclusive span.
--
-- source_field mapping: F.2's "drafted" spans have no prior stored field to
-- attribute to (S-101's canonical was blank), so source_field is NULL for
-- them -- 'authored' is available but is reserved by convention (M1) for text
-- recovered from another item's retired canonical under
-- authorized_cross_item_parent_recovery; this text is newly written for this
-- item specifically, so NULL is the more honest source_field. F.2's
-- "assembly_literal" paragraph-break spans also get source_field NULL and
-- empty criterion_keys, matching M1's treatment of the same provenance value.
--
-- Rollback: set canonical_answer_1 back to NULL and
-- delete from app.canonical_answer_spans where proposal_run = 'work_order_F2_2026_09_24'.

begin;

update app.content_item_versions
set canonical_answer_1 = 'A synapomorphy is a shared derived character that evolved in the common ancestor of a group and was inherited by its descendants.

It is more useful than a symplesiomorphy because an ancestral character may be shared by many lineages and therefore does not distinguish more recent branches, whereas a shared derived character identifies a more recent common ancestor.

Species A is the outgroup because it lacks all four derived characters. The most parsimonious topology is (A,(B,(C,(D,E)))). Character 1 unites B-E, character 2 unites C-E, character 3 unites D and E, and character 4 is unique to E, so each character needs to arise only once on this tree.

"Most parsimonious" means the tree that requires the fewest total character-state changes.

Parsimony is preferred because it explains the observed character distribution with the fewest unsupported evolutionary assumptions, such as repeated independent origins or reversals of the same character.'
where id = '406df04d-6c14-4ca2-9444-9f18cd2a5ed8'
  and canonical_answer_1 is null;

insert into app.canonical_answer_spans (
  content_item_version_id, answer_field, span_ordinal, span_text,
  criterion_keys, provenance, source_field, proposal_run
) values
  ('406df04d-6c14-4ca2-9444-9f18cd2a5ed8', 'canonical_answer_1', 0,
   'A synapomorphy is a shared derived character that evolved in the common ancestor of a group and was inherited by its descendants.',
   array['a-i'], 'drafted', null, 'work_order_F2_2026_09_24'),
  ('406df04d-6c14-4ca2-9444-9f18cd2a5ed8', 'canonical_answer_1', 1,
   E'\n\n', array[]::text[], 'assembly_literal', null, 'work_order_F2_2026_09_24'),
  ('406df04d-6c14-4ca2-9444-9f18cd2a5ed8', 'canonical_answer_1', 2,
   'It is more useful than a symplesiomorphy because an ancestral character may be shared by many lineages and therefore does not distinguish more recent branches, whereas a shared derived character identifies a more recent common ancestor.',
   array['a-ii'], 'drafted', null, 'work_order_F2_2026_09_24'),
  ('406df04d-6c14-4ca2-9444-9f18cd2a5ed8', 'canonical_answer_1', 3,
   E'\n\n', array[]::text[], 'assembly_literal', null, 'work_order_F2_2026_09_24'),
  ('406df04d-6c14-4ca2-9444-9f18cd2a5ed8', 'canonical_answer_1', 4,
   'Species A is the outgroup because it lacks all four derived characters. The most parsimonious topology is (A,(B,(C,(D,E)))). Character 1 unites B-E, character 2 unites C-E, character 3 unites D and E, and character 4 is unique to E, so each character needs to arise only once on this tree.',
   array['a-iii'], 'drafted', null, 'work_order_F2_2026_09_24'),
  ('406df04d-6c14-4ca2-9444-9f18cd2a5ed8', 'canonical_answer_1', 5,
   E'\n\n', array[]::text[], 'assembly_literal', null, 'work_order_F2_2026_09_24'),
  ('406df04d-6c14-4ca2-9444-9f18cd2a5ed8', 'canonical_answer_1', 6,
   '"Most parsimonious" means the tree that requires the fewest total character-state changes.',
   array['a-iv'], 'drafted', null, 'work_order_F2_2026_09_24'),
  ('406df04d-6c14-4ca2-9444-9f18cd2a5ed8', 'canonical_answer_1', 7,
   E'\n\n', array[]::text[], 'assembly_literal', null, 'work_order_F2_2026_09_24'),
  ('406df04d-6c14-4ca2-9444-9f18cd2a5ed8', 'canonical_answer_1', 8,
   'Parsimony is preferred because it explains the observed character distribution with the fewest unsupported evolutionary assumptions, such as repeated independent origins or reversals of the same character.',
   array['a-v'], 'drafted', null, 'work_order_F2_2026_09_24');

-- Verification: the M0 invariant (spans reconstruct the field exactly) and the
-- exclusivity invariant (every criterion has exactly one exclusive span).
do $$
declare
  v_reconstructed text;
  v_canonical text;
  v_missing_exclusive int;
begin
  select canonical_answer_1 into v_canonical
  from app.content_item_versions where id = '406df04d-6c14-4ca2-9444-9f18cd2a5ed8';

  if v_canonical is null then
    raise exception 'S-101: canonical_answer_1 is still null -- the update did not apply (row may already have had a non-null value, or the id/predicate did not match)';
  end if;

  select string_agg(span_text, '' order by span_ordinal) into v_reconstructed
  from app.canonical_answer_spans
  where content_item_version_id = '406df04d-6c14-4ca2-9444-9f18cd2a5ed8'
    and answer_field = 'canonical_answer_1';

  if v_reconstructed is distinct from v_canonical then
    raise exception 'S-101: spans do not reconstruct canonical_answer_1';
  end if;

  select count(*) into v_missing_exclusive
  from app.frq_criteria fc
  where fc.content_item_version_id = '406df04d-6c14-4ca2-9444-9f18cd2a5ed8'
    and not exists (
      select 1 from app.canonical_answer_spans sp
      where sp.content_item_version_id = fc.content_item_version_id
        and sp.criterion_keys = array[fc.criterion_key]);
  if v_missing_exclusive <> 0 then
    raise exception 'S-101: % criteria have no exclusive span', v_missing_exclusive;
  end if;
end $$;

commit;
