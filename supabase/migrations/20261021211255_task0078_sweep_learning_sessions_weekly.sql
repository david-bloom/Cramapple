-- TASK-0078 A9 (ruling 2, David 2026-10-21): weekly reaper for learning sessions
-- whose declared budget plus the grace window has elapsed.
-- app.sweep_learning_sessions(integer) exists since 20260821050000 and had no
-- invoker. Saturday 06:00 UTC = 01:00 EST / 02:00 EDT, overnight all year.
-- cron.schedule upserts by job name, so re-running this file is a no-op.
select cron.schedule(
  'task0078-sweep-learning-sessions',
  '0 6 * * 6',
  'select app.sweep_learning_sessions(120);'
);

comment on function app.sweep_learning_sessions(integer) is
  'Archives learning sessions whose available_minutes budget plus a grace window has elapsed. Scheduled weekly by pg_cron (task0078-sweep-learning-sessions, Saturday 06:00 UTC) since 2026-10-21. Counterpart to app.sweep_session_targets().';
