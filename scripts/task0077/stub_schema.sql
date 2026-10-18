-- Minimal stand-ins for the objects 20261018200000_task0077_card_trial_orders.sql
-- depends on, so the migration and its state machine can be tested on a
-- throwaway local Postgres. Not a migration.
do $$ begin
  if not exists (select 1 from pg_roles where rolname = 'anon') then create role anon; end if;
  if not exists (select 1 from pg_roles where rolname = 'authenticated') then create role authenticated; end if;
  if not exists (select 1 from pg_roles where rolname = 'service_role') then create role service_role; end if;
end $$;
create schema app; create schema auth;
create table auth.users (id uuid primary key, email text);
create table app.profiles (user_id uuid primary key references auth.users(id));
create table app.subjects (id uuid primary key default gen_random_uuid(), subject_key text unique);
create table app.subject_entitlements (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references app.profiles(user_id) on delete cascade,
  subject_id uuid not null references app.subjects(id) on delete cascade,
  access_tier text not null check (access_tier in ('beta','paid','trial')),
  status text not null check (status in ('active','revoked','expired')),
  source text not null,
  external_reference text,
  starts_at timestamptz not null default now(),
  ends_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  all_subjects boolean not null default false,
  constraint subject_entitlements_dates_check check (ends_at is null or ends_at > starts_at),
  constraint subject_entitlements_unique unique (user_id, subject_id, access_tier, source)
);
create table app.growth_event_outbox (
  id uuid primary key default gen_random_uuid(),
  event_name text not null,
  constraint growth_event_outbox_event_name_check check (event_name in ('landing_view'))
);

-- Vault and pg_net stand-ins for 20261018200100 (never called in tests).
create schema if not exists vault;
create table if not exists vault.decrypted_secrets (name text, decrypted_secret text);
create schema if not exists net;
create or replace function net.http_post(url text, headers jsonb, body jsonb, timeout_milliseconds int)
returns bigint language sql as $$ select 0::bigint $$;
