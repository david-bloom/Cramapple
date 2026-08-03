-- Exported from Production migration history (supabase_migrations.schema_migrations)
-- version: 20260627124548
-- recorded name: daily_budget_row_lock
-- statements: 1
-- This file is a faithful transcript of what Production actually ran.
-- Do not edit to "improve" it; corrections belong in a new forward migration.

-- Replace the global per-day advisory lock with a row-level lock on a single daily-budget row.

begin;

create table if not exists app.daily_budgets (
  usage_date_utc date primary key,
  reserved_cost_usd numeric(12,4) not null default 0,
  actual_cost_usd numeric(12,4) not null default 0,
  cap_usd numeric(12,4),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint daily_budgets_reserved_nonneg check (reserved_cost_usd >= 0),
  constraint daily_budgets_actual_nonneg check (actual_cost_usd >= 0)
);

create trigger daily_budgets_set_updated_at
before update on app.daily_budgets
for each row execute function app.set_updated_at();

alter table app.daily_budgets enable row level security;

create policy "daily_budgets_service_only_select"
on app.daily_budgets for select to service_role using (true);

create policy "daily_budgets_service_only_insert"
on app.daily_budgets for insert to service_role with check (true);

create policy "daily_budgets_service_only_update"
on app.daily_budgets for update to service_role using (true) with check (true);

grant select, insert, update on app.daily_budgets to service_role;

insert into app.daily_budgets (usage_date_utc, reserved_cost_usd, actual_cost_usd)
select
  current_date,
  coalesce(sum(case when status in ('reserved', 'running') then reserved_cost_usd else 0 end), 0),
  coalesce(sum(case when status not in ('reserved', 'running') then coalesce(actual_cost_usd, 0) else 0 end), 0)
from app.model_usage_ledger
where usage_date_utc = current_date
on conflict (usage_date_utc) do nothing;

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
  budget app.daily_budgets%rowtype;
  projected_total numeric(12,4);
begin
  if p_reserved_cost_usd is null or p_reserved_cost_usd <= 0 then
    raise exception 'invalid reservation amount';
  end if;

  select * into existing from app.model_usage_ledger where request_id = p_request_id limit 1;
  if found then
    if existing.request_hash <> p_request_hash then raise exception 'idempotency key conflict'; end if;
    return existing;
  end if;

  insert into app.daily_budgets (usage_date_utc, cap_usd)
  values (current_date, p_cap_usd)
  on conflict (usage_date_utc) do update
    set cap_usd = coalesce(app.daily_budgets.cap_usd, excluded.cap_usd);

  select * into budget from app.daily_budgets where usage_date_utc = current_date for update;

  projected_total := budget.reserved_cost_usd + budget.actual_cost_usd + p_reserved_cost_usd;
  if projected_total > p_cap_usd then raise exception 'daily cap exceeded'; end if;

  update app.daily_budgets set reserved_cost_usd = reserved_cost_usd + p_reserved_cost_usd where usage_date_utc = current_date;

  insert into app.model_usage_ledger (request_id, request_hash, usage_date_utc, reserved_cost_usd, status, model_id)
  values (p_request_id, p_request_hash, current_date, p_reserved_cost_usd, 'reserved', p_model_id)
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
  prior_reserved numeric(10,4);
  burn_cost numeric(10,4);
begin
  select * into existing from app.model_usage_ledger
  where request_id = p_request_id and request_hash = p_request_hash for update;

  if not found then raise exception 'usage request not found'; end if;
  if existing.status not in ('reserved', 'running') then return existing; end if;

  prior_reserved := existing.reserved_cost_usd;
  burn_cost := case when p_status in ('completed') then coalesce(p_actual_cost_usd, 0) else 0 end;

  update app.model_usage_ledger set
    status = p_status, actual_cost_usd = p_actual_cost_usd,
    input_tokens = p_input_tokens, output_tokens = p_output_tokens, completed_at = now()
  where request_id = p_request_id and request_hash = p_request_hash
  returning * into existing;

  update app.daily_budgets set
    reserved_cost_usd = greatest(0, reserved_cost_usd - prior_reserved),
    actual_cost_usd = actual_cost_usd + burn_cost
  where usage_date_utc = existing.usage_date_utc;

  return existing;
end;
$$;

revoke all on function app.reserve_model_usage(text, text, text, numeric, numeric) from public, anon, authenticated;
grant execute on function app.reserve_model_usage(text, text, text, numeric, numeric) to service_role;

revoke all on function app.complete_model_usage(text, text, text, numeric, integer, integer) from public, anon, authenticated;
grant execute on function app.complete_model_usage(text, text, text, numeric, integer, integer) to service_role;

commit;
