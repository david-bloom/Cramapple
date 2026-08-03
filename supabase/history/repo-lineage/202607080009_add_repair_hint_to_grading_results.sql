-- Persist the actionable repair hint for uncertain grading outcomes.
--
-- This keeps the next-step guidance durable for audit, replay, and future UI
-- consumers that read directly from the grading ledger.

begin;

alter table app.grading_results
  add column if not exists repair_hint text;

commit;
