-- Development only: removes exactly the rows scripts/qa/question_experience_dev_seed.sql created.
begin;
set local role service_role;
delete from app.content_item_comparison_answers where comparison_answer_id::text like 'a0a0a0a0-0000-4000-8000-%';
delete from app.grading_results where id::text like 'a0a0a0a0-0000-4000-8000-%' and request_id like 'qx-probe-%';
delete from app.response_versions where id::text like 'a0a0a0a0-0000-4000-8000-%';
delete from app.attempts where id::text like 'a0a0a0a0-0000-4000-8000-%';
delete from app.learning_sessions where id::text like 'a0a0a0a0-0000-4000-8000-%';  -- cascades learning_session_items
commit;
