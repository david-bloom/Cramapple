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
