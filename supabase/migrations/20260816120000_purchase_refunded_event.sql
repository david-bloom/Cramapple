-- Adds purchase_refunded to the growth event taxonomy, for the new
-- charge.refunded webhook handler (auto-revokes the matching
-- subject_entitlements row instead of requiring a manual DB fix per
-- refund, as happened on 2026-08-16).

begin;

alter table app.growth_event_outbox
  drop constraint growth_event_outbox_event_name_check;

alter table app.growth_event_outbox
  add constraint growth_event_outbox_event_name_check
  check (event_name = any (array[
    'landing_view', 'demo_started', 'signup_started', 'trial_started',
    'first_response_graded', 'repair_completed', 'returned_day_2',
    'returned_day_7', 'checkout_started', 'checkout_payment_pending',
    'checkout_async_payment_failed', 'checkout_expired',
    'purchase_completed', 'purchase_refunded', 'referral_shared',
    'referred_trial_started', 'referred_purchase'
  ]));

commit;
