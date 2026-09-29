-- TASK-0041 Development/runtime repair for purchase funnel.
-- Idempotent: creates only the payment tables/mapping missing from drifted environments.

begin;

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

alter table app.stripe_checkout_sessions enable row level security;
drop policy if exists "stripe_checkout_sessions_service_all" on app.stripe_checkout_sessions;
create policy "stripe_checkout_sessions_service_all"
on app.stripe_checkout_sessions for all to service_role
using (true) with check (true);
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

alter table app.stripe_checkout_session_attempts enable row level security;
drop policy if exists "stripe_checkout_session_attempts_service_all"
  on app.stripe_checkout_session_attempts;
create policy "stripe_checkout_session_attempts_service_all"
on app.stripe_checkout_session_attempts for all to service_role
using (true) with check (true);
grant select, insert, update, delete on app.stripe_checkout_session_attempts to service_role;

create table if not exists app.stripe_customers (
  user_id uuid primary key,
  stripe_customer_id text not null unique,
  default_payment_method_id text,
  source_checkout_session_id text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table app.stripe_customers enable row level security;
drop policy if exists "stripe_customers_service_all" on app.stripe_customers;
create policy "stripe_customers_service_all"
on app.stripe_customers for all to service_role
using (true) with check (true);
grant select, insert, update, delete on app.stripe_customers to service_role;

commit;
