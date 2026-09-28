-- TASK-0039: hardening from the independent QA pass on the BYOQ backend.
--
-- 1. Capture capabilities record the storage prefix they were minted under,
--    so a sign-in that changes the owner's namespace mid-capture cannot
--    orphan an upload, and closed capabilities can have their unsubmitted
--    (raw, unstripped) `incoming/` objects swept (`incoming_swept_at`).
-- 2. bind_byoq_attachment refuses archived items and page numbers past the
--    column's 50-page ceiling (previously a CHECK violation -> HTTP 500).
-- 3. The 30-day anonymous retention purge and the incoming sweep run on a
--    schedule: pg_cron calls app.byoq_invoke_purge(), which POSTs to the
--    byoq function with a random token held in Vault. Both Vault secrets
--    (`byoq_purge_token`, `byoq_function_url`) are set per environment at
--    deploy time (see the TASK-0039 release notes); without them the job is
--    a no-op rather than an error.
-- 4. learner-uploads gets a 20 MB object size ceiling, matching the
--    MAX_CAPTURE_BYTES limit every capture path already validates against,
--    so a signed upload URL cannot be used to store an arbitrarily large object.
-- 5. Explicitly revoke the app-schema default grants on the new tables from
--    content_reviewer (RLS already blocked it; this makes intent explicit).

begin;

create extension if not exists pg_net;

-- 1. ------------------------------------------------------------------------
alter table app.byoq_capture_pairing_tokens
  add column storage_prefix text,
  add column incoming_swept_at timestamptz;

update app.byoq_capture_pairing_tokens t
  set storage_prefix = case
    when o.user_id is not null then o.user_id::text || '/byoq/' || o.id::text
    else 'byoq-anon/' || o.id::text
  end
  from app.byoq_owners o
  where o.id = t.owner_id and t.storage_prefix is null;

alter table app.byoq_capture_pairing_tokens
  alter column storage_prefix set not null,
  add constraint byoq_tokens_storage_prefix_shape
    check (storage_prefix ~ '^(byoq-anon/[0-9a-f-]{36}|[0-9a-f-]{36}/byoq/[0-9a-f-]{36})$');

create index byoq_tokens_unswept_idx
  on app.byoq_capture_pairing_tokens (closed_at)
  where incoming_swept_at is null and state in ('consumed', 'expired', 'cancelled', 'rejected');

create or replace function app.byoq_tokens_guard_immutable_fields()
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
    or new.storage_prefix is distinct from old.storage_prefix
  then
    raise exception 'byoq_capture_pairing_tokens: binding and expiry fields are immutable after insert (row %)', old.id;
  end if;
  return new;
end;
$$;

-- 2. ------------------------------------------------------------------------
create or replace function app.bind_byoq_attachment(
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
  if exists (select 1 from app.byoq_items where id = v_token.item_id and status = 'archived') then
    raise exception using errcode = 'P0001', message = 'byoq_bind:item_archived';
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
    if v_current_count >= p_max_current_pages or v_page > 50 then
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

revoke all on function app.bind_byoq_attachment(uuid, text, text, integer, integer, integer, text, text, uuid, integer) from public;
grant execute on function app.bind_byoq_attachment(uuid, text, text, integer, integer, integer, text, text, uuid, integer) to service_role;

-- 3. ------------------------------------------------------------------------
create function app.byoq_verify_purge_token(p_token text)
returns boolean
language sql
stable
security definer
set search_path = 'pg_catalog'
as $$
  select coalesce(
    (select s.decrypted_secret = p_token
       from vault.decrypted_secrets s
      where s.name = 'byoq_purge_token'
      limit 1),
    false
  ) and char_length(coalesce(p_token, '')) >= 32
$$;

revoke all on function app.byoq_verify_purge_token(text) from public;
grant execute on function app.byoq_verify_purge_token(text) to service_role;

create function app.byoq_invoke_purge()
returns bigint
language plpgsql
security definer
set search_path = 'pg_catalog'
as $$
declare
  v_url text;
  v_token text;
begin
  select decrypted_secret into v_url from vault.decrypted_secrets where name = 'byoq_function_url' limit 1;
  select decrypted_secret into v_token from vault.decrypted_secrets where name = 'byoq_purge_token' limit 1;
  if v_url is null or v_token is null then
    return null;
  end if;
  return net.http_post(
    url := v_url,
    headers := jsonb_build_object('Content-Type', 'application/json', 'x-byoq-purge-token', v_token),
    body := jsonb_build_object('operation', 'purge'),
    timeout_milliseconds := 55000
  );
end;
$$;

revoke all on function app.byoq_invoke_purge() from public;

select cron.schedule(
  'task0039-byoq-purge',
  '7,22,37,52 * * * *',
  'select app.byoq_invoke_purge();'
);

-- 4. ------------------------------------------------------------------------
update storage.buckets
  set file_size_limit = 20971520
  where id = 'learner-uploads' and file_size_limit is null;

-- 5. ------------------------------------------------------------------------
do $$
begin
  if exists (select 1 from pg_roles where rolname = 'content_reviewer') then
    execute 'revoke all on table app.byoq_owners, app.byoq_items, app.byoq_responses, '
      'app.byoq_capture_pairing_tokens, app.byoq_attachments from content_reviewer';
  end if;
end;
$$;

commit;
