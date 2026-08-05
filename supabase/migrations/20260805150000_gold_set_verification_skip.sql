-- Reviewer skip: gold_set_verification_next(p_exclude_ids) lets the frontend
-- ask for the next pending item OTHER than ones already shown this session,
-- without touching status/marks (skip is navigation, not a decision — unlike
-- submit or flagged_contaminated, which both write).
--
-- p_exclude_ids over a seq cursor: admin-mode ordering is
-- (is-someone-else's-item, assigned_at, seq), not a single ascending integer
-- — seq only resets to 1 within each reviewer's own queue, so "seq > N" is
-- meaningless once pulling from the shared cross-reviewer pool. An
-- exclude-list works regardless of ordering scheme and trivially supports
-- "return to top" (frontend just clears its local exclude set and re-fetches
-- with p_exclude_ids = '{}', which reproduces the original first-in-order
-- item since nothing server-side changed).
--
-- Dropped rather than replaced: adding a defaulted parameter to an existing
-- zero-arg function creates a second overload, and a no-arg call becomes
-- ambiguous between the two (the exact issue 20260803200000_gold_set_admin_
-- scope.sql already hit and documented for gold_set_verification_progress).

begin;

drop function if exists public.gold_set_verification_next();

create or replace function public.gold_set_verification_next(
  p_exclude_ids uuid[] default '{}'::uuid[]
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
    and not (a.gold_set_verification_assignment_id
      = any(coalesce(p_exclude_ids, '{}'::uuid[])))
  order by
    (a.reviewer_id <> v_user_id),
    a.assigned_at,
    a.seq
  limit 1;

  return v_result;
end;
$$;

revoke all on function public.gold_set_verification_next(uuid[]) from public, anon;
grant execute on function public.gold_set_verification_next(uuid[]) to authenticated;

commit;
