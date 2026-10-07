create table app.transactional_email_outbox (
  id uuid primary key default gen_random_uuid(),
  dedupe_key text not null unique,
  template_env text not null,
  recipient_email text not null,
  data_variables jsonb not null,
  created_at timestamptz not null default now(),
  delivered_at timestamptz,
  attempt_count integer not null default 0,
  next_attempt_at timestamptz not null default now(),
  lease_id uuid,
  leased_until timestamptz,
  last_error text,
  needs_review boolean not null default false
);
alter table app.transactional_email_outbox enable row level security;
revoke all on app.transactional_email_outbox from public, anon, authenticated;
grant select, insert, update, delete on app.transactional_email_outbox to service_role;
create index transactional_email_pending_idx
  on app.transactional_email_outbox (next_attempt_at, created_at)
  where delivered_at is null and not needs_review;

create function app.claim_transactional_emails(p_limit integer default 10)
returns setof app.transactional_email_outbox
language sql security invoker set search_path = '' as $$
  update app.transactional_email_outbox e
  set lease_id = gen_random_uuid(), leased_until = now() + interval '2 minutes',
      attempt_count = e.attempt_count + 1
  where e.id in (
    select q.id from app.transactional_email_outbox q
    where q.delivered_at is null and not q.needs_review
      and q.next_attempt_at <= now()
      and (q.leased_until is null or q.leased_until < now())
    order by q.created_at
    limit greatest(1, least(p_limit, 10))
    for update skip locked
  ) returning e.*;
$$;
revoke all on function app.claim_transactional_emails(integer) from public, anon, authenticated;
grant execute on function app.claim_transactional_emails(integer) to service_role;
