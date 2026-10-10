-- Development-only seed for public.get_question_experience probes. NEVER run against Production.
-- Every seeded row uses an a0a0a0a0-… id (or a qx-probe- request id) so
-- scripts/qa/question_experience_dev_teardown.sql removes exactly these rows.
--
-- Student: cda34c9d-80f3-43bb-b359-8413bad3ee2e (Dev student profile).
-- S1 (FRQ fixtures, exam pack 16000000-…-003):
--   #1 FRQ …-202: attempt 1 graded 0/1 (not_yet_earned), attempt 2 graded 1/1 (earned) -> pointsChange 'gained';
--      comparison answers: full_credit published, common_mistake unpublished, vague absent.
--   #2 FRQ …-204: draft attempt, not submitted -> resume 'continue_draft'; comparison content locked.
--   #3 FRQ …-205: no attempt.
-- S2 (AP Statistics MCQs, topic 1.5, has published reference entries):
--   #1 MCQ b3bd1255…: no attempt -> resume 'start_item'; reference grouped by kind; choices without truth.
--   #2 MCQ 44af54c9…: graded correct -> mcqFeedback present.
-- S3 (same FRQ pack): session with zero items -> resume 'no_items', counter null.

begin;
set local role service_role;

insert into app.learning_sessions (id, user_id, exam_pack_version_id, entry_path, session_mode, available_minutes, status, started_at)
values
  ('a0a0a0a0-0000-4000-8000-000000000001', 'cda34c9d-80f3-43bb-b359-8413bad3ee2e', '16000000-0000-4000-8000-000000000003', 'self_guided_format', 'focused', 20, 'active', now() - interval '2 hours'),
  ('a0a0a0a0-0000-4000-8000-000000000002', 'cda34c9d-80f3-43bb-b359-8413bad3ee2e', '4e54bb4f-695f-41be-ac06-745fe9ad8bcc', 'topic', 'quick', 10, 'active', now() - interval '1 hour'),
  ('a0a0a0a0-0000-4000-8000-000000000003', 'cda34c9d-80f3-43bb-b359-8413bad3ee2e', '16000000-0000-4000-8000-000000000003', 'self_guided_format', 'quick', 10, 'active', now());

select app.append_learning_session_items('a0a0a0a0-0000-4000-8000-000000000001',
  array['16000000-0000-4000-8000-000000000202', '16000000-0000-4000-8000-000000000204', '16000000-0000-4000-8000-000000000205']::uuid[]);
-- Re-sent page: must not renumber or duplicate.
select app.append_learning_session_items('a0a0a0a0-0000-4000-8000-000000000001',
  array['16000000-0000-4000-8000-000000000204']::uuid[]);
select app.append_learning_session_items('a0a0a0a0-0000-4000-8000-000000000002',
  array['b3bd1255-e9e5-4541-a8aa-d20384691e92', '44af54c9-56d0-4226-ba67-7428557897f7']::uuid[]);

-- Attempts. Grading truth is written as service_role (the trigger's rule), at insert.
insert into app.attempts (id, user_id, learning_session_id, exam_pack_version_id, content_item_version_id, attempt_mode, status, assistance_state,
                          started_at, submitted_at, graded_at, score_points, score_possible, confidence_level, result_state, result_summary)
values
  ('a0a0a0a0-0000-4000-8000-000000000101', 'cda34c9d-80f3-43bb-b359-8413bad3ee2e', 'a0a0a0a0-0000-4000-8000-000000000001', '16000000-0000-4000-8000-000000000003',
   '16000000-0000-4000-8000-000000000202', 'frq', 'graded', 'independent', now() - interval '110 minutes', now() - interval '105 minutes', now() - interval '104 minutes',
   0, 1, 'high', 'graded', 'You earned 0 of 1 point.'),
  ('a0a0a0a0-0000-4000-8000-000000000102', 'cda34c9d-80f3-43bb-b359-8413bad3ee2e', 'a0a0a0a0-0000-4000-8000-000000000001', '16000000-0000-4000-8000-000000000003',
   '16000000-0000-4000-8000-000000000202', 'frq', 'graded', 'independent', now() - interval '100 minutes', now() - interval '95 minutes', now() - interval '94 minutes',
   1, 1, 'high', 'graded', 'You earned 1 of 1 point.'),
  ('a0a0a0a0-0000-4000-8000-000000000103', 'cda34c9d-80f3-43bb-b359-8413bad3ee2e', 'a0a0a0a0-0000-4000-8000-000000000001', '16000000-0000-4000-8000-000000000003',
   '16000000-0000-4000-8000-000000000204', 'frq', 'draft', 'independent', now() - interval '90 minutes', null, null, null, null, null, null, null),
  ('a0a0a0a0-0000-4000-8000-000000000104', 'cda34c9d-80f3-43bb-b359-8413bad3ee2e', 'a0a0a0a0-0000-4000-8000-000000000002', '4e54bb4f-695f-41be-ac06-745fe9ad8bcc',
   '44af54c9-56d0-4226-ba67-7428557897f7', 'mcq', 'graded', 'independent', now() - interval '50 minutes', now() - interval '49 minutes', now() - interval '49 minutes',
   1, 1, 'high', 'graded', 'Correct.');

insert into app.response_versions (id, attempt_id, response_text, response_parts, version_number, is_submitted, submitted_at)
values
  ('a0a0a0a0-0000-4000-8000-000000000201', 'a0a0a0a0-0000-4000-8000-000000000101', 'The median is larger.', '{}'::jsonb, 1, true, now() - interval '105 minutes'),
  ('a0a0a0a0-0000-4000-8000-000000000202', 'a0a0a0a0-0000-4000-8000-000000000102', 'The median (12 min) exceeds the mean (10 min) because of left skew.', '{}'::jsonb, 1, true, now() - interval '95 minutes'),
  ('a0a0a0a0-0000-4000-8000-000000000203', 'a0a0a0a0-0000-4000-8000-000000000103', 'Draft in progress', '{}'::jsonb, 1, false, null),
  ('a0a0a0a0-0000-4000-8000-000000000204', 'a0a0a0a0-0000-4000-8000-000000000104',
   (select choice_key from app.mcq_choices where content_item_version_id = '44af54c9-56d0-4226-ba67-7428557897f7' and is_correct limit 1),
   '{}'::jsonb, 1, true, now() - interval '49 minutes');

insert into app.grading_results (id, request_id, request_hash, attempt_id, response_version_id, operation, status, points_earned, points_available,
                                 criterion_results, confidence, model_id, prompt_version, feedback_preview, action_hint, created_at)
values
  ('a0a0a0a0-0000-4000-8000-000000000301', 'qx-probe-101', 'qx-probe-101', 'a0a0a0a0-0000-4000-8000-000000000101', 'a0a0a0a0-0000-4000-8000-000000000201',
   'grade_initial_attempt', 'graded', 0, 1,
   '[{"criterion_key":"criterion_1","status":"not_yet_earned","points_awarded":0,"evidence_quote":"The median is larger.","decision_explanation":"Names a comparison but gives no values.","minimum_fix":"State both values."}]'::jsonb,
   'high', 'qx-probe-seed', 'v1.0.0', 'Add the values.', 'State both the median and the mean.', now() - interval '104 minutes'),
  ('a0a0a0a0-0000-4000-8000-000000000302', 'qx-probe-102', 'qx-probe-102', 'a0a0a0a0-0000-4000-8000-000000000102', 'a0a0a0a0-0000-4000-8000-000000000202',
   'grade_initial_attempt', 'graded', 1, 1,
   '[{"criterion_key":"criterion_1","status":"earned","points_awarded":1,"evidence_quote":"The median (12 min) exceeds the mean (10 min)","decision_explanation":"Both values given and compared.","minimum_fix":null}]'::jsonb,
   'high', 'qx-probe-seed', 'v1.0.0', 'Full credit.', null, now() - interval '94 minutes'),
  ('a0a0a0a0-0000-4000-8000-000000000303', 'qx-probe-104', 'qx-probe-104', 'a0a0a0a0-0000-4000-8000-000000000104', 'a0a0a0a0-0000-4000-8000-000000000204',
   'grade_initial_attempt', 'graded', 1, 1, '[]'::jsonb, 'high', 'qx-probe-seed', 'v1.0.0', 'Correct.', null, now() - interval '49 minutes');

insert into app.content_item_comparison_answers (comparison_answer_id, content_item_version_id, variant, response_text, explanation, is_published, source_note)
values
  ('a0a0a0a0-0000-4000-8000-000000000401', '16000000-0000-4000-8000-000000000202', 'full_credit',
   'The median commute (12 minutes) is greater than the mean (10 minutes).', 'States both values and compares them.', true, 'qx-probe-seed'),
  ('a0a0a0a0-0000-4000-8000-000000000402', '16000000-0000-4000-8000-000000000202', 'common_mistake',
   'The mean is bigger because there are outliers.', 'Reverses the comparison and gives no values.', false, 'qx-probe-seed');

commit;
