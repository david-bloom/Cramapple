-- Bootstrap FRQ schema for TASK-0013 Phase 5 grader calibration.
--
-- Stores the complete corpus of AP Statistics FRQs and their synthetic responses
-- for bootstrap grader calibration workflow.

begin
-- FRQ items table
create table if not exists app.bootstrap_frqs (
  bootstrap_frq_id uuid primary key default gen_random_uuid(),
  calibration_set_id uuid not null references app.calibration_sets(calibration_set_id) on delete cascade,
  content_key text not null,
  module integer not null,
  difficulty text not null,
  form text not null,
  hdr boolean not null default false,
  question_text text not null,
  rubric jsonb not null default '[]'::jsonb,
  codex jsonb not null default '{}'::jsonb,
  investigative_task boolean not null default false,
  module_span integer[] not null default '{}',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint bootstrap_frqs_difficulty_check
    check (difficulty in ('easy', 'medium', 'hard', 'very_hard')),
  constraint bootstrap_frqs_form_check
    check (form in ('short', 'long')),
  constraint bootstrap_frqs_content_key_unique unique (calibration_set_id, content_key)
)
create index bootstrap_frqs_calibration_set_id_idx on app.bootstrap_frqs(calibration_set_id)
create index bootstrap_frqs_content_key_idx on app.bootstrap_frqs(content_key)
create index bootstrap_frqs_module_idx on app.bootstrap_frqs(module)
create index bootstrap_frqs_difficulty_idx on app.bootstrap_frqs(difficulty)
create index bootstrap_frqs_form_idx on app.bootstrap_frqs(form)
create trigger bootstrap_frqs_set_updated_at
before update on app.bootstrap_frqs
for each row execute function app.set_updated_at()
-- Synthetic responses table
create table if not exists app.bootstrap_frq_synthetic_responses (
  synthetic_response_id uuid primary key default gen_random_uuid(),
  bootstrap_frq_id uuid not null references app.bootstrap_frqs(bootstrap_frq_id) on delete cascade,
  response_type text not null,
  student_response text not null,
  created_at timestamptz not null default now(),
  constraint bootstrap_frq_synthetic_responses_type_check
    check (response_type in ('fully_correct', 'borderline', 'partially_correct', 'subtly_wrong', 'incorrect'))
)
create index bootstrap_frq_synthetic_responses_frq_id_idx on app.bootstrap_frq_synthetic_responses(bootstrap_frq_id)
create index bootstrap_frq_synthetic_responses_type_idx on app.bootstrap_frq_synthetic_responses(response_type)
-- Grading assignments table (links tutors to FRQs for calibration)
create table if not exists app.bootstrap_grading_assignments (
  assignment_id uuid primary key default gen_random_uuid(),
  calibration_set_id uuid not null references app.calibration_sets(calibration_set_id) on delete cascade,
  tutor_id uuid not null references app.profiles(user_id) on delete cascade,
  bootstrap_frq_id uuid not null references app.bootstrap_frqs(bootstrap_frq_id) on delete cascade,
  status text not null default 'assigned',
  priority integer not null default 0,
  assigned_at timestamptz not null default now(),
  completed_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint bootstrap_grading_assignments_status_check
    check (status in ('assigned', 'in_progress', 'completed', 'skipped')),
  constraint bootstrap_grading_assignments_unique unique (calibration_set_id, tutor_id, bootstrap_frq_id)
)
create index bootstrap_grading_assignments_calibration_set_id_idx on app.bootstrap_grading_assignments(calibration_set_id)
create index bootstrap_grading_assignments_tutor_id_idx on app.bootstrap_grading_assignments(tutor_id)
create index bootstrap_grading_assignments_frq_id_idx on app.bootstrap_grading_assignments(bootstrap_frq_id)
create index bootstrap_grading_assignments_status_idx on app.bootstrap_grading_assignments(status)
create trigger bootstrap_grading_assignments_set_updated_at
before update on app.bootstrap_grading_assignments
for each row execute function app.set_updated_at()
-- RLS policies
alter table app.bootstrap_frqs enable row level security
alter table app.bootstrap_frq_synthetic_responses enable row level security
alter table app.bootstrap_grading_assignments enable row level security
create policy "bootstrap_frqs_service_all"
on app.bootstrap_frqs
for all
to service_role
using (true)
with check (true)
create policy "bootstrap_frq_synthetic_responses_service_all"
on app.bootstrap_frq_synthetic_responses
for all
to service_role
using (true)
with check (true)
create policy "bootstrap_grading_assignments_service_all"
on app.bootstrap_grading_assignments
for all
to service_role
using (true)
with check (true)
-- Grants
grant select, insert, update, delete on app.bootstrap_frqs to service_role
grant select, insert, update, delete on app.bootstrap_frq_synthetic_responses to service_role
grant select, insert, update, delete on app.bootstrap_grading_assignments to service_role
-- Comments
comment on table app.bootstrap_frqs is
  'Bootstrap FRQ corpus for TASK-0013 Phase 5 grader calibration. Contains all 100 FRQs (10 Long investigative tasks + 90 Short) spanning Modules 1-9 and all difficulty levels.'
comment on table app.bootstrap_frq_synthetic_responses is
  'Synthetic student responses for bootstrap FRQs. Long FRQs have 4 responses each (fully_correct, borderline, partially_correct, subtly_wrong). Short FRQs have 2 responses each (fully_correct, incorrect).'
comment on table app.bootstrap_grading_assignments is
  'Tutor assignments for bootstrap FRQ calibration. Tracks which FRQs are assigned to which tutors for scoring and calibration.'
commit
