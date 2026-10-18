-- TASK-0077: seven-day free trial with a saved card (DECISION-0126).
-- Plan: docs/product/SEVEN_DAY_CARD_TRIAL_PLAN_2026_10_18.md (v3), §6.
--
-- Additive only. No client role can read or write any table here; every state
-- change goes through a service-only function that locks the order row and
-- checks the expected prior state. Stripe calls happen in edge functions,
-- outside these transactions.

-- ---------------------------------------------------------------------------
-- Orders
-- ---------------------------------------------------------------------------
create table app.trial_orders (
  id uuid primary key default gen_random_uuid(),
  purchase_type text not null
    check (purchase_type in ('student_direct', 'parent_share')),
  student_email text not null,
  student_email_norm text not null
    check (student_email_norm = lower(btrim(student_email_norm))),
  student_name text,
  -- Filled at activation. Deleting a learner must cancel their trials first
  -- (plan §6.16), so a profile with an order cannot be removed.
  user_id uuid references app.profiles(user_id) on delete restrict,

  offer text not null check (offer in ('single', 'bundle_2', 'bundle_3')),
  subject_ids uuid[] not null check (cardinality(subject_ids) between 1 and 3),
  subject_keys text[] not null,
  price_id text not null,
  currency text not null default 'usd' check (currency = 'usd'),

  -- Locked quote (DECISION-0126 item 3): never recomputed at charge time.
  list_amount integer not null check (list_amount > 0),
  discount_amount integer not null default 0 check (discount_amount >= 0),
  charge_amount integer not null check (charge_amount >= 50),
  quote_version text not null,
  quote_expires_at timestamptz not null,
  promotion_code_id text,
  coupon_id text,
  promo_code text,
  promo_use_state text
    check (promo_use_state in ('reserved', 'redeemed', 'released')),

  checkout_session_id text unique,
  setup_intent_id text unique,
  stripe_customer_id text,
  payment_method_id text,
  payment_intent_id text unique,

  -- The parent's email is captured from the completed setup, never from the
  -- request that created the link.
  payer_email text,
  payer_is_learner boolean not null,

  student_ack_version text not null,
  student_ack_at timestamptz not null,
  student_ack_source text not null,
  payer_accept_version text,
  payer_accept_at timestamptz,
  payer_accept_source text,
  mandate_text_version text not null,
  consent_ip inet,
  consent_user_agent text,

  trial_started_at timestamptz,
  trial_ends_at timestamptz,
  first_failure_at timestamptz,
  grace_ends_at timestamptz,
  recovery_expires_at timestamptz,
  delayed_notice_at timestamptz,
  canceled_at timestamptz,
  canceled_by text check (canceled_by in ('student', 'parent', 'deletion', 'operator')),
  cancel_outcome text check (cancel_outcome in ('no_charge', 'pending', 'refunded')),
  converted_at timestamptz,
  stripe_cleanup_done_at timestamptz,

  status text not null default 'pending_setup' check (status in (
    'pending_setup', 'setup_expired', 'activation_refused', 'trialing', 'charging',
    'payment_failed', 'requires_action', 'recovery_only', 'recovery_expired',
    'delayed_notice', 'reconciling', 'converted', 'canceled', 'refunded',
    'disputed'
  )),
  -- What the current claim is for: a first charge, the one retry, a charge
  -- delayed by our outage, or reconciling a stale lease.
  charge_phase text check (charge_phase in ('first', 'retry', 'delayed', 'reconcile')),
  attempt_count integer not null default 0 check (attempt_count between 0 and 3),
  next_attempt_at timestamptz,
  lease_token uuid,
  lease_expires_at timestamptz,
  last_error_code text,
  last_decline_code text,
  reconcile_reason text,
  recovery_attempts integer not null default 0 check (recovery_attempts >= 0),

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  check (list_amount - discount_amount = charge_amount),
  check (cardinality(subject_keys) = cardinality(subject_ids)),
  check (payer_is_learner = (purchase_type = 'student_direct')),
  check (trial_ends_at is null or trial_ends_at = trial_started_at + interval '7 days'),
  -- Every status after these means the trial started; canceled may be either.
  check (status in ('pending_setup', 'setup_expired', 'activation_refused', 'canceled')
    or trial_started_at is not null),
  check (trial_started_at is null
    or (payment_intent_id is not null and user_id is not null and payer_email is not null)),
  -- Whoever pays accepts the Terms (DECISION-0126 items 8, 17).
  check (purchase_type = 'student_direct' or trial_started_at is null
    or payer_accept_at is not null)
);

-- One pending order per student email at a time.
create unique index trial_orders_one_pending_per_email
  on app.trial_orders (student_email_norm) where status = 'pending_setup';
create index trial_orders_due_idx
  on app.trial_orders (status, trial_ends_at, next_attempt_at);
create index trial_orders_user_idx on app.trial_orders (user_id);
create index trial_orders_customer_idx on app.trial_orders (stripe_customer_id);

-- ---------------------------------------------------------------------------
-- Eligibility ledger (DECISION-0126 items 6, 26, 31): one trial per student
-- email, ever, kept indefinitely as a hash.
-- ---------------------------------------------------------------------------
create table app.trial_consumed_emails (
  email_hash text primary key check (email_hash ~ '^[0-9a-f]{64}$'),
  source text not null check (source in ('trial_v1', 'stripe_trial_v1')),
  order_id uuid references app.trial_orders(id),
  consumed_at timestamptz not null default now()
);

create function app.trial_email_hash(p_email text)
returns text language sql immutable set search_path = '' as $$
  select encode(sha256(convert_to(lower(btrim(p_email)), 'UTF8')), 'hex');
$$;

create function app.trial_email_consumed(p_email text)
returns boolean language sql stable security invoker set search_path = '' as $$
  select exists (
    select 1 from app.trial_consumed_emails
    where email_hash = app.trial_email_hash(p_email)
  );
$$;

-- Legacy cardless trials count as used (plan §6.11).
insert into app.trial_consumed_emails (email_hash, source, consumed_at)
select app.trial_email_hash(u.email), 'trial_v1', min(e.created_at)
from app.subject_entitlements e
join auth.users u on u.id = e.user_id
where e.source = 'trial_v1' and u.email is not null and btrim(u.email) <> ''
group by app.trial_email_hash(u.email)
on conflict (email_hash) do nothing;

-- ---------------------------------------------------------------------------
-- Cancel and recovery links (plan §6.1): only a hash of the token is stored.
-- ---------------------------------------------------------------------------
create table app.trial_capabilities (
  id uuid primary key default gen_random_uuid(),
  order_id uuid not null references app.trial_orders(id),
  purpose text not null check (purpose in ('parent_cancel', 'payer_recovery')),
  token_hash text not null unique check (token_hash ~ '^[0-9a-f]{64}$'),
  expires_at timestamptz not null,
  voided_at timestamptz,
  created_at timestamptz not null default now()
);
-- Each email carries its own token, so an order can hold several live
-- tokens per purpose; all are voided together on cancel or conversion.
create index trial_capabilities_order_idx on app.trial_capabilities (order_id, purpose);

-- ---------------------------------------------------------------------------
-- Notice jobs (plan §6.13). Written in the same transaction as the state
-- change; the worker renders and sends, rechecking order state first.
-- ---------------------------------------------------------------------------
create table app.trial_notice_jobs (
  id uuid primary key default gen_random_uuid(),
  dedupe_key text not null unique,
  order_id uuid not null references app.trial_orders(id),
  kind text not null check (kind in (
    'trial_started', 'reminder', 'payment_failed', 'requires_action',
    'grace_ended', 'delayed_charge', 'canceled', 'converted', 'refunded'
  )),
  recipient_role text not null check (recipient_role in ('payer', 'student')),
  due_at timestamptz not null default now(),
  next_attempt_at timestamptz not null default now(),
  created_at timestamptz not null default now(),
  delivered_at timestamptz,
  cancelled_at timestamptz,
  attempt_count integer not null default 0 check (attempt_count >= 0),
  lease_id uuid,
  leased_until timestamptz,
  last_error text,
  needs_review boolean not null default false
);

create index trial_notice_jobs_pending_idx
  on app.trial_notice_jobs (next_attempt_at, due_at)
  where delivered_at is null and cancelled_at is null and not needs_review;
create index trial_notice_jobs_order_idx on app.trial_notice_jobs (order_id);

-- Single heartbeat row for the trial workers (plan §6.5).
create table app.trial_worker_heartbeat (
  worker text primary key check (worker in ('charge', 'notice')),
  last_run_at timestamptz not null,
  last_summary jsonb not null default '{}'::jsonb
);

-- ---------------------------------------------------------------------------
-- Privileges
-- ---------------------------------------------------------------------------
do $$
declare t text;
begin
  foreach t in array array[
    'trial_orders', 'trial_consumed_emails', 'trial_capabilities',
    'trial_notice_jobs', 'trial_worker_heartbeat'
  ] loop
    execute format('alter table app.%I enable row level security', t);
    execute format('alter table app.%I force row level security', t);
    execute format('revoke all on app.%I from public, anon, authenticated', t);
    execute format('grant select, insert, update on app.%I to service_role', t);
    execute format(
      'create policy %I on app.%I for all to service_role using (true) with check (true)',
      t || '_service', t);
  end loop;
end $$;

-- ---------------------------------------------------------------------------
-- Internal helpers
-- ---------------------------------------------------------------------------

-- Queue a notice for the payer and, on parent-pay, the student too
-- (DECISION-0126 items 11, 13).
create function app.trial_enqueue_notice(
  p_order app.trial_orders, p_kind text, p_due_at timestamptz default now(),
  p_key_suffix text default ''
) returns void language plpgsql security invoker set search_path = '' as $$
begin
  insert into app.trial_notice_jobs (dedupe_key, order_id, kind, recipient_role, due_at, next_attempt_at)
  values (p_order.id || ':' || p_kind || ':payer' || p_key_suffix, p_order.id, p_kind, 'payer', p_due_at, p_due_at)
  on conflict (dedupe_key) do nothing;
  if p_order.purchase_type = 'parent_share' then
    insert into app.trial_notice_jobs (dedupe_key, order_id, kind, recipient_role, due_at, next_attempt_at)
    values (p_order.id || ':' || p_kind || ':student' || p_key_suffix, p_order.id, p_kind, 'student', p_due_at, p_due_at)
    on conflict (dedupe_key) do nothing;
  end if;
end $$;

-- Move this order's trial access to a new end (grace, delayed notice) or end
-- it now. Never touches another order's or another source's rows.
create function app.trial_set_trial_access(
  p_order app.trial_orders, p_status text, p_ends_at timestamptz
) returns void language sql security invoker set search_path = '' as $$
  update app.subject_entitlements e
  set status = p_status,
      ends_at = greatest(p_ends_at, e.starts_at + interval '1 millisecond'),
      updated_at = now()
  where e.user_id = p_order.user_id
    and e.access_tier = 'trial'
    and e.source = 'stripe_trial_v1'
    and e.external_reference = p_order.id::text;
$$;

create function app.trial_set_paid_access(
  p_order app.trial_orders, p_status text
) returns void language sql security invoker set search_path = '' as $$
  update app.subject_entitlements e
  set status = p_status,
      ends_at = case when p_status = 'active' then null
                     else greatest(now(), e.starts_at + interval '1 millisecond') end,
      updated_at = now()
  where e.user_id = p_order.user_id
    and e.access_tier = 'paid'
    and e.source = 'stripe_trial_conversion_' || p_order.offer
    and e.external_reference = p_order.id::text;
$$;

-- ---------------------------------------------------------------------------
-- Activation (plan §6.4): the PaymentIntent already exists; its id lands in
-- the same transaction as the grant.
-- ---------------------------------------------------------------------------
create function app.trial_activate(
  p_order_id uuid,
  p_user_id uuid,
  p_payment_intent_id text,
  p_setup_intent_id text,
  p_payment_method_id text,
  p_payer_email text,
  p_started_at timestamptz,
  p_payer_accept_version text default null,
  p_payer_accept_source text default null
) returns text language plpgsql security invoker set search_path = '' as $$
declare
  o app.trial_orders;
  v_ends timestamptz;
  v_subject uuid;
begin
  select * into o from app.trial_orders where id = p_order_id for update;
  if not found then return 'not_found'; end if;
  if o.status <> 'pending_setup' then
    return case when o.payment_intent_id = p_payment_intent_id then 'already_active'
                else 'bad_state' end;
  end if;

  insert into app.trial_consumed_emails (email_hash, source, order_id, consumed_at)
  values (app.trial_email_hash(o.student_email_norm), 'stripe_trial_v1', o.id, p_started_at)
  on conflict (email_hash) do nothing;
  if not found then
    -- The caller cancels the unconfirmed PaymentIntent and detaches the card.
    update app.trial_orders
    set status = 'activation_refused', reconcile_reason = 'email_consumed',
        promo_use_state = case when promotion_code_id is not null then 'released' else promo_use_state end,
        updated_at = now()
    where id = o.id;
    return 'email_consumed';
  end if;

  v_ends := p_started_at + interval '7 days';
  update app.trial_orders
  set status = 'trialing',
      user_id = p_user_id,
      payment_intent_id = p_payment_intent_id,
      setup_intent_id = p_setup_intent_id,
      payment_method_id = p_payment_method_id,
      payer_email = lower(btrim(p_payer_email)),
      payer_accept_version = coalesce(p_payer_accept_version, payer_accept_version),
      payer_accept_at = case when p_payer_accept_version is not null then now() else payer_accept_at end,
      payer_accept_source = coalesce(p_payer_accept_source, payer_accept_source),
      trial_started_at = p_started_at,
      trial_ends_at = v_ends,
      promo_use_state = case when promotion_code_id is not null then 'redeemed' else promo_use_state end,
      updated_at = now()
  where id = o.id
  returning * into o;

  foreach v_subject in array o.subject_ids loop
    insert into app.subject_entitlements
      (user_id, subject_id, access_tier, status, source, external_reference, starts_at, ends_at)
    values
      (o.user_id, v_subject, 'trial', 'active', 'stripe_trial_v1', o.id::text,
       least(p_started_at, now()), v_ends)
    on conflict (user_id, subject_id, access_tier, source) do update
      set status = 'active', external_reference = excluded.external_reference,
          starts_at = excluded.starts_at, ends_at = excluded.ends_at, updated_at = now();
  end loop;

  perform app.trial_enqueue_notice(o, 'trial_started');
  -- Day 5: 48 hours before the charge (plan §6.13).
  perform app.trial_enqueue_notice(o, 'reminder', v_ends - interval '48 hours');
  return 'activated';
end $$;

-- ---------------------------------------------------------------------------
-- Sweep (run by the charge worker before claiming): pending expiry, grace
-- expiry, recovery expiry and our-fault delays (plan §6.6, §6.12).
-- ---------------------------------------------------------------------------
create function app.trial_sweep()
returns jsonb language plpgsql security invoker set search_path = '' as $$
declare
  o app.trial_orders;
  n_pending int := 0; n_grace int := 0; n_recovery int := 0; n_delayed int := 0;
  v_next timestamptz;
begin
  update app.trial_orders
  set status = 'setup_expired',
      promo_use_state = case when promotion_code_id is not null then 'released' else promo_use_state end,
      updated_at = now()
  where status = 'pending_setup' and quote_expires_at < now();
  get diagnostics n_pending = row_count;

  -- Grace over with no retry left: access lapses by itself at grace_ends_at.
  for o in
    select * from app.trial_orders
    where status in ('payment_failed', 'requires_action')
      and next_attempt_at is null and grace_ends_at <= now()
    for update skip locked
  loop
    update app.trial_orders
    set status = 'recovery_only',
        recovery_expires_at = o.grace_ends_at + interval '30 days',
        updated_at = now()
    where id = o.id returning * into o;
    perform app.trial_enqueue_notice(o, 'grace_ended');
    n_grace := n_grace + 1;
  end loop;

  update app.trial_orders
  set status = 'recovery_expired', updated_at = now()
  where status = 'recovery_only' and recovery_expires_at <= now();
  get diagnostics n_recovery = row_count;

  -- A due attempt the worker reached outside its window is our fault: no
  -- charge; 48 hours' notice; access continues (DECISION-0126 items 16, 20).
  for o in
    select * from app.trial_orders
    where (status = 'trialing' and now() > trial_ends_at + interval '2 hours')
       or (status = 'payment_failed' and next_attempt_at is not null
           and now() > grace_ends_at)
       or (status = 'delayed_notice' and now() > next_attempt_at + interval '2 hours')
    for update skip locked
  loop
    v_next := now() + interval '48 hours';
    update app.trial_orders
    set status = 'delayed_notice',
        delayed_notice_at = now(),
        next_attempt_at = v_next,
        updated_at = now()
    where id = o.id returning * into o;
    perform app.trial_set_trial_access(o, 'active', v_next + interval '1 hour');
    perform app.trial_enqueue_notice(o, 'delayed_charge', now(),
      ':' || extract(epoch from v_next)::bigint);
    n_delayed := n_delayed + 1;
  end loop;

  return jsonb_build_object('pending_expired', n_pending, 'grace_ended', n_grace,
    'recovery_expired', n_recovery, 'delayed', n_delayed);
end $$;

-- ---------------------------------------------------------------------------
-- Claim (plan §6.5): only attempts inside their window, plus stale leases to
-- reconcile. attempt_count counts business attempts, not lease claims.
-- ---------------------------------------------------------------------------
create function app.trial_claim_due(p_limit integer default 10)
returns setof app.trial_orders
language sql security invoker set search_path = '' as $$
  with due as (
    select q.id,
      case
        when q.status = 'charging' then 'reconcile'
        when q.status = 'trialing' then 'first'
        when q.status = 'payment_failed' then 'retry'
        else 'delayed'
      end as phase
    from app.trial_orders q
    where (q.status = 'trialing'
             and now() between q.trial_ends_at and q.trial_ends_at + interval '2 hours')
       or (q.status = 'payment_failed' and q.next_attempt_at is not null
             and now() between q.next_attempt_at and q.grace_ends_at)
       or (q.status = 'delayed_notice'
             and now() between q.next_attempt_at and q.next_attempt_at + interval '2 hours')
       or (q.status = 'charging' and q.lease_expires_at < now())
    order by coalesce(q.next_attempt_at, q.trial_ends_at)
    limit greatest(1, least(p_limit, 25))
    for update skip locked
  )
  update app.trial_orders o
  set status = 'charging',
      charge_phase = due.phase,
      attempt_count = case when due.phase = 'reconcile' then o.attempt_count
                           else o.attempt_count + 1 end,
      lease_token = gen_random_uuid(),
      lease_expires_at = now() + interval '5 minutes',
      updated_at = now()
  from due
  where o.id = due.id
  returning o.*;
$$;

-- ---------------------------------------------------------------------------
-- Worker outcome for a claimed attempt. Compare-and-set on the lease token so
-- a stale worker cannot overwrite newer state.
-- ---------------------------------------------------------------------------
create function app.trial_record_attempt(
  p_order_id uuid, p_lease_token uuid, p_outcome text,
  p_error_code text default null, p_decline_code text default null
) returns text language plpgsql security invoker set search_path = '' as $$
declare
  o app.trial_orders;
  v_grace timestamptz;
  v_first boolean;
begin
  select * into o from app.trial_orders
  where id = p_order_id and lease_token = p_lease_token and status = 'charging'
  for update;
  if not found then return 'stale_lease'; end if;

  if p_outcome in ('declined_retryable', 'declined_hard', 'requires_action') then
    v_first := o.first_failure_at is null;
    -- Grace is the original trial end + 24 h (DECISION-0126 item 5). Only a
    -- charge we delayed ourselves starts grace from the actual attempt.
    v_grace := coalesce(o.grace_ends_at,
      case when o.charge_phase = 'delayed' then now() else o.trial_ends_at end
        + interval '24 hours');
    update app.trial_orders
    set status = case when p_outcome = 'requires_action' then 'requires_action' else 'payment_failed' end,
        first_failure_at = coalesce(first_failure_at, now()),
        grace_ends_at = v_grace,
        -- One automatic retry, only after a first retryable decline.
        next_attempt_at = case
          when v_first and p_outcome = 'declined_retryable' and o.attempt_count < 2
            then v_grace - interval '1 hour'
          else null end,
        last_error_code = p_error_code,
        last_decline_code = p_decline_code,
        lease_token = null, lease_expires_at = null,
        updated_at = now()
    where id = o.id returning * into o;
    if v_first then
      -- Grace is applied once (DECISION-0126 item 5).
      perform app.trial_set_trial_access(o, 'active', v_grace);
      perform app.trial_enqueue_notice(o,
        case when p_outcome = 'requires_action' then 'requires_action' else 'payment_failed' end);
    end if;
    return o.status;
  elsif p_outcome = 'transport_error' then
    update app.trial_orders
    set status = 'reconciling', reconcile_reason = 'transport_error',
        last_error_code = p_error_code, lease_token = null, lease_expires_at = null,
        updated_at = now()
    where id = o.id;
    return 'reconciling';
  elsif p_outcome in ('succeeded_observed', 'processing') then
    -- The webhook converts. Keep the order claimed for a while so a missing
    -- webhook is reconciled on a later run.
    update app.trial_orders
    set lease_expires_at = now() + interval '30 minutes', updated_at = now()
    where id = o.id;
    return 'charging';
  elsif p_outcome = 'canceled_observed' then
    update app.trial_orders
    set status = 'reconciling', reconcile_reason = 'payment_intent_canceled',
        lease_token = null, lease_expires_at = null, updated_at = now()
    where id = o.id;
    return 'reconciling';
  end if;
  raise exception 'unknown trial attempt outcome %', p_outcome;
end $$;

-- ---------------------------------------------------------------------------
-- Conversion (webhook payment_intent.succeeded). Returns 'refund_required'
-- when the order was canceled first (DECISION-0126 item 19).
-- ---------------------------------------------------------------------------
create function app.trial_convert(
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
  if o.status in ('canceled', 'recovery_expired', 'refunded', 'disputed', 'setup_expired',
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
  return 'converted';
end $$;

-- ---------------------------------------------------------------------------
-- Cancellation (plan §6.7). Always stops future collection and ends this
-- order's trial access now. The edge function then resolves the PaymentIntent
-- and records the outcome with trial_set_cancel_outcome.
-- ---------------------------------------------------------------------------
create function app.trial_cancel(p_order_id uuid, p_actor text)
returns jsonb language plpgsql security invoker set search_path = '' as $$
declare
  o app.trial_orders;
  v_prior text;
begin
  select * into o from app.trial_orders where id = p_order_id for update;
  if not found then return jsonb_build_object('result', 'not_found'); end if;
  if o.status = 'canceled' then
    return jsonb_build_object('result', 'already_canceled', 'payment_intent_id', o.payment_intent_id,
      'cancel_outcome', o.cancel_outcome);
  end if;
  if o.status in ('converted', 'refunded', 'disputed', 'recovery_expired', 'setup_expired',
                  'activation_refused') then
    return jsonb_build_object('result', 'not_cancelable', 'status', o.status);
  end if;
  v_prior := o.status;
  update app.trial_orders
  set status = 'canceled', canceled_at = now(), canceled_by = p_actor,
      next_attempt_at = null, lease_token = null, lease_expires_at = null,
      promo_use_state = case when v_prior = 'pending_setup' and promotion_code_id is not null
                             then 'released' else promo_use_state end,
      updated_at = now()
  where id = o.id returning * into o;
  if o.user_id is not null then
    perform app.trial_set_trial_access(o, 'revoked', now());
  end if;
  update app.trial_capabilities set voided_at = now()
  where order_id = o.id and voided_at is null;
  update app.trial_notice_jobs set cancelled_at = now()
  where order_id = o.id and delivered_at is null and cancelled_at is null;
  return jsonb_build_object('result', 'canceled', 'prior_status', v_prior,
    'payment_intent_id', o.payment_intent_id);
end $$;

create function app.trial_set_cancel_outcome(p_order_id uuid, p_outcome text)
returns void language plpgsql security invoker set search_path = '' as $$
declare o app.trial_orders;
begin
  update app.trial_orders set cancel_outcome = p_outcome, updated_at = now()
  where id = p_order_id and status = 'canceled'
  returning * into o;
  -- The cancellation notice goes out only once the outcome is known
  -- (DECISION-0126 item 19).
  if found and p_outcome in ('no_charge', 'refunded') and o.trial_started_at is not null then
    perform app.trial_enqueue_notice(o, 'canceled', now(), ':' || p_outcome);
  end if;
end $$;

-- ---------------------------------------------------------------------------
-- Refunds and disputes on a converted order (plan §6.8).
-- ---------------------------------------------------------------------------
create function app.trial_mark_refunded(p_order_id uuid, p_full boolean)
returns text language plpgsql security invoker set search_path = '' as $$
declare o app.trial_orders;
begin
  select * into o from app.trial_orders where id = p_order_id for update;
  if not found then return 'not_found'; end if;
  if not p_full then return 'partial_kept'; end if;
  if o.status = 'refunded' then return 'already_refunded'; end if;
  perform app.trial_set_paid_access(o, 'revoked');
  perform app.trial_set_trial_access(o, 'revoked', now());
  if o.status = 'converted' then
    update app.trial_orders set status = 'refunded', updated_at = now()
    where id = o.id returning * into o;
    perform app.trial_enqueue_notice(o, 'refunded');
  end if;
  return 'refunded';
end $$;

create function app.trial_mark_disputed(p_order_id uuid)
returns text language plpgsql security invoker set search_path = '' as $$
declare o app.trial_orders;
begin
  select * into o from app.trial_orders where id = p_order_id for update;
  if not found then return 'not_found'; end if;
  perform app.trial_set_paid_access(o, 'revoked');
  perform app.trial_set_trial_access(o, 'revoked', now());
  update app.trial_orders set status = 'disputed', updated_at = now() where id = o.id;
  return 'disputed';
end $$;

-- ---------------------------------------------------------------------------
-- Notice worker claim (same pattern as parent_email_lifecycle_jobs).
-- ---------------------------------------------------------------------------
create function app.claim_trial_notice_jobs(p_limit integer default 10)
returns setof app.trial_notice_jobs
language sql security invoker set search_path = '' as $$
  update app.trial_notice_jobs j
  set lease_id = gen_random_uuid(),
      leased_until = now() + interval '2 minutes',
      attempt_count = j.attempt_count + 1
  where j.id in (
    select q.id from app.trial_notice_jobs q
    where q.delivered_at is null and q.cancelled_at is null
      and not q.needs_review
      and q.due_at <= now() and q.next_attempt_at <= now()
      and (q.leased_until is null or q.leased_until < now())
    order by q.due_at, q.created_at
    limit greatest(1, least(p_limit, 25))
    for update skip locked
  ) returning j.*;
$$;

-- ---------------------------------------------------------------------------
-- Function privileges: service role only.
-- ---------------------------------------------------------------------------
do $$
declare f text;
begin
  foreach f in array array[
    'app.trial_email_hash(text)',
    'app.trial_email_consumed(text)',
    'app.trial_enqueue_notice(app.trial_orders, text, timestamptz, text)',
    'app.trial_set_trial_access(app.trial_orders, text, timestamptz)',
    'app.trial_set_paid_access(app.trial_orders, text)',
    'app.trial_activate(uuid, uuid, text, text, text, text, timestamptz, text, text)',
    'app.trial_sweep()',
    'app.trial_claim_due(integer)',
    'app.trial_record_attempt(uuid, uuid, text, text, text)',
    'app.trial_convert(uuid, text, integer, text)',
    'app.trial_cancel(uuid, text)',
    'app.trial_set_cancel_outcome(uuid, text)',
    'app.trial_mark_refunded(uuid, boolean)',
    'app.trial_mark_disputed(uuid)',
    'app.claim_trial_notice_jobs(integer)'
  ] loop
    execute format('revoke all on function %s from public, anon, authenticated', f);
    execute format('grant execute on function %s to service_role', f);
  end loop;
end $$;

-- ---------------------------------------------------------------------------
-- Analytics event names (plan §6.15). Recreates the check with the five
-- trial events added. Verify the Production definition matches the list
-- below before applying there.
-- ---------------------------------------------------------------------------
alter table app.growth_event_outbox drop constraint growth_event_outbox_event_name_check;
alter table app.growth_event_outbox add constraint growth_event_outbox_event_name_check
  check (event_name = any (array[
    'landing_view', 'demo_started', 'signup_started', 'trial_started',
    'first_response_graded', 'repair_completed', 'returned_day_2',
    'returned_day_7', 'checkout_started', 'checkout_payment_pending',
    'checkout_async_payment_failed', 'checkout_expired', 'purchase_completed',
    'purchase_refunded', 'referral_shared', 'referred_trial_started',
    'referred_purchase',
    'trial_card_started', 'trial_converted', 'trial_canceled',
    'trial_payment_failed', 'trial_recovered'
  ]));
