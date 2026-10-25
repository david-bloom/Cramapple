-- Reddit Conversions API for day-7 trial charges
-- (docs/product/REDDIT_CONVERSIONS_API_DAY7_PLAN_2026_10_25.md; David 2026-10-25:
-- trial conversions only, click id only). Applied after the TASK-0077 migrations.
--
-- 1. trial_orders.reddit_click_id: the Reddit ad click id (rdt_cid) the
--    checkout page passed at trial start. Null when there was none or the
--    visitor had opted out. Nothing else about the visitor is stored for ads.
-- 2. app.ad_conversion_outbox: one row per converted order with a click id,
--    written in the same transaction as the conversion and delivered by the
--    charge worker. Service role only.
-- 3. trial_convert: unchanged except for that enqueue. Body otherwise
--    identical to 20261019142835 (md5 0f69a73c… on Production and Development,
--    2026-10-25).

alter table app.trial_orders add column reddit_click_id text
  check (reddit_click_id is null
         or (char_length(reddit_click_id) between 1 and 300 and reddit_click_id ~ '^[A-Za-z0-9._~-]+$'));

create table app.ad_conversion_outbox (
  id uuid primary key default gen_random_uuid(),
  order_id uuid not null references app.trial_orders(id),
  platform text not null check (platform in ('reddit')),
  event_type text not null check (event_type in ('PURCHASE')),
  click_id text not null,
  value_cents integer not null check (value_cents >= 0),
  currency text not null,
  event_at timestamptz not null,
  created_at timestamptz not null default now(),
  attempt_count integer not null default 0,
  next_attempt_at timestamptz not null default now(),
  lease_id uuid,
  leased_until timestamptz,
  delivered_at timestamptz,
  last_error text,
  needs_review boolean not null default false,
  unique (order_id, platform)
);
create index ad_conversion_outbox_pending_idx on app.ad_conversion_outbox (next_attempt_at)
  where delivered_at is null and not needs_review;
alter table app.ad_conversion_outbox enable row level security;
alter table app.ad_conversion_outbox force row level security;
revoke all on app.ad_conversion_outbox from public, anon, authenticated;
grant select, insert, update on app.ad_conversion_outbox to service_role;
create policy ad_conversion_outbox_service on app.ad_conversion_outbox
  for all to service_role using (true) with check (true);

-- Lease a batch for delivery (two-minute lease, attempt counted on claim).
create function app.claim_ad_conversions(p_limit integer default 10)
returns setof app.ad_conversion_outbox
language sql security invoker set search_path = '' as $$
  update app.ad_conversion_outbox j
  set lease_id = gen_random_uuid(),
      leased_until = now() + interval '2 minutes',
      attempt_count = j.attempt_count + 1
  where j.id in (
    select q.id from app.ad_conversion_outbox q
    where q.delivered_at is null and not q.needs_review
      and q.next_attempt_at <= now()
      and (q.leased_until is null or q.leased_until < now())
    order by q.next_attempt_at, q.created_at
    limit greatest(1, least(p_limit, 50))
    for update skip locked
  ) returning j.*;
$$;
revoke all on function app.claim_ad_conversions(integer) from public, anon, authenticated;
grant execute on function app.claim_ad_conversions(integer) to service_role;

create or replace function app.trial_convert(
  p_order_id uuid, p_payment_intent_id text, p_amount_received integer, p_currency text
) returns text language plpgsql security invoker set search_path = '' as $$
declare
  o app.trial_orders;
  v_subject uuid;
begin
  select * into o from app.trial_orders where id = p_order_id for update;
  if not found then return 'not_found'; end if;
  if o.payment_intent_id is distinct from p_payment_intent_id then
    update app.trial_orders set status = 'reconciling', reconcile_reason = 'payment_intent_mismatch',
      updated_at = now() where id = o.id;
    return 'mismatch';
  end if;
  if o.status = 'converted' then return 'already_converted'; end if;
  if o.status = 'refunded' then return 'already_refunded'; end if;
  if o.status in ('canceled', 'recovery_expired', 'disputed', 'setup_expired',
                  'pending_setup', 'activation_refused') then
    return 'refund_required';
  end if;
  if p_amount_received <> o.charge_amount or lower(p_currency) <> o.currency then
    update app.trial_orders set status = 'reconciling', reconcile_reason = 'amount_mismatch',
      updated_at = now() where id = o.id;
    return 'mismatch';
  end if;

  foreach v_subject in array o.subject_ids loop
    insert into app.subject_entitlements
      (user_id, subject_id, access_tier, status, source, external_reference, starts_at, ends_at)
    values
      (o.user_id, v_subject, 'paid', 'active', 'stripe_trial_conversion_' || o.offer,
       o.id::text, now(), null)
    on conflict (user_id, subject_id, access_tier, source) do update
      set status = 'active', external_reference = excluded.external_reference,
          ends_at = null, updated_at = now();
  end loop;
  perform app.trial_set_trial_access(o, 'expired', now());

  update app.trial_orders
  set status = 'converted', converted_at = now(),
      lease_token = null, lease_expires_at = null, next_attempt_at = null,
      updated_at = now()
  where id = o.id returning * into o;
  update app.trial_capabilities set voided_at = now()
  where order_id = o.id and voided_at is null;
  update app.trial_notice_jobs set cancelled_at = now()
  where order_id = o.id and delivered_at is null and cancelled_at is null
    and kind in ('reminder', 'payment_failed', 'requires_action', 'grace_ended', 'delayed_charge');
  perform app.trial_enqueue_notice(o, 'converted');
  -- Reddit Conversions API: queued in this transaction, delivered later by the
  -- charge worker; only when checkout recorded a Reddit click id (the page
  -- sends none when the visitor opted out or sends Global Privacy Control).
  if o.reddit_click_id is not null then
    insert into app.ad_conversion_outbox
      (order_id, platform, event_type, click_id, value_cents, currency, event_at)
    values (o.id, 'reddit', 'PURCHASE', o.reddit_click_id, o.charge_amount, o.currency, o.converted_at)
    on conflict (order_id, platform) do nothing;
  end if;
  return 'converted';
end $$;
