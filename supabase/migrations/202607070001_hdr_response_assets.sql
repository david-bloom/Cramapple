-- HDR response asset metadata.
--
-- Records the Supabase Storage object path for photographed hand-drawn
-- responses, while keeping the actual image bytes in the private
-- content-assets bucket. Rows may start life linked to an ingest row and later
-- be backfilled to a promoted content_item_version.

begin;

create extension if not exists pgcrypto;

create table if not exists app.hdr_response_assets (
  hdr_response_asset_id uuid primary key default gen_random_uuid(),
  asset_key text not null,
  ingest_row_id uuid references app.content_ingest_rows(ingest_row_id) on delete set null,
  content_item_version_id uuid references app.content_item_versions(id) on delete set null,
  storage_bucket text not null default 'content-assets',
  object_path text not null,
  capture_version text not null,
  mime_type text,
  notes text,
  created_by uuid references app.profiles(user_id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint hdr_response_assets_bucket_check
    check (storage_bucket = 'content-assets'),
  constraint hdr_response_assets_link_check
    check (ingest_row_id is not null or content_item_version_id is not null),
  constraint hdr_response_assets_asset_key_check
    check (char_length(asset_key) between 1 and 200),
  constraint hdr_response_assets_capture_version_check
    check (char_length(capture_version) between 1 and 50),
  constraint hdr_response_assets_object_path_unique unique (object_path),
  constraint hdr_response_assets_asset_key_unique unique (asset_key)
);

create trigger hdr_response_assets_set_updated_at
before update on app.hdr_response_assets
for each row execute function app.set_updated_at();

create index if not exists hdr_response_assets_ingest_row_idx
  on app.hdr_response_assets (ingest_row_id)
  where ingest_row_id is not null;

create index if not exists hdr_response_assets_content_item_version_idx
  on app.hdr_response_assets (content_item_version_id)
  where content_item_version_id is not null;

alter table app.hdr_response_assets enable row level security;

create policy "hdr_response_assets_service_all"
on app.hdr_response_assets
for all
to service_role
using (true)
with check (true);

grant select, insert, update, delete on app.hdr_response_assets to service_role;

comment on table app.hdr_response_assets is
  'Sidecar metadata for photographed hand-drawn responses stored in Supabase Storage bucket content-assets. Each row records the object path plus an ingest-row and/or content-item-version link for HDR review and promotion workflows.';

commit;
