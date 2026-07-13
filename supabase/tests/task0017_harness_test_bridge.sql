-- Extends the intentionally small P0 fixture with the current canonical
-- subject/package columns required by the H1-H5 repository migrations.
create table app.subjects (
  id uuid primary key default gen_random_uuid(), subject_key text not null unique,
  display_name text not null, status text not null default 'active',
  created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);
alter table app.exam_packs alter column subject drop not null;
alter table app.exam_packs add column subject_id uuid references app.subjects(id),
  add column created_at timestamptz not null default now(), add column updated_at timestamptz not null default now();
alter table app.exam_pack_versions add column source_uri text, add column created_by uuid references app.profiles(user_id),
  add column created_at timestamptz not null default now(), add column updated_at timestamptz not null default now();
alter table app.content_items add column created_by uuid references app.profiles(user_id),
  add column created_at timestamptz not null default now(), add column updated_at timestamptz not null default now();
alter table app.content_item_versions add column prompt_json jsonb not null default '{}',
  add column created_by uuid references app.profiles(user_id), add column created_at timestamptz not null default now(),
  add column updated_at timestamptz not null default now();
alter table app.validation_suites add column created_at timestamptz not null default now(),
  add column created_by uuid references app.profiles(user_id);
create table app.content_review_assignments (
  content_review_assignment_id uuid primary key default gen_random_uuid(),
  content_item_version_id uuid not null references app.content_item_versions(id),
  reviewer_id uuid not null references app.profiles(user_id), review_stage text not null,
  status text not null default 'pending', created_by uuid references app.profiles(user_id)
);

grant select,insert,update on app.subjects,app.exam_packs,app.exam_pack_versions,
  app.content_items,app.content_item_versions to service_role;

insert into app.subjects(id,subject_key,display_name) values
  ('10000000-0000-0000-0000-000000000001','ap-statistics','AP Statistics'),
  ('10000000-0000-0000-0000-000000000002','ap-chemistry','AP Chemistry'),
  ('10000000-0000-0000-0000-000000000003','ap-biology','AP Biology');
insert into app.exam_packs(id,exam_code,exam_name,subject_id) values
  ('20000000-0000-0000-0000-000000000001','ap_statistics','AP Statistics','10000000-0000-0000-0000-000000000001'),
  ('20000000-0000-0000-0000-000000000002','ap_chemistry','AP Chemistry','10000000-0000-0000-0000-000000000002'),
  ('20000000-0000-0000-0000-000000000003','ap_biology','AP Biology','10000000-0000-0000-0000-000000000003');
insert into app.exam_pack_versions(id,exam_pack_id,school_year,official_exam_date,status,created_by) values
  ('30000000-0000-0000-0000-000000000001','20000000-0000-0000-0000-000000000001','2026','2026-05-07','draft','00000000-0000-0000-0000-000000000001'),
  ('30000000-0000-0000-0000-000000000002','20000000-0000-0000-0000-000000000002','2026','2026-05-05','draft','00000000-0000-0000-0000-000000000001'),
  ('30000000-0000-0000-0000-000000000003','20000000-0000-0000-0000-000000000003','2026','2026-05-04','draft','00000000-0000-0000-0000-000000000001');
insert into app.content_items(id,exam_pack_version_id,content_key,item_type,title,status,created_by) values
  ('40000000-0000-0000-0000-000000000001','30000000-0000-0000-0000-000000000001','stats-golden','mcq','Stats golden','draft','00000000-0000-0000-0000-000000000001'),
  ('40000000-0000-0000-0000-000000000002','30000000-0000-0000-0000-000000000003','bio-golden','mcq','Bio golden','draft','00000000-0000-0000-0000-000000000001');
insert into app.content_item_versions(id,content_item_id,version_num,stem,prompt_json,content_hash,status,created_by) values
  ('50000000-0000-0000-0000-000000000001','40000000-0000-0000-0000-000000000001',1,'Stats payload','{"answer":"A"}','aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa','draft','00000000-0000-0000-0000-000000000001'),
  ('50000000-0000-0000-0000-000000000002','40000000-0000-0000-0000-000000000002',1,'Bio payload','{"answer":"B"}','bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb','draft','00000000-0000-0000-0000-000000000001');
