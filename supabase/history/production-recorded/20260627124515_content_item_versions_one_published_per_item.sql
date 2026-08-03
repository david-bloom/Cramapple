-- Exported from Production migration history (supabase_migrations.schema_migrations)
-- version: 20260627124515
-- recorded name: content_item_versions_one_published_per_item
-- statements: 1
-- This file is a faithful transcript of what Production actually ran.
-- Do not edit to "improve" it; corrections belong in a new forward migration.

-- Replace the wrong "one published item per exam pack version" index.

begin;

drop index if exists app.content_items_one_published_per_item;

create unique index if not exists content_item_versions_one_published_per_item
  on app.content_item_versions (content_item_id)
  where status = 'published';

commit;
