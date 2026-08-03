-- Persist a learner-facing feedback preview alongside grading_results.
--
-- This keeps the feedback contract durable for audit, replay, and future UI
-- consumers that read directly from the grading ledger.

begin;

alter table app.grading_results
  add column if not exists feedback_preview text;

commit;
