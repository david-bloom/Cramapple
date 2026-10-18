-- TASK-0077 release step (plan §8 slice 7), run once per environment AFTER:
--   1. migrations 20261018200000 and 20261018200100 are applied;
--   2. the four Vault entries named in 20261018200100 exist;
--   3. charge-due-trials and deliver-transactional-email are deployed with
--      their secrets.
-- Not a migration: applying migrations must never start charging.
select cron.schedule('task0077-charge-due-trials', '*/5 * * * *',
  'select app.invoke_charge_due_trials();');
select cron.schedule('task0077-deliver-transactional-email', '*/2 * * * *',
  'select app.invoke_deliver_transactional_email();');

-- Check (no secrets returned):
-- select jobname, schedule, active from cron.job where jobname like 'task0077-%';
-- select worker, last_run_at, last_summary from app.trial_worker_heartbeat;
