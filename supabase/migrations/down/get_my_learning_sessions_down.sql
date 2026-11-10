-- Down script for 20261109221340_get_my_learning_sessions.sql. Development only
-- unless separately approved.
begin;
drop function if exists public.get_my_learning_sessions(text, integer);
delete from supabase_migrations.schema_migrations where name = 'get_my_learning_sessions';
commit;
