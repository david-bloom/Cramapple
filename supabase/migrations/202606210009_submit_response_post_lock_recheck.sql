-- Fix the concurrent-idempotency race in app.submit_response.
--
-- The version in 202606210007 probed app.audit_events for the request_id
-- BEFORE acquiring any row lock. Two concurrent callers with the same
-- request_id could both observe no audit row, both block on the attempts
-- FOR UPDATE lock, and the loser would proceed to state validation —
-- where the attempt now reads status = 'submitted' (because the winner
-- committed in the meantime) and the function raises
-- 'submit_response:attempt_not_submittable:submitted' instead of
-- returning the cached idempotent result.
--
-- This migration CREATE OR REPLACEs the function so it re-probes
-- audit_events AFTER acquiring the attempt FOR UPDATE lock and BEFORE
-- any state validation. By the moment we hold that lock, any concurrent
-- caller that won the race has already committed and its audit row is
-- visible to us. The pre-lock probe remains as a fast-path optimisation
-- for replays of completed requests; the post-lock probe is the
-- correctness guarantee. Same shape as the
-- 202606210008_reserve_model_usage_race_fix.sql pattern.

begin;

create or replace function app.submit_response(
  p_attempt_id uuid,
  p_response_version_id uuid,
  p_actor_id uuid,
  p_actor_role text,
  p_idempotency_key text,
  p_request_hash text
)
returns jsonb
language plpgsql
security definer
set search_path = app, public
as $$
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
  -- Fast-path idempotency probe before any lock acquisition. If the
  -- request has already completed, return its cached result without
  -- contending on the attempt row.
  select metadata
    into v_existing_metadata
    from app.audit_events
    where request_id = p_idempotency_key
      and reason_code = 'submit_response'
    limit 1;

  if found then
    v_existing_hash := coalesce(v_existing_metadata ->> 'request_hash', '');
    if v_existing_hash <> p_request_hash then
      raise exception 'submit_response:idempotency_conflict'
        using errcode = 'P0001';
    end if;
    return coalesce(v_existing_metadata -> 'result', 'null'::jsonb);
  end if;

  -- Lock the attempt row. The lock serialises concurrent submitters and
  -- is the synchronisation point at which any concurrent winner's audit
  -- row becomes visible to us.
  select id, user_id, status
    into v_attempt
    from app.attempts
    where id = p_attempt_id
    for update;

  if not found then
    raise exception 'submit_response:attempt_not_found'
      using errcode = 'P0001';
  end if;

  -- Post-lock idempotency re-probe. A concurrent caller may have raced
  -- through the pre-lock probe and committed its audit row while we
  -- waited on the attempt lock. Returning the cached result here keeps
  -- idempotency intact instead of raising attempt_not_submittable when
  -- the attempt is already in 'submitted' state from the winner's
  -- update.
  select metadata
    into v_existing_metadata
    from app.audit_events
    where request_id = p_idempotency_key
      and reason_code = 'submit_response'
    limit 1;

  if found then
    v_existing_hash := coalesce(v_existing_metadata ->> 'request_hash', '');
    if v_existing_hash <> p_request_hash then
      raise exception 'submit_response:idempotency_conflict'
        using errcode = 'P0001';
    end if;
    return coalesce(v_existing_metadata -> 'result', 'null'::jsonb);
  end if;

  -- State validation only runs once we know no concurrent winner has
  -- committed.
  if v_attempt.user_id <> p_actor_id and p_actor_role <> 'admin' then
    raise exception 'submit_response:forbidden'
      using errcode = 'P0001';
  end if;

  if v_attempt.status not in ('draft', 'failed') then
    raise exception 'submit_response:attempt_not_submittable:%', v_attempt.status
      using errcode = 'P0001';
  end if;

  -- Lock the response_version and validate.
  select id, attempt_id, is_submitted
    into v_response
    from app.response_versions
    where id = p_response_version_id
    for update;

  if not found then
    raise exception 'submit_response:response_not_found'
      using errcode = 'P0001';
  end if;

  if v_response.attempt_id <> v_attempt.id then
    raise exception 'submit_response:response_attempt_mismatch'
      using errcode = 'P0001';
  end if;

  if v_response.is_submitted then
    raise exception 'submit_response:response_already_submitted'
      using errcode = 'P0001';
  end if;

  v_submitted_at := now();

  update app.response_versions
    set is_submitted = true,
        submitted_at = v_submitted_at
    where id = p_response_version_id;

  update app.attempts
    set status = 'submitted',
        submitted_at = v_submitted_at
    where id = p_attempt_id;

  v_result := jsonb_build_object(
    'attempt_id', v_attempt.id,
    'response_version_id', v_response.id,
    'status', 'submitted',
    'submitted_at', v_submitted_at
  );

  v_audit_event_id := gen_random_uuid()::text;
  v_event_sha256 := encode(
    digest(
      jsonb_build_object(
        'operation', 'submit_response',
        'request_hash', p_request_hash,
        'result', v_result
      )::text,
      'sha256'
    ),
    'hex'
  );

  insert into app.audit_events (
    audit_event_id,
    occurred_at,
    actor_type,
    actor_id,
    action,
    object_type,
    object_id,
    request_id,
    reason_code,
    metadata,
    event_sha256,
    created_at
  )
  values (
    v_audit_event_id,
    v_submitted_at,
    'human',
    p_actor_id::text,
    'submit_response.submit_response',
    'response_version',
    p_response_version_id::text,
    p_idempotency_key,
    'submit_response',
    jsonb_build_object(
      'request_hash', p_request_hash,
      'attempt_id', v_attempt.id,
      'actor_role', p_actor_role,
      'result', v_result
    ),
    v_event_sha256,
    v_submitted_at
  );

  return v_result;
end;
$$;

-- Re-assert grants. CREATE OR REPLACE preserves them in modern Postgres
-- but we keep this explicit to match the pattern in 202606210007 and
-- 202606210008.
revoke all on function app.submit_response(uuid, uuid, uuid, text, text, text)
  from public, anon, authenticated;
grant execute on function app.submit_response(uuid, uuid, uuid, text, text, text)
  to service_role;

commit;
