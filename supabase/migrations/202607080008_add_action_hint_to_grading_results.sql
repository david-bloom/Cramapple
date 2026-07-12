-- Persist the action hint that accompanies uncertain grading outcomes.
--
-- This keeps the scaffold/help signal durable for audit, replay, and future UI
-- consumers that read directly from the grading ledger.

begin;

alter table app.grading_results
  add column if not exists action_hint text;

commit;
