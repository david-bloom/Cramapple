-- TASK-0067 / TASK-0066 — unit reference entries and memory hooks. Read-only.
-- Every check row should read ok = true. Run against Development after the Phase A migration and
-- against Production after its Hard-Gate apply.

-- 1. Objects exist
select 'tables_and_views' as check_name,
  (select count(*) from pg_tables where schemaname = 'app' and tablename in ('unit_reference_entries', 'topic_memory_hooks')) = 2
  and (select count(*) from pg_views where schemaname = 'public' and viewname in ('unit_reference_entries', 'topic_memory_hooks')) = 2 as ok;

-- 2. RLS enabled and forced on both tables
select 'rls_forced' as check_name,
  bool_and(c.relrowsecurity and c.relforcerowsecurity) as ok
from pg_class c join pg_namespace n on n.oid = c.relnamespace
where n.nspname = 'app' and c.relname in ('unit_reference_entries', 'topic_memory_hooks');

-- 3. No anon grants on the tables or views
select 'no_anon_grants' as check_name,
  not exists (
    select 1 from information_schema.role_table_grants
    where grantee = 'anon'
      and ((table_schema = 'app' and table_name in ('unit_reference_entries', 'topic_memory_hooks'))
        or (table_schema = 'public' and table_name in ('unit_reference_entries', 'topic_memory_hooks')))
  ) as ok;

-- 4. Zero orphans: every topic code on every entry exists in the subject's latest verified taxonomy
with latest as (
  select distinct on (tsv.subject_key) tsv.taxonomy_source_version, tsv.subject_key
  from app.taxonomy_source_versions tsv
  where tsv.taxonomy_confidence = 'verified'
  order by tsv.subject_key, tsv.school_year desc, tsv.verified_at desc nulls last, tsv.created_at desc
), expanded as (
  select ure.reference_entry_id, ure.subject_key, ure.unit_number, ure.owner_topic_code, tc.topic_code
  from app.unit_reference_entries ure
  cross join lateral unnest(ure.topic_codes) as tc(topic_code)
)
select 'zero_orphan_topic_codes' as check_name,
  not exists (
    select 1 from expanded e
    left join latest l on l.subject_key = e.subject_key
    left join app.taxonomy_topics tt
      on tt.taxonomy_source_version = l.taxonomy_source_version and tt.topic_code = e.topic_code
    where tt.taxonomy_topic_id is null
  ) as ok;

-- 5. Unit agrees with the owner topic's unit in the taxonomy
with latest as (
  select distinct on (tsv.subject_key) tsv.taxonomy_source_version, tsv.subject_key
  from app.taxonomy_source_versions tsv
  where tsv.taxonomy_confidence = 'verified'
  order by tsv.subject_key, tsv.school_year desc, tsv.verified_at desc nulls last, tsv.created_at desc
)
select 'owner_unit_matches_taxonomy' as check_name,
  not exists (
    select 1 from app.unit_reference_entries ure
    join latest l on l.subject_key = ure.subject_key
    join app.taxonomy_topics tt
      on tt.taxonomy_source_version = l.taxonomy_source_version and tt.topic_code = ure.owner_topic_code
    where tt.unit_number <> ure.unit_number
  ) as ok;

-- 6. Every published hook points at a published entry
select 'published_hooks_have_published_entries' as check_name,
  not exists (
    select 1 from app.topic_memory_hooks h
    join app.unit_reference_entries ure on ure.reference_entry_id = h.reference_entry_id
    where h.status = 'published' and ure.status <> 'published'
  ) as ok;

-- 7. Published rows carry published_at
select 'published_at_present' as check_name,
  not exists (select 1 from app.unit_reference_entries where status = 'published' and published_at is null)
  and not exists (select 1 from app.topic_memory_hooks where status = 'published' and published_at is null) as ok;

-- 8. The RPC body carries the original keys and the two new ones
select 'rpc_payload_keys' as check_name,
  (select d like '%''briefs''%' and d like '%''explainers''%' and d like '%''reference''%' and d like '%''memoryHooks''%'
   from pg_get_functiondef('public.get_topic_point_guides(text,integer,text)'::regprocedure) d) as ok;

-- 9. Inventory (informational)
select ure.subject_key, ure.unit_number, ure.kind, ure.status, count(*) as entries,
  (select count(*) from app.topic_memory_hooks h where h.reference_entry_id = any (array_agg(ure.reference_entry_id))) as hooks
from app.unit_reference_entries ure
group by 1, 2, 3, 4
order by 1, 2, 3, 4;
