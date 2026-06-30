-- Fix a 500 on every real call to app.submit_response, found during dev
-- E2E smoke testing (2026-06-22): the function fails with
--   ERROR: 42883: function digest(text, unknown) does not exist
-- because it is declared `set search_path = app, public`, and on this
-- project pgcrypto (which provides digest()) is installed in the
-- `extensions` schema, not `public`. The unqualified digest(...) call
-- at the audit-event hashing step can never resolve.
--
-- This migration is a minimal, behavior-preserving fix: schema-qualify
-- the one digest() call as extensions.digest(...). It does not widen
-- the function's search_path — this remains a SECURITY DEFINER function,
-- and broadening search_path on a SECURITY DEFINER function is its own
-- footgun (a writable schema earlier in the path could shadow a builtin).
-- Qualifying the call site is the narrower, safer fix.
--
-- No other logic changes from 202606210009_submit_response_post_lock_recheck.sql.

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
    extensions.digest(
      jsonb_build_object(
        'operation', 'submit_response',
        'request_hash', p_request_hash,
        'result', v_result
      )::text,
      'sha256'::text
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
-- but we keep this explicit to match the pattern in prior migrations.
revoke all on function app.submit_response(uuid, uuid, uuid, text, text, text)
  from public, anon, authenticated;
grant execute on function app.submit_response(uuid, uuid, uuid, text, text, text)
  to service_role;

commit;
