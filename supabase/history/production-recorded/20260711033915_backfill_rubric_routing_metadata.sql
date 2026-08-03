-- Exported from Production migration history (supabase_migrations.schema_migrations)
-- version: 20260711033915
-- recorded name: backfill_rubric_routing_metadata
-- statements: 1
-- This file is a faithful transcript of what Production actually ran.
-- Do not edit to "improve" it; corrections belong in a new forward migration.

-- Backfill explicit grading-router metadata for existing safe production items.
--
-- MCQ and FRQ text items already have stable automated handling, so we can
-- make their routing explicit without changing behavior. Quantitative items
-- remain null for now so they continue to route to shadow review until the
-- structured-formula verifier is actually wired in.

begin;

update app.content_item_versions civ
set rubric_type = 'mcq',
    evaluator_strategy = 'rule_based_mcq'
from app.content_items ci
where civ.content_item_id = ci.id
  and civ.rubric_type is null
  and civ.evaluator_strategy is null
  and ci.item_type = 'mcq';

update app.content_item_versions civ
set rubric_type = 'discrete_text',
    evaluator_strategy = 'llm_discrete_text'
from app.content_items ci
where civ.content_item_id = ci.id
  and civ.rubric_type is null
  and civ.evaluator_strategy is null
  and ci.item_type = 'frq';

commit;
;
