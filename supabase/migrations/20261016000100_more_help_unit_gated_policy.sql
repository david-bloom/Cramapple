-- Owner direction 2026-10-15: roll More help out ONE subject at a time, units 1-3
-- first; nothing in unit 4+ of any newly enabled subject without asking.
-- The reservation function now reads app.more_help_subject_policy instead of a
-- hard-coded subject list. allowed_units NULL = every unit (only the three
-- subjects already live in Production); otherwise the question's primary,
-- non-superseded topic cell must fall in the array (fail closed when absent).
-- Everything else in the function is the exact Production snapshot.
begin;
create table if not exists app.more_help_subject_policy(
  subject_key text primary key,
  allowed_units int[],
  enabled_at timestamptz not null default now(),
  note text
);
alter table app.more_help_subject_policy enable row level security;
revoke all on app.more_help_subject_policy from public,anon,authenticated;
grant select on app.more_help_subject_policy to service_role;
-- Only the three subjects already live in Production. New subjects are enabled one at a
-- time with a separate, owner-approved INSERT (docs/qa/more_help_release/02_enable_subject.sql).
insert into app.more_help_subject_policy(subject_key,allowed_units,note) values
 ('ap-calculus-ab',null,'live before unit gating; behavior preserved'),
 ('ap-calculus-bc',null,'live before unit gating; behavior preserved'),
 ('ap-chemistry',null,'live before unit gating; behavior preserved')
on conflict (subject_key) do nothing;

CREATE OR REPLACE FUNCTION public.reserve_question_help_delivery(p_user_id uuid, p_request_id uuid, p_session_id uuid, p_version_id uuid, p_input_hash text)
 RETURNS jsonb
 LANGUAGE plpgsql
 SET search_path TO ''
AS $function$
declare
 v_subject text;
 v_subject_id uuid;
 v_allowed int[];
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
 select p.allowed_units into v_allowed from app.more_help_subject_policy p where p.subject_key=v_subject;
 if not found then return jsonb_build_object('error','subject_not_supported'); end if;
 if v_allowed is not null and not exists(
   select 1 from app.content_item_cells c
   where c.content_item_version_id=p_version_id and c.is_primary and c.superseded_by is null
     and c.topic_code ~ '^[0-9]+\.' and split_part(c.topic_code,'.',1)::int = any(v_allowed)
 ) then return jsonb_build_object('error','subject_not_supported'); end if;
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
end $function$;

revoke all on function public.reserve_question_help_delivery(uuid,uuid,uuid,uuid,text) from public,anon,authenticated;
grant execute on function public.reserve_question_help_delivery(uuid,uuid,uuid,uuid,text) to service_role;
commit;
