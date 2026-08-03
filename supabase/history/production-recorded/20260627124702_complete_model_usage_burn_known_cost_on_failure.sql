-- Exported from Production migration history (supabase_migrations.schema_migrations)
-- version: 20260627124702
-- recorded name: complete_model_usage_burn_known_cost_on_failure
-- statements: 1
-- This file is a faithful transcript of what Production actually ran.
-- Do not edit to "improve" it; corrections belong in a new forward migration.

begin;

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
  burn_cost := case
    when p_status = 'completed' then coalesce(p_actual_cost_usd, 0)
    when p_actual_cost_usd is not null then p_actual_cost_usd
    else 0
  end;

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

revoke all on function app.complete_model_usage(text, text, text, numeric, integer, integer) from public, anon, authenticated;
grant execute on function app.complete_model_usage(text, text, text, numeric, integer, integer) to service_role;

commit;
