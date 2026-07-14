-- Post-apply evidence for the TASK-0017 / publication batch on Development.
-- Run: psql "$CRAMAPPLE_DEV_DB_URL" -f scripts/dev-migration-apply/verify.sql
-- (The `app`-not-Data-API-exposed proof is a REST probe, not SQL — see README.)

\echo '== Publication (P0) functions =='
select proname,
       pg_get_function_identity_arguments(p.oid) as args,
       (p.prosecdef) as security_definer
from pg_proc p join pg_namespace n on n.oid=p.pronamespace
where n.nspname='app'
  and proname in ('publish_content_item_version_atomic','validation_run_is_current',
                  'calibration_requirement_satisfied','has_active_content_clearance_exception',
                  'active_content_clearance_exception_id')
order by proname;

\echo '== publish RPC is service_role-only (no anon/authenticated execute) =='
select r.rolname, has_function_privilege(r.rolname,
  'app.publish_content_item_version_atomic(jsonb)','execute') as can_execute
from pg_roles r where r.rolname in ('anon','authenticated','service_role') order by r.rolname;

\echo '== H1/H2 subject-harness tables present =='
select unnest(array['item_archetypes','item_archetype_versions','taxonomy_schemes',
  'taxonomy_scheme_versions','taxonomy_node_versions','taxonomy_node_relations',
  'content_version_taxonomy_assignments','exam_pack_manifest_content_versions',
  'subject_package_applications','item_package_applications']) as tbl,
  to_regclass('app.'||unnest(array['item_archetypes','item_archetype_versions','taxonomy_schemes',
  'taxonomy_scheme_versions','taxonomy_node_versions','taxonomy_node_relations',
  'content_version_taxonomy_assignments','exam_pack_manifest_content_versions',
  'subject_package_applications','item_package_applications'])) is not null as present;

\echo '== H3-H5 validation/exception tables + reference seeds present =='
select 'content_clearance_exceptions' as obj, to_regclass('app.content_clearance_exceptions') is not null as present
union all select 'platform_capabilities', to_regclass('app.platform_capabilities') is not null
union all select 'deterministic_check_types', to_regclass('app.deterministic_check_types') is not null
union all select 'reviewer_capability_assignments', to_regclass('app.reviewer_capability_assignments') is not null
union all select 'eligibility_evaluations', to_regclass('app.eligibility_evaluations') is not null;

\echo '== Curated public interface installed =='
select exists(select 1 from information_schema.schemata where schema_name='public_interface') as public_interface_schema,
       to_regclass('app.config') is not null as app_config_table;

\echo '== Recorded migration versions for this batch =='
select version, name from supabase_migrations.schema_migrations
where version in ('202607090001','202607090002','202607130001','20260713172806','20260713172817')
order by version;
