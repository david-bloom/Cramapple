-- TASK-0078. UNAPPLIED release artifact: migration precedes both Edge deploys.
-- Preserve the existing global (request_id, reason_code) namespace and hashes.
-- No TTL/reclaim: a pending key can describe an already-committed action.
create table app.operation_replay_claims (
  request_id text not null,
  operation text not null,
  actor_id text not null,
  request_hash text not null,
  claim_token uuid not null default gen_random_uuid(),
  completed_at timestamptz,
  created_at timestamptz not null default now(),
  primary key (request_id, operation),
  unique (claim_token),
  check (operation in ('session_start','session_save','session_resume','session_end',
                       'sign_upload','sign_download','sign_delete'))
);
alter table app.operation_replay_claims enable row level security;
revoke all on app.operation_replay_claims from public, anon, authenticated;
grant select, insert, update on app.operation_replay_claims to service_role;

create function app.claim_operation_replay(
  p_actor_id text, p_request_id text, p_request_hash text, p_operation text
) returns jsonb language plpgsql security invoker set search_path = '' as $$
declare
  v_event record;
  v_claim app.operation_replay_claims%rowtype;
begin
  if coalesce(p_actor_id,'') = '' or coalesce(p_request_id,'') = '' or coalesce(p_request_hash,'') = '' then
    raise exception 'operation_replay:invalid_claim';
  end if;
  -- Both RPCs lock the same legacy key before reading or writing audit rows.
  perform pg_catalog.pg_advisory_xact_lock(pg_catalog.hashtextextended(p_request_id || ':' || p_operation, 78));
  select actor_id, metadata into v_event from app.audit_events
    where request_id = p_request_id and reason_code = p_operation limit 1;
  if found then
    if v_event.actor_id <> p_actor_id or coalesce(v_event.metadata->>'request_hash','') <> p_request_hash then
      return jsonb_build_object('kind','conflict');
    end if;
    return jsonb_build_object('kind','replay','result',v_event.metadata->'result');
  end if;
  select * into v_claim from app.operation_replay_claims
    where request_id = p_request_id and operation = p_operation;
  if found then
    if v_claim.actor_id <> p_actor_id or v_claim.request_hash <> p_request_hash then
      return jsonb_build_object('kind','conflict');
    end if;
    return jsonb_build_object('kind','pending');
  end if;
  insert into app.operation_replay_claims(request_id,operation,actor_id,request_hash)
    values(p_request_id,p_operation,p_actor_id,p_request_hash) returning * into v_claim;
  return jsonb_build_object('kind','claimed','claim_token',v_claim.claim_token);
end;
$$;

create function app.complete_operation_replay(p_claim_token uuid, p_event jsonb)
returns void language plpgsql security invoker set search_path = '' as $$
declare v_claim app.operation_replay_claims%rowtype; v_existing record;
begin
  select * into strict v_claim from app.operation_replay_claims where claim_token=p_claim_token;
  perform pg_catalog.pg_advisory_xact_lock(pg_catalog.hashtextextended(v_claim.request_id || ':' || v_claim.operation, 78));
  select * into strict v_claim from app.operation_replay_claims where claim_token=p_claim_token for update;
  if p_event->>'actor_id' is distinct from v_claim.actor_id
     or p_event->>'request_id' is distinct from v_claim.request_id
     or p_event->>'reason_code' is distinct from v_claim.operation
     or p_event->'metadata'->>'request_hash' is distinct from v_claim.request_hash then
    raise exception 'operation_replay:claim_mismatch';
  end if;
  if (p_event->'metadata'->'result') ?| array['signed_url','token'] then
    raise exception 'operation_replay:bearer_result_forbidden';
  end if;
  select actor_id,metadata into v_existing from app.audit_events
    where request_id=v_claim.request_id and reason_code=v_claim.operation limit 1;
  if found then
    if v_existing.actor_id <> v_claim.actor_id
       or coalesce(v_existing.metadata->>'request_hash','') <> v_claim.request_hash then
      raise exception 'operation_replay:idempotency_conflict';
    end if;
  else
    insert into app.audit_events(audit_event_id,occurred_at,actor_type,actor_id,action,
      object_type,object_id,request_id,reason_code,metadata,event_sha256,created_at)
    values(p_event->>'audit_event_id',(p_event->>'occurred_at')::timestamptz,
      p_event->>'actor_type',v_claim.actor_id,p_event->>'action',p_event->>'object_type',
      (p_event->>'object_id')::uuid,v_claim.request_id,v_claim.operation,
      p_event->'metadata',p_event->>'event_sha256',(p_event->>'created_at')::timestamptz);
  end if;
  update app.operation_replay_claims set completed_at=coalesce(completed_at,now()) where claim_token=p_claim_token;
end;
$$;
revoke all on function app.claim_operation_replay(text,text,text,text) from public, anon, authenticated;
revoke all on function app.complete_operation_replay(uuid,jsonb) from public, anon, authenticated;
grant execute on function app.claim_operation_replay(text,text,text,text) to service_role;
grant execute on function app.complete_operation_replay(uuid,jsonb) to service_role;
