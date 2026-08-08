-- Correction to 20260808200000_publish_gate_review_status.sql, caught by
-- Vercel Agent Review on PR #73 before merge.
--
-- The prior migration's allowlist was too narrow: it only allowed
-- review_status='question_review_approved'. But
-- app.content_item_versions_review_status_check (schema baseline) and the
-- pre-existing ready_to_ship_versions_count computation both already treat
-- FOUR review_status values as terminal-approved:
--   'question_review_approved', 'difficulty_confirmed', 'answer_approved',
--   'mcq_answer_review_complete'
-- (the latter three cover the difficulty-discussion-resolved path and the
-- MCQ answer-review path the schema anticipated, distinct from
-- question_review_approved which the review-decision edge function's
-- comments suggest was meant to be FRQ-specific).
--
-- Verified before writing this fix: none of the 130 items retired earlier
-- this session (docs/activity_log/ACTIVITY_LOG.md, 2026-08-08) had any of
-- the three added statuses, so that retirement pass was not affected by
-- this gap -- this migration only widens the gate going forward.

create or replace function app.enforce_publish_gate()
returns trigger
language plpgsql
as $$
begin
  if new.status = 'published'
     and (new.review_status is null or new.review_status not in (
       'question_review_approved',
       'difficulty_confirmed',
       'answer_approved',
       'mcq_answer_review_complete'
     ))
  then
    raise exception
      'publish_gate: status=published requires review_status in the approved allowlist (question_review_approved, difficulty_confirmed, answer_approved, mcq_answer_review_complete); got %',
      coalesce(new.review_status, 'NULL')
      using errcode = 'P0001';
  end if;
  return new;
end;
$$;
