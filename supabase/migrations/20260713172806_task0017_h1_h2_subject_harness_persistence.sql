-- TASK-0017 H1/H2 repository/local design. Shared-environment application
-- requires a separate approval ID.
begin;

create or replace function app.reject_immutable_record_mutation()
returns trigger language plpgsql security invoker set search_path = '' as $$
begin
  raise exception 'immutable_record:%_not_allowed', lower(tg_op);
end;
$$;

-- Normalize legacy calendar-year identifiers from the authoritative exam date.
do $$
begin
  if exists (
    select 1 from app.exam_pack_versions legacy
    join app.exam_pack_versions canonical
      on canonical.exam_pack_id = legacy.exam_pack_id and canonical.id <> legacy.id
     and canonical.school_year =
       (extract(year from legacy.official_exam_date)::int - 1)::text || '-'
       || right(extract(year from legacy.official_exam_date)::int::text, 2)
    where legacy.school_year ~ '^[0-9]{4}$'
      and legacy.school_year = extract(year from legacy.official_exam_date)::int::text
  ) then
    raise exception 'subject_harness:academic_year_normalization_conflict';
  end if;
  if exists(select 1 from app.release_candidates where school_year ~ '^[0-9]{4}$')
    or exists(select 1 from app.exam_pack_manifests where school_year ~ '^[0-9]{4}$') then
    raise exception 'subject_harness:legacy_governance_school_year_requires_reconciliation';
  end if;
end;
$$;

update app.exam_pack_versions
set school_year = (extract(year from official_exam_date)::int - 1)::text || '-'
  || right(extract(year from official_exam_date)::int::text, 2)
where school_year ~ '^[0-9]{4}$'
  and school_year = extract(year from official_exam_date)::int::text;

alter table app.exam_pack_versions add column if not exists exam_pack_semver text;
alter table app.exam_pack_versions add constraint exam_pack_versions_semver_check
  check (exam_pack_semver is null or exam_pack_semver ~ '^[0-9]+\.[0-9]+\.[0-9]+$');

create table app.item_archetypes (
  archetype_id uuid primary key default gen_random_uuid(),
  exam_pack_id uuid not null references app.exam_packs(id) on delete restrict,
  archetype_key text not null check (archetype_key ~ '^[a-z0-9]+(?:-[a-z0-9]+)*$'),
  item_type text not null check (item_type in ('mcq','frq','quantitative')),
  created_at timestamptz not null default now(),
  created_by uuid references app.profiles(user_id),
  unique (exam_pack_id, archetype_key)
);
create index item_archetypes_exam_pack_idx on app.item_archetypes(exam_pack_id);
create index item_archetypes_created_by_idx on app.item_archetypes(created_by);

create table app.item_archetype_versions (
  archetype_version_id uuid primary key default gen_random_uuid(),
  archetype_id uuid not null references app.item_archetypes(archetype_id) on delete restrict,
  semantic_version text not null check (semantic_version ~ '^[0-9]+\.[0-9]+\.[0-9]+$'),
  total_points integer not null check (total_points > 0),
  definition jsonb not null,
  content_sha256 text not null check (content_sha256 ~ '^[a-f0-9]{64}$'),
  supersedes_archetype_version_id uuid references app.item_archetype_versions(archetype_version_id) on delete restrict,
  created_at timestamptz not null default now(),
  created_by uuid references app.profiles(user_id),
  unique (archetype_id, semantic_version)
);
create index item_archetype_versions_archetype_idx on app.item_archetype_versions(archetype_id);
create index item_archetype_versions_created_by_idx on app.item_archetype_versions(created_by);
create index item_archetype_versions_supersedes_idx on app.item_archetype_versions(supersedes_archetype_version_id)
  where supersedes_archetype_version_id is not null;

create or replace function app.enforce_archetype_supersession_scope()
returns trigger language plpgsql security invoker set search_path='' as $$ begin
  if new.supersedes_archetype_version_id is not null and not exists(
    select 1 from app.item_archetype_versions prior where prior.archetype_version_id=new.supersedes_archetype_version_id
      and prior.archetype_id=new.archetype_id) then raise exception 'subject_harness:archetype_supersession_cross_identity'; end if;
  return new;
end; $$;
create trigger item_archetype_versions_enforce_supersession before insert or update on app.item_archetype_versions
  for each row execute function app.enforce_archetype_supersession_scope();

alter table app.content_item_versions
  add column if not exists item_package_schema_version text,
  add column if not exists item_package_payload jsonb,
  add column if not exists item_package_sha256 text,
  add column if not exists archetype_version_id uuid references app.item_archetype_versions(archetype_version_id) on delete restrict;
alter table app.content_item_versions add constraint content_item_versions_package_columns_check check (
  (item_package_schema_version is null and item_package_payload is null and item_package_sha256 is null)
  or (item_package_schema_version is not null and item_package_payload is not null
    and item_package_sha256 ~ '^[a-f0-9]{64}$' and archetype_version_id is not null)
);
create index content_item_versions_archetype_idx on app.content_item_versions(archetype_version_id)
  where archetype_version_id is not null;

create or replace function app.protect_item_package_snapshot()
returns trigger language plpgsql security invoker set search_path = '' as $$
begin
  if old.item_package_sha256 is not null and
    (to_jsonb(new) - array['status','review_status','approved_at','approved_by','published_at','updated_at'])
      is distinct from
    (to_jsonb(old) - array['status','review_status','approved_at','approved_by','published_at','updated_at'])
  then raise exception 'subject_harness:item_package_snapshot_immutable'; end if;
  return new;
end;
$$;
create trigger content_item_versions_protect_item_package_snapshot before update
  on app.content_item_versions for each row execute function app.protect_item_package_snapshot();

create or replace function app.protect_package_managed_content_item()
returns trigger language plpgsql security invoker set search_path = '' as $$
begin
  if exists(select 1 from app.content_item_versions v where v.content_item_id=old.id and v.item_package_sha256 is not null)
    and (to_jsonb(new)-array['status','updated_at']) is distinct from (to_jsonb(old)-array['status','updated_at'])
  then raise exception 'subject_harness:package_managed_content_item_immutable'; end if;
  return new;
end;
$$;
create trigger content_items_protect_package_managed before update on app.content_items
  for each row execute function app.protect_package_managed_content_item();

create table app.taxonomy_schemes (
  taxonomy_scheme_id uuid primary key default gen_random_uuid(),
  exam_pack_version_id uuid not null references app.exam_pack_versions(id) on delete restrict,
  scheme_key text not null check (scheme_key ~ '^[a-z0-9]+(?:-[a-z0-9]+)*$'),
  created_at timestamptz not null default now(), created_by uuid references app.profiles(user_id),
  unique (exam_pack_version_id, scheme_key)
);
create index taxonomy_schemes_pack_version_idx on app.taxonomy_schemes(exam_pack_version_id);
create index taxonomy_schemes_created_by_idx on app.taxonomy_schemes(created_by);

create table app.taxonomy_scheme_versions (
  taxonomy_scheme_version_id uuid primary key default gen_random_uuid(),
  taxonomy_scheme_id uuid not null references app.taxonomy_schemes(taxonomy_scheme_id) on delete restrict,
  semantic_version text not null check (semantic_version ~ '^[0-9]+\.[0-9]+\.[0-9]+$'),
  schema_version text not null,
  definition_sha256 text not null check (definition_sha256 ~ '^[a-f0-9]{64}$'),
  supersedes_taxonomy_scheme_version_id uuid references app.taxonomy_scheme_versions(taxonomy_scheme_version_id) on delete restrict,
  created_at timestamptz not null default now(), created_by uuid references app.profiles(user_id),
  unique (taxonomy_scheme_id, semantic_version)
);
create index taxonomy_scheme_versions_scheme_idx on app.taxonomy_scheme_versions(taxonomy_scheme_id);
create index taxonomy_scheme_versions_created_by_idx on app.taxonomy_scheme_versions(created_by);
create index taxonomy_scheme_versions_supersedes_idx on app.taxonomy_scheme_versions(supersedes_taxonomy_scheme_version_id)
  where supersedes_taxonomy_scheme_version_id is not null;

create or replace function app.enforce_taxonomy_supersession_scope()
returns trigger language plpgsql security invoker set search_path='' as $$ begin
  if new.supersedes_taxonomy_scheme_version_id is not null and not exists(
    select 1 from app.taxonomy_scheme_versions prior
    where prior.taxonomy_scheme_version_id=new.supersedes_taxonomy_scheme_version_id
      and prior.taxonomy_scheme_id=new.taxonomy_scheme_id) then raise exception 'subject_harness:taxonomy_supersession_cross_identity'; end if;
  return new;
end; $$;
create trigger taxonomy_scheme_versions_enforce_supersession before insert or update on app.taxonomy_scheme_versions
  for each row execute function app.enforce_taxonomy_supersession_scope();

create table app.taxonomy_node_versions (
  taxonomy_node_version_id uuid primary key default gen_random_uuid(),
  taxonomy_scheme_version_id uuid not null references app.taxonomy_scheme_versions(taxonomy_scheme_version_id) on delete restrict,
  node_key text not null check (node_key ~ '^[a-z0-9]+(?:-[a-z0-9]+)*$'),
  node_type text not null check (node_type in ('unit','topic','learning_objective','practice','skill')),
  label text not null check (length(btrim(label)) > 0), ordinal integer not null check (ordinal > 0),
  source_refs text[] not null default '{}', legacy_refs text[] not null default '{}',
  node_sha256 text not null check (node_sha256 ~ '^[a-f0-9]{64}$'),
  created_at timestamptz not null default now(), created_by uuid references app.profiles(user_id),
  unique (taxonomy_scheme_version_id, node_key)
);
create index taxonomy_node_versions_scheme_version_idx on app.taxonomy_node_versions(taxonomy_scheme_version_id);
create index taxonomy_node_versions_created_by_idx on app.taxonomy_node_versions(created_by);

create table app.taxonomy_node_relations (
  taxonomy_node_relation_id uuid primary key default gen_random_uuid(),
  taxonomy_scheme_version_id uuid not null references app.taxonomy_scheme_versions(taxonomy_scheme_version_id) on delete restrict,
  from_node_version_id uuid not null references app.taxonomy_node_versions(taxonomy_node_version_id) on delete restrict,
  to_node_version_id uuid not null references app.taxonomy_node_versions(taxonomy_node_version_id) on delete restrict,
  relation_type text not null check (relation_type in ('parent','prerequisite','related')),
  created_at timestamptz not null default now(), created_by uuid references app.profiles(user_id),
  check (from_node_version_id <> to_node_version_id),
  unique (taxonomy_scheme_version_id, from_node_version_id, to_node_version_id, relation_type)
);
create index taxonomy_node_relations_from_idx on app.taxonomy_node_relations(from_node_version_id);
create index taxonomy_node_relations_to_idx on app.taxonomy_node_relations(to_node_version_id);
create index taxonomy_node_relations_created_by_idx on app.taxonomy_node_relations(created_by);

create or replace function app.enforce_taxonomy_relation_scope()
returns trigger language plpgsql security invoker set search_path = '' as $$
begin
  if not exists(select 1 from app.taxonomy_node_versions where taxonomy_node_version_id=new.from_node_version_id and taxonomy_scheme_version_id=new.taxonomy_scheme_version_id)
    or not exists(select 1 from app.taxonomy_node_versions where taxonomy_node_version_id=new.to_node_version_id and taxonomy_scheme_version_id=new.taxonomy_scheme_version_id)
  then raise exception 'subject_harness:taxonomy_relation_cross_scheme'; end if;
  return new;
end;
$$;
create trigger taxonomy_node_relations_enforce_scope before insert or update on app.taxonomy_node_relations
  for each row execute function app.enforce_taxonomy_relation_scope();

create table app.content_version_taxonomy_assignments (
  taxonomy_assignment_id uuid primary key default gen_random_uuid(),
  content_item_version_id uuid not null references app.content_item_versions(id) on delete restrict,
  taxonomy_node_version_id uuid not null references app.taxonomy_node_versions(taxonomy_node_version_id) on delete restrict,
  assignment_role text not null check (assignment_role in ('primary','secondary','practice','objective')),
  provenance jsonb not null default '{}', created_at timestamptz not null default now(),
  created_by uuid references app.profiles(user_id),
  unique (content_item_version_id, taxonomy_node_version_id, assignment_role)
);
create index content_taxonomy_assignment_content_idx on app.content_version_taxonomy_assignments(content_item_version_id);
create index content_taxonomy_assignment_node_idx on app.content_version_taxonomy_assignments(taxonomy_node_version_id);
create index content_taxonomy_assignment_created_by_idx on app.content_version_taxonomy_assignments(created_by);

create table app.taxonomy_crosswalks (
  taxonomy_crosswalk_id uuid primary key default gen_random_uuid(),
  from_node_version_id uuid not null references app.taxonomy_node_versions(taxonomy_node_version_id) on delete restrict,
  to_node_version_id uuid not null references app.taxonomy_node_versions(taxonomy_node_version_id) on delete restrict,
  relationship_type text not null check (relationship_type in ('equivalent','broader','narrower','overlap','removed')),
  confidence numeric(5,4) not null check (confidence between 0 and 1), evidence jsonb not null,
  crosswalk_sha256 text not null check (crosswalk_sha256 ~ '^[a-f0-9]{64}$'),
  created_at timestamptz not null default now(), created_by uuid references app.profiles(user_id),
  check (from_node_version_id <> to_node_version_id),
  unique (from_node_version_id, to_node_version_id, relationship_type)
);
create index taxonomy_crosswalks_from_idx on app.taxonomy_crosswalks(from_node_version_id);
create index taxonomy_crosswalks_to_idx on app.taxonomy_crosswalks(to_node_version_id);
create index taxonomy_crosswalks_created_by_idx on app.taxonomy_crosswalks(created_by);

create table app.exam_pack_manifest_content_versions (
  manifest_id uuid not null references app.exam_pack_manifests(manifest_id) on delete restrict,
  ordinal integer not null check (ordinal > 0),
  content_item_version_id uuid not null references app.content_item_versions(id) on delete restrict,
  content_key_snapshot text not null,
  content_sha256 text not null check (content_sha256 ~ '^[a-f0-9]{64}$'),
  created_at timestamptz not null default now(), created_by uuid references app.profiles(user_id),
  primary key (manifest_id, ordinal), unique (manifest_id, content_item_version_id)
);
create index manifest_content_versions_content_idx on app.exam_pack_manifest_content_versions(content_item_version_id);
create index manifest_content_versions_created_by_idx on app.exam_pack_manifest_content_versions(created_by);

create table app.subject_package_applications (
  subject_package_application_id uuid primary key default gen_random_uuid(),
  package_id text not null, package_schema_version text not null,
  operation text not null check (operation in ('create-subject','create-exam-pack-version')),
  package_payload jsonb not null,
  subject_id uuid not null references app.subjects(id) on delete restrict,
  exam_pack_version_id uuid not null references app.exam_pack_versions(id) on delete restrict,
  package_sha256 text not null check (package_sha256 ~ '^[a-f0-9]{64}$'),
  plan_sha256 text not null check (plan_sha256 ~ '^[a-f0-9]{64}$'),
  environment text not null check (environment in ('local','dev','production')),
  approval_id text, applied_at timestamptz not null default now(),
  applied_by uuid not null references app.profiles(user_id),
  unique (package_id, environment)
);
create index subject_package_applications_subject_idx on app.subject_package_applications(subject_id);
create index subject_package_applications_pack_version_idx on app.subject_package_applications(exam_pack_version_id);
create index subject_package_applications_applied_by_idx on app.subject_package_applications(applied_by);

create table app.item_package_applications (
  item_package_application_id uuid primary key default gen_random_uuid(),
  subject_package_application_id uuid not null references app.subject_package_applications(subject_package_application_id) on delete restrict,
  environment text not null check (environment in ('local','dev','production')),
  package_id text not null, package_sha256 text not null check (package_sha256 ~ '^[a-f0-9]{64}$'),
  content_item_version_id uuid not null references app.content_item_versions(id) on delete restrict,
  applied_at timestamptz not null default now(), applied_by uuid not null references app.profiles(user_id),
  unique (environment, package_id), unique (content_item_version_id)
);
create index item_package_applications_parent_idx on app.item_package_applications(subject_package_application_id);
create index item_package_applications_applied_by_idx on app.item_package_applications(applied_by);

do $$ declare v_table regclass; begin
  foreach v_table in array array[
    'app.item_archetype_versions'::regclass, 'app.taxonomy_scheme_versions'::regclass,
    'app.taxonomy_node_versions'::regclass, 'app.taxonomy_node_relations'::regclass,
    'app.content_version_taxonomy_assignments'::regclass, 'app.taxonomy_crosswalks'::regclass,
    'app.exam_pack_manifest_content_versions'::regclass, 'app.subject_package_applications'::regclass,
    'app.item_package_applications'::regclass
  ] loop
    execute format('create trigger reject_immutable_mutation before update or delete on %s for each row execute function app.reject_immutable_record_mutation()', v_table);
  end loop;
end; $$;

alter table app.item_archetypes enable row level security;
alter table app.item_archetype_versions enable row level security;
alter table app.taxonomy_schemes enable row level security;
alter table app.taxonomy_scheme_versions enable row level security;
alter table app.taxonomy_node_versions enable row level security;
alter table app.taxonomy_node_relations enable row level security;
alter table app.content_version_taxonomy_assignments enable row level security;
alter table app.taxonomy_crosswalks enable row level security;
alter table app.exam_pack_manifest_content_versions enable row level security;
alter table app.subject_package_applications enable row level security;
alter table app.item_package_applications enable row level security;

revoke all on app.item_archetypes, app.item_archetype_versions, app.taxonomy_schemes,
  app.taxonomy_scheme_versions, app.taxonomy_node_versions, app.taxonomy_node_relations,
  app.content_version_taxonomy_assignments, app.taxonomy_crosswalks,
  app.exam_pack_manifest_content_versions, app.subject_package_applications,
  app.item_package_applications from public, anon, authenticated;
grant select, insert, update on app.item_archetypes, app.taxonomy_schemes to service_role;
grant select, insert on app.item_archetype_versions, app.taxonomy_scheme_versions,
  app.taxonomy_node_versions, app.taxonomy_node_relations, app.content_version_taxonomy_assignments,
  app.taxonomy_crosswalks, app.exam_pack_manifest_content_versions,
  app.subject_package_applications, app.item_package_applications to service_role;

commit;
