-- Revise app.complete_model_usage budget-burn semantics per owner Decision 2
-- (2026-06-22): failed/rejected grading should still burn the daily cap
-- when actual_cost_usd is known, instead of always burning zero.
--
-- Previous behaviour (202606210004): any status other than 'completed'
-- burned 0, regardless of whether the provider call actually incurred
-- cost (e.g. a grading call that got a billable response from OpenAI but
-- then failed downstream validation). That under-counted real spend
-- against OPENAI_DAILY_CAP_USD.
--
-- New behaviour:
--   completed                              -> burn actual_cost_usd (unchanged)
--   failed/rejected, actual_cost_usd known -> burn actual_cost_usd
--   failed/rejected, actual_cost_usd null  -> burn 0 (unchanged fallback)
--
-- This keeps OPENAI_DAILY_CAP_USD aligned with known provider spend while
-- avoiding inventing a cost figure when the caller has no usage data to
-- report (e.g. the request never reached the provider).
--
-- Follow-up: failed rows that complete with a null actual_cost_usd are
-- not reconciled against provider billing by this migration. That
-- reconciliation should happen during production monitoring (compare
-- app.model_usage_ledger against the OpenAI usage dashboard/API) rather
-- than being guessed here.
--
-- Reservation release behavior (reserved_cost_usd reduction on the
-- daily_budgets row) is unchanged.

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

  -- Burn known cost regardless of outcome. completed always has a cost;
  -- failed/rejected only burns when the caller reports a known
  -- actual_cost_usd (i.e. the provider call happened and had a cost).
  -- Failed/rejected with no known cost burns 0 rather than guessing.
  burn_cost := case
    when p_status = 'completed' then coalesce(p_actual_cost_usd, 0)
    when p_actual_cost_usd is not null then p_actual_cost_usd
    else 0
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
-- but we keep this explicit to match the pattern in prior migrations).
revoke all on function app.complete_model_usage(text, text, text, numeric, integer, integer)
  from public, anon, authenticated;
grant execute on function app.complete_model_usage(text, text, text, numeric, integer, integer)
  to service_role;

commit;
