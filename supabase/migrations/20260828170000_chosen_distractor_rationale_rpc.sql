-- Narrow, post-grade-only distractor rationale for Course Mode repair.
--
-- PR #106 revoked authenticated column SELECT on app.mcq_choices.is_correct /
-- .rationale (migrations 20260824040000 / 20260824060000 / 20260827010000)
-- because either column, read broadly, is an answer-key leak: rationale text
-- on a distractor lets a student find the correct choice by elimination
-- before ever answering.
--
-- The Course Mode repair panel (CourseModeRepairPanel / RepairBlock) wants to
-- show "why the choice you picked doesn't hold up" after a miss. That is safe
-- ONLY under three conditions, all enforced server-side here rather than left
-- to the client:
--   1. the requesting user owns the attempt;
--   2. the attempt is already GRADED -- never before the real verdict has
--      rendered (this must never become a side channel for the verdict
--      itself, or for whether the pick was even wrong);
--   3. the requested choice is confirmed, server-side, to be the WRONG
--      choice on THIS item -- never any other choice's rationale, and never
--      exposed alongside is_correct for the full choice set.
--
-- This is deliberately narrower than public.get_review_mcq_choices (which
-- serves the full answer key to an assigned reviewer): it returns one
-- distractor's rationale text, for one already-graded-incorrect attempt, and
-- nothing else.

begin;

create or replace function public.get_chosen_distractor_rationale(
  p_attempt_id uuid,
  p_choice_id uuid
)
returns text
language plpgsql
stable
security definer
set search_path = pg_catalog
as $$
declare
  v_user_id uuid := auth.uid();
  v_content_item_version_id uuid;
  v_status text;
  v_rationale text;
begin
  if v_user_id is null then
    raise exception 'not_authenticated' using errcode = '28000';
  end if;
  if p_attempt_id is null or p_choice_id is null then
    raise exception 'distractor_rationale:missing_identity' using errcode = '22023';
  end if;

  select a.content_item_version_id, a.status
  into v_content_item_version_id, v_status
  from app.attempts a
  where a.id = p_attempt_id
    and a.user_id = v_user_id;

  if v_content_item_version_id is null then
    -- No such attempt, or it isn't this user's. Same response either way.
    return null;
  end if;

  -- Never before the real grade has landed -- this function is not a way to
  -- learn the verdict early.
  if v_status <> 'graded' then
    return null;
  end if;

  select mc.rationale
  into v_rationale
  from app.mcq_choices mc
  where mc.id = p_choice_id
    and mc.content_item_version_id = v_content_item_version_id
    and mc.is_correct = false
  limit 1;

  return v_rationale;
end;
$$;

revoke all on function public.get_chosen_distractor_rationale(uuid, uuid)
  from public, anon;
grant execute on function public.get_chosen_distractor_rationale(uuid, uuid)
  to authenticated, service_role;

comment on function public.get_chosen_distractor_rationale(uuid, uuid) is
  'Course Mode repair: the authored rationale for ONE distractor the caller '
  'actually picked, on ONE attempt the caller owns, ONLY once that attempt '
  'is graded and ONLY when the requested choice is confirmed wrong for that '
  'item server-side. Never returns is_correct or any other choice''s '
  'rationale -- narrower than public.get_review_mcq_choices by design, to '
  'avoid reopening the PR #106 answer-key leak.';

commit;
