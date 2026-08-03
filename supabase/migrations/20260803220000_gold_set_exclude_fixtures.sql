-- Keep QA fixtures out of the admin aggregate views.
--
-- QA seeds throwaway answers to exercise the verification screen. They are real
-- rows to their owner — the tester must see their own queue and progress — but
-- they must never inflate the numbers an admin reads as the state of the
-- certification. David saw "48 assignments" when the real corpus was 40.
--
-- Marked with an explicit column rather than matched on the 'QAFIXTURE' string.
-- A boolean states the intent at the row level and survives someone tagging a
-- future fixture differently; inferring it from a hash value would not.
--
-- Scope rule: fixtures are visible to their owner, invisible in aggregate.
--   caller-scoped progress -> includes fixtures (the tester needs 0 of 8)
--   admin all-scope progress -> excludes them
--   admin overview          -> excludes them

begin;

alter table app.gold_set_answers
  add column if not exists is_fixture boolean not null default false;

comment on column app.gold_set_answers.is_fixture is
  'QA scaffolding, not part of any gold set. Excluded from admin aggregate views; '
  'still visible to the reviewer it is assigned to.';

-- Backfill the fixtures seeded on 2026-08-03.
update app.gold_set_answers
set is_fixture = true
where item_content_hash = 'QAFIXTURE' or script_hash = 'QAFIXTURE';

create index if not exists gold_set_answers_real_idx
  on app.gold_set_answers (gold_set_answer_id) where not is_fixture;

create or replace function public.gold_set_verification_progress(
  p_all_reviewers boolean default false
)
returns jsonb
language plpgsql
stable
security definer
set search_path = pg_catalog
as $$
declare
  v_user_id uuid := auth.uid();
  v_is_admin boolean;
  v_all boolean;
  v_done integer;
  v_total integer;
begin
  if v_user_id is null then
    raise exception 'not_authenticated' using errcode = '28000';
  end if;

  select exists (
    select 1 from app.profiles p where p.user_id = v_user_id and p.role = 'admin'
  ) into v_is_admin;

  v_all := coalesce(p_all_reviewers, false) and v_is_admin;

  select count(*) filter (where a.status <> 'pending'), count(*)
  into v_done, v_total
  from app.gold_set_verification_assignments a
  join app.gold_set_answers ans on ans.gold_set_answer_id = a.gold_set_answer_id
  where (
    -- Own queue: everything, fixtures included, so a QA tester sees their own work.
    a.reviewer_id = v_user_id
    -- Aggregate: real corpus only.
    or (v_all and not ans.is_fixture)
  );

  return jsonb_build_object(
    'done', coalesce(v_done, 0),
    'total', coalesce(v_total, 0),
    'scope', case when v_all then 'all' else 'mine' end
  );
end;
$$;

revoke all on function public.gold_set_verification_progress(boolean) from public, anon;
grant execute on function public.gold_set_verification_progress(boolean) to authenticated;

create or replace function public.gold_set_admin_overview()
returns jsonb
language plpgsql
stable
security definer
set search_path = pg_catalog
as $$
declare
  v_user_id uuid := auth.uid();
begin
  if v_user_id is null then
    raise exception 'not_authenticated' using errcode = '28000';
  end if;
  if not exists (
    select 1 from app.profiles p where p.user_id = v_user_id and p.role = 'admin'
  ) then
    raise exception 'not_authorized' using errcode = '42501';
  end if;

  return jsonb_build_object(
    'by_reviewer', coalesce((
      select jsonb_agg(x order by x->>'reviewer_name')
      from (
        select jsonb_build_object(
          'reviewer_name', p.full_name,
          'total', count(*),
          'pending', count(*) filter (where a.status = 'pending'),
          'submitted', count(*) filter (where a.status = 'submitted'),
          'flagged', count(*) filter (where a.status = 'flagged_contaminated'),
          'last_submitted_at', max(a.submitted_at)
        ) as x
        from app.gold_set_verification_assignments a
        join app.gold_set_answers ans on ans.gold_set_answer_id = a.gold_set_answer_id
        join app.profiles p on p.user_id = a.reviewer_id
        where not ans.is_fixture
        group by p.full_name
      ) s), '[]'::jsonb),
    'assignments', coalesce((
      select jsonb_agg(y order by y->>'reviewer_name', (y->>'seq')::int)
      from (
        select jsonb_build_object(
          'reviewer_name', p.full_name,
          'content_key', ci.content_key,
          'seq', a.seq,
          'status', a.status,
          'submitted_at', a.submitted_at,
          'marks_recorded', (
            select count(*) from app.gold_set_element_marks m
            where m.gold_set_verification_assignment_id
                = a.gold_set_verification_assignment_id)
        ) as y
        from app.gold_set_verification_assignments a
        join app.gold_set_answers ans on ans.gold_set_answer_id = a.gold_set_answer_id
        join app.profiles p on p.user_id = a.reviewer_id
        join app.content_item_versions civ on civ.id = ans.content_item_version_id
        join app.content_items ci on ci.id = civ.content_item_id
        where not ans.is_fixture
      ) t), '[]'::jsonb)
  );
end;
$$;

revoke all on function public.gold_set_admin_overview() from public, anon;
grant execute on function public.gold_set_admin_overview() to authenticated;

commit;
