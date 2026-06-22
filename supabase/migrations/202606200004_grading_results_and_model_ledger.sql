-- Cramapple grading results, response versions, and model usage ledger.

begin;

create table if not exists app.response_versions (
  id uuid primary key default gen_random_uuid(),
  attempt_id uuid not null references app.attempts(id) on delete cascade,
  parent_response_version_id uuid references app.response_versions(id) on delete set null,
  response_text text,
  response_parts jsonb not null default '{}'::jsonb,
  version_number integer not null,
  is_submitted boolean not null default false,
  created_by uuid references app.profiles(user_id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint response_versions_unique unique (attempt_id, version_number)
);

create trigger response_versions_set_updated_at
before update on app.response_versions
for each row execute function app.set_updated_at();

alter table app.response_versions enable row level security;

create policy "response_versions_owner_select"
on app.response_versions
for select
to authenticated
using (
  exists (
    select 1
    from app.attempts a
    where a.id = response_versions.attempt_id
      and a.user_id = auth.uid()
  )
);

create policy "response_versions_owner_insert_draft"
on app.response_versions
for insert
to authenticated
with check (
  exists (
    select 1
    from app.attempts a
    where a.id = response_versions.attempt_id
      and a.user_id = auth.uid()
      and a.status in ('draft', 'failed')
  )
);

create policy "response_versions_owner_update_draft"
on app.response_versions
for update
to authenticated
using (
  exists (
    select 1
    from app.attempts a
    where a.id = response_versions.attempt_id
      and a.user_id = auth.uid()
      and a.status in ('draft', 'failed')
  )
  and is_submitted = false
)
with check (
  exists (
    select 1
    from app.attempts a
    where a.id = response_versions.attempt_id
      and a.user_id = auth.uid()
      and a.status in ('draft', 'failed')
  )
  and is_submitted = false
);

create table if not exists app.grading_results (
  id uuid primary key default gen_random_uuid(),
  request_id text not null unique,
  request_hash text not null,
  attempt_id uuid not null references app.attempts(id) on delete cascade,
  response_version_id uuid not null references app.response_versions(id) on delete cascade,
  operation text not null,
  status text not null,
  points_earned integer,
  points_available integer not null,
  criterion_results jsonb not null default '[]'::jsonb,
  highest_value_gap jsonb,
  predicted_label text,
  predicted_point_gain integer,
  actual_point_gain integer,
  prediction_outcome text,
  confidence text not null,
  uncertainty_reason text,
  model_id text not null,
  prompt_version text not null,
  rubric_version_id uuid,
  input_tokens integer,
  output_tokens integer,
  estimated_cost_usd numeric(10,4),
  latency_ms integer,
  raw_model_response jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint grading_results_operation_check
    check (operation in ('grade_initial_attempt', 'select_repair', 'grade_revision', 'grade_transfer_attempt')),
  constraint grading_results_status_check
    check (status in ('processing', 'graded', 'uncertain', 'failed', 'duplicate')),
  constraint grading_results_confidence_check
    check (confidence in ('high', 'medium', 'low'))
);

create trigger grading_results_set_updated_at
before update on app.grading_results
for each row execute function app.set_updated_at();

alter table app.grading_results enable row level security;

create policy "grading_results_owner_select"
on app.grading_results
for select
to authenticated
using (
  exists (
    select 1
    from app.attempts a
    where a.id = grading_results.attempt_id
      and a.user_id = auth.uid()
  )
);

create table if not exists app.model_usage_ledger (
  id uuid primary key default gen_random_uuid(),
  request_id text not null unique,
  request_hash text not null,
  usage_date_utc date not null,
  reserved_cost_usd numeric(10,4) not null,
  actual_cost_usd numeric(10,4),
  status text not null,
  model_id text not null,
  input_tokens integer,
  output_tokens integer,
  created_at timestamptz not null default now(),
  completed_at timestamptz,
  constraint model_usage_ledger_status_check
    check (status in ('reserved', 'running', 'completed', 'failed', 'rejected'))
);

alter table app.model_usage_ledger enable row level security;

create policy "model_usage_ledger_service_only"
on app.model_usage_ledger
for select
to service_role
using (true);

create policy "model_usage_ledger_service_only_write"
on app.model_usage_ledger
for insert
to service_role
with check (true);

create policy "model_usage_ledger_service_only_update"
on app.model_usage_ledger
for update
to service_role
using (true)
with check (true);

create table if not exists app.prompt_versions (
  id uuid primary key default gen_random_uuid(),
  operation text not null,
  version text not null,
  status text not null default 'draft',
  prompt_hash text not null,
  created_at timestamptz not null default now(),
  released_at timestamptz,
  constraint prompt_versions_status_check
    check (status in ('draft', 'published', 'retired')),
  constraint prompt_versions_unique unique (operation, version)
);

alter table app.prompt_versions enable row level security;

create policy "prompt_versions_service_only"
on app.prompt_versions
for select
to service_role
using (true);

create or replace function app.reserve_model_usage(
  p_request_id text,
  p_request_hash text,
  p_model_id text,
  p_reserved_cost_usd numeric,
  p_cap_usd numeric
)
returns app.model_usage_ledger
language plpgsql
security definer
set search_path = app, public
as $$
declare
  existing app.model_usage_ledger%rowtype;
  spend_total numeric(10,4);
begin
  perform pg_advisory_xact_lock(hashtext(current_date::text)::bigint);

  select *
  into existing
  from app.model_usage_ledger
  where request_id = p_request_id
  limit 1;

  if found then
    if existing.request_hash <> p_request_hash then
      raise exception 'idempotency key conflict';
    end if;
    return existing;
  end if;

  select coalesce(sum(
    case
      when status in ('reserved', 'running') then reserved_cost_usd
      else coalesce(actual_cost_usd, 0)
    end
  ), 0)
  into spend_total
  from app.model_usage_ledger
  where usage_date_utc = current_date;

  if spend_total + p_reserved_cost_usd > p_cap_usd then
    raise exception 'daily cap exceeded';
  end if;

  insert into app.model_usage_ledger (
    request_id,
    request_hash,
    usage_date_utc,
    reserved_cost_usd,
    status,
    model_id
  )
  values (
    p_request_id,
    p_request_hash,
    current_date,
    p_reserved_cost_usd,
    'reserved',
    p_model_id
  )
  returning * into existing;

  return existing;
end;
$$;

create or replace function app.complete_model_usage(
  p_request_id text,
  p_request_hash text,
  p_status text,
  p_actual_cost_usd numeric,
  p_input_tokens integer,
  p_output_tokens integer
)
returns app.model_usage_ledger
language plpgsql
security definer
set search_path = app, public
as $$
declare
  existing app.model_usage_ledger%rowtype;
begin
  update app.model_usage_ledger
  set
    status = p_status,
    actual_cost_usd = p_actual_cost_usd,
    input_tokens = p_input_tokens,
    output_tokens = p_output_tokens,
    completed_at = now()
  where request_id = p_request_id
    and request_hash = p_request_hash
  returning * into existing;

  if not found then
    raise exception 'usage request not found';
  end if;

  return existing;
end;
$$;

grant usage on schema app to authenticated, service_role;

grant select on
  app.response_versions,
  app.grading_results,
  app.prompt_versions
to authenticated;

grant select, insert, update on app.response_versions to authenticated;

grant select, insert, update, delete on
  app.response_versions,
  app.grading_results,
  app.model_usage_ledger,
  app.prompt_versions
to service_role;

commit;
