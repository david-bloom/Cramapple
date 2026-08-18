begin;

-- TASK-0023: extend the existing entitlement table to support Stripe-granted
-- access instead of introducing a parallel table. `stripe_checkout_session_id`
-- and `stripe_event_id` give each row a traceable link back to the Stripe
-- purchase that created it; `all_subjects` tags rows created by an unlimited
-- purchase so reporting can identify unlimited holders without counting rows.
alter table app.subject_entitlements
  add column stripe_checkout_session_id text,
  add column stripe_event_id text,
  add column all_subjects boolean not null default false;

create index subject_entitlements_stripe_checkout_session_id_idx
  on app.subject_entitlements (stripe_checkout_session_id)
  where stripe_checkout_session_id is not null;

create index subject_entitlements_stripe_event_id_idx
  on app.subject_entitlements (stripe_event_id)
  where stripe_event_id is not null;

-- Unlimited access is implemented as one entitlement row per subject (tagged
-- all_subjects = true) rather than a nullable-subject wildcard row, so every
-- existing reader of subject_entitlements keeps working unchanged. This
-- trigger is what makes "unlimited" actually cover subjects added after the
-- purchase: whenever a new subject is inserted, every user with an active
-- all_subjects row is backfilled with an entitlement for it.
create or replace function app.grant_unlimited_holders_new_subject()
returns trigger
language plpgsql
security definer
set search_path = app, public
as $$
begin
  insert into app.subject_entitlements (
    user_id, subject_id, access_tier, status, source, all_subjects, starts_at
  )
  select distinct se.user_id, new.id, se.access_tier, 'active', se.source, true, now()
  from app.subject_entitlements se
  where se.all_subjects = true
    and se.status = 'active'
  on conflict (user_id, subject_id, access_tier, source) do nothing;
  return new;
end;
$$;

revoke all on function app.grant_unlimited_holders_new_subject() from public, anon, authenticated;
grant execute on function app.grant_unlimited_holders_new_subject() to service_role;

create trigger subjects_grant_unlimited_holders
after insert on app.subjects
for each row execute function app.grant_unlimited_holders_new_subject();

commit;
