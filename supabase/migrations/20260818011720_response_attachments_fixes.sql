-- TASK-0025 QA review (2026-08-17) fixes for
-- 20260815130526_response_attachments.sql. Confirmed correctness bugs
-- fixed at the DB layer:
--
-- 1. attach_capture's retake path inserted the new current-original row
--    BEFORE flipping the prior current row's is_current to false -- two
--    separate, sequential edge-function round-trips against a plain
--    (non-deferrable) unique index that permits only one current original
--    per response_version. Every real retake hit unique_violation. Fixed by
--    moving the supersede-then-insert sequence into a single atomic
--    Postgres function (this migration), called via RPC from the edge
--    function instead of two separate client calls. A `for update` row lock
--    on the prior current row also closes a second, previously-unflagged
--    race: two concurrent attach_capture calls for the same response
--    version can no longer both observe "no current row" and both insert an
--    "original".
--
-- 1b. attempt-response's record_manual_grade operation had no lock/
--    precondition stopping it from racing evaluate-attempt (the automated
--    grading path) for the same attempt -- whichever finished last silently
--    clobbered the other's grade. Fixed by moving the claim (attempts
--    status: submitted -> graded) and the grading_results insert into one
--    atomic function, with the claim conditioned on status = 'submitted'.
--
-- 2. response_attachments' documented "rows are never deleted" invariant
--    (see the table comment in 20260815130526) was enforced by a BEFORE
--    UPDATE trigger only -- DELETE was ungoverned, service_role had DELETE
--    granted, and parent-row deletes cascade. This deviated from this
--    codebase's own precedent (content_review_decisions_immutable guards
--    BEFORE DELETE OR UPDATE). Fixed by extending the trigger to also fire
--    on DELETE (unconditionally rejecting it) and revoking the DELETE grant.
--
-- Two further findings from the same review are fixed in application code,
-- not here: attach_capture's storage-object TOCTOU race (a freshness check
-- immediately before the bind call, in attempt-response/index.ts) and
-- record_manual_grade's missing growth-event/mastery-memory side effects
-- (attempt-response/index.ts now calls the same recordGrowthEvent /
-- persistGradingMemory-equivalent path evaluate-attempt uses).

begin;

-- Fix 1: atomic supersede-then-insert, replacing the edge function's
-- separate select-then-insert-then-update sequence. Mirrors the JS
-- planAttachmentInsert() validation (supabase/functions/_shared/
-- capture-attachment.ts) so the same reasons are reported, but this is now
-- the authoritative, race-proof enforcement -- the JS function remains only
-- as an early-exit fast path so a client fed an obviously-invalid retake
-- gets a cheap rejection without touching the database.
create function app.bind_response_attachment(
  p_response_version_id uuid,
  p_attempt_id uuid,
  p_content_item_version_id uuid,
  p_kind text,
  p_replaces_attachment_id uuid,
  p_storage_path text,
  p_media_type text,
  p_byte_size integer,
  p_pixel_width integer,
  p_pixel_height integer,
  p_sha256_digest text,
  p_captured_by uuid
)
returns app.response_attachments
language plpgsql
security definer
set search_path = 'app', 'public'
as $$
declare
  v_prior_current_id uuid;
  v_new_row app.response_attachments;
begin
  if p_kind = 'original' then
    -- Lock any existing current original for this response_version so a
    -- second concurrent call for the same response_version blocks here
    -- instead of both racing past the is_current=true check below.
    select id into v_prior_current_id
    from app.response_attachments
    where response_version_id = p_response_version_id
      and kind = 'original'
      and is_current
    for update;

    if p_replaces_attachment_id is not null then
      if v_prior_current_id is null then
        raise exception using errcode = 'P0001',
          message = 'attach_capture:no_current_original_to_replace';
      end if;
      if v_prior_current_id is distinct from p_replaces_attachment_id then
        raise exception using errcode = 'P0001',
          message = 'attach_capture:stale_retake_target';
      end if;
    else
      if v_prior_current_id is not null then
        raise exception using errcode = 'P0001',
          message = 'attach_capture:original_already_current';
      end if;
    end if;

    if v_prior_current_id is not null then
      -- Supersede BEFORE inserting the new current row -- the ordering bug
      -- this migration fixes -- and in the same transaction as the insert
      -- below, so a failure either way rolls back both.
      update app.response_attachments
        set is_current = false
        where id = v_prior_current_id;
    end if;
  elsif p_replaces_attachment_id is not null then
    raise exception using errcode = 'P0001',
      message = 'attach_capture:derived_cannot_replace';
  end if;

  insert into app.response_attachments (
    response_version_id, attempt_id, content_item_version_id, kind,
    replaces_attachment_id, is_current, storage_path, media_type,
    byte_size, pixel_width, pixel_height, sha256_digest, captured_by
  ) values (
    p_response_version_id, p_attempt_id, p_content_item_version_id, p_kind,
    p_replaces_attachment_id, p_kind = 'original', p_storage_path,
    p_media_type, p_byte_size, p_pixel_width, p_pixel_height,
    p_sha256_digest, p_captured_by
  )
  returning * into v_new_row;

  return v_new_row;
end;
$$;

comment on function app.bind_response_attachment is
  'Atomically supersedes the prior current original (if any) and inserts the new response_attachments row in one transaction, with a row lock preventing two concurrent retakes for the same response_version. Called by attempt-response''s attach_capture operation instead of separate insert/update calls. See TASK-0025 QA review 2026-08-17.';

-- security definer needs an explicit, narrow grant -- only service_role
-- calls this (attach_capture runs with the service client), matching the
-- table's own insert/update grants.
revoke all on function app.bind_response_attachment from public;
grant execute on function app.bind_response_attachment to service_role;

-- Fix 1b (attempt-response's record_manual_grade, same QA review): the
-- operation checked attempt.status once, then did an unguarded insert into
-- grading_results followed by an unconditional attempts update, with no
-- lock or precondition stopping it from racing evaluate-attempt (the
-- automated grading path) for the same attempt -- whichever finished last
-- silently won. Atomicize the claim: the attempts update is now
-- conditioned on status = 'submitted' and happens BEFORE the
-- grading_results insert, in the same transaction; if a concurrent
-- automated grade already moved the attempt off 'submitted', this raises
-- and nothing is written, instead of silently clobbering (or being
-- clobbered by) the other grade.
create function app.record_manual_grade(
  p_attempt_id uuid,
  p_response_version_id uuid,
  p_request_id text,
  p_request_hash text,
  p_criterion_results jsonb,
  p_points_earned integer,
  p_points_available integer,
  p_feedback_preview text
)
returns app.grading_results
language plpgsql
security definer
set search_path = 'app', 'public'
as $$
declare
  v_claimed_id uuid;
  v_grading_result app.grading_results;
begin
  update app.attempts
    set status = 'graded',
        graded_at = now(),
        score_points = p_points_earned,
        score_possible = p_points_available,
        confidence_level = 'high',
        result_state = 'graded',
        result_summary = p_feedback_preview
    where id = p_attempt_id
      and status = 'submitted'
    returning id into v_claimed_id;

  if v_claimed_id is null then
    raise exception using errcode = 'P0001',
      message = 'record_manual_grade:attempt_not_gradable';
  end if;

  insert into app.grading_results (
    request_id, request_hash, attempt_id, response_version_id, operation,
    status, points_earned, points_available, criterion_results, confidence,
    model_id, prompt_version, feedback_preview
  ) values (
    p_request_id, p_request_hash, p_attempt_id, p_response_version_id,
    'grade_initial_attempt', 'graded', p_points_earned, p_points_available,
    p_criterion_results, 'high', 'manual-review', 'manual-v1',
    p_feedback_preview
  )
  returning * into v_grading_result;

  return v_grading_result;
end;
$$;

comment on function app.record_manual_grade is
  'Atomically claims an attempt (attempts.status conditioned on submitted -> graded) and inserts its grading_results row in one transaction, so this pilot''s human-grading path and evaluate-attempt''s automated path cannot silently overwrite each other''s grade for the same attempt. See TASK-0025 QA review 2026-08-17.';

revoke all on function app.record_manual_grade from public;
grant execute on function app.record_manual_grade to service_role;

-- Fix 2: DELETE was ungoverned -- extend the existing immutability trigger
-- to also fire BEFORE DELETE and unconditionally reject it (rows are
-- retake-superseded via is_current, never removed), and revoke the DELETE
-- grant added in 20260815130526 now that nothing should use it.
create or replace function app.response_attachments_guard_immutable_fields()
returns trigger
language plpgsql
as $$
begin
  if tg_op = 'DELETE' then
    raise exception 'response_attachments: rows are never deleted (row %); retakes supersede via is_current instead', old.id;
  end if;

  if new.response_version_id is distinct from old.response_version_id
    or new.attempt_id is distinct from old.attempt_id
    or new.content_item_version_id is distinct from old.content_item_version_id
    or new.kind is distinct from old.kind
    or new.replaces_attachment_id is distinct from old.replaces_attachment_id
    or new.storage_bucket is distinct from old.storage_bucket
    or new.storage_path is distinct from old.storage_path
    or new.media_type is distinct from old.media_type
    or new.byte_size is distinct from old.byte_size
    or new.pixel_width is distinct from old.pixel_width
    or new.pixel_height is distinct from old.pixel_height
    or new.sha256_digest is distinct from old.sha256_digest
    or new.captured_by is distinct from old.captured_by
    or new.created_at is distinct from old.created_at
  then
    raise exception 'response_attachments: only capture_quality_state, is_current, and reviewed_at may change after insert (row %)', old.id;
  end if;
  return new;
end;
$$;

drop trigger if exists response_attachments_guard_immutable on app.response_attachments;
create trigger response_attachments_guard_immutable
  before update or delete on app.response_attachments
  for each row execute function app.response_attachments_guard_immutable_fields();

revoke delete on table app.response_attachments from service_role;

commit;
