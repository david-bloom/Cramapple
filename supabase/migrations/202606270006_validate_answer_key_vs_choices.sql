-- Validate answer_key against actual mcq_choices on decision insert.
--
-- content_review_decisions.answer_key was a free-text CHECK IN ('A','B','C','D')
-- with no FK to mcq_choices. A reviewer could approve answer_key='B' for a
-- version that has no choice with choice_key='B'.
--
-- This trigger fires BEFORE INSERT on content_review_decisions and, when the
-- stage is 'tutor_answer' and both answer_key and content_item_version_id are
-- set, verifies that a matching mcq_choices row exists.
--
-- Skips validation when content_item_version_id is null (staging-only
-- assignment not yet promoted) — the check runs again if the reviewer
-- resubmits after promotion.

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
