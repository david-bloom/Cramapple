-- Dedicated calibration artifact sets for content testing.
--
-- This table stores compact, service-role-only manifests for small curated
-- calibration packs. The first use case is the AP Statistics FRQ bootstrap
-- corpus used for grader experiments and rubric calibration.

begin
create extension if not exists pgcrypto
create table if not exists app.calibration_sets (
  calibration_set_id uuid primary key default gen_random_uuid(),
  calibration_set_key text not null,
  name text not null,
  subject text not null,
  dataset_version text not null,
  exam_pack_version_ref text,
  payload_schema_version text not null default '1.0.0',
  source_manifest_path text not null,
  source_manifest_sha256 text not null,
  item_count integer not null default 0,
  hdr_item_count integer not null default 0,
  difficulty_summary jsonb not null default '{}'::jsonb,
  manifest jsonb not null default '{}'::jsonb,
  status text not null default 'draft',
  notes text,
  created_by uuid references app.profiles(user_id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint calibration_sets_status_check
    check (status in ('draft', 'published', 'retired')),
  constraint calibration_sets_item_count_check
    check (item_count >= 0),
  constraint calibration_sets_hdr_item_count_check
    check (hdr_item_count >= 0),
  constraint calibration_sets_unique_key unique (calibration_set_key),
  constraint calibration_sets_subject_dataset_unique unique (subject, dataset_version)
)
create trigger calibration_sets_set_updated_at
before update on app.calibration_sets
for each row execute function app.set_updated_at()
alter table app.calibration_sets enable row level security
create policy "calibration_sets_service_all"
on app.calibration_sets
for all
to service_role
using (true)
with check (true)
grant select, insert, update, delete on app.calibration_sets to service_role
comment on table app.calibration_sets is
  'Service-role-only calibration manifests for compact content-testing sets. Each row summarizes a curated corpus and points back to the source artifact in the repo or another storage location.'
commit
