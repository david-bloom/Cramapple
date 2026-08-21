-- TASK-0027: drop the TASK-0017 five-subject harness objects (Development only)
-- ---------------------------------------------------------------------------
-- Removes 65 objects that exist in Development and never existed in the
-- Production lineage: 39 tables, 25 functions and 1 view, plus 3 harness-era
-- FK columns on retained tables.
--
-- Provenance, confirmed by Codex 2026-08-21 and independently verified:
--   TASK-0017 subject-onboarding harness, built 13-18 July 2026, Dev-only in
--   practice, never adopted into Production, not live work.
--
-- RESTORE PATH — this drop is reversible. Everything lives in the tag
-- `archive/codex-five-subject-20260727` (present on origin):
--   supabase/migrations/20260713172806_task0017_h1_h2_subject_harness_persistence.sql
--   supabase/migrations/20260713172817_task0017_h3_h5_validation_and_exceptions.sql
--   supabase/migrations/20260715215736_five_subject_harness_content_pool.sql
--   supabase/migrations/20260718014159_add_atomic_draft_package_adoption.sql
--   docs/architecture/TASK0017_H1_H5_PHYSICAL_DESIGN_2026_07_13.md
--   docs/tasks/TASK-0017-SUBJECT-ONBOARDING-HARNESS.md
--   prompts/CODEX_FIVE_SUBJECT_HARNESS_AND_CONTENT_SEEDING_2026_07_15.md
-- Re-applying those four migrations restores the harness.
--
-- Safe to run against Production: every statement is IF EXISTS, and none of
-- these objects exist there, so it is a no-op.
--
-- Approved by the Product Owner, 2026-08-21.

-- --- Preconditions ---------------------------------------------------------
-- Refuse to run if the harness holds anything other than the three known
-- lookup tables' seeded rows, or if any retained row actually uses a harness
-- FK column. Both were true when this was written; assert rather than assume.
do $$
declare
  lookup_rows bigint;
  other_rows bigint;
  used bigint;
begin
  if to_regclass('app.execution_approvals') is null then
    raise notice 'TASK-0017 harness not present; nothing to drop';
    return;
  end if;

  select coalesce(sum(n_live_tup),0) into lookup_rows from pg_stat_user_tables
   where schemaname='app' and relname in
     ('platform_capabilities','validation_suite_types','deterministic_check_types');

  select coalesce(sum(n_live_tup),0) into other_rows from pg_stat_user_tables
   where schemaname='app' and relname in (
     'bootstrap_frq_synthetic_responses','bootstrap_frqs','bootstrap_grading_assignments',
     'calibration_evidence_records','calibration_sets','content_clearance_exception_revocations',
     'content_clearance_exceptions','content_review_batches','content_review_pool_items',
     'content_version_taxonomy_assignments','eligibility_evaluations',
     'exam_pack_manifest_content_versions','execution_approval_consumptions',
     'execution_approval_revocations','execution_approvals','governance_role_assignments',
     'grading_experiment_cases','grading_experiment_results','grading_experiment_runs',
     'hdr_response_assets','item_archetype_versions','item_archetypes','item_package_applications',
     'qualification_evidence_records','review_policy_versions','reviewer_capability_assignments',
     'reviewer_capability_evidence','reviewer_capability_revocations','subject_package_applications',
     'taxonomy_crosswalks','taxonomy_node_relations','taxonomy_node_versions',
     'taxonomy_scheme_versions','taxonomy_schemes','verifier_plugin_versions','verifier_plugins');

  if other_rows > 0 then
    raise exception 'PRECONDITION FAIL: % row(s) of operational harness data present; refusing to drop', other_rows;
  end if;
  raise notice 'Precondition OK: 0 operational rows, % lookup row(s)', lookup_rows;

  execute 'select count(*) from app.content_item_versions where archetype_version_id is not null' into used;
  if used > 0 then raise exception 'PRECONDITION FAIL: % content_item_versions row(s) use archetype_version_id', used; end if;
  execute 'select count(*) from app.validation_suites where suite_type_key is not null' into used;
  if used > 0 then raise exception 'PRECONDITION FAIL: % validation_suites row(s) use suite_type_key', used; end if;
  execute 'select count(*) from app.exam_pack_manifests where content_clearance_exception_id is not null' into used;
  if used > 0 then raise exception 'PRECONDITION FAIL: % exam_pack_manifests row(s) use content_clearance_exception_id', used; end if;
  raise notice 'Precondition OK: no retained row uses a harness FK column';
end $$;

-- --- View ------------------------------------------------------------------
-- Dropped before the columns it reads.
drop view if exists app.validation_suite_versions cascade;

-- --- Functions (all overloads) ---------------------------------------------
do $$
declare r record;
begin
  for r in
    select n.nspname ns, p.proname nm, pg_get_function_identity_arguments(p.oid) args
      from pg_proc p join pg_namespace n on n.oid = p.pronamespace
     where n.nspname = 'app'
       and p.proname = any (array[
         'active_content_clearance_exception_id','apply_subject_package_atomic',
         'apply_subject_package_atomic_v1','assign_validation_suite_type_key',
         'calibration_requirement_satisfied','content_publication_gate_status',
         'create_five_subject_review_pool','enforce_archetype_supersession_scope',
         'enforce_content_review_assignment_eligibility','enforce_reviewed_verifier_plugin',
         'enforce_taxonomy_relation_scope','enforce_taxonomy_supersession_scope',
         'enforce_typed_manifest_validation','evaluate_review_team_eligibility',
         'evaluate_reviewer_eligibility','has_active_content_clearance_exception',
         'project_item_package_details','project_manifest_content_versions',
         'protect_item_package_snapshot','protect_package_managed_content_item',
         'provision_reviewer_capability','publish_content_item_version_atomic',
         'reject_immutable_record_mutation','validate_reviewer_capability_assignment',
         'validation_run_is_current'])
  loop
    execute format('drop function if exists %I.%I(%s) cascade', r.ns, r.nm, r.args);
  end loop;
end $$;

-- --- Harness-era columns on retained tables --------------------------------
-- Absent from Production and 100% NULL in Development; dropping them converges
-- the two schemas.
--
-- ORDER MATTERS: these must come AFTER the view and the functions. A first
-- attempt dropped them earlier and failed on
-- `trigger validation_suites_assign_type ... depends on column suite_type_key`.
-- The trigger depends on app.assign_validation_suite_type_key, so dropping the
-- functions with CASCADE removes it and leaves the columns free.
alter table if exists app.content_item_versions drop column if exists archetype_version_id;
alter table if exists app.validation_suites     drop column if exists suite_type_key;
alter table if exists app.exam_pack_manifests   drop column if exists content_clearance_exception_id;

-- --- Tables ----------------------------------------------------------------
do $$
declare t text;
begin
  foreach t in array array[
    'bootstrap_frq_synthetic_responses','bootstrap_frqs','bootstrap_grading_assignments',
    'calibration_evidence_records','calibration_sets','content_clearance_exception_revocations',
    'content_clearance_exceptions','content_review_batches','content_review_pool_items',
    'content_version_taxonomy_assignments','deterministic_check_types','eligibility_evaluations',
    'exam_pack_manifest_content_versions','execution_approval_consumptions',
    'execution_approval_revocations','execution_approvals','governance_role_assignments',
    'grading_experiment_cases','grading_experiment_results','grading_experiment_runs',
    'hdr_response_assets','item_archetype_versions','item_archetypes','item_package_applications',
    'platform_capabilities','qualification_evidence_records','review_policy_versions',
    'reviewer_capability_assignments','reviewer_capability_evidence','reviewer_capability_revocations',
    'subject_package_applications','taxonomy_crosswalks','taxonomy_node_relations',
    'taxonomy_node_versions','taxonomy_scheme_versions','taxonomy_schemes','validation_suite_types',
    'verifier_plugin_versions','verifier_plugins']
  loop
    execute format('drop table if exists app.%I cascade', t);
  end loop;
end $$;

-- --- Post-assertions -------------------------------------------------------
do $$
declare left_over int;
begin
  select count(*) into left_over from information_schema.tables
   where table_schema='app' and table_name in
     ('execution_approvals','taxonomy_schemes','item_archetypes','verifier_plugins',
      'reviewer_capability_assignments','platform_capabilities');
  if left_over > 0 then
    raise exception 'POST FAIL: % harness table(s) survived the drop', left_over;
  end if;

  -- The live taxonomy model and the student RPCs must be untouched.
  if to_regclass('app.taxonomy_source_versions') is null
     or to_regclass('app.taxonomy_units') is null
     or to_regclass('app.taxonomy_topics') is null then
    raise exception 'POST FAIL: the live taxonomy model was damaged';
  end if;
  if not exists (select 1 from pg_proc p join pg_namespace n on n.oid=p.pronamespace
                  where n.nspname='public' and p.proname='get_student_progress_dashboard') then
    raise exception 'POST FAIL: get_student_progress_dashboard was dropped';
  end if;
  if not exists (select 1 from pg_proc p join pg_namespace n on n.oid=p.pronamespace
                  where n.nspname='public' and p.proname='get_student_taxonomy') then
    raise exception 'POST FAIL: get_student_taxonomy was dropped';
  end if;
  raise notice 'POST OK: harness removed; live taxonomy and student RPCs intact';
end $$;
