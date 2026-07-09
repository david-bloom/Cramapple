-- Phase 1 curated interface verification queries.
-- Read-only checks for Dev / branch first, then rerun as an authenticated role
-- before any Production comparison.

-- 1) Confirm the curated public views exist.
select schemaname, viewname
from pg_views
where schemaname = 'public'
  and viewname in (
    'profiles',
    'subjects',
    'exam_packs',
    'exam_pack_versions',
    'content_labels',
    'content_items',
    'content_item_versions',
    'mcq_choices',
    'frq_criteria',
    'content_item_labels',
    'learning_sessions',
    'attempts',
    'response_versions',
    'attempt_criterion_results',
    'grading_results',
    'content_review_assignments',
    'content_review_decisions',
    'config',
    'dashboard_overview_v1',
    'dashboard_subjects_v1',
    'dashboard_pipeline_v1',
    'dashboard_engagement_v1',
    'dashboard_quality_v1',
    'dashboard_attention_v1'
  )
order by viewname;

-- 2) Confirm the view definitions carry the expected security model.
select
  n.nspname as schema_name,
  c.relname as view_name,
  c.reloptions
from pg_class c
join pg_namespace n
  on n.oid = c.relnamespace
where n.nspname = 'public'
  and c.relkind = 'v'
  and c.relname in (
    'profiles',
    'subjects',
    'exam_packs',
    'exam_pack_versions',
    'content_labels',
    'content_items',
    'content_item_versions',
    'mcq_choices',
    'frq_criteria',
    'content_item_labels',
    'learning_sessions',
    'attempts',
    'response_versions',
    'attempt_criterion_results',
    'grading_results',
    'content_review_assignments',
    'content_review_decisions',
    'config',
    'dashboard_overview_v1',
    'dashboard_subjects_v1',
    'dashboard_pipeline_v1',
    'dashboard_engagement_v1',
    'dashboard_quality_v1',
    'dashboard_attention_v1'
  )
order by view_name;

-- 3) Confirm the curated column shapes that were previously broken in QA.
select
  table_schema,
  table_name,
  column_name
from information_schema.columns
where table_schema = 'public'
  and table_name in (
    'content_item_versions',
    'grading_results',
    'content_item_labels',
    'content_review_assignments',
    'content_review_decisions'
  )
  and column_name in (
    'canonical_answer_1',
    'canonical_answer_2',
    'feedback_preview',
    'action_hint',
    'repair_hint',
    'created_at',
    'content_review_assignment_id',
    'content_review_decision_id'
  )
order by table_name, column_name;

select
  table_schema,
  table_name,
  column_name
from information_schema.columns
where table_schema = 'public'
  and table_name in (
    'content_item_versions',
    'grading_results',
    'content_item_labels',
    'content_review_assignments',
    'content_review_decisions'
  )
  and column_name in (
    'canonical_answer',
    'feedback_preview',
    'action_hint',
    'repair_hint',
    'id',
    'assignment_id'
  );

-- 4) Confirm authenticated grants and absence of anon grants on the curated views.
select
  table_schema,
  table_name,
  grantee,
  privilege_type
from information_schema.table_privileges
where table_schema = 'public'
  and table_name in (
    'profiles',
    'subjects',
    'exam_packs',
    'exam_pack_versions',
    'content_labels',
    'content_items',
    'content_item_versions',
    'mcq_choices',
    'frq_criteria',
    'content_item_labels',
    'learning_sessions',
    'attempts',
    'response_versions',
    'attempt_criterion_results',
    'grading_results',
    'content_review_assignments',
    'content_review_decisions',
    'config',
    'dashboard_overview_v1',
    'dashboard_subjects_v1',
    'dashboard_pipeline_v1',
    'dashboard_engagement_v1',
    'dashboard_quality_v1',
    'dashboard_attention_v1'
  )
order by table_name, grantee, privilege_type;

select *
from information_schema.table_privileges
where table_schema = 'public'
  and grantee = 'anon'
  and table_name in (
    'profiles',
    'subjects',
    'exam_packs',
    'exam_pack_versions',
    'content_labels',
    'content_items',
    'content_item_versions',
    'mcq_choices',
    'frq_criteria',
    'content_item_labels',
    'learning_sessions',
    'attempts',
    'response_versions',
    'attempt_criterion_results',
    'grading_results',
    'content_review_assignments',
    'content_review_decisions',
    'config',
    'dashboard_overview_v1',
    'dashboard_subjects_v1',
    'dashboard_pipeline_v1',
    'dashboard_engagement_v1',
    'dashboard_quality_v1',
    'dashboard_attention_v1'
  );

-- 5) Confirm the key RPCs exist with the expected identity signatures.
select
  n.nspname as schema_name,
  p.proname as function_name,
  pg_get_function_identity_arguments(p.oid) as identity_args,
  pg_get_function_result(p.oid) as return_type,
  p.prosecdef as security_definer
from pg_proc p
join pg_namespace n
  on n.oid = p.pronamespace
where n.nspname = 'app'
  and p.proname in (
    'submit_response',
    'apply_student_memory_event',
    'compose_learning_runtime_context',
    'reserve_model_usage',
    'complete_model_usage'
  )
order by function_name;

-- 6) Confirm app.config exists and is shaped for the public filter.
select
  c.table_schema,
  c.table_name,
  c.column_name,
  c.data_type,
  c.is_nullable
from information_schema.columns c
where c.table_schema = 'app'
  and c.table_name = 'config'
order by c.ordinal_position;

-- 7) Sample row checks for the curated interface.
select count(*) as rows_visible from public.subjects;
select count(*) as rows_visible from public.content_items;
select count(*) as rows_visible from public.content_item_versions;
select count(*) as rows_visible from public.grading_results;
select count(*) as rows_visible from public.content_review_assignments;
select count(*) as rows_visible from public.content_review_decisions;

-- 8) Confirm the six dashboard views return a rowset.
select count(*) as rows_visible from public.dashboard_overview_v1;
select count(*) as rows_visible from public.dashboard_subjects_v1;
select count(*) as rows_visible from public.dashboard_pipeline_v1;
select count(*) as rows_visible from public.dashboard_engagement_v1;
select count(*) as rows_visible from public.dashboard_quality_v1;
select count(*) as rows_visible from public.dashboard_attention_v1;
