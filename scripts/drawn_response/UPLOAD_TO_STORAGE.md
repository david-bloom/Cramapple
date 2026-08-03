# Uploading drawn-response reference images to Supabase Storage

This corpus (180 PNGs — 20 + 160, ~40 MiB) used to be committed directly
into git. It
now lives in the `validation-artifacts` Storage bucket on Production
(`pcntajvbdfqhbeewmdry`) instead — that bucket already exists with
service-role-only RLS policies (see
`supabase/migrations/202606200002_storage_buckets_and_policies.sql`), so no
new bucket or policy work is needed, only the upload.

`prompts/DRG_P1_REFERENCE_IMAGES_assets/` and
`docs/research/DRAWN_RESPONSE_FRQs_v1.1_images/` are now gitignored — the
files are regenerable (see the two generator scripts in this directory) or,
for this one-time migration, already extracted to a local staging directory
by the session that did this move:
`/private/tmp/pr46-storage-staging/` (`drg_p1_reference_images/` — 20
files, `drawn_response_frqs_v1_1_images/` — 160 files). That staging
directory is outside git and outside this repo (and is temporary — it may
not survive a reboot); copy the two subfolders' contents back into the
paths above before running the upload script, or regenerate them fresh
instead.

## Steps

1. Get the 207 PNGs onto disk at their original repo-relative paths:
   ```
   cp /private/tmp/pr46-storage-staging/drg_p1_reference_images/*.png \
     prompts/DRG_P1_REFERENCE_IMAGES_assets/
   cp /private/tmp/pr46-storage-staging/drawn_response_frqs_v1_1_images/*.png \
     docs/research/DRAWN_RESPONSE_FRQs_v1.1_images/
   ```
   (Both directories are gitignored, so this won't create anything to commit.)

2. Get a Production service-role key (Supabase dashboard → Project Settings
   → API → `service_role` secret key — **never** commit this or put it in a
   tracked file).

3. Run the upload script:
   ```
   SUPABASE_URL=https://pcntajvbdfqhbeewmdry.supabase.co \
   SUPABASE_SERVICE_ROLE_KEY=<paste service_role key> \
     node scripts/drawn_response/upload_reference_images_to_storage.mjs
   ```

4. Verify the count landed in Storage:
   ```sql
   select count(*) from storage.objects
   where bucket_id = 'validation-artifacts'
     and name like 'drawn-response-reference-images/%';
   -- expect 180
   ```

5. Once confirmed, the local PNGs can be deleted from disk — they're
   gitignored, so this doesn't touch git history. The staging directory at
   `/private/tmp/pr46-storage-staging/` can also be deleted after this.

## Where the paths map to

| Local (gitignored)                                        | Storage path                                                        |
|-------------------------------------------------------------|-----------------------------------------------------------------------|
| `prompts/DRG_P1_REFERENCE_IMAGES_assets/<file>.png`          | `validation-artifacts/drawn-response-reference-images/drg-p1/<file>.png` |
| `docs/research/DRAWN_RESPONSE_FRQs_v1.1_images/<file>.png`   | `validation-artifacts/drawn-response-reference-images/drg-p2/<file>.png` |

`prompts/DRG_P1_REFERENCE_IMAGES.md` references these paths as text (not
markdown image embeds — the bucket is private, so a plain `![]()` embed
would never render); regenerate that doc via
`generate_drg_p1_reference_images.py` if the corpus changes.
