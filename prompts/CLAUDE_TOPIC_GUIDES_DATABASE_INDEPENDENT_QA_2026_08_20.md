# Claude Execution Prompt - Topic Guides Database Independent QA

Repo: `Cramapple`

Production Supabase project: `pcntajvbdfqhbeewmdry`
Development Supabase project: `wmgjsdkphcyhngaffbqf`

## What This Is

Independent QA for the database changes behind the new student Home topic-guide content:

- Topic Point Briefs
- Topic Explainers / Learn More content
- Lovable-facing public read views
- authenticated RPCs for taxonomy and topic guides

The frontend symptom that prompted this pass was Lovable reporting `PGRST205` for:

- `public.topic_point_briefs`
- `public.topic_explainers`

Codex claims Production now has:

- `app.topic_point_briefs`: 23 rows
- `app.topic_explainers`: 16 rows
- `public.topic_point_briefs`: 23 rows
- `public.topic_explainers`: 16 rows
- Calc AB Unit 1: 16 briefs and 16 explainers
- Biology Unit 1: 7 briefs and 0 explainers
- `public.topic_point_briefs` and `public.topic_explainers` grant `SELECT` only to `authenticated` and `service_role`
- no `anon` access
- PostgREST schema cache was reloaded
- migration history contains `20260820192400 student_readable_taxonomy_and_topic_guides`

Do not trust those claims. Verify independently.

## Scope And Discipline

You are a reviewer, not an implementer.

Do not write code, apply migrations, repair migration history, update grants, deploy, push, or mutate persistent database state.

Allowed:

- read files
- run read-only SQL
- run the provided rollback-only QA script
- inspect Supabase migration history
- query Postgres metadata
- call REST endpoints with safe `GET`/`HEAD`-equivalent reads if you have the project URL and anon/publishable key

Disallowed:

- `insert`, `update`, `delete`, `truncate`, `drop`, `alter`, `create`, `grant`, `revoke`, `notify`, `supabase db push`, `supabase migration repair`
- any command that changes Production or Development state

If a provided script uses `begin`/`rollback`, review it first and confirm it only creates temp objects or uses transaction-local settings before running it.

## Read First

1. `supabase/migrations/20260820192400_student_readable_taxonomy_and_topic_guides.sql`
2. `supabase/tests/student_taxonomy_guides.integration.sql`
3. `scripts/qa/topic_guides_database_qa.sql`
4. `docs/product/AP_CALCULUS_UNIT1_TOPIC_POINT_BRIEFS.md`
5. `docs/product/AP_CALCULUS_UNIT1_TOPIC_EXPLAINERS.md`
6. `docs/product/AP_BIOLOGY_UNIT1_TOPIC_POINT_BRIEFS.md`

Important: `20260820201000_align_published_pack_subject_status.sql` was intentionally **not** applied to Production and has been retired from the active migration folder. Treat its absence from migration history as expected unless you find evidence otherwise.

## Part A - Production Object And Migration Verification

Run read-only checks against Production `pcntajvbdfqhbeewmdry`.

Verify:

1. Migration history includes `20260820192400 student_readable_taxonomy_and_topic_guides`.
2. Migration history does **not** include `20260820201000 align_published_pack_subject_status` unless someone applied it after Codex.
3. These relations exist:
   - `app.topic_point_briefs`
   - `app.topic_explainers`
   - `public.topic_point_briefs`
   - `public.topic_explainers`
4. `app.topic_point_briefs` and `app.topic_explainers` have RLS enabled.
5. Public relations are views, not writable base tables.

Suggested SQL:

```sql
select
  to_regclass('app.topic_point_briefs') as app_topic_point_briefs,
  to_regclass('app.topic_explainers') as app_topic_explainers,
  to_regclass('public.topic_point_briefs') as public_topic_point_briefs,
  to_regclass('public.topic_explainers') as public_topic_explainers;

select
  n.nspname as schema_name,
  c.relname,
  c.relkind,
  c.relrowsecurity,
  c.relforcerowsecurity
from pg_class c
join pg_namespace n on n.oid = c.relnamespace
where (n.nspname, c.relname) in (
  ('app', 'topic_point_briefs'),
  ('app', 'topic_explainers'),
  ('public', 'topic_point_briefs'),
  ('public', 'topic_explainers')
)
order by n.nspname, c.relname;
```

Expected:

- `app.*` objects exist as tables (`relkind = 'r'`) with RLS enabled and forced.
- `public.*` objects exist as views (`relkind = 'v'`).

## Part B - Lovable Public Read Surface

Verify the exact frontend-facing objects Lovable should query.

Suggested SQL:

```sql
select 'topic_point_briefs' as view_name, count(*)::int as row_count
from public.topic_point_briefs
union all
select 'topic_explainers' as view_name, count(*)::int as row_count
from public.topic_explainers
order by view_name;

select subject_key, unit_number, count(*)::int as brief_count
from public.topic_point_briefs
group by subject_key, unit_number
order by subject_key, unit_number;

select subject_key, unit_number, count(*)::int as explainer_count
from public.topic_explainers
group by subject_key, unit_number
order by subject_key, unit_number;
```

Expected:

- `public.topic_point_briefs`: 23 rows
- `public.topic_explainers`: 16 rows
- `ap_calculus_ab`, Unit 1: 16 briefs
- `ap_biology`, Unit 1: 7 briefs
- `ap_calculus_ab`, Unit 1: 16 explainers
- no Biology explainers yet

Also inspect a representative row shape:

```sql
select
  subject_key,
  unit_number,
  unit_id,
  topic_id,
  title,
  class_importance,
  exam_importance,
  learn_more_path,
  practice_params
from public.topic_point_briefs
where subject_key = 'ap_calculus_ab'
  and unit_number = 1
  and topic_id in ('1.1', '1.16')
order by topic_id;

select
  subject_key,
  unit_number,
  unit_id,
  topic_id,
  title,
  mini_example
from public.topic_explainers
where subject_key = 'ap_calculus_ab'
  and unit_number = 1
  and topic_id in ('1.1', '1.16')
order by topic_id;
```

Expected:

- `unit_id = 'unit-1'`
- `topic_id` matches the CED topic code
- `practice_params` has `subject`, `unit`, `topic`
- `mini_example` has `question`, `weakAnswer`, `pointAttainingAnswer`

## Part C - Grants And API Access Safety

Verify public views are authenticated-only and read-only.

Suggested SQL:

```sql
select grantee, table_schema, table_name, privilege_type
from information_schema.role_table_grants
where table_schema = 'public'
  and table_name in ('topic_point_briefs', 'topic_explainers')
  and grantee in ('anon', 'authenticated', 'service_role')
order by table_name, grantee, privilege_type;

select
  has_table_privilege('anon', 'public.topic_point_briefs', 'SELECT') as anon_briefs_select,
  has_table_privilege('anon', 'public.topic_explainers', 'SELECT') as anon_explainers_select,
  has_table_privilege('authenticated', 'public.topic_point_briefs', 'SELECT') as auth_briefs_select,
  has_table_privilege('authenticated', 'public.topic_explainers', 'SELECT') as auth_explainers_select,
  has_table_privilege('authenticated', 'public.topic_point_briefs', 'INSERT') as auth_briefs_insert,
  has_table_privilege('authenticated', 'public.topic_point_briefs', 'UPDATE') as auth_briefs_update,
  has_table_privilege('authenticated', 'public.topic_point_briefs', 'DELETE') as auth_briefs_delete,
  has_table_privilege('authenticated', 'public.topic_explainers', 'INSERT') as auth_explainers_insert,
  has_table_privilege('authenticated', 'public.topic_explainers', 'UPDATE') as auth_explainers_update,
  has_table_privilege('authenticated', 'public.topic_explainers', 'DELETE') as auth_explainers_delete;
```

Expected:

- `anon` has no privileges.
- `authenticated` has `SELECT`.
- `authenticated` does not have `INSERT`, `UPDATE`, or `DELETE`.
- `service_role` has `SELECT`.

## Part D - RPC Behavior

Verify these public RPCs exist:

- `public.get_student_taxonomy(text)`
- `public.get_topic_point_guides(text, integer, text)`

Suggested SQL:

```sql
select
  n.nspname as schema_name,
  p.proname,
  pg_get_function_identity_arguments(p.oid) as args,
  p.prosecdef as security_definer
from pg_proc p
join pg_namespace n on n.oid = p.pronamespace
where n.nspname = 'public'
  and p.proname in ('get_student_taxonomy', 'get_topic_point_guides')
order by p.proname, args;
```

Expected:

- both functions exist
- both are `security definer`

Then run the rollback-only QA script after reviewing it:

```bash
supabase db query --linked \
  --file scripts/qa/topic_guides_database_qa.sql \
  --workdir /Users/davidbloom/Documents/Cramapple
```

Expected:

- exit code 0
- no exception

If your Supabase CLI is linked to Development, do not relink Production unless explicitly allowed by the user. Use your connector or a read-only project selector if available. If you must relink temporarily for read-only QA, restore the previous link and report that you did so.

## Part E - PostgREST / Lovable Failure Mode

The original frontend issue was `PGRST205` for missing public objects in schema cache. Verify that condition is gone.

Minimum DB-side evidence:

- `to_regclass('public.topic_point_briefs')` returns non-null.
- `to_regclass('public.topic_explainers')` returns non-null.
- `select count(*) from public.topic_point_briefs` succeeds.
- `select count(*) from public.topic_explainers` succeeds.

If you have safe access to the Supabase REST API with the browser-safe publishable key, additionally perform authenticated-session-equivalent or service-side read checks. Do not expose secrets in the report.

## Part F - Content Spot Check

Verify content is not empty and is subject-specific.

Suggested SQL:

```sql
select topic_id, title, what_it_is, how_points_are_earned, answer_move
from public.topic_point_briefs
where subject_key = 'ap_calculus_ab'
  and unit_number = 1
order by topic_id
limit 3;

select topic_id, title, what_it_is, how_points_are_earned, answer_move
from public.topic_point_briefs
where subject_key = 'ap_biology'
  and unit_number = 1
order by topic_id
limit 3;
```

Expected:

- Calculus content talks about limits, continuity, asymptotes, IVT, or instant/average change.
- Biology content talks about water, elements, macromolecules, carbohydrates, lipids, nucleic acids, or proteins.
- It should not look like generic test-taking advice detached from the subject.

## Things To Try To Break

1. Query topic guides by exact public view names Lovable uses. Any `relation does not exist`, `schema cache`, or permission error is a blocker.
2. Check whether `anon` can read either view. If yes, serious security finding.
3. Check whether `authenticated` can write either view. If yes, serious access-control finding.
4. Check whether public views expose draft/retired rows. If yes, serious content lifecycle finding.
5. Check whether topic IDs sort lexicographically in a harmful way (`1.10` before `1.2`) in frontend-facing queries. DB views do not enforce order, so frontend must order numerically if needed; report as integration risk, not necessarily DB bug.
6. Check whether Development and Production diverge in a way that would confuse Lovable or local QA.

## Output Format

Lead with findings, ordered by severity.

For each finding include:

- severity: blocking / serious / lower
- evidence: query or file reference
- expected
- actual
- why it matters to Lovable or student Home

Then include:

1. Verdict: `pass`, `pass with risks`, or `fail`.
2. Production object/count summary.
3. Grant/RLS summary.
4. RPC summary.
5. Whether `20260820201000_align_published_pack_subject_status` remains absent from migration history, as expected.
6. Any follow-up recommendations for Codex or Lovable.

Do not fix anything. If you find a defect, stop at the report.
