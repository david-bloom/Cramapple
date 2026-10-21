\set ON_ERROR_STOP on
do $$ begin if current_database()<>'task0078_submit_fixture' then raise exception 'fixture database required'; end if; end $$;
create schema if not exists extensions;
create extension if not exists pgcrypto with schema extensions;
create schema app;
create table app.attempts(id uuid primary key,user_id uuid,status text,submitted_at timestamptz);
create table app.response_versions(id uuid primary key,attempt_id uuid,is_submitted boolean default false,submitted_at timestamptz);
create table app.audit_events(audit_event_id text,occurred_at timestamptz,actor_type text,actor_id text,action text,object_type text,object_id uuid,request_id text,reason_code text,metadata jsonb,event_sha256 text,created_at timestamptz);
create unique index audit_events_request_id_reason_code_unique on app.audit_events(request_id,reason_code) where request_id is not null and reason_code is not null;
CREATE OR REPLACE FUNCTION app.submit_response(p_attempt_id uuid, p_response_version_id uuid, p_actor_id uuid, p_actor_role text, p_idempotency_key text, p_request_hash text)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'app', 'public'
AS $function$
declare
  v_existing_metadata jsonb;
  v_existing_hash text;
  v_attempt record;
  v_response record;
  v_submitted_at timestamptz;
  v_result jsonb;
  v_audit_event_id text;
  v_event_sha256 text;
begin
  select metadata into v_existing_metadata
    from app.audit_events
    where request_id = p_idempotency_key and reason_code = 'submit_response'
    limit 1;
  if found then
    v_existing_hash := coalesce(v_existing_metadata ->> 'request_hash', '');
    if v_existing_hash <> p_request_hash then
      raise exception 'submit_response:idempotency_conflict' using errcode = 'P0001';
    end if;
    return coalesce(v_existing_metadata -> 'result', 'null'::jsonb);
  end if;

  select id, user_id, status into v_attempt from app.attempts where id = p_attempt_id for update;
  if not found then raise exception 'submit_response:attempt_not_found' using errcode = 'P0001'; end if;

  select metadata into v_existing_metadata
    from app.audit_events
    where request_id = p_idempotency_key and reason_code = 'submit_response'
    limit 1;
  if found then
    v_existing_hash := coalesce(v_existing_metadata ->> 'request_hash', '');
    if v_existing_hash <> p_request_hash then
      raise exception 'submit_response:idempotency_conflict' using errcode = 'P0001';
    end if;
    return coalesce(v_existing_metadata -> 'result', 'null'::jsonb);
  end if;

  if v_attempt.user_id <> p_actor_id and p_actor_role <> 'admin' then
    raise exception 'submit_response:forbidden' using errcode = 'P0001';
  end if;
  if v_attempt.status not in ('draft', 'failed') then
    raise exception 'submit_response:attempt_not_submittable:%', v_attempt.status using errcode = 'P0001';
  end if;

  select id, attempt_id, is_submitted into v_response
    from app.response_versions where id = p_response_version_id for update;
  if not found then raise exception 'submit_response:response_not_found' using errcode = 'P0001'; end if;
  if v_response.attempt_id <> v_attempt.id then
    raise exception 'submit_response:response_attempt_mismatch' using errcode = 'P0001';
  end if;
  if v_response.is_submitted then
    raise exception 'submit_response:response_already_submitted' using errcode = 'P0001';
  end if;

  v_submitted_at := now();
  update app.response_versions set is_submitted = true, submitted_at = v_submitted_at where id = p_response_version_id;
  update app.attempts set status = 'submitted', submitted_at = v_submitted_at where id = p_attempt_id;

  v_result := jsonb_build_object(
    'attempt_id', v_attempt.id, 'response_version_id', v_response.id,
    'status', 'submitted', 'submitted_at', v_submitted_at
  );

  v_audit_event_id := gen_random_uuid()::text;
  v_event_sha256 := encode(
    extensions.digest(
      jsonb_build_object('operation', 'submit_response', 'request_hash', p_request_hash, 'result', v_result)::text,
      'sha256'::text
    ),
    'hex'
  );

  insert into app.audit_events (
    audit_event_id, occurred_at, actor_type, actor_id, action,
    object_type, object_id, request_id, reason_code, metadata, event_sha256, created_at
  ) values (
    v_audit_event_id, v_submitted_at, 'human', p_actor_id::text,
    'submit_response.submit_response', 'response_version',
    p_response_version_id,  -- uuid, not ::text
    p_idempotency_key, 'submit_response',
    jsonb_build_object('request_hash', p_request_hash, 'attempt_id', v_attempt.id, 'actor_role', p_actor_role, 'result', v_result),
    v_event_sha256, v_submitted_at
  );

  return v_result;
end;
$function$;

\ir ../../supabase/migrations/20261021153645_task0078_submit_response_actor_replay.sql
insert into app.attempts values('11111111-1111-4111-8111-111111111111','aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa','draft',null),('22222222-2222-4222-8222-222222222222','bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb','draft',null),('33333333-3333-4333-8333-333333333333','aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa','draft',null);
insert into app.response_versions(id,attempt_id) select id,id from app.attempts;
do $$ declare r jsonb; x jsonb; begin
 r:=app.submit_response('11111111-1111-4111-8111-111111111111','11111111-1111-4111-8111-111111111111','aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa','student','same-key','same-hash');
 x:=app.submit_response('11111111-1111-4111-8111-111111111111','11111111-1111-4111-8111-111111111111','aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa','student','same-key','same-hash');
 if r<>x then raise exception 'same actor replay changed'; end if;
 begin
  perform app.submit_response('11111111-1111-4111-8111-111111111111','11111111-1111-4111-8111-111111111111','bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb','student','same-key','same-hash');
  raise exception 'cross actor replay leaked';
 exception when raise_exception then if sqlerrm<>'submit_response:forbidden' then raise; end if; end;
 begin
  perform app.submit_response('22222222-2222-4222-8222-222222222222','22222222-2222-4222-8222-222222222222','bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb','student','same-key','other-hash');
  raise exception 'collision accepted';
 exception when raise_exception then if sqlerrm<>'submit_response:idempotency_conflict' then raise; end if; end;
 if (select status from app.attempts where id='22222222-2222-4222-8222-222222222222')<>'draft' or (select is_submitted from app.response_versions where id='22222222-2222-4222-8222-222222222222') then raise exception 'collision did not roll back both mutations'; end if;
 begin
  perform app.submit_response('11111111-1111-4111-8111-111111111111','11111111-1111-4111-8111-111111111111','aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa','student','same-key','changed');
  raise exception 'changed body accepted';
 exception when raise_exception then if sqlerrm<>'submit_response:idempotency_conflict' then raise; end if; end;
end $$;
select 'PASS: submit RPC actor scope, legitimate replay and atomic collision rollback' as result;

