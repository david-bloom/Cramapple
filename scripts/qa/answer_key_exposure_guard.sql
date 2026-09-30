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
    ('app.mcq_choices',           'rationale'),
    -- Added 2026-09-30 (TASK-0056b). prompt_json is a SECOND copy of the key:
    -- on Production, 212 published versions carried the exact canonical_answer_1
    -- string and 46 the explanation, while 20260930120200 granted the column and
    -- 20260930120100 projected it into public.content_item_versions. The list
    -- below is a deny-list and could not see it; the content scan at the end of
    -- this file is what would have.
    ('app.content_item_versions', 'prompt_json')
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

-- ---------------------------------------------------------------------------
-- Content scan (added 2026-09-30, TASK-0056b).
--
-- The list above is a deny-list: it sees only columns someone remembered to
-- add, which is why it returned zero rows on both environments while
-- prompt_json was handing the key to every signed-in student. This scan is
-- shaped the other way round -- it reads the DATA in any json column of the
-- content bank that anon or authenticated can select, and fails on
-- answer-shaped keys. A new carrier is caught without anyone editing this file.
--
-- Scoped to content-bank tables on purpose. Student-owned json (their own
-- response, their own grading result) is RLS-scoped and legitimately readable,
-- so scanning it would produce permanent noise and the guard would be ignored.
--
-- Run as a second statement, as postgres. A non-empty result is a violation.
-- Must be run against PRODUCTION data: Dev's prompt_json held no answers, which
-- is exactly why the Dev matrix could not fail.
-- ---------------------------------------------------------------------------

-- No ON COMMIT DROP. CI runs this file with `psql -f` in autocommit, so every
-- top-level statement is its own transaction: an ON COMMIT DROP table would be
-- dropped the instant this CREATE commits, and the DO block below would fail
-- with "relation ... does not exist" on every run. A plain temporary table
-- lives for the whole session, so it survives the CREATE, the DO block and the
-- final SELECT. The DROP keeps a re-run inside one psql session from colliding,
-- and is pg_temp-qualified so it can never touch a permanent table of the same
-- name when this is run as postgres.
-- Caught by review on PR #299; the original passed a batched test only because
-- that harness wrapped all three statements in one implicit transaction.
drop table if exists pg_temp.answer_key_content_scan;
create temporary table answer_key_content_scan(
  table_schema text, table_name text, column_name text,
  matched_key text, rows_affected bigint
);

do $scan$
declare
  r record;
  k text;
  n bigint;
  -- Key names that carry an answer, a rubric, or a worked solution.
  keys text[] := array[
    'canonical_answer', 'is_correct', 'correct_choice', 'answer_key',
    'rationale', 'minimum_fix', 'accepted_variants', 'evidence_requirements',
    'worked_solution', 'scoring_contract', 'criteria'
  ];
begin
  for r in
    select c.table_schema, c.table_name, c.column_name
    from information_schema.columns c
    where c.data_type in ('json','jsonb')
      and c.table_schema in ('app','public')
      -- Content bank only; student-owned rows are excluded by design (above).
      and (c.table_name like 'content\_%' or c.table_name like 'frq\_%'
           or c.table_name like 'mcq\_%' or c.table_name like 'gold\_set%'
           or c.table_name in ('questions','topic_explainers','topic_point_briefs'))
      and exists (
        select 1 from information_schema.column_privileges g
        where g.table_schema = c.table_schema and g.table_name = c.table_name
          and g.column_name = c.column_name and g.privilege_type = 'SELECT'
          and g.grantee in ('anon','authenticated'))
  loop
    foreach k in array keys loop
      begin
        execute format(
          'select count(*) from %I.%I where %I::text ~ %L',
          r.table_schema, r.table_name, r.column_name, '"' || k
        ) into n;
      exception when others then
        n := 0;  -- unreadable relation: the deny-list above covers those
      end;
      if n > 0 then
        insert into answer_key_content_scan
        values (r.table_schema, r.table_name, r.column_name, k, n);
      end if;
    end loop;
  end loop;
end
$scan$;

select table_schema, table_name, column_name, matched_key, rows_affected,
       'answer-shaped key readable by anon/authenticated in content-bank json; '
       'revoke the column or remove the key at publish time' as finding
from answer_key_content_scan
order by rows_affected desc, table_schema, table_name, column_name, matched_key;
