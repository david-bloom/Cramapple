-- TASK-0077: how pg_cron reaches the two trial workers (plan §6.5, §6.13).
-- Same pattern as app.byoq_invoke_purge(): the URL and Bearer token live in
-- Vault and are never in SQL. This migration does NOT schedule anything; the
-- schedules are created at release (scripts/task0077/schedule_workers.sql),
-- after the Vault entries and function secrets exist.
--
-- Vault entries to create first (values never printed or committed):
--   trial_charge_function_url   https://<ref>.supabase.co/functions/v1/charge-due-trials
--   trial_charge_worker_secret  = the function's TRIAL_CHARGE_WORKER_SECRET
--   email_worker_function_url   https://<ref>.supabase.co/functions/v1/deliver-transactional-email
--   email_worker_secret         = the function's TRANSACTIONAL_EMAIL_WORKER_SECRET

create function app.invoke_trial_worker(p_url_secret text, p_token_secret text)
returns bigint
language plpgsql
security definer
set search_path = 'pg_catalog'
as $$
declare
  v_url text;
  v_token text;
begin
  select decrypted_secret into v_url from vault.decrypted_secrets where name = p_url_secret limit 1;
  select decrypted_secret into v_token from vault.decrypted_secrets where name = p_token_secret limit 1;
  if v_url is null or v_token is null then
    -- Missing configuration shows up as a stale heartbeat, not a crash.
    return null;
  end if;
  return net.http_post(
    url := v_url,
    headers := jsonb_build_object('Content-Type', 'application/json', 'Authorization', 'Bearer ' || v_token),
    body := '{}'::jsonb,
    timeout_milliseconds := 55000
  );
end;
$$;

create function app.invoke_charge_due_trials()
returns bigint language sql security definer set search_path = 'pg_catalog' as $$
  select app.invoke_trial_worker('trial_charge_function_url', 'trial_charge_worker_secret');
$$;

create function app.invoke_deliver_transactional_email()
returns bigint language sql security definer set search_path = 'pg_catalog' as $$
  select app.invoke_trial_worker('email_worker_function_url', 'email_worker_secret');
$$;

revoke all on function app.invoke_trial_worker(text, text) from public, anon, authenticated, service_role;
revoke all on function app.invoke_charge_due_trials() from public, anon, authenticated, service_role;
revoke all on function app.invoke_deliver_transactional_email() from public, anon, authenticated, service_role;
