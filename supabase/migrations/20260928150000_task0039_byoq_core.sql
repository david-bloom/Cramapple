-- TASK-0039: BYOQ (bring-your-own-question) production backend.
--
-- Governing records: DECISION-0057 (a BYOQ item never carries or reveals a
-- canonical answer, in any mode; never Open Hand; never scored),
-- DECISION-0068 / APPROVAL-0050 (Option A: fully parallel byoq_* tables, no
-- shared code path with the graded pipeline), DECISION-0076 / APPROVAL-0052
-- (phone/QR capture is the launch-required intake; typed is the fallback),
-- DECISION-0077 / APPROVAL-0053 (identity-agnostic: anonymous on the
-- marketing site, recognized-but-not-gated in the app).
--
-- STRUCTURAL GUARANTEES (enforced here, not by application code)
-- ---------------------------------------------------------------
-- * No answer-bearing column exists on any byoq_* table. There is no
--   is_correct, no criteria, no score, no result_state. MCQ choices are a
--   jsonb array whose element shape is pinned by a CHECK to exactly
--   {choice_key, choice_text} -- an `is_correct` key is rejected by the
--   database, so no future code path can smuggle one in.
-- * Nothing here references app.attempts / app.response_versions /
--   app.response_attachments / app.capture_pairing_tokens. The human-grading
--   queue, evaluate-attempt and record_manual_grade structurally cannot see a
--   byoq_* row.
-- * Ownership is carried by app.byoq_owners, which models both an anonymous
--   visitor (a server-issued secret whose SHA-256 is stored) and a recognized
--   signed-in student (user_id). Every child row is pinned to its item's owner
--   by a composite foreign key, so a row cannot be attributed to one owner
--   while pointing at another owner's item.
-- * A question may not be marked `ready` while the answer-leak heuristic
--   (BYOQ_WORKSHEET_PARSING_DESIGN.md §6, applied to typed/photo intake per
--   §6.4) still flags its text.
--
-- ACCESS POSTURE
-- --------------
-- All reads/writes go through the `byoq` edge function (service_role), which
-- resolves the caller's owner from a JWT or an owner key. RLS is enabled on
-- every table. `authenticated` gets SELECT-only policies scoped to its own
-- user_id, as defense in depth for recognized students; `anon` gets nothing.
--
-- DELIBERATE NON-GUARANTEES
-- -------------------------
-- * BYOQ photos are NOT immutable (contrast response_attachments). They are
--   ungraded and undisputed, and the most likely objects in the system to
--   hold third-party or personal material a student will want removed.
-- * Storage objects are removed by the edge function before rows are
--   deleted; a DB-level cascade alone (e.g. a future account-deletion flow)
--   would orphan objects. Account deletion has no flow anywhere yet; that is
--   a pre-existing gap, not introduced here.

begin;

-- ---------------------------------------------------------------------------
-- Owners
-- ---------------------------------------------------------------------------
create table app.byoq_owners (
  id uuid primary key default gen_random_uuid(),
  -- SHA-256 of the anonymous owner key. The key itself is returned to the
  -- browser once and never stored. Null for a keyless recognized owner.
  key_sha256 text unique check (key_sha256 is null or key_sha256 ~ '^[0-9a-f]{64}$'),
  -- Recognition metadata (DECISION-0077), never a gate.
  user_id uuid references app.profiles(user_id) on delete cascade,
  -- HMAC of the creating IP, used only to rate-limit anonymous owner
  -- creation. Never the raw address.
  created_ip_hmac text check (created_ip_hmac is null or created_ip_hmac ~ '^[0-9a-f]{64}$'),
  created_at timestamptz not null default now(),
  last_seen_at timestamptz not null default now(),
  constraint byoq_owners_has_identity check (key_sha256 is not null or user_id is not null)
);

comment on table app.byoq_owners is
  'TASK-0039 / DECISION-0077. Who owns a BYOQ item: an anonymous visitor (key_sha256 of a server-issued secret) and/or a recognized student (user_id, recognition only). Not client-readable.';

create unique index byoq_owners_one_keyless_per_user
  on app.byoq_owners (user_id) where key_sha256 is null;
create index byoq_owners_user_idx on app.byoq_owners (user_id);
create index byoq_owners_anon_last_seen_idx
  on app.byoq_owners (last_seen_at) where user_id is null;
create index byoq_owners_ip_created_idx
  on app.byoq_owners (created_ip_hmac, created_at) where created_ip_hmac is not null;

-- ---------------------------------------------------------------------------
-- Choice-shape guard: the "no is_correct column" rule, extended into jsonb.
-- ---------------------------------------------------------------------------
create function app.byoq_choices_are_answer_free(p_choices jsonb)
returns boolean
language sql
immutable
set search_path = pg_catalog
as $$
  select jsonb_typeof(p_choices) = 'array'
    and jsonb_array_length(p_choices) <= 6
    and not exists (
      select 1
      from jsonb_array_elements(p_choices) as e(v)
      where jsonb_typeof(e.v) <> 'object'
         or (select array_agg(k order by k) from jsonb_object_keys(e.v) as k)
              is distinct from array['choice_key', 'choice_text']
         or jsonb_typeof(e.v -> 'choice_key') <> 'string'
         or jsonb_typeof(e.v -> 'choice_text') <> 'string'
         or (e.v ->> 'choice_key') !~ '^[A-F]$'
         or char_length(e.v ->> 'choice_text') not between 1 and 1000
    )
$$;

comment on function app.byoq_choices_are_answer_free(jsonb) is
  'DECISION-0057: a BYOQ MCQ choice is exactly {choice_key, choice_text}. Any other key (is_correct, rationale, ...) fails the CHECK that uses this.';

-- ---------------------------------------------------------------------------
-- Items
-- ---------------------------------------------------------------------------
create table app.byoq_items (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null references app.byoq_owners(id) on delete cascade,
  user_id uuid references app.profiles(user_id) on delete cascade,
  -- Human-typeable lookup code, unique per owner (not globally) so a code is
  -- not a cross-student existence oracle.
  code text not null check (code ~ '^BQ-[23456789ABCDEFGHJKMNPQRSTUVWXYZ]{6}$'),
  item_type text check (item_type is null or item_type in ('mcq', 'frq')),
  title text check (title is null or char_length(title) between 1 and 140),
  stem text check (stem is null or char_length(stem) <= 6000),
  choices jsonb not null default '[]'::jsonb
    check (app.byoq_choices_are_answer_free(choices)),
  subject_key text check (subject_key is null or subject_key ~ '^[a-z0-9_]{2,64}$'),
  taxonomy_topic_id uuid references app.taxonomy_topics(taxonomy_topic_id) on delete set null,
  difficulty text check (difficulty is null or difficulty in ('easy', 'medium', 'hard')),
  source_kind text not null default 'typed'
    check (source_kind in ('typed', 'photo_single', 'worksheet_split')),
  -- "Where is this question from?" (STUDENT_PROVIDED_QUESTION_INTAKE_DESIGN.md)
  source_note text check (source_note is null or char_length(source_note) <= 200),
  status text not null default 'draft' check (status in ('draft', 'ready', 'archived')),
  -- Answer-leak heuristic output for the CURRENT text: [{field, index, start, end, rule}].
  leak_flags jsonb not null default '[]'::jsonb check (jsonb_typeof(leak_flags) = 'array'),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  confirmed_at timestamptz,
  last_practiced_at timestamptz,
  constraint byoq_items_code_unique_per_owner unique (owner_id, code),
  constraint byoq_items_id_owner_unique unique (id, owner_id),
  constraint byoq_items_ready_is_complete check (
    status <> 'ready' or (
      item_type is not null
      and stem is not null and char_length(btrim(stem)) > 0
      and jsonb_array_length(leak_flags) = 0
      and (
        (item_type = 'frq' and jsonb_array_length(choices) = 0)
        or (item_type = 'mcq' and jsonb_array_length(choices) between 2 and 6)
      )
    )
  )
);

comment on table app.byoq_items is
  'TASK-0039. A student-supplied question. Practice-only, never Open Hand, never scored (DECISION-0057). Carries no answer by construction. Private to its owner; any future public/SEO promotion path must pass a moderation step first and must not read this table directly.';

create index byoq_items_owner_created_idx on app.byoq_items (owner_id, created_at desc);
create index byoq_items_user_idx on app.byoq_items (user_id) where user_id is not null;

create trigger byoq_items_set_updated_at
  before update on app.byoq_items
  for each row execute function app.set_updated_at();

-- ---------------------------------------------------------------------------
-- Responses: attempts, saved versions, retake lineage. No score, ever.
-- ---------------------------------------------------------------------------
create table app.byoq_responses (
  id uuid primary key default gen_random_uuid(),
  item_id uuid not null,
  owner_id uuid not null,
  attempt_number integer not null check (attempt_number between 1 and 500),
  version_number integer not null check (version_number between 1 and 500),
  parent_response_id uuid references app.byoq_responses(id) on delete set null,
  selected_choice_key text check (selected_choice_key is null or selected_choice_key ~ '^[A-F]$'),
  response_text text check (response_text is null or char_length(response_text) <= 20000),
  is_final boolean not null default false,
  created_at timestamptz not null default now(),
  constraint byoq_responses_item_owner_fk foreign key (item_id, owner_id)
    references app.byoq_items (id, owner_id) on delete cascade,
  constraint byoq_responses_version_unique unique (item_id, attempt_number, version_number),
  constraint byoq_responses_id_item_unique unique (id, item_id)
);

comment on table app.byoq_responses is
  'TASK-0039. A student''s saved work on their own BYOQ item. Deliberately has no grading columns and no path to the human-grading queue.';

create index byoq_responses_item_idx on app.byoq_responses (item_id, attempt_number, version_number);

-- ---------------------------------------------------------------------------
-- QR capture capabilities (question photo and hand-drawn response photo)
-- ---------------------------------------------------------------------------
create table app.byoq_capture_pairing_tokens (
  id uuid primary key default gen_random_uuid(),
  handle_sha256 text not null unique check (handle_sha256 ~ '^[0-9a-f]{64}$'),
  owner_id uuid not null,
  item_id uuid not null,
  capture_role text not null check (capture_role in ('question', 'response')),
  response_id uuid,
  part_key text not null default 'whole' check (part_key ~ '^[a-z0-9_]{1,32}$'),
  generation integer not null default 1 check (generation > 0),
  state text not null default 'issued'
    check (state in ('issued', 'paired', 'uploaded', 'consumed', 'expired', 'cancelled', 'rejected')),
  access_path text check (access_path is null or access_path in ('QR', 'FALLBACK_DIRECT')),
  expires_at timestamptz not null,
  redemption_attempts integer not null default 0 check (redemption_attempts >= 0),
  uploads_bound integer not null default 0 check (uploads_bound >= 0),
  created_at timestamptz not null default now(),
  paired_at timestamptz,
  uploaded_at timestamptz,
  consumed_at timestamptz,
  closed_at timestamptz,
  constraint byoq_tokens_item_owner_fk foreign key (item_id, owner_id)
    references app.byoq_items (id, owner_id) on delete cascade,
  constraint byoq_tokens_response_item_fk foreign key (response_id, item_id)
    references app.byoq_responses (id, item_id) on delete cascade,
  constraint byoq_tokens_role_matches_response
    check ((capture_role = 'response') = (response_id is not null))
);

comment on table app.byoq_capture_pairing_tokens is
  'TASK-0039 Phase 2. Short-lived, purpose-bound capture capabilities for the BYOQ phone leg. Stores only the SHA-256 of each capability. Parallel to (never shared with) app.capture_pairing_tokens. Not client-readable.';

create unique index byoq_tokens_one_live_per_slot
  on app.byoq_capture_pairing_tokens (
    item_id, capture_role,
    coalesce(response_id, '00000000-0000-0000-0000-000000000000'::uuid),
    part_key
  )
  where state in ('issued', 'paired', 'uploaded');
create index byoq_tokens_owner_created_idx
  on app.byoq_capture_pairing_tokens (owner_id, created_at desc);
create index byoq_tokens_live_expiry_idx
  on app.byoq_capture_pairing_tokens (expires_at)
  where state in ('issued', 'paired', 'uploaded');

create function app.byoq_tokens_guard_immutable_fields()
returns trigger
language plpgsql
set search_path = pg_catalog
as $$
begin
  if new.handle_sha256 is distinct from old.handle_sha256
    or new.owner_id is distinct from old.owner_id
    or new.item_id is distinct from old.item_id
    or new.capture_role is distinct from old.capture_role
    or new.response_id is distinct from old.response_id
    or new.part_key is distinct from old.part_key
    or new.generation is distinct from old.generation
    or new.expires_at is distinct from old.expires_at
    or new.created_at is distinct from old.created_at
  then
    raise exception 'byoq_capture_pairing_tokens: binding and expiry fields are immutable after insert (row %)', old.id;
  end if;
  return new;
end;
$$;

create trigger byoq_tokens_guard_immutable
  before update on app.byoq_capture_pairing_tokens
  for each row execute function app.byoq_tokens_guard_immutable_fields();

-- ---------------------------------------------------------------------------
-- Attachments (question photos and response photos), multi-part/multi-page.
-- ---------------------------------------------------------------------------
create table app.byoq_attachments (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null,
  item_id uuid not null,
  capture_role text not null check (capture_role in ('question', 'response')),
  response_id uuid,
  part_key text not null default 'whole' check (part_key ~ '^[a-z0-9_]{1,32}$'),
  page_sequence integer not null default 1 check (page_sequence between 1 and 50),
  kind text not null default 'original' check (kind in ('original', 'derived')),
  storage_bucket text not null default 'learner-uploads' check (storage_bucket = 'learner-uploads'),
  storage_path text not null unique,
  media_type text not null check (media_type in ('image/jpeg', 'image/png', 'image/webp')),
  byte_size integer not null check (byte_size > 0),
  pixel_width integer check (pixel_width is null or pixel_width > 0),
  pixel_height integer check (pixel_height is null or pixel_height > 0),
  sha256_digest text not null check (sha256_digest ~ '^[0-9a-f]{64}$'),
  metadata_status text not null check (metadata_status in ('STRIPPED', 'NOT_PRESENT', 'UNKNOWN')),
  is_current boolean not null default true,
  replaces_attachment_id uuid references app.byoq_attachments(id) on delete set null,
  pairing_token_id uuid references app.byoq_capture_pairing_tokens(id) on delete set null,
  created_at timestamptz not null default now(),
  constraint byoq_attachments_item_owner_fk foreign key (item_id, owner_id)
    references app.byoq_items (id, owner_id) on delete cascade,
  constraint byoq_attachments_response_item_fk foreign key (response_id, item_id)
    references app.byoq_responses (id, item_id) on delete cascade,
  constraint byoq_attachments_role_matches_response
    check ((capture_role = 'response') = (response_id is not null))
);

comment on table app.byoq_attachments is
  'TASK-0039 Phase 2. One uploaded, metadata-stripped image bound to a BYOQ item (question role) or to one saved response (response role). part_key/page_sequence support multi-part and multi-page answers. Owner-deletable by design (no immutability trigger).';

-- One current original per (item, role, response, part, page). part_key and
-- page_sequence are NOT NULL precisely so this index cannot be defeated by a
-- NULL that compares distinct from every other NULL.
create unique index byoq_attachments_one_current_page
  on app.byoq_attachments (
    item_id, capture_role,
    coalesce(response_id, '00000000-0000-0000-0000-000000000000'::uuid),
    part_key, page_sequence
  )
  where kind = 'original' and is_current;
create index byoq_attachments_item_idx on app.byoq_attachments (item_id, capture_role);
create index byoq_attachments_owner_idx on app.byoq_attachments (owner_id);

-- ---------------------------------------------------------------------------
-- Atomic capability claim (replay + attempt budget + expiry under a row lock).
-- ---------------------------------------------------------------------------
create function app.claim_byoq_capture_upload(
  p_handle_sha256 text,
  p_max_attempts integer,
  p_access_path text default null
)
returns app.byoq_capture_pairing_tokens
language plpgsql
security definer
set search_path = 'app', 'public'
as $$
declare
  v_row app.byoq_capture_pairing_tokens;
begin
  select * into v_row
  from app.byoq_capture_pairing_tokens
  where handle_sha256 = p_handle_sha256
  for update;

  if v_row.id is null then
    raise exception using errcode = 'P0001', message = 'byoq_pairing:not_found';
  end if;
  if v_row.state = 'consumed' then
    raise exception using errcode = 'P0001', message = 'byoq_pairing:already_used';
  end if;
  if v_row.state = 'cancelled' then
    raise exception using errcode = 'P0001', message = 'byoq_pairing:cancelled';
  end if;
  if v_row.state = 'rejected' then
    raise exception using errcode = 'P0001', message = 'byoq_pairing:rejected';
  end if;
  if v_row.state = 'expired' then
    raise exception using errcode = 'P0001', message = 'byoq_pairing:expired';
  end if;

  -- Just-now-terminal transitions are RETURNED, not raised, so the terminal
  -- state commits (same reasoning as app.claim_capture_pairing_upload).
  if v_row.expires_at <= now() then
    update app.byoq_capture_pairing_tokens
      set state = 'expired', closed_at = coalesce(closed_at, now())
      where id = v_row.id
      returning * into v_row;
    return v_row;
  end if;
  if v_row.redemption_attempts >= p_max_attempts then
    update app.byoq_capture_pairing_tokens
      set state = 'rejected', closed_at = coalesce(closed_at, now())
      where id = v_row.id
      returning * into v_row;
    return v_row;
  end if;

  update app.byoq_capture_pairing_tokens
    set redemption_attempts = redemption_attempts + 1,
        state = case when state = 'issued' then 'paired' else state end,
        paired_at = coalesce(paired_at, now()),
        access_path = coalesce(access_path, p_access_path)
    where id = v_row.id
    returning * into v_row;
  return v_row;
end;
$$;

-- ---------------------------------------------------------------------------
-- Atomic bind. Every binding fact (owner, item, role, response, part) is
-- derived from the capability row, never accepted from the caller.
-- ---------------------------------------------------------------------------
create function app.bind_byoq_attachment(
  p_pairing_id uuid,
  p_storage_path text,
  p_media_type text,
  p_byte_size integer,
  p_pixel_width integer,
  p_pixel_height integer,
  p_sha256_digest text,
  p_metadata_status text,
  p_replaces_attachment_id uuid,
  p_max_current_pages integer
)
returns app.byoq_attachments
language plpgsql
security definer
set search_path = 'app', 'public'
as $$
declare
  v_token app.byoq_capture_pairing_tokens;
  v_prior app.byoq_attachments;
  v_page integer;
  v_current_count integer;
  v_row app.byoq_attachments;
  v_nil constant uuid := '00000000-0000-0000-0000-000000000000';
begin
  select * into v_token
  from app.byoq_capture_pairing_tokens
  where id = p_pairing_id
  for update;

  if v_token.id is null then
    raise exception using errcode = 'P0001', message = 'byoq_bind:pairing_not_found';
  end if;
  if v_token.state not in ('paired', 'uploaded') then
    raise exception using errcode = 'P0001', message = 'byoq_bind:pairing_not_live';
  end if;
  if v_token.expires_at <= now() then
    raise exception using errcode = 'P0001', message = 'byoq_bind:pairing_expired';
  end if;

  if p_replaces_attachment_id is not null then
    select * into v_prior
    from app.byoq_attachments
    where id = p_replaces_attachment_id
    for update;
    if v_prior.id is null
      or v_prior.item_id <> v_token.item_id
      or v_prior.capture_role <> v_token.capture_role
      or coalesce(v_prior.response_id, v_nil) <> coalesce(v_token.response_id, v_nil)
      or v_prior.part_key <> v_token.part_key
      or v_prior.kind <> 'original'
    then
      raise exception using errcode = 'P0001', message = 'byoq_bind:invalid_retake_target';
    end if;
    if not v_prior.is_current then
      raise exception using errcode = 'P0001', message = 'byoq_bind:stale_retake_target';
    end if;
    update app.byoq_attachments set is_current = false where id = v_prior.id;
    v_page := v_prior.page_sequence;
  else
    select count(*), coalesce(max(page_sequence), 0) + 1
      into v_current_count, v_page
    from app.byoq_attachments
    where item_id = v_token.item_id
      and capture_role = v_token.capture_role
      and coalesce(response_id, v_nil) = coalesce(v_token.response_id, v_nil)
      and part_key = v_token.part_key
      and kind = 'original'
      and is_current;
    if v_current_count >= p_max_current_pages then
      raise exception using errcode = 'P0001', message = 'byoq_bind:page_limit_reached';
    end if;
  end if;

  insert into app.byoq_attachments (
    owner_id, item_id, capture_role, response_id, part_key, page_sequence,
    kind, storage_path, media_type, byte_size, pixel_width, pixel_height,
    sha256_digest, metadata_status, is_current, replaces_attachment_id,
    pairing_token_id
  ) values (
    v_token.owner_id, v_token.item_id, v_token.capture_role, v_token.response_id,
    v_token.part_key, v_page, 'original', p_storage_path, p_media_type,
    p_byte_size, p_pixel_width, p_pixel_height, p_sha256_digest,
    p_metadata_status, true, p_replaces_attachment_id, v_token.id
  )
  returning * into v_row;

  update app.byoq_capture_pairing_tokens
    set state = 'uploaded',
        uploaded_at = coalesce(uploaded_at, now()),
        uploads_bound = uploads_bound + 1
    where id = v_token.id;

  return v_row;
end;
$$;

-- ---------------------------------------------------------------------------
-- Expiry sweep (DB-only; scheduled below).
-- ---------------------------------------------------------------------------
create function app.expire_byoq_capture_pairing_tokens(p_limit integer default 500)
returns integer
language plpgsql
security definer
set search_path = 'app', 'public'
as $$
declare
  v_count integer;
begin
  with lapsed as (
    select id from app.byoq_capture_pairing_tokens
    where state in ('issued', 'paired', 'uploaded')
      and expires_at <= now()
    order by expires_at
    limit greatest(p_limit, 0)
    for update skip locked
  )
  update app.byoq_capture_pairing_tokens t
    set state = case when t.uploads_bound > 0 then 'consumed' else 'expired' end,
        consumed_at = case when t.uploads_bound > 0 then coalesce(t.consumed_at, now()) else t.consumed_at end,
        closed_at = coalesce(t.closed_at, now())
    from lapsed
    where t.id = lapsed.id;
  get diagnostics v_count = row_count;
  return v_count;
end;
$$;

revoke all on function app.claim_byoq_capture_upload(text, integer, text) from public;
revoke all on function app.bind_byoq_attachment(uuid, text, text, integer, integer, integer, text, text, uuid, integer) from public;
revoke all on function app.expire_byoq_capture_pairing_tokens(integer) from public;
grant execute on function app.claim_byoq_capture_upload(text, integer, text) to service_role;
grant execute on function app.bind_byoq_attachment(uuid, text, text, integer, integer, integer, text, text, uuid, integer) to service_role;
grant execute on function app.expire_byoq_capture_pairing_tokens(integer) to service_role;

-- ---------------------------------------------------------------------------
-- RLS and grants
-- ---------------------------------------------------------------------------
alter table app.byoq_owners enable row level security;
alter table app.byoq_items enable row level security;
alter table app.byoq_responses enable row level security;
alter table app.byoq_capture_pairing_tokens enable row level security;
alter table app.byoq_attachments enable row level security;

revoke all on table app.byoq_owners, app.byoq_items, app.byoq_responses,
  app.byoq_capture_pairing_tokens, app.byoq_attachments from anon, authenticated;

grant select, insert, update, delete on table app.byoq_owners, app.byoq_items,
  app.byoq_responses, app.byoq_capture_pairing_tokens, app.byoq_attachments to service_role;

grant select on table app.byoq_items, app.byoq_responses, app.byoq_attachments to authenticated;

create policy byoq_items_owner_select on app.byoq_items
  for select to authenticated
  using (user_id = auth.uid());

create policy byoq_responses_owner_select on app.byoq_responses
  for select to authenticated
  using (exists (
    select 1 from app.byoq_items i
    where i.id = byoq_responses.item_id and i.user_id = auth.uid()
  ));

create policy byoq_attachments_owner_select on app.byoq_attachments
  for select to authenticated
  using (exists (
    select 1 from app.byoq_items i
    where i.id = byoq_attachments.item_id and i.user_id = auth.uid()
  ));

-- byoq_owners and byoq_capture_pairing_tokens: RLS on, no client policy at all.

select cron.schedule(
  'task0039-expire-byoq-pairings',
  '*/15 * * * *',
  'select app.expire_byoq_capture_pairing_tokens();'
);

commit;
