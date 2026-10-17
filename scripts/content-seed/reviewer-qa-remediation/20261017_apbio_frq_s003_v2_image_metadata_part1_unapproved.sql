-- APBIO-FRQ-S-003 v2 (draft from APPROVAL-0189): version-matched image metadata, PART 1 of 2 (UNAPPROVED rows only).
-- Drafted 2026-10-17; NOT YET EXECUTED. Follow-up to APPROVAL-0190 (PR #483), which approved metadata for v1 only.
-- v2 reuses the exact corrected image v1 now points to, so alt text and long description are COPIED from v1's
-- already-approved row (no new wording). This part writes approved_by/approved_at = NULL, so the image gate still
-- withholds v2; it records no approval and publishes nothing. PART 2 (owner-run) approves it.
-- Rehearse by replacing the final `commit;` with `rollback;`.
begin;
set local lock_timeout='3s';
set local statement_timeout='20s';
do $guard$
declare v2 app.content_item_versions%rowtype; v1 app.content_item_versions%rowtype;
begin
  select * into strict v2 from app.content_item_versions where id='bf317c96-1289-4803-b71f-b0aff4620844' for update;
  select * into strict v1 from app.content_item_versions where id='c4da3229-8d7a-4cf9-8738-68b62af20372' for update;
  if v2.status<>'draft' or v2.version_num<>v1.version_num+1 or v2.content_item_id<>v1.content_item_id then raise exception 'v2 is not the expected draft successor of v1'; end if;
  if v2.prompt_json->>'qa_remediation' not like '%APPROVAL-0189%' then raise exception 'v2 is not the APPROVAL-0189 draft'; end if;
  if v2.stimulus_image_path is distinct from v1.stimulus_image_path then raise exception 'v1 and v2 image paths differ; do not reuse v1 metadata'; end if;
  if exists(select 1 from app.content_asset_metadata where content_item_version_id=v2.id) then raise exception 'v2 already has metadata'; end if;
  if exists(select 1 from app.content_visual_requirements where content_item_version_id=v2.id) then raise exception 'v2 already has a visual decision'; end if;
  if not exists(select 1 from app.content_asset_metadata a where a.content_item_version_id=v1.id and a.storage_bucket='content-assets' and a.storage_path=v1.stimulus_image_path and a.approved_at is not null and nullif(btrim(a.alt_text),'') is not null) then raise exception 'v1 approved metadata not found to copy'; end if;
  if not exists(select 1 from storage.objects o join storage.buckets b on b.id=o.bucket_id where o.bucket_id='content-assets' and o.name=v2.stimulus_image_path and b.public is false and o.metadata->>'mimetype'='image/png') then raise exception 'private image object absent or changed'; end if;
end $guard$;

insert into app.content_asset_metadata (content_item_version_id,storage_bucket,storage_path,alt_text,long_description,approved_by,approved_at)
select 'bf317c96-1289-4803-b71f-b0aff4620844'::uuid, a.storage_bucket, a.storage_path, a.alt_text, a.long_description, null, null
from app.content_asset_metadata a where a.content_item_version_id='c4da3229-8d7a-4cf9-8738-68b62af20372' and a.storage_path=(select stimulus_image_path from app.content_item_versions where id='bf317c96-1289-4803-b71f-b0aff4620844');

do $verify$ begin
  if (select count(*) from app.content_asset_metadata a join app.content_asset_metadata b on b.content_item_version_id='c4da3229-8d7a-4cf9-8738-68b62af20372' and b.storage_path=a.storage_path and b.alt_text=a.alt_text and b.long_description is not distinct from a.long_description where a.content_item_version_id='bf317c96-1289-4803-b71f-b0aff4620844' and a.approved_by is null and a.approved_at is null)<>1 then raise exception 'v2 metadata row incorrect'; end if;
  if (select count(*) from app.content_visual_requirements where content_item_version_id='bf317c96-1289-4803-b71f-b0aff4620844')<>0 then raise exception 'unexpected visual decision'; end if;
end $verify$;
select 'v2_metadata_unapproved' metric, count(*)::text value from app.content_asset_metadata where content_item_version_id='bf317c96-1289-4803-b71f-b0aff4620844';
commit;
