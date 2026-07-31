-- TASK-0019 QA remediation.
--
-- This is forward-only because 20260730172100 was already verified in
-- Development. It hardens input validation and error contracts, records the
-- target practice format on the atomic learning-session insert, bounds
-- unconsumed target creation, schedules retention cleanup, and removes
-- unnecessary item mutation privileges.

begin;

do $$
begin
  if to_regclass('public.session_targets') is not null then
    raise exception
      'task0019:conflicting_public_session_targets_exists';
  end if;
end;
$$;

alter table app.session_targets
  drop constraint session_targets_fingerprint_check;

alter table app.session_targets
  add constraint session_targets_fingerprint_check
  check (request_fingerprint ~ '^[a-f0-9]{32,128}$');

revoke update, delete on app.session_target_items from service_role;
grant select, insert on app.session_target_items to service_role;

create or replace function public.issue_session_target(
  p_user_id uuid,
  p_exam_pack_version_id uuid,
  p_kind text,
  p_idempotency_key text,
  p_resolved_items jsonb,
  p_constraints jsonb default '{}'::jsonb,
  p_provenance jsonb default '{}'::jsonb,
  p_fallback jsonb default '{"mode":"reissue"}'::jsonb,
  p_minutes integer default 15,
  p_ttl_seconds integer default 900
)
returns jsonb
language plpgsql
security invoker
set search_path = pg_catalog
as $$
declare
  v_target app.session_targets%rowtype;
  v_fingerprint text;
  v_item_count integer;
  v_valid_shape_count integer;
  v_distinct_count integer;
  v_valid_content_count integer;
  v_active_target_count integer;
  v_max_active_targets constant integer := 10;
begin
  if p_user_id is null or p_exam_pack_version_id is null then
    raise exception 'session_target:invalid_identity';
  end if;
  if p_kind not in ('first_session', 'next_point') then
    raise exception 'session_target:invalid_kind';
  end if;
  if char_length(coalesce(p_idempotency_key, '')) not between 8 and 200 then
    raise exception 'session_target:invalid_idempotency_key';
  end if;
  if p_minutes not between 5 and 90 then
    raise exception 'session_target:invalid_minutes';
  end if;
  if p_ttl_seconds not between 60 and 604800 then
    raise exception 'session_target:invalid_ttl';
  end if;
  if jsonb_typeof(p_resolved_items) <> 'array'
     or jsonb_array_length(p_resolved_items) = 0
     or jsonb_array_length(p_resolved_items) > 50 then
    raise exception 'session_target:invalid_items';
  end if;
  if jsonb_typeof(coalesce(p_constraints, '{}'::jsonb)) <> 'object'
     or jsonb_typeof(coalesce(p_provenance, '{}'::jsonb)) <> 'object'
     or jsonb_typeof(coalesce(p_fallback, '{}'::jsonb)) <> 'object' then
    raise exception 'session_target:invalid_metadata';
  end if;

  if not exists (
    select 1
    from app.profiles p
    where p.user_id = p_user_id
  ) then
    raise exception 'session_target:user_not_found';
  end if;

  if not exists (
    select 1
    from app.exam_pack_versions epv
    join app.exam_packs ep on ep.id = epv.exam_pack_id
    join app.subject_entitlements se
      on se.subject_id = ep.subject_id
     and se.user_id = p_user_id
     and se.status = 'active'
     and se.starts_at <= now()
     and (se.ends_at is null or se.ends_at > now())
    where epv.id = p_exam_pack_version_id
      and epv.status = 'published'
  ) then
    raise exception 'session_target:pack_unavailable_or_unentitled';
  end if;

  select
    count(*)::integer,
    count(*) filter (
      where jsonb_typeof(item.value) = 'object'
        and coalesce(item.value->>'content_item_version_id', '')
          ~* '^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$'
    )::integer,
    count(distinct case
      when jsonb_typeof(item.value) = 'object'
       and coalesce(item.value->>'content_item_version_id', '')
         ~* '^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$'
      then (item.value->>'content_item_version_id')::uuid
    end)::integer
  into v_item_count, v_valid_shape_count, v_distinct_count
  from jsonb_array_elements(p_resolved_items) as item(value);

  if v_valid_shape_count <> v_item_count then
    raise exception 'session_target:invalid_items';
  end if;
  if v_distinct_count <> v_item_count then
    raise exception 'session_target:duplicate_items';
  end if;

  select count(*)::integer
  into v_valid_content_count
  from jsonb_array_elements(p_resolved_items) as item(value)
  join app.content_item_versions civ
    on civ.id = (item.value->>'content_item_version_id')::uuid
  join app.content_items ci
    on ci.id = civ.content_item_id
  where ci.exam_pack_version_id = p_exam_pack_version_id
    and ci.status = 'published'
    and civ.status = 'published'
    and (
      ci.item_type in ('mcq', 'quantitative')
      or (ci.item_type = 'frq' and ci.frq_form in ('short', 'long'))
    );

  if v_valid_content_count <> v_item_count then
    raise exception 'session_target:content_not_published_or_compatible';
  end if;

  v_fingerprint := encode(
    extensions.digest(
      jsonb_build_object(
        'exam_pack_version_id', p_exam_pack_version_id,
        'kind', p_kind,
        'resolved_items', p_resolved_items,
        'constraints', coalesce(p_constraints, '{}'::jsonb),
        'provenance', coalesce(p_provenance, '{}'::jsonb),
        'fallback', coalesce(p_fallback, '{"mode":"reissue"}'::jsonb),
        'minutes', p_minutes,
        'ttl_seconds', p_ttl_seconds
      )::text,
      'sha256'
    ),
    'hex'
  );

  -- This advisory lock serializes issuance per user so concurrent fresh
  -- idempotency keys cannot bypass the active-target quota. Hash collisions
  -- can cause only brief spurious serialization; the unique constraint is the
  -- idempotency correctness mechanism.
  perform pg_advisory_xact_lock(
    hashtextextended('session-target-user:' || p_user_id::text, 0)
  );

  select *
  into v_target
  from app.session_targets
  where user_id = p_user_id
    and idempotency_key = p_idempotency_key
  for update;

  if found then
    if v_target.request_fingerprint <> v_fingerprint then
      raise exception 'session_target:idempotency_conflict';
    end if;
    return jsonb_build_object(
      'target_id', v_target.id,
      'kind', v_target.kind,
      'status', v_target.status,
      'minutes', v_target.minutes,
      'expires_at', v_target.expires_at
    );
  end if;

  update app.session_targets
  set
    status = 'expired',
    invalidated_at = now(),
    invalidation_reason = 'expired'
  where user_id = p_user_id
    and status = 'issued'
    and expires_at <= now();

  select count(*)::integer
  into v_active_target_count
  from app.session_targets
  where user_id = p_user_id
    and status = 'issued'
    and expires_at > now();

  if v_active_target_count >= v_max_active_targets then
    raise exception 'session_target:too_many_active_targets';
  end if;

  insert into app.session_targets (
    user_id,
    exam_pack_version_id,
    kind,
    idempotency_key,
    request_fingerprint,
    constraints,
    provenance,
    fallback,
    minutes,
    expires_at
  ) values (
    p_user_id,
    p_exam_pack_version_id,
    p_kind,
    p_idempotency_key,
    v_fingerprint,
    coalesce(p_constraints, '{}'::jsonb),
    coalesce(p_provenance, '{}'::jsonb),
    coalesce(p_fallback, '{"mode":"reissue"}'::jsonb),
    p_minutes,
    now() + make_interval(secs => p_ttl_seconds)
  )
  returning * into v_target;

  insert into app.session_target_items (
    target_id,
    ordinal,
    content_item_version_id,
    item_type,
    practice_format
  )
  select
    v_target.id,
    item.ordinality::integer,
    civ.id,
    ci.item_type,
    case
      when ci.item_type = 'mcq' then 'mcq'
      when ci.item_type = 'quantitative' then 'quantitative'
      when ci.item_type = 'frq' and ci.frq_form = 'short' then 'short_frq'
      when ci.item_type = 'frq' and ci.frq_form = 'long' then 'long_frq'
    end
  from jsonb_array_elements(p_resolved_items)
    with ordinality as item(value, ordinality)
  join app.content_item_versions civ
    on civ.id = (item.value->>'content_item_version_id')::uuid
  join app.content_items ci
    on ci.id = civ.content_item_id
  order by item.ordinality;

  return jsonb_build_object(
    'target_id', v_target.id,
    'kind', v_target.kind,
    'status', v_target.status,
    'minutes', v_target.minutes,
    'expires_at', v_target.expires_at
  );
end;
$$;

create or replace function public.consume_session_target(
  p_user_id uuid,
  p_target_id uuid,
  p_expected_exam_pack_version_id uuid
)
returns jsonb
language plpgsql
security invoker
set search_path = pg_catalog
as $$
declare
  v_target app.session_targets%rowtype;
  v_session_id uuid;
  v_items jsonb;
  v_item_count integer;
  v_valid_count integer;
  v_mode text;
  v_practice_format text;
begin
  -- Serialize session creation per user. The target row lock below still
  -- provides target-level consumption idempotency.
  perform pg_advisory_xact_lock(
    hashtextextended('learning-session-user:' || p_user_id::text, 0)
  );

  select *
  into v_target
  from app.session_targets
  where id = p_target_id
    and user_id = p_user_id
  for update;

  if not found then
    return jsonb_build_object('ok', false, 'code', 'target_not_found');
  end if;

  if v_target.exam_pack_version_id <> p_expected_exam_pack_version_id then
    return jsonb_build_object('ok', false, 'code', 'target_wrong_pack');
  end if;

  if v_target.status = 'consumed' then
    select jsonb_agg(
      jsonb_build_object(
        'ordinal', sti.ordinal,
        'content_item_version_id', sti.content_item_version_id,
        'item_type', sti.item_type,
        'practice_format', sti.practice_format
      )
      order by sti.ordinal
    )
    into v_items
    from app.session_target_items sti
    where sti.target_id = v_target.id;

    return jsonb_build_object(
      'ok', true,
      'idempotent_replay', true,
      'target_id', v_target.id,
      'learning_session_id', v_target.learning_session_id,
      'items', coalesce(v_items, '[]'::jsonb)
    );
  end if;

  if v_target.status in ('expired', 'invalidated') then
    return jsonb_build_object('ok', false, 'code', 'target_' || v_target.status);
  end if;

  if v_target.expires_at <= now() then
    update app.session_targets
    set
      status = 'expired',
      invalidated_at = now(),
      invalidation_reason = 'expired'
    where id = v_target.id;
    return jsonb_build_object('ok', false, 'code', 'target_expired');
  end if;

  if not exists (
    select 1
    from app.exam_pack_versions epv
    join app.exam_packs ep on ep.id = epv.exam_pack_id
    join app.subject_entitlements se
      on se.subject_id = ep.subject_id
     and se.user_id = p_user_id
     and se.status = 'active'
     and se.starts_at <= now()
     and (se.ends_at is null or se.ends_at > now())
    where epv.id = v_target.exam_pack_version_id
      and epv.status = 'published'
  ) then
    update app.session_targets
    set
      status = 'invalidated',
      invalidated_at = now(),
      invalidation_reason = 'pack_unavailable_or_unentitled'
    where id = v_target.id;
    return jsonb_build_object(
      'ok', false,
      'code', 'target_pack_unavailable_or_unentitled'
    );
  end if;

  select count(*)::integer
  into v_item_count
  from app.session_target_items sti
  where sti.target_id = v_target.id;

  select count(*)::integer
  into v_valid_count
  from app.session_target_items sti
  join app.content_item_versions civ
    on civ.id = sti.content_item_version_id
  join app.content_items ci
    on ci.id = civ.content_item_id
  where sti.target_id = v_target.id
    and ci.exam_pack_version_id = v_target.exam_pack_version_id
    and ci.status = 'published'
    and civ.status = 'published'
    and (
      ci.item_type in ('mcq', 'quantitative')
      or (ci.item_type = 'frq' and ci.frq_form in ('short', 'long'))
    );

  if v_item_count = 0 or v_valid_count <> v_item_count then
    update app.session_targets
    set
      status = 'invalidated',
      invalidated_at = now(),
      invalidation_reason = 'content_retired_or_missing'
    where id = v_target.id;
    return jsonb_build_object(
      'ok', false,
      'code', 'target_content_unavailable',
      'fallback', v_target.fallback
    );
  end if;

  if exists (
    select 1
    from app.learning_sessions ls
    where ls.user_id = p_user_id
      and ls.status = 'active'
  ) then
    return jsonb_build_object(
      'ok', false,
      'code', 'target_active_session_exists'
    );
  end if;

  select sti.practice_format
  into v_practice_format
  from app.session_target_items sti
  where sti.target_id = v_target.id
  order by sti.ordinal
  limit 1;

  if v_practice_format is null then
    return jsonb_build_object(
      'ok', false,
      'code', 'target_content_unavailable'
    );
  end if;

  v_mode := case
    when v_target.minutes <= 20 then 'quick'
    when v_target.minutes <= 35 then 'focused'
    else 'buckle_down'
  end;

  insert into app.learning_sessions (
    user_id,
    exam_pack_version_id,
    entry_path,
    session_mode,
    practice_format,
    available_minutes,
    status
  ) values (
    p_user_id,
    v_target.exam_pack_version_id,
    'recommend',
    v_mode,
    v_practice_format,
    v_target.minutes,
    'active'
  )
  returning id into v_session_id;

  update app.session_targets
  set
    status = 'consumed',
    learning_session_id = v_session_id,
    consumed_at = now()
  where id = v_target.id;

  select jsonb_agg(
    jsonb_build_object(
      'ordinal', sti.ordinal,
      'content_item_version_id', sti.content_item_version_id,
      'item_type', sti.item_type,
      'practice_format', sti.practice_format
    )
    order by sti.ordinal
  )
  into v_items
  from app.session_target_items sti
  where sti.target_id = v_target.id;

  return jsonb_build_object(
    'ok', true,
    'idempotent_replay', false,
    'target_id', v_target.id,
    'learning_session_id', v_session_id,
    'items', coalesce(v_items, '[]'::jsonb)
  );
end;
$$;

revoke all on function public.issue_session_target(
  uuid, uuid, text, text, jsonb, jsonb, jsonb, jsonb, integer, integer
) from public, anon, authenticated;
grant execute on function public.issue_session_target(
  uuid, uuid, text, text, jsonb, jsonb, jsonb, jsonb, integer, integer
) to service_role;

revoke all on function public.consume_session_target(uuid, uuid, uuid)
  from public, anon, authenticated;
grant execute on function public.consume_session_target(uuid, uuid, uuid)
  to service_role;

create extension if not exists pg_cron with schema pg_catalog;

create or replace function app.sweep_session_targets()
returns jsonb
language plpgsql
security invoker
set search_path = pg_catalog
as $$
declare
  v_expired integer;
  v_deleted integer;
begin
  update app.session_targets
  set
    status = 'expired',
    invalidated_at = now(),
    invalidation_reason = 'expired'
  where status = 'issued'
    and expires_at <= now();
  get diagnostics v_expired = row_count;

  delete from app.session_targets
  where (
      status in ('expired', 'invalidated')
      and invalidated_at < now() - interval '30 days'
    )
    or (
      status = 'consumed'
      and consumed_at < now() - interval '90 days'
    );
  get diagnostics v_deleted = row_count;

  return jsonb_build_object(
    'expired', v_expired,
    'deleted', v_deleted
  );
end;
$$;

revoke all on function app.sweep_session_targets()
  from public, anon, authenticated, service_role;

select cron.schedule(
  'task0019-sweep-session-targets',
  '17 3 * * *',
  'select app.sweep_session_targets();'
);

comment on function app.sweep_session_targets() is
  'TASK-0019 daily retention sweep; scheduled and executed by postgres only.';

commit;
