-- FF-4/FF-5, DECISION-0064: split AP Biology S-101's criterion a-iv into two
-- single-fact criteria (a-iv, a-v), per Codex work order F.2
-- (docs/research/apbio_f2_s101_and_holdouts_2026_09_24/criteria_change.json).
--
-- Why: M5-B-001/M1-B-001 found a-iv required evidence from two separated stem
-- sub-parts -- (a)(iii) "what most parsimonious means" and (a)(iv) "why
-- parsimony is preferred" -- under one criterion with one contiguous-quote
-- requirement. The grader could satisfy it only by constructing an elided
-- quote (1 run in 3), never reliably. This is a rubric defect, not a content
-- or grader defect (docs/research/biology_m1_regrade_and_blocker_2026_09_24/README.md).
--
-- This migration is scoped to app.frq_criteria only. It does not write
-- canonical_answer_1/2 or any label -- S-101 stays held out of M1 until the
-- corrected rubric clears the DECISION-0052 grader gate (tested separately,
-- after this applies, via app.qa_grade_frq).
--
-- Point total for this item moves 4 -> 5. content_item_versions.prompt_json
-- for this version has no total_points key (verified before writing this
-- migration), so nothing else needs updating to stay consistent; the M4
-- migration (20260924140000) already established frq_criteria.points_possible
-- as the only source of truth for Biology point totals.
--
-- Rollback: restore the single row below (delete a-v, restore a-iv).
--   criterion_key='a-iv', points_possible=1,
--   learner_facing_text='Explains what "most parsimonious" means and why parsimony is preferred when building cladograms.',
--   evidence_requirements='States that the most parsimonious tree requires the fewest evolutionary changes (character-state transitions), and that parsimony is preferred because it requires the fewest unsupported assumptions (independent convergent origins) of the character data.',
--   minimum_fix='State that parsimony minimizes the number of required evolutionary changes, and that this is preferred because it assumes the fewest independent, unsupported evolutionary events.'

update app.frq_criteria
set
  learner_facing_text = 'Explains what "most parsimonious" means in phylogenetic analysis.',
  evidence_requirements = 'States that the most parsimonious tree requires the fewest evolutionary changes or character-state transitions.',
  minimum_fix = 'State that the most parsimonious tree is the one requiring the fewest character-state changes.'
where content_item_version_id = '406df04d-6c14-4ca2-9444-9f18cd2a5ed8'
  and criterion_key = 'a-iv';

insert into app.frq_criteria (
  content_item_version_id, criterion_key, points_possible,
  learner_facing_text, evidence_requirements, minimum_fix, accepted_variants
) values (
  '406df04d-6c14-4ca2-9444-9f18cd2a5ed8', 'a-v', 1,
  'Explains why parsimony is preferred when building cladograms.',
  'States that parsimony is preferred because it requires the fewest unsupported assumptions, such as independent origins or reversals.',
  'State that parsimony is preferred because it requires the fewest unsupported assumptions, such as repeated independent origins or reversals of a character.',
  '[]'::jsonb
);
