-- TASK-0048 Workstream 2 -- topic-level course position, tracked independently
-- from the existing unit-level source (a student can confirm their unit
-- while leaving the topic estimated, or vice versa). Mirrors the existing
-- unit_id/source consistency pattern exactly.

alter table app.student_course_positions
  add column topic_code text,
  add column topic_source text not null default 'unknown';

alter table app.student_course_positions
  add constraint student_course_positions_topic_source_check
    check (topic_source = any (array['confirmed', 'estimated', 'unknown']));

alter table app.student_course_positions
  add constraint student_course_positions_topic_unknown_check
    check (
      ((topic_code is null) and (topic_source = 'unknown'))
      or ((topic_code is not null) and (topic_source = any (array['confirmed', 'estimated'])))
    );

comment on column app.student_course_positions.topic_code is
  'Topic-level position within the confirmed/estimated unit, e.g. "5.3". '
  'Independent of unit_id/source -- a student can confirm their unit while '
  'leaving the topic estimated. Null means not yet set (topic_source is then '
  'always ''unknown'', enforced by student_course_positions_topic_unknown_check).';
comment on column app.student_course_positions.topic_source is
  'Same three-state vocabulary as source, tracked independently for topic_code.';
