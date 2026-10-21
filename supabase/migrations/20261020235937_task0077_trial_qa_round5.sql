-- TASK-0077: fix from the fifth PR #507 review (Codex, review of cfbd59b1).
-- Applied after 20261020233210.
--
-- F7. A failed-payment event the webhook retries (its processed mark failed
--     after the count committed) must not count twice. Each counted Stripe
--     event is recorded here in the same transaction as the increment, so a
--     repeat of the same event changes nothing; distinct events still each
--     count.

create table app.trial_recovery_failure_events (
  stripe_event_id text primary key check (stripe_event_id ~ '^evt_'),
  order_id uuid not null references app.trial_orders(id),
  counted_at timestamptz not null default now()
);
alter table app.trial_recovery_failure_events enable row level security;
alter table app.trial_recovery_failure_events force row level security;
revoke all on table app.trial_recovery_failure_events from public, anon, authenticated;
grant select, insert on table app.trial_recovery_failure_events to service_role;
create policy trial_recovery_failure_events_service on app.trial_recovery_failure_events
  for all to service_role using (true) with check (true);

drop function app.trial_count_recovery_failure(uuid, text);

-- Returns the order's attempt count after this event, or null when the intent
-- is not the order's. A repeat of an already counted event returns the
-- current count unchanged.
create function app.trial_count_recovery_failure(
  p_order_id uuid, p_payment_intent_id text, p_stripe_event_id text
) returns integer language plpgsql security invoker set search_path = '' as $$
declare
  v_count integer;
begin
  select recovery_attempts into v_count from app.trial_orders
  where id = p_order_id and payment_intent_id = p_payment_intent_id
  for update;
  if not found then return null; end if;
  insert into app.trial_recovery_failure_events (stripe_event_id, order_id)
  values (p_stripe_event_id, p_order_id)
  on conflict (stripe_event_id) do nothing;
  if not found then return v_count; end if;
  update app.trial_orders
  set recovery_attempts = recovery_attempts + 1, updated_at = now()
  where id = p_order_id
  returning recovery_attempts into v_count;
  return v_count;
end $$;

revoke all on function app.trial_count_recovery_failure(uuid, text, text) from public, anon, authenticated;
grant execute on function app.trial_count_recovery_failure(uuid, text, text) to service_role;
