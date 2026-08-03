-- Admin all-reviewer scope for the gold set, matching Review tasks' CC mode.
--
-- The reviewer portal already asks for this: rpcScoped() sends
-- p_all_reviewers:true for admins and falls back to a caller-scoped call when
-- the function has no such parameter. Both functions took no arguments, so the
-- fallback fired every time — an admin silently saw only their own assignments
-- (i.e. none), and every progress call burned two 404s discovering that.
--
-- WHAT WIDENS, AND WHAT DELIBERATELY DOES NOT.
--
--   progress  -> widens. Aggregate counts across every reviewer are useful
--                oversight and leak nothing.
--   overview  -> new. The "all gold-set assignments" list, the analogue of the
--                owner-labelled Review queue.
--   next      -> does NOT widen, and must not.
--
-- next is the marking flow, not a browse view. submit_gold_set_verification is
-- bound to the assignment's own reviewer, so serving an admin someone else's
-- next answer can only end in a submit error — or, if submit were loosened to
-- match, in an admin marking answers the certification records as Jill's
-- independent cold reading. That would swap the reader out of the measurement
-- silently, which is the one failure this whole programme is built to prevent.
-- Admins get full visibility instead, which is what was actually asked for.
--
-- The overview projects metadata only: no answer_text, no script, no route, no
-- writer_family, and no answer_type. answer_type is withheld because it encodes
-- the expected pattern ("A1" means all elements present), and an admin who may
-- later verify must not have seen it.

begin;

-- Dropped rather than replaced: adding a defaulted parameter creates a second
-- overload, and a no-arg call would then be ambiguous between the two.
drop function if exists public.gold_set_verification_progress();

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

  -- Scope widening is granted by the server, never by the caller's assertion.
  v_all := coalesce(p_all_reviewers, false) and v_is_admin;

  select count(*) filter (where status <> 'pending'), count(*)
  into v_done, v_total
  from app.gold_set_verification_assignments
  where v_all or reviewer_id = v_user_id;

  return jsonb_build_object(
    'done', coalesce(v_done, 0),
    'total', coalesce(v_total, 0),
    'scope', case when v_all then 'all' else 'mine' end
  );
end;
$$;

revoke all on function public.gold_set_verification_progress(boolean) from public, anon;
grant execute on function public.gold_set_verification_progress(boolean) to authenticated;

-- The all-assignments list. Admin only.
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
        join app.profiles p on p.user_id = a.reviewer_id
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
        join app.profiles p on p.user_id = a.reviewer_id
        join app.gold_set_answers ans on ans.gold_set_answer_id = a.gold_set_answer_id
        join app.content_item_versions civ on civ.id = ans.content_item_version_id
        join app.content_items ci on ci.id = civ.content_item_id
      ) t), '[]'::jsonb)
  );
end;
$$;

revoke all on function public.gold_set_admin_overview() from public, anon;
grant execute on function public.gold_set_admin_overview() to authenticated;

commit;
