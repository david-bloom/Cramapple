-- Scenario tests for 20261018200000_task0077_card_trial_orders.sql.
-- Run on a throwaway database after scripts/task0077/stub_schema.sql and the
-- migration; see scripts/task0077/README.md. Every check raises on failure.
\set ON_ERROR_STOP 1

create or replace function pg_temp.check(ok boolean, label text) returns void
language plpgsql as $$ begin
  if ok is not true then raise exception 'FAILED: %', label; end if;
  raise notice 'ok: %', label;
end $$;

-- Fixtures: three learners, two subjects.
insert into auth.users values
  ('00000000-0000-0000-0000-000000000001', 'Student.One@Example.com'),
  ('00000000-0000-0000-0000-000000000002', 'kid@example.com'),
  ('00000000-0000-0000-0000-000000000003', 'three@example.com');
insert into app.profiles select id from auth.users;
insert into app.subjects (id, subject_key) values
  ('10000000-0000-0000-0000-000000000001', 'biology'),
  ('10000000-0000-0000-0000-000000000002', 'statistics');

create or replace function pg_temp.new_order(
  p_email text, p_type text default 'student_direct', p_offer text default 'single',
  p_subjects uuid[] default array['10000000-0000-0000-0000-000000000001'::uuid]
) returns uuid language sql as $$
  insert into app.trial_orders (
    purchase_type, student_email, student_email_norm, offer, subject_ids, subject_keys,
    price_id, list_amount, discount_amount, charge_amount, quote_version, quote_expires_at,
    promotion_code_id, coupon_id, promo_code, promo_use_state,
    payer_is_learner, student_ack_version, student_ack_at, student_ack_source,
    mandate_text_version)
  values (
    p_type, p_email, lower(btrim(p_email)), p_offer, p_subjects,
    array(select 'k' || g from generate_series(1, cardinality(p_subjects)) g),
    'price_x', 3999, 2000, 1999, 'q1', now() + interval '1 day',
    'promo_1', 'coupon_1', 'HALF', 'reserved',
    p_type = 'student_direct', 'terms-2026-10', now(), 'checkout', 'mandate-1')
  returning id;
$$;

-- ---------------------------------------------------------------------------
-- 1. Direct activation, replay, notices, access window.
-- ---------------------------------------------------------------------------
do $$
declare o uuid; r text; t app.trial_orders;
begin
  o := pg_temp.new_order(' Student.One@Example.com ');
  r := app.trial_activate(o, '00000000-0000-0000-0000-000000000001', 'pi_1', 'seti_1', 'pm_1',
    'Student.One@Example.com', now() - interval '1 minute');
  perform pg_temp.check(r = 'activated', 'direct activation');
  select * into t from app.trial_orders where id = o;
  perform pg_temp.check(t.status = 'trialing' and t.promo_use_state = 'redeemed', 'trialing, promo redeemed');
  perform pg_temp.check(t.trial_ends_at = t.trial_started_at + interval '7 days', 'seven-day clock');
  perform pg_temp.check((select count(*) from app.subject_entitlements
    where external_reference = o::text and access_tier = 'trial' and status = 'active'
      and ends_at = t.trial_ends_at) = 1, 'trial access granted to the trial end');
  perform pg_temp.check((select count(*) from app.trial_notice_jobs where order_id = o) = 2
    and not exists (select 1 from app.trial_notice_jobs where order_id = o and recipient_role = 'student'),
    'direct: start + reminder to the payer only');
  perform pg_temp.check((select due_at from app.trial_notice_jobs where order_id = o and kind = 'reminder')
    = t.trial_ends_at - interval '48 hours', 'reminder 48 h before the charge');
  r := app.trial_activate(o, '00000000-0000-0000-0000-000000000001', 'pi_1', 'seti_1', 'pm_1',
    'x@example.com', now());
  perform pg_temp.check(r = 'already_active', 'replay is idempotent');
  perform pg_temp.check(app.trial_email_consumed('student.one@example.com'), 'email consumed (case-insensitive)');
end $$;

-- ---------------------------------------------------------------------------
-- 2. One trial per student email: a second order for the same email.
-- ---------------------------------------------------------------------------
do $$
declare o uuid; r text;
begin
  o := pg_temp.new_order('student.one@example.com');
  r := app.trial_activate(o, '00000000-0000-0000-0000-000000000001', 'pi_dup', 'seti_dup', 'pm_1',
    'student.one@example.com', now());
  perform pg_temp.check(r = 'email_consumed', 'second trial for the same email refused');
  perform pg_temp.check((select status from app.trial_orders where id = o) = 'activation_refused'
    and (select promo_use_state from app.trial_orders where id = o) = 'released', 'refused order released its promo');
end $$;

-- Cancelling a pending order (no trial yet) is allowed.
do $$
declare o uuid;
begin
  o := pg_temp.new_order('cancel-pending@example.com');
  -- Read back in a separate statement: a subquery in the same statement as
  -- the call sees the row as it was before the call.
  perform pg_temp.check((app.trial_cancel(o, 'student') ->> 'result') = 'canceled', 'pending order cancels');
  perform pg_temp.check((select promo_use_state from app.trial_orders where id = o) = 'released',
    'cancelled pending order released its promo');
end $$;

-- One pending order per email.
do $$
begin
  perform pg_temp.new_order('pending@example.com');
  begin
    perform pg_temp.new_order('PENDING@example.com');
    perform pg_temp.check(false, 'second pending order should fail');
  exception when unique_violation then
    perform pg_temp.check(true, 'one pending order per email');
  end;
end $$;

-- ---------------------------------------------------------------------------
-- 3. Decline, grace, retry, recovery, conversion.
-- ---------------------------------------------------------------------------
do $$
declare o uuid; r text; t app.trial_orders; c app.trial_orders;
begin
  o := pg_temp.new_order('kid@example.com');
  perform app.trial_activate(o, '00000000-0000-0000-0000-000000000002', 'pi_2', 'seti_2', 'pm_2',
    'kid@example.com', now() - interval '7 days' - interval '10 minutes');
  select * into c from app.trial_claim_due(10) where id = o;
  perform pg_temp.check(c.charge_phase = 'first' and c.attempt_count = 1, 'claimed first attempt in window');
  perform pg_temp.check(app.trial_record_attempt(o, gen_random_uuid(), 'declined_hard') = 'stale_lease',
    'wrong lease token is ignored');
  r := app.trial_record_attempt(o, c.lease_token, 'declined_retryable', 'card_declined', 'insufficient_funds');
  select * into t from app.trial_orders where id = o;
  perform pg_temp.check(r = 'payment_failed' and t.grace_ends_at = t.trial_ends_at + interval '24 hours',
    'first decline: grace = trial end + 24 h');
  perform pg_temp.check(t.next_attempt_at = t.grace_ends_at - interval '1 hour', 'one retry an hour before grace ends');
  perform pg_temp.check((select ends_at from app.subject_entitlements where external_reference = o::text
    and access_tier = 'trial') = t.grace_ends_at, 'access extended to grace end');

  update app.trial_orders set next_attempt_at = now() - interval '1 minute',
    grace_ends_at = now() + interval '50 minutes' where id = o;
  select * into c from app.trial_claim_due(10) where id = o;
  perform pg_temp.check(c.charge_phase = 'retry' and c.attempt_count = 2, 'claimed the retry');
  r := app.trial_record_attempt(o, c.lease_token, 'declined_retryable');
  select * into t from app.trial_orders where id = o;
  perform pg_temp.check(t.next_attempt_at is null and t.grace_ends_at = now() + interval '50 minutes',
    'second decline: no more retries, grace not extended again');
  perform pg_temp.check((select count(*) from app.trial_notice_jobs where order_id = o and kind = 'payment_failed') = 1,
    'failure notice sent once');

  update app.trial_orders set grace_ends_at = now() - interval '1 second' where id = o;
  perform app.trial_sweep();
  select * into t from app.trial_orders where id = o;
  perform pg_temp.check(t.status = 'recovery_only'
    and t.recovery_expires_at = t.grace_ends_at + interval '30 days', 'grace over: 30-day recovery');

  r := app.trial_convert(o, 'pi_2', 1999, 'usd');
  perform pg_temp.check(r = 'converted', 'recovery payment converts');
  perform pg_temp.check((select count(*) from app.subject_entitlements where external_reference = o::text
    and access_tier = 'paid' and status = 'active' and ends_at is null
    and source = 'stripe_trial_conversion_single') = 1, 'paid lifetime access granted');
  perform pg_temp.check((select status from app.subject_entitlements where external_reference = o::text
    and access_tier = 'trial') = 'expired', 'trial access ended at conversion');
  perform pg_temp.check(app.trial_convert(o, 'pi_2', 1999, 'usd') = 'already_converted', 'conversion is idempotent');

  perform pg_temp.check(app.trial_mark_refunded(o, false) = 'partial_kept', 'partial refund keeps access');
  perform pg_temp.check(app.trial_mark_refunded(o, true) = 'refunded', 'full refund');
  perform pg_temp.check((select status from app.subject_entitlements where external_reference = o::text
    and access_tier = 'paid') = 'revoked', 'full refund revokes this order''s paid access');
end $$;

-- ---------------------------------------------------------------------------
-- 4. Our-fault delay: no charge outside the window; notice; access continues.
-- ---------------------------------------------------------------------------
do $$
declare o uuid; t app.trial_orders; n int;
begin
  o := pg_temp.new_order('three@example.com');
  perform app.trial_activate(o, '00000000-0000-0000-0000-000000000003', 'pi_3', 'seti_3', 'pm_3',
    'three@example.com', now() - interval '7 days' - interval '3 hours');
  select count(*) into n from app.trial_claim_due(10) where id = o;
  perform pg_temp.check(n = 0, 'no claim outside the first-attempt window');
  perform app.trial_sweep();
  select * into t from app.trial_orders where id = o;
  perform pg_temp.check(t.status = 'delayed_notice'
    and t.next_attempt_at between now() + interval '47 hours 59 minutes' and now() + interval '48 hours 1 minute',
    'delayed: next attempt 48 h after notice');
  perform pg_temp.check((select ends_at from app.subject_entitlements where external_reference = o::text)
    > now() + interval '48 hours', 'access continues past the delayed charge');
  perform pg_temp.check(exists (select 1 from app.trial_notice_jobs where order_id = o and kind = 'delayed_charge'),
    'delayed-charge notice queued');

  -- Cancel stops everything; a late success must be refunded, never granted.
  perform pg_temp.check((app.trial_cancel(o, 'student') ->> 'result') = 'canceled', 'cancel');
  perform pg_temp.check((select status from app.subject_entitlements where external_reference = o::text) = 'revoked',
    'cancel ends access now');
  perform pg_temp.check(not exists (select 1 from app.trial_notice_jobs where order_id = o
    and delivered_at is null and cancelled_at is null), 'pending notices cancelled');
  perform pg_temp.check(app.trial_convert(o, 'pi_3', 1999, 'usd') = 'refund_required',
    'late success after cancel requires a refund');
  perform app.trial_set_cancel_outcome(o, 'refunded');
  perform pg_temp.check(exists (select 1 from app.trial_notice_jobs where order_id = o and kind = 'canceled'),
    'cancel notice only once the outcome is known');
end $$;

-- ---------------------------------------------------------------------------
-- 5. Parent-pay: payer acceptance required; both recipients notified.
-- ---------------------------------------------------------------------------
do $$
declare o uuid; r text;
begin
  insert into auth.users values ('00000000-0000-0000-0000-000000000004', 'child2@example.com');
  insert into app.profiles values ('00000000-0000-0000-0000-000000000004');
  o := pg_temp.new_order('child2@example.com', 'parent_share', 'bundle_2',
    array['10000000-0000-0000-0000-000000000001'::uuid, '10000000-0000-0000-0000-000000000002'::uuid]);
  begin
    perform app.trial_activate(o, '00000000-0000-0000-0000-000000000004', 'pi_4', 'seti_4', 'pm_4',
      'parent@example.com', now());
    perform pg_temp.check(false, 'parent activation without payer acceptance should fail');
  exception when check_violation then
    perform pg_temp.check(true, 'parent activation needs payer acceptance');
  end;
  r := app.trial_activate(o, '00000000-0000-0000-0000-000000000004', 'pi_4', 'seti_4', 'pm_4',
    'Parent@Example.com', now(), 'terms-2026-10', 'stripe_consent_collection');
  perform pg_temp.check(r = 'activated', 'parent activation with payer acceptance');
  perform pg_temp.check((select count(*) from app.subject_entitlements where external_reference = o::text) = 2,
    'bundle grants both subjects');
  perform pg_temp.check((select count(*) from app.trial_notice_jobs where order_id = o and kind = 'trial_started') = 2,
    'parent-pay: start notice to parent and student');
  perform pg_temp.check((select payer_email from app.trial_orders where id = o) = 'parent@example.com',
    'payer email captured and normalised');
  -- A second child for the same parent is fine (DECISION-0126 item 9).
  insert into auth.users values ('00000000-0000-0000-0000-000000000005', 'child3@example.com');
  insert into app.profiles values ('00000000-0000-0000-0000-000000000005');
  o := pg_temp.new_order('child3@example.com', 'parent_share');
  r := app.trial_activate(o, '00000000-0000-0000-0000-000000000005', 'pi_5', 'seti_5', 'pm_5',
    'parent@example.com', now(), 'terms-2026-10', 'stripe_consent_collection');
  perform pg_temp.check(r = 'activated', 'same parent, second child gets a trial');
end $$;

-- ---------------------------------------------------------------------------
-- 6. Guards: amount mismatch, profile deletion, dispute.
-- ---------------------------------------------------------------------------
do $$
declare o uuid;
begin
  select id into o from app.trial_orders where payment_intent_id = 'pi_5';
  perform pg_temp.check(app.trial_convert(o, 'pi_5', 999, 'usd') = 'mismatch', 'wrong amount refused');
  perform pg_temp.check((select reconcile_reason from app.trial_orders where id = o) = 'amount_mismatch'
    and not exists (select 1 from app.subject_entitlements where external_reference = o::text
      and access_tier = 'paid'), 'wrong amount goes to reconciling, no grant');
  begin
    delete from app.profiles where user_id = '00000000-0000-0000-0000-000000000005';
    perform pg_temp.check(false, 'deleting a learner with an order should fail');
  exception when foreign_key_violation then
    perform pg_temp.check(true, 'learner with a trial order cannot be deleted directly');
  end;
  select id into o from app.trial_orders where payment_intent_id = 'pi_4';
  perform pg_temp.check(app.trial_mark_disputed(o) = 'disputed', 'dispute recorded');
  perform pg_temp.check(not exists (select 1 from app.subject_entitlements
    where external_reference = o::text and status = 'active'), 'dispute revokes this order''s access');
end $$;

select 'ALL TRIAL ORDER SQL TESTS PASSED' as result;
