-- TASK-0056 guard (DECISION-0089): answer keys must not be directly readable.
--
-- Returns one row per violation; an empty result is a pass. Read-only; safe to
-- run on Development and Production. Run as postgres (or another role that can
-- see every view definition).
--
-- A violation is either:
--   base    `anon` or `authenticated` can SELECT a protected column on its base
--           table (column- or table-level privilege).
--   view    a view in a PostgREST-exposed schema depends on a protected column
--           and `anon` or `authenticated` can SELECT from that view.
--
-- The view rule is deliberately strict: it does not trust security_invoker or
-- column aliasing. A view that needs a protected column should be a
-- SECURITY DEFINER function with its own gate instead (e.g.
-- public.get_review_item_version, public.get_open_hand_item).
--
-- Protected = the "never student-readable" and "recorded hint" rows of the
-- field classification in docs/tasks/TASK-0056-ANSWER-KEY-DIRECT-READ-EXPOSURE.md.
-- Add a row below when a new answer-bearing column is created.

with protected(tbl, col) as (
  values
    ('app.content_item_versions', 'canonical_answer_1'),
    ('app.content_item_versions', 'canonical_answer_2'),
    ('app.content_item_versions', 'explanation'),
    ('app.content_item_versions', 'item_package_payload'),
    ('app.frq_criteria',          'evidence_requirements'),
    ('app.frq_criteria',          'accepted_variants'),
    ('app.frq_criteria',          'minimum_fix'),
    ('app.mcq_choices',           'is_correct'),
    ('app.mcq_choices',           'rationale')
),
protected_cols as (
  select p.tbl, p.col, a.attrelid, a.attnum
  from protected p
  join pg_attribute a
    on a.attrelid = p.tbl::regclass and a.attname = p.col and not a.attisdropped
  union all
  -- every column of canonical_answer_spans is never student-readable
  select 'app.canonical_answer_spans', a.attname, a.attrelid, a.attnum
  from pg_attribute a
  where a.attrelid = to_regclass('app.canonical_answer_spans')
    and a.attnum > 0 and not a.attisdropped
),
roles(r) as (values ('anon'), ('authenticated')),
exposed_schemas(nsp) as (values ('public'), ('app'), ('graphql_public'))
select 'base' as kind, r.r as role, pc.tbl as relation, pc.col as column_name
from protected_cols pc cross join roles r
where has_column_privilege(r.r, pc.attrelid, pc.attnum, 'SELECT')
union all
select distinct 'view', r.r, vn.nspname || '.' || v.relname, pc.tbl || '.' || pc.col
from protected_cols pc
join pg_depend d
  on d.refobjid = pc.attrelid and d.refobjsubid = pc.attnum and d.classid = 'pg_rewrite'::regclass
join pg_rewrite rw on rw.oid = d.objid
join pg_class v on v.oid = rw.ev_class and v.relkind in ('v', 'm')
join pg_namespace vn on vn.oid = v.relnamespace
join exposed_schemas es on es.nsp = vn.nspname
cross join roles r
where has_table_privilege(r.r, v.oid, 'SELECT')
   or exists (
     select 1 from pg_attribute va
     where va.attrelid = v.oid and va.attnum > 0 and not va.attisdropped
       and has_column_privilege(r.r, v.oid, va.attnum, 'SELECT'))
order by 1, 2, 3, 4;
