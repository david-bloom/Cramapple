-- Exported from Production migration history (supabase_migrations.schema_migrations)
-- version: 20260722143147
-- recorded name: lock_content_review_submission
-- statements: 1
-- This file is a faithful transcript of what Production actually ran.
-- Do not edit to "improve" it; corrections belong in a new forward migration.

-- Make reviewer submission and assignment locking one atomic database action.
--
-- The Edge Function previously inserted an immutable decision and only then
-- issued a separate best-effort assignment update. Concurrent retries could
-- therefore create multiple decisions for one assignment, and an update
-- failure could leave a recorded decision attached to an unlocked assignment.

begin;

create or replace function app.lock_content_review_submission()
returns trigger
language plpgsql
security invoker
set search_path = ''
as $$
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

revoke execute on function app.lock_content_review_submission()
  from public, anon, authenticated;

drop trigger if exists content_review_submission_lock
  on app.content_review_decisions;

create trigger content_review_submission_lock
before insert on app.content_review_decisions
for each row execute function app.lock_content_review_submission();

comment on function app.lock_content_review_submission() is
  'Serializes one immutable review decision per assignment and atomically marks the assignment submitted.';

commit;
