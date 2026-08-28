-- Course Mode -- `/home` Learn-mode hero due-queue.
--
-- The "Start here" hero card on `/home` (TopicHome.tsx, `home3-hero
-- home3-start`) currently renders a literal "Your 12 minutes" / "3 questions
-- we picked for you right now" with a hardcoded three-item PLACEHOLDER_QUEUE
-- -- fabricated content, not backed by any student evidence. This migration
-- adds the read seam the hero needs to become honest: a coarse, due-cells-only
-- projection of app.student_cell_state (F2), the store that already tracks
-- per-(user x cell) tier, decay and due_reason (CM-D08).
--
-- INV-1 ("store fine, present coarse; never surface letter codes to
-- students") means this RPC returns topic/skill codes and the raw due_reason
-- enum, never the student-facing copy -- the plain-language skill name and
-- the honest due-reason sentence (COURSE_MODE_STUDENT_UX_INTEGRATION_SPEC.md
-- §3) are a presentation-layer concern, resolved client-side the same way
-- the existing Unit 1 skills rail already resolves cell identity to a name
-- (`findPilotSkillByCell` in stats-unit1-skills.ts).

begin;

create or replace function public.get_home_start_queue(
  _exam_pack_version_id uuid,
  _limit integer default 3
)
returns jsonb
language plpgsql
stable
security definer
set search_path = pg_catalog
as $$
declare
  v_user_id uuid := auth.uid();
  v_subject_id uuid;
  v_subject_key text;
  v_taxonomy_source_version uuid;
  v_limit integer := greatest(1, least(coalesce(_limit, 3), 10));
  v_payload jsonb;
begin
  if v_user_id is null then
    raise exception 'not_authenticated' using errcode = '28000';
  end if;
  if _exam_pack_version_id is null then
    raise exception 'home_start_queue:exam_pack_version_required' using errcode = '22023';
  end if;

  select ep.subject_id, s.subject_key
  into v_subject_id, v_subject_key
  from app.exam_pack_versions epv
  join app.exam_packs ep on ep.id = epv.exam_pack_id
  join app.subjects s on s.id = ep.subject_id
  where epv.id = _exam_pack_version_id
    and epv.status = 'published';

  if v_subject_key is null then
    raise exception 'home_start_queue:pack_not_found' using errcode = '22023';
  end if;

  -- Same entitlement gate as issue_session_target: only an active,
  -- currently-in-window subject entitlement can read its due queue.
  if not exists (
    select 1
    from app.subject_entitlements se
    where se.user_id = v_user_id
      and se.subject_id = v_subject_id
      and se.status = 'active'
      and se.starts_at <= now()
      and (se.ends_at is null or se.ends_at > now())
  ) then
    raise exception 'home_start_queue:unentitled' using errcode = '42501';
  end if;

  select tsv.taxonomy_source_version
  into v_taxonomy_source_version
  from app.taxonomy_source_versions tsv
  where tsv.subject_key = v_subject_key
    and tsv.taxonomy_confidence = 'verified'
  order by tsv.school_year desc, tsv.verified_at desc nulls last, tsv.created_at desc
  limit 1;

  -- No verified taxonomy for this subject yet: an honest empty queue, not an
  -- error -- the hero degrades to its "nothing due" state.
  if v_taxonomy_source_version is null then
    return jsonb_build_object('items', '[]'::jsonb, 'dueCount', 0);
  end if;

  with due as (
    select
      scs.topic_code,
      scs.skill_code,
      scs.due_reason,
      scs.tier,
      scs.next_due_at
    from app.student_cell_state scs
    where scs.user_id = v_user_id
      and scs.subject_id = v_subject_id
      and scs.taxonomy_source_version = v_taxonomy_source_version
      and scs.due_reason is not null
      and scs.next_due_at is not null
      and scs.next_due_at <= now()
    order by
      -- Priority order matches the four Phase-1 due-reasons
      -- (COURSE_MODE_STUDENT_UX_INTEGRATION_SPEC.md §3): a direct miss or
      -- decay/maintenance item surfaces before a provisional confirm or a
      -- fresh new-exposure consolidation.
      case scs.due_reason
        when 'direct_miss' then 0
        when 'decay' then 1
        when 'provisional_confirm' then 2
        when 'new_exposure' then 3
        else 4
      end,
      scs.next_due_at asc
  ),
  counted as (
    select count(*)::integer as total from due
  )
  select jsonb_build_object(
    'items', coalesce((
      select jsonb_agg(
        jsonb_build_object(
          'topicCode', d.topic_code,
          'skillCode', d.skill_code,
          'dueReason', d.due_reason,
          'tier', d.tier,
          'nextDueAt', d.next_due_at
        )
      )
      from (select * from due limit v_limit) d
    ), '[]'::jsonb),
    'dueCount', (select total from counted)
  )
  into v_payload;

  return v_payload;
end;
$$;

revoke all on function public.get_home_start_queue(uuid, integer) from public, anon;
grant execute on function public.get_home_start_queue(uuid, integer)
  to authenticated, service_role;

comment on function public.get_home_start_queue(uuid, integer) is
  'Authenticated due-queue for the /home Learn-mode "Start here" hero. Reads '
  'app.student_cell_state (service_role-only) through a coarse, due-cells-only '
  'projection -- topic/skill codes, due_reason, tier -- never plain-language '
  'copy (INV-1). Returns an honest empty items array with dueCount 0 when '
  'nothing is due, rather than fabricating content.';

commit;
