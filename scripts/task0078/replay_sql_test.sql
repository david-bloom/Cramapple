\set ON_ERROR_STOP on
-- Disposable local/CI database ONLY; never execute against a project database.
do $$ begin
  if current_database() <> 'task0078_fixture' then raise exception 'fixture database required'; end if;
end $$;
do $$ begin
  if not exists(select 1 from pg_roles where rolname='anon') then create role anon; end if;
  if not exists(select 1 from pg_roles where rolname='authenticated') then create role authenticated; end if;
  if not exists(select 1 from pg_roles where rolname='service_role') then create role service_role bypassrls; end if;
end $$;
drop schema if exists app cascade;
create schema app;
grant usage on schema app to service_role, anon, authenticated;
create table app.audit_events (
  audit_event_id text primary key, occurred_at timestamptz not null,
  actor_type text not null, actor_id text not null, action text not null,
  object_type text not null, object_id uuid, request_id text, reason_code text,
  metadata jsonb not null, event_sha256 text not null, created_at timestamptz not null
);
create unique index audit_events_request_id_reason_code_unique on app.audit_events(request_id,reason_code)
  where request_id is not null and reason_code is not null;
grant select,insert on app.audit_events to service_role;
\ir ../../supabase/migrations/20261021152931_task0078_operation_replay_claims.sql

create function pg_temp.assert_true(value boolean, label text) returns void language plpgsql as $$
begin if value is distinct from true then raise exception 'FAIL: %',label; end if; end $$;
select pg_temp.assert_true(not has_function_privilege('authenticated','app.claim_operation_replay(text,text,text,text)','EXECUTE'),'client cannot claim');
select pg_temp.assert_true(not has_table_privilege('anon','app.operation_replay_claims','SELECT'),'anon cannot read claims');
set role service_role;
do $$
declare v jsonb; token uuid; event jsonb;
begin
  v := app.claim_operation_replay('actor-a','key-1','hash-1','session_start');
  perform pg_temp.assert_true(v->>'kind'='claimed','first request claimed');
  token := (v->>'claim_token')::uuid;
  perform pg_temp.assert_true(app.claim_operation_replay('actor-a','key-1','hash-1','session_start')->>'kind'='pending','retry waits before effects');
  perform pg_temp.assert_true(app.claim_operation_replay('actor-b','key-1','hash-1','session_start')->>'kind'='conflict','cross actor collision refused');
  perform pg_temp.assert_true(app.claim_operation_replay('actor-a','key-1','changed','session_start')->>'kind'='conflict','changed body refused');
  event := jsonb_build_object('audit_event_id','event-1','occurred_at',now(),'actor_type','human','actor_id','actor-a',
    'action','session_event.session_start','object_type','learning_session','object_id',gen_random_uuid(),
    'request_id','key-1','reason_code','session_start','metadata',jsonb_build_object('request_hash','hash-1','result',jsonb_build_object('id','original-session')),
    'event_sha256','fixture-digest','created_at',now());
  begin
    perform app.complete_operation_replay(token,event - 'audit_event_id');
    raise exception 'expected audit failure';
  exception when not_null_violation then null; end;
  perform pg_temp.assert_true((select completed_at is null from app.operation_replay_claims where claim_token=token),'failed audit leaves claim pending');
  perform pg_temp.assert_true(app.claim_operation_replay('actor-a','key-1','hash-1','session_start')->>'kind'='pending','audit failure never permits reexecution');
  perform app.complete_operation_replay(token,event);
  perform app.complete_operation_replay(token,event);
  v := app.claim_operation_replay('actor-a','key-1','hash-1','session_start');
  perform pg_temp.assert_true(v->>'kind'='replay' and v->'result'->>'id'='original-session','completed replay preserves result');
  perform pg_temp.assert_true((select count(*)=1 from app.audit_events),'lost completion acknowledgement cannot duplicate audit');
  perform pg_temp.assert_true(app.claim_operation_replay('actor-b','key-1','hash-1','session_start')->>'kind'='conflict','legacy audit actor protected');
  v := app.claim_operation_replay('actor-a','key-2','hash-2','sign_upload');
  token := (v->>'claim_token')::uuid;
  begin
    perform app.complete_operation_replay(token,event || jsonb_build_object('actor_id','actor-b'));
    raise exception 'expected identity refusal';
  exception when raise_exception then
    if sqlerrm <> 'operation_replay:claim_mismatch' then raise; end if;
  end;
end $$;
reset role;
select 'PASS: durable replay claims, actor/hash collisions, failed audit, lost acknowledgement and privileges' as result;
