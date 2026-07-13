-- Minimal production-shaped schema for TASK-0017 P0 database tests.
-- This fixture is for a disposable PostgreSQL database only.

create schema if not exists extensions;
-- Deliberately install pgcrypto outside Supabase's expected `extensions`
-- schema. The P0 migration must normalize it and prove extensions.digest
-- resolves; the fixture must not hide that deployment dependency.
create extension if not exists pgcrypto with schema public;
create schema app;

do $$
begin
  if not exists (select 1 from pg_roles where rolname = 'anon') then
    create role anon nologin;
  end if;
  if not exists (select 1 from pg_roles where rolname = 'authenticated') then
    create role authenticated nologin;
  end if;
  if not exists (select 1 from pg_roles where rolname = 'service_role') then
    create role service_role nologin;
  end if;
end;
$$;

create table app.profiles (
  user_id uuid primary key,
  full_name text not null,
  role text not null,
  created_at timestamptz not null default now(),
  constraint profiles_role_check check (role in (
    'student', 'content_author', 'tutor', 'reader', 'validator', 'support', 'admin'
  ))
);

insert into app.profiles (user_id, full_name, role)
values ('00000000-0000-0000-0000-000000000001', 'P0 Test Admin', 'admin');

create table app.exam_packs (
  id uuid primary key default gen_random_uuid(),
  exam_code text not null unique,
  exam_name text not null,
  subject text not null
);

create table app.exam_pack_versions (
  id uuid primary key default gen_random_uuid(),
  exam_pack_id uuid not null references app.exam_packs(id) on delete cascade,
  school_year text not null,
  official_exam_date date not null,
  status text not null check (status in ('draft', 'published', 'retired')),
  unique (exam_pack_id, school_year)
);

create table app.content_items (
  id uuid primary key default gen_random_uuid(),
  exam_pack_version_id uuid not null references app.exam_pack_versions(id) on delete cascade,
  content_key text not null,
  item_type text not null check (item_type in ('mcq', 'frq', 'quantitative')),
  title text not null,
  status text not null default 'draft' check (status in ('draft', 'published', 'retired')),
  unique (exam_pack_version_id, content_key)
);

create table app.content_item_versions (
  id uuid primary key default gen_random_uuid(),
  content_item_id uuid not null references app.content_items(id) on delete cascade,
  version_num integer not null,
  stem text not null,
  content_hash text not null,
  status text not null default 'draft' check (status in ('draft', 'published', 'retired')),
  review_status text,
  published_at timestamptz,
  unique (content_item_id, version_num)
);

create unique index content_item_versions_one_published_per_item
  on app.content_item_versions (content_item_id)
  where status = 'published';

create table app.source_records (
  source_id uuid not null,
  source_version_id uuid primary key default gen_random_uuid(),
  version_sequence integer not null,
  title text not null,
  publisher text not null,
  source_type text not null,
  scope_statement text not null,
  content_sha256 text not null,
  authority_tier integer not null,
  refresh_class text not null,
  next_refresh_due_at timestamptz not null,
  provenance_status text not null
);

create table app.rights_records (
  rights_record_id uuid primary key default gen_random_uuid(),
  source_version_id uuid not null references app.source_records(source_version_id) on delete cascade,
  rights_status text not null,
  license_expires_at timestamptz,
  legal_approval_required boolean not null default false,
  legal_approval_id uuid,
  next_review_due_at timestamptz not null
);

create table app.validation_suites (
  suite_id uuid primary key default gen_random_uuid(),
  suite_version_id uuid not null unique,
  name text not null,
  exam_id uuid not null,
  suite_type text not null,
  split text not null,
  content_sha256 text not null
);

create table app.validation_runs (
  run_id uuid primary key default gen_random_uuid(),
  suite_version_id uuid not null references app.validation_suites(suite_version_id) on delete cascade,
  target_version_ids uuid[] not null default '{}'::uuid[],
  environment text not null,
  runner_type text not null,
  completed_at timestamptz,
  status text not null check (status in ('running', 'passed', 'failed', 'invalidated', 'cancelled'))
);

create table app.artifact_versions (
  artifact_version_id uuid primary key default gen_random_uuid()
);

create table app.artifact_state_events (
  artifact_state_event_id uuid primary key default gen_random_uuid(),
  artifact_version_id uuid not null references app.artifact_versions(artifact_version_id) on delete cascade,
  prior_state text,
  new_state text not null,
  reason_code text not null,
  evidence_record_ids uuid[] not null default '{}'::uuid[],
  changed_by uuid references app.profiles(user_id),
  changed_at timestamptz not null default now(),
  created_by uuid references app.profiles(user_id)
);

create function app.project_artifact_state(p_artifact_version_id uuid)
returns text
language sql
stable
set search_path = ''
as $$
  select coalesce(
    (
      select ase.new_state
      from app.artifact_state_events ase
      where ase.artifact_version_id = p_artifact_version_id
      order by ase.changed_at desc, ase.artifact_state_event_id desc
      limit 1
    ),
    'draft'
  );
$$;

create table app.release_candidates (
  release_candidate_id uuid primary key default gen_random_uuid(),
  exam_id uuid not null,
  school_year text not null,
  proposed_version text not null,
  release_class text not null check (release_class in ('patch', 'minor', 'major', 'emergency')),
  manifest_id uuid,
  source_gate text not null,
  rights_gate text not null,
  teaching_gate text not null,
  grading_gate text not null,
  security_privacy_gate text not null,
  release_gate text not null,
  blocking_findings uuid[] not null default '{}'::uuid[],
  created_by uuid references app.profiles(user_id)
);

create table app.exam_pack_manifests (
  manifest_id uuid primary key default gen_random_uuid(),
  exam_id uuid not null,
  school_year text not null,
  exam_pack_version text not null,
  artifact_version_ids uuid[] not null default '{}'::uuid[],
  source_version_ids uuid[] not null default '{}'::uuid[],
  rights_record_ids uuid[] not null default '{}'::uuid[],
  validator_policy_version_id uuid not null,
  teaching_policy_version_id uuid not null,
  grading_policy_version_id uuid not null,
  prompt_version_ids uuid[] not null default '{}'::uuid[],
  model_configuration_version_ids uuid[] not null default '{}'::uuid[],
  validation_run_ids uuid[] not null default '{}'::uuid[],
  qualification_rule_version_ids uuid[] not null default '{}'::uuid[],
  manifest_sha256 text not null,
  created_by uuid references app.profiles(user_id)
);

create table app.publication_events (
  publication_event_id uuid primary key default gen_random_uuid(),
  release_candidate_id uuid not null references app.release_candidates(release_candidate_id) on delete cascade,
  manifest_id uuid not null references app.exam_pack_manifests(manifest_id) on delete cascade,
  environment text not null,
  prior_manifest_id uuid references app.exam_pack_manifests(manifest_id) on delete set null,
  action text not null,
  approved_by uuid[] not null default '{}'::uuid[],
  executed_by uuid references app.profiles(user_id),
  transaction_id text not null,
  smoke_test_run_id uuid,
  outcome text not null,
  created_by uuid references app.profiles(user_id)
);

grant usage on schema app to service_role;
grant select, insert, update, delete on all tables in schema app to service_role;
