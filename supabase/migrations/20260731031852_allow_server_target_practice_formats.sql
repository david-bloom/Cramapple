-- TASK-0019 stores the server-resolved route format on the session. Expand
-- the legacy FRQ-only constraint so consuming a valid MCQ/quantitative target
-- cannot fail after the target has already been marked consumed.
alter table app.learning_sessions
  drop constraint if exists learning_sessions_practice_format_check,
  add constraint learning_sessions_practice_format_check
  check (
    practice_format is null
    or practice_format in (
      'targeted_drill',
      'full_exam_frq',
      'mcq',
      'quantitative',
      'short_frq',
      'long_frq'
    )
  );
