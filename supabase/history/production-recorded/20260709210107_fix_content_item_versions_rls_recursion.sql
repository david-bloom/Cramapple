-- Exported from Production migration history (supabase_migrations.schema_migrations)
-- version: 20260709210107
-- recorded name: fix_content_item_versions_rls_recursion
-- statements: 1
-- This file is a faithful transcript of what Production actually ran.
-- Do not edit to "improve" it; corrections belong in a new forward migration.

-- Fix: app.content_item_versions_select_published and app.content_items policies
-- referenced each other's tables directly, causing "infinite recursion detected
-- in policy for relation content_item_versions" for real authenticated (non
-- service-role) reads. Break the cycle with a SECURITY DEFINER helper that
-- bypasses content_items' RLS (table is owned by postgres, no FORCE RLS, so a
-- definer function owned by postgres reads it directly without re-triggering
-- content_items' own policies).

create or replace function app.content_item_is_published(p_content_item_id uuid)
returns boolean
language sql
stable
security definer
set search_path = app, pg_temp
as $$
  select exists (
    select 1
    from app.content_items ci
    join app.exam_pack_versions epv
      on epv.id = ci.exam_pack_version_id
    where ci.id = p_content_item_id
      and ci.status = 'published'
      and epv.status = 'published'
  );
$$;

revoke all on function app.content_item_is_published(uuid) from public;
grant execute on function app.content_item_is_published(uuid) to authenticated, service_role;

drop policy if exists content_item_versions_select_published on app.content_item_versions;

create policy content_item_versions_select_published
on app.content_item_versions
for select
to authenticated
using (
  status = 'published'
  and app.content_item_is_published(content_item_id)
);
