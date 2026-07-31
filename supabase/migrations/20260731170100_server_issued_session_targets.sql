-- TASK-0019: durable, server-issued session targets.
--
-- The browser receives only an opaque target id before consumption. A trusted
-- server resolves published content and invokes the service-role-only RPCs.
-- Target consumption and learning-session creation are one transaction.

begin;

create table app.session_targets (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references app.profiles(user_id) on delete cascade,
  exam_pack_version_id uuid not null references app.exam_pack_versions(id),
  kind text not null,
  status text not null default 'issued',
  idempotency_key text not null,
  request_fingerprint text not null,
  constraints jsonb not null default '{}'::jsonb,
  provenance jsonb not null default '{}'::jsonb,
  fallback jsonb not null default '{"mode":"reissue"}'::jsonb,
  minutes integer not null,
  learning_session_id uuid unique
    references app.learning_sessions(id) on delete restrict,
  created_at timestamptz not null default now(),
  expires_at timestamptz not null,
  consumed_at timestamptz,
  invalidated_at timestamptz,
  invalidation_reason text,
  constraint session_targets_kind_check
    check (kind in ('first_session', 'next_point')),
  constraint session_targets_status_check
    check (status in ('issued', 'consumed', 'expired', 'invalidated')),
  constraint session_targets_idempotency_key_check
    check (char_length(idempotency_key) between 8 and 200),
  constraint session_targets_fingerprint_check
    check (request_fingerprint ~ '^[a-f0-9]{32}$'),
  constraint session_targets_json_objects_check
    check (
      jsonb_typeof(constraints) = 'object'
      and jsonb_typeof(provenance) = 'object'
      and jsonb_typeof(fallback) = 'object'
    ),
  constraint session_targets_minutes_check
    check (minutes between 5 and 90),
  constraint session_targets_expiry_check
    check (expires_at > created_at),
  constraint session_targets_terminal_state_check
    check (
      (status = 'issued'
        and learning_session_id is null
        and consumed_at is null
        and invalidated_at is null)
      or
      (status = 'consumed'
        and learning_session_id is not null
        and consumed_at is not null
        and invalidated_at is null)
      or
      (status in ('expired', 'invalidated')
        and learning_session_id is null
        and consumed_at is null
        and invalidated_at is not null
        and invalidation_reason is not null)
    ),
  constraint session_targets_user_idempotency_unique
    unique (user_id, idempotency_key)
);

create table app.session_target_items (
  target_id uuid not null
    references app.session_targets(id) on delete cascade,
  ordinal integer not null,
  content_item_version_id uuid not null
    references app.content_item_versions(id),
  item_type text not null,
  practice_format text,
  created_at timestamptz not null default now(),
  primary key (target_id, ordinal),
  constraint session_target_items_ordinal_check
    check (ordinal > 0),
  constraint session_target_items_type_check
    check (item_type in ('mcq', 'frq', 'quantitative')),
  constraint session_target_items_unique_content
    unique (target_id, content_item_version_id)
);

create index session_targets_user_status_expiry_idx
  on app.session_targets (user_id, status, expires_at);

create index session_target_items_content_version_idx
  on app.session_target_items (content_item_version_id);

alter table app.session_targets enable row level security;
alter table app.session_targets force row level security;
alter table app.session_target_items enable row level security;
alter table app.session_target_items force row level security;

revoke all on app.session_targets from public, anon, authenticated;
revoke all on app.session_target_items from public, anon, authenticated;
grant select, insert, update on app.session_targets to service_role;
grant select, insert, update, delete on app.session_target_items to service_role;

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
  v_valid_count integer;
  v_distinct_count integer;
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
    count(distinct nullif(item.value->>'content_item_version_id', '')::uuid)::integer
  into v_item_count, v_distinct_count
  from jsonb_array_elements(p_resolved_items) as item(value);

  if v_item_count <> v_distinct_count then
    raise exception 'session_target:duplicate_or_invalid_items';
  end if;

  select count(*)::integer
  into v_valid_count
  from jsonb_array_elements(p_resolved_items) as item(value)
  join app.content_item_versions civ
    on civ.id = nullif(item.value->>'content_item_version_id', '')::uuid
  join app.content_items ci
    on ci.id = civ.content_item_id
  where ci.exam_pack_version_id = p_exam_pack_version_id
    and ci.status = 'published'
    and civ.status = 'published';

  if v_valid_count <> v_item_count then
    raise exception 'session_target:content_not_published_for_pack';
  end if;

  v_fingerprint := md5(
    jsonb_build_object(
      'exam_pack_version_id', p_exam_pack_version_id,
      'kind', p_kind,
      'resolved_items', p_resolved_items,
      'constraints', coalesce(p_constraints, '{}'::jsonb),
      'provenance', coalesce(p_provenance, '{}'::jsonb),
      'fallback', coalesce(p_fallback, '{"mode":"reissue"}'::jsonb),
      'minutes', p_minutes,
      'ttl_seconds', p_ttl_seconds
    )::text
  );

  perform pg_advisory_xact_lock(
    hashtextextended(p_user_id::text || ':' || p_idempotency_key, 0)
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
      when ci.item_type = 'frq' and ci.frq_form = 'short' then 'short_frq'
      when ci.item_type = 'frq' and ci.frq_form = 'long' then 'long_frq'
      else ci.item_type
    end
  from jsonb_array_elements(p_resolved_items)
    with ordinality as item(value, ordinality)
  join app.content_item_versions civ
    on civ.id = nullif(item.value->>'content_item_version_id', '')::uuid
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
begin
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
    and civ.status = 'published';

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
    available_minutes,
    status
  ) values (
    p_user_id,
    v_target.exam_pack_version_id,
    'recommend',
    v_mode,
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

comment on table app.session_targets is
  'TASK-0019 server-only target envelope; no browser grants.';
comment on table app.session_target_items is
  'TASK-0019 ordered resolved content; hidden until server consumption.';
comment on function public.issue_session_target(
  uuid, uuid, text, text, jsonb, jsonb, jsonb, jsonb, integer, integer
) is 'Service-role-only idempotent target issuance.';
comment on function public.consume_session_target(uuid, uuid, uuid)
  is 'Service-role-only atomic target consumption and session creation.';

commit;
