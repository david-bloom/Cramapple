-- More help: minimal private request receipts; no student text or generated help.
-- Approved real-app Calculus AB/BC + Chemistry rollout: WORK-MORE-HELP-PRODUCTION.
create table app.question_help_receipts (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  request_id uuid not null,
  learning_session_id uuid not null references app.learning_sessions(id) on delete cascade,
  content_item_version_id uuid not null references app.content_item_versions(id),
  created_at timestamptz not null default clock_timestamp(),
  unique(user_id, request_id)
);
create index question_help_receipts_user_created on app.question_help_receipts(user_id,created_at);
create index question_help_receipts_created on app.question_help_receipts(created_at);
create index question_help_receipts_session_item on app.question_help_receipts(learning_session_id,content_item_version_id);
alter table app.question_help_receipts enable row level security;
revoke all on app.question_help_receipts from public, anon, authenticated;
grant select, insert on app.question_help_receipts to service_role;
comment on table app.question_help_receipts is 'More help request/assistance metadata only; owned by session/account, cascades on deletion. No answer, focus, generated explanation or new student history.';

-- Keep the existing event kind/policy. Distinguish More help by source.
alter table app.attempt_assistance_events drop constraint attempt_assistance_events_source_check;
alter table app.attempt_assistance_events add constraint attempt_assistance_events_source_check
  check(source in ('session_frame','practice_mcq','practice_frq','more_help'));

-- Called only with a verified user by the Edge Function. Serialize reservation
-- with future attempt creation, and serialize rate limits across workers.
create function public.reserve_question_help(
 p_user_id uuid, p_request_id uuid, p_session_id uuid, p_version_id uuid
) returns jsonb language plpgsql security invoker set search_path='' as $$
declare
 v_subject text;
 v_subject_id uuid;
 r app.question_help_receipts%rowtype;
 v_attempt record;
begin
 if p_user_id is null or p_request_id is null or p_session_id is null or p_version_id is null then
   return jsonb_build_object('error','invalid_request');
 end if;
 select s.subject_key,s.id into v_subject,v_subject_id
 from app.learning_sessions ls
 join app.learning_session_items lsi on lsi.learning_session_id=ls.id and lsi.content_item_version_id=p_version_id
 join app.exam_pack_versions epv on epv.id=ls.exam_pack_version_id
 join app.exam_packs ep on ep.id=epv.exam_pack_id
 join app.subjects s on s.id=ep.subject_id
 join app.content_item_versions civ on civ.id=lsi.content_item_version_id and civ.status='published'
 join app.content_items ci on ci.id=civ.content_item_id and ci.status='published'
 where ls.id=p_session_id and ls.user_id=p_user_id and ls.status='active';
 if not found then return jsonb_build_object('error','question_not_owned'); end if;
 if v_subject not in ('ap-calculus-ab','ap-calculus-bc','ap-chemistry') then
   return jsonb_build_object('error','subject_not_supported');
 end if;
 if not exists(select 1 from app.subject_entitlements e where e.user_id=p_user_id
   and (e.subject_id=v_subject_id or e.all_subjects) and e.status='active'
   and e.starts_at<=now() and (e.ends_at is null or e.ends_at>now())) then
   return jsonb_build_object('error','entitlement_required');
 end if;
 perform pg_advisory_xact_lock(hashtextextended('more-help-quota',0));
 perform pg_advisory_xact_lock(hashtextextended('more-help:'||p_user_id::text||':'||p_session_id::text||':'||p_version_id::text,0));
 if exists(select 1 from app.question_help_receipts where user_id=p_user_id and request_id=p_request_id) then
   return jsonb_build_object('error','request_already_used');
 end if;
 if (select count(*) from app.question_help_receipts where user_id=p_user_id and created_at>now()-interval '24 hours')>=30
   or (select count(*) from app.question_help_receipts where created_at>now()-interval '24 hours')>=1000 then
   return jsonb_build_object('error','rate_limited');
 end if;
 insert into app.question_help_receipts(user_id,request_id,learning_session_id,content_item_version_id)
 values(p_user_id,p_request_id,p_session_id,p_version_id) returning * into r;
 -- Lock each existing draft before inserting its event; submission must wait,
 -- and a submitted attempt never acquires a retroactive pre-submit event.
 for v_attempt in select id from app.attempts where user_id=p_user_id
   and learning_session_id=p_session_id and content_item_version_id=p_version_id and submitted_at is null
   for update
 loop
   if not exists(select 1 from app.attempt_assistance_events where attempt_id=v_attempt.id and source='more_help') then
     insert into app.attempt_assistance_events(attempt_id,event_kind,source,occurred_at)
     values(v_attempt.id,'topic_hint','more_help',r.created_at);
     update app.attempts set assistance_state='coached' where id=v_attempt.id;
   end if;
 end loop;
 return jsonb_build_object('state','reserved','id',r.id);
end $$;
revoke all on function public.reserve_question_help(uuid,uuid,uuid,uuid) from public,anon,authenticated;
grant execute on function public.reserve_question_help(uuid,uuid,uuid,uuid) to service_role;

-- Later attempts on the same served question are coached even after a reload
-- or help after an earlier submitted attempt. Existing grades are untouched.
create function app.record_prior_question_help() returns trigger
language plpgsql security definer set search_path='' as $$
declare v_opened timestamptz;
begin
 perform pg_advisory_xact_lock(hashtextextended('more-help:'||new.user_id::text||':'||new.learning_session_id::text||':'||new.content_item_version_id::text,0));
 select min(created_at) into v_opened from app.question_help_receipts
 where user_id=new.user_id and learning_session_id=new.learning_session_id
   and content_item_version_id=new.content_item_version_id;
 if v_opened is not null and new.submitted_at is null then
   insert into app.attempt_assistance_events(attempt_id,event_kind,source,occurred_at)
   values(new.id,'topic_hint','more_help',v_opened);
   update app.attempts set assistance_state='coached' where id=new.id;
 end if;
 return new;
end $$;
revoke all on function app.record_prior_question_help() from public,anon,authenticated;
create trigger trg_record_prior_question_help after insert on app.attempts
 for each row execute function app.record_prior_question_help();

-- A read-only caller-scoped receipt for the persistent UI assistance notice.
create function public.has_question_help(p_session_id uuid,p_version_id uuid) returns boolean
language sql stable security definer set search_path='' as $$
 select auth.uid() is not null and exists(select 1 from app.question_help_receipts r
   join app.learning_sessions ls on ls.id=r.learning_session_id and ls.user_id=auth.uid()
   where r.user_id=auth.uid() and r.learning_session_id=p_session_id and r.content_item_version_id=p_version_id)
$$;
revoke all on function public.has_question_help(uuid,uuid) from public,anon;
grant execute on function public.has_question_help(uuid,uuid) to authenticated;
