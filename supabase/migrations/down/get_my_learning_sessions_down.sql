-- Down script for get_my_learning_sessions (Development ledger 20261109221340;
-- Production ledger 20261110022041). Production rollback needs separate approval.
begin;
drop function if exists public.get_my_learning_sessions(text, integer);
delete from supabase_migrations.schema_migrations where name = 'get_my_learning_sessions';
commit;
