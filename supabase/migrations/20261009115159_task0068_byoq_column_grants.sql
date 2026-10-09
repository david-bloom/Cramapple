-- TASK-0068 QA finding 2 (docs/qa/QA_TASK0068_BACKEND_2026_10_09.md):
-- `authenticated` held a table-level SELECT on app.byoq_items (own rows via RLS),
-- which silently included the new `extraction` (raw, unmasked proposal) and
-- `captured_work` columns over PostgREST. Neither may be read outside the byoq
-- function (plan §4.5). Replace the table grant with an explicit column list,
-- the same pattern used for mcq_choices (TASK-0056). The byoq function uses the
-- service role and is unaffected; the app never reads this table directly.

revoke select on table app.byoq_items from authenticated;

grant select (
  id, owner_id, user_id, code, item_type, title, stem, choices, subject_key,
  taxonomy_topic_id, difficulty, source_kind, source_note, status, leak_flags,
  created_at, updated_at, confirmed_at, last_practiced_at, context_unit_number
) on app.byoq_items to authenticated;

-- Belt and braces: no other app role may read these two columns either
-- (content_reviewer exists in Production but not in Development).
revoke select (extraction, captured_work) on app.byoq_items from anon;
do $$
begin
  if exists (select 1 from pg_roles where rolname = 'content_reviewer') then
    execute 'revoke select (extraction, captured_work) on app.byoq_items from content_reviewer';
  end if;
end $$;
