-- Exported from Production migration history (supabase_migrations.schema_migrations)
-- version: 20260628193942
-- recorded name: validate_answer_key_vs_choices
-- statements: 1
-- This file is a faithful transcript of what Production actually ran.
-- Do not edit to "improve" it; corrections belong in a new forward migration.

create or replace function app.validate_decision_answer_key()
returns trigger
language plpgsql
as $$
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

create trigger content_review_decisions_validate_answer_key
before insert on app.content_review_decisions
for each row execute function app.validate_decision_answer_key();
