-- Scenario tests for 20261018191924_task0077_card_trial_orders.sql and its
-- QA follow-up 20261019142835_task0077_trial_qa_fixes.sql.
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
  perform pg_temp.check(t.status = 'delayed_notice' and t.next_attempt_at is null,
    'delayed: no attempt time until the notice is sent');
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

-- ---------------------------------------------------------------------------
-- 7. QA 2026-10-19: a full refund whose event arrives before the success
--    event is terminal; the late success grants nothing.
-- ---------------------------------------------------------------------------
insert into auth.users values
  ('00000000-0000-0000-0000-000000000006', 'refund-first@example.com'),
  ('00000000-0000-0000-0000-000000000007', 'delayed@example.com'),
  ('00000000-0000-0000-0000-000000000008', 'kid8@example.com'),
  ('00000000-0000-0000-0000-000000000009', 'cancel-refund@example.com');
insert into app.profiles values
  ('00000000-0000-0000-0000-000000000006'), ('00000000-0000-0000-0000-000000000007'),
  ('00000000-0000-0000-0000-000000000008'), ('00000000-0000-0000-0000-000000000009');

do $$
declare o uuid;
begin
  o := pg_temp.new_order('refund-first@example.com');
  perform app.trial_activate(o, '00000000-0000-0000-0000-000000000006', 'pi_6', 'seti_6', 'pm_6',
    'refund-first@example.com', now() - interval '7 days');
  perform pg_temp.check(app.trial_mark_refunded(o, true) = 'refunded', 'full refund before success is recorded');
  perform pg_temp.check((select status from app.trial_orders where id = o) = 'refunded', 'refund is terminal');
  perform pg_temp.check(app.trial_convert(o, 'pi_6', 1999, 'usd') = 'already_refunded',
    'late success after a full refund is not converted');
  perform pg_temp.check(not exists (select 1 from app.subject_entitlements where external_reference = o::text
    and status = 'active'), 'no access after refund-then-success');
  perform pg_temp.check(app.trial_mark_refunded(o, true) = 'already_refunded', 'refund replay is idempotent');
  perform pg_temp.check(not exists (select 1 from app.trial_claim_due(25) where id = o), 'refunded order is never claimed');
  perform pg_temp.check((app.trial_cancel(o, 'student') ->> 'result') = 'not_cancelable', 'refunded order is not cancelable');

  -- A cancelled order's full refund becomes its cancel outcome.
  o := pg_temp.new_order('cancel-refund@example.com');
  perform app.trial_activate(o, '00000000-0000-0000-0000-000000000009', 'pi_9', 'seti_9', 'pm_9',
    'cancel-refund@example.com', now() - interval '7 days');
  perform app.trial_cancel(o, 'student');
  perform pg_temp.check(app.trial_mark_refunded(o, true) = 'refunded', 'refund on a cancelled order');
  perform pg_temp.check((select (status, cancel_outcome)::text from app.trial_orders where id = o) = '(canceled,refunded)',
    'cancelled order records the refund as its outcome');
  perform pg_temp.check(exists (select 1 from app.trial_notice_jobs where order_id = o and kind = 'canceled'),
    'cancel notice once refunded');
end $$;

-- ---------------------------------------------------------------------------
-- 8. QA 2026-10-19: a delayed charge is claimable only 48 h after its notice
--    was sent; an unsent notice never lets the charge run.
-- ---------------------------------------------------------------------------
do $$
declare o uuid; t app.trial_orders; v timestamptz;
begin
  o := pg_temp.new_order('delayed@example.com');
  perform app.trial_activate(o, '00000000-0000-0000-0000-000000000007', 'pi_7', 'seti_7', 'pm_7',
    'delayed@example.com', now() - interval '7 days' - interval '3 hours');
  perform app.trial_sweep();
  -- Emulate days passing with the notice still unsent.
  update app.trial_orders set delayed_notice_at = now() - interval '5 days' where id = o;
  perform app.trial_sweep();
  perform pg_temp.check(not exists (select 1 from app.trial_claim_due(25) where id = o),
    'unsent delayed notice: never claimable, however long');
  perform pg_temp.check((select count(*) from app.trial_notice_jobs where order_id = o
    and kind = 'delayed_charge' and cancelled_at is null) = 1, 'one live delayed notice, not re-queued');
  perform pg_temp.check((select ends_at from app.subject_entitlements where external_reference = o::text)
    > now() + interval '48 hours', 'access continues while the notice is pending');

  v := app.trial_delayed_notice_sent(o, now() + interval '49 hours');
  perform pg_temp.check(v = now() + interval '49 hours', 'notice sent: attempt at the announced time');
  perform pg_temp.check(app.trial_delayed_notice_sent(o, now() + interval '1 hour') = v,
    'a repeated acknowledgement does not move the date');
  perform pg_temp.check((select ends_at from app.subject_entitlements where external_reference = o::text)
    >= v + interval '1 hour', 'access lasts past the announced charge');
  perform pg_temp.check(not exists (select 1 from app.trial_claim_due(25) where id = o), 'not claimable before 48 h');
  update app.trial_orders set next_attempt_at = now() - interval '1 minute' where id = o;
  perform pg_temp.check(exists (select 1 from app.trial_claim_due(25) where id = o and charge_phase = 'delayed'),
    'claimable once the announced time arrives');
end $$;

do $$
declare o uuid;
begin
  select id into o from app.trial_orders where payment_intent_id = 'pi_7';
  -- A missed delayed window: delay again with a fresh notice; the old date is void.
  update app.trial_orders set status = 'delayed_notice', lease_token = null, lease_expires_at = null,
    next_attempt_at = now() - interval '3 hours' where id = o;
  perform app.trial_sweep();
  perform pg_temp.check((select next_attempt_at from app.trial_orders where id = o) is null,
    'missed delayed window: no attempt time until a new notice is sent');
  perform pg_temp.check((select count(*) from app.trial_notice_jobs where order_id = o
    and kind = 'delayed_charge') = 2, 'a new delayed notice is queued');
  perform pg_temp.check(app.trial_delayed_notice_sent(o, now()) >= now() + interval '48 hours',
    'never less than 48 hours from the acknowledgement');
end $$;

-- ---------------------------------------------------------------------------
-- 9. QA 2026-10-19: the parent's cancel link stays valid until the
--    cancellation's outcome is recorded, so a failed settlement can retry.
-- ---------------------------------------------------------------------------
do $$
declare o uuid;
begin
  o := pg_temp.new_order('kid8@example.com', 'parent_share');
  perform app.trial_activate(o, '00000000-0000-0000-0000-000000000008', 'pi_8', 'seti_8', 'pm_8',
    'parent8@example.com', now(), 'terms-2026-10', 'stripe_consent_collection');
  insert into app.trial_capabilities (order_id, purpose, token_hash, expires_at) values
    (o, 'parent_cancel', repeat('a', 64), now() + interval '10 days'),
    (o, 'payer_recovery', repeat('b', 64), now() + interval '10 days');
  perform app.trial_cancel(o, 'parent');
  perform pg_temp.check((select voided_at from app.trial_capabilities where token_hash = repeat('b', 64)) is not null,
    'cancel voids recovery links at once');
  perform pg_temp.check((select voided_at from app.trial_capabilities where token_hash = repeat('a', 64)) is null,
    'the parent cancel link survives until settlement finishes');
  perform pg_temp.check((app.trial_cancel(o, 'parent') ->> 'cancel_outcome') is null,
    'a retry sees the unfinished settlement');
  perform app.trial_set_cancel_outcome(o, 'no_charge');
  perform pg_temp.check((select voided_at from app.trial_capabilities where token_hash = repeat('a', 64)) is not null,
    'recording the outcome voids the parent cancel link');
end $$;

-- ---------------------------------------------------------------------------
-- 10. QA round 3 (20261020224101): pending orders with a Stripe session wait
--     for Stripe's expiry; refused and late activations keep their Stripe ids;
--     access continues while the day-7 charge is due or paused; the delayed
--     acknowledgement keeps the emailed date.
-- ---------------------------------------------------------------------------
insert into auth.users values
  ('00000000-0000-0000-0000-00000000000a', 'ten-a@example.com'),
  ('00000000-0000-0000-0000-00000000000b', 'ten-b@example.com'),
  ('00000000-0000-0000-0000-00000000000c', 'ten-c@example.com');
insert into app.profiles values
  ('00000000-0000-0000-0000-00000000000a'), ('00000000-0000-0000-0000-00000000000b'),
  ('00000000-0000-0000-0000-00000000000c');

do $$
declare a uuid; b uuid; c uuid; n uuid; r text; t app.trial_orders; v timestamptz;
begin
  -- Pending rule.
  a := pg_temp.new_order('ten-pending-a@example.com');
  b := pg_temp.new_order('ten-pending-b@example.com');
  n := pg_temp.new_order('ten-pending-n@example.com');
  update app.trial_orders set checkout_session_id = 'cs_a', quote_expires_at = now() - interval '1 hour' where id = a;
  update app.trial_orders set checkout_session_id = 'cs_b', quote_expires_at = now() - interval '5 days' where id = b;
  update app.trial_orders set quote_expires_at = now() - interval '1 hour' where id = n;
  perform app.trial_sweep();
  perform pg_temp.check((select status from app.trial_orders where id = a) = 'pending_setup',
    'a lapsed quote with a Stripe session waits for Stripe''s expiry event');
  perform pg_temp.check((select status from app.trial_orders where id = b) = 'setup_expired',
    'the sweep backstops a session whose events never arrived');
  perform pg_temp.check((select status from app.trial_orders where id = n) = 'setup_expired',
    'a lapsed quote that never reached Stripe expires at once');

  -- F3: refused after the PI exists, and late on a lapsed order.
  a := pg_temp.new_order('ten-a@example.com', 'parent_share');
  perform app.trial_activate(a, '00000000-0000-0000-0000-00000000000a', 'pi_10a', 'seti_10a', 'pm_10a',
    'p@example.com', now(), 'terms-2026-10', 'stripe_consent_collection');
  b := pg_temp.new_order('ten-a@example.com', 'parent_share');
  r := app.trial_activate(b, '00000000-0000-0000-0000-00000000000a', 'pi_10b', 'seti_10b', 'pm_10b',
    'p@example.com', now(), 'terms-2026-10', 'stripe_consent_collection');
  select * into t from app.trial_orders where id = b;
  perform pg_temp.check(r = 'email_consumed' and t.status = 'activation_refused'
    and t.payment_intent_id = 'pi_10b' and t.payment_method_id = 'pm_10b',
    'a consumed-email refusal keeps the PI and card for clean-up');
  update app.trial_orders set status = 'setup_expired', stripe_cleanup_done_at = now() where id = n;
  r := app.trial_activate(n, '00000000-0000-0000-0000-00000000000a', 'pi_10n', 'seti_10n', 'pm_10n',
    'p@example.com', now());
  select * into t from app.trial_orders where id = n;
  perform pg_temp.check(r = 'bad_state' and t.payment_intent_id = 'pi_10n' and t.payment_method_id = 'pm_10n'
    and t.stripe_cleanup_done_at is null, 'a late activation on a lapsed order is queued for clean-up');

  -- F4: day 7 passed an hour ago, charges paused: access continues.
  c := pg_temp.new_order('ten-b@example.com');
  perform app.trial_activate(c, '00000000-0000-0000-0000-00000000000b', 'pi_10c', 'seti_10c', 'pm_10c',
    'ten-b@example.com', now() - interval '7 days 1 hour');
  perform app.trial_sweep();
  select * into t from app.trial_orders where id = c;
  perform pg_temp.check(t.status = 'trialing', 'inside the collection window the order is not yet delayed');
  perform pg_temp.check((select count(*) from app.subject_entitlements where external_reference = c::text
    and access_tier = 'trial' and status = 'active' and ends_at > now()) = 1,
    'access continues while the day-7 charge is due or paused');
  -- Ten minutes before day 7: extended ahead, so there is no gap at the boundary.
  a := pg_temp.new_order('ten-c@example.com');
  perform app.trial_activate(a, '00000000-0000-0000-0000-00000000000c', 'pi_10d', 'seti_10d', 'pm_10d',
    'ten-c@example.com', now() - interval '7 days' + interval '10 minutes');
  perform app.trial_sweep();
  perform pg_temp.check((select ends_at from app.subject_entitlements where external_reference = a::text
    and access_tier = 'trial') >= now() + interval '59 minutes', 'access is extended before the boundary');
  -- A cancelled trial is not revived.
  perform app.trial_cancel(a, 'student');
  perform app.trial_sweep();
  perform pg_temp.check(not exists (select 1 from app.subject_entitlements where external_reference = a::text
    and access_tier = 'trial' and status = 'active'), 'the sweep never extends a cancelled trial');

  -- F2: the acknowledgement keeps the emailed date when it still gives 48 hours.
  update app.trial_orders set trial_started_at = trial_started_at - interval '2 hours',
    trial_ends_at = trial_ends_at - interval '2 hours' where id = c;
  perform app.trial_sweep();
  perform pg_temp.check((select status from app.trial_orders where id = c) = 'delayed_notice', 'delayed after the window');
  v := app.trial_delayed_notice_sent(c, now() + interval '49 hours', now());
  perform pg_temp.check(v = now() + interval '49 hours', 'the acknowledged date is the one the email gave');
  update app.trial_orders set next_attempt_at = null where id = c;
  v := app.trial_delayed_notice_sent(c, now() + interval '10 hours', now() + interval '5 hours');
  perform pg_temp.check(v = now() + interval '48 hours', 'never under 48 hours, and a future send time is clamped');
end $$;

select 'ALL TRIAL ORDER SQL TESTS PASSED' as result;
