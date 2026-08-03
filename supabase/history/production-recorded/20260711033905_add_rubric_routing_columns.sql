-- Exported from Production migration history (supabase_migrations.schema_migrations)
-- version: 20260711033905
-- recorded name: add_rubric_routing_columns
-- statements: 1
-- This file is a faithful transcript of what Production actually ran.
-- Do not edit to "improve" it; corrections belong in a new forward migration.

-- Add rubric-routing metadata to content item versions.
--
-- The Phase A router can read these columns when they are present. Until
-- content authors backfill them, the production code falls back to the legacy
-- item_type mapping so existing Biology / Statistics text grading is preserved.

begin;

alter table app.content_item_versions
  add column if not exists rubric_type text,
  add column if not exists evaluator_strategy text;

do $$
begin
  alter table app.content_item_versions
    add constraint content_item_versions_rubric_type_check
      check (rubric_type is null or rubric_type in (
        'mcq',
        'discrete_text',
        'structured_formula',
        'spatial',
        'holistic'
      ));
exception
  when duplicate_object then null;
end;
$$;

do $$
begin
  alter table app.content_item_versions
    add constraint content_item_versions_evaluator_strategy_check
      check (evaluator_strategy is null or evaluator_strategy in (
        'rule_based_mcq',
        'llm_discrete_text',
        'python_symbolic_ecf',
        'human_shadow'
      ));
exception
  when duplicate_object then null;
end;
$$;

commit;
;
