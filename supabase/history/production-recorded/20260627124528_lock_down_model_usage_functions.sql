-- Exported from Production migration history (supabase_migrations.schema_migrations)
-- version: 20260627124528
-- recorded name: lock_down_model_usage_functions
-- statements: 1
-- This file is a faithful transcript of what Production actually ran.
-- Do not edit to "improve" it; corrections belong in a new forward migration.

-- Lock down the SECURITY DEFINER functions that manage the daily model budget.

begin;

revoke all on function app.reserve_model_usage(text, text, text, numeric, numeric)
  from public, anon, authenticated;
grant execute on function app.reserve_model_usage(text, text, text, numeric, numeric)
  to service_role;

revoke all on function app.complete_model_usage(text, text, text, numeric, integer, integer)
  from public, anon, authenticated;
grant execute on function app.complete_model_usage(text, text, text, numeric, integer, integer)
  to service_role;

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
  if p_reserved_cost_usd is null or p_reserved_cost_usd <= 0 then
    raise exception 'invalid reservation amount';
  end if;

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
    request_id, request_hash, usage_date_utc, reserved_cost_usd, status, model_id
  )
  values (
    p_request_id, p_request_hash, current_date, p_reserved_cost_usd, 'reserved', p_model_id
  )
  returning * into existing;

  return existing;
end;
$$;

revoke all on function app.reserve_model_usage(text, text, text, numeric, numeric)
  from public, anon, authenticated;
grant execute on function app.reserve_model_usage(text, text, text, numeric, numeric)
  to service_role;

revoke all on function app.complete_model_usage(text, text, text, numeric, integer, integer)
  from public, anon, authenticated;
grant execute on function app.complete_model_usage(text, text, text, numeric, integer, integer)
  to service_role;

commit;
