-- Independent QA remediation: reserve cost/request first; commit assistance
-- only when validated generated help is ready to disclose. No raw content stored.
alter table app.question_help_receipts
 add column delivered_at timestamptz,
 add column input_hash text not null default '',
 add column request_state text not null default 'working' check(request_state in ('working','failed','delivered')),
 add column delivery_attempts integer not null default 1 check(delivery_attempts between 1 and 3),
 add column lease_until timestamptz default clock_timestamp()+interval '50 seconds';
-- Keep the old signature for audit, but remove its runtime grant.
revoke execute on function public.reserve_question_help(uuid,uuid,uuid,uuid) from service_role;
create function public.reserve_question_help_delivery(
 p_user_id uuid, p_request_id uuid, p_session_id uuid, p_version_id uuid, p_input_hash text
) returns jsonb language plpgsql security invoker set search_path='' as $$
declare
 v_subject text;
 v_subject_id uuid;
 r app.question_help_receipts%rowtype;
 v_attempt record;
begin
 if p_user_id is null or p_request_id is null or p_session_id is null or p_version_id is null or p_input_hash is null or p_input_hash !~ '^[0-9a-f]{64}$' then
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
 select * into r from app.question_help_receipts where user_id=p_user_id and request_id=p_request_id;
 if found then
   if r.learning_session_id<>p_session_id or r.content_item_version_id<>p_version_id or r.input_hash<>p_input_hash then
     return jsonb_build_object('error','request_conflict');
   end if;
   if r.request_state='delivered' then return jsonb_build_object('error','request_already_used'); end if;
   if r.request_state='working' and r.lease_until>clock_timestamp() then return jsonb_build_object('error','request_in_progress'); end if;
   if r.delivery_attempts>=3 or r.created_at<now()-interval '24 hours' then return jsonb_build_object('error','retry_exhausted'); end if;
 end if;
 if coalesce((select sum(delivery_attempts) from app.question_help_receipts where user_id=p_user_id and created_at>now()-interval '24 hours'),0)>=30
   or coalesce((select sum(delivery_attempts) from app.question_help_receipts where created_at>now()-interval '24 hours'),0)>=1000 then
   return jsonb_build_object('error','rate_limited');
 end if;
 if r.id is null then
   insert into app.question_help_receipts(user_id,request_id,learning_session_id,content_item_version_id,input_hash)
   values(p_user_id,p_request_id,p_session_id,p_version_id,p_input_hash) returning * into r;
 else
   update app.question_help_receipts set request_state='working',lease_until=clock_timestamp()+interval '50 seconds',delivery_attempts=delivery_attempts+1 where id=r.id returning * into r;
 end if;
 return jsonb_build_object('state','reserved','id',r.id);
end $$;
revoke all on function public.reserve_question_help_delivery(uuid,uuid,uuid,uuid,text) from public,anon,authenticated;
grant execute on function public.reserve_question_help_delivery(uuid,uuid,uuid,uuid,text) to service_role;


-- Delivery acknowledgement is durable BEFORE generated content leaves the API.
-- Failed generation keeps a retryable reservation, never an assistance event.
create function public.commit_question_help(p_user_id uuid,p_request_id uuid)
returns jsonb language plpgsql security invoker set search_path='' as $$
declare r app.question_help_receipts%rowtype; v_attempt record;
begin
 select * into r from app.question_help_receipts where user_id=p_user_id and request_id=p_request_id;
 if not found then return jsonb_build_object('error','receipt_not_found'); end if;
 perform pg_advisory_xact_lock(hashtextextended('more-help:'||p_user_id::text||':'||r.learning_session_id::text||':'||r.content_item_version_id::text,0));
 select * into r from app.question_help_receipts where id=r.id for update;
 if r.request_state='delivered' then return jsonb_build_object('state','delivered'); end if;
 if r.request_state<>'working' or r.lease_until<clock_timestamp() then return jsonb_build_object('error','delivery_expired'); end if;
 update app.question_help_receipts set request_state='delivered',delivered_at=clock_timestamp(),lease_until=null where id=r.id returning * into r;
 for v_attempt in select id from app.attempts where user_id=p_user_id
   and learning_session_id=r.learning_session_id and content_item_version_id=r.content_item_version_id and submitted_at is null for update
 loop
   if not exists(select 1 from app.attempt_assistance_events where attempt_id=v_attempt.id and source='more_help') then
     insert into app.attempt_assistance_events(attempt_id,event_kind,source,occurred_at)
       values(v_attempt.id,'topic_hint','more_help',r.delivered_at);
     update app.attempts set assistance_state='coached' where id=v_attempt.id;
   end if;
 end loop;
 return jsonb_build_object('state','delivered');
end $$;
revoke all on function public.commit_question_help(uuid,uuid) from public,anon,authenticated;
grant execute on function public.commit_question_help(uuid,uuid) to service_role;

create function public.fail_question_help(p_user_id uuid,p_request_id uuid) returns void
language sql security invoker set search_path='' as $$
 update app.question_help_receipts set request_state='failed',lease_until=null
 where user_id=p_user_id and request_id=p_request_id and request_state='working'
$$;
revoke all on function public.fail_question_help(uuid,uuid) from public,anon,authenticated;
grant execute on function public.fail_question_help(uuid,uuid) to service_role;
create or replace function app.record_prior_question_help() returns trigger
language plpgsql security definer set search_path='' as $$
declare v_opened timestamptz;
begin
 perform pg_advisory_xact_lock(hashtextextended('more-help:'||new.user_id::text||':'||new.learning_session_id::text||':'||new.content_item_version_id::text,0));
 select min(delivered_at) into v_opened from app.question_help_receipts
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

-- A read-only caller-scoped receipt for the persistent UI assistance notice.
create or replace function public.has_question_help(p_session_id uuid,p_version_id uuid) returns boolean
language sql stable security definer set search_path='' as $$
 select auth.uid() is not null and exists(select 1 from app.question_help_receipts r
   join app.learning_sessions ls on ls.id=r.learning_session_id and ls.user_id=auth.uid()
   where r.user_id=auth.uid() and r.learning_session_id=p_session_id and r.content_item_version_id=p_version_id and r.delivered_at is not null)
$$;
revoke all on function public.has_question_help(uuid,uuid) from public,anon;
grant execute on function public.has_question_help(uuid,uuid) to authenticated;
