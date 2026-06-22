-- Fix the concurrent-idempotency race in app.reserve_model_usage.
--
-- The prior version (202606210004) checked for an existing ledger row
-- BEFORE acquiring the daily_budgets row lock. Two concurrent callers
-- with the same request_id could both observe no existing row, both
-- proceed to the lock acquisition phase, both compute the cap, and then
-- one would INSERT into app.model_usage_ledger while the other would hit
-- the unique constraint and raise a unique_violation — instead of
-- returning the cached idempotent result.
--
-- This migration CREATE OR REPLACEs the function so the existence probe
-- runs both BEFORE and AFTER the lock. The pre-lock probe stays as a
-- fast-path optimisation for replays of already-completed requests. The
-- post-lock probe is the correctness guarantee: once we hold the daily
-- budget row lock, no concurrent caller can have raced past us into the
-- ledger insert, so re-checking and returning the existing row is safe.

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

  -- Fast-path replay check before any lock acquisition. If the row is
  -- already there from a prior call, return it without contending on the
  -- daily budget row. Race-safety is provided by the second check below.
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

  -- Upsert today's budget row, then lock it. The lock serialises all
  -- concurrent reservation attempts for this UTC date.
  insert into app.daily_budgets (usage_date_utc, cap_usd)
  values (current_date, p_cap_usd)
  on conflict (usage_date_utc) do update
    set cap_usd = coalesce(app.daily_budgets.cap_usd, excluded.cap_usd);

  select *
  into budget
  from app.daily_budgets
  where usage_date_utc = current_date
  for update;

  -- Re-check the ledger AFTER acquiring the lock. A concurrent caller may
  -- have raced through the pre-lock probe and inserted the ledger row
  -- between then and our lock acquisition. Returning the existing row
  -- here keeps idempotency intact and prevents a duplicate budget burn.
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

  projected_total := budget.reserved_cost_usd + budget.actual_cost_usd + p_reserved_cost_usd;
  if projected_total > p_cap_usd then
    raise exception 'daily cap exceeded';
  end if;

  update app.daily_budgets
    set reserved_cost_usd = reserved_cost_usd + p_reserved_cost_usd
    where usage_date_utc = current_date;

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

-- Re-assert grants. CREATE OR REPLACE preserves them in modern Postgres
-- but we keep this explicit to match the pattern in 202606210003 and
-- 202606210004.
revoke all on function app.reserve_model_usage(text, text, text, numeric, numeric)
  from public, anon, authenticated;
grant execute on function app.reserve_model_usage(text, text, text, numeric, numeric)
  to service_role;

commit;
