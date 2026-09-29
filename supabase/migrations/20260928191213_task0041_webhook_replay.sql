begin;

alter table app.stripe_webhook_events
  add column if not exists status text,
  add column if not exists attempt_count integer not null default 0,
  add column if not exists last_attempt_at timestamptz;

update app.stripe_webhook_events
set
  status = case
    when processed_at is not null then 'processed'
    when processing_error is not null then 'failed'
    else 'received'
  end,
  attempt_count = greatest(attempt_count, 1),
  last_attempt_at = coalesce(last_attempt_at, received_at, created_at)
where status is null;

alter table app.stripe_webhook_events
  alter column status set default 'received',
  alter column status set not null;

alter table app.stripe_webhook_events
  drop constraint if exists stripe_webhook_events_status_check;
alter table app.stripe_webhook_events
  add constraint stripe_webhook_events_status_check
  check (status in ('received', 'processing', 'processed', 'failed'));

create or replace function app.claim_stripe_webhook_event(p_event_id text)
returns boolean
language plpgsql
security definer
set search_path = pg_catalog, app
as $$
declare
  claimed_rows integer := 0;
begin
  update app.stripe_webhook_events
  set
    status = 'processing',
    processing_error = null,
    attempt_count = attempt_count + 1,
    last_attempt_at = now()
  where id = p_event_id
    and (
      status in ('received', 'failed')
      or (
        status = 'processing'
        and coalesce(last_attempt_at, received_at, created_at) < now() - interval '5 minutes'
      )
    );

  get diagnostics claimed_rows = row_count;
  return claimed_rows = 1;
end;
$$;

revoke all on function app.claim_stripe_webhook_event(text) from public, anon, authenticated;
grant execute on function app.claim_stripe_webhook_event(text) to service_role;

commit;
