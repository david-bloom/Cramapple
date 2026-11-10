-- Own-sessions listing for the ended-trial "Your saved work" entry point
-- (DECISION-0135 D2: saved work stays readable after day 7; spec §6).
-- Authority: APPROVAL-0208 (Development only).
--
-- Lists the caller's own app.learning_sessions, newest first, with the counts
-- the app needs to link into /question. NOT gated on subject access: readback is
-- allowed in every trial phase and get_question_experience enforces
-- app.has_study_readback_access per session. `readable` tells the app, per
-- session, whether that read will succeed (false for a subject the account
-- never had access to; such rows are listed but greyed out, not hidden).

begin;

create or replace function public.get_my_learning_sessions(
  p_subject_key text default null, p_limit integer default 20
) returns jsonb language plpgsql stable security definer set search_path = pg_catalog as $$
declare
  v_user_id uuid := auth.uid();
  v_limit integer := greatest(1, least(coalesce(p_limit, 20), 50));
  v_subject text := nullif(btrim(coalesce(p_subject_key, '')), '');
begin
  if v_user_id is null then
    raise exception 'not_authenticated' using errcode = '28000';
  end if;
  return coalesce((
    select jsonb_agg(row_json order by last_activity_at desc, started_at desc)
    from (
      select
        jsonb_build_object(
          'learningSessionId', ls.id,
          'subjectKey', s.subject_key,
          'subjectName', s.display_name,
          'examPackVersionId', ls.exam_pack_version_id,
          'entryPath', ls.entry_path,
          'sessionMode', ls.session_mode,
          'practiceFormat', ls.practice_format,
          'status', ls.status,
          'startedAt', ls.started_at,
          'endedAt', ls.ended_at,
          'itemCount', (select count(*) from app.learning_session_items i where i.learning_session_id = ls.id),
          'submittedCount', (select count(distinct a.content_item_version_id) from app.attempts a
                             where a.learning_session_id = ls.id and a.user_id = v_user_id and a.submitted_at is not null),
          'firstItemType', (select ci.item_type from app.learning_session_items i
                            join app.content_item_versions civ on civ.id = i.content_item_version_id
                            join app.content_items ci on ci.id = civ.content_item_id
                            where i.learning_session_id = ls.id order by i.ordinal limit 1),
          'lastActivityAt', la.last_activity_at,
          'readable', app.has_study_readback_access(v_user_id, ls.exam_pack_version_id)
        ) as row_json,
        la.last_activity_at,
        ls.started_at
      from app.learning_sessions ls
      join app.exam_pack_versions v on v.id = ls.exam_pack_version_id
      join app.exam_packs p on p.id = v.exam_pack_id
      join app.subjects s on s.id = p.subject_id
      cross join lateral (
        select greatest(ls.started_at, coalesce(ls.ended_at, ls.started_at),
                        coalesce((select max(a.submitted_at) from app.attempts a where a.learning_session_id = ls.id), ls.started_at)) as last_activity_at
      ) la
      where ls.user_id = v_user_id
        and (v_subject is null
             or app.normalize_student_subject_key(s.subject_key) = app.normalize_student_subject_key(v_subject))
        and exists (select 1 from app.learning_session_items i where i.learning_session_id = ls.id)
      order by la.last_activity_at desc, ls.started_at desc
      limit v_limit
    ) x
  ), '[]'::jsonb);
end;
$$;
revoke all on function public.get_my_learning_sessions(text, integer) from public, anon;
grant execute on function public.get_my_learning_sessions(text, integer) to authenticated;

commit;

-- down: drop function public.get_my_learning_sessions(text, integer);
