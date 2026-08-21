-- QA: Development / Production schema drift (TASK-0027)
-- ---------------------------------------------------------------------------
-- Read-only. Run against BOTH projects and compare the outputs.
--   psql <prod> -f scripts/qa/dev_prod_drift_qa.sql > /tmp/drift_prod.txt
--   psql <dev>  -f scripts/qa/dev_prod_drift_qa.sql > /tmp/drift_dev.txt
--   diff /tmp/drift_prod.txt /tmp/drift_dev.txt
--
-- Baseline measured 2026-08-21: Production 184 objects, Development 199,
-- 135 shared, 49 Prod-only, 64 Dev-only.
--
-- The central lesson this script encodes: **the migration ledger is not
-- evidence.** Development records migrations as applied whose objects do not
-- exist. Compare objects, never version ids.

-- D1: the ledger must not claim migrations whose objects are absent ---------
-- Each row asserts "if this migration is recorded as applied, this object must
-- exist". Extend the list as new structural migrations land.
do $$
declare r record; missing text := '';
begin
  for r in select * from (values
      ('20260804170000', 'app.taxonomy_source_versions'),
      ('20260804183000', 'app.taxonomy_units'),
      ('20260821080000', 'public.get_student_progress_dashboard')
    ) as t(version, obj)
  loop
    if exists (select 1 from supabase_migrations.schema_migrations m
                where m.version = r.version) then
      if to_regclass(r.obj) is null
         and not exists (select 1 from pg_proc p join pg_namespace n on n.oid = p.pronamespace
                          where n.nspname || '.' || p.proname = r.obj) then
        missing := missing || format('%s->%s ', r.version, r.obj);
      end if;
    end if;
  end loop;
  if missing <> '' then
    raise exception 'D1 FAIL: ledger records migrations whose objects are absent: %', missing;
  end if;
  raise notice 'D1 PASS: every checked recorded migration has its objects present';
end $$;

-- D2: the student-facing RPCs must actually execute -------------------------
-- These failed in Development with 42P01 before TASK-0027.
do $$
begin
  if to_regclass('app.taxonomy_source_versions') is null
     or to_regclass('app.taxonomy_units') is null
     or to_regclass('app.taxonomy_topics') is null then
    raise exception 'D2 FAIL: taxonomy layer incomplete in this project';
  end if;
  perform set_config('request.jwt.claims',
    '{"sub":"00000000-0000-4000-8000-00000000000d","role":"authenticated"}', true);
  begin
    perform public.get_student_taxonomy(null);
  exception
    when sqlstate '42P01' then
      raise exception 'D2 FAIL: get_student_taxonomy still hits a missing relation';
    when others then null;  -- auth/entitlement outcomes are fine; 42P01 is not
  end;
  raise notice 'D2 PASS: taxonomy layer present and get_student_taxonomy resolves';
end $$;

-- D3: exactly one taxonomy model may exist ----------------------------------
-- Production uses taxonomy_source_versions/units/topics. Development also
-- carries an unused taxonomy_schemes/node_versions/crosswalks model (0 rows,
-- in no repo migration). Reported, not failed, pending the Product Owner
-- decision recorded in TASK-0027.
do $$
declare legacy int; canonical int;
begin
  select count(*) into canonical from information_schema.tables
   where table_schema='app' and table_name in
     ('taxonomy_source_versions','taxonomy_units','taxonomy_topics');
  select count(*) into legacy from information_schema.tables
   where table_schema='app' and table_name in
     ('taxonomy_schemes','taxonomy_scheme_versions','taxonomy_node_versions',
      'taxonomy_node_relations','taxonomy_crosswalks');
  if canonical <> 3 then
    raise exception 'D3 FAIL: canonical taxonomy model incomplete (% of 3 tables)', canonical;
  end if;
  if legacy > 0 then
    raise warning 'D3 NOTE: % second-taxonomy-model table(s) present (TASK-0027, expected only in Dev)', legacy;
  end if;
  raise notice 'D3 PASS: canonical taxonomy model complete';
end $$;

-- D4: object inventory fingerprint ------------------------------------------
-- Compare across projects. A changed hash means the object set moved.
-- Counts are DISTINCT by qualified name: overloaded functions collapse to one
-- entry, matching how the TASK-0027 baseline (184 / 199 / 135) was measured.
select 'OBJECT_COUNT' as metric, count(*)::text as value
  from (
  select distinct x from (
    select table_schema||'.'||table_name x from information_schema.tables
     where table_schema in ('app','public') and table_type='BASE TABLE'
    union all
    select table_schema||'.'||table_name from information_schema.views
     where table_schema in ('app','public')
    union all
    select n.nspname||'.'||p.proname from pg_proc p
      join pg_namespace n on n.oid=p.pronamespace
     where n.nspname in ('app','public')
       and p.proname !~ '(trgm|similarity|set_limit|show_limit|show_trgm)'
  ) u ) t
union all
select 'OBJECT_SHA',
  left(encode(sha256(string_agg(x, E'\n' order by x)::bytea),'hex'),16)
  from (
  select distinct x from (
    select 'T '||table_schema||'.'||table_name x from information_schema.tables
     where table_schema in ('app','public') and table_type='BASE TABLE'
    union all
    select 'V '||table_schema||'.'||table_name from information_schema.views
     where table_schema in ('app','public')
    union all
    select 'F '||n.nspname||'.'||p.proname from pg_proc p
      join pg_namespace n on n.oid=p.pronamespace
     where n.nspname in ('app','public')
       and p.proname !~ '(trgm|similarity|set_limit|show_limit|show_trgm)'
  ) u ) t;

-- D5: full object list, for diffing ------------------------------------------
select distinct 'T '||table_schema||'.'||table_name as object from information_schema.tables
 where table_schema in ('app','public') and table_type='BASE TABLE'
union all
select 'V '||table_schema||'.'||table_name from information_schema.views
 where table_schema in ('app','public')
union all
select 'F '||n.nspname||'.'||p.proname from pg_proc p
  join pg_namespace n on n.oid=p.pronamespace
 where n.nspname in ('app','public')
   and p.proname !~ '(trgm|similarity|set_limit|show_limit|show_trgm)'
order by 1;
