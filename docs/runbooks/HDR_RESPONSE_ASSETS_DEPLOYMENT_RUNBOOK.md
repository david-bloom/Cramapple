# HDR Response Assets Deployment Runbook

**Target project:** `pcntajvbdfqhbeewmdry`  
**Purpose:** Apply the HDR response asset metadata change and verify the
promotion backfill path.

## What ships

- `supabase/migrations/202607070001_hdr_response_assets.sql`
- `supabase/functions/admin-content/index.ts`

## Exact SQL

Use the migration file as written. It creates:

- `app.hdr_response_assets`
- a `content-assets`-only bucket constraint
- service-role-only access
- lookup indexes for `ingest_row_id` and `content_item_version_id`

Do not edit the SQL during application unless a live database constraint
forces a targeted adjustment.

## Apply steps

1. Open the target Supabase project `pcntajvbdfqhbeewmdry`.
2. Apply `supabase/migrations/202607070001_hdr_response_assets.sql` in a
   single transaction.
3. Deploy the updated `admin-content` edge function so promotion backfills
   `content_item_version_id` into `app.hdr_response_assets` rows that are still
   linked only by `ingest_row_id`.

## Verification queries

Run these after the migration is applied:

```sql
select
  hdr_response_asset_id,
  asset_key,
  ingest_row_id,
  content_item_version_id,
  storage_bucket,
  object_path,
  capture_version
from app.hdr_response_assets
order by created_at desc
limit 20;
```

```sql
select count(*) as invalid_rows
from app.hdr_response_assets
where storage_bucket <> 'content-assets'
   or (ingest_row_id is null and content_item_version_id is null);
```

If there are already staged HDR rows, promote one through `admin-content` and
confirm the matching `hdr_response_assets` row receives the promoted
`content_item_version_id`.

## Expected behavior after deployment

- New HDR photos can be stored in the private `content-assets` bucket.
- HDR photo metadata stays queryable in Supabase.
- Promotion of a staged artifact backfills both review assignments and HDR
  response asset rows to the promoted content item version.
