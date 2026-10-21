-- TASK-0078: unapplied migration; preserve locks, hash format, guards and grants.
-- Bodies read live on 2026-10-21. Abort instead of overwriting concurrent work.
do $$ begin
  if not exists (select 1 from pg_proc p join pg_namespace n on n.oid=p.pronamespace
    where n.nspname='app' and p.proname='submit_response' and md5(p.prosrc) in
      ('024e412aacf07cfd7ed0c0e03ef70d89','f15074ff69f68948034ab6d0e8f72615')) then
    raise exception 'TASK-0078: submit_response changed; re-review deployed definition';
  end if;
end $$;

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
  v_constraint text;
begin
  -- Fast-path idempotency probe before any lock acquisition. If the
  -- request has already completed, return its cached result without
  -- contending on the attempt row.
  select metadata
    into v_existing_metadata
    from app.audit_events
    where request_id = p_idempotency_key
      and reason_code = 'submit_response'
      and actor_id = p_actor_id::text
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
      and actor_id = p_actor_id::text
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
    p_response_version_id,
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
exception when unique_violation then
  get stacked diagnostics v_constraint = constraint_name;
  if v_constraint = 'audit_events_request_id_reason_code_unique' then
    raise exception 'submit_response:idempotency_conflict' using errcode='P0001';
  end if;
  raise;
end;
$function$;

