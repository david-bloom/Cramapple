-- Replace the wrong "one published item per exam pack version" index.
--
-- Migration 202606200005 created:
--   create unique index content_items_one_published_per_item
--     on app.content_items (exam_pack_version_id)
--     where status = 'published';
--
-- That enforced "at most one published row in app.content_items per
-- exam_pack_version_id" — i.e. only one published question per exam pack.
-- An exam pack has many published items, so this index blocks the second
-- publish attempt with a unique violation, surfacing as a 500 from
-- admin-content.
--
-- The intended guard is "at most one published version per content item":
-- a single app.content_items row may have many versions in app.content_item_versions
-- but only one of those versions should be in status = 'published' at a time.
-- Uniqueness of (exam_pack_version_id, content_key) at the content_items level
-- is already enforced by content_items_unique_key (202606200001_initial_app_schema.sql).

begin;

drop index if exists app.content_items_one_published_per_item;

create unique index if not exists content_item_versions_one_published_per_item
  on app.content_item_versions (content_item_id)
  where status = 'published';

commit;
