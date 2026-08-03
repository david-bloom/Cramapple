-- Exported from Production migration history (supabase_migrations.schema_migrations)
-- version: 20260627124810
-- recorded name: prototype_student_schema
-- statements: 1
-- This file is a faithful transcript of what Production actually ran.
-- Do not edit to "improve" it; corrections belong in a new forward migration.

create extension if not exists pgcrypto;

create table public.exam_specs (
  id uuid primary key default gen_random_uuid(),
  subject text not null,
  exam_year integer not null,
  exam_date date not null,
  source_url text,
  effective_from date,
  created_at timestamptz not null default now()
);

alter table public.exam_specs
  add constraint exam_specs_subject_exam_year_unique unique (subject, exam_year);

alter table public.exam_specs enable row level security;

create policy "exam_specs_select_authenticated"
  on public.exam_specs
  for select
  to authenticated
  using (true);

insert into public.exam_specs (subject, exam_year, exam_date, source_url)
values (
  'ap_biology',
  2027,
  '2027-05-12',
  'https://apstudents.collegeboard.org/exam-calendar'
)
on conflict (subject, exam_year) do update
set exam_date = excluded.exam_date,
    source_url = excluded.source_url;

create table public.questions (
  id uuid primary key default gen_random_uuid(),
  type text not null check (type in ('mcq', 'short_frq', 'long_frq')),
  unit integer not null check (unit between 1 and 8),
  topic_id text not null,
  science_practice integer check (science_practice between 1 and 6),
  task_verb text,
  difficulty text check (difficulty in ('accessible', 'standard', 'challenging')),
  is_diagnostic boolean not null default false,
  status text not null default 'draft' check (status in ('draft', 'review', 'approved', 'suspended')),
  stem text not null,
  stimulus_url text,
  answer_choices jsonb,
  points_available integer not null default 1,
  rubric jsonb,
  teaching_package jsonb,
  version integer not null default 1,
  created_by text,
  approved_by text,
  approved_at timestamptz,
  created_at timestamptz not null default now()
);

alter table public.questions enable row level security;

create policy "questions_select_approved_authenticated"
  on public.questions
  for select
  to authenticated
  using (status = 'approved');

create table public.sessions (
  id uuid primary key default gen_random_uuid(),
  student_id uuid not null references auth.users(id) on delete cascade,
  started_at timestamptz not null default now(),
  ended_at timestamptz,
  mode text check (mode in ('quick', 'focused', 'buckle_down')),
  entry_path text check (entry_path in ('recommendation', 'self_guided_topic', 'self_guided_format')),
  selected_unit integer,
  selected_topic text,
  selected_format text check (selected_format in ('mcq', 'short_frq', 'long_frq', 'mixed')),
  questions_served uuid[],
  summary jsonb,
  created_at timestamptz not null default now()
);

alter table public.sessions enable row level security;

create policy "sessions_select_own"
  on public.sessions
  for select
  to authenticated
  using ((select auth.uid()) = student_id);

create policy "sessions_insert_own"
  on public.sessions
  for insert
  to authenticated
  with check ((select auth.uid()) = student_id);

create policy "sessions_update_own"
  on public.sessions
  for update
  to authenticated
  using ((select auth.uid()) = student_id)
  with check ((select auth.uid()) = student_id);

create table public.student_attempts (
  id uuid primary key default gen_random_uuid(),
  student_id uuid not null references auth.users(id) on delete cascade,
  question_id uuid not null references public.questions(id) on delete restrict,
  session_id uuid references public.sessions(id) on delete set null,
  attempt_number integer not null default 1,
  assistance_level text check (assistance_level in ('cold', 'coached', 'exam')),
  response_text text,
  submitted_at timestamptz,
  grading_state text not null default 'draft_saved',
  grader_output jsonb,
  time_on_task_s integer,
  paste_detected boolean not null default false,
  created_at timestamptz not null default now()
);

alter table public.student_attempts enable row level security;

create policy "student_attempts_select_own"
  on public.student_attempts
  for select
  to authenticated
  using ((select auth.uid()) = student_id);

create policy "student_attempts_insert_own"
  on public.student_attempts
  for insert
  to authenticated
  with check ((select auth.uid()) = student_id);

create policy "student_attempts_update_own"
  on public.student_attempts
  for update
  to authenticated
  using ((select auth.uid()) = student_id)
  with check ((select auth.uid()) = student_id);

create table public.student_lock_queue (
  id uuid primary key default gen_random_uuid(),
  student_id uuid not null references auth.users(id) on delete cascade,
  question_id uuid not null references public.questions(id) on delete restrict,
  criterion_id text not null,
  assistance_level text check (assistance_level in ('cold', 'coached')),
  result text check (result in ('earned', 'not_earned')),
  next_review_at timestamptz not null,
  review_count integer not null default 0,
  last_attempt_id uuid references public.student_attempts(id) on delete set null,
  created_at timestamptz not null default now()
);

alter table public.student_lock_queue enable row level security;

create policy "student_lock_queue_select_own"
  on public.student_lock_queue
  for select
  to authenticated
  using ((select auth.uid()) = student_id);

create index if not exists sessions_student_started_at_idx
  on public.sessions (student_id, started_at desc);

create index if not exists student_attempts_student_submitted_at_idx
  on public.student_attempts (student_id, submitted_at desc);

create index if not exists student_attempts_session_idx
  on public.student_attempts (session_id);

create index if not exists student_lock_queue_student_next_review_idx
  on public.student_lock_queue (student_id, next_review_at asc);

create index if not exists questions_status_unit_topic_idx
  on public.questions (status, unit, topic_id);

grant usage on schema public to authenticated, service_role;

grant select on public.exam_specs to authenticated, service_role;
grant select on public.questions to authenticated, service_role;

grant select, insert, update on public.sessions to authenticated, service_role;
grant select, insert, update on public.student_attempts to authenticated, service_role;

grant select on public.student_lock_queue to authenticated, service_role;
grant insert, update, delete on public.student_lock_queue to service_role;
