-- Review schema stabilization for the reviewer/submissions surface.
--
-- Root issue:
-- - The deployed UI has been drifting between the older governance tables
--   (`review_assignments` / `review_decisions`) and the newer UX-002 review
--   tables (`content_review_assignments` / `content_review_decisions`).
-- - Some live queries still expect `difficulty_label` on `review_decisions`.
-- - Some live queries still project `content_key` from `content_items`.
-- - A recursive RLS policy on `review_decisions` can deadlock the table when
--   the UI or a nested select touches it through RLS.
--
-- This migration keeps the legacy table readable in a simple, non-recursive,
-- owner-scoped way and adds the compatibility column that the deployed UI has
-- been trying to read. The canonical UX-002 path should still use
-- `content_review_*` going forward.

begin;

-- Make the legacy governance table compatible with the deployed submissions UI.
alter table app.review_decisions
  add column if not exists difficulty_label text;

-- Ensure the content table still exposes the expected identifier in any live
-- environment that may have drifted from the canonical schema.
alter table app.content_items
  add column if not exists content_key text;

-- Remove any existing policies on the legacy table so a recursive policy
-- cannot survive across deployments or manual edits.
do $$
declare
  policy_name text;
begin
  for policy_name in
    select p.policyname
    from pg_policies p
    where p.schemaname = 'app'
      and p.tablename = 'review_decisions'
  loop
    execute format('drop policy if exists %I on app.review_decisions', policy_name);
  end loop;
end;
$$;

-- Keep the legacy table readable only to the row owner and writable only by
-- the row owner. The UI should not depend on this table for new flows, but if
-- it still reads it, the policy is now simple and non-recursive.
create policy "review_decisions_select_own"
  on app.review_decisions
  for select
  to authenticated
  using (created_by = auth.uid());

create policy "review_decisions_insert_own"
  on app.review_decisions
  for insert
  to authenticated
  with check (created_by = auth.uid());

grant select, insert on app.review_decisions to authenticated;

commit;
