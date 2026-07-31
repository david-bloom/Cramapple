-- Exported from Production migration history (supabase_migrations.schema_migrations)
-- version: 20260627124823
-- recorded name: subjects_normalization
-- statements: 1
-- This file is a faithful transcript of what Production actually ran.
-- Do not edit to "improve" it; corrections belong in a new forward migration.

begin;

create table if not exists app.subjects (
  id uuid primary key default gen_random_uuid(),
  subject_key text not null unique,
  display_name text not null,
  status text not null default 'active',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint subjects_status_check
    check (status in ('active', 'retired'))
);

create trigger subjects_set_updated_at
before update on app.subjects
for each row execute function app.set_updated_at();

alter table app.subjects enable row level security;

create policy "subjects_select_active"
on app.subjects
for select
to authenticated
using (status = 'active');

insert into app.subjects (subject_key, display_name)
select distinct
  lower(trim(ep.subject)) as subject_key,
  initcap(replace(lower(trim(ep.subject)), '_', ' ')) as display_name
from app.exam_packs ep
where ep.subject is not null
on conflict (subject_key)
do update set
  display_name = excluded.display_name;

alter table app.exam_packs
  add column if not exists subject_id uuid;

update app.exam_packs ep
set subject_id = s.id
from app.subjects s
where lower(trim(ep.subject)) = s.subject_key
  and ep.subject_id is null;

alter table app.exam_packs
  alter column subject_id set not null;

alter table app.exam_packs
  add constraint exam_packs_subject_id_fkey
  foreign key (subject_id) references app.subjects(id) on delete restrict;

alter table app.question_coverage_targets
  add constraint question_coverage_targets_subject_id_fkey
  foreign key (subject_id) references app.subjects(id) on delete restrict;

create index if not exists exam_packs_subject_id_idx
  on app.exam_packs (subject_id);

create index if not exists question_coverage_targets_subject_id_idx
  on app.question_coverage_targets (subject_id);

alter table app.exam_packs
  drop column if exists subject;

grant select on app.subjects to authenticated;
grant select, insert, update, delete on app.subjects to service_role;

commit;
