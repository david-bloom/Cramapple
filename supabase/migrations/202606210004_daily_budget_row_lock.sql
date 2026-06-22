-- Replace the global per-day advisory lock with a row-level lock on a
-- single daily-budget row.
--
-- Background: app.reserve_model_usage in
-- 202606200004_grading_results_and_model_ledger.sql (re-defined in 0003 of
-- the 2026-06-21 batch) uses:
--     perform pg_advisory_xact_lock(hashtext(current_date::text)::bigint);
-- to serialise the spend_total computation across concurrent reservations.
--
-- That lock is held until commit and is the SAME lock for every grading
-- call on a given UTC day. At Cramapple's stated scale (~2500 AP Bio
-- students for the Aug 2026 beta; exam-week tail latency is brand-critical
-- per memory), this serialises every concurrent FRQ grading start through
-- a single transactional lock, turning the budget reservation into a
-- throughput bottleneck.
--
-- This migration:
--   1. Adds app.daily_budgets as a one-row-per-day budget tracker
--   2. Rewrites reserve_model_usage to SELECT ... FOR UPDATE on that row
--      after upserting it, so only the budget row is contended — not the
--      entire ledger query path
--   3. Rewrites complete_model_usage to reconcile the daily_budgets row
--      when an in-flight reservation completes, so spend totals stay
--      consistent without re-summing the full ledger on every read
--   4. Preserves the EXECUTE grants from 202606210003 (re-asserted at the
--      bottom of this migration so they survive the CREATE OR REPLACE)
--
-- Net effect: a grading reservation now waits only on the budget row for
-- today, not on every other grading call's reservation phase.

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
on app.daily_budgets
for select
to service_role
using (true);

create policy "daily_budgets_service_only_insert"
on app.daily_budgets
for insert
to service_role
with check (true);

create policy "daily_budgets_service_only_update"
on app.daily_budgets
for update
to service_role
using (true)
with check (true);

grant select, insert, update on app.daily_budgets to service_role;

-- Seed today's row from existing ledger totals so the rewritten function
-- doesn't underestimate spend if there are in-flight reservations when
-- this migration applies.
insert into app.daily_budgets (usage_date_utc, reserved_cost_usd, actual_cost_usd)
select
  current_date,
  coalesce(sum(case when status in ('reserved', 'running') then reserved_cost_usd else 0 end), 0),
  coalesce(sum(case when status not in ('reserved', 'running') then coalesce(actual_cost_usd, 0) else 0 end), 0)
from app.model_usage_ledger
where usage_date_utc = current_date
on conflict (usage_date_utc) do nothing;

-- Rewrite reserve_model_usage to lock the daily_budgets row instead of an
-- advisory lock spanning the whole day. The row is upserted on first call
-- of the day and then SELECT ... FOR UPDATE serialises subsequent
-- reservations only against each other on the same row.
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

  -- Replay protection runs before any lock acquisition so duplicate
  -- requests don't unnecessarily contend on the budget row.
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

  -- Upsert today's budget row, then lock it. INSERT ... ON CONFLICT
  -- followed by SELECT ... FOR UPDATE gives us a row to wait on even on
  -- the first reservation of the day.
  insert into app.daily_budgets (usage_date_utc, cap_usd)
  values (current_date, p_cap_usd)
  on conflict (usage_date_utc) do update
    set cap_usd = coalesce(app.daily_budgets.cap_usd, excluded.cap_usd);

  select *
  into budget
  from app.daily_budgets
  where usage_date_utc = current_date
  for update;

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

-- Rewrite complete_model_usage so it reconciles the daily_budgets row when
-- a reservation completes. We subtract the original reservation from
-- reserved_cost_usd and add the actual cost to actual_cost_usd (or zero
-- for failed/rejected outcomes, so failed grading doesn't burn budget
-- against the cap).
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
  -- Lock the ledger row to prevent double-completion races.
  select *
  into existing
  from app.model_usage_ledger
  where request_id = p_request_id
    and request_hash = p_request_hash
  for update;

  if not found then
    raise exception 'usage request not found';
  end if;

  -- If already completed (replay), return the existing row unchanged.
  if existing.status not in ('reserved', 'running') then
    return existing;
  end if;

  prior_reserved := existing.reserved_cost_usd;
  burn_cost := case
    when p_status in ('completed') then coalesce(p_actual_cost_usd, 0)
    else 0  -- failed / rejected reservations do not count against the cap
  end;

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

  update app.daily_budgets
  set
    reserved_cost_usd = greatest(0, reserved_cost_usd - prior_reserved),
    actual_cost_usd = actual_cost_usd + burn_cost
  where usage_date_utc = existing.usage_date_utc;

  return existing;
end;
$$;

-- Re-assert grants (CREATE OR REPLACE preserves them in modern Postgres,
-- but we keep this explicit to match the pattern in 202606210003 and
-- defend against future Postgres semantic changes).
revoke all on function app.reserve_model_usage(text, text, text, numeric, numeric)
  from public, anon, authenticated;
grant execute on function app.reserve_model_usage(text, text, text, numeric, numeric)
  to service_role;

revoke all on function app.complete_model_usage(text, text, text, numeric, integer, integer)
  from public, anon, authenticated;
grant execute on function app.complete_model_usage(text, text, text, numeric, integer, integer)
  to service_role;

commit;
