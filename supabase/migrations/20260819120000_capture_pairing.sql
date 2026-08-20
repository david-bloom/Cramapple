-- TASK-0016 Phase D, Stage D2: QR capture-pairing capability + provenance.
--
-- NOT APPLIED. This file is written but has deliberately NOT been run
-- against Development or Production (no `supabase db push`, no MCP
-- `apply_migration`). Stage D2's execution boundary is "verifiable via
-- deno test / deno check and code review only".
--
-- WHY THIS EXISTS
-- ---------------
-- DECISION-0051 (2026-08-19) confirmed QR handoff as Engine 4's sole
-- capture path and directed that the QR frontend be rewired onto the
-- already-deployed `attach_capture` / `app.response_attachments` backend
-- instead of recreating `capture_sessions` and the `capture-research`
-- bucket. The single gap that leaves is the phone leg: it holds only a
-- pairing link, but every existing write path requires an authenticated
-- caller. This migration adds the server-side state that lets a
-- short-lived, single-use, purpose-bound capability stand in for that
-- authentication -- and nothing else. In particular it deliberately does
-- NOT recreate `capture_sessions`: image bytes still land in
-- `learner-uploads` and still bind through `app.bind_response_attachment`,
-- so there is exactly one storage system and one attachment table, which is
-- the whole point of the decision.
--
-- SECURITY POSTURE
-- ----------------
-- * Only the SHA-256 of a capability is stored. A database read (or a leak
--   of this table) cannot recover a live capability. This mirrors the Stage
--   D1 frozen contract `pairing_submission_provenance_event.v1`'s
--   `pairing.handle_sha256` field.
-- * RLS is enabled with NO policies for `authenticated`. Neither table is
--   client-readable at all: the primary device polls status through the
--   `capture-pairing` edge function, which re-derives ownership itself. A
--   learner has no reason to read a capability row and no way to.
-- * Binding columns are immutable after insert (trigger below), so a
--   capability can never be repointed at a different attempt, response
--   version, or slot after it has been handed to a phone.
-- * A partial unique index allows at most ONE live capability per
--   (attempt, submission slot), which is what makes "bind capability to ...
--   submission slot" a real constraint rather than a naming convention.

begin;

create table app.capture_pairing_tokens (
  id uuid primary key default gen_random_uuid(),

  -- SHA-256 hex of the capability. The capability itself is returned to the
  -- minting client exactly once and never persisted anywhere.
  handle_sha256 text not null
    check (handle_sha256 ~ '^[0-9a-f]{64}$'),

  -- Purpose binding. Constrained to a single value today; the column exists
  -- (rather than being implied) so a future second upload purpose cannot
  -- silently reuse a drawn-response capability.
  upload_purpose text not null default 'DRAWN_RESPONSE'
    check (upload_purpose = 'DRAWN_RESPONSE'),

  -- Everything the phone leg would otherwise have to be trusted to supply.
  user_id uuid not null references app.profiles(user_id),
  learning_session_id uuid references app.learning_sessions(id) on delete cascade,
  attempt_id uuid not null references app.attempts(id) on delete cascade,
  response_version_id uuid not null references app.response_versions(id) on delete cascade,
  content_item_version_id uuid not null references app.content_item_versions(id),

  -- One capture slot on one item. Free text rather than an enum because the
  -- caller (the session runner) names slots per item; uniqueness below is
  -- what gives it meaning.
  submission_slot_id text not null check (char_length(submission_slot_id) between 1 and 64),

  -- Incremented when a capability is re-minted for the same slot after a
  -- terminal outcome (contract field `pairing.generation`).
  generation integer not null default 1 check (generation > 0),

  state text not null default 'issued'
    check (state in ('issued', 'paired', 'uploaded', 'consumed', 'expired', 'cancelled', 'rejected')),

  -- How the phone reached the capture page. Null until the phone pairs.
  access_path text check (access_path is null or access_path in ('QR', 'FALLBACK_DIRECT')),

  expires_at timestamptz not null,

  -- Bounded reuse: a student may retake a blurry photo against the same
  -- capability, but not indefinitely (see PAIRING_MAX_REDEMPTION_ATTEMPTS
  -- in supabase/functions/_shared/capture-pairing.ts).
  redemption_attempts integer not null default 0 check (redemption_attempts >= 0),

  -- Latest upload staged against this capability, and the attachment it was
  -- finally bound to. Both null until the corresponding step happens.
  upload_storage_path text,
  bound_attachment_id uuid references app.response_attachments(id),
  capture_quality_state text
    check (capture_quality_state is null or capture_quality_state in ('pending', 'acceptable', 'retake_required', 'indeterminate')),

  created_at timestamptz not null default now(),
  paired_at timestamptz,
  uploaded_at timestamptz,
  consumed_at timestamptz,
  closed_at timestamptz,

  constraint capture_pairing_tokens_handle_unique unique (handle_sha256)
);

comment on table app.capture_pairing_tokens is
  'Short-lived, single-use, purpose-bound capture capabilities for the QR phone leg (TASK-0016 Phase D Stage D2, DECISION-0051). Stores only the SHA-256 of each capability. Resolves user/attempt/response-version/content-item-version/submission-slot server-side so the unauthenticated phone leg never names a record. Not client-readable: RLS is on with no authenticated policies.';

comment on column app.capture_pairing_tokens.handle_sha256 is
  'SHA-256 hex of the capability. The capability is returned to the minting (authenticated) client once and never stored; this table cannot be used to recover one.';

-- At most one live capability per submission slot. This is the constraint
-- that makes cross-slot confusion impossible: a second concurrent QR code
-- for the same slot cannot exist, so a stale phone tab cannot attach to a
-- slot a newer capability owns.
create unique index capture_pairing_tokens_one_live_per_slot
  on app.capture_pairing_tokens (attempt_id, submission_slot_id)
  where state in ('issued', 'paired', 'uploaded');

create index capture_pairing_tokens_user_created_idx
  on app.capture_pairing_tokens (user_id, created_at desc);
create index capture_pairing_tokens_attempt_idx
  on app.capture_pairing_tokens (attempt_id);
-- Supports the expiry sweep (see app.expire_capture_pairing_tokens below).
create index capture_pairing_tokens_live_expiry_idx
  on app.capture_pairing_tokens (expires_at)
  where state in ('issued', 'paired', 'uploaded');

-- Binding immutability. Mirrors response_attachments_guard_immutable_fields'
-- precedent (20260815130526) and applies to service_role too, since that is
-- the only role that writes here at all.
create function app.capture_pairing_tokens_guard_immutable_fields()
returns trigger
language plpgsql
as $$
begin
  if new.handle_sha256 is distinct from old.handle_sha256
    or new.upload_purpose is distinct from old.upload_purpose
    or new.user_id is distinct from old.user_id
    or new.learning_session_id is distinct from old.learning_session_id
    or new.attempt_id is distinct from old.attempt_id
    or new.response_version_id is distinct from old.response_version_id
    or new.content_item_version_id is distinct from old.content_item_version_id
    or new.submission_slot_id is distinct from old.submission_slot_id
    or new.generation is distinct from old.generation
    or new.expires_at is distinct from old.expires_at
    or new.created_at is distinct from old.created_at
  then
    raise exception 'capture_pairing_tokens: binding and expiry fields are immutable after insert (row %)', old.id;
  end if;
  return new;
end;
$$;

create trigger capture_pairing_tokens_guard_immutable
  before update on app.capture_pairing_tokens
  for each row execute function app.capture_pairing_tokens_guard_immutable_fields();

alter table app.capture_pairing_tokens enable row level security;
-- No policy for `authenticated` on purpose: see the table comment.
grant select, insert, update on table app.capture_pairing_tokens to service_role;

-- ---------------------------------------------------------------------------
-- Append-only provenance event stream.
--
-- Shaped to the Stage D1 frozen contract
-- docs/research/grading_phase_d_spatial_2026_07_27/schemas/
-- pairing_submission_provenance_event.v1.schema.json -- the full record is
-- stored in `event` so the contract remains the single source of truth for
-- its shape, with the fields needed for indexing/ordering lifted into
-- columns. Append-only is enforced (no update, no delete, for any role).
-- ---------------------------------------------------------------------------
create table app.capture_pairing_events (
  event_id uuid primary key default gen_random_uuid(),
  pairing_id uuid not null references app.capture_pairing_tokens(id) on delete cascade,
  sequence integer not null check (sequence > 0),
  event_type text not null check (event_type in (
    'SESSION_CREATED', 'PAIRING_ACCEPTED', 'PAIRING_REJECTED', 'RECOVERY_ISSUED',
    'CAPTURE_RECORDED', 'QUALITY_RECORDED', 'RETAKE_REQUESTED', 'CAPTURE_REMOVED',
    'REVIEW_OPENED', 'SUBMISSION_ACCEPTED', 'SUBMISSION_REJECTED',
    'SESSION_CANCELLED', 'SESSION_EXPIRED'
  )),
  actor text not null check (actor in ('SYSTEM', 'LEARNER', 'PRIMARY_DEVICE', 'CAPTURE_DEVICE', 'STAFF')),
  occurred_at timestamptz not null default now(),
  -- The conforming pairing_submission_provenance_event.v1 record.
  event jsonb not null,
  created_at timestamptz not null default now(),
  constraint capture_pairing_events_sequence_unique unique (pairing_id, sequence)
);

comment on table app.capture_pairing_events is
  'Append-only pairing/submission provenance stream for QR capture. Each row''s `event` column is a pairing_submission_provenance_event.v1 record (Stage D1 frozen contract). Rows are never updated or deleted -- enforced by capture_pairing_events_guard_append_only.';

create index capture_pairing_events_pairing_idx
  on app.capture_pairing_events (pairing_id, sequence);

create function app.capture_pairing_events_guard_append_only()
returns trigger
language plpgsql
as $$
begin
  raise exception 'capture_pairing_events is append-only (attempted % on event %)',
    tg_op, coalesce(old.event_id::text, 'unknown');
end;
$$;

create trigger capture_pairing_events_guard_append_only
  before update or delete on app.capture_pairing_events
  for each row execute function app.capture_pairing_events_guard_append_only();

alter table app.capture_pairing_events enable row level security;
grant select, insert on table app.capture_pairing_events to service_role;

-- ---------------------------------------------------------------------------
-- Atomic redemption claim.
--
-- Replay prevention and rate limiting for the phone leg have to be one
-- indivisible step: read-then-update from the edge function would let two
-- concurrent submits both observe `redemption_attempts = 4` and both
-- proceed. This function takes a row lock, re-checks expiry and state under
-- it, increments the counter, and returns the row -- so a replayed or
-- parallel request loses deterministically.
--
-- Note it does NOT trust any client-supplied clock: expiry is evaluated
-- against now() inside the database.
-- ---------------------------------------------------------------------------
create function app.claim_capture_pairing_upload(
  p_handle_sha256 text,
  p_max_attempts integer,
  p_access_path text default null
)
returns app.capture_pairing_tokens
language plpgsql
security definer
set search_path = 'app', 'public'
as $$
declare
  v_row app.capture_pairing_tokens;
begin
  select * into v_row
  from app.capture_pairing_tokens
  where handle_sha256 = p_handle_sha256
  for update;

  if v_row.id is null then
    raise exception using errcode = 'P0001',
      message = 'capture_pairing:not_found';
  end if;

  if v_row.state = 'consumed' then
    raise exception using errcode = 'P0001',
      message = 'capture_pairing:already_used';
  end if;
  if v_row.state = 'cancelled' then
    raise exception using errcode = 'P0001',
      message = 'capture_pairing:cancelled';
  end if;
  if v_row.state = 'rejected' then
    raise exception using errcode = 'P0001',
      message = 'capture_pairing:rejected';
  end if;
  if v_row.state = 'expired' or v_row.expires_at <= now() then
    -- Record the expiry rather than leaving a live-looking row behind.
    update app.capture_pairing_tokens
      set state = 'expired', closed_at = coalesce(closed_at, now())
      where id = v_row.id;
    raise exception using errcode = 'P0001',
      message = 'capture_pairing:expired';
  end if;
  if v_row.redemption_attempts >= p_max_attempts then
    update app.capture_pairing_tokens
      set state = 'rejected', closed_at = coalesce(closed_at, now())
      where id = v_row.id;
    raise exception using errcode = 'P0001',
      message = 'capture_pairing:attempts_exhausted';
  end if;

  update app.capture_pairing_tokens
    set redemption_attempts = redemption_attempts + 1,
        state = case when state = 'issued' then 'paired' else state end,
        paired_at = coalesce(paired_at, now()),
        access_path = coalesce(access_path, p_access_path)
    where id = v_row.id
    returning * into v_row;

  return v_row;
end;
$$;

comment on function app.claim_capture_pairing_upload(text, integer, text) is
  'Atomically validates a capture capability (existence, state, expiry, attempt budget) under a row lock and consumes one redemption attempt. Raises capture_pairing:<reason> on refusal. This is the authoritative replay/rate-limit check; the JS equivalents in _shared/capture-pairing.ts are a fast path only.';

-- ---------------------------------------------------------------------------
-- Single-use consumption.
--
-- The compare-and-set that makes a capability single-use: only a row still
-- in 'paired'/'uploaded' can become 'consumed', so a second submit for the
-- same capability updates zero rows and is reported as a replay.
-- ---------------------------------------------------------------------------
create function app.consume_capture_pairing(
  p_pairing_id uuid,
  p_attachment_id uuid,
  p_capture_quality_state text,
  p_storage_path text
)
returns app.capture_pairing_tokens
language plpgsql
security definer
set search_path = 'app', 'public'
as $$
declare
  v_row app.capture_pairing_tokens;
begin
  update app.capture_pairing_tokens
    set state = 'consumed',
        consumed_at = now(),
        closed_at = now(),
        uploaded_at = coalesce(uploaded_at, now()),
        bound_attachment_id = p_attachment_id,
        capture_quality_state = p_capture_quality_state,
        upload_storage_path = p_storage_path
    where id = p_pairing_id
      and state in ('paired', 'uploaded')
    returning * into v_row;

  if v_row.id is null then
    raise exception using errcode = 'P0001',
      message = 'capture_pairing:not_consumable';
  end if;
  return v_row;
end;
$$;

-- ---------------------------------------------------------------------------
-- Expiry sweep / cleanup.
--
-- Stage D2 requires expiration and cleanup be real and tested, not implied
-- by a timestamp nobody acts on. This marks lapsed capabilities terminal so
-- the one-live-capability-per-slot index frees up and the primary device
-- sees a truthful state. Intended to be called on a schedule; it is also
-- safe to call inline. It deliberately does NOT delete storage objects:
-- an uploaded original that was already bound is immutable evidence, and an
-- unbound abandoned object is handled by bucket retention, not by a
-- function that could race a concurrent bind.
-- ---------------------------------------------------------------------------
create function app.expire_capture_pairing_tokens(p_limit integer default 500)
returns integer
language plpgsql
security definer
set search_path = 'app', 'public'
as $$
declare
  v_count integer;
begin
  with lapsed as (
    select id from app.capture_pairing_tokens
    where state in ('issued', 'paired', 'uploaded')
      and expires_at <= now()
    order by expires_at
    limit greatest(p_limit, 0)
    for update skip locked
  )
  update app.capture_pairing_tokens t
    set state = 'expired', closed_at = coalesce(t.closed_at, now())
    from lapsed
    where t.id = lapsed.id;
  get diagnostics v_count = row_count;
  return v_count;
end;
$$;

revoke all on function app.claim_capture_pairing_upload(text, integer, text) from public;
revoke all on function app.consume_capture_pairing(uuid, uuid, text, text) from public;
revoke all on function app.expire_capture_pairing_tokens(integer) from public;
grant execute on function app.claim_capture_pairing_upload(text, integer, text) to service_role;
grant execute on function app.consume_capture_pairing(uuid, uuid, text, text) to service_role;
grant execute on function app.expire_capture_pairing_tokens(integer) to service_role;

commit;
