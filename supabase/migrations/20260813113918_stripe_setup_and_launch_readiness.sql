-- Reconcile the live Production Stripe checkout/webhook schema back into the
-- repo. Production already had these objects when this migration was authored;
-- every DDL statement is idempotent so the file is safe as a source-of-truth
-- catch-up migration and for fresh environments.

begin;

alter table app.subject_entitlements
  add column if not exists stripe_checkout_session_id text,
  add column if not exists stripe_event_id text,
  add column if not exists all_subjects boolean not null default false;

create index if not exists subject_entitlements_stripe_checkout_session_id_idx
  on app.subject_entitlements (stripe_checkout_session_id)
  where stripe_checkout_session_id is not null;

create index if not exists subject_entitlements_stripe_event_id_idx
  on app.subject_entitlements (stripe_event_id)
  where stripe_event_id is not null;

alter table app.growth_event_outbox
  drop constraint if exists growth_event_outbox_event_name_check;

alter table app.growth_event_outbox
  add constraint growth_event_outbox_event_name_check check (event_name in (
    'landing_view', 'demo_started', 'signup_started', 'trial_started',
    'first_response_graded', 'repair_completed', 'returned_day_2',
    'returned_day_7', 'checkout_started', 'checkout_payment_pending',
    'checkout_async_payment_failed', 'checkout_expired',
    'purchase_completed', 'referral_shared', 'referred_trial_started',
    'referred_purchase'
  ));

create table if not exists app.stripe_checkout_sessions (
  id text primary key,
  user_id uuid,
  mode text,
  status text not null,
  payment_status text,
  currency text,
  amount_subtotal integer,
  amount_total integer,
  amount_discount integer not null default 0,
  subject_keys text[] not null default '{}'::text[],
  coupon_ids text[] not null default '{}'::text[],
  promotion_code_ids text[] not null default '{}'::text[],
  promotion_codes text[] not null default '{}'::text[],
  discount_details jsonb not null default '[]'::jsonb,
  payload jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists stripe_checkout_sessions_user_id_idx
  on app.stripe_checkout_sessions (user_id)
  where user_id is not null;

create index if not exists stripe_checkout_sessions_status_idx
  on app.stripe_checkout_sessions (status);

create index if not exists stripe_checkout_sessions_coupon_ids_idx
  on app.stripe_checkout_sessions using gin (coupon_ids);

create index if not exists stripe_checkout_sessions_promotion_code_ids_idx
  on app.stripe_checkout_sessions using gin (promotion_code_ids);

alter table app.stripe_checkout_sessions enable row level security;

drop policy if exists "stripe_checkout_sessions_service_all"
  on app.stripe_checkout_sessions;
create policy "stripe_checkout_sessions_service_all"
on app.stripe_checkout_sessions
for all to service_role
using (true)
with check (true);

grant select, insert, update, delete on app.stripe_checkout_sessions to service_role;

create table if not exists app.stripe_checkout_session_attempts (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  mode text,
  subject_keys text[] not null default '{}'::text[],
  status text not null,
  stripe_error_type text,
  stripe_error_code text,
  stripe_error_param text,
  error_message text,
  created_at timestamptz not null default now()
);

create index if not exists stripe_checkout_session_attempts_created_at_idx
  on app.stripe_checkout_session_attempts (created_at desc);

create index if not exists stripe_checkout_session_attempts_user_id_idx
  on app.stripe_checkout_session_attempts (user_id)
  where user_id is not null;

alter table app.stripe_checkout_session_attempts enable row level security;

drop policy if exists "stripe_checkout_session_attempts_service_all"
  on app.stripe_checkout_session_attempts;
create policy "stripe_checkout_session_attempts_service_all"
on app.stripe_checkout_session_attempts
for all to service_role
using (true)
with check (true);

grant select, insert, update, delete on app.stripe_checkout_session_attempts to service_role;

create table if not exists app.stripe_webhook_events (
  id text primary key,
  event_type text not null,
  payload jsonb not null default '{}'::jsonb,
  received_at timestamptz not null default now(),
  processed_at timestamptz,
  processing_error text,
  created_at timestamptz not null default now()
);

alter table app.stripe_webhook_events enable row level security;

drop policy if exists "stripe_webhook_events_service_all"
  on app.stripe_webhook_events;
create policy "stripe_webhook_events_service_all"
on app.stripe_webhook_events
for all to service_role
using (true)
with check (true);

grant select, insert, update, delete on app.stripe_webhook_events to service_role;

commit;
