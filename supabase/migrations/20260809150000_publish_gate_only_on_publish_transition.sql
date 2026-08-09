-- Bug found via a live reviewer-submission failure (Adil Abbasi, 2026-08-09):
-- POST /review-decision returned 500 "decision_insert_failed" while
-- submitting an ordinary tutor_question decision (an edit-note/ambiguity
-- flag) on an already-published item. Postgres logs showed the actual
-- cause: "publish_gate: status=published requires review_status in the
-- approved allowlist (...); got modification_reserved".
--
-- Root cause: the P0-B publish gate trigger
-- (20260808200000_publish_gate_review_status.sql,
-- 20260808201500_publish_gate_full_allowlist.sql) fires
-- `BEFORE INSERT OR UPDATE OF status, review_status` and checks
-- `NEW.status = 'published'` against the review_status allowlist on EVERY
-- such update -- including one that only touches review_status on a row
-- that is ALREADY published and staying published. That's the common case
-- for re-review/adjudication: a reviewer scores an already-published item
-- and the aggregate lands on "needs modification" or "recycle", and
-- advanceWorkflow (supabase/functions/review-decision/index.ts) tries to
-- set review_status='modification_reserved' on that version. NEW.status is
-- unchanged ('published'), but the trigger doesn't distinguish "just
-- published with a bad review_status" from "already published, only
-- review_status changing" -- it blocks both, inside the same transaction as
-- the content_review_decisions insert, so the whole decision insert rolls
-- back and the reviewer sees a generic 500.
--
-- Verified this is live and reproducible right now: Ahmed Ali alone has
-- ~200 pending tutor_question re-review assignments on items whose
-- content_item_versions.status is already 'published' (production query,
-- 2026-08-09) -- any of those that aggregates to modification_reserved (or
-- any reader_question recycle on a published item) hits this exact 500.
--
-- Fix: the gate's job is to stop content from being NEWLY published with a
-- bad review_status -- not to freeze review_status forever once published.
-- Only run the allowlist check on the actual transition into 'published'
-- (INSERT with status='published', or UPDATE where OLD.status IS DISTINCT
-- FROM 'published' AND NEW.status='published'). A row that is already
-- published and only having review_status updated is unaffected.

create or replace function app.enforce_publish_gate()
returns trigger
language plpgsql
as $$
begin
  if new.status = 'published'
     and (tg_op = 'INSERT' or old.status is distinct from 'published')
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
