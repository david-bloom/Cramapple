-- Transactional submit_response RPC.
--
-- Replaces the two-statement update sequence in the original
-- supabase/functions/submit-response/index.ts implementation (PR #14). That
-- form could leave response_versions.is_submitted = true while
-- attempts.status stayed 'draft' if the second update failed, and two
-- concurrent submitters could both pass the pre-check because nothing was
-- locked between the read and the write.
--
-- The RPC below locks both rows with SELECT ... FOR UPDATE, validates
-- state inside the lock, performs both updates plus the audit insert in
-- one transaction, and uses a single idempotency probe against
-- app.audit_events (request_id, reason_code='submit_response') for replay.
--
-- Error contract: the function raises plpgsql exceptions with structured
-- messages of the form 'submit_response:<code>[:<detail>]'. The Edge
-- Function parses the prefix and maps to HTTP status. Codes:
--   idempotency_conflict      -> 409
--   attempt_not_found         -> 404
--   response_not_found        -> 404
--   forbidden                 -> 403
--   response_attempt_mismatch -> 409
--   attempt_not_submittable   -> 409 (detail: current status)
--   response_already_submitted-> 409
--
-- Successful return shape: jsonb with keys attempt_id, response_version_id,
-- status='submitted', submitted_at. On idempotent replay the function
-- returns the cached metadata.result jsonb from the prior audit row.

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
  -- Idempotency probe. Composite unique on (request_id, reason_code) was
  -- added in 202606210001, so this can return at most one row.
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

  -- Lock the attempt and validate. FOR UPDATE serialises concurrent
  -- submitters; the lock is released at COMMIT.
  select id, user_id, status
    into v_attempt
    from app.attempts
    where id = p_attempt_id
    for update;

  if not found then
    raise exception 'submit_response:attempt_not_found'
      using errcode = 'P0001';
  end if;

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

revoke all on function app.submit_response(uuid, uuid, uuid, text, text, text)
  from public, anon, authenticated;
grant execute on function app.submit_response(uuid, uuid, uuid, text, text, text)
  to service_role;

commit;
