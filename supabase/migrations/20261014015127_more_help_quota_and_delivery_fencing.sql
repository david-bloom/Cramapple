-- Owner-approved: separate delivered-help allowance from attempted-call limits.
-- A generation token fences expired workers from committing/releasing a retry.
create table app.question_help_calls (
 receipt_id uuid not null references app.question_help_receipts(id) on delete cascade,
 user_id uuid not null references auth.users(id) on delete cascade,
 generation integer not null check(generation between 1 and 3),
 attempted_at timestamptz not null default clock_timestamp(),
 primary key(receipt_id,generation)
);
alter table app.question_help_calls enable row level security;
revoke all on app.question_help_calls from public,anon,authenticated;
grant select,insert on app.question_help_calls to service_role;
create index question_help_calls_user_time_idx on app.question_help_calls(user_id,attempted_at);
create index question_help_calls_time_idx on app.question_help_calls(attempted_at);
-- Preserve pre-migration attempt accounting without assuming successful delivery.
insert into app.question_help_calls(receipt_id,user_id,generation,attempted_at)
select r.id,r.user_id,n,r.created_at from app.question_help_receipts r
cross join lateral generate_series(1,r.delivery_attempts) n;
-- The old signatures remain for audit/rollback, but are not runtime APIs.
revoke execute on function public.commit_question_help(uuid,uuid) from service_role;
revoke execute on function public.fail_question_help(uuid,uuid) from service_role;

create or replace function public.reserve_question_help_delivery(
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
 -- Delivered help has its own allowance. Active leases reserve a transient
 -- slot; failures release it. Every attempted call still consumes cost limits.
 if (select count(*) from app.question_help_receipts where user_id=p_user_id
     and (delivered_at>now()-interval '24 hours' or (request_state='working' and lease_until>clock_timestamp())))>=30 then
   return jsonb_build_object('error','rate_limited','retryAfterSeconds',greatest(1,ceil(extract(epoch from (
     select min(case when request_state='working' and delivered_at is null then lease_until else delivered_at+interval '24 hours' end)
     from app.question_help_receipts where user_id=p_user_id and (delivered_at>now()-interval '24 hours' or (request_state='working' and lease_until>clock_timestamp()))
   )-clock_timestamp()))));
 end if;
 if (select count(*) from app.question_help_calls where user_id=p_user_id and attempted_at>now()-interval '1 minute')>=6 then
   return jsonb_build_object('error','attempt_rate_limited','retryAfterSeconds',greatest(1,ceil(extract(epoch from (
     select min(attempted_at)+interval '1 minute' from app.question_help_calls where user_id=p_user_id and attempted_at>now()-interval '1 minute'
   )-clock_timestamp()))));
 end if;
 if (select count(*) from app.question_help_calls where user_id=p_user_id and attempted_at>now()-interval '24 hours')>=90
    or (select count(*) from app.question_help_calls where attempted_at>now()-interval '24 hours')>=1000 then
   return jsonb_build_object('error','attempt_rate_limited','retryAfterSeconds',greatest(1,ceil(extract(epoch from (
     select greatest(
       case when (select count(*) from app.question_help_calls where user_id=p_user_id and attempted_at>now()-interval '24 hours')>=90
         then (select min(attempted_at)+interval '24 hours' from app.question_help_calls where user_id=p_user_id and attempted_at>now()-interval '24 hours') else clock_timestamp() end,
       case when (select count(*) from app.question_help_calls where attempted_at>now()-interval '24 hours')>=1000
         then (select min(attempted_at)+interval '24 hours' from app.question_help_calls where attempted_at>now()-interval '24 hours') else clock_timestamp() end
     )
   )-clock_timestamp()))));
 end if;
 if r.id is null then
   insert into app.question_help_receipts(user_id,request_id,learning_session_id,content_item_version_id,input_hash)
   values(p_user_id,p_request_id,p_session_id,p_version_id,p_input_hash) returning * into r;
 else
   update app.question_help_receipts set request_state='working',lease_until=clock_timestamp()+interval '50 seconds',delivery_attempts=delivery_attempts+1 where id=r.id returning * into r;
 end if;
 insert into app.question_help_calls(receipt_id,user_id,generation) values(r.id,p_user_id,r.delivery_attempts);
 return jsonb_build_object('state','reserved','id',r.id,'generation',r.delivery_attempts);
end $$;
revoke all on function public.reserve_question_help_delivery(uuid,uuid,uuid,uuid,text) from public,anon,authenticated;
grant execute on function public.reserve_question_help_delivery(uuid,uuid,uuid,uuid,text) to service_role;

create function public.commit_question_help(p_user_id uuid,p_request_id uuid,p_generation integer)
returns jsonb language plpgsql security invoker set search_path='' as $$
declare r app.question_help_receipts%rowtype; v_attempt record;
begin
 select * into r from app.question_help_receipts where user_id=p_user_id and request_id=p_request_id;
 if not found then return jsonb_build_object('error','receipt_not_found'); end if;
 perform pg_advisory_xact_lock(hashtextextended('more-help:'||p_user_id::text||':'||r.learning_session_id::text||':'||r.content_item_version_id::text,0));
 select * into r from app.question_help_receipts where id=r.id for update;
 if r.delivery_attempts<>p_generation or p_generation is null then return jsonb_build_object('error','delivery_expired'); end if;
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
revoke all on function public.commit_question_help(uuid,uuid,integer) from public,anon,authenticated;
grant execute on function public.commit_question_help(uuid,uuid,integer) to service_role;

create function public.fail_question_help(p_user_id uuid,p_request_id uuid,p_generation integer) returns void
language sql security invoker set search_path='' as $$
 update app.question_help_receipts set request_state='failed',lease_until=null
 where user_id=p_user_id and request_id=p_request_id and request_state='working' and delivery_attempts=p_generation
$$;
revoke all on function public.fail_question_help(uuid,uuid,integer) from public,anon,authenticated;
grant execute on function public.fail_question_help(uuid,uuid,integer) to service_role;
