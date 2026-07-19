-- Add a storage reference for a stimulus reference image on content items.
--
-- No column anywhere in the app schema could reference an image/asset for a
-- content item before this -- stimulus was text-only. Confirmed live on
-- Production (2026-07-12): storage.objects was completely empty across
-- every bucket, and the reviewer portal frontend only ever rendered
-- artifact.stimulus as plain text, with no <img> or chart-rendering path.
-- This is the minimal fix: a single nullable storage-path reference per
-- content_item_versions row, populated for items whose stimulus text
-- describes a graph/diagram but gives no underlying data (i.e. genuinely
-- needs an image, as opposed to items that fully embed their data as text
-- and are answerable without one).
--
-- Path convention: content-assets/biology/frq/<content_key>.png (bucket is
-- private; access via storage-sign-url, not a public URL).

begin;

alter table app.content_item_versions
  add column if not exists stimulus_image_path text;

commit;
