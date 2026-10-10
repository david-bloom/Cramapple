-- Hand-drawn responses on every FRQ -- hardening after independent review
-- (2026-10-09, TASK-0069). Four findings, each closed here:
--
-- H2  propose_transcript and confirm_transcript rewrote the whole
--     response_parts column from a snapshot taken before a model call; a
--     confirm landing during the call was silently erased. They now patch
--     through app.merge_response_parts(), an atomic jsonb merge under the row
--     lock that also refuses a submitted version.
-- M2  app is a PostgREST-exposed schema and response_versions_owner_update_draft
--     lets an owner update their unsubmitted rows, so a student could PATCH
--     "_confirmed_at" into response_parts and skip the confirmation step.
--     app.response_versions_guard_reserved_parts() refuses any change to a
--     key beginning with "_" from a writer other than the service role (the
--     edge functions). The student's own part texts stay writable as before.
-- M1  the 20261009230918 create-or-replace of
--     app.response_attachments_guard_immutable_fields() dropped the
--     function's search_path setting; restored here (and in that file).
-- L3  the access_path constraint swap assumed Postgres' auto name; nothing to
--     redo on a database where 20261009230918 already ran, and that file now
--     drops by definition instead of by name for Production.

-- ---------------------------------------------------------------------------
-- H2: atomic merge of response_parts (+ optional response_text)
-- ---------------------------------------------------------------------------
create or replace function app.merge_response_parts(
  p_response_version_id uuid,
  p_patch jsonb,
  p_response_text text default null,
  p_drop_keys text[] default '{}'::text[]
)
returns app.response_versions
language plpgsql
-- SECURITY INVOKER on purpose: the service role calls this, and the
-- reserved-keys trigger below identifies the service role by current_user.
-- A definer function would run as its owner and be refused by that trigger.
security invoker
set search_path = 'app', 'pg_catalog'
as $$
declare
  v_row app.response_versions;
begin
  if p_patch is null or jsonb_typeof(p_patch) <> 'object' then
    raise exception 'response_versions:invalid_patch' using errcode = '22023';
  end if;

  select * into v_row
    from app.response_versions
   where id = p_response_version_id
   for update;
  if v_row.id is null then
    raise exception 'response_versions:not_found' using errcode = 'P0002';
  end if;
  if v_row.is_submitted then
    raise exception 'response_versions:already_submitted' using errcode = 'P0001';
  end if;

  update app.response_versions
     set response_parts = (
           coalesce(case when jsonb_typeof(response_parts) = 'object' then response_parts else '{}'::jsonb end, '{}'::jsonb)
           - coalesce(p_drop_keys, '{}'::text[])
         ) || p_patch,
         response_text = coalesce(p_response_text, response_text)
   where id = p_response_version_id
  returning * into v_row;

  return v_row;
end;
$$;

revoke all on function app.merge_response_parts(uuid, jsonb, text, text[]) from public, anon, authenticated;
grant execute on function app.merge_response_parts(uuid, jsonb, text, text[]) to service_role;

comment on function app.merge_response_parts(uuid, jsonb, text, text[]) is
  'Atomic jsonb merge into an UNSUBMITTED response version''s response_parts (optionally dropping keys and setting response_text). Service role only; used by attempt-response propose_transcript / confirm_transcript so concurrent writers cannot erase each other (TASK-0069 review H2).';

-- ---------------------------------------------------------------------------
-- M2: reserved keys in response_parts are server-written only
-- ---------------------------------------------------------------------------
create or replace function app.reserved_response_parts(p jsonb)
returns jsonb
language sql
immutable
set search_path = 'pg_catalog'
as $$
  select coalesce(
    (select jsonb_object_agg(e.key, e.value)
       from jsonb_each(case when jsonb_typeof(p) = 'object' then p else '{}'::jsonb end) e
      where e.key like '\_%' escape '\'),
    '{}'::jsonb);
$$;

create or replace function app.response_versions_guard_reserved_parts()
returns trigger
language plpgsql
set search_path = 'app', 'pg_catalog'
as $$
begin
  -- The edge functions write with the service role; everyone else (owner
  -- through PostgREST, a reviewer role, an admin's own client) may not touch
  -- the transcript/confirmation bookkeeping.
  if current_user = 'service_role'
     or coalesce(current_setting('request.jwt.claim.role', true), '') = 'service_role' then
    return new;
  end if;
  if tg_op = 'INSERT' then
    if app.reserved_response_parts(new.response_parts) <> '{}'::jsonb then
      raise exception 'response_versions:reserved_keys_are_server_only' using errcode = '42501';
    end if;
    return new;
  end if;
  if app.reserved_response_parts(new.response_parts) is distinct from app.reserved_response_parts(old.response_parts) then
    raise exception 'response_versions:reserved_keys_are_server_only' using errcode = '42501';
  end if;
  return new;
end;
$$;

drop trigger if exists response_versions_guard_reserved_parts on app.response_versions;
create trigger response_versions_guard_reserved_parts
  before insert or update of response_parts on app.response_versions
  for each row execute function app.response_versions_guard_reserved_parts();

comment on function app.response_versions_guard_reserved_parts() is
  'Keys of response_parts beginning with "_" (_transcript, _source, _student_added, _confirmed_at, _confirmed_digest) can only be written by the service role. Closes the PostgREST owner-update bypass of the transcript gate (TASK-0069 review M2).';

-- ---------------------------------------------------------------------------
-- M1: restore the immutability guard's search_path (dropped by the
--     create-or-replace in 20261009230918)
-- ---------------------------------------------------------------------------
alter function app.response_attachments_guard_immutable_fields() set search_path = 'app', 'pg_catalog';
