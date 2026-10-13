-- Worked teaching examples have no practice session. Match the existing teaching RPC's entitlement gate.
alter table app.question_issue_reports alter column learning_session_id drop not null;
alter table app.question_issue_reports add constraint question_issue_report_context check (mode='worked' or learning_session_id is not null);

create or replace function public.reserve_question_issue_report(
  p_user_id uuid, p_request_id uuid, p_session_id uuid,
  p_version_id uuid, p_mode text, p_note text
) returns jsonb language plpgsql security invoker set search_path = '' as $$
declare
  r app.question_issue_reports%rowtype;
  v_subject text;
  v_question text;
begin
  if (p_mode='worked' and p_session_id is not null) or (p_mode <> 'worked' and p_session_id is null) or p_mode not in ('worked','learn','practice','review') or p_note is null or char_length(p_note) > 2000 then
    return jsonb_build_object('error','invalid_report');
  end if;
  perform pg_advisory_xact_lock(hashtextextended('question-report:' || p_user_id::text, 0));
  select * into r from app.question_issue_reports where user_id=p_user_id and request_id=p_request_id;
  if found then
    if r.learning_session_id is distinct from p_session_id or r.content_item_version_id <> p_version_id or r.mode <> p_mode or r.note <> p_note then
      return jsonb_build_object('error','request_conflict');
    end if;
    if r.notification_state='sent' then return jsonb_build_object('state','sent','id',r.id); end if;
    if r.created_at < now()-interval '23 hours' or r.delivery_attempts >= 5 then
      return jsonb_build_object('error','retry_exhausted');
    end if;
    if r.notification_state='sending' and r.lease_until > now() then
      return jsonb_build_object('error','delivery_in_progress');
    end if;
    update app.question_issue_reports set notification_state='sending', lease_until=now()+interval '30 seconds', delivery_attempts=delivery_attempts+1
      where id=r.id returning * into r;
  else
    if p_mode='worked' then
      select s.subject_key, civ.stem into v_subject, v_question
      from app.content_item_versions civ
      join app.content_items ci on ci.id=civ.content_item_id
      join app.open_hand_teaching_items t on t.content_item_id=ci.id and t.released_at is null
      join app.exam_pack_versions epv on epv.id=ci.exam_pack_version_id
      join app.exam_packs ep on ep.id=epv.exam_pack_id
      join app.subjects s on s.id=ep.subject_id and s.status='active'
      where civ.id=p_version_id and civ.status='published' and ci.status='published'
        and epv.status='published' and epv.retired_at is null
        and (exists (select 1 from app.profiles p where p.user_id=p_user_id and p.role in ('admin','content_author','tutor','reader','validator'))
          or exists (select 1 from app.subject_entitlements se where se.user_id=p_user_id and se.status='active'
            and (se.all_subjects is true or se.subject_id=s.id)
            and (se.starts_at is null or se.starts_at <= now()) and (se.ends_at is null or se.ends_at > now())));
    else
      select coalesce(s.subject_key, ep.exam_code), civ.stem into v_subject, v_question
    from app.learning_sessions ls
    join app.learning_session_items lsi on lsi.learning_session_id=ls.id and lsi.content_item_version_id=p_version_id
    join app.content_item_versions civ on civ.id=lsi.content_item_version_id
    join app.exam_pack_versions epv on epv.id=ls.exam_pack_version_id
    join app.exam_packs ep on ep.id=epv.exam_pack_id
    left join app.subjects s on s.id=ep.subject_id
    where ls.id=p_session_id and ls.user_id=p_user_id;
    end if;
    if not found then return jsonb_build_object('error','question_not_owned'); end if;
    if (select count(*) from app.question_issue_reports where user_id=p_user_id and created_at > now()-interval '1 hour') >= 10 then
      return jsonb_build_object('error','rate_limited');
    end if;
    insert into app.question_issue_reports(user_id,request_id,learning_session_id,content_item_version_id,mode,note,subject,question,lease_until)
    values(p_user_id,p_request_id,p_session_id,p_version_id,p_mode,p_note,v_subject,coalesce(v_question,'[Question text unavailable]'),now()+interval '30 seconds')
    returning * into r;
  end if;
  return jsonb_build_object('state','reserved','id',r.id,'subject',r.subject,'question',r.question,'questionId',r.content_item_version_id,'mode',r.mode,'comment',r.note);
end $$;
