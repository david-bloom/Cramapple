-- Open Hand is a sanctioned full-answer-key teaching mode. Calling this RPC
-- permanently excludes the disclosed item version from scored use for the
-- caller, without weakening the ordinary student answer-key boundary.

begin;

create table app.open_hand_scoring_exclusions (
  user_id uuid not null references auth.users(id) on delete cascade,
  content_item_version_id uuid not null
    references app.content_item_versions(id) on delete cascade,
  learning_session_id uuid not null
    references app.learning_sessions(id) on delete restrict,
  disclosed_at timestamptz not null default now(),
  primary key (user_id, content_item_version_id)
);

comment on table app.open_hand_scoring_exclusions is
  'Permanent per-user, per-content-version scoring exclusions created '
  'atomically when get_open_hand_item discloses an answer key. '
  'evaluate-attempt rejects matching attempts with HTTP 409 and '
  'error=open_hand_item_not_scorable before reading answer-key tables.';

alter table app.open_hand_scoring_exclusions enable row level security;
alter table app.open_hand_scoring_exclusions force row level security;

revoke all on app.open_hand_scoring_exclusions
  from public, anon, authenticated;
grant select on app.open_hand_scoring_exclusions to service_role;

create or replace function public.get_open_hand_item(
  p_learning_session_id uuid,
  p_content_item_version_id uuid
)
returns jsonb
language plpgsql
volatile
security definer
set search_path = pg_catalog
as $$
declare
  v_user_id uuid := auth.uid();
  v_exam_pack_version_id uuid;
  v_item_type text;
  v_canonical_answer_1 text;
  v_canonical_answer_2 text;
  v_result jsonb;
begin
  if v_user_id is null then
    raise exception 'not_authenticated' using errcode = '28000';
  end if;

  if p_learning_session_id is null or p_content_item_version_id is null then
    raise exception 'open_hand:missing_identity' using errcode = '22023';
  end if;

  -- Mirror student-session-items' first gate: the session must exist, be
  -- active, and belong to the caller. Deliberately no admin bypass: Open Hand
  -- disclosure and its permanent exclusion are always student-owned.
  select ls.exam_pack_version_id
  into v_exam_pack_version_id
  from app.learning_sessions ls
  where ls.id = p_learning_session_id
    and ls.user_id = v_user_id
    and ls.status = 'active';

  if v_exam_pack_version_id is null then
    raise exception 'open_hand:session_not_accessible' using errcode = '42501';
  end if;

  -- Ordinary student-session-items queues are selected at request time and
  -- are not persisted item-by-item. The faithful database-level equivalent
  -- is therefore an owned active session plus a published item/version in
  -- that session's exact exam pack.
  select ci.item_type, civ.canonical_answer_1, civ.canonical_answer_2
  into v_item_type, v_canonical_answer_1, v_canonical_answer_2
  from app.content_item_versions civ
  join app.content_items ci on ci.id = civ.content_item_id
  where civ.id = p_content_item_version_id
    and civ.status = 'published'
    and ci.status = 'published'
    and ci.exam_pack_version_id = v_exam_pack_version_id;

  if v_item_type is null then
    raise exception 'open_hand:item_not_accessible' using errcode = '42501';
  end if;

  insert into app.open_hand_scoring_exclusions (
    user_id,
    content_item_version_id,
    learning_session_id
  ) values (
    v_user_id,
    p_content_item_version_id,
    p_learning_session_id
  )
  on conflict (user_id, content_item_version_id) do nothing;

  select jsonb_build_object(
    'content_item_version_id', p_content_item_version_id,
    'item_type', v_item_type,
    'scoring_eligible', false,
    'canonical_answers', jsonb_strip_nulls(jsonb_build_object(
      'answer_1', v_canonical_answer_1,
      'answer_2', v_canonical_answer_2
    )),
    'mcq_choices', coalesce((
      select jsonb_agg(
        jsonb_build_object(
          'choice_key', mc.choice_key,
          'choice_text', mc.choice_text,
          'is_correct', mc.is_correct,
          'rationale', mc.rationale,
          -- O9: avoid a new authoring requirement. The authored rationale is
          -- also the Open Hand per-choice correction line.
          'minimum_fix', mc.rationale
        ) order by mc.choice_key
      )
      from app.mcq_choices mc
      where mc.content_item_version_id = p_content_item_version_id
    ), '[]'::jsonb),
    'frq_criteria', coalesce((
      select jsonb_agg(
        jsonb_build_object(
          'criterion_key', fc.criterion_key,
          'learner_facing_text', fc.learner_facing_text,
          'points_possible', fc.points_possible,
          'evidence_requirements', fc.evidence_requirements,
          'accepted_variants', fc.accepted_variants,
          'minimum_fix', fc.minimum_fix
        ) order by fc.criterion_key
      )
      from app.frq_criteria fc
      where fc.content_item_version_id = p_content_item_version_id
    ), '[]'::jsonb)
  )
  into v_result;

  return v_result;
end;
$$;

revoke all on function public.get_open_hand_item(uuid, uuid)
  from public, anon;
grant execute on function public.get_open_hand_item(uuid, uuid)
  to authenticated, service_role;

comment on function public.get_open_hand_item(uuid, uuid) is
  'Returns the full MCQ/FRQ key only for a published item in an active '
  'learning session owned by auth.uid(). In the same transaction, '
  'idempotently records a permanent (user, content item version) scoring '
  'exclusion. MCQ minimum_fix intentionally derives from rationale (O9). '
  'Matching evaluate-attempt calls hard-reject with HTTP 409 and '
  'open_hand_item_not_scorable.';

commit;
