-- Grading experiment schema for AP Statistics scale runs.
--
-- Stores run metadata, per-response grading cases, and per-arm model outputs
-- so calibration experiments can be replayed and compared in Supabase.

begin
create table if not exists app.grading_experiment_runs (
  grading_experiment_run_id uuid primary key default gen_random_uuid(),
  run_key text not null unique,
  calibration_set_id uuid references app.calibration_sets(calibration_set_id) on delete set null,
  subject text not null,
  dataset_version text not null,
  corpus_path text not null,
  prompt_path text not null,
  item_selection text not null default 'boundary_then_full',
  item_count integer not null default 0,
  case_count integer not null default 0,
  model_arms jsonb not null default '[]'::jsonb,
  status text not null default 'draft',
  notes text not null default '',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint grading_experiment_runs_status_check
    check (status in ('draft', 'queued', 'running', 'completed', 'failed'))
)
create index grading_experiment_runs_subject_idx on app.grading_experiment_runs(subject)
create index grading_experiment_runs_dataset_version_idx on app.grading_experiment_runs(dataset_version)
create index grading_experiment_runs_status_idx on app.grading_experiment_runs(status)
create trigger grading_experiment_runs_set_updated_at
before update on app.grading_experiment_runs
for each row execute function app.set_updated_at()
create table if not exists app.grading_experiment_cases (
  grading_experiment_case_id uuid primary key default gen_random_uuid(),
  grading_experiment_run_id uuid not null references app.grading_experiment_runs(grading_experiment_run_id) on delete cascade,
  case_key text not null,
  sequence_index integer not null,
  content_key text not null,
  response_index integer not null default 0,
  response_type text not null,
  form text not null,
  difficulty text not null,
  hdr boolean not null default false,
  frq_subtype text not null default 'standard_response',
  module integer not null,
  question_text text not null,
  rubric jsonb not null default '[]'::jsonb,
  codex jsonb not null default '{}'::jsonb,
  student_response text not null,
  expected_score_type text not null default '',
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint grading_experiment_cases_unique unique (grading_experiment_run_id, case_key)
)
create index grading_experiment_cases_run_id_idx on app.grading_experiment_cases(grading_experiment_run_id)
create index grading_experiment_cases_content_key_idx on app.grading_experiment_cases(content_key)
create index grading_experiment_cases_response_type_idx on app.grading_experiment_cases(response_type)
create index grading_experiment_cases_form_idx on app.grading_experiment_cases(form)
create trigger grading_experiment_cases_set_updated_at
before update on app.grading_experiment_cases
for each row execute function app.set_updated_at()
create table if not exists app.grading_experiment_results (
  grading_experiment_result_id uuid primary key default gen_random_uuid(),
  grading_experiment_run_id uuid not null references app.grading_experiment_runs(grading_experiment_run_id) on delete cascade,
  grading_experiment_case_id uuid not null references app.grading_experiment_cases(grading_experiment_case_id) on delete cascade,
  arm_key text not null,
  model_id text not null,
  reasoning_effort text not null,
  prompt_version text not null,
  prompt_hash text not null,
  output_schema_version text not null,
  schema_valid boolean not null default false,
  timeout_or_retry boolean not null default false,
  raw_output jsonb not null default '{}'::jsonb,
  criterion_scores jsonb not null default '[]'::jsonb,
  total_score integer,
  confidence_summary text not null default '',
  failure_modes text[] not null default '{}',
  notes text not null default '',
  input_tokens integer not null default 0,
  output_tokens integer not null default 0,
  reasoning_tokens integer not null default 0,
  cached_tokens integer not null default 0,
  latency_ms numeric not null default 0,
  estimated_cost_usd numeric not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint grading_experiment_results_unique unique (grading_experiment_run_id, grading_experiment_case_id, arm_key)
)
create index grading_experiment_results_run_id_idx on app.grading_experiment_results(grading_experiment_run_id)
create index grading_experiment_results_case_id_idx on app.grading_experiment_results(grading_experiment_case_id)
create index grading_experiment_results_arm_key_idx on app.grading_experiment_results(arm_key)
create index grading_experiment_results_schema_valid_idx on app.grading_experiment_results(schema_valid)
create trigger grading_experiment_results_set_updated_at
before update on app.grading_experiment_results
for each row execute function app.set_updated_at()
alter table app.grading_experiment_runs enable row level security
alter table app.grading_experiment_cases enable row level security
alter table app.grading_experiment_results enable row level security
create policy "grading_experiment_runs_service_all"
on app.grading_experiment_runs
for all
to service_role
using (true)
with check (true)
create policy "grading_experiment_cases_service_all"
on app.grading_experiment_cases
for all
to service_role
using (true)
with check (true)
create policy "grading_experiment_results_service_all"
on app.grading_experiment_results
for all
to service_role
using (true)
with check (true)
grant select, insert, update, delete on app.grading_experiment_runs to service_role
grant select, insert, update, delete on app.grading_experiment_cases to service_role
grant select, insert, update, delete on app.grading_experiment_results to service_role
comment on table app.grading_experiment_runs is
  'High-level metadata for AP Statistics grading experiments, including the run key, selection strategy, and model arms.'
comment on table app.grading_experiment_cases is
  'Per-response grading cases for experiment runs. One row per synthetic response, including the source FRQ and response text.'
comment on table app.grading_experiment_results is
  'Per-arm model outputs for each grading case, stored with raw JSON output and execution metrics.'
commit
