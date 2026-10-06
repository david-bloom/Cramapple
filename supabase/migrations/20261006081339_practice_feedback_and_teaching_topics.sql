-- TASK-0064 / QA 2026-10-06 (B2, B3). Two read-only RPCs for the plate loop.
--
-- 1. public.get_graded_mcq_feedback(p_attempt_id): after a student's MCQ
--    attempt has been SUBMITTED and GRADED, return every choice with its
--    correct mark and rationale so Practice can show the answer. Gated on:
--    caller owns the attempt; the item is an MCQ; attempts.submitted_at is not
--    null; a grading_results row exists. Draft (pre-warmed) attempts therefore
--    cannot be used as an answer-key oracle. Post-submission disclosure is the
--    intended path under TASK-0056. Writes nothing (David, 2026-10-06: seeing
--    the answer after grading does not block re-serving).
-- 2. public.get_open_hand_teaching_topics(p_subject_key): topic codes that
--    currently have an active Open Hand teaching item for a subject, so the
--    client can find the next worked example without probing every topic.
--    Topic codes only, no item content; entitlement-scoped like the item RPC.

create or replace function public.get_graded_mcq_feedback(p_attempt_id uuid)
returns jsonb
language plpgsql
stable
security definer
set search_path = pg_catalog
as $$
declare
  v_user_id uuid := auth.uid();
  v_civ_id uuid;
  v_item_type text;
  v_submitted timestamptz;
  v_earned int;
  v_possible int;
  v_picked text;
begin
  if v_user_id is null then
    raise exception 'not_authenticated' using errcode = '28000';
  end if;

  select a.content_item_version_id, ci.item_type, a.submitted_at
    into v_civ_id, v_item_type, v_submitted
  from app.attempts a
  join app.content_item_versions civ on civ.id = a.content_item_version_id
  join app.content_items ci on ci.id = civ.content_item_id
  where a.id = p_attempt_id and a.user_id = v_user_id;

  if v_civ_id is null or v_item_type <> 'mcq' then
    raise exception 'feedback:not_found' using errcode = '42501';
  end if;

  select gr.points_earned, gr.points_available
    into v_earned, v_possible
  from app.grading_results gr
  where gr.attempt_id = p_attempt_id
  order by gr.created_at desc
  limit 1;

  if v_submitted is null or v_possible is null then
    raise exception 'feedback:not_graded' using errcode = '42501';
  end if;

  -- The submitted answer lives on response_versions (save_response /
  -- submit_response); attempt_responses is the older per-part store.
  select rv.response_text into v_picked
  from app.response_versions rv
  where rv.attempt_id = p_attempt_id and rv.is_submitted is true
  order by rv.submitted_at desc nulls last, rv.version_number desc
  limit 1;
  if v_picked is null then
    select ar.response_text into v_picked
    from app.attempt_responses ar
    where ar.attempt_id = p_attempt_id
    order by ar.updated_at desc nulls last, ar.created_at desc
    limit 1;
  end if;

  return jsonb_build_object(
    'attempt_id', p_attempt_id,
    'content_item_version_id', v_civ_id,
    'picked_choice_key', v_picked,
    'earned', v_earned,
    'possible', v_possible,
    'choices', coalesce((
      select jsonb_agg(jsonb_build_object(
        'choice_key', mc.choice_key,
        'choice_text', mc.choice_text,
        'is_correct', mc.is_correct,
        'rationale', mc.rationale) order by mc.choice_key)
      from app.mcq_choices mc where mc.content_item_version_id = v_civ_id
    ), '[]'::jsonb)
  );
end;
$$;

revoke all on function public.get_graded_mcq_feedback(uuid) from public, anon;
grant execute on function public.get_graded_mcq_feedback(uuid) to authenticated, service_role;

create or replace function public.get_open_hand_teaching_topics(p_subject_key text)
returns text[]
language plpgsql
stable
security definer
set search_path = pg_catalog
as $$
declare
  v_user_id uuid := auth.uid();
  v_role text;
  v_subject_id uuid;
begin
  if v_user_id is null then
    raise exception 'not_authenticated' using errcode = '28000';
  end if;
  select s.id into v_subject_id from app.subjects s
  where s.subject_key = p_subject_key and s.status = 'active';
  if v_subject_id is null then
    raise exception 'open_hand:item_not_accessible' using errcode = '42501';
  end if;
  select p.role into v_role from app.profiles p where p.user_id = v_user_id;
  if not (coalesce(v_role, '') = any (array['admin', 'content_author', 'tutor', 'reader', 'validator']))
     and not exists (
       select 1 from app.subject_entitlements se
       where se.user_id = v_user_id and se.status = 'active'
         and (se.all_subjects is true or se.subject_id = v_subject_id)
         and (se.starts_at is null or se.starts_at <= now())
         and (se.ends_at is null or se.ends_at > now())
     ) then
    raise exception 'open_hand:entitlement_required' using errcode = '42501';
  end if;

  return coalesce((
    select array_agg(distinct t.topic_code order by t.topic_code)
    from app.open_hand_teaching_items t
    join app.content_items ci on ci.id = t.content_item_id
    join app.exam_pack_versions epv on epv.id = ci.exam_pack_version_id
    join app.exam_packs ep on ep.id = epv.exam_pack_id
    where t.released_at is null and ep.subject_id = v_subject_id
      and ci.status = 'published' and epv.status = 'published' and epv.retired_at is null
  ), array[]::text[]);
end;
$$;

revoke all on function public.get_open_hand_teaching_topics(text) from public, anon;
grant execute on function public.get_open_hand_teaching_topics(text) to authenticated, service_role;
