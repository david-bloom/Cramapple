-- Exported from Production migration history (supabase_migrations.schema_migrations)
-- version: 20260627124631
-- recorded name: reserve_model_usage_race_fix
-- statements: 1
-- This file is a faithful transcript of what Production actually ran.
-- Do not edit to "improve" it; corrections belong in a new forward migration.

begin;

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

  -- Fast-path replay check before lock acquisition
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

  -- Post-lock re-check to handle concurrent duplicate requests
  select * into existing from app.model_usage_ledger where request_id = p_request_id limit 1;
  if found then
    if existing.request_hash <> p_request_hash then raise exception 'idempotency key conflict'; end if;
    return existing;
  end if;

  projected_total := budget.reserved_cost_usd + budget.actual_cost_usd + p_reserved_cost_usd;
  if projected_total > p_cap_usd then raise exception 'daily cap exceeded'; end if;

  update app.daily_budgets set reserved_cost_usd = reserved_cost_usd + p_reserved_cost_usd where usage_date_utc = current_date;

  insert into app.model_usage_ledger (request_id, request_hash, usage_date_utc, reserved_cost_usd, status, model_id)
  values (p_request_id, p_request_hash, current_date, p_reserved_cost_usd, 'reserved', p_model_id)
  returning * into existing;

  return existing;
end;
$$;

revoke all on function app.reserve_model_usage(text, text, text, numeric, numeric) from public, anon, authenticated;
grant execute on function app.reserve_model_usage(text, text, text, numeric, numeric) to service_role;

commit;
