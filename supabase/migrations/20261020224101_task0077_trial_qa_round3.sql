-- TASK-0077: fixes from the third PR #507 review (Codex, 2026-10-19) and the
-- Development readiness run (2026-10-20). Applied after 20261019142835.
--
-- F1/H. A pending order that has a Checkout Session is expired by Stripe's own
--    checkout.session.expired event (the session now expires with the quote),
--    not by the sweep; the sweep is a backstop after Stripe's 3-day retry window.
--    A card saved on an order that is already over is recorded so clean-up can
--    remove it.
-- F3. Every refused or late activation keeps the PaymentIntent and card ids, so
--    the clean-up worker can cancel the intent and detach a parent's card.
-- F4. Trial access keeps going while the day-7 charge is due, being collected
--    or paused, until the order converts, fails, is delayed or is cancelled.
-- F2. A notice is rendered once and stored, so a retry resends the same email
--    under the same idempotency key; the delayed-charge acknowledgement counts
--    48 hours from the send, not from when the acknowledgement lands.
-- R.  A recovery attempt is a new failure on the PaymentIntent, not a page view.

alter table app.trial_notice_jobs
  add column delivery_payload jsonb,
  add column rendered_at timestamptz;
comment on column app.trial_notice_jobs.delivery_payload is
  'The rendered email (recipient, template, variables, capability links) while undelivered; cleared on delivery.';

alter table app.trial_orders add column recovery_seen_error text;

-- ---------------------------------------------------------------------------
-- Activation: unchanged except that a refusal keeps the Stripe ids (F3).
-- ---------------------------------------------------------------------------
create or replace function app.trial_activate(
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
    if o.payment_intent_id = p_payment_intent_id then return 'already_active'; end if;
    -- An order that ended before its setup was processed: keep the ids the
    -- caller just created so clean-up can undo them.
    if o.status in ('setup_expired', 'activation_refused') then
      update app.trial_orders
      set payment_intent_id = coalesce(payment_intent_id, p_payment_intent_id),
          setup_intent_id = coalesce(setup_intent_id, p_setup_intent_id),
          payment_method_id = coalesce(payment_method_id, p_payment_method_id),
          stripe_cleanup_done_at = null,
          updated_at = now()
      where id = o.id;
    end if;
    return 'bad_state';
  end if;

  insert into app.trial_consumed_emails (email_hash, source, order_id, consumed_at)
  values (app.trial_email_hash(o.student_email_norm), 'stripe_trial_v1', o.id, p_started_at)
  on conflict (email_hash) do nothing;
  if not found then
    -- The caller cancels the unconfirmed PaymentIntent and detaches the card;
    -- the ids stay so the clean-up worker retries if that fails.
    update app.trial_orders
    set status = 'activation_refused', reconcile_reason = 'email_consumed',
        payment_intent_id = p_payment_intent_id,
        setup_intent_id = p_setup_intent_id,
        payment_method_id = p_payment_method_id,
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
-- Sweep: as in 20261019142835, with the pending rule (F1/H) and the access
-- rule for due trials (F4).
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
  where status = 'pending_setup'
    and (
      -- Never reached Stripe: nothing can complete it.
      (checkout_session_id is null and quote_expires_at < now())
      -- Stripe expires the session with the quote and tells us; this only
      -- catches an order whose events never arrived, after Stripe stops retrying.
      or quote_expires_at < now() - interval '4 days'
    );
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

  -- Day 7 reached and the charge not settled yet (due, being collected, or
  -- charges switched off): access keeps going in rolling hours until the order
  -- converts, fails, is delayed or is cancelled (plan §6.12). Only active rows
  -- are extended, never revoked ones, and never shortened.
  update app.subject_entitlements e
  set ends_at = now() + interval '1 hour', updated_at = now()
  from app.trial_orders t
  where t.status in ('trialing', 'charging')
    and t.trial_ends_at <= now() + interval '15 minutes'
    and e.user_id = t.user_id and e.access_tier = 'trial' and e.source = 'stripe_trial_v1'
    and e.external_reference = t.id::text and e.status = 'active'
    and e.ends_at < now() + interval '1 hour';

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
-- The payer's delayed-charge notice was accepted (F2): the 48 hours count from
-- the send (p_sent_at), so a late acknowledgement keeps the date the email gave.
-- ---------------------------------------------------------------------------
drop function app.trial_delayed_notice_sent(uuid, timestamptz);
create function app.trial_delayed_notice_sent(
  p_order_id uuid, p_next_attempt_at timestamptz, p_sent_at timestamptz default null
) returns timestamptz language plpgsql security invoker set search_path = '' as $$
declare
  o app.trial_orders;
  v_next timestamptz;
  v_sent timestamptz := least(coalesce(p_sent_at, now()), now());
begin
  select * into o from app.trial_orders where id = p_order_id for update;
  if not found or o.status <> 'delayed_notice' then return null; end if;
  if o.next_attempt_at is not null then return o.next_attempt_at; end if;
  -- A send time from before this delay began is not this notice's.
  if o.delayed_notice_at is not null and v_sent < o.delayed_notice_at then
    v_sent := now();
  end if;
  v_next := greatest(p_next_attempt_at, v_sent + interval '48 hours');
  update app.trial_orders set next_attempt_at = v_next, updated_at = now()
  where id = o.id returning * into o;
  perform app.trial_set_trial_access(o, 'active', v_next + interval '1 hour');
  return v_next;
end $$;

revoke all on function app.trial_delayed_notice_sent(uuid, timestamptz, timestamptz) from public, anon, authenticated;
grant execute on function app.trial_delayed_notice_sent(uuid, timestamptz, timestamptz) to service_role;
