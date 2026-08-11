begin;

-- Idempotency ledger for the Stripe webhook receiver (TASK-0023). The
-- receiver inserts a row keyed by the Stripe event id before doing any
-- entitlement writes; a primary-key conflict on redelivery means the event
-- was already handled (or is being handled concurrently), so the receiver
-- can short-circuit without reprocessing. This is independent of, and in
-- addition to, the natural idempotency the subject_entitlements unique
-- constraint gives entitlement grants themselves.
create table app.stripe_webhook_events (
  id text primary key,
  event_type text not null,
  payload jsonb not null default '{}'::jsonb,
  received_at timestamptz not null default now(),
  processed_at timestamptz,
  processing_error text,
  created_at timestamptz not null default now()
);

alter table app.stripe_webhook_events enable row level security;

create policy "stripe_webhook_events_service_all"
on app.stripe_webhook_events
for all to service_role
using (true)
with check (true);

grant select, insert, update, delete on app.stripe_webhook_events to service_role;

commit;
