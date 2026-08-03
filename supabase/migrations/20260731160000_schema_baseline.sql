-- ===========================================================================
-- Cramapple schema baseline
--
-- Provenance: pg_dump --schema-only --schema=app --schema=public --no-owner
-- taken from Production (pcntajvbdfqhbeewmdry) on 2026-07-31.
--
-- This file supersedes the 70-migration history recorded in Production's
-- supabase_migrations.schema_migrations. That history is preserved verbatim
-- under supabase/history/ and is NOT replayable: 6 of its migrations assert
-- app-authored content that no migration creates, and 11 objects in Production
-- were created by hand outside migration control entirely.
--
-- Hand-made objects captured here that NO migration ever created:
--   app.profiles.review_queue_scope            (column)
--   app.frq_synthetic_responses                (table)
--   app.student_memory_events                  (table)
--   app.student_memory_snapshots               (table)
--   app.subject_guidance_profiles              (table)
--   app.apply_student_memory_event()           (function)
--   app.compose_learning_runtime_context()     (function)
--   app.tg_content_pipeline_guard_publish()    (function)
--   app.tg_content_pipeline_on_assignment()    (function)
--   content_reviewer                           (ROLE — only pg_dump surfaced it)
--
-- Everything after this baseline is an ordinary 14-digit forward migration
-- created with `supabase migration new`.
-- ===========================================================================

-- Platform schemas: never fail if the environment already provides them.
create schema if not exists app;
create schema if not exists public;

-- Custom role referenced by GRANTs below. pg_dump emits the grants but not the
-- role (that lives in pg_dumpall --roles-only), so it must be declared here or
-- every GRANT to it fails on a fresh database.
do $$
begin
  if not exists (select 1 from pg_roles where rolname = 'content_reviewer') then
    create role content_reviewer nologin noinherit;
  end if;
end
$$;

--
-- PostgreSQL database dump
--

\restrict Kl4mlZmDIxz3oCliWI55VDzEpghmcuVukscAM3d0dT5a1TPxdrB9cFPYBhoJMSm

-- Dumped from database version 17.6
-- Dumped by pg_dump version 17.10 (Homebrew)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: app; Type: SCHEMA; Schema: -; Owner: -
--



--
-- Name: SCHEMA app; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA app IS 'Cramapple application schema';


--
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--



--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- Name: apply_student_memory_event(); Type: FUNCTION; Schema: app; Owner: -
--

CREATE FUNCTION app.apply_student_memory_event() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare
  next_state jsonb;
  next_event_at timestamptz;
  next_event_kind text;
begin
  next_state := coalesce(new.event_payload -> 'memory_state', '{}'::jsonb);
  next_event_at := coalesce(
    (new.event_payload ->> 'event_at')::timestamptz,
    new.created_at
  );
  next_event_kind := coalesce(
    new.event_payload ->> 'event_kind',
    new.event_kind
  );

  insert into app.student_memory_snapshots (
    user_id,
    subject_id,
    memory_state,
    state_version,
    evidence_count,
    last_event_id,
    last_event_kind,
    last_event_at
  )
  values (
    new.user_id,
    new.subject_id,
    next_state,
    '2026-07-07',
    1,
    new.id,
    next_event_kind,
    next_event_at
  )
  on conflict (user_id, subject_id)
  do update set
    memory_state = excluded.memory_state,
    state_version = excluded.state_version,
    evidence_count = app.student_memory_snapshots.evidence_count + 1,
    last_event_id = excluded.last_event_id,
    last_event_kind = excluded.last_event_kind,
    last_event_at = excluded.last_event_at,
    updated_at = now();

  return new;
end;
$$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: model_usage_ledger; Type: TABLE; Schema: app; Owner: -
--

CREATE TABLE app.model_usage_ledger (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    request_id text NOT NULL,
    request_hash text NOT NULL,
    usage_date_utc date NOT NULL,
    reserved_cost_usd numeric(10,4) NOT NULL,
    actual_cost_usd numeric(10,4),
    status text NOT NULL,
    model_id text NOT NULL,
    input_tokens integer,
    output_tokens integer,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    completed_at timestamp with time zone,
    CONSTRAINT model_usage_ledger_status_check CHECK ((status = ANY (ARRAY['reserved'::text, 'running'::text, 'completed'::text, 'failed'::text, 'rejected'::text])))
);


--
-- Name: complete_model_usage(text, text, text, numeric, integer, integer); Type: FUNCTION; Schema: app; Owner: -
--

CREATE FUNCTION app.complete_model_usage(p_request_id text, p_request_hash text, p_status text, p_actual_cost_usd numeric, p_input_tokens integer, p_output_tokens integer) RETURNS app.model_usage_ledger
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'app', 'public'
    AS $$
declare
  existing app.model_usage_ledger%rowtype;
  prior_reserved numeric(10,4);
  burn_cost numeric(10,4);
begin
  select * into existing from app.model_usage_ledger
  where request_id = p_request_id and request_hash = p_request_hash for update;

  if not found then raise exception 'usage request not found'; end if;
  if existing.status not in ('reserved', 'running') then return existing; end if;

  prior_reserved := existing.reserved_cost_usd;
  burn_cost := case
    when p_status = 'completed' then coalesce(p_actual_cost_usd, 0)
    when p_actual_cost_usd is not null then p_actual_cost_usd
    else 0
  end;

  update app.model_usage_ledger set
    status = p_status, actual_cost_usd = p_actual_cost_usd,
    input_tokens = p_input_tokens, output_tokens = p_output_tokens, completed_at = now()
  where request_id = p_request_id and request_hash = p_request_hash
  returning * into existing;

  update app.daily_budgets set
    reserved_cost_usd = greatest(0, reserved_cost_usd - prior_reserved),
    actual_cost_usd = actual_cost_usd + burn_cost
  where usage_date_utc = existing.usage_date_utc;

  return existing;
end;
$$;


--
-- Name: compose_learning_runtime_context(uuid); Type: FUNCTION; Schema: app; Owner: -
--

CREATE FUNCTION app.compose_learning_runtime_context(p_session_id uuid) RETURNS jsonb
    LANGUAGE sql STABLE
    SET search_path TO 'app', 'public'
    AS $$
  with session_row as (
    select
      ls.id,
      ls.user_id,
      ls.exam_pack_version_id,
      ls.entry_path,
      ls.session_mode,
      ls.available_minutes,
      ls.status,
      ls.started_at,
      ls.ended_at,
      ls.created_at,
      ls.updated_at
    from app.learning_sessions ls
    where ls.id = p_session_id
  ),
  exam_pack_version_row as (
    select
      epv.id,
      epv.exam_pack_id,
      epv.school_year,
      epv.official_exam_date,
      epv.status,
      epv.source_uri,
      epv.source_published_at,
      epv.released_at,
      epv.created_at,
      epv.updated_at
    from app.exam_pack_versions epv
    join session_row sr on sr.exam_pack_version_id = epv.id
  ),
  exam_pack_row as (
    select
      ep.id,
      ep.exam_code,
      ep.exam_name,
      ep.subject_id,
      ep.created_at,
      ep.updated_at
    from app.exam_packs ep
    join exam_pack_version_row epv on epv.exam_pack_id = ep.id
  ),
  subject_row as (
    select
      s.id,
      s.subject_key,
      s.display_name,
      s.status,
      s.created_at,
      s.updated_at
    from app.subjects s
    join exam_pack_row ep on ep.subject_id = s.id
  ),
  guidance_row as (
    select
      sgp.profile_version,
      sgp.guidance_defaults,
      sgp.status,
      sgp.created_at,
      sgp.updated_at
    from app.subject_guidance_profiles sgp
    join subject_row s on sgp.subject_id = s.id
    order by sgp.updated_at desc
    limit 1
  ),
  memory_row as (
    select
      sms.memory_state,
      sms.state_version,
      sms.evidence_count,
      sms.last_event_id,
      sms.last_event_kind,
      sms.last_event_at,
      sms.created_at,
      sms.updated_at
    from app.student_memory_snapshots sms
    join session_row sr on sms.user_id = sr.user_id
    join subject_row s on sms.subject_id = s.id
  ),
  recent_attempts as (
    select coalesce(
      jsonb_agg(
        jsonb_build_object(
          'id', a.id,
          'content_item_version_id', a.content_item_version_id,
          'attempt_mode', a.attempt_mode,
          'status', a.status,
          'assistance_state', a.assistance_state,
          'started_at', a.started_at,
          'submitted_at', a.submitted_at,
          'graded_at', a.graded_at,
          'score_points', a.score_points,
          'score_possible', a.score_possible,
          'confidence_level', a.confidence_level,
          'result_state', a.result_state,
          'result_summary', a.result_summary
        )
        order by a.started_at desc
      ),
      '[]'::jsonb
    ) as items
    from (
      select
        a.id,
        a.content_item_version_id,
        a.attempt_mode,
        a.status,
        a.assistance_state,
        a.started_at,
        a.submitted_at,
        a.graded_at,
        a.score_points,
        a.score_possible,
        a.confidence_level,
        a.result_state,
        a.result_summary
      from app.attempts a
      join session_row sr on a.learning_session_id = sr.id
      order by a.started_at desc
      limit 5
    ) a
  )
  select jsonb_build_object(
    'context_version', '2026-07-07',
    'subject_defaults',
      jsonb_build_object(
        'subject', jsonb_build_object(
          'id', subject_row.id,
          'subject_key', subject_row.subject_key,
          'display_name', subject_row.display_name,
          'status', subject_row.status
        ),
        'exam_pack', jsonb_build_object(
          'id', exam_pack_row.id,
          'exam_code', exam_pack_row.exam_code,
          'exam_name', exam_pack_row.exam_name
        ),
        'exam_pack_version', jsonb_build_object(
          'id', exam_pack_version_row.id,
          'school_year', exam_pack_version_row.school_year,
          'official_exam_date', exam_pack_version_row.official_exam_date,
          'status', exam_pack_version_row.status
        ),
        'guidance_defaults', coalesce(guidance_row.guidance_defaults, '{}'::jsonb)
      ),
    'student_memory',
      jsonb_build_object(
        'memory_state', coalesce(memory_row.memory_state, '{}'::jsonb),
        'state_version', coalesce(memory_row.state_version, '2026-07-07'),
        'evidence_count', coalesce(memory_row.evidence_count, 0),
        'last_event_id', memory_row.last_event_id,
        'last_event_kind', memory_row.last_event_kind,
        'last_event_at', memory_row.last_event_at
      ),
    'session_state',
      jsonb_build_object(
        'id', session_row.id,
        'user_id', session_row.user_id,
        'exam_pack_version_id', session_row.exam_pack_version_id,
        'entry_path', session_row.entry_path,
        'session_mode', session_row.session_mode,
        'available_minutes', session_row.available_minutes,
        'status', session_row.status,
        'started_at', session_row.started_at,
        'ended_at', session_row.ended_at,
        'recent_attempts', recent_attempts.items
      ),
    'effective_guidance',
      coalesce(guidance_row.guidance_defaults, '{}'::jsonb)
      || coalesce(memory_row.memory_state, '{}'::jsonb)
      || jsonb_build_object(
        'current_session_mode', session_row.session_mode,
        'current_entry_path', session_row.entry_path,
        'available_minutes', session_row.available_minutes,
        'session_status', session_row.status
      )
  )
  from session_row
  join exam_pack_version_row on true
  join exam_pack_row on true
  join subject_row on true
  left join guidance_row on true
  left join memory_row on true
  left join recent_attempts on true;
$$;


--
-- Name: content_item_is_published(uuid); Type: FUNCTION; Schema: app; Owner: -
--

CREATE FUNCTION app.content_item_is_published(p_content_item_id uuid) RETURNS boolean
    LANGUAGE sql STABLE SECURITY DEFINER
    SET search_path TO 'app', 'pg_temp'
    AS $$
  select exists (
    select 1
    from app.content_items ci
    join app.exam_pack_versions epv
      on epv.id = ci.exam_pack_version_id
    where ci.id = p_content_item_id
      and ci.status = 'published'
      and epv.status = 'published'
  );
$$;


--
-- Name: enforce_content_items_frq_form(); Type: FUNCTION; Schema: app; Owner: -
--

CREATE FUNCTION app.enforce_content_items_frq_form() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
  if new.item_type = 'frq' and new.frq_form is null then
    raise exception
      'frq_form is required when item_type is ''frq'' (content_key: %)',
      new.content_key;
  end if;
  if new.item_type <> 'frq' and new.frq_form is not null then
    raise exception
      'frq_form must be null when item_type is not ''frq'' (content_key: %)',
      new.content_key;
  end if;
  return new;
end;
$$;


--
-- Name: enforce_full_exam_frq_criteria(); Type: FUNCTION; Schema: app; Owner: -
--

CREATE FUNCTION app.enforce_full_exam_frq_criteria() RETURNS trigger
    LANGUAGE plpgsql
    SET search_path TO 'pg_catalog'
    AS $$
begin
  perform app.validate_full_exam_frq_version(
    case
      when tg_op = 'DELETE' then old.content_item_version_id
      else new.content_item_version_id
    end
  );
  if tg_op = 'DELETE' then
    return old;
  end if;
  return new;
end
$$;


--
-- Name: enforce_full_exam_frq_version(); Type: FUNCTION; Schema: app; Owner: -
--

CREATE FUNCTION app.enforce_full_exam_frq_version() RETURNS trigger
    LANGUAGE plpgsql
    SET search_path TO 'pg_catalog'
    AS $$
begin
  perform app.validate_full_exam_frq_version(new.id);
  return new;
end
$$;


--
-- Name: handle_new_user(); Type: FUNCTION; Schema: app; Owner: -
--

CREATE FUNCTION app.handle_new_user() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'app', 'public'
    AS $$
begin
  insert into app.profiles (user_id, full_name, role)
  values (
    new.id,
    coalesce(
      nullif(new.raw_user_meta_data ->> 'full_name', ''),
      split_part(coalesce(new.email, ''), '@', 1)
    ),
    'student'
  );
  return new;
end;
$$;


--
-- Name: lock_content_review_submission(); Type: FUNCTION; Schema: app; Owner: -
--

CREATE FUNCTION app.lock_content_review_submission() RETURNS trigger
    LANGUAGE plpgsql
    SET search_path TO ''
    AS $$
declare
  assignment_row app.content_review_assignments%rowtype;
begin
  -- Serialize every submission attempt for this assignment. The row lock is
  -- held until the decision insert commits or rolls back.
  select *
    into assignment_row
    from app.content_review_assignments
   where content_review_assignment_id = new.content_review_assignment_id
   for update;

  if not found then
    raise exception using
      errcode = 'P0001',
      message = 'review_submission:assignment_not_found';
  end if;

  if assignment_row.status not in ('pending', 'in_progress') then
    raise exception using
      errcode = 'P0001',
      message = 'review_submission:assignment_locked';
  end if;

  if exists (
    select 1
      from app.content_review_decisions
     where content_review_assignment_id = new.content_review_assignment_id
  ) then
    raise exception using
      errcode = 'P0001',
      message = 'review_submission:assignment_locked';
  end if;

  if new.reviewer_id is distinct from assignment_row.reviewer_id then
    raise exception using
      errcode = 'P0001',
      message = 'review_submission:reviewer_mismatch';
  end if;

  if new.review_stage is distinct from assignment_row.review_stage then
    raise exception using
      errcode = 'P0001',
      message = 'review_submission:stage_mismatch';
  end if;

  -- This update is in the same transaction as the immutable decision insert.
  -- If any later constraint or trigger rejects the decision, it rolls back.
  update app.content_review_assignments
     set status = 'submitted'
   where content_review_assignment_id = new.content_review_assignment_id;

  return new;
end;
$$;


--
-- Name: FUNCTION lock_content_review_submission(); Type: COMMENT; Schema: app; Owner: -
--

COMMENT ON FUNCTION app.lock_content_review_submission() IS 'Serializes one immutable review decision per assignment and atomically marks the assignment submitted.';


--
-- Name: prevent_client_grading_truth_update(); Type: FUNCTION; Schema: app; Owner: -
--

CREATE FUNCTION app.prevent_client_grading_truth_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
  if coalesce(current_setting('request.jwt.claim.role', true), '') <> 'service_role' then
    if new.score_points is distinct from old.score_points
      or new.score_possible is distinct from old.score_possible
      or new.graded_at is distinct from old.graded_at
      or new.confidence_level is distinct from old.confidence_level
      or new.result_state is distinct from old.result_state
      or new.result_summary is distinct from old.result_summary
      or (
        old.status not in ('graded', 'uncertain')
        and new.status in ('graded', 'uncertain')
      )
    then
      raise exception 'grading truth is service-side only';
    end if;
  end if;

  return new;
end;
$$;


--
-- Name: prevent_empty_frq_criteria(); Type: FUNCTION; Schema: app; Owner: -
--

CREATE FUNCTION app.prevent_empty_frq_criteria() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare
  remaining  integer;
  item_type  text;
begin
  select count(*) into remaining
  from app.frq_criteria
  where content_item_version_id = old.content_item_version_id;

  if remaining = 0 then
    select ci.item_type into item_type
    from app.content_item_versions civ
    join app.content_items ci on ci.id = civ.content_item_id
    where civ.id = old.content_item_version_id;

    if item_type = 'frq' then
      raise exception
        'cannot remove the last frq_criterion from an FRQ content_item_version (id: %)',
        old.content_item_version_id;
    end if;
  end if;

  return old;
end;
$$;


--
-- Name: prevent_live_frq_reclassification(); Type: FUNCTION; Schema: app; Owner: -
--

CREATE FUNCTION app.prevent_live_frq_reclassification() RETURNS trigger
    LANGUAGE plpgsql
    SET search_path TO 'pg_catalog'
    AS $$
begin
  if (
    new.practice_format is distinct from old.practice_format
    or new.frq_archetype is distinct from old.frq_archetype
    or new.frq_form is distinct from old.frq_form
  ) and exists (
    select 1
    from app.content_item_versions civ
    where civ.content_item_id = old.id
      and civ.status = 'published'
  ) then
    raise exception
      'published_frq_reclassification_requires_retirement:%',
      old.content_key;
  end if;
  return new;
end
$$;


--
-- Name: prevent_profile_role_change(); Type: FUNCTION; Schema: app; Owner: -
--

CREATE FUNCTION app.prevent_profile_role_change() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
  if current_user <> 'service_role'
     and coalesce(current_setting('request.jwt.claim.role', true), '') <> 'service_role'
     and new.role <> old.role then
    raise exception 'role changes are server-side only';
  end if;
  return new;
end;
$$;


--
-- Name: prevent_review_decision_mutation(); Type: FUNCTION; Schema: app; Owner: -
--

CREATE FUNCTION app.prevent_review_decision_mutation() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
  raise exception
    'content_review_decisions rows are immutable after insert (id: %). '
    'To supersede a decision, insert a new row with supersedes_id referencing this row.',
    old.id;
end;
$$;


--
-- Name: project_artifact_state(uuid); Type: FUNCTION; Schema: app; Owner: -
--

CREATE FUNCTION app.project_artifact_state(p_artifact_version_id uuid) RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select coalesce(
    (
      select ase.new_state
      from app.artifact_state_events ase
      where ase.artifact_version_id = p_artifact_version_id
      order by ase.changed_at desc, ase.artifact_state_event_id desc
      limit 1
    ),
    'draft'
  );
$$;


--
-- Name: refresh_artifact_state(); Type: FUNCTION; Schema: app; Owner: -
--

CREATE FUNCTION app.refresh_artifact_state() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
  return null;
end;
$$;


--
-- Name: reserve_artifact_version_sequence(uuid); Type: FUNCTION; Schema: app; Owner: -
--

CREATE FUNCTION app.reserve_artifact_version_sequence(p_artifact_id uuid) RETURNS integer
    LANGUAGE plpgsql
    SET search_path TO 'app', 'public'
    AS $$
declare
  next_sequence integer;
begin
  perform pg_advisory_xact_lock(hashtextextended(p_artifact_id::text, 0));
  select coalesce(max(version_sequence), 0) + 1
    into next_sequence
  from app.artifact_versions
  where artifact_id = p_artifact_id;
  return next_sequence;
end;
$$;


--
-- Name: reserve_model_usage(text, text, text, numeric, numeric); Type: FUNCTION; Schema: app; Owner: -
--

CREATE FUNCTION app.reserve_model_usage(p_request_id text, p_request_hash text, p_model_id text, p_reserved_cost_usd numeric, p_cap_usd numeric) RETURNS app.model_usage_ledger
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'app', 'public'
    AS $$
declare
  existing app.model_usage_ledger%rowtype;
  budget app.daily_budgets%rowtype;
  projected_total numeric(12,4);
begin
  if p_reserved_cost_usd is null or p_reserved_cost_usd <= 0 then
    raise exception 'invalid reservation amount';
  end if;

  -- Fast-path replay check before lock acquisition
  select * into existing from app.model_usage_ledger where request_id = p_request_id limit 1;
  if found then
    if existing.request_hash <> p_request_hash then raise exception 'idempotency key conflict'; end if;
    return existing;
  end if;

  insert into app.daily_budgets (usage_date_utc, cap_usd)
  values (current_date, p_cap_usd)
  on conflict (usage_date_utc) do update
    set cap_usd = coalesce(app.daily_budgets.cap_usd, excluded.cap_usd);

  select * into budget from app.daily_budgets where usage_date_utc = current_date for update;

  -- Post-lock re-check to handle concurrent duplicate requests
  select * into existing from app.model_usage_ledger where request_id = p_request_id limit 1;
  if found then
    if existing.request_hash <> p_request_hash then raise exception 'idempotency key conflict'; end if;
    return existing;
  end if;

  projected_total := budget.reserved_cost_usd + budget.actual_cost_usd + p_reserved_cost_usd;
  if projected_total > p_cap_usd then raise exception 'daily cap exceeded'; end if;

  update app.daily_budgets set reserved_cost_usd = reserved_cost_usd + p_reserved_cost_usd where usage_date_utc = current_date;

  insert into app.model_usage_ledger (request_id, request_hash, usage_date_utc, reserved_cost_usd, status, model_id)
  values (p_request_id, p_request_hash, current_date, p_reserved_cost_usd, 'reserved', p_model_id)
  returning * into existing;

  return existing;
end;
$$;


--
-- Name: set_updated_at(); Type: FUNCTION; Schema: app; Owner: -
--

CREATE FUNCTION app.set_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
  new.updated_at = now();
  return new;
end;
$$;


--
-- Name: submit_response(uuid, uuid, uuid, text, text, text); Type: FUNCTION; Schema: app; Owner: -
--

CREATE FUNCTION app.submit_response(p_attempt_id uuid, p_response_version_id uuid, p_actor_id uuid, p_actor_role text, p_idempotency_key text, p_request_hash text) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'app', 'public'
    AS $$
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
  select metadata into v_existing_metadata
    from app.audit_events
    where request_id = p_idempotency_key and reason_code = 'submit_response'
    limit 1;
  if found then
    v_existing_hash := coalesce(v_existing_metadata ->> 'request_hash', '');
    if v_existing_hash <> p_request_hash then
      raise exception 'submit_response:idempotency_conflict' using errcode = 'P0001';
    end if;
    return coalesce(v_existing_metadata -> 'result', 'null'::jsonb);
  end if;

  select id, user_id, status into v_attempt from app.attempts where id = p_attempt_id for update;
  if not found then raise exception 'submit_response:attempt_not_found' using errcode = 'P0001'; end if;

  select metadata into v_existing_metadata
    from app.audit_events
    where request_id = p_idempotency_key and reason_code = 'submit_response'
    limit 1;
  if found then
    v_existing_hash := coalesce(v_existing_metadata ->> 'request_hash', '');
    if v_existing_hash <> p_request_hash then
      raise exception 'submit_response:idempotency_conflict' using errcode = 'P0001';
    end if;
    return coalesce(v_existing_metadata -> 'result', 'null'::jsonb);
  end if;

  if v_attempt.user_id <> p_actor_id and p_actor_role <> 'admin' then
    raise exception 'submit_response:forbidden' using errcode = 'P0001';
  end if;
  if v_attempt.status not in ('draft', 'failed') then
    raise exception 'submit_response:attempt_not_submittable:%', v_attempt.status using errcode = 'P0001';
  end if;

  select id, attempt_id, is_submitted into v_response
    from app.response_versions where id = p_response_version_id for update;
  if not found then raise exception 'submit_response:response_not_found' using errcode = 'P0001'; end if;
  if v_response.attempt_id <> v_attempt.id then
    raise exception 'submit_response:response_attempt_mismatch' using errcode = 'P0001';
  end if;
  if v_response.is_submitted then
    raise exception 'submit_response:response_already_submitted' using errcode = 'P0001';
  end if;

  v_submitted_at := now();
  update app.response_versions set is_submitted = true, submitted_at = v_submitted_at where id = p_response_version_id;
  update app.attempts set status = 'submitted', submitted_at = v_submitted_at where id = p_attempt_id;

  v_result := jsonb_build_object(
    'attempt_id', v_attempt.id, 'response_version_id', v_response.id,
    'status', 'submitted', 'submitted_at', v_submitted_at
  );

  v_audit_event_id := gen_random_uuid()::text;
  v_event_sha256 := encode(
    extensions.digest(
      jsonb_build_object('operation', 'submit_response', 'request_hash', p_request_hash, 'result', v_result)::text,
      'sha256'::text
    ),
    'hex'
  );

  insert into app.audit_events (
    audit_event_id, occurred_at, actor_type, actor_id, action,
    object_type, object_id, request_id, reason_code, metadata, event_sha256, created_at
  ) values (
    v_audit_event_id, v_submitted_at, 'human', p_actor_id::text,
    'submit_response.submit_response', 'response_version',
    p_response_version_id,  -- uuid, not ::text
    p_idempotency_key, 'submit_response',
    jsonb_build_object('request_hash', p_request_hash, 'attempt_id', v_attempt.id, 'actor_role', p_actor_role, 'result', v_result),
    v_event_sha256, v_submitted_at
  );

  return v_result;
end;
$$;


--
-- Name: tg_content_pipeline_guard_publish(); Type: FUNCTION; Schema: app; Owner: -
--

CREATE FUNCTION app.tg_content_pipeline_guard_publish() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'app', 'pg_temp'
    AS $$
begin
  if new.status = 'published' and old.status is distinct from 'published' then
    if old.status is distinct from 'reviewed_approved' then
      raise exception
        'content_pipeline_guard: cannot publish from status % (must be reviewed_approved)',
        old.status;
    end if;
  end if;
  return new;
end;
$$;


--
-- Name: tg_content_pipeline_on_assignment(); Type: FUNCTION; Schema: app; Owner: -
--

CREATE FUNCTION app.tg_content_pipeline_on_assignment() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'app', 'pg_temp'
    AS $$
declare
  v_item_id uuid;
begin
  if new.content_item_version_id is null or new.status <> 'pending' then
    return new;
  end if;

  update app.content_item_versions
  set status = 'assigned'
  where id = new.content_item_version_id
    and status = 'draft';

  select content_item_id into v_item_id
  from app.content_item_versions
  where id = new.content_item_version_id;

  if v_item_id is not null then
    update app.content_items
    set status = 'assigned'
    where id = v_item_id
      and status = 'draft';
  end if;

  return new;
end;
$$;


--
-- Name: tg_content_pipeline_on_decision(); Type: FUNCTION; Schema: app; Owner: -
--

CREATE FUNCTION app.tg_content_pipeline_on_decision() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'app', 'pg_temp'
    AS $$
declare
  v_item_id uuid;
  v_outcome text;
  v_review_status text;
  v_blind_group_id uuid;
  v_assignment_count integer;
  v_submitted_count integer;
  v_group_score integer;
  v_is_latest boolean;
begin
  if new.content_item_version_id is null then
    return new;
  end if;

  if new.review_stage = 'tutor_question' then
    select blind_group_id
      into v_blind_group_id
      from app.content_review_assignments
     where content_review_assignment_id = new.content_review_assignment_id;

    if v_blind_group_id is not null then
      select count(*), count(*) filter (where status = 'submitted')
        into v_assignment_count, v_submitted_count
        from app.content_review_assignments
       where blind_group_id = v_blind_group_id
         and review_stage = 'tutor_question';
    else
      v_assignment_count := 1;
      v_submitted_count := 1;
    end if;

    if v_assignment_count = 1 then
      if new.tutor_score = 1 then
        v_outcome := 'reviewed_approved';
        v_review_status := 'question_review_approved';
      elsif new.tutor_score = 2 then
        v_outcome := 'changes_requested';
        v_review_status := 'modification_reserved';
      elsif new.tutor_score = 3 then
        v_outcome := 'reviewed_disapproved';
        v_review_status := 'excluded';
      else
        return new;
      end if;
    elsif v_assignment_count = 2 then
      if v_submitted_count <> 2 then
        return new;
      end if;

      select sum(d.tutor_score)
        into v_group_score
        from app.content_review_assignments a
        join app.content_review_decisions d
          on d.content_review_assignment_id = a.content_review_assignment_id
       where a.blind_group_id = v_blind_group_id
         and a.review_stage = 'tutor_question'
         and not exists (
           select 1
             from app.content_review_decisions newer
            where newer.supersedes_id = d.content_review_decision_id
         );

      if v_group_score = 2 then
        v_outcome := 'reviewed_approved';
        v_review_status := 'ap_reader_pending';
      elsif v_group_score = 3 then
        v_outcome := 'changes_requested';
        v_review_status := 'modification_reserved';
      elsif v_group_score between 4 and 6 then
        v_outcome := 'reviewed_disapproved';
        v_review_status := 'excluded';
      else
        return new;
      end if;
    else
      return new;
    end if;
  elsif new.review_stage = 'reader_question' then
    if new.reader_decision = 'agree' or new.tutor_score = 1 then
      v_outcome := 'reviewed_approved';
      v_review_status := 'question_review_approved';
    elsif new.tutor_score = 2 then
      v_outcome := 'changes_requested';
      v_review_status := 'modification_reserved';
    elsif new.reader_decision = 'disagree' or new.tutor_score = 3 then
      v_outcome := 'reviewed_disapproved';
      v_review_status := 'excluded';
    else
      return new;
    end if;
  else
    return new;
  end if;

  update app.content_item_versions
     set status = case
           when status in (
             'draft', 'assigned', 'changes_requested',
             'reviewed_approved', 'reviewed_disapproved'
           ) then v_outcome
           else status
         end,
         review_status = v_review_status
   where id = new.content_item_version_id;

  select civ.content_item_id,
         not exists (
           select 1
             from app.content_item_versions newer
            where newer.content_item_id = civ.content_item_id
              and (
                newer.version_num > civ.version_num
                or (
                  newer.version_num = civ.version_num
                  and newer.created_at > civ.created_at
                )
              )
         )
    into v_item_id, v_is_latest
    from app.content_item_versions civ
   where civ.id = new.content_item_version_id;

  if v_item_id is not null and v_is_latest then
    update app.content_items
       set status = case
             when status in (
               'draft', 'assigned', 'changes_requested',
               'reviewed_approved', 'reviewed_disapproved'
             ) then v_outcome
             else status
           end
     where id = v_item_id;
  end if;

  return new;
end;
$$;


--
-- Name: FUNCTION tg_content_pipeline_on_decision(); Type: COMMENT; Schema: app; Owner: -
--

COMMENT ON FUNCTION app.tg_content_pipeline_on_decision() IS 'Maps approve_with_edits to changes_requested, resolves blind tutor pairs as a pair, and changes parent state only for the latest version.';


--
-- Name: tg_enforce_content_review_qualification(); Type: FUNCTION; Schema: app; Owner: -
--

CREATE FUNCTION app.tg_enforce_content_review_qualification() RETURNS trigger
    LANGUAGE plpgsql
    SET search_path TO 'app', 'pg_temp'
    AS $$
declare
  target_exam_id uuid;
begin
  if new.content_item_version_id is null then
    return new;
  end if;

  if new.assignment_purpose = 'owner_remediation_approval' then
    if new.reviewer_id is distinct from new.created_by
       or new.blind_group_id is not null
       or new.review_stage <> 'tutor_question'
       or not exists (
         select 1
           from app.profiles p
          where p.user_id = new.reviewer_id
            and p.role = 'admin'
       )
    then
      raise exception using
        errcode = '23514',
        constraint =
          'content_review_assignments_owner_remediation_approval_check',
        message =
          'owner remediation approval requires a non-blind admin self-assignment';
    end if;
    return new;
  end if;

  select epv.exam_pack_id
    into target_exam_id
    from app.content_item_versions civ
    join app.content_items ci
      on ci.id = civ.content_item_id
    join app.exam_pack_versions epv
      on epv.id = ci.exam_pack_version_id
   where civ.id = new.content_item_version_id;

  if target_exam_id is null then
    raise exception using
      errcode = '23514',
      constraint = 'content_review_assignments_reviewer_qualification_check',
      message = format(
        'content review assignment %s has no resolvable exam scope',
        new.content_review_assignment_id
      );
  end if;

  if not exists (
    select 1
      from app.validator_qualifications vq
     where vq.reviewer_id = new.reviewer_id
       and vq.status = 'active'
       and target_exam_id = any(vq.exam_ids)
       and vq.effective_at <= now()
       and vq.expires_at > now()
  ) then
    raise exception using
      errcode = '23514',
      constraint = 'content_review_assignments_reviewer_qualification_check',
      message = format(
        'reviewer %s lacks an active qualification for exam %s',
        new.reviewer_id,
        target_exam_id
      );
  end if;

  return new;
end;
$$;


--
-- Name: FUNCTION tg_enforce_content_review_qualification(); Type: COMMENT; Schema: app; Owner: -
--

COMMENT ON FUNCTION app.tg_enforce_content_review_qualification() IS 'Requires exam qualification for subject review; permits only explicit, non-blind admin self-assignments for owner-confirmed remediation approval.';


--
-- Name: validate_decision_answer_key(); Type: FUNCTION; Schema: app; Owner: -
--

CREATE FUNCTION app.validate_decision_answer_key() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare
  choice_exists boolean;
begin
  if new.review_stage <> 'tutor_answer'
     or new.answer_key is null
     or new.content_item_version_id is null
  then
    return new;
  end if;

  select exists (
    select 1
    from app.mcq_choices
    where content_item_version_id = new.content_item_version_id
      and choice_key = new.answer_key
  ) into choice_exists;

  if not choice_exists then
    raise exception
      'answer_key ''%'' does not match any mcq_choices row for content_item_version_id %',
      new.answer_key,
      new.content_item_version_id;
  end if;

  return new;
end;
$$;


--
-- Name: validate_full_exam_frq_version(uuid); Type: FUNCTION; Schema: app; Owner: -
--

CREATE FUNCTION app.validate_full_exam_frq_version(p_content_item_version_id uuid) RETURNS void
    LANGUAGE plpgsql
    SET search_path TO 'pg_catalog'
    AS $_$
declare
  v_item record;
  v_expected_points integer;
  v_expected_parts jsonb;
  v_actual_parts jsonb;
  v_criteria_points integer;
  v_bad_part_count integer;
begin
  select
    civ.id as version_id,
    civ.status as version_status,
    civ.prompt_json,
    ci.id as item_id,
    ci.content_key,
    ci.item_type,
    ci.frq_form,
    ci.practice_format,
    ci.frq_archetype,
    ep.exam_code
  into v_item
  from app.content_item_versions civ
  join app.content_items ci on ci.id = civ.content_item_id
  join app.exam_pack_versions epv on epv.id = ci.exam_pack_version_id
  join app.exam_packs ep on ep.id = epv.exam_pack_id
  where civ.id = p_content_item_version_id;

  if not found
    or v_item.version_status <> 'published'
    or v_item.practice_format is distinct from 'full_exam_frq'
  then
    return;
  end if;

  if v_item.exam_code not in (
    'ap_physics_1',
    'ap_physics_2',
    'ap_physics_c_mechanics',
    'ap_physics_c_em'
  ) then
    return;
  end if;

  case v_item.frq_archetype
    when 'Mathematical Routines' then
      v_expected_points := 10;
      v_expected_parts := '[7,3]'::jsonb;
    when 'Translation Between Representations' then
      v_expected_points := 12;
      v_expected_parts := '[3,4,3,2]'::jsonb;
    when 'Experimental Design and Analysis' then
      v_expected_points := 10;
      v_expected_parts := '[2,2,4,2]'::jsonb;
    when 'Qualitative/Quantitative Translation' then
      v_expected_points := 8;
      v_expected_parts := '[3,3,2]'::jsonb;
    else
      raise exception 'full_exam_frq_invalid_archetype:%:%', v_item.content_key, coalesce(v_item.frq_archetype, '<null>');
  end case;

  if v_item.item_type <> 'frq' or v_item.frq_form <> 'long' then
    raise exception 'full_exam_frq_invalid_form:%', v_item.content_key;
  end if;

  if coalesce(v_item.prompt_json ->> 'archetype', '') <> v_item.frq_archetype then
    raise exception 'full_exam_frq_archetype_mismatch:%', v_item.content_key;
  end if;

  if jsonb_typeof(v_item.prompt_json -> 'parts') <> 'array' then
    raise exception 'full_exam_frq_missing_parts:%', v_item.content_key;
  end if;

  select coalesce(jsonb_agg((part ->> 'points')::integer order by ordinal), '[]'::jsonb)
  into v_actual_parts
  from jsonb_array_elements(v_item.prompt_json -> 'parts') with ordinality as p(part, ordinal);

  if v_actual_parts <> v_expected_parts then
    raise exception 'full_exam_frq_part_contract_mismatch:%:expected=%:actual=%', v_item.content_key, v_expected_parts, v_actual_parts;
  end if;

  select count(*)
  into v_bad_part_count
  from jsonb_array_elements(v_item.prompt_json -> 'parts') part
  where coalesce(part ->> 'part_key', '') !~ '^part-[a-d]$'
    or coalesce(part ->> 'prompt', '') = ''
    or jsonb_typeof(part -> 'criteria') <> 'array'
    or coalesce((
      select sum((criterion ->> 'points')::integer)
      from jsonb_array_elements(part -> 'criteria') criterion
    ), 0) <> (part ->> 'points')::integer;

  if v_bad_part_count <> 0 then
    raise exception 'full_exam_frq_invalid_part_payload:%', v_item.content_key;
  end if;

  select coalesce(sum(fc.points_possible), 0)
  into v_criteria_points
  from app.frq_criteria fc
  where fc.content_item_version_id = v_item.version_id;

  if v_criteria_points <> v_expected_points then
    raise exception 'full_exam_frq_criteria_total_mismatch:%:expected=%:actual=%', v_item.content_key, v_expected_points, v_criteria_points;
  end if;

  if exists (
    select 1
    from jsonb_array_elements(v_item.prompt_json -> 'parts') part
    where coalesce((
      select sum(fc.points_possible)
      from app.frq_criteria fc
      where fc.content_item_version_id = v_item.version_id
        and fc.criterion_key like (part ->> 'part_key') || '-criterion-%'
    ), 0) <> (part ->> 'points')::integer
  ) then
    raise exception 'full_exam_frq_criterion_part_mismatch:%', v_item.content_key;
  end if;
end
$_$;


--
-- Name: _epv_is_selectable(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public._epv_is_selectable(_version_id uuid) RETURNS boolean
    LANGUAGE sql STABLE SECURITY DEFINER
    SET search_path TO 'pg_catalog'
    AS $$
  SELECT EXISTS (
    SELECT 1
      FROM app.exam_pack_versions v
      JOIN app.exam_packs         p ON p.id = v.exam_pack_id
      JOIN app.subjects           s ON s.id = p.subject_id
     WHERE v.id     = _version_id
       AND v.status = 'published'
       AND s.status = 'active'
  );
$$;


--
-- Name: complete_onboarding(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.complete_onboarding(_version_id uuid) RETURNS TABLE(active_exam_pack_version_id uuid, onboarding_completed_at timestamp with time zone)
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'pg_catalog'
    AS $$
DECLARE
  v_uid uuid := auth.uid();
BEGIN
  IF v_uid IS NULL THEN
    RAISE EXCEPTION 'not_authenticated' USING ERRCODE = '28000';
  END IF;

  IF _version_id IS NULL
     OR NOT public._epv_is_selectable(_version_id) THEN
    RAISE EXCEPTION 'invalid_exam_pack_version' USING ERRCODE = '22023';
  END IF;

  RETURN QUERY
  UPDATE app.profiles p
     SET active_exam_pack_version_id = _version_id,
         onboarding_completed_at     = COALESCE(p.onboarding_completed_at,
                                                pg_catalog.now())
   WHERE p.user_id = v_uid
  RETURNING p.active_exam_pack_version_id, p.onboarding_completed_at;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'profile_not_found' USING ERRCODE = 'P0002';
  END IF;
END;
$$;


--
-- Name: select_practice_frqs(uuid, text, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.select_practice_frqs(_exam_pack_version_id uuid, _practice_format text, _limit integer DEFAULT 20) RETURNS TABLE(content_item_version_id uuid, content_item_id uuid, content_key text, title text, stem text, stimulus text, stimulus_image_path text, prompt_json jsonb, frq_form text, practice_format text, frq_archetype text, published_at timestamp with time zone)
    LANGUAGE sql STABLE
    SET search_path TO 'pg_catalog'
    AS $$
  select
    civ.id,
    ci.id,
    ci.content_key,
    ci.title,
    civ.stem,
    civ.stimulus,
    civ.stimulus_image_path,
    civ.prompt_json,
    ci.frq_form,
    ci.practice_format,
    ci.frq_archetype,
    civ.published_at
  from app.content_items ci
  join app.content_item_versions civ
    on civ.content_item_id = ci.id
  where ci.exam_pack_version_id = _exam_pack_version_id
    and ci.item_type = 'frq'
    and ci.status = 'published'
    and civ.status = 'published'
    and ci.practice_format = _practice_format
    and _practice_format in ('targeted_drill', 'full_exam_frq')
  order by civ.published_at, ci.content_key
  limit greatest(1, least(coalesce(_limit, 20), 50));
$$;


--
-- Name: FUNCTION select_practice_frqs(_exam_pack_version_id uuid, _practice_format text, _limit integer); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION public.select_practice_frqs(_exam_pack_version_id uuid, _practice_format text, _limit integer) IS 'Fail-closed student FRQ candidate selector scoped by exam pack and practice format.';


--
-- Name: set_active_exam_pack_version(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.set_active_exam_pack_version(_version_id uuid) RETURNS uuid
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'pg_catalog'
    AS $$
DECLARE
  v_uid       uuid := auth.uid();
  v_returned  uuid;
BEGIN
  IF v_uid IS NULL THEN
    RAISE EXCEPTION 'not_authenticated' USING ERRCODE = '28000';
  END IF;

  IF _version_id IS NOT NULL
     AND NOT public._epv_is_selectable(_version_id) THEN
    RAISE EXCEPTION 'invalid_exam_pack_version' USING ERRCODE = '22023';
  END IF;

  UPDATE app.profiles
     SET active_exam_pack_version_id = _version_id
   WHERE user_id = v_uid
  RETURNING active_exam_pack_version_id INTO v_returned;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'profile_not_found' USING ERRCODE = 'P0002';
  END IF;

  RETURN v_returned;
END;
$$;


--
-- Name: ai_variant_runs; Type: TABLE; Schema: app; Owner: -
--

CREATE TABLE app.ai_variant_runs (
    variant_run_id uuid DEFAULT gen_random_uuid() NOT NULL,
    base_artifact_version_ids uuid[] DEFAULT '{}'::uuid[] NOT NULL,
    content_rights_release_ids uuid[] DEFAULT '{}'::uuid[] NOT NULL,
    authoring_brief_version_id uuid NOT NULL,
    prompt_version_id uuid NOT NULL,
    model_configuration_version_id uuid NOT NULL,
    parameter_payload jsonb DEFAULT '{}'::jsonb NOT NULL,
    invariant_requirements jsonb DEFAULT '{}'::jsonb NOT NULL,
    permitted_changes jsonb DEFAULT '{}'::jsonb NOT NULL,
    approved_source_version_ids uuid[] DEFAULT '{}'::uuid[] NOT NULL,
    generated_candidate_version_ids uuid[] DEFAULT '{}'::uuid[] NOT NULL,
    run_input_sha256 text NOT NULL,
    run_output_sha256 text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    holdout_policy_version_id uuid,
    holdout_result text DEFAULT 'pending'::text NOT NULL
);


--
-- Name: artifact_dependencies; Type: TABLE; Schema: app; Owner: -
--

CREATE TABLE app.artifact_dependencies (
    dependency_id uuid DEFAULT gen_random_uuid() NOT NULL,
    from_artifact_version_id uuid NOT NULL,
    to_artifact_version_id uuid NOT NULL,
    dependency_type text NOT NULL,
    impact_mode text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid
);


--
-- Name: artifact_label_assignments; Type: TABLE; Schema: app; Owner: -
--

CREATE TABLE app.artifact_label_assignments (
    artifact_version_id uuid NOT NULL,
    content_label_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid
);


--
-- Name: artifact_state_events; Type: TABLE; Schema: app; Owner: -
--

CREATE TABLE app.artifact_state_events (
    artifact_state_event_id uuid DEFAULT gen_random_uuid() NOT NULL,
    artifact_version_id uuid NOT NULL,
    prior_state text,
    new_state text NOT NULL,
    reason_code text NOT NULL,
    evidence_record_ids uuid[] DEFAULT '{}'::uuid[] NOT NULL,
    changed_by uuid,
    changed_at timestamp with time zone DEFAULT now() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    CONSTRAINT artifact_state_events_new_state_check CHECK ((new_state = ANY (ARRAY['draft'::text, 'in_review'::text, 'approved'::text, 'published'::text, 'suspended'::text, 'superseded'::text, 'retired'::text, 'withdrawn'::text]))),
    CONSTRAINT artifact_state_events_prior_state_check CHECK (((prior_state IS NULL) OR (prior_state = ANY (ARRAY['draft'::text, 'in_review'::text, 'approved'::text, 'published'::text, 'suspended'::text, 'superseded'::text, 'retired'::text, 'withdrawn'::text]))))
);


--
-- Name: artifact_versions; Type: TABLE; Schema: app; Owner: -
--

CREATE TABLE app.artifact_versions (
    artifact_id uuid NOT NULL,
    artifact_version_id uuid DEFAULT gen_random_uuid() NOT NULL,
    artifact_type text NOT NULL,
    exam_id uuid NOT NULL,
    school_year text NOT NULL,
    version_sequence integer NOT NULL,
    semantic_version text NOT NULL,
    language text NOT NULL,
    payload_schema_version text NOT NULL,
    payload jsonb NOT NULL,
    payload_sha256 text NOT NULL,
    risk_class text NOT NULL,
    change_class text NOT NULL,
    change_summary text NOT NULL,
    change_rationale text NOT NULL,
    authored_by uuid[] DEFAULT '{}'::uuid[] NOT NULL,
    authored_at timestamp with time zone DEFAULT now() NOT NULL,
    predecessor_version_id uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    CONSTRAINT artifact_versions_artifact_type_check CHECK ((artifact_type = ANY (ARRAY['exam_fact'::text, 'taxonomy_node'::text, 'question'::text, 'stimulus'::text, 'asset'::text, 'lesson'::text, 'explanation'::text, 'hint'::text, 'misconception'::text, 'intervention'::text, 'transfer_item'::text, 'delayed_retrieval_item'::text, 'rubric'::text, 'criterion'::text, 'accepted_variant'::text, 'contradiction'::text, 'sample_response'::text, 'calibration_case'::text, 'teaching_policy'::text, 'grading_policy'::text, 'prompt'::text, 'model_configuration'::text, 'validator_policy'::text]))),
    CONSTRAINT artifact_versions_change_class_check CHECK ((change_class = ANY (ARRAY['C0'::text, 'C1'::text, 'C2'::text, 'C3'::text]))),
    CONSTRAINT artifact_versions_change_rationale_check CHECK (((char_length(change_rationale) >= 1) AND (char_length(change_rationale) <= 4000))),
    CONSTRAINT artifact_versions_change_summary_check CHECK (((char_length(change_summary) >= 1) AND (char_length(change_summary) <= 2000))),
    CONSTRAINT artifact_versions_risk_class_check CHECK ((risk_class = ANY (ARRAY['R0'::text, 'R1'::text, 'R2'::text, 'R3'::text]))),
    CONSTRAINT artifact_versions_version_sequence_check CHECK ((version_sequence >= 1))
);


--
-- Name: attempt_criterion_results; Type: TABLE; Schema: app; Owner: -
--

CREATE TABLE app.attempt_criterion_results (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    attempt_id uuid NOT NULL,
    criterion_key text NOT NULL,
    status text NOT NULL,
    points_awarded integer DEFAULT 0 NOT NULL,
    evidence_quote text,
    decision_explanation text,
    minimum_fix text,
    evaluator_version text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT attempt_criterion_results_status_check CHECK ((status = ANY (ARRAY['earned'::text, 'not_yet_earned'::text, 'unable_to_determine'::text, 'not_applicable'::text])))
);


--
-- Name: attempt_responses; Type: TABLE; Schema: app; Owner: -
--

CREATE TABLE app.attempt_responses (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    attempt_id uuid NOT NULL,
    part_key text NOT NULL,
    response_text text,
    response_json jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: attempts; Type: TABLE; Schema: app; Owner: -
--

CREATE TABLE app.attempts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    learning_session_id uuid,
    exam_pack_version_id uuid NOT NULL,
    content_item_version_id uuid NOT NULL,
    attempt_mode text NOT NULL,
    status text DEFAULT 'draft'::text NOT NULL,
    assistance_state text DEFAULT 'independent'::text NOT NULL,
    started_at timestamp with time zone DEFAULT now() NOT NULL,
    submitted_at timestamp with time zone,
    graded_at timestamp with time zone,
    score_points integer,
    score_possible integer,
    confidence_level text,
    result_state text,
    result_summary text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    artifact_version_id uuid,
    CONSTRAINT attempts_assistance_check CHECK ((assistance_state = ANY (ARRAY['independent'::text, 'coached'::text, 'exam_practice'::text]))),
    CONSTRAINT attempts_mode_check CHECK ((attempt_mode = ANY (ARRAY['mcq'::text, 'frq'::text, 'quantitative'::text]))),
    CONSTRAINT attempts_status_check CHECK ((status = ANY (ARRAY['draft'::text, 'submitted'::text, 'grading'::text, 'graded'::text, 'uncertain'::text, 'failed'::text])))
);


--
-- Name: audit_events; Type: TABLE; Schema: app; Owner: -
--

CREATE TABLE app.audit_events (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    actor_user_id uuid,
    subject_user_id uuid,
    object_type text NOT NULL,
    object_id uuid,
    action text NOT NULL,
    payload jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    audit_event_id text NOT NULL,
    occurred_at timestamp with time zone NOT NULL,
    actor_type text NOT NULL,
    actor_id text NOT NULL,
    prior_event_id text,
    request_id text,
    reason_code text,
    metadata jsonb DEFAULT '{}'::jsonb NOT NULL,
    event_sha256 text NOT NULL
);


--
-- Name: author_commissions; Type: TABLE; Schema: app; Owner: -
--

CREATE TABLE app.author_commissions (
    commission_id uuid DEFAULT gen_random_uuid() NOT NULL,
    brief_version_id uuid NOT NULL,
    author_id uuid NOT NULL,
    author_qualification_id uuid NOT NULL,
    agreement_record_id uuid NOT NULL,
    compensation_terms_record_id uuid NOT NULL,
    commissioned_deliverables text[] DEFAULT '{}'::text[] NOT NULL,
    assigned_at timestamp with time zone DEFAULT now() NOT NULL,
    due_at timestamp with time zone NOT NULL,
    status text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    CONSTRAINT author_commissions_status_check CHECK ((status = ANY (ARRAY['pending'::text, 'active'::text, 'delivered'::text, 'closed'::text, 'cancelled'::text])))
);


--
-- Name: author_qualifications; Type: TABLE; Schema: app; Owner: -
--

CREATE TABLE app.author_qualifications (
    author_qualification_id uuid DEFAULT gen_random_uuid() NOT NULL,
    author_id uuid NOT NULL,
    exam_ids uuid[] DEFAULT '{}'::uuid[] NOT NULL,
    school_years text[] DEFAULT '{}'::text[] NOT NULL,
    taxonomy_scope_ids uuid[] DEFAULT '{}'::uuid[] NOT NULL,
    evidence_record_ids uuid[] DEFAULT '{}'::uuid[] NOT NULL,
    qualification_policy_version_id uuid NOT NULL,
    effective_at timestamp with time zone NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    status text NOT NULL,
    suspension_reason text,
    granted_by uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    CONSTRAINT author_qualifications_status_check CHECK ((status = ANY (ARRAY['pending'::text, 'active'::text, 'suspended'::text, 'expired'::text, 'revoked'::text])))
);


--
-- Name: authoring_briefs; Type: TABLE; Schema: app; Owner: -
--

CREATE TABLE app.authoring_briefs (
    brief_id uuid DEFAULT gen_random_uuid() NOT NULL,
    brief_version_id uuid NOT NULL,
    exam_id uuid NOT NULL,
    school_year text NOT NULL,
    taxonomy_scope_ids uuid[] DEFAULT '{}'::uuid[] NOT NULL,
    assessable_skill_target_ids uuid[] DEFAULT '{}'::uuid[] NOT NULL,
    task_verbs text[] DEFAULT '{}'::text[] NOT NULL,
    question_form text NOT NULL,
    intended_use text NOT NULL,
    intended_difficulty text NOT NULL,
    approved_source_version_ids uuid[] DEFAULT '{}'::uuid[] NOT NULL,
    stimulus_requirements jsonb DEFAULT '{}'::jsonb NOT NULL,
    reasoning_requirements jsonb DEFAULT '{}'::jsonb NOT NULL,
    accessibility_requirements jsonb DEFAULT '{}'::jsonb NOT NULL,
    prohibited_similarities text[] DEFAULT '{}'::text[] NOT NULL,
    deliverable_schema_version text NOT NULL,
    brief_sha256 text NOT NULL,
    approved_by uuid[] DEFAULT '{}'::uuid[] NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid
);


--
-- Name: config; Type: TABLE; Schema: app; Owner: -
--

CREATE TABLE app.config (
    config_key text NOT NULL,
    config_value jsonb DEFAULT '{}'::jsonb NOT NULL,
    is_public boolean DEFAULT false NOT NULL,
    description text,
    created_by uuid,
    updated_by uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: content_ingest_batches; Type: TABLE; Schema: app; Owner: -
--

CREATE TABLE app.content_ingest_batches (
    batch_id uuid DEFAULT gen_random_uuid() NOT NULL,
    subject_id uuid NOT NULL,
    exam_pack_version_id uuid,
    upload_format text NOT NULL,
    original_filename text,
    raw_template text NOT NULL,
    parsed_template jsonb DEFAULT '{}'::jsonb NOT NULL,
    parser_version text DEFAULT 'ux-002-template-v1'::text NOT NULL,
    parse_status text DEFAULT 'uploaded'::text NOT NULL,
    parse_error text,
    row_count integer DEFAULT 0 NOT NULL,
    created_by uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT content_ingest_batches_format_check CHECK ((upload_format = ANY (ARRAY['csv'::text, 'json'::text]))),
    CONSTRAINT content_ingest_batches_row_count_check CHECK ((row_count >= 0)),
    CONSTRAINT content_ingest_batches_status_check CHECK ((parse_status = ANY (ARRAY['uploaded'::text, 'parsed'::text, 'imported'::text, 'failed'::text])))
);


--
-- Name: content_ingest_rows; Type: TABLE; Schema: app; Owner: -
--

CREATE TABLE app.content_ingest_rows (
    ingest_row_id uuid DEFAULT gen_random_uuid() NOT NULL,
    batch_id uuid NOT NULL,
    row_number integer NOT NULL,
    row_key text,
    review_stage text NOT NULL,
    question_type text NOT NULL,
    stem text NOT NULL,
    answer_letter text,
    answer_text text,
    canonical_answer text,
    modules text[] DEFAULT '{}'::text[] NOT NULL,
    subtopics text[] DEFAULT '{}'::text[] NOT NULL,
    change_request text,
    notes text,
    row_payload jsonb DEFAULT '{}'::jsonb NOT NULL,
    materialized_artifact_version_id uuid,
    ingest_status text DEFAULT 'pending'::text NOT NULL,
    ingest_error text,
    created_by uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    frq_form text,
    CONSTRAINT content_ingest_rows_frq_form_check CHECK (((frq_form IS NULL) OR (frq_form = ANY (ARRAY['short'::text, 'long'::text])))),
    CONSTRAINT content_ingest_rows_row_number_check CHECK ((row_number >= 1)),
    CONSTRAINT content_ingest_rows_stage_check CHECK ((review_stage = ANY (ARRAY['question'::text, 'answer'::text, 'canonical_answer'::text, 'difficulty_discussion'::text]))),
    CONSTRAINT content_ingest_rows_status_check CHECK ((ingest_status = ANY (ARRAY['pending'::text, 'parsed'::text, 'materialized'::text, 'failed'::text]))),
    CONSTRAINT content_ingest_rows_type_check CHECK ((question_type = ANY (ARRAY['mcq'::text, 'frq'::text])))
);


--
-- Name: content_item_labels; Type: TABLE; Schema: app; Owner: -
--

CREATE TABLE app.content_item_labels (
    content_item_id uuid NOT NULL,
    content_label_id uuid NOT NULL
);


--
-- Name: TABLE content_item_labels; Type: COMMENT; Schema: app; Owner: -
--

COMMENT ON TABLE app.content_item_labels IS 'Deprecated compatibility projection. New tagging and release workflows should be expressed through governance records and projections.';


--
-- Name: content_item_versions; Type: TABLE; Schema: app; Owner: -
--

CREATE TABLE app.content_item_versions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    content_item_id uuid NOT NULL,
    version_num integer NOT NULL,
    stem text NOT NULL,
    stimulus text,
    prompt_json jsonb DEFAULT '{}'::jsonb NOT NULL,
    explanation text,
    help_text text,
    content_hash text NOT NULL,
    status text DEFAULT 'draft'::text NOT NULL,
    approved_at timestamp with time zone,
    approved_by uuid,
    published_at timestamp with time zone,
    created_by uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    canonical_answer_1 text,
    canonical_answer_2 text,
    review_status text,
    rubric_type text,
    evaluator_strategy text,
    stimulus_image_path text,
    CONSTRAINT content_item_versions_evaluator_strategy_check CHECK (((evaluator_strategy IS NULL) OR (evaluator_strategy = ANY (ARRAY['rule_based_mcq'::text, 'llm_discrete_text'::text, 'python_symbolic_ecf'::text, 'human_shadow'::text])))),
    CONSTRAINT content_item_versions_review_status_check CHECK (((review_status IS NULL) OR (review_status = ANY (ARRAY['tutor_review_pending'::text, 'tutor_review_partial'::text, 'ap_reader_pending'::text, 'modification_reserved'::text, 'excluded'::text, 'question_review_approved'::text, 'difficulty_discussion'::text, 'difficulty_confirmed'::text, 'answer_tutor_review_pending'::text, 'answer_ap_reader_pending'::text, 'answer_modification_reserved'::text, 'answer_approved'::text, 'mcq_package_excluded'::text, 'mcq_answer_review_complete'::text])))),
    CONSTRAINT content_item_versions_rubric_type_check CHECK (((rubric_type IS NULL) OR (rubric_type = ANY (ARRAY['mcq'::text, 'discrete_text'::text, 'structured_formula'::text, 'spatial'::text, 'holistic'::text])))),
    CONSTRAINT content_item_versions_status_check CHECK ((status = ANY (ARRAY['draft'::text, 'assigned'::text, 'changes_requested'::text, 'reviewed_approved'::text, 'reviewed_disapproved'::text, 'published'::text, 'retired'::text])))
);


--
-- Name: TABLE content_item_versions; Type: COMMENT; Schema: app; Owner: -
--

COMMENT ON TABLE app.content_item_versions IS 'Deprecated compatibility projection. New versions should be authored as app.artifact_versions rows and projected here only for compatibility during the migration period.';


--
-- Name: COLUMN content_item_versions.canonical_answer_1; Type: COMMENT; Schema: app; Owner: -
--

COMMENT ON COLUMN app.content_item_versions.canonical_answer_1 IS 'Model canonical answer #1 for FRQ grading calibration. NULL when not provided.';


--
-- Name: COLUMN content_item_versions.canonical_answer_2; Type: COMMENT; Schema: app; Owner: -
--

COMMENT ON COLUMN app.content_item_versions.canonical_answer_2 IS 'Model canonical answer #2 for FRQ grading calibration. NULL when not provided.';


--
-- Name: content_items; Type: TABLE; Schema: app; Owner: -
--

CREATE TABLE app.content_items (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    exam_pack_version_id uuid NOT NULL,
    content_key text NOT NULL,
    item_type text NOT NULL,
    title text NOT NULL,
    status text DEFAULT 'draft'::text NOT NULL,
    created_by uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    frq_form text,
    practice_format text,
    frq_archetype text,
    CONSTRAINT content_items_frq_form_check CHECK ((frq_form = ANY (ARRAY['short'::text, 'long'::text]))),
    CONSTRAINT content_items_full_exam_archetype_check CHECK (((practice_format <> 'full_exam_frq'::text) OR ((frq_form = 'long'::text) AND (frq_archetype IS NOT NULL) AND (btrim(frq_archetype) <> ''::text)))),
    CONSTRAINT content_items_practice_format_check CHECK (((practice_format IS NULL) OR ((item_type = 'frq'::text) AND (practice_format = ANY (ARRAY['targeted_drill'::text, 'full_exam_frq'::text]))))),
    CONSTRAINT content_items_status_check CHECK ((status = ANY (ARRAY['draft'::text, 'assigned'::text, 'changes_requested'::text, 'reviewed_approved'::text, 'reviewed_disapproved'::text, 'published'::text, 'retired'::text]))),
    CONSTRAINT content_items_type_check CHECK ((item_type = ANY (ARRAY['mcq'::text, 'frq'::text, 'quantitative'::text])))
);


--
-- Name: TABLE content_items; Type: COMMENT; Schema: app; Owner: -
--

COMMENT ON TABLE app.content_items IS 'Deprecated compatibility projection. Use app.artifact_versions and app.artifact_state_events for authoritative content lifecycle.';


--
-- Name: COLUMN content_items.practice_format; Type: COMMENT; Schema: app; Owner: -
--

COMMENT ON COLUMN app.content_items.practice_format IS 'Serving contract: targeted_drill or full_exam_frq for FRQs.';


--
-- Name: COLUMN content_items.frq_archetype; Type: COMMENT; Schema: app; Owner: -
--

COMMENT ON COLUMN app.content_items.frq_archetype IS 'Canonical subject-specific FRQ archetype; separate from serving format.';


--
-- Name: content_labels; Type: TABLE; Schema: app; Owner: -
--

CREATE TABLE app.content_labels (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    exam_pack_id uuid NOT NULL,
    label_key text NOT NULL,
    label_name text NOT NULL,
    label_type text NOT NULL,
    status text DEFAULT 'draft'::text NOT NULL,
    created_by uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT content_labels_status_check CHECK ((status = ANY (ARRAY['draft'::text, 'published'::text, 'retired'::text]))),
    CONSTRAINT content_labels_type_check CHECK ((label_type = ANY (ARRAY['topic'::text, 'unit'::text, 'skill'::text, 'difficulty'::text, 'workflow'::text])))
);


--
-- Name: TABLE content_labels; Type: COMMENT; Schema: app; Owner: -
--

COMMENT ON TABLE app.content_labels IS 'Deprecated compatibility projection. Use app.source_records, app.rights_records, app.artifact_versions, app.artifact_state_events, and related governance tables for new content workflows.';


--
-- Name: content_review_assignment_labels; Type: TABLE; Schema: app; Owner: -
--

CREATE TABLE app.content_review_assignment_labels (
    content_review_assignment_id uuid NOT NULL,
    content_label_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid
);


--
-- Name: content_review_assignments; Type: TABLE; Schema: app; Owner: -
--

CREATE TABLE app.content_review_assignments (
    content_review_assignment_id uuid DEFAULT gen_random_uuid() NOT NULL,
    content_item_version_id uuid,
    reviewer_id uuid NOT NULL,
    review_stage text NOT NULL,
    blind_group_id uuid,
    status text DEFAULT 'pending'::text NOT NULL,
    assigned_at timestamp with time zone DEFAULT now() NOT NULL,
    due_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    ingest_row_id uuid,
    review_kind text,
    assignment_purpose text DEFAULT 'subject_review'::text NOT NULL,
    CONSTRAINT content_review_assignments_purpose_check CHECK ((assignment_purpose = ANY (ARRAY['subject_review'::text, 'owner_remediation_approval'::text]))),
    CONSTRAINT content_review_assignments_review_kind_check CHECK (((review_kind IS NULL) OR (review_kind = ANY (ARRAY['frq'::text, 'mcq'::text])))),
    CONSTRAINT cra_review_kind_stage_check CHECK (((review_kind IS NULL) OR ((review_kind = 'mcq'::text) AND (review_stage = ANY (ARRAY['tutor_question'::text, 'tutor_answer'::text, 'reader_question'::text]))) OR ((review_kind = 'frq'::text) AND (review_stage = ANY (ARRAY['tutor_question'::text, 'tutor_frq_canonical'::text, 'reader_question'::text]))))),
    CONSTRAINT cra_stage_check CHECK ((review_stage = ANY (ARRAY['tutor_question'::text, 'tutor_answer'::text, 'tutor_frq_canonical'::text, 'reader_question'::text]))),
    CONSTRAINT cra_status_check CHECK ((status = ANY (ARRAY['pending'::text, 'in_progress'::text, 'submitted'::text, 'skipped'::text])))
);


--
-- Name: content_review_decisions; Type: TABLE; Schema: app; Owner: -
--

CREATE TABLE app.content_review_decisions (
    content_review_decision_id uuid DEFAULT gen_random_uuid() NOT NULL,
    content_review_assignment_id uuid NOT NULL,
    content_item_version_id uuid,
    reviewer_id uuid NOT NULL,
    supersedes_id uuid,
    review_stage text NOT NULL,
    tutor_score integer,
    difficulty_label text,
    diagnostic_flag boolean DEFAULT false NOT NULL,
    concern_codes text[] DEFAULT '{}'::text[] NOT NULL,
    note text,
    topic_selections jsonb,
    answer_key text,
    answer_approval text,
    canonical_decision text,
    reader_decision text,
    decision_payload jsonb DEFAULT '{}'::jsonb NOT NULL,
    decision_hash text NOT NULL,
    submitted_at timestamp with time zone DEFAULT now() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    canonical_answer_snapshot text,
    answer_approvals jsonb,
    tutor_decision text,
    difficulty_action text,
    CONSTRAINT crd_answer_approval_check CHECK (((answer_approval IS NULL) OR (answer_approval = ANY (ARRAY['approved'::text, 'rejected'::text])))),
    CONSTRAINT crd_answer_key_check CHECK (((answer_key IS NULL) OR (answer_key = ANY (ARRAY['A'::text, 'B'::text, 'C'::text, 'D'::text])))),
    CONSTRAINT crd_canonical_decision_check CHECK (((canonical_decision IS NULL) OR (canonical_decision = ANY (ARRAY['approved'::text, 'rejected'::text, 'edited'::text])))),
    CONSTRAINT crd_concern_codes_check CHECK ((concern_codes <@ ARRAY['Accuracy'::text, 'Ambiguity'::text, 'Rubric gap'::text, 'Other'::text])),
    CONSTRAINT crd_difficulty_action_check CHECK (((difficulty_action IS NULL) OR (difficulty_action = ANY (ARRAY['agree'::text, 'propose'::text])))),
    CONSTRAINT crd_difficulty_check CHECK (((difficulty_label IS NULL) OR (difficulty_label = ANY (ARRAY['Easy'::text, 'Moderately easy'::text, 'Medium'::text, 'Hard'::text, 'Very hard'::text])))),
    CONSTRAINT crd_reader_decision_check CHECK (((reader_decision IS NULL) OR (reader_decision = ANY (ARRAY['agree'::text, 'disagree'::text, 'approve'::text, 'approve_with_edits'::text, 'disapprove'::text])))),
    CONSTRAINT crd_stage_check CHECK ((review_stage = ANY (ARRAY['tutor_question'::text, 'tutor_answer'::text, 'tutor_frq_canonical'::text, 'reader_question'::text]))),
    CONSTRAINT crd_tutor_decision_check CHECK (((tutor_decision IS NULL) OR (tutor_decision = ANY (ARRAY['approve'::text, 'approve_with_edits'::text, 'disapprove'::text])))),
    CONSTRAINT crd_tutor_score_check CHECK (((tutor_score IS NULL) OR (tutor_score = ANY (ARRAY[1, 2, 3]))))
);


--
-- Name: COLUMN content_review_decisions.answer_approvals; Type: COMMENT; Schema: app; Owner: -
--

COMMENT ON COLUMN app.content_review_decisions.answer_approvals IS 'Per-MCQ-choice approve/reject picks captured alongside the tutor_question decision, e.g. [{"choice_key":"A","approved":true}, ...]. Null for FRQ items and non-tutor_question stages.';


--
-- Name: content_rights_releases; Type: TABLE; Schema: app; Owner: -
--

CREATE TABLE app.content_rights_releases (
    release_id uuid DEFAULT gen_random_uuid() NOT NULL,
    author_or_seller_id uuid NOT NULL,
    commission_id uuid,
    covered_artifact_ids uuid[] DEFAULT '{}'::uuid[] NOT NULL,
    compensation_record_id uuid NOT NULL,
    ownership_mode text NOT NULL,
    rights_granted text[] DEFAULT '{}'::text[] NOT NULL,
    worldwide boolean DEFAULT true NOT NULL,
    perpetual boolean DEFAULT true NOT NULL,
    originality_warranty boolean DEFAULT true NOT NULL,
    no_conflicting_rights_warranty boolean DEFAULT true NOT NULL,
    source_and_asset_disclosure_required boolean DEFAULT true NOT NULL,
    restricted_material_prohibited boolean DEFAULT true NOT NULL,
    further_payment_required boolean DEFAULT false NOT NULL,
    signed_by_creator uuid NOT NULL,
    signed_by_cramapple uuid NOT NULL,
    signed_at timestamp with time zone DEFAULT now() NOT NULL,
    agreement_sha256 text NOT NULL,
    counsel_approved_template_version_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid
);


--
-- Name: daily_budgets; Type: TABLE; Schema: app; Owner: -
--

CREATE TABLE app.daily_budgets (
    usage_date_utc date NOT NULL,
    reserved_cost_usd numeric(12,4) DEFAULT 0 NOT NULL,
    actual_cost_usd numeric(12,4) DEFAULT 0 NOT NULL,
    cap_usd numeric(12,4),
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT daily_budgets_actual_nonneg CHECK ((actual_cost_usd >= (0)::numeric)),
    CONSTRAINT daily_budgets_reserved_nonneg CHECK ((reserved_cost_usd >= (0)::numeric))
);


--
-- Name: exam_pack_manifests; Type: TABLE; Schema: app; Owner: -
--

CREATE TABLE app.exam_pack_manifests (
    manifest_id uuid DEFAULT gen_random_uuid() NOT NULL,
    exam_id uuid NOT NULL,
    school_year text NOT NULL,
    exam_pack_version text NOT NULL,
    artifact_version_ids uuid[] DEFAULT '{}'::uuid[] NOT NULL,
    source_version_ids uuid[] DEFAULT '{}'::uuid[] NOT NULL,
    rights_record_ids uuid[] DEFAULT '{}'::uuid[] NOT NULL,
    validator_policy_version_id uuid NOT NULL,
    teaching_policy_version_id uuid NOT NULL,
    grading_policy_version_id uuid NOT NULL,
    prompt_version_ids uuid[] DEFAULT '{}'::uuid[] NOT NULL,
    model_configuration_version_ids uuid[] DEFAULT '{}'::uuid[] NOT NULL,
    validation_run_ids uuid[] DEFAULT '{}'::uuid[] NOT NULL,
    qualification_rule_version_ids uuid[] DEFAULT '{}'::uuid[] NOT NULL,
    manifest_sha256 text NOT NULL,
    generated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid
);


--
-- Name: exam_pack_versions; Type: TABLE; Schema: app; Owner: -
--

CREATE TABLE app.exam_pack_versions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    exam_pack_id uuid NOT NULL,
    school_year text NOT NULL,
    official_exam_date date NOT NULL,
    status text NOT NULL,
    source_uri text,
    source_published_at date,
    released_at timestamp with time zone,
    retired_at timestamp with time zone,
    created_by uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT exam_pack_versions_status_check CHECK ((status = ANY (ARRAY['draft'::text, 'published'::text, 'retired'::text])))
);


--
-- Name: exam_packs; Type: TABLE; Schema: app; Owner: -
--

CREATE TABLE app.exam_packs (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    exam_code text NOT NULL,
    exam_name text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    subject_id uuid NOT NULL
);


--
-- Name: frq_criteria; Type: TABLE; Schema: app; Owner: -
--

CREATE TABLE app.frq_criteria (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    content_item_version_id uuid NOT NULL,
    criterion_key text NOT NULL,
    learner_facing_text text NOT NULL,
    points_possible integer NOT NULL,
    evidence_requirements text,
    minimum_fix text,
    accepted_variants jsonb DEFAULT '[]'::jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT frq_criteria_evidence_requirements_nonempty CHECK ((NULLIF(btrim(evidence_requirements), ''::text) IS NOT NULL)),
    CONSTRAINT frq_criteria_minimum_fix_nonempty CHECK ((NULLIF(btrim(minimum_fix), ''::text) IS NOT NULL)),
    CONSTRAINT frq_criteria_points_check CHECK ((points_possible > 0))
);


--
-- Name: TABLE frq_criteria; Type: COMMENT; Schema: app; Owner: -
--

COMMENT ON TABLE app.frq_criteria IS 'Deprecated compatibility projection. The authoritative rubric and criterion model lives in the governance tables.';


--
-- Name: frq_synthetic_responses; Type: TABLE; Schema: app; Owner: -
--

CREATE TABLE app.frq_synthetic_responses (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    content_item_version_id uuid NOT NULL,
    response_type text NOT NULL,
    student_response text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT frq_synthetic_responses_type_check CHECK ((response_type = ANY (ARRAY['fully_correct'::text, 'borderline'::text, 'partially_correct'::text, 'subtly_wrong'::text, 'incorrect'::text])))
);


--
-- Name: TABLE frq_synthetic_responses; Type: COMMENT; Schema: app; Owner: -
--

COMMENT ON TABLE app.frq_synthetic_responses IS 'Synthetic student responses for real FRQ content_item_versions (e.g. AP Biology FRQ bootstrap calibration). Long-form items typically have 4 responses (fully_correct, borderline, partially_correct, subtly_wrong); short-form items typically have 2 (fully_correct, incorrect).';


--
-- Name: grading_results; Type: TABLE; Schema: app; Owner: -
--

CREATE TABLE app.grading_results (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    request_id text NOT NULL,
    request_hash text NOT NULL,
    attempt_id uuid NOT NULL,
    response_version_id uuid NOT NULL,
    operation text NOT NULL,
    status text NOT NULL,
    points_earned integer,
    points_available integer NOT NULL,
    criterion_results jsonb DEFAULT '[]'::jsonb NOT NULL,
    highest_value_gap jsonb,
    predicted_label text,
    predicted_point_gain integer,
    actual_point_gain integer,
    prediction_outcome text,
    confidence text NOT NULL,
    uncertainty_reason text,
    model_id text NOT NULL,
    prompt_version text NOT NULL,
    rubric_version_id uuid,
    input_tokens integer,
    output_tokens integer,
    estimated_cost_usd numeric(10,4),
    latency_ms integer,
    raw_model_response jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    feedback_preview text,
    action_hint text,
    repair_hint text,
    deterministic_verifier_version text,
    boundary_contract_version text,
    CONSTRAINT grading_results_confidence_check CHECK ((confidence = ANY (ARRAY['high'::text, 'medium'::text, 'low'::text]))),
    CONSTRAINT grading_results_operation_check CHECK ((operation = ANY (ARRAY['grade_initial_attempt'::text, 'select_repair'::text, 'grade_revision'::text, 'grade_transfer_attempt'::text]))),
    CONSTRAINT grading_results_status_check CHECK ((status = ANY (ARRAY['processing'::text, 'graded'::text, 'uncertain'::text, 'failed'::text, 'duplicate'::text])))
);


--
-- Name: learning_sessions; Type: TABLE; Schema: app; Owner: -
--

CREATE TABLE app.learning_sessions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    exam_pack_version_id uuid NOT NULL,
    entry_path text NOT NULL,
    session_mode text NOT NULL,
    available_minutes integer NOT NULL,
    status text DEFAULT 'active'::text NOT NULL,
    started_at timestamp with time zone DEFAULT now() NOT NULL,
    ended_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    practice_format text,
    CONSTRAINT learning_sessions_entry_path_check CHECK ((entry_path = ANY (ARRAY['recommend'::text, 'topic'::text, 'check_work'::text, 'bring_question'::text]))),
    CONSTRAINT learning_sessions_practice_format_check CHECK (((practice_format IS NULL) OR (practice_format = ANY (ARRAY['targeted_drill'::text, 'full_exam_frq'::text])))),
    CONSTRAINT learning_sessions_session_mode_check CHECK ((session_mode = ANY (ARRAY['quick'::text, 'focused'::text, 'buckle_down'::text]))),
    CONSTRAINT learning_sessions_status_check CHECK ((status = ANY (ARRAY['active'::text, 'completed'::text, 'archived'::text])))
);


--
-- Name: COLUMN learning_sessions.practice_format; Type: COMMENT; Schema: app; Owner: -
--

COMMENT ON COLUMN app.learning_sessions.practice_format IS 'Requested FRQ serving format enforced again at attempt creation.';


--
-- Name: mcq_choices; Type: TABLE; Schema: app; Owner: -
--

CREATE TABLE app.mcq_choices (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    content_item_version_id uuid NOT NULL,
    choice_key text NOT NULL,
    choice_text text NOT NULL,
    is_correct boolean DEFAULT false NOT NULL,
    rationale text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT mcq_choices_choice_text_nonempty CHECK ((NULLIF(btrim(choice_text), ''::text) IS NOT NULL)),
    CONSTRAINT mcq_choices_rationale_nonempty CHECK ((NULLIF(btrim(rationale), ''::text) IS NOT NULL))
);


--
-- Name: TABLE mcq_choices; Type: COMMENT; Schema: app; Owner: -
--

COMMENT ON TABLE app.mcq_choices IS 'Deprecated compatibility projection. The authoritative MCQ content lives in app.artifact_versions and related governance records.';


--
-- Name: originality_attestations; Type: TABLE; Schema: app; Owner: -
--

CREATE TABLE app.originality_attestations (
    attestation_id uuid DEFAULT gen_random_uuid() NOT NULL,
    commission_id uuid NOT NULL,
    artifact_version_ids uuid[] DEFAULT '{}'::uuid[] NOT NULL,
    independently_authored boolean NOT NULL,
    no_official_or_third_party_adaptation boolean NOT NULL,
    no_restricted_material_use boolean NOT NULL,
    prior_publication_or_assignment_disclosed boolean NOT NULL,
    factual_source_version_ids uuid[] DEFAULT '{}'::uuid[] NOT NULL,
    asset_rights_record_ids uuid[] DEFAULT '{}'::uuid[] NOT NULL,
    disclosed_collaborator_ids uuid[] DEFAULT '{}'::uuid[] NOT NULL,
    disclosed_tools text[] DEFAULT '{}'::text[] NOT NULL,
    statement text NOT NULL,
    signed_by uuid NOT NULL,
    signed_at timestamp with time zone DEFAULT now() NOT NULL,
    attestation_sha256 text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid
);


--
-- Name: profiles; Type: TABLE; Schema: app; Owner: -
--

CREATE TABLE app.profiles (
    user_id uuid NOT NULL,
    full_name text NOT NULL,
    role text DEFAULT 'student'::text NOT NULL,
    timezone text,
    locale text,
    onboarding_completed_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    review_queue_scope text DEFAULT 'my_queue'::text NOT NULL,
    active_exam_pack_version_id uuid,
    notification_email text,
    CONSTRAINT profiles_notification_email_format_check CHECK (((notification_email IS NULL) OR (notification_email ~* '^[^[:space:]@]+@[^[:space:]@]+\.[^[:space:]@]+$'::text))),
    CONSTRAINT profiles_review_queue_scope_check CHECK ((review_queue_scope = ANY (ARRAY['my_queue'::text, 'all_pending'::text]))),
    CONSTRAINT profiles_role_check CHECK ((role = ANY (ARRAY['student'::text, 'content_author'::text, 'tutor'::text, 'reader'::text, 'validator'::text, 'support'::text, 'admin'::text])))
);


--
-- Name: COLUMN profiles.notification_email; Type: COMMENT; Schema: app; Owner: -
--

COMMENT ON COLUMN app.profiles.notification_email IS 'Optional address for operational notifications only. It is not an authentication identifier and does not change the user login.';


--
-- Name: progress_snapshots; Type: TABLE; Schema: app; Owner: -
--

CREATE TABLE app.progress_snapshots (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    exam_pack_version_id uuid NOT NULL,
    snapshot_kind text NOT NULL,
    snapshot_json jsonb NOT NULL,
    source_version text,
    generated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT progress_snapshots_kind_check CHECK ((snapshot_kind = ANY (ARRAY['daily'::text, 'weekly'::text, 'on_demand'::text])))
);


--
-- Name: prompt_versions; Type: TABLE; Schema: app; Owner: -
--

CREATE TABLE app.prompt_versions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    operation text NOT NULL,
    version text NOT NULL,
    status text DEFAULT 'draft'::text NOT NULL,
    prompt_hash text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    released_at timestamp with time zone,
    CONSTRAINT prompt_versions_status_check CHECK ((status = ANY (ARRAY['draft'::text, 'published'::text, 'retired'::text])))
);


--
-- Name: provenance_claims; Type: TABLE; Schema: app; Owner: -
--

CREATE TABLE app.provenance_claims (
    claim_id uuid DEFAULT gen_random_uuid() NOT NULL,
    artifact_version_id uuid NOT NULL,
    claim_path text NOT NULL,
    claim_text text NOT NULL,
    claim_kind text NOT NULL,
    source_version_ids uuid[] DEFAULT '{}'::uuid[] NOT NULL,
    derivation text NOT NULL,
    formula text,
    assumptions text[] DEFAULT '{}'::text[] NOT NULL,
    confidence text NOT NULL,
    verified_by uuid,
    verified_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    CONSTRAINT provenance_claims_claim_text_check CHECK (((char_length(claim_text) >= 1) AND (char_length(claim_text) <= 4000)))
);


--
-- Name: publication_events; Type: TABLE; Schema: app; Owner: -
--

CREATE TABLE app.publication_events (
    publication_event_id uuid DEFAULT gen_random_uuid() NOT NULL,
    release_candidate_id uuid NOT NULL,
    manifest_id uuid NOT NULL,
    environment text NOT NULL,
    prior_manifest_id uuid,
    action text NOT NULL,
    approved_by uuid[] DEFAULT '{}'::uuid[] NOT NULL,
    executed_by uuid,
    executed_at timestamp with time zone DEFAULT now() NOT NULL,
    transaction_id text NOT NULL,
    smoke_test_run_id uuid,
    outcome text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    CONSTRAINT publication_events_outcome_check CHECK ((outcome = ANY (ARRAY['succeeded'::text, 'failed'::text, 'blocked'::text])))
);


--
-- Name: quality_incidents; Type: TABLE; Schema: app; Owner: -
--

CREATE TABLE app.quality_incidents (
    incident_id uuid DEFAULT gen_random_uuid() NOT NULL,
    severity text NOT NULL,
    detected_at timestamp with time zone DEFAULT now() NOT NULL,
    detected_by uuid,
    affected_version_ids uuid[] DEFAULT '{}'::uuid[] NOT NULL,
    affected_manifest_ids uuid[] DEFAULT '{}'::uuid[] NOT NULL,
    category text NOT NULL,
    evidence jsonb DEFAULT '{}'::jsonb NOT NULL,
    containment_action jsonb DEFAULT '{}'::jsonb NOT NULL,
    status text NOT NULL,
    incident_commander_id uuid,
    root_cause text,
    closed_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    CONSTRAINT quality_incidents_severity_check CHECK ((severity = ANY (ARRAY['S0'::text, 'S1'::text, 'S2'::text, 'S3'::text]))),
    CONSTRAINT quality_incidents_status_check CHECK ((status = ANY (ARRAY['open'::text, 'contained'::text, 'remediating'::text, 'monitoring'::text, 'closed'::text])))
);


--
-- Name: question_coverage_targets; Type: TABLE; Schema: app; Owner: -
--

CREATE TABLE app.question_coverage_targets (
    coverage_target_id uuid DEFAULT gen_random_uuid() NOT NULL,
    exam_id uuid NOT NULL,
    subject_id uuid NOT NULL,
    scope_type text NOT NULL,
    taxonomy_scope_id uuid NOT NULL,
    school_year text NOT NULL,
    mcq_target integer DEFAULT 0 NOT NULL,
    short_frq_prompt_target integer DEFAULT 0 NOT NULL,
    long_frq_prompt_target integer DEFAULT 0 NOT NULL,
    required_skill_ids uuid[] DEFAULT '{}'::uuid[] NOT NULL,
    required_representation_types text[] DEFAULT '{}'::text[] NOT NULL,
    required_difficulty_bands text[] DEFAULT '{}'::text[] NOT NULL,
    approved_by uuid[] DEFAULT '{}'::uuid[] NOT NULL,
    effective_at timestamp with time zone NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    CONSTRAINT question_coverage_targets_long_frq_prompt_target_check CHECK ((long_frq_prompt_target >= 0)),
    CONSTRAINT question_coverage_targets_mcq_target_check CHECK ((mcq_target >= 0)),
    CONSTRAINT question_coverage_targets_short_frq_prompt_target_check CHECK ((short_frq_prompt_target >= 0))
);


--
-- Name: question_use_assignments; Type: TABLE; Schema: app; Owner: -
--

CREATE TABLE app.question_use_assignments (
    use_assignment_id uuid DEFAULT gen_random_uuid() NOT NULL,
    artifact_version_id uuid NOT NULL,
    use_class text NOT NULL,
    population_scope jsonb,
    exposure_summary jsonb DEFAULT '{}'::jsonb NOT NULL,
    decision_record_ids uuid[] DEFAULT '{}'::uuid[] NOT NULL,
    effective_at timestamp with time zone DEFAULT now() NOT NULL,
    ended_at timestamp with time zone,
    replaced_by_artifact_version_id uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid
);


--
-- Name: release_candidates; Type: TABLE; Schema: app; Owner: -
--

CREATE TABLE app.release_candidates (
    release_candidate_id uuid DEFAULT gen_random_uuid() NOT NULL,
    exam_id uuid NOT NULL,
    school_year text NOT NULL,
    proposed_version text NOT NULL,
    release_class text NOT NULL,
    manifest_id uuid,
    source_gate text NOT NULL,
    rights_gate text NOT NULL,
    teaching_gate text NOT NULL,
    grading_gate text NOT NULL,
    security_privacy_gate text NOT NULL,
    release_gate text NOT NULL,
    blocking_findings uuid[] DEFAULT '{}'::uuid[] NOT NULL,
    created_by uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT release_candidates_grading_gate_check CHECK ((grading_gate = ANY (ARRAY['pending'::text, 'passed'::text, 'failed'::text, 'not_applicable'::text]))),
    CONSTRAINT release_candidates_release_class_check CHECK ((release_class = ANY (ARRAY['patch'::text, 'minor'::text, 'major'::text, 'emergency'::text]))),
    CONSTRAINT release_candidates_release_gate_check CHECK ((release_gate = ANY (ARRAY['pending'::text, 'passed'::text, 'failed'::text]))),
    CONSTRAINT release_candidates_rights_gate_check CHECK ((rights_gate = ANY (ARRAY['pending'::text, 'passed'::text, 'failed'::text]))),
    CONSTRAINT release_candidates_security_privacy_gate_check CHECK ((security_privacy_gate = ANY (ARRAY['pending'::text, 'passed'::text, 'failed'::text, 'not_applicable'::text]))),
    CONSTRAINT release_candidates_source_gate_check CHECK ((source_gate = ANY (ARRAY['pending'::text, 'passed'::text, 'failed'::text]))),
    CONSTRAINT release_candidates_teaching_gate_check CHECK ((teaching_gate = ANY (ARRAY['pending'::text, 'passed'::text, 'failed'::text, 'not_applicable'::text])))
);


--
-- Name: response_versions; Type: TABLE; Schema: app; Owner: -
--

CREATE TABLE app.response_versions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    attempt_id uuid NOT NULL,
    parent_response_version_id uuid,
    response_text text,
    response_parts jsonb DEFAULT '{}'::jsonb NOT NULL,
    version_number integer NOT NULL,
    is_submitted boolean DEFAULT false NOT NULL,
    created_by uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    submitted_at timestamp with time zone
);


--
-- Name: COLUMN response_versions.submitted_at; Type: COMMENT; Schema: app; Owner: -
--

COMMENT ON COLUMN app.response_versions.submitted_at IS 'Timestamp when is_submitted transitioned to true. Backfilled rows may use updated_at as an approximation; new rows always use the actual submission moment.';


--
-- Name: revalidation_cases; Type: TABLE; Schema: app; Owner: -
--

CREATE TABLE app.revalidation_cases (
    revalidation_id uuid DEFAULT gen_random_uuid() NOT NULL,
    trigger_type text NOT NULL,
    trigger_record_id uuid NOT NULL,
    affected_version_ids uuid[] DEFAULT '{}'::uuid[] NOT NULL,
    impact_graph_snapshot jsonb DEFAULT '{}'::jsonb NOT NULL,
    required_scope text NOT NULL,
    required_gates text[] DEFAULT '{}'::text[] NOT NULL,
    due_at timestamp with time zone NOT NULL,
    status text NOT NULL,
    disposition_manifest_id uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    CONSTRAINT revalidation_cases_required_scope_check CHECK ((required_scope = ANY (ARRAY['C0'::text, 'C1'::text, 'C2'::text, 'C3'::text]))),
    CONSTRAINT revalidation_cases_status_check CHECK ((status = ANY (ARRAY['open'::text, 'in_progress'::text, 'passed'::text, 'failed'::text, 'superseded'::text]))),
    CONSTRAINT revalidation_cases_trigger_type_check CHECK ((trigger_type = ANY (ARRAY['source_change'::text, 'rights_change'::text, 'artifact_change'::text, 'dependency_change'::text, 'model_change'::text, 'prompt_change'::text, 'metric_drift'::text, 'incident'::text, 'scheduled_review'::text, 'reviewer_challenge'::text])))
);


--
-- Name: review_assignments; Type: TABLE; Schema: app; Owner: -
--

CREATE TABLE app.review_assignments (
    assignment_id uuid DEFAULT gen_random_uuid() NOT NULL,
    artifact_version_id uuid NOT NULL,
    review_type text NOT NULL,
    required_qualification_id uuid NOT NULL,
    assigned_reviewer_id uuid NOT NULL,
    blind_group_id uuid,
    assigned_at timestamp with time zone DEFAULT now() NOT NULL,
    due_at timestamp with time zone NOT NULL,
    status text NOT NULL,
    conflict_attestation boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    CONSTRAINT review_assignments_review_type_check CHECK ((review_type = ANY (ARRAY['source'::text, 'rights'::text, 'teaching'::text, 'grading'::text, 'accessibility'::text, 'adjudication'::text, 'release'::text]))),
    CONSTRAINT review_assignments_status_check CHECK ((status = ANY (ARRAY['assigned'::text, 'opened'::text, 'submitted'::text, 'recused'::text, 'expired'::text, 'cancelled'::text])))
);


--
-- Name: review_decisions; Type: TABLE; Schema: app; Owner: -
--

CREATE TABLE app.review_decisions (
    review_decision_id uuid DEFAULT gen_random_uuid() NOT NULL,
    assignment_id uuid NOT NULL,
    artifact_version_id uuid NOT NULL,
    checklist_version_id uuid NOT NULL,
    decision text NOT NULL,
    blocker_codes text[] DEFAULT '{}'::text[] NOT NULL,
    non_blocking_codes text[] DEFAULT '{}'::text[] NOT NULL,
    criterion_results jsonb DEFAULT '{}'::jsonb NOT NULL,
    rationale text NOT NULL,
    submitted_at timestamp with time zone DEFAULT now() NOT NULL,
    decision_sha256 text NOT NULL,
    supersedes_review_decision_id uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    CONSTRAINT review_decisions_decision_check CHECK ((decision = ANY (ARRAY['approve'::text, 'approve_with_notes'::text, 'changes_required'::text, 'reject'::text, 'abstain'::text]))),
    CONSTRAINT review_decisions_rationale_check CHECK (((char_length(rationale) >= 1) AND (char_length(rationale) <= 8000)))
);


--
-- Name: rights_records; Type: TABLE; Schema: app; Owner: -
--

CREATE TABLE app.rights_records (
    rights_record_id uuid DEFAULT gen_random_uuid() NOT NULL,
    source_version_id uuid NOT NULL,
    rights_status text NOT NULL,
    permitted_uses text[] DEFAULT '{}'::text[] NOT NULL,
    prohibited_uses text[] DEFAULT '{}'::text[] NOT NULL,
    territory text[] DEFAULT '{}'::text[] NOT NULL,
    audience_restrictions text[] DEFAULT '{}'::text[] NOT NULL,
    license_or_permission_id text,
    license_effective_at timestamp with time zone,
    license_expires_at timestamp with time zone,
    attribution_required boolean DEFAULT false NOT NULL,
    attribution_text text,
    reviewed_by uuid,
    reviewed_at timestamp with time zone DEFAULT now() NOT NULL,
    legal_approval_required boolean DEFAULT false NOT NULL,
    legal_approval_id uuid,
    next_review_due_at timestamp with time zone NOT NULL,
    notes text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    CONSTRAINT rights_records_rights_status_check CHECK ((rights_status = ANY (ARRAY['cramapple_owned'::text, 'public_domain'::text, 'licensed'::text, 'written_permission'::text, 'link_only'::text, 'internal_reference_only'::text, 'restricted'::text, 'disputed'::text, 'unknown'::text])))
);


--
-- Name: source_records; Type: TABLE; Schema: app; Owner: -
--

CREATE TABLE app.source_records (
    source_id uuid NOT NULL,
    source_version_id uuid DEFAULT gen_random_uuid() NOT NULL,
    version_sequence integer NOT NULL,
    title text NOT NULL,
    publisher text NOT NULL,
    authors text[] DEFAULT '{}'::text[] NOT NULL,
    source_type text NOT NULL,
    canonical_uri text,
    publication_date date,
    source_update_date date,
    retrieved_at timestamp with time zone DEFAULT now() NOT NULL,
    effective_from date,
    effective_to date,
    exam_id uuid,
    school_year text,
    scope_statement text NOT NULL,
    source_excerpt_locator text,
    stored_object_id uuid,
    content_sha256 text NOT NULL,
    authority_tier integer NOT NULL,
    refresh_class text NOT NULL,
    next_refresh_due_at timestamp with time zone NOT NULL,
    supersedes_source_version_id uuid,
    provenance_status text DEFAULT 'draft'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    CONSTRAINT source_records_authority_tier_check CHECK ((authority_tier = ANY (ARRAY[1, 2, 3, 4]))),
    CONSTRAINT source_records_provenance_status_check CHECK ((provenance_status = ANY (ARRAY['draft'::text, 'verified'::text, 'superseded'::text, 'withdrawn'::text]))),
    CONSTRAINT source_records_publisher_check CHECK (((char_length(publisher) >= 1) AND (char_length(publisher) <= 300))),
    CONSTRAINT source_records_refresh_class_check CHECK ((refresh_class = ANY (ARRAY['EXAM'::text, 'RIGHTS'::text, 'SCIENCE_STABLE'::text, 'SCIENCE_VOLATILE'::text, 'LINK_ONLY'::text, 'PROVIDER_POLICY'::text]))),
    CONSTRAINT source_records_scope_statement_check CHECK (((char_length(scope_statement) >= 1) AND (char_length(scope_statement) <= 2000))),
    CONSTRAINT source_records_title_check CHECK (((char_length(title) >= 1) AND (char_length(title) <= 500))),
    CONSTRAINT source_records_version_sequence_check CHECK ((version_sequence >= 1))
);


--
-- Name: student_memory_events; Type: TABLE; Schema: app; Owner: -
--

CREATE TABLE app.student_memory_events (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    subject_id uuid NOT NULL,
    event_kind text NOT NULL,
    source_session_id uuid,
    source_attempt_id uuid,
    event_payload jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT student_memory_events_kind_check CHECK ((event_kind = ANY (ARRAY['session_summary'::text, 'grading_result'::text, 'manual_preference'::text, 'stuck_choice'::text, 'review_outcome'::text])))
);


--
-- Name: student_memory_snapshots; Type: TABLE; Schema: app; Owner: -
--

CREATE TABLE app.student_memory_snapshots (
    user_id uuid NOT NULL,
    subject_id uuid NOT NULL,
    memory_state jsonb DEFAULT '{}'::jsonb NOT NULL,
    state_version text DEFAULT '2026-07-07'::text NOT NULL,
    evidence_count integer DEFAULT 0 NOT NULL,
    last_event_id uuid,
    last_event_kind text,
    last_event_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: subject_guidance_profiles; Type: TABLE; Schema: app; Owner: -
--

CREATE TABLE app.subject_guidance_profiles (
    subject_id uuid NOT NULL,
    profile_version text DEFAULT '2026-07-07'::text NOT NULL,
    guidance_defaults jsonb DEFAULT '{}'::jsonb NOT NULL,
    status text DEFAULT 'published'::text NOT NULL,
    created_by uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT subject_guidance_profiles_status_check CHECK ((status = ANY (ARRAY['draft'::text, 'published'::text, 'retired'::text])))
);


--
-- Name: subjects; Type: TABLE; Schema: app; Owner: -
--

CREATE TABLE app.subjects (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    subject_key text NOT NULL,
    display_name text NOT NULL,
    status text DEFAULT 'active'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT subjects_status_check CHECK ((status = ANY (ARRAY['active'::text, 'retired'::text])))
);


--
-- Name: validation_cases; Type: TABLE; Schema: app; Owner: -
--

CREATE TABLE app.validation_cases (
    case_id uuid DEFAULT gen_random_uuid() NOT NULL,
    case_version_id uuid NOT NULL,
    case_type text NOT NULL,
    input_payload jsonb DEFAULT '{}'::jsonb NOT NULL,
    expected_payload jsonb DEFAULT '{}'::jsonb NOT NULL,
    source_artifact_version_ids uuid[] DEFAULT '{}'::uuid[] NOT NULL,
    gold_status text NOT NULL,
    sensitivity text NOT NULL,
    content_sha256 text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    CONSTRAINT validation_cases_gold_status_check CHECK ((gold_status = ANY (ARRAY['draft'::text, 'dual_reviewed'::text, 'adjudicated'::text, 'retired'::text])))
);


--
-- Name: validation_results; Type: TABLE; Schema: app; Owner: -
--

CREATE TABLE app.validation_results (
    result_id uuid DEFAULT gen_random_uuid() NOT NULL,
    run_id uuid NOT NULL,
    case_version_id uuid NOT NULL,
    output_payload jsonb DEFAULT '{}'::jsonb NOT NULL,
    expected_comparison jsonb DEFAULT '{}'::jsonb NOT NULL,
    metric_values jsonb DEFAULT '{}'::jsonb NOT NULL,
    error_codes text[] DEFAULT '{}'::text[] NOT NULL,
    reviewer_decision_ids uuid[] DEFAULT '{}'::uuid[] NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid
);


--
-- Name: validation_runs; Type: TABLE; Schema: app; Owner: -
--

CREATE TABLE app.validation_runs (
    run_id uuid DEFAULT gen_random_uuid() NOT NULL,
    suite_version_id uuid NOT NULL,
    target_version_ids uuid[] DEFAULT '{}'::uuid[] NOT NULL,
    environment text NOT NULL,
    runner_type text NOT NULL,
    prompt_version_id uuid,
    model_configuration_version_id uuid,
    started_at timestamp with time zone DEFAULT now() NOT NULL,
    completed_at timestamp with time zone,
    status text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    CONSTRAINT validation_runs_status_check CHECK ((status = ANY (ARRAY['running'::text, 'passed'::text, 'failed'::text, 'invalidated'::text, 'cancelled'::text])))
);


--
-- Name: validation_suites; Type: TABLE; Schema: app; Owner: -
--

CREATE TABLE app.validation_suites (
    suite_id uuid DEFAULT gen_random_uuid() NOT NULL,
    suite_version_id uuid NOT NULL,
    name text NOT NULL,
    exam_id uuid NOT NULL,
    suite_type text NOT NULL,
    coverage_requirements jsonb DEFAULT '{}'::jsonb NOT NULL,
    case_ids uuid[] DEFAULT '{}'::uuid[] NOT NULL,
    split text NOT NULL,
    content_sha256 text NOT NULL,
    approved_by uuid[] DEFAULT '{}'::uuid[] NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid
);


--
-- Name: validator_entitlements; Type: TABLE; Schema: app; Owner: -
--

CREATE TABLE app.validator_entitlements (
    entitlement_id uuid DEFAULT gen_random_uuid() NOT NULL,
    reviewer_id uuid NOT NULL,
    qualification_id uuid NOT NULL,
    allowed_actions text[] DEFAULT '{}'::text[] NOT NULL,
    exam_ids uuid[] DEFAULT '{}'::uuid[] NOT NULL,
    artifact_types text[] DEFAULT '{}'::text[] NOT NULL,
    assignment_ids uuid[] DEFAULT '{}'::uuid[] NOT NULL,
    environment_scope text[] DEFAULT '{}'::text[] NOT NULL,
    effective_at timestamp with time zone NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    granted_by uuid NOT NULL,
    status text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    CONSTRAINT validator_entitlements_status_check CHECK ((status = ANY (ARRAY['active'::text, 'suspended'::text, 'expired'::text, 'revoked'::text])))
);


--
-- Name: validator_qualifications; Type: TABLE; Schema: app; Owner: -
--

CREATE TABLE app.validator_qualifications (
    qualification_id uuid DEFAULT gen_random_uuid() NOT NULL,
    reviewer_id uuid NOT NULL,
    qualification_type text NOT NULL,
    exam_ids uuid[] DEFAULT '{}'::uuid[] NOT NULL,
    school_years text[] DEFAULT '{}'::text[] NOT NULL,
    taxonomy_scope_ids uuid[] DEFAULT '{}'::uuid[] NOT NULL,
    artifact_types text[] DEFAULT '{}'::text[] NOT NULL,
    environment_scope text[] DEFAULT '{}'::text[] NOT NULL,
    evidence_record_ids uuid[] DEFAULT '{}'::uuid[] NOT NULL,
    qualification_policy_version_id uuid NOT NULL,
    granted_by uuid NOT NULL,
    granted_at timestamp with time zone DEFAULT now() NOT NULL,
    effective_at timestamp with time zone NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    status text NOT NULL,
    suspension_reason text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    CONSTRAINT validator_qualifications_status_check CHECK ((status = ANY (ARRAY['pending'::text, 'active'::text, 'suspended'::text, 'expired'::text, 'revoked'::text]))),
    CONSTRAINT validator_qualifications_type_check CHECK ((qualification_type = ANY (ARRAY['teaching'::text, 'grading'::text, 'ap_reader_teaching'::text, 'ap_reader_grading'::text, 'lead_teaching'::text, 'lead_grading'::text, 'source_steward'::text, 'rights_reviewer'::text, 'release_approver'::text])))
);


--
-- Name: attempt_criterion_results; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.attempt_criterion_results WITH (security_invoker='true') AS
 SELECT acr.id,
    acr.attempt_id,
    a.user_id,
    a.learning_session_id,
    a.exam_pack_version_id,
    epv.exam_pack_id,
    ep.exam_code,
    ep.exam_name,
    ep.subject_id,
    s.subject_key,
    s.display_name AS subject_name,
    a.content_item_version_id,
    acr.criterion_key,
    acr.status,
    acr.points_awarded,
    acr.evidence_quote,
    acr.decision_explanation,
    acr.minimum_fix,
    acr.evaluator_version,
    acr.created_at
   FROM ((((app.attempt_criterion_results acr
     JOIN app.attempts a ON ((a.id = acr.attempt_id)))
     JOIN app.exam_pack_versions epv ON ((epv.id = a.exam_pack_version_id)))
     JOIN app.exam_packs ep ON ((ep.id = epv.exam_pack_id)))
     JOIN app.subjects s ON ((s.id = ep.subject_id)));


--
-- Name: attempts; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.attempts WITH (security_invoker='true') AS
 SELECT a.id,
    a.user_id,
    a.learning_session_id,
    a.exam_pack_version_id,
    epv.exam_pack_id,
    ep.exam_code,
    ep.exam_name,
    ep.subject_id,
    s.subject_key,
    s.display_name AS subject_name,
    a.content_item_version_id,
    a.artifact_version_id,
    a.attempt_mode,
    a.status,
    a.assistance_state,
    a.started_at,
    a.submitted_at,
    a.graded_at,
    a.score_points,
    a.score_possible,
    a.confidence_level,
    a.result_state,
    a.result_summary,
    a.created_at,
    a.updated_at
   FROM (((app.attempts a
     JOIN app.exam_pack_versions epv ON ((epv.id = a.exam_pack_version_id)))
     JOIN app.exam_packs ep ON ((ep.id = epv.exam_pack_id)))
     JOIN app.subjects s ON ((s.id = ep.subject_id)));


--
-- Name: config; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.config WITH (security_invoker='true') AS
 SELECT config_key,
    config_value,
    description,
    created_at,
    updated_at
   FROM app.config c
  WHERE is_public;


--
-- Name: content_item_labels; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.content_item_labels WITH (security_invoker='true') AS
 SELECT cil.content_item_id,
    ci.content_key,
    ci.title,
    cil.content_label_id,
    cl.label_key,
    cl.label_name,
    cl.label_type
   FROM ((app.content_item_labels cil
     JOIN app.content_items ci ON ((ci.id = cil.content_item_id)))
     JOIN app.content_labels cl ON ((cl.id = cil.content_label_id)));


--
-- Name: content_item_versions; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.content_item_versions WITH (security_invoker='true') AS
 SELECT civ.id,
    civ.content_item_id,
    ci.exam_pack_version_id,
    epv.exam_pack_id,
    ep.exam_code,
    ep.exam_name,
    ep.subject_id,
    s.subject_key,
    s.display_name AS subject_name,
    ci.content_key,
    ci.item_type,
    ci.frq_form,
    ci.title,
    civ.version_num,
    civ.stem,
    civ.stimulus,
    civ.stimulus_image_path,
    civ.prompt_json,
    civ.explanation,
    civ.help_text,
    civ.content_hash,
    civ.canonical_answer_1,
    civ.canonical_answer_2,
    civ.review_status,
    civ.status,
    civ.approved_at,
    civ.approved_by,
    civ.published_at,
    civ.created_by,
    civ.created_at,
    civ.updated_at
   FROM ((((app.content_item_versions civ
     JOIN app.content_items ci ON ((ci.id = civ.content_item_id)))
     JOIN app.exam_pack_versions epv ON ((epv.id = ci.exam_pack_version_id)))
     JOIN app.exam_packs ep ON ((ep.id = epv.exam_pack_id)))
     JOIN app.subjects s ON ((s.id = ep.subject_id)));


--
-- Name: content_items; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.content_items WITH (security_invoker='true') AS
 SELECT ci.id,
    ci.exam_pack_version_id,
    epv.exam_pack_id,
    ep.exam_code,
    ep.exam_name,
    ep.subject_id,
    s.subject_key,
    s.display_name AS subject_name,
    ci.content_key,
    ci.item_type,
    ci.frq_form,
    ci.title,
    ci.status,
    ci.created_by,
    ci.created_at,
    ci.updated_at
   FROM (((app.content_items ci
     JOIN app.exam_pack_versions epv ON ((epv.id = ci.exam_pack_version_id)))
     JOIN app.exam_packs ep ON ((ep.id = epv.exam_pack_id)))
     JOIN app.subjects s ON ((s.id = ep.subject_id)));


--
-- Name: content_labels; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.content_labels WITH (security_invoker='true') AS
 SELECT cl.id,
    cl.exam_pack_id,
    ep.exam_code,
    ep.exam_name,
    ep.subject_id,
    s.subject_key,
    s.display_name AS subject_name,
    cl.label_key,
    cl.label_name,
    cl.label_type,
    cl.status,
    cl.created_by,
    cl.created_at,
    cl.updated_at
   FROM ((app.content_labels cl
     JOIN app.exam_packs ep ON ((ep.id = cl.exam_pack_id)))
     JOIN app.subjects s ON ((s.id = ep.subject_id)));


--
-- Name: content_review_assignments; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.content_review_assignments WITH (security_invoker='true') AS
 SELECT cra.content_review_assignment_id,
    cra.content_item_version_id,
    civ.content_item_id,
    ci.exam_pack_version_id,
    epv.exam_pack_id,
    ep.exam_code,
    ep.exam_name,
    ep.subject_id,
    s.subject_key,
    s.display_name AS subject_name,
    ci.content_key,
    ci.item_type,
    ci.frq_form,
    ci.title,
    cra.reviewer_id,
    cra.review_stage,
    cra.blind_group_id,
    cra.status,
    cra.assigned_at,
    cra.due_at,
    cra.created_at,
    cra.created_by
   FROM (((((app.content_review_assignments cra
     JOIN app.content_item_versions civ ON ((civ.id = cra.content_item_version_id)))
     JOIN app.content_items ci ON ((ci.id = civ.content_item_id)))
     JOIN app.exam_pack_versions epv ON ((epv.id = ci.exam_pack_version_id)))
     JOIN app.exam_packs ep ON ((ep.id = epv.exam_pack_id)))
     JOIN app.subjects s ON ((s.id = ep.subject_id)));


--
-- Name: content_review_decisions; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.content_review_decisions WITH (security_invoker='true') AS
 SELECT crd.content_review_decision_id,
    crd.content_review_assignment_id,
    cra.content_item_version_id,
    civ.content_item_id,
    ci.exam_pack_version_id,
    epv.exam_pack_id,
    ep.exam_code,
    ep.exam_name,
    ep.subject_id,
    s.subject_key,
    s.display_name AS subject_name,
    ci.content_key,
    ci.item_type,
    ci.frq_form,
    ci.title,
    crd.reviewer_id,
    crd.supersedes_id,
    crd.review_stage,
    crd.tutor_score,
    crd.difficulty_label,
    crd.diagnostic_flag,
    crd.concern_codes,
    crd.note,
    crd.topic_selections,
    crd.answer_key,
    crd.answer_approval,
    crd.canonical_decision,
    crd.reader_decision,
    crd.decision_payload,
    crd.decision_hash,
    crd.submitted_at,
    crd.created_at,
    crd.created_by
   FROM ((((((app.content_review_decisions crd
     JOIN app.content_review_assignments cra ON ((cra.content_review_assignment_id = crd.content_review_assignment_id)))
     JOIN app.content_item_versions civ ON ((civ.id = cra.content_item_version_id)))
     JOIN app.content_items ci ON ((ci.id = civ.content_item_id)))
     JOIN app.exam_pack_versions epv ON ((epv.id = ci.exam_pack_version_id)))
     JOIN app.exam_packs ep ON ((ep.id = epv.exam_pack_id)))
     JOIN app.subjects s ON ((s.id = ep.subject_id)));


--
-- Name: dashboard_attention_v1; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.dashboard_attention_v1 AS
SELECT
    NULL::uuid AS subject_id,
    NULL::text AS subject_key,
    NULL::text AS subject_name,
    NULL::bigint AS overdue_review_assignments_count,
    NULL::bigint AS open_review_assignments_count,
    NULL::bigint AS blocked_content_versions_count,
    NULL::bigint AS unresolved_grading_results_count,
    NULL::timestamp with time zone AS latest_update_at;


--
-- Name: dashboard_engagement_v1; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.dashboard_engagement_v1 AS
 WITH windowed_sessions AS (
         SELECT ls.user_id,
            ls.started_at,
            ls.ended_at,
            ls.status
           FROM app.learning_sessions ls
          WHERE (ls.started_at >= (now() - '30 days'::interval))
        ), active_students AS (
         SELECT count(DISTINCT windowed_sessions.user_id) AS active_students_count
           FROM windowed_sessions
        ), session_counts AS (
         SELECT count(*) AS sessions_started_count,
            count(*) FILTER (WHERE (windowed_sessions.status = 'completed'::text)) AS sessions_completed_count
           FROM windowed_sessions
        ), attempt_counts AS (
         SELECT count(*) AS attempts_count
           FROM app.attempts a
          WHERE (a.started_at >= (now() - '30 days'::interval))
        ), returning_students AS (
         SELECT count(*) AS returning_students_count
           FROM ( SELECT ws.user_id
                   FROM windowed_sessions ws
                  GROUP BY ws.user_id
                 HAVING (count(*) >= 2)) repeated
        )
 SELECT active_students.active_students_count,
    session_counts.sessions_started_count,
    session_counts.sessions_completed_count,
    attempt_counts.attempts_count,
        CASE
            WHEN (active_students.active_students_count = 0) THEN NULL::numeric
            ELSE round(((attempt_counts.attempts_count)::numeric / (active_students.active_students_count)::numeric), 2)
        END AS attempts_per_active_student,
        CASE
            WHEN (active_students.active_students_count = 0) THEN NULL::numeric
            ELSE round(((returning_students.returning_students_count)::numeric / (active_students.active_students_count)::numeric), 4)
        END AS return_rate,
    now() AS generated_at
   FROM (((active_students
     CROSS JOIN session_counts)
     CROSS JOIN attempt_counts)
     CROSS JOIN returning_students)
  WHERE (EXISTS ( SELECT 1
           FROM app.profiles p
          WHERE ((p.user_id = auth.uid()) AND (p.role = ANY (ARRAY['content_author'::text, 'tutor'::text, 'reader'::text, 'validator'::text, 'support'::text, 'admin'::text])))));


--
-- Name: dashboard_overview_v1; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.dashboard_overview_v1 AS
 WITH visible_subjects AS (
         SELECT count(*) AS active_subjects_count
           FROM app.subjects s
          WHERE (s.status = 'active'::text)
        ), visible_content AS (
         SELECT count(DISTINCT ci.id) FILTER (WHERE (ci.status = 'published'::text)) AS published_content_items_count,
            count(DISTINCT civ.id) FILTER (WHERE (civ.status = 'published'::text)) AS published_content_versions_count
           FROM (app.content_items ci
             JOIN app.content_item_versions civ ON ((civ.content_item_id = ci.id)))
        ), visible_sessions AS (
         SELECT count(*) AS active_learning_sessions_count
           FROM app.learning_sessions ls
          WHERE (ls.status = 'active'::text)
        ), visible_reviews AS (
         SELECT count(*) AS open_review_assignments_count
           FROM app.content_review_assignments cra
          WHERE (cra.status = ANY (ARRAY['pending'::text, 'in_progress'::text]))
        ), visible_grading AS (
         SELECT count(*) AS active_grading_results_count
           FROM app.grading_results gr
          WHERE (gr.status = ANY (ARRAY['processing'::text, 'failed'::text, 'uncertain'::text]))
        ), visible_attention AS (
         SELECT count(*) AS overdue_review_assignments_count
           FROM app.content_review_assignments cra
          WHERE ((cra.status = ANY (ARRAY['pending'::text, 'in_progress'::text])) AND (cra.due_at IS NOT NULL) AND (cra.due_at < now()))
        )
 SELECT visible_subjects.active_subjects_count,
    visible_content.published_content_items_count,
    visible_content.published_content_versions_count,
    visible_sessions.active_learning_sessions_count,
    visible_reviews.open_review_assignments_count,
    visible_grading.active_grading_results_count,
    visible_attention.overdue_review_assignments_count,
    now() AS generated_at
   FROM (((((visible_subjects
     CROSS JOIN visible_content)
     CROSS JOIN visible_sessions)
     CROSS JOIN visible_reviews)
     CROSS JOIN visible_grading)
     CROSS JOIN visible_attention)
  WHERE (EXISTS ( SELECT 1
           FROM app.profiles p
          WHERE ((p.user_id = auth.uid()) AND (p.role = ANY (ARRAY['content_author'::text, 'tutor'::text, 'reader'::text, 'validator'::text, 'support'::text, 'admin'::text])))));


--
-- Name: dashboard_pipeline_v1; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.dashboard_pipeline_v1 AS
 SELECT ci.item_type,
    ci.frq_form,
    count(*) AS total_versions_count,
    count(*) FILTER (WHERE (civ.status = 'draft'::text)) AS draft_versions_count,
    count(*) FILTER (WHERE (civ.status = 'published'::text)) AS published_versions_count,
    count(*) FILTER (WHERE (civ.status = 'retired'::text)) AS retired_versions_count,
    count(*) FILTER (WHERE (civ.review_status = ANY (ARRAY['tutor_review_pending'::text, 'tutor_review_partial'::text, 'ap_reader_pending'::text, 'difficulty_discussion'::text, 'answer_tutor_review_pending'::text, 'answer_ap_reader_pending'::text]))) AS in_review_versions_count,
    count(*) FILTER (WHERE (civ.review_status = ANY (ARRAY['modification_reserved'::text, 'excluded'::text, 'answer_modification_reserved'::text, 'mcq_package_excluded'::text]))) AS blocked_versions_count,
    count(*) FILTER (WHERE ((civ.status = 'published'::text) AND (civ.review_status = ANY (ARRAY['question_review_approved'::text, 'difficulty_confirmed'::text, 'answer_approved'::text, 'mcq_answer_review_complete'::text])))) AS ready_to_ship_versions_count,
    max(civ.updated_at) AS latest_update_at
   FROM (app.content_item_versions civ
     JOIN app.content_items ci ON ((ci.id = civ.content_item_id)))
  WHERE (EXISTS ( SELECT 1
           FROM app.profiles p
          WHERE ((p.user_id = auth.uid()) AND (p.role = ANY (ARRAY['content_author'::text, 'tutor'::text, 'reader'::text, 'validator'::text, 'support'::text, 'admin'::text])))))
  GROUP BY ci.item_type, ci.frq_form
  ORDER BY ci.item_type, ci.frq_form;


--
-- Name: dashboard_quality_v1; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.dashboard_quality_v1 AS
 WITH quality_rows AS (
         SELECT s.id AS subject_id,
            s.subject_key,
            s.display_name AS subject_name,
            ci.item_type,
            ci.frq_form,
            gr.latency_ms,
            gr.estimated_cost_usd,
            gr.prediction_outcome
           FROM ((((((app.grading_results gr
             JOIN app.attempts a ON ((a.id = gr.attempt_id)))
             JOIN app.content_item_versions civ ON ((civ.id = a.content_item_version_id)))
             JOIN app.content_items ci ON ((ci.id = civ.content_item_id)))
             JOIN app.exam_pack_versions epv ON ((epv.id = a.exam_pack_version_id)))
             JOIN app.exam_packs ep ON ((ep.id = epv.exam_pack_id)))
             JOIN app.subjects s ON ((s.id = ep.subject_id)))
          WHERE ((gr.status = ANY (ARRAY['graded'::text, 'uncertain'::text, 'failed'::text])) AND (EXISTS ( SELECT 1
                   FROM app.profiles p
                  WHERE ((p.user_id = auth.uid()) AND (p.role = ANY (ARRAY['content_author'::text, 'tutor'::text, 'reader'::text, 'validator'::text, 'support'::text, 'admin'::text]))))))
        )
 SELECT subject_id,
    subject_key,
    subject_name,
    item_type,
    frq_form,
    count(*) AS grading_results_count,
    round((percentile_cont((0.5)::double precision) WITHIN GROUP (ORDER BY ((latency_ms)::double precision)))::numeric, 0) AS latency_p50_ms,
    round((percentile_cont((0.9)::double precision) WITHIN GROUP (ORDER BY ((latency_ms)::double precision)))::numeric, 0) AS latency_p90_ms,
    round((percentile_cont((0.99)::double precision) WITHIN GROUP (ORDER BY ((latency_ms)::double precision)))::numeric, 0) AS latency_p99_ms,
    round(avg(estimated_cost_usd), 4) AS average_cost_usd,
    NULL::numeric AS rubric_agreement_rate,
    max(
        CASE
            WHEN (prediction_outcome IS NOT NULL) THEN 1
            ELSE 0
        END) AS has_prediction_outcomes
   FROM quality_rows
  GROUP BY subject_id, subject_key, subject_name, item_type, frq_form
  ORDER BY subject_name, item_type, frq_form;


--
-- Name: dashboard_subjects_v1; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.dashboard_subjects_v1 AS
SELECT
    NULL::uuid AS subject_id,
    NULL::text AS subject_key,
    NULL::text AS subject_name,
    NULL::bigint AS exam_packs_count,
    NULL::bigint AS published_content_items_count,
    NULL::bigint AS published_content_versions_count,
    NULL::bigint AS active_learning_sessions_count,
    NULL::bigint AS attempts_count,
    NULL::bigint AS open_review_assignments_count,
    NULL::bigint AS grading_results_count,
    NULL::timestamp with time zone AS latest_update_at;


--
-- Name: exam_pack_versions; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.exam_pack_versions WITH (security_invoker='true') AS
 SELECT epv.id,
    epv.exam_pack_id,
    ep.exam_code,
    ep.exam_name,
    ep.subject_id,
    s.subject_key,
    s.display_name AS subject_name,
    epv.school_year,
    epv.official_exam_date,
    epv.status,
    epv.source_uri,
    epv.source_published_at,
    epv.released_at,
    epv.retired_at,
    epv.created_by,
    epv.created_at,
    epv.updated_at
   FROM ((app.exam_pack_versions epv
     JOIN app.exam_packs ep ON ((ep.id = epv.exam_pack_id)))
     JOIN app.subjects s ON ((s.id = ep.subject_id)));


--
-- Name: exam_packs; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.exam_packs WITH (security_invoker='true') AS
 SELECT ep.id,
    ep.exam_code,
    ep.exam_name,
    ep.subject_id,
    s.subject_key,
    s.display_name AS subject_name,
    ep.created_at,
    ep.updated_at
   FROM (app.exam_packs ep
     JOIN app.subjects s ON ((s.id = ep.subject_id)));


--
-- Name: exam_specs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.exam_specs (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    subject text NOT NULL,
    exam_year integer NOT NULL,
    exam_date date NOT NULL,
    source_url text,
    effective_from date,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: frq_criteria; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.frq_criteria WITH (security_invoker='true') AS
 SELECT fc.id,
    fc.content_item_version_id,
    civ.content_item_id,
    ci.exam_pack_version_id,
    epv.exam_pack_id,
    ep.exam_code,
    ep.exam_name,
    ep.subject_id,
    s.subject_key,
    s.display_name AS subject_name,
    ci.content_key,
    ci.item_type,
    ci.title,
    fc.criterion_key,
    fc.learner_facing_text,
    fc.points_possible,
    fc.evidence_requirements,
    fc.minimum_fix,
    fc.accepted_variants,
    fc.created_at
   FROM (((((app.frq_criteria fc
     JOIN app.content_item_versions civ ON ((civ.id = fc.content_item_version_id)))
     JOIN app.content_items ci ON ((ci.id = civ.content_item_id)))
     JOIN app.exam_pack_versions epv ON ((epv.id = ci.exam_pack_version_id)))
     JOIN app.exam_packs ep ON ((ep.id = epv.exam_pack_id)))
     JOIN app.subjects s ON ((s.id = ep.subject_id)));


--
-- Name: grading_results; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.grading_results WITH (security_invoker='true') AS
 SELECT gr.id,
    gr.request_id,
    gr.request_hash,
    gr.attempt_id,
    a.user_id,
    a.learning_session_id,
    a.exam_pack_version_id,
    epv.exam_pack_id,
    ep.exam_code,
    ep.exam_name,
    ep.subject_id,
    s.subject_key,
    s.display_name AS subject_name,
    a.content_item_version_id,
    ci.content_key,
    ci.item_type,
    ci.frq_form,
    ci.title,
    gr.response_version_id,
    gr.operation,
    gr.status,
    gr.points_earned,
    gr.points_available,
    gr.criterion_results,
    gr.highest_value_gap,
    gr.predicted_label,
    gr.predicted_point_gain,
    gr.actual_point_gain,
    gr.prediction_outcome,
    gr.confidence,
    gr.uncertainty_reason,
    gr.feedback_preview,
    gr.action_hint,
    gr.repair_hint,
    gr.deterministic_verifier_version,
    gr.boundary_contract_version,
    gr.created_at,
    gr.updated_at
   FROM ((((((app.grading_results gr
     JOIN app.attempts a ON ((a.id = gr.attempt_id)))
     JOIN app.content_item_versions civ ON ((civ.id = a.content_item_version_id)))
     JOIN app.content_items ci ON ((ci.id = civ.content_item_id)))
     JOIN app.exam_pack_versions epv ON ((epv.id = a.exam_pack_version_id)))
     JOIN app.exam_packs ep ON ((ep.id = epv.exam_pack_id)))
     JOIN app.subjects s ON ((s.id = ep.subject_id)));


--
-- Name: learning_sessions; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.learning_sessions WITH (security_invoker='true') AS
 SELECT ls.id,
    ls.user_id,
    ls.exam_pack_version_id,
    epv.exam_pack_id,
    ep.exam_code,
    ep.exam_name,
    ep.subject_id,
    s.subject_key,
    s.display_name AS subject_name,
    ls.entry_path,
    ls.session_mode,
    ls.available_minutes,
    ls.status,
    ls.started_at,
    ls.ended_at,
    ls.created_at,
    ls.updated_at
   FROM (((app.learning_sessions ls
     JOIN app.exam_pack_versions epv ON ((epv.id = ls.exam_pack_version_id)))
     JOIN app.exam_packs ep ON ((ep.id = epv.exam_pack_id)))
     JOIN app.subjects s ON ((s.id = ep.subject_id)));


--
-- Name: mcq_choices; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.mcq_choices WITH (security_invoker='true') AS
 SELECT mc.id,
    mc.content_item_version_id,
    civ.content_item_id,
    ci.exam_pack_version_id,
    epv.exam_pack_id,
    ep.exam_code,
    ep.exam_name,
    ep.subject_id,
    s.subject_key,
    s.display_name AS subject_name,
    ci.content_key,
    ci.item_type,
    ci.title,
    mc.choice_key,
    mc.choice_text,
    mc.is_correct,
    mc.rationale,
    mc.created_at
   FROM (((((app.mcq_choices mc
     JOIN app.content_item_versions civ ON ((civ.id = mc.content_item_version_id)))
     JOIN app.content_items ci ON ((ci.id = civ.content_item_id)))
     JOIN app.exam_pack_versions epv ON ((epv.id = ci.exam_pack_version_id)))
     JOIN app.exam_packs ep ON ((ep.id = epv.exam_pack_id)))
     JOIN app.subjects s ON ((s.id = ep.subject_id)));


--
-- Name: profiles; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.profiles WITH (security_invoker='true') AS
 SELECT user_id,
    full_name,
    role,
    review_queue_scope,
    timezone,
    locale,
    onboarding_completed_at,
    created_at,
    updated_at,
    active_exam_pack_version_id
   FROM app.profiles p;


--
-- Name: progress_snapshots; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.progress_snapshots WITH (security_invoker='true') AS
 SELECT ps.id,
    ps.user_id,
    ps.exam_pack_version_id,
    epv.exam_pack_id,
    ep.exam_code,
    ep.exam_name,
    ep.subject_id,
    s.subject_key,
    s.display_name AS subject_name,
    ps.snapshot_kind,
    ps.snapshot_json,
    ps.source_version,
    ps.generated_at
   FROM (((app.progress_snapshots ps
     JOIN app.exam_pack_versions epv ON ((epv.id = ps.exam_pack_version_id)))
     JOIN app.exam_packs ep ON ((ep.id = epv.exam_pack_id)))
     JOIN app.subjects s ON ((s.id = ep.subject_id)));


--
-- Name: questions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.questions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    type text NOT NULL,
    unit integer NOT NULL,
    topic_id text NOT NULL,
    science_practice integer,
    task_verb text,
    difficulty text,
    is_diagnostic boolean DEFAULT false NOT NULL,
    status text DEFAULT 'draft'::text NOT NULL,
    stem text NOT NULL,
    stimulus_url text,
    answer_choices jsonb,
    points_available integer DEFAULT 1 NOT NULL,
    rubric jsonb,
    teaching_package jsonb,
    version integer DEFAULT 1 NOT NULL,
    created_by text,
    approved_by text,
    approved_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT questions_difficulty_check CHECK ((difficulty = ANY (ARRAY['accessible'::text, 'standard'::text, 'challenging'::text]))),
    CONSTRAINT questions_science_practice_check CHECK (((science_practice >= 1) AND (science_practice <= 6))),
    CONSTRAINT questions_status_check CHECK ((status = ANY (ARRAY['draft'::text, 'review'::text, 'approved'::text, 'suspended'::text]))),
    CONSTRAINT questions_type_check CHECK ((type = ANY (ARRAY['mcq'::text, 'short_frq'::text, 'long_frq'::text]))),
    CONSTRAINT questions_unit_check CHECK (((unit >= 1) AND (unit <= 8)))
);


--
-- Name: response_versions; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.response_versions WITH (security_invoker='true') AS
 SELECT rv.id,
    rv.attempt_id,
    a.user_id,
    a.learning_session_id,
    a.exam_pack_version_id,
    epv.exam_pack_id,
    ep.exam_code,
    ep.exam_name,
    ep.subject_id,
    s.subject_key,
    s.display_name AS subject_name,
    a.content_item_version_id,
    rv.parent_response_version_id,
    rv.response_text,
    rv.response_parts,
    rv.version_number,
    rv.is_submitted,
    rv.created_by,
    rv.created_at,
    rv.updated_at
   FROM ((((app.response_versions rv
     JOIN app.attempts a ON ((a.id = rv.attempt_id)))
     JOIN app.exam_pack_versions epv ON ((epv.id = a.exam_pack_version_id)))
     JOIN app.exam_packs ep ON ((ep.id = epv.exam_pack_id)))
     JOIN app.subjects s ON ((s.id = ep.subject_id)));


--
-- Name: sessions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sessions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    student_id uuid NOT NULL,
    started_at timestamp with time zone DEFAULT now() NOT NULL,
    ended_at timestamp with time zone,
    mode text,
    entry_path text,
    selected_unit integer,
    selected_topic text,
    selected_format text,
    questions_served uuid[],
    summary jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT sessions_entry_path_check CHECK ((entry_path = ANY (ARRAY['recommendation'::text, 'self_guided_topic'::text, 'self_guided_format'::text]))),
    CONSTRAINT sessions_mode_check CHECK ((mode = ANY (ARRAY['quick'::text, 'focused'::text, 'buckle_down'::text]))),
    CONSTRAINT sessions_selected_format_check CHECK ((selected_format = ANY (ARRAY['mcq'::text, 'short_frq'::text, 'long_frq'::text, 'mixed'::text])))
);


--
-- Name: student_attempts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.student_attempts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    student_id uuid NOT NULL,
    question_id uuid NOT NULL,
    session_id uuid,
    attempt_number integer DEFAULT 1 NOT NULL,
    assistance_level text,
    response_text text,
    submitted_at timestamp with time zone,
    grading_state text DEFAULT 'draft_saved'::text NOT NULL,
    grader_output jsonb,
    time_on_task_s integer,
    paste_detected boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT student_attempts_assistance_level_check CHECK ((assistance_level = ANY (ARRAY['cold'::text, 'coached'::text, 'exam'::text])))
);


--
-- Name: student_lock_queue; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.student_lock_queue (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    student_id uuid NOT NULL,
    question_id uuid NOT NULL,
    criterion_id text NOT NULL,
    assistance_level text,
    result text,
    next_review_at timestamp with time zone NOT NULL,
    review_count integer DEFAULT 0 NOT NULL,
    last_attempt_id uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT student_lock_queue_assistance_level_check CHECK ((assistance_level = ANY (ARRAY['cold'::text, 'coached'::text]))),
    CONSTRAINT student_lock_queue_result_check CHECK ((result = ANY (ARRAY['earned'::text, 'not_earned'::text])))
);


--
-- Name: subjects; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.subjects WITH (security_invoker='true') AS
 SELECT id,
    subject_key,
    display_name,
    status,
    created_at,
    updated_at
   FROM app.subjects s;


--
-- Name: ai_variant_runs ai_variant_runs_pkey; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.ai_variant_runs
    ADD CONSTRAINT ai_variant_runs_pkey PRIMARY KEY (variant_run_id);


--
-- Name: artifact_dependencies artifact_dependencies_pkey; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.artifact_dependencies
    ADD CONSTRAINT artifact_dependencies_pkey PRIMARY KEY (dependency_id);


--
-- Name: artifact_label_assignments artifact_label_assignments_pkey; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.artifact_label_assignments
    ADD CONSTRAINT artifact_label_assignments_pkey PRIMARY KEY (artifact_version_id, content_label_id);


--
-- Name: artifact_state_events artifact_state_events_pkey; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.artifact_state_events
    ADD CONSTRAINT artifact_state_events_pkey PRIMARY KEY (artifact_state_event_id);


--
-- Name: artifact_versions artifact_versions_pkey; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.artifact_versions
    ADD CONSTRAINT artifact_versions_pkey PRIMARY KEY (artifact_version_id);


--
-- Name: attempt_criterion_results attempt_criterion_results_pkey; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.attempt_criterion_results
    ADD CONSTRAINT attempt_criterion_results_pkey PRIMARY KEY (id);


--
-- Name: attempt_responses attempt_responses_pkey; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.attempt_responses
    ADD CONSTRAINT attempt_responses_pkey PRIMARY KEY (id);


--
-- Name: attempt_responses attempt_responses_unique; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.attempt_responses
    ADD CONSTRAINT attempt_responses_unique UNIQUE (attempt_id, part_key);


--
-- Name: attempts attempts_pkey; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.attempts
    ADD CONSTRAINT attempts_pkey PRIMARY KEY (id);


--
-- Name: audit_events audit_events_pkey; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.audit_events
    ADD CONSTRAINT audit_events_pkey PRIMARY KEY (id);


--
-- Name: author_commissions author_commissions_pkey; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.author_commissions
    ADD CONSTRAINT author_commissions_pkey PRIMARY KEY (commission_id);


--
-- Name: author_qualifications author_qualifications_pkey; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.author_qualifications
    ADD CONSTRAINT author_qualifications_pkey PRIMARY KEY (author_qualification_id);


--
-- Name: authoring_briefs authoring_briefs_brief_version_id_key; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.authoring_briefs
    ADD CONSTRAINT authoring_briefs_brief_version_id_key UNIQUE (brief_version_id);


--
-- Name: authoring_briefs authoring_briefs_pkey; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.authoring_briefs
    ADD CONSTRAINT authoring_briefs_pkey PRIMARY KEY (brief_id);


--
-- Name: config config_pkey; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.config
    ADD CONSTRAINT config_pkey PRIMARY KEY (config_key);


--
-- Name: content_ingest_batches content_ingest_batches_pkey; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.content_ingest_batches
    ADD CONSTRAINT content_ingest_batches_pkey PRIMARY KEY (batch_id);


--
-- Name: content_ingest_rows content_ingest_rows_pkey; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.content_ingest_rows
    ADD CONSTRAINT content_ingest_rows_pkey PRIMARY KEY (ingest_row_id);


--
-- Name: content_item_labels content_item_labels_pkey; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.content_item_labels
    ADD CONSTRAINT content_item_labels_pkey PRIMARY KEY (content_item_id, content_label_id);


--
-- Name: content_item_versions content_item_versions_pkey; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.content_item_versions
    ADD CONSTRAINT content_item_versions_pkey PRIMARY KEY (id);


--
-- Name: content_item_versions content_item_versions_unique; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.content_item_versions
    ADD CONSTRAINT content_item_versions_unique UNIQUE (content_item_id, version_num);


--
-- Name: content_items content_items_pkey; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.content_items
    ADD CONSTRAINT content_items_pkey PRIMARY KEY (id);


--
-- Name: content_items content_items_unique_key; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.content_items
    ADD CONSTRAINT content_items_unique_key UNIQUE (exam_pack_version_id, content_key);


--
-- Name: content_labels content_labels_pkey; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.content_labels
    ADD CONSTRAINT content_labels_pkey PRIMARY KEY (id);


--
-- Name: content_labels content_labels_unique; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.content_labels
    ADD CONSTRAINT content_labels_unique UNIQUE (exam_pack_id, label_key);


--
-- Name: content_review_assignment_labels content_review_assignment_labels_pkey; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.content_review_assignment_labels
    ADD CONSTRAINT content_review_assignment_labels_pkey PRIMARY KEY (content_review_assignment_id, content_label_id);


--
-- Name: content_review_assignments content_review_assignments_pkey; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.content_review_assignments
    ADD CONSTRAINT content_review_assignments_pkey PRIMARY KEY (content_review_assignment_id);


--
-- Name: content_review_decisions content_review_decisions_pkey; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.content_review_decisions
    ADD CONSTRAINT content_review_decisions_pkey PRIMARY KEY (content_review_decision_id);


--
-- Name: content_rights_releases content_rights_releases_pkey; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.content_rights_releases
    ADD CONSTRAINT content_rights_releases_pkey PRIMARY KEY (release_id);


--
-- Name: daily_budgets daily_budgets_pkey; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.daily_budgets
    ADD CONSTRAINT daily_budgets_pkey PRIMARY KEY (usage_date_utc);


--
-- Name: exam_pack_manifests exam_pack_manifests_pkey; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.exam_pack_manifests
    ADD CONSTRAINT exam_pack_manifests_pkey PRIMARY KEY (manifest_id);


--
-- Name: exam_pack_versions exam_pack_versions_pkey; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.exam_pack_versions
    ADD CONSTRAINT exam_pack_versions_pkey PRIMARY KEY (id);


--
-- Name: exam_pack_versions exam_pack_versions_unique; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.exam_pack_versions
    ADD CONSTRAINT exam_pack_versions_unique UNIQUE (exam_pack_id, school_year);


--
-- Name: exam_packs exam_packs_exam_code_key; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.exam_packs
    ADD CONSTRAINT exam_packs_exam_code_key UNIQUE (exam_code);


--
-- Name: exam_packs exam_packs_pkey; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.exam_packs
    ADD CONSTRAINT exam_packs_pkey PRIMARY KEY (id);


--
-- Name: frq_criteria frq_criteria_pkey; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.frq_criteria
    ADD CONSTRAINT frq_criteria_pkey PRIMARY KEY (id);


--
-- Name: frq_criteria frq_criteria_unique; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.frq_criteria
    ADD CONSTRAINT frq_criteria_unique UNIQUE (content_item_version_id, criterion_key);


--
-- Name: frq_synthetic_responses frq_synthetic_responses_pkey; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.frq_synthetic_responses
    ADD CONSTRAINT frq_synthetic_responses_pkey PRIMARY KEY (id);


--
-- Name: grading_results grading_results_pkey; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.grading_results
    ADD CONSTRAINT grading_results_pkey PRIMARY KEY (id);


--
-- Name: grading_results grading_results_request_id_key; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.grading_results
    ADD CONSTRAINT grading_results_request_id_key UNIQUE (request_id);


--
-- Name: learning_sessions learning_sessions_pkey; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.learning_sessions
    ADD CONSTRAINT learning_sessions_pkey PRIMARY KEY (id);


--
-- Name: mcq_choices mcq_choices_pkey; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.mcq_choices
    ADD CONSTRAINT mcq_choices_pkey PRIMARY KEY (id);


--
-- Name: mcq_choices mcq_choices_unique; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.mcq_choices
    ADD CONSTRAINT mcq_choices_unique UNIQUE (content_item_version_id, choice_key);


--
-- Name: model_usage_ledger model_usage_ledger_pkey; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.model_usage_ledger
    ADD CONSTRAINT model_usage_ledger_pkey PRIMARY KEY (id);


--
-- Name: model_usage_ledger model_usage_ledger_request_id_key; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.model_usage_ledger
    ADD CONSTRAINT model_usage_ledger_request_id_key UNIQUE (request_id);


--
-- Name: originality_attestations originality_attestations_pkey; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.originality_attestations
    ADD CONSTRAINT originality_attestations_pkey PRIMARY KEY (attestation_id);


--
-- Name: profiles profiles_pkey; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.profiles
    ADD CONSTRAINT profiles_pkey PRIMARY KEY (user_id);


--
-- Name: progress_snapshots progress_snapshots_pkey; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.progress_snapshots
    ADD CONSTRAINT progress_snapshots_pkey PRIMARY KEY (id);


--
-- Name: prompt_versions prompt_versions_pkey; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.prompt_versions
    ADD CONSTRAINT prompt_versions_pkey PRIMARY KEY (id);


--
-- Name: prompt_versions prompt_versions_unique; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.prompt_versions
    ADD CONSTRAINT prompt_versions_unique UNIQUE (operation, version);


--
-- Name: provenance_claims provenance_claims_pkey; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.provenance_claims
    ADD CONSTRAINT provenance_claims_pkey PRIMARY KEY (claim_id);


--
-- Name: publication_events publication_events_pkey; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.publication_events
    ADD CONSTRAINT publication_events_pkey PRIMARY KEY (publication_event_id);


--
-- Name: quality_incidents quality_incidents_pkey; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.quality_incidents
    ADD CONSTRAINT quality_incidents_pkey PRIMARY KEY (incident_id);


--
-- Name: question_coverage_targets question_coverage_targets_pkey; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.question_coverage_targets
    ADD CONSTRAINT question_coverage_targets_pkey PRIMARY KEY (coverage_target_id);


--
-- Name: question_use_assignments question_use_assignments_pkey; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.question_use_assignments
    ADD CONSTRAINT question_use_assignments_pkey PRIMARY KEY (use_assignment_id);


--
-- Name: release_candidates release_candidates_pkey; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.release_candidates
    ADD CONSTRAINT release_candidates_pkey PRIMARY KEY (release_candidate_id);


--
-- Name: response_versions response_versions_pkey; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.response_versions
    ADD CONSTRAINT response_versions_pkey PRIMARY KEY (id);


--
-- Name: response_versions response_versions_unique; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.response_versions
    ADD CONSTRAINT response_versions_unique UNIQUE (attempt_id, version_number);


--
-- Name: revalidation_cases revalidation_cases_pkey; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.revalidation_cases
    ADD CONSTRAINT revalidation_cases_pkey PRIMARY KEY (revalidation_id);


--
-- Name: review_assignments review_assignments_pkey; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.review_assignments
    ADD CONSTRAINT review_assignments_pkey PRIMARY KEY (assignment_id);


--
-- Name: review_decisions review_decisions_pkey; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.review_decisions
    ADD CONSTRAINT review_decisions_pkey PRIMARY KEY (review_decision_id);


--
-- Name: rights_records rights_records_pkey; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.rights_records
    ADD CONSTRAINT rights_records_pkey PRIMARY KEY (rights_record_id);


--
-- Name: source_records source_records_pkey; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.source_records
    ADD CONSTRAINT source_records_pkey PRIMARY KEY (source_version_id);


--
-- Name: student_memory_events student_memory_events_pkey; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.student_memory_events
    ADD CONSTRAINT student_memory_events_pkey PRIMARY KEY (id);


--
-- Name: student_memory_snapshots student_memory_snapshots_pkey; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.student_memory_snapshots
    ADD CONSTRAINT student_memory_snapshots_pkey PRIMARY KEY (user_id, subject_id);


--
-- Name: subject_guidance_profiles subject_guidance_profiles_pkey; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.subject_guidance_profiles
    ADD CONSTRAINT subject_guidance_profiles_pkey PRIMARY KEY (subject_id);


--
-- Name: subjects subjects_pkey; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.subjects
    ADD CONSTRAINT subjects_pkey PRIMARY KEY (id);


--
-- Name: subjects subjects_subject_key_key; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.subjects
    ADD CONSTRAINT subjects_subject_key_key UNIQUE (subject_key);


--
-- Name: validation_cases validation_cases_case_version_id_key; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.validation_cases
    ADD CONSTRAINT validation_cases_case_version_id_key UNIQUE (case_version_id);


--
-- Name: validation_cases validation_cases_pkey; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.validation_cases
    ADD CONSTRAINT validation_cases_pkey PRIMARY KEY (case_id);


--
-- Name: validation_results validation_results_pkey; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.validation_results
    ADD CONSTRAINT validation_results_pkey PRIMARY KEY (result_id);


--
-- Name: validation_runs validation_runs_pkey; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.validation_runs
    ADD CONSTRAINT validation_runs_pkey PRIMARY KEY (run_id);


--
-- Name: validation_suites validation_suites_pkey; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.validation_suites
    ADD CONSTRAINT validation_suites_pkey PRIMARY KEY (suite_id);


--
-- Name: validation_suites validation_suites_suite_version_id_key; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.validation_suites
    ADD CONSTRAINT validation_suites_suite_version_id_key UNIQUE (suite_version_id);


--
-- Name: validator_entitlements validator_entitlements_pkey; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.validator_entitlements
    ADD CONSTRAINT validator_entitlements_pkey PRIMARY KEY (entitlement_id);


--
-- Name: validator_qualifications validator_qualifications_pkey; Type: CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.validator_qualifications
    ADD CONSTRAINT validator_qualifications_pkey PRIMARY KEY (qualification_id);


--
-- Name: exam_specs exam_specs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exam_specs
    ADD CONSTRAINT exam_specs_pkey PRIMARY KEY (id);


--
-- Name: exam_specs exam_specs_subject_exam_year_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exam_specs
    ADD CONSTRAINT exam_specs_subject_exam_year_unique UNIQUE (subject, exam_year);


--
-- Name: questions questions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.questions
    ADD CONSTRAINT questions_pkey PRIMARY KEY (id);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: student_attempts student_attempts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.student_attempts
    ADD CONSTRAINT student_attempts_pkey PRIMARY KEY (id);


--
-- Name: student_lock_queue student_lock_queue_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.student_lock_queue
    ADD CONSTRAINT student_lock_queue_pkey PRIMARY KEY (id);


--
-- Name: artifact_state_events_artifact_version_id_idx; Type: INDEX; Schema: app; Owner: -
--

CREATE INDEX artifact_state_events_artifact_version_id_idx ON app.artifact_state_events USING btree (artifact_version_id, changed_at DESC);


--
-- Name: artifact_versions_artifact_id_version_sequence_unique; Type: INDEX; Schema: app; Owner: -
--

CREATE UNIQUE INDEX artifact_versions_artifact_id_version_sequence_unique ON app.artifact_versions USING btree (artifact_id, version_sequence);


--
-- Name: attempt_criterion_results_one_criterion_per_attempt; Type: INDEX; Schema: app; Owner: -
--

CREATE UNIQUE INDEX attempt_criterion_results_one_criterion_per_attempt ON app.attempt_criterion_results USING btree (attempt_id, criterion_key);


--
-- Name: attempt_responses_one_part_per_attempt; Type: INDEX; Schema: app; Owner: -
--

CREATE UNIQUE INDEX attempt_responses_one_part_per_attempt ON app.attempt_responses USING btree (attempt_id, part_key);


--
-- Name: attempts_artifact_version_id_idx; Type: INDEX; Schema: app; Owner: -
--

CREATE INDEX attempts_artifact_version_id_idx ON app.attempts USING btree (artifact_version_id, submitted_at DESC);


--
-- Name: attempts_learning_session_id_idx; Type: INDEX; Schema: app; Owner: -
--

CREATE INDEX attempts_learning_session_id_idx ON app.attempts USING btree (learning_session_id);


--
-- Name: audit_events_request_id_reason_code_unique; Type: INDEX; Schema: app; Owner: -
--

CREATE UNIQUE INDEX audit_events_request_id_reason_code_unique ON app.audit_events USING btree (request_id, reason_code) WHERE ((request_id IS NOT NULL) AND (reason_code IS NOT NULL));


--
-- Name: content_ingest_rows_batch_id_idx; Type: INDEX; Schema: app; Owner: -
--

CREATE INDEX content_ingest_rows_batch_id_idx ON app.content_ingest_rows USING btree (batch_id, row_number);


--
-- Name: content_item_versions_one_published_per_item; Type: INDEX; Schema: app; Owner: -
--

CREATE UNIQUE INDEX content_item_versions_one_published_per_item ON app.content_item_versions USING btree (content_item_id) WHERE (status = 'published'::text);


--
-- Name: content_items_exam_pack_practice_format_idx; Type: INDEX; Schema: app; Owner: -
--

CREATE INDEX content_items_exam_pack_practice_format_idx ON app.content_items USING btree (exam_pack_version_id, item_type, practice_format, status);


--
-- Name: content_review_assignment_labels_label_idx; Type: INDEX; Schema: app; Owner: -
--

CREATE INDEX content_review_assignment_labels_label_idx ON app.content_review_assignment_labels USING btree (content_label_id, content_review_assignment_id);


--
-- Name: cra_blind_group_idx; Type: INDEX; Schema: app; Owner: -
--

CREATE INDEX cra_blind_group_idx ON app.content_review_assignments USING btree (blind_group_id) WHERE (blind_group_id IS NOT NULL);


--
-- Name: cra_ingest_row_idx; Type: INDEX; Schema: app; Owner: -
--

CREATE INDEX cra_ingest_row_idx ON app.content_review_assignments USING btree (ingest_row_id) WHERE (ingest_row_id IS NOT NULL);


--
-- Name: cra_reviewer_status_idx; Type: INDEX; Schema: app; Owner: -
--

CREATE INDEX cra_reviewer_status_idx ON app.content_review_assignments USING btree (reviewer_id, status);


--
-- Name: cra_unique_by_content_version; Type: INDEX; Schema: app; Owner: -
--

CREATE UNIQUE INDEX cra_unique_by_content_version ON app.content_review_assignments USING btree (content_item_version_id, reviewer_id, review_stage) WHERE (content_item_version_id IS NOT NULL);


--
-- Name: cra_unique_by_ingest_row; Type: INDEX; Schema: app; Owner: -
--

CREATE UNIQUE INDEX cra_unique_by_ingest_row ON app.content_review_assignments USING btree (ingest_row_id, reviewer_id, review_stage) WHERE (ingest_row_id IS NOT NULL);


--
-- Name: cra_version_stage_idx; Type: INDEX; Schema: app; Owner: -
--

CREATE INDEX cra_version_stage_idx ON app.content_review_assignments USING btree (content_item_version_id, review_stage);


--
-- Name: crd_assignment_submitted_idx; Type: INDEX; Schema: app; Owner: -
--

CREATE INDEX crd_assignment_submitted_idx ON app.content_review_decisions USING btree (content_review_assignment_id, submitted_at DESC);


--
-- Name: crd_reviewer_submitted_idx; Type: INDEX; Schema: app; Owner: -
--

CREATE INDEX crd_reviewer_submitted_idx ON app.content_review_decisions USING btree (reviewer_id, submitted_at DESC);


--
-- Name: crd_supersedes_idx; Type: INDEX; Schema: app; Owner: -
--

CREATE INDEX crd_supersedes_idx ON app.content_review_decisions USING btree (supersedes_id) WHERE (supersedes_id IS NOT NULL);


--
-- Name: crd_version_stage_idx; Type: INDEX; Schema: app; Owner: -
--

CREATE INDEX crd_version_stage_idx ON app.content_review_decisions USING btree (content_item_version_id, review_stage);


--
-- Name: exam_packs_subject_id_idx; Type: INDEX; Schema: app; Owner: -
--

CREATE INDEX exam_packs_subject_id_idx ON app.exam_packs USING btree (subject_id);


--
-- Name: frq_synthetic_responses_civ_id_idx; Type: INDEX; Schema: app; Owner: -
--

CREATE INDEX frq_synthetic_responses_civ_id_idx ON app.frq_synthetic_responses USING btree (content_item_version_id);


--
-- Name: frq_synthetic_responses_type_idx; Type: INDEX; Schema: app; Owner: -
--

CREATE INDEX frq_synthetic_responses_type_idx ON app.frq_synthetic_responses USING btree (response_type);


--
-- Name: mcq_choices_one_correct_per_version; Type: INDEX; Schema: app; Owner: -
--

CREATE UNIQUE INDEX mcq_choices_one_correct_per_version ON app.mcq_choices USING btree (content_item_version_id) WHERE is_correct;


--
-- Name: profiles_active_epv_idx; Type: INDEX; Schema: app; Owner: -
--

CREATE INDEX profiles_active_epv_idx ON app.profiles USING btree (active_exam_pack_version_id);


--
-- Name: profiles_role_idx; Type: INDEX; Schema: app; Owner: -
--

CREATE INDEX profiles_role_idx ON app.profiles USING btree (role);


--
-- Name: question_coverage_targets_subject_id_idx; Type: INDEX; Schema: app; Owner: -
--

CREATE INDEX question_coverage_targets_subject_id_idx ON app.question_coverage_targets USING btree (subject_id);


--
-- Name: review_assignments_artifact_version_id_idx; Type: INDEX; Schema: app; Owner: -
--

CREATE INDEX review_assignments_artifact_version_id_idx ON app.review_assignments USING btree (artifact_version_id, status);


--
-- Name: review_assignments_one_active_review_per_artifact; Type: INDEX; Schema: app; Owner: -
--

CREATE UNIQUE INDEX review_assignments_one_active_review_per_artifact ON app.review_assignments USING btree (artifact_version_id, review_type) WHERE (status = ANY (ARRAY['assigned'::text, 'opened'::text]));


--
-- Name: review_decisions_assignment_id_idx; Type: INDEX; Schema: app; Owner: -
--

CREATE INDEX review_decisions_assignment_id_idx ON app.review_decisions USING btree (assignment_id, submitted_at DESC);


--
-- Name: rights_records_one_per_source_version; Type: INDEX; Schema: app; Owner: -
--

CREATE UNIQUE INDEX rights_records_one_per_source_version ON app.rights_records USING btree (source_version_id);


--
-- Name: source_records_source_id_version_sequence_unique; Type: INDEX; Schema: app; Owner: -
--

CREATE UNIQUE INDEX source_records_source_id_version_sequence_unique ON app.source_records USING btree (source_id, version_sequence);


--
-- Name: student_memory_events_user_subject_created_idx; Type: INDEX; Schema: app; Owner: -
--

CREATE INDEX student_memory_events_user_subject_created_idx ON app.student_memory_events USING btree (user_id, subject_id, created_at DESC);


--
-- Name: validation_cases_case_version_unique; Type: INDEX; Schema: app; Owner: -
--

CREATE UNIQUE INDEX validation_cases_case_version_unique ON app.validation_cases USING btree (case_version_id);


--
-- Name: validation_suites_suite_version_unique; Type: INDEX; Schema: app; Owner: -
--

CREATE UNIQUE INDEX validation_suites_suite_version_unique ON app.validation_suites USING btree (suite_version_id);


--
-- Name: validator_entitlements_reviewer_id_idx; Type: INDEX; Schema: app; Owner: -
--

CREATE INDEX validator_entitlements_reviewer_id_idx ON app.validator_entitlements USING btree (reviewer_id, status);


--
-- Name: validator_qualifications_reviewer_id_idx; Type: INDEX; Schema: app; Owner: -
--

CREATE INDEX validator_qualifications_reviewer_id_idx ON app.validator_qualifications USING btree (reviewer_id, status);


--
-- Name: questions_status_unit_topic_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX questions_status_unit_topic_idx ON public.questions USING btree (status, unit, topic_id);


--
-- Name: sessions_student_started_at_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sessions_student_started_at_idx ON public.sessions USING btree (student_id, started_at DESC);


--
-- Name: student_attempts_session_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX student_attempts_session_idx ON public.student_attempts USING btree (session_id);


--
-- Name: student_attempts_student_submitted_at_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX student_attempts_student_submitted_at_idx ON public.student_attempts USING btree (student_id, submitted_at DESC);


--
-- Name: student_lock_queue_student_next_review_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX student_lock_queue_student_next_review_idx ON public.student_lock_queue USING btree (student_id, next_review_at);


--
-- Name: dashboard_attention_v1 _RETURN; Type: RULE; Schema: public; Owner: -
--

CREATE OR REPLACE VIEW public.dashboard_attention_v1 AS
 WITH attention_rows AS (
         SELECT s.id AS subject_id,
            s.subject_key,
            s.display_name AS subject_name,
            count(DISTINCT cra.content_review_assignment_id) FILTER (WHERE ((cra.status = ANY (ARRAY['pending'::text, 'in_progress'::text])) AND (cra.due_at IS NOT NULL) AND (cra.due_at < now()))) AS overdue_review_assignments_count,
            count(DISTINCT cra.content_review_assignment_id) FILTER (WHERE (cra.status = ANY (ARRAY['pending'::text, 'in_progress'::text]))) AS open_review_assignments_count,
            count(DISTINCT civ.id) FILTER (WHERE (civ.review_status = ANY (ARRAY['modification_reserved'::text, 'excluded'::text, 'answer_modification_reserved'::text, 'mcq_package_excluded'::text]))) AS blocked_content_versions_count,
            count(DISTINCT gr.id) FILTER (WHERE (gr.status = ANY (ARRAY['failed'::text, 'uncertain'::text]))) AS unresolved_grading_results_count,
            GREATEST(COALESCE(max(cra.created_at), s.created_at), COALESCE(max(civ.updated_at), s.created_at), COALESCE(max(gr.updated_at), s.created_at)) AS latest_update_at
           FROM (((((((app.subjects s
             LEFT JOIN app.exam_packs ep ON ((ep.subject_id = s.id)))
             LEFT JOIN app.exam_pack_versions epv ON ((epv.exam_pack_id = ep.id)))
             LEFT JOIN app.content_items ci ON ((ci.exam_pack_version_id = epv.id)))
             LEFT JOIN app.content_item_versions civ ON ((civ.content_item_id = ci.id)))
             LEFT JOIN app.content_review_assignments cra ON ((cra.content_item_version_id = civ.id)))
             LEFT JOIN app.attempts a ON ((a.content_item_version_id = civ.id)))
             LEFT JOIN app.grading_results gr ON ((gr.attempt_id = a.id)))
          WHERE ((s.status = 'active'::text) AND (EXISTS ( SELECT 1
                   FROM app.profiles p
                  WHERE ((p.user_id = auth.uid()) AND (p.role = ANY (ARRAY['content_author'::text, 'tutor'::text, 'reader'::text, 'validator'::text, 'support'::text, 'admin'::text]))))))
          GROUP BY s.id, s.subject_key, s.display_name
        )
 SELECT subject_id,
    subject_key,
    subject_name,
    overdue_review_assignments_count,
    open_review_assignments_count,
    blocked_content_versions_count,
    unresolved_grading_results_count,
    latest_update_at
   FROM attention_rows
  ORDER BY overdue_review_assignments_count DESC, blocked_content_versions_count DESC, subject_name;


--
-- Name: dashboard_subjects_v1 _RETURN; Type: RULE; Schema: public; Owner: -
--

CREATE OR REPLACE VIEW public.dashboard_subjects_v1 AS
 SELECT s.id AS subject_id,
    s.subject_key,
    s.display_name AS subject_name,
    count(DISTINCT ep.id) AS exam_packs_count,
    count(DISTINCT ci.id) FILTER (WHERE (ci.status = 'published'::text)) AS published_content_items_count,
    count(DISTINCT civ.id) FILTER (WHERE (civ.status = 'published'::text)) AS published_content_versions_count,
    count(DISTINCT ls.id) FILTER (WHERE (ls.status = 'active'::text)) AS active_learning_sessions_count,
    count(DISTINCT a.id) FILTER (WHERE (a.status = ANY (ARRAY['draft'::text, 'submitted'::text, 'grading'::text, 'graded'::text, 'uncertain'::text, 'failed'::text]))) AS attempts_count,
    count(DISTINCT cra.content_review_assignment_id) FILTER (WHERE (cra.status = ANY (ARRAY['pending'::text, 'in_progress'::text]))) AS open_review_assignments_count,
    count(DISTINCT gr.id) FILTER (WHERE (gr.status = ANY (ARRAY['processing'::text, 'failed'::text, 'uncertain'::text]))) AS grading_results_count,
    GREATEST(COALESCE(max(s.updated_at), s.created_at), COALESCE(max(ep.updated_at), s.created_at), COALESCE(max(ci.updated_at), s.created_at), COALESCE(max(civ.updated_at), s.created_at), COALESCE(max(ls.updated_at), s.created_at), COALESCE(max(a.updated_at), s.created_at), COALESCE(max(cra.created_at), s.created_at), COALESCE(max(gr.updated_at), s.created_at)) AS latest_update_at
   FROM ((((((((app.subjects s
     LEFT JOIN app.exam_packs ep ON ((ep.subject_id = s.id)))
     LEFT JOIN app.exam_pack_versions epv ON ((epv.exam_pack_id = ep.id)))
     LEFT JOIN app.content_items ci ON ((ci.exam_pack_version_id = epv.id)))
     LEFT JOIN app.content_item_versions civ ON ((civ.content_item_id = ci.id)))
     LEFT JOIN app.learning_sessions ls ON ((ls.exam_pack_version_id = epv.id)))
     LEFT JOIN app.attempts a ON ((a.exam_pack_version_id = epv.id)))
     LEFT JOIN app.content_review_assignments cra ON ((cra.content_item_version_id = civ.id)))
     LEFT JOIN app.grading_results gr ON ((gr.attempt_id = a.id)))
  WHERE ((s.status = 'active'::text) AND (EXISTS ( SELECT 1
           FROM app.profiles p
          WHERE ((p.user_id = auth.uid()) AND (p.role = ANY (ARRAY['content_author'::text, 'tutor'::text, 'reader'::text, 'validator'::text, 'support'::text, 'admin'::text]))))))
  GROUP BY s.id, s.subject_key, s.display_name;


--
-- Name: attempt_responses attempt_responses_set_updated_at; Type: TRIGGER; Schema: app; Owner: -
--

CREATE TRIGGER attempt_responses_set_updated_at BEFORE UPDATE ON app.attempt_responses FOR EACH ROW EXECUTE FUNCTION app.set_updated_at();


--
-- Name: attempts attempts_prevent_client_grading_truth_update; Type: TRIGGER; Schema: app; Owner: -
--

CREATE TRIGGER attempts_prevent_client_grading_truth_update BEFORE UPDATE ON app.attempts FOR EACH ROW EXECUTE FUNCTION app.prevent_client_grading_truth_update();


--
-- Name: attempts attempts_set_updated_at; Type: TRIGGER; Schema: app; Owner: -
--

CREATE TRIGGER attempts_set_updated_at BEFORE UPDATE ON app.attempts FOR EACH ROW EXECUTE FUNCTION app.set_updated_at();


--
-- Name: config config_set_updated_at; Type: TRIGGER; Schema: app; Owner: -
--

CREATE TRIGGER config_set_updated_at BEFORE UPDATE ON app.config FOR EACH ROW EXECUTE FUNCTION app.set_updated_at();


--
-- Name: content_ingest_batches content_ingest_batches_set_updated_at; Type: TRIGGER; Schema: app; Owner: -
--

CREATE TRIGGER content_ingest_batches_set_updated_at BEFORE UPDATE ON app.content_ingest_batches FOR EACH ROW EXECUTE FUNCTION app.set_updated_at();


--
-- Name: content_ingest_rows content_ingest_rows_set_updated_at; Type: TRIGGER; Schema: app; Owner: -
--

CREATE TRIGGER content_ingest_rows_set_updated_at BEFORE UPDATE ON app.content_ingest_rows FOR EACH ROW EXECUTE FUNCTION app.set_updated_at();


--
-- Name: content_item_versions content_item_versions_set_updated_at; Type: TRIGGER; Schema: app; Owner: -
--

CREATE TRIGGER content_item_versions_set_updated_at BEFORE UPDATE ON app.content_item_versions FOR EACH ROW EXECUTE FUNCTION app.set_updated_at();


--
-- Name: content_items content_items_enforce_frq_form; Type: TRIGGER; Schema: app; Owner: -
--

CREATE TRIGGER content_items_enforce_frq_form BEFORE INSERT OR UPDATE ON app.content_items FOR EACH ROW EXECUTE FUNCTION app.enforce_content_items_frq_form();


--
-- Name: content_items content_items_set_updated_at; Type: TRIGGER; Schema: app; Owner: -
--

CREATE TRIGGER content_items_set_updated_at BEFORE UPDATE ON app.content_items FOR EACH ROW EXECUTE FUNCTION app.set_updated_at();


--
-- Name: content_labels content_labels_set_updated_at; Type: TRIGGER; Schema: app; Owner: -
--

CREATE TRIGGER content_labels_set_updated_at BEFORE UPDATE ON app.content_labels FOR EACH ROW EXECUTE FUNCTION app.set_updated_at();


--
-- Name: content_item_versions content_pipeline_guard_publish; Type: TRIGGER; Schema: app; Owner: -
--

CREATE TRIGGER content_pipeline_guard_publish BEFORE UPDATE ON app.content_item_versions FOR EACH ROW EXECUTE FUNCTION app.tg_content_pipeline_guard_publish();


--
-- Name: content_items content_pipeline_guard_publish; Type: TRIGGER; Schema: app; Owner: -
--

CREATE TRIGGER content_pipeline_guard_publish BEFORE UPDATE ON app.content_items FOR EACH ROW EXECUTE FUNCTION app.tg_content_pipeline_guard_publish();


--
-- Name: content_review_assignments content_pipeline_on_assignment; Type: TRIGGER; Schema: app; Owner: -
--

CREATE TRIGGER content_pipeline_on_assignment AFTER INSERT ON app.content_review_assignments FOR EACH ROW EXECUTE FUNCTION app.tg_content_pipeline_on_assignment();


--
-- Name: content_review_decisions content_pipeline_on_decision; Type: TRIGGER; Schema: app; Owner: -
--

CREATE TRIGGER content_pipeline_on_decision AFTER INSERT ON app.content_review_decisions FOR EACH ROW EXECUTE FUNCTION app.tg_content_pipeline_on_decision();


--
-- Name: content_review_assignments content_review_assignment_qualification_on_insert; Type: TRIGGER; Schema: app; Owner: -
--

CREATE TRIGGER content_review_assignment_qualification_on_insert BEFORE INSERT ON app.content_review_assignments FOR EACH ROW EXECUTE FUNCTION app.tg_enforce_content_review_qualification();


--
-- Name: content_review_assignments content_review_assignment_qualification_on_scope_change; Type: TRIGGER; Schema: app; Owner: -
--

CREATE TRIGGER content_review_assignment_qualification_on_scope_change BEFORE UPDATE OF reviewer_id, content_item_version_id ON app.content_review_assignments FOR EACH ROW EXECUTE FUNCTION app.tg_enforce_content_review_qualification();


--
-- Name: content_review_decisions content_review_decisions_immutable; Type: TRIGGER; Schema: app; Owner: -
--

CREATE TRIGGER content_review_decisions_immutable BEFORE DELETE OR UPDATE ON app.content_review_decisions FOR EACH ROW EXECUTE FUNCTION app.prevent_review_decision_mutation();


--
-- Name: content_review_decisions content_review_decisions_validate_answer_key; Type: TRIGGER; Schema: app; Owner: -
--

CREATE TRIGGER content_review_decisions_validate_answer_key BEFORE INSERT ON app.content_review_decisions FOR EACH ROW EXECUTE FUNCTION app.validate_decision_answer_key();


--
-- Name: content_review_decisions content_review_submission_lock; Type: TRIGGER; Schema: app; Owner: -
--

CREATE TRIGGER content_review_submission_lock BEFORE INSERT ON app.content_review_decisions FOR EACH ROW EXECUTE FUNCTION app.lock_content_review_submission();


--
-- Name: daily_budgets daily_budgets_set_updated_at; Type: TRIGGER; Schema: app; Owner: -
--

CREATE TRIGGER daily_budgets_set_updated_at BEFORE UPDATE ON app.daily_budgets FOR EACH ROW EXECUTE FUNCTION app.set_updated_at();


--
-- Name: frq_criteria enforce_full_exam_frq_criteria; Type: TRIGGER; Schema: app; Owner: -
--

CREATE CONSTRAINT TRIGGER enforce_full_exam_frq_criteria AFTER INSERT OR DELETE OR UPDATE ON app.frq_criteria DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE FUNCTION app.enforce_full_exam_frq_criteria();


--
-- Name: content_item_versions enforce_full_exam_frq_version; Type: TRIGGER; Schema: app; Owner: -
--

CREATE CONSTRAINT TRIGGER enforce_full_exam_frq_version AFTER INSERT OR UPDATE OF status, prompt_json ON app.content_item_versions DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE FUNCTION app.enforce_full_exam_frq_version();


--
-- Name: exam_pack_versions exam_pack_versions_set_updated_at; Type: TRIGGER; Schema: app; Owner: -
--

CREATE TRIGGER exam_pack_versions_set_updated_at BEFORE UPDATE ON app.exam_pack_versions FOR EACH ROW EXECUTE FUNCTION app.set_updated_at();


--
-- Name: exam_packs exam_packs_set_updated_at; Type: TRIGGER; Schema: app; Owner: -
--

CREATE TRIGGER exam_packs_set_updated_at BEFORE UPDATE ON app.exam_packs FOR EACH ROW EXECUTE FUNCTION app.set_updated_at();


--
-- Name: frq_criteria frq_criteria_prevent_empty; Type: TRIGGER; Schema: app; Owner: -
--

CREATE TRIGGER frq_criteria_prevent_empty AFTER DELETE ON app.frq_criteria FOR EACH ROW EXECUTE FUNCTION app.prevent_empty_frq_criteria();


--
-- Name: grading_results grading_results_set_updated_at; Type: TRIGGER; Schema: app; Owner: -
--

CREATE TRIGGER grading_results_set_updated_at BEFORE UPDATE ON app.grading_results FOR EACH ROW EXECUTE FUNCTION app.set_updated_at();


--
-- Name: learning_sessions learning_sessions_set_updated_at; Type: TRIGGER; Schema: app; Owner: -
--

CREATE TRIGGER learning_sessions_set_updated_at BEFORE UPDATE ON app.learning_sessions FOR EACH ROW EXECUTE FUNCTION app.set_updated_at();


--
-- Name: content_items prevent_live_frq_reclassification; Type: TRIGGER; Schema: app; Owner: -
--

CREATE TRIGGER prevent_live_frq_reclassification BEFORE UPDATE OF practice_format, frq_archetype, frq_form ON app.content_items FOR EACH ROW WHEN ((old.item_type = 'frq'::text)) EXECUTE FUNCTION app.prevent_live_frq_reclassification();


--
-- Name: profiles profiles_prevent_role_change; Type: TRIGGER; Schema: app; Owner: -
--

CREATE TRIGGER profiles_prevent_role_change BEFORE UPDATE ON app.profiles FOR EACH ROW EXECUTE FUNCTION app.prevent_profile_role_change();


--
-- Name: profiles profiles_set_updated_at; Type: TRIGGER; Schema: app; Owner: -
--

CREATE TRIGGER profiles_set_updated_at BEFORE UPDATE ON app.profiles FOR EACH ROW EXECUTE FUNCTION app.set_updated_at();


--
-- Name: response_versions response_versions_set_updated_at; Type: TRIGGER; Schema: app; Owner: -
--

CREATE TRIGGER response_versions_set_updated_at BEFORE UPDATE ON app.response_versions FOR EACH ROW EXECUTE FUNCTION app.set_updated_at();


--
-- Name: student_memory_events student_memory_events_apply_snapshot; Type: TRIGGER; Schema: app; Owner: -
--

CREATE TRIGGER student_memory_events_apply_snapshot AFTER INSERT ON app.student_memory_events FOR EACH ROW EXECUTE FUNCTION app.apply_student_memory_event();


--
-- Name: student_memory_snapshots student_memory_snapshots_set_updated_at; Type: TRIGGER; Schema: app; Owner: -
--

CREATE TRIGGER student_memory_snapshots_set_updated_at BEFORE UPDATE ON app.student_memory_snapshots FOR EACH ROW EXECUTE FUNCTION app.set_updated_at();


--
-- Name: subject_guidance_profiles subject_guidance_profiles_set_updated_at; Type: TRIGGER; Schema: app; Owner: -
--

CREATE TRIGGER subject_guidance_profiles_set_updated_at BEFORE UPDATE ON app.subject_guidance_profiles FOR EACH ROW EXECUTE FUNCTION app.set_updated_at();


--
-- Name: subjects subjects_set_updated_at; Type: TRIGGER; Schema: app; Owner: -
--

CREATE TRIGGER subjects_set_updated_at BEFORE UPDATE ON app.subjects FOR EACH ROW EXECUTE FUNCTION app.set_updated_at();


--
-- Name: ai_variant_runs ai_variant_runs_created_by_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.ai_variant_runs
    ADD CONSTRAINT ai_variant_runs_created_by_fkey FOREIGN KEY (created_by) REFERENCES app.profiles(user_id);


--
-- Name: ai_variant_runs ai_variant_runs_prompt_version_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.ai_variant_runs
    ADD CONSTRAINT ai_variant_runs_prompt_version_id_fkey FOREIGN KEY (prompt_version_id) REFERENCES app.prompt_versions(id) ON DELETE RESTRICT;


--
-- Name: artifact_dependencies artifact_dependencies_created_by_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.artifact_dependencies
    ADD CONSTRAINT artifact_dependencies_created_by_fkey FOREIGN KEY (created_by) REFERENCES app.profiles(user_id);


--
-- Name: artifact_dependencies artifact_dependencies_from_artifact_version_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.artifact_dependencies
    ADD CONSTRAINT artifact_dependencies_from_artifact_version_id_fkey FOREIGN KEY (from_artifact_version_id) REFERENCES app.artifact_versions(artifact_version_id) ON DELETE CASCADE;


--
-- Name: artifact_dependencies artifact_dependencies_to_artifact_version_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.artifact_dependencies
    ADD CONSTRAINT artifact_dependencies_to_artifact_version_id_fkey FOREIGN KEY (to_artifact_version_id) REFERENCES app.artifact_versions(artifact_version_id) ON DELETE CASCADE;


--
-- Name: artifact_label_assignments artifact_label_assignments_artifact_version_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.artifact_label_assignments
    ADD CONSTRAINT artifact_label_assignments_artifact_version_id_fkey FOREIGN KEY (artifact_version_id) REFERENCES app.artifact_versions(artifact_version_id) ON DELETE CASCADE;


--
-- Name: artifact_label_assignments artifact_label_assignments_content_label_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.artifact_label_assignments
    ADD CONSTRAINT artifact_label_assignments_content_label_id_fkey FOREIGN KEY (content_label_id) REFERENCES app.content_labels(id) ON DELETE CASCADE;


--
-- Name: artifact_label_assignments artifact_label_assignments_created_by_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.artifact_label_assignments
    ADD CONSTRAINT artifact_label_assignments_created_by_fkey FOREIGN KEY (created_by) REFERENCES app.profiles(user_id);


--
-- Name: artifact_state_events artifact_state_events_artifact_version_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.artifact_state_events
    ADD CONSTRAINT artifact_state_events_artifact_version_id_fkey FOREIGN KEY (artifact_version_id) REFERENCES app.artifact_versions(artifact_version_id) ON DELETE CASCADE;


--
-- Name: artifact_state_events artifact_state_events_changed_by_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.artifact_state_events
    ADD CONSTRAINT artifact_state_events_changed_by_fkey FOREIGN KEY (changed_by) REFERENCES app.profiles(user_id);


--
-- Name: artifact_state_events artifact_state_events_created_by_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.artifact_state_events
    ADD CONSTRAINT artifact_state_events_created_by_fkey FOREIGN KEY (created_by) REFERENCES app.profiles(user_id);


--
-- Name: artifact_versions artifact_versions_created_by_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.artifact_versions
    ADD CONSTRAINT artifact_versions_created_by_fkey FOREIGN KEY (created_by) REFERENCES app.profiles(user_id);


--
-- Name: artifact_versions artifact_versions_predecessor_version_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.artifact_versions
    ADD CONSTRAINT artifact_versions_predecessor_version_id_fkey FOREIGN KEY (predecessor_version_id) REFERENCES app.artifact_versions(artifact_version_id) ON DELETE SET NULL;


--
-- Name: attempt_criterion_results attempt_criterion_results_attempt_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.attempt_criterion_results
    ADD CONSTRAINT attempt_criterion_results_attempt_id_fkey FOREIGN KEY (attempt_id) REFERENCES app.attempts(id) ON DELETE CASCADE;


--
-- Name: attempt_responses attempt_responses_attempt_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.attempt_responses
    ADD CONSTRAINT attempt_responses_attempt_id_fkey FOREIGN KEY (attempt_id) REFERENCES app.attempts(id) ON DELETE CASCADE;


--
-- Name: attempts attempts_artifact_version_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.attempts
    ADD CONSTRAINT attempts_artifact_version_id_fkey FOREIGN KEY (artifact_version_id) REFERENCES app.artifact_versions(artifact_version_id) ON DELETE SET NULL;


--
-- Name: attempts attempts_content_item_version_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.attempts
    ADD CONSTRAINT attempts_content_item_version_id_fkey FOREIGN KEY (content_item_version_id) REFERENCES app.content_item_versions(id);


--
-- Name: attempts attempts_exam_pack_version_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.attempts
    ADD CONSTRAINT attempts_exam_pack_version_id_fkey FOREIGN KEY (exam_pack_version_id) REFERENCES app.exam_pack_versions(id);


--
-- Name: attempts attempts_learning_session_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.attempts
    ADD CONSTRAINT attempts_learning_session_id_fkey FOREIGN KEY (learning_session_id) REFERENCES app.learning_sessions(id) ON DELETE SET NULL;


--
-- Name: attempts attempts_user_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.attempts
    ADD CONSTRAINT attempts_user_id_fkey FOREIGN KEY (user_id) REFERENCES app.profiles(user_id) ON DELETE CASCADE;


--
-- Name: audit_events audit_events_actor_user_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.audit_events
    ADD CONSTRAINT audit_events_actor_user_id_fkey FOREIGN KEY (actor_user_id) REFERENCES app.profiles(user_id);


--
-- Name: audit_events audit_events_subject_user_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.audit_events
    ADD CONSTRAINT audit_events_subject_user_id_fkey FOREIGN KEY (subject_user_id) REFERENCES app.profiles(user_id);


--
-- Name: author_commissions author_commissions_author_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.author_commissions
    ADD CONSTRAINT author_commissions_author_id_fkey FOREIGN KEY (author_id) REFERENCES app.profiles(user_id) ON DELETE CASCADE;


--
-- Name: author_commissions author_commissions_author_qualification_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.author_commissions
    ADD CONSTRAINT author_commissions_author_qualification_id_fkey FOREIGN KEY (author_qualification_id) REFERENCES app.author_qualifications(author_qualification_id) ON DELETE RESTRICT;


--
-- Name: author_commissions author_commissions_created_by_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.author_commissions
    ADD CONSTRAINT author_commissions_created_by_fkey FOREIGN KEY (created_by) REFERENCES app.profiles(user_id);


--
-- Name: author_qualifications author_qualifications_author_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.author_qualifications
    ADD CONSTRAINT author_qualifications_author_id_fkey FOREIGN KEY (author_id) REFERENCES app.profiles(user_id) ON DELETE CASCADE;


--
-- Name: author_qualifications author_qualifications_created_by_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.author_qualifications
    ADD CONSTRAINT author_qualifications_created_by_fkey FOREIGN KEY (created_by) REFERENCES app.profiles(user_id);


--
-- Name: author_qualifications author_qualifications_granted_by_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.author_qualifications
    ADD CONSTRAINT author_qualifications_granted_by_fkey FOREIGN KEY (granted_by) REFERENCES app.profiles(user_id);


--
-- Name: authoring_briefs authoring_briefs_created_by_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.authoring_briefs
    ADD CONSTRAINT authoring_briefs_created_by_fkey FOREIGN KEY (created_by) REFERENCES app.profiles(user_id);


--
-- Name: config config_created_by_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.config
    ADD CONSTRAINT config_created_by_fkey FOREIGN KEY (created_by) REFERENCES app.profiles(user_id);


--
-- Name: config config_updated_by_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.config
    ADD CONSTRAINT config_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES app.profiles(user_id);


--
-- Name: content_ingest_batches content_ingest_batches_created_by_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.content_ingest_batches
    ADD CONSTRAINT content_ingest_batches_created_by_fkey FOREIGN KEY (created_by) REFERENCES app.profiles(user_id);


--
-- Name: content_ingest_batches content_ingest_batches_exam_pack_version_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.content_ingest_batches
    ADD CONSTRAINT content_ingest_batches_exam_pack_version_id_fkey FOREIGN KEY (exam_pack_version_id) REFERENCES app.exam_pack_versions(id) ON DELETE SET NULL;


--
-- Name: content_ingest_batches content_ingest_batches_subject_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.content_ingest_batches
    ADD CONSTRAINT content_ingest_batches_subject_id_fkey FOREIGN KEY (subject_id) REFERENCES app.subjects(id) ON DELETE RESTRICT;


--
-- Name: content_ingest_rows content_ingest_rows_batch_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.content_ingest_rows
    ADD CONSTRAINT content_ingest_rows_batch_id_fkey FOREIGN KEY (batch_id) REFERENCES app.content_ingest_batches(batch_id) ON DELETE CASCADE;


--
-- Name: content_ingest_rows content_ingest_rows_created_by_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.content_ingest_rows
    ADD CONSTRAINT content_ingest_rows_created_by_fkey FOREIGN KEY (created_by) REFERENCES app.profiles(user_id);


--
-- Name: content_ingest_rows content_ingest_rows_materialized_artifact_version_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.content_ingest_rows
    ADD CONSTRAINT content_ingest_rows_materialized_artifact_version_id_fkey FOREIGN KEY (materialized_artifact_version_id) REFERENCES app.artifact_versions(artifact_version_id) ON DELETE SET NULL;


--
-- Name: content_item_labels content_item_labels_content_item_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.content_item_labels
    ADD CONSTRAINT content_item_labels_content_item_id_fkey FOREIGN KEY (content_item_id) REFERENCES app.content_items(id) ON DELETE CASCADE;


--
-- Name: content_item_labels content_item_labels_content_label_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.content_item_labels
    ADD CONSTRAINT content_item_labels_content_label_id_fkey FOREIGN KEY (content_label_id) REFERENCES app.content_labels(id) ON DELETE CASCADE;


--
-- Name: content_item_versions content_item_versions_approved_by_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.content_item_versions
    ADD CONSTRAINT content_item_versions_approved_by_fkey FOREIGN KEY (approved_by) REFERENCES app.profiles(user_id);


--
-- Name: content_item_versions content_item_versions_content_item_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.content_item_versions
    ADD CONSTRAINT content_item_versions_content_item_id_fkey FOREIGN KEY (content_item_id) REFERENCES app.content_items(id) ON DELETE CASCADE;


--
-- Name: content_item_versions content_item_versions_created_by_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.content_item_versions
    ADD CONSTRAINT content_item_versions_created_by_fkey FOREIGN KEY (created_by) REFERENCES app.profiles(user_id);


--
-- Name: content_items content_items_created_by_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.content_items
    ADD CONSTRAINT content_items_created_by_fkey FOREIGN KEY (created_by) REFERENCES app.profiles(user_id);


--
-- Name: content_items content_items_exam_pack_version_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.content_items
    ADD CONSTRAINT content_items_exam_pack_version_id_fkey FOREIGN KEY (exam_pack_version_id) REFERENCES app.exam_pack_versions(id) ON DELETE CASCADE;


--
-- Name: content_labels content_labels_created_by_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.content_labels
    ADD CONSTRAINT content_labels_created_by_fkey FOREIGN KEY (created_by) REFERENCES app.profiles(user_id);


--
-- Name: content_labels content_labels_exam_pack_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.content_labels
    ADD CONSTRAINT content_labels_exam_pack_id_fkey FOREIGN KEY (exam_pack_id) REFERENCES app.exam_packs(id) ON DELETE CASCADE;


--
-- Name: content_review_assignment_labels content_review_assignment_labels_content_label_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.content_review_assignment_labels
    ADD CONSTRAINT content_review_assignment_labels_content_label_id_fkey FOREIGN KEY (content_label_id) REFERENCES app.content_labels(id) ON DELETE CASCADE;


--
-- Name: content_review_assignment_labels content_review_assignment_labels_created_by_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.content_review_assignment_labels
    ADD CONSTRAINT content_review_assignment_labels_created_by_fkey FOREIGN KEY (created_by) REFERENCES app.profiles(user_id);


--
-- Name: content_review_assignments content_review_assignments_content_item_version_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.content_review_assignments
    ADD CONSTRAINT content_review_assignments_content_item_version_id_fkey FOREIGN KEY (content_item_version_id) REFERENCES app.content_item_versions(id) ON DELETE CASCADE;


--
-- Name: content_review_assignments content_review_assignments_created_by_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.content_review_assignments
    ADD CONSTRAINT content_review_assignments_created_by_fkey FOREIGN KEY (created_by) REFERENCES app.profiles(user_id);


--
-- Name: content_review_assignments content_review_assignments_ingest_row_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.content_review_assignments
    ADD CONSTRAINT content_review_assignments_ingest_row_id_fkey FOREIGN KEY (ingest_row_id) REFERENCES app.content_ingest_rows(ingest_row_id) ON DELETE SET NULL;


--
-- Name: content_review_assignments content_review_assignments_reviewer_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.content_review_assignments
    ADD CONSTRAINT content_review_assignments_reviewer_id_fkey FOREIGN KEY (reviewer_id) REFERENCES app.profiles(user_id) ON DELETE CASCADE;


--
-- Name: content_review_decisions content_review_decisions_assignment_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.content_review_decisions
    ADD CONSTRAINT content_review_decisions_assignment_id_fkey FOREIGN KEY (content_review_assignment_id) REFERENCES app.content_review_assignments(content_review_assignment_id) ON DELETE CASCADE;


--
-- Name: content_review_decisions content_review_decisions_content_item_version_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.content_review_decisions
    ADD CONSTRAINT content_review_decisions_content_item_version_id_fkey FOREIGN KEY (content_item_version_id) REFERENCES app.content_item_versions(id) ON DELETE CASCADE;


--
-- Name: content_review_decisions content_review_decisions_created_by_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.content_review_decisions
    ADD CONSTRAINT content_review_decisions_created_by_fkey FOREIGN KEY (created_by) REFERENCES app.profiles(user_id);


--
-- Name: content_review_decisions content_review_decisions_reviewer_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.content_review_decisions
    ADD CONSTRAINT content_review_decisions_reviewer_id_fkey FOREIGN KEY (reviewer_id) REFERENCES app.profiles(user_id) ON DELETE CASCADE;


--
-- Name: content_review_decisions content_review_decisions_supersedes_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.content_review_decisions
    ADD CONSTRAINT content_review_decisions_supersedes_id_fkey FOREIGN KEY (supersedes_id) REFERENCES app.content_review_decisions(content_review_decision_id) ON DELETE SET NULL;


--
-- Name: content_rights_releases content_rights_releases_author_or_seller_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.content_rights_releases
    ADD CONSTRAINT content_rights_releases_author_or_seller_id_fkey FOREIGN KEY (author_or_seller_id) REFERENCES app.profiles(user_id);


--
-- Name: content_rights_releases content_rights_releases_commission_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.content_rights_releases
    ADD CONSTRAINT content_rights_releases_commission_id_fkey FOREIGN KEY (commission_id) REFERENCES app.author_commissions(commission_id) ON DELETE SET NULL;


--
-- Name: content_rights_releases content_rights_releases_created_by_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.content_rights_releases
    ADD CONSTRAINT content_rights_releases_created_by_fkey FOREIGN KEY (created_by) REFERENCES app.profiles(user_id);


--
-- Name: content_rights_releases content_rights_releases_signed_by_cramapple_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.content_rights_releases
    ADD CONSTRAINT content_rights_releases_signed_by_cramapple_fkey FOREIGN KEY (signed_by_cramapple) REFERENCES app.profiles(user_id);


--
-- Name: content_rights_releases content_rights_releases_signed_by_creator_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.content_rights_releases
    ADD CONSTRAINT content_rights_releases_signed_by_creator_fkey FOREIGN KEY (signed_by_creator) REFERENCES app.profiles(user_id);


--
-- Name: exam_pack_manifests exam_pack_manifests_created_by_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.exam_pack_manifests
    ADD CONSTRAINT exam_pack_manifests_created_by_fkey FOREIGN KEY (created_by) REFERENCES app.profiles(user_id);


--
-- Name: exam_pack_versions exam_pack_versions_created_by_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.exam_pack_versions
    ADD CONSTRAINT exam_pack_versions_created_by_fkey FOREIGN KEY (created_by) REFERENCES app.profiles(user_id);


--
-- Name: exam_pack_versions exam_pack_versions_exam_pack_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.exam_pack_versions
    ADD CONSTRAINT exam_pack_versions_exam_pack_id_fkey FOREIGN KEY (exam_pack_id) REFERENCES app.exam_packs(id) ON DELETE CASCADE;


--
-- Name: exam_packs exam_packs_subject_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.exam_packs
    ADD CONSTRAINT exam_packs_subject_id_fkey FOREIGN KEY (subject_id) REFERENCES app.subjects(id) ON DELETE RESTRICT;


--
-- Name: frq_criteria frq_criteria_content_item_version_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.frq_criteria
    ADD CONSTRAINT frq_criteria_content_item_version_id_fkey FOREIGN KEY (content_item_version_id) REFERENCES app.content_item_versions(id) ON DELETE CASCADE;


--
-- Name: frq_synthetic_responses frq_synthetic_responses_content_item_version_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.frq_synthetic_responses
    ADD CONSTRAINT frq_synthetic_responses_content_item_version_id_fkey FOREIGN KEY (content_item_version_id) REFERENCES app.content_item_versions(id) ON DELETE CASCADE;


--
-- Name: grading_results grading_results_attempt_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.grading_results
    ADD CONSTRAINT grading_results_attempt_id_fkey FOREIGN KEY (attempt_id) REFERENCES app.attempts(id) ON DELETE CASCADE;


--
-- Name: grading_results grading_results_response_version_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.grading_results
    ADD CONSTRAINT grading_results_response_version_id_fkey FOREIGN KEY (response_version_id) REFERENCES app.response_versions(id) ON DELETE CASCADE;


--
-- Name: learning_sessions learning_sessions_exam_pack_version_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.learning_sessions
    ADD CONSTRAINT learning_sessions_exam_pack_version_id_fkey FOREIGN KEY (exam_pack_version_id) REFERENCES app.exam_pack_versions(id);


--
-- Name: learning_sessions learning_sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.learning_sessions
    ADD CONSTRAINT learning_sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES app.profiles(user_id) ON DELETE CASCADE;


--
-- Name: mcq_choices mcq_choices_content_item_version_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.mcq_choices
    ADD CONSTRAINT mcq_choices_content_item_version_id_fkey FOREIGN KEY (content_item_version_id) REFERENCES app.content_item_versions(id) ON DELETE CASCADE;


--
-- Name: originality_attestations originality_attestations_commission_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.originality_attestations
    ADD CONSTRAINT originality_attestations_commission_id_fkey FOREIGN KEY (commission_id) REFERENCES app.author_commissions(commission_id) ON DELETE CASCADE;


--
-- Name: originality_attestations originality_attestations_created_by_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.originality_attestations
    ADD CONSTRAINT originality_attestations_created_by_fkey FOREIGN KEY (created_by) REFERENCES app.profiles(user_id);


--
-- Name: originality_attestations originality_attestations_signed_by_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.originality_attestations
    ADD CONSTRAINT originality_attestations_signed_by_fkey FOREIGN KEY (signed_by) REFERENCES app.profiles(user_id);


--
-- Name: profiles profiles_active_exam_pack_version_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.profiles
    ADD CONSTRAINT profiles_active_exam_pack_version_id_fkey FOREIGN KEY (active_exam_pack_version_id) REFERENCES app.exam_pack_versions(id) ON DELETE SET NULL;


--
-- Name: profiles profiles_user_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.profiles
    ADD CONSTRAINT profiles_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: progress_snapshots progress_snapshots_exam_pack_version_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.progress_snapshots
    ADD CONSTRAINT progress_snapshots_exam_pack_version_id_fkey FOREIGN KEY (exam_pack_version_id) REFERENCES app.exam_pack_versions(id);


--
-- Name: progress_snapshots progress_snapshots_user_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.progress_snapshots
    ADD CONSTRAINT progress_snapshots_user_id_fkey FOREIGN KEY (user_id) REFERENCES app.profiles(user_id) ON DELETE CASCADE;


--
-- Name: provenance_claims provenance_claims_artifact_version_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.provenance_claims
    ADD CONSTRAINT provenance_claims_artifact_version_id_fkey FOREIGN KEY (artifact_version_id) REFERENCES app.artifact_versions(artifact_version_id) ON DELETE CASCADE;


--
-- Name: provenance_claims provenance_claims_created_by_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.provenance_claims
    ADD CONSTRAINT provenance_claims_created_by_fkey FOREIGN KEY (created_by) REFERENCES app.profiles(user_id);


--
-- Name: provenance_claims provenance_claims_verified_by_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.provenance_claims
    ADD CONSTRAINT provenance_claims_verified_by_fkey FOREIGN KEY (verified_by) REFERENCES app.profiles(user_id);


--
-- Name: publication_events publication_events_created_by_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.publication_events
    ADD CONSTRAINT publication_events_created_by_fkey FOREIGN KEY (created_by) REFERENCES app.profiles(user_id);


--
-- Name: publication_events publication_events_executed_by_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.publication_events
    ADD CONSTRAINT publication_events_executed_by_fkey FOREIGN KEY (executed_by) REFERENCES app.profiles(user_id);


--
-- Name: publication_events publication_events_manifest_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.publication_events
    ADD CONSTRAINT publication_events_manifest_id_fkey FOREIGN KEY (manifest_id) REFERENCES app.exam_pack_manifests(manifest_id) ON DELETE CASCADE;


--
-- Name: publication_events publication_events_prior_manifest_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.publication_events
    ADD CONSTRAINT publication_events_prior_manifest_id_fkey FOREIGN KEY (prior_manifest_id) REFERENCES app.exam_pack_manifests(manifest_id) ON DELETE SET NULL;


--
-- Name: publication_events publication_events_release_candidate_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.publication_events
    ADD CONSTRAINT publication_events_release_candidate_id_fkey FOREIGN KEY (release_candidate_id) REFERENCES app.release_candidates(release_candidate_id) ON DELETE CASCADE;


--
-- Name: quality_incidents quality_incidents_created_by_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.quality_incidents
    ADD CONSTRAINT quality_incidents_created_by_fkey FOREIGN KEY (created_by) REFERENCES app.profiles(user_id);


--
-- Name: quality_incidents quality_incidents_detected_by_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.quality_incidents
    ADD CONSTRAINT quality_incidents_detected_by_fkey FOREIGN KEY (detected_by) REFERENCES app.profiles(user_id);


--
-- Name: quality_incidents quality_incidents_incident_commander_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.quality_incidents
    ADD CONSTRAINT quality_incidents_incident_commander_id_fkey FOREIGN KEY (incident_commander_id) REFERENCES app.profiles(user_id);


--
-- Name: question_coverage_targets question_coverage_targets_created_by_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.question_coverage_targets
    ADD CONSTRAINT question_coverage_targets_created_by_fkey FOREIGN KEY (created_by) REFERENCES app.profiles(user_id);


--
-- Name: question_coverage_targets question_coverage_targets_subject_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.question_coverage_targets
    ADD CONSTRAINT question_coverage_targets_subject_id_fkey FOREIGN KEY (subject_id) REFERENCES app.subjects(id) ON DELETE RESTRICT;


--
-- Name: question_use_assignments question_use_assignments_artifact_version_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.question_use_assignments
    ADD CONSTRAINT question_use_assignments_artifact_version_id_fkey FOREIGN KEY (artifact_version_id) REFERENCES app.artifact_versions(artifact_version_id) ON DELETE CASCADE;


--
-- Name: question_use_assignments question_use_assignments_created_by_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.question_use_assignments
    ADD CONSTRAINT question_use_assignments_created_by_fkey FOREIGN KEY (created_by) REFERENCES app.profiles(user_id);


--
-- Name: question_use_assignments question_use_assignments_replaced_by_artifact_version_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.question_use_assignments
    ADD CONSTRAINT question_use_assignments_replaced_by_artifact_version_id_fkey FOREIGN KEY (replaced_by_artifact_version_id) REFERENCES app.artifact_versions(artifact_version_id) ON DELETE SET NULL;


--
-- Name: release_candidates release_candidates_created_by_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.release_candidates
    ADD CONSTRAINT release_candidates_created_by_fkey FOREIGN KEY (created_by) REFERENCES app.profiles(user_id);


--
-- Name: response_versions response_versions_attempt_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.response_versions
    ADD CONSTRAINT response_versions_attempt_id_fkey FOREIGN KEY (attempt_id) REFERENCES app.attempts(id) ON DELETE CASCADE;


--
-- Name: response_versions response_versions_created_by_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.response_versions
    ADD CONSTRAINT response_versions_created_by_fkey FOREIGN KEY (created_by) REFERENCES app.profiles(user_id);


--
-- Name: response_versions response_versions_parent_response_version_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.response_versions
    ADD CONSTRAINT response_versions_parent_response_version_id_fkey FOREIGN KEY (parent_response_version_id) REFERENCES app.response_versions(id) ON DELETE SET NULL;


--
-- Name: revalidation_cases revalidation_cases_created_by_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.revalidation_cases
    ADD CONSTRAINT revalidation_cases_created_by_fkey FOREIGN KEY (created_by) REFERENCES app.profiles(user_id);


--
-- Name: revalidation_cases revalidation_cases_disposition_manifest_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.revalidation_cases
    ADD CONSTRAINT revalidation_cases_disposition_manifest_id_fkey FOREIGN KEY (disposition_manifest_id) REFERENCES app.exam_pack_manifests(manifest_id) ON DELETE SET NULL;


--
-- Name: review_assignments review_assignments_artifact_version_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.review_assignments
    ADD CONSTRAINT review_assignments_artifact_version_id_fkey FOREIGN KEY (artifact_version_id) REFERENCES app.artifact_versions(artifact_version_id) ON DELETE CASCADE;


--
-- Name: review_assignments review_assignments_assigned_reviewer_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.review_assignments
    ADD CONSTRAINT review_assignments_assigned_reviewer_id_fkey FOREIGN KEY (assigned_reviewer_id) REFERENCES app.profiles(user_id);


--
-- Name: review_assignments review_assignments_created_by_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.review_assignments
    ADD CONSTRAINT review_assignments_created_by_fkey FOREIGN KEY (created_by) REFERENCES app.profiles(user_id);


--
-- Name: review_assignments review_assignments_required_qualification_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.review_assignments
    ADD CONSTRAINT review_assignments_required_qualification_id_fkey FOREIGN KEY (required_qualification_id) REFERENCES app.validator_qualifications(qualification_id) ON DELETE RESTRICT;


--
-- Name: review_decisions review_decisions_artifact_version_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.review_decisions
    ADD CONSTRAINT review_decisions_artifact_version_id_fkey FOREIGN KEY (artifact_version_id) REFERENCES app.artifact_versions(artifact_version_id) ON DELETE CASCADE;


--
-- Name: review_decisions review_decisions_assignment_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.review_decisions
    ADD CONSTRAINT review_decisions_assignment_id_fkey FOREIGN KEY (assignment_id) REFERENCES app.review_assignments(assignment_id) ON DELETE CASCADE;


--
-- Name: review_decisions review_decisions_created_by_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.review_decisions
    ADD CONSTRAINT review_decisions_created_by_fkey FOREIGN KEY (created_by) REFERENCES app.profiles(user_id);


--
-- Name: review_decisions review_decisions_supersedes_review_decision_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.review_decisions
    ADD CONSTRAINT review_decisions_supersedes_review_decision_id_fkey FOREIGN KEY (supersedes_review_decision_id) REFERENCES app.review_decisions(review_decision_id) ON DELETE SET NULL;


--
-- Name: rights_records rights_records_created_by_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.rights_records
    ADD CONSTRAINT rights_records_created_by_fkey FOREIGN KEY (created_by) REFERENCES app.profiles(user_id);


--
-- Name: rights_records rights_records_reviewed_by_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.rights_records
    ADD CONSTRAINT rights_records_reviewed_by_fkey FOREIGN KEY (reviewed_by) REFERENCES app.profiles(user_id);


--
-- Name: rights_records rights_records_source_version_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.rights_records
    ADD CONSTRAINT rights_records_source_version_id_fkey FOREIGN KEY (source_version_id) REFERENCES app.source_records(source_version_id) ON DELETE CASCADE;


--
-- Name: source_records source_records_created_by_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.source_records
    ADD CONSTRAINT source_records_created_by_fkey FOREIGN KEY (created_by) REFERENCES app.profiles(user_id);


--
-- Name: source_records source_records_supersedes_source_version_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.source_records
    ADD CONSTRAINT source_records_supersedes_source_version_id_fkey FOREIGN KEY (supersedes_source_version_id) REFERENCES app.source_records(source_version_id) ON DELETE SET NULL;


--
-- Name: student_memory_events student_memory_events_source_attempt_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.student_memory_events
    ADD CONSTRAINT student_memory_events_source_attempt_id_fkey FOREIGN KEY (source_attempt_id) REFERENCES app.attempts(id) ON DELETE SET NULL;


--
-- Name: student_memory_events student_memory_events_source_session_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.student_memory_events
    ADD CONSTRAINT student_memory_events_source_session_id_fkey FOREIGN KEY (source_session_id) REFERENCES app.learning_sessions(id) ON DELETE SET NULL;


--
-- Name: student_memory_events student_memory_events_subject_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.student_memory_events
    ADD CONSTRAINT student_memory_events_subject_id_fkey FOREIGN KEY (subject_id) REFERENCES app.subjects(id) ON DELETE CASCADE;


--
-- Name: student_memory_events student_memory_events_user_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.student_memory_events
    ADD CONSTRAINT student_memory_events_user_id_fkey FOREIGN KEY (user_id) REFERENCES app.profiles(user_id) ON DELETE CASCADE;


--
-- Name: student_memory_snapshots student_memory_snapshots_last_event_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.student_memory_snapshots
    ADD CONSTRAINT student_memory_snapshots_last_event_id_fkey FOREIGN KEY (last_event_id) REFERENCES app.student_memory_events(id) ON DELETE SET NULL;


--
-- Name: student_memory_snapshots student_memory_snapshots_subject_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.student_memory_snapshots
    ADD CONSTRAINT student_memory_snapshots_subject_id_fkey FOREIGN KEY (subject_id) REFERENCES app.subjects(id) ON DELETE CASCADE;


--
-- Name: student_memory_snapshots student_memory_snapshots_user_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.student_memory_snapshots
    ADD CONSTRAINT student_memory_snapshots_user_id_fkey FOREIGN KEY (user_id) REFERENCES app.profiles(user_id) ON DELETE CASCADE;


--
-- Name: subject_guidance_profiles subject_guidance_profiles_created_by_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.subject_guidance_profiles
    ADD CONSTRAINT subject_guidance_profiles_created_by_fkey FOREIGN KEY (created_by) REFERENCES app.profiles(user_id);


--
-- Name: subject_guidance_profiles subject_guidance_profiles_subject_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.subject_guidance_profiles
    ADD CONSTRAINT subject_guidance_profiles_subject_id_fkey FOREIGN KEY (subject_id) REFERENCES app.subjects(id) ON DELETE CASCADE;


--
-- Name: validation_cases validation_cases_created_by_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.validation_cases
    ADD CONSTRAINT validation_cases_created_by_fkey FOREIGN KEY (created_by) REFERENCES app.profiles(user_id);


--
-- Name: validation_results validation_results_case_version_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.validation_results
    ADD CONSTRAINT validation_results_case_version_id_fkey FOREIGN KEY (case_version_id) REFERENCES app.validation_cases(case_version_id) ON DELETE CASCADE;


--
-- Name: validation_results validation_results_created_by_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.validation_results
    ADD CONSTRAINT validation_results_created_by_fkey FOREIGN KEY (created_by) REFERENCES app.profiles(user_id);


--
-- Name: validation_results validation_results_run_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.validation_results
    ADD CONSTRAINT validation_results_run_id_fkey FOREIGN KEY (run_id) REFERENCES app.validation_runs(run_id) ON DELETE CASCADE;


--
-- Name: validation_runs validation_runs_created_by_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.validation_runs
    ADD CONSTRAINT validation_runs_created_by_fkey FOREIGN KEY (created_by) REFERENCES app.profiles(user_id);


--
-- Name: validation_runs validation_runs_prompt_version_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.validation_runs
    ADD CONSTRAINT validation_runs_prompt_version_id_fkey FOREIGN KEY (prompt_version_id) REFERENCES app.prompt_versions(id) ON DELETE SET NULL;


--
-- Name: validation_runs validation_runs_suite_version_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.validation_runs
    ADD CONSTRAINT validation_runs_suite_version_id_fkey FOREIGN KEY (suite_version_id) REFERENCES app.validation_suites(suite_version_id) ON DELETE CASCADE;


--
-- Name: validation_suites validation_suites_created_by_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.validation_suites
    ADD CONSTRAINT validation_suites_created_by_fkey FOREIGN KEY (created_by) REFERENCES app.profiles(user_id);


--
-- Name: validator_entitlements validator_entitlements_created_by_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.validator_entitlements
    ADD CONSTRAINT validator_entitlements_created_by_fkey FOREIGN KEY (created_by) REFERENCES app.profiles(user_id);


--
-- Name: validator_entitlements validator_entitlements_granted_by_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.validator_entitlements
    ADD CONSTRAINT validator_entitlements_granted_by_fkey FOREIGN KEY (granted_by) REFERENCES app.profiles(user_id);


--
-- Name: validator_entitlements validator_entitlements_qualification_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.validator_entitlements
    ADD CONSTRAINT validator_entitlements_qualification_id_fkey FOREIGN KEY (qualification_id) REFERENCES app.validator_qualifications(qualification_id) ON DELETE CASCADE;


--
-- Name: validator_entitlements validator_entitlements_reviewer_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.validator_entitlements
    ADD CONSTRAINT validator_entitlements_reviewer_id_fkey FOREIGN KEY (reviewer_id) REFERENCES app.profiles(user_id) ON DELETE CASCADE;


--
-- Name: validator_qualifications validator_qualifications_created_by_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.validator_qualifications
    ADD CONSTRAINT validator_qualifications_created_by_fkey FOREIGN KEY (created_by) REFERENCES app.profiles(user_id);


--
-- Name: validator_qualifications validator_qualifications_granted_by_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.validator_qualifications
    ADD CONSTRAINT validator_qualifications_granted_by_fkey FOREIGN KEY (granted_by) REFERENCES app.profiles(user_id);


--
-- Name: validator_qualifications validator_qualifications_reviewer_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: -
--

ALTER TABLE ONLY app.validator_qualifications
    ADD CONSTRAINT validator_qualifications_reviewer_id_fkey FOREIGN KEY (reviewer_id) REFERENCES app.profiles(user_id) ON DELETE CASCADE;


--
-- Name: sessions sessions_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_student_id_fkey FOREIGN KEY (student_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: student_attempts student_attempts_question_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.student_attempts
    ADD CONSTRAINT student_attempts_question_id_fkey FOREIGN KEY (question_id) REFERENCES public.questions(id) ON DELETE RESTRICT;


--
-- Name: student_attempts student_attempts_session_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.student_attempts
    ADD CONSTRAINT student_attempts_session_id_fkey FOREIGN KEY (session_id) REFERENCES public.sessions(id) ON DELETE SET NULL;


--
-- Name: student_attempts student_attempts_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.student_attempts
    ADD CONSTRAINT student_attempts_student_id_fkey FOREIGN KEY (student_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: student_lock_queue student_lock_queue_last_attempt_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.student_lock_queue
    ADD CONSTRAINT student_lock_queue_last_attempt_id_fkey FOREIGN KEY (last_attempt_id) REFERENCES public.student_attempts(id) ON DELETE SET NULL;


--
-- Name: student_lock_queue student_lock_queue_question_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.student_lock_queue
    ADD CONSTRAINT student_lock_queue_question_id_fkey FOREIGN KEY (question_id) REFERENCES public.questions(id) ON DELETE RESTRICT;


--
-- Name: student_lock_queue student_lock_queue_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.student_lock_queue
    ADD CONSTRAINT student_lock_queue_student_id_fkey FOREIGN KEY (student_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: ai_variant_runs; Type: ROW SECURITY; Schema: app; Owner: -
--

ALTER TABLE app.ai_variant_runs ENABLE ROW LEVEL SECURITY;

--
-- Name: artifact_dependencies; Type: ROW SECURITY; Schema: app; Owner: -
--

ALTER TABLE app.artifact_dependencies ENABLE ROW LEVEL SECURITY;

--
-- Name: artifact_label_assignments; Type: ROW SECURITY; Schema: app; Owner: -
--

ALTER TABLE app.artifact_label_assignments ENABLE ROW LEVEL SECURITY;

--
-- Name: artifact_label_assignments artifact_label_assignments_staff_delete; Type: POLICY; Schema: app; Owner: -
--

CREATE POLICY artifact_label_assignments_staff_delete ON app.artifact_label_assignments FOR DELETE TO authenticated USING ((EXISTS ( SELECT 1
   FROM app.profiles p
  WHERE ((p.user_id = ( SELECT auth.uid() AS uid)) AND (p.role = ANY (ARRAY['admin'::text, 'content_author'::text]))))));


--
-- Name: artifact_label_assignments artifact_label_assignments_staff_insert; Type: POLICY; Schema: app; Owner: -
--

CREATE POLICY artifact_label_assignments_staff_insert ON app.artifact_label_assignments FOR INSERT TO authenticated WITH CHECK ((EXISTS ( SELECT 1
   FROM app.profiles p
  WHERE ((p.user_id = ( SELECT auth.uid() AS uid)) AND (p.role = ANY (ARRAY['admin'::text, 'content_author'::text]))))));


--
-- Name: artifact_label_assignments artifact_label_assignments_staff_select; Type: POLICY; Schema: app; Owner: -
--

CREATE POLICY artifact_label_assignments_staff_select ON app.artifact_label_assignments FOR SELECT TO authenticated USING ((EXISTS ( SELECT 1
   FROM app.profiles p
  WHERE ((p.user_id = ( SELECT auth.uid() AS uid)) AND (p.role = ANY (ARRAY['admin'::text, 'content_author'::text]))))));


--
-- Name: artifact_label_assignments artifact_label_assignments_staff_update; Type: POLICY; Schema: app; Owner: -
--

CREATE POLICY artifact_label_assignments_staff_update ON app.artifact_label_assignments FOR UPDATE TO authenticated USING ((EXISTS ( SELECT 1
   FROM app.profiles p
  WHERE ((p.user_id = ( SELECT auth.uid() AS uid)) AND (p.role = ANY (ARRAY['admin'::text, 'content_author'::text])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM app.profiles p
  WHERE ((p.user_id = ( SELECT auth.uid() AS uid)) AND (p.role = ANY (ARRAY['admin'::text, 'content_author'::text]))))));


--
-- Name: artifact_state_events; Type: ROW SECURITY; Schema: app; Owner: -
--

ALTER TABLE app.artifact_state_events ENABLE ROW LEVEL SECURITY;

--
-- Name: artifact_versions; Type: ROW SECURITY; Schema: app; Owner: -
--

ALTER TABLE app.artifact_versions ENABLE ROW LEVEL SECURITY;

--
-- Name: attempt_criterion_results; Type: ROW SECURITY; Schema: app; Owner: -
--

ALTER TABLE app.attempt_criterion_results ENABLE ROW LEVEL SECURITY;

--
-- Name: attempt_responses; Type: ROW SECURITY; Schema: app; Owner: -
--

ALTER TABLE app.attempt_responses ENABLE ROW LEVEL SECURITY;

--
-- Name: attempt_responses attempt_responses_owner_select; Type: POLICY; Schema: app; Owner: -
--

CREATE POLICY attempt_responses_owner_select ON app.attempt_responses FOR SELECT TO authenticated USING ((EXISTS ( SELECT 1
   FROM app.attempts a
  WHERE ((a.id = attempt_responses.attempt_id) AND (a.user_id = auth.uid())))));


--
-- Name: attempt_responses attempt_responses_owner_update_draft; Type: POLICY; Schema: app; Owner: -
--

CREATE POLICY attempt_responses_owner_update_draft ON app.attempt_responses FOR UPDATE TO authenticated USING ((EXISTS ( SELECT 1
   FROM app.attempts a
  WHERE ((a.id = attempt_responses.attempt_id) AND (a.user_id = auth.uid()) AND (a.status = ANY (ARRAY['draft'::text, 'failed'::text])))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM app.attempts a
  WHERE ((a.id = attempt_responses.attempt_id) AND (a.user_id = auth.uid()) AND (a.status = ANY (ARRAY['draft'::text, 'failed'::text]))))));


--
-- Name: attempt_responses attempt_responses_owner_write_draft; Type: POLICY; Schema: app; Owner: -
--

CREATE POLICY attempt_responses_owner_write_draft ON app.attempt_responses FOR INSERT TO authenticated WITH CHECK ((EXISTS ( SELECT 1
   FROM app.attempts a
  WHERE ((a.id = attempt_responses.attempt_id) AND (a.user_id = auth.uid()) AND (a.status = ANY (ARRAY['draft'::text, 'failed'::text]))))));


--
-- Name: attempts; Type: ROW SECURITY; Schema: app; Owner: -
--

ALTER TABLE app.attempts ENABLE ROW LEVEL SECURITY;

--
-- Name: attempts attempts_owner_insert; Type: POLICY; Schema: app; Owner: -
--

CREATE POLICY attempts_owner_insert ON app.attempts FOR INSERT TO authenticated WITH CHECK ((auth.uid() = user_id));


--
-- Name: attempts attempts_owner_select; Type: POLICY; Schema: app; Owner: -
--

CREATE POLICY attempts_owner_select ON app.attempts FOR SELECT TO authenticated USING ((auth.uid() = user_id));


--
-- Name: attempts attempts_owner_update_draft; Type: POLICY; Schema: app; Owner: -
--

CREATE POLICY attempts_owner_update_draft ON app.attempts FOR UPDATE TO authenticated USING (((auth.uid() = user_id) AND (status = ANY (ARRAY['draft'::text, 'failed'::text])))) WITH CHECK ((auth.uid() = user_id));


--
-- Name: audit_events; Type: ROW SECURITY; Schema: app; Owner: -
--

ALTER TABLE app.audit_events ENABLE ROW LEVEL SECURITY;

--
-- Name: audit_events audit_events_service_only; Type: POLICY; Schema: app; Owner: -
--

CREATE POLICY audit_events_service_only ON app.audit_events FOR SELECT TO service_role USING (true);


--
-- Name: author_commissions; Type: ROW SECURITY; Schema: app; Owner: -
--

ALTER TABLE app.author_commissions ENABLE ROW LEVEL SECURITY;

--
-- Name: author_qualifications; Type: ROW SECURITY; Schema: app; Owner: -
--

ALTER TABLE app.author_qualifications ENABLE ROW LEVEL SECURITY;

--
-- Name: authoring_briefs; Type: ROW SECURITY; Schema: app; Owner: -
--

ALTER TABLE app.authoring_briefs ENABLE ROW LEVEL SECURITY;

--
-- Name: content_items ci_select_assigned_reviewer; Type: POLICY; Schema: app; Owner: -
--

CREATE POLICY ci_select_assigned_reviewer ON app.content_items FOR SELECT TO authenticated USING ((EXISTS ( SELECT 1
   FROM (app.content_item_versions civ
     JOIN app.content_review_assignments cra ON ((cra.content_item_version_id = civ.id)))
  WHERE ((civ.content_item_id = content_items.id) AND (cra.reviewer_id = auth.uid()) AND (cra.status = ANY (ARRAY['pending'::text, 'in_progress'::text, 'submitted'::text]))))));


--
-- Name: content_item_versions civ_select_assigned_reviewer; Type: POLICY; Schema: app; Owner: -
--

CREATE POLICY civ_select_assigned_reviewer ON app.content_item_versions FOR SELECT TO authenticated USING ((EXISTS ( SELECT 1
   FROM app.content_review_assignments cra
  WHERE ((cra.content_item_version_id = content_item_versions.id) AND (cra.reviewer_id = auth.uid()) AND (cra.status = ANY (ARRAY['pending'::text, 'in_progress'::text, 'submitted'::text]))))));


--
-- Name: config; Type: ROW SECURITY; Schema: app; Owner: -
--

ALTER TABLE app.config ENABLE ROW LEVEL SECURITY;

--
-- Name: config config_select_public; Type: POLICY; Schema: app; Owner: -
--

CREATE POLICY config_select_public ON app.config FOR SELECT TO authenticated USING (is_public);


--
-- Name: config config_service_all; Type: POLICY; Schema: app; Owner: -
--

CREATE POLICY config_service_all ON app.config TO service_role USING (true) WITH CHECK (true);


--
-- Name: content_ingest_batches; Type: ROW SECURITY; Schema: app; Owner: -
--

ALTER TABLE app.content_ingest_batches ENABLE ROW LEVEL SECURITY;

--
-- Name: content_ingest_batches content_ingest_batches_owner_select; Type: POLICY; Schema: app; Owner: -
--

CREATE POLICY content_ingest_batches_owner_select ON app.content_ingest_batches FOR SELECT TO authenticated USING ((created_by = auth.uid()));


--
-- Name: content_ingest_batches content_ingest_batches_owner_update; Type: POLICY; Schema: app; Owner: -
--

CREATE POLICY content_ingest_batches_owner_update ON app.content_ingest_batches FOR UPDATE TO authenticated USING ((created_by = auth.uid())) WITH CHECK ((created_by = auth.uid()));


--
-- Name: content_ingest_batches content_ingest_batches_owner_write; Type: POLICY; Schema: app; Owner: -
--

CREATE POLICY content_ingest_batches_owner_write ON app.content_ingest_batches FOR INSERT TO authenticated WITH CHECK ((created_by = auth.uid()));


--
-- Name: content_ingest_rows; Type: ROW SECURITY; Schema: app; Owner: -
--

ALTER TABLE app.content_ingest_rows ENABLE ROW LEVEL SECURITY;

--
-- Name: content_ingest_rows content_ingest_rows_owner_select; Type: POLICY; Schema: app; Owner: -
--

CREATE POLICY content_ingest_rows_owner_select ON app.content_ingest_rows FOR SELECT TO authenticated USING (((created_by = auth.uid()) OR (EXISTS ( SELECT 1
   FROM app.content_ingest_batches b
  WHERE ((b.batch_id = content_ingest_rows.batch_id) AND (b.created_by = auth.uid()))))));


--
-- Name: content_ingest_rows content_ingest_rows_owner_update; Type: POLICY; Schema: app; Owner: -
--

CREATE POLICY content_ingest_rows_owner_update ON app.content_ingest_rows FOR UPDATE TO authenticated USING (((created_by = auth.uid()) OR (EXISTS ( SELECT 1
   FROM app.content_ingest_batches b
  WHERE ((b.batch_id = content_ingest_rows.batch_id) AND (b.created_by = auth.uid())))))) WITH CHECK (((created_by = auth.uid()) OR (EXISTS ( SELECT 1
   FROM app.content_ingest_batches b
  WHERE ((b.batch_id = content_ingest_rows.batch_id) AND (b.created_by = auth.uid()))))));


--
-- Name: content_ingest_rows content_ingest_rows_owner_write; Type: POLICY; Schema: app; Owner: -
--

CREATE POLICY content_ingest_rows_owner_write ON app.content_ingest_rows FOR INSERT TO authenticated WITH CHECK ((created_by = auth.uid()));


--
-- Name: content_item_labels; Type: ROW SECURITY; Schema: app; Owner: -
--

ALTER TABLE app.content_item_labels ENABLE ROW LEVEL SECURITY;

--
-- Name: content_item_labels content_item_labels_select_published; Type: POLICY; Schema: app; Owner: -
--

CREATE POLICY content_item_labels_select_published ON app.content_item_labels FOR SELECT TO authenticated USING ((EXISTS ( SELECT 1
   FROM (app.content_items ci
     JOIN app.exam_pack_versions epv ON ((epv.id = ci.exam_pack_version_id)))
  WHERE ((ci.id = content_item_labels.content_item_id) AND (ci.status = 'published'::text) AND (epv.status = 'published'::text)))));


--
-- Name: content_item_versions; Type: ROW SECURITY; Schema: app; Owner: -
--

ALTER TABLE app.content_item_versions ENABLE ROW LEVEL SECURITY;

--
-- Name: content_item_versions content_item_versions_admin_select; Type: POLICY; Schema: app; Owner: -
--

CREATE POLICY content_item_versions_admin_select ON app.content_item_versions FOR SELECT TO authenticated USING ((EXISTS ( SELECT 1
   FROM app.profiles p
  WHERE ((p.user_id = auth.uid()) AND (p.role = 'admin'::text)))));


--
-- Name: content_item_versions content_item_versions_select_published; Type: POLICY; Schema: app; Owner: -
--

CREATE POLICY content_item_versions_select_published ON app.content_item_versions FOR SELECT TO authenticated USING (((status = 'published'::text) AND app.content_item_is_published(content_item_id)));


--
-- Name: content_items; Type: ROW SECURITY; Schema: app; Owner: -
--

ALTER TABLE app.content_items ENABLE ROW LEVEL SECURITY;

--
-- Name: content_items content_items_admin_select; Type: POLICY; Schema: app; Owner: -
--

CREATE POLICY content_items_admin_select ON app.content_items FOR SELECT TO authenticated USING ((EXISTS ( SELECT 1
   FROM app.profiles p
  WHERE ((p.user_id = auth.uid()) AND (p.role = 'admin'::text)))));


--
-- Name: content_items content_items_select_published; Type: POLICY; Schema: app; Owner: -
--

CREATE POLICY content_items_select_published ON app.content_items FOR SELECT TO authenticated USING (((status = 'published'::text) AND (EXISTS ( SELECT 1
   FROM app.exam_pack_versions epv
  WHERE ((epv.id = content_items.exam_pack_version_id) AND (epv.status = 'published'::text))))));


--
-- Name: content_labels; Type: ROW SECURITY; Schema: app; Owner: -
--

ALTER TABLE app.content_labels ENABLE ROW LEVEL SECURITY;

--
-- Name: content_labels content_labels_select_published; Type: POLICY; Schema: app; Owner: -
--

CREATE POLICY content_labels_select_published ON app.content_labels FOR SELECT TO authenticated USING ((status = 'published'::text));


--
-- Name: content_review_assignment_labels; Type: ROW SECURITY; Schema: app; Owner: -
--

ALTER TABLE app.content_review_assignment_labels ENABLE ROW LEVEL SECURITY;

--
-- Name: content_review_assignment_labels content_review_assignment_labels_reviewer_delete; Type: POLICY; Schema: app; Owner: -
--

CREATE POLICY content_review_assignment_labels_reviewer_delete ON app.content_review_assignment_labels FOR DELETE TO authenticated USING ((EXISTS ( SELECT 1
   FROM app.content_review_assignments cra
  WHERE ((cra.content_review_assignment_id = content_review_assignment_labels.content_review_assignment_id) AND (cra.status = ANY (ARRAY['pending'::text, 'in_progress'::text])) AND ((cra.reviewer_id = ( SELECT auth.uid() AS uid)) OR (cra.created_by = ( SELECT auth.uid() AS uid)) OR (EXISTS ( SELECT 1
           FROM app.profiles p
          WHERE ((p.user_id = ( SELECT auth.uid() AS uid)) AND (p.role = 'admin'::text)))))))));


--
-- Name: content_review_assignment_labels content_review_assignment_labels_reviewer_insert; Type: POLICY; Schema: app; Owner: -
--

CREATE POLICY content_review_assignment_labels_reviewer_insert ON app.content_review_assignment_labels FOR INSERT TO authenticated WITH CHECK ((EXISTS ( SELECT 1
   FROM app.content_review_assignments cra
  WHERE ((cra.content_review_assignment_id = content_review_assignment_labels.content_review_assignment_id) AND (cra.status = ANY (ARRAY['pending'::text, 'in_progress'::text])) AND ((cra.reviewer_id = ( SELECT auth.uid() AS uid)) OR (cra.created_by = ( SELECT auth.uid() AS uid)) OR (EXISTS ( SELECT 1
           FROM app.profiles p
          WHERE ((p.user_id = ( SELECT auth.uid() AS uid)) AND (p.role = 'admin'::text)))))))));


--
-- Name: content_review_assignment_labels content_review_assignment_labels_reviewer_select; Type: POLICY; Schema: app; Owner: -
--

CREATE POLICY content_review_assignment_labels_reviewer_select ON app.content_review_assignment_labels FOR SELECT TO authenticated USING ((EXISTS ( SELECT 1
   FROM app.content_review_assignments cra
  WHERE ((cra.content_review_assignment_id = content_review_assignment_labels.content_review_assignment_id) AND ((cra.reviewer_id = ( SELECT auth.uid() AS uid)) OR (cra.created_by = ( SELECT auth.uid() AS uid)) OR (EXISTS ( SELECT 1
           FROM app.profiles p
          WHERE ((p.user_id = ( SELECT auth.uid() AS uid)) AND (p.role = 'admin'::text)))))))));


--
-- Name: content_review_assignment_labels content_review_assignment_labels_reviewer_update; Type: POLICY; Schema: app; Owner: -
--

CREATE POLICY content_review_assignment_labels_reviewer_update ON app.content_review_assignment_labels FOR UPDATE TO authenticated USING ((EXISTS ( SELECT 1
   FROM app.content_review_assignments cra
  WHERE ((cra.content_review_assignment_id = content_review_assignment_labels.content_review_assignment_id) AND (cra.status = ANY (ARRAY['pending'::text, 'in_progress'::text])) AND ((cra.reviewer_id = ( SELECT auth.uid() AS uid)) OR (cra.created_by = ( SELECT auth.uid() AS uid)) OR (EXISTS ( SELECT 1
           FROM app.profiles p
          WHERE ((p.user_id = ( SELECT auth.uid() AS uid)) AND (p.role = 'admin'::text))))))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM app.content_review_assignments cra
  WHERE ((cra.content_review_assignment_id = content_review_assignment_labels.content_review_assignment_id) AND (cra.status = ANY (ARRAY['pending'::text, 'in_progress'::text])) AND ((cra.reviewer_id = ( SELECT auth.uid() AS uid)) OR (cra.created_by = ( SELECT auth.uid() AS uid)) OR (EXISTS ( SELECT 1
           FROM app.profiles p
          WHERE ((p.user_id = ( SELECT auth.uid() AS uid)) AND (p.role = 'admin'::text)))))))));


--
-- Name: content_review_assignments; Type: ROW SECURITY; Schema: app; Owner: -
--

ALTER TABLE app.content_review_assignments ENABLE ROW LEVEL SECURITY;

--
-- Name: content_review_decisions; Type: ROW SECURITY; Schema: app; Owner: -
--

ALTER TABLE app.content_review_decisions ENABLE ROW LEVEL SECURITY;

--
-- Name: content_rights_releases; Type: ROW SECURITY; Schema: app; Owner: -
--

ALTER TABLE app.content_rights_releases ENABLE ROW LEVEL SECURITY;

--
-- Name: content_review_assignments cra_reviewer_select_own; Type: POLICY; Schema: app; Owner: -
--

CREATE POLICY cra_reviewer_select_own ON app.content_review_assignments FOR SELECT TO authenticated USING ((reviewer_id = auth.uid()));


--
-- Name: content_review_assignments cra_service_all; Type: POLICY; Schema: app; Owner: -
--

CREATE POLICY cra_service_all ON app.content_review_assignments TO service_role USING (true) WITH CHECK (true);


--
-- Name: content_review_decisions crd_reviewer_insert_own; Type: POLICY; Schema: app; Owner: -
--

CREATE POLICY crd_reviewer_insert_own ON app.content_review_decisions FOR INSERT TO authenticated WITH CHECK ((reviewer_id = auth.uid()));


--
-- Name: content_review_decisions crd_reviewer_select_own; Type: POLICY; Schema: app; Owner: -
--

CREATE POLICY crd_reviewer_select_own ON app.content_review_decisions FOR SELECT TO authenticated USING ((reviewer_id = auth.uid()));


--
-- Name: content_review_decisions crd_service_all; Type: POLICY; Schema: app; Owner: -
--

CREATE POLICY crd_service_all ON app.content_review_decisions TO service_role USING (true) WITH CHECK (true);


--
-- Name: attempt_criterion_results criterion_results_owner_select; Type: POLICY; Schema: app; Owner: -
--

CREATE POLICY criterion_results_owner_select ON app.attempt_criterion_results FOR SELECT TO authenticated USING ((EXISTS ( SELECT 1
   FROM app.attempts a
  WHERE ((a.id = attempt_criterion_results.attempt_id) AND (a.user_id = auth.uid())))));


--
-- Name: daily_budgets; Type: ROW SECURITY; Schema: app; Owner: -
--

ALTER TABLE app.daily_budgets ENABLE ROW LEVEL SECURITY;

--
-- Name: daily_budgets daily_budgets_service_only_insert; Type: POLICY; Schema: app; Owner: -
--

CREATE POLICY daily_budgets_service_only_insert ON app.daily_budgets FOR INSERT TO service_role WITH CHECK (true);


--
-- Name: daily_budgets daily_budgets_service_only_select; Type: POLICY; Schema: app; Owner: -
--

CREATE POLICY daily_budgets_service_only_select ON app.daily_budgets FOR SELECT TO service_role USING (true);


--
-- Name: daily_budgets daily_budgets_service_only_update; Type: POLICY; Schema: app; Owner: -
--

CREATE POLICY daily_budgets_service_only_update ON app.daily_budgets FOR UPDATE TO service_role USING (true) WITH CHECK (true);


--
-- Name: ai_variant_runs deny_authenticated_all; Type: POLICY; Schema: app; Owner: -
--

CREATE POLICY deny_authenticated_all ON app.ai_variant_runs TO authenticated USING (false) WITH CHECK (false);


--
-- Name: artifact_dependencies deny_authenticated_all; Type: POLICY; Schema: app; Owner: -
--

CREATE POLICY deny_authenticated_all ON app.artifact_dependencies TO authenticated USING (false) WITH CHECK (false);


--
-- Name: artifact_state_events deny_authenticated_all; Type: POLICY; Schema: app; Owner: -
--

CREATE POLICY deny_authenticated_all ON app.artifact_state_events TO authenticated USING (false) WITH CHECK (false);


--
-- Name: artifact_versions deny_authenticated_all; Type: POLICY; Schema: app; Owner: -
--

CREATE POLICY deny_authenticated_all ON app.artifact_versions TO authenticated USING (false) WITH CHECK (false);


--
-- Name: audit_events deny_authenticated_all; Type: POLICY; Schema: app; Owner: -
--

CREATE POLICY deny_authenticated_all ON app.audit_events TO authenticated USING (false) WITH CHECK (false);


--
-- Name: author_commissions deny_authenticated_all; Type: POLICY; Schema: app; Owner: -
--

CREATE POLICY deny_authenticated_all ON app.author_commissions TO authenticated USING (false) WITH CHECK (false);


--
-- Name: author_qualifications deny_authenticated_all; Type: POLICY; Schema: app; Owner: -
--

CREATE POLICY deny_authenticated_all ON app.author_qualifications TO authenticated USING (false) WITH CHECK (false);


--
-- Name: authoring_briefs deny_authenticated_all; Type: POLICY; Schema: app; Owner: -
--

CREATE POLICY deny_authenticated_all ON app.authoring_briefs TO authenticated USING (false) WITH CHECK (false);


--
-- Name: content_rights_releases deny_authenticated_all; Type: POLICY; Schema: app; Owner: -
--

CREATE POLICY deny_authenticated_all ON app.content_rights_releases TO authenticated USING (false) WITH CHECK (false);


--
-- Name: exam_pack_manifests deny_authenticated_all; Type: POLICY; Schema: app; Owner: -
--

CREATE POLICY deny_authenticated_all ON app.exam_pack_manifests TO authenticated USING (false) WITH CHECK (false);


--
-- Name: originality_attestations deny_authenticated_all; Type: POLICY; Schema: app; Owner: -
--

CREATE POLICY deny_authenticated_all ON app.originality_attestations TO authenticated USING (false) WITH CHECK (false);


--
-- Name: provenance_claims deny_authenticated_all; Type: POLICY; Schema: app; Owner: -
--

CREATE POLICY deny_authenticated_all ON app.provenance_claims TO authenticated USING (false) WITH CHECK (false);


--
-- Name: publication_events deny_authenticated_all; Type: POLICY; Schema: app; Owner: -
--

CREATE POLICY deny_authenticated_all ON app.publication_events TO authenticated USING (false) WITH CHECK (false);


--
-- Name: quality_incidents deny_authenticated_all; Type: POLICY; Schema: app; Owner: -
--

CREATE POLICY deny_authenticated_all ON app.quality_incidents TO authenticated USING (false) WITH CHECK (false);


--
-- Name: question_coverage_targets deny_authenticated_all; Type: POLICY; Schema: app; Owner: -
--

CREATE POLICY deny_authenticated_all ON app.question_coverage_targets TO authenticated USING (false) WITH CHECK (false);


--
-- Name: question_use_assignments deny_authenticated_all; Type: POLICY; Schema: app; Owner: -
--

CREATE POLICY deny_authenticated_all ON app.question_use_assignments TO authenticated USING (false) WITH CHECK (false);


--
-- Name: release_candidates deny_authenticated_all; Type: POLICY; Schema: app; Owner: -
--

CREATE POLICY deny_authenticated_all ON app.release_candidates TO authenticated USING (false) WITH CHECK (false);


--
-- Name: revalidation_cases deny_authenticated_all; Type: POLICY; Schema: app; Owner: -
--

CREATE POLICY deny_authenticated_all ON app.revalidation_cases TO authenticated USING (false) WITH CHECK (false);


--
-- Name: review_assignments deny_authenticated_all; Type: POLICY; Schema: app; Owner: -
--

CREATE POLICY deny_authenticated_all ON app.review_assignments TO authenticated USING (false) WITH CHECK (false);


--
-- Name: review_decisions deny_authenticated_all; Type: POLICY; Schema: app; Owner: -
--

CREATE POLICY deny_authenticated_all ON app.review_decisions TO authenticated USING (false) WITH CHECK (false);


--
-- Name: rights_records deny_authenticated_all; Type: POLICY; Schema: app; Owner: -
--

CREATE POLICY deny_authenticated_all ON app.rights_records TO authenticated USING (false) WITH CHECK (false);


--
-- Name: source_records deny_authenticated_all; Type: POLICY; Schema: app; Owner: -
--

CREATE POLICY deny_authenticated_all ON app.source_records TO authenticated USING (false) WITH CHECK (false);


--
-- Name: validation_cases deny_authenticated_all; Type: POLICY; Schema: app; Owner: -
--

CREATE POLICY deny_authenticated_all ON app.validation_cases TO authenticated USING (false) WITH CHECK (false);


--
-- Name: validation_results deny_authenticated_all; Type: POLICY; Schema: app; Owner: -
--

CREATE POLICY deny_authenticated_all ON app.validation_results TO authenticated USING (false) WITH CHECK (false);


--
-- Name: validation_runs deny_authenticated_all; Type: POLICY; Schema: app; Owner: -
--

CREATE POLICY deny_authenticated_all ON app.validation_runs TO authenticated USING (false) WITH CHECK (false);


--
-- Name: validation_suites deny_authenticated_all; Type: POLICY; Schema: app; Owner: -
--

CREATE POLICY deny_authenticated_all ON app.validation_suites TO authenticated USING (false) WITH CHECK (false);


--
-- Name: validator_entitlements deny_authenticated_all; Type: POLICY; Schema: app; Owner: -
--

CREATE POLICY deny_authenticated_all ON app.validator_entitlements TO authenticated USING (false) WITH CHECK (false);


--
-- Name: validator_qualifications deny_authenticated_all; Type: POLICY; Schema: app; Owner: -
--

CREATE POLICY deny_authenticated_all ON app.validator_qualifications TO authenticated USING (false) WITH CHECK (false);


--
-- Name: exam_pack_manifests; Type: ROW SECURITY; Schema: app; Owner: -
--

ALTER TABLE app.exam_pack_manifests ENABLE ROW LEVEL SECURITY;

--
-- Name: exam_pack_versions; Type: ROW SECURITY; Schema: app; Owner: -
--

ALTER TABLE app.exam_pack_versions ENABLE ROW LEVEL SECURITY;

--
-- Name: exam_pack_versions exam_pack_versions_select_published; Type: POLICY; Schema: app; Owner: -
--

CREATE POLICY exam_pack_versions_select_published ON app.exam_pack_versions FOR SELECT TO authenticated USING ((status = 'published'::text));


--
-- Name: exam_packs; Type: ROW SECURITY; Schema: app; Owner: -
--

ALTER TABLE app.exam_packs ENABLE ROW LEVEL SECURITY;

--
-- Name: exam_packs exam_packs_select_published; Type: POLICY; Schema: app; Owner: -
--

CREATE POLICY exam_packs_select_published ON app.exam_packs FOR SELECT TO authenticated USING (true);


--
-- Name: frq_criteria; Type: ROW SECURITY; Schema: app; Owner: -
--

ALTER TABLE app.frq_criteria ENABLE ROW LEVEL SECURITY;

--
-- Name: frq_criteria frq_criteria_select_assigned_reviewer; Type: POLICY; Schema: app; Owner: -
--

CREATE POLICY frq_criteria_select_assigned_reviewer ON app.frq_criteria FOR SELECT TO authenticated USING ((EXISTS ( SELECT 1
   FROM app.content_review_assignments cra
  WHERE ((cra.content_item_version_id = frq_criteria.content_item_version_id) AND (cra.reviewer_id = auth.uid()) AND (cra.status = ANY (ARRAY['pending'::text, 'in_progress'::text, 'submitted'::text]))))));


--
-- Name: frq_criteria frq_criteria_select_published; Type: POLICY; Schema: app; Owner: -
--

CREATE POLICY frq_criteria_select_published ON app.frq_criteria FOR SELECT TO authenticated USING ((EXISTS ( SELECT 1
   FROM ((app.content_item_versions civ
     JOIN app.content_items ci ON ((ci.id = civ.content_item_id)))
     JOIN app.exam_pack_versions epv ON ((epv.id = ci.exam_pack_version_id)))
  WHERE ((civ.id = frq_criteria.content_item_version_id) AND (civ.status = 'published'::text) AND (ci.status = 'published'::text) AND (epv.status = 'published'::text)))));


--
-- Name: frq_synthetic_responses; Type: ROW SECURITY; Schema: app; Owner: -
--

ALTER TABLE app.frq_synthetic_responses ENABLE ROW LEVEL SECURITY;

--
-- Name: frq_synthetic_responses frq_synthetic_responses_service_all; Type: POLICY; Schema: app; Owner: -
--

CREATE POLICY frq_synthetic_responses_service_all ON app.frq_synthetic_responses TO service_role USING (true) WITH CHECK (true);


--
-- Name: grading_results; Type: ROW SECURITY; Schema: app; Owner: -
--

ALTER TABLE app.grading_results ENABLE ROW LEVEL SECURITY;

--
-- Name: grading_results grading_results_owner_select; Type: POLICY; Schema: app; Owner: -
--

CREATE POLICY grading_results_owner_select ON app.grading_results FOR SELECT TO authenticated USING ((EXISTS ( SELECT 1
   FROM app.attempts a
  WHERE ((a.id = grading_results.attempt_id) AND (a.user_id = auth.uid())))));


--
-- Name: learning_sessions; Type: ROW SECURITY; Schema: app; Owner: -
--

ALTER TABLE app.learning_sessions ENABLE ROW LEVEL SECURITY;

--
-- Name: learning_sessions learning_sessions_owner_insert; Type: POLICY; Schema: app; Owner: -
--

CREATE POLICY learning_sessions_owner_insert ON app.learning_sessions FOR INSERT TO authenticated WITH CHECK ((auth.uid() = user_id));


--
-- Name: learning_sessions learning_sessions_owner_select; Type: POLICY; Schema: app; Owner: -
--

CREATE POLICY learning_sessions_owner_select ON app.learning_sessions FOR SELECT TO authenticated USING ((auth.uid() = user_id));


--
-- Name: learning_sessions learning_sessions_owner_update; Type: POLICY; Schema: app; Owner: -
--

CREATE POLICY learning_sessions_owner_update ON app.learning_sessions FOR UPDATE TO authenticated USING ((auth.uid() = user_id)) WITH CHECK ((auth.uid() = user_id));


--
-- Name: mcq_choices; Type: ROW SECURITY; Schema: app; Owner: -
--

ALTER TABLE app.mcq_choices ENABLE ROW LEVEL SECURITY;

--
-- Name: mcq_choices mcq_choices_select_assigned_reviewer; Type: POLICY; Schema: app; Owner: -
--

CREATE POLICY mcq_choices_select_assigned_reviewer ON app.mcq_choices FOR SELECT TO authenticated USING ((EXISTS ( SELECT 1
   FROM app.content_review_assignments cra
  WHERE ((cra.content_item_version_id = mcq_choices.content_item_version_id) AND (cra.reviewer_id = auth.uid()) AND (cra.status = ANY (ARRAY['pending'::text, 'in_progress'::text, 'submitted'::text]))))));


--
-- Name: mcq_choices mcq_choices_select_published; Type: POLICY; Schema: app; Owner: -
--

CREATE POLICY mcq_choices_select_published ON app.mcq_choices FOR SELECT TO authenticated USING ((EXISTS ( SELECT 1
   FROM ((app.content_item_versions civ
     JOIN app.content_items ci ON ((ci.id = civ.content_item_id)))
     JOIN app.exam_pack_versions epv ON ((epv.id = ci.exam_pack_version_id)))
  WHERE ((civ.id = mcq_choices.content_item_version_id) AND (civ.status = 'published'::text) AND (ci.status = 'published'::text) AND (epv.status = 'published'::text)))));


--
-- Name: model_usage_ledger; Type: ROW SECURITY; Schema: app; Owner: -
--

ALTER TABLE app.model_usage_ledger ENABLE ROW LEVEL SECURITY;

--
-- Name: model_usage_ledger model_usage_ledger_service_only; Type: POLICY; Schema: app; Owner: -
--

CREATE POLICY model_usage_ledger_service_only ON app.model_usage_ledger FOR SELECT TO service_role USING (true);


--
-- Name: model_usage_ledger model_usage_ledger_service_only_update; Type: POLICY; Schema: app; Owner: -
--

CREATE POLICY model_usage_ledger_service_only_update ON app.model_usage_ledger FOR UPDATE TO service_role USING (true) WITH CHECK (true);


--
-- Name: model_usage_ledger model_usage_ledger_service_only_write; Type: POLICY; Schema: app; Owner: -
--

CREATE POLICY model_usage_ledger_service_only_write ON app.model_usage_ledger FOR INSERT TO service_role WITH CHECK (true);


--
-- Name: originality_attestations; Type: ROW SECURITY; Schema: app; Owner: -
--

ALTER TABLE app.originality_attestations ENABLE ROW LEVEL SECURITY;

--
-- Name: profiles; Type: ROW SECURITY; Schema: app; Owner: -
--

ALTER TABLE app.profiles ENABLE ROW LEVEL SECURITY;

--
-- Name: profiles profiles_select_own; Type: POLICY; Schema: app; Owner: -
--

CREATE POLICY profiles_select_own ON app.profiles FOR SELECT TO authenticated USING ((auth.uid() = user_id));


--
-- Name: profiles profiles_update_own; Type: POLICY; Schema: app; Owner: -
--

CREATE POLICY profiles_update_own ON app.profiles FOR UPDATE TO authenticated USING ((auth.uid() = user_id)) WITH CHECK ((auth.uid() = user_id));


--
-- Name: progress_snapshots; Type: ROW SECURITY; Schema: app; Owner: -
--

ALTER TABLE app.progress_snapshots ENABLE ROW LEVEL SECURITY;

--
-- Name: progress_snapshots progress_snapshots_owner_select; Type: POLICY; Schema: app; Owner: -
--

CREATE POLICY progress_snapshots_owner_select ON app.progress_snapshots FOR SELECT TO authenticated USING ((auth.uid() = user_id));


--
-- Name: prompt_versions; Type: ROW SECURITY; Schema: app; Owner: -
--

ALTER TABLE app.prompt_versions ENABLE ROW LEVEL SECURITY;

--
-- Name: prompt_versions prompt_versions_service_only; Type: POLICY; Schema: app; Owner: -
--

CREATE POLICY prompt_versions_service_only ON app.prompt_versions FOR SELECT TO service_role USING (true);


--
-- Name: provenance_claims; Type: ROW SECURITY; Schema: app; Owner: -
--

ALTER TABLE app.provenance_claims ENABLE ROW LEVEL SECURITY;

--
-- Name: publication_events; Type: ROW SECURITY; Schema: app; Owner: -
--

ALTER TABLE app.publication_events ENABLE ROW LEVEL SECURITY;

--
-- Name: quality_incidents; Type: ROW SECURITY; Schema: app; Owner: -
--

ALTER TABLE app.quality_incidents ENABLE ROW LEVEL SECURITY;

--
-- Name: question_coverage_targets; Type: ROW SECURITY; Schema: app; Owner: -
--

ALTER TABLE app.question_coverage_targets ENABLE ROW LEVEL SECURITY;

--
-- Name: question_use_assignments; Type: ROW SECURITY; Schema: app; Owner: -
--

ALTER TABLE app.question_use_assignments ENABLE ROW LEVEL SECURITY;

--
-- Name: release_candidates; Type: ROW SECURITY; Schema: app; Owner: -
--

ALTER TABLE app.release_candidates ENABLE ROW LEVEL SECURITY;

--
-- Name: response_versions; Type: ROW SECURITY; Schema: app; Owner: -
--

ALTER TABLE app.response_versions ENABLE ROW LEVEL SECURITY;

--
-- Name: response_versions response_versions_owner_insert_draft; Type: POLICY; Schema: app; Owner: -
--

CREATE POLICY response_versions_owner_insert_draft ON app.response_versions FOR INSERT TO authenticated WITH CHECK ((EXISTS ( SELECT 1
   FROM app.attempts a
  WHERE ((a.id = response_versions.attempt_id) AND (a.user_id = auth.uid()) AND (a.status = ANY (ARRAY['draft'::text, 'failed'::text]))))));


--
-- Name: response_versions response_versions_owner_select; Type: POLICY; Schema: app; Owner: -
--

CREATE POLICY response_versions_owner_select ON app.response_versions FOR SELECT TO authenticated USING ((EXISTS ( SELECT 1
   FROM app.attempts a
  WHERE ((a.id = response_versions.attempt_id) AND (a.user_id = auth.uid())))));


--
-- Name: response_versions response_versions_owner_update_draft; Type: POLICY; Schema: app; Owner: -
--

CREATE POLICY response_versions_owner_update_draft ON app.response_versions FOR UPDATE TO authenticated USING (((EXISTS ( SELECT 1
   FROM app.attempts a
  WHERE ((a.id = response_versions.attempt_id) AND (a.user_id = auth.uid()) AND (a.status = ANY (ARRAY['draft'::text, 'failed'::text]))))) AND (is_submitted = false))) WITH CHECK (((EXISTS ( SELECT 1
   FROM app.attempts a
  WHERE ((a.id = response_versions.attempt_id) AND (a.user_id = auth.uid()) AND (a.status = ANY (ARRAY['draft'::text, 'failed'::text]))))) AND (is_submitted = false)));


--
-- Name: revalidation_cases; Type: ROW SECURITY; Schema: app; Owner: -
--

ALTER TABLE app.revalidation_cases ENABLE ROW LEVEL SECURITY;

--
-- Name: review_assignments; Type: ROW SECURITY; Schema: app; Owner: -
--

ALTER TABLE app.review_assignments ENABLE ROW LEVEL SECURITY;

--
-- Name: review_decisions; Type: ROW SECURITY; Schema: app; Owner: -
--

ALTER TABLE app.review_decisions ENABLE ROW LEVEL SECURITY;

--
-- Name: rights_records; Type: ROW SECURITY; Schema: app; Owner: -
--

ALTER TABLE app.rights_records ENABLE ROW LEVEL SECURITY;

--
-- Name: source_records; Type: ROW SECURITY; Schema: app; Owner: -
--

ALTER TABLE app.source_records ENABLE ROW LEVEL SECURITY;

--
-- Name: student_memory_events; Type: ROW SECURITY; Schema: app; Owner: -
--

ALTER TABLE app.student_memory_events ENABLE ROW LEVEL SECURITY;

--
-- Name: student_memory_events student_memory_events_service_all; Type: POLICY; Schema: app; Owner: -
--

CREATE POLICY student_memory_events_service_all ON app.student_memory_events TO service_role USING (true) WITH CHECK (true);


--
-- Name: student_memory_snapshots; Type: ROW SECURITY; Schema: app; Owner: -
--

ALTER TABLE app.student_memory_snapshots ENABLE ROW LEVEL SECURITY;

--
-- Name: student_memory_snapshots student_memory_snapshots_service_all; Type: POLICY; Schema: app; Owner: -
--

CREATE POLICY student_memory_snapshots_service_all ON app.student_memory_snapshots TO service_role USING (true) WITH CHECK (true);


--
-- Name: subject_guidance_profiles; Type: ROW SECURITY; Schema: app; Owner: -
--

ALTER TABLE app.subject_guidance_profiles ENABLE ROW LEVEL SECURITY;

--
-- Name: subject_guidance_profiles subject_guidance_profiles_service_all; Type: POLICY; Schema: app; Owner: -
--

CREATE POLICY subject_guidance_profiles_service_all ON app.subject_guidance_profiles TO service_role USING (true) WITH CHECK (true);


--
-- Name: subjects; Type: ROW SECURITY; Schema: app; Owner: -
--

ALTER TABLE app.subjects ENABLE ROW LEVEL SECURITY;

--
-- Name: subjects subjects_select_active; Type: POLICY; Schema: app; Owner: -
--

CREATE POLICY subjects_select_active ON app.subjects FOR SELECT TO authenticated USING ((status = 'active'::text));


--
-- Name: validation_cases; Type: ROW SECURITY; Schema: app; Owner: -
--

ALTER TABLE app.validation_cases ENABLE ROW LEVEL SECURITY;

--
-- Name: validation_results; Type: ROW SECURITY; Schema: app; Owner: -
--

ALTER TABLE app.validation_results ENABLE ROW LEVEL SECURITY;

--
-- Name: validation_runs; Type: ROW SECURITY; Schema: app; Owner: -
--

ALTER TABLE app.validation_runs ENABLE ROW LEVEL SECURITY;

--
-- Name: validation_suites; Type: ROW SECURITY; Schema: app; Owner: -
--

ALTER TABLE app.validation_suites ENABLE ROW LEVEL SECURITY;

--
-- Name: validator_entitlements; Type: ROW SECURITY; Schema: app; Owner: -
--

ALTER TABLE app.validator_entitlements ENABLE ROW LEVEL SECURITY;

--
-- Name: validator_qualifications; Type: ROW SECURITY; Schema: app; Owner: -
--

ALTER TABLE app.validator_qualifications ENABLE ROW LEVEL SECURITY;

--
-- Name: exam_specs; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.exam_specs ENABLE ROW LEVEL SECURITY;

--
-- Name: exam_specs exam_specs_select_authenticated; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY exam_specs_select_authenticated ON public.exam_specs FOR SELECT TO authenticated USING (true);


--
-- Name: questions; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.questions ENABLE ROW LEVEL SECURITY;

--
-- Name: questions questions_select_approved_authenticated; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY questions_select_approved_authenticated ON public.questions FOR SELECT TO authenticated USING ((status = 'approved'::text));


--
-- Name: sessions; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.sessions ENABLE ROW LEVEL SECURITY;

--
-- Name: sessions sessions_insert_own; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY sessions_insert_own ON public.sessions FOR INSERT TO authenticated WITH CHECK ((( SELECT auth.uid() AS uid) = student_id));


--
-- Name: sessions sessions_select_own; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY sessions_select_own ON public.sessions FOR SELECT TO authenticated USING ((( SELECT auth.uid() AS uid) = student_id));


--
-- Name: sessions sessions_update_own; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY sessions_update_own ON public.sessions FOR UPDATE TO authenticated USING ((( SELECT auth.uid() AS uid) = student_id)) WITH CHECK ((( SELECT auth.uid() AS uid) = student_id));


--
-- Name: student_attempts; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.student_attempts ENABLE ROW LEVEL SECURITY;

--
-- Name: student_attempts student_attempts_insert_own; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY student_attempts_insert_own ON public.student_attempts FOR INSERT TO authenticated WITH CHECK ((( SELECT auth.uid() AS uid) = student_id));


--
-- Name: student_attempts student_attempts_select_own; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY student_attempts_select_own ON public.student_attempts FOR SELECT TO authenticated USING ((( SELECT auth.uid() AS uid) = student_id));


--
-- Name: student_attempts student_attempts_update_own; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY student_attempts_update_own ON public.student_attempts FOR UPDATE TO authenticated USING ((( SELECT auth.uid() AS uid) = student_id)) WITH CHECK ((( SELECT auth.uid() AS uid) = student_id));


--
-- Name: student_lock_queue; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.student_lock_queue ENABLE ROW LEVEL SECURITY;

--
-- Name: student_lock_queue student_lock_queue_select_own; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY student_lock_queue_select_own ON public.student_lock_queue FOR SELECT TO authenticated USING ((( SELECT auth.uid() AS uid) = student_id));


--
-- Name: SCHEMA app; Type: ACL; Schema: -; Owner: -
--

GRANT USAGE ON SCHEMA app TO authenticated;
GRANT USAGE ON SCHEMA app TO service_role;
GRANT USAGE ON SCHEMA app TO content_reviewer;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: -
--

GRANT USAGE ON SCHEMA public TO postgres;
GRANT USAGE ON SCHEMA public TO anon;
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT USAGE ON SCHEMA public TO service_role;


--
-- Name: TABLE model_usage_ledger; Type: ACL; Schema: app; Owner: -
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE app.model_usage_ledger TO service_role;
GRANT SELECT ON TABLE app.model_usage_ledger TO content_reviewer;


--
-- Name: FUNCTION complete_model_usage(p_request_id text, p_request_hash text, p_status text, p_actual_cost_usd numeric, p_input_tokens integer, p_output_tokens integer); Type: ACL; Schema: app; Owner: -
--

REVOKE ALL ON FUNCTION app.complete_model_usage(p_request_id text, p_request_hash text, p_status text, p_actual_cost_usd numeric, p_input_tokens integer, p_output_tokens integer) FROM PUBLIC;
GRANT ALL ON FUNCTION app.complete_model_usage(p_request_id text, p_request_hash text, p_status text, p_actual_cost_usd numeric, p_input_tokens integer, p_output_tokens integer) TO service_role;


--
-- Name: FUNCTION compose_learning_runtime_context(p_session_id uuid); Type: ACL; Schema: app; Owner: -
--

GRANT ALL ON FUNCTION app.compose_learning_runtime_context(p_session_id uuid) TO service_role;


--
-- Name: FUNCTION content_item_is_published(p_content_item_id uuid); Type: ACL; Schema: app; Owner: -
--

REVOKE ALL ON FUNCTION app.content_item_is_published(p_content_item_id uuid) FROM PUBLIC;
GRANT ALL ON FUNCTION app.content_item_is_published(p_content_item_id uuid) TO authenticated;
GRANT ALL ON FUNCTION app.content_item_is_published(p_content_item_id uuid) TO service_role;


--
-- Name: FUNCTION lock_content_review_submission(); Type: ACL; Schema: app; Owner: -
--

REVOKE ALL ON FUNCTION app.lock_content_review_submission() FROM PUBLIC;


--
-- Name: FUNCTION reserve_artifact_version_sequence(p_artifact_id uuid); Type: ACL; Schema: app; Owner: -
--

REVOKE ALL ON FUNCTION app.reserve_artifact_version_sequence(p_artifact_id uuid) FROM PUBLIC;
GRANT ALL ON FUNCTION app.reserve_artifact_version_sequence(p_artifact_id uuid) TO service_role;


--
-- Name: FUNCTION reserve_model_usage(p_request_id text, p_request_hash text, p_model_id text, p_reserved_cost_usd numeric, p_cap_usd numeric); Type: ACL; Schema: app; Owner: -
--

REVOKE ALL ON FUNCTION app.reserve_model_usage(p_request_id text, p_request_hash text, p_model_id text, p_reserved_cost_usd numeric, p_cap_usd numeric) FROM PUBLIC;
GRANT ALL ON FUNCTION app.reserve_model_usage(p_request_id text, p_request_hash text, p_model_id text, p_reserved_cost_usd numeric, p_cap_usd numeric) TO service_role;


--
-- Name: FUNCTION submit_response(p_attempt_id uuid, p_response_version_id uuid, p_actor_id uuid, p_actor_role text, p_idempotency_key text, p_request_hash text); Type: ACL; Schema: app; Owner: -
--

REVOKE ALL ON FUNCTION app.submit_response(p_attempt_id uuid, p_response_version_id uuid, p_actor_id uuid, p_actor_role text, p_idempotency_key text, p_request_hash text) FROM PUBLIC;
GRANT ALL ON FUNCTION app.submit_response(p_attempt_id uuid, p_response_version_id uuid, p_actor_id uuid, p_actor_role text, p_idempotency_key text, p_request_hash text) TO service_role;


--
-- Name: FUNCTION tg_content_pipeline_on_decision(); Type: ACL; Schema: app; Owner: -
--

REVOKE ALL ON FUNCTION app.tg_content_pipeline_on_decision() FROM PUBLIC;


--
-- Name: FUNCTION _epv_is_selectable(_version_id uuid); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION public._epv_is_selectable(_version_id uuid) FROM PUBLIC;
GRANT ALL ON FUNCTION public._epv_is_selectable(_version_id uuid) TO service_role;


--
-- Name: FUNCTION complete_onboarding(_version_id uuid); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION public.complete_onboarding(_version_id uuid) FROM PUBLIC;
GRANT ALL ON FUNCTION public.complete_onboarding(_version_id uuid) TO authenticated;
GRANT ALL ON FUNCTION public.complete_onboarding(_version_id uuid) TO service_role;


--
-- Name: FUNCTION select_practice_frqs(_exam_pack_version_id uuid, _practice_format text, _limit integer); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION public.select_practice_frqs(_exam_pack_version_id uuid, _practice_format text, _limit integer) FROM PUBLIC;
GRANT ALL ON FUNCTION public.select_practice_frqs(_exam_pack_version_id uuid, _practice_format text, _limit integer) TO authenticated;
GRANT ALL ON FUNCTION public.select_practice_frqs(_exam_pack_version_id uuid, _practice_format text, _limit integer) TO service_role;


--
-- Name: FUNCTION set_active_exam_pack_version(_version_id uuid); Type: ACL; Schema: public; Owner: -
--

REVOKE ALL ON FUNCTION public.set_active_exam_pack_version(_version_id uuid) FROM PUBLIC;
GRANT ALL ON FUNCTION public.set_active_exam_pack_version(_version_id uuid) TO authenticated;
GRANT ALL ON FUNCTION public.set_active_exam_pack_version(_version_id uuid) TO service_role;


--
-- Name: TABLE ai_variant_runs; Type: ACL; Schema: app; Owner: -
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE app.ai_variant_runs TO service_role;
GRANT SELECT ON TABLE app.ai_variant_runs TO content_reviewer;


--
-- Name: TABLE artifact_dependencies; Type: ACL; Schema: app; Owner: -
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE app.artifact_dependencies TO service_role;
GRANT SELECT ON TABLE app.artifact_dependencies TO content_reviewer;


--
-- Name: TABLE artifact_label_assignments; Type: ACL; Schema: app; Owner: -
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE app.artifact_label_assignments TO authenticated;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE app.artifact_label_assignments TO service_role;
GRANT SELECT ON TABLE app.artifact_label_assignments TO content_reviewer;


--
-- Name: TABLE artifact_state_events; Type: ACL; Schema: app; Owner: -
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE app.artifact_state_events TO service_role;
GRANT SELECT ON TABLE app.artifact_state_events TO content_reviewer;


--
-- Name: TABLE artifact_versions; Type: ACL; Schema: app; Owner: -
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE app.artifact_versions TO service_role;
GRANT SELECT ON TABLE app.artifact_versions TO content_reviewer;


--
-- Name: TABLE attempt_criterion_results; Type: ACL; Schema: app; Owner: -
--

GRANT SELECT ON TABLE app.attempt_criterion_results TO authenticated;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE app.attempt_criterion_results TO service_role;
GRANT SELECT ON TABLE app.attempt_criterion_results TO content_reviewer;


--
-- Name: TABLE attempt_responses; Type: ACL; Schema: app; Owner: -
--

GRANT SELECT,INSERT,UPDATE ON TABLE app.attempt_responses TO authenticated;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE app.attempt_responses TO service_role;
GRANT SELECT ON TABLE app.attempt_responses TO content_reviewer;


--
-- Name: TABLE attempts; Type: ACL; Schema: app; Owner: -
--

GRANT SELECT,INSERT,UPDATE ON TABLE app.attempts TO authenticated;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE app.attempts TO service_role;
GRANT SELECT ON TABLE app.attempts TO content_reviewer;


--
-- Name: TABLE audit_events; Type: ACL; Schema: app; Owner: -
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE app.audit_events TO service_role;
GRANT SELECT ON TABLE app.audit_events TO content_reviewer;


--
-- Name: TABLE author_commissions; Type: ACL; Schema: app; Owner: -
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE app.author_commissions TO service_role;
GRANT SELECT ON TABLE app.author_commissions TO content_reviewer;


--
-- Name: TABLE author_qualifications; Type: ACL; Schema: app; Owner: -
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE app.author_qualifications TO service_role;
GRANT SELECT ON TABLE app.author_qualifications TO content_reviewer;


--
-- Name: TABLE authoring_briefs; Type: ACL; Schema: app; Owner: -
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE app.authoring_briefs TO service_role;
GRANT SELECT ON TABLE app.authoring_briefs TO content_reviewer;


--
-- Name: TABLE config; Type: ACL; Schema: app; Owner: -
--

GRANT SELECT ON TABLE app.config TO content_reviewer;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE app.config TO service_role;
GRANT SELECT ON TABLE app.config TO authenticated;


--
-- Name: TABLE content_ingest_batches; Type: ACL; Schema: app; Owner: -
--

GRANT SELECT,INSERT,UPDATE ON TABLE app.content_ingest_batches TO authenticated;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE app.content_ingest_batches TO service_role;
GRANT SELECT ON TABLE app.content_ingest_batches TO content_reviewer;


--
-- Name: TABLE content_ingest_rows; Type: ACL; Schema: app; Owner: -
--

GRANT SELECT,INSERT,UPDATE ON TABLE app.content_ingest_rows TO authenticated;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE app.content_ingest_rows TO service_role;
GRANT SELECT ON TABLE app.content_ingest_rows TO content_reviewer;


--
-- Name: TABLE content_item_labels; Type: ACL; Schema: app; Owner: -
--

GRANT SELECT ON TABLE app.content_item_labels TO authenticated;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE app.content_item_labels TO service_role;
GRANT SELECT ON TABLE app.content_item_labels TO content_reviewer;


--
-- Name: TABLE content_item_versions; Type: ACL; Schema: app; Owner: -
--

GRANT SELECT ON TABLE app.content_item_versions TO authenticated;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE app.content_item_versions TO service_role;
GRANT SELECT ON TABLE app.content_item_versions TO content_reviewer;


--
-- Name: TABLE content_items; Type: ACL; Schema: app; Owner: -
--

GRANT SELECT ON TABLE app.content_items TO authenticated;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE app.content_items TO service_role;
GRANT SELECT ON TABLE app.content_items TO content_reviewer;


--
-- Name: TABLE content_labels; Type: ACL; Schema: app; Owner: -
--

GRANT SELECT ON TABLE app.content_labels TO authenticated;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE app.content_labels TO service_role;
GRANT SELECT ON TABLE app.content_labels TO content_reviewer;


--
-- Name: TABLE content_review_assignment_labels; Type: ACL; Schema: app; Owner: -
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE app.content_review_assignment_labels TO authenticated;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE app.content_review_assignment_labels TO service_role;
GRANT SELECT ON TABLE app.content_review_assignment_labels TO content_reviewer;


--
-- Name: TABLE content_review_assignments; Type: ACL; Schema: app; Owner: -
--

GRANT SELECT ON TABLE app.content_review_assignments TO authenticated;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE app.content_review_assignments TO service_role;
GRANT SELECT ON TABLE app.content_review_assignments TO content_reviewer;


--
-- Name: TABLE content_review_decisions; Type: ACL; Schema: app; Owner: -
--

GRANT SELECT,INSERT ON TABLE app.content_review_decisions TO authenticated;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE app.content_review_decisions TO service_role;
GRANT SELECT ON TABLE app.content_review_decisions TO content_reviewer;


--
-- Name: TABLE content_rights_releases; Type: ACL; Schema: app; Owner: -
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE app.content_rights_releases TO service_role;
GRANT SELECT ON TABLE app.content_rights_releases TO content_reviewer;


--
-- Name: TABLE daily_budgets; Type: ACL; Schema: app; Owner: -
--

GRANT SELECT,INSERT,UPDATE ON TABLE app.daily_budgets TO service_role;
GRANT SELECT ON TABLE app.daily_budgets TO content_reviewer;


--
-- Name: TABLE exam_pack_manifests; Type: ACL; Schema: app; Owner: -
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE app.exam_pack_manifests TO service_role;
GRANT SELECT ON TABLE app.exam_pack_manifests TO content_reviewer;


--
-- Name: TABLE exam_pack_versions; Type: ACL; Schema: app; Owner: -
--

GRANT SELECT ON TABLE app.exam_pack_versions TO authenticated;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE app.exam_pack_versions TO service_role;
GRANT SELECT ON TABLE app.exam_pack_versions TO content_reviewer;


--
-- Name: TABLE exam_packs; Type: ACL; Schema: app; Owner: -
--

GRANT SELECT ON TABLE app.exam_packs TO authenticated;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE app.exam_packs TO service_role;
GRANT SELECT ON TABLE app.exam_packs TO content_reviewer;


--
-- Name: TABLE frq_criteria; Type: ACL; Schema: app; Owner: -
--

GRANT SELECT ON TABLE app.frq_criteria TO authenticated;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE app.frq_criteria TO service_role;
GRANT SELECT ON TABLE app.frq_criteria TO content_reviewer;


--
-- Name: TABLE frq_synthetic_responses; Type: ACL; Schema: app; Owner: -
--

GRANT SELECT ON TABLE app.frq_synthetic_responses TO content_reviewer;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE app.frq_synthetic_responses TO service_role;


--
-- Name: TABLE grading_results; Type: ACL; Schema: app; Owner: -
--

GRANT SELECT ON TABLE app.grading_results TO authenticated;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE app.grading_results TO service_role;
GRANT SELECT ON TABLE app.grading_results TO content_reviewer;


--
-- Name: TABLE learning_sessions; Type: ACL; Schema: app; Owner: -
--

GRANT SELECT,INSERT,UPDATE ON TABLE app.learning_sessions TO authenticated;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE app.learning_sessions TO service_role;
GRANT SELECT ON TABLE app.learning_sessions TO content_reviewer;


--
-- Name: TABLE mcq_choices; Type: ACL; Schema: app; Owner: -
--

GRANT SELECT ON TABLE app.mcq_choices TO authenticated;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE app.mcq_choices TO service_role;
GRANT SELECT ON TABLE app.mcq_choices TO content_reviewer;


--
-- Name: TABLE originality_attestations; Type: ACL; Schema: app; Owner: -
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE app.originality_attestations TO service_role;
GRANT SELECT ON TABLE app.originality_attestations TO content_reviewer;


--
-- Name: TABLE profiles; Type: ACL; Schema: app; Owner: -
--

GRANT SELECT,UPDATE ON TABLE app.profiles TO authenticated;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE app.profiles TO service_role;
GRANT SELECT ON TABLE app.profiles TO content_reviewer;


--
-- Name: TABLE progress_snapshots; Type: ACL; Schema: app; Owner: -
--

GRANT SELECT ON TABLE app.progress_snapshots TO authenticated;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE app.progress_snapshots TO service_role;
GRANT SELECT ON TABLE app.progress_snapshots TO content_reviewer;


--
-- Name: TABLE prompt_versions; Type: ACL; Schema: app; Owner: -
--

GRANT SELECT ON TABLE app.prompt_versions TO authenticated;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE app.prompt_versions TO service_role;
GRANT SELECT ON TABLE app.prompt_versions TO content_reviewer;


--
-- Name: TABLE provenance_claims; Type: ACL; Schema: app; Owner: -
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE app.provenance_claims TO service_role;
GRANT SELECT ON TABLE app.provenance_claims TO content_reviewer;


--
-- Name: TABLE publication_events; Type: ACL; Schema: app; Owner: -
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE app.publication_events TO service_role;
GRANT SELECT ON TABLE app.publication_events TO content_reviewer;


--
-- Name: TABLE quality_incidents; Type: ACL; Schema: app; Owner: -
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE app.quality_incidents TO service_role;
GRANT SELECT ON TABLE app.quality_incidents TO content_reviewer;


--
-- Name: TABLE question_coverage_targets; Type: ACL; Schema: app; Owner: -
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE app.question_coverage_targets TO service_role;
GRANT SELECT ON TABLE app.question_coverage_targets TO content_reviewer;


--
-- Name: TABLE question_use_assignments; Type: ACL; Schema: app; Owner: -
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE app.question_use_assignments TO service_role;
GRANT SELECT ON TABLE app.question_use_assignments TO content_reviewer;


--
-- Name: TABLE release_candidates; Type: ACL; Schema: app; Owner: -
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE app.release_candidates TO service_role;
GRANT SELECT ON TABLE app.release_candidates TO content_reviewer;


--
-- Name: TABLE response_versions; Type: ACL; Schema: app; Owner: -
--

GRANT SELECT,INSERT,UPDATE ON TABLE app.response_versions TO authenticated;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE app.response_versions TO service_role;
GRANT SELECT ON TABLE app.response_versions TO content_reviewer;


--
-- Name: TABLE revalidation_cases; Type: ACL; Schema: app; Owner: -
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE app.revalidation_cases TO service_role;
GRANT SELECT ON TABLE app.revalidation_cases TO content_reviewer;


--
-- Name: TABLE review_assignments; Type: ACL; Schema: app; Owner: -
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE app.review_assignments TO service_role;
GRANT SELECT ON TABLE app.review_assignments TO content_reviewer;


--
-- Name: TABLE review_decisions; Type: ACL; Schema: app; Owner: -
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE app.review_decisions TO service_role;
GRANT SELECT ON TABLE app.review_decisions TO content_reviewer;


--
-- Name: TABLE rights_records; Type: ACL; Schema: app; Owner: -
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE app.rights_records TO service_role;
GRANT SELECT ON TABLE app.rights_records TO content_reviewer;


--
-- Name: TABLE source_records; Type: ACL; Schema: app; Owner: -
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE app.source_records TO service_role;
GRANT SELECT ON TABLE app.source_records TO content_reviewer;


--
-- Name: TABLE student_memory_events; Type: ACL; Schema: app; Owner: -
--

GRANT SELECT ON TABLE app.student_memory_events TO content_reviewer;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE app.student_memory_events TO service_role;


--
-- Name: TABLE student_memory_snapshots; Type: ACL; Schema: app; Owner: -
--

GRANT SELECT ON TABLE app.student_memory_snapshots TO content_reviewer;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE app.student_memory_snapshots TO service_role;


--
-- Name: TABLE subject_guidance_profiles; Type: ACL; Schema: app; Owner: -
--

GRANT SELECT ON TABLE app.subject_guidance_profiles TO content_reviewer;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE app.subject_guidance_profiles TO service_role;


--
-- Name: TABLE subjects; Type: ACL; Schema: app; Owner: -
--

GRANT SELECT ON TABLE app.subjects TO authenticated;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE app.subjects TO service_role;
GRANT SELECT ON TABLE app.subjects TO content_reviewer;


--
-- Name: TABLE validation_cases; Type: ACL; Schema: app; Owner: -
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE app.validation_cases TO service_role;
GRANT SELECT ON TABLE app.validation_cases TO content_reviewer;


--
-- Name: TABLE validation_results; Type: ACL; Schema: app; Owner: -
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE app.validation_results TO service_role;
GRANT SELECT ON TABLE app.validation_results TO content_reviewer;


--
-- Name: TABLE validation_runs; Type: ACL; Schema: app; Owner: -
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE app.validation_runs TO service_role;
GRANT SELECT ON TABLE app.validation_runs TO content_reviewer;


--
-- Name: TABLE validation_suites; Type: ACL; Schema: app; Owner: -
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE app.validation_suites TO service_role;
GRANT SELECT ON TABLE app.validation_suites TO content_reviewer;


--
-- Name: TABLE validator_entitlements; Type: ACL; Schema: app; Owner: -
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE app.validator_entitlements TO service_role;
GRANT SELECT ON TABLE app.validator_entitlements TO content_reviewer;


--
-- Name: TABLE validator_qualifications; Type: ACL; Schema: app; Owner: -
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE app.validator_qualifications TO service_role;
GRANT SELECT ON TABLE app.validator_qualifications TO content_reviewer;


--
-- Name: TABLE attempt_criterion_results; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.attempt_criterion_results TO authenticated;
GRANT ALL ON TABLE public.attempt_criterion_results TO service_role;


--
-- Name: TABLE attempts; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.attempts TO authenticated;
GRANT ALL ON TABLE public.attempts TO service_role;


--
-- Name: TABLE config; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.config TO authenticated;
GRANT ALL ON TABLE public.config TO service_role;


--
-- Name: TABLE content_item_labels; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.content_item_labels TO authenticated;
GRANT ALL ON TABLE public.content_item_labels TO service_role;


--
-- Name: TABLE content_item_versions; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.content_item_versions TO anon;
GRANT ALL ON TABLE public.content_item_versions TO authenticated;
GRANT ALL ON TABLE public.content_item_versions TO service_role;


--
-- Name: TABLE content_items; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.content_items TO authenticated;
GRANT ALL ON TABLE public.content_items TO service_role;


--
-- Name: TABLE content_labels; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.content_labels TO authenticated;
GRANT ALL ON TABLE public.content_labels TO service_role;


--
-- Name: TABLE content_review_assignments; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.content_review_assignments TO authenticated;
GRANT ALL ON TABLE public.content_review_assignments TO service_role;


--
-- Name: TABLE content_review_decisions; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.content_review_decisions TO authenticated;
GRANT ALL ON TABLE public.content_review_decisions TO service_role;


--
-- Name: TABLE dashboard_attention_v1; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.dashboard_attention_v1 TO authenticated;
GRANT ALL ON TABLE public.dashboard_attention_v1 TO service_role;


--
-- Name: TABLE dashboard_engagement_v1; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.dashboard_engagement_v1 TO authenticated;
GRANT ALL ON TABLE public.dashboard_engagement_v1 TO service_role;


--
-- Name: TABLE dashboard_overview_v1; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.dashboard_overview_v1 TO authenticated;
GRANT ALL ON TABLE public.dashboard_overview_v1 TO service_role;


--
-- Name: TABLE dashboard_pipeline_v1; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.dashboard_pipeline_v1 TO authenticated;
GRANT ALL ON TABLE public.dashboard_pipeline_v1 TO service_role;


--
-- Name: TABLE dashboard_quality_v1; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.dashboard_quality_v1 TO authenticated;
GRANT ALL ON TABLE public.dashboard_quality_v1 TO service_role;


--
-- Name: TABLE dashboard_subjects_v1; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.dashboard_subjects_v1 TO authenticated;
GRANT ALL ON TABLE public.dashboard_subjects_v1 TO service_role;


--
-- Name: TABLE exam_pack_versions; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.exam_pack_versions TO authenticated;
GRANT ALL ON TABLE public.exam_pack_versions TO service_role;


--
-- Name: TABLE exam_packs; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.exam_packs TO authenticated;
GRANT ALL ON TABLE public.exam_packs TO service_role;


--
-- Name: TABLE exam_specs; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.exam_specs TO anon;
GRANT ALL ON TABLE public.exam_specs TO authenticated;
GRANT ALL ON TABLE public.exam_specs TO service_role;


--
-- Name: TABLE frq_criteria; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.frq_criteria TO authenticated;
GRANT ALL ON TABLE public.frq_criteria TO service_role;


--
-- Name: TABLE grading_results; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.grading_results TO anon;
GRANT ALL ON TABLE public.grading_results TO authenticated;
GRANT ALL ON TABLE public.grading_results TO service_role;


--
-- Name: TABLE learning_sessions; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.learning_sessions TO authenticated;
GRANT ALL ON TABLE public.learning_sessions TO service_role;


--
-- Name: TABLE mcq_choices; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.mcq_choices TO authenticated;
GRANT ALL ON TABLE public.mcq_choices TO service_role;


--
-- Name: TABLE profiles; Type: ACL; Schema: public; Owner: -
--

GRANT SELECT,MAINTAIN ON TABLE public.profiles TO authenticated;
GRANT ALL ON TABLE public.profiles TO service_role;


--
-- Name: TABLE progress_snapshots; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.progress_snapshots TO authenticated;
GRANT ALL ON TABLE public.progress_snapshots TO service_role;


--
-- Name: TABLE questions; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.questions TO anon;
GRANT ALL ON TABLE public.questions TO authenticated;
GRANT ALL ON TABLE public.questions TO service_role;


--
-- Name: TABLE response_versions; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.response_versions TO authenticated;
GRANT ALL ON TABLE public.response_versions TO service_role;


--
-- Name: TABLE sessions; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.sessions TO anon;
GRANT ALL ON TABLE public.sessions TO authenticated;
GRANT ALL ON TABLE public.sessions TO service_role;


--
-- Name: TABLE student_attempts; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.student_attempts TO anon;
GRANT ALL ON TABLE public.student_attempts TO authenticated;
GRANT ALL ON TABLE public.student_attempts TO service_role;


--
-- Name: TABLE student_lock_queue; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.student_lock_queue TO anon;
GRANT ALL ON TABLE public.student_lock_queue TO authenticated;
GRANT ALL ON TABLE public.student_lock_queue TO service_role;


--
-- Name: TABLE subjects; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.subjects TO authenticated;
GRANT ALL ON TABLE public.subjects TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: app; Owner: -
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA app GRANT SELECT,USAGE ON SEQUENCES TO content_reviewer;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: app; Owner: -
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA app GRANT SELECT ON TABLES TO content_reviewer;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: -
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: -
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: -
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: -
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: -
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: -
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO service_role;


--
-- PostgreSQL database dump complete
--

\unrestrict Kl4mlZmDIxz3oCliWI55VDzEpghmcuVukscAM3d0dT5a1TPxdrB9cFPYBhoJMSm

