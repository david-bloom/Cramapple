-- TASK-0077: fixes from the fourth PR #507 review (Codex, review of fb1ace39).
-- Applied after 20261020224101.
--
-- F6. A recovery attempt is one failed on-session confirmation of the order's
--     PaymentIntent, counted once per Stripe event by the webhook (its ledger
--     runs each event once). Opening the page counts nothing. The worker's
--     off-session attempts are not recovery attempts. Replaces the round-3
--     error fingerprint, which collapsed repeated authentication failures.

alter table app.trial_orders drop column recovery_seen_error;

create function app.trial_count_recovery_failure(p_order_id uuid, p_payment_intent_id text)
returns integer language sql security invoker set search_path = '' as $$
  update app.trial_orders
  set recovery_attempts = recovery_attempts + 1, updated_at = now()
  where id = p_order_id and payment_intent_id = p_payment_intent_id
  returning recovery_attempts;
$$;

revoke all on function app.trial_count_recovery_failure(uuid, text) from public, anon, authenticated;
grant execute on function app.trial_count_recovery_failure(uuid, text) to service_role;
