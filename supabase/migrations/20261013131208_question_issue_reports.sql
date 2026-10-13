-- Private delivery receipts for owner-requested question reports.
create table app.question_issue_reports (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  request_id uuid not null,
  learning_session_id uuid not null references app.learning_sessions(id) on delete cascade,
  content_item_version_id uuid not null references app.content_item_versions(id),
  mode text not null check (mode in ('worked', 'learn', 'practice', 'review')),
  note text not null default '' check (char_length(note) <= 2000),
  subject text not null,
  question text not null,
  notification_state text not null default 'sending' check (notification_state in ('sending', 'failed', 'sent')),
  delivery_attempts integer not null default 1 check (delivery_attempts between 1 and 5),
  lease_until timestamptz,
  created_at timestamptz not null default now(),
  notified_at timestamptz,
  unique (user_id, request_id)
);
create index question_issue_reports_user_created on app.question_issue_reports(user_id, created_at);
create index question_issue_reports_session on app.question_issue_reports(learning_session_id);
create index question_issue_reports_version on app.question_issue_reports(content_item_version_id);
alter table app.question_issue_reports enable row level security;
revoke all on app.question_issue_reports from public, anon, authenticated;
grant select, insert, update on app.question_issue_reports to service_role;
comment on table app.question_issue_reports is 'Service-only question reports and email delivery receipts; no answers, grades or email addresses.';

-- Service-only, SECURITY INVOKER: the Edge Function supplies the verified auth user.
-- Per-user lock makes ownership, rate limit and receipt reservation atomic.
create function public.reserve_question_issue_report(
  p_user_id uuid, p_request_id uuid, p_session_id uuid,
  p_version_id uuid, p_mode text, p_note text
) returns jsonb language plpgsql security invoker set search_path = '' as $$
declare
  r app.question_issue_reports%rowtype;
  v_subject text;
  v_question text;
begin
  if p_mode not in ('worked','learn','practice','review') or p_note is null or char_length(p_note) > 2000 then
    return jsonb_build_object('error','invalid_report');
  end if;
  perform pg_advisory_xact_lock(hashtextextended('question-report:' || p_user_id::text, 0));
  select * into r from app.question_issue_reports where user_id=p_user_id and request_id=p_request_id;
  if found then
    if r.learning_session_id <> p_session_id or r.content_item_version_id <> p_version_id or r.mode <> p_mode or r.note <> p_note then
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
    select coalesce(s.subject_key, ep.exam_code), civ.stem into v_subject, v_question
    from app.learning_sessions ls
    join app.learning_session_items lsi on lsi.learning_session_id=ls.id and lsi.content_item_version_id=p_version_id
    join app.content_item_versions civ on civ.id=lsi.content_item_version_id
    join app.exam_pack_versions epv on epv.id=ls.exam_pack_version_id
    join app.exam_packs ep on ep.id=epv.exam_pack_id
    left join app.subjects s on s.id=ep.subject_id
    where ls.id=p_session_id and ls.user_id=p_user_id;
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
revoke all on function public.reserve_question_issue_report(uuid,uuid,uuid,uuid,text,text) from public, anon, authenticated;
grant execute on function public.reserve_question_issue_report(uuid,uuid,uuid,uuid,text,text) to service_role;
