-- True Review-Tasks parity for gold-set: an admin can open and complete ANY
-- pending gold-set assignment, not just their own, matching review-decision's
-- admin bypass (supabase/functions/review-decision/index.ts:353 — role='admin'
-- overrides the reviewer_id === caller check).
--
-- 20260803200000_gold_set_admin_scope.sql deliberately did NOT widen `next`/
-- `submit`, on the reasoning that doing so "can only end in a submit error —
-- or, if submit were loosened to match, in an admin marking answers the
-- certification records as Jill's independent cold reading. That would swap
-- the reader out of the measurement silently."
--
-- David Bloom (product owner, admin) explicitly requested this after being
-- shown that exact tradeoff (2026-08-05): he wants to be able to clear any
-- pending gold-set item himself, same as he already can on Review Tasks.
--
-- The mitigation: `reviewer_id` stays the originally assigned reviewer
-- (Jill's items keep saying Jill), but every submit now also stamps
-- `completed_by` with whoever actually clicked submit. So the "silent swap"
-- the old comment warned about is no longer silent — gold_set_admin_overview
-- surfaces completed_by, so anyone auditing the corpus can see and exclude
-- admin-completed items from an inter-rater measurement if that matters for
-- a given analysis, instead of the substitution being invisible.

begin;

alter table app.gold_set_verification_assignments
  add column completed_by uuid references app.profiles(user_id);

comment on column app.gold_set_verification_assignments.completed_by is
  'Who actually submitted the marks. Usually equals reviewer_id; differs when '
  'an admin completed someone else''s assignment via the CC-marking path.';

-- ── next(): admins draw from the full pending pool, not just their own ────────

create or replace function public.gold_set_verification_next()
returns jsonb
language plpgsql
stable
security definer
set search_path = pg_catalog
as $$
declare
  v_user_id uuid := auth.uid();
  v_is_admin boolean;
  v_result jsonb;
begin
  if v_user_id is null then
    raise exception 'not_authenticated' using errcode = '28000';
  end if;

  if not app.gold_set_reader_is_eligible(v_user_id) then
    raise exception 'not_authorized' using errcode = '42501';
  end if;

  select exists (
    select 1 from app.profiles p where p.user_id = v_user_id and p.role = 'admin'
  ) into v_is_admin;

  select jsonb_build_object(
    'assignment_id', a.gold_set_verification_assignment_id,
    'seq', a.seq,
    'stem', civ.stem,
    'stimulus', civ.stimulus,
    'stimulus_image_path', civ.stimulus_image_path,
    'parts', coalesce(
      (
        select jsonb_agg(
          jsonb_build_object(
            'part_key', p.part ->> 'part_key',
            'prompt_text', p.part ->> 'prompt_text'
          )
          order by p.ord
        )
        from jsonb_array_elements(civ.prompt_json -> 'parts') with ordinality as p(part, ord)
      ),
      '[]'::jsonb
    ),
    'answer_text', ans.answer_text,
    'elements', coalesce(
      (
        select jsonb_agg(
          jsonb_build_object(
            'element_id', e.gold_set_element_id,
            'criterion_key', fc.criterion_key,
            'element_label', e.element_label,
            'element_index', e.element_index
          )
          order by fc.criterion_key, e.element_index
        )
        from app.gold_set_elements e
        join app.frq_criteria fc on fc.id = e.frq_criterion_id
        where e.content_item_version_id = ans.content_item_version_id
      ),
      '[]'::jsonb
    )
  )
  into v_result
  from app.gold_set_verification_assignments a
  join app.gold_set_answers ans
    on ans.gold_set_answer_id = a.gold_set_answer_id
  join app.content_item_versions civ
    on civ.id = ans.content_item_version_id
  where a.status = 'pending'
    and (v_is_admin or a.reviewer_id = v_user_id)
  order by
    -- Prefer a caller's own queue first even in admin mode, so an admin who
    -- also carries personal assignments finishes those before dipping into
    -- the shared pool.
    (a.reviewer_id <> v_user_id),
    a.assigned_at,
    a.seq
  limit 1;

  return v_result;
end;
$$;

-- ── submit(): admin may close an assignment that isn't their own ──────────────

create or replace function public.submit_gold_set_verification(
  p_assignment_id uuid,
  p_marks jsonb,
  p_flagged_contaminated boolean default false
)
returns jsonb
language plpgsql
security definer
set search_path = pg_catalog
as $$
declare
  v_user_id uuid := auth.uid();
  v_is_admin boolean;
  v_assignment app.gold_set_verification_assignments%rowtype;
  v_version_id uuid;
  v_expected_elements integer;
  v_supplied_elements integer;
  v_status text;
begin
  if v_user_id is null then
    raise exception 'not_authenticated' using errcode = '28000';
  end if;

  select exists (
    select 1 from app.profiles p where p.user_id = v_user_id and p.role = 'admin'
  ) into v_is_admin;

  select * into v_assignment
  from app.gold_set_verification_assignments
  where gold_set_verification_assignment_id = p_assignment_id
  for update;

  if not found then
    raise exception 'assignment_not_found' using errcode = 'P0002';
  end if;

  if v_assignment.reviewer_id <> v_user_id and not v_is_admin then
    raise exception 'not_authorized' using errcode = '42501';
  end if;

  if v_assignment.status <> 'pending' then
    return jsonb_build_object(
      'status', 'already_submitted',
      'assignment_id', p_assignment_id
    );
  end if;

  if jsonb_typeof(p_marks) <> 'array' then
    raise exception 'invalid_marks' using errcode = '22023';
  end if;

  select ans.content_item_version_id into v_version_id
  from app.gold_set_answers ans
  where ans.gold_set_answer_id = v_assignment.gold_set_answer_id;

  v_status := case
    when p_flagged_contaminated then 'flagged_contaminated'
    else 'submitted'
  end;

  if not p_flagged_contaminated then
    select count(*) into v_expected_elements
    from app.gold_set_elements
    where content_item_version_id = v_version_id;

    if v_expected_elements = 0 then
      raise exception 'no_elements_seeded'
        using errcode = '23514',
              detail = 'This item has no gold_set_elements; seed them before verification.';
    end if;

    select count(*) into v_supplied_elements
    from jsonb_array_elements(p_marks) m
    where (m ->> 'element_id') is not null;

    if v_supplied_elements <> v_expected_elements then
      raise exception 'incomplete_marks'
        using errcode = '23514',
              detail = format(
                'expected %s element marks, received %s',
                v_expected_elements, v_supplied_elements
              );
    end if;
  end if;

  insert into app.gold_set_element_marks (
    gold_set_verification_assignment_id,
    gold_set_element_id,
    present,
    evidence_quote
  )
  select
    p_assignment_id,
    (m ->> 'element_id')::uuid,
    (m ->> 'present')::boolean,
    nullif(btrim(coalesce(m ->> 'evidence_quote', '')), '')
  from jsonb_array_elements(p_marks) m
  where (m ->> 'element_id') is not null;

  if exists (
    select 1
    from app.gold_set_element_marks mk
    join app.gold_set_elements e
      on e.gold_set_element_id = mk.gold_set_element_id
    where mk.gold_set_verification_assignment_id = p_assignment_id
      and e.content_item_version_id is distinct from v_version_id
  ) then
    raise exception 'element_item_mismatch' using errcode = '23514';
  end if;

  update app.gold_set_verification_assignments
  set status = v_status,
      submitted_at = pg_catalog.now(),
      completed_by = v_user_id
  where gold_set_verification_assignment_id = p_assignment_id;

  return jsonb_build_object(
    'status', v_status,
    'assignment_id', p_assignment_id
  );
end;
$$;

-- ── admin_overview(): surface who actually completed each item ────────────────

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
          'completed_by_name', cb.full_name,
          'marks_recorded', (
            select count(*) from app.gold_set_element_marks m
            where m.gold_set_verification_assignment_id
                = a.gold_set_verification_assignment_id)
        ) as y
        from app.gold_set_verification_assignments a
        join app.profiles p on p.user_id = a.reviewer_id
        left join app.profiles cb on cb.user_id = a.completed_by
        join app.gold_set_answers ans on ans.gold_set_answer_id = a.gold_set_answer_id
        join app.content_item_versions civ on civ.id = ans.content_item_version_id
        join app.content_items ci on ci.id = civ.content_item_id
      ) t), '[]'::jsonb)
  );
end;
$$;

commit;
