-- Widen app.learning_sessions.entry_path to accept the frontend's real
-- EntryPath values ('recommendation', 'self_guided_topic',
-- 'self_guided_format'), alongside the existing four.
--
-- Every real session-start has been failing: the frontend's SessionContract
-- (src/lib/session-contract.ts, exam-buddy-wireframe) has only ever sent
-- 'recommendation' | 'self_guided_topic' | 'self_guided_format', which never
-- matched this constraint's 'recommend' | 'topic' | 'check_work' |
-- 'bring_question' -- every insert violated the CHECK and session-event
-- returned a 400 ("session_start_failed"), for every entry path, for every
-- student. The four original values match a separate, apparently-unused
-- legacy `sessions` table's own entry_path constraint
-- (sessions_entry_path_check) -- session-event was migrated to
-- learning_sessions at some point and the frontend was never updated to
-- match its constraint.
--
-- Additive only: existing rows and the four original values remain valid.

alter table app.learning_sessions
  drop constraint learning_sessions_entry_path_check;

alter table app.learning_sessions
  add constraint learning_sessions_entry_path_check
  check (entry_path = any (array[
    'recommend',
    'topic',
    'check_work',
    'bring_question',
    'recommendation',
    'self_guided_topic',
    'self_guided_format'
  ]));
