-- Exported from Production migration history (supabase_migrations.schema_migrations)
-- version: 20260627124254
-- recorded name: attempt_guardrails_and_constraints
-- statements: 1
-- This file is a faithful transcript of what Production actually ran.
-- Do not edit to "improve" it; corrections belong in a new forward migration.

-- Additional guardrails for the production attempt/session schema.

begin;

create or replace function app.prevent_client_grading_truth_update()
returns trigger
language plpgsql
as $$
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

drop trigger if exists attempts_prevent_client_grading_truth_update on app.attempts;
create trigger attempts_prevent_client_grading_truth_update
before update on app.attempts
for each row execute function app.prevent_client_grading_truth_update();

create unique index if not exists content_items_one_published_per_item
  on app.content_items (exam_pack_version_id)
  where status = 'published';

create unique index if not exists mcq_choices_one_correct_per_version
  on app.mcq_choices (content_item_version_id)
  where is_correct;

create unique index if not exists attempt_responses_one_part_per_attempt
  on app.attempt_responses (attempt_id, part_key);

create unique index if not exists attempt_criterion_results_one_criterion_per_attempt
  on app.attempt_criterion_results (attempt_id, criterion_key);

create index if not exists attempts_learning_session_id_idx
  on app.attempts (learning_session_id);

create index if not exists profiles_role_idx
  on app.profiles (role);

commit;
