-- Cramapple production storage buckets and object-level policies.

begin;

alter table storage.objects enable row level security;

insert into storage.buckets (id, name, public)
values
  ('content-assets', 'content-assets', false),
  ('learner-uploads', 'learner-uploads', false),
  ('validation-artifacts', 'validation-artifacts', false)
on conflict (id) do nothing;

-- Private bucket for question assets and approved content media.
drop policy if exists "content_assets_service_only_select" on storage.objects;
create policy "content_assets_service_only_select"
on storage.objects
for select
to service_role
using (bucket_id = 'content-assets');

drop policy if exists "content_assets_service_only_insert" on storage.objects;
create policy "content_assets_service_only_insert"
on storage.objects
for insert
to service_role
with check (bucket_id = 'content-assets');

drop policy if exists "content_assets_service_only_update" on storage.objects;
create policy "content_assets_service_only_update"
on storage.objects
for update
to service_role
using (bucket_id = 'content-assets')
with check (bucket_id = 'content-assets');

drop policy if exists "content_assets_service_only_delete" on storage.objects;
create policy "content_assets_service_only_delete"
on storage.objects
for delete
to service_role
using (bucket_id = 'content-assets');

-- Student-owned uploads. Path convention:
--   {user_id}/{learning_session_id}/{attempt_id}/{filename}
-- The first path segment must match the authenticated user id.
drop policy if exists "learner_uploads_owner_select" on storage.objects;
create policy "learner_uploads_owner_select"
on storage.objects
for select
to authenticated
using (
  bucket_id = 'learner-uploads'
  and split_part(name, '/', 1) = auth.uid()::text
);

drop policy if exists "learner_uploads_owner_insert" on storage.objects;
create policy "learner_uploads_owner_insert"
on storage.objects
for insert
to authenticated
with check (
  bucket_id = 'learner-uploads'
  and split_part(name, '/', 1) = auth.uid()::text
);

drop policy if exists "learner_uploads_owner_update" on storage.objects;
create policy "learner_uploads_owner_update"
on storage.objects
for update
to authenticated
using (
  bucket_id = 'learner-uploads'
  and split_part(name, '/', 1) = auth.uid()::text
)
with check (
  bucket_id = 'learner-uploads'
  and split_part(name, '/', 1) = auth.uid()::text
);

drop policy if exists "learner_uploads_owner_delete" on storage.objects;
create policy "learner_uploads_owner_delete"
on storage.objects
for delete
to authenticated
using (
  bucket_id = 'learner-uploads'
  and split_part(name, '/', 1) = auth.uid()::text
);

-- Validation artifacts stay server-side and reviewer-only.
drop policy if exists "validation_artifacts_service_only_select" on storage.objects;
create policy "validation_artifacts_service_only_select"
on storage.objects
for select
to service_role
using (bucket_id = 'validation-artifacts');

drop policy if exists "validation_artifacts_service_only_insert" on storage.objects;
create policy "validation_artifacts_service_only_insert"
on storage.objects
for insert
to service_role
with check (bucket_id = 'validation-artifacts');

drop policy if exists "validation_artifacts_service_only_update" on storage.objects;
create policy "validation_artifacts_service_only_update"
on storage.objects
for update
to service_role
using (bucket_id = 'validation-artifacts')
with check (bucket_id = 'validation-artifacts');

drop policy if exists "validation_artifacts_service_only_delete" on storage.objects;
create policy "validation_artifacts_service_only_delete"
on storage.objects
for delete
to service_role
using (bucket_id = 'validation-artifacts');

grant select, insert, update, delete on storage.objects to authenticated, service_role;

commit;
