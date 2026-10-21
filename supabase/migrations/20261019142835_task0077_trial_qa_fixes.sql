-- TASK-0077: fixes from the PR #507 QA review (2026-10-19). Replaces five
-- functions from 20261018191924 and adds one; no table changes. Applied after
-- the original migration, which is already on Development.
--
-- 1. A full refund is terminal whatever order the webhook events arrive in:
--    a refund that lands before payment_intent.succeeded is recorded, and the
--    later success never grants access (trial_mark_refunded, trial_convert).
-- 3. A charge we delayed is never collected without 48 hours' notice measured
--    from the notice actually being sent: the sweep leaves next_attempt_at
--    unset, and only trial_delayed_notice_sent (called by the notice worker
--    after the payer's email is accepted) makes the order claimable.
-- 5. A cancellation whose Stripe settlement failed can be retried: the
--    parent's cancel tokens stay valid until the outcome is recorded.

-- ---------------------------------------------------------------------------
-- Sweep: as before, except the delayed branch.
-- ---------------------------------------------------------------------------
create or replace function app.trial_sweep()
returns jsonb language plpgsql security invoker set search_path = '' as $$
declare
  o app.trial_orders;
  n_pending int := 0; n_grace int := 0; n_recovery int := 0; n_delayed int := 0;
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
  -- The new attempt time is set only once the notice has been sent.
  for o in
    select * from app.trial_orders
    where (status = 'trialing' and now() > trial_ends_at + interval '2 hours')
       or (status = 'payment_failed' and next_attempt_at is not null
           and now() > grace_ends_at)
       or (status = 'delayed_notice' and next_attempt_at is not null
           and now() > next_attempt_at + interval '2 hours')
    for update skip locked
  loop
    update app.trial_orders
    set status = 'delayed_notice',
        delayed_notice_at = now(),
        next_attempt_at = null,
        updated_at = now()
    where id = o.id returning * into o;
    -- An unsent notice from an earlier delay names a date that no longer holds.
    update app.trial_notice_jobs set cancelled_at = now()
    where order_id = o.id and kind = 'delayed_charge'
      and delivered_at is null and cancelled_at is null;
    perform app.trial_set_trial_access(o, 'active', now() + interval '49 hours');
    perform app.trial_enqueue_notice(o, 'delayed_charge', now(),
      ':' || (extract(epoch from now()) * 1000)::bigint);
    n_delayed := n_delayed + 1;
  end loop;

  -- Waiting for the delayed-charge notice to go out: access keeps going.
  for o in
    select * from app.trial_orders
    where status = 'delayed_notice' and next_attempt_at is null
    for update skip locked
  loop
    perform app.trial_set_trial_access(o, 'active', now() + interval '49 hours');
  end loop;

  return jsonb_build_object('pending_expired', n_pending, 'grace_ended', n_grace,
    'recovery_expired', n_recovery, 'delayed', n_delayed);
end $$;

-- ---------------------------------------------------------------------------
-- The payer's delayed-charge notice was accepted for delivery: the charge may
-- run no sooner than 48 hours from now, and access lasts past it. Returns the
-- attempt time, or null when the order is no longer waiting on this notice.
-- ---------------------------------------------------------------------------
create function app.trial_delayed_notice_sent(p_order_id uuid, p_next_attempt_at timestamptz)
returns timestamptz language plpgsql security invoker set search_path = '' as $$
declare
  o app.trial_orders;
  v_next timestamptz;
begin
  select * into o from app.trial_orders where id = p_order_id for update;
  if not found or o.status <> 'delayed_notice' then return null; end if;
  if o.next_attempt_at is not null then return o.next_attempt_at; end if;
  v_next := greatest(p_next_attempt_at, now() + interval '48 hours');
  update app.trial_orders set next_attempt_at = v_next, updated_at = now()
  where id = o.id returning * into o;
  perform app.trial_set_trial_access(o, 'active', v_next + interval '1 hour');
  return v_next;
end $$;

-- ---------------------------------------------------------------------------
-- Conversion: a fully refunded order is never converted and never refunded
-- again.
-- ---------------------------------------------------------------------------
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
  return 'converted';
end $$;

-- ---------------------------------------------------------------------------
-- Cancellation: as before, except the parent's cancel tokens stay valid until
-- the outcome is recorded, so a failed Stripe settlement can be retried from
-- the same link. Recovery tokens are voided at once.
-- ---------------------------------------------------------------------------
create or replace function app.trial_cancel(p_order_id uuid, p_actor text)
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
  where order_id = o.id and voided_at is null and purpose = 'payer_recovery';
  update app.trial_notice_jobs set cancelled_at = now()
  where order_id = o.id and delivered_at is null and cancelled_at is null;
  return jsonb_build_object('result', 'canceled', 'prior_status', v_prior,
    'payment_intent_id', o.payment_intent_id);
end $$;

create or replace function app.trial_set_cancel_outcome(p_order_id uuid, p_outcome text)
returns void language plpgsql security invoker set search_path = '' as $$
declare o app.trial_orders;
begin
  update app.trial_orders set cancel_outcome = p_outcome, updated_at = now()
  where id = p_order_id and status = 'canceled'
  returning * into o;
  if not found then return; end if;
  -- Settlement is finished: the parent's cancel link has done its job.
  update app.trial_capabilities set voided_at = now()
  where order_id = o.id and voided_at is null;
  -- The cancellation notice goes out only once the outcome is known
  -- (DECISION-0126 item 19).
  if p_outcome in ('no_charge', 'refunded') and o.trial_started_at is not null then
    perform app.trial_enqueue_notice(o, 'canceled', now(), ':' || p_outcome);
  end if;
end $$;

-- ---------------------------------------------------------------------------
-- Full refund: terminal for every charged-or-chargeable order, whether or not
-- the success event has been processed yet. A cancelled order keeps its
-- status and records the refund as its cancel outcome.
-- ---------------------------------------------------------------------------
create or replace function app.trial_mark_refunded(p_order_id uuid, p_full boolean)
returns text language plpgsql security invoker set search_path = '' as $$
declare o app.trial_orders;
begin
  select * into o from app.trial_orders where id = p_order_id for update;
  if not found then return 'not_found'; end if;
  if not p_full then return 'partial_kept'; end if;
  if o.status = 'refunded' then return 'already_refunded'; end if;
  if o.status in ('pending_setup', 'setup_expired', 'activation_refused') then
    return 'no_charge';
  end if;
  if o.user_id is not null then
    perform app.trial_set_paid_access(o, 'revoked');
    perform app.trial_set_trial_access(o, 'revoked', now());
  end if;
  if o.status = 'canceled' then
    if o.cancel_outcome is distinct from 'refunded' then
      perform app.trial_set_cancel_outcome(o.id, 'refunded');
    end if;
    return 'refunded';
  end if;
  if o.status = 'disputed' then return 'refunded'; end if;
  update app.trial_orders
  set status = 'refunded', next_attempt_at = null, lease_token = null, lease_expires_at = null,
      updated_at = now()
  where id = o.id returning * into o;
  update app.trial_capabilities set voided_at = now()
  where order_id = o.id and voided_at is null;
  update app.trial_notice_jobs set cancelled_at = now()
  where order_id = o.id and delivered_at is null and cancelled_at is null and kind <> 'refunded';
  perform app.trial_enqueue_notice(o, 'refunded');
  return 'refunded';
end $$;

revoke all on function app.trial_delayed_notice_sent(uuid, timestamptz) from public, anon, authenticated;
grant execute on function app.trial_delayed_notice_sent(uuid, timestamptz) to service_role;
