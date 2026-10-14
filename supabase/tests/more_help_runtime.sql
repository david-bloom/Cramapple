-- Development integration QA. Run the entire batch as postgres/SQL admin.
-- Fill the four __QA_*__ placeholders using a task-owned disposable QA account
-- and its served question. No new Auth identity is created. ALL changes roll back.
-- Runtime RPC assertions explicitly run as service_role, never the table owner.
-- No password, email sending, model call, real student work or history is used.
-- The explicit synthetic email guard prevents accidental use of a real account.
begin;
do $$
declare u uuid:='__QA_USER__'; s uuid:='__QA_SESSION__'; q uuid:='__QA_VERSION__'; pack uuid;
begin
 if not exists(select 1 from auth.users where id=u and email='__QA_EMAIL__') then raise exception 'Task-local synthetic QA identity mismatch'; end if;
 select exam_pack_version_id into pack from app.learning_sessions where id=s and user_id=u;
 if pack is null or not exists(select 1 from app.learning_session_items where learning_session_id=s and content_item_version_id=q) then raise exception 'Task-local QA session mismatch'; end if;
 update app.subject_entitlements set status='active',ends_at=now()+interval '1 hour' where user_id=u;
 perform set_config('more_help.qa_user',u::text,true);
 perform set_config('more_help.qa_session',s::text,true);
 perform set_config('more_help.qa_version',q::text,true);
 perform set_config('more_help.qa_pack',pack::text,true);
 perform set_config('request.jwt.claim.sub',u::text,true);
end $$;
set local role service_role;
do $$
declare u uuid:=current_setting('more_help.qa_user')::uuid; s uuid:=current_setting('more_help.qa_session')::uuid;
 q uuid:=current_setting('more_help.qa_version')::uuid; pack uuid:=current_setting('more_help.qa_pack')::uuid;
 rid uuid:=gen_random_uuid(); lease_rid uuid:=gen_random_uuid(); draft uuid:=gen_random_uuid(); future uuid:=gen_random_uuid(); r jsonb; fresh uuid;
begin
 if current_user<>'service_role' then raise exception 'Wrong QA runtime role'; end if;
 if has_function_privilege('authenticated','public.reserve_question_help_delivery(uuid,uuid,uuid,uuid,text)','EXECUTE')
   or has_function_privilege('anon','public.commit_question_help(uuid,uuid,integer)','EXECUTE')
   or has_function_privilege('service_role','public.commit_question_help(uuid,uuid)','EXECUTE')
   or has_function_privilege('service_role','public.fail_question_help(uuid,uuid)','EXECUTE')
   or has_table_privilege('authenticated','app.question_help_receipts','SELECT')
   or has_table_privilege('authenticated','app.question_help_calls','SELECT') then raise exception 'Unexpected public/old-signature grant'; end if;
 insert into app.attempts(id,user_id,learning_session_id,exam_pack_version_id,content_item_version_id,attempt_mode)
 values(draft,u,s,pack,q,'frq');
 r:=public.reserve_question_help_delivery(u,rid,s,q,repeat('a',64));
 if (r->>'state') is distinct from 'reserved' or ((r->>'generation')::integer) is distinct from 1 then raise exception 'Reserve failed: %',r; end if;
 if (select pre_submit_hint_count from app.attempts where id=draft)<>0 or public.has_question_help(s,q) then raise exception 'Reservation coached/disclosed prematurely'; end if;
 perform public.fail_question_help(u,rid,1);
 if (select request_state from app.question_help_receipts where user_id=u and request_id=rid)<>'failed' then raise exception 'Failure did not persist'; end if;
 r:=public.reserve_question_help_delivery(u,rid,s,q,repeat('a',64));
 if (r->>'state') is distinct from 'reserved' or ((r->>'generation')::integer) is distinct from 2 then raise exception 'Retry did not reuse receipt'; end if;
 perform public.fail_question_help(u,rid,1);
 if (select request_state from app.question_help_receipts where user_id=u and request_id=rid)<>'working' then raise exception 'Stale worker released retry'; end if;
 r:=public.commit_question_help(u,rid,1);
 if (r->>'error') is distinct from 'delivery_expired' then raise exception 'Stale worker committed retry'; end if;
 r:=public.commit_question_help(u,rid,2);
 if (r->>'state') is distinct from 'delivered' or not public.has_question_help(s,q) then raise exception 'Commit failed: %',r; end if;
 if (select pre_submit_hint_count from app.attempts where id=draft)<>1 or
   (select assistance_state from app.attempts where id=draft)<>'coached' then raise exception 'Existing draft not coached exactly once'; end if;
 r:=public.reserve_question_help_delivery(u,rid,s,q,repeat('a',64));
 if (r->>'error') is distinct from 'request_already_used' then raise exception 'Delivered duplicate accepted'; end if;
 insert into app.attempts(id,user_id,learning_session_id,exam_pack_version_id,content_item_version_id,attempt_mode)
 values(future,u,s,pack,q,'frq');
 if (select pre_submit_hint_count from app.attempts where id=future)<>1 then raise exception 'Future draft missed receipt'; end if;
 update app.attempts set status='submitted',submitted_at=clock_timestamp() where id=draft;
 rid:=gen_random_uuid(); r:=public.reserve_question_help_delivery(u,rid,s,q,repeat('a',64));
 r:=public.commit_question_help(u,rid,1);
 if (r->>'state') is distinct from 'delivered' or (select count(*) from app.attempt_assistance_events where attempt_id=draft and source='more_help')<>1
   or (select count(*) from app.attempt_assistance_events where attempt_id=future and source='more_help')<>1 then raise exception 'Post-help changed submitted/doubled existing events'; end if;
 r:=public.reserve_question_help_delivery(u,lease_rid,s,q,repeat('a',64));
 update app.question_help_receipts set lease_until=clock_timestamp()-interval '1 second' where user_id=u and request_id=lease_rid;
 r:=public.reserve_question_help_delivery(u,lease_rid,s,q,repeat('a',64));
 if ((r->>'generation')::integer) is distinct from 2 then raise exception 'Expired lease not recovered'; end if;
 r:=public.commit_question_help(u,lease_rid,1);
 if (r->>'error') is distinct from 'delivery_expired' then raise exception 'Expired worker committed newer lease'; end if;
 perform public.fail_question_help(u,lease_rid,1);
 if (select request_state from app.question_help_receipts where user_id=u and request_id=lease_rid)<>'working' then raise exception 'Expired worker invalidated newer lease'; end if;
 perform public.fail_question_help(u,lease_rid,2);
 r:=public.reserve_question_help_delivery(gen_random_uuid(),gen_random_uuid(),s,q,repeat('a',64));
 if (r->>'error') is distinct from 'question_not_owned' then raise exception 'Foreign session accepted'; end if;
 insert into app.learning_sessions(user_id,exam_pack_version_id,entry_path,session_mode,available_minutes,practice_format)
 values(u,pack,'topic','focused',10,'short_frq') returning id into fresh;
 insert into app.attempts(user_id,learning_session_id,exam_pack_version_id,content_item_version_id,attempt_mode)
 values(u,fresh,pack,q,'frq');
 if exists(select 1 from app.attempts where learning_session_id=fresh and pre_submit_hint_count<>0) then raise exception 'Fresh session inherited assistance'; end if;
end $$;
reset role;
-- Keep old failures away from the burst window; these are this transaction's own fixtures.
update app.question_help_calls set attempted_at=now()-interval '2 hours' where user_id=current_setting('more_help.qa_user')::uuid;
insert into app.question_help_receipts(user_id,request_id,learning_session_id,content_item_version_id,input_hash,request_state,lease_until)
select current_setting('more_help.qa_user')::uuid,gen_random_uuid(),current_setting('more_help.qa_session')::uuid,
 current_setting('more_help.qa_version')::uuid,repeat('b',64),'failed',null from generate_series(1,30);
insert into app.question_help_calls(receipt_id,user_id,generation,attempted_at)
select id,user_id,1,now()-interval '2 hours' from app.question_help_receipts
where user_id=current_setting('more_help.qa_user')::uuid and input_hash=repeat('b',64);
set local role service_role;
do $$
declare r jsonb; rid uuid:=gen_random_uuid(); u uuid:=current_setting('more_help.qa_user')::uuid;
begin
 r:=public.reserve_question_help_delivery(u,rid,current_setting('more_help.qa_session')::uuid,current_setting('more_help.qa_version')::uuid,repeat('a',64));
 if (r->>'state') is distinct from 'reserved' then raise exception '30 failures consumed delivered-help allowance: %',r; end if;
 perform public.fail_question_help(u,rid,1);
end $$;
reset role;
-- Test the exact allowance boundary: 29 permits one reservation; 30 refuses.
update app.question_help_receipts set request_state='failed',delivered_at=null,lease_until=null where user_id=current_setting('more_help.qa_user')::uuid;
update app.question_help_receipts set request_state='delivered',delivered_at=clock_timestamp(),lease_until=null
where id in (select id from app.question_help_receipts where user_id=current_setting('more_help.qa_user')::uuid and input_hash=repeat('b',64) order by id limit 29);
set local role service_role;
do $$
declare r jsonb; rid uuid:=gen_random_uuid(); u uuid:=current_setting('more_help.qa_user')::uuid;
begin
 r:=public.reserve_question_help_delivery(u,rid,current_setting('more_help.qa_session')::uuid,current_setting('more_help.qa_version')::uuid,repeat('a',64));
 if (r->>'state') is distinct from 'reserved' then raise exception '29 deliveries blocked the last allowance slot: %',r; end if;
 perform public.fail_question_help(u,rid,1);
end $$;
reset role;
-- Exactly 30 delivered fixtures reach the independent delivered-help allowance.
update app.question_help_receipts set request_state='delivered',delivered_at=clock_timestamp(),lease_until=null
where user_id=current_setting('more_help.qa_user')::uuid and input_hash=repeat('b',64);
set local role service_role;
do $$
declare r jsonb;
begin
 r:=public.reserve_question_help_delivery(current_setting('more_help.qa_user')::uuid,gen_random_uuid(),current_setting('more_help.qa_session')::uuid,current_setting('more_help.qa_version')::uuid,repeat('a',64));
 if (r->>'error') is distinct from 'rate_limited' or coalesce((r->>'retryAfterSeconds')::numeric,0)<=0 then raise exception 'Delivered allowance failed: %',r; end if;
end $$;
reset role;
update app.question_help_receipts set request_state='failed',delivered_at=null,lease_until=null where user_id=current_setting('more_help.qa_user')::uuid;
delete from app.question_help_calls where user_id=current_setting('more_help.qa_user')::uuid;
insert into app.question_help_receipts(user_id,request_id,learning_session_id,content_item_version_id,input_hash,request_state,lease_until)
select current_setting('more_help.qa_user')::uuid,gen_random_uuid(),current_setting('more_help.qa_session')::uuid,current_setting('more_help.qa_version')::uuid,
 repeat('c',64),'failed',null from generate_series(1,89);
insert into app.question_help_calls(receipt_id,user_id,generation,attempted_at)
select id,user_id,1,now()-interval '2 hours' from app.question_help_receipts where user_id=current_setting('more_help.qa_user')::uuid and input_hash=repeat('c',64);
set local role service_role;
do $$
declare r jsonb; rid uuid:=gen_random_uuid(); u uuid:=current_setting('more_help.qa_user')::uuid;
begin
 r:=public.reserve_question_help_delivery(u,rid,current_setting('more_help.qa_session')::uuid,current_setting('more_help.qa_version')::uuid,repeat('a',64));
 if (r->>'state') is distinct from 'reserved' then raise exception '89 attempts blocked final cost slot: %',r; end if;
 perform public.fail_question_help(u,rid,1);
 r:=public.reserve_question_help_delivery(u,gen_random_uuid(),current_setting('more_help.qa_session')::uuid,current_setting('more_help.qa_version')::uuid,repeat('a',64));
 if (r->>'error') is distinct from 'attempt_rate_limited' or coalesce((r->>'retryAfterSeconds')::numeric,0)<=0 then raise exception 'Attempt cost cap failed: %',r; end if;
end $$;
reset role;
delete from app.question_help_calls where user_id=current_setting('more_help.qa_user')::uuid;
insert into app.question_help_calls(receipt_id,user_id,generation)
select id,user_id,1 from app.question_help_receipts where user_id=current_setting('more_help.qa_user')::uuid limit 6;
set local role service_role;
do $$
declare r jsonb;
begin
 r:=public.reserve_question_help_delivery(current_setting('more_help.qa_user')::uuid,gen_random_uuid(),current_setting('more_help.qa_session')::uuid,current_setting('more_help.qa_version')::uuid,repeat('a',64));
 if (r->>'error') is distinct from 'attempt_rate_limited' or (coalesce((r->>'retryAfterSeconds')::numeric,61)>60 or coalesce((r->>'retryAfterSeconds')::numeric,0)<=0) then raise exception 'Burst cap failed: %',r; end if;
end $$;
reset role;
update app.subject_entitlements set status='revoked' where user_id=current_setting('more_help.qa_user')::uuid;
set local role service_role;
do $$
declare r jsonb;
begin
 r:=public.reserve_question_help_delivery(current_setting('more_help.qa_user')::uuid,gen_random_uuid(),current_setting('more_help.qa_session')::uuid,current_setting('more_help.qa_version')::uuid,repeat('a',64));
 if (r->>'error') is distinct from 'entitlement_required' then raise exception 'Entitlement gate failed: %',r; end if;
end $$;
select jsonb_build_object('runtime_role','service_role','reserve_commit_fail_retry',true,'existing_future_drafts',true,
 'submitted_attempt_preserved',true,'fresh_session_independent',true,'foreign_and_entitlement_denied',true,
 'stale_worker_fenced',true,'failed_calls_not_delivered_allowance',true,'delivered_allowance',true,
 'attempt_cost_limit',true,'burst_limit',true,'private_grants',true) as qa_result;
rollback;
